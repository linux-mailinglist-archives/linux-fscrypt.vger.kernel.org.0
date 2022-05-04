Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035365192A8
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 May 2022 02:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243203AbiEDAWL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 May 2022 20:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiEDAWL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 May 2022 20:22:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B552342A0F
        for <linux-fscrypt@vger.kernel.org>; Tue,  3 May 2022 17:18:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w133-20020a25c78b000000b0064847b10a22so16928882ybe.18
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 May 2022 17:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=mj48fHHaUDuN4yy8hcAAY5+2UaHiNilq4RJZoBQ5Oc8=;
        b=IxvLtmaP7cvO5HZ/GJvfdOkQpkyZAbERyP59coJGc8rt2yYoH0VHDayFN9sBvUh07Z
         qG1YCvior3FsOeftw4ZD+keFM+Srk35Q4qUpZ7UaDNTNGI1cK927Fd28vXC40EViZBO0
         pdjr8gT/oM03+TCQ0yK3MiJx7p59E2Qb5DdsULSi908yjq/onn0wLcfpv+LtueKVnHFO
         3YkZUFyoBswcnIUF6Y67nppP1oANT4rapYToJRYg9Mg3cbsAfs6gBmQtE8ijT/voi6do
         i5+kr7yv6wZv+uSSdjS+M1qokxDd+3Lm4EBMtNQUWy0/a2nLAS+ZOSmW+11SOtLBcPPZ
         2KpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=mj48fHHaUDuN4yy8hcAAY5+2UaHiNilq4RJZoBQ5Oc8=;
        b=OqAiNfGzNXH4zOJ2QWFAnEe1SjIW0S7spyGTtyZ0jsu9mlF39fveX3pLS7w7i+L/Sd
         p70+38fHUrAyTneu9OA7YDrZsrFR1dvVwKUrPkxbCNQplUSC5qyHyKlFZUl5JEN0lgiL
         p6NTYj5FNLG/QNcfYXRUOVqo6yTladBGIPELnIckayeDUW4V+Wm+qyt+0xn3OjPyXdCD
         YvCPOrHd0WvQith9RKTYOcOncpLKbRxqEDzpB0C/1gY33Z/qDanpev6TEUFyQe6rboFB
         h7XmpTRQAub7DXqg7IUttssIsQYxfilQA40CRocWue2IZveNSCao9d9zg0CPMWWDwtgK
         PxXw==
X-Gm-Message-State: AOAM530DbhOsogZgnO3AkTJ+W0GUhEfi/YFVtYnq8Tp1cjd3Nt/qk/Hj
        /Mwb7pFl/++r2ddshLIKo5w2Qcw4yg==
X-Google-Smtp-Source: ABdhPJzyviXe6qjst27FZ+09lb/P0J0M7uqcA3q8ZW1YkTXItQepJ2CwdKdeFAlRuJCoFlXgcTx3IYRmqQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a0d:ddc6:0:b0:2f8:a506:a5c0 with SMTP id
 g189-20020a0dddc6000000b002f8a506a5c0mr18521523ywe.140.1651623515866; Tue, 03
 May 2022 17:18:35 -0700 (PDT)
Date:   Wed,  4 May 2022 00:18:14 +0000
Message-Id: <20220504001823.2483834-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 0/9] crypto: HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

HCTR2 is a length-preserving encryption mode that is efficient on
processors with instructions to accelerate AES and carryless
multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
processors with the ARMv8 Crypto Extensions.

HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving encryption
with HCTR2" which shows that if AES is secure and HCTR2 is instantiated
with AES, then HCTR2 is secure.  Reference code and test vectors are at
https://github.com/google/hctr2.

As a length-preserving encryption mode, HCTR2 is suitable for applications
such as storage encryption where ciphertext expansion is not possible, and
thus authenticated encryption cannot be used.  Currently, such applications
usually use XTS, or in some cases Adiantum.  XTS has the disadvantage that
it is a narrow-block mode: a bitflip will only change 16 bytes in the
resulting ciphertext or plaintext.  This reveals more information to an
attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property: a
bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
take advantage of existing crypto instructions, while Adiantum targets
devices without such hardware support.  Adiantum is also designed with
longer messages in mind, while HCTR2 is designed to be efficient even on
short messages.

The first intended use of this mode in the kernel is for the encryption of
filenames, where for efficiency reasons encryption must be fully
deterministic (only one ciphertext for each plaintext) and the existing CBC
solution leaks more information than necessary for filenames with common
prefixes.

HCTR2 uses two passes of an =CE=B5-almost-=E2=88=86-universal hash function=
 called
POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
polynomial hash designed for efficiency on modern processors and was
originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
variant of CTR mode that is more efficient on little-endian machines.

This patchset adds HCTR2 to Linux's crypto API, including generic
implementations of XCTR and POLYVAL, hardware accelerated implementations
of XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation
of HCTR2, and an fscrypt policy for using HCTR2 for filename encryption.

Changes in v6:
 * Split ARM64 XCTR/CTR refactoring into separate patch
 * Allow simd POLYVAL implementations to be preempted
 * Fix uninitialized bug in HCTR2
 * Fix streamcipher name handling bug in HCTR2
 * Various small style fixes

Changes in v5:
 * Refactor HCTR2 tweak hashing
 * Remove non-AVX x86-64 XCTR implementation
 * Combine arm64 CTR and XCTR modes
 * Comment and alias CTR and XCTR modes
 * Move generic fallback code for simd POLYVAL into polyval-generic.c
 * Various small style fixes

Changes in v4:
 * Small style fixes in generic POLYVAL and XCTR
 * Move HCTR2 hash exporting/importing to helper functions
 * Rewrite montgomery reduction for x86-64 POLYVAL
 * Rewrite partial block handling for x86-64 POLYVAL
 * Optimize x86-64 POLYVAL loop handling
 * Remove ahash wrapper from x86-64 POLYVAL
 * Add simd-unavailable handling to x86-64 POLYVAL
 * Rewrite montgomery reduction for ARM64 POLYVAL
 * Rewrite partial block handling for ARM64 POLYVAL
 * Optimize ARM64 POLYVAL loop handling
 * Remove ahash wrapper from ARM64 POLYVAL
 * Add simd-unavailable handling to ARM64 POLYVAL

Changes in v3:
 * Improve testvec coverage for XCTR, POLYVAL and HCTR2
 * Fix endianness bug in xctr.c
 * Fix alignment issues in polyval-generic.c
 * Optimize hctr2.c by exporting/importing hash states
 * Fix blockcipher name derivation in hctr2.c
 * Move x86-64 XCTR implementation into aes_ctrby8_avx-x86_64.S
 * Reuse ARM64 CTR mode tail handling in ARM64 XCTR
 * Fix x86-64 POLYVAL comments
 * Fix x86-64 POLYVAL key_powers type to match asm
 * Fix ARM64 POLYVAL comments
 * Fix ARM64 POLYVAL key_powers type to match asm
 * Add XTS + HCTR2 policy to fscrypt

Nathan Huckleberry (9):
  crypto: xctr - Add XCTR support
  crypto: polyval - Add POLYVAL support
  crypto: hctr2 - Add HCTR2 support
  crypto: x86/aesni-xctr: Add accelerated implementation of XCTR
  crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
  crypto: arm64/aes-xctr: Improve readability of XCTR and CTR modes
  crypto: x86/polyval: Add PCLMULQDQ accelerated implementation of
    POLYVAL
  crypto: arm64/polyval: Add PMULL accelerated implementation of POLYVAL
  fscrypt: Add HCTR2 support for filename encryption

 Documentation/filesystems/fscrypt.rst   |   22 +-
 arch/arm64/crypto/Kconfig               |    9 +-
 arch/arm64/crypto/Makefile              |    3 +
 arch/arm64/crypto/aes-glue.c            |   64 +-
 arch/arm64/crypto/aes-modes.S           |  309 +++--
 arch/arm64/crypto/polyval-ce-core.S     |  367 ++++++
 arch/arm64/crypto/polyval-ce-glue.c     |  190 +++
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  232 ++--
 arch/x86/crypto/aesni-intel_glue.c      |  114 +-
 arch/x86/crypto/polyval-clmulni_asm.S   |  331 +++++
 arch/x86/crypto/polyval-clmulni_glue.c  |  202 +++
 crypto/Kconfig                          |   39 +-
 crypto/Makefile                         |    3 +
 crypto/hctr2.c                          |  581 +++++++++
 crypto/polyval-generic.c                |  245 ++++
 crypto/tcrypt.c                         |   10 +
 crypto/testmgr.c                        |   20 +
 crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
 crypto/xctr.c                           |  191 +++
 fs/crypto/fscrypt_private.h             |    2 +-
 fs/crypto/keysetup.c                    |    7 +
 fs/crypto/policy.c                      |   14 +-
 include/crypto/polyval.h                |   22 +
 include/uapi/linux/fscrypt.h            |    3 +-
 25 files changed, 4321 insertions(+), 198 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.36.0.464.gb9c8b46e94-goog

