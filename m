Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CBA48B53F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbiAKSGb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:06:31 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4393 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345458AbiAKSDy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:54 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJTw627tz681p5;
        Wed, 12 Jan 2022 02:03:48 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:50 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 05/14] PGPLIB: Signature parser
Date:   Tue, 11 Jan 2022 19:03:09 +0100
Message-ID: <20220111180318.591029-6-roberto.sassu@huawei.com>
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

Provide some PGP signature parsing helpers:

 (1) A function to parse V4 signature subpackets and pass the desired ones
     to a processor function:

	int pgp_parse_sig_subpkts(const u8 *data, size_t datalen,
				  struct pgp_parse_sig_context *ctx);

 (2) A function to parse out basic signature parameters from any PGP
     signature such that the algorithms and public key can be selected:

	int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
				 struct pgp_sig_parameters *p);

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/pgp_library.c | 284 +++++++++++++++++++++++++++
 crypto/asymmetric_keys/pgplib.h      |  25 +++
 2 files changed, 309 insertions(+)

diff --git a/crypto/asymmetric_keys/pgp_library.c b/crypto/asymmetric_keys/pgp_library.c
index d2c3149983d5..de4a748db9be 100644
--- a/crypto/asymmetric_keys/pgp_library.c
+++ b/crypto/asymmetric_keys/pgp_library.c
@@ -270,3 +270,287 @@ int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pgp_parse_public_key);
+
+/**
+ * pgp_parse_sig_subpkt_header - Parse a PGP V4 signature subpacket header
+ * @_data: Start of the subpacket (updated to subpacket data)
+ * @_datalen: Amount of data remaining in buffer (decreased)
+ * @_type: Where the subpacket type will be returned
+ *
+ * Parse a PGP V4 signature subpacket header [RFC 4880: 5.2.3.1].
+ *
+ * Return: packet data size on success; non-zero on error.  If successful,
+ * *_data and *_datalen will have been updated and *_headerlen will be set to
+ * hold the length of the packet header.
+ */
+static ssize_t pgp_parse_sig_subpkt_header(const u8 **_data, size_t *_datalen,
+					   enum pgp_sig_subpkt_type *_type)
+{
+	enum pgp_sig_subpkt_type type;
+	const u8 *data = *_data;
+	size_t size, datalen = *_datalen;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 2)
+		goto short_subpacket;
+
+	pr_devel("subpkt hdr %02x, %02x\n", data[0], data[1]);
+
+	switch (data[0]) {
+	case 0x00 ... 0xbf:
+		/* One-byte length */
+		size = data[0];
+		data++;
+		datalen--;
+		break;
+	case 0xc0 ... 0xfe:
+		/* Two-byte length */
+		if (datalen < 3)
+			goto short_subpacket;
+		size = (data[0] - 192) * 256;
+		size += data[1] + 192;
+		data += 2;
+		datalen -= 2;
+		break;
+	case 0xff:
+		if (datalen < 6)
+			goto short_subpacket;
+		size  = data[1] << 24;
+		size |= data[2] << 16;
+		size |= data[3] << 8;
+		size |= data[4];
+		data += 5;
+		datalen -= 5;
+		break;
+	}
+
+	/* The type octet is included in the size */
+	pr_devel("datalen=%zu size=%zu\n", datalen, size);
+	if (datalen < size)
+		goto short_subpacket;
+	if (size == 0)
+		goto very_short_subpacket;
+	if (size > INT_MAX)
+		goto too_big;
+
+	type = *data++ & ~PGP_SIG_SUBPKT_TYPE_CRITICAL_MASK;
+	datalen--;
+	size--;
+
+	*_data = data;
+	*_datalen = datalen;
+	*_type = type;
+	pr_devel("Found subpkt type=%u size=%zd\n", type, size);
+	return size;
+
+very_short_subpacket:
+	pr_debug("Signature subpacket size can't be zero\n");
+	return -EBADMSG;
+short_subpacket:
+	pr_debug("Attempt to parse short signature subpacket\n");
+	return -EBADMSG;
+too_big:
+	pr_debug("Signature subpacket size >2G\n");
+	return -EMSGSIZE;
+}
+
+/**
+ * pgp_parse_sig_subpkts - Parse a set of PGP V4 signatute subpackets
+ * @data: Data to be parsed (updated)
+ * @datalen: Amount of data (updated)
+ * @ctx: Parsing context
+ *
+ * Parse a set of PGP signature subpackets [RFC 4880: 5.2.3].
+ *
+ * Return: 0 on successful parsing, an error value otherwise
+ */
+static int pgp_parse_sig_subpkts(const u8 *data, size_t datalen,
+				 struct pgp_parse_sig_context *ctx)
+{
+	enum pgp_sig_subpkt_type type;
+	ssize_t pktlen;
+	int ret;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	while (datalen > 2) {
+		pktlen = pgp_parse_sig_subpkt_header(&data, &datalen, &type);
+		if (pktlen < 0)
+			return pktlen;
+		if (test_bit(type, ctx->types_of_interest)) {
+			ret = ctx->process_packet(ctx, type, data, pktlen);
+			if (ret < 0)
+				return ret;
+		}
+		data += pktlen;
+		datalen -= pktlen;
+	}
+
+	if (datalen != 0) {
+		pr_debug("Excess octets in signature subpacket stream\n");
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+struct pgp_parse_sig_params_ctx {
+	struct pgp_parse_sig_context base;
+	struct pgp_sig_parameters *params;
+	bool got_the_issuer;
+};
+
+/*
+ * Process a V4 signature subpacket.
+ */
+static int pgp_process_sig_params_subpkt(struct pgp_parse_sig_context *context,
+					 enum pgp_sig_subpkt_type type,
+					 const u8 *data,
+					 size_t datalen)
+{
+	struct pgp_parse_sig_params_ctx *ctx =
+		container_of(context, struct pgp_parse_sig_params_ctx, base);
+
+	if (ctx->got_the_issuer) {
+		pr_debug("V4 signature packet has multiple issuers\n");
+		return -EBADMSG;
+	}
+
+	if (datalen != 8) {
+		pr_debug("V4 signature issuer subpkt not 8 long (%zu)\n",
+			   datalen);
+		return -EBADMSG;
+	}
+
+	memcpy(&ctx->params->issuer, data, 8);
+	ctx->got_the_issuer = true;
+	return 0;
+}
+
+/**
+ * pgp_parse_sig_params - Parse basic parameters from a PGP signature packet
+ * @_data: Content of packet (updated)
+ * @_datalen: Length of packet remaining (updated)
+ * @p: The basic parameters
+ *
+ * Parse the basic parameters from a PGP signature packet [RFC 4880: 5.2] that
+ * are needed to start off a signature verification operation.  The only ones
+ * actually necessary are the signature type (which affects how the data is
+ * transformed) and the hash algorithm.
+ *
+ * We also extract the public key algorithm and the issuer's key ID as we'll
+ * need those to determine if we actually have the public key available.  If
+ * not, then we can't verify the signature anyway.
+ *
+ * Return: 0 if successful or a negative error code.  *_data and *_datalen are
+ * updated to point to the 16-bit subset of the hash value and the set of MPIs.
+ */
+int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
+			 struct pgp_sig_parameters *p)
+{
+	const u8 *data = *_data;
+	size_t datalen = *_datalen;
+	int ret;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 1)
+		return -EBADMSG;
+	p->version = *data;
+
+	if (p->version == PGP_SIG_VERSION_3) {
+		const struct pgp_signature_v3_packet *v3 = (const void *)data;
+
+		if (datalen < sizeof(*v3)) {
+			pr_debug("Short V3 signature packet\n");
+			return -EBADMSG;
+		}
+		datalen -= sizeof(*v3);
+		data += sizeof(*v3);
+
+		/* V3 has everything we need in the header */
+		p->signature_type = v3->hashed.signature_type;
+		memcpy(&p->issuer, &v3->issuer, 8);
+		p->pubkey_algo = v3->pubkey_algo;
+		p->hash_algo = v3->hash_algo;
+
+	} else if (p->version == PGP_SIG_VERSION_4) {
+		const struct pgp_signature_v4_packet *v4 = (const void *)data;
+		struct pgp_parse_sig_params_ctx ctx = {
+			.base.process_packet = pgp_process_sig_params_subpkt,
+			.params = p,
+			.got_the_issuer = false,
+		};
+		size_t subdatalen;
+
+		if (datalen < sizeof(*v4) + 2 + 2 + 2) {
+			pr_debug("Short V4 signature packet\n");
+			return -EBADMSG;
+		}
+		datalen -= sizeof(*v4);
+		data += sizeof(*v4);
+
+		/* V4 has most things in the header... */
+		p->signature_type = v4->signature_type;
+		p->pubkey_algo = v4->pubkey_algo;
+		p->hash_algo = v4->hash_algo;
+
+		/*
+		 * ... but we have to get the key ID from the subpackets, of
+		 * which there are two sets.
+		 */
+		__set_bit(PGP_SIG_ISSUER, ctx.base.types_of_interest);
+
+		subdatalen  = *data++ << 8;
+		subdatalen |= *data++;
+		datalen -= 2;
+		if (subdatalen) {
+			/* Hashed subpackets */
+			pr_devel("hashed data: %zu (after %zu)\n",
+				 subdatalen, sizeof(*v4));
+			if (subdatalen > datalen + 2 + 2) {
+				pr_debug("Short V4 signature packet [hdata]\n");
+				return -EBADMSG;
+			}
+			ret = pgp_parse_sig_subpkts(data, subdatalen,
+						    &ctx.base);
+			if (ret < 0)
+				return ret;
+			data += subdatalen;
+			datalen -= subdatalen;
+		}
+
+		subdatalen  = *data++ << 8;
+		subdatalen |= *data++;
+		datalen -= 2;
+		if (subdatalen) {
+			/* Unhashed subpackets */
+			pr_devel("unhashed data: %zu\n", subdatalen);
+			if (subdatalen > datalen + 2) {
+				pr_debug("Short V4 signature packet [udata]\n");
+				return -EBADMSG;
+			}
+			ret = pgp_parse_sig_subpkts(data, subdatalen,
+						    &ctx.base);
+			if (ret < 0)
+				return ret;
+			data += subdatalen;
+			datalen -= subdatalen;
+		}
+
+		if (!ctx.got_the_issuer) {
+			pr_debug("V4 signature packet lacks issuer\n");
+			return -EBADMSG;
+		}
+	} else {
+		pr_debug("Signature packet with unhandled version %d\n",
+			 p->version);
+		return -EBADMSG;
+	}
+
+	*_data = data;
+	*_datalen = datalen;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_sig_params);
diff --git a/crypto/asymmetric_keys/pgplib.h b/crypto/asymmetric_keys/pgplib.h
index d82b84179433..967e2853186d 100644
--- a/crypto/asymmetric_keys/pgplib.h
+++ b/crypto/asymmetric_keys/pgplib.h
@@ -31,3 +31,28 @@ struct pgp_parse_pubkey {
 
 extern int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
 				struct pgp_parse_pubkey *pk);
+
+struct pgp_parse_sig_context {
+	unsigned long types_of_interest[128 / BITS_PER_LONG];
+	int (*process_packet)(struct pgp_parse_sig_context *context,
+			      enum pgp_sig_subpkt_type type,
+			      const u8 *data,
+			      size_t datalen);
+};
+
+extern int pgp_parse_sig_packets(const u8 *data, size_t datalen,
+				 struct pgp_parse_sig_context *ctx);
+
+struct pgp_sig_parameters {
+	enum pgp_signature_version version : 8;
+	enum pgp_signature_type signature_type : 8;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	enum pgp_hash_algo hash_algo : 8;
+	union {
+		struct pgp_key_ID issuer;
+		__be32 issuer32[2];
+	};
+};
+
+extern int pgp_parse_sig_params(const u8 **_data, size_t *_datalen,
+				struct pgp_sig_parameters *p);
-- 
2.32.0

