Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359E4ACE36
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343507AbiBHBsL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344851AbiBHBmW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA95C061355;
        Mon,  7 Feb 2022 17:42:21 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217MZBR3010102;
        Tue, 8 Feb 2022 01:42:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=UNUur/hBWvqFbCPOd/NO7v0L0HXsVxHb5kP1rmwZ78I=;
 b=FC5+b6Yg+hB7IS0MJtqKFStj1ANHUixlyf5/N0SCLdYIP9Z2nivXWkxXV5gcN39Bsn9c
 cPQSA1AfKj6irNGuaX4zot06MnARp8u6MxsTJp1qUuYQCkCD5UIsNZ3AS1JgATfVMtc1
 5PYLhYfqY/X7ZLZqHbB8THCY0qR8JU2WtbOr4tkEj/61TgMAcbO5Wz8cTsOQD6qbq4Od
 +Yu8PO1mTrL7AC7dumfNxYZtzYqRX8Z/+QFuwqfZ4kyBnRDCxvzS29dlIS9jf30oPogj
 k2n19aorhPRAD17c+d8RMeBqtupKwSwc/nv2x7jaAWlaZO/O8kLCv23JbupW7IuDEGKz Mw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22qf4n4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181WqOr025785;
        Tue, 8 Feb 2022 01:42:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3e1ggj0pqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gDB339584252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:13 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55EB9A4057;
        Tue,  8 Feb 2022 01:42:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B102A4053;
        Tue,  8 Feb 2022 01:42:12 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:12 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/8] ima: support fs-verity digests and signatures
Date:   Mon,  7 Feb 2022 20:41:32 -0500
Message-Id: <20220208014140.483447-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tiZgD6NcCqFjkfNAaXxdhQJyE1d3TVam
X-Proofpoint-GUID: tiZgD6NcCqFjkfNAaXxdhQJyE1d3TVam
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 adultscore=0 malwarescore=0 clxscore=1015 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
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

Support for including fs-verity file digests and signatures in the IMA
measurement list as well as verifying the fs-verity file digest based
signatures, both based on IMA policy rules, was discussed prior to
fs-verity being upstreamed[1,2].

Support for including fs-verity file digests in the 'd-ng' template field
is based on a new policy rule option named 'digest_type=verity'.  A new
template field named 'd-type' as well as a new template named 'ima-ngv2'
are defined to differentiate between the regular IMA file hashes from the
fs-verity file digests (tree-hash based file hashes) stored in the 'd-ng'
template field.

Support for verifying fs-verity based file signatures stored in the
'security.ima' xattr is similarly based on the policy rule option
'digest_type=verity'.

To differentiate IMA from fs-verity file signatures a new xattr_type
named IMA_VERITY_DIGSIG is defined.  Signature version 3, which is a hash
of the ima_file_id struct, disambiguates the signatures stored as
'security.ima' xattr.  fs-verity only supports the new signature format
(version 3).  To prevent abuse of the different signature formats, policy
rules must be limited to a specific signature version.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Changelog v4:
- Based on Eric Bigger's signature verification concerns of replacing the
  contents of a file with the ima_file_id struct hash, require per policy
  rule signature versions.
- Addressed Eric Bigger's other comments.
- Added new audit messages "causes".
- Updated patch descriptions.

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
  ima: permit fsverity's file digests in the IMA measurement list
  ima: define signature version 3
  ima: support fs-verity file digest based version 3 signatures
  fsverity: update the documentation

 Documentation/ABI/testing/ima_policy      |  22 +++++
 Documentation/filesystems/fsverity.rst    |  22 +++--
 Documentation/security/IMA-templates.rst  |  11 ++-
 fs/verity/Kconfig                         |   1 +
 fs/verity/fsverity_private.h              |   7 --
 fs/verity/measure.c                       |  41 ++++++++
 include/linux/fsverity.h                  |  18 ++++
 security/integrity/digsig.c               |   3 +-
 security/integrity/ima/ima_api.c          |  59 ++++++++---
 security/integrity/ima/ima_appraise.c     | 113 +++++++++++++++++++++-
 security/integrity/ima/ima_init.c         |  10 +-
 security/integrity/ima/ima_main.c         |   2 +-
 security/integrity/ima/ima_policy.c       |  45 ++++++++-
 security/integrity/ima/ima_template.c     |   3 +
 security/integrity/ima/ima_template_lib.c |  23 ++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  53 +++++++++-
 17 files changed, 385 insertions(+), 50 deletions(-)

-- 
2.27.0

