Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF04301C99
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbhAXOKg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:10:36 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.101]:18552 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbhAXOKE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611497208;
        s=strato-dkim-0002; d=chronox.de;
        h=Message-ID:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=kD8GXYJD7ne6R4TTKn1bkqiMktIc67naKuk3V4KmkGQ=;
        b=rKxsCcbDsx8r0ELNMQf1n5B3j+esMZgzC0W7FX0UjSgcgth7aU9NBMVQGTe1H7gykp
        JVXaej1zwuBQ4aNW9HhfYbX9k/LKWHPzuHDxFuUDFdzBr07PGcFmcPB10nuh4cRsnBAo
        FGJiZtfly+IZ9IDK5T409UgcSA559dFGaeVD+jGQpCuYbzeEljJjbiIvArGT5kHxZ9/u
        TzkBoc1e4uua1MutLxb16tshVgv5dE26nEwmBH1Nj9xfWldbbk8/WC9jBAX7GmEGMBgk
        YtPGw5DjyB53RInjJUzVxAkj/ksFPIZG+QEIk5iMeg5HsVSH3CA+kyXJM+yFgPc25gEr
        1YGg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OE6meic
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:06:48 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     ebiggers@kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
        linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
        simo@redhat.com
Subject: [PATCH v2 0/7] Add KDF implementations to crypto API
Date:   Sun, 24 Jan 2021 15:01:12 +0100
Message-ID: <1772794.tdWV9SEqCh@positron.chronox.de>
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

Changes v2:

* change HKDF function names
* change HKDF/SP800-108 KDF extract / seed function prototype
* ensure clearing of memory of destination buffer in KDF implementation
  if KDF operation fails
* security DH: split the removal of dead code into separate patch

Stephan Mueller (7):
  crypto: Add key derivation self-test support code
  crypto: add SP800-108 counter key derivation function
  crypto: add RFC5869 HKDF
  security: DH - remove dead code for zero padding
  security: DH - use KDF implementation from crypto API
  fs: use HKDF implementation from kernel crypto API
  fs: HKDF - remove duplicate memory clearing

 crypto/Kconfig                         |  14 ++
 crypto/Makefile                        |   6 +
 crypto/hkdf.c                          | 199 +++++++++++++++++++++++++
 crypto/kdf_sp800108.c                  | 149 ++++++++++++++++++
 fs/crypto/Kconfig                      |   2 +-
 fs/crypto/hkdf.c                       | 103 +++----------
 include/crypto/hkdf.h                  |  48 ++++++
 include/crypto/internal/kdf_selftest.h |  71 +++++++++
 include/crypto/kdf_sp800108.h          |  61 ++++++++
 security/keys/Kconfig                  |   2 +-
 security/keys/dh.c                     | 118 ++-------------
 11 files changed, 586 insertions(+), 187 deletions(-)
 create mode 100644 crypto/hkdf.c
 create mode 100644 crypto/kdf_sp800108.c
 create mode 100644 include/crypto/hkdf.h
 create mode 100644 include/crypto/internal/kdf_selftest.h
 create mode 100644 include/crypto/kdf_sp800108.h

-- 
2.26.2




