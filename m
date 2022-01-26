Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E76E49BFF1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbiAZAH2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:28 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7122 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235177AbiAZAHZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:25 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PNklpW015377;
        Wed, 26 Jan 2022 00:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B+NdcKPHFPZZgDawrfKFq6M17fFn4ErIyjO6KR4BsVw=;
 b=sFXUo5JSMF0ynqhEZKQNFfp1idwR86vjG5aPiZQfVZkiNzb8XhVCurfYARrcPwUILNcR
 iMZkPnac0w46I0tTV3I4HRXA6rMyP4P0udMGeE7UtyPUK7NSkKm2ZSjpuO4fh44EGEQf
 MymviRrSxglHJRCZKfffS6RnAz616RD7cowaw8mlGGBhp82gJVwQcS11O4W7XLgpxKn6
 XzP+eQfsIZUwzz8KmsMv66RvIgEaMujX9CvLd8OJvaXRya211gXbSjsqr6gMDftMOLe4
 u2Af2A6BuJIDbsS7+pt0GagwwBzVujcs66vk0G9Kqoq/74tv4vwZfaIo6nR/F848xCZ9 CA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtu66r9bt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q07K3G004940;
        Wed, 26 Jan 2022 00:07:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3dr96jgv3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q07E7m43516414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EBDB4C04E;
        Wed, 26 Jan 2022 00:07:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 753064C044;
        Wed, 26 Jan 2022 00:07:13 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:13 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/8] ima: define signature version 3
Date:   Tue, 25 Jan 2022 19:06:56 -0500
Message-Id: <20220126000658.138345-7-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3efVHz3QjSMeL0EfX-5n5j4L1nClqyUr
X-Proofpoint-ORIG-GUID: 3efVHz3QjSMeL0EfX-5n5j4L1nClqyUr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

To disambiguate the signed data, instead of directly signing the file data
hash, signature version 3 signs the hash of the ima_file_id structure.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/digsig.c           |  3 ++-
 security/integrity/ima/ima_appraise.c | 36 +++++++++++++++++++++++++++
 security/integrity/integrity.h        | 20 +++++++++++++--
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 3b06a01bd0fd..fd8f77d92a62 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -74,7 +74,8 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		/* v1 API expect signature without xattr type */
 		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
 				     digestlen);
-	case 2:
+	case 2: /* regular file data hash based sginature */
+	case 3: /* struct ima_file_id data base signature */
 		return asymmetric_verify(keyring, sig, siglen, digest,
 					 digestlen);
 	}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17232bbfb9f9..7bc180bd808e 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -225,6 +225,34 @@ int ima_read_xattr(struct dentry *dentry,
 	return ret;
 }
 
+/*
+ * calc_file_id_hash - calculate the hash of the ima_file_id struct data
+ * @type: xattr type [enum evm_ima_xattr_type]
+ * @algo: hash algorithm [enum hash_algo]
+ * @digest: pointer to the digest to be hashed
+ * @hash: (out) pointer to the hash
+ *
+ * IMA signature version 3 disambiguates the data that is signed by
+ * indirectly signing the hash of the ima_file_id structure data.
+ *
+ * Return 0 on success, error code otherwise.
+ */
+static int calc_file_id_hash(enum evm_ima_xattr_type type,
+			     enum hash_algo algo, const u8 *digest,
+			     struct ima_max_digest_data *hash)
+{
+	struct ima_file_id file_id = {.hash_algorithm = algo};
+	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
+
+	memcpy(file_id.hash, digest, hash_digest_size[algo]);
+
+	hash->algo = algo;
+	hash->length = hash_digest_size[algo];
+
+	return ima_calc_buffer_hash(&file_id, sizeof(file_id) - unused,
+				    (struct ima_digest_data *)hash);
+}
+
 /*
  * xattr_verify - verify xattr digest or signature
  *
@@ -236,6 +264,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	struct signature_v2_hdr *sig;
 	int rc = -EINVAL, hash_start = 0;
 
 	switch (xattr_value->type) {
@@ -274,6 +303,13 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		sig = (typeof(sig))xattr_value;
+		if (sig->version != 2) {
+			*cause = "invalid-signature-version";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
 					     (const char *)xattr_value,
 					     xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index a996d4fa7be3..ed4966d943e9 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -94,7 +94,7 @@ struct evm_xattr {
 	u8 digest[SHA1_DIGEST_SIZE];
 } __packed;
 
-#define IMA_MAX_DIGEST_SIZE	64
+#define IMA_MAX_DIGEST_SIZE	HASH_MAX_DIGESTSIZE
 
 struct ima_digest_data {
 	u8 algo;
@@ -137,7 +137,11 @@ struct ima_max_digest_data {
 } __packed;
 
 /*
- * signature format v2 - for using with asymmetric keys
+ * signature header format v2 - for using with asymmetric keys
+ *
+ * signature format:
+ * version 2: regular file data hash based signature
+ * version 3: struct ima_file_id data based signature
  */
 struct signature_v2_hdr {
 	uint8_t type;		/* xattr type */
@@ -148,6 +152,18 @@ struct signature_v2_hdr {
 	uint8_t sig[];		/* signature payload */
 } __packed;
 
+/*
+ * IMA signature version 3 disambiguates the data that is signed, by
+ * indirectly signing the hash of the ima_file_id structure data.
+ *
+ * (The hash of the ima_file_id structure is only of the portion used.)
+ */
+struct ima_file_id {
+	__u8 hash_type;		/* xattr type [enum evm_ima_xattr_type] */
+	__u8 hash_algorithm;	/* Digest algorithm [enum hash_algo] */
+	__u8 hash[HASH_MAX_DIGESTSIZE];
+} __packed;
+
 /* integrity data associated with an inode */
 struct integrity_iint_cache {
 	struct rb_node rb_node;	/* rooted in integrity_iint_tree */
-- 
2.27.0

