Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C73488BD1
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 19:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbiAISzk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 13:55:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36162 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236611AbiAISzg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 13:55:36 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209EYONg017065;
        Sun, 9 Jan 2022 18:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9toffhtVXIbOj8Kz5TdIttbfb0Q+TcpRB3r/3EU2XW4=;
 b=EmNFHth8ohxDwUguSnEolG/s19Z0K7eI0tJekHEZ+YCGitdEOAjEtDoo54Hh9XUouBTz
 thAJQ4Zs2XpQWZTVAQDYTbCVvFagTiJNSgfZ07wLG/jUGnc8zZ4+yF/gkMNRBraouxVt
 VAUi0u0BCKkxv7AqAsFvTNfwWC3UM8JKuCymm+zmuqL+Db+AJpXXCvPDre5sjwCM3F8w
 SOOVHjF0kL2rArqe156uibpRub47SlvG/FFAyA25S3Gv0qM6LmvLNhGCno+6T82T1TKs
 dwPyWIQbS6IvCm+iFdIK5A6uZ8kXeMu79C/UsXTSritqCkll0VJcsZrXgU7bJez7F1rR aQ== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm5rb38e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:35 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209Is6KJ028205;
        Sun, 9 Jan 2022 18:55:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3df288xjs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:32 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209ItUjW41091508
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 18:55:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B7F3A404D;
        Sun,  9 Jan 2022 18:55:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65426A4051;
        Sun,  9 Jan 2022 18:55:29 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Jan 2022 18:55:29 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] ima: support fs-verity file digest based signatures
Date:   Sun,  9 Jan 2022 13:55:16 -0500
Message-Id: <20220109185517.312280-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109185517.312280-1-zohar@linux.ibm.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SbON_Ho9zS34kKm9dNVqpXFJxTfmCTKx
X-Proofpoint-ORIG-GUID: SbON_Ho9zS34kKm9dNVqpXFJxTfmCTKx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-09_08,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201090135
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of calculating a file hash and verifying the signature stored
in the security.ima xattr against the calculated file hash, verify the
signature based on a hash of fs-verity's file digest and the digest's
metadata.

To differentiate between a regular file hash and an fs-verity file digest
based signature stored as security.ima xattr, define a new signature type
named IMA_VERITY_DIGSIG.

The hash format of fs-verity's file digest and the digest's metadata to
be signed is defined as a structure named "ima_tbs_hash".

Update the 'ima-sig' template field to display the new fs-verity signature
type as well.

For example:
  appraise func=BPRM_CHECK digest_type=hash|verity

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 10 +++
 Documentation/security/IMA-templates.rst  |  4 +-
 include/uapi/linux/ima.h                  | 26 ++++++++
 security/integrity/ima/ima_appraise.c     | 81 +++++++++++++++++++++++
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  1 +
 6 files changed, 122 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/ima.h

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
diff --git a/include/uapi/linux/ima.h b/include/uapi/linux/ima.h
new file mode 100644
index 000000000000..6a2a68fc0fad
--- /dev/null
+++ b/include/uapi/linux/ima.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+/*
+ * IMA user API
+ *
+ */
+#ifndef _UAPI_LINUX_IMA_H
+#define _UAPI_LINUX_IMA_H
+
+#include <linux/types.h>
+
+/*
+ * The hash format of fs-verity's file digest and other file metadata
+ * to be signed.  The resulting signature is stored as a security.ima
+ * xattr.
+ *
+ * "type" is defined as IMA_VERITY_DIGSIG
+ * "algo" is the hash_algo enum of fs-verity's file digest
+ * (e.g. HASH_ALGO_SHA256, HASH_ALGO_SHA512).
+ */
+struct ima_tbs_hash {
+	__u8 type;        /* xattr type [enum evm_ima_xattr_type] */
+	__u8 algo;        /* Digest algorithm [enum hash_algo] */
+	__u8 digest[];    /* fs-verity digest */
+};
+
+#endif /* _UAPI_LINUX_IMA_H */
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index dbba51583e7c..4e092c189ed0 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -13,7 +13,10 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <linux/fsverity.h>
 #include <keys/system_keyring.h>
+#include <uapi/linux/fsverity.h>
+#include <uapi/linux/ima.h>
 
 #include "ima.h"
 
@@ -183,6 +186,8 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 		return ima_hash_algo;
 
 	switch (xattr_value->type) {
+	case IMA_VERITY_DIGSIG:
+		fallthrough;
 	case EVM_IMA_XATTR_DIGSIG:
 		sig = (typeof(sig))xattr_value;
 		if (sig->version != 2 || xattr_len <= sizeof(*sig)
@@ -225,6 +230,47 @@ int ima_read_xattr(struct dentry *dentry,
 	return ret;
 }
 
+/*
+ * calc_tbs_hash - calculate hash of a digest and digest metadata
+ * @type: signature type [IMA_VERITY_DIGSIG]
+ * @algo: hash algorithm [enum hash_algo]
+ * @digest: pointer to the digest to be hashed
+ * @hash: (out) pointer to the hash
+ *
+ * The IMA signature is a signature over the hash of fs-verity's file digest
+ * with other digest metadata, not just fs-verity's file digest. Calculate
+ * the to be signed hash.
+ *
+ * Return 0 on success, error code otherwise.
+ */
+static int calc_tbs_hash(enum evm_ima_xattr_type xattr_type,
+			 enum hash_algo algo, const u8 *digest,
+			 struct ima_digest_data *hash)
+{
+	struct ima_tbs_hash *tbs_h;
+	int rc = 0;
+
+	if (xattr_type != IMA_VERITY_DIGSIG)
+		return -EINVAL;
+
+	tbs_h = kzalloc(sizeof(*tbs_h) + hash_digest_size[algo], GFP_KERNEL);
+	if (!tbs_h)
+		return -ENOMEM;
+
+	tbs_h->type = xattr_type;
+	tbs_h->algo = algo;
+	memcpy(tbs_h->digest, digest, hash_digest_size[algo]);
+
+	hash->algo = algo;
+	hash->length = hash_digest_size[algo];
+
+	rc = ima_calc_buffer_hash(tbs_h,
+				  sizeof(*tbs_h) + hash_digest_size[algo],
+				  hash);
+	kfree(tbs_h);
+	return rc;
+}
+
 /*
  * xattr_verify - verify xattr digest or signature
  *
@@ -236,7 +282,9 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	struct ima_digest_data *hash = NULL;
 	int rc = -EINVAL, hash_start = 0;
+	u8 algo;  /* Digest algorithm [enum hash_algo] */
 
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST_NG:
@@ -271,6 +319,38 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			break;
 		}
 		*status = INTEGRITY_PASS;
+		break;
+	case IMA_VERITY_DIGSIG:
+		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		algo = iint->ima_hash->algo;
+		hash = kzalloc(sizeof(*hash) + hash_digest_size[algo],
+			       GFP_KERNEL);
+		if (!hash) {
+			*cause = "verity-hashing-error";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = calc_tbs_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
+				   iint->ima_hash->digest, hash);
+		if (rc) {
+			*cause = "verity-hashing-error";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     (const char *)xattr_value,
+					     xattr_len, hash->digest,
+					     hash->length);
+		if (rc) {
+			*cause = "invalid-verity-signature";
+			*status = INTEGRITY_FAIL;
+		} else {
+			*status = INTEGRITY_PASS;
+		}
+
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
@@ -303,6 +383,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		break;
 	}
 
+	kfree(hash);
 	return rc;
 }
 
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 1c0cea2b805f..31a14943e459 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -498,7 +498,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if ((!xattr_value) ||
+	     !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index e7ac1086d1d9..51124708c072 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -79,6 +79,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_VERITY_DIGSIG,
 	IMA_XATTR_LAST
 };
 
-- 
2.27.0

