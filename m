Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322884E7C21
	for <lists+linux-fscrypt@lfdr.de>; Sat, 26 Mar 2022 01:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbiCYWki (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Mar 2022 18:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiCYWke (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Mar 2022 18:40:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B55F197F90;
        Fri, 25 Mar 2022 15:38:59 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PMHVQZ018879;
        Fri, 25 Mar 2022 22:38:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uxNdkudvJDPqrzHUZ4EkewfMuuigKb6zJK6bktrZaP4=;
 b=RF+y+Uspd9sYHiozOquTTvYLzD4lmTb2yGEk1GlY2KGYHk+WaXDE5kp9QooKA+LmVo0Y
 UZSTmPJqU3dq7xTyaHexVMZpRsZuV9C7UZeK/kDQR6QxoA+QoUD+VQugoYp3fzCc8yry
 YRrlurPtu6mvzNUPu2skg5J+uxBdQe/Ijyl3noLipru8zFAo6PrvO/YDBGRgRPq7B4BW
 QlT4oltJoAC3R/Ha5qEBJAYmTjkaXeLqatllvA6M2pwfEo7mc917bdkaGGGUrlLysVEV
 Iy+qY1H73Ci9OX3CYKI7MSs6aR9CCiqduwLATiL7+guXY+pjrS3D+E/F7NT9UgRD0enq 9g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kaxd4bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:55 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PMXorK006026;
        Fri, 25 Mar 2022 22:38:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej64cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PMcoeU49021268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 22:38:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A38C1A4054;
        Fri, 25 Mar 2022 22:38:50 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97C3CA405B;
        Fri, 25 Mar 2022 22:38:49 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.52])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 22:38:49 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/5] ima: support fs-verity file digest based version 3 signatures
Date:   Fri, 25 Mar 2022 18:38:23 -0400
Message-Id: <20220325223824.310119-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220325223824.310119-1-zohar@linux.ibm.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MwjC4LtfzbJ3aKBKHSI6gBwWJtnYIW_p
X-Proofpoint-GUID: MwjC4LtfzbJ3aKBKHSI6gBwWJtnYIW_p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_08,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

IMA may verify a file's integrity against a "good" value stored in the
'security.ima' xattr or as an appended signature, based on policy.  When
the "good value" is stored in the xattr, the xattr may contain a file
hash or signature.  In either case, the "good" value is preceded by a
header.  The first byte of the xattr header indicates the type of data
- hash, signature - stored in the xattr.  To support storing fs-verity
signatures in the 'security.ima' xattr requires further differentiating
the fs-verity signature from the existing IMA signature.

In addition the signatures stored in 'security.ima' xattr, need to be
disambiguated.  Instead of directly signing the fs-verity digest, a new
signature version 3 is defined as the hash of the ima_file_id structure,
which identifies the type of signature and the digest.

The IMA policy defines "which" files are to be measured, verified, and/or
audited.  For those files being verified, the policy rules indicate "how"
the file should be verified.  For example to require a file be signed,
the appraise policy rule must include the 'appraise_type' option.

	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
           where 'imasig' is the original or v2 signature (default),
           where 'modsig' is an appended signature,
           where 'sigv3' is the signature v3 format.

The policy rule must also indicate the type of signature, if not the IMA
default, by specifying the digest type:

	digest_type:= [verity]

The following policy rule requires fsverity signatures.  The rule may be
constrained, for example, based on a fsuuid or LSM label.

      appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      |  27 ++++-
 Documentation/security/IMA-templates.rst  |   4 +-
 security/integrity/digsig.c               |   3 +-
 security/integrity/ima/ima_appraise.c     | 114 +++++++++++++++++++++-
 security/integrity/ima/ima_policy.c       |  30 +++++-
 security/integrity/ima/ima_template_lib.c |   4 +-
 security/integrity/integrity.h            |  23 ++++-
 7 files changed, 190 insertions(+), 15 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 2e0c501ce9c8..acd17183ad8c 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -47,7 +47,11 @@ Description:
 			fgroup:= decimal value
 		  lsm:  are LSM specific
 		  option:
-			appraise_type:= [imasig] [imasig|modsig]
+			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
+			    where 'imasig' is the original or v2 signature,
+			    where 'modsig' is an appended signature,
+			    where 'sigv3' is the IMA v3 signature.
+
 			appraise_flag:= [check_blacklist]
 			Currently, blacklist check is only for files signed with appended
 			signature.
@@ -158,3 +162,24 @@ Description:
 
 			measure func=FILE_CHECK digest_type=verity \
 				template=ima-ngv2
+
+		Example of 'measure' and 'appraise' rules requiring fs-verity
+		signatures (version 3) stored in security.ima xattr.
+
+		The 'measure' rule specifies the 'ima-sigv2' template option,
+		which includes the indication of type of digest and the file
+		signature in the measurement list.
+
+			measure func=BPRM_CHECK digest_type=verity \
+				template=ima-sigv2
+
+
+		The 'appraise' rule specifies the type and signature version
+		(sigv3) required.
+
+			appraise func=BPRM_CHECK digest_type=verity \
+				appraise_type=sigv3
+
+		All of these policy rules could, for example, be constrained
+		either based on a filesystem's UUID (fsuuid) or based on LSM
+		labels.
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 2d4789dc7750..06cddcd510da 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -73,8 +73,8 @@ descriptors by adding their identifier to the format string
         where the digest type is either "ima" or "verity".
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature, or the EVM portable signature if the file
-   signature is not found;
+ - 'sig': the file signature, based on either the file's/fsverity's digest[1],
+   or the EVM portable signature, if 'security.ima' contains a file hash.
  - 'modsig' the appended file signature;
  - 'buf': the buffer data that was used to generate the hash without size limitations;
  - 'evmsig': the EVM portable signature;
diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
index 3b06a01bd0fd..56472bc8e44c 100644
--- a/security/integrity/digsig.c
+++ b/security/integrity/digsig.c
@@ -74,7 +74,8 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
 		/* v1 API expect signature without xattr type */
 		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
 				     digestlen);
-	case 2:
+	case 2: /* regular file data hash based signature */
+	case 3: /* struct ima_file_id data base signature */
 		return asymmetric_verify(keyring, sig, siglen, digest,
 					 digestlen);
 	}
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 17232bbfb9f9..e76d88b309a2 100644
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
@@ -225,6 +232,40 @@ int ima_read_xattr(struct dentry *dentry,
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
+ * Signing the ima_file_id struct is currently only supported for
+ * IMA_VERITY_DIGSIG type xattrs.
+ *
+ * Return 0 on success, error code otherwise.
+ */
+static int calc_file_id_hash(enum evm_ima_xattr_type type,
+			     enum hash_algo algo, const u8 *digest,
+			     struct ima_digest_data *hash)
+{
+	struct ima_file_id file_id = {
+		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
+	uint unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
+
+	if (type != IMA_VERITY_DIGSIG)
+		return -EINVAL;
+
+	memcpy(file_id.hash, digest, hash_digest_size[algo]);
+
+	hash->algo = algo;
+	hash->length = hash_digest_size[algo];
+
+	return ima_calc_buffer_hash(&file_id, sizeof(file_id) - unused, hash);
+}
+
 /*
  * xattr_verify - verify xattr digest or signature
  *
@@ -236,7 +277,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	struct ima_max_digest_data hash;
+	struct signature_v2_hdr *sig;
 	int rc = -EINVAL, hash_start = 0;
+	int mask;
 
 	switch (xattr_value->type) {
 	case IMA_XATTR_DIGEST_NG:
@@ -246,7 +290,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
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
@@ -274,6 +321,20 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
+
+		mask = IMA_DIGSIG_REQUIRED | IMA_VERITY_REQUIRED;
+		if ((iint->flags & mask) == mask) {
+			*cause = "verity-signature-required";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
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
@@ -296,6 +357,44 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
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
+				       iint->ima_hash->digest, &hash.hdr);
+		if (rc) {
+			*cause = "sigv3-hashing-error";
+			*status = INTEGRITY_FAIL;
+			break;
+		}
+
+		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+					     (const char *)xattr_value,
+					     xattr_len, hash.digest,
+					     hash.hdr.length);
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
@@ -396,8 +495,15 @@ int ima_appraise_measurement(enum ima_hooks func,
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
index c6b0454b2e25..fbdea5c0cdc6 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1311,6 +1311,16 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 	    !(entry->flags & IMA_MODSIG_ALLOWED))
 		return false;
 
+	/*
+	 * To avoid 'appraise_type=sigv3' and 'digest_type=verity' ordering
+	 * requirements, ensure both have been specified for file verity
+	 * signatures.
+	 */
+	if (entry->action == APPRAISE &&
+	    (entry->flags & IMA_VERITY_REQUIRED) &&
+	    !(entry->flags & IMA_DIGSIG_REQUIRED))
+		return false;
+
 	return true;
 }
 
@@ -1735,14 +1745,24 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			break;
 		case Opt_appraise_type:
 			ima_log_string(ab, "appraise_type", args[0].from);
-			if ((strcmp(args[0].from, "imasig")) == 0)
+			if ((strcmp(args[0].from, "imasig")) == 0) {
 				entry->flags |= IMA_DIGSIG_REQUIRED;
-			else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
-				 strcmp(args[0].from, "imasig|modsig") == 0)
+			} else if (strcmp(args[0].from, "sigv3") == 0) {
+				/*
+				 * Only fsverity supports sigv3 for now.
+				 * No need to define a new flag.
+				 */
+				if (entry->flags & IMA_VERITY_REQUIRED)
+					entry->flags |= IMA_DIGSIG_REQUIRED;
+				else
+					result = -EINVAL;
+			} else if (IS_ENABLED(CONFIG_IMA_APPRAISE_MODSIG) &&
+				 strcmp(args[0].from, "imasig|modsig") == 0) {
 				entry->flags |= IMA_DIGSIG_REQUIRED |
 						IMA_MODSIG_ALLOWED;
-			else
+			} else {
 				result = -EINVAL;
+			}
 			break;
 		case Opt_appraise_flag:
 			ima_log_string(ab, "appraise_flag", args[0].from);
@@ -2186,6 +2206,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 	if (entry->flags & IMA_DIGSIG_REQUIRED) {
 		if (entry->flags & IMA_MODSIG_ALLOWED)
 			seq_puts(m, "appraise_type=imasig|modsig ");
+		else if (entry->flags & IMA_VERITY_REQUIRED)
+			seq_puts(m, "appraise_type=sigv3 ");
 		else
 			seq_puts(m, "appraise_type=imasig ");
 	}
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 590b32b4eedd..5e6bebd7ee2b 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -539,7 +539,9 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if (!xattr_value ||
+	    (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
+	     xattr_value->type != IMA_VERITY_DIGSIG))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d42a01903f08..44418f0ec0ab 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -79,6 +79,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_VERITY_DIGSIG,
 	IMA_XATTR_LAST
 };
 
@@ -93,7 +94,7 @@ struct evm_xattr {
 	u8 digest[SHA1_DIGEST_SIZE];
 } __packed;
 
-#define IMA_MAX_DIGEST_SIZE	64
+#define IMA_MAX_DIGEST_SIZE	HASH_MAX_DIGESTSIZE
 
 struct ima_digest_data {
 	u8 algo;
@@ -122,7 +123,11 @@ struct ima_max_digest_data {
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
@@ -133,6 +138,20 @@ struct signature_v2_hdr {
 	uint8_t sig[];		/* signature payload */
 } __packed;
 
+/*
+ * IMA signature version 3 disambiguates the data that is signed, by
+ * indirectly signing the hash of the ima_file_id structure data,
+ * containing either the fsverity_descriptor struct digest or, in the
+ * future, the regular IMA file hash.
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

