Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E250B4ACE27
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242934AbiBHBsD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344923AbiBHBm2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:28 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBCAC061A73;
        Mon,  7 Feb 2022 17:42:27 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217LdT0V008334;
        Tue, 8 Feb 2022 01:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0o/CVgJfjg9UmldGd/c9YXeYPfyLIotoz30uC/3rpg4=;
 b=RRSO+O94yvP+qpdXk1vE2sWZVLpB9WiVjoG1nfUN/sGhLeAEYOEqwzyAm2uCe7faIWo8
 ScBnCxOnNwfCXXYiKJNPIp6QXSl6ITqeLjIr9g92OQMlWz7L/JRrxnhL5H4vafVVPe7k
 N2foq4ADch+TJDtg8OgMi6FD9R+KjlCV77MPXHd9sUZRB6BiaLo1bQyNZP6vv4216Lsi
 yB48Vl9BEmLDqQJ4BoPbiK+rnxw/rlz6Wk5NkjkD6EkM90f134m5s0As3HyuZjLDCoUs
 krcgZVLz0lefO/4X6BecGPJh3bRNl5mrKDIutH+4hNXiBeKd/Xzi1vTp65HCCwU4fXrf uw== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e2319kt58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:24 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181Wv99010045;
        Tue, 8 Feb 2022 01:42:23 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3e1gva0mcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:22 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gJm833685862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30D8BA4059;
        Tue,  8 Feb 2022 01:42:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A1A0A4040;
        Tue,  8 Feb 2022 01:42:18 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:18 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/8] ima: permit fsverity's file digests in the IMA measurement list
Date:   Mon,  7 Feb 2022 20:41:37 -0500
Message-Id: <20220208014140.483447-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aCPdj3Ai-FMUC8n3o6Fvuc7UgzUAZPUD
X-Proofpoint-GUID: aCPdj3Ai-FMUC8n3o6Fvuc7UgzUAZPUD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 impostorscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Permit fsverity's file digest (a hash of struct fsverity_digest) to be
included in the 'd-ng' field of the IMA measurement list, based on the
new measurement policy rule 'digest_type=verity' option.

To differentiate between an unsigned regular IMA file hash and an
unsigned fsverity's file digest stored in the 'd-ng' field of the
measurement list, it is recommended to include the 'd-type' template
field.

The following policy rule requires fsverity file digests and specifies
the new 'ima-ngv2' template, which contains the new 'd-type' field.  The
policy rule may be constrained, for example based on a fsuuid or LSM
label.

measure func=FILE_CHECK digest_type=verity template=ima-ngv2

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/ABI/testing/ima_policy      | 10 ++++++
 Documentation/security/IMA-templates.rst  |  7 ++++
 security/integrity/ima/ima_api.c          | 39 +++++++++++++++++++++--
 security/integrity/ima/ima_policy.c       | 38 +++++++++++++++++++++-
 security/integrity/ima/ima_template_lib.c |  9 +++++-
 security/integrity/integrity.h            |  4 ++-
 6 files changed, 102 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 839fab811b18..ff3c906738cb 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -51,6 +51,9 @@ Description:
 			appraise_flag:= [check_blacklist]
 			Currently, blacklist check is only for files signed with appended
 			signature.
+			digest_type:= verity
+			    Require fs-verity's file digest instead of the
+			    regular IMA file hash.
 			keyrings:= list of keyrings
 			(eg, .builtin_trusted_keys|.ima). Only valid
 			when action is "measure" and func is KEY_CHECK.
@@ -149,3 +152,10 @@ Description:
 		security.ima xattr of a file:
 
 			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
+
+		Example of 'measure' rule requiring fs-verity's digests on a
+		particular filesystem with indication of type of digest in
+		the measurement list.
+
+			measure func=FILE_CHECK digest_type=verity \
+				fsuuid=... template=ima-ngv2
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 1a91d92950a7..1e3fe986764e 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -69,6 +69,8 @@ descriptors by adding their identifier to the format string
    algorithm (field format: [<hash algo>:]digest, where the digest
    prefix is shown only if the hash algorithm is not SHA1 or MD5);
  - 'd-modsig': the digest of the event without the appended modsig;
+ - 'd-type': differentiate between fs-verity's Merkle tree based file hash
+   from a regular IMA file hash measurement.
  - 'n-ng': the name of the event, without size limitations;
  - 'sig': the file signature, or the EVM portable signature if the file
    signature is not found;
@@ -106,3 +108,8 @@ currently the following methods are supported:
    the ``ima_template=`` parameter;
  - register a new template descriptor with custom format through the kernel
    command line parameter ``ima_template_fmt=``.
+
+
+References
+==========
+[1] Documentation/filesystems/fsverity.rst
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 45294f18dabc..c359c4d50a1e 100644
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
+				 struct ima_max_digest_data *hash)
+{
+	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_alg;
+	int ret;
+
+	ret = fsverity_get_digest(iint->inode, verity_digest, &verity_alg);
+	if (ret)
+		return ret;
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
@@ -246,12 +264,29 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (buf)
+	if (buf) {
 		result = ima_calc_buffer_hash(buf, size,
 					      (struct ima_digest_data *)&hash);
-	else
+	} else if (iint->flags & IMA_VERITY_REQUIRED) {
+		result = ima_get_verity_digest(iint, &hash);
+		switch (result) {
+		case 0:
+			iint->flags |= IMA_VERITY_DIGEST;
+			break;
+		case -ENODATA:
+			audit_cause = "no-verity-digest";
+			hash.length = hash_digest_size[algo];
+			result = -EINVAL;
+			break;
+		case -EINVAL:
+		default:
+			audit_cause = "invalid-verity-digest";
+			break;
+		}
+	} else {
 		result = ima_calc_file_hash(file,
 					    (struct ima_digest_data *)&hash);
+	}
 
 	if (result && result != -EBADF && result != -EINVAL)
 		goto out;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index a0f3775cbd82..28aca1f9633b 100644
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
+				     IMA_VERITY_REQUIRED))
 			return false;
 
 		break;
@@ -1708,6 +1726,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
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
@@ -1798,6 +1823,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		check_template_modsig(template_desc);
 	}
 
+	/* d-type template field recommended for unsigned fs-verity digests */
+	if (!result && entry->action == MEASURE &&
+	    entry->flags & IMA_VERITY_REQUIRED) {
+		template_desc = entry->template ? entry->template :
+						  ima_template_desc_current();
+		check_template_field(template_desc, "d-type",
+				     "verity rules should include d-type");
+	}
+
 	audit_log_format(ab, "res=%d", !result);
 	audit_log_end(ab);
 	return result;
@@ -2155,6 +2189,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 		else
 			seq_puts(m, "appraise_type=imasig ");
 	}
+	if (entry->flags & IMA_VERITY_REQUIRED)
+		seq_puts(m, "digest_type=verity ");
 	if (entry->flags & IMA_CHECK_BLACKLIST)
 		seq_puts(m, "appraise_flag=check_blacklist ");
 	if (entry->flags & IMA_PERMIT_DIRECTIO)
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 48c2fcbefacf..31573b4c7763 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -392,7 +392,14 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 int ima_eventdigest_type_init(struct ima_event_data *event_data,
 			      struct ima_field_data *field_data)
 {
-	static const char * const digest_type[] = {"ima"};
+	static const char * const digest_type[] = {"ima", "verity"};
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
index ee2e6b7c7575..cbc41d4288ed 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -32,7 +32,7 @@
 #define IMA_HASHED		0x00000200
 
 /* iint policy rule cache flags */
-#define IMA_NONACTION_FLAGS	0xff000000
+#define IMA_NONACTION_FLAGS	0xff800000
 #define IMA_DIGSIG_REQUIRED	0x01000000
 #define IMA_PERMIT_DIRECTIO	0x02000000
 #define IMA_NEW_FILE		0x04000000
@@ -40,6 +40,8 @@
 #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
 #define IMA_MODSIG_ALLOWED	0x20000000
 #define IMA_CHECK_BLACKLIST	0x40000000
+#define IMA_VERITY_REQUIRED	0x80000000
+#define IMA_VERITY_DIGEST	0x00800000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)
-- 
2.27.0

