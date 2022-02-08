Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7684ACE2F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbiBHBsG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiBHBm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BD1C043188;
        Mon,  7 Feb 2022 17:42:26 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217N8PAs025954;
        Tue, 8 Feb 2022 01:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BVWehtGOga1dT6JExPEbRi83VIZGpv6n5mY+Uo913BQ=;
 b=P0HkL9OJFVS/Imyg+ALpHdERlJPTwhBXWu56PxV0BMZ6MU4+0IWn77DWh7SxxNSVNqnq
 zzq+r0mFmLyV62A5bh7FbBHlYomjoBk3mYRjeUNKzp3oqxDczk4NydgjjCPk07ht3l4n
 b4bn8kMkJha8Cs+O0UMip8ZIjV94xPJJ+HNIU5hZu3Ly74xBuVupPPv9eidw/3TsXfRj
 nrXScqkr5nT+ft42BbQP+BLsTFHgarxQtFLv1de6bqcdkOgQc1r1D92BShU6WDb5BltF
 HBfRagcrNAATMOvMR+5MNBuj38KBlrGZHrNuSEa0fCdCe5o2iO/+ySiWirEQw71mq3U/ lQ== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e22m6c6uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:23 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181gASm022648;
        Tue, 8 Feb 2022 01:42:21 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3e1gv98m78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gFRZ47579604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98410A4053;
        Tue,  8 Feb 2022 01:42:15 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D58F8A4040;
        Tue,  8 Feb 2022 01:42:14 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:14 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/8] ima: define ima_max_digest_data struct without a flexible array variable
Date:   Mon,  7 Feb 2022 20:41:34 -0500
Message-Id: <20220208014140.483447-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zZ65NR7aFMOGafbR6lQmKOKbzggtnxgs
X-Proofpoint-ORIG-GUID: zZ65NR7aFMOGafbR6lQmKOKbzggtnxgs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

To support larger hash digests in the 'iint' cache, instead of defining
the 'digest' field as the maximum digest size, the 'digest' field was
defined as a flexible array variable and was dynamically allocated.
This resulted in wrapping the "ima_digest_data" struct inside a local
structure with the maximum digest size in a number of places.

The original reason for defining the 'digest' field as a flexible array
variable is still valid for the 'iint' cache use case.  In addition,
define 'ima_max_digest_data' struct to be use instead of the (ugly)
local wrapping of the "ima_digest_data" struct.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_api.c  | 20 ++++++++++----------
 security/integrity/ima/ima_init.c | 10 ++++------
 security/integrity/integrity.h    | 24 ++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 5b220a2fe573..45294f18dabc 100644
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
@@ -239,24 +236,27 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 
 	/*
 	 * Detecting file change is based on i_version. On filesystems
-	 * which do not support i_version, support is limited to an initial
-	 * measurement/appraisal/audit.
+	 * which do not support i_version, support was originally limited
+	 * to an initial measurement/appraisal/audit, but was modified to
+	 * assume the file changed.
 	 */
 	i_version = inode_query_iversion(inode);
-	hash.hdr.algo = algo;
+	hash.algo = algo;
 
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
 	if (buf)
-		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
+		result = ima_calc_buffer_hash(buf, size,
+					      (struct ima_digest_data *)&hash);
 	else
-		result = ima_calc_file_hash(file, &hash.hdr);
+		result = ima_calc_file_hash(file,
+					    (struct ima_digest_data *)&hash);
 
 	if (result && result != -EBADF && result != -EINVAL)
 		goto out;
 
-	length = sizeof(hash.hdr) + hash.hdr.length;
+	length = sizeof(struct ima_digest_data) + hash.length;
 	tmpbuf = krealloc(iint->ima_hash, length, GFP_NOFS);
 	if (!tmpbuf) {
 		result = -ENOMEM;
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index b26fa67476b4..890821af08dd 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -47,16 +47,13 @@ static int __init ima_add_boot_aggregate(void)
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
-	iint->ima_hash = &hash.hdr;
+	iint->ima_hash = (struct ima_digest_data *)&hash;
 	iint->ima_hash->algo = ima_hash_algo;
 	iint->ima_hash->length = hash_digest_size[ima_hash_algo];
 
@@ -73,7 +70,8 @@ static int __init ima_add_boot_aggregate(void)
 	 * is not found.
 	 */
 	if (ima_tpm_chip) {
-		result = ima_calc_boot_aggregate(&hash.hdr);
+		result = ima_calc_boot_aggregate((struct ima_digest_data *)
+						  &hash);
 		if (result < 0) {
 			audit_cause = "hashing_error";
 			goto err_out;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index d045dccd415a..ee2e6b7c7575 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/integrity.h>
 #include <crypto/sha1.h>
+#include <crypto/hash.h>
 #include <linux/key.h>
 #include <linux/audit.h>
 
@@ -110,6 +111,29 @@ struct ima_digest_data {
 	u8 digest[];
 } __packed;
 
+/*
+ * Instead of dynamically allocating memory for the ima_digest_data struct
+ * with space for the specific hash algo or wrapping the ima_digest_data
+ * struct inside another local structure, define ima_max_digest_data struct
+ * with the maximum digest size.
+ */
+struct ima_max_digest_data {
+	u8 algo;
+	u8 length;
+	union {
+		struct {
+			u8 unused;
+			u8 type;
+		} sha1;
+		struct {
+			u8 type;
+			u8 algo;
+		} ng;
+		u8 data[2];
+	} xattr;
+	u8 digest[HASH_MAX_DIGESTSIZE];
+} __packed;
+
 /*
  * signature format v2 - for using with asymmetric keys
  */
-- 
2.27.0

