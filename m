Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F7461C60
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Nov 2021 18:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347604AbhK2RGs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 12:06:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346560AbhK2REq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 12:04:46 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGJDUu011775;
        Mon, 29 Nov 2021 17:01:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vnpMIpG89MhXH3dRDMarWDD1tkRVlFDirdGGtz2CuD4=;
 b=H3/gf0aesgfOj7/Xg0UYp04y3iRkpTZEHeLvQu7zYO1R2bhqFjwFnFOoSH9n4GdhnkMb
 meBywMbV50xoG5eECcQdSbV1Z7/v4MLDzz6vV20+CRcKIgvNRamlpkUKsweKt/J4JwiA
 UvCQ+Flii1zkaxQjAtjUAptBLE9GrpKPJmbKZZpTom0Mfe/whs+YIqBTPGCYvSAEAGUM
 hPi563Qmu3iWpWxfuYKLoYdqJhNHCLLT7QDBLeflOT8gwTjKXmUz+1LSnEodebgvcJQq
 +id7PYv2l0plHQQLXfmek61pinbxet3AQVqwmHLEhVawY7vqFhv4rTY3vzKZVQbXXe33 vA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn29f93pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:26 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGwZgm011339;
        Mon, 29 Nov 2021 17:01:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3ckca9p3f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATGru8966257306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 16:53:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDF6D4C062;
        Mon, 29 Nov 2021 17:01:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 328DF4C04A;
        Mon, 29 Nov 2021 17:01:21 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.68.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 17:01:21 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/4] ima: limit including fs-verity's file digest in measurement list
Date:   Mon, 29 Nov 2021 12:00:56 -0500
Message-Id: <20211129170057.243127-4-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211129170057.243127-1-zohar@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NIYCuYyrUnBDKFM0oRjpeUeUPq_Zqg3P
X-Proofpoint-GUID: NIYCuYyrUnBDKFM0oRjpeUeUPq_Zqg3P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290081
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Without the file signature included the IMA measurement list, the type
of file digest is unclear.  Limit including fs-verity's file digest in
the IMA measurement list based on whether the template name is ima-sig.
In the future, this could be relaxed to include any template format that
includes the file signature.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima.h              | 3 ++-
 security/integrity/ima/ima_api.c          | 3 ++-
 security/integrity/ima/ima_appraise.c     | 3 ++-
 security/integrity/ima/ima_main.c         | 7 ++++++-
 security/integrity/ima/ima_template_lib.c | 3 ++-
 5 files changed, 14 insertions(+), 5 deletions(-)

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
index 42c6ff7056e6..179c7f0364c2 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -217,7 +217,8 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
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
index d43a27a9a9b6..b31be383e668 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -510,7 +510,8 @@ void ima_update_xattr(struct integrity_iint_cache *iint, struct file *file)
 	    !(iint->flags & IMA_HASH))
 		return;
 
-	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo, NULL);
+	rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo,
+				     NULL, FALSE);
 	if (rc < 0)
 		return;
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 465865412100..a73e1e845ea8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -216,6 +216,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	bool violation_check;
 	enum hash_algo hash_algo;
 	unsigned int allowed_algos = 0;
+	int veritysig = FALSE;
 
 	if (!ima_policy_flag || !S_ISREG(inode->i_mode))
 		return 0;
@@ -333,8 +334,12 @@ static int process_measurement(struct file *file, const struct cred *cred,
 	}
 
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
+	if (xattr_value && xattr_value->type == IMA_VERITY_DIGSIG &&
+	    strcmp(template_desc->name, "ima-sig") == 0)
+		veritysig = TRUE;
 
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

