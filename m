Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C318488BC7
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbiAISzd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 13:55:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14254 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236588AbiAISzd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 13:55:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209H9mvD031989;
        Sun, 9 Jan 2022 18:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=W4IIXHsSWQAy9QMb/Wvcg7Zmq8gbqRFWtvjUwb5isuk=;
 b=nrOgb95pKdQLV8haSaNH8xBcKtUife1NudL8IQak4AMJcsORFaA51yca4VE71SK3Akz4
 pJc1do8H+sZhjDtmMeGoEUcJihlmGPiRif1wGXGNQLRs0OewcqmpHkBgcknGhi4LX7Dh
 AIK8xdfr33WIQPKUDqQ21WFT2bibiJfYcncgugdfQ0TfZwlkU2sVZssQnHqAQKvr56hg
 Krhp1aJLEPNKbJ50jKRxQBzmw7lCvPkyUcjczwEidOV1pg+yHBFaYGy8ia6jj6BJxcLP
 sY0vZNMbDR7hlVREXpS1aWtBbsdwh1wEy2gxmkrz5RwpFQZphUaPx7kthYBsGLMynhXM zQ== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmd9323n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209Irhrt032754;
        Sun, 9 Jan 2022 18:55:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3df288x5d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209ItPQo45809990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 18:55:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7655A4051;
        Sun,  9 Jan 2022 18:55:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F122FA404D;
        Sun,  9 Jan 2022 18:55:24 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Jan 2022 18:55:24 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
Date:   Sun,  9 Jan 2022 13:55:12 -0500
Message-Id: <20220109185517.312280-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109185517.312280-1-zohar@linux.ibm.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uUiJutJCnvfrBa7lKXHXIuOk4l-wt7lq
X-Proofpoint-GUID: uUiJutJCnvfrBa7lKXHXIuOk4l-wt7lq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-09_08,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201090135
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Simple policy rule options, such as fowner, uid, or euid, can be checked
immediately, while other policy rule options, such as requiring a file
signature, need to be deferred.

The 'flags' field in the integrity_iint_cache struct contains the policy
action', 'subaction', and non action/subaction.

action: measure/measured, appraise/appraised, (collect)/collected,
        audit/audited
subaction: appraise status for each hook (e.g. file, mmap, bprm, read,
        creds)
non action/subaction: deferred policy rule options and state

Rename the IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_main.c   | 2 +-
 security/integrity/ima/ima_policy.c | 2 +-
 security/integrity/integrity.h      | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 465865412100..e51ddc8d84ee 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -263,7 +263,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		/* reset appraisal flags if ima_inode_post_setattr was called */
 		iint->flags &= ~(IMA_APPRAISE | IMA_APPRAISED |
 				 IMA_APPRAISE_SUBMASK | IMA_APPRAISED_SUBMASK |
-				 IMA_ACTION_FLAGS);
+				 IMA_NONACTION_FLAGS);
 
 	/*
 	 * Re-evaulate the file if either the xattr has changed or the
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 320ca80aacab..a1df015934bc 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -712,7 +712,7 @@ int ima_match_policy(struct user_namespace *mnt_userns, struct inode *inode,
 				     func, mask, func_data))
 			continue;
 
-		action |= entry->flags & IMA_ACTION_FLAGS;
+		action |= entry->flags & IMA_NONACTION_FLAGS;
 
 		action |= entry->action & IMA_DO_MASK;
 		if (entry->action & IMA_APPRAISE) {
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 547425c20e11..d045dccd415a 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -30,8 +30,8 @@
 #define IMA_HASH		0x00000100
 #define IMA_HASHED		0x00000200
 
-/* iint cache flags */
-#define IMA_ACTION_FLAGS	0xff000000
+/* iint policy rule cache flags */
+#define IMA_NONACTION_FLAGS	0xff000000
 #define IMA_DIGSIG_REQUIRED	0x01000000
 #define IMA_PERMIT_DIRECTIO	0x02000000
 #define IMA_NEW_FILE		0x04000000
-- 
2.27.0

