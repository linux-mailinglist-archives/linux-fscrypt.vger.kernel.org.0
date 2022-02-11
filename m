Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685E14B2FB5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Feb 2022 22:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353800AbiBKVnf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Feb 2022 16:43:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353803AbiBKVnd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Feb 2022 16:43:33 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B8C6D;
        Fri, 11 Feb 2022 13:43:31 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BKQsMN023461;
        Fri, 11 Feb 2022 21:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WNFf97Dfhs8uN6OBjnSX4t6+edB858RQf/+/wsTTzwk=;
 b=dRGd1HKWsU8n1LeE0XvaNYEEPKHdhmcA18MpC53dzVkpJ0U1VZgPc/1Fy01m6TUPE3+G
 OVGGpZrpokktQVveoguZYTQ1MxbKQBFNbXBe1zFkpWz3IXLqVHI/rtJq1t9uoP2v5rSr
 SooPXrGk4FF9whwJWcDfraS88bJL7TXHqcSFOtseGTi0Ky3Ic8U2BgNMn9x0fgTxOTSm
 nMmimNZWTk8XzUQ828n8OrxdV7btN52wADn0RDFeKLxQw3aGsXpDKId3G8547yUutpLo
 0OU1CRqCOnjFTY3c9j9eLzwHhUQRWugKjdZnKY1RB2yRWOsUCz/k3d59NDpq9F2gcJtC oA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5sk5rm3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BLWTrl028242;
        Fri, 11 Feb 2022 21:43:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3e1gva55xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BLhMLH32899564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:43:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 129575204F;
        Fri, 11 Feb 2022 21:43:22 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3DA525204E;
        Fri, 11 Feb 2022 21:43:21 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/8] ima: define ima_max_digest_data struct without a flexible array variable
Date:   Fri, 11 Feb 2022 16:43:04 -0500
Message-Id: <20220211214310.119257-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220211214310.119257-1-zohar@linux.ibm.com>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B3kvcF4-dk7xskQZw54-H8_GxtznPvnQ
X-Proofpoint-GUID: B3kvcF4-dk7xskQZw54-H8_GxtznPvnQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

To support larger hash digests in the 'iint' cache, instead of defining
the 'digest' field as the maximum digest size, the 'digest' field was
defined as a flexible array variable.  The "ima_digest_data" struct was
wrapped inside a local structure with the maximum digest size.  But
before adding the record to the iint cache, memory for the exact digest
size was dynamically allocated.

The original reason for defining the 'digest' field as a flexible array
variable is still valid for the 'iint' cache use case.  Instead of
wrapping the 'ima_digest_data' struct in a local structure define
'ima_max_digest_data' struct.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_api.c          | 10 ++++------
 security/integrity/ima/ima_init.c         |  5 +----
 security/integrity/ima/ima_main.c         |  5 +----
 security/integrity/ima/ima_template_lib.c |  5 +----
 security/integrity/integrity.h            | 10 ++++++++++
 5 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 5b220a2fe573..c6805af46211 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -217,14 +217,11 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
 	const char *filename = file->f_path.dentry->d_name.name;
+	struct ima_max_digest_data hash;
 	int result = 0;
 	int length;
 	void *tmpbuf;
 	u64 i_version;
-	struct {
-		struct ima_digest_data hdr;
-		char digest[IMA_MAX_DIGEST_SIZE];
-	} hash;
 
 	/*
 	 * Always collect the modsig, because IMA might have already collected
@@ -239,8 +236,9 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 
 	/*
 	 * Detecting file change is based on i_version. On filesystems
-	 * which do not support i_version, support is limited to an initial
-	 * measurement/appraisal/audit.
+	 * which do not support i_version, support was originally limited
+	 * to an initial measurement/appraisal/audit, but was modified to
+	 * assume the file changed.
 	 */
 	i_version = inode_query_iversion(inode);
 	hash.hdr.algo = algo;
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index b26fa67476b4..63979aefc95f 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -47,12 +47,9 @@ static int __init ima_add_boot_aggregate(void)
 	struct integrity_iint_cache tmp_iint, *iint = &tmp_iint;
 	struct ima_event_data event_data = { .iint = iint,
 					     .filename = boot_aggregate_name };
+	struct ima_max_digest_data hash;
 	int result = -ENOMEM;
 	int violation = 0;
-	struct {
-		struct ima_digest_data hdr;
-		char digest[TPM_MAX_DIGEST_SIZE];
-	} hash;
 
 	memset(iint, 0, sizeof(*iint));
 	memset(&hash, 0, sizeof(hash));
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 7c80dfe2c7a5..c6412dec3810 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -874,10 +874,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
 					    .buf = buf,
 					    .buf_len = size};
 	struct ima_template_desc *template;
-	struct {
-		struct ima_digest_data hdr;
-		char digest[IMA_MAX_DIGEST_SIZE];
-	} hash = {};
+	struct ima_max_digest_data hash;
 	char digest_hash[IMA_MAX_DIGEST_SIZE];
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 5a5d462ab36d..7155d17a3b75 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -307,10 +307,7 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
 int ima_eventdigest_init(struct ima_event_data *event_data,
 			 struct ima_field_data *field_data)
 {
-	struct {
-		struct ima_digest_data hdr;
-		char digest[IMA_MAX_DIGEST_SIZE];
-	} hash;
+	struct ima_max_digest_data hash;
 	u8 *cur_digest = NULL;
 	u32 cur_digestsize = 0;
 	struct inode *inode;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d045dccd415a..daf49894fd7d 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/integrity.h>
 #include <crypto/sha1.h>
+#include <crypto/hash.h>
 #include <linux/key.h>
 #include <linux/audit.h>
 
@@ -110,6 +111,15 @@ struct ima_digest_data {
 	u8 digest[];
 } __packed;
 
+/*
+ * Instead of wrapping the ima_digest_data struct inside a local structure
+ * with the maximum hash size, define ima_max_digest_data struct.
+ */
+struct ima_max_digest_data {
+	struct ima_digest_data hdr;
+	u8 digest[HASH_MAX_DIGESTSIZE];
+} __packed;
+
 /*
  * signature format v2 - for using with asymmetric keys
  */
-- 
2.27.0

