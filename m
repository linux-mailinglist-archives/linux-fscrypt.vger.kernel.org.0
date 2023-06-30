Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69607433E0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 07:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjF3FD6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 01:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjF3FD6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 01:03:58 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52082694;
        Thu, 29 Jun 2023 22:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688101300; c=relaxed/relaxed; h=content-type:date:from:message-id:mime-version:subject:to; bh=8AIXZizyPokne0cmJAO6gND1QvEsxh7xFBcNcY+FQgU=; b=Tgc1vKAY4O7o3IRmgMdmdblXl+/ExrgSvklv8fcfCOMNWcFXzotwcQp0XBe7w9LPwAIjgGfTdahdkH7hQ4mhCo/uc0LtqBZnKmbSI7rEh6V6vNn0WUSzM+DiMuEN5vpR2uZn1TUN+BVjEohhDv4njwa5Ut7ts1NUD7PXDAZCw2hv9qr42HDHvP92cVLbhP8z6r9Q3Jpd0fM06Fbfl2vbXv61Lum+lomzHi0GiTHMZ3T6YxaU+dZtfQvgQ6/AvEAJYDl0pJgMtJhNH21+uqGjPu6Lfq87OXRbdTX4DlJqaVVk8gg8p2pOKgWq6shEdxb7wT8Wl/No2jT/x9IGoYNG+g==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 30 Jun 2023 14:01:25 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 128;
          Fri, 30 Jun 2023 14:03:31 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v4 0/4] crypto: LEA block cipher implementation
Date:   Fri, 30 Jun 2023 14:03:19 +0900
Message-Id: <20230630050323.984216-1-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This submission contains a generic C implementation of the LEA cipher algorithm and test vectors for it. It also includes modifications to use the LEA in fscrypt.

The LEA algorithm is a lightweight block cipher that processes data blocks of 128-bits and has three different key lengths, each with a different number of rounds:

- LEA-128: 128-bit key, 24 rounds,
- LEA-192: 192-bit key, 28 rounds, and
- LEA-256: 256-bit key, 32 rounds.

The round function of LEA consists of 32-bit ARX(modular Addition, bitwise Rotation, and bitwise XOR) operations. See [2, 5, 7] for details.

LEA is a Korean national standard block cipher, described in "KS X 3246"[1] and is also included in the international standard, "ISO/IEC 29192-2:2019 standard"[2].

It is one of the approved block ciphers for the current Korean Cryptographic Module Validation Program (KCMVP).

We expect that the first application of the patch would be disk encryption on the Gooroom platform ('Gooroom' is a Korean word, meaning 'cloud') [3]. Currently, the Gooroom platform uses AES-XTS for disk encryption. The main reason for submitting this patch is to make disk encryption with LEA (e.g. LEA-XTS) available on there. It is possible to use LEA without any additional modifications in dm-crypt, a module that provides disk encryption functionality within the kernel.

This patch also includes a modification to enable LEA for use in fscrypt, another data-at-rest method available within the kernel, and a modification to blk-crypto-fallback to enable the "inlinecrypt" mount option in fscrypt.

The Gooroom platform is a government-driven Debian-based Linux distribution in South Korea. In Korea, there are many crypto companies that want to bundle Linux into their products and sell them. They create their own Gooroom platforms by modifying the original Gooroom platform for their services. (Of course, the Gooroom platform is not mandatory, and companies wishing to use Linux are free to choose an appropriate distribution.) BTW, in Korea, many crypto companies want to use LEA, because LEA is one of the block ciphers of the KCMVP, a validation program for commercial crypto S/W to be delivered to the Korean government.

The Linux Crypto API already has another Korean block cipher, ARIA, also one of the block ciphers of the KCVMP. However, LEA is more widely used than ARIA in industry nowadays, because LEA is one of the lightweight cryptography standard of ISO/IEC [2] and performs well on low-end devices that support 32-bit operations. So we think they are complementary to each other.

In general, it's obvious that the hardware-accelerated AES is the best performer. However, there exist not only environments where the hardware-accelerated AES is not supported, but also situations where AES is not preferred for various reasons. In these cases, if someone wants to encrypt using a block cipher, LEA could be an alternative.

There are also SIMD implementations for efficiently using LEA, which is not included in this patch. We have SSE2 and AVX2 assembly implementations, some of which were included in the previous version of the patch. The SIMD implementations are being re-implemented to support a wider range of environments.

Apart from this, we also have implemented LEA in lightweight environments such as 8-bit AVR, 16-bit MSP and 32-bit ARM [4]. If LEA were to be included in the Linux kernel, it would be possible to modify and supplement the submission with lightweight implementations to provide efficient encryption on embedded linux devices.

Although the designers of LEA did not provide test vectors in their paper [5], the ISO/IEC standard [2] and the KS standard [1] do. Furthermore, the Block Cipher LEA Specification("블록암호 LEA 규격서", written in Korean) document on the LEA introduction page [6] and the Wikipedia article on LEA [7] show the same test vectors as in the standards.

The test vectors for ECB, CBC, CTR, and GCM modes included in the testmgr module are taken from the KCMVP Cryptographic Algorithm Verification Criteria V3.0("KCMVP 검증대상 암호알고리즘 검증기준 V3.0", written in Korean) [8]. Test vectors for the XTS mode were generated by ourselves, and we crosschecked them using Crypto++ [9] and testmgr on Linux.

The implementation has been tested with kernel module tcrypt.ko and has passed the selftest using above-mentioned test vectors. It also has been tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS. The fscrypt patch was tested using a modified tool by forking https://github.com/google/fscrypt.

[1] KS X 3246, 128-bit block cipher LEA.
[2] ISO/IEC 29192-2:2019, Information security — Lightweight cryptography — Part 2: Block ciphers.
[3] https://github.com/gooroom https://www.gooroom.kr/
[4] https://github.com/cryptolu/FELICS/tree/master/block_ciphers/source/ciphers/LEA_128_128_v01/source
[5] Hong, Deukjo, et al. "LEA: A 128-bit block cipher for fast encryption on common processors.", WISA 2013.
[6] https://seed.kisa.or.kr/kisa/algorithm/EgovLeaInfo.do
[7] https://en.wikipedia.org/wiki/LEA_(cipher)
[8] https://seed.kisa.or.kr/kisa/kcmvp/EgovVerification.do
[9] https://www.cryptopp.com/

Changelog:
v4:
- Removed documentation to describe LEAs in fscrypt.
v3:
- Added implementations to enable LEA in fscrypt and blk-crypt.
v2:
- Reimplemented the Generic C implementation as a Loop version.
  - The decryption code was adapted from an optimized implementation by Eric Biggers.
    https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/commit/?h=old/wip-lea&id=1d1cbba14380f8a1abc76baf939b9e51de047fb6
- Removed AVX2 SIMD implementation.
- Added comments for functions.
- Improved the description in Kconfig.
- Added test vectors from the standard documentation.

Dongsoo Lee (4):
  crypto: LEA block cipher implementation
  crypto: add LEA testmgr tests
  blk-crypto: Add LEA-256-XTS blk-crypto support
  fscrypt: Add LEA-256-XTS, LEA-256-CTS support

 block/blk-crypto.c                 |    6 +
 crypto/Kconfig                     |   18 +
 crypto/Makefile                    |    1 +
 crypto/lea_generic.c               |  410 +++++++++
 crypto/tcrypt.c                    |   73 ++
 crypto/testmgr.c                   |   32 +
 crypto/testmgr.h                   | 1241 ++++++++++++++++++++++++++++
 fs/crypto/fscrypt_private.h        |    2 +-
 fs/crypto/keysetup.c               |   15 +
 fs/crypto/policy.c                 |    4 +
 include/crypto/lea.h               |   44 +
 include/linux/blk-crypto.h         |    1 +
 include/uapi/linux/fscrypt.h       |    4 +-
 tools/include/uapi/linux/fscrypt.h |    4 +-
 14 files changed, 1852 insertions(+), 3 deletions(-)
 create mode 100644 crypto/lea_generic.c
 create mode 100644 include/crypto/lea.h

-- 
2.34.1
