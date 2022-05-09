Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68204520538
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 May 2022 21:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240523AbiEITYT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 15:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240536AbiEITYR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 15:24:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576BC245795
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 May 2022 12:20:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f4dee8688cso126633767b3.16
        for <linux-fscrypt@vger.kernel.org>; Mon, 09 May 2022 12:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=H6QqIh+pI17Kk15/gtJ53p2UAO94Xn8dwVwMH5QlY3k=;
        b=aZd5gr74deqM0PWU/lTsKqXLMnEU65bjkdfRXqd8IAoV4e2yTN0Lc6cT8ljEWulBDy
         Xe7b/5PhZbbMwEgi+P0B23R4CjJ9xPKwiw80+c+NzKzgGRYqmU3K395ycca6WLi5eSTj
         wrDuVjkynlnh6oJX3w9QlPiOsXuWO/DtOo0ao738l9PsiLadtKHtBgI7SxWq80alDH00
         niCt4VFfXXbbj/mlX26d0Mlg8hwJ1tImpq8pmSeK/PgsTuSDitJaobJPIqcBJly3dD9U
         q9+xhZdPKCXejuKLaWy5snj96wMKZZaS8Yqvair1sZdQjm/hr6aKOEOX+mKklKneV3Yd
         h45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=H6QqIh+pI17Kk15/gtJ53p2UAO94Xn8dwVwMH5QlY3k=;
        b=1vAM/8mAjNhESfw2AvyAhhXeyQKpu1ifM3vTi+jrjcTbubRONYYy9VyvdXH1Taq2pN
         ler0zyRr1v8Y9PGwzbyfww+s5tetQaJLPbE9esW5Cjtqfw+55BmWvrX5o/v69UfWQYgt
         7k86tG6O3cABg5yIZWVgj0V1ys9pZirSIq6pfOQu63vJjUoIJ1RDgGbpG9wI579w+dFF
         /IKoCpbWzMvqJLK67tySgICJmoHAk8C6qpNfc7+XOpvwikFPTdk9oBFPkLbRj2w5vuZw
         yh4n3+3Gf/xxIITnPmrPcLk7ssFUp4/gVEEsNEhfoE3WzRYfDaD7rtiZujqiy+AwwPTV
         UQng==
X-Gm-Message-State: AOAM533zaf30nl3Skp2JVXUW1Hn8QZrqpRZByonuRvbU3V2FXgJFyida
        upwl9nQ+Fy86nfFXXBheLQTa/ojzuw==
X-Google-Smtp-Source: ABdhPJyrf244tD9QmISI/73P96aZPF8Hub18aiV5tm/9iMdpU9npSqAqFJxLhjCSPjKaxcMF94TNF+TrQw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a0d:eb4b:0:b0:2f8:9089:3ad4 with SMTP id
 u72-20020a0deb4b000000b002f890893ad4mr15479867ywe.65.1652124017396; Mon, 09
 May 2022 12:20:17 -0700 (PDT)
Date:   Mon,  9 May 2022 19:10:58 +0000
Message-Id: <20220509191107.3556468-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH v7 0/9] crypto: HCTR2 support
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
 arch/arm64/crypto/aes-glue.c            |   82 +-
 arch/arm64/crypto/aes-modes.S           |  338 +++--
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
 25 files changed, 4355 insertions(+), 199 deletions(-)
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

