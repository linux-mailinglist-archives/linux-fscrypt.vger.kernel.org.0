Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E784B2F9F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Feb 2022 22:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353843AbiBKVnw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Feb 2022 16:43:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353826AbiBKVnm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Feb 2022 16:43:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3AFC62;
        Fri, 11 Feb 2022 13:43:40 -0800 (PST)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BLB7cS022647;
        Fri, 11 Feb 2022 21:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=86gyvodLhKJ9hhGwTwa2MXRDv6rVFIm3jTl4U3ebThE=;
 b=o38RxcMo0ZfD09ILCnumJnFVC+qhcCyvwmT8P0FtZebnS1nmaPzX2dphTEXwV24dzB/3
 ohkS38uyo9XjBOVb1vmb92kQRvswkuS4ks1NG+COIU34HLwb/khdEnQPMX42yNaLpqNJ
 Mawn7guba7hJCPIIXkIaBwxwzCsdmY7Ff25+mRoEIGxeKePq70kj0peD7Nl3pWD9SdYs
 hdxBhZg5u1LvzGA9Lh+DLAnLtzmnO2MbFzgLI8x/W+0tiIPjsY9g+SpWkc4kwdET7N+U
 h2tY1AA7CyRBZxgL85RYVKq4IrIsmqWNYb7AhURKte2JRSBBA+c48wpmheOU1xZH47/S Mw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e5t14fqyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:37 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BLYPbc005736;
        Fri, 11 Feb 2022 21:43:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggkw71x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BLhV6j47776128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:43:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C391D52050;
        Fri, 11 Feb 2022 21:43:31 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D1E465204F;
        Fri, 11 Feb 2022 21:43:30 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/8] ima: support fs-verity file digest based version 3 signatures
Date:   Fri, 11 Feb 2022 16:43:09 -0500
Message-Id: <20220211214310.119257-8-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220211214310.119257-1-zohar@linux.ibm.com>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hAnTTY2nmi-lGLq3DVHAW9608vnPW8RG
X-Proofpoint-GUID: hAnTTY2nmi-lGLq3DVHAW9608vnPW8RG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 impostorscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110108
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

The policy rule 'appraise_type=' option is extended to support 'sigv3',
which is initiality limited to fs-verity.

The fs-verity 'appraise' rules are identified by the 'digest-type=verity'
option and require the 'appraise_type=sigv3' option.  The following
'appraise' policy rule requires fsverity file digests.  (The rule may be
constrained, for example based on a fsuuid or LSM label.)

Basic fs-verity policy rule example:
  appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3

Lastly, for IMA to differentiate between the original IMA signature
from an fs-verity signature a new 'xattr_type' named IMA_VERITY_DIGSIG
is defined.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 28 ++++++--
 Documentation/security/IMA-templates.rst  |  4 +-
 security/integrity/ima/ima_appraise.c     | 79 +++++++++++++++++++++--
 security/integrity/ima/ima_policy.c       | 26 ++++++--
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  5 +-
 6 files changed, 127 insertions(+), 18 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index ff3c906738cb..508053b8dd0a 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -47,7 +47,7 @@ Description:
 			fgroup:= decimal value
 		  lsm:  are LSM specific
 		  option:
-			appraise_type:= [imasig] [imasig|modsig]
+			appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
 			appraise_flag:= [check_blacklist]
 			Currently, blacklist check is only for files signed with appended
 			signature.
@@ -153,9 +153,27 @@ Description:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
 
-		Example of 'measure' rule requiring fs-verity's digests on a
-		particular filesystem with indication of type of digest in
-		the measurement list.
+		Example of a 'measure' rule requiring fs-verity's digests
+		with indication of type of digest in the measurement list.
 
 			measure func=FILE_CHECK digest_type=verity \
-				fsuuid=... template=ima-ngv2
+				template=ima-ngv2
+
+		Example of 'measure' and 'appraise' rules requiring fs-verity
+		signatures (version 3) stored in security.ima xattr.
+
+		The 'measure' rule specifies the 'ima-sig' template option,
+		which includes the file signature in the measurement list.
+
+			measure func=BPRM_CHECK digest_type=verity \
+				template=ima-sig
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
index c2b429c141a7..71e27dba01ab 100644
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
 			     struct ima_digest_data *hash)
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
@@ -263,6 +277,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 			struct evm_ima_xattr_data *xattr_value, int xattr_len,
 			enum integrity_status *status, const char **cause)
 {
+	struct ima_max_digest_data hash;
 	struct signature_v2_hdr *sig;
 	int rc = -EINVAL, hash_start = 0;
 
@@ -274,7 +289,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
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
@@ -303,6 +321,12 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
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
@@ -331,6 +355,44 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
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
@@ -431,8 +493,15 @@ int ima_appraise_measurement(enum ima_hooks func,
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
index 28aca1f9633b..d3006cc22ab1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1311,6 +1311,12 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 	    !(entry->flags & IMA_MODSIG_ALLOWED))
 		return false;
 
+	/* Ensure APPRAISE verity file implies a v3 signature */
+	if (entry->action == APPRAISE &&
+	    (entry->flags & IMA_VERITY_REQUIRED) &&
+	    !(entry->flags & IMA_DIGSIG_REQUIRED))
+		return false;
+
 	return true;
 }
 
@@ -1735,14 +1741,24 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
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
@@ -2186,6 +2202,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 	if (entry->flags & IMA_DIGSIG_REQUIRED) {
 		if (entry->flags & IMA_MODSIG_ALLOWED)
 			seq_puts(m, "appraise_type=imasig|modsig ");
+		else if (entry->flags & IMA_VERITY_REQUIRED)
+			seq_puts(m, "appraise_type=sigv3 ");
 		else
 			seq_puts(m, "appraise_type=imasig ");
 	}
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index d370fca04de4..ecbe61c53d40 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -495,7 +495,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if (!xattr_value ||
+	    !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index bd38bd451b19..b3267384c028 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -80,6 +80,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_VERITY_DIGSIG,
 	IMA_XATTR_LAST
 };
 
@@ -140,7 +141,9 @@ struct signature_v2_hdr {
 
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

