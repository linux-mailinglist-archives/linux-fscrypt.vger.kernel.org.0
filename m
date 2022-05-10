Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7541522262
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 May 2022 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347966AbiEJR2P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 May 2022 13:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244672AbiEJR2O (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 May 2022 13:28:14 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7701826FA4E
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 May 2022 10:24:16 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id s14-20020ab02bce000000b0035d45862725so8516472uar.22
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 May 2022 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=6r/ZpHbsiySxV5VQid/gvVbmfYmzXarl5519kJ622bw=;
        b=dthyzoCTryNs5xJ3SDkvyOldofJ+9s+5hFYp60WuytpwZA6ipz5clneS4WKnri/9Nb
         2MSBTQRE51h6uI1KNKrYtF1MNLX38EGbEq8kKlgo6w2HOEI/awixcC5l8tOMQl4Cm7fz
         200qG6F+MDfVSAep5eQjL4bJxlCc0V11eLSLhhu0Oi/pIO4u4zmyk9ujcDX1k4NYNUSw
         bNMFmRUjxfzSBdN1f1g286uFVjTk/k6Q6qeIywCwx6zTtdnyYHqgMb3GbCdF26HOjLHr
         LjG4xouTbO+T6W35YEN+IVehq0eebxjp7XdQoxn+9zzpGH/rPetP2F8R727MVzqaqOWb
         zLJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=6r/ZpHbsiySxV5VQid/gvVbmfYmzXarl5519kJ622bw=;
        b=NpYaghDNb0pS0UMgJFDStX+8dibFDDgO6/Imsbckn9uNIGpBEjflEGwQVNb4GUzUG2
         tRYI4e88T94mWL3cUQP0ltmhe7ocutq1+CyZPasOw/wTvcgs3l5bzUyyz5Bm+UvokeJa
         E4Ak1KFtuh0LnyTlqyo4jGq9KltpCZb8pSmqZn6gKnRc2IR/zf5rL160/G1bUAtQvvSC
         B2eFPeU+k4ku1jYFnk0Yp+b8qeMe9cOvxK+xIKFhfXyQYqjV60q2dKrhq9Q2YsJukpLt
         1gdXfNVwJ45ZvcE8gvwsT0lmibxkXMn7TlJr4viTZy+viXf3L1TwFogVSs8oi9/U+3zH
         Mv5g==
X-Gm-Message-State: AOAM5306W1UYnwYfYBwEaOprWNlO5Igs6B/RKKBRRux5cjR9arJ9puhQ
        H4T3anC6bYM+vWjCpeLTxsVe3Or8NA==
X-Google-Smtp-Source: ABdhPJwTXo8rNem0I447e4qtWcPuz/r0rU0CiMyBopSV7rxnh39eNWjXVHNBaa1OsOP0dOTvgtajwApRBw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a1f:5c0b:0:b0:34d:719f:bf13 with SMTP id
 q11-20020a1f5c0b000000b0034d719fbf13mr12771625vkb.19.1652203455523; Tue, 10
 May 2022 10:24:15 -0700 (PDT)
Date:   Tue, 10 May 2022 17:23:50 +0000
Message-Id: <20220510172359.3720527-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v8 0/9] crypto: HCTR2 support
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
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

Changes in v8:
 * Fix incorrect x86 POLYVAL comment
 * Add additional comments to ARM64 XCTR/CTR implementation

Changes in v7:
 * Added/modified some comments in ARM64 XCTR/CTR implementation
 * Various small style fixes

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
 arch/arm64/crypto/aes-glue.c            |   80 +-
 arch/arm64/crypto/aes-modes.S           |  349 +++--
 arch/arm64/crypto/polyval-ce-core.S     |  361 ++++++
 arch/arm64/crypto/polyval-ce-glue.c     |  193 +++
 arch/x86/crypto/Makefile                |    3 +
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  232 ++--
 arch/x86/crypto/aesni-intel_glue.c      |  114 +-
 arch/x86/crypto/polyval-clmulni_asm.S   |  321 +++++
 arch/x86/crypto/polyval-clmulni_glue.c  |  203 +++
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
 25 files changed, 4364 insertions(+), 199 deletions(-)
 create mode 100644 arch/arm64/crypto/polyval-ce-core.S
 create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
 create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
 create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
 create mode 100644 crypto/hctr2.c
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 crypto/xctr.c
 create mode 100644 include/crypto/polyval.h

--=20
2.36.0.512.ge40c2bad7a-goog

