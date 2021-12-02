Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA565466BD2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377195AbhLBV7P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28514 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243133AbhLBV7O (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:14 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LrTU7007410;
        Thu, 2 Dec 2021 21:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=99lf/4mNYjONbemwVu4aG12hSpqub1w/eY5dW67leSE=;
 b=ouiimTMzkYTdPcoBYy3EbXUu1uDg3PN7eY+Vc3stjOcsEIoj7mPzrbJS1qiVIQywJs1L
 +G+xH3gAaaV913tj2PrYnRCk9lq39LJIrKhtbBlN6b627V5mgMLGOsmRw03Q6OgtGjkO
 H+9fE4T2n/64+o3n3Rs4TXRS+Qsv8Spd4BMvyY4MYxAf1YPErBthDMegnK875kMPJETg
 U0N29vPBDmR/144YCz3bPD4/ZLYIATDjGt3VrkBrd871lm+VVsgsnxhrPuCQ2tL0+8SF
 NHVkL8uCl0xQvCN8E/3MgGh83A1O8YQvg8ZPvXa65Y7WrgzWpDuYNREjAuyk8bAPYn6d jg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cq489u57x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:49 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LnbdU031196;
        Thu, 2 Dec 2021 21:55:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckcaa89dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2Ltjm323593370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:55:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FBF452051;
        Thu,  2 Dec 2021 21:55:45 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1E75F52050;
        Thu,  2 Dec 2021 21:55:44 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/5] ima: support fs-verity file digest based signatures
Date:   Thu,  2 Dec 2021 16:55:06 -0500
Message-Id: <20211202215507.298415-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211202215507.298415-1-zohar@linux.ibm.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0avv4h6rzYJEsiA-Baj_7wB_btp7qSiI
X-Proofpoint-GUID: 0avv4h6rzYJEsiA-Baj_7wB_btp7qSiI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of calculating a file hash and verifying the signature stored
in the security.ima xattr against the calculated file hash, verify the
signature based on the fs-verity's file digest and other metadata.  The
fs-verity file digest is a hash that includes the Merkle tree root hash.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
Changelog v1:
- Based on Eric Bigger's review, instead of verifying the fsverity's file
digest directly, sign a hash of it with other file metadata.

 security/integrity/ima/ima_api.c      | 20 ++++++++++++
 security/integrity/ima/ima_appraise.c | 45 ++++++++++++++++++++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 7505563315cb..4fe7bc99378a 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/evm.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 
 #include "ima.h"
 
@@ -200,6 +201,23 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 				allowed_algos);
 }
 
+static int ima_collect_verity_digest(struct integrity_iint_cache *iint,
+				     struct ima_digest_data *hash)
+{
+	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_alg;
+	int rc;
+
+	rc = fsverity_collect_digest(iint->inode, verity_digest, &verity_alg);
+	if (rc)
+		return -EINVAL;
+	if (hash->algo != verity_alg)
+		return -EINVAL;
+	hash->length = hash_digest_size[verity_alg];
+	memcpy(hash->digest, verity_digest, hash->length);
+	return 0;
+}
+
 /*
  * ima_collect_measurement - collect file measurement
  *
@@ -251,6 +269,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 
 	if (buf)
 		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
+	else if (veritysig)
+		result = ima_collect_verity_digest(iint, &hash.hdr);
 	else
 		result = ima_calc_file_hash(file, &hash.hdr);
 
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 549fe051269a..53938aa0497a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -240,6 +240,11 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	u8 verity_digest[IMA_MAX_DIGEST_SIZE + 1];
+	struct {
+		struct ima_digest_data hdr;
+		char digest[IMA_MAX_DIGEST_SIZE];
+	} hash;
 	int rc = -EINVAL, hash_start = 0;
 
 	switch (xattr_value->type) {
@@ -277,7 +282,45 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		*status = INTEGRITY_PASS;
 		break;
 	case IMA_VERITY_DIGSIG:
-		fallthrough;
+		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		/*
+		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
+		 * and the fs-verity file digest, not directly on the
+		 * fs-verity file digest.  Both digests should probably be
+		 * included in the IMA measurement list, but for now this
+		 * digest is only used for verifying the IMA signature.
+		 */
+		verity_digest[0] = IMA_VERITY_DIGSIG;
+		memcpy(verity_digest + 1, iint->ima_hash->digest,
+		       iint->ima_hash->length);
+
+		hash.hdr.algo = iint->ima_hash->algo;
+		hash.hdr.length = iint->ima_hash->length;
+
+		rc = ima_calc_buffer_hash(verity_digest,
+					  iint->ima_hash->length + 1,
+					  &hash.hdr);
+		if (rc) {
+			*cause = "verity-hashing-error";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     (const char *)xattr_value,
+					      xattr_len,
+					      hash.hdr.digest,
+					      hash.hdr.length);
+
+		if (rc) {
+			*cause = "invalid-verity-signature";
+			*status = INTEGRITY_FAIL;
+		} else {
+			*status = INTEGRITY_PASS;
+		}
+
+		break;
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
-- 
2.27.0

