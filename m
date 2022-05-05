Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4408951BF54
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 14:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376714AbiEEMfo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 08:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242028AbiEEMfn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 08:35:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE6855352;
        Thu,  5 May 2022 05:32:04 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245AkSOg024926;
        Thu, 5 May 2022 12:32:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lmoixnNzKsFunVasoTqcDGgPiqnVn6U54g3/xCduPwA=;
 b=Cxr3YoY4s0Ug+4etqYpM4zc4ir49155SFVtPpmENfwrGvs8BLRBzkQNMu4loGAacZP5V
 +P0dr46UpDg4fBn7kFUgWxTl5w7XEVhsnPf8SdZbpM6XYa7pyRVFdiWzrJs0iaqnJrPt
 9CBATcvPAO4NJw4lcYevobUHKYOnZUsPlNE89LgCcysoOGBri0cvW7zjYriYQ7yiv5u1
 efX4VJXEdkHGzMmPT++/6M3t/a2TbxzYG0JQPP5SRIXV9GJmI4cnqUXzYRGQ0nfAgk2r
 fwfM/JYbGlMscOAyolM2+42TQiUyAqRNqUHf8w2ELrcFCOT4l+fIJDIISA7UjLYBCefN ng== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvd4ga0be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:02 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CSl6m019464;
        Thu, 5 May 2022 12:32:00 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3frvr8wsme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:31:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CVudi41287966
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:31:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E60A4C044;
        Thu,  5 May 2022 12:31:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FA014C046;
        Thu,  5 May 2022 12:31:55 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.81.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:31:55 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 2/7] ima: use IMA default hash algorithm for integrity violations
Date:   Thu,  5 May 2022 08:31:36 -0400
Message-Id: <20220505123141.1599622-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220505123141.1599622-1-zohar@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GzPu6eGLvu73wM_2xpYKOXSOjgMFdt1s
X-Proofpoint-ORIG-GUID: GzPu6eGLvu73wM_2xpYKOXSOjgMFdt1s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=957 clxscore=1015 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

Tested-by: Stefan Berger <stefanb@linux.ibm.com>
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

