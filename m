Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E49C4E14A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Jun 2019 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFUHhh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jun 2019 03:37:37 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37386 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfFUHhh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jun 2019 03:37:37 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so309057iok.4
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Jun 2019 00:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eKu56qrR6ldaXAhpuMytqyaXBo7rKIWHf2u55/S5qlc=;
        b=ry3MGo6vj2UUu2k78C94AXspzrPTVv17EtBHPoknofeiZ/Orx2ftqk3BgPoZtzrySQ
         gPd8q6xevN0EQMJTG7oqVQ7vZG/3WYK6IB5su/Vv7tyWMvEPBT+NgIys0A/LUV8B+++3
         cUKfr8l/nLXxlV08YrRLzN1A20b6G2lWcJPM0uSAg6tahMRN2sDtXL8nHxDTUVmVMkKL
         q2WFuBW8unlJjgLsrlv7mXZcP7dLBCrk4QqA/C96H5hc1tWVTeSTGq6rYt9+tx2Sff+n
         xlxzWmkOzkkJp6wmK/S0yOno4cehwNim+KkdiP+z5fy6KebuhT0JgKWY66b+gku9pO15
         9njA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eKu56qrR6ldaXAhpuMytqyaXBo7rKIWHf2u55/S5qlc=;
        b=GIkkqHUkNBfQBUsYLyda/IpOqgt35cktSjmvg81lKI9rPbTrcW23M53Uhe1+++QSSO
         5oj8yASR9fyZa5ZIcRafG2PMBCNCan0Af645AQeGXRnHdFgOZwBFRACf8XQggc2p/M+B
         vwm01/DsCeH7IIfEEQb+j9WOyM26qI8NeiEWNlBayDGd9p5+LPIoE3FTKFGzonTMRFFl
         81D7dQMxF6EIUUeM7Ej/j5hAG/UT2FJId+nKC6elFWV6XDtbblKV7kriNgLBVkvNwR36
         Mgp1wPL4FcbZ4CHUhF2uBv/xxh5YW2PRw8mTl/29SBffyS17fa+abRUxmHN3NoGp2v7H
         IStA==
X-Gm-Message-State: APjAAAVi7G1ai2YysGLDbq72j2gkF8e4ylCtIg+k8Rdrc5MEa47BKSh8
        ZZKon7wL+aukDVv+vNSsBsmEXnnom579UMMRyq96pQ==
X-Google-Smtp-Source: APXvYqxImupikNlO14TIwMpCXgLXbnvoAqX+dwe6kFb5GggQWUFSXCcCfyRIkJCDq/nFa68GIFuX+IltrNSfDTDZ3UE=
X-Received: by 2002:a02:ce37:: with SMTP id v23mr23351565jar.2.1561102656600;
 Fri, 21 Jun 2019 00:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com> <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
 <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com> <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
 <CAKv+Gu-ZETNJh2VzUkpbQUmYv6Zqb7nVj91bxuxKoNAJwgON=w@mail.gmail.com>
 <b635b78d-cfe8-3fa4-d9b2-6cf4185dac71@gmail.com> <CAKv+Gu-uRUFv1+yEqNdM1KpJSwic2oGF=CYPU6Sebf3eXwruMQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu-uRUFv1+yEqNdM1KpJSwic2oGF=CYPU6Sebf3eXwruMQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 21 Jun 2019 09:37:25 +0200
Message-ID: <CAKv+Gu_aarbJ+UBjVP2eMEKekd_u-EPeAvuCwFVWfaO2uRhGUA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] crypto: switch to crypto API for ESSIV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 21 Jun 2019 at 09:06, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Fri, 21 Jun 2019 at 09:01, Milan Broz <gmazyland@gmail.com> wrote:
> >
> > On 20/06/2019 15:52, Ard Biesheuvel wrote:
> > >>>> Does this include configurations that combine authenc with essiv?
> > >>>
> > >>> Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.
> > >>>
> > >>> I also used this older test
> > >>> https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh
> > >>>
> > >>> (just aes-gcm-random need to be commented out, we never supported this format, it was
> > >>> written for some devel version)
> > >>>
> > >>> But seems ESSIV is there tested only without AEAD composition...
> > >>>
> > >>> So yes, this AEAD part need more testing.
> > >>
> > >> And unfortunately it does not work - it returns EIO on sectors where it should not be data corruption.
> > >>
> > >> I added few lines with length-preserving mode with ESSIV + AEAD, please could you run luks2-integrity-test
> > >> in cryptsetup upstream?
> > >>
> > >> This patch adds the tests:
> > >> https://gitlab.com/cryptsetup/cryptsetup/commit/4c74ff5e5ae328cb61b44bf99f98d08ffee3366a
> > >>
> > >> It is ok on mainline kernel, fails with the patchset:
> > >>
> > >> # ./luks2-integrity-test
> > >> [aes-cbc-essiv:sha256:hmac-sha256:128:512][FORMAT][ACTIVATE]sha256sum: /dev/mapper/dmi_test: Input/output error
> > >> [FAIL]
> > >>  Expecting ee501705a084cd0ab6f4a28014bcf62b8bfa3434de00b82743c50b3abf06232c got .
> > >>
> > >> FAILED backtrace:
> > >> 77 ./luks2-integrity-test
> > >> 112 intformat ./luks2-integrity-test
> > >> 127 main ./luks2-integrity-test
> > >>
> > >
> > > OK, I will investigate.
> > >
> > > I did my testing in a VM using a volume that was created using a
> > > distro kernel, and mounted and used it using a kernel with these
> > > changes applied.
> > >
> > > Likewise, if I take a working key.img and mode-test.img, i can mount
> > > it and use it on the system running these patches.
> > >
> > > I noticed that this test uses algif_skcipher not algif_aead when it
> > > formats the volume, and so I wonder if the way userland creates the
> > > image is affected by this?
> >
> > Not sure if I understand the question, but I do not think userspace even touch data area here
> > (except direct-io wiping after the format, but it does not read it back).
> >
> > It only encrypts keyslots - and here we cannot use AEAD (in fact it is already
> > authenticated by a LUKS digest).
> >
> > So if the data area uses AEAD (or composition of length-preserving mode and
> > some authentication tag like HMAC), we fallback to non-AEAD for keyslot encryption.
> >
> > In short, to test it, you need to activate device (that works ok with your patches)
> > and *access* the data, testing LUKS format and just keyslot access will never use AEAD.
> >
> > So init the data by direct-io writes, and try to read them back (with dd).
> >
> > For testing data on dm-integrity (or dm-crypt with AEAD encryption stacked oved dm-integrity)
> > I used small utility, maybe it could be useful https://github.com/mbroz/dm_int_tools
> >
>
> Thanks.
>
> It appears that my code generates the wrong authentication tags on
> encryption, but on decryption it works fine.
> I'll keep digging ...

OK, mystery solved.

The skcipher inside authenc() was corrupting the IV before the hmac
got a chance to read it.

I'll send out an updated version of the series.
