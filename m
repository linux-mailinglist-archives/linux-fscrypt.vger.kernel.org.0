Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B890E301C82
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbhAXOJj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:09:39 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:15382 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbhAXOJh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497203;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=0ozQ7D0LjsLkwuUVvu/LMw1Ws2DU4G4yUwdnm8CemKw=;
        b=D01H358+uCmof8sgwdQ974EEM1p/c9sCRFeQQ5AJmaF8grT9avkq5RN4IafDRDRQV2
        hqDZIbasj8qJ3TRGnFHgecOmbA2PswE0Z181HryIE2+KKWGfPzUF8QIXvPRduwotNzlc
        +NBKT5w1lWoxFSAGaGlzdPKTRiGVOt0pf0POnkUvBMXcf9qfU0m9dI+pjpE8nolqjaVo
        Cee9cs3gB1BsaDTY/7J6rrPNow3/1MFJl+mvejBvKE5Mdc8ZBC3hlgGa2E2/JQ6E7dTG
        iFElDp0oVZqxCIpiW4sUnWe0GyGCG4SCQ+UJAhT5wlwUDQuCbqPfa0PcVGHpzb1OBIj+
        XDcA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6heiV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:43 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 6/7] fs: use HKDF implementation from kernel crypto API
Date:   Sun, 24 Jan 2021 15:04:31 +0100
Message-ID: <3577027.kQq0lBPeGt@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
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
 fs/crypto/Kconfig |  2 +-
 fs/crypto/hkdf.c  | 98 +++++++++--------------------------------------
 2 files changed, 20 insertions(+), 80 deletions(-)

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
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index e0ec21055505..ae236b42b1f0 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -9,7 +9,7 @@
  * Copyright 2019 Google LLC
  */
 
-#include <crypto/hash.h>
+#include <crypto/hkdf.h>
 #include <crypto/sha2.h>
 
 #include "fscrypt_private.h"
@@ -37,23 +37,7 @@
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
@@ -64,7 +48,6 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 		      unsigned int master_key_size)
 {
 	struct crypto_shash *hmac_tfm;
-	u8 prk[HKDF_HASHLEN];
 	int err;
 
 	hmac_tfm = crypto_alloc_shash(HKDF_HMAC_ALG, 0, 0);
@@ -74,16 +57,14 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
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
+	/* HKDF-Extract (RFC 5869 section 2.2), unsalted */
+	err = crypto_hkdf_extract(hmac_tfm, NULL, 0,
+				  master_key, master_key_size);
 	if (err)
 		goto err_free_tfm;
 
@@ -93,7 +74,6 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 err_free_tfm:
 	crypto_free_shash(hmac_tfm);
 out:
-	memzero_explicit(prk, sizeof(prk));
 	return err;
 }
 
@@ -112,62 +92,22 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
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
+		.iov_base = (u8 *)info,
+		.iov_len = infolen,
+	} };
+	int err = crypto_hkdf_expand(hkdf->hmac_tfm,
+				     info_iov, ARRAY_SIZE(info_iov),
+				     okm, okmlen);
 
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




