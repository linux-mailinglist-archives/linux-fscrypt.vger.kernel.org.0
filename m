Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D55D79265C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Aug 2019 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfHSORi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Aug 2019 10:17:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40311 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfHSORi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Aug 2019 10:17:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so8919332wrd.7
        for <linux-fscrypt@vger.kernel.org>; Mon, 19 Aug 2019 07:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=9Xrs6PZejrdbYuAGd9A0Bw17AwMfilxW7+CqMJVtBPI=;
        b=dGv3mm31pmCbdLGVe1vigGT4JTyXPV/Mda7rlHDMoJ/zN1H9HG2NxJCGH+Fn1Sdehu
         FBHEAwKqAjDqjYyX8/RewEzYXbPnD58fiIrjQGVDftD5ennsB0BunKLzbv4KZsS2opPX
         uZIS1Eyi83D8xgTxLyg3c2jp+Vrk87jCFD90yvmAxyeV6cfK/XVfBZXakW3ZRI+cuNo0
         PiKAAteRJVNcWe2ao4RMGDENnThoecJ04sxxFS7bFTLhgEvXK2A4N3jooDN1YL2Pa3RD
         GIoECd3qzyvuJhMjdFhgPQusMVg96NiCSVHgeHXIXbZJBxGNsOPCZQR9R04J9M/TAF+a
         U2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9Xrs6PZejrdbYuAGd9A0Bw17AwMfilxW7+CqMJVtBPI=;
        b=Bc0mimPBAH7/ZYOmXAhMtePaAiDPAuL2oal4RqM80H3diXQ1+OIRcg+xsU4Pz5Ue8q
         UppJeqxF2DNPEVh6Li3cf0dvJVbTqVruUU7jqkiuzcYREc0byBKGm0AqWUDO7rB2C8h6
         MHzLn5OBX8Dkw/vQrvdQ+7ucaETfBJL6z71yTjLk167U6E8zlABSveX8u64xG08ytayb
         VYQGQHa9rY51KYl/Ft2FH/zWl/sVsVSmMWuUTgQ8tETEKvSi8tqatIHAJKTnLfrX0Zbj
         o2w9h3YenP9F3T7/J03fmjlJKXtjhRfvfpd1ikm1L5kZCn3HMaM32UgqN7nmnHTq+3u+
         py5A==
X-Gm-Message-State: APjAAAVAjqB25XYG76BY7X89JD37fyFp8D4C7X6gsKsRjnzxgC2aoeZb
        sbo7MKGwn9xkXeTdDg+U8OOoumIeVuWr0Q==
X-Google-Smtp-Source: APXvYqy2NrlHoI/QHWVvXP2A0fy5mgEEmo/UHs+9ks1kdMRq1l8TjnQyPXLRkJY7cvuRlrs6C3RzOQ==
X-Received: by 2002:a05:6000:1041:: with SMTP id c1mr26116018wrx.99.1566224255401;
        Mon, 19 Aug 2019 07:17:35 -0700 (PDT)
Received: from localhost.localdomain (11.172.185.81.rev.sfr.net. [81.185.172.11])
        by smtp.gmail.com with ESMTPSA id b26sm12693352wmj.14.2019.08.19.07.17.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:17:34 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v13 0/6] crypto: switch to crypto API for ESSIV generation
Date:   Mon, 19 Aug 2019 17:17:32 +0300
Message-Id: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
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

Changes since v12:
- don't use a per-instance shash but only record the cra_driver_name of the
  shash when instantiating the template, and allocate the shash for each
  allocated transform instead
- add back the dm-crypt patch -> as Milan has indicated, his preference would
  be to queue these changes for v5.4 (with the first patch shared between the
  cryptodev and md trees on a stable branch based on v5.3-rc1 - if needed,
  I can provide a signed tag)

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

Ard Biesheuvel (6):
  crypto: essiv - create wrapper template for ESSIV generation
  crypto: essiv - add tests for essiv in cbc(aes)+sha256 mode
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode
  md: dm-crypt: switch to ESSIV crypto API template
  md: dm-crypt: omit parsing of the encapsulated cipher

 arch/arm64/crypto/aes-glue.c  | 206 ++++--
 arch/arm64/crypto/aes-modes.S |  28 +
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 663 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 drivers/md/Kconfig            |   1 +
 drivers/md/dm-crypt.c         | 271 ++------
 10 files changed, 1448 insertions(+), 270 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

