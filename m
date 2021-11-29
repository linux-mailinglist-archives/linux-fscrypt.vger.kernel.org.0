Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1F0461C63
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Nov 2021 18:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347759AbhK2RGw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 12:06:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37566 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232856AbhK2REr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 12:04:47 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGlhBC015849;
        Mon, 29 Nov 2021 17:01:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aFJ0ZfwIB+86qoxxN6yWbiQmqQqDpvIJIqfTfdLri1E=;
 b=bQQJX1U4KJocPG8q1q+ZpO8M/c+0IDHdNgrnPshvpART5dlTLga1H2Cm/pns47FTqNpy
 20+/+VJ7d6MoLhTknasuPX7DOpcg6NrryCuR1OsQllvwVYqYihhLU95QiDXhDGQQng07
 O0GhRB5H40N6nGrjwqNrztKNrpspY3NSGX+GhF/Ud33fK8H2u2I5JqFRHf6Dq54hBaqT
 Gvda2fUDJNG2RLuJ67kqNMHIPSkG9+aVHBSDDnR/XFlx8fiFft2EMEk+H2wb5RtH0HVm
 p0ykd4FiuIE6Mr8D6bqXALIjLJpQEqQ3j7M73XgTEeBLm8BLtX9PlEw5my39Z9QExfA4 Bw== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn2ps89fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:26 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGwSW0031907;
        Mon, 29 Nov 2021 17:01:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckca97260-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATH1MJb25166322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 17:01:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5CFC4C059;
        Mon, 29 Nov 2021 17:01:22 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 183014C062;
        Mon, 29 Nov 2021 17:01:22 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.68.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 17:01:21 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/4] ima: support fs-verity file digest based signatures
Date:   Mon, 29 Nov 2021 12:00:57 -0500
Message-Id: <20211129170057.243127-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211129170057.243127-1-zohar@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FpMpnnkmU3QVPmLZeK41pNDtxFZyKelN
X-Proofpoint-ORIG-GUID: FpMpnnkmU3QVPmLZeK41pNDtxFZyKelN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290081
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of calculating a file hash and verifying the signature stored
in the security.ima xattr against the calculated file hash, verify the
signature of the fs-verity's file digest.  The fs-verity file digest is
a hash that includes the Merkle tree root hash.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_api.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 179c7f0364c2..ee1701f8c0f3 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -16,6 +16,7 @@
 #include <linux/xattr.h>
 #include <linux/evm.h>
 #include <linux/iversion.h>
+#include <linux/fsverity.h>
 
 #include "ima.h"
 
@@ -205,6 +206,23 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
 				allowed_algos);
 }
 
+static int ima_collect_verity_measurement(struct integrity_iint_cache *iint,
+					  struct ima_digest_data *hash)
+{
+	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_alg;
+	int rc;
+
+	rc = fsverity_measure(iint->inode, verity_digest, &verity_alg);
+	if (rc)
+		return -EINVAL;
+	if (hash->algo != verity_alg)
+		return -EINVAL;
+	hash->length = hash_digest_size[verity_alg];
+	memcpy(hash->digest, verity_digest, hash->length);
+	return 0;
+}
+
 /*
  * ima_collect_measurement - collect file measurement
  *
@@ -256,6 +274,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 
 	if (buf)
 		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
+	else if (veritysig)
+		result = ima_collect_verity_measurement(iint, &hash.hdr);
 	else
 		result = ima_calc_file_hash(file, &hash.hdr);
 
-- 
2.27.0

