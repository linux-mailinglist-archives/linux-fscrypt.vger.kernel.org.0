Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC22A48B4E8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350121AbiAKSEF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:05 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4390 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345415AbiAKSDv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:51 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJPq5XqSz67k5K;
        Wed, 12 Jan 2022 02:00:15 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:48 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 02/14] rsa: add parser of raw format
Date:   Tue, 11 Jan 2022 19:03:06 +0100
Message-ID: <20220111180318.591029-3-roberto.sassu@huawei.com>
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

Parse the RSA key with RAW format if the ASN.1 parser returns an error.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 crypto/rsa.c                  | 14 +++++--
 crypto/rsa_helper.c           | 69 +++++++++++++++++++++++++++++++++++
 include/crypto/internal/rsa.h |  6 +++
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 4cdbec95d077..ece7bafd6984 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -164,8 +164,11 @@ static int rsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_free_mpi_key(mpi_key);
 
 	ret = rsa_parse_pub_key(&raw_key, key, keylen);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = rsa_parse_pub_key_raw(&raw_key, key, keylen);
+		if (ret)
+			return ret;
+	}
 
 	mpi_key->e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
 	if (!mpi_key->e)
@@ -198,8 +201,11 @@ static int rsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
 	rsa_free_mpi_key(mpi_key);
 
 	ret = rsa_parse_priv_key(&raw_key, key, keylen);
-	if (ret)
-		return ret;
+	if (ret) {
+		ret = rsa_parse_priv_key_raw(&raw_key, key, keylen);
+		if (ret)
+			return ret;
+	}
 
 	mpi_key->d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
 	if (!mpi_key->d)
diff --git a/crypto/rsa_helper.c b/crypto/rsa_helper.c
index 94266f29049c..fb9443df8f0b 100644
--- a/crypto/rsa_helper.c
+++ b/crypto/rsa_helper.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/fips.h>
+#include <linux/mpi.h>
 #include <crypto/internal/rsa.h>
 #include "rsapubkey.asn1.h"
 #include "rsaprivkey.asn1.h"
@@ -148,6 +149,32 @@ int rsa_get_qinv(void *context, size_t hdrlen, unsigned char tag,
 	return 0;
 }
 
+typedef int (*rsa_get_func)(void *, size_t, unsigned char,
+			    const void *, size_t);
+
+static int rsa_parse_key_raw(struct rsa_key *rsa_key,
+			     const void *key, unsigned int key_len,
+			     rsa_get_func *func, int n_func)
+{
+	unsigned int nbytes, len = key_len;
+	const void *key_ptr = key;
+	int ret, i;
+
+	for (i = 0; i < n_func; i++) {
+		ret = mpi_key_length(key_ptr, len, NULL, &nbytes);
+		if (ret < 0)
+			return ret;
+
+		ret = func[i](rsa_key, 0, 0, key_ptr + 2, nbytes);
+		if (ret < 0)
+			return ret;
+
+		key_ptr += nbytes + 2;
+	}
+
+	return (key_ptr == key + key_len) ? 0 : -EINVAL;
+}
+
 /**
  * rsa_parse_pub_key() - decodes the BER encoded buffer and stores in the
  *                       provided struct rsa_key, pointers to the raw key as is,
@@ -166,6 +193,27 @@ int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 }
 EXPORT_SYMBOL_GPL(rsa_parse_pub_key);
 
+/**
+ * rsa_parse_pub_key_raw() - parse the RAW key and store in the provided struct
+ *                           rsa_key, pointers to the raw key as is, so that
+ *                           the caller can copy it or MPI parse it, etc.
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in RAW format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_pub_key_raw(struct rsa_key *rsa_key, const void *key,
+			  unsigned int key_len)
+{
+	rsa_get_func pub_func[] = {rsa_get_n, rsa_get_e};
+
+	return rsa_parse_key_raw(rsa_key, key, key_len,
+				 pub_func, ARRAY_SIZE(pub_func));
+}
+EXPORT_SYMBOL_GPL(rsa_parse_pub_key_raw);
+
 /**
  * rsa_parse_priv_key() - decodes the BER encoded buffer and stores in the
  *                        provided struct rsa_key, pointers to the raw key
@@ -184,3 +232,24 @@ int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 	return asn1_ber_decoder(&rsaprivkey_decoder, rsa_key, key, key_len);
 }
 EXPORT_SYMBOL_GPL(rsa_parse_priv_key);
+
+/**
+ * rsa_parse_priv_key_raw() - parse the RAW key and store in the provided struct
+ *                            rsa_key, pointers to the raw key as is, so that
+ *                            the caller can copy it or MPI parse it, etc.
+ *
+ * @rsa_key:	struct rsa_key key representation
+ * @key:	key in RAW format
+ * @key_len:	length of key
+ *
+ * Return:	0 on success or error code in case of error
+ */
+int rsa_parse_priv_key_raw(struct rsa_key *rsa_key, const void *key,
+			   unsigned int key_len)
+{
+	rsa_get_func priv_func[] = {rsa_get_n, rsa_get_e, rsa_get_d};
+
+	return rsa_parse_key_raw(rsa_key, key, key_len,
+				 priv_func, ARRAY_SIZE(priv_func));
+}
+EXPORT_SYMBOL_GPL(rsa_parse_priv_key_raw);
diff --git a/include/crypto/internal/rsa.h b/include/crypto/internal/rsa.h
index e870133f4b77..7141e806ceea 100644
--- a/include/crypto/internal/rsa.h
+++ b/include/crypto/internal/rsa.h
@@ -50,8 +50,14 @@ struct rsa_key {
 int rsa_parse_pub_key(struct rsa_key *rsa_key, const void *key,
 		      unsigned int key_len);
 
+int rsa_parse_pub_key_raw(struct rsa_key *rsa_key, const void *key,
+			  unsigned int key_len);
+
 int rsa_parse_priv_key(struct rsa_key *rsa_key, const void *key,
 		       unsigned int key_len);
 
+int rsa_parse_priv_key_raw(struct rsa_key *rsa_key, const void *key,
+			   unsigned int key_len);
+
 extern struct crypto_template rsa_pkcs1pad_tmpl;
 #endif
-- 
2.32.0

