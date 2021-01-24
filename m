Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49D8301C8C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbhAXOJt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:09:49 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:22338 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbhAXOJo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:09:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497207;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=zJqo8nf/jHkzH9Q6/0XyhbU/V8rrLtwyZJii/ef29vM=;
        b=f2kW1Jhbt9M63652XWycanaxWYdh3wcDidKQUFJSNi1UyHbsPjeMiSNjbAfnowzHha
        +fhaodTtBcVNeUZHNfRJTgSbQ7N8kbbz0jSDACP+NHerMxK+85jg+HRZ3S1ik5oSD7ak
        mZXJZccaExfz/VqQn0KA4rJ9nj6PpZg8XCkmAd/qvZ62kKvOC+meGwIv+bAlCqhMLD/I
        UjI4MtvjPB79+onr3Ix6/zkyqR2clmafCd90y4q81Ed/K4W76ImWob6ZXuiJ6Xr2cPvD
        aaoZrMPrfOjOZv0qfKoWgv0pOL7Bz8Ub31AGPOwtbnfjTXkfr2JqqmbF59l5PAdVTzLY
        CqyQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6leib
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:47 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 1/7] crypto: Add key derivation self-test support code
Date:   Sun, 24 Jan 2021 15:01:43 +0100
Message-ID: <12692814.uLZWGnKmhe@positron.chronox.de>
In-Reply-To: <1772794.tdWV9SEqCh@positron.chronox.de>
References: <1772794.tdWV9SEqCh@positron.chronox.de>
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
 include/crypto/internal/kdf_selftest.h | 71 ++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 include/crypto/internal/kdf_selftest.h

diff --git a/include/crypto/internal/kdf_selftest.h b/include/crypto/internal/kdf_selftest.h
new file mode 100644
index 000000000000..373fcb11f2fa
--- /dev/null
+++ b/include/crypto/internal/kdf_selftest.h
@@ -0,0 +1,71 @@
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
+	unsigned char *key;
+	size_t keylen;
+	unsigned char *ikm;
+	size_t ikmlen;
+	struct kvec info;
+	unsigned char *expected;
+	size_t expectedlen;
+};
+
+static inline int
+kdf_test(const struct kdf_testvec *test, const char *name,
+	 int (*crypto_kdf_setkey)(struct crypto_shash *kmd,
+				  const u8 *key, size_t keylen,
+				  const u8 *ikm, size_t ikmlen),
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
+		pr_err("alg: kdf: could not allocate hash handle for %s\n",
+		       name);
+		kfree(buf);
+		return -ENOMEM;
+	}
+
+	ret = crypto_kdf_setkey(kmd, test->key, test->keylen,
+				test->ikm, test->ikmlen);
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




