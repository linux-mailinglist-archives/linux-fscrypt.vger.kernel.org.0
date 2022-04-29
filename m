Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8547514809
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 13:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358303AbiD2L3v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 07:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358294AbiD2L3t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 07:29:49 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E78348E62;
        Fri, 29 Apr 2022 04:26:32 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T95EqC018469;
        Fri, 29 Apr 2022 11:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aSo+kCFltMYZLft9IccbKmYPNXMLjEMiM6MAdSOa4Po=;
 b=Nlt3+YYtZQ2uz6XCCVJQyya5mEcKiTd3i4JgiuH4cWmUncy59kppeSjt19RY+fgtsTHR
 2X6SPiulKeeH+aylUDT1tBCApa3GAl/UuakOO0Bca9Ar7WGIeG10EV4TPqIGPZrAxSEs
 /JrZo+tiY+oomBH+yqsITfMGW02/c5gpnp5dc964ELefsjBjAXzOAPOqFSwO0oM/0TWq
 FUPjed1ItkUuSHG9zkQXVU1DocprjmXdGq48cTBKVi2NtEjazA2yvBdO2PuKVbIeHXk1
 WqcLrqRZBEEMb0Wj3DyhYYrRH6bB7gU4k/F/zLdp+TIOH9L3WZZSSfO1LddM9rTOl+rp Hg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqvapy21a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TBCqoH016350;
        Fri, 29 Apr 2022 11:26:22 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm9391050-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:22 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TBQI4p40567182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:26:18 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDA3111C050;
        Fri, 29 Apr 2022 11:26:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D592E11C052;
        Fri, 29 Apr 2022 11:26:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.70.88])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 11:26:17 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/7] ima: fix 'd-ng' comments and documentation
Date:   Fri, 29 Apr 2022 07:25:55 -0400
Message-Id: <20220429112601.1421947-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220429112601.1421947-1-zohar@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tcN3u_cOQqhlL1Ku1XzuhZwVM1xBUyRs
X-Proofpoint-GUID: tcN3u_cOQqhlL1Ku1XzuhZwVM1xBUyRs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 priorityscore=1501 suspectscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Initially the 'd-ng' template field did not prefix the digest with either
"md5" or "sha1" hash algorithms.  Prior to being upstreamed this changed,
but the comments and documentation were not updated.  Fix the comments
and documentation.

Fixes: 4d7aeee73f53 ("ima: define new template ima-ng and template fields d-ng and n-ng")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/security/IMA-templates.rst  | 3 +--
 security/integrity/ima/ima_template_lib.c | 8 +++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index 1a91d92950a7..cab97f49971d 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -66,8 +66,7 @@ descriptors by adding their identifier to the format string
    calculated with the SHA1 or MD5 hash algorithm;
  - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
  - 'd-ng': the digest of the event, calculated with an arbitrary hash
-   algorithm (field format: [<hash algo>:]digest, where the digest
-   prefix is shown only if the hash algorithm is not SHA1 or MD5);
+   algorithm (field format: <hash algo>:digest);
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
  - 'sig': the file signature, or the EVM portable signature if the file
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 7155d17a3b75..e9d65f6fe2ae 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -271,9 +271,11 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
 	/*
 	 * digest formats:
 	 *  - DATA_FMT_DIGEST: digest
-	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
-	 *    where <hash algo> is provided if the hash algorithm is not
-	 *    SHA1 or MD5
+	 *  - DATA_FMT_DIGEST_WITH_ALGO: <hash algo> + ':' + '\0' + digest,
+	 *
+	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
+	 *      with a hash size limitation of 20 bytes,
+	 *    where <hash algo> is the hash_algo_name[] string.
 	 */
 	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
 	enum data_formats fmt = DATA_FMT_DIGEST;
-- 
2.27.0

