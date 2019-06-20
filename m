Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76234CF9B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 15:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfFTNwn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 09:52:43 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34824 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfFTNwm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 09:52:42 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so242237ioo.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 06:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPlo4ROIMQa8sOuaoqIkOQSj3Mcwb4w4V3cG/vc+vQA=;
        b=lxhbTNJhQFHk5Nh49O6lU3dP3+kNBGjoiUV/BmQODg1LQ9Ub0dY++pcl+pEuFGqFrT
         EzzKvo6ufBm/yDlmslfhMxaC6tBCVVuhFtRoZJ2+/uexU7u3Dpw/5JikDj7jbU4h+0vG
         oxm+FB1xxsa00eBmMG6HfGBDgYCY76whWDcTY1+7Dbp7jtNOL0a/VLmwhvraGWbEnYXh
         V+ZRKzeFMi7E5UQ0zNGA6KFdYevZbtBXc4htEE9IXNtQMYreaMAQ17xo2wkT5wJotxy+
         UMVM93Is2GOBTuQTLDk1cKc+cGEIAmgePwFuaFNU9Lw+zlkalRvhmXBXLTjbzwo77HJV
         mlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPlo4ROIMQa8sOuaoqIkOQSj3Mcwb4w4V3cG/vc+vQA=;
        b=mB+agxlIbvfvvfQsYVVah/G5qPZFXRVm0hFyWOeFbsVbhv1Yj3dlkzg2uyrrLcYzWB
         KErZSN4gAgxREEj79IPTjtgtw7t1vGlSeEMwx7JnM6YgAK8RwS6T9A7i/kXzoRCfFC+t
         yXqd5XVExWDcNI/uXrz0sWGRCXOaRDjb7hloD2laVKcWyU9nIA30YAaIAGgu1qPXu3vF
         jknUpg/1Y6hHsYOHco/hgYtZppgPwY/UolFlLQY2xoPf5BncKnlBX8DDMT0RlEYaq/GE
         QD0u2/Soq3L6yb+EWqV8N2JSUAxMDfebQDRjovOof2vChT+LtqTMuFkpTkOIgO7v17C3
         4Ylw==
X-Gm-Message-State: APjAAAUIKHF/I/4D7sLzLv8dekGRe8Bt9n5evBo9lpzA4SOwW1KjDJE5
        xzEdg4d+TSDvsPzJx+WprUz9QTaiAbfhyBUPtBtFNg==
X-Google-Smtp-Source: APXvYqw6VAlpllr5EWM/2M4CZD21EH8cP8bUHreqigRUdab056YARTj1ExIee/8IV/gjAnwOXXpKbQ6WhMtLupqmbtw=
X-Received: by 2002:a5d:9d97:: with SMTP id 23mr18882540ion.204.1561038762005;
 Thu, 20 Jun 2019 06:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <459f5760-3a1c-719d-2b44-824ba6283dd7@gmail.com> <CAKv+Gu9jk8KxWykTcKeh6k0HUb47wgx7iZYuwwN8AUyErFLXxA@mail.gmail.com>
 <075cddec-1603-4a23-17c4-c766b4bd9086@gmail.com> <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
In-Reply-To: <6a45dfa5-e383-d8a3-ebf1-abdc43c95ebd@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 15:52:30 +0200
Message-ID: <CAKv+Gu-ZETNJh2VzUkpbQUmYv6Zqb7nVj91bxuxKoNAJwgON=w@mail.gmail.com>
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

On Thu, 20 Jun 2019 at 15:14, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 20/06/2019 14:09, Milan Broz wrote:
> > On 20/06/2019 13:54, Ard Biesheuvel wrote:
> >> On Thu, 20 Jun 2019 at 13:22, Milan Broz <gmazyland@gmail.com> wrote:
> >>>
> >>> On 19/06/2019 18:29, Ard Biesheuvel wrote:
> >>>> This series creates an ESSIV template that produces a skcipher or AEAD
> >>>> transform based on a tuple of the form '<skcipher>,<cipher>,<shash>'
> >>>> (or '<aead>,<cipher>,<shash>' for the AEAD case). It exposes the
> >>>> encapsulated sync or async skcipher/aead by passing through all operations,
> >>>> while using the cipher/shash pair to transform the input IV into an ESSIV
> >>>> output IV.
> >>>>
> >>>> This matches what both users of ESSIV in the kernel do, and so it is proposed
> >>>> as a replacement for those, in patches #2 and #4.
> >>>>
> >>>> This code has been tested using the fscrypt test suggested by Eric
> >>>> (generic/549), as well as the mode-test script suggested by Milan for
> >>>> the dm-crypt case. I also tested the aead case in a virtual machine,
> >>>> but it definitely needs some wider testing from the dm-crypt experts.
> >>>>
> >>>> Changes since v2:
> >>>> - fixed a couple of bugs that snuck in after I'd done the bulk of my
> >>>>   testing
> >>>> - some cosmetic tweaks to the ESSIV template skcipher setkey function
> >>>>   to align it with the aead one
> >>>> - add a test case for essiv(cbc(aes),aes,sha256)
> >>>> - add an accelerated implementation for arm64 that combines the IV
> >>>>   derivation and the actual en/decryption in a single asm routine
> >>>
> >>> I run tests for the whole patchset, including some older scripts and seems
> >>> it works for dm-crypt now.
> >>>
> >>
> >> Thanks Milan, that is really helpful.
> >>
> >> Does this include configurations that combine authenc with essiv?
> >
> > Hm, seems that we are missing these in luks2-integrity-test. I'll add them there.
> >
> > I also used this older test
> > https://gitlab.com/omos/dm-crypt-test-scripts/blob/master/root/test_dmintegrity.sh
> >
> > (just aes-gcm-random need to be commented out, we never supported this format, it was
> > written for some devel version)
> >
> > But seems ESSIV is there tested only without AEAD composition...
> >
> > So yes, this AEAD part need more testing.
>
> And unfortunately it does not work - it returns EIO on sectors where it should not be data corruption.
>
> I added few lines with length-preserving mode with ESSIV + AEAD, please could you run luks2-integrity-test
> in cryptsetup upstream?
>
> This patch adds the tests:
> https://gitlab.com/cryptsetup/cryptsetup/commit/4c74ff5e5ae328cb61b44bf99f98d08ffee3366a
>
> It is ok on mainline kernel, fails with the patchset:
>
> # ./luks2-integrity-test
> [aes-cbc-essiv:sha256:hmac-sha256:128:512][FORMAT][ACTIVATE]sha256sum: /dev/mapper/dmi_test: Input/output error
> [FAIL]
>  Expecting ee501705a084cd0ab6f4a28014bcf62b8bfa3434de00b82743c50b3abf06232c got .
>
> FAILED backtrace:
> 77 ./luks2-integrity-test
> 112 intformat ./luks2-integrity-test
> 127 main ./luks2-integrity-test
>

OK, I will investigate.

I did my testing in a VM using a volume that was created using a
distro kernel, and mounted and used it using a kernel with these
changes applied.

Likewise, if I take a working key.img and mode-test.img, i can mount
it and use it on the system running these patches.

I noticed that this test uses algif_skcipher not algif_aead when it
formats the volume, and so I wonder if the way userland creates the
image is affected by this?
