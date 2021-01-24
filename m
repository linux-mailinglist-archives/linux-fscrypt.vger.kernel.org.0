Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52B2301C88
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbhAXOJu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:09:50 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:30599 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbhAXOJp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497207;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=k1tLiObOjMEBJYxYaAtS89sk3jS8kmjetw4TumO6KRc=;
        b=CO1RVKl2h0mcXyyHXPwXd5VbmC2RsEj3GV9jRefhb1oc01hltof62V6BhcOZ+MnpfI
        zUlSEmlBe/6Nz/2+4h4AhNt3HbvGfdcSfczV7gONbrkwCbE8qOB9sZ8w3bqznwn92b1P
        PG3b16PjaxSGMldJdV5QaF0lxTsfuifKScfJk1ZT0zelSY163+B0R52rNh2sKT6deJvA
        3qw+danMLlo/DJIQjVYJKSM1Kts5xcI/zYuqFNpE4uHaK4SyGDdo6arq/L1Q3M6SlKEC
        jw8pXE6p4Q25gb7ISJgZ3W3ahIqkGNaAOA87BsP13saNQw3AhYcJL6vqLzHaTOq9HEAK
        w1Yw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6keia
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:46 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 2/7] crypto: add SP800-108 counter key derivation function
Date:   Sun, 24 Jan 2021 15:02:07 +0100
Message-ID: <3091021.aeNJFYEL58@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SP800-108 defines three KDFs - this patch provides the counter KDF
implementation.

The KDF is implemented as a service function where the caller has to
maintain the hash / HMAC state. Apart from this hash/HMAC state, no
additional state is required to be maintained by either the caller or
the KDF implementation.

The key for the KDF is set with the crypto_kdf108_setkey function which
is intended to be invoked before the caller requests a key derivation
operation via crypto_kdf108_ctr_generate.

SP800-108 allows the use of either a HMAC or a hash as crypto primitive
for the KDF. When a HMAC primtive is intended to be used,
crypto_kdf108_setkey must be used to set the HMAC key. Otherwise, for a
hash crypto primitve crypto_kdf108_ctr_generate can be used immediately
after allocating the hash handle.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig                |   7 ++
 crypto/Makefile               |   5 ++
 crypto/kdf_sp800108.c         | 149 ++++++++++++++++++++++++++++++++++
 include/crypto/kdf_sp800108.h |  61 ++++++++++++++
 4 files changed, 222 insertions(+)
 create mode 100644 crypto/kdf_sp800108.c
 create mode 100644 include/crypto/kdf_sp800108.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a367fcfeb5d4..9f375c2350f5 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1862,6 +1862,13 @@ config CRYPTO_JITTERENTROPY
 	  random numbers. This Jitterentropy RNG registers with
 	  the kernel crypto API and can be used by any caller.
 
+config CRYPTO_KDF800108_CTR
+	tristate "Counter KDF (SP800-108)"
+	select CRYPTO_HASH
+	help
+	  Enable the key derivation function in counter mode compliant to
+	  SP800-108.
+
 config CRYPTO_USER_API
 	tristate
 
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..46845a70850d 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -197,3 +197,8 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += asymmetric_keys/
 obj-$(CONFIG_CRYPTO_HASH_INFO) += hash_info.o
 crypto_simd-y := simd.o
 obj-$(CONFIG_CRYPTO_SIMD) += crypto_simd.o
+
+#
+# Key derivation function
+#
+obj-$(CONFIG_CRYPTO_KDF800108_CTR) += kdf_sp800108.o
diff --git a/crypto/kdf_sp800108.c b/crypto/kdf_sp800108.c
new file mode 100644
index 000000000000..84b45e0cadf5
--- /dev/null
+++ b/crypto/kdf_sp800108.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * SP800-108 Key-derivation function
+ *
+ * Copyright (C) 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <linux/module.h>
+#include <crypto/kdf_sp800108.h>
+#include <crypto/internal/kdf_selftest.h>
+
+/*
+ * SP800-108 CTR KDF implementation
+ */
+int crypto_kdf108_ctr_generate(struct crypto_shash *kmd,
+			       const struct kvec *info, unsigned int info_nvec,
+			       u8 *dst, unsigned int dlen)
+{
+	SHASH_DESC_ON_STACK(desc, kmd);
+	__be32 counter = cpu_to_be32(1);
+	const unsigned int h = crypto_shash_digestsize(kmd), dlen_orig = dlen;
+	unsigned int i;
+	int err = 0;
+	u8 *dst_orig = dst;
+
+	desc->tfm = kmd;
+
+	while (dlen) {
+		err = crypto_shash_init(desc);
+		if (err)
+			goto out;
+
+		err = crypto_shash_update(desc, (u8 *)&counter, sizeof(__be32));
+		if (err)
+			goto out;
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
+			err = crypto_shash_final(desc, tmpbuffer);
+			if (err)
+				goto out;
+			memcpy(dst, tmpbuffer, dlen);
+			memzero_explicit(tmpbuffer, h);
+			goto out;
+		}
+
+		err = crypto_shash_final(desc, dst);
+		if (err)
+			goto out;
+
+		dlen -= h;
+		dst += h;
+		counter = cpu_to_be32(be32_to_cpu(counter) + 1);
+	}
+
+out:
+	if (err)
+		memzero_explicit(dst_orig, dlen_orig);
+	shash_desc_zero(desc);
+	return err;
+}
+EXPORT_SYMBOL(crypto_kdf108_ctr_generate);
+
+/*
+ * The seeding of the KDF
+ */
+int crypto_kdf108_setkey(struct crypto_shash *kmd,
+			 const u8 *key, size_t keylen,
+			 const u8 *ikm, size_t ikmlen)
+{
+	unsigned int ds = crypto_shash_digestsize(kmd);
+
+	/* SP800-108 does not support IKM */
+	if (ikm || ikmlen)
+		return -EINVAL;
+
+	/* Check according to SP800-108 section 7.2 */
+	if (ds > keylen)
+		return -EINVAL;
+
+	/*
+	 * We require that we operate on a MAC -- if we do not operate on a
+	 * MAC, this function returns an error.
+	 */
+	return crypto_shash_setkey(kmd, key, keylen);
+}
+EXPORT_SYMBOL(crypto_kdf108_setkey);
+
+/*
+ * Test vector obtained from
+ * http://csrc.nist.gov/groups/STM/cavp/documents/KBKDF800-108/CounterMode.zip
+ */
+static const struct kdf_testvec kdf_ctr_hmac_sha256_tv_template[] = {
+	{
+		.key = "\xdd\x1d\x91\xb7\xd9\x0b\x2b\xd3"
+		       "\x13\x85\x33\xce\x92\xb2\x72\xfb"
+		       "\xf8\xa3\x69\x31\x6a\xef\xe2\x42"
+		       "\xe6\x59\xcc\x0a\xe2\x38\xaf\xe0",
+		.keylen = 32,
+		.ikm = NULL,
+		.ikmlen = 0,
+		.info = {
+			.iov_base = "\x01\x32\x2b\x96\xb3\x0a\xcd\x19"
+				    "\x79\x79\x44\x4e\x46\x8e\x1c\x5c"
+				    "\x68\x59\xbf\x1b\x1c\xf9\x51\xb7"
+				    "\xe7\x25\x30\x3e\x23\x7e\x46\xb8"
+				    "\x64\xa1\x45\xfa\xb2\x5e\x51\x7b"
+				    "\x08\xf8\x68\x3d\x03\x15\xbb\x29"
+				    "\x11\xd8\x0a\x0e\x8a\xba\x17\xf3"
+				    "\xb4\x13\xfa\xac",
+			.iov_len  = 60
+		},
+		.expected	  = "\x10\x62\x13\x42\xbf\xb0\xfd\x40"
+				    "\x04\x6c\x0e\x29\xf2\xcf\xdb\xf0",
+		.expectedlen	  = 16
+	}
+};
+
+static int __init crypto_kdf108_init(void)
+{
+	int ret = kdf_test(&kdf_ctr_hmac_sha256_tv_template[0], "hmac(sha256)",
+			   crypto_kdf108_setkey, crypto_kdf108_ctr_generate);
+
+	if (ret)
+		pr_warn("alg: self-tests for CTR-KDF (hmac(sha256)) failed (rc=%d)\n",
+			ret);
+	else
+		pr_info("alg: self-tests for CTR-KDF (hmac(sha256)) passed\n");
+
+	return ret;
+}
+
+static void __exit crypto_kdf108_exit(void) { }
+
+module_init(crypto_kdf108_init);
+module_exit(crypto_kdf108_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Key Derivation Function conformant to SP800-108");
diff --git a/include/crypto/kdf_sp800108.h b/include/crypto/kdf_sp800108.h
new file mode 100644
index 000000000000..fdc360bd9cd6
--- /dev/null
+++ b/include/crypto/kdf_sp800108.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _CRYPTO_KDF108_H
+#define _CRYPTO_KDF108_H
+
+#include <crypto/hash.h>
+#include <linux/uio.h>
+
+/**
+ * Counter KDF generate operation according to SP800-108 section 5.1
+ * as well as SP800-56A section 5.8.1 (Single-step KDF).
+ *
+ * @kmd Keyed message digest whose key was set with crypto_kdf108_setkey or
+ *	unkeyed message digest
+ * @info optional context and application specific information - this may be
+ *	 NULL
+ * @info_vec number of optional context/application specific information entries
+ * @dst destination buffer that the caller already allocated
+ * @dlen length of the destination buffer - the KDF derives that amount of
+ *	 bytes.
+ *
+ * To comply with SP800-108, the caller must provide Label || 0x00 || Context
+ * in the info parameter.
+ *
+ * @return 0 on success, < 0 on error
+ */
+int crypto_kdf108_ctr_generate(struct crypto_shash *kmd,
+			       const struct kvec *info, unsigned int info_nvec,
+			       u8 *dst, unsigned int dlen);
+
+/**
+ * Counter KDF setkey operation
+ *
+ * @kmd Keyed message digest allocated by the caller. The key should not have
+ *	been set.
+ * @key Seed key to be used to initialize the keyed message digest context.
+ * @keylen This length of the key buffer.
+ * @ikm The SP800-108 KDF does not support IKM - this parameter must be NULL
+ * @ikmlen This parameter must be 0.
+ *
+ * According to SP800-108 section 7.2, the seed key must be at least as large as
+ * the message digest size of the used keyed message digest. This limitation
+ * is enforced by the implementation.
+ *
+ * SP800-108 allows the use of either a HMAC or a hash primitive. When
+ * the caller intends to use a hash primitive, the call to
+ * crypto_kdf108_setkey is not required and the key derivation operation can
+ * immediately performed using crypto_kdf108_ctr_generate after allocating
+ * a handle.
+ *
+ * @return 0 on success, < 0 on error
+ */
+int crypto_kdf108_setkey(struct crypto_shash *kmd,
+			 const u8 *key, size_t keylen,
+			 const u8 *ikm, size_t ikmlen);
+
+#endif /* _CRYPTO_KDF108_H */
-- 
2.26.2




