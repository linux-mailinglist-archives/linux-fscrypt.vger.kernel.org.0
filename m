Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DA149BFEE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235208AbiAZAH1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235156AbiAZAHX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:23 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PNgTde026636;
        Wed, 26 Jan 2022 00:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=iGr19k7o6hb3Nkx430pzdrb1sBfVddXzHyYuPPk6Ju0=;
 b=B+y3Z/A8czNUYqjO5q4AUi6FS/tleUZdRI5XhNC4UHNbsTytpjGS3l/HCjHatjXXlL9X
 BrLPvhcpqNxWsMUj0UnpkTjyycfjt0tcqG8RUTyPi+M4mk0oS2bMuV7i/pQGKIkmpbtG
 ZCdoLWevrDhNwWoPdWRDskgH7qnNH+YssJ0nh2sX7mFTzghXjXnFKqPP2XFXbWZ4Bjbr
 zV8tYvYScflMkMG/ZN2DXXI1rGcD2JDNEWJoYorNeW7FUjcm54kLMHHhop5K2p3lX5U2
 chLpa8Md51Ul1v3axTA76R4WvTBc92XCSBfsyi92mV6RTCmE4LGo696WxDOVoDnDDFh/ YA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtu3u8e0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q03ur6014076;
        Wed, 26 Jan 2022 00:07:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dr9j9a7u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q07DFn48496904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4540A4C04A;
        Wed, 26 Jan 2022 00:07:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4424B4C044;
        Wed, 26 Jan 2022 00:07:12 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:12 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/8] ima: include fsverity's file digests in the IMA measurement list
Date:   Tue, 25 Jan 2022 19:06:55 -0500
Message-Id: <20220126000658.138345-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MvAqJgF8Aw9ta8t3428_e-XEGej9e-SL
X-Proofpoint-GUID: MvAqJgF8Aw9ta8t3428_e-XEGej9e-SL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
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
index 5b220a2fe573..3f8fbddcabf6 100644
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
index 56a9f75c3d44..787e0eb506e6 100644
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
index aa5d4a490657..44e57d7e5fed 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -393,7 +393,14 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
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
index ee2e6b7c7575..a996d4fa7be3 100644
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
+#define IMA_VERITY_ALLOWED	0x80000000
+#define IMA_VERITY_DIGEST	0x00800000
 
 #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
 				 IMA_HASH | IMA_APPRAISE_SUBMASK)
-- 
2.27.0

