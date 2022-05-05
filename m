Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011AC51BF62
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 14:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376901AbiEEMfx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 08:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376834AbiEEMfs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 08:35:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC145534C;
        Thu,  5 May 2022 05:32:08 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245BifB0014133;
        Thu, 5 May 2022 12:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9j2ZEww4RNDuuZ1dfZy2aHlthnB0djSUyEVAown+m5g=;
 b=iwM6SYSGrrBAfFaw7bOiTjcCzCR9S3z4uQuCr+2gzuWwf0u6tJKDAWgW4tORS+06t1pc
 BEsyzgRHjB911gsHJkjM+5k8xzqEh03QHXdJ7t/VlyMNCWdv5mTDCQHbtzisM0fszpIF
 M3WzcBVV0HpH7WkVoZBwUji/sQ1NIdc0570WRomZNYRBcQCJnahaQo2zZMyiv60IR1OL
 UsZcDsDrPq5bTDBGxqcu7TSiKStZYSukOozaCJ0b5kPzpyjVSbgm4bFpfFCX67Z3f+GL
 01tubOfMWkrXR+PmDr6OTBnXCgVOGxamsOxjadFQRDPM1KpvfTEANK+fClyAV5qEWm+f 0g== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdys8w9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:06 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CTHEf006145;
        Thu, 5 May 2022 12:32:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3fuxwkrwk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CW0Le30212488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:32:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19E9D4C04A;
        Thu,  5 May 2022 12:32:00 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F16B04C040;
        Thu,  5 May 2022 12:31:58 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.81.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:31:58 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 5/7] ima: permit fsverity's file digests in the IMA measurement list
Date:   Thu,  5 May 2022 08:31:39 -0400
Message-Id: <20220505123141.1599622-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220505123141.1599622-1-zohar@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MjZkaTXpuHMRanwSVDpYVlzxR4aQlGQu
X-Proofpoint-ORIG-GUID: MjZkaTXpuHMRanwSVDpYVlzxR4aQlGQu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205050091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Permit fsverity's file digest (a hash of struct fsverity_descriptor) to
be included in the IMA measurement list, based on the new measurement
policy rule 'digest_type=verity' option.

To differentiate between a regular IMA file hash from an fsverity's
file digest, use the new d-ngv2 format field included in the ima-ngv2
template.

The following policy rule requires fsverity file digests and specifies
the new 'ima-ngv2' template, which contains the new 'd-ngv2' field.  The
policy rule may be constrained, for example based on a fsuuid or LSM
label.

measure func=FILE_CHECK digest_type=verity template=ima-ngv2

Acked-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 14 ++++++-
 Documentation/security/IMA-templates.rst  |  2 +-
 security/integrity/ima/ima_api.c          | 47 +++++++++++++++++++++--
 security/integrity/ima/ima_main.c         |  2 +-
 security/integrity/ima/ima_policy.c       | 38 +++++++++++++++++-
 security/integrity/ima/ima_template_lib.c | 10 +++--
 security/integrity/integrity.h            |  1 +
 7 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 839fab811b18..0a8caed393e3 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -27,8 +27,9 @@ Description:
 				[fowner=] [fgroup=]]
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
-			option:	[[appraise_type=]] [template=] [permit_directio]
-				[appraise_flag=] [appraise_algos=] [keyrings=]
+			option:	[digest_type=] [template=] [permit_directio]
+				[appraise_type=] [appraise_flag=]
+				[appraise_algos=] [keyrings=]
 		  base:
 			func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
 				[FIRMWARE_CHECK]
@@ -51,6 +52,9 @@ Description:
 			appraise_flag:= [check_blacklist]
 			Currently, blacklist check is only for files signed with appended
 			signature.
+			digest_type:= verity
+			    Require fs-verity's file digest instead of the
+			    regular IMA file hash.
 			keyrings:= list of keyrings
 			(eg, .builtin_trusted_keys|.ima). Only valid
 			when action is "measure" and func is KEY_CHECK.
@@ -149,3 +153,9 @@ Description:
 		security.ima xattr of a file:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
+
+		Example of a 'measure' rule requiring fs-verity's digests
+		with indication of type of digest in the measurement list.
+
+			measure func=FILE_CHECK digest_type=verity \
+				template=ima-ngv2
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index eafc4e34f890..09b5fac38195 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -67,7 +67,7 @@ descriptors by adding their identifier to the format string
  - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
  - 'd-ng': the digest of the event, calculated with an arbitrary hash
    algorithm (field format: <hash algo>:digest);
- - 'd-ngv2': same as d-ng, but prefixed with the "ima" digest type
+ - 'd-ngv2': same as d-ng, but prefixed with the "ima" or "verity" digest type
    (field format: <digest type>:<hash algo>:digest);
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c6805af46211..c1e76282b5ee 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/evm.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 
 #include "ima.h"
 
@@ -200,6 +201,32 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 				allowed_algos);
 }
 
+static int ima_get_verity_digest(struct integrity_iint_cache *iint,
+				 struct ima_max_digest_data *hash)
+{
+	enum hash_algo verity_alg;
+	int ret;
+
+	/*
+	 * On failure, 'measure' policy rules will result in a file data
+	 * hash containing 0's.
+	 */
+	ret = fsverity_get_digest(iint->inode, hash->digest, &verity_alg);
+	if (ret)
+		return ret;
+
+	/*
+	 * Unlike in the case of actually calculating the file hash, in
+	 * the fsverity case regardless of the hash algorithm, return
+	 * the verity digest to be included in the measurement list. A
+	 * mismatch between the verity algorithm and the xattr signature
+	 * algorithm, if one exists, will be detected later.
+	 */
+	hash->hdr.algo = verity_alg;
+	hash->hdr.length = hash_digest_size[verity_alg];
+	return 0;
+}
+
 /*
  * ima_collect_measurement - collect file measurement
  *
@@ -242,16 +269,30 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	 */
 	i_version = inode_query_iversion(inode);
 	hash.hdr.algo = algo;
+	hash.hdr.length = hash_digest_size[algo];
 
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (buf)
+	if (iint->flags & IMA_VERITY_REQUIRED) {
+		result = ima_get_verity_digest(iint, &hash);
+		switch (result) {
+		case 0:
+			break;
+		case -ENODATA:
+			audit_cause = "no-verity-digest";
+			break;
+		default:
+			audit_cause = "invalid-verity-digest";
+			break;
+		}
+	} else if (buf) {
 		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
-	else
+	} else {
 		result = ima_calc_file_hash(file, &hash.hdr);
+	}
 
-	if (result && result != -EBADF && result != -EINVAL)
+	if (result == -ENOMEM)
 		goto out;
 
 	length = sizeof(hash.hdr) + hash.hdr.length;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 1aebf63ad7a6..040b03ddc1c7 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -335,7 +335,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
 	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
-	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
+	if (rc == -ENOMEM)
 		goto out_locked;
 
 	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index eea6e92500b8..390a8faa77f9 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1023,6 +1023,7 @@ enum policy_opt {
 	Opt_fowner_gt, Opt_fgroup_gt,
 	Opt_uid_lt, Opt_euid_lt, Opt_gid_lt, Opt_egid_lt,
 	Opt_fowner_lt, Opt_fgroup_lt,
+	Opt_digest_type,
 	Opt_appraise_type, Opt_appraise_flag, Opt_appraise_algos,
 	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
 	Opt_label, Opt_err
@@ -1065,6 +1066,7 @@ static const match_table_t policy_tokens = {
 	{Opt_egid_lt, "egid<%s"},
 	{Opt_fowner_lt, "fowner<%s"},
 	{Opt_fgroup_lt, "fgroup<%s"},
+	{Opt_digest_type, "digest_type=%s"},
 	{Opt_appraise_type, "appraise_type=%s"},
 	{Opt_appraise_flag, "appraise_flag=%s"},
 	{Opt_appraise_algos, "appraise_algos=%s"},
@@ -1172,6 +1174,21 @@ static void check_template_modsig(const struct ima_template_desc *template)
 #undef MSG
 }
 
+/*
+ * Warn if the template does not contain the given field.
+ */
+static void check_template_field(const struct ima_template_desc *template,
+				 const char *field, const char *msg)
+{
+	int i;
+
+	for (i = 0; i < template->num_fields; i++)
+		if (!strcmp(template->fields[i]->field_id, field))
+			return;
+
+	pr_notice_once("%s", msg);
+}
+
 static bool ima_validate_rule(struct ima_rule_entry *entry)
 {
 	/* Ensure that the action is set and is compatible with the flags */
@@ -1214,7 +1231,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 				     IMA_INMASK | IMA_EUID | IMA_PCR |
 				     IMA_FSNAME | IMA_GID | IMA_EGID |
 				     IMA_FGROUP | IMA_DIGSIG_REQUIRED |
-				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS))
+				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS |
+				     IMA_VERITY_REQUIRED))
 			return false;
 
 		break;
@@ -1707,6 +1725,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 						   LSM_SUBJ_TYPE,
 						   AUDIT_SUBJ_TYPE);
 			break;
+		case Opt_digest_type:
+			ima_log_string(ab, "digest_type", args[0].from);
+			if ((strcmp(args[0].from, "verity")) == 0)
+				entry->flags |= IMA_VERITY_REQUIRED;
+			else
+				result = -EINVAL;
+			break;
 		case Opt_appraise_type:
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
@@ -1797,6 +1822,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		check_template_modsig(template_desc);
 	}
 
+	/* d-ngv2 template field recommended for unsigned fs-verity digests */
+	if (!result && entry->action == MEASURE &&
+	    entry->flags & IMA_VERITY_REQUIRED) {
+		template_desc = entry->template ? entry->template :
+						  ima_template_desc_current();
+		check_template_field(template_desc, "d-ngv2",
+				     "verity rules should include d-ngv2");
+	}
+
 	audit_log_format(ab, "res=%d", !result);
 	audit_log_end(ab);
 	return result;
@@ -2154,6 +2188,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 		else
 			seq_puts(m, "appraise_type=imasig ");
 	}
+	if (entry->flags & IMA_VERITY_REQUIRED)
+		seq_puts(m, "digest_type=verity ");
 	if (entry->flags & IMA_CHECK_BLACKLIST)
 		seq_puts(m, "appraise_flag=check_blacklist ");
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 8b8cf46d5b52..bea3d4044025 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -32,12 +32,14 @@ enum data_formats {
 
 enum digest_type {
 	DIGEST_TYPE_IMA,
+	DIGEST_TYPE_VERITY,
 	DIGEST_TYPE__LAST
 };
 
-#define DIGEST_TYPE_NAME_LEN_MAX 4	/* including NUL */
+#define DIGEST_TYPE_NAME_LEN_MAX 7	/* including NUL */
 static const char * const digest_type_name[DIGEST_TYPE__LAST] = {
-	[DIGEST_TYPE_IMA] = "ima"
+	[DIGEST_TYPE_IMA] = "ima",
+	[DIGEST_TYPE_VERITY] = "verity"
 };
 
 static int ima_write_template_field_data(const void *data, const u32 datalen,
@@ -297,7 +299,7 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
 	 *
 	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
 	 *      with a hash size limitation of 20 bytes,
-	 *    where <digest type> is "ima",
+	 *    where <digest type> is either "ima" or "verity",
 	 *    where <hash algo> is the hash_algo_name[] string.
 	 */
 	u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
@@ -435,6 +437,8 @@ int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
 	cur_digestsize = event_data->iint->ima_hash->length;
 
 	hash_algo = event_data->iint->ima_hash->algo;
+	if (event_data->iint->flags & IMA_VERITY_REQUIRED)
+		digest_type = DIGEST_TYPE_VERITY;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
 					   digest_type, hash_algo,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 3510e413ea17..04e2b99cd912 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -40,6 +40,7 @@
 #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
 #define IMA_MODSIG_ALLOWED	0x20000000
 #define IMA_CHECK_BLACKLIST	0x40000000
+#define IMA_VERITY_REQUIRED	0x80000000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)
-- 
2.27.0

