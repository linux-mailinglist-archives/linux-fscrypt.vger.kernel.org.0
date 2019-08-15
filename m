Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A688F2A7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 19:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731528AbfHOR7f (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 13:59:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40928 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730372AbfHOR7e (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 13:59:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id c3so2966370wrd.7
        for <linux-fscrypt@vger.kernel.org>; Thu, 15 Aug 2019 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fDiKGk9sGd71gzB1JxmvmDU6+YxWpqZzFJYbeb3g5Oc=;
        b=s+PbkYI63wwqg2bZSGV+5aCPEIRQdmwZ6g0owPrEyE1RefJJ79JWsHHZ+8xF5aufB9
         CT1xKQkXFHIeBDO7jO9PEHXNPS34Z/Irm3bGuuBfWcQkmr18XhRYv6XicDfswx6A90Yi
         LU+IQGF6SfF4kFURVmasNni8o5o3AibM3C+jMFzJ6ALff5N3YIJQE21janxNeEWE9/Ii
         WIpt8nswQe2VLtFXT/DwklNd4i+9fYtohOIEQxPzBrmHoth1JxkHWYXKixu2qsJ6mLa6
         0o8istn6X646ZaS5eUZBlFcdilMiod6scvyXx87cjL4jq1damUM145EeO+iVzUg2LkP+
         ymgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fDiKGk9sGd71gzB1JxmvmDU6+YxWpqZzFJYbeb3g5Oc=;
        b=OuoNoRLCsdvSQ8rTzvrOGlG/UwrPD2XP102MV+Qr/1LuYeIQeLfKrovWbWGUsgvjsq
         olfFLUyWSMZk/cyTEF7m6C3TiTPWksGfXSGXBbe+TttyLlzSL/eyhp1dQiTtAo8fhWAQ
         NGDE02xU33CRti84Dto/a18SsaeHxW8krGbsS3L5lSAbI6VMMhujWSjsYqnoy/7u+VHO
         mlmm4/XIR9Z31oSdTWtAqJOJ/MfI1l6zZymkIzuKCQluyyUx9otYJ100XfLqB6xx35+Q
         T/b969s8Mr1saEnEiZDQlv9qLHDRrk188E8myhM74kgf5s09KqOiJGWK70boiTBFCV5H
         MHyw==
X-Gm-Message-State: APjAAAXYk6eZcd830TXJgbo4qY7ZdqZW61IVVGE/uQhBzXNgBmhA1/od
        qvUcHvYOr8kU2kTlYRSb5g8EnLTmS7jsztnHrqCHoQ==
X-Google-Smtp-Source: APXvYqzZXQJtLZz35otOaBEz0CFyoFQKMPLr3kKlvp4Bb0CNFG6zHi3siAAk337L0RQzmGYzvAhUKBi6JyPlOUBWQ04=
X-Received: by 2002:adf:eb52:: with SMTP id u18mr6426644wrn.174.1565891972765;
 Thu, 15 Aug 2019 10:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com>
 <20190815051320.GA24982@gondor.apana.org.au> <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
 <20190815113548.GA27723@gondor.apana.org.au> <CAKv+Gu9Yx3Jk_ikZC1GrR8rR1zV_5CzkXv5NntXnLYim2n+R9g@mail.gmail.com>
In-Reply-To: <CAKv+Gu9Yx3Jk_ikZC1GrR8rR1zV_5CzkXv5NntXnLYim2n+R9g@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 20:59:21 +0300
Message-ID: <CAKv+Gu9wK_8RxOer5x5UuMu4rTZOWP+6xaCu+LpSDff2o_ukOg@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 15 Aug 2019 at 20:46, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 15 Aug 2019 at 14:35, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Aug 15, 2019 at 08:15:29AM +0300, Ard Biesheuvel wrote:
> > >
> > > So what about checking that the cipher key size matches the shash
> > > digest size, or that the cipher block size matches the skcipher IV
> > > size? This all moves to the TFM init function?
> >
> > I don't think you need to check those things.  If the shash produces
> > an incorrect key size the setkey will just fail naturally.  As to
> > the block size matching the IV size, in the kernel it's not actually
> > possible to get an underlying cipher with different block size
> > than the cbc mode that you used to derive it.
> >
>
> dm-crypt permits any skcipher to be used with ESSIV, so the template
> does not enforce CBC to be used.
>
> > The size checks that we have in general are to stop people from
> > making crazy combinations such as lrw(des3_ede), it's not there
> > to test the correctness of a given implementation.  That is,
> > we assume that whoever provides "aes" will give it the correct
> > geometry for it.
> >
> > Sure we haven't made it explicit (which we should at some point)
> > but as it stands, it can only occur if we have a bug or someone
> > loads a malicious kernel module in which case none of this matters.
> >
>
> OK.
>
> > > Are there any existing templates that use this approach?
> >
> > I'm not sure of templates doing this but this is similar to fallbacks.
> > In fact we don't check any gemoetry on the fallbacks at all.
> >
>
> OK, so one other thing: how should I populate the cra_name template
> field if someone instantiates essiv(cbc(aes),sha256-ce)? We won't know
> until TFM init time what cra_name allocating the sha256-ce shash
> actually produces, so the only way to populate those names is to use
> the bare string supplied by the caller, which could be bogus.
>
> To me, it seems like retaining the spawn for the shash is more
> idiomatic, and avoids strange issues like the one above. Dropping the
> spawn for the encapsulated cipher (which is tightly coupled to the
> skcipher/aead being encapsulated) does seem feasible, so I'll go with
> that.

Actually, I should be able to lookup the alg without using it to
create a spawn. Let me try that instead.
