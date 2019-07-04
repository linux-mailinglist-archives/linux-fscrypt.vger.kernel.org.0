Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3765B5FCE5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfGDSan (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54946 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfGDSan (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so3535746wme.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yk+JztDjUT/qSbh+IewDnfzPsmvS7/u063GlyhA1d8U=;
        b=BmBZ+MX9BXAQxEj2buKZqZihI4km2NUvVBKuQKUJyDY7DFynpvmFuxmqewZQ9KT2TY
         C9kY9BEs+DlKRO5OwmOMSKC6KAdb++a7y2kCihIXImX28PopDdfaLSVF2qad4/In5f+l
         cOKwRPxInEEPb75rxIQJrrh6U5EFPDNGqM+Qb0UFM9absAdtVngZ+isF3qWwTQMCHFPD
         F0+q90C3oPUtqvBKwjyg5s3NOUr/ooEAtEsa5StHGZCXoD2kTrfaGrtD+n9B4zjv7cj/
         SLq19dUKWf9emsxZClNP6AutpVFhv/lJXIKFtJtZp72NivqUuskMrg6t398VLIWWRFP3
         uhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yk+JztDjUT/qSbh+IewDnfzPsmvS7/u063GlyhA1d8U=;
        b=FznnYPnt/WU05sIk5EKr8/xLjZ181nfqqHq+i2nI9eeVwkRlfoHtWs2fE9vCksQ8s1
         5ohZimyyL9p9p3UE2VoA+o8V5T9xBTpAeDEH50XOkSCpdUbbgmHxOAN8dfmDJQsbVy8+
         0EYWXfUzVIOyMJR4QFW0N3poj0i+qX//J//DWH41e7rlVRw3SkCxTFeiL9sRiwyeaWSl
         5ZfBoHt630+l3M3/uMylYv0mU+SLwwQXzWSNf/7vcSyd867gjY7c2rb1cfYarMC1XPDQ
         pfJpf4QaMqdXGJ6DIAXEve/pUx5xQXO2H1FG+svH+1G/+TKiNcZUfM7sltwUfwKaB6fp
         7zwQ==
X-Gm-Message-State: APjAAAW1dTxdjVX5TYxXeocJJuuiSLAEfAKr51JNWoks+3dZJ2QQslT0
        RUguhzt7pcWOhCgIz5k99CzmVkCj4xKN8Q==
X-Google-Smtp-Source: APXvYqyipzTA43sgCecfs/nwEE8twcuGUax7qR2FvBJdFF1ZBok/6pdHPrp60LV3tGcl7fOEHuUIrQ==
X-Received: by 2002:a05:600c:291:: with SMTP id 17mr555909wmk.32.1562265040371;
        Thu, 04 Jul 2019 11:30:40 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:39 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 0/7]  crypto: switch to crypto API for ESSIV generation
Date:   Thu,  4 Jul 2019 20:30:10 +0200
Message-Id: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
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

Note to the maintainer: patches #2 .. #4 are against other subsystems, and
so it might make sense to take only the crypto patches (#1, #5, and optionally
#6 and #7) now, and allow the other subsystem maintainers to take the other
patches at their leisure during the next cycle.

This code has been tested using the fscrypt test suggested by Eric
(generic/549 *), as well as the mode-test scripts suggested by Milan for
the dm-crypt case. I also tested the aead case in a virtual machine,
but it definitely needs some wider testing from the dm-crypt experts.

* due to sloppiness on my part, the fscrypt change was actually broken
  since I switched back to using full size IVs in the ESSIV template.
  This time, I fixed this, and reran the test in question and it passed.

The consensus appears to be that it would be useful if the crypto API
encapsulates the handling of multiple subsequent blocks that are
encrypted using a 64-bit LE counter as IV, and makes it the duty of
the algo to increment the counter between blocks. However, this is
equally suitable for non-ESSIV transforms (or even more so), and so
this is left as a future enhancement to  be applied on top.

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
  md: dm-crypt: infer ESSIV block cipher from cipher string directly
  md: dm-crypt: switch to ESSIV crypto API template
  crypto: essiv - add test vector for essiv(cbc(aes),aes,sha256)
  crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
  crypto: arm64/aes - implement accelerated ESSIV/CBC mode

 arch/arm64/crypto/aes-glue.c  | 205 +++++--
 arch/arm64/crypto/aes-modes.S |  29 +-
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 640 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 drivers/md/Kconfig            |   1 +
 drivers/md/dm-crypt.c         | 235 ++-----
 fs/crypto/Kconfig             |   1 +
 fs/crypto/crypto.c            |   5 -
 fs/crypto/fscrypt_private.h   |   9 -
 fs/crypto/keyinfo.c           |  93 +--
 14 files changed, 1435 insertions(+), 332 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

