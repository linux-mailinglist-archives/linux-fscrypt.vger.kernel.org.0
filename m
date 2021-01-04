Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518582E9FC4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 23:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbhADWBn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 17:01:43 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:10396 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbhADWBm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 17:01:42 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2021 17:01:41 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609797530;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=7m2tAgjw0olQMR4EnqbiK2mYFghGtcPIs/ldbj9WMRc=;
        b=d9YH46k9T6BirSVAC6K/AIN3qp1OQ34JnWE/vumaQ5Pgp9eAW6RFxVn9lzXaVDCDrA
        +24H6BAR3s+FThuihmdMQ8ej0NhlQMTfK+aWiL6H26FCFBpubSAEVRYtx10ZcwPWfX8k
        NPmxejudRjNV4/AcPnRKihmYF3ijCXOTGaHbkuhIu8e6zbX4rWVSNfrb7cvo+Asb10qQ
        b4hEQNwbCDXsnRkwAjHr+W1cxXNutAowz87wmlBDiTk00UVt4TmsL0bgRDwNeO/uajKL
        Bm8nCT+RECs8uyhypJetFaetzlHgms2uu/LH7rmrD0Tv0CwTe+g6dTzYSwFEuTWdWbem
        4QEQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZFqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x04LqlxfN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 4 Jan 2021 22:52:47 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH 1/5] crypto: Add key derivation self-test support code
Date:   Mon, 04 Jan 2021 22:47:06 +0100
Message-ID: <2182726.ElGaqSPkdT@positron.chronox.de>
In-Reply-To: <4616980.31r3eYUQgx@positron.chronox.de>
References: <4616980.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

As a preparation to add the key derivation implementations, the
self-test data structure definition and the common test code is made
available.

The test framework follows the testing applied by the NIST CAVP test
approach.

The structure of the test code follows the implementations found in
crypto/testmgr.c|h. In case the KDF implementations will be made
available via a kernel crypto API templates, the test code is intended
to be merged into testmgr.c|h.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/crypto/internal/kdf_selftest.h | 68 ++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 include/crypto/internal/kdf_selftest.h

diff --git a/include/crypto/internal/kdf_selftest.h b/include/crypto/internal/kdf_selftest.h
new file mode 100644
index 000000000000..c4f80d2cc61c
--- /dev/null
+++ b/include/crypto/internal/kdf_selftest.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _CRYPTO_KDF_SELFTEST_H
+#define _CRYPTO_KDF_SELFTEST_H
+
+#include <crypto/hash.h>
+#include <linux/uio.h>
+
+struct kdf_testvec {
+	struct kvec seed[2];
+	unsigned int seed_nvec;
+	struct kvec info;
+	unsigned char *expected;
+	size_t expectedlen;
+};
+
+static inline int
+kdf_test(const struct kdf_testvec *test, const char *name,
+	 int (*crypto_kdf_setkey)(struct crypto_shash *kmd,
+				  const struct kvec *seed,
+				  unsigned int seed_nvec),
+	 int (*crypto_kdf_generate)(struct crypto_shash *kmd,
+				    const struct kvec *info,
+				    unsigned int info_nvec,
+				    u8 *dst, unsigned int dlen))
+{
+	struct crypto_shash *kmd;
+	int ret;
+	u8 *buf = kzalloc(test->expectedlen, GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	kmd = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(kmd)) {
+		pr_err("alg: kdf: could not allocate cipher handle for %s\n",
+		       name);
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	ret = crypto_kdf_setkey(kmd, test->seed, test->seed_nvec);
+	if (ret) {
+		pr_err("alg: kdf: could not set key derivation key\n");
+		goto err;
+	}
+
+	ret = crypto_kdf_generate(kmd, &test->info, 1, buf, test->expectedlen);
+	if (ret) {
+		pr_err("alg: kdf: could not obtain key data\n");
+		goto err;
+	}
+
+	ret = memcmp(test->expected, buf, test->expectedlen);
+	if (ret)
+		ret = -EINVAL;
+
+err:
+	crypto_free_shash(kmd);
+	kfree(buf);
+	return ret;
+}
+
+#endif /* _CRYPTO_KDF_SELFTEST_H */
-- 
2.26.2




