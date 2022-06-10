Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F2546166
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jun 2022 11:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348279AbiFJJQW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jun 2022 05:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348580AbiFJJPj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jun 2022 05:15:39 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B2249323;
        Fri, 10 Jun 2022 02:15:24 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzajf-005MXu-VZ; Fri, 10 Jun 2022 19:15:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:15:20 +0800
Date:   Fri, 10 Jun 2022 17:15:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v9 0/9] crypto: HCTR2 support
Message-ID: <YqMLqNlDnfqsKasc@gondor.apana.org.au>
References: <20220520181501.2159644-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520181501.2159644-1-nhuck@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 20, 2022 at 06:14:52PM +0000, Nathan Huckleberry wrote:
> HCTR2 is a length-preserving encryption mode that is efficient on
> processors with instructions to accelerate AES and carryless
> multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> processors with the ARMv8 Crypto Extensions.
> 
> HCTR2 is specified in https://ia.cr/2021/1441 "Length-preserving encryption
> with HCTR2" which shows that if AES is secure and HCTR2 is instantiated
> with AES, then HCTR2 is secure.  Reference code and test vectors are at
> https://github.com/google/hctr2.
> 
> As a length-preserving encryption mode, HCTR2 is suitable for applications
> such as storage encryption where ciphertext expansion is not possible, and
> thus authenticated encryption cannot be used.  Currently, such applications
> usually use XTS, or in some cases Adiantum.  XTS has the disadvantage that
> it is a narrow-block mode: a bitflip will only change 16 bytes in the
> resulting ciphertext or plaintext.  This reveals more information to an
> attacker than necessary.
> 
> HCTR2 is a wide-block mode, so it provides a stronger security property: a
> bitflip will change the entire message.  HCTR2 is somewhat similar to
> Adiantum, which is also a wide-block mode.  However, HCTR2 is designed to
> take advantage of existing crypto instructions, while Adiantum targets
> devices without such hardware support.  Adiantum is also designed with
> longer messages in mind, while HCTR2 is designed to be efficient even on
> short messages.
> 
> The first intended use of this mode in the kernel is for the encryption of
> filenames, where for efficiency reasons encryption must be fully
> deterministic (only one ciphertext for each plaintext) and the existing CBC
> solution leaks more information than necessary for filenames with common
> prefixes.
> 
> HCTR2 uses two passes of an ε-almost-∆-universal hash function called
> POLYVAL and one pass of a block cipher mode called XCTR.  POLYVAL is a
> polynomial hash designed for efficiency on modern processors and was
> originally specified for use in AES-GCM-SIV (RFC 8452).  XCTR mode is a
> variant of CTR mode that is more efficient on little-endian machines.
> 
> This patchset adds HCTR2 to Linux's crypto API, including generic
> implementations of XCTR and POLYVAL, hardware accelerated implementations
> of XCTR and POLYVAL for both x86-64 and ARM64, a templated implementation
> of HCTR2, and an fscrypt policy for using HCTR2 for filename encryption.
> 
> Changes in v9:
>  * Fix redefinition error
> 
> Changes in v8:
>  * Fix incorrect x86 POLYVAL comment
>  * Add additional comments to ARM64 XCTR/CTR implementation
> 
> Changes in v7:
>  * Added/modified some comments in ARM64 XCTR/CTR implementation
>  * Various small style fixes
> 
> Changes in v6:
>  * Split ARM64 XCTR/CTR refactoring into separate patch
>  * Allow simd POLYVAL implementations to be preempted
>  * Fix uninitialized bug in HCTR2
>  * Fix streamcipher name handling bug in HCTR2
>  * Various small style fixes
> 
> Changes in v5:
>  * Refactor HCTR2 tweak hashing
>  * Remove non-AVX x86-64 XCTR implementation
>  * Combine arm64 CTR and XCTR modes
>  * Comment and alias CTR and XCTR modes
>  * Move generic fallback code for simd POLYVAL into polyval-generic.c
>  * Various small style fixes
> 
> Changes in v4:
>  * Small style fixes in generic POLYVAL and XCTR
>  * Move HCTR2 hash exporting/importing to helper functions
>  * Rewrite montgomery reduction for x86-64 POLYVAL
>  * Rewrite partial block handling for x86-64 POLYVAL
>  * Optimize x86-64 POLYVAL loop handling
>  * Remove ahash wrapper from x86-64 POLYVAL
>  * Add simd-unavailable handling to x86-64 POLYVAL
>  * Rewrite montgomery reduction for ARM64 POLYVAL
>  * Rewrite partial block handling for ARM64 POLYVAL
>  * Optimize ARM64 POLYVAL loop handling
>  * Remove ahash wrapper from ARM64 POLYVAL
>  * Add simd-unavailable handling to ARM64 POLYVAL
> 
> Changes in v3:
>  * Improve testvec coverage for XCTR, POLYVAL and HCTR2
>  * Fix endianness bug in xctr.c
>  * Fix alignment issues in polyval-generic.c
>  * Optimize hctr2.c by exporting/importing hash states
>  * Fix blockcipher name derivation in hctr2.c
>  * Move x86-64 XCTR implementation into aes_ctrby8_avx-x86_64.S
>  * Reuse ARM64 CTR mode tail handling in ARM64 XCTR
>  * Fix x86-64 POLYVAL comments
>  * Fix x86-64 POLYVAL key_powers type to match asm
>  * Fix ARM64 POLYVAL comments
>  * Fix ARM64 POLYVAL key_powers type to match asm
>  * Add XTS + HCTR2 policy to fscrypt
> 
> Nathan Huckleberry (9):
>   crypto: xctr - Add XCTR support
>   crypto: polyval - Add POLYVAL support
>   crypto: hctr2 - Add HCTR2 support
>   crypto: x86/aesni-xctr: Add accelerated implementation of XCTR
>   crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
>   crypto: arm64/aes-xctr: Improve readability of XCTR and CTR modes
>   crypto: x86/polyval: Add PCLMULQDQ accelerated implementation of
>     POLYVAL
>   crypto: arm64/polyval: Add PMULL accelerated implementation of POLYVAL
>   fscrypt: Add HCTR2 support for filename encryption
> 
>  Documentation/filesystems/fscrypt.rst   |   22 +-
>  arch/arm64/crypto/Kconfig               |    9 +-
>  arch/arm64/crypto/Makefile              |    3 +
>  arch/arm64/crypto/aes-glue.c            |   80 +-
>  arch/arm64/crypto/aes-modes.S           |  349 +++--
>  arch/arm64/crypto/polyval-ce-core.S     |  361 ++++++
>  arch/arm64/crypto/polyval-ce-glue.c     |  191 +++
>  arch/x86/crypto/Makefile                |    3 +
>  arch/x86/crypto/aes_ctrby8_avx-x86_64.S |  232 ++--
>  arch/x86/crypto/aesni-intel_glue.c      |  114 +-
>  arch/x86/crypto/polyval-clmulni_asm.S   |  321 +++++
>  arch/x86/crypto/polyval-clmulni_glue.c  |  203 +++
>  crypto/Kconfig                          |   39 +-
>  crypto/Makefile                         |    3 +
>  crypto/hctr2.c                          |  581 +++++++++
>  crypto/polyval-generic.c                |  245 ++++
>  crypto/tcrypt.c                         |   10 +
>  crypto/testmgr.c                        |   20 +
>  crypto/testmgr.h                        | 1536 +++++++++++++++++++++++
>  crypto/xctr.c                           |  191 +++
>  fs/crypto/fscrypt_private.h             |    2 +-
>  fs/crypto/keysetup.c                    |    7 +
>  fs/crypto/policy.c                      |   14 +-
>  include/crypto/polyval.h                |   22 +
>  include/uapi/linux/fscrypt.h            |    3 +-
>  25 files changed, 4362 insertions(+), 199 deletions(-)
>  create mode 100644 arch/arm64/crypto/polyval-ce-core.S
>  create mode 100644 arch/arm64/crypto/polyval-ce-glue.c
>  create mode 100644 arch/x86/crypto/polyval-clmulni_asm.S
>  create mode 100644 arch/x86/crypto/polyval-clmulni_glue.c
>  create mode 100644 crypto/hctr2.c
>  create mode 100644 crypto/polyval-generic.c
>  create mode 100644 crypto/xctr.c
>  create mode 100644 include/crypto/polyval.h
> 
> -- 
> 2.36.1.124.g0e6072fb45-goog

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
