Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB22D4DE0FA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Mar 2022 19:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbiCRSXn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Mar 2022 14:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbiCRSXj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Mar 2022 14:23:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76430CDAE;
        Fri, 18 Mar 2022 11:22:12 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IHN266023400;
        Fri, 18 Mar 2022 18:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y0TAq5uOzk+Jle3ny7B++D4HVgPEgEWaFU3XPVXJg8U=;
 b=XyUhszYWI904V5MNyMw78ui1qXiT27dzvslnCSEIPTpj3kS44h1dKSHkkBMXBB781I6F
 wuBtCS/YxSKNXsH0u9mnBIc5hGmZ45YR0M4D2LBj8kWxepaPh16qeIo/b4nb7RLmFKdd
 ViqZvn1EZA6MJ9gBer0Urtz+FaJqF/+YY5x+Z/FqU2Zon7FM17DhvjDOrPbDXD+p1eX0
 rXX/cvBfO40+7xiaZG68XTofdU6N70fqBmWmvBsTTI5p0KkPVUoF9euXpNA+V4e1rA+g
 H70GdghOF5ZKSmrqOyTH6Z3MnEsAxEM9wYyiCEWR/PuwBZc6XpINczlvSscTs3njffwI Ew== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3euy5wx0ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22II4pdZ028153;
        Fri, 18 Mar 2022 18:22:08 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3euc6r5juh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IIM4Ki43909402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 18:22:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A843EAE05F;
        Fri, 18 Mar 2022 18:22:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBEE6AE05A;
        Fri, 18 Mar 2022 18:22:03 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.75.142])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 18:22:03 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 5/5] fsverity: update the documentation
Date:   Fri, 18 Mar 2022 14:21:51 -0400
Message-Id: <20220318182151.100847-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318182151.100847-1-zohar@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9Hmc_71JoqzadQh3KMJNdCTdUIuKBryl
X-Proofpoint-ORIG-GUID: 9Hmc_71JoqzadQh3KMJNdCTdUIuKBryl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_13,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=897 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fsverity documentation related to IMA signature support.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 1d831e3cbcb3..28a47488848e 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -74,8 +74,12 @@ authenticating the files is up to userspace.  However, to meet some
 users' needs, fs-verity optionally supports a simple signature
 verification mechanism where users can configure the kernel to require
 that all fs-verity files be signed by a key loaded into a keyring; see
-`Built-in signature verification`_.  Support for fs-verity file hashes
-in IMA (Integrity Measurement Architecture) policies is also planned.
+`Built-in signature verification`_.
+
+IMA supports including fs-verity file digests and signatures in the
+IMA (Integrity Measurement Architecture) measurement list and
+verifying fs-verity based file signatures stored as security.ima
+xattrs, based on policy.
 
 User API
 ========
@@ -653,13 +657,13 @@ weren't already directly answered in other parts of this document.
     hashed and what to do with those hashes, such as log them,
     authenticate them, or add them to a measurement list.
 
-    IMA is planned to support the fs-verity hashing mechanism as an
-    alternative to doing full file hashes, for people who want the
-    performance and security benefits of the Merkle tree based hash.
-    But it doesn't make sense to force all uses of fs-verity to be
-    through IMA.  As a standalone filesystem feature, fs-verity
-    already meets many users' needs, and it's testable like other
-    filesystem features e.g. with xfstests.
+    IMA supports the fs-verity hashing mechanism as an alternative
+    to doing full file hashes, for people who want the performance
+    and security benefits of the Merkle tree based hash.  But it
+    doesn't make sense to force all uses of fs-verity to be through
+    IMA.  As a standalone filesystem feature, fs-verity already meets
+    many users' needs, and it's testable like other filesystem
+    features e.g. with xfstests.
 
 :Q: Isn't fs-verity useless because the attacker can just modify the
     hashes in the Merkle tree, which is stored on-disk?
-- 
2.27.0

