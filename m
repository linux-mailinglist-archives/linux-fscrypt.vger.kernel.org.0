Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0B48B51C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbiAKSFI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:05:08 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4400 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345691AbiAKSEB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:04:01 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJPz6dnDz688Cb;
        Wed, 12 Jan 2022 02:00:23 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:56 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 12/14] PGP: Provide a key type for testing PGP signatures
Date:   Tue, 11 Jan 2022 19:03:16 +0100
Message-ID: <20220111180318.591029-13-roberto.sassu@huawei.com>
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

Provide a key type for testing the PGP signature parser.  It is given a
non-detached PGP message as payload:

	keyctl padd pgp_test a @s <content.txt.gpg

A suitable message can be generated like this:

	echo "This is a test attached-signed content" >content.txt
	gpg --compress-algo=none -s content.txt

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/Kconfig        |  13 +++
 crypto/asymmetric_keys/Makefile       |   2 +
 crypto/asymmetric_keys/pgp_library.c  |  64 +++++++++++++
 crypto/asymmetric_keys/pgp_test_key.c | 129 ++++++++++++++++++++++++++
 crypto/asymmetric_keys/pgplib.h       |  16 ++++
 5 files changed, 224 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pgp_test_key.c

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 7be60ef07ac0..5f328f57dd0b 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -113,4 +113,17 @@ config PGP_KEY_PARSER
 	  for key data and provides the ability to instantiate a crypto key
 	  from a public key packet found inside the blob.
 
+config PGP_TEST_KEY
+	tristate "PGP testing key type"
+	depends on SYSTEM_DATA_VERIFICATION
+	depends on PGP_KEY_PARSER=y
+	help
+	  This option provides a type of key that can be loaded up from a
+	  PGP message - provided the message is signed by a trusted key.  If
+	  it is, the PGP wrapper is discarded and reading the key returns
+	  just the payload.  If it isn't, adding the key will fail with an
+	  error.
+
+	  This is intended for testing the PGP parser.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index e2aeb2a4b6a6..99240d11f591 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -96,3 +96,5 @@ obj-$(CONFIG_PGP_KEY_PARSER) += pgp_key_parser.o
 pgp_key_parser-y := \
 	pgp_public_key.o \
 	pgp_signature.o
+
+obj-$(CONFIG_PGP_TEST_KEY) += pgp_test_key.o
diff --git a/crypto/asymmetric_keys/pgp_library.c b/crypto/asymmetric_keys/pgp_library.c
index de4a748db9be..5e5d75e99194 100644
--- a/crypto/asymmetric_keys/pgp_library.c
+++ b/crypto/asymmetric_keys/pgp_library.c
@@ -554,3 +554,67 @@ int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pgp_parse_sig_params);
+
+#if IS_ENABLED(CONFIG_PGP_TEST_KEY)
+
+/**
+ * pgp_parse_literal_data - Parse basic params from a PGP literal data packet
+ * @data: Content of packet
+ * @datalen: Length of packet remaining
+ * @p: The basic parameters
+ *
+ * Parse the basic parameters from a PGP literal data packet [RFC 4880: 5.9]
+ * that are needed to work out what form the data is in and where it is.
+ *
+ * Returns 0 if successful or a negative error code.
+ */
+int pgp_parse_literal_data(const u8 *data, size_t datalen,
+			   struct pgp_literal_data_parameters *p)
+{
+	unsigned int tmp;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 6)
+		goto too_short;
+	datalen -= 6;
+
+	p->format = *data++;
+	switch (p->format) {
+	case PGP_LIT_FORMAT_BINARY:
+	case PGP_LIT_FORMAT_TEXT:
+	case PGP_LIT_FORMAT_TEXT_UTF8:
+		break;
+	default:
+		pr_debug("Literal data packet with unhandled format %02x\n",
+			 p->format);
+		return -EBADMSG;
+	}
+
+	p->filename_len = *data++;
+	p->filename_offset = 2;
+	if (datalen < p->filename_len)
+		goto too_short;
+	data += p->filename_len;
+	datalen -= p->filename_len;
+
+	tmp  = *data++ << 24;
+	tmp |= *data++ << 16;
+	tmp |= *data++ << 8;
+	tmp |= *data++;
+	p->time = tmp;
+
+	p->content_offset = 6 + p->filename_len;
+	p->content_len = datalen;
+
+	pr_devel("%x,%u,%x,%u\n",
+		 p->format, p->filename_len, p->time, p->content_len);
+	return 0;
+
+too_short:
+	pr_debug("Literal data packet too short\n");
+	return -EBADMSG;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_literal_data);
+
+#endif /* CONFIG_PGP_TEST_KEY */
diff --git a/crypto/asymmetric_keys/pgp_test_key.c b/crypto/asymmetric_keys/pgp_test_key.c
new file mode 100644
index 000000000000..e067dedf6ca0
--- /dev/null
+++ b/crypto/asymmetric_keys/pgp_test_key.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Testing module to load key from trusted PGP message
+ *
+ * Copyright (C) 2014 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) "PGPtest: "fmt
+#include <linux/key.h>
+#include <linux/key-type.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/verification.h>
+#include <keys/user-type.h>
+#include <keys/system_keyring.h>
+#include <crypto/pgp.h>
+
+#include "pgp_parser.h"
+
+MODULE_LICENSE("GPL");
+
+struct pgp_test_parse_context {
+	struct pgp_parse_context pgp;
+	struct pgp_literal_data_parameters params;
+	const void *content;
+};
+
+static int pgp_test_parse_data(struct pgp_parse_context *context,
+			       enum pgp_packet_tag type,
+			       u8 headerlen,
+			       const u8 *data,
+			       size_t datalen)
+{
+	struct pgp_test_parse_context *ctx =
+		container_of(context, struct pgp_test_parse_context, pgp);
+	int ret;
+
+	kenter("");
+
+	ret = pgp_parse_literal_data(data, datalen, &ctx->params);
+	if (ret == 0)
+		ctx->content = data + ctx->params.content_offset;
+	return ret;
+}
+
+/*
+ * Instantiate a PGP wrapped and validated key.
+ */
+static int pgp_test_instantiate(struct key *key,
+				struct key_preparsed_payload *prep)
+{
+	struct pgp_test_parse_context p;
+	const void *saved_prep_data;
+	size_t saved_prep_datalen;
+	const struct cred *cred = current_cred();
+	int ret;
+
+	kenter("");
+
+	memset(&p, 0, sizeof(p));
+	p.pgp.types_of_interest = (1 << PGP_PKT_LITERAL_DATA);
+	p.pgp.process_packet = pgp_test_parse_data;
+	ret = pgp_parse_packets(prep->data, prep->datalen, &p.pgp);
+	if (ret < 0) {
+		kleave(" = %d [parse]", ret);
+		return ret;
+	}
+
+	if (!p.params.content_len) {
+		kleave(" = -ENODATA [no literal data");
+		return -ENODATA;
+	}
+
+	ret = verify_pgp_signature(p.content, p.params.content_len,
+				   prep->data, prep->datalen, NULL,
+				   VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
+	if (ret < 0 && cred->session_keyring) {
+		ret = verify_pgp_signature(p.content, p.params.content_len,
+					   prep->data, prep->datalen,
+					   cred->session_keyring,
+					   VERIFYING_UNSPECIFIED_SIGNATURE,
+					   NULL, NULL);
+		if (ret < 0)
+			goto error;
+
+		pr_warn("PGP message doesn't chain back to a trusted key\n");
+	}
+
+	saved_prep_data = prep->data;
+	saved_prep_datalen = prep->datalen;
+	prep->data = p.content;
+	prep->datalen = p.params.content_len;
+	ret = generic_key_instantiate(key, prep);
+	prep->data = saved_prep_data;
+	prep->datalen = saved_prep_datalen;
+error:
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
+ * user defined keys take an arbitrary string as the description and an
+ * arbitrary blob of data as the payload
+ */
+static struct key_type key_type_pgp_test = {
+	.name			= "pgp_test",
+	.instantiate		= pgp_test_instantiate,
+	.revoke			= user_revoke,
+	.destroy		= user_destroy,
+	.describe		= user_describe,
+	.read			= user_read,
+};
+
+/*
+ * Module stuff
+ */
+static int __init pgp_key_init(void)
+{
+	return register_key_type(&key_type_pgp_test);
+}
+
+static void __exit pgp_key_cleanup(void)
+{
+	unregister_key_type(&key_type_pgp_test);
+}
+
+module_init(pgp_key_init);
+module_exit(pgp_key_cleanup);
diff --git a/crypto/asymmetric_keys/pgplib.h b/crypto/asymmetric_keys/pgplib.h
index 967e2853186d..0dc3cd142469 100644
--- a/crypto/asymmetric_keys/pgplib.h
+++ b/crypto/asymmetric_keys/pgplib.h
@@ -56,3 +56,19 @@ struct pgp_sig_parameters {
 
 extern int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
 				struct pgp_sig_parameters *p);
+
+#if IS_ENABLED(CONFIG_PGP_TEST_KEY)
+
+struct pgp_literal_data_parameters {
+	enum pgp_literal_data_format format : 8;
+	u8 filename_len;
+	u8 filename_offset;
+	u8 content_offset;
+	u32 content_len;
+	u32 time;
+};
+
+extern int pgp_parse_literal_data(const u8 *data, size_t datalen,
+				  struct pgp_literal_data_parameters *p);
+
+#endif /* CONFIG_PGP_TEST_KEY */
-- 
2.32.0

