Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57886488BC3
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jan 2022 19:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236591AbiAISzc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 13:55:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234502AbiAISzc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 13:55:32 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 209DWew1014801;
        Sun, 9 Jan 2022 18:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=lIm/rOyA185Zks70ISzgQ4p1rhd/W81gVO7jYqIVD9Q=;
 b=Du9IOo8Pe6OxmSKz1ftfCpZLJ/wb+dbOTC4LSLqCERoKcxIc5FnsxU4y9JblJFLBBTZ/
 Zu9bKT572U/Je+nIfYaES3vSM6EygazyNjiID5L7okGPacYsUo4OyzN4hUmDddBRNLYU
 TfakSne+k2XHhYbqWxNVaYK2/fO0tp9QG+cfrkUNRp0YYgKRj/dNdQMrtKNc1AB7l2Sw
 uoBF40SGWEprqi5UPHNDshlPqn2mR0cgJARpAIdqcE8JMoG5V/Hk8qMp7MTy5mUvQn1h
 zd6k4wiXzy3YLKiOe31yXezOX8ptu/Yn/P6ehN1W+lEWbF5pFWb8MAA78xLkO3lffTOU wA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfmpmb6mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 209Irnoe028057;
        Sun, 9 Jan 2022 18:55:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3df1vhepm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Jan 2022 18:55:27 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 209ItOv042598750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 9 Jan 2022 18:55:24 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6200A4053;
        Sun,  9 Jan 2022 18:55:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E5EBA404D;
        Sun,  9 Jan 2022 18:55:23 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.17])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sun,  9 Jan 2022 18:55:23 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] ima: support fs-verity digests and signatures
Date:   Sun,  9 Jan 2022 13:55:11 -0500
Message-Id: <20220109185517.312280-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gryZV_NOa-7g_2CbVnzwn6wtNGivjZne
X-Proofpoint-ORIG-GUID: gryZV_NOa-7g_2CbVnzwn6wtNGivjZne
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-09_07,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 clxscore=1011 impostorscore=0 mlxscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201090135
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Support for including fs-verity file digests and signatures in the IMA
measurement list as well as verifying the fs-verity file digest based
signatures, all based on IMA policy rules, was discussed from the
beginning, prior to fs-verity being upstreamed[1,2].

Support including fs-verity file digests in the 'd-ng' template field
based on a new policy rule option named 'digest_type=hash|verity'.
Also support verifying fs-verity file digest based signatures based on
policy.

A new template field named 'd-type' as well as a new template named
'ima-ngv2' are defined to differentiate betweeen file hashes and fs-verity
file digests, when file signatures are not included in the IMA measurement
list.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Changelog v2:
- Addressed Eric Bigger's comments: sign the hash of fsverity's digest
  and the digest's metadata, use match_string, use preferred function
  name fsverity_get_digest(), support including unsigned fs-verity's
  digests in the IMA measurement list.
- Remove signatures requirement for including fs-verity's file digests in
  the 'd-ng' field of the measurement list.

Changelog v1:
- Updated both fsverity and IMA documentation.
- Addressed both Eric Bigger's and Lakshmi's comments.

Mimi Zohar (6):
  ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new template field 'd-type' and a new template
    'ima-ngv2'
  ima: include fsverity's file digests in the IMA measurement list
  ima: support fs-verity file digest based signatures
  fsverity: update the documentation

 Documentation/ABI/testing/ima_policy      | 17 +++++
 Documentation/filesystems/fsverity.rst    | 22 +++---
 Documentation/security/IMA-templates.rst  | 10 ++-
 fs/verity/Kconfig                         |  1 +
 fs/verity/fsverity_private.h              |  7 --
 fs/verity/measure.c                       | 40 +++++++++++
 include/linux/fsverity.h                  | 18 +++++
 include/uapi/linux/ima.h                  | 26 ++++++++
 security/integrity/ima/ima_api.c          | 29 +++++++-
 security/integrity/ima/ima_appraise.c     | 81 +++++++++++++++++++++++
 security/integrity/ima/ima_main.c         |  2 +-
 security/integrity/ima/ima_policy.c       | 40 ++++++++++-
 security/integrity/ima/ima_template.c     |  3 +
 security/integrity/ima/ima_template_lib.c | 23 ++++++-
 security/integrity/ima/ima_template_lib.h |  2 +
 security/integrity/integrity.h            |  7 +-
 16 files changed, 302 insertions(+), 26 deletions(-)
 create mode 100644 include/uapi/linux/ima.h

-- 
2.27.0

