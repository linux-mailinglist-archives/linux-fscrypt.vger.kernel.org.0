Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3224A49BFE2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiAZAHS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15580 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229778AbiAZAHR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:17 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PMhFwR012590;
        Wed, 26 Jan 2022 00:07:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IQUcoB3Qd+GaISwW378g5gXroZtdaGjoF3IryHPuMOU=;
 b=th/DF2Mf/wQRL1dcNW/MgrGbAv1mOBEF97pEO9g/HSEMIFwrbOr+UVOphY1V9ilGt4L1
 wBgTv5ggeg3aoLFUMRscre7hnHaQMpQF9U44EHZL4i7iHOlzzPukbVUpyMmXv2T7cB+u
 XIyux1fiAe7s51LZNDg7vt5tk/K07zoJrVPNK53Dm7k9kdHOKbz+2gbGGx4rDP8DuE//
 z09DLyWI+Zhi7fr261JIrkx0DRM6JU1YFe8L0llj/aL+s+aALDHkDaM4yw+ECxrDQwxm
 fUBzGFa7IYsWIrRunNALbHhiDkdZWxcAkMHy4bvUYj9C/2u4v4ilLg2MqQUA7ge1J3Bx Iw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtt83h8yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q02xnv024333;
        Wed, 26 Jan 2022 00:07:13 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9gpxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q077Jp44499318
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:07 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C010E4C052;
        Wed, 26 Jan 2022 00:07:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 530A04C04E;
        Wed, 26 Jan 2022 00:07:06 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:06 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/8] ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
Date:   Tue, 25 Jan 2022 19:06:51 -0500
Message-Id: <20220126000658.138345-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vwDYTJT5OSdURi8eV56Fa7L3-vtggt_D
X-Proofpoint-GUID: vwDYTJT5OSdURi8eV56Fa7L3-vtggt_D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
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
index 8ed6da428328..7c80dfe2c7a5 100644
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
index ad7e19208a69..56a9f75c3d44 100644
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

