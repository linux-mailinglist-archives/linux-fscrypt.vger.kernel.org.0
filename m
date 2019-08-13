Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF008C049
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Aug 2019 20:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfHMSQ2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Aug 2019 14:16:28 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54695 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfHMSQ2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Aug 2019 14:16:28 -0400
Received: by mail-wm1-f68.google.com with SMTP id p74so2361723wme.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 13 Aug 2019 11:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Nrxu1gfhcbocfYIZUw0NkOzczURAyLQVnvTJn31YeTc=;
        b=x2xJ9KtUYmejpdb+kbqiHkXaAfhfDNN7U5IiJWhmumpTtrK2rYVpy7DfvU5zbhsimZ
         BFn+M9U7v5lyzCZ8INrOLufJ55/GJ6x2y97ZMvzps+dzZwn/ZnbZyp5Qmriva94OcoXF
         UFQo5zsChF51q+meunPCt2HLWsmUCIWsAhFmvmIppYUwsLjq+fhqxN8xBzryTW2S5icI
         qFsR9P/sxKCOP8dg2dA7Ukpb18hfmjtwUBGMmhgM07rBO0+og1B1PYI/6+EaIiGn97DZ
         8DslTNM23x8u8/qGyruiVB51ZiixCmm0J0n9o2HMF/S9F02kEtZMxm/C7vAv8BRvUCMC
         iKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Nrxu1gfhcbocfYIZUw0NkOzczURAyLQVnvTJn31YeTc=;
        b=W4xX6YMpMgQmr+vSAuB+PDRJX6zplhZHYOYucM4oHJNSaLF9nf/dZ/9NmAfJDa7rga
         laLkssk33ix7uHtUIIzrB9NJo/mIjbe/Q5nn2f4sDOreSyXNhcpvx8fZjl112JXj48a/
         UysMQnUy6vLzwSRE+KQs30/C/GzmmhYDZloujSpBNgCWbrsvMb4qTlQKJuLZOXwXHJGX
         E1pn3Ng63s51LEYcbIHTs5UCGrU5FyVhhki9Us9qOgwIMtHsIulYuA74zMrUBYMVnlOU
         aA2PSECpw8YlxX4EMKtlm/oMqOuJblUggR/7qXd48mllR+sFgAIfxowOibiKDmkDoLvp
         KHGA==
X-Gm-Message-State: APjAAAXx98G6l7nBvLnq24Nf9H56Qa113LWq7S+B6lTmiZwBO+HFvXzL
        CfMBdvDJSTUuxoJURxVLZoj11R31Jyoq39Wo7JpMlw==
X-Google-Smtp-Source: APXvYqxtZ6RS190EVhcPAEXpCsTTHX9gHaKFcumPuHU1VSD712jSdxyEDlEcsx+6ns9L97XUK86wnf9qb5k9JtXw1r8=
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr4097412wmi.61.1565720185710;
 Tue, 13 Aug 2019 11:16:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org> <20190812194747.GB131059@gmail.com>
 <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com> <20190813180020.GA233786@gmail.com>
In-Reply-To: <20190813180020.GA233786@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 13 Aug 2019 21:16:14 +0300
Message-ID: <CAKv+Gu8BFxyre0XDpE2To6yEvBP4E16abMZbR=r17TpQQko54Q@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v10 2/7] fs: crypto: invoke crypto API for
 ESSIV handling
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 13 Aug 2019 at 21:00, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Aug 13, 2019 at 08:09:41AM +0300, Ard Biesheuvel wrote:
> > On Mon, 12 Aug 2019 at 22:47, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> > > > Instead of open coding the calculations for ESSIV handling, use a
> > > > ESSIV skcipher which does all of this under the hood.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >
> > > This looks fine (except for one comment below), but this heavily conflicts with
> > > the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
> > > the series and having Herbert take only 1-6, and I'll apply this one to the
> > > fscrypt tree later.
> > >
> >
> > I think the same applies to dm-crypt: at least patch #7 cannot be
> > applied until my eboiv patch is applied there as well, but [Milan
> > should confirm] I'd expect them to prefer taking those patches via the
> > dm tree anyway.
> >
> > Herbert, what would you prefer:
> > - taking a pull request from a [signed] tag based on v4.3-rc1 that
> > contains patches #1, #4, #5 and #6, allowing Eric and Milan/Mike to
> > merge it as well, and apply the respective fscrypt and dm-crypt
> > changes on top
> > - just take patches #1, #4, #5 and #6 as usual, and let the fscrypt
> > and dm-crypt changes be reposted to the respective lists during the
> > next cycle
> >
>
> FWIW I'd much prefer the second option, to minimize the number of special things
> that Linus will have to consider or deal with.  (There's also going to be a
> conflict between the fscrypt and keyrings trees.)  I'd be glad to take the
> fscrypt patch for 5.5, if the essiv template is added in 5.4.
>

Works for me. I'll respin with the dm-crypt and fscrypt patches
omitted (and the minor fixes you suggested applied).
