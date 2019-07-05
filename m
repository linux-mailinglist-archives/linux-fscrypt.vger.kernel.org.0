Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B360112
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Jul 2019 08:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfGEGgC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Jul 2019 02:36:02 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37138 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEGgB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Jul 2019 02:36:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so8121151wme.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 23:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OCBMk8z+QfRen/W6CulSDPkPOiGjYu90pG1vgqV+00=;
        b=UNvQtQ4AUmcYi/az3mwo721g5Wpc4pTlCuxBHHebt7UGH5e2mPVGw1Ge2jzAX4DHrV
         V7Pg84Oww4lQ8FZeJzS/4uxlz2EBStgdgWH6SxHpMyOKIFp+i23IOfUHNkEOSPlXIB5G
         +RyE/yN7DJwSWyR89XdcGQFbEXj5uGwrkscJCDrGKF2mLaUZCUYOuYwBRdv5Fb//rKXH
         KUkR1RFekNsC1DS3Uac59Eb0z4RHqNsOJ58jf0yxlvrIZ5piSV5+huApzbmsDZwp05eg
         ETypOYqT1h0idd5vPSflj7Ep5V7Shm1aEwCNghCPWk21PooBK5GnnrwDRD3cntEwBm1z
         CtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OCBMk8z+QfRen/W6CulSDPkPOiGjYu90pG1vgqV+00=;
        b=D7dA3/yHpTta7VhURC87Xv2yHC7FZNcTd84RCFV+TPzFZWoqMWv24sgxCQFDr2LYGa
         o3BEN/vaBWaDiqEvdZii3hLI1Lg5Uz06L0edBqTnN7tWipZqmWQR7gNYHRsJhCkaWbXa
         0zdk5xN9Q4Fa86HIvVPmQ/Xoc/AQOD6kUC6+H0yOipoH94KP+W5jorppoC3sJU+81dlr
         yeaeuEIbHXNhlP5R7QcugbvCrdcWiuY0EpfASDGYQC9mwpyRrAaigh956FdW36ssjp+t
         GYN3rbbMAJ5xq5hgLCtv+E6Yjx5/mqDIyME93UzduEpB8003uuIxOHUk2Rvb1QxoCTK7
         d7Hw==
X-Gm-Message-State: APjAAAUT4nJDMdjGbVBQeUFQHkkXjWW3nj1vXuMt3RTMwVwLD5LAaR2n
        M0i0tjaCKTJjqzL1ajk6CjXAiCd5l7H/Ykfr7/M6HQ==
X-Google-Smtp-Source: APXvYqzRDSCd/ZBfF6c0dFdo08XvQFF7eRXe8X5mY2WZaVNr84/xpFMytKWXFtUvLo4KnkNo/B0phzmuo3eypTBDqis=
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr1626256wmj.61.1562308559023;
 Thu, 04 Jul 2019 23:35:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 5 Jul 2019 08:35:42 +0200
Message-ID: <CAKv+Gu83Z2U0JABYEVyJ0sW_onoUEM3BmGGzFg48b0Uc3SPQjg@mail.gmail.com>
Subject: Re: [PATCH v8 0/7] crypto: switch to crypto API for ESSIV generation
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 4 Jul 2019 at 20:30, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> encapsulated sync or async skcipher/aead by passing through all operations,
> while using the cipher/shash pair to transform the input IV into an ESSIV
> output IV.
>
> This matches what both users of ESSIV in the kernel do, and so it is proposed
> as a replacement for those, in patches #2 and #4.
>
> Note to the maintainer: patches #2 .. #4 are against other subsystems, and
> so it might make sense to take only the crypto patches (#1, #5, and optionally
> #6 and #7) now, and allow the other subsystem maintainers to take the other
> patches at their leisure during the next cycle.
>

Please disregard #6 and #7 for now - the IV handling is busted after
the rebase to cryptodev/master. #1 and #5 should be fine though

Since I am obviously unsuccessful in cranking out these patches
without bugs in time before my leave, I am going to stop trying, and I
will get back to this work when I return from my leave, around the end
of September.


> This code has been tested using the fscrypt test suggested by Eric
> (generic/549 *), as well as the mode-test scripts suggested by Milan for
> the dm-crypt case. I also tested the aead case in a virtual machine,
> but it definitely needs some wider testing from the dm-crypt experts.
>
> * due to sloppiness on my part, the fscrypt change was actually broken
>   since I switched back to using full size IVs in the ESSIV template.
>   This time, I fixed this, and reran the test in question and it passed.
>
> The consensus appears to be that it would be useful if the crypto API
> encapsulates the handling of multiple subsequent blocks that are
> encrypted using a 64-bit LE counter as IV, and makes it the duty of
> the algo to increment the counter between blocks. However, this is
> equally suitable for non-ESSIV transforms (or even more so), and so
> this is left as a future enhancement to  be applied on top.
>
> Changes since v7:
> - rebase onto cryptodev/master
> - drop change to ivsize in #2
> - add Milan's R-b's
>
> Changes since v6:
> - make CRYPTO_ESSIV user selectable so we can opt out of selecting it even
>   if FS_ENCRYPTION (which cannot be built as a module) is enabled
> - move a comment along with the code it referred to (#3), not that this change
>   and removing some redundant braces makes the diff look totally different
> - add Milan's R-b to #3 and #4
>
> Changes since v5:
> - drop redundant #includes and drop some unneeded braces (#2)
> - add test case for essiv(authenc(hmac(sha256),cbc(aes)),aes,sha256)
> - make ESSIV driver deal with assoc data that is described by more than two
>   scatterlist entries - this only happens when the extended tests are being
>   performed, so don't optimize for it
> - clarify that both fscrypt and dm-crypt only use ESSIV in special cases (#7)
>
> Changes since v4:
> - make the ESSIV template IV size equal the IV size of the encapsulated
>   cipher - defining it as 8 bytes was needlessly restrictive, and also
>   complicated the code for no reason
> - add a missing kfree() spotted by Smatch
> - add additional algo length name checks when constructing the essiv()
>   cipher name
> - reinstate the 'essiv' IV generation implementation in dm-crypt, but
>   make its generation function identical to plain64le (and drop the other
>   methods)
> - fix a bug in the arm64 CE/NEON code
> - simplify the arm64 code by reusing more of the existing CBC implementation
>   (patch #6 is new to this series and was added for this reason)
>
> Changes since v3:
> - address various review comments from Eric on patch #1
> - use Kconfig's 'imply' instead of 'select' to permit CRYPTO_ESSIV to be
>   enabled as a module or disabled entirely even if fscrypt is compiled in (#2)
> - fix an issue in the AEAD encrypt path caused by the IV being clobbered by
>   the inner skcipher before the hmac was being calculated
>
> Changes since v2:
> - fixed a couple of bugs that snuck in after I'd done the bulk of my
>   testing
> - some cosmetic tweaks to the ESSIV template skcipher setkey function
>   to align it with the aead one
> - add a test case for essiv(cbc(aes),aes,sha256)
> - add an accelerated implementation for arm64 that combines the IV
>   derivation and the actual en/decryption in a single asm routine
>
> Scroll down for tcrypt speed test result comparing the essiv template
> with the asm implementation. Bare cbc(aes) tests included for reference
> as well. Taken on a 2GHz Cortex-A57 (AMD Seattle)
>
> Code can be found here
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=essiv-v8
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: dm-devel@redhat.com
> Cc: linux-fscrypt@vger.kernel.org
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: Milan Broz <gmazyland@gmail.com>
>
> Ard Biesheuvel (7):
>   crypto: essiv - create wrapper template for ESSIV generation
>   fs: crypto: invoke crypto API for ESSIV handling
>   md: dm-crypt: infer ESSIV block cipher from cipher string directly
>   md: dm-crypt: switch to ESSIV crypto API template
>   crypto: essiv - add test vector for essiv(cbc(aes),aes,sha256)
>   crypto: arm64/aes-cts-cbc - factor out CBC en/decryption of a walk
>   crypto: arm64/aes - implement accelerated ESSIV/CBC mode
>
>  arch/arm64/crypto/aes-glue.c  | 205 +++++--
>  arch/arm64/crypto/aes-modes.S |  29 +-
>  crypto/Kconfig                |  28 +
>  crypto/Makefile               |   1 +
>  crypto/essiv.c                | 640 ++++++++++++++++++++
>  crypto/tcrypt.c               |   9 +
>  crypto/testmgr.c              |  14 +
>  crypto/testmgr.h              | 497 +++++++++++++++
>  drivers/md/Kconfig            |   1 +
>  drivers/md/dm-crypt.c         | 235 ++-----
>  fs/crypto/Kconfig             |   1 +
>  fs/crypto/crypto.c            |   5 -
>  fs/crypto/fscrypt_private.h   |   9 -
>  fs/crypto/keyinfo.c           |  93 +--
>  14 files changed, 1435 insertions(+), 332 deletions(-)
>  create mode 100644 crypto/essiv.c
>
> --
> 2.17.1
>
