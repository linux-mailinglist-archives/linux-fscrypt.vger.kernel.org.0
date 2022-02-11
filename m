Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7A24B2F98
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Feb 2022 22:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353787AbiBKVn2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Feb 2022 16:43:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350658AbiBKVn1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Feb 2022 16:43:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD9AC62;
        Fri, 11 Feb 2022 13:43:25 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BLUc67019629;
        Fri, 11 Feb 2022 21:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=lAPZZmqkcdFxs/5+7TVyE8qan2jmuvnoLt958gIaeZ4=;
 b=KhCP/OOwA+9qW0eKbNMptsSojN0TLutopKiV5eAcIB/ZGxnRIDU9xQllW4uGgLJysVhf
 bS+arq6JHw/qxpwJUpLRyFrmHY2i3miRRNv/j4cI3CZtvVUIOef/8vsbCEMus4fMagqT
 5c+PrcjEc8nGRIyl10xDaFAzv6m9LdM6Wpq5dERPg46kWAdwiBLJylrkfah47GQrXlpk
 OA03kzrGRCwAiksN5oI5N/lbfJTO61JgkItVkOwlnYcFFHtLZ8OVllvIlw9bGdITXK/C
 8Dve38D32aHOA6cNi6NZB3rxpWdElHIMaa2gJMjf6DsrGtmXz7VVzN74tfjPTrnM7VAf hw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e50hjref2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:22 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BLYD5s008618;
        Fri, 11 Feb 2022 21:43:21 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygr1hxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 21:43:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BLhHoD45940994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:43:17 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A0D52052;
        Fri, 11 Feb 2022 21:43:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.69.128])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5E0785204E;
        Fri, 11 Feb 2022 21:43:16 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/8] ima: support fs-verity digests and signatures
Date:   Fri, 11 Feb 2022 16:43:02 -0500
Message-Id: <20220211214310.119257-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LRZzjNPK9YY_yH5iBAwWKQMXFK3i8rH9
X-Proofpoint-ORIG-GUID: LRZzjNPK9YY_yH5iBAwWKQMXFK3i8rH9
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110108
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

Support for including fs-verity file digests in the 'd-ng' template
field is based on a new policy rule option named 'digest_type=verity'.
A new template field named 'd-type' as well as a new template named
'ima-ngv2' are defined to differentiate between the regular IMA file
hashes from the fs-verity file digests (tree-hash based file hashes)
stored in the 'd-ng' template field of the measurement list.

A new signature version (v3) is defined as a hash of the 'ima_file_id'
struct, to disambiguate the signatures stored as 'security.ima' xattr.
The policy rule 'appraise_type=' option is extended to support 'sigv3',
which is initially limited to fs-verity.

The fs-verity 'appraise' rules are identified by the 'digest-type=verity'
option and require the 'appraise_type=sigv3' option.

Lastly, for IMA to differentiate between the original IMA signature
from an fs-verity signature a new 'xattr_type' named IMA_VERITY_DIGSIG
is defined.


[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Changelog v5:
- Define ima_max_digest_size struct, removing the locally defined versions.
- Don't overload the 'digest_type=verity' to imply a verity signature,
  but extend the 'appraise_type' policy rule option to define 'sigv3'.

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

 Documentation/ABI/testing/ima_policy      |  30 +++++-
 Documentation/filesystems/fsverity.rst    |  22 +++--
 Documentation/security/IMA-templates.rst  |  11 ++-
 fs/verity/Kconfig                         |   1 +
 fs/verity/fsverity_private.h              |   7 --
 fs/verity/measure.c                       |  41 ++++++++
 include/linux/fsverity.h                  |  18 ++++
 security/integrity/digsig.c               |   3 +-
 security/integrity/ima/ima_api.c          |  49 ++++++++--
 security/integrity/ima/ima_appraise.c     | 112 +++++++++++++++++++++-
 security/integrity/ima/ima_init.c         |   5 +-
 security/integrity/ima/ima_main.c         |   7 +-
 security/integrity/ima/ima_policy.c       |  66 +++++++++++--
 security/integrity/ima/ima_template.c     |   3 +
 security/integrity/ima/ima_template_lib.c |  28 +++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  39 +++++++-
 17 files changed, 388 insertions(+), 56 deletions(-)

-- 
2.27.0

