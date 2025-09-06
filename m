Return-Path: <linux-fscrypt+bounces-808-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81A1CB468BE
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 Sep 2025 06:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A2477B0B1C
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 Sep 2025 04:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D52A517B425;
	Sat,  6 Sep 2025 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tgjULxB1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39B929A2;
	Sat,  6 Sep 2025 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757131291; cv=none; b=mSgXYkt9lw1TWXOuGq3hGW2+fGGc7ITuXGe/7Q9xhSBypUHQvjc48Y8V0h5NCpNB6jB6gnHaoumJnEJ70arrn4NM0xuzr1mJFV3Su+dkBSk3t7zqp8vLNbKjkMJB38T/qAyb/0rfR5KVdo0wy7VGxpWp6pCxSAmhpNMKORPH2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757131291; c=relaxed/simple;
	bh=xwekRgQSywTMnK1CtYUK8taqbmueVBFI5LjESUWHNC4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ES8d0GHGGhYQl9op9MzycVgtw9vL9c0mAqYwuw6r3hrRRQ8AzJ/goV6N2uvs2zidiGETLXxMREJOF+cmY1Kn5+jDaRj5DjkXjkh79mjsETqxreBTocUXGhbi/0QIcycf47KfH76oj77bASkR1eQav8sNTcSaxUzjH0rtKQZJ61k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tgjULxB1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4897C4CEE7;
	Sat,  6 Sep 2025 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757131291;
	bh=xwekRgQSywTMnK1CtYUK8taqbmueVBFI5LjESUWHNC4=;
	h=From:To:Cc:Subject:Date:From;
	b=tgjULxB13JNObZim5olsnXfFi7t2BTGPBtEw4JQo9FUrLedDfJOBwzwR1Ivo6uPhr
	 sInMBCGAaXPgOnXHVitMJ37rW207TVjIiqtM5yGKqylAvULDmgMoNmVUU/uRS8qwvf
	 RvcoO54fnXWHwZRFGoxzL2GZCbmp7nI9PDbNIuJUL9ugGBZnDaq+75XMbGBa4wR59s
	 ETVD/7g3bNQWTGbYdYAn+ukRkSzWdCqJNrbbGb5GysU/p3aevHMNukF7dtRteHG0Mx
	 FLuJwPJjmoaXtCFW6fH6mQqBLGSVZ1Pt1jLHpm2yKd32sq92pcm8g6aGzHY2QEeLp/
	 BKWJEbsyO02NA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Hannes Reinecke <hare@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] fscrypt: use HMAC-SHA512 library for HKDF
Date: Fri,  5 Sep 2025 20:59:13 -0700
Message-ID: <20250906035913.1141532-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For the HKDF-SHA512 key derivation needed by fscrypt, just use the
HMAC-SHA512 library functions directly.  These functions were introduced
in v6.17, and they provide simple and efficient direct support for
HMAC-SHA512.  This ends up being quite a bit simpler and more efficient
than using crypto/hkdf.c, as it avoids the generic crypto layer:

- The HMAC library can't fail, so callers don't need to handle errors
- No inefficient indirect calls
- No inefficient and error-prone dynamic allocations
- No inefficient and error-prone loading of algorithm by name
- Less stack usage

Benchmarks on x86_64 show that deriving a per-file key gets about 30%
faster, and FS_IOC_ADD_ENCRYPTION_KEY gets nearly twice as fast.

The only small downside is the HKDF-Expand logic gets duplicated again.
Then again, even considering that, the new fscrypt_hkdf_expand() is only
7 lines longer than the version that called hkdf_expand().  Later we
could add HKDF support to lib/crypto/, but for now let's just do this.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting fscrypt/for-next

 fs/crypto/Kconfig           |   5 +-
 fs/crypto/fname.c           |   1 -
 fs/crypto/fscrypt_private.h |  26 ++++-----
 fs/crypto/hkdf.c            | 109 +++++++++++++-----------------------
 fs/crypto/hooks.c           |   2 +-
 fs/crypto/keyring.c         |  30 +++-------
 fs/crypto/keysetup.c        |  65 +++++++--------------
 fs/crypto/policy.c          |   4 +-
 8 files changed, 82 insertions(+), 160 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index b5dfb0aa405ab..464b54610fd34 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,13 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
 	select CRYPTO
-	select CRYPTO_HASH
-	select CRYPTO_HKDF
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
 	  feature is similar to ecryptfs, but it is more memory
 	  efficient since it avoids caching the encrypted and
@@ -30,12 +29,10 @@ config FS_ENCRYPTION_ALGS
 	tristate
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_CTS
 	select CRYPTO_ECB
-	select CRYPTO_HMAC
-	select CRYPTO_SHA512
 	select CRYPTO_XTS
 
 config FS_ENCRYPTION_INLINE_CRYPT
 	bool "Enable fscrypt to use inline crypto"
 	depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index f9f6713e144f7..5fa1eb58bb1d5 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -9,11 +9,10 @@
  * Modified by Jaegeuk Kim, 2015.
  *
  * This has not yet undergone a rigorous security audit.
  */
 
-#include <crypto/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/skcipher.h>
 #include <linux/export.h>
 #include <linux/namei.h>
 #include <linux/scatterlist.h>
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d8b485b9881c5..3a09f45887a47 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -9,14 +9,14 @@
  */
 
 #ifndef _FSCRYPT_PRIVATE_H
 #define _FSCRYPT_PRIVATE_H
 
+#include <crypto/sha2.h>
 #include <linux/fscrypt.h>
 #include <linux/minmax.h>
 #include <linux/siphash.h>
-#include <crypto/hash.h>
 #include <linux/blk-crypto.h>
 
 #define CONST_STRLEN(str)	(sizeof(str) - 1)
 
 #define FSCRYPT_FILE_NONCE_SIZE	16
@@ -379,16 +379,12 @@ fscrypt_max_file_dun_bits(const struct super_block *sb, int du_bits)
 bool __fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 				    u32 orig_len, u32 max_len,
 				    u32 *encrypted_len_ret);
 
 /* hkdf.c */
-struct fscrypt_hkdf {
-	struct crypto_shash *hmac_tfm;
-};
-
-int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
-		      unsigned int master_key_size);
+void fscrypt_init_hkdf(struct hmac_sha512_key *hkdf, const u8 *master_key,
+		       unsigned int master_key_size);
 
 /*
  * The list of contexts in which fscrypt uses HKDF.  These values are used as
  * the first byte of the HKDF application-specific info string to guarantee that
  * info strings are never repeated between contexts.  This ensures that all HKDF
@@ -403,15 +399,13 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
 #define HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY \
 					8 /* info=<empty>		*/
 
-int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
-			const u8 *info, unsigned int infolen,
-			u8 *okm, unsigned int okmlen);
-
-void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
+void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
+			 const u8 *info, unsigned int infolen,
+			 u8 *okm, unsigned int okmlen);
 
 /* inline_crypt.c */
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
 				   bool is_hw_wrapped_key);
@@ -515,11 +509,11 @@ struct fscrypt_master_key_secret {
 	 * For v1 policy keys, this isn't applicable and won't be set.
 	 * Otherwise, this KDF will be keyed by this master key if
 	 * ->is_hw_wrapped=false, or by the "software secret" that hardware
 	 * derived from this master key if ->is_hw_wrapped=true.
 	 */
-	struct fscrypt_hkdf	hkdf;
+	struct hmac_sha512_key	hkdf;
 
 	/*
 	 * True if this key is a hardware-wrapped key; false if this key is a
 	 * raw key (i.e. a "software key").  For v1 policy keys this will always
 	 * be false, as v1 policy support is a legacy feature which doesn't
@@ -694,11 +688,11 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 
 struct fscrypt_master_key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
 
-int fscrypt_get_test_dummy_key_identifier(
+void fscrypt_get_test_dummy_key_identifier(
 			  u8 key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
 
 int fscrypt_add_test_dummy_key(struct super_block *sb,
 			       struct fscrypt_key_specifier *key_spec);
 
@@ -730,12 +724,12 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 				  struct fscrypt_prepared_key *prep_key);
 
 int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
 				 const u8 *raw_key);
 
-int fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
-			       const struct fscrypt_master_key *mk);
+void fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
+				const struct fscrypt_master_key *mk);
 
 void fscrypt_hash_inode_number(struct fscrypt_inode_info *ci,
 			       const struct fscrypt_master_key *mk);
 
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported);
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index b1ef506cd341d..706f56d0076ee 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -1,18 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
+ * Implementation of HKDF ("HMAC-based Extract-and-Expand Key Derivation
+ * Function"), aka RFC 5869.  See also the original paper (Krawczyk 2010):
+ * "Cryptographic Extraction and Key Derivation: The HKDF Scheme".
+ *
  * This is used to derive keys from the fscrypt master keys (or from the
  * "software secrets" which hardware derives from the fscrypt master keys, in
  * the case that the fscrypt master keys are hardware-wrapped keys).
  *
  * Copyright 2019 Google LLC
  */
 
-#include <crypto/hash.h>
-#include <crypto/hkdf.h>
-#include <crypto/sha2.h>
-
 #include "fscrypt_private.h"
 
 /*
  * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
  * SHA-512 because it is well-established, secure, and reasonably efficient.
@@ -22,11 +22,10 @@
  * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
  * common case of deriving an AES-256-XTS key (512 bits), that can result in
  * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
  * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
  */
-#define HKDF_HMAC_ALG		"hmac(sha512)"
 #define HKDF_HASHLEN		SHA512_DIGEST_SIZE
 
 /*
  * HKDF consists of two steps:
  *
@@ -42,88 +41,60 @@
  * salt is used, since fscrypt master keys should already be pseudorandom and
  * there's no way to persist a random salt per master key from kernel mode.
  */
 
 /*
- * Compute HKDF-Extract using the given master key as the input keying material,
- * and prepare an HMAC transform object keyed by the resulting pseudorandom key.
- *
- * Afterwards, the keyed HMAC transform object can be used for HKDF-Expand many
- * times without having to recompute HKDF-Extract each time.
+ * Compute HKDF-Extract using 'master_key' as the input keying material, and
+ * prepare the resulting HMAC key in 'hkdf'.  Afterwards, 'hkdf' can be used for
+ * HKDF-Expand many times without having to recompute HKDF-Extract each time.
  */
-int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
-		      unsigned int master_key_size)
+void fscrypt_init_hkdf(struct hmac_sha512_key *hkdf, const u8 *master_key,
+		       unsigned int master_key_size)
 {
-	struct crypto_shash *hmac_tfm;
 	static const u8 default_salt[HKDF_HASHLEN];
 	u8 prk[HKDF_HASHLEN];
-	int err;
-
-	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, FSCRYPT_CRYPTOAPI_MASK);
-	if (IS_ERR(hmac_tfm)) {
-		fscrypt_err(NULL, "Error allocating " HKDF_HMAC_ALG ": %ld",
-			    PTR_ERR(hmac_tfm));
-		return PTR_ERR(hmac_tfm);
-	}
-
-	if (WARN_ON_ONCE(crypto_shash_digestsize(hmac_tfm) != sizeof(prk))) {
-		err = -EINVAL;
-		goto err_free_tfm;
-	}
-
-	err = hkdf_extract(hmac_tfm, master_key, master_key_size,
-			   default_salt, HKDF_HASHLEN, prk);
-	if (err)
-		goto err_free_tfm;
-
-	err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
-	if (err)
-		goto err_free_tfm;
 
-	hkdf->hmac_tfm = hmac_tfm;
-	goto out;
-
-err_free_tfm:
-	crypto_free_shash(hmac_tfm);
-out:
+	hmac_sha512_usingrawkey(default_salt, sizeof(default_salt),
+				master_key, master_key_size, prk);
+	hmac_sha512_preparekey(hkdf, prk, sizeof(prk));
 	memzero_explicit(prk, sizeof(prk));
-	return err;
 }
 
 /*
- * HKDF-Expand (RFC 5869 section 2.3).  This expands the pseudorandom key, which
- * was already keyed into 'hkdf->hmac_tfm' by fscrypt_init_hkdf(), into 'okmlen'
+ * HKDF-Expand (RFC 5869 section 2.3).  Expand the HMAC key 'hkdf' into 'okmlen'
  * bytes of output keying material parameterized by the application-specific
  * 'info' of length 'infolen' bytes, prefixed by "fscrypt\0" and the 'context'
  * byte.  This is thread-safe and may be called by multiple threads in parallel.
  *
  * ('context' isn't part of the HKDF specification; it's just a prefix fscrypt
  * adds to its application-specific info strings to guarantee that it doesn't
  * accidentally repeat an info string when using HKDF for different purposes.)
  */
-int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
-			const u8 *info, unsigned int infolen,
-			u8 *okm, unsigned int okmlen)
-{
-	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
-	u8 *full_info;
-	int err;
-
-	full_info = kzalloc(infolen + 9, GFP_KERNEL);
-	if (!full_info)
-		return -ENOMEM;
-	desc->tfm = hkdf->hmac_tfm;
-
-	memcpy(full_info, "fscrypt\0", 8);
-	full_info[8] = context;
-	memcpy(full_info + 9, info, infolen);
-
-	err = hkdf_expand(hkdf->hmac_tfm, full_info, infolen + 9,
-			  okm, okmlen);
-	kfree_sensitive(full_info);
-	return err;
-}
-
-void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf)
+void fscrypt_hkdf_expand(const struct hmac_sha512_key *hkdf, u8 context,
+			 const u8 *info, unsigned int infolen,
+			 u8 *okm, unsigned int okmlen)
 {
-	crypto_free_shash(hkdf->hmac_tfm);
+	struct hmac_sha512_ctx ctx;
+	u8 counter = 1;
+	u8 tmp[HKDF_HASHLEN];
+
+	WARN_ON_ONCE(okmlen > 255 * HKDF_HASHLEN);
+
+	for (unsigned int i = 0; i < okmlen; i += HKDF_HASHLEN) {
+		hmac_sha512_init(&ctx, hkdf);
+		if (i != 0)
+			hmac_sha512_update(&ctx, &okm[i - HKDF_HASHLEN],
+					   HKDF_HASHLEN);
+		hmac_sha512_update(&ctx, "fscrypt\0", 8);
+		hmac_sha512_update(&ctx, &context, 1);
+		hmac_sha512_update(&ctx, info, infolen);
+		hmac_sha512_update(&ctx, &counter, 1);
+		if (okmlen - i < HKDF_HASHLEN) {
+			hmac_sha512_final(&ctx, tmp);
+			memcpy(&okm[i], tmp, okmlen - i);
+			memzero_explicit(tmp, sizeof(tmp));
+		} else {
+			hmac_sha512_final(&ctx, &okm[i]);
+		}
+		counter++;
+	}
 }
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index e0b32ac841f76..0fb3496551b94 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -203,11 +203,11 @@ int fscrypt_prepare_setflags(struct inode *inode,
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
 			return -EINVAL;
 		mk = ci->ci_master_key;
 		down_read(&mk->mk_sem);
 		if (mk->mk_present)
-			err = fscrypt_derive_dirhash_key(ci, mk);
+			fscrypt_derive_dirhash_key(ci, mk);
 		else
 			err = -ENOKEY;
 		up_read(&mk->mk_sem);
 		return err;
 	}
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7557f6a88b8f3..3adbd7167055a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -40,11 +40,10 @@ struct fscrypt_keyring {
 	struct hlist_head key_hashtable[128];
 };
 
 static void wipe_master_key_secret(struct fscrypt_master_key_secret *secret)
 {
-	fscrypt_destroy_hkdf(&secret->hkdf);
 	memzero_explicit(secret, sizeof(*secret));
 }
 
 static void move_master_key_secret(struct fscrypt_master_key_secret *dst,
 				   struct fscrypt_master_key_secret *src)
@@ -585,25 +584,21 @@ static int add_master_key(struct super_block *sb,
 			 * identifiers using different KDF contexts.
 			 */
 			keyid_kdf_ctx =
 				HKDF_CONTEXT_KEY_IDENTIFIER_FOR_HW_WRAPPED_KEY;
 		}
-		err = fscrypt_init_hkdf(&secret->hkdf, kdf_key, kdf_key_size);
+		fscrypt_init_hkdf(&secret->hkdf, kdf_key, kdf_key_size);
 		/*
 		 * Now that the KDF context is initialized, the raw KDF key is
 		 * no longer needed.
 		 */
 		memzero_explicit(kdf_key, kdf_key_size);
-		if (err)
-			return err;
 
 		/* Calculate the key identifier */
-		err = fscrypt_hkdf_expand(&secret->hkdf, keyid_kdf_ctx, NULL, 0,
-					  key_spec->u.identifier,
-					  FSCRYPT_KEY_IDENTIFIER_SIZE);
-		if (err)
-			return err;
+		fscrypt_hkdf_expand(&secret->hkdf, keyid_kdf_ctx, NULL, 0,
+				    key_spec->u.identifier,
+				    FSCRYPT_KEY_IDENTIFIER_SIZE);
 	}
 	return do_add_master_key(sb, secret, key_spec);
 }
 
 /*
@@ -833,28 +828,21 @@ fscrypt_get_test_dummy_secret(struct fscrypt_master_key_secret *secret)
 	memset(secret, 0, sizeof(*secret));
 	secret->size = sizeof(test_key);
 	memcpy(secret->bytes, test_key, sizeof(test_key));
 }
 
-int fscrypt_get_test_dummy_key_identifier(
+void fscrypt_get_test_dummy_key_identifier(
 				u8 key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
 {
 	struct fscrypt_master_key_secret secret;
-	int err;
 
 	fscrypt_get_test_dummy_secret(&secret);
-
-	err = fscrypt_init_hkdf(&secret.hkdf, secret.bytes, secret.size);
-	if (err)
-		goto out;
-	err = fscrypt_hkdf_expand(&secret.hkdf,
-				  HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY,
-				  NULL, 0, key_identifier,
-				  FSCRYPT_KEY_IDENTIFIER_SIZE);
-out:
+	fscrypt_init_hkdf(&secret.hkdf, secret.bytes, secret.size);
+	fscrypt_hkdf_expand(&secret.hkdf,
+			    HKDF_CONTEXT_KEY_IDENTIFIER_FOR_RAW_KEY, NULL, 0,
+			    key_identifier, FSCRYPT_KEY_IDENTIFIER_SIZE);
 	wipe_master_key_secret(&secret);
-	return err;
 }
 
 /**
  * fscrypt_add_test_dummy_key() - add the test dummy encryption key
  * @sb: the filesystem instance to add the key to
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 4f3b9ecbfe4e6..a3ed96eaebc85 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -251,15 +251,12 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 	if (include_fs_uuid) {
 		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
 		       sizeof(sb->s_uuid));
 		hkdf_infolen += sizeof(sb->s_uuid);
 	}
-	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
-				  hkdf_context, hkdf_info, hkdf_infolen,
-				  mode_key, mode->keysize);
-	if (err)
-		goto out_unlock;
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context, hkdf_info,
+			    hkdf_infolen, mode_key, mode->keysize);
 	err = fscrypt_prepare_key(prep_key, mode_key, ci);
 	memzero_explicit(mode_key, mode->keysize);
 	if (err)
 		goto out_unlock;
 done_unlock:
@@ -276,40 +273,29 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
  *
  * Note that the KDF produces a byte array, but the SipHash APIs expect the key
  * as a pair of 64-bit words.  Therefore, on big endian CPUs we have to do an
  * endianness swap in order to get the same results as on little endian CPUs.
  */
-static int fscrypt_derive_siphash_key(const struct fscrypt_master_key *mk,
-				      u8 context, const u8 *info,
-				      unsigned int infolen, siphash_key_t *key)
+static void fscrypt_derive_siphash_key(const struct fscrypt_master_key *mk,
+				       u8 context, const u8 *info,
+				       unsigned int infolen, siphash_key_t *key)
 {
-	int err;
-
-	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf, context, info, infolen,
-				  (u8 *)key, sizeof(*key));
-	if (err)
-		return err;
-
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, context, info, infolen,
+			    (u8 *)key, sizeof(*key));
 	BUILD_BUG_ON(sizeof(*key) != 16);
 	BUILD_BUG_ON(ARRAY_SIZE(key->key) != 2);
 	le64_to_cpus(&key->key[0]);
 	le64_to_cpus(&key->key[1]);
-	return 0;
 }
 
-int fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
-			       const struct fscrypt_master_key *mk)
+void fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
+				const struct fscrypt_master_key *mk)
 {
-	int err;
-
-	err = fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_DIRHASH_KEY,
-					 ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
-					 &ci->ci_dirhash_key);
-	if (err)
-		return err;
+	fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_DIRHASH_KEY,
+				   ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+				   &ci->ci_dirhash_key);
 	ci->ci_dirhash_key_initialized = true;
-	return 0;
 }
 
 void fscrypt_hash_inode_number(struct fscrypt_inode_info *ci,
 			       const struct fscrypt_master_key *mk)
 {
@@ -336,21 +322,16 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_inode_info *ci,
 		mutex_lock(&fscrypt_mode_key_setup_mutex);
 
 		if (mk->mk_ino_hash_key_initialized)
 			goto unlock;
 
-		err = fscrypt_derive_siphash_key(mk,
-						 HKDF_CONTEXT_INODE_HASH_KEY,
-						 NULL, 0, &mk->mk_ino_hash_key);
-		if (err)
-			goto unlock;
+		fscrypt_derive_siphash_key(mk, HKDF_CONTEXT_INODE_HASH_KEY,
+					   NULL, 0, &mk->mk_ino_hash_key);
 		/* pairs with smp_load_acquire() above */
 		smp_store_release(&mk->mk_ino_hash_key_initialized, true);
 unlock:
 		mutex_unlock(&fscrypt_mode_key_setup_mutex);
-		if (err)
-			return err;
 	}
 
 	/*
 	 * New inodes may not have an inode number assigned yet.
 	 * Hashing their inode number is delayed until later.
@@ -400,29 +381,23 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
 
-		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
-					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
-					  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
-					  derived_key, ci->ci_mode->keysize);
-		if (err)
-			return err;
-
+		fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
+				    HKDF_CONTEXT_PER_FILE_ENC_KEY,
+				    ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+				    derived_key, ci->ci_mode->keysize);
 		err = fscrypt_set_per_file_enc_key(ci, derived_key);
 		memzero_explicit(derived_key, ci->ci_mode->keysize);
 	}
 	if (err)
 		return err;
 
 	/* Derive a secret dirhash key for directories that need it. */
-	if (need_dirhash_key) {
-		err = fscrypt_derive_dirhash_key(ci, mk);
-		if (err)
-			return err;
-	}
+	if (need_dirhash_key)
+		fscrypt_derive_dirhash_key(ci, mk);
 
 	return 0;
 }
 
 /*
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 6ad30ae07c065..cf38b36d7bdfd 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -824,14 +824,12 @@ int fscrypt_parse_test_dummy_encryption(const struct fs_parameter *param,
 		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 	} else if (!strcmp(arg, "v2")) {
 		policy->version = FSCRYPT_POLICY_V2;
 		policy->v2.contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
 		policy->v2.filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
-		err = fscrypt_get_test_dummy_key_identifier(
+		fscrypt_get_test_dummy_key_identifier(
 				policy->v2.master_key_identifier);
-		if (err)
-			goto out;
 	} else {
 		err = -EINVAL;
 		goto out;
 	}
 

base-commit: 0e6608d4938eb209616e8673c95364bb2a7d55bd
-- 
2.50.1


