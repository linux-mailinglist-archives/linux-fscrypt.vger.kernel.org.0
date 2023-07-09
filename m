Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD2C74C782
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjGISx3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjGISxT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:19 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC7A10C;
        Sun,  9 Jul 2023 11:53:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EAB7780AE5;
        Sun,  9 Jul 2023 14:53:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928796; bh=g0b35MrtF2uGyl8iDzN5bX4Wn/xb7o1sAgwZ2In2a1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUeDIAkH5XC1eYu/AXfveKRO/5XacnBp/UhgpqpVXLQe5AmISySingz5JXdYP69JZ
         cg7oaySnlXEWMDM/sYL50tUm6YxnfajQF/QRVDg7mVUJ3ozBiZqVJPdaI/bUtFZt31
         Voq7Fy2kwumbVo0BQWYQa7mEOjtbxtNeLjT5ZSfhHk9RLkk5Z5XNYOO4QGz7uvVFTw
         p/bB9BLgr8wecauPNbstsynNe+u5zE5eiOIjh3NLW3QUW+9VmET6JlItJ8oRMwnkND
         CMGX72CFHRfMFp6RU+M5i4PKgIAGkFpxmD6lsvVGaSSCSedSdnzHjg1166Y7mt67Zk
         AecCGFHpEV98w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 1/8] fscrypt: move inline crypt decision to info setup
Date:   Sun,  9 Jul 2023 14:53:01 -0400
Message-Id: <5f8bf550b27040b9631c3d9c063847b8a7d6cba6.1688927423.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927423.git.sweettea-kernel@dorminy.me>
References: <cover.1688927423.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

setup_file_encryption_key() is doing a lot of things at the moment --
setting the crypt_info's inline encryption bit, finding and locking a
master key, and calling the functions to get the appropriate prepared
key for this info. Since setting the inline encryption bit has nothing
to do with finding the master key, it's easy and hopefully clearer to
select the encryption implementation in fscrypt_setup_encryption_info(),
the main fscrypt_info setup function, instead of in
setup_file_encryption_key() which will long-term only deal in setting
up the prepared key for the info.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 361f41ef46c7..b89c32ad19fb 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -443,10 +443,6 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	struct fscrypt_master_key *mk;
 	int err;
 
-	err = fscrypt_select_encryption_impl(ci);
-	if (err)
-		return err;
-
 	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
 	if (err)
 		return err;
@@ -580,6 +576,10 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	WARN_ON_ONCE(mode->ivsize > FSCRYPT_MAX_IV_SIZE);
 	crypt_info->ci_mode = mode;
 
+	res = fscrypt_select_encryption_impl(crypt_info);
+	if (res)
+		goto out;
+
 	res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
 	if (res)
 		goto out;
-- 
2.40.1

