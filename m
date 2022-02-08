Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4AB54ACE33
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbiBHBsI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344937AbiBHBmb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBF7C061355;
        Mon,  7 Feb 2022 17:42:29 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217M0Zp1023002;
        Tue, 8 Feb 2022 01:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=weP/7A1pYJpzDNjvvzmEj/1Rdn+84YPS1WHgAZB+5NM=;
 b=hdykv4TrjH0NTzgej1ZYI0xZZ8VeKIpUq1E2EI5QvIPl9dAEZLOLWvuXQO7++X27IsKe
 8FODFK1G7GRswyjjUlQt2FiE5xMU71/dc6a6LbXjqSv+pQyBjtDu+Dq8aESsbzoDVSiT
 Zj9eeQRrmAjarc+i+WMY3PXVYkUidkecamHmHCVKO1mNE3TI8YRl/IJmguk9jS5haOfY
 SLFDcSSW63m240ctRM7NTsNdt20alC4E7Lwr9shjY18nDPeNwpRz1OmfBn6x057DT/9u
 Cx+2Oj8hucvV2ZB9wKzq3rIX732KOM3mDVe0BjgMw0ISTIcaK4zTwQAyBavmbOl6+OFJ yA== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22kqcdv9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:26 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181Wjbi025016;
        Tue, 8 Feb 2022 01:42:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygpyh6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:24 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gL0s38273280
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:21 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 955D0A4065;
        Tue,  8 Feb 2022 01:42:21 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C5FEA406D;
        Tue,  8 Feb 2022 01:42:20 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:20 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 7/8] ima: support fs-verity file digest based version 3 signatures
Date:   Mon,  7 Feb 2022 20:41:39 -0500
Message-Id: <20220208014140.483447-8-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ykc3RaG6kL8uKNknPTGGBZSlJQduBDv6
X-Proofpoint-ORIG-GUID: Ykc3RaG6kL8uKNknPTGGBZSlJQduBDv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of calculating a regular file hash and verifying the signature
stored in the 'security.ima' xattr against the calculated file hash, get
fs-verity's file digest and verify the signature (version 3) stored in
'security.ima' against the digest.

To differentiate between IMA's and fs-verity's signatures, define a
new signature type named 'IMA_VERITY_DIGSIG'.

Update the 'ima-sig' template field to also display the new fs-verity
signature type.

To prevent abuse of the different signature formats, policy rules must be
limited to a specific signature version.  The following 'appraise' policy
rule requires fsverity file digests (signature v3).  The policy rule may
be constrained, for example based on a fsuuid or LSM label.

Basic fs-verity policy rule example:
  appraise func=BPRM_CHECK digest_type=verity

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 12 ++++
 Documentation/security/IMA-templates.rst  |  4 +-
 security/integrity/ima/ima_appraise.c     | 79 +++++++++++++++++++++--
 security/integrity/ima/ima_policy.c       |  9 ++-
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  5 +-
 6 files changed, 100 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index ff3c906738cb..aabbb206098d 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -159,3 +159,15 @@ Description:
 
 			measure func=FILE_CHECK digest_type=verity \
 				fsuuid=... template=ima-ngv2
+
+		Example of 'measure' and 'appraise' rules requiring fs-verity
+		signatures (version 3) stored in security.ima xattr. The
+		'ima-sig' template option includes the signature in the
+		measurement list.  The 'appraise' rule verifies the signature.
+		These policy rules are limited to a particular filesystem
+		based on its fsuuid.
+
+			measure func=BPRM_CHECK digest_type=verity \
+				fsuuid=... template=ima-sig
+			appraise func=BPRM_CHECK digest_type=verity \
+				fsuuid=...
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 1e3fe986764e..fe9bc2595fa2 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -72,8 +72,8 @@ descriptors by adding their identifier to the format string
  - 'd-type': differentiate between fs-verity's Merkle tree based file hash
    from a regular IMA file hash measurement.
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature, or the EVM portable signature if the file
-   signature is not found;
+ - 'sig': the file signature, based on either the file's/fsverity's digest[1],
+   or the EVM portable signature if the file signature is not found;
  - 'modsig' the appended file signature;
  - 'buf': the buffer data that was used to generate the hash without size limitations;
  - 'evmsig': the EVM portable signature;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 7bc180bd808e..98f2ef99afc0 100644
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
 
@@ -275,7 +290,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 	case IMA_XATTR_DIGEST:
 		if (*status != INTEGRITY_PASS_IMMUTABLE) {
 			if (iint->flags & IMA_DIGSIG_REQUIRED) {
-				*cause = "IMA-signature-required";
+				if (iint->flags & IMA_VERITY_REQUIRED)
+					*cause = "verity-signature-required";
+				else
+					*cause = "IMA-signature-required";
 				*status = INTEGRITY_FAIL;
 				break;
 			}
@@ -304,6 +322,12 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
 
+		if (iint->flags & (IMA_DIGSIG_REQUIRED | IMA_VERITY_REQUIRED)) {
+			*cause = "verity-signature-required";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
 		sig = (typeof(sig))xattr_value;
 		if (sig->version != 2) {
 			*cause = "invalid-signature-version";
@@ -332,6 +356,44 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		} else {
 			*status = INTEGRITY_PASS;
 		}
+		break;
+	case IMA_VERITY_DIGSIG:
+		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+			if (!(iint->flags & IMA_VERITY_REQUIRED)) {
+				*cause = "IMA-signature-required";
+				*status = INTEGRITY_FAIL;
+				break;
+			}
+		}
+
+		sig = (typeof(sig))xattr_value;
+		if (sig->version != 3) {
+			*cause = "invalid-signature-version";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = calc_file_id_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
+				       iint->ima_hash->digest, &hash);
+		if (rc) {
+			*cause = "sigv3-hashing-error";
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
@@ -432,8 +494,15 @@ int ima_appraise_measurement(enum ima_hooks func,
 		if (rc && rc != -ENODATA)
 			goto out;
 
-		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
-				"IMA-signature-required" : "missing-hash";
+		if (iint->flags & IMA_DIGSIG_REQUIRED) {
+			if (iint->flags & IMA_VERITY_REQUIRED)
+				cause = "verity-signature-required";
+			else
+				cause = "IMA-signature-required";
+		} else {
+			cause = "missing-hash";
+		}
+
 		status = INTEGRITY_NOLABEL;
 		if (file->f_mode & FMODE_CREATED)
 			iint->flags |= IMA_NEW_FILE;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 28aca1f9633b..576cbe790e27 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1728,10 +1728,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			break;
 		case Opt_digest_type:
 			ima_log_string(ab, "digest_type", args[0].from);
-			if ((strcmp(args[0].from, "verity")) == 0)
+			if ((strcmp(args[0].from, "verity")) == 0) {
 				entry->flags |= IMA_VERITY_REQUIRED;
-			else
+				if (entry->action == APPRAISE)
+					entry->flags |= IMA_DIGSIG_REQUIRED;
+			} else {
 				result = -EINVAL;
+			}
 			break;
 		case Opt_appraise_type:
 			ima_log_string(ab, "appraise_type", args[0].from);
@@ -2186,7 +2189,7 @@ int ima_policy_show(struct seq_file *m, void *v)
 	if (entry->flags & IMA_DIGSIG_REQUIRED) {
 		if (entry->flags & IMA_MODSIG_ALLOWED)
 			seq_puts(m, "appraise_type=imasig|modsig ");
-		else
+		else if (!(entry->flags & IMA_VERITY_REQUIRED))
 			seq_puts(m, "appraise_type=imasig ");
 	}
 	if (entry->flags & IMA_VERITY_REQUIRED)
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 31573b4c7763..8f789ee4383e 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -498,7 +498,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if (!xattr_value ||
+	    !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index f59f83527c0c..df68f291fbf0 100644
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

