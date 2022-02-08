Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6C4ACE2B
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243570AbiBHBsE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344854AbiBHBm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:27 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4212C06109E;
        Mon,  7 Feb 2022 17:42:25 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217N69aH015605;
        Tue, 8 Feb 2022 01:42:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fApnaRWACVUPpeVBH0HFNVuIthCj71ypW1R4B1fdcwE=;
 b=fUj+QzxZnX77QtZ8UizZyCQeviRnyylus2SVPMHSlNkWEdZzUBMMYDF2/sP9k+b8uIzU
 oGRPC1D+tpOkIf6EWH3n0xisY92V7hHDbhCxU+2MeVK5LFDnd6S4331bh3v8TumfHxtf
 Wl5rvPpqQJ0jzR+7psMzTs6aleN739iJaM0Oy3M7sXIj9dysgk+kOyoSw8XLnAYup2/I
 CqGfCYw3zlJumpKhXSo9GrxrLURYxJIN51JYU62ooFf1+hcJRDYRXpHp5+LGtEUQ9Sfv
 YryM6twOtxdHbuTJ1KGZBFqFqAr/eBfHQg4T/lr4oqkc8c6FH3TRBV4tuQj7FtgdlOzT hA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e236f3rej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:22 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181WqOs025785;
        Tue, 8 Feb 2022 01:42:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj0pr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:20 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gE9I46334242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:14 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FC0CA405B;
        Tue,  8 Feb 2022 01:42:14 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 862DAA404D;
        Tue,  8 Feb 2022 01:42:13 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:13 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/8] ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
Date:   Mon,  7 Feb 2022 20:41:33 -0500
Message-Id: <20220208014140.483447-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fMaOV1Yxc0Gb8MUcm6BYPR-O0w48Zowa
X-Proofpoint-GUID: fMaOV1Yxc0Gb8MUcm6BYPR-O0w48Zowa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
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
index 90f528558adc..a0f3775cbd82 100644
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

