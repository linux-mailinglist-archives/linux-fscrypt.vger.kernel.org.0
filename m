Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8990F2E9FC9
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 23:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbhADWBx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 17:01:53 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:36447 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbhADWBx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 17:01:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609797538;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=qRsN114uQtDe/60EmQywot6dLP23wd8WMbXKa+qPjD4=;
        b=JrN0k5aElPGcy8UGd5o373srtIlKixnnVswmAEv9LB3L5Ybn/OjvIBKKAWLH1mXTYP
        i4QgUJC1GDwlQd22yTxm678i0uKvn6wZ+fp5tmCuxMV38DB58xE0pDmP/Qvfmzye+DEc
        TeIgorP4blfdoET8fu+KzAgVUfuZNhadCgSk9kxivdmFc7WsC7uAIM7mxypYgVVfVcU3
        rXXLlA69nT1ZAQZERa7pojFV40bPxC3mLhB9vPO3jx6MrvW06UaDTWat3AoGCltgV1pe
        t+O+JjBK/ypkA/J01Dq5cMHVxF134L3PKWOFfdejaujdutiPH1/NziVxEEM/xNR6CkFx
        3jrg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZFqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x04LqkxfL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 4 Jan 2021 22:52:46 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH 3/5] crypto: add RFC5869 HKDF
Date:   Mon, 04 Jan 2021 22:49:13 +0100
Message-ID: <12679948.uLZWGnKmhe@positron.chronox.de>
In-Reply-To: <4616980.31r3eYUQgx@positron.chronox.de>
References: <4616980.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

RFC5869 specifies an extract and expand two-step key derivation
function. The HKDF implementation is provided as a service function that
operates on a caller-provided HMAC cipher handle. The caller has to
allocate the HMAC cipher and then can invoke the HKDF service functions.
The HKDF implementation ensures that the entire state is kept with the
HMAC cipher handle which implies that no additional state is required to
be maintained by the HKDF implementation.

The extract function is invoked via the crypto_hkdf_setkey call. RFC5869
allows two optional parameters to be provided to the extract operation:
the salt and additional information. Both are to be provided with the
seed parameter where the salt is the first entry of the seed parameter
and all subsequent entries are handled as additional information. If
the caller intends to invoke the HKDF without salt, it has to provide a
NULL/0 entry as first entry in seed.

The expand function is invoked via the crypto_hkdf_generate and can be
invoked multiple times. This function allows the caller to provide a
context for the key derivation operation. As specified in RFC5869, it is
optional. In case such context is not provided, the caller must provide
NULL / 0 for the info / info_nvec parameters.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig        |   7 ++
 crypto/Makefile       |   1 +
 crypto/hkdf.c         | 226 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/hkdf.h |  48 +++++++++
 4 files changed, 282 insertions(+)
 create mode 100644 crypto/hkdf.c
 create mode 100644 include/crypto/hkdf.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9f375c2350f5..661287d7283b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1862,6 +1862,13 @@ config CRYPTO_JITTERENTROPY
 	  random numbers. This Jitterentropy RNG registers with
 	  the kernel crypto API and can be used by any caller.
 
+config CRYPTO_HKDF
+	tristate "Extract and Expand HKDF (RFC 5869)"
+	select CRYPTO_HASH
+	help
+	  Enable the extract and expand key derivation function compliant
+	  to RFC 5869.
+
 config CRYPTO_KDF800108_CTR
 	tristate "Counter KDF (SP800-108)"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 46845a70850d..55a4d8c31a45 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -201,4 +201,5 @@ obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
 #
 # Key derivation function
 #
+obj-$(CONFIG_CRYPTO_HKDF) += hkdf.o
 obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
diff --git a/crypto/hkdf.c b/crypto/hkdf.c
new file mode 100644
index 000000000000..a3bf6d6b07ea
--- /dev/null
+++ b/crypto/hkdf.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * HMAC-based Extract-and-Expand Key Derivation Function (conformant to RFC5869)
+ *
+ * Copyright (C) 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <linux/module.h>
+#include <crypto/hkdf.h>
+#include <crypto/internal/kdf_selftest.h>
+
+/*
+ * HKDF expand phase
+ */
+int crypto_hkdf_generate(struct crypto_shash *kmd,
+			 const struct kvec *info, unsigned int info_nvec,
+			 u8 *dst, unsigned int dlen)
+{
+	SHASH_DESC_ON_STACK(desc, kmd);
+	const unsigned int h = crypto_shash_digestsize(kmd);
+	unsigned int i;
+	int err = 0;
+	u8 *dst_orig = dst;
+	const u8 *prev = NULL;
+	u8 ctr = 0x01;
+
+	if (dlen > h * 255)
+		return -EINVAL;
+
+	desc->tfm = kmd;
+
+	/* T(1) and following */
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+
+		if (prev) {
+			err = crypto_shash_update(desc, prev, h);
+			if (err)
+				goto out;
+		}
+
+		for (i = 0; i < info_nvec; i++) {
+			err = crypto_shash_update(desc, info[i].iov_base,
+						  info[i].iov_len);
+			if (err)
+				goto out;
+		}
+
+		if (dlen < h) {
+			u8 tmpbuffer[HASH_MAX_DIGESTSIZE];
+
+			err = crypto_shash_finup(desc, &ctr, 1, tmpbuffer);
+			if (err)
+				goto out;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			goto out;
+		}
+
+		err = crypto_shash_finup(desc, &ctr, 1, dst);
+		if (err)
+			goto out;
+
+		prev = dst;
+		dst += h;
+		dlen -= h;
+		ctr++;
+	}
+
+out:
+	if (err)
+		memzero_explicit(dst_orig, dlen);
+	shash_desc_zero(desc);
+	return err;
+}
+EXPORT_SYMBOL(crypto_hkdf_generate);
+
+/*
+ * HKDF extract phase.
+ */
+int crypto_hkdf_setkey(struct crypto_shash *kmd,
+		       const struct kvec *seed, unsigned int seed_nvec)
+{
+	SHASH_DESC_ON_STACK(desc, kmd);
+	unsigned int h = crypto_shash_digestsize(kmd);
+	int err;
+	static const u8 null_salt[HASH_MAX_DIGESTSIZE] = { 0 };
+	u8 prk[HASH_MAX_DIGESTSIZE];
+
+	/* Require at least the salt information */
+	if (seed_nvec < 1)
+		return -EINVAL;
+
+	desc->tfm = kmd;
+
+	if (seed[0].iov_len) {
+		/* Set the salt as HMAC key */
+		err = crypto_shash_setkey(kmd,
+					  seed[0].iov_base, seed[0].iov_len);
+	} else {
+		/* Set the default HMAC key as none was provided */
+		err = crypto_shash_setkey(kmd, null_salt, h);
+	}
+
+	if (err)
+		return err;
+
+	/* Extract the PRK */
+	if (seed_nvec > 1) {
+		unsigned int i;
+
+		err = crypto_shash_init(desc);
+		if (err)
+			goto err;
+
+		for (i = 1; i < seed_nvec; i++) {
+			err = crypto_shash_update(desc, seed[i].iov_base,
+						  seed[i].iov_len);
+			if (err)
+				goto err;
+		}
+
+		err = crypto_shash_final(desc, prk);
+	} else {
+		err = crypto_shash_digest(desc, NULL, 0, prk);
+	}
+	if (err)
+		goto err;
+
+	/* Set the PRK for the expand phase */
+	err = crypto_shash_setkey(kmd, prk, h);
+
+err:
+	shash_desc_zero(desc);
+	memzero_explicit(prk, h);
+	return err;
+}
+EXPORT_SYMBOL(crypto_hkdf_setkey);
+
+/* Test vectors from RFC 5869 appendix A */
+static const struct kdf_testvec hkdf_hmac_sha256_tv_template[] = {
+	{
+		.seed = { {
+			/* salt */
+			.iov_base = "\x00\x01\x02\x03\x04\x05\x06\x07"
+				    "\x08\x09\x0a\x0b\x0c",
+			.iov_len  = 13,
+		}, {
+			/* IKM */
+			.iov_base = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+				    "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+				    "\x0b\x0b\x0b\x0b\x0b\x0b",
+			.iov_len  = 22,
+		} },
+		.seed_nvec	  = 2,
+		.info = {
+			.iov_base = "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+				    "\xf8\xf9",
+			.iov_len  = 10
+		},
+		.expected	  = "\x3c\xb2\x5f\x25\xfa\xac\xd5\x7a"
+				    "\x90\x43\x4f\x64\xd0\x36\x2f\x2a"
+				    "\x2d\x2d\x0a\x90\xcf\x1a\x5a\x4c"
+				    "\x5d\xb0\x2d\x56\xec\xc4\xc5\xbf"
+				    "\x34\x00\x72\x08\xd5\xb8\x87\x18"
+				    "\x58\x65",
+		.expectedlen	  = 42
+	}, {
+		.seed = { {
+			/* salt */
+			.iov_base = NULL,
+			.iov_len  = 0,
+		}, {
+			/* IKM */
+			.iov_base = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+				    "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+				    "\x0b\x0b\x0b\x0b\x0b\x0b",
+			.iov_len  = 22,
+		} },
+		.seed_nvec	  = 2,
+		.info = {
+			.iov_base = NULL,
+			.iov_len  = 0
+		},
+		.expected	  = "\x8d\xa4\xe7\x75\xa5\x63\xc1\x8f"
+				    "\x71\x5f\x80\x2a\x06\x3c\x5a\x31"
+				    "\xb8\xa1\x1f\x5c\x5e\xe1\x87\x9e"
+				    "\xc3\x45\x4e\x5f\x3c\x73\x8d\x2d"
+				    "\x9d\x20\x13\x95\xfa\xa4\xb6\x1a"
+				    "\x96\xc8",
+		.expectedlen	  = 42
+	}
+};
+
+static int __init crypto_hkdf_init(void)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(hkdf_hmac_sha256_tv_template); i++) {
+		ret = kdf_test(&hkdf_hmac_sha256_tv_template[i], "hmac(sha256)",
+			       crypto_hkdf_setkey, crypto_hkdf_generate);
+
+		if (ret) {
+			pr_warn("alg: self-tests for HKDF (hmac(sha256)) failed (rc=%d)\n",
+				ret);
+			return ret;
+		}
+	}
+
+	pr_info("alg: self-tests for HKDF (hmac(sha256)) passed\n");
+
+	return 0;
+}
+
+static void __exit crypto_hkdf_exit(void) { }
+
+module_init(crypto_hkdf_init);
+module_exit(crypto_hkdf_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("HKDF HMAC-based Extract-and-Expand Key Derivation Function  (conformant to RFC5869)");
diff --git a/include/crypto/hkdf.h b/include/crypto/hkdf.h
new file mode 100644
index 000000000000..4e4b5444a7a6
--- /dev/null
+++ b/include/crypto/hkdf.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _CRYPTO_HKDF_H
+#define _CRYPTO_HKDF_H
+
+#include <crypto/hash.h>
+#include <linux/uio.h>
+
+/**
+ * RFC 5869 HKDF expand operation
+ *
+ * @kmd Keyed message digest whose key was set with crypto_hkdf_setkey
+ * @info optional context and application specific information - this may be
+ *	 NULL
+ * @info_vec number of optional context/application specific information entries
+ * @dst destination buffer that the caller already allocated
+ * @dlen length of the destination buffer - the KDF derives that amount of
+ *	 bytes.
+ *
+ * @return 0 on success, < 0 on error
+ */
+int crypto_hkdf_generate(struct crypto_shash *kmd,
+			 const struct kvec *info, unsigned int info_nvec,
+			 u8 *dst, unsigned int dlen);
+
+/**
+ * RFC 5869 HKDF extract operation
+ *
+ * @kmd Keyed message digest allocated by the caller. The key should not have
+ *	been set.
+ * @seed Seed data to extract the HKDF state from - for HKDF, the seed is
+ *	 partitioned as follows:
+ *	 seed[0] is the salt - this kvec MUST be filled in. It is permissible
+ *	 to provide a NULL seed where .iov_base = NULL and .iov_len = 0.
+ *	 seed[>0] is the additional information data. It is permissible to
+ *	 provide zero or more kvec entries.
+ * @seed_nvec number of seed entries (must be at least 1)
+ *
+ * @return 0 on success, < 0 on error
+ */
+int crypto_hkdf_setkey(struct crypto_shash *kmd,
+		       const struct kvec *seed, unsigned int seed_nvec);
+
+#endif /* _CRYPTO_HKDF_H */
-- 
2.26.2




