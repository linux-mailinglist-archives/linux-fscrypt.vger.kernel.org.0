Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD848B4E7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 19:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350105AbiAKSEE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 13:04:04 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4388 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345156AbiAKSDv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 13:03:51 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JYJQj1JcLz67Cr0;
        Wed, 12 Jan 2022 02:01:01 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 11 Jan 2022 19:03:46 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <dhowells@redhat.com>, <dwmw2@infradead.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zohar@linux.ibm.com>,
        <ebiggers@kernel.org>, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
Date:   Tue, 11 Jan 2022 19:03:04 +0100
Message-ID: <20220111180318.591029-1-roberto.sassu@huawei.com>
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

Support for PGP keys and signatures was proposed by David long time ago,
before the decision of using PKCS#7 for kernel modules signatures
verification was made. After that, there has been not enough interest to
support PGP too.

Lately, when discussing a proposal of introducing fsverity signatures in
Fedora [1], developers expressed their preference on not having a separate
key for signing, which would complicate the management of the distribution.
They would be more in favor of using the same PGP key, currently used for
signing RPM headers, also for file-based signatures (not only fsverity, but
also IMA ones).

Another envisioned use case would be to add the ability to appraise RPM
headers with their existing PGP signature, so that they can be used as an
authenticated source of reference values for appraising remaining
files [2].

To make these use cases possible, introduce support for PGP keys and
signatures in the kernel, and load provided PGP keys in the built-in
keyring, so that PGP signatures of RPM headers, fsverity digests, and IMA
digests can be verified from this trust anchor.

In addition to the original version of the patch set, also introduce
support for signature verification of PGP keys, so that those keys can be
added to keyrings with a signature-based restriction (e.g. .ima). PGP keys
are searched with partial IDs, provided with signature subtype 16 (Issuer).
Search with full IDs could be supported with
draft-ietf-openpgp-rfc4880bis-10, by retrieving the information from
signature subtype 33 (Issuer Fingerprint). Due to the possibility of ID
collisions, the key_or_keyring restriction is not supported.

The patch set includes two preliminary patches: patch 1 introduces
mpi_key_length(), to get the number of bits and bytes of an MPI; patch 2
introduces rsa_parse_priv_key_raw() and rsa_parse_pub_key_raw(), to parse
an RSA key in RAW format if the ASN.1 parser returns an error.

Patches 3-5 introduce the library necessary to parse PGP keys and
signatures, whose support is added with patches 6-10. Patch 11 introduces
verify_pgp_signature() to be used by kernel subsystems (e.g. fsverity and
IMA). Patch 12 is for testing of PGP signatures. Finally, patches 13-14
allow loading a set of PGP keys from a supplied blob at boot time.

I generated the diff from [3] (rebased). It is available at:

https://github.com/robertosassu/linux/compare/pgp-signatures-v1-orig..pgp-signatures-v1

Changelog

v0 [3]:
- style fixes
- move include/linux/pgp.h and pgplib.h to crypto/asymmetric_keys
- introduce verify_pgp_signature()
- replace KEY_ALLOC_TRUSTED flag with KEY_ALLOC_BUILT_IN
- don't fetch PGP subkeys
- drop support for DSA
- store number of MPIs in pgp_key_algo_p_num_mpi array
- replace dynamic memory allocations with static ones in
  pgp_generate_fingerprint()
- store only keys with capability of verifying signatures
- remember selection of PGP signature packet and don't repeat parsing
- move search of the PGP key to verify the signature from the beginning
  to the end of the verification process (to be similar with PKCS#7)
- don't retry key search in the session keyring from the signature
  verification code, let the caller pass the desired keyring
- for the PGP signature test key type, retry the key search in the session
  keyring
- retry key search in restrict_link_by_signature() with a partial ID
  (provided in the PGP signature)

[1] https://fedoraproject.org/wiki/Changes/FsVerityRPM
[2] https://fedoraproject.org/wiki/Changes/DIGLIM
[3] https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pgp-parser

David Howells (8):
  PGPLIB: PGP definitions (RFC 4880)
  PGPLIB: Basic packet parser
  PGPLIB: Signature parser
  KEYS: PGP data parser
  KEYS: Provide PGP key description autogeneration
  KEYS: PGP-based public key signature verification
  PGP: Provide a key type for testing PGP signatures
  KEYS: Provide a function to load keys from a PGP keyring blob

Roberto Sassu (6):
  mpi: Introduce mpi_key_length()
  rsa: add parser of raw format
  KEYS: Retry asym key search with partial ID in
    restrict_link_by_signature()
  KEYS: Calculate key digest and get signature of the key
  verification: introduce verify_pgp_signature()
  KEYS: Introduce load_pgp_public_keyring()

 MAINTAINERS                             |   1 +
 certs/Kconfig                           |  11 +
 certs/Makefile                          |   7 +
 certs/system_certificates.S             |  18 +
 certs/system_keyring.c                  |  91 ++++
 crypto/asymmetric_keys/Kconfig          |  38 ++
 crypto/asymmetric_keys/Makefile         |  13 +
 crypto/asymmetric_keys/pgp.h            | 206 ++++++++
 crypto/asymmetric_keys/pgp_library.c    | 620 ++++++++++++++++++++++++
 crypto/asymmetric_keys/pgp_parser.h     |  18 +
 crypto/asymmetric_keys/pgp_preload.c    | 110 +++++
 crypto/asymmetric_keys/pgp_public_key.c | 484 ++++++++++++++++++
 crypto/asymmetric_keys/pgp_signature.c  | 507 +++++++++++++++++++
 crypto/asymmetric_keys/pgp_test_key.c   | 129 +++++
 crypto/asymmetric_keys/pgplib.h         |  74 +++
 crypto/asymmetric_keys/restrict.c       |  10 +-
 crypto/rsa.c                            |  14 +-
 crypto/rsa_helper.c                     |  69 +++
 include/crypto/internal/rsa.h           |   6 +
 include/crypto/pgp.h                    |  35 ++
 include/linux/mpi.h                     |   2 +
 include/linux/verification.h            |  23 +
 lib/mpi/mpicoder.c                      |  33 +-
 23 files changed, 2506 insertions(+), 13 deletions(-)
 create mode 100644 crypto/asymmetric_keys/pgp.h
 create mode 100644 crypto/asymmetric_keys/pgp_library.c
 create mode 100644 crypto/asymmetric_keys/pgp_parser.h
 create mode 100644 crypto/asymmetric_keys/pgp_preload.c
 create mode 100644 crypto/asymmetric_keys/pgp_public_key.c
 create mode 100644 crypto/asymmetric_keys/pgp_signature.c
 create mode 100644 crypto/asymmetric_keys/pgp_test_key.c
 create mode 100644 crypto/asymmetric_keys/pgplib.h
 create mode 100644 include/crypto/pgp.h

-- 
2.32.0

