Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E6D4E7D2B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 26 Mar 2022 01:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiCYWk3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Mar 2022 18:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbiCYWk2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Mar 2022 18:40:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496C118CD3F;
        Fri, 25 Mar 2022 15:38:53 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PJqTkT023838;
        Fri, 25 Mar 2022 22:38:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=9Vf2Np/u8aW3zAC23uIh4/co9Mu6SLc68vzzyshG+Qw=;
 b=iLh4FLpUYmmB14aEgn0aa2GbC9FAezdlunTZSBAkcVkeMji2vAHO59Lwc+xM0TElnpGa
 mLE7MBRjOAV/2kZ6bfiyy7xH436/zSjSF6J2jRl527zekEuOhuGpNHHImIP/jK6Ma4qm
 umaJ7zUFP+3pXjyrue/aAmoZ9fFyv9AWjLnXI7x/tzx0j10XGWLzFbcwyuQ2fpfwsfPC
 AQOfRFmSiz6YGsIrhb0JLCNLyRi4mL4pp2DV1AF6q+bT+ov5PDNtt7+4+5leVtQLRQa+
 qPCrmLDASFygsMvVy4WTZSlWsq9RiGRh/u3PhlrQzPnVgBhZT/U5Sff6/ErfHJTfCzx5 3w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0q5p8ce8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:50 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PMY3C5006528;
        Fri, 25 Mar 2022 22:38:48 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej64cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 22:38:48 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PMQu7x46662134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 22:26:56 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 197E8A405C;
        Fri, 25 Mar 2022 22:38:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 132A5A4054;
        Fri, 25 Mar 2022 22:38:44 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.52])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Mar 2022 22:38:43 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/5] ima: support fs-verity digests and signatures
Date:   Fri, 25 Mar 2022 18:38:19 -0400
Message-Id: <20220325223824.310119-1-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pGc8BDZFeGkgjhEFIQ3oRKjJ8zcyOrEl
X-Proofpoint-GUID: pGc8BDZFeGkgjhEFIQ3oRKjJ8zcyOrEl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_08,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
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

Support for including fs-verity file digests and signatures in the IMA
measurement list as well as verifying the fs-verity file digest based
signatures was discussed prior to fs-verity being upstreamed[1,2].

Including fs-verity file digests and signatures in the IMA measurement
list need to be based on policy and be identifiable.  To address being
based on policy, a new policy rule option "digest_type=verity", applicable
to both "measure" and "appraise" policy rules, is defined.  To address
being identifiable, a new template field 'd-ngv2' and two new template
formats 'ima-ngv2' and 'ima-sigv2' are defined.

d-ngv2:  prefixes the digest type ("ima", "verity") to the digest
algorithm and digest.

ima-ngv2', ima-sigv2: templates with the new d-ngv2 field defined.

In addition the signatures stored in 'security.ima' xattr need to be
disambiguated.  So instead of directly signing the fs-verity digest, the
fs-verity digest is indirectly signed, by signing the hash of the new
ima_file_id structure data (signature version 3) containing the fs-verity
digest and other metadata.

New policy rule option:
appraise_type=sigv3: support for new IMA signature version 3


[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
[2] Documentation/filesystems/fsverity.rst

Changelog v7:
- Based on Stefan Berger's review, cleaned up code by defining an enum,
  removed unnecessary memcpy, fs-verity documentation suggestions.
- Add comment in ima_get_verify_digest() with explanation for always
  returning the fs-verity digest.

Changelog v6:
- As suggested by Eric Bigger's, instead of defining a new field to
  differentiate between IMA and fs-verity signatures, prepend the
  digest type to the digest field.
- Addressed Eric Bigger's comments: updated the patch description,
  corrected comment, squashed patches, fixed enumeration usage,and
  added assumption to fsverity_get_digest.
- Removed the now unnecessary IMA_VERITY_DIGEST flag
- Updated kernel-parameters.txt

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

Mimi Zohar (5):
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new template field named 'd-ngv2' and templates
  ima: permit fsverity's file digests in the IMA measurement list
  ima: support fs-verity file digest based version 3 signatures
  fsverity: update the documentation

 Documentation/ABI/testing/ima_policy          |  36 +++++-
 .../admin-guide/kernel-parameters.txt         |   3 +-
 Documentation/filesystems/fsverity.rst        |  20 +--
 Documentation/security/IMA-templates.rst      |  12 +-
 fs/verity/Kconfig                             |   1 +
 fs/verity/fsverity_private.h                  |   7 --
 fs/verity/measure.c                           |  43 +++++++
 include/linux/fsverity.h                      |  18 +++
 security/integrity/digsig.c                   |   3 +-
 security/integrity/ima/ima_api.c              |  44 ++++++-
 security/integrity/ima/ima_appraise.c         | 114 +++++++++++++++++-
 security/integrity/ima/ima_policy.c           |  68 ++++++++++-
 security/integrity/ima/ima_template.c         |   4 +
 security/integrity/ima/ima_template_lib.c     |  86 +++++++++++--
 security/integrity/ima/ima_template_lib.h     |   4 +
 security/integrity/integrity.h                |  26 +++-
 16 files changed, 445 insertions(+), 44 deletions(-)

-- 
2.27.0

