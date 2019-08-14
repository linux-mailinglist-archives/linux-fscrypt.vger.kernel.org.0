Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B57C8D835
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Aug 2019 18:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfHNQhz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 12:37:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37707 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNQhy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 12:37:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so9781511wrt.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 14 Aug 2019 09:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=YrX5oOBk5fypgWbJscKxKeLPHT3qLuTnVQQLPTR0vac=;
        b=HH43fx/4WxeG034Z8g5xymkrpGH25FM4SFla/c6+uLtKbXJDeQ81MWvsUdQzkD0l6q
         O+5tcX875782QBTdD7F6rsy0/v+AdkjgwbKaLyqj+1HBWgnArvEbgkNzMr30iES6OjSJ
         olNSeGb2ThQRVljsx55UUVLSnUmwUwdEXdAsCCraNnaLxoyFg1vki+A6rq5xbiJgTfOE
         ErJ0SYP7zI7Xiu2JFeCGlne53BIFTQ5uy0JiRAc4GdstThv9fkEHF0JQfOJjdIJO4oPy
         ZbqoG9XKK0Bi7Mkb+SkeI2HHa8veJh2lyNYtteTuYnE4e/zVTh+nAkzBxp9qslIW1ct7
         gjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YrX5oOBk5fypgWbJscKxKeLPHT3qLuTnVQQLPTR0vac=;
        b=AnxRKRYIOp0RPe+BWzsbEc2oneEsA8LQAD2slO26bsw68vmV6uqt8D9gq/7F4FYAhr
         FJQ1Bq6m2RtYVviPvdbfh9o3GpsN9hA5yeYFc27cbq8e9jLF4x4AntJHG0iezM4ilhIY
         CihHAe0YcVNKmfOSDTVArQ/0MWGyS19Lknl9EEM+v2vuSCd9OyZ2xgUX6ZlNGaQQeSnf
         qtqVQDI06iDU/gyYj6juRs4VjF/BgIZAhc/Tdtligu39UDj7N1BA1M1Cqj1AfswgtuMK
         fgJoh3tLEBzcFaAqfwmzgKzMUlNEJSi+0vhvY3qRCVqQhQDpRFRlsCFjPyxjMQBVehmG
         /4AA==
X-Gm-Message-State: APjAAAV2TNTPWtDFdaq0zc5X06Pit52RJPMoxD7ZMALtMr1lmh9CVzSa
        LbdmTBSP1YdnF17GeTdwhAkolQ==
X-Google-Smtp-Source: APXvYqzo0gOCjOPMy8yxO4B9jPVmtUYgTV3UQvfE4klj68cyHDaW+VO5Hui8cHBtbXhAe1rvWTEG/g==
X-Received: by 2002:adf:db01:: with SMTP id s1mr694402wri.164.1565800671885;
        Wed, 14 Aug 2019 09:37:51 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:1c0e:f938:89a1:8e17])
        by smtp.gmail.com with ESMTPSA id 39sm610724wrc.45.2019.08.14.09.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:37:50 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v11 0/4] crypto: switch to crypto API for ESSIV generation
Date:   Wed, 14 Aug 2019 19:37:42 +0300
Message-Id: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
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

 arch/arm64/crypto/aes-glue.c  | 206 ++++--
 arch/arm64/crypto/aes-modes.S |  28 +
 crypto/Kconfig                |  28 +
 crypto/Makefile               |   1 +
 crypto/essiv.c                | 667 ++++++++++++++++++++
 crypto/tcrypt.c               |   9 +
 crypto/testmgr.c              |  14 +
 crypto/testmgr.h              | 497 +++++++++++++++
 8 files changed, 1408 insertions(+), 42 deletions(-)
 create mode 100644 crypto/essiv.c

-- 
2.17.1

