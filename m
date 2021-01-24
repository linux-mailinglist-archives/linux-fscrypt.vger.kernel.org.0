Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D528301C85
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbhAXOJn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:09:43 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:36640 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbhAXOJj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497204;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=UJu2Jvh1nCXdU612niCLGD96cRpQm9KprkqF1VzUH4c=;
        b=O1sp8nZFfVBbVwsoxCyo8shb0N04546U1JvOFdq78GhTVjlJpJd70yDmqTGcCei/EI
        LcbKe8UlARGjcR/OfPKBaXPpO+L+iclQzzYEGx6WLoeX40vEX1g83wBscMfQdwO+cpsE
        TI/YQIptsLWnlFtiAJyPzIG2oW5wXPNgoZraidhx2O8sW8CZvk6RBORZXehiM2zy0uAK
        KUUdiTPnV1wBO97PP5331e2E9dBbQDLzd40mVTrLplOo5lXNiRBP2jz96u00lYT+ZMOb
        IV2d3z3p/y2Zd74sor9H3u77xsIDTUhgYD8JOYGd5L9JwJIo0expXcz7vDHA+kC+DJuL
        ni/Q==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6heiW
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
Subject: [PATCH v2 5/7] security: DH - use KDF implementation from crypto API
Date:   Sun, 24 Jan 2021 15:04:11 +0100
Message-ID: <20932396.EfDdHjke4D@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The kernel crypto API provides the SP800-108 counter KDF implementation.
Thus, the separate implementation provided as part of the keys subsystem
can be replaced with calls to the KDF offered by the kernel crypto API.

The keys subsystem uses the counter KDF with a hash primitive. Thus,
it only uses the call to crypto_kdf108_ctr_generate.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 security/keys/Kconfig |  2 +-
 security/keys/dh.c    | 97 +++++++------------------------------------
 2 files changed, 15 insertions(+), 84 deletions(-)

diff --git a/security/keys/Kconfig b/security/keys/Kconfig
index 83bc23409164..e6604499f0a8 100644
--- a/security/keys/Kconfig
+++ b/security/keys/Kconfig
@@ -106,7 +106,7 @@ config KEY_DH_OPERATIONS
        bool "Diffie-Hellman operations on retained keys"
        depends on KEYS
        select CRYPTO
-       select CRYPTO_HASH
+       select CRYPTO_KDF800108_CTR
        select CRYPTO_DH
        help
 	 This option provides support for calculating Diffie-Hellman
diff --git a/security/keys/dh.c b/security/keys/dh.c
index 56e12dae4534..46fa442b81ec 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -11,6 +11,7 @@
 #include <crypto/hash.h>
 #include <crypto/kpp.h>
 #include <crypto/dh.h>
+#include <crypto/kdf_sp800108.h>
 #include <keys/user-type.h>
 #include "internal.h"
 
@@ -79,16 +80,9 @@ static void dh_crypto_done(struct crypto_async_request *req, int err)
 	complete(&compl->completion);
 }
 
-struct kdf_sdesc {
-	struct shash_desc shash;
-	char ctx[];
-};
-
-static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
+static int kdf_alloc(struct crypto_shash **hash, char *hashname)
 {
 	struct crypto_shash *tfm;
-	struct kdf_sdesc *sdesc;
-	int size;
 	int err;
 
 	/* allocate synchronous hash */
@@ -102,14 +96,7 @@ static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
 	if (crypto_shash_digestsize(tfm) == 0)
 		goto out_free_tfm;
 
-	err = -ENOMEM;
-	size = sizeof(struct shash_desc) + crypto_shash_descsize(tfm);
-	sdesc = kmalloc(size, GFP_KERNEL);
-	if (!sdesc)
-		goto out_free_tfm;
-	sdesc->shash.tfm = tfm;
-
-	*sdesc_ret = sdesc;
+	*hash = tfm;
 
 	return 0;
 
@@ -118,76 +105,20 @@ static int kdf_alloc(struct kdf_sdesc **sdesc_ret, char *hashname)
 	return err;
 }
 
-static void kdf_dealloc(struct kdf_sdesc *sdesc)
-{
-	if (!sdesc)
-		return;
-
-	if (sdesc->shash.tfm)
-		crypto_free_shash(sdesc->shash.tfm);
-
-	kfree_sensitive(sdesc);
-}
-
-/*
- * Implementation of the KDF in counter mode according to SP800-108 section 5.1
- * as well as SP800-56A section 5.8.1 (Single-step KDF).
- *
- * SP800-56A:
- * The src pointer is defined as Z || other info where Z is the shared secret
- * from DH and other info is an arbitrary string (see SP800-56A section
- * 5.8.1.2).
- *
- * 'dlen' must be a multiple of the digest size.
- */
-static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
-		   u8 *dst, unsigned int dlen)
+static void kdf_dealloc(struct crypto_shash *hash)
 {
-	struct shash_desc *desc = &sdesc->shash;
-	unsigned int h = crypto_shash_digestsize(desc->tfm);
-	int err = 0;
-	u8 *dst_orig = dst;
-	__be32 counter = cpu_to_be32(1);
-
-	while (dlen) {
-		err = crypto_shash_init(desc);
-		if (err)
-			goto err;
-
-		err = crypto_shash_update(desc, (u8 *)&counter, sizeof(__be32));
-		if (err)
-			goto err;
-
-		if (src && slen) {
-			err = crypto_shash_update(desc, src, slen);
-			if (err)
-				goto err;
-		}
-
-		err = crypto_shash_final(desc, dst);
-		if (err)
-			goto err;
-
-		dlen -= h;
-		dst += h;
-		counter = cpu_to_be32(be32_to_cpu(counter) + 1);
-	}
-
-	return 0;
-
-err:
-	memzero_explicit(dst_orig, dlen);
-	return err;
+	if (hash)
+		crypto_free_shash(hash);
 }
 
-static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
+static int keyctl_dh_compute_kdf(struct crypto_shash *hash,
 				 char __user *buffer, size_t buflen,
 				 uint8_t *kbuf, size_t kbuflen)
 {
+	struct kvec kbuf_iov = { .iov_base = kbuf, .iov_len = kbuflen };
 	uint8_t *outbuf = NULL;
 	int ret;
-	size_t outbuf_len = roundup(buflen,
-				    crypto_shash_digestsize(sdesc->shash.tfm));
+	size_t outbuf_len = roundup(buflen, crypto_shash_digestsize(hash));
 
 	outbuf = kmalloc(outbuf_len, GFP_KERNEL);
 	if (!outbuf) {
@@ -195,7 +126,7 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 		goto err;
 	}
 
-	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len);
+	ret = crypto_kdf108_ctr_generate(hash, &kbuf_iov, 1, outbuf, outbuf_len);
 	if (ret)
 		goto err;
 
@@ -224,7 +155,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	struct kpp_request *req;
 	uint8_t *secret;
 	uint8_t *outbuf;
-	struct kdf_sdesc *sdesc = NULL;
+	struct crypto_shash *hash = NULL;
 
 	if (!params || (!buffer && buflen)) {
 		ret = -EINVAL;
@@ -257,7 +188,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 		}
 
 		/* allocate KDF from the kernel crypto API */
-		ret = kdf_alloc(&sdesc, hashname);
+		ret = kdf_alloc(&hash, hashname);
 		kfree(hashname);
 		if (ret)
 			goto out1;
@@ -367,7 +298,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 			goto out6;
 		}
 
-		ret = keyctl_dh_compute_kdf(sdesc, buffer, buflen, outbuf,
+		ret = keyctl_dh_compute_kdf(hash, buffer, buflen, outbuf,
 					    req->dst_len + kdfcopy->otherinfolen);
 	} else if (copy_to_user(buffer, outbuf, req->dst_len) == 0) {
 		ret = req->dst_len;
@@ -386,7 +317,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 out2:
 	dh_free_data(&dh_inputs);
 out1:
-	kdf_dealloc(sdesc);
+	kdf_dealloc(hash);
 	return ret;
 }
 
-- 
2.26.2




