Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8700349EA88
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiA0Sqg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:36 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4531 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiA0Sqc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:32 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8gH2kzgz682bj;
        Fri, 28 Jan 2022 02:46:03 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:28 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 00/11] ima: support fs-verity digests and signatures (alternative)
Date:   Thu, 27 Jan 2022 19:46:09 +0100
Message-ID: <20220127184614.2837938-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I wanted to propose a different approach for handling fsverity digests and
signatures, compared to:

https://lore.kernel.org/linux-integrity/20220126000658.138345-1-zohar@linux.ibm.com/

In the original proposal, a new signature version has been introduced (v3)
to allow the possibility of signing the digest of a more flexible data
structure, ima_file_id, which could also include the fsverity file digest.

While the new signature type would be sufficient to handle fsverity file
digests, the problem is that its format would not be compatible with the
signature format supported by the built-in verification module in fsverity.
The rpm package manager already has an extension to include fsverity
signatures, with the existing format, in the RPM header.

Given that the fsverity signature is in the PKCS#7 format, IMA has already
the capability of handling it with the existing code, more specifically the
modsig code. It would be sufficient to provide to modsig the correct data
to avoid introducing a new signature format.

This is what this alternative patch set does. Patches 1-5, 8 have been
omitted as they almost don't need modification. Patches 6-7 of this patch
set extend the fsverity API to get the necessary information to handle the
existing fsverity signatures. Patch 8 (which could be split in two parts,
moving the appraisal-specific part to a new patch) gets the fsverity
formatted digest and the signature, if present, and use the obtained
information for measurement, appraisal and audit.

Interference with the code dealing with modsig has been elimitated by
introducing the new function ima_modsig_is_verity(), from which that
code knows how to deal with the data structure.

Also, the fsverity method needs to be enabled with the policy (no change
from the original patch set) and is used only if the xattr and modsig
appraisal methods are not available.

Regarding the measurement part, the original patch set avoids the ambiguity
of d-ng, or with the new template field d-type, or with the new signature
type IMA_XATTR_DIGSIG in the sig field. This patch set removes the
ambiguity by linking d-ng with d-modsig: if d-modsig is the digest of the
formatted digest including d-ng, sig is an fsverity signature, otherwise it
is a modsig signature.

Finally, this patch set addresses also the EVM part. Since the link of an
EVM portable signature/HMAC is not done anymore with the IMA xattr, as in
the original patch set, EVM directly fetches the formatted digest from
fsverity, and includes it in the HMAC/digest calculation. This behavior is
disabled by default and needs to be enabled in the kernel configuration.
A new function has been exposed to tell to IMA whether or not the fsverity
formatted digest is protected.

Remaining work would probably be to introduce new template fields to
specifically store the fsverity formatted digest and signature (instead of
d-modsig and modsig).

Mimi Zohar (6):
  ima: rename IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS
  ima: define ima_max_digest_data struct without a flexible array
    variable
  fs-verity: define a function to return the integrity protected file
    digest
  ima: define a new template field 'd-type' and a new template
    'ima-ngv2'
  ima: include fsverity's file digests in the IMA measurement list
  fsverity: update the documentation

Roberto Sassu (5):
  fsverity: Introduce fsverity_get_formatted_digest()
  fsverity: Introduce fsverity_get_signature()
  fsverity: Completely disable signature verification if not requested
  ima: Add support for fsverity signatures
  evm: Include fsverity formatted digest in the HMAC/digest calculation

 Documentation/ABI/testing/ima_policy      |  17 +++
 Documentation/filesystems/fsverity.rst    |  22 ++--
 Documentation/security/IMA-templates.rst  |  13 ++-
 fs/verity/Kconfig                         |   1 +
 fs/verity/fsverity_private.h              |   7 --
 fs/verity/measure.c                       | 123 ++++++++++++++++++++++
 fs/verity/signature.c                     |  12 +--
 include/linux/evm.h                       |   9 ++
 include/linux/fsverity.h                  |  37 +++++++
 security/integrity/evm/Kconfig            |  15 +++
 security/integrity/evm/evm_crypto.c       |  18 ++++
 security/integrity/evm/evm_main.c         |   4 +
 security/integrity/ima/ima.h              |  21 +++-
 security/integrity/ima/ima_api.c          |  19 +++-
 security/integrity/ima/ima_appraise.c     |  67 ++++++++++--
 security/integrity/ima/ima_crypto.c       |   2 +-
 security/integrity/ima/ima_init.c         |   9 +-
 security/integrity/ima/ima_main.c         |  34 +++++-
 security/integrity/ima/ima_modsig.c       |  75 +++++++++++++
 security/integrity/ima/ima_policy.c       |  40 ++++++-
 security/integrity/ima/ima_template.c     |   3 +
 security/integrity/ima/ima_template_lib.c |  23 +++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  30 +++++-
 24 files changed, 553 insertions(+), 50 deletions(-)

-- 
2.32.0

