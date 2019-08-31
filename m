Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D622A4560
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Aug 2019 18:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfHaQiC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Aug 2019 12:38:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46542 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfHaQiC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Aug 2019 12:38:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so8534776wrt.13
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Aug 2019 09:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mHCgJTa167mXOf521wY9Uhp8C8rQVMSZvRt1D4lWNlU=;
        b=dYXFBAYxoNOiN1xNVpdMIn8W8TYv7nuYIRPaL9r9sf2ARnssriUhdkMoOCH8ji3jbb
         y67Np56SMreukzf95+aotZk/sxdeq9j2rEKCTcLkpJcnUI4MYooy/rtu7TBQQORAoxM+
         VSAe9IIfJgUTQETHvvd2mbIEZ2RefeggyVhxa6FgQSnxiiRmIZw9jiLeYBthLnte18ZD
         x45mSZueT0qq9CgxPvD7X/URNqgGSCVS0vONh659TayRHNhrVqMYNb7mE2n9+dowpMqC
         NZJXwH2hZ4F+aZaUKhSfbHROcpn0SK1816l5laIWLogLV3gczX05KA2mlqdae7hTijIr
         9tGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mHCgJTa167mXOf521wY9Uhp8C8rQVMSZvRt1D4lWNlU=;
        b=ILZ4Gg2Da/jCzYt+oz84j35O66QATEHg6luEjvWDQfXN/aha98bEI2ndob//XIiMSW
         EPandF3oSkBD/1JnH+vdxyWpH8fcaEHAiuP7ITxBhSNMWwJGvicby2keNLXq1wytRMlJ
         k6GoqmjxXniRxxgIfRJXwkMdiegUspdPGqMQuhsictVM3Q6WJ0aRC3F2ubRnQUzYO5tC
         jDmMKq+lCeThQPYmSWzRewbMd+mQteAIYY96TpxoD/dFthJWjWWpp0RgY5DBZMjAFQQn
         rjvR7Y0PLlKzbgUfr+h6L53OSwrjSIjkBn5drpouhZaKVacItrsT1mBJRS8FbQ5cbKA5
         ZImg==
X-Gm-Message-State: APjAAAUdWugE8KJdnZ3PD496+o+GwphlOmtislrLyIw+Kegl7WrlMgBn
        DmqevQI51nF/U6qnOZPCeuNCn9xvPVpKW159l0SL7Q==
X-Google-Smtp-Source: APXvYqxOF01WJIu5hP8TwQQKuuOgCrfcvI06umhuEUCpy+lqt2cBpviobMUs+d2ImL+amyZ4Tf04ZZJPwIXR8WA5nmc=
X-Received: by 2002:adf:ee50:: with SMTP id w16mr7303621wro.93.1567269480090;
 Sat, 31 Aug 2019 09:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
 <20190819141738.1231-2-ard.biesheuvel@linaro.org> <20190830045822.GA17901@gondor.apana.org.au>
In-Reply-To: <20190830045822.GA17901@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 31 Aug 2019 19:37:48 +0300
Message-ID: <CAKv+Gu-7c+L4KzC=h=rBxLhZRt3RhK3eO2L2NvVrajR0MX_9+g@mail.gmail.com>
Subject: Re: [PATCH v13 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 30 Aug 2019 at 07:58, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Aug 19, 2019 at 05:17:33PM +0300, Ard Biesheuvel wrote:
> > Implement a template that wraps a (skcipher,shash) or (aead,shash) tuple
> > so that we can consolidate the ESSIV handling in fscrypt and dm-crypt and
> > move it into the crypto API. This will result in better test coverage, and
> > will allow future changes to make the bare cipher interface internal to the
> > crypto subsystem, in order to increase robustness of the API against misuse.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  crypto/Kconfig  |  28 +
> >  crypto/Makefile |   1 +
> >  crypto/essiv.c  | 663 ++++++++++++++++++++
> >  3 files changed, 692 insertions(+)
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Milan,

Hopefully, this can still be taken for v5.4. If not, please coordinate
with Eric on how to get this queued for v5.5

Thanks,
Ard.
