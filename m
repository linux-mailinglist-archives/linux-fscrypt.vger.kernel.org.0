Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A4A488BCA
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbiAISzi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 13:55:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236608AbiAISzf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 13:55:35 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209DXsTL016395;
        Sun, 9 Jan 2022 18:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nu5eW348Lfv7r1a+6IWW1RnlhnYLMIm9BBL7ZzcdJnY=;
 b=IBwnlRiTODT1cq/1pR0syxE3NjvS8SNpNCrY9wfsE5RlOU3rejoTaHoItEKGYQlYPWOd
 xxZ7mjPCnGnQfXdUDLt2VoEERITVDEVxQzG9wS2+l2WcPLbt42nlCMwL3WXldB6oU9pY
 ZjSnMaNDhf+2icD0t4Q2+QRtwafIRZmOeXqJN74wvJBG7X1X6NW54tMljKJqxV57pgGH
 lXzIYy3KJIFYre8SeU+RpmArL4XH4uvwZAZTXeO2MEdO0G7O1JCEuEEqaoCpRAP6IIGx
 7rHj8E3nxEksYNfSDmW/SfyqWBKyK2qZRp7Bi8NOBnEquPBulJsZLtcYlixwC9BKQNZX 7Q== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm5rb38a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:34 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209IrZbl013991;
        Sun, 9 Jan 2022 18:55:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhhha9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:31 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209ItTDw37552538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 18:55:29 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35CA7A4059;
        Sun,  9 Jan 2022 18:55:29 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C39FA4051;
        Sun,  9 Jan 2022 18:55:28 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Jan 2022 18:55:27 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] ima: include fsverity's file digests in the IMA measurement list
Date:   Sun,  9 Jan 2022 13:55:15 -0500
Message-Id: <20220109185517.312280-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109185517.312280-1-zohar@linux.ibm.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8FvRh_pjNLFJOW9uJ1sSDYxyrwNrhcX1
X-Proofpoint-ORIG-GUID: 8FvRh_pjNLFJOW9uJ1sSDYxyrwNrhcX1
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

Allow fsverity's file digests to be included in the IMA measurement list
based on policy.

Define a new measurement policy rule option named 'digest_type=' to
allow fsverity file digests to be included in the measurement list
in the d-ng field.

Including the 'd-type' template field is recommended for unsigned
fs-verity digests to distinguish between d-ng digest types.  The
following policy rule, for example, specifies the new 'ima-ngv2'
template.

measure func=FILE_CHECK digest_type=hash|verity template=ima-ngv2

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
Comment:
- To avoid unnecessary patch churn for the proposed IMA namespacing
patch set, don't increase the iint->flags size, but include an
additional bit in the IMA_NONACTION_FLAGS.


 Documentation/ABI/testing/ima_policy      |  7 +++++
 Documentation/security/IMA-templates.rst  |  6 ++++
 security/integrity/ima/ima_api.c          | 29 +++++++++++++++--
 security/integrity/ima/ima_policy.c       | 38 ++++++++++++++++++++++-
 security/integrity/ima/ima_template_lib.c |  9 +++++-
 security/integrity/integrity.h            |  4 ++-
 6 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 839fab811b18..444bb7ccbe03 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -51,6 +51,7 @@ Description:
 			appraise_flag:= [check_blacklist]
 			Currently, blacklist check is only for files signed with appended
 			signature.
+			digest_type:= [hash|verity]
 			keyrings:= list of keyrings
 			(eg, .builtin_trusted_keys|.ima). Only valid
 			when action is "measure" and func is KEY_CHECK.
@@ -149,3 +150,9 @@ Description:
 		security.ima xattr of a file:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
+
+		Example of measure rule allowing fs-verity's digests on a
+		particular filesystem with indication of type of digest.
+
+			measure func=FILE_CHECK digest_type=hash|verity \
+				fsuuid=... template=ima-ngv2
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 1a91d92950a7..5e31513e8ec4 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -69,6 +69,7 @@ descriptors by adding their identifier to the format string
    algorithm (field format: [<hash algo>:]digest, where the digest
    prefix is shown only if the hash algorithm is not SHA1 or MD5);
  - 'd-modsig': the digest of the event without the appended modsig;
+ - 'd-type': the type of file digest (e.g. hash, verity[1]);
  - 'n-ng': the name of the event, without size limitations;
  - 'sig': the file signature, or the EVM portable signature if the file
    signature is not found;
@@ -106,3 +107,8 @@ currently the following methods are supported:
    the ``ima_template=`` parameter;
  - register a new template descriptor with custom format through the kernel
    command line parameter ``ima_template_fmt=``.
+
+
+References
+==========
+[1] Documentation/filesystems/fsverity.rst
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index a64fb0130b01..8760c4874f7d 100644
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
 
+static int ima_get_verity_digest(struct integrity_iint_cache *iint,
+				 struct ima_digest_data *hash)
+{
+	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_alg;
+	int rc;
+
+	rc = fsverity_get_digest(iint->inode, verity_digest, &verity_alg);
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
@@ -248,10 +266,17 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (buf)
+	if (buf) {
 		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
-	else
+	} else if (iint->flags & IMA_VERITY_ALLOWED) {
+		result = ima_get_verity_digest(iint, &hash.hdr);
+		if (result < 0)
+			result = ima_calc_file_hash(file, &hash.hdr);
+		else
+			iint->flags |= IMA_VERITY_DIGEST;
+	} else {
 		result = ima_calc_file_hash(file, &hash.hdr);
+	}
 
 	if (result && result != -EBADF && result != -EINVAL)
 		goto out;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a1df015934bc..29aa7a64b834 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1024,6 +1024,7 @@ enum policy_opt {
 	Opt_fowner_gt, Opt_fgroup_gt,
 	Opt_uid_lt, Opt_euid_lt, Opt_gid_lt, Opt_egid_lt,
 	Opt_fowner_lt, Opt_fgroup_lt,
+	Opt_digest_type,
 	Opt_appraise_type, Opt_appraise_flag, Opt_appraise_algos,
 	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
 	Opt_label, Opt_err
@@ -1066,6 +1067,7 @@ static const match_table_t policy_tokens = {
 	{Opt_egid_lt, "egid<%s"},
 	{Opt_fowner_lt, "fowner<%s"},
 	{Opt_fgroup_lt, "fgroup<%s"},
+	{Opt_digest_type, "digest_type=%s"},
 	{Opt_appraise_type, "appraise_type=%s"},
 	{Opt_appraise_flag, "appraise_flag=%s"},
 	{Opt_appraise_algos, "appraise_algos=%s"},
@@ -1173,6 +1175,21 @@ static void check_template_modsig(const struct ima_template_desc *template)
 #undef MSG
 }
 
+/*
+ * Make sure the policy rule and template format are in sync.
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
@@ -1215,7 +1232,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 				     IMA_INMASK | IMA_EUID | IMA_PCR |
 				     IMA_FSNAME | IMA_GID | IMA_EGID |
 				     IMA_FGROUP | IMA_DIGSIG_REQUIRED |
-				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS))
+				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS |
+				     IMA_VERITY_ALLOWED))
 			return false;
 
 		break;
@@ -1708,6 +1726,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 						   LSM_SUBJ_TYPE,
 						   AUDIT_SUBJ_TYPE);
 			break;
+		case Opt_digest_type:
+			ima_log_string(ab, "digest_type", args[0].from);
+			if ((strcmp(args[0].from, "hash|verity")) == 0)
+				entry->flags |= IMA_VERITY_ALLOWED;
+			else
+				result = -EINVAL;
+			break;
 		case Opt_appraise_type:
 			ima_log_string(ab, "appraise_type", args[0].from);
 			if ((strcmp(args[0].from, "imasig")) == 0)
@@ -1798,6 +1823,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		check_template_modsig(template_desc);
 	}
 
+	/* d-type template field recommended for unsigned fs-verity digests */
+	if (!result && entry->action == MEASURE &&
+	    entry->flags & IMA_VERITY_ALLOWED) {
+		template_desc = entry->template ? entry->template :
+						  ima_template_desc_current();
+		check_template_field(template_desc, "d-type",
+				     "verity rules should include d-type");
+	}
+
 	audit_log_format(ab, "res=%d", !result);
 	audit_log_end(ab);
 	return result;
@@ -2147,6 +2181,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 		else
 			seq_puts(m, "appraise_type=imasig ");
 	}
+	if (entry->flags & IMA_VERITY_ALLOWED)
+		seq_puts(m, "digest_type=hash|verity ");
 	if (entry->flags & IMA_CHECK_BLACKLIST)
 		seq_puts(m, "appraise_flag=check_blacklist ");
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index fb23bde297f1..1c0cea2b805f 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -392,7 +392,14 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 int ima_eventdigest_type_init(struct ima_event_data *event_data,
 			      struct ima_field_data *field_data)
 {
-	static const char * const digest_type[] = {"hash"};
+	static const char * const digest_type[] = {"hash", "verity"};
+
+	if (event_data->iint->flags & IMA_VERITY_DIGEST) {
+		return ima_write_template_field_data(digest_type[1],
+						     strlen(digest_type[1]),
+						     DATA_FMT_STRING,
+						     field_data);
+	}
 
 	return ima_write_template_field_data(digest_type[0],
 					     strlen(digest_type[0]),
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d045dccd415a..e7ac1086d1d9 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -31,7 +31,7 @@
 #define IMA_HASHED		0x00000200
 
 /* iint policy rule cache flags */
-#define IMA_NONACTION_FLAGS	0xff000000
+#define IMA_NONACTION_FLAGS	0xff800000
 #define IMA_DIGSIG_REQUIRED	0x01000000
 #define IMA_PERMIT_DIRECTIO	0x02000000
 #define IMA_NEW_FILE		0x04000000
@@ -39,6 +39,8 @@
 #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
 #define IMA_MODSIG_ALLOWED	0x20000000
 #define IMA_CHECK_BLACKLIST	0x40000000
+#define IMA_VERITY_ALLOWED	0x80000000
+#define IMA_VERITY_DIGEST	0x00800000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)
-- 
2.27.0

