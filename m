Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F64B48B515
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiAKSFA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:05:00 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4395 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiAKSDz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:55 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJQp5x6Vz683S6;
        Wed, 12 Jan 2022 02:01:06 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:52 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 07/14] KEYS: Provide PGP key description autogeneration
Date:   Tue, 11 Jan 2022 19:03:11 +0100
Message-ID: <20220111180318.591029-8-roberto.sassu@huawei.com>
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

Provide a facility to autogenerate the name of PGP keys from the contents
of the payload.  If add_key() is given a blank description, a description
is constructed from the last user ID packet in the payload data plus the
last 8 hex digits of the key ID.  For instance:

	keyctl padd asymmetric "" @s </tmp/key.pub

might create a key with a constructed description that can be seen in
/proc/keys:

2f674b96 I--Q---     1 perm 39390000     0     0 crypto    \
			Sample kernel key 31f0ae93: PGP.RSA 31f0ae93 []

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/pgp_public_key.c | 47 ++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/pgp_public_key.c b/crypto/asymmetric_keys/pgp_public_key.c
index 2763a53ea378..378ed5ff0a3a 100644
--- a/crypto/asymmetric_keys/pgp_public_key.c
+++ b/crypto/asymmetric_keys/pgp_public_key.c
@@ -59,6 +59,8 @@ struct pgp_key_data_parse_context {
 	struct public_key *pub;
 	u8 raw_fingerprint[HASH_MAX_DIGESTSIZE];
 	size_t raw_fingerprint_len;
+	const char *user_id;
+	size_t user_id_len;
 };
 
 /*
@@ -210,6 +212,15 @@ static int pgp_process_public_key(struct pgp_parse_context *context,
 
 	kenter(",%u,%u,,%zu", type, headerlen, datalen);
 
+	if (type == PGP_PKT_USER_ID) {
+		if (!ctx->user_id_len) {
+			ctx->user_id = data;
+			ctx->user_id_len = datalen;
+		}
+		kleave(" = 0 [user ID]");
+		return 0;
+	}
+
 	if (ctx->raw_fingerprint_len) {
 		kleave(" = -ENOKEY [already]");
 		return -EBADMSG;
@@ -315,13 +326,47 @@ static int pgp_key_parse(struct key_preparsed_payload *prep)
 	kenter("");
 
 	memset(&ctx, 0, sizeof(ctx));
-	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY);
+	ctx.pgp.types_of_interest = (1 << PGP_PKT_PUBLIC_KEY) |
+				    (1 << PGP_PKT_USER_ID);
 	ctx.pgp.process_packet = pgp_process_public_key;
 
 	ret = pgp_parse_packets(prep->data, prep->datalen, &ctx.pgp);
 	if (ret < 0)
 		goto error;
 
+	if (ctx.user_id && ctx.user_id_len > 0) {
+		/*
+		 * Propose a description for the key (user ID without the
+		 * comment).
+		 */
+		size_t ulen = ctx.user_id_len;
+		const char *p;
+
+		p = memchr(ctx.user_id, '(', ulen);
+		if (p) {
+			/* Remove the comment */
+			do {
+				p--;
+			} while (*p == ' ' && p > ctx.user_id);
+			if (*p != ' ')
+				p++;
+			ulen = p - ctx.user_id;
+		}
+
+		if (ulen > 255 - 9)
+			ulen = 255 - 9;
+		prep->description = kmalloc(ulen + 1 + 8 + 1, GFP_KERNEL);
+		ret = -ENOMEM;
+		if (!prep->description)
+			goto error;
+		memcpy(prep->description, ctx.user_id, ulen);
+		prep->description[ulen] = ' ';
+		bin2hex(prep->description + ulen + 1,
+			ctx.raw_fingerprint + ctx.raw_fingerprint_len - 4, 4);
+		prep->description[ulen + 9] = 0;
+		pr_debug("desc '%s'\n", prep->description);
+	}
+
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
 	prep->payload.data[asym_subtype] = &public_key_subtype;
-- 
2.32.0

