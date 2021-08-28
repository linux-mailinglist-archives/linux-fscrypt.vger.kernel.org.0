Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95133FA282
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Aug 2021 02:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbhH1AkP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Aug 2021 20:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhH1AkL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Aug 2021 20:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94EFE60FD9;
        Sat, 28 Aug 2021 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630111160;
        bh=Pcb9LguJG/IekBjhF/+KIpyiXRSksr2RsXIKGXyHRME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM5nb/8DQd+l3iFMEj5GH2S2nghGCQShMRRTGWFGM+zUD5EA+HTyXgcdezYWZS7U4
         5iElEoRmOGb1/ZlH7eeFEjd0HGwieB7LJnorE8wx+9tTY3qKLiqAQBg6KLTHdgJGMI
         fml4WGEzg16NtD0TjFwsFE7YQMTGGbwejQ+Dc7T0ULEA5TnUru0dkYq4FwxiVsCuIv
         jR0kdFe+im9aMNwyLjY8pQycJ7j5BLIGgLjZWMW4oR/xVkL+xu5DWC+Cdp21vtf80L
         /b5uGimfO4r5q6+F+Cv+t+I+uOt5chVU8gpXkWw+GVOPyxH2aYBP6L30K7CT0c5F3+
         ifK/7d1LvytPQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [RFC PATCH 3/4] fscrypt: allow 256-bit master keys with AES-256-XTS
Date:   Fri, 27 Aug 2021 17:32:23 -0700
Message-Id: <20210828003224.33346-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828003224.33346-1-ebiggers@kernel.org>
References: <20210828003224.33346-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt currently requires a 512-bit master key when AES-256-XTS is
used, since AES-256-XTS keys are 512-bit and fscrypt requires that the
master key be at least as long any key that will be derived from it.

However, this is overly strict because AES-256-XTS doesn't actually have
a 512-bit security strength, but rather 256-bit.  The fact that XTS
takes twice the expected key size is a quirk of the XTS mode.  It is
sufficient to use 256 bits of entropy for AES-256-XTS, provided that it
is first properly expanded into a 512-bit key, which HKDF-SHA512 does.

Therefore, relax the check of the master key size to use the security
strength of the derived key rather than the size of the derived key
(except for v1 encryption policies, which don't use HKDF).

Besides making things more flexible for userspace, this is needed in
order for the use of a KDF which only takes a 256-bit key to be
introduced into the fscrypt key hierarchy.  This will happen with
hardware-wrapped keys support, as all known hardware which supports that
feature uses an SP800-108 KDF using AES-256-CMAC, so the wrapped keys
are wrapped 256-bit AES keys.  Moreover, there is interest in fscrypt
supporting the same type of AES-256-CMAC based KDF in software as an
alternative to HKDF-SHA512.  There is no security problem with such
features, so fix the key length check to work properly with them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  5 ++--
 fs/crypto/hkdf.c            | 11 +++++--
 fs/crypto/keysetup.c        | 57 +++++++++++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 3fa965eb3336d..cb25ef0cdf1f3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -549,8 +549,9 @@ int __init fscrypt_init_keyring(void);
 struct fscrypt_mode {
 	const char *friendly_name;
 	const char *cipher_str;
-	int keysize;
-	int ivsize;
+	int keysize;		/* key size in bytes */
+	int security_strength;	/* security strength in bytes */
+	int ivsize;		/* IV size in bytes */
 	int logged_impl_name;
 	enum blk_crypto_mode_num blk_crypto_mode;
 };
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index e0ec210555053..7607d18b35fc0 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -16,9 +16,14 @@
 
 /*
  * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
- * SHA-512 because it is reasonably secure and efficient; and since it produces
- * a 64-byte digest, deriving an AES-256-XTS key preserves all 64 bytes of
- * entropy from the master key and requires only one iteration of HKDF-Expand.
+ * SHA-512 because it is well-established, secure, and reasonably efficient.
+ *
+ * HKDF-SHA256 was also considered, as its 256-bit security strength would be
+ * sufficient here.  A 512-bit security strength is "nice to have", though.
+ * Also, on 64-bit CPUs, SHA-512 is usually just as fast as SHA-256.  In the
+ * common case of deriving an AES-256-XTS key (512 bits), that can result in
+ * HKDF-SHA512 being much faster than HKDF-SHA256, as the longer digest size of
+ * SHA-512 causes HKDF-Expand to only need to do one iteration rather than two.
  */
 #define HKDF_HMAC_ALG		"hmac(sha512)"
 #define HKDF_HASHLEN		SHA512_DIGEST_SIZE
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index bca9c6658a7c5..89cd533a88bff 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -19,6 +19,7 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.friendly_name = "AES-256-XTS",
 		.cipher_str = "xts(aes)",
 		.keysize = 64,
+		.security_strength = 32,
 		.ivsize = 16,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS,
 	},
@@ -26,12 +27,14 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.friendly_name = "AES-256-CTS-CBC",
 		.cipher_str = "cts(cbc(aes))",
 		.keysize = 32,
+		.security_strength = 32,
 		.ivsize = 16,
 	},
 	[FSCRYPT_MODE_AES_128_CBC] = {
 		.friendly_name = "AES-128-CBC-ESSIV",
 		.cipher_str = "essiv(cbc(aes),sha256)",
 		.keysize = 16,
+		.security_strength = 16,
 		.ivsize = 16,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	},
@@ -39,12 +42,14 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.friendly_name = "AES-128-CTS-CBC",
 		.cipher_str = "cts(cbc(aes))",
 		.keysize = 16,
+		.security_strength = 16,
 		.ivsize = 16,
 	},
 	[FSCRYPT_MODE_ADIANTUM] = {
 		.friendly_name = "Adiantum",
 		.cipher_str = "adiantum(xchacha12,aes)",
 		.keysize = 32,
+		.security_strength = 32,
 		.ivsize = 32,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_ADIANTUM,
 	},
@@ -357,6 +362,45 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 	return 0;
 }
 
+/*
+ * Check whether the size of the given master key (@mk) is appropriate for the
+ * encryption settings which a particular file will use (@ci).
+ *
+ * If the file uses a v1 encryption policy, then the master key must be at least
+ * as long as the derived key, as this is a requirement of the v1 KDF.
+ *
+ * Otherwise, the KDF can accept any size key, so we enforce a slightly looser
+ * requirement: we require that the size of the master key be at least the
+ * maximum security strength of any algorithm whose key will be derived from it
+ * (but in practice we only need to consider @ci->ci_mode, since any other
+ * possible subkeys such as DIRHASH and INODE_HASH will never increase the
+ * required key size over @ci->ci_mode).  This allows AES-256-XTS keys to be
+ * derived from a 256-bit master key, which is cryptographically sufficient,
+ * rather than requiring a 512-bit master key which is unnecessarily long.  (We
+ * still allow 512-bit master keys if the user chooses to use them, though.)
+ */
+static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
+					  const struct fscrypt_info *ci)
+{
+	unsigned int min_keysize;
+
+	if (ci->ci_policy.version == FSCRYPT_POLICY_V1)
+		min_keysize = ci->ci_mode->keysize;
+	else
+		min_keysize = ci->ci_mode->security_strength;
+
+	if (mk->mk_secret.size < min_keysize) {
+		fscrypt_warn(NULL,
+			     "key with %s %*phN is too short (got %u bytes, need %u+ bytes)",
+			     master_key_spec_type(&mk->mk_spec),
+			     master_key_spec_len(&mk->mk_spec),
+			     (u8 *)&mk->mk_spec.u,
+			     mk->mk_secret.size, min_keysize);
+		return false;
+	}
+	return true;
+}
+
 /*
  * Find the master key, then set up the inode's actual encryption key.
  *
@@ -422,18 +466,7 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 		goto out_release_key;
 	}
 
-	/*
-	 * Require that the master key be at least as long as the derived key.
-	 * Otherwise, the derived key cannot possibly contain as much entropy as
-	 * that required by the encryption mode it will be used for.  For v1
-	 * policies it's also required for the KDF to work at all.
-	 */
-	if (mk->mk_secret.size < ci->ci_mode->keysize) {
-		fscrypt_warn(NULL,
-			     "key with %s %*phN is too short (got %u bytes, need %u+ bytes)",
-			     master_key_spec_type(&mk_spec),
-			     master_key_spec_len(&mk_spec), (u8 *)&mk_spec.u,
-			     mk->mk_secret.size, ci->ci_mode->keysize);
+	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
-- 
2.32.0

