Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5A94E0D3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Jun 2019 09:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfFUHGd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jun 2019 03:06:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38350 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfFUHGd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jun 2019 03:06:33 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so310909ioa.5
        for <linux-fscrypt@vger.kernel.org>; Fri, 21 Jun 2019 00:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+ipu44bRUM/fC2jb/sLHPlE7YLX58quUWlKDNfCZgo=;
        b=xrfqfzE36e7CEm7bA18IJhpxy273utoadSKj3s++FOJM88tNE2GFyT5oj4zrUMcMV+
         dzK9INeaOjY4nIlRbawaFnt9Bkhn+WU8rEOSi1GtjNFHGXxitO+uzNCvsmmrwpIGSI9B
         Z4QcNQzmwr3H21SMGcIZKkBdJDYIHmT66iuppXGKlRsO9xL/Z151AlKIxv99kpYTEZKH
         n3ITIF6nkFPX7zxnmkKqL7hk+7LjLoWr359Z0zeyh22McgUKWk3B3lP65L0uLV+Jkdxu
         sEjedU3TfLQjQ/4XLYlP39mDNfu0CF9OLRwoXeRky2pGslk9fe9jOB37fI+QkgPJcUys
         JIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+ipu44bRUM/fC2jb/sLHPlE7YLX58quUWlKDNfCZgo=;
        b=PGgEeaJhsLNiJC5nR+/MlDsLi4r4ADjm5vZw4xozpeHwWqP5ql/4suCLIylbl61q9f
         3gr636ZhHMWe4JipN5x9MqQNbNnS2g06YBwPMRJIvoOyREL10AO95gHbL0Ns6OuTUfY+
         EZmlRwLBONaLOGeA6Idlab6qJIv47FUozF1wA2sPTDr0FzFos7V6wngcbhPH+wXL+doJ
         q80em5Q409ogML+aD8IzGN6Mw0vq4XZbllxFB0dZ70cxc5mnOaGFX+PIHqW9mzWF1hXo
         hP2YIYoyshh9Z16SjY5SFceDPnuE9nGlHf2kjF04YPc7kW2ZxGJbq5i5A0oC7ItKSuND
         Bh8Q==
X-Gm-Message-State: APjAAAUF/WXhFGGD6q2K99rgwzSFkIWY/RNaSr6GPcTvBaPKwR5dLaJJ
        aIjzEGFhkPHhuM5GCbPT/PX34dMHWkcfauj0kcZT0g==
X-Google-Smtp-Source: APXvYqwDFrY41dQ7KWWg8abbd4ymKKguSu8Q/QL1WMr5Z+rXtSQTafy2FrDJqQ7NOxKIenuKOrtN7EdnmxQjwAi8yRE=
X-Received: by 2002:a02:5a89:: with SMTP id v131mr19144017jaa.130.1561100792521;
 Fri, 21 Jun 2019 00:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com> <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
 <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com> <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
 <CAKv+Gu-ZETNJh2VzUkpbQUmYv6Zqb7nVj91bxuxKoNAJwgON=w@mail.gmail.com> <b635b78d-cfe8-3fa4-d9b2-6cf4185dac71@gmail.com>
In-Reply-To: <b635b78d-cfe8-3fa4-d9b2-6cf4185dac71@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 21 Jun 2019 09:06:20 +0200
Message-ID: <CAKv+Gu-uRUFv1+yEqNdM1KpJSwic2oGF=CYPU6Sebf3eXwruMQ@mail.gmail.com>
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

On Fri, 21 Jun 2019 at 09:01, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 20/06/2019 15:52, Ard Biesheuvel wrote:
> >>>> Does this include configurations that combine authenc with essiv?
> >>>
> >>> Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.
> >>>
> >>> I also used this older test
> >>> https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh
> >>>
> >>> (just aes-gcm-random need to be commented out, we never supported this format, it was
> >>> written for some devel version)
> >>>
> >>> But seems ESSIV is there tested only without AEAD composition...
> >>>
> >>> So yes, this AEAD part need more testing.
> >>
> >> And unfortunately it does not work - it returns EIO on sectors where it should not be data corruption.
> >>
> >> I added few lines with length-preserving mode with ESSIV + AEAD, please could you run luks2-integrity-test
> >> in cryptsetup upstream?
> >>
> >> This patch adds the tests:
> >> https://gitlab.com/cryptsetup/cryptsetup/commit/4c74ff5e5ae328cb61b44bf99f98d08ffee3366a
> >>
> >> It is ok on mainline kernel, fails with the patchset:
> >>
> >> # ./luks2-integrity-test
> >> [aes-cbc-essiv:sha256:hmac-sha256:128:512][FORMAT][ACTIVATE]sha256sum: /dev/mapper/dmi_test: Input/output error
> >> [FAIL]
> >>  Expecting ee501705a084cd0ab6f4a28014bcf62b8bfa3434de00b82743c50b3abf06232c got .
> >>
> >> FAILED backtrace:
> >> 77 ./luks2-integrity-test
> >> 112 intformat ./luks2-integrity-test
> >> 127 main ./luks2-integrity-test
> >>
> >
> > OK, I will investigate.
> >
> > I did my testing in a VM using a volume that was created using a
> > distro kernel, and mounted and used it using a kernel with these
> > changes applied.
> >
> > Likewise, if I take a working key.img and mode-test.img, i can mount
> > it and use it on the system running these patches.
> >
> > I noticed that this test uses algif_skcipher not algif_aead when it
> > formats the volume, and so I wonder if the way userland creates the
> > image is affected by this?
>
> Not sure if I understand the question, but I do not think userspace even touch data area here
> (except direct-io wiping after the format, but it does not read it back).
>
> It only encrypts keyslots - and here we cannot use AEAD (in fact it is already
> authenticated by a LUKS digest).
>
> So if the data area uses AEAD (or composition of length-preserving mode and
> some authentication tag like HMAC), we fallback to non-AEAD for keyslot encryption.
>
> In short, to test it, you need to activate device (that works ok with your patches)
> and *access* the data, testing LUKS format and just keyslot access will never use AEAD.
>
> So init the data by direct-io writes, and try to read them back (with dd).
>
> For testing data on dm-integrity (or dm-crypt with AEAD encryption stacked oved dm-integrity)
> I used small utility, maybe it could be useful https://github.com/mbroz/dm_int_tools
>

Thanks.

It appears that my code generates the wrong authentication tags on
encryption, but on decryption it works fine.
I'll keep digging ...
