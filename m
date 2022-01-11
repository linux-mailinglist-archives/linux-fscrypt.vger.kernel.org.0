Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5E748B4EC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350140AbiAKSEH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:07 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4398 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345554AbiAKSD6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:58 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJQs1ypdz6842D;
        Wed, 12 Jan 2022 02:01:09 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:54 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 10/14] KEYS: Calculate key digest and get signature of the key
Date:   Tue, 11 Jan 2022 19:03:14 +0100
Message-ID: <20220111180318.591029-11-roberto.sassu@huawei.com>
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

Calculate the digest of the signature, according to the RFC4880 section
5.2.4, get the last suitable signature with type 0x13 (Positive
certification of a User ID and Public Key packet), and store it in the
asym_auth field of the key payload, so that it is available for validating
a restriction on a keyring.

The rationale of taking the last signature is that, if there are multiple
signatures, that would be of a different issuer (not a self-signature),
that likely has more chances to be useful for the restriction verification.
If there is one (the self-signature), that will be used.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/pgp_public_key.c | 81 +++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/crypto/asymmetric_keys/pgp_public_key.c b/crypto/asymmetric_keys/pgp_public_key.c
index 378ed5ff0a3a..cecd67bab4e6 100644
--- a/crypto/asymmetric_keys/pgp_public_key.c
+++ b/crypto/asymmetric_keys/pgp_public_key.c
@@ -14,6 +14,7 @@
 #include <keys/asymmetric-parser.h>
 #include <crypto/hash.h>
 #include <crypto/public_key.h>
+#include <crypto/pgp.h>
 
 #include "pgp_parser.h"
 
@@ -61,6 +62,8 @@ struct pgp_key_data_parse_context {
 	size_t raw_fingerprint_len;
 	const char *user_id;
 	size_t user_id_len;
+	const char *key_pkt;
+	size_t key_pkt_len;
 };
 
 /*
@@ -226,6 +229,12 @@ static int pgp_process_public_key(struct pgp_parse_context *context,
 		return -EBADMSG;
 	}
 
+	/* Pointer refers to data being processed. */
+	if (type == PGP_PKT_PUBLIC_KEY) {
+		ctx->key_pkt = data;
+		ctx->key_pkt_len = datalen;
+	}
+
 	pub = kzalloc(sizeof(struct public_key), GFP_KERNEL);
 	if (!pub)
 		return -ENOMEM;
@@ -314,6 +323,77 @@ static struct asymmetric_key_ids *pgp_key_generate_id(
 	return NULL;
 }
 
+/*
+ * Calculate the digest of the signature according to the RFC4880, section
+ * 5.2.4 (packet type 0x13).
+ */
+static int pgp_key_add_sig_data(struct pgp_key_data_parse_context *ctx,
+				struct pgp_sig_verify *sig_ctx)
+{
+	loff_t offset = 0;
+	u8 *data;
+
+	if (!ctx->key_pkt_len || !ctx->user_id_len)
+		return 0;
+
+	/* 0x99 + key pkt len + key pkt + 0xb4 + user ID len + user ID */
+	data = kmalloc(1 + sizeof(u16) + ctx->key_pkt_len +
+		       1 + sizeof(u32) + ctx->user_id_len, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data[offset++] = 0x99;
+	data[offset++] = ctx->key_pkt_len >> 8;
+	data[offset++] = ctx->key_pkt_len;
+
+	memcpy(data + offset, ctx->key_pkt, ctx->key_pkt_len);
+	offset += ctx->key_pkt_len;
+
+	if (pgp_sig_get_version(sig_ctx) == PGP_SIG_VERSION_4) {
+		data[offset++] = 0xb4;
+		data[offset++] = ctx->user_id_len >> 24;
+		data[offset++] = ctx->user_id_len >> 16;
+		data[offset++] = ctx->user_id_len >> 8;
+		data[offset++] = ctx->user_id_len;
+	}
+
+	memcpy(data + offset, ctx->user_id, ctx->user_id_len);
+	offset += ctx->user_id_len;
+
+	pgp_sig_add_data(sig_ctx, data, offset);
+	kfree(data);
+	return 0;
+}
+
+static struct public_key_signature *pgp_key_get_sig(
+					struct key_preparsed_payload *prep,
+					struct pgp_key_data_parse_context *ctx)
+{
+	struct public_key_signature *sig = NULL;
+	struct pgp_sig_verify *sig_ctx;
+	bool keep_sig = false;
+	int ret;
+
+	sig_ctx = pgp_sig_parse(prep->data, prep->datalen);
+	if (IS_ERR(sig_ctx))
+		return NULL;
+
+	ret = pgp_key_add_sig_data(ctx, sig_ctx);
+	if (ret < 0)
+		goto out;
+
+	sig = pgp_sig_get_sig(sig_ctx);
+	if (IS_ERR(sig)) {
+		sig = NULL;
+		goto out;
+	}
+
+	keep_sig = true;
+out:
+	pgp_sig_verify_cancel(sig_ctx, keep_sig);
+	return sig;
+}
+
 /*
  * Attempt to parse the instantiation data blob for a key as a PGP packet
  * message holding a key.
@@ -372,6 +452,7 @@ static int pgp_key_parse(struct key_preparsed_payload *prep)
 	prep->payload.data[asym_subtype] = &public_key_subtype;
 	prep->payload.data[asym_key_ids] = pgp_key_generate_id(&ctx);
 	prep->payload.data[asym_crypto] = ctx.pub;
+	prep->payload.data[asym_auth] = pgp_key_get_sig(prep, &ctx);
 	prep->quotalen = 100;
 	return 0;
 
-- 
2.32.0

