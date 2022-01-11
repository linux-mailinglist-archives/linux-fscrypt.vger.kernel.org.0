Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F2D48B519
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350187AbiAKSFF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:05:05 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4401 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349792AbiAKSEB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:04:01 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJPz0y9yz688jd;
        Wed, 12 Jan 2022 02:00:23 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:55 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 11/14] verification: introduce verify_pgp_signature()
Date:   Tue, 11 Jan 2022 19:03:15 +0100
Message-ID: <20220111180318.591029-12-roberto.sassu@huawei.com>
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

Introduce verify_pgp_signature() to verify PGP signatures from detached
data. It will be used by fsverity and by IMA.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 certs/system_keyring.c       | 70 ++++++++++++++++++++++++++++++++++++
 include/linux/verification.h | 23 ++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 692365dee2bd..26a11b1dcd59 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -16,6 +16,7 @@
 #include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
 #include <crypto/pkcs7.h>
+#include <crypto/pgp.h>
 #include "common.h"
 
 static struct key *builtin_trusted_keys;
@@ -289,6 +290,75 @@ int verify_pkcs7_signature(const void *data, size_t len,
 }
 EXPORT_SYMBOL_GPL(verify_pkcs7_signature);
 
+#ifdef CONFIG_PGP_KEY_PARSER
+/**
+ * verify_pgp_signature - Verify a PGP-based signature on system data.
+ * @data: The data to be verified (must be provided).
+ * @len: Size of @data.
+ * @raw_pgp: The PGP message that is the signature.
+ * @pgp_len: The size of @raw_pgp.
+ * @trusted_keys: Trusted keys to use (NULL for builtin trusted keys only,
+ *					(void *)1UL for all trusted keys).
+ * @usage: The use to which the key is being put.
+ * @view_content: Callback to gain access to content.
+ * @ctx: Context for callback.
+ */
+int verify_pgp_signature(const void *data, size_t len,
+			 const void *raw_pgp, size_t pgp_len,
+			 struct key *trusted_keys,
+			 enum key_being_used_for usage,
+			 int (*view_content)(void *ctx,
+					     const void *data, size_t len,
+					     size_t asn1hdrlen),
+			 void *ctx)
+{
+	struct pgp_sig_verify *pgp_ctx;
+	int ret;
+
+	if (!data || !len)
+		return -EINVAL;
+
+	pgp_ctx = pgp_sig_parse(raw_pgp, pgp_len);
+	if (IS_ERR(pgp_ctx))
+		return PTR_ERR(pgp_ctx);
+
+	if (!trusted_keys) {
+		trusted_keys = builtin_trusted_keys;
+	} else if (trusted_keys == VERIFY_USE_SECONDARY_KEYRING) {
+#ifdef CONFIG_SECONDARY_TRUSTED_KEYRING
+		trusted_keys = secondary_trusted_keys;
+#else
+		trusted_keys = builtin_trusted_keys;
+#endif
+	} else if (trusted_keys == VERIFY_USE_PLATFORM_KEYRING) {
+#ifdef CONFIG_INTEGRITY_PLATFORM_KEYRING
+		trusted_keys = platform_trusted_keys;
+#else
+		trusted_keys = NULL;
+#endif
+		if (!trusted_keys) {
+			ret = -ENOKEY;
+			pr_devel("PGP platform keyring is not available\n");
+			goto error;
+		}
+	}
+
+	/* The data should be detached - so we need to supply it. */
+	if (pgp_sig_add_data(pgp_ctx, data, len)) {
+		pr_err("Failed to supply data for PGP signature\n");
+		ret = -EBADMSG;
+		goto error;
+	}
+
+	ret = pgp_sig_verify(pgp_ctx, trusted_keys);
+error:
+	pgp_sig_verify_cancel(pgp_ctx, false);
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(verify_pgp_signature);
+
+#endif /* CONFIG_PGP_KEY_PARSER */
 #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
 
 #ifdef CONFIG_INTEGRITY_PLATFORM_KEYRING
diff --git a/include/linux/verification.h b/include/linux/verification.h
index a655923335ae..c27516d68962 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -54,6 +54,29 @@ extern int verify_pkcs7_message_sig(const void *data, size_t len,
 							size_t asn1hdrlen),
 				    void *ctx);
 
+#ifdef CONFIG_PGP_KEY_PARSER
+extern int verify_pgp_signature(const void *data, size_t len,
+				const void *raw_pgp, size_t pgp_len,
+				struct key *trusted_keys,
+				enum key_being_used_for usage,
+				int (*view_content)(void *ctx,
+						const void *data, size_t len,
+						size_t asn1hdrlen),
+				void *ctx);
+#else
+static inline int verify_pgp_signature(const void *data, size_t len,
+				const void *raw_pgp, size_t pgp_len,
+				struct key *trusted_keys,
+				enum key_being_used_for usage,
+				int (*view_content)(void *ctx,
+						const void *data, size_t len,
+						size_t asn1hdrlen),
+				void *ctx)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_PGP_KEY_PARSER */
+
 #ifdef CONFIG_SIGNED_PE_FILE_VERIFICATION
 extern int verify_pefile_signature(const void *pebuf, unsigned pelen,
 				   struct key *trusted_keys,
-- 
2.32.0

