Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284C2466BDB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377194AbhLBV7y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1348903AbhLBV7y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:54 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2KktsN009762;
        Thu, 2 Dec 2021 21:56:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=iTWQP/n0n09z1WP95N0FwphD/XUv/oniGiym4E3oL1A=;
 b=oJwSghfex3WhmIKNZ5mfhtuyyqK/J88kAAbnqZNjSiaB5GDZTGr7Lk1gnBd3WcUPY/zm
 REVf7+1swebpdRTBeAJ6GuQn2ensMbxdIfgaZOnnKJSQP9lVJ8e9tDmH0GaPvSG2gWSP
 Eu9SzO5Sug9Eon23kh72EYu2M1hgbUhs2d0D0Y0K0+y8Ei41n/F0r6OZrXFGZAGEXvD2
 cOxcw4K8j3Rc9cW1I/7y/JnQgYgBtySodeVJDJbuNQI8bhsVYoxLgoWJ1kczZp/jZ/lc
 gMBq9rne1ujGmrCHUREMUEHNoFmYTNeH2d3CPf0KXBJiT4VS3/vC7ZDGpVzws0OBnj5x NA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cq5fxhndn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:56:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LnWbS021437;
        Thu, 2 Dec 2021 21:55:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3ckcaa5rd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2Lm0Qb23986568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:48:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD1E352051;
        Thu,  2 Dec 2021 21:55:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EF22E5204E;
        Thu,  2 Dec 2021 21:55:29 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/5] ima: support fs-verity signatures stored as
Date:   Thu,  2 Dec 2021 16:55:02 -0500
Message-Id: <20211202215507.298415-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gpLRBplFxcHxg_bJYLu81DF49Qbzn6Fs
X-Proofpoint-ORIG-GUID: gpLRBplFxcHxg_bJYLu81DF49Qbzn6Fs
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 spamscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020133
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

Changelog v1:
- Updated both fsverity and IMA documentation.
- Addressed both Eric Bigger's and Lakshmi's comments.

Mimi Zohar (5):
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new signature type named IMA_VERITY_DIGSIG
  ima: limit including fs-verity's file digest in measurement list
  ima: support fs-verity file digest based signatures
  fsverity: update the documentation

 Documentation/filesystems/fsverity.rst    | 22 ++++++----
 Documentation/security/IMA-templates.rst  |  9 +++-
 fs/verity/Kconfig                         |  1 +
 fs/verity/fsverity_private.h              |  7 ---
 fs/verity/measure.c                       | 49 +++++++++++++++++++++
 include/linux/fsverity.h                  | 18 ++++++++
 security/integrity/ima/ima.h              |  3 +-
 security/integrity/ima/ima_api.c          | 23 +++++++++-
 security/integrity/ima/ima_appraise.c     | 52 ++++++++++++++++++++++-
 security/integrity/ima/ima_main.c         |  7 ++-
 security/integrity/ima/ima_template_lib.c |  3 +-
 security/integrity/integrity.h            |  1 +
 12 files changed, 172 insertions(+), 23 deletions(-)

-- 
2.27.0

