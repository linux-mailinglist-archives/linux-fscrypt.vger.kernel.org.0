Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3C16E6A72
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjDRRE5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbjDRRE4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:04:56 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6C176A2
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:04:53 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 2BEE2824C4;
        Tue, 18 Apr 2023 13:04:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837492; bh=ICxqBiWWNIPjhSuPacp2YUBjYU78VvV6ho2HQWm0wWs=;
        h=From:To:Cc:Subject:Date:From;
        b=lJFUdJlfgYWd/KBhRyMoYYDBtx8Pjj3YLSDWhXm320ebVhM92/5TLryeByMzN6f9N
         sWJMUuRUuO/+Mwvu8HVpJvNabJBk4Lg9yA9JM7jjP7dYVlxt627GF1pca68a8TrQA6
         LOEDjgG035p/TAu8gdPfzAq17UNQKzZxd/9IgXSUU1sadUu8MENLnIkA4kWh1h6f5W
         OinglPpCvFWVGMqZkIvU3lOLNnW0ygvKWenUP8/oqHU05s3NwkgrbFX7Rj29pfqpX2
         Qsm2Wq4aPlDvsRu5QDgp2zcYcw5wHj7t3JRFNDRsBk945Xk2g6Ee6OxR3yQVMGTf0T
         FtRtQlzm4ov3g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 01/11] fscrypt: move inline crypt decision to info setup.
Date:   Tue, 18 Apr 2023 13:04:26 -0400
Message-Id: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
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
2.40.0

