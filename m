Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33729572B1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jun 2019 22:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfFZUky (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Jun 2019 16:40:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34006 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbfFZUky (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Jun 2019 16:40:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so4302287wrl.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 26 Jun 2019 13:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NPjxqtyjQpYCgybS5zN78zffB956dgNyXrI9VH1y9Hc=;
        b=IIHfq8mCVktitxkEaThPZUfzgKbkr3QTYmX2SgJ6H0We5g1vtQscSIvE2OTtjaDQ3C
         +4+TjStEWDjMKdKm/SyAA12jVhu2yYFeSBuM58Ir1x0bsp/e9NJjODm2Ym6B4N7ZsTjD
         00GSJbQNyCvojnjTVMzq31XyKvzY4yUW7+XH3CVNURSYmQ01eNF2ukHpukfVQeiOYEsj
         2lOpFgA8UwWZ44zGgHx8ksc+gLrG8zfF5+p2cWP7oSzotuZ6S0ydvQwHL4G07DZKO302
         Miyt4b5mFXqFHGCyqD8VILdjvAlnF87KAp9rNGb7HW3qaaDvvfjcSOPcJw0bcpA+OQqU
         ivjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NPjxqtyjQpYCgybS5zN78zffB956dgNyXrI9VH1y9Hc=;
        b=jHfitlY2DBrGPb+xDpHmXSxsx0vKBTHsHsZb2ee82P3fq8IghyKAudJW/+9uHRDIVA
         u7S8vH8eAQBr7086WKw6G6/4dFQPTNvF2ENU0+IJPVMPmiT4V1P4zYCelzwBwaE3BdQo
         iktBnbJbbSTYQpjXj8ul1lvqVVM8KxKER1Agwt7ZEP09rN85XgtCEXMc3FjjdfK+7YDt
         zOuDrCtX3cXsYwjbSHtbMKAP+q3HRDR2bAyc4fDkKp2uICzfPufwWM9eYKFQx/FG+kK9
         zPRC/KdlNPY6kMVIe+C4974+07voSDdHDv97bL9C4WLm81Nu2LYxvs7sBi/Ge9sioFZl
         a7KA==
X-Gm-Message-State: APjAAAW8fMW5XOJzzoFT7u2H5T3CRhnySZ3a/91ds44rFlv2i1qNgF5g
        YzlGwzRMCxKc//gkNHQmIAK4ow==
X-Google-Smtp-Source: APXvYqzyPP2kqpROYclJaOZTSu+oBTttt7ijJE2qrnLMB35rJqOYfqlpYR3U9Q9USBzOTxHA6dZ5xA==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr5328474wrv.89.1561581651363;
        Wed, 26 Jun 2019 13:40:51 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:9c7f:f574:ee94:7dec])
        by smtp.gmail.com with ESMTPSA id 32sm35164587wra.35.2019.06.26.13.40.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 13:40:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v5 0/7] crypto: switch to crypto API for ESSIV generation
Date:   Wed, 26 Jun 2019 22:40:40 +0200
Message-Id: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series creates an ESSIV template that produces a skcipher or AEAD
transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
(or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
encapsulated sync or async skcipher/aead by passing through all operations,
while using the cipher/shash pair to transform the input IV into an ESSIV
output IV.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #4.

This code has been tested using the fscrypt test suggested by Eric
(generic/549), as well as the mode-test script suggested by Milan for
the dm-crypt case. I also tested the aead case in a virtual machine,
but it definitely needs some wider testing from the dm-crypt experts.

The consensus appears to be that it would be useful if the crypto API
encapsulates the handling of multiple subsequent blocks that are
encrypted using a 64-bit LE counter as IV, and makes it the duty of
the algo to increment the counter between blocks. However, this is
equally suitable for non-ESSIV transforms (or even more so), and so
this is left as a future enhancement to  be applied on top.

Changes since v4:
- make the ESSIV template IV size equal the IV size of the encapsulated
  cipher - defining it as 8 bytes was needlessly restrictive, and also
  complicated the code for no reason
- add a missing kfree() spotted by Smatch
- add additional algo length name checks when constructing the essiv()
  cipher name
- reinstate the 'essiv' IV generation implementation in dm-crypt, but
  make its generation function identical to plain64le (and drop the other
  methods)
- fix a bug in the arm64 CE/NEON code
- simplify the arm64 code by reusing more of the existing CBC implementation
  (patch #6 is new to this series and was added for this reason)

Changes since v3:
- address various review comments from Eric on patch #1
- use Kconfig's 'imply' instead of 'select' to permit CRYPTO_ESSIV to be
  enabled as a module or disabled entirely even if fscrypt is compiled in (#2)
- fix an issue in the AEAD encrypt path caused by the IV being clobbered by
  the inner skcipher before the hmac was being calculated

Changes since v2:
- fixed a couple of bugs that snuck in after I'd done the bulk of my
  testing
- some cosmetic tweaks to the ESSIV template skcipher setkey function
  to align it with the aead one
- add a test case for essiv(cbc(aes),aes,sha256)
- add an accelerated implementation for arm64 that combines the IV
  derivation and the actual en/decryption in a single asm routine

Scroll down for tcrypt speed test result comparing the essiv template
with the asm implementation. Bare cbc(aes) tests included for reference
as well. Taken on a 2GHz Cortex-A57 (AMD Seattle)

Code can be found here
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v5

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (7):
  crypto: essiv - create wrapper template for ESSIV generation
  fs: crypto: invoke crypto API for ESSIV handling
  md: dm-crypt: infer ESSIV block cipher from cipher string directly
  md: dm-crypt: switch to ESSIV crypto API template
  crypto: essiv - add test vector for essiv(cbc(aes),aes,sha256)
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode

 arch/arm64/crypto/aes-glue.c  | 205 +++++--
 arch/arm64/crypto/aes-modes.S |  29 +-
 crypto/Kconfig                |   4 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 636 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |   6 +
 crypto/testmgr.h              | 213 +++++++
 drivers/md/Kconfig            |   1 +
 drivers/md/dm-crypt.c         | 229 ++-----
 fs/crypto/Kconfig             |   1 +
 fs/crypto/crypto.c            |   5 -
 fs/crypto/fscrypt_private.h   |   9 -
 fs/crypto/keyinfo.c           |  88 +--
 14 files changed, 1111 insertions(+), 325 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.20.1

