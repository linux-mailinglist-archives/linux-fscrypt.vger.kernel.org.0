Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5614CEED
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 15:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbfFTNfl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 09:35:41 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33416 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFTNfl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 09:35:41 -0400
Received: by mail-io1-f67.google.com with SMTP id u13so557224iop.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 06:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIDlsIvtATsL3hA5QAEsaHCyI03s2C5u03IcGdawceo=;
        b=o9alXZRUfb+rgrya2OuK7msSKBSLIOUcWsFtVHJICr1ID4KycIx7HeXphqKApgwkI9
         iw0YS5AdA0fd8S83GuH7isN4P46piJaZucQrcO8ruXW+kJlrMAlX7V3RGwNhUMBHwusy
         CKEO6hOXtvhXh8p3lY2HbCSH+vJY+2boyK2mzZ+5o73aqFC2CzeGmVxRVgquHcMCRso4
         CC/ckDTCWo5P1Lhs3Hz5hBXUExB8hoc+AiNI21xrnOnoXE8FK+7zsnyuEz5t7kEGTuGf
         wCKoKqoq4Tskwk2qh+Y240HsyZpWKtvGadkxkAFffQ3V/GkdyDzDIDUFJ1NZsm/n7kRv
         xq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIDlsIvtATsL3hA5QAEsaHCyI03s2C5u03IcGdawceo=;
        b=J0j9pJz4SdcW+tqCWcil1wOz4wvTqaL5kmlcb8lA58wpyZKcCuzn9/JtfIj3IUND23
         t5qmmhVwFIq6N8cwnE4SbIX9bgQlNOsRZY9zgeqqQ3WKICzuAYZ+zZkhpfc3LoCdw1l9
         4KOTb0bUQ1u+fLiGlxCgbqPbtEHralbWh6b2mrR9dM2yGtKsfwlmrMTcWjEo5s7hNuHM
         sW+cZ2mY8PHpaNJirq51d/lJKPU7Ggec+VLixeIDtYITud0nbR7WL5Qb8QMdI8mGlrJC
         eyMf6LH7yamEKWDotxVvBaZQNTAk94kkewbq2JyMfExsO1wmTQxlzHYxJpUSkV8xSpa5
         ZfkA==
X-Gm-Message-State: APjAAAWUCyZ/+Di9FZSRRI2NssgEYywM6Yk9ChVuP/v/a2YzqMc7ky0H
        YfgCNu5+I1HR/lD+XLtW8pyx8LjYFyIYWDvw7n+9jkqAB5M=
X-Google-Smtp-Source: APXvYqxDNCT96WaC9Fy8q5f65kLAobnwxGYT6HTiFYdT15g7/FQXFMdaTJClLAv6we1Ldq6NmxiyxWHSpR02EcCMayA=
X-Received: by 2002:a02:9143:: with SMTP id b3mr48893jag.12.1561037740085;
 Thu, 20 Jun 2019 06:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au> <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 15:35:28 +0200
Message-ID: <CAKv+Gu_7dQsJdb1Wmn2mzG7HFcfjF7ggGzUyPB5b_JR0ujHCrQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 20 Jun 2019 at 15:02, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 20 Jun 2019 at 14:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Jun 20, 2019 at 09:30:41AM +0200, Ard Biesheuvel wrote:
> > >
> > > Is this the right approach? Or are there better ways to convey this
> > > information when instantiating the template?
> > > Also, it seems to me that the dm-crypt and fscrypt layers would
> > > require major surgery in order to take advantage of this.
> >
> > Oh and you don't have to make dm-crypt use it from the start.  That
> > is, you can just make things simple by doing it one sector at a
> > time in the dm-crypt code even though the underlying essiv code
> > supports multiple sectors.
> >
> > Someone who cares about this is sure to come along and fix it later.
> >
>
> It also depend on how realistic it is that we will need to support
> arbitrary sector sizes in the future. I mean, if we decide today that
> essiv() uses an implicit sector size of 4k, we can always add
> essiv64k() later, rather than adding lots of complexity now that we
> are never going to use. Note that ESSIV is already more or less
> deprecated, so there is really no point in inventing these weird and
> wonderful things if we want people to move to XTS and plain IV
> generation instead.

Never mind, the sector size is already variable ...
