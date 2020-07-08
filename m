Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CC22192F4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2020 23:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725915AbgGHV6E (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jul 2020 17:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGHV6D (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jul 2020 17:58:03 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB54120775
        for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jul 2020 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594245483;
        bh=ezXyVl0+KpppPhg7J73o47H4mBFJaOiPfJGiXX7gcLk=;
        h=From:To:Subject:Date:From;
        b=bxj3G1kV3Au9FDQN7PagY7vFkkKozX/YVtMM5bYeHbVWhJIlNhddjz9r0tHmACfDZ
         gD9/cvPb1nDTc+Qk9C5QK6Tux7jmnQmYZ8yWrvcFjzQZo2EYoBDhhyMKTqe8cmPTdL
         VUyPtmF32xf4I2qWNxRTPaPa8dfiWDkoiiCBr2Go=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: rename FS_KEY_DERIVATION_NONCE_SIZE
Date:   Wed,  8 Jul 2020 14:57:22 -0700
Message-Id: <20200708215722.147154-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The name "FS_KEY_DERIVATION_NONCE_SIZE" is a bit outdated since due to
the addition of FSCRYPT_POLICY_FLAG_DIRECT_KEY, the file nonce may now
be used as a tweak instead of for key derivation.  Also, we're now
prefixing the fscrypt constants with "FSCRYPT_" instead of "FS_".

Therefore, rename this constant to FSCRYPT_FILE_NONCE_SIZE.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst |  6 +++---
 fs/crypto/crypto.c                    |  2 +-
 fs/crypto/fscrypt_private.h           | 12 ++++++------
 fs/crypto/keysetup.c                  |  7 +++----
 fs/crypto/keysetup_v1.c               |  4 ++--
 fs/crypto/policy.c                    |  2 +-
 6 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index f5d8b0303ddf..1a6ad6f736b5 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1158,7 +1158,7 @@ setxattr() because of the special semantics of the encryption xattr.
 were to be added to or removed from anything other than an empty
 directory.)  These structs are defined as follows::
 
-    #define FS_KEY_DERIVATION_NONCE_SIZE 16
+    #define FSCRYPT_FILE_NONCE_SIZE 16
 
     #define FSCRYPT_KEY_DESCRIPTOR_SIZE  8
     struct fscrypt_context_v1 {
@@ -1167,7 +1167,7 @@ directory.)  These structs are defined as follows::
             u8 filenames_encryption_mode;
             u8 flags;
             u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
-            u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+            u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
     };
 
     #define FSCRYPT_KEY_IDENTIFIER_SIZE  16
@@ -1178,7 +1178,7 @@ directory.)  These structs are defined as follows::
             u8 flags;
             u8 __reserved[4];
             u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
-            u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+            u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
     };
 
 The context structs contain the same information as the corresponding
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index a52cf32733ab..9212325763b0 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -84,7 +84,7 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		lblk_num = (u32)(ci->ci_hashed_ino + lblk_num);
 	} else if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
-		memcpy(iv->nonce, ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE);
+		memcpy(iv->nonce, ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
 	}
 	iv->lblk_num = cpu_to_le64(lblk_num);
 }
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 0f154bdbc14b..bc1a3fcd45ed 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -18,9 +18,9 @@
 
 #define CONST_STRLEN(str)	(sizeof(str) - 1)
 
-#define FS_KEY_DERIVATION_NONCE_SIZE	16
+#define FSCRYPT_FILE_NONCE_SIZE	16
 
-#define FSCRYPT_MIN_KEY_SIZE		16
+#define FSCRYPT_MIN_KEY_SIZE	16
 
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
@@ -31,7 +31,7 @@ struct fscrypt_context_v1 {
 	u8 filenames_encryption_mode;
 	u8 flags;
 	u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
-	u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
 struct fscrypt_context_v2 {
@@ -41,7 +41,7 @@ struct fscrypt_context_v2 {
 	u8 flags;
 	u8 __reserved[4];
 	u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
-	u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
 /*
@@ -244,7 +244,7 @@ struct fscrypt_info {
 	union fscrypt_policy ci_policy;
 
 	/* This inode's nonce, copied from the fscrypt_context */
-	u8 ci_nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
 
 	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
 	u32 ci_hashed_ino;
@@ -280,7 +280,7 @@ union fscrypt_iv {
 		__le64 lblk_num;
 
 		/* per-file nonce; only set in DIRECT_KEY mode */
-		u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE];
+		u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
 	};
 	u8 raw[FSCRYPT_MAX_IV_SIZE];
 	__le64 dun[FSCRYPT_MAX_IV_SIZE / sizeof(__le64)];
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 99d3e0d07fc6..22a94b18fe70 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -211,7 +211,7 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
 	int err;
 
 	err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf, HKDF_CONTEXT_DIRHASH_KEY,
-				  ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE,
+				  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 				  (u8 *)&ci->ci_dirhash_key,
 				  sizeof(ci->ci_dirhash_key));
 	if (err)
@@ -292,8 +292,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 
 		err = fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
 					  HKDF_CONTEXT_PER_FILE_ENC_KEY,
-					  ci->ci_nonce,
-					  FS_KEY_DERIVATION_NONCE_SIZE,
+					  ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 					  derived_key, ci->ci_mode->keysize);
 		if (err)
 			return err;
@@ -498,7 +497,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 	}
 
 	memcpy(crypt_info->ci_nonce, fscrypt_context_nonce(&ctx),
-	       FS_KEY_DERIVATION_NONCE_SIZE);
+	       FSCRYPT_FILE_NONCE_SIZE);
 
 	if (!fscrypt_supported_policy(&crypt_info->ci_policy, inode)) {
 		res = -EINVAL;
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index a52686729a67..e4e707fb1100 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -45,7 +45,7 @@ static DEFINE_SPINLOCK(fscrypt_direct_keys_lock);
  * key is longer, then only the first 'derived_keysize' bytes are used.
  */
 static int derive_key_aes(const u8 *master_key,
-			  const u8 nonce[FS_KEY_DERIVATION_NONCE_SIZE],
+			  const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
 			  u8 *derived_key, unsigned int derived_keysize)
 {
 	int res = 0;
@@ -68,7 +68,7 @@ static int derive_key_aes(const u8 *master_key,
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 			crypto_req_done, &wait);
-	res = crypto_skcipher_setkey(tfm, nonce, FS_KEY_DERIVATION_NONCE_SIZE);
+	res = crypto_skcipher_setkey(tfm, nonce, FSCRYPT_FILE_NONCE_SIZE);
 	if (res < 0)
 		goto out;
 
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index d23ff162c78b..8a8ad0e44bb8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -529,7 +529,7 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg)
 	if (!fscrypt_context_is_valid(&ctx, ret))
 		return -EINVAL;
 	if (copy_to_user(arg, fscrypt_context_nonce(&ctx),
-			 FS_KEY_DERIVATION_NONCE_SIZE))
+			 FSCRYPT_FILE_NONCE_SIZE))
 		return -EFAULT;
 	return 0;
 }
-- 
2.27.0

