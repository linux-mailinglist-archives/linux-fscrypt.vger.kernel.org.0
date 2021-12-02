Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CBB466BD4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377183AbhLBV7S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46308 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1377196AbhLBV7Q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:16 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LmFq0008337;
        Thu, 2 Dec 2021 21:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PeO0/hc3erG3X51IVBgR1vS4QW4jYCIERfbZMYRZViw=;
 b=G760Z2+pDNHhLje9uO85fn9pJ2AaG9WKBARfIC168Pl9Jv6cx0/Bnxxse8dvrUAc6mEl
 jT0hYdYd6FJAIzOpE4UdWAupWbOohGEHe55ZbyGvsM3HYTBV+WyyxtJlRlYRMmCIh3dT
 heYOVtCcMeCnon3l6J9hNUXN4myuxEBI9iz6XoeXVMtQ1id84wDD0pUnEmpuhgWCOBns
 m5DL9kLJD9RTYhDmj/W+Cu+SaNGMpmuC5hJicT/eymMmzr1wi9EL14niz5waSm/zUdHZ
 +qqCP6maCwXHgbQKtE6IoeX/F5Q4SEg4Ok8SJf8AvWr1eyOZCB5aiuG6gqfzC8taOuEg oQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq6ccg68j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LoM68008897;
        Thu, 2 Dec 2021 21:55:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkrb72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2Ltl0N26149130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:55:47 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CE9152059;
        Thu,  2 Dec 2021 21:55:47 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 56C915204E;
        Thu,  2 Dec 2021 21:55:46 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 5/5] fsverity: update the documentation
Date:   Thu,  2 Dec 2021 16:55:07 -0500
Message-Id: <20211202215507.298415-6-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211202215507.298415-1-zohar@linux.ibm.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: c8JL2WTN8MOCgCK-YTxRD0r5SYXOvor8
X-Proofpoint-ORIG-GUID: c8JL2WTN8MOCgCK-YTxRD0r5SYXOvor8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fsverity documentation related to IMA signature support.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 1d831e3cbcb3..c71f6e365df5 100644
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
+IMA (Integrity Measurement Architecture) supports fs-verity file
+digests based signatures stored as security.ima xattrs, which are
+identified by the signature type IMA_VERITY_DIGSIG.
+
 
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

