Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67FE5FCE7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGDSaq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47036 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDSaq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so2882619wru.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1IaO7Z2keIlr8JRlm4hOULHLN6+6fSKqJMz4h8ttQSo=;
        b=e7e0/ID86+GPm76y79JHFa/n80pDhUb+6hDj9YLdVdw2Q7Qzkch0LElEuUIsYd/Uw6
         LeoRqZON4nu1eRNl+WIozF/duSMkSYLoFR3wKxlODiP3EuPH0uDZWj8zC3YOJN2Ga53m
         Iv4nRM2LeNlc0TDi4x6AetVu+2AIVW0mJ4ulNIPohSUP7PCqCbSzvDBS0LrWgq1mNWVv
         QrG18dfFPdS3WD7swM+vQ08pz8w1ixQp1TFPoWoPqtHfLqYaeOiqTa+gsuiwCfrz447y
         FEFHdFHzyvVRGC0oauX2FnpPvJKYQ07dqco4IKxH0ZPM51k4w+O7P/v9HSkVtOiUnhtK
         i90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1IaO7Z2keIlr8JRlm4hOULHLN6+6fSKqJMz4h8ttQSo=;
        b=TW89ajICSuWeKFKf7CERIjPpdvZmF+GFf7m4djDizuQYDv2L8KbIB1CuE1YNMBzJFd
         oj27SfkzAbWgKXhHEFiam3vljSkVkGKBxSu8mnsg0TKdmOYmiw/iipkneDnazJaBNkFX
         OlaNl2Bcj5V84xY6WcUeHpCp2lLmNNbGbi01iC7iN8vK/oW53318txgWeIwFxff//QmB
         2ctVhYseKpDSo8Dt1yNuasfjKM9iQ+7PpkG2j29rx+CBOFoe3WZBzrDxJIeOkk+N5Xgu
         5JCCuEWJY2pFKkIU8kJVUc79t99/40tKQ+JrvME4JR7kWrUKXd/GSTMEpcnWs+sFEwIB
         9DYQ==
X-Gm-Message-State: APjAAAX5b12R+QO9C1vtpqeBYpoDbP4e7PFobOvNiLV9O0yr6kNUzoq2
        FQ/nkJ+u0di816ZjYYzW05vAiQ==
X-Google-Smtp-Source: APXvYqxkDllW6tLxlvtYUSH9Wm5hSdatb+iLlLXiQxhhxrfy6eAiG2h2Q+yGWwgXO0R56avPppKwMw==
X-Received: by 2002:a5d:42c5:: with SMTP id t5mr10824wrr.5.1562265043825;
        Thu, 04 Jul 2019 11:30:43 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:43 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 2/7] fs: crypto: invoke crypto API for ESSIV handling
Date:   Thu,  4 Jul 2019 20:30:12 +0200
Message-Id: <20190704183017.31570-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of open coding the calculations for ESSIV handling, use a
ESSIV skcipher which does all of this under the hood.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/crypto/Kconfig           |  1 +
 fs/crypto/crypto.c          |  5 --
 fs/crypto/fscrypt_private.h |  9 --
 fs/crypto/keyinfo.c         | 93 +-------------------
 4 files changed, 4 insertions(+), 104 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index f0de238000c0..848c064e8370 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -4,6 +4,7 @@ config FS_ENCRYPTION
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
+	select CRYPTO_ESSIV
 	select CRYPTO_XTS
 	select CRYPTO_CTS
 	select CRYPTO_SHA256
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 68e2ca4c4af6..6015c275590e 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -135,9 +135,6 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 
 	if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY)
 		memcpy(iv->nonce, ci->ci_nonce, FS_KEY_DERIVATION_NONCE_SIZE);
-
-	if (ci->ci_essiv_tfm != NULL)
-		crypto_cipher_encrypt_one(ci->ci_essiv_tfm, iv->raw, iv->raw);
 }
 
 int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
@@ -491,8 +488,6 @@ static void __exit fscrypt_exit(void)
 		destroy_workqueue(fscrypt_read_workqueue);
 	kmem_cache_destroy(fscrypt_ctx_cachep);
 	kmem_cache_destroy(fscrypt_info_cachep);
-
-	fscrypt_essiv_cleanup();
 }
 module_exit(fscrypt_exit);
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7da276159593..59d0cba9cfb9 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -61,12 +61,6 @@ struct fscrypt_info {
 	/* The actual crypto transform used for encryption and decryption */
 	struct crypto_skcipher *ci_ctfm;
 
-	/*
-	 * Cipher for ESSIV IV generation.  Only set for CBC contents
-	 * encryption, otherwise is NULL.
-	 */
-	struct crypto_cipher *ci_essiv_tfm;
-
 	/*
 	 * Encryption mode used for this inode.  It corresponds to either
 	 * ci_data_mode or ci_filename_mode, depending on the inode type.
@@ -166,9 +160,6 @@ struct fscrypt_mode {
 	int keysize;
 	int ivsize;
 	bool logged_impl_name;
-	bool needs_essiv;
 };
 
-extern void __exit fscrypt_essiv_cleanup(void);
-
 #endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index dcd91a3fbe49..109ec3e5e215 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -13,14 +13,10 @@
 #include <linux/hashtable.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
-#include <crypto/aes.h>
 #include <crypto/algapi.h>
-#include <crypto/sha.h>
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
-static struct crypto_shash *essiv_hash_tfm;
-
 /* Table of keys referenced by FS_POLICY_FLAG_DIRECT_KEY policies */
 static DEFINE_HASHTABLE(fscrypt_master_keys, 6); /* 6 bits = 64 buckets */
 static DEFINE_SPINLOCK(fscrypt_master_keys_lock);
@@ -144,10 +140,9 @@ static struct fscrypt_mode available_modes[] = {
 	},
 	[FS_ENCRYPTION_MODE_AES_128_CBC] = {
 		.friendly_name = "AES-128-CBC",
-		.cipher_str = "cbc(aes)",
+		.cipher_str = "essiv(cbc(aes),aes,sha256)",
 		.keysize = 16,
 		.ivsize = 16,
-		.needs_essiv = true,
 	},
 	[FS_ENCRYPTION_MODE_AES_128_CTS] = {
 		.friendly_name = "AES-128-CTS-CBC",
@@ -377,72 +372,6 @@ fscrypt_get_master_key(const struct fscrypt_info *ci, struct fscrypt_mode *mode,
 	return ERR_PTR(err);
 }
 
-static int derive_essiv_salt(const u8 *key, int keysize, u8 *salt)
-{
-	struct crypto_shash *tfm = READ_ONCE(essiv_hash_tfm);
-
-	/* init hash transform on demand */
-	if (unlikely(!tfm)) {
-		struct crypto_shash *prev_tfm;
-
-		tfm = crypto_alloc_shash("sha256", 0, 0);
-		if (IS_ERR(tfm)) {
-			fscrypt_warn(NULL,
-				     "error allocating SHA-256 transform: %ld",
-				     PTR_ERR(tfm));
-			return PTR_ERR(tfm);
-		}
-		prev_tfm = cmpxchg(&essiv_hash_tfm, NULL, tfm);
-		if (prev_tfm) {
-			crypto_free_shash(tfm);
-			tfm = prev_tfm;
-		}
-	}
-
-	{
-		SHASH_DESC_ON_STACK(desc, tfm);
-		desc->tfm = tfm;
-
-		return crypto_shash_digest(desc, key, keysize, salt);
-	}
-}
-
-static int init_essiv_generator(struct fscrypt_info *ci, const u8 *raw_key,
-				int keysize)
-{
-	int err;
-	struct crypto_cipher *essiv_tfm;
-	u8 salt[SHA256_DIGEST_SIZE];
-
-	essiv_tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(essiv_tfm))
-		return PTR_ERR(essiv_tfm);
-
-	ci->ci_essiv_tfm = essiv_tfm;
-
-	err = derive_essiv_salt(raw_key, keysize, salt);
-	if (err)
-		goto out;
-
-	/*
-	 * Using SHA256 to derive the salt/key will result in AES-256 being
-	 * used for IV generation. File contents encryption will still use the
-	 * configured keysize (AES-128) nevertheless.
-	 */
-	err = crypto_cipher_setkey(essiv_tfm, salt, sizeof(salt));
-	if (err)
-		goto out;
-
-out:
-	memzero_explicit(salt, sizeof(salt));
-	return err;
-}
-
-void __exit fscrypt_essiv_cleanup(void)
-{
-	crypto_free_shash(essiv_hash_tfm);
-}
-
 /*
  * Given the encryption mode and key (normally the derived key, but for
  * FS_POLICY_FLAG_DIRECT_KEY mode it's the master key), set up the inode's
@@ -454,7 +383,6 @@ static int setup_crypto_transform(struct fscrypt_info *ci,
 {
 	struct fscrypt_master_key *mk;
 	struct crypto_skcipher *ctfm;
-	int err;
 
 	if (ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY) {
 		mk = fscrypt_get_master_key(ci, mode, raw_key, inode);
@@ -470,19 +398,6 @@ static int setup_crypto_transform(struct fscrypt_info *ci,
 	ci->ci_master_key = mk;
 	ci->ci_ctfm = ctfm;
 
-	if (mode->needs_essiv) {
-		/* ESSIV implies 16-byte IVs which implies !DIRECT_KEY */
-		WARN_ON(mode->ivsize != AES_BLOCK_SIZE);
-		WARN_ON(ci->ci_flags & FS_POLICY_FLAG_DIRECT_KEY);
-
-		err = init_essiv_generator(ci, raw_key, mode->keysize);
-		if (err) {
-			fscrypt_warn(inode->i_sb,
-				     "error initializing ESSIV generator for inode %lu: %d",
-				     inode->i_ino, err);
-			return err;
-		}
-	}
 	return 0;
 }
 
@@ -491,12 +406,10 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	if (!ci)
 		return;
 
-	if (ci->ci_master_key) {
+	if (ci->ci_master_key)
 		put_master_key(ci->ci_master_key);
-	} else {
+	else
 		crypto_free_skcipher(ci->ci_ctfm);
-		crypto_free_cipher(ci->ci_essiv_tfm);
-	}
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
-- 
2.17.1

