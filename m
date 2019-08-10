Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6238F88A4D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 10 Aug 2019 11:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfHJJlQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 10 Aug 2019 05:41:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37061 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfHJJlP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 10 Aug 2019 05:41:15 -0400
Received: by mail-wr1-f68.google.com with SMTP id b3so7964129wro.4
        for <linux-fscrypt@vger.kernel.org>; Sat, 10 Aug 2019 02:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1Ez7lK+LuPpIg+HhJBVdgpuAY4Gjp54dlakRShLhnPw=;
        b=ER2b6rIew5uz7jC/ClKE1xocsfE2aUdN7tL8007Dn1Bs971gq1nsI9abRiQN05KmUG
         ZjZjI8szPbgeZaB8ObI1N/P8+Bl72w4VPbYFC2AkwrmhV5Hvuwe43wCFxjORbvJt64zb
         SJYfYKclveqNlLPPOq19gtDMkbLyfMuhyOClf+DosGRc0NeqvLX8NhI2/apcXkxqMdV2
         eamNFpvHVulfmUQj192+1YJMi7E0mmSwCtJXWnSsyAzo+7Q834mAsYe7IdTShvydN3oh
         04YeFYbgH/1NQ72ZFRK1xIQnWSovqKKgk5SGxT/Y1S+Z7ETh+j6NxblAOK3XYilZxs+a
         PUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1Ez7lK+LuPpIg+HhJBVdgpuAY4Gjp54dlakRShLhnPw=;
        b=JC2o5QrJ7dezto7soZ0OLmklyMHuMZ6HvCQQ5+OYEZJ27BaNFwXd6oGPv3wIUroMKi
         127PLNQ23dEkooFCU2TXfIsZgXEkrjcaDhBPfsGMaaRbPs3vzEobenFBm+HVUUl2DQEO
         eKc8oGCss4SSAk8A0IUqhI2jbnuZR6PPw/q6nWPvpHSWcAIQigsnh0ff0x8gR83m90Db
         4U8swmOykY7o0ditl+qEWeVODqec+EqmrbLmrY2d4RR1x8Q1y1mD+Yo4BXfG+qsPCgd0
         pM7icIsIiLjSaEwWQ4fyKDY0NdMUa9VDKbRLf9I9OA3sD5KgeMGzzBe6gdRRX9XywoLx
         xhtA==
X-Gm-Message-State: APjAAAVjBWOG08PH6/eeP7OUyeEohHz5Mgn2MNmzqJ9q6FoBGdadQfPP
        rfw+LsiAxtv3QwHs9jkrChOWxA==
X-Google-Smtp-Source: APXvYqzlXF6v5LTSHcdDNI2vB4TBkMmjDouWYJcWE3fRg88Tr1Rr98Jf3k3oHGjDbzuzaI1vAyx14w==
X-Received: by 2002:a5d:570e:: with SMTP id a14mr14507871wrv.258.1565430073246;
        Sat, 10 Aug 2019 02:41:13 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id n16sm519883wmk.12.2019.08.10.02.41.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Aug 2019 02:41:11 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v9 0/7] crypto: switch to crypto API for ESSIV generation
Date:   Sat, 10 Aug 2019 12:40:46 +0300
Message-Id: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series creates an ESSIV template that produces a skcipher or AEAD
transform based on a tuple of the form '<skcipher>,<shash>' (or '<aead>,<shash>'
for the AEAD case). It exposes the encapsulated sync or async skcipher/aead by
passing through all operations, while using the cipher/shash pair to transform
the input IV into an ESSIV output IV.

This matches what both users of ESSIV in the kernel do, and so it is proposed
as a replacement for those, in patches #2 and #3.

Changes since v8:
- Remove 'cipher' argument from essiv() template, and instead, parse the
  cra_name of the skcipher to obtain the cipher. This is slightly cleaner
  than what dm-crypt currently does, since we can get the cra_name from the
  spawn, and we don't have to actually allocate the TFM. Since this implies
  that dm-crypt does not need to provide the cipher, we can drop the parsing
  code from it entirely (assuming the eboiv patch I sent out recently is
  applied first) (patch #7)
- Restrict the essiv() AEAD instantiation to AEADs whose cra_name starts with
  'authenc('
- Rebase onto cryptodev/master
- Drop dm-crypt to reorder/refactor cipher name parsing, since it was wrong
  and it is no longer needed.
- Drop Milan's R-b since the code has changed
- Fix bug in accelerated arm64 implementation.

Changes since v7:
- rebase onto cryptodev/master
- drop change to ivsize in #2
- add Milan's R-b's

Changes since v6:
- make CRYPTO_ESSIV user selectable so we can opt out of selecting it even
  if FS_ENCRYPTION (which cannot be built as a module) is enabled
- move a comment along with the code it referred to (#3), not that this change
  and removing some redundant braces makes the diff look totally different
- add Milan's R-b to #3 and #4

Changes since v5:
- drop redundant #includes and drop some unneeded braces (#2)
- add test case for essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)
- make ESSIV driver deal with assoc data that is described by more than two
  scatterlist entries - this only happens when the extended tests are being
  performed, so don't optimize for it
- clarify that both fscrypt and dm-crypt only use ESSIV in special cases (#7)

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
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v8

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (7):
  crypto: essiv - create wrapper template for ESSIV generation
  fs: crypto: invoke crypto API for ESSIV handling
  md: dm-crypt: switch to ESSIV crypto API template
  crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode
  md: dm-crypt: omit parsing of the encapsulated cipher

 arch/arm64/crypto/aes-glue.c  | 205 ++++--
 arch/arm64/crypto/aes-modes.S |  28 +
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 665 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 drivers/md/Kconfig            |   1 +
 drivers/md/dm-crypt.c         | 252 +-------
 fs/crypto/Kconfig             |   1 +
 fs/crypto/crypto.c            |   5 -
 fs/crypto/fscrypt_private.h   |   9 -
 fs/crypto/keyinfo.c           |  92 +--
 14 files changed, 1442 insertions(+), 365 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

