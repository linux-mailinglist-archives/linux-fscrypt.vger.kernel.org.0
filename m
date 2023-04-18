Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BB36E6A88
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjDRRFm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjDRRFj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:39 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6BB443
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:05:27 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 95AAC8262E;
        Tue, 18 Apr 2023 13:05:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837526; bh=DP5hlVvNjw2JROMJ6s6bshEcbxvK3Nx2/UIgbRvXRGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cChsGaRaUY0s/TGia1Mi6oL0P7Fya5oUD4czQ0bzPHPd+HSExk91nZj0CTLS5eZqd
         xpX7czwsBVtEubCVu82CLI4zRzK7m2qIad10Kh0FrsBVZKVbRmZ9f3X3D7Ec1YO+lV
         rfRDbm+uUyICGsNemfaoFUqWG/7qyttuk88vyRK/aljClNyKD08Je2TZF/mpcXFiYg
         E6uJ2fBZaQyU/oKbYTqgTlzL1yj/ZLzAv59sqh92sdBKU6XQ0YdVHLWXnNmw4IiUz6
         YDRuWMyo1Jec3KaV3RBmSG2oKJ5eku5zgx6vaWiS8NZ/qsDZO/wot9CbVDQRQxCHYc
         OkXPC44cehqLQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 11/11] fscrypt: factor helper for locking master key
Date:   Tue, 18 Apr 2023 13:04:48 -0400
Message-Id: <0624b444f5a952f27b9de209f28ce3c3387e2f35.1681837335.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681837335.git.sweettea-kernel@dorminy.me>
References: <cover.1681837335.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

When keys are prepared at the point of use, using a pooled prepared key,
we'll need to lock and check the existence of the master key secret in
multiple places. So go on and factor out the helper.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 55c416df6a71..9cd60e09b0c5 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -106,6 +106,17 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	return ERR_PTR(-EINVAL);
 }
 
+static int lock_master_key(struct fscrypt_master_key *mk)
+{
+	down_read(&mk->mk_sem);
+
+	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
+	if (!is_master_key_secret_present(&mk->mk_secret))
+		return -ENOKEY;
+
+	return 0;
+}
+
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
  * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
@@ -569,13 +580,10 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 		*mk_ret = NULL;
 		return 0;
 	}
-	down_read(&mk->mk_sem);
 
-	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
-		err = -ENOKEY;
+	err = lock_master_key(mk);
+	if (err)
 		goto out_release_key;
-	}
 
 	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
-- 
2.40.0

