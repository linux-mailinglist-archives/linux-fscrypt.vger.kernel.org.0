Return-Path: <linux-fscrypt+bounces-1535-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAg8JBFPvmntMAMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1535-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Mar 2026 08:56:01 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9651B2E414D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Mar 2026 08:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CF18F301C5A1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Mar 2026 07:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E694534750E;
	Sat, 21 Mar 2026 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbX8KUHW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143C3451CD;
	Sat, 21 Mar 2026 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774079754; cv=none; b=eMXZ8i9gYJ7lfFS/+wWUiTXzgUb7TTgyH/vRc3mKENmFSdp1hp/Vlghufkkunza7/VX7LYF63temdqVYVSfacubtHnaQl0aT4ZN7DIsIjZG8UhmmdNQvxiCE1Vgwjjk8OC9k/ISh8fmmFDD+DQp7ekjO7zawJ4uefDqkRwWnGN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774079754; c=relaxed/simple;
	bh=puCGFcYeI61lOqZL3kjhFyXd4MxNKJiMgQEPJxLCdOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZnpYLHltpB6TWsonMv4woPXwyP/qptoMVEG6WvBP7FXIBeyntAUtYX8Cz/VsI+Nmfgi9Bp9TjyJnM7cJBD6M9V0LZvL4tczZpXF1Lm6/hK1KyNBg0u4FdXKXsrtSgA6x+gV1xrhzQcFVLz9IrXTEeYAaqd5kqsrgV/G8b2C++L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbX8KUHW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE20C19421;
	Sat, 21 Mar 2026 07:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774079754;
	bh=puCGFcYeI61lOqZL3kjhFyXd4MxNKJiMgQEPJxLCdOo=;
	h=From:To:Cc:Subject:Date:From;
	b=fbX8KUHWpGso5TqHkVPb0LOJFHjlWUNnEDTVxmdbeQ4mjd9Dzp/c2bwYKaw2tcXou
	 9GNANBei0gNe/HMoYqB/VCftg/Xf4o2YEWAawlSDNzZoqF9QwKTVuaxYeF8as5si7k
	 24ArixYRtRwet6MiwU/xQOcjzy0g8Wi5P4PuP8alhtuK6eAiQflHVbMqVfG6Ipam4+
	 sNq+f8G+M3KM1yB+iwTpDdZkA6Km7ku0GZRK3ZFkgRCN40gi26qsq0GpQ2iGzvh5Dh
	 OsNiOuRqOHY84eM1mNh0F4flDFA445xMjzKWxey3Pgn26HBWvEjfHqJi3GpekUUYLT
	 0ayOdYIx2Gysw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] fscrypt: use AES library for v1 key derivation
Date: Sat, 21 Mar 2026 00:53:38 -0700
Message-ID: <20260321075338.99809-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1535-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9651B2E414D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Convert the implementation of the v1 (original / deprecated) fscrypt
per-file key derivation algorithm to use the AES library instead of an
"ecb(aes)" crypto_skcipher.  This is much simpler.

While the AES library doesn't support AES-ECB directly yet, we can still
simply call aes_encrypt() in a loop.  While that doesn't explicitly
parallelize the AES encryptions, it doesn't really matter in this case,
where a new key is used each time and only 16 to 64 bytes are encrypted.

In fact, a quick benchmark (AMD Ryzen 9 9950X) shows that this commit
actually greatly improves performance, from ~7000 cycles per key derived
to ~1500.  The times don't differ much between 32 bytes and 64 bytes
either, so clearly the bottleneck is API stuff and key expansion.

Granted, performance of the v1 key derivation is no longer very
relevant: most users have moved onto v2 encryption policies.  The v2 key
derivation uses HKDF-SHA512 (which is ~3500 cycles on the same CPU).

Still, it's nice that the simpler solution is much faster as well.

Compatibility verified with xfstests generic/548.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting fscrypt/for-next

 fs/crypto/Kconfig       |  2 +-
 fs/crypto/keysetup_v1.c | 87 +++++++++++++----------------------------
 2 files changed, 29 insertions(+), 60 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 464b54610fd3..983d8ad1f417 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,10 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
 	select CRYPTO
 	select CRYPTO_SKCIPHER
+	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
@@ -28,11 +29,10 @@ config FS_ENCRYPTION
 config FS_ENCRYPTION_ALGS
 	tristate
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_CTS
-	select CRYPTO_ECB
 	select CRYPTO_XTS
 
 config FS_ENCRYPTION_INLINE_CRYPT
 	bool "Enable fscrypt to use inline crypto"
 	depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 3d673c36b678..e6e527c73f16 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -18,64 +18,21 @@
  * - Handling policies with the DIRECT_KEY flag set using a master key table
  *   (rather than the new method of implementing DIRECT_KEY with per-mode keys
  *    managed alongside the master keys in the filesystem-level keyring)
  */
 
-#include <crypto/skcipher.h>
+#include <crypto/aes.h>
 #include <crypto/utils.h>
 #include <keys/user-type.h>
 #include <linux/hashtable.h>
-#include <linux/scatterlist.h>
 
 #include "fscrypt_private.h"
 
 /* Table of keys referenced by DIRECT_KEY policies */
 static DEFINE_HASHTABLE(fscrypt_direct_keys, 6); /* 6 bits = 64 buckets */
 static DEFINE_SPINLOCK(fscrypt_direct_keys_lock);
 
-/*
- * v1 key derivation function.  This generates the derived key by encrypting the
- * master key with AES-128-ECB using the nonce as the AES key.  This provides a
- * unique derived key with sufficient entropy for each inode.  However, it's
- * nonstandard, non-extensible, doesn't evenly distribute the entropy from the
- * master key, and is trivially reversible: an attacker who compromises a
- * derived key can "decrypt" it to get back to the master key, then derive any
- * other key.  For all new code, use HKDF instead.
- *
- * The master key must be at least as long as the derived key.  If the master
- * key is longer, then only the first 'derived_keysize' bytes are used.
- */
-static int derive_key_aes(const u8 *master_key,
-			  const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
-			  u8 *derived_key, unsigned int derived_keysize)
-{
-	struct crypto_sync_skcipher *tfm;
-	int err;
-
-	tfm = crypto_alloc_sync_skcipher("ecb(aes)", 0, FSCRYPT_CRYPTOAPI_MASK);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	err = crypto_sync_skcipher_setkey(tfm, nonce, FSCRYPT_FILE_NONCE_SIZE);
-	if (err == 0) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
-		struct scatterlist src_sg, dst_sg;
-
-		skcipher_request_set_callback(req,
-					      CRYPTO_TFM_REQ_MAY_BACKLOG |
-						      CRYPTO_TFM_REQ_MAY_SLEEP,
-					      NULL, NULL);
-		sg_init_one(&src_sg, master_key, derived_keysize);
-		sg_init_one(&dst_sg, derived_key, derived_keysize);
-		skcipher_request_set_crypt(req, &src_sg, &dst_sg,
-					   derived_keysize, NULL);
-		err = crypto_skcipher_encrypt(req);
-	}
-	crypto_free_sync_skcipher(tfm);
-	return err;
-}
-
 /*
  * Search the current task's subscribed keyrings for a "logon" key with
  * description prefix:descriptor, and if found acquire a read lock on it and
  * return a pointer to its validated payload in *payload_ret.
  */
@@ -253,33 +210,45 @@ static int setup_v1_file_key_direct(struct fscrypt_inode_info *ci,
 	ci->ci_direct_key = dk;
 	ci->ci_enc_key = dk->dk_key;
 	return 0;
 }
 
-/* v1 policy, !DIRECT_KEY: derive the file's encryption key */
+/*
+ * v1 policy, !DIRECT_KEY: derive the file's encryption key.
+ *
+ * The v1 key derivation function generates the derived key by encrypting the
+ * master key with AES-128-ECB using the file's nonce as the AES key.  This
+ * provides a unique derived key with sufficient entropy for each inode.
+ * However, it's nonstandard, non-extensible, doesn't evenly distribute the
+ * entropy from the master key, and is trivially reversible: an attacker who
+ * compromises a derived key can "decrypt" it to get back to the master key,
+ * then derive any other key.  For all new code, use HKDF instead.
+ *
+ * The master key must be at least as long as the derived key.  If the master
+ * key is longer, then only the first ci->ci_mode->keysize bytes are used.
+ */
 static int setup_v1_file_key_derived(struct fscrypt_inode_info *ci,
 				     const u8 *raw_master_key)
 {
-	u8 *derived_key;
+	const unsigned int derived_keysize = ci->ci_mode->keysize;
+	u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
+	struct aes_enckey aes;
 	int err;
 
-	/*
-	 * This cannot be a stack buffer because it will be passed to the
-	 * scatterlist crypto API during derive_key_aes().
-	 */
-	derived_key = kmalloc(ci->ci_mode->keysize, GFP_KERNEL);
-	if (!derived_key)
-		return -ENOMEM;
+	if (WARN_ON_ONCE(derived_keysize > FSCRYPT_MAX_RAW_KEY_SIZE ||
+			 derived_keysize % AES_BLOCK_SIZE != 0))
+		return -EINVAL;
 
-	err = derive_key_aes(raw_master_key, ci->ci_nonce,
-			     derived_key, ci->ci_mode->keysize);
-	if (err)
-		goto out;
+	static_assert(FSCRYPT_FILE_NONCE_SIZE == AES_KEYSIZE_128);
+	aes_prepareenckey(&aes, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
+	for (unsigned int i = 0; i < derived_keysize; i += AES_BLOCK_SIZE)
+		aes_encrypt(&aes, &derived_key[i], &raw_master_key[i]);
 
 	err = fscrypt_set_per_file_enc_key(ci, derived_key);
-out:
-	kfree_sensitive(derived_key);
+
+	memzero_explicit(derived_key, derived_keysize);
+	/* No need to zeroize 'aes', as its key is not secret. */
 	return err;
 }
 
 int fscrypt_setup_v1_file_key(struct fscrypt_inode_info *ci,
 			      const u8 *raw_master_key)

base-commit: 4377a22d84f726f0a650927edf75cdc0698baf06
-- 
2.53.0


