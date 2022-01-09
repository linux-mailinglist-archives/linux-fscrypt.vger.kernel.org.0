Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E368488BD4
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiAISzl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 13:55:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35902 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236614AbiAISzh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 13:55:37 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209I5ZT1021796;
        Sun, 9 Jan 2022 18:55:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=zROlUnGp7KwW/JRJDF1wWCeMVgCxWkXiPtbI6LaWmgA=;
 b=HF7heHGVE6wZrG9Fta53b1u4TTR5ogsIHB+BnB8btOxWDwmupEmcjFK3h8z9WDVEhgnf
 wLUZuXVkqGSqAl3favxPCIxXeVq1yk/zl9BR3Jiwi0HpMyvr7HfM5/M9KV1G8wZQ/NYX
 t/4De4iqWvSQ+6ovuiuhC8e5dO0rxQXhXRc/nJ3b7SOUKNgK3buhMc/mGncjlEcjn+yF
 k7N7G7bQ7hmtGUXU09VndYcVAY4Zf9SxhSlb4mSlo9h0VUS1tFPtmdObc2atm4Cf0hgj
 ENOrpPv03glr+U9Xkecr4mMV75XSSe7ZpBJlviurxbHtDgucA5bt/XuyJWxhNlY8gMhi nw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfkyrb2d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:35 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209IreqH023288;
        Sun, 9 Jan 2022 18:55:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3df288ekj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209ItVik40370648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 18:55:31 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FF29A404D;
        Sun,  9 Jan 2022 18:55:31 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C911A4051;
        Sun,  9 Jan 2022 18:55:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Jan 2022 18:55:30 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] fsverity: update the documentation
Date:   Sun,  9 Jan 2022 13:55:17 -0500
Message-Id: <20220109185517.312280-7-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109185517.312280-1-zohar@linux.ibm.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gtgM7nNJhqVvYGAtG8laFqJgZiSoGPsp
X-Proofpoint-ORIG-GUID: gtgM7nNJhqVvYGAtG8laFqJgZiSoGPsp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-09_08,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201090135
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fsverity documentation related to IMA signature support.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 1d831e3cbcb3..7d8a574a0d3b 100644
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
+IMA supports including fs-verity file digests and signatures based
+on the fs-verity file digests in the IMA (Integrity Measurement
+Architecture) measurement list and verifying fs-verity based file
+signatures stored as security.ima xattrs, based on policy.
 
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

