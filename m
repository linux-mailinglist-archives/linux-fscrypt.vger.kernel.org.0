Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406572E9FB4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 22:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhADV6r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 16:58:47 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:11820 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbhADV6r (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 16:58:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609797354;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=6fGapvYj1KUbHyiUaqLugayVcLwc8fLHw2DuUxRIf1I=;
        b=Bz5ljw7tQ+MN6HibseZZb72afaYxc2bkLJFnUODmNBM8A/0ySGucRLIqURbKfbEBQe
        /lDmjpo4SEiHYcfRgMhMFO4D53kzTWF7oX/kj1Be9r4phrf8nrtrAhnhpzNaiWjv1nYo
        QsdN8Kh+pr/CPzruW574v9UcdAxXU1U6vsenoMwCqMTi18sD4wa/2SX5TWgXt6PcSGaG
        ZkCJ8ymBg20QwlYcB1p//d1hNI6RSRNLrsw/WzCGItW0wAy4cdsxDyFLuoDU3+V1TR0m
        qbxVBlnXYpQq4SYVM4ZyewbL6TLbAsQPUVinvoZmo+t2bB6M9872K/XwB+2wDpBqX/lH
        Ymdw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZFqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x04LqhxfJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 4 Jan 2021 22:52:43 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH 5/5] fs: use HKDF implementation from kernel crypto API
Date:   Mon, 04 Jan 2021 22:50:49 +0100
Message-ID: <7857050.T7Z3S40VBb@positron.chronox.de>
In-Reply-To: <4616980.31r3eYUQgx@positron.chronox.de>
References: <4616980.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

As the kernel crypto API implements HKDF, replace the
file-system-specific HKDF implementation with the generic HKDF
implementation.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 fs/crypto/Kconfig           |   2 +-
 fs/crypto/fscrypt_private.h |   4 +-
 fs/crypto/hkdf.c            | 108 +++++++++---------------------------
 3 files changed, 30 insertions(+), 84 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index a5f5c30368a2..9450e958f1d1 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -2,7 +2,7 @@
 config FS_ENCRYPTION
 	bool "FS Encryption (Per-file encryption)"
 	select CRYPTO
-	select CRYPTO_HASH
+	select CRYPTO_HKDF
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_SHA256
 	select KEYS
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 3fa965eb3336..0d6871838099 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -304,7 +304,7 @@ struct fscrypt_hkdf {
 	struct crypto_shash *hmac_tfm;
 };
 
-int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
+int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
 		      unsigned int master_key_size);
 
 /*
@@ -323,7 +323,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
-			const u8 *info, unsigned int infolen,
+			u8 *info, unsigned int infolen,
 			u8 *okm, unsigned int okmlen);
 
 void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index e0ec21055505..f837cb8ec0a5 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -9,7 +9,7 @@
  * Copyright 2019 Google LLC
  */
 
-#include <crypto/hash.h>
+#include <crypto/hkdf.h>
 #include <crypto/sha2.h>
 
 #include "fscrypt_private.h"
@@ -37,34 +37,25 @@
  * unnecessarily long master keys.  Thus fscrypt still does HKDF-Extract.  No
  * salt is used, since fscrypt master keys should already be pseudorandom and
  * there's no way to persist a random salt per master key from kernel mode.
- */
-
-/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
-static int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
-			unsigned int ikmlen, u8 prk[HKDF_HASHLEN])
-{
-	static const u8 default_salt[HKDF_HASHLEN];
-	int err;
-
-	err = crypto_shash_setkey(hmac_tfm, default_salt, HKDF_HASHLEN);
-	if (err)
-		return err;
-
-	return crypto_shash_tfm_digest(hmac_tfm, ikm, ikmlen, prk);
-}
-
-/*
+ *
  * Compute HKDF-Extract using the given master key as the input keying material,
  * and prepare an HMAC transform object keyed by the resulting pseudorandom key.
  *
  * Afterwards, the keyed HMAC transform object can be used for HKDF-Expand many
  * times without having to recompute HKDF-Extract each time.
  */
-int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
+int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, u8 *master_key,
 		      unsigned int master_key_size)
 {
+	/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
+	const struct kvec seed[] = { {
+		.iov_base = NULL,
+		.iov_len = 0
+	}, {
+		.iov_base = master_key,
+		.iov_len = master_key_size
+	} };
 	struct crypto_shash *hmac_tfm;
-	u8 prk[HKDF_HASHLEN];
 	int err;
 
 	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
@@ -74,16 +65,12 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 		return PTR_ERR(hmac_tfm);
 	}
 
-	if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != sizeof(prk))) {
+	if (WARN_ON(crypto_shash_digestsize(hmac_tfm) != HKDF_HASHLEN)) {
 		err = -EINVAL;
 		goto err_free_tfm;
 	}
 
-	err = hkdf_extract(hmac_tfm, master_key, master_key_size, prk);
-	if (err)
-		goto err_free_tfm;
-
-	err = crypto_shash_setkey(hmac_tfm, prk, sizeof(prk));
+	err = crypto_hkdf_setkey(hmac_tfm, seed, ARRAY_SIZE(seed));
 	if (err)
 		goto err_free_tfm;
 
@@ -93,7 +80,6 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 err_free_tfm:
 	crypto_free_shash(hmac_tfm);
 out:
-	memzero_explicit(prk, sizeof(prk));
 	return err;
 }
 
@@ -109,65 +95,25 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
  * accidentally repeat an info string when using HKDF for different purposes.)
  */
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
-			const u8 *info, unsigned int infolen,
+			u8 *info, unsigned int infolen,
 			u8 *okm, unsigned int okmlen)
 {
-	SHASH_DESC_ON_STACK(desc, hkdf->hmac_tfm);
-	u8 prefix[9];
-	unsigned int i;
-	int err;
-	const u8 *prev = NULL;
-	u8 counter = 1;
-	u8 tmp[HKDF_HASHLEN];
-
-	if (WARN_ON(okmlen > 255 * HKDF_HASHLEN))
-		return -EINVAL;
-
-	desc->tfm = hkdf->hmac_tfm;
-
-	memcpy(prefix, "fscrypt\0", 8);
-	prefix[8] = context;
-
-	for (i = 0; i < okmlen; i += HKDF_HASHLEN) {
+	const struct kvec info_iov[] = { {
+		.iov_base = "fscrypt\0",
+		.iov_len = 8,
+	}, {
+		.iov_base = &context,
+		.iov_len = 1,
+	}, {
+		.iov_base = info,
+		.iov_len = infolen,
+	} };
+	int err = crypto_hkdf_generate(hkdf->hmac_tfm,
+				       info_iov, ARRAY_SIZE(info_iov),
+				       okm, okmlen);
 
-		err = crypto_shash_init(desc);
-		if (err)
-			goto out;
-
-		if (prev) {
-			err = crypto_shash_update(desc, prev, HKDF_HASHLEN);
-			if (err)
-				goto out;
-		}
-
-		err = crypto_shash_update(desc, prefix, sizeof(prefix));
-		if (err)
-			goto out;
-
-		err = crypto_shash_update(desc, info, infolen);
-		if (err)
-			goto out;
-
-		BUILD_BUG_ON(sizeof(counter) != 1);
-		if (okmlen - i < HKDF_HASHLEN) {
-			err = crypto_shash_finup(desc, &counter, 1, tmp);
-			if (err)
-				goto out;
-			memcpy(&okm[i], tmp, okmlen - i);
-			memzero_explicit(tmp, sizeof(tmp));
-		} else {
-			err = crypto_shash_finup(desc, &counter, 1, &okm[i]);
-			if (err)
-				goto out;
-		}
-		counter++;
-		prev = &okm[i];
-	}
-	err = 0;
-out:
 	if (unlikely(err))
 		memzero_explicit(okm, okmlen); /* so caller doesn't need to */
-	shash_desc_zero(desc);
 	return err;
 }
 
-- 
2.26.2




