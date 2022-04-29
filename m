Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D2A514810
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 13:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358321AbiD2L3y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 07:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358313AbiD2L3w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 07:29:52 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCD649264;
        Fri, 29 Apr 2022 04:26:33 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T8HK4Q025933;
        Fri, 29 Apr 2022 11:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dhabbGXhdWEZKSomL5GlgkEUR4yGtHLfzEtnFb5cnto=;
 b=F8WSIGckqIpKWXuXajNlRkPHnuKuPZ1luIfIIvjle/sZn896LPRQOjv4A5Qpjj4Nubwg
 42JdS9201qvxDMyAHHCszVkWm0oYiE8Ty8R2a+uIT6WfjVZa7I1L66i9Mfe0Bz2ZxyK0
 SGoyFF5L1fXMkO5YJoTnFcThfzPJ/ZcB9R+YoFftWDZR+Lmw8uc6uL/KIp3GOrD+eas+
 xh7otjOiB6Jq3hDCzmG2OLCdX9LeFQOU5+wr3pLbFmmDEClp2zOxgsnHeoR7Wl3omEI8
 mIgdT1WkizbREGdTgNgGsvQvd5+GnPJoqwHc0/KnAjGd1Hqt48xExobJNesdq74Oxwdz fQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqtqvtn2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TBCmPA016335;
        Fri, 29 Apr 2022 11:26:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm9391055-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TBQQQZ42139918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:26:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1452D11C050;
        Fri, 29 Apr 2022 11:26:26 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E5A511C04A;
        Fri, 29 Apr 2022 11:26:25 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.70.88])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 11:26:25 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 7/7] fsverity: update the documentation
Date:   Fri, 29 Apr 2022 07:26:01 -0400
Message-Id: <20220429112601.1421947-8-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220429112601.1421947-1-zohar@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TIcGhbkW5n5o72ztsMLT7cyPTxVcp1fl
X-Proofpoint-ORIG-GUID: TIcGhbkW5n5o72ztsMLT7cyPTxVcp1fl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=755 phishscore=0 malwarescore=0 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fsverity documentation related to IMA signature support.

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

