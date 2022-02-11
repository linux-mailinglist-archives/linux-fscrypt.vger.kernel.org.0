Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637D44B2FA6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Feb 2022 22:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiBKVn3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Feb 2022 16:43:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353790AbiBKVn2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Feb 2022 16:43:28 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA39C65;
        Fri, 11 Feb 2022 13:43:27 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BKvmW8009061;
        Fri, 11 Feb 2022 21:43:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=fApnaRWACVUPpeVBH0HFNVuIthCj71ypW1R4B1fdcwE=;
 b=Fag4+g80XOEmywWAkrB78TwT0zvMRsq4w8MEa80S5quznOWFpLZB0LmEi1XOjKet+my+
 0qZN8dtb1l6MBJEOVO/7exiPACE95w7nIDkBWwCcliXwNmUSYSt8JziBiiyAvmNaexzK
 G+YjIAAYw15P2RRzlbntdf3phdfdTEcFZ+qCiFa01gcYMIo4EErXhhEaNfMLFfuUFiF4
 vvB6hySlJNmyw2QowDOqRRsZmCQC1lMAmKGUKOyyGbSMXBRMd2mDg8m9zuGj+LvAR+U+
 EygLHeXEW3Hi9ypDcWvr6gW1xv11DJytYkljkThWXQjhSPuIC1K2bwEuW1qOs/7+QrvS yA== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5y9yrpjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BLXbQv001417;
        Fri, 11 Feb 2022 21:43:23 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gvaagu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BLhJ3Q32112916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:43:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA505204F;
        Fri, 11 Feb 2022 21:43:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B799D52050;
        Fri, 11 Feb 2022 21:43:18 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/8] ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
Date:   Fri, 11 Feb 2022 16:43:03 -0500
Message-Id: <20220211214310.119257-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220211214310.119257-1-zohar@linux.ibm.com>
References: <20220211214310.119257-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vKRbji7SMALyD5uKv8rSNXtOHVytA4OP
X-Proofpoint-ORIG-GUID: vKRbji7SMALyD5uKv8rSNXtOHVytA4OP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110108
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

