Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB36E712B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjDSCm2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSCm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:27 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105E619B
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:26 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id F142C80528;
        Tue, 18 Apr 2023 22:42:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872146; bh=zducZ1m40XwNI7f1Cy1G8j8mEtd6BO9umHmTn5M/Qr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWnAA7qGXyd8GJ31UWy4792RVWkEkYi+0dh439wOMhApL8I+9kZwjdkodXi2sQe9g
         SOiZzsgRKh4mW0iqIs6StzcHk/9JvZ9qtOXKi4lNmepdPxP63F89ycxsVDrVWDI/lA
         1hLmtrrG7lwO6MuUo2vbOVJEemMdXnUAcF1vIKR7m6K7uQOvyFMtNXpEnQFxQtdiIr
         awdjfMA2kvYYVqsCLP/lWTFa8Eyd+i/LYIwgJRCp+bWQV6aA5x5yafaPsLzcAnoaeH
         S2bm6Giz8scy1/MLnk1W6BwYN1kc59fQWiorGryMjF+XLmcQTl9r4JECO9aDbl1uQR
         id3l/sr32fCwQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 2/7] fscrypt: set up pooled keys upon first use
Date:   Tue, 18 Apr 2023 22:42:11 -0400
Message-Id: <b009307aebaf3fc6a591ce3d01f8496b81fac23f.1681871298.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681871298.git.sweettea-kernel@dorminy.me>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
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

This change starts setting up pooled prepared keys only when they are
first used, which is a step toward how they will be used for
extent-based encryption. While currently they're still allocated as part
of the info, this defers actual key setup to usage time, and adds error
handling needed for this.

If used on leaf inodes, this passes most tests, except the tests which
assert that one can open a file, forget the master key, and still do IO
with the cached prepared key in the file's info. Since the master key is
used at first IO time to set up the actual prepared key, the expectation
that the prepared key is already cached is violated.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c          |  4 +++-
 fs/crypto/fscrypt_private.h |  2 ++
 fs/crypto/keysetup.c        | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 9f3bda18c797..91ef520a9961 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -108,9 +108,11 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
 	struct fscrypt_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key->tfm;
+	struct crypto_skcipher *tfm = fscrypt_get_contents_tfm(ci);
 	int res = 0;
 
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
 	if (WARN_ON_ONCE(len <= 0))
 		return -EINVAL;
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4942a8ae2061..143dc039bb03 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -624,6 +624,8 @@ struct fscrypt_mode {
 
 extern struct fscrypt_mode fscrypt_modes[];
 
+struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci);
+
 int fscrypt_allocate_key_member(struct fscrypt_prepared_key *prep_key,
 				const struct fscrypt_info *ci);
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 171114fd5590..c179a478020a 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -93,6 +93,10 @@ struct fscrypt_pooled_prepared_key {
 	struct fscrypt_prepared_key prep_key;
 };
 
+/* Forward declaration so that all the prepared key handling can stay together */
+static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
+				     struct fscrypt_master_key *mk);
+
 static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
@@ -159,6 +163,31 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 	return err;
 }
 
+struct crypto_skcipher *fscrypt_get_contents_tfm(struct fscrypt_info *ci)
+{
+	int err;
+	struct fscrypt_master_key *mk = ci->ci_master_key;
+	unsigned int allocflags;
+
+	if (!fscrypt_using_pooled_prepared_key(ci))
+		return ci->ci_enc_key->tfm;
+
+	err = lock_master_key(mk);
+	if (err) {
+		up_read(&mk->mk_sem);
+		return ERR_PTR(err);
+	}
+
+	allocflags = memalloc_nofs_save();
+	err = fscrypt_setup_v2_file_key(ci, mk);
+	up_read(&mk->mk_sem);
+	memalloc_nofs_restore(allocflags);
+	if (err)
+		return ERR_PTR(err);
+
+	return ci->ci_enc_key->tfm;
+}
+
 /* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
@@ -234,6 +263,9 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 	if (fscrypt_using_pooled_prepared_key(ci)) {
 		struct fscrypt_pooled_prepared_key *pooled_key;
 
+		if (ci->ci_enc_key)
+			return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
+
 		pooled_key = kzalloc(sizeof(*pooled_key), GFP_KERNEL);
 		if (!pooled_key)
 			return -ENOMEM;
@@ -246,6 +278,7 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 
 		pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
 		ci->ci_enc_key = &pooled_key->prep_key;
+		return 0;
 	} else {
 		ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
 		if (!ci->ci_enc_key)
-- 
2.40.0

