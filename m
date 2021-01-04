Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC52E9FCA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 23:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbhADWBy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 17:01:54 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:32340 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhADWBy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 17:01:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609797542;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=/l4AZil43hDxz8/ZZ/lKuvRDLAdZAYmH4XExlIK8Y+E=;
        b=iTzsclHzfWa/rmOKHHo+ulzXGe7S871BrhEoerjLWTJ/QJIicz4CTUA5F+MGfrjJPS
        BVdazQQ7FlcFXYEW4iDn80oN/P7pKDAB8TeeCzlgS0cztwX15MQqjeHYr62RVQgU3Wh3
        25TmmIP7BNb8EFc/JU9U0lHxF+UHjBkWmLQN0we8fiyhyAYdVVuRKqkbA1g2v5LqK3n4
        YdQBt5OUUqx+g1mlJ4GY5A8W71q9lg9+wsT+U70YBg6Jp7YfCUhEWBsdvy1ac3Embzhf
        z+08mUqJoLmSmUkWTQlbUvTJdxcin1qOA1Ft+LWBKRCAAxBn39Ud90iGNhREEPSCiWMA
        qdwQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSZFqc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id h02bd9x04LqmxfO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 4 Jan 2021 22:52:48 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH 0/5] Add KDF implementations to crypto API
Date:   Mon, 04 Jan 2021 22:45:57 +0100
Message-ID: <4616980.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

The key derviation functions are considered to be a cryptographic
operation. As cryptographic operations are provided via the kernel
crypto API, this patch set consolidates the KDF implementations into the
crypto API.

The KDF implementations are provided as service functions. Yet, the
interface to the two provided KDFs are identical with the goal to allow
them to be transformed into a crypto API template eventually.

The KDFs execute a power-on self test with test vectors from commonly
known sources.

Tbe SP800-108 KDF implementation is used to replace the implementation
in the keys subsystem. The implementation was verified using the
keyutils command line test code provided in
tests/keyctl/dh_compute/valid. All tests show that the expected values
are calculated with the new code.

The HKDF addition is used to replace the implementation in the filesystem
crypto extension. This code was tested by using an EXT4 encrypted file
system that was created and contains files written to by the current
implementation. Using the new implementation a successful read of the
existing files was possible and new files / directories were created
and read successfully. These newly added file system objects could be
successfully read using the current code. Yet if there is a test suite
to validate whether the invokcation of the HKDF calculates the same
result as the existing implementation, I would be happy to validate
the implementation accordingly.

Stephan Mueller (5):
  crypto: Add key derivation self-test support code
  crypto: add SP800-108 counter key derivation function
  crypto: add RFC5869 HKDF
  security: DH - use KDF implementation from crypto API
  fs: use HKDF implementation from kernel crypto API

 crypto/Kconfig                         |  14 ++
 crypto/Makefile                        |   6 +
 crypto/hkdf.c                          | 226 +++++++++++++++++++++++++
 crypto/kdf_sp800108.c                  | 149 ++++++++++++++++
 fs/crypto/Kconfig                      |   2 +-
 fs/crypto/fscrypt_private.h            |   4 +-
 fs/crypto/hkdf.c                       | 108 +++---------
 include/crypto/hkdf.h                  |  48 ++++++
 include/crypto/internal/kdf_selftest.h |  68 ++++++++
 include/crypto/kdf_sp800108.h          |  59 +++++++
 security/keys/Kconfig                  |   2 +-
 security/keys/dh.c                     | 118 ++-----------
 12 files changed, 617 insertions(+), 187 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 crypto/kdf_sp800108.c
 create mode 100644 include/crypto/hkdf.h
 create mode 100644 include/crypto/internal/kdf_selftest.h
 create mode 100644 include/crypto/kdf_sp800108.h

-- 
2.26.2




