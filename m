Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0F94ACE54
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiBHBsF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344950AbiBHBmb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D026AC061A73;
        Mon,  7 Feb 2022 17:42:29 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2180DqRu004583;
        Tue, 8 Feb 2022 01:42:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=y0TAq5uOzk+Jle3ny7B++D4HVgPEgEWaFU3XPVXJg8U=;
 b=rYRpBngbgasX9Vnl8OIXnYOBZHd8n9xAVBpgL+3W3dXm6yrGmo8901pZNkm35hWtBBoU
 1v9NK+KsOyrkgb+CO4vOAGBQcKm7lxzy2NmQZI7jlqqn/D4nea+WcpNArgb3f11jh8Dy
 X3r8mqYZU8BowyBqsyKIzd9Tp6xb7v5r5y+pODT1GkZ7xaJQjK//HoJJra3/FdldwJi4
 1nlSxexSb6D9bnybsWN4A7F80g5G6EFmtYz1gmtkHf3uIqrt0j7pWBc6TZrUgLTXwbTH
 jpsPdj39ucNqm1+WAjP85FG/QO8w81ofJkbRdGtEYcQ+G1xKCFdKNqJDaqSjerd4DlgH jg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22stchad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:28 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181Whmd025441;
        Tue, 8 Feb 2022 01:42:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj0prk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:25 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gMLu45548014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3919A4059;
        Tue,  8 Feb 2022 01:42:22 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC818A4053;
        Tue,  8 Feb 2022 01:42:21 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:21 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 8/8] fsverity: update the documentation
Date:   Mon,  7 Feb 2022 20:41:40 -0500
Message-Id: <20220208014140.483447-9-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d6deKs_zOydTre7id0wXx9a4R3wKvDGd
X-Proofpoint-ORIG-GUID: d6deKs_zOydTre7id0wXx9a4R3wKvDGd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=944 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
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

