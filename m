Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC00461C62
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Nov 2021 18:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347702AbhK2RGu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 12:06:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1346680AbhK2REq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 12:04:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGIOXn021478;
        Mon, 29 Nov 2021 17:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6fG9ayNl7XB4ba0DJUWzHk9XuaS/XZNTIce55PxwIbM=;
 b=sl8N60VOcJRqyRVhEhwRMRid58OTUlLb8JOWKoOEwR/SgWuaR/zC556iaYQy96csWnit
 x6/J2T/sUdmOAAeX1yJsJNzY+N/ewTCxdjH4AzdclMah92a8W0az/RzZQD3tMHiyQyZH
 o8uXh0rTDmG0816RFL3IkByDJvyitE7Ckr+/GoT/Mbk+fFb5AUVNoYqDZPUnlkhSI9ZR
 GwqMA78SrRmV5tpD2xf2AWcdXdSB7sutqB6UGrxolE1rg9wDpfbPkmP5foyIHq5HR2PO
 ddS3Mjk+OYiHka3HeYBPzUbzvj0V61eAq3odFLO5j937c92CtXv4e1yZPk7OENpR0mVm HA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cn28ss1wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGv1RH020222;
        Mon, 29 Nov 2021 17:01:24 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ckcac712a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATGrtKi66257300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 16:53:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF54C4C04A;
        Mon, 29 Nov 2021 17:01:20 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44DEB4C044;
        Mon, 29 Nov 2021 17:01:20 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.68.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 17:01:19 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/4] ima: define a new signature type named IMA_VERITY_DIGSIG
Date:   Mon, 29 Nov 2021 12:00:55 -0500
Message-Id: <20211129170057.243127-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211129170057.243127-1-zohar@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XT-tD30-Q2o5YhH-pjitoCgR3AT08OgZ
X-Proofpoint-GUID: XT-tD30-Q2o5YhH-pjitoCgR3AT08OgZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290080
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

To differentiate between a regular file hash and an fs-verity file digest
based signature stored as security.ima xattr, define a new signature type
named IMA_VERITY_DIGSIG.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_appraise.c | 6 ++++++
 security/integrity/integrity.h        | 1 +
 2 files changed, 7 insertions(+)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index dbba51583e7c..d43a27a9a9b6 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -13,7 +13,9 @@
 #include <linux/magic.h>
 #include <linux/ima.h>
 #include <linux/evm.h>
+#include <linux/fsverity.h>
 #include <keys/system_keyring.h>
+#include <uapi/linux/fsverity.h>
 
 #include "ima.h"
 
@@ -183,6 +185,8 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
 		return ima_hash_algo;
 
 	switch (xattr_value->type) {
+	case IMA_VERITY_DIGSIG:
+		fallthrough;
 	case EVM_IMA_XATTR_DIGSIG:
 		sig = (typeof(sig))xattr_value;
 		if (sig->version != 2 || xattr_len <= sizeof(*sig)
@@ -272,6 +276,8 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
 		}
 		*status = INTEGRITY_PASS;
 		break;
+	case IMA_VERITY_DIGSIG:
+		fallthrough;
 	case EVM_IMA_XATTR_DIGSIG:
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
 		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 547425c20e11..94f9ba55e840 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -77,6 +77,7 @@ enum evm_ima_xattr_type {
 	EVM_IMA_XATTR_DIGSIG,
 	IMA_XATTR_DIGEST_NG,
 	EVM_XATTR_PORTABLE_DIGSIG,
+	IMA_VERITY_DIGSIG,
 	IMA_XATTR_LAST
 };
 
-- 
2.27.0

