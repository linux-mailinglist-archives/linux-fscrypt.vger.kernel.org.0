Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9398466BCF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377185AbhLBV7N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1377162AbhLBV7L (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:11 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LHekP006217;
        Thu, 2 Dec 2021 21:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=a3ulnL1eGQ5GGqvFiwrxTdTgYbAoXQdQEXbOeUXaoHc=;
 b=WCCqvFUBWj1j0ajzq12yMmbm4KuJSaLsP+tqXhUqdXFa+JPFX24dULv9BfrB0z90kYAA
 4i8od8SLgpWlZp8cnrfMBgu+hwV7QJ7OL+m+TOrI2MBK5ggLcfohnTLMaJ99PBnPyXS9
 WCMlcSr6gPOhdtSa3jG4scgQ8ZgAHaGPqtXr/bmprwC0STB+ya833mMO8Es7qDAsO7XX
 gwREHf2HUlNhhCzCDNJzE1b4BinEPqsYwbpLWNk5+7z+ieQ/dEm/rBu9otP771Seo8dF
 uodvscz/zQtlgly/Z1RMzRAGvU3kAv1q7cfaO6AR4tvEh9+QnoFTUnpOb8e2ibBPCjeV kQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq5xcs0xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LoEx8008841;
        Thu, 2 Dec 2021 21:55:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkrb6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2LtgxN28967242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:55:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980CF52052;
        Thu,  2 Dec 2021 21:55:42 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DE2CF5204E;
        Thu,  2 Dec 2021 21:55:41 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/5] ima: limit including fs-verity's file digest in measurement list
Date:   Thu,  2 Dec 2021 16:55:05 -0500
Message-Id: <20211202215507.298415-4-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211202215507.298415-1-zohar@linux.ibm.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aDJQP93ZKOmBjDKWv5gQdnTK_WcNa1rn
X-Proofpoint-GUID: aDJQP93ZKOmBjDKWv5gQdnTK_WcNa1rn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Without the file signature included in the IMA measurement list, the type
of file digest is unclear.  Set up the plumbing to limit including
fs-verity's file digest in the IMA measurement list based on whether the
template name is ima-sig.  In the future, this could be relaxed to include
any template format that includes the file signature.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
Changelog v1:
- Updated patch description to indicate this is a prepartory patch.
- Addressed Eric's comment: use lowercase 'true'/'false'.
- Fixed patch description based on Lakshmi's review.


 Documentation/security/IMA-templates.rst  | 9 +++++++--
 security/integrity/ima/ima.h              | 3 ++-
 security/integrity/ima/ima_api.c          | 3 ++-
 security/integrity/ima/ima_appraise.c     | 3 ++-
 security/integrity/ima/ima_main.c         | 7 ++++++-
 security/integrity/ima/ima_template_lib.c | 3 ++-
 6 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 1a91d92950a7..28640b543340 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -70,8 +70,8 @@ descriptors by adding their identifier to the format string
    prefix is shown only if the hash algorithm is not SHA1 or MD5);
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
- - 'sig': the file signature, or the EVM portable signature if the file
-   signature is not found;
+ - 'sig': the file signature, based on either the file's/fsverity's digest[1],
+   or the EVM portable signature if the file signature is not found;
  - 'modsig' the appended file signature;
  - 'buf': the buffer data that was used to generate the hash without size limitations;
  - 'evmsig': the EVM portable signature;
@@ -106,3 +106,8 @@ currently the following methods are supported:
    the ``ima_template=`` parameter;
  - register a new template descriptor with custom format through the kernel
    command line parameter ``ima_template_fmt=``.
+
+
+References
+==========
+[1] Documentation/filesystems/fsverity.rst
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index be965a8715e4..ab257e404f8e 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -262,7 +262,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file, void *buf, loff_t size,
-			    enum hash_algo algo, struct modsig *modsig);
+			    enum hash_algo algo, struct modsig *modsig,
+			    bool veritysig);
 void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   const unsigned char *filename,
 			   struct evm_ima_xattr_data *xattr_value,
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index a64fb0130b01..7505563315cb 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -212,7 +212,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
  */
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file, void *buf, loff_t size,
-			    enum hash_algo algo, struct modsig *modsig)
+			    enum hash_algo algo, struct modsig *modsig,
+			    bool veritysig)
 {
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index d43a27a9a9b6..549fe051269a 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -510,7 +510,8 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
 	    !(iint->flags & IMA_HASH))
 		return;
 
-	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo, NULL);
+	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo,
+				     NULL, false);
 	if (rc < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 465865412100..4b6b13becb16 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -216,6 +216,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	bool violation_check;
 	enum hash_algo hash_algo;
 	unsigned int allowed_algos = 0;
+	int veritysig = false;
 
 	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
 		return 0;
@@ -333,8 +334,12 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	}
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
+	if (xattr_value && xattr_value->type == IMA_VERITY_DIGSIG &&
+	    strcmp(template_desc->name, "ima-sig") == 0)
+		veritysig = true;
 
-	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
+	rc = ima_collect_measurement(iint, file, buf, size, hash_algo,
+				     modsig, veritysig);
 	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
 		goto out_locked;
 
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index ca017cae73eb..5bad251f3b07 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -478,7 +478,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
 {
 	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
 
-	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
+	if ((!xattr_value) || !(xattr_value->type == EVM_IMA_XATTR_DIGSIG ||
+				xattr_value->type == IMA_VERITY_DIGSIG))
 		return ima_eventevmsig_init(event_data, field_data);
 
 	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
-- 
2.27.0

