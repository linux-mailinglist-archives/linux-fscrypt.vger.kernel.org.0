Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EA5461C5C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Nov 2021 18:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347353AbhK2RGn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 12:06:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346245AbhK2REn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 12:04:43 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATFkcHL004585;
        Mon, 29 Nov 2021 17:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=tyJn1dJDKOISYr6ZBfAQkOJsshvSUxtJqeXTCrXzPaQ=;
 b=djYJS2prL6tqi/AWoA9X3CWmj4j+SNJYduPxpWdiUVaxHxL07Ku2a+Qe9m5kUk8FtW1K
 7PWw0YU0xMdSFhzGYQ76ptNt7ZGnE4UxbBjKfShINeV/QNAjhD6N3tBVENP2ROTg3LZZ
 Zv8RfG/G2RBNNwdddFArA34RmPP6wpC1ayWxRYatLQitE/YR4r5Y6QiEUIvrOmjnoWVN
 MflHwENtYcxqjbaGX2QFcZ7SBDbyMPbumsSqU0XhPb3xmAYjDDtLvc9X8l4P/CmfsI19
 Y2rNw6HB2Aug/A6LfweqMFRIa3wU0hStQ0ZYQMn2RdTMo9EFuegWcFcpjP2xiyxdgR/r Sg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn1t71yrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:23 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGuj1x006995;
        Mon, 29 Nov 2021 17:01:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3ckbxje6uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATH1Ivp19661196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 17:01:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA7F44C063;
        Mon, 29 Nov 2021 17:01:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A542A4C044;
        Mon, 29 Nov 2021 17:01:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.68.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 17:01:17 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] ima: support fs-verity signatures stored as
Date:   Mon, 29 Nov 2021 12:00:53 -0500
Message-Id: <20211129170057.243127-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lut-SrzVKLJ-JpDWmXzwhdr9vCKQgf5G
X-Proofpoint-ORIG-GUID: lut-SrzVKLJ-JpDWmXzwhdr9vCKQgf5G
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290081
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Support for fs-verity file digests in IMA was discussed from the beginning,
prior to fs-verity being upstreamed[1,2].  This patch set adds signature
verification support based on the fs-verity file digest.  Both the
file digest and the signature must be included in the IMA measurement list
in order to disambiguate the type of file digest.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Mimi Zohar (4):
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new signature type named IMA_VERITY_DIGSIG
  ima: limit including fs-verity's file digest in measurement list
  ima: support fs-verity file digest based signatures

 fs/verity/fsverity_private.h              |  6 ---
 fs/verity/measure.c                       | 49 +++++++++++++++++++++++
 include/linux/fsverity.h                  | 17 ++++++++
 security/integrity/ima/ima.h              |  3 +-
 security/integrity/ima/ima_api.c          | 23 ++++++++++-
 security/integrity/ima/ima_appraise.c     |  9 ++++-
 security/integrity/ima/ima_main.c         |  7 +++-
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  1 +
 9 files changed, 107 insertions(+), 11 deletions(-)

-- 
2.27.0

