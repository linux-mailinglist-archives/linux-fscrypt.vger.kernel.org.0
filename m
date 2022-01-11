Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3848B4FC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbiAKSEX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:23 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4399 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345640AbiAKSEA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:04:00 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJQv55hlz67x8s;
        Wed, 12 Jan 2022 02:01:11 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:57 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 13/14] KEYS: Provide a function to load keys from a PGP keyring blob
Date:   Tue, 11 Jan 2022 19:03:17 +0100
Message-ID: <20220111180318.591029-14-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220111180318.591029-1-roberto.sassu@huawei.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Provide a function to load keys from a PGP keyring blob to the built-in
keyring:

	int preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
			     struct key *keyring);

Descriptions are generated from user ID notes and key fingerprints.  The
keys will actually be identified by the ID calculated from the PGP data
rather than by the description, so this shouldn't be a problem.

The keys are attached to the keyring supplied.

Looking as root in /proc/keys after the built-in keyring has been loaded:

383a00c1 I------     1 perm 1f030000     0     0 asymmetri \
				Red Hat, Inc. dbeca166: PGP.DSA dbeca166 []

Thanks to Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> for some
pointing out some errors.

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/Kconfig       |   8 ++
 crypto/asymmetric_keys/Makefile      |   1 +
 crypto/asymmetric_keys/pgp_preload.c | 110 +++++++++++++++++++++++++++
 include/crypto/pgp.h                 |   8 +-
 4 files changed, 126 insertions(+), 1 deletion(-)
 create mode 100644 crypto/asymmetric_keys/pgp_preload.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 5f328f57dd0b..79a95bf8919a 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -126,4 +126,12 @@ config PGP_TEST_KEY
 
 	  This is intended for testing the PGP parser.
 
+config PGP_PRELOAD
+	bool "PGP public key preloading facility"
+	depends on SYSTEM_TRUSTED_KEYRING
+	select PGP_KEY_PARSER
+	help
+	  This option provides a facility for the kernel to preload PGP-wrapped
+	  bundles of keys during boot to the built-in keyring.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 99240d11f591..daaed990376f 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -91,6 +91,7 @@ $(obj)/tpm.asn1.o: $(obj)/tpm.asn1.c $(obj)/tpm.asn1.h
 # PGP handling
 #
 obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
+obj-$(CONFIG_PGP_PRELOAD) += pgp_preload.o
 
 obj-$(CONFIG_PGP_KEY_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
diff --git a/crypto/asymmetric_keys/pgp_preload.c b/crypto/asymmetric_keys/pgp_preload.c
new file mode 100644
index 000000000000..0eb9ba0db3df
--- /dev/null
+++ b/crypto/asymmetric_keys/pgp_preload.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Asymmetric key request handling
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include <linux/module.h>
+#include <linux/key.h>
+#include <linux/err.h>
+#include <keys/asymmetric-type.h>
+
+#include "pgp_parser.h"
+
+struct preload_pgp_keys_context {
+	struct pgp_parse_context pgp;
+	key_ref_t keyring;
+	const u8 *key_start;
+	const u8 *key_end;
+	bool found_key;
+};
+
+/*
+ * Create a key.
+ */
+static void __init create_pgp_key(struct preload_pgp_keys_context *ctx)
+{
+	key_ref_t key;
+
+	key = key_create_or_update(ctx->keyring,
+				   "asymmetric",
+				   NULL,
+				   ctx->key_start,
+				   ctx->key_end - ctx->key_start,
+				   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+				    KEY_USR_VIEW | KEY_USR_READ),
+				   KEY_ALLOC_NOT_IN_QUOTA |
+				   KEY_ALLOC_BUILT_IN |
+				   KEY_ALLOC_BYPASS_RESTRICTION);
+	if (IS_ERR(key)) {
+		pr_notice("Ignoring PGP key, error: %ld\n", PTR_ERR(key));
+		return;
+	}
+
+	pr_notice("Loaded PGP key '%s'\n",
+		  key_ref_to_ptr(key)->description);
+
+	key_ref_put(key);
+}
+
+/*
+ * Extract a public key or subkey from the PGP stream.
+ */
+static int __init found_pgp_key(struct pgp_parse_context *context,
+				enum pgp_packet_tag type, u8 headerlen,
+				const u8 *data, size_t datalen)
+{
+	struct preload_pgp_keys_context *ctx =
+		container_of(context, struct preload_pgp_keys_context, pgp);
+
+	if (ctx->found_key) {
+		ctx->key_end = data - headerlen;
+		create_pgp_key(ctx);
+	}
+
+	ctx->key_start = data - headerlen;
+	ctx->found_key = true;
+	return 0;
+}
+
+/**
+ * preload_pgp_keys - Load keys from a PGP keyring blob
+ * @pgpdata: The PGP keyring blob containing the keys.
+ * @pgpdatalen: The size of the @pgpdata blob.
+ * @keyring: The keyring to add the new keys to.
+ *
+ * Preload a pack of keys from a PGP keyring blob.
+ *
+ * The keys have their descriptions generated from the user ID and fingerprint
+ * in the PGP stream.  Since keys can be matched on their key IDs independently
+ * of the key description, the description is mostly irrelevant apart from the
+ * fact that keys of the same description displace one another from a keyring.
+ *
+ * The caller should override the current creds if they want the keys to be
+ * owned by someone other than the current process's owner.  Keys will not be
+ * accounted towards the owner's quota.
+ *
+ * This function may only be called whilst the kernel is booting.
+ */
+int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+			    struct key *keyring)
+{
+	struct preload_pgp_keys_context ctx;
+	int ret;
+
+	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY);
+	ctx.pgp.process_packet = found_pgp_key;
+	ctx.keyring = make_key_ref(keyring, 1);
+	ctx.found_key = false;
+
+	ret = pgp_parse_packets(pgpdata, pgpdatalen, &ctx.pgp);
+	if (ret < 0)
+		return ret;
+
+	if (ctx.found_key) {
+		ctx.key_end = pgpdata + pgpdatalen;
+		create_pgp_key(&ctx);
+	}
+	return 0;
+}
diff --git a/include/crypto/pgp.h b/include/crypto/pgp.h
index a58453843dc8..fcb1c4c38a9d 100644
--- a/include/crypto/pgp.h
+++ b/include/crypto/pgp.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
-/* PGP signature processing
+/* PGP key and signature processing
  *
  * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
@@ -26,4 +26,10 @@ extern void pgp_sig_verify_cancel(struct pgp_sig_verify *ctx, bool keep_sig);
 extern struct public_key_signature *pgp_sig_get_sig(struct pgp_sig_verify *ctx);
 extern u8 pgp_sig_get_version(struct pgp_sig_verify *ctx);
 
+/*
+ * pgp_preload.c
+ */
+extern int __init preload_pgp_keys(const u8 *pgpdata, size_t pgpdatalen,
+				   struct key *keyring);
+
 #endif /* _CRYPTO_PGP_H */
-- 
2.32.0

