Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C434A49BFE4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiAZAHU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235126AbiAZAHT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:19 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PNeECH031332;
        Wed, 26 Jan 2022 00:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kQYtu+wFyQQfDCJ1wAGRdtoB4P3YfHsu0yLH/J24MYE=;
 b=k474ltd1VSJfsFPb/ILCQOofhi/eHvkLZchuT7DPjHH0590nFsBy1Dphmr55BfuNCn/N
 /2QpK+YU788+d0+lONFLwQUxLr9c4TkhZSdTmesdix1o3tsu6Gc13iFeArJ9zNbdkx81
 q3+QgqjMAkaCY6nWEtQEoL94j80wZH5Hy6/P9xv0Jak+EXJ6JccYQygi9RvrX3OXTcAe
 3fj2cPCSncYNm7GpGwXVTmVTvF835gX5OWl28Zc4jsbXuTa5JkoF90ndns3QS0SMxkjJ
 UIBTBRlmhhgC+EoScqwfF+Oizzo0PqQYHb2eNwBnONh/Aj1Ratb5KIxGGTn3Ktb/3nUB 5A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtsbehvpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:15 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q040jc014106;
        Wed, 26 Jan 2022 00:07:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9a7tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q079W242402196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CEF84C046;
        Wed, 26 Jan 2022 00:07:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F00194C044;
        Wed, 26 Jan 2022 00:07:07 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:07 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/8] ima: define ima_max_digest_data struct without a flexible array variable
Date:   Tue, 25 Jan 2022 19:06:52 -0500
Message-Id: <20220126000658.138345-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 64MBaGRUxs3xGWQ_BPct-TnRQw_yu3Rs
X-Proofpoint-GUID: 64MBaGRUxs3xGWQ_BPct-TnRQw_yu3Rs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Replace (the ugly) wrapping of the "ima_digest_data" struct, containing
a flexible array variable, inside another local structure, by defining
"ima_max_digest_data" struct with the maximum digest size.

For example, use the "ima_max_digest_data" struct when calculating the
"boot_aggregate" value.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima.h              |  2 +-
 security/integrity/ima/ima_crypto.c       |  2 +-
 security/integrity/ima/ima_init.c         |  9 +++------
 security/integrity/ima/ima_template_lib.c |  3 ++-
 security/integrity/integrity.h            | 24 +++++++++++++++++++++++
 5 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index be965a8715e4..78395bed7fad 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -144,7 +144,7 @@ int ima_calc_buffer_hash(const void *buf, loff_t len,
 			 struct ima_digest_data *hash);
 int ima_calc_field_array_hash(struct ima_field_data *field_data,
 			      struct ima_template_entry *entry);
-int ima_calc_boot_aggregate(struct ima_digest_data *hash);
+int ima_calc_boot_aggregate(struct ima_max_digest_data *hash);
 void ima_add_violation(struct file *file, const unsigned char *filename,
 		       struct integrity_iint_cache *iint,
 		       const char *op, const char *cause);
diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
index a7206cc1d7d1..0ff1bfcaf13f 100644
--- a/security/integrity/ima/ima_crypto.c
+++ b/security/integrity/ima/ima_crypto.c
@@ -840,7 +840,7 @@ static int ima_calc_boot_aggregate_tfm(char *digest, u16 alg_id,
 	return rc;
 }
 
-int ima_calc_boot_aggregate(struct ima_digest_data *hash)
+int ima_calc_boot_aggregate(struct ima_max_digest_data *hash)
 {
 	struct crypto_shash *tfm;
 	u16 crypto_id, alg_id;
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index b26fa67476b4..dfbef713e0b6 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -47,16 +47,13 @@ static int __init ima_add_boot_aggregate(void)
 	struct integrity_iint_cache tmp_iint, *iint = &tmp_iint;
 	struct ima_event_data event_data = { .iint = iint,
 					     .filename = boot_aggregate_name };
+	struct ima_max_digest_data hash;
 	int result = -ENOMEM;
 	int violation = 0;
-	struct {
-		struct ima_digest_data hdr;
-		char digest[TPM_MAX_DIGEST_SIZE];
-	} hash;
 
 	memset(iint, 0, sizeof(*iint));
 	memset(&hash, 0, sizeof(hash));
-	iint->ima_hash = &hash.hdr;
+	iint->ima_hash = (struct ima_digest_data *)&hash;
 	iint->ima_hash->algo = ima_hash_algo;
 	iint->ima_hash->length = hash_digest_size[ima_hash_algo];
 
@@ -73,7 +70,7 @@ static int __init ima_add_boot_aggregate(void)
 	 * is not found.
 	 */
 	if (ima_tpm_chip) {
-		result = ima_calc_boot_aggregate(&hash.hdr);
+		result = ima_calc_boot_aggregate(&hash);
 		if (result < 0) {
 			audit_cause = "hashing_error";
 			goto err_out;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 5a5d462ab36d..d3aa511027cd 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -330,7 +330,8 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 	if ((const char *)event_data->filename == boot_aggregate_name) {
 		if (ima_tpm_chip) {
 			hash.hdr.algo = HASH_ALGO_SHA1;
-			result = ima_calc_boot_aggregate(&hash.hdr);
+			result = ima_calc_boot_aggregate(
+				(struct ima_max_digest_data *)&hash.hdr);
 
 			/* algo can change depending on available PCR banks */
 			if (!result && hash.hdr.algo != HASH_ALGO_SHA1)
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d045dccd415a..ee2e6b7c7575 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/integrity.h>
 #include <crypto/sha1.h>
+#include <crypto/hash.h>
 #include <linux/key.h>
 #include <linux/audit.h>
 
@@ -110,6 +111,29 @@ struct ima_digest_data {
 	u8 digest[];
 } __packed;
 
+/*
+ * Instead of dynamically allocating memory for the ima_digest_data struct
+ * with space for the specific hash algo or wrapping the ima_digest_data
+ * struct inside another local structure, define ima_max_digest_data struct
+ * with the maximum digest size.
+ */
+struct ima_max_digest_data {
+	u8 algo;
+	u8 length;
+	union {
+		struct {
+			u8 unused;
+			u8 type;
+		} sha1;
+		struct {
+			u8 type;
+			u8 algo;
+		} ng;
+		u8 data[2];
+	} xattr;
+	u8 digest[HASH_MAX_DIGESTSIZE];
+} __packed;
+
 /*
  * signature format v2 - for using with asymmetric keys
  */
-- 
2.27.0

