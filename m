Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B5514806
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 13:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358290AbiD2L3t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 07:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345528AbiD2L3q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 07:29:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597B748E62;
        Fri, 29 Apr 2022 04:26:28 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TAZlAh022483;
        Fri, 29 Apr 2022 11:26:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0ey2QZKzR7MgelhAbo9DrNIMSB0573ABCrZ32z+LTKs=;
 b=N82+5l4/AV9UCapN1hZGWGPCFknCpEUPPU5Y/bQecBMiKTMdN6Cl3DV8aFoVGWvb9did
 BSD6hqVegrSJMRADufhI0rUNHhXobDKWdHnSJi1ryisbSEbqsnOWgWFpiwjtBst+xenH
 gbY8KnkkwrxPDCwVVLEYIRTaM8AWjB1GdUiLoe2wzoTeqoW8FUwGVQvkpRzOQF+jyHAo
 Sh7VZF1VTVflKOgfzt/Y2QGVsXF0ZfaKB+H5MKBPbc6gROSAC7PBskozJCtkfYEsFlkz
 71BZDEQEgb+8elmhaQsObetfShK8RG+D82o6D2Z5tl29kQhbV8MRv8+O5tW+zTtUGg9m Bw== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqqtnptt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:25 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TBCmC6022159;
        Fri, 29 Apr 2022 11:26:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3fpuygb419-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TBQTpW20316564
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:26:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 413A411C04C;
        Fri, 29 Apr 2022 11:26:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 091F311C050;
        Fri, 29 Apr 2022 11:26:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.70.88])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 11:26:18 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 2/7] ima: use IMA default hash algorithm for integrity violations
Date:   Fri, 29 Apr 2022 07:25:56 -0400
Message-Id: <20220429112601.1421947-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220429112601.1421947-1-zohar@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bSoO0RcY9nVH6974wXrkbWenqCqLzetY
X-Proofpoint-GUID: bSoO0RcY9nVH6974wXrkbWenqCqLzetY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=852
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Integrity file violations - ToM/ToU, open writers - are recorded in the IMA
measurement list, containing 0x00's in both the template data and file data
hash fields, but 0xFF's are actually extended into TPM PCRs.  Although the
original 'ima' template data field ('d') is limited to 20 bytes, the 'd-ng'
template digest field is not.

The violation file data hash template field ('d-ng') is unnecessarily hard
coded to SHA1.  Instead of simply replacing the hard coded SHA1 hash
algorithm with a larger hash algorithm, use the hash algorithm as defined
in "ima_hash_algo".  ima_hash_algo is set to either the Kconfig IMA default
hash algorithm or as defined on the boot command line (ima_hash=).

Including a non-SHA1 file data hash algorithm in the 'd-ng' field of
violations is a cosmetic change.  The template data hash field, which is
extended into the TPM PCRs, is not affected by this change and should not
affect attestation of the IMA measurement list.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_template_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index e9d65f6fe2ae..4b6706f864d4 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -370,7 +370,7 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 			    struct ima_field_data *field_data)
 {
-	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
+	u8 *cur_digest = NULL, hash_algo = ima_hash_algo;
 	u32 cur_digestsize = 0;
 
 	if (event_data->violation)	/* recording a violation. */
-- 
2.27.0

