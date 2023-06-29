Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B322741CF3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjF2Aeb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjF2Aea (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:34:30 -0400
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jun 2023 17:34:28 PDT
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2CE2102;
        Wed, 28 Jun 2023 17:34:28 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BDA7480B08;
        Wed, 28 Jun 2023 20:34:27 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998868; bh=BANyZkPSFuy2bDBhnuzG9Pf7Z/O08lmSVAs1RBZ5k/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvuEU5HC9UUJuXpqbER3aDs8p1ZxFCCINKEg7TY1hvDWiq0USPmpr8Qx+Wgf48KOR
         zPDIDdLonnkNGpljoMeGc1qVIKt4aMu+hDfinper9VbSjR8aW48WxwOZiudS/kvhJp
         KiVPJ50A7vMNpmHC1xgtzlhv3Bz2Qt9Q6Y1ybO7/RuCGkALGH6N7znuGWgWREvjURG
         aZgtEwW9RM7iEUUZPnBwmdkm+LkkkpdX2iilRGwwN1TDg1uSz56dvX2H38BG5+5s3g
         cTlqg6NYF6NSU6gGqwuRqpxHuMKj3YWjsg2nqXnKccN+1cWk2qN37Puavy1RSAhhIM
         2QhpO9OWUqMUA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 01/12] fscrypt: factor helper for locking master key
Date:   Wed, 28 Jun 2023 20:29:31 -0400
Message-Id: <e61801a7bd58c0dc97b932d58ae7c7f406e63f8c.1687988246.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988246.git.sweettea-kernel@dorminy.me>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

When we are making extent infos, we'll need to lock the master key in
more places, so go on and factor out a helper.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index be3a84508806..6cbb42a8a537 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -106,7 +106,18 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	return ERR_PTR(-EINVAL);
 }
 
-/* Create a symmetric cipher object for the given encryption mode and key */
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
+/* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			  const struct inode *inode)
@@ -556,13 +567,10 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
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
2.40.1

