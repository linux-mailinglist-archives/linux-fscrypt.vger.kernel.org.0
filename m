Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEF249BFF3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbiAZAH2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51280 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235179AbiAZAHZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:25 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q05qdx009016;
        Wed, 26 Jan 2022 00:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=R7R5foVU/Im5PGylEF0xbOzDNnjoBVKtWXh3C22nZII=;
 b=JcdDF6gXce4CmD/mwjnuvkThl2DuV7vBHDUmNJuCSoauuEw25geb0Hwxij61ZLI+FbTC
 vTcbwvFj9Omg8MPQtq9mYl8Fui63HRnQZgKdM3x0ijVFk0iRo1WG7RPN3M1Ort9W0Yo5
 xKkL/zk7+SbDyIr3RvYofpuSzcIsgq7YwTUEHxPeBwlJ36Y5dvkGzJoPx17NyK0hun2V
 V69+Zg+1egDqprlDVfjwQfbcBXI4aOuJgt7qf0cLk4D1aOdO87D5ng+DyGzmegeDFA5X
 4Sm0dp7FWiVCmEhWzfVAcpLyGeFWrRebMSO9TfI598c4MhlwZXC27lGIktPgsAW0tnPw NQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dttae950b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:21 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q03V2P003644;
        Wed, 26 Jan 2022 00:07:19 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9j9gr2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PNvfd032440794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 23:57:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5ECC4C040;
        Wed, 26 Jan 2022 00:07:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDD144C044;
        Wed, 26 Jan 2022 00:07:14 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:14 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/8] ima: support fs-verity file digest based version 3 signatures
Date:   Tue, 25 Jan 2022 19:06:57 -0500
Message-Id: <20220126000658.138345-8-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YAdKyRFYUFj1WVUzXswdT9B1ttZES040
X-Proofpoint-ORIG-GUID: YAdKyRFYUFj1WVUzXswdT9B1ttZES040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of calculating a file hash and verifying the signature stored
in the security.ima xattr against the calculated file hash, verify
fs-verity's signature (version 3).

To differentiate between a regular file hash and an fs-verity file digest
based signature stored as security.ima xattr, define a new signature type
named IMA_VERITY_DIGSIG.

Update the 'ima-sig' template field to display the new fs-verity signature
type as well.

For example:
  appraise func=BPRM_CHECK digest_type=hash|verity

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 10 +++++
 Documentation/security/IMA-templates.rst  |  4 +-
 security/integrity/ima/ima_appraise.c     | 49 ++++++++++++++++++++++-
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  5 ++-
 5 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 444bb7ccbe03..fadf90dde289 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -151,6 +151,16 @@ Description:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
 
+		Example of measure and appraise rules allowing fs-verity
+		signed digests on a particular filesystem identified by
+		it's fsuuid:
+
+			measure func=BPRM_CHECK digest_type=hash|verity \
+				fsuuid=... template=ima-sig
+			appraise func=BPRM_CHECK digest_type=hash|verity \
+				fsuuid=...
+
+
 		Example of measure rule allowing fs-verity's digests on a
 		particular filesystem with indication of type of digest.
 
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 5e31513e8ec4..390936810ebc 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -71,8 +71,8 @@ descriptors by adding their identifier to the format string
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'd-type': the type of file digest (e.g. hash, verity[1]);
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature, or the EVM portable signature if the file
-   signature is not found;
+ - 'sig': the file signature, based on either the file's/fsverity's digest[1],
+   or the EVM portable signature if the file signature is not found;
  - 'modsig' the appended file signature;
  - 'buf': the buffer data that was used to generate the hash without size limitations;
  - 'evmsig': the EVM portable signature;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 7bc180bd808e..68376c56feff 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -13,7 +13,9 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <linux/fsverity.h>
 #include <keys/system_keyring.h>
+#include <uapi/linux/fsverity.h>
 
 #include "ima.h"
 
@@ -183,13 +185,18 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 		return ima_hash_algo;
 
 	switch (xattr_value->type) {
+	case IMA_VERITY_DIGSIG:
+		sig = (typeof(sig))xattr_value;
+		if (sig->version != 3 || xattr_len <= sizeof(*sig) ||
+		    sig->hash_algo >= HASH_ALGO__LAST)
+			return ima_hash_algo;
+		return sig->hash_algo;
 	case EVM_IMA_XATTR_DIGSIG:
 		sig = (typeof(sig))xattr_value;
 		if (sig->version != 2 || xattr_len <= sizeof(*sig)
 		    || sig->hash_algo >= HASH_ALGO__LAST)
 			return ima_hash_algo;
 		return sig->hash_algo;
-		break;
 	case IMA_XATTR_DIGEST_NG:
 		/* first byte contains algorithm id */
 		ret = xattr_value->data[0];
@@ -235,15 +242,22 @@ int ima_read_xattr(struct dentry *dentry,
  * IMA signature version 3 disambiguates the data that is signed by
  * indirectly signing the hash of the ima_file_id structure data.
  *
+ * Signing the ima_file_id struct is currently only supported for
+ * IMA_VERITY_DIGSIG type xattrs.
+ *
  * Return 0 on success, error code otherwise.
  */
 static int calc_file_id_hash(enum evm_ima_xattr_type type,
 			     enum hash_algo algo, const u8 *digest,
 			     struct ima_max_digest_data *hash)
 {
-	struct ima_file_id file_id = {.hash_algorithm = algo};
+	struct ima_file_id file_id = {
+		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
 	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
 
+	if (type != IMA_VERITY_DIGSIG)
+		return -EINVAL;
+
 	memcpy(file_id.hash, digest, hash_digest_size[algo]);
 
 	hash->algo = algo;
@@ -264,6 +278,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	struct ima_max_digest_data hash;
 	struct signature_v2_hdr *sig;
 	int rc = -EINVAL, hash_start = 0;
 
@@ -332,6 +347,36 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		} else {
 			*status = INTEGRITY_PASS;
 		}
+		break;
+	case IMA_VERITY_DIGSIG:
+		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		sig = (typeof(sig))xattr_value;
+		if (sig->version != 3) {
+			*cause = "invalid-verity-version";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = calc_file_id_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
+				       iint->ima_hash->digest, &hash);
+		if (rc) {
+			*cause = "verity-hashing-error";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     (const char *)xattr_value,
+					     xattr_len, hash.digest,
+					     hash.length);
+		if (rc) {
+			*cause = "invalid-verity-signature";
+			*status = INTEGRITY_FAIL;
+		} else {
+			*status = INTEGRITY_PASS;
+		}
+
 		break;
 	default:
 		*status = INTEGRITY_UNKNOWN;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 44e57d7e5fed..0d4bbb4da59a 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -499,7 +499,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if (!xattr_value ||
+	    !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index ed4966d943e9..5b1aa8b7d61c 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -80,6 +80,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_VERITY_DIGSIG,
 	IMA_XATTR_LAST
 };
 
@@ -154,7 +155,9 @@ struct signature_v2_hdr {
 
 /*
  * IMA signature version 3 disambiguates the data that is signed, by
- * indirectly signing the hash of the ima_file_id structure data.
+ * indirectly signing the hash of the ima_file_id structure data,
+ * containing either the fsverity_descriptor struct digest or, in the
+ * future, the regular IMA file hash.
  *
  * (The hash of the ima_file_id structure is only of the portion used.)
  */
-- 
2.27.0

