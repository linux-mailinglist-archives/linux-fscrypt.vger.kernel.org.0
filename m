Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBFA49BFDE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiAZAHO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229778AbiAZAHO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:14 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PNlk1p016339;
        Wed, 26 Jan 2022 00:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=MyNOO2y2NTgdphZjjNlv+83B10EGstE/9PurPZnuNbA=;
 b=ebNzjcP5ws998TJINGKg2mFV9v7CvcbQOZGNoPgIDrLsjMGnNNcjYABa6R0XAcAetnvV
 CYwvUtV33saD5VevdkZhN7U2cnQYTuVsCR6En+gqZCUDKWG7lkw3RB3sBtuS5+GyGh9/
 ZsJKQF9kusRThlqsXB2tt0KhJbZy3KViWKo3wDv7qGMuQr76yKq4gOxLoFeKzIG8GLVM
 TObF3AtK4Xnzv3bmuDhEjzB4Fr7nAPzRf/raPlm3TW1MS8kRbNcb+FmDs+3XC4bLFMoG
 mRtf5ukiljNAa3Dtc76mESkI5RWdIFdAmuyNEoHuX+YsghgeIXhVZhp7Fib8rsYv2629 Ug== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dtu6ng974-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q03Y9E003693;
        Wed, 26 Jan 2022 00:07:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dr9j9gr1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:09 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q076Mo37552600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21C6C4C050;
        Wed, 26 Jan 2022 00:07:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 423004C040;
        Wed, 26 Jan 2022 00:07:05 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:05 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/8] ima: support fs-verity digests and signatures
Date:   Tue, 25 Jan 2022 19:06:50 -0500
Message-Id: <20220126000658.138345-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ySI-ZVluDnP0MbkutOe4_R4IirCoW_HO
X-Proofpoint-ORIG-GUID: ySI-ZVluDnP0MbkutOe4_R4IirCoW_HO
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
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

To disambiguate the type of file signature, define IMA_VERITY_SIG xattr
type and a new signature format version, which is a hash of the new
ima_file_id structure.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Changelog v3:
- Addressed Eric Bigger's comments: included Ack, incremented the
  signature format version, the crypto issues are generic and will be
  addressed by him separately.
- Addressed Vitaly Chikunov's comments: hard coded maximum digest size
  rather than using a flexible array, removed unnecessary assignment, and
  fixed comment to match variable name.
- Defined new "ima_max_digest_size" struct to avoid wrapping the
  "ima_digest_data" struct inside a function local structure or
  having to dynamically allocate it with enough memory for the specific
  hash algo size.

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

Mimi Zohar (8):
  ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
  ima: define ima_max_digest_data struct without a flexible array
    variable
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new template field 'd-type' and a new template
    'ima-ngv2'
  ima: include fsverity's file digests in the IMA measurement list
  ima: define signature version 3
  ima: support fs-verity file digest based version 3 signatures
  fsverity: update the documentation

 Documentation/ABI/testing/ima_policy      | 17 +++++
 Documentation/filesystems/fsverity.rst    | 22 +++---
 Documentation/security/IMA-templates.rst  | 10 ++-
 fs/verity/Kconfig                         |  1 +
 fs/verity/fsverity_private.h              |  7 --
 fs/verity/measure.c                       | 39 +++++++++++
 include/linux/fsverity.h                  | 18 +++++
 security/integrity/digsig.c               |  3 +-
 security/integrity/ima/ima.h              |  2 +-
 security/integrity/ima/ima_api.c          | 29 +++++++-
 security/integrity/ima/ima_appraise.c     | 83 ++++++++++++++++++++++-
 security/integrity/ima/ima_crypto.c       |  2 +-
 security/integrity/ima/ima_init.c         |  9 +--
 security/integrity/ima/ima_main.c         |  2 +-
 security/integrity/ima/ima_policy.c       | 40 ++++++++++-
 security/integrity/ima/ima_template.c     |  3 +
 security/integrity/ima/ima_template_lib.c | 26 ++++++-
 security/integrity/ima/ima_template_lib.h |  2 +
 security/integrity/integrity.h            | 53 +++++++++++++--
 19 files changed, 329 insertions(+), 39 deletions(-)

-- 
2.27.0

