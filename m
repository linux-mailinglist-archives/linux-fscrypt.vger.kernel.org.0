Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B619D48B512
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242318AbiAKSFA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:05:00 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4392 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345450AbiAKSDx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:53 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJPs2gYKz688S5;
        Wed, 12 Jan 2022 02:00:17 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:49 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 04/14] PGPLIB: Basic packet parser
Date:   Tue, 11 Jan 2022 19:03:08 +0100
Message-ID: <20220111180318.591029-5-roberto.sassu@huawei.com>
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

Provide a simple parser that extracts the packets from a PGP packet blob
and passes the desirous ones to the given processor function:

	struct pgp_parse_context {
		u64 types_of_interest;
		int (*process_packet)(struct pgp_parse_context *context,
				      enum pgp_packet_tag type,
				      u8 headerlen,
				      const u8 *data,
				      size_t datalen);
	};

	int pgp_parse_packets(const u8 *data, size_t datalen,
			      struct pgp_parse_context *ctx);

This is configured on with CONFIG_PGP_LIBRARY.

Signed-off-by: David Howells <dhowells@redhat.com>
Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/asymmetric_keys/Kconfig       |   6 +
 crypto/asymmetric_keys/Makefile      |   5 +
 crypto/asymmetric_keys/pgp_library.c | 272 +++++++++++++++++++++++++++
 crypto/asymmetric_keys/pgplib.h      |  33 ++++
 4 files changed, 316 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pgp_library.c
 create mode 100644 crypto/asymmetric_keys/pgplib.h

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 1f1f004dc757..0678ede9d17e 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -96,4 +96,10 @@ config SIGNED_PE_FILE_VERIFICATION
 	  This option provides support for verifying the signature(s) on a
 	  signed PE binary.
 
+config PGP_LIBRARY
+	tristate "PGP parsing library"
+	help
+	  This option enables a library that provides a number of simple
+	  utility functions for parsing PGP (RFC 4880) packet-based messages.
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
index 28b91adba2ae..55a67ebfe8e1 100644
--- a/crypto/asymmetric_keys/Makefile
+++ b/crypto/asymmetric_keys/Makefile
@@ -86,3 +86,8 @@ tpm_key_parser-y := \
 
 $(obj)/tpm_parser.o: $(obj)/tpm.asn1.h
 $(obj)/tpm.asn1.o: $(obj)/tpm.asn1.c $(obj)/tpm.asn1.h
+
+#
+# PGP handling
+#
+obj-$(CONFIG_PGP_LIBRARY) += pgp_library.o
diff --git a/crypto/asymmetric_keys/pgp_library.c b/crypto/asymmetric_keys/pgp_library.c
new file mode 100644
index 000000000000..d2c3149983d5
--- /dev/null
+++ b/crypto/asymmetric_keys/pgp_library.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0
+/* PGP packet parser (RFC 4880)
+ *
+ * Copyright (C) 2011 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#define pr_fmt(fmt) "PGPL: "fmt
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "pgplib.h"
+
+MODULE_LICENSE("GPL");
+
+const char *const pgp_hash_algorithms[PGP_HASH__LAST] = {
+	[PGP_HASH_MD5]			= "md5",
+	[PGP_HASH_SHA1]			= "sha1",
+	[PGP_HASH_RIPE_MD_160]		= "rmd160",
+	[PGP_HASH_SHA256]		= "sha256",
+	[PGP_HASH_SHA384]		= "sha384",
+	[PGP_HASH_SHA512]		= "sha512",
+	[PGP_HASH_SHA224]		= "sha224",
+};
+EXPORT_SYMBOL_GPL(pgp_hash_algorithms);
+
+/**
+ * pgp_parse_packet_header - Parse a PGP packet header
+ * @_data: Start of the PGP packet (updated to PGP packet data)
+ * @_datalen: Amount of data remaining in buffer (decreased)
+ * @_type: Where the packet type will be returned
+ * @_headerlen: Where the header length will be returned
+ *
+ * Parse a set of PGP packet header [RFC 4880: 4.2].
+ *
+ * Return: packet data size on success; non-zero on error.  If successful,
+ * *_data and *_datalen will have been updated and *_headerlen will be set to
+ * hold the length of the packet header.
+ */
+static ssize_t pgp_parse_packet_header(const u8 **_data, size_t *_datalen,
+				       enum pgp_packet_tag *_type,
+				       u8 *_headerlen)
+{
+	enum pgp_packet_tag type;
+	const u8 *data = *_data;
+	size_t size, datalen = *_datalen;
+
+	pr_devel("-->%s(,%zu,,)\n", __func__, datalen);
+
+	if (datalen < 2)
+		goto short_packet;
+
+	pr_devel("pkthdr %02x, %02x\n", data[0], data[1]);
+
+	type = *data++;
+	datalen--;
+	if (!(type & 0x80)) {
+		pr_debug("Packet type does not have MSB set\n");
+		return -EBADMSG;
+	}
+	type &= ~0x80;
+
+	if (type & 0x40) {
+		/* New packet length format */
+		type &= ~0x40;
+		pr_devel("new format: t=%u\n", type);
+		switch (data[0]) {
+		case 0x00 ... 0xbf:
+			/* One-byte length */
+			size = data[0];
+			data++;
+			datalen--;
+			*_headerlen = 2;
+			break;
+		case 0xc0 ... 0xdf:
+			/* Two-byte length */
+			if (datalen < 2)
+				goto short_packet;
+			size = (data[0] - 192) * 256;
+			size += data[1] + 192;
+			data += 2;
+			datalen -= 2;
+			*_headerlen = 3;
+			break;
+		case 0xff:
+			/* Five-byte length */
+			if (datalen < 5)
+				goto short_packet;
+			size =  data[1] << 24;
+			size |= data[2] << 16;
+			size |= data[3] << 8;
+			size |= data[4];
+			data += 5;
+			datalen -= 5;
+			*_headerlen = 6;
+			break;
+		default:
+			pr_debug("Partial body length packet not supported\n");
+			return -EBADMSG;
+		}
+	} else {
+		/* Old packet length format */
+		u8 length_type = type & 0x03;
+
+		type >>= 2;
+		pr_devel("old format: t=%u lt=%u\n", type, length_type);
+
+		switch (length_type) {
+		case 0:
+			/* One-byte length */
+			size = data[0];
+			data++;
+			datalen--;
+			*_headerlen = 2;
+			break;
+		case 1:
+			/* Two-byte length */
+			if (datalen < 2)
+				goto short_packet;
+			size  = data[0] << 8;
+			size |= data[1];
+			data += 2;
+			datalen -= 2;
+			*_headerlen = 3;
+			break;
+		case 2:
+			/* Four-byte length */
+			if (datalen < 4)
+				goto short_packet;
+			size  = data[0] << 24;
+			size |= data[1] << 16;
+			size |= data[2] << 8;
+			size |= data[3];
+			data += 4;
+			datalen -= 4;
+			*_headerlen = 5;
+			break;
+		default:
+			pr_debug("Indefinite length packet not supported\n");
+			return -EBADMSG;
+		}
+	}
+
+	pr_devel("datalen=%zu size=%zu\n", datalen, size);
+	if (datalen < size)
+		goto short_packet;
+	if (size > INT_MAX)
+		goto too_big;
+
+	*_data = data;
+	*_datalen = datalen;
+	*_type = type;
+	pr_devel("Found packet type=%u size=%zd\n", type, size);
+	return size;
+
+short_packet:
+	pr_debug("Attempt to parse short packet\n");
+	return -EBADMSG;
+too_big:
+	pr_debug("Signature subpacket size >2G\n");
+	return -EMSGSIZE;
+}
+
+/**
+ * pgp_parse_packets - Parse a set of PGP packets
+ * @data: Data to be parsed (updated)
+ * @datalen: Amount of data (updated)
+ * @ctx: Parsing context
+ *
+ * Parse a set of PGP packets [RFC 4880: 4].
+ *
+ * Return: 0 on successful parsing, a negative value otherwise
+ */
+int pgp_parse_packets(const u8 *data, size_t datalen,
+		      struct pgp_parse_context *ctx)
+{
+	enum pgp_packet_tag type;
+	ssize_t pktlen;
+	u8 headerlen;
+	int ret;
+
+	while (datalen > 2) {
+		pktlen = pgp_parse_packet_header(&data, &datalen, &type,
+						 &headerlen);
+		if (pktlen < 0)
+			return pktlen;
+
+		if ((ctx->types_of_interest >> type) & 1) {
+			ret = ctx->process_packet(ctx, type, headerlen,
+						  data, pktlen);
+			if (ret < 0)
+				return ret;
+		}
+		data += pktlen;
+		datalen -= pktlen;
+	}
+
+	if (datalen != 0) {
+		pr_debug("Excess octets in packet stream\n");
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_packets);
+
+/**
+ * pgp_parse_public_key - Parse the common part of a PGP pubkey packet
+ * @_data: Content of packet (updated)
+ * @_datalen: Length of packet remaining (updated)
+ * @pk: Public key data
+ *
+ * Parse the common data struct for a PGP pubkey packet [RFC 4880: 5.5.2].
+ *
+ * Return: 0 on successful parsing, a negative value otherwise
+ */
+int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
+			 struct pgp_parse_pubkey *pk)
+{
+	const u8 *data = *_data;
+	size_t datalen = *_datalen;
+	unsigned int tmp;
+
+	if (datalen < 12) {
+		pr_debug("Public key packet too short\n");
+		return -EBADMSG;
+	}
+
+	pk->version = *data++;
+	switch (pk->version) {
+	case PGP_KEY_VERSION_2:
+	case PGP_KEY_VERSION_3:
+	case PGP_KEY_VERSION_4:
+		break;
+	default:
+		pr_debug("Public key packet with unhandled version %d\n",
+			   pk->version);
+		return -EBADMSG;
+	}
+
+	tmp  = *data++ << 24;
+	tmp |= *data++ << 16;
+	tmp |= *data++ << 8;
+	tmp |= *data++;
+	pk->creation_time = tmp;
+	if (pk->version == PGP_KEY_VERSION_4) {
+		pk->expires_at = 0; /* Have to get it from the selfsignature */
+	} else {
+		unsigned short ndays;
+
+		ndays  = *data++ << 8;
+		ndays |= *data++;
+		if (ndays)
+			pk->expires_at = pk->creation_time + ndays * 86400UL;
+		else
+			pk->expires_at = 0;
+		datalen -= 2;
+	}
+
+	pk->pubkey_algo = *data++;
+	datalen -= 6;
+
+	pr_devel("%x,%x,%lx,%lx\n",
+		 pk->version, pk->pubkey_algo, pk->creation_time,
+		 pk->expires_at);
+
+	*_data = data;
+	*_datalen = datalen;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pgp_parse_public_key);
diff --git a/crypto/asymmetric_keys/pgplib.h b/crypto/asymmetric_keys/pgplib.h
new file mode 100644
index 000000000000..d82b84179433
--- /dev/null
+++ b/crypto/asymmetric_keys/pgplib.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* PGP library definitions (RFC 4880)
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+
+#include "pgp.h"
+
+/*
+ * PGP library packet parser
+ */
+struct pgp_parse_context {
+	u64 types_of_interest;
+	int (*process_packet)(struct pgp_parse_context *context,
+			      enum pgp_packet_tag type,
+			      u8 headerlen,
+			      const u8 *data,
+			      size_t datalen);
+};
+
+extern int pgp_parse_packets(const u8 *data, size_t datalen,
+			     struct pgp_parse_context *ctx);
+
+struct pgp_parse_pubkey {
+	enum pgp_key_version version : 8;
+	enum pgp_pubkey_algo pubkey_algo : 8;
+	__kernel_old_time_t creation_time;
+	__kernel_old_time_t expires_at;
+};
+
+extern int pgp_parse_public_key(const u8 **_data, size_t *_datalen,
+				struct pgp_parse_pubkey *pk);
-- 
2.32.0

