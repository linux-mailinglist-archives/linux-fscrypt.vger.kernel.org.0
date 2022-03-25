Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F34E7B7B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 26 Mar 2022 01:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiCYWkg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Mar 2022 18:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiCYWke (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Mar 2022 18:40:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EA7198EEE;
        Fri, 25 Mar 2022 15:38:59 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PLS5od024434;
        Fri, 25 Mar 2022 22:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6HSNayO2zoTea8iDOvU9XKWZ92yAaQB4lSX8FXdVqGU=;
 b=JH4vL8e37Pve+5DmHt9idRQZWDT5vgkK+wKYZJl/G4lHi1E2rG60Vh2t3QuOFWCPRTPr
 HHvABDBUMYUTwGlZBHjbiVNJOlPZMQxpztdEPSk4cO9UEfDvRBtzNO5aNEOjh97FYFUt
 OW5uoDHhn8WdKi+r1opi7zT3mRr2LLuOzpcVZRIGmN7Dke2cnPWbuobq2AOonO9wQvVZ
 G8R8M1UcUfPUvvZsg6j3uZXJdr+a464nYR7uOO+kUnRlND+JPbdIrb4UyQVmUlbJta0F
 GwpwDIoQD0PFCxCkAD0q4WkpU322sI9hhY19wRiIylyZRjyS7E/HHmhk7zdBPWjhgUqB LA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0q5p8cft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PMXLFK025406;
        Fri, 25 Mar 2022 22:38:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t962us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PMcuvB41288112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 22:38:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A4080A405C;
        Fri, 25 Mar 2022 22:38:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3BB9A405B;
        Fri, 25 Mar 2022 22:38:50 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.52])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 22:38:50 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 5/5] fsverity: update the documentation
Date:   Fri, 25 Mar 2022 18:38:24 -0400
Message-Id: <20220325223824.310119-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220325223824.310119-1-zohar@linux.ibm.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MknxbNp5w9EfobQ0javNiFOp6lQtJ5Ln
X-Proofpoint-GUID: MknxbNp5w9EfobQ0javNiFOp6lQtJ5Ln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_08,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=913
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203250124
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
 Documentation/filesystems/fsverity.rst | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 1d831e3cbcb3..c1d355f17a54 100644
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
+The Integrity Measurement Architecture (IMA) supports including
+fs-verity file digests and signatures in the IMA measurement list
+and verifying fs-verity based file signatures stored as security.ima
+xattrs, based on policy.
 
 User API
 ========
@@ -653,12 +657,12 @@ weren't already directly answered in other parts of this document.
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

