Return-Path: <linux-fscrypt+bounces-661-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4011AD607D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Jun 2025 23:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96EE13AA67C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Jun 2025 21:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23EA91F4CB7;
	Wed, 11 Jun 2025 21:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvTiMFEp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDC419A;
	Wed, 11 Jun 2025 21:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749675631; cv=none; b=Cmj9XGU1chUBo3Gg9W6lA8TJj1T1WvBZNn/zTHzpI7bwpxclUDjQ/8gmmh0DXlR060SoWEk1DHtmcd+WenTxgIqt3u4mG8VESvqHvJeJsv+WpIOfH82ZTB0naTXQvWg7CpHfn6/eh4MqT2jdT9GRC/WvRvG+a7fpvnMwpxMDTGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749675631; c=relaxed/simple;
	bh=ufdekVOYWt8m3xq4jkK/O28QDQm1sAnVWeCFEjZjOhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S9h8v9+IGdEc0Ruf7tW+tlutYjji2X61Xyy/jHOdoK7xvWi1tFp9s2Af+2poL2dFb6qzML2UU4bNV2bRiU7xOMSiHZg4wiAw26XvTLQuZIADx8XApvvmC7h5cGUBKS1xv5LBGS824ZhGc3iu76Mk69nl+WxbC22ftGt8DkUp1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvTiMFEp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C44C4CEE3;
	Wed, 11 Jun 2025 21:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749675630;
	bh=ufdekVOYWt8m3xq4jkK/O28QDQm1sAnVWeCFEjZjOhw=;
	h=From:To:Cc:Subject:Date:From;
	b=RvTiMFEpxUD4MzFZRsyUdiXQH0upKQl4nEyPUOFBiaCI7vET0SorY8i8il3dXTZMS
	 edik1QH0PF4rSwwha/q0PR7wYYxOagItYezlwJgpK2qU3A44yrdFiIKbRDLx33D57E
	 GO2Gg1p8X4GPddbngPnV/fuclAPMmULwzEV/3wrgXFmDr9vaR4DIPiYQcdPn87+/XJ
	 agWoe8yQStLctGQfdX3PTZAqQ/R/mC6GsqUBQQt1jAl/qFIVvNX1PgLTGjjO7hORJi
	 Z1JnvyWIf2cmCGyowvkW8AwGDJ0tTuplmjW3s/i67PvKd1LfzTh5puWEIvdV3H5GQM
	 E2hR+5dqNIs8g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Date: Wed, 11 Jun 2025 13:58:59 -0700
Message-ID: <20250611205859.80819-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

fscrypt has never properly supported the old-school Crypto API hardware
offload drivers, as it processes each request synchronously.  There was
one report of someone successfully using such a driver 8 years ago.  But
otherwise this style of hardware offload is basically obsolete and has
been superseded by hardware-accelerated crypto instructions directly on
the CPU as well as inline storage encryption (UFS/eMMC).  Since then,
all I've gotten are issue reports where someone accidentally used a
buggy offload driver and it caused a problem for them, for example:

- https://lore.kernel.org/r/PH0PR02MB731916ECDB6C613665863B6CFFAA2@PH0PR02MB7319.namprd02.prod.outlook.com
- https://github.com/google/fscryptctl/issues/32

To protect users from these buggy and seemingly unhelpful drivers that I
have no way of testing, let's make fscrypt not use them.  Unfortunately
there is no direct support for doing so in the Crypto API, but we can
achieve something very close to it by disallowing algorithms that have
ASYNC, ALLOCATES_MEMORY, or KERN_DRIVER_ONLY set.

Disallowing ASYNC has the bonus that the code that waits for
asynchronous requests to complete is no longer necessary.

Note that for years dm-crypt has already had most of these drivers
disabled, as it disallows algorithms with ALLOCATES_MEMORY.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c          |  7 +++----
 fs/crypto/fname.c           | 18 ++++++++----------
 fs/crypto/fscrypt_private.h | 14 ++++++++++++++
 fs/crypto/hkdf.c            |  2 +-
 fs/crypto/keysetup.c        |  3 ++-
 fs/crypto/keysetup_v1.c     | 12 ++++++------
 6 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index b74b5937e695c..0acb440ae9723 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -111,11 +111,10 @@ int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 			    unsigned int len, unsigned int offs,
 			    gfp_t gfp_flags)
 {
 	union fscrypt_iv iv;
 	struct skcipher_request *req = NULL;
-	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	int res = 0;
 
 	if (WARN_ON_ONCE(len <= 0))
@@ -129,21 +128,21 @@ int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 	if (!req)
 		return -ENOMEM;
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		crypto_req_done, &wait);
+		NULL, NULL);
 
 	sg_init_table(&dst, 1);
 	sg_set_page(&dst, dest_page, len, offs);
 	sg_init_table(&src, 1);
 	sg_set_page(&src, src_page, len, offs);
 	skcipher_request_set_crypt(req, &src, &dst, len, &iv);
 	if (rw == FS_DECRYPT)
-		res = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
+		res = crypto_skcipher_decrypt(req);
 	else
-		res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+		res = crypto_skcipher_encrypt(req);
 	skcipher_request_free(req);
 	if (res) {
 		fscrypt_err(ci->ci_inode,
 			    "%scryption failed for data unit %llu: %d",
 			    (rw == FS_DECRYPT ? "De" : "En"), index, res);
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 010f9c0a4c2f1..6365070211c02 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -91,11 +91,10 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
  */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen)
 {
 	struct skcipher_request *req = NULL;
-	DECLARE_CRYPTO_WAIT(wait);
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	struct scatterlist sg;
 	int res;
@@ -114,18 +113,18 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 
 	/* Set up the encryption request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
-	skcipher_request_set_callback(req,
-			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			crypto_req_done, &wait);
+	skcipher_request_set_callback(
+		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		NULL, NULL);
 	sg_init_one(&sg, out, olen);
 	skcipher_request_set_crypt(req, &sg, &sg, olen, &iv);
 
 	/* Do the encryption */
-	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	res = crypto_skcipher_encrypt(req);
 	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename encryption failed: %d", res);
 		return res;
 	}
@@ -147,33 +146,32 @@ EXPORT_SYMBOL_GPL(fscrypt_fname_encrypt);
 static int fname_decrypt(const struct inode *inode,
 			 const struct fscrypt_str *iname,
 			 struct fscrypt_str *oname)
 {
 	struct skcipher_request *req = NULL;
-	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	union fscrypt_iv iv;
 	int res;
 
 	/* Allocate request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
-	skcipher_request_set_callback(req,
-		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		crypto_req_done, &wait);
+	skcipher_request_set_callback(
+		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		NULL, NULL);
 
 	/* Initialize IV */
 	fscrypt_generate_iv(&iv, 0, ci);
 
 	/* Create decryption request */
 	sg_init_one(&src_sg, iname->name, iname->len);
 	sg_init_one(&dst_sg, oname->name, oname->len);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, iname->len, &iv);
-	res = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
+	res = crypto_skcipher_decrypt(req);
 	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename decryption failed: %d", res);
 		return res;
 	}
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index c1d92074b65c5..e9acf96f76739 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -43,10 +43,24 @@
  * hardware-wrapped keys has made it misleading as it's only for raw keys.
  * Don't use it in kernel code; use one of the above constants instead.
  */
 #undef FSCRYPT_MAX_KEY_SIZE
 
+/*
+ * This mask is passed as the third argument to crypto_alloc_*() functions to
+ * disallow CryptoAPI algorithm implementations that have any of these flags
+ * set.  This ensures that fscrypt uses only either well-tested "software"
+ * crypto (which these days is usually hardware-accelerated by specialized CPU
+ * instructions) or an inline encryption engine, not obsolete dedicated crypto
+ * accelerators.  Dedicated crypto accelerators often have buggy drivers and/or
+ * are slower than the "software" crypto, and fscrypt has never really been able
+ * to properly take advantage of them, as it en/decrypts data synchronously.
+ */
+#define FSCRYPT_CRYPTOAPI_MASK                            \
+	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY | \
+	 CRYPTO_ALG_KERN_DRIVER_ONLY)
+
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 0f3028adc9c72..5b9c21cfe2b45 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -56,11 +56,11 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 	struct crypto_shash *hmac_tfm;
 	static const u8 default_salt[HKDF_HASHLEN];
 	u8 prk[HKDF_HASHLEN];
 	int err;
 
-	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
+	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, FSCRYPT_CRYPTOAPI_MASK);
 	if (IS_ERR(hmac_tfm)) {
 		fscrypt_err(NULL, "Error allocating " HKDF_HMAC_ALG ": %ld",
 			    PTR_ERR(hmac_tfm));
 		return PTR_ERR(hmac_tfm);
 	}
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 0d71843af9469..d8113a7196979 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -101,11 +101,12 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			  const struct inode *inode)
 {
 	struct crypto_skcipher *tfm;
 	int err;
 
-	tfm = crypto_alloc_skcipher(mode->cipher_str, 0, 0);
+	tfm = crypto_alloc_skcipher(mode->cipher_str, 0,
+				    FSCRYPT_CRYPTOAPI_MASK);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
 			fscrypt_warn(inode,
 				     "Missing crypto API support for %s (API name: \"%s\")",
 				     mode->friendly_name, mode->cipher_str);
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index b70521c55132b..3fdf174384f3d 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -48,13 +48,13 @@ static int derive_key_aes(const u8 *master_key,
 			  const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
 			  u8 *derived_key, unsigned int derived_keysize)
 {
 	int res = 0;
 	struct skcipher_request *req = NULL;
-	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
-	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	struct crypto_skcipher *tfm =
+		crypto_alloc_skcipher("ecb(aes)", 0, FSCRYPT_CRYPTOAPI_MASK);
 
 	if (IS_ERR(tfm)) {
 		res = PTR_ERR(tfm);
 		tfm = NULL;
 		goto out;
@@ -63,22 +63,22 @@ static int derive_key_aes(const u8 *master_key,
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		res = -ENOMEM;
 		goto out;
 	}
-	skcipher_request_set_callback(req,
-			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			crypto_req_done, &wait);
+	skcipher_request_set_callback(
+		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		NULL, NULL);
 	res = crypto_skcipher_setkey(tfm, nonce, FSCRYPT_FILE_NONCE_SIZE);
 	if (res < 0)
 		goto out;
 
 	sg_init_one(&src_sg, master_key, derived_keysize);
 	sg_init_one(&dst_sg, derived_key, derived_keysize);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, derived_keysize,
 				   NULL);
-	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+	res = crypto_skcipher_encrypt(req);
 out:
 	skcipher_request_free(req);
 	crypto_free_skcipher(tfm);
 	return res;
 }

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0


