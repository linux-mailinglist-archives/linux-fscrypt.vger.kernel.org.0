Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9292251BF5A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 14:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376986AbiEEMfz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 08:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376940AbiEEMfv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 08:35:51 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30D455360;
        Thu,  5 May 2022 05:32:10 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245BiioQ014442;
        Thu, 5 May 2022 12:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9VCCMYA2saXgFhGUsRzgpbtwBPHpjOWbNPgHdeeLmZ8=;
 b=ko4l5bBvi2t7TFjJqU0dmjCg0sYM/c0rgcjPJzoam0Gamig0kpCLdRESV4atRFx9cBMT
 t99roaFJj/o06QOIfo1XYEyddZK++4zU3t7Xe5N3Ey1pnqGrFjfFv/RHQJGuc0Z7XUT5
 66NXfny/tu9m4jInNmkmtX5BsesdGrPVb0Y6/PJBOVCWeZQPqlITBd28ZYFcfaipW7ZA
 AxxLuFvmitryYHJkxD7nQEAJAXBwoP1swJ+UQXcUpRSnwpDYTquVM9IRYmNubzkGJDk3
 43/B18OcndCYn7GvDBNpF8xdvHslqLIoNeBLP10+TQ/zW9s2L+8wHBc73wGzUSMp8kq9 Cw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvdys8waf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:08 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245CSSgi023596;
        Thu, 5 May 2022 12:32:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3frvcj772d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 12:32:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245CW2al50594096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 12:32:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88DE34C046;
        Thu,  5 May 2022 12:32:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8354B4C040;
        Thu,  5 May 2022 12:32:01 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.81.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 12:32:01 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 7/7] fsverity: update the documentation
Date:   Thu,  5 May 2022 08:31:41 -0400
Message-Id: <20220505123141.1599622-8-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220505123141.1599622-1-zohar@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VlAR-KLR5hwIRpCLmgp2ea4gy9gfDvij
X-Proofpoint-ORIG-GUID: VlAR-KLR5hwIRpCLmgp2ea4gy9gfDvij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_05,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=802 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205050091
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fsverity documentation related to IMA signature support.

Acked-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/filesystems/fsverity.rst | 35 +++++++++++++++++---------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 8cc536d08f51..b7d42fd65e9d 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -70,12 +70,23 @@ must live on a read-write filesystem because they are independently
 updated and potentially user-installed, so dm-verity cannot be used.
 
 The base fs-verity feature is a hashing mechanism only; actually
-authenticating the files is up to userspace.  However, to meet some
-users' needs, fs-verity optionally supports a simple signature
-verification mechanism where users can configure the kernel to require
-that all fs-verity files be signed by a key loaded into a keyring; see
-`Built-in signature verification`_.  Support for fs-verity file hashes
-in IMA (Integrity Measurement Architecture) policies is also planned.
+authenticating the files may be done by:
+
+* Userspace-only
+
+* Builtin signature verification + userspace policy
+
+  fs-verity optionally supports a simple signature verification
+  mechanism where users can configure the kernel to require that
+  all fs-verity files be signed by a key loaded into a keyring;
+  see `Built-in signature verification`_.
+
+* Integrity Measurement Architecture (IMA)
+
+  IMA supports including fs-verity file digests and signatures in the
+  IMA measurement list and verifying fs-verity based file signatures
+  stored as security.ima xattrs, based on policy.
+
 
 User API
 ========
@@ -653,12 +664,12 @@ weren't already directly answered in other parts of this document.
     hashed and what to do with those hashes, such as log them,
     authenticate them, or add them to a measurement list.
 
-    IMA is planned to support the fs-verity hashing mechanism as an
-    alternative to doing full file hashes, for people who want the
-    performance and security benefits of the Merkle tree based hash.
-    But it doesn't make sense to force all uses of fs-verity to be
-    through IMA.  As a standalone filesystem feature, fs-verity
-    already meets many users' needs, and it's testable like other
+    IMA supports the fs-verity hashing mechanism as an alternative
+    to full file hashes, for those who want the performance and
+    security benefits of the Merkle tree based hash.  However, it
+    doesn't make sense to force all uses of fs-verity to be through
+    IMA.  fs-verity already meets many users' needs even as a
+    standalone filesystem feature, and it's testable like other
     filesystem features e.g. with xfstests.
 
 :Q: Isn't fs-verity useless because the attacker can just modify the
-- 
2.27.0

