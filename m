Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABC251BF6A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 14:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376773AbiEEMfp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 08:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357555AbiEEMfn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 08:35:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04465534E;
        Thu,  5 May 2022 05:32:03 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245C31UE023383;
        Thu, 5 May 2022 12:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ez6JfmodL5ssL3UW5oAaQCKyZGM7BcAVj3vg3Sy0sYQ=;
 b=sKuiCrjMD+/EtdR7PiSu4t7EPssZO1rBFvhCVFySit+eQaoetab5rAjKErKVvtSA2TiD
 vCHwd235sOBek9w21RZvssfmQZQ+DI0WpXUelXY2cSMMi5ygfrglSkUWFfvkHLjm1nY6
 lu35kHP8TUoh81XRIgJ66O7QgDEaxhVjw4V1+RxZPro0UyqpzNPfk4e9qFwBDeK8wDmv
 bA+fRnTquqg3mflsjk/nKA10Z0Wktq1cr6R9dTe4nmfpscjCg/O4Es5vfb2oMfBW2/K2
 RGDXwM83qapgxLkMdJIEmOTR0cO9Oo370PHCpVG9SfK11IA9nW0tyxr4MDB/r8a4MYNV ow== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fve8c8m0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:00 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CSSgf023596;
        Thu, 5 May 2022 12:31:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj7726-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:31:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CVt4K50004408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:31:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C08E4C040;
        Thu,  5 May 2022 12:31:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55FCA4C046;
        Thu,  5 May 2022 12:31:54 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.81.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:31:54 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 1/7] ima: fix 'd-ng' comments and documentation
Date:   Thu,  5 May 2022 08:31:35 -0400
Message-Id: <20220505123141.1599622-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220505123141.1599622-1-zohar@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XOLdVuZIxVjKkAtg3pcYOzXsHPADc5fU
X-Proofpoint-GUID: XOLdVuZIxVjKkAtg3pcYOzXsHPADc5fU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_04,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
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

