Return-Path: <linux-fscrypt+bounces-692-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FCBAFD63D
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 20:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A21ED1C261D0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 18:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183AA2E719C;
	Tue,  8 Jul 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDh5kklU"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAA2E7178;
	Tue,  8 Jul 2025 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751998452; cv=none; b=TEQerY3oL13kpsLUmzgqVKBoewcgMzVmc6ZL/E+OXXUsrfuXygYpIYiEtEMtHGi5fF0f56//pcufFI1KaQy7GGe6QBWVIos/JQZNfMjSdukbc/wKS+c5POQzHKZsEaIFQOXvEKnhJ/Skgjg3cFMsu7LXLmO8f1kAsP3JXcaDWUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751998452; c=relaxed/simple;
	bh=SMvl8BICR7sgYnBvhraVZULwOpTOgC3GHUTwRUt2+Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Z5T2xUFKLegt4bgf7sdKzIe4tEClfZwluSAR30l5ehpCT/SlX407MqKcgzoX1gCC6Be6W8hjvZu+vZ8izwA2BA4UI/Ac8qaRmIM390IE+MhTefdOaxMGjpqHe87nI0IVSXBI7NDpfOWb/CZnAGnZclCwya7z3wU19bHOfN9A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDh5kklU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF6DC4CEF7;
	Tue,  8 Jul 2025 18:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751998451;
	bh=SMvl8BICR7sgYnBvhraVZULwOpTOgC3GHUTwRUt2+Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDh5kklUANHd9Kn2IwIctfzbRZOCeYXN3lrhi7lvDnXkVWXqpQ4mg1OYxgYRm1PUc
	 T6uYhngSgFatCE3PFBARzwzQUZYN7wT3An5lc2uHgeWqF58T51WDEa17F41fCQJcWP
	 wjhwvY9W1ZBDebYnv/CZQAkxQraCWdaxFkmUDZ1EyWSMjfc02pvlmK11XTi/YAq/LT
	 8d5O6mwTDsbIpdMWd0KgMnqxTAcmhPNnCr+r/J6Xb9RZ+Pr6JrQ2iWs5QoL4oYZReS
	 4YCo3zIJE3c/jwtbMhTcg76VMQpHXaV7sxELJNNTLMUDrvs4N9ek5a7lBgibkme2MG
	 y+LoAHzvJUs9A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Yuwen Chen <ywen.chen@foxmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] fscrypt: Switch to sync_skcipher and on-stack requests
Date: Tue,  8 Jul 2025 11:13:13 -0700
Message-ID: <20250708181313.66961-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708181313.66961-1-ebiggers@kernel.org>
References: <20250708181313.66961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that fscrypt uses only synchronous skciphers, switch to the actual
sync_skcipher API and the corresponding on-stack requests.  This
eliminates a heap allocation per en/decryption operation.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/crypto.c          | 24 ++++++-----------
 fs/crypto/fname.c           | 53 ++++++++++++------------------------
 fs/crypto/fscrypt_private.h |  2 +-
 fs/crypto/keysetup.c        | 23 ++++++++--------
 fs/crypto/keysetup_v1.c     | 54 +++++++++++++++++--------------------
 5 files changed, 63 insertions(+), 93 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 43d1658e07cec..646b1831e6831 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -111,48 +111,40 @@ int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    fscrypt_direction_t rw, u64 index,
 			    struct page *src_page, struct page *dest_page,
 			    unsigned int len, unsigned int offs,
 			    gfp_t gfp_flags)
 {
+	struct crypto_sync_skcipher *tfm = ci->ci_enc_key.tfm;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
 	union fscrypt_iv iv;
-	struct skcipher_request *req = NULL;
 	struct scatterlist dst, src;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
-	int res = 0;
+	int err;
 
 	if (WARN_ON_ONCE(len <= 0))
 		return -EINVAL;
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
 		return -EINVAL;
 
 	fscrypt_generate_iv(&iv, index, ci);
 
-	req = skcipher_request_alloc(tfm, gfp_flags);
-	if (!req)
-		return -ENOMEM;
-
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		NULL, NULL);
-
 	sg_init_table(&dst, 1);
 	sg_set_page(&dst, dest_page, len, offs);
 	sg_init_table(&src, 1);
 	sg_set_page(&src, src_page, len, offs);
 	skcipher_request_set_crypt(req, &src, &dst, len, &iv);
 	if (rw == FS_DECRYPT)
-		res = crypto_skcipher_decrypt(req);
+		err = crypto_skcipher_decrypt(req);
 	else
-		res = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-	if (res) {
+		err = crypto_skcipher_encrypt(req);
+	if (err)
 		fscrypt_err(ci->ci_inode,
 			    "%scryption failed for data unit %llu: %d",
-			    (rw == FS_DECRYPT ? "De" : "En"), index, res);
-		return res;
-	}
-	return 0;
+			    (rw == FS_DECRYPT ? "De" : "En"), index, err);
+	return err;
 }
 
 /**
  * fscrypt_encrypt_pagecache_blocks() - Encrypt data from a pagecache folio
  * @folio: the locked pagecache folio containing the data to encrypt
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 17edc24ccd42f..f9f6713e144f7 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -92,48 +92,37 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
  * Return: 0 on success, -errno on failure
  */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen)
 {
-	struct skcipher_request *req = NULL;
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	struct crypto_sync_skcipher *tfm = ci->ci_enc_key.tfm;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
 	union fscrypt_iv iv;
 	struct scatterlist sg;
-	int res;
+	int err;
 
 	/*
 	 * Copy the filename to the output buffer for encrypting in-place and
 	 * pad it with the needed number of NUL bytes.
 	 */
 	if (WARN_ON_ONCE(olen < iname->len))
 		return -ENOBUFS;
 	memcpy(out, iname->name, iname->len);
 	memset(out + iname->len, 0, olen - iname->len);
 
-	/* Initialize the IV */
 	fscrypt_generate_iv(&iv, 0, ci);
 
-	/* Set up the encryption request */
-	req = skcipher_request_alloc(tfm, GFP_NOFS);
-	if (!req)
-		return -ENOMEM;
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		NULL, NULL);
 	sg_init_one(&sg, out, olen);
 	skcipher_request_set_crypt(req, &sg, &sg, olen, &iv);
-
-	/* Do the encryption */
-	res = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-	if (res < 0) {
-		fscrypt_err(inode, "Filename encryption failed: %d", res);
-		return res;
-	}
-
-	return 0;
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		fscrypt_err(inode, "Filename encryption failed: %d", err);
+	return err;
 }
 EXPORT_SYMBOL_GPL(fscrypt_fname_encrypt);
 
 /**
  * fname_decrypt() - decrypt a filename
@@ -147,37 +136,29 @@ EXPORT_SYMBOL_GPL(fscrypt_fname_encrypt);
  */
 static int fname_decrypt(const struct inode *inode,
 			 const struct fscrypt_str *iname,
 			 struct fscrypt_str *oname)
 {
-	struct skcipher_request *req = NULL;
-	struct scatterlist src_sg, dst_sg;
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
-	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	struct crypto_sync_skcipher *tfm = ci->ci_enc_key.tfm;
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
 	union fscrypt_iv iv;
-	int res;
+	struct scatterlist src_sg, dst_sg;
+	int err;
+
+	fscrypt_generate_iv(&iv, 0, ci);
 
-	/* Allocate request */
-	req = skcipher_request_alloc(tfm, GFP_NOFS);
-	if (!req)
-		return -ENOMEM;
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		NULL, NULL);
-
-	/* Initialize IV */
-	fscrypt_generate_iv(&iv, 0, ci);
-
-	/* Create decryption request */
 	sg_init_one(&src_sg, iname->name, iname->len);
 	sg_init_one(&dst_sg, oname->name, oname->len);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, iname->len, &iv);
-	res = crypto_skcipher_decrypt(req);
-	skcipher_request_free(req);
-	if (res < 0) {
-		fscrypt_err(inode, "Filename decryption failed: %d", res);
-		return res;
+	err = crypto_skcipher_decrypt(req);
+	if (err) {
+		fscrypt_err(inode, "Filename decryption failed: %d", err);
+		return err;
 	}
 
 	oname->len = strnlen(oname->name, iname->len);
 	return 0;
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 06fa8f2b2d081..bffeb14501fd0 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -237,11 +237,11 @@ struct fscrypt_symlink_data {
  * @blk_key: key for blk-crypto
  *
  * Normally only one of the fields will be non-NULL.
  */
 struct fscrypt_prepared_key {
-	struct crypto_skcipher *tfm;
+	struct crypto_sync_skcipher *tfm;
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	struct blk_crypto_key *blk_key;
 #endif
 };
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 74d4a2e1ad23a..4f3b9ecbfe4e6 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -95,19 +95,19 @@ select_encryption_mode(const union fscrypt_policy *policy,
 		  inode->i_ino, (inode->i_mode & S_IFMT));
 	return ERR_PTR(-EINVAL);
 }
 
 /* Create a symmetric cipher object for the given encryption mode and key */
-static struct crypto_skcipher *
+static struct crypto_sync_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			  const struct inode *inode)
 {
-	struct crypto_skcipher *tfm;
+	struct crypto_sync_skcipher *tfm;
 	int err;
 
-	tfm = crypto_alloc_skcipher(mode->cipher_str, 0,
-				    FSCRYPT_CRYPTOAPI_MASK);
+	tfm = crypto_alloc_sync_skcipher(mode->cipher_str, 0,
+					 FSCRYPT_CRYPTOAPI_MASK);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			fscrypt_warn(inode,
 				     "Missing crypto API support for %s (API name: \"%s\")",
 				     mode->friendly_name, mode->cipher_str);
@@ -123,25 +123,26 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 		 * crypto algorithm implementation is used.  Help people debug
 		 * performance problems by logging the ->cra_driver_name the
 		 * first time a mode is used.
 		 */
 		pr_info("fscrypt: %s using implementation \"%s\"\n",
-			mode->friendly_name, crypto_skcipher_driver_name(tfm));
+			mode->friendly_name,
+			crypto_skcipher_driver_name(&tfm->base));
 	}
-	if (WARN_ON_ONCE(crypto_skcipher_ivsize(tfm) != mode->ivsize)) {
+	if (WARN_ON_ONCE(crypto_sync_skcipher_ivsize(tfm) != mode->ivsize)) {
 		err = -EINVAL;
 		goto err_free_tfm;
 	}
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	err = crypto_skcipher_setkey(tfm, raw_key, mode->keysize);
+	crypto_sync_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
+	err = crypto_sync_skcipher_setkey(tfm, raw_key, mode->keysize);
 	if (err)
 		goto err_free_tfm;
 
 	return tfm;
 
 err_free_tfm:
-	crypto_free_skcipher(tfm);
+	crypto_free_sync_skcipher(tfm);
 	return ERR_PTR(err);
 }
 
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
@@ -150,11 +151,11 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
  * and IV generation method (@ci->ci_policy.flags).
  */
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_inode_info *ci)
 {
-	struct crypto_skcipher *tfm;
+	struct crypto_sync_skcipher *tfm;
 
 	if (fscrypt_using_inline_encryption(ci))
 		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key,
 							ci->ci_mode->keysize,
 							false, ci);
@@ -174,11 +175,11 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 
 /* Destroy a crypto transform object and/or blk-crypto key. */
 void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key)
 {
-	crypto_free_skcipher(prep_key->tfm);
+	crypto_free_sync_skcipher(prep_key->tfm);
 	fscrypt_destroy_inline_crypt_key(sb, prep_key);
 	memzero_explicit(prep_key, sizeof(*prep_key));
 }
 
 /* Given a per-file encryption key, set up the file's crypto transform object */
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 75b0f1211a1e6..4a93b4763469f 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -46,42 +46,38 @@ static DEFINE_SPINLOCK(fscrypt_direct_keys_lock);
  */
 static int derive_key_aes(const u8 *master_key,
 			  const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
 			  u8 *derived_key, unsigned int derived_keysize)
 {
-	int res = 0;
-	struct skcipher_request *req = NULL;
-	struct scatterlist src_sg, dst_sg;
-	struct crypto_skcipher *tfm =
-		crypto_alloc_skcipher("ecb(aes)", 0, FSCRYPT_CRYPTOAPI_MASK);
-
-	if (IS_ERR(tfm)) {
-		res = PTR_ERR(tfm);
-		tfm = NULL;
-		goto out;
-	}
-	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		res = -ENOMEM;
-		goto out;
-	}
-	skcipher_request_set_callback(
-		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		NULL, NULL);
-	res = crypto_skcipher_setkey(tfm, nonce, FSCRYPT_FILE_NONCE_SIZE);
-	if (res < 0)
+	struct crypto_sync_skcipher *tfm;
+	int err;
+
+	tfm = crypto_alloc_sync_skcipher("ecb(aes)", 0, FSCRYPT_CRYPTOAPI_MASK);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	err = crypto_sync_skcipher_setkey(tfm, nonce, FSCRYPT_FILE_NONCE_SIZE);
+	if (err)
 		goto out;
 
-	sg_init_one(&src_sg, master_key, derived_keysize);
-	sg_init_one(&dst_sg, derived_key, derived_keysize);
-	skcipher_request_set_crypt(req, &src_sg, &dst_sg, derived_keysize,
-				   NULL);
-	res = crypto_skcipher_encrypt(req);
+	{
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
+		struct scatterlist src_sg, dst_sg;
+
+		skcipher_request_set_callback(req,
+					      CRYPTO_TFM_REQ_MAY_BACKLOG |
+						      CRYPTO_TFM_REQ_MAY_SLEEP,
+					      NULL, NULL);
+		sg_init_one(&src_sg, master_key, derived_keysize);
+		sg_init_one(&dst_sg, derived_key, derived_keysize);
+		skcipher_request_set_crypt(req, &src_sg, &dst_sg,
+					   derived_keysize, NULL);
+		err = crypto_skcipher_encrypt(req);
+	}
 out:
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
-	return res;
+	crypto_free_sync_skcipher(tfm);
+	return err;
 }
 
 /*
  * Search the current task's subscribed keyrings for a "logon" key with
  * description prefix:descriptor, and if found acquire a read lock on it and
-- 
2.50.0


