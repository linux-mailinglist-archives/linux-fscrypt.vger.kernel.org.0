Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60FA8F48A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfHOT3P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 15:29:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41270 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfHOT3P (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 15:29:15 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so3185824wrr.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 15 Aug 2019 12:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=s/c4wOImg7BBgmPbETiCg295igmPUld6lm9sPeqg3ow=;
        b=wrbBC6l36GrKTnlSCoC/XDQ04JTfMThyQuTbVHfUnII80IXNxmQOZXzs7QWreDnyEe
         ZqGAlygpZ3DDP+R9HjPx3v/UlYBUEcyY3HeHb3bEHHNSK39i3V5cPuubLgoJaWo6f+gM
         7MHgqZfmsSpo94zrgzZh6/kZr/NEmuloDvBEpbDNw/9zSjdX2WoUtvioHJZKOb0gfMbt
         OvcSjnH2Q807LjLeD82+GnSytcMjt2eINdBATUqfr+DvmDiyVm36nOnoSJtX9L3MMoU9
         NErE9+RE7z7l1E05kdhw6Yd2qgAUh5qTBj1PstDAbPJd8d5tCRiVqi3Wvqx+d6Syilqk
         vR9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s/c4wOImg7BBgmPbETiCg295igmPUld6lm9sPeqg3ow=;
        b=Ls2TUen1iUi2EQ3k5LxHvv0ZN7Jg1M3saXPuNk9Qh+ERHWoW9TB7hFMeNsyzlUwKpG
         fc9gBvQPJiTKb4kwoa3cZs1kXmYG0aF2oj7XzJHvXgJwvroU1PumXrA5YZlXSvRsWtHm
         znAhH+IKaFq0CZJYdUDsoI6KKTAbiiX80R8X0aKaMQiwySITs4YkhGl31CoctEBmgaI3
         XQ4C3ZgOCGlyggTCJxwCwoiC5yFHHN6I3u0mxoCkieUOifO7eWdB0lV1Zi0Bpk7jh0a+
         Qd8hzVdLCA5/gAhhgutK/c4gBUpriLuTATCgpWL6KnLf/S1OtfXuFH3+80qcA/XZzEd9
         r7KA==
X-Gm-Message-State: APjAAAWmeMXtqd+NFusJkrregDWbYwndcw8camtqB2pUcMvUBENxrBpO
        5E78uuvEXY/ve1jzTuwckBoJAQ==
X-Google-Smtp-Source: APXvYqy6OwWb5amCS2Y9yrAdIHzcqp4PNSwWaQjBGjQn0ndqFhdp7cyefe4RO9hpPv0xnbKXmzPZPA==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr7174015wre.114.1565897352881;
        Thu, 15 Aug 2019 12:29:12 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id h9sm2949063wrt.53.2019.08.15.12.29.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 12:29:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v12 0/4] crypto: switch to crypto API for ESSIV generation
Date:   Thu, 15 Aug 2019 22:28:54 +0300
Message-Id: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
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

Changes since v11:
- Avoid spawns for the ESSIV shash and cipher algos. Instead, the shash TFM is
  allocated per-instance (which is appropriate since it is unkeyed and thus
  stateless), and the cipher is allocated explicitly based on the parsed
  skcipher/aead cra_name.

Changes since v10:
- Drop patches against fscrypt and dm-crypt - these will be routed via the
  respective maintainer trees during the next cycle
- Fix error handling when parsing the cipher name from the skcipher cra_name
- Use existing ivsize temporary instead of retrieving it again
- Expose cra_name via module alias (#4)

Changes since v9:
- Fix cipher_api parsing bug that was introduced by dropping the cipher name
  parsing patch in v9 (#3). Thanks to Milan for finding it.
- Fix a couple of instances where the old essiv(x,y,z) format was used in
  comments instead of the essiv(x,z) format we adopted in v9

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

Code can be found here
https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v11

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: dm-devel@redhat.com
Cc: linux-fscrypt@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Milan Broz <gmazyland@gmail.com>

Ard Biesheuvel (4):
  crypto: essiv - create wrapper template for ESSIV generation
  crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode

 arch/arm64/crypto/aes-glue.c  | 206 +++++--
 arch/arm64/crypto/aes-modes.S |  28 +
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 645 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 8 files changed, 1386 insertions(+), 42 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

