Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B47466BCC
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377159AbhLBV7L (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35132 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243133AbhLBV7K (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:10 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LdABA007282;
        Thu, 2 Dec 2021 21:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6fG9ayNl7XB4ba0DJUWzHk9XuaS/XZNTIce55PxwIbM=;
 b=SEFAbPGc7uXONZi8mRIeHWUj6yTKJW7zpRecIQR9TcrPBuoDQdzk1HYtI8GGZ/AVBWGX
 nBc/lUK7VMVi7C4l/GpB2z8/jFe4ZnyBaDdN6bRy4yl7lDeHAsFfg8a5EMtiZc3dcxCJ
 GOFS58xV+q2xRPowupqbHipW8+tygu/eyk7JsHLEB4UfmsaKA2ju9tKhV9uh4c+ST6D8
 TiVyxX1bDn4D+F3h38O3usby9NwpKGNf8vbeoUa77psMiuePyNeWSF8+iC+D6nbW0rAv
 VRMCpWGOn2Au079cmNJfAIMCbMO33/HGAWTbPJoJEQaJbv/W5IBakPBJOnaVodcXZJjA 8w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cq489u56h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LoDSg005227;
        Thu, 2 Dec 2021 21:55:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3ckcaadrn8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2LteIp28443028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:55:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D17EF52052;
        Thu,  2 Dec 2021 21:55:40 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CCF7052059;
        Thu,  2 Dec 2021 21:55:39 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/5] ima: define a new signature type named IMA_VERITY_DIGSIG
Date:   Thu,  2 Dec 2021 16:55:04 -0500
Message-Id: <20211202215507.298415-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211202215507.298415-1-zohar@linux.ibm.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: So5DpT1roc2uJbBRelwhXm8a956duiwS
X-Proofpoint-GUID: So5DpT1roc2uJbBRelwhXm8a956duiwS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
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

