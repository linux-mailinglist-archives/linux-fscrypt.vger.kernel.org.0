Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7D689845
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 09:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfHLHuc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 03:50:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38360 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfHLHuc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 03:50:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id m125so6829211wmm.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 12 Aug 2019 00:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3fUIo7bf1pVPngPlyIX37AdYP0H8U4V2yGXzc3Q8PU=;
        b=oTfqh5iRHusnTRpAqy4qvCs8UwHzoKalNbqMK/GjgIboOgPnfdXRyXnph+Q37L7hc6
         5L8nRT1ZtexlBg+WQw5KrY1H+fYbgWjHqv9QL8Vg2kzsKzb2kYJPeOT2RZz4GFhzthnj
         2hKX6j7vrWopkZGcewExFiAeKafnl/M8gLPo2ku/KWuX0IG7cSgEIYJa41kqEKSwa/R7
         UDQ/J9fuH6hoNIYy7Gls/PJ2v3y7+aDjRhmBQwjqLNz29KSh+BgPUiiNdg1RIDJxB5E7
         NiNuN5ngcwxOe+en/TyM5rgehfOAJa54oo+rSMScntSkZDQfPLq1mJt0haiJX1v4UCm0
         obCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3fUIo7bf1pVPngPlyIX37AdYP0H8U4V2yGXzc3Q8PU=;
        b=d5ne9c/BEsQTFfMb2qfJCwR+Ec9ID062bqf8kyvq3J5S636Cuuubr93tmMlcWj5UdJ
         U4lXbFamNeylXORmxvNxdgIO4Rf8r4NDMIfEpctk6Xe/GLcHIgICdfEDcUqdnoRulH1W
         XWkoe3crc0oi8k21GH3997cePhKt0tBQxRDD8pBX76z5KWpoGDNbESIhcv+Ak/yFaw8a
         3lH3uHA8qwtYEqMv2/D3EWFk/zPtB3wnb/tommSnr36TGAsLmxc35WV0l2Cal004PVyS
         kNUC9mzuGDnt742p4fWvk4RoRFo/LDe4qNcW+394a8KBZ0CwlLElhlOadr+t5kchVKam
         c14g==
X-Gm-Message-State: APjAAAWyCyEQh2KrCNIEe0GRMYTA2pGph9i92XNJKUtwUSerfRMhalga
        a4r1PjW9+Xm12ioEMXT+gf9sajlUp5iuItERYMMfuQ==
X-Google-Smtp-Source: APXvYqwgX4GSGhKVfxz1Y7uXiz3RKDX4LiVGl3zj4caTjar5UkkOQnpMqABzSOE6jltHT5IOZsjPe+lkzp++qlubqQ4=
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr5924657wmi.10.1565596229982;
 Mon, 12 Aug 2019 00:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org> <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
 <CAKv+Gu-ZPPR5xQSR6T4o+8yJvsHY2a3xXZ5zsM_aGS3frVChgQ@mail.gmail.com> <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
In-Reply-To: <82a87cae-8eb7-828c-35c3-fb39a9abe692@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 12 Aug 2019 10:50:18 +0300
Message-ID: <CAKv+Gu_d+3NsTKFZbS+xeuxf5uCz=ENmPX-a=s-2kgLrW4d7cQ@mail.gmail.com>
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
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

On Mon, 12 Aug 2019 at 10:44, Milan Broz <gmazyland@gmail.com> wrote:
>
> On 12/08/2019 08:54, Ard Biesheuvel wrote:
> > On Mon, 12 Aug 2019 at 09:33, Milan Broz <gmazyland@gmail.com> wrote:
> >> Try for example
> >> # cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1
> >>
> >> It should produce Crypto API string
> >>   authenc(hmac(sha256),essiv(cbc(aes),sha256))
> >> while it produces
> >>   essiv(authenc(hmac(sha256),cbc(aes)),sha256)
> >> (and fails).
> >>
> >
> > No. I don't know why it fails, but the latter is actually the correct
> > string. The essiv template is instantiated either as a skcipher or as
> > an aead, and it encapsulates the entire transformation. (This is
> > necessary considering that the IV is passed via the AAD and so the
> > ESSIV handling needs to touch that as well)
>
> Hm. Constructing these strings seems to be more confusing than dmcrypt mode combinations :-)
>
> But you are right, I actually tried the former string (authenc(hmac(sha256),essiv(cbc(aes),sha256)))
> and it worked, but I guess the authenticated IV (AAD) was actually the input to IV (plain sector number)
> not the output of ESSIV? Do I understand it correctly now?
>

Indeed. The former string instantiates the skcipher version of the
ESSIV template, and so the AAD handling is omitted, and we end up
using the plain IV in the authentication rather than the encrypted IV.

So when using the latter string, does it produce any error messages
when it fails?
