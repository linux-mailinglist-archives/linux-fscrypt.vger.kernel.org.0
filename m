Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD5C4CE20
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 15:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfFTNCQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 09:02:16 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33274 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfFTNCQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 09:02:16 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so311800iop.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 06:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZG8hEqbKe8+NeO2UU3Wo1+Qx5s8edmihncRtoEu3NsE=;
        b=MHTQMQVycFJCJ1pv4dvDM7CbdvxB6eMQ5eFLRBVsGLJPwPa9hppCUVqcneOWxT80KF
         jUe1M05/taAPwL1EJl0AnAGaG0KUbuYUTyWXis/WsdYyGp9eReDMAAK2U/GeHFsA5Rrr
         9VeWEtO5w18/7n5diW4KQIqXW1x48GXpihS2l8CkwMHl4QxJ3RwmM0bEPePNnbBTL+BI
         w2UMRGqFWkrOyc+6jnpUN5gy825JITBUPGdKC75EICXqMjMksL3U6Q/vj4N1U+WFFH1f
         PcEJxZZcsf5C0ad9umqyZjCFN+XMQN1JiXdijMWXEXkXihw+lfNQi02kqhJCExouBxFH
         liNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZG8hEqbKe8+NeO2UU3Wo1+Qx5s8edmihncRtoEu3NsE=;
        b=m5utolNzIHddRGjRxR9FutqpFIZPThru6G5G9RyxkSrKL0V/z2u2RudT8/grAFeWCv
         wrDNUtv6X7t8f9wC8Zci/DG9Kx/qv5XfNO9pW4EUJi4AUM3kNo4rOay4N3DD4fsEbZWf
         wqVl/JeIR37/XpJGOQgf/IURhFUWBISuo2QroG0aldwdidC+JXTl/h5DzD58y1BidDHY
         6phLmlH11Ioyxam9/+UMeUdW/8W04HAVf3jaM01GHMYLdfDIhy6AI1z+0hSQc2O9zHJ3
         ovqfeShdsQkm+4AsCc8GGYYD1PyqI7D+NhgUx7vGpNgsO90DBNa0FisbkUC3mIwpLsj1
         wZ1g==
X-Gm-Message-State: APjAAAXWf9PoZB6BXuKUvbf/BeqLX7dJ/MlSzSMp9uzcur2spmEDUkhX
        5P3yVbKtlsHF+P7ZGpuHfogwoiSmt2ajXKUSzr5rdA==
X-Google-Smtp-Source: APXvYqy2/J+ggwqeC5SCchrzOHDj4MwOttTaRmIM+xoZHARU21kDD/whmCPtQebvBvILJla6Mt768q+Wl8ajU6EQdQ0=
X-Received: by 2002:a5d:8794:: with SMTP id f20mr30229023ion.128.1561035735859;
 Thu, 20 Jun 2019 06:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au>
In-Reply-To: <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 15:02:04 +0200
Message-ID: <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
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

On Thu, 20 Jun 2019 at 14:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 20, 2019 at 09:30:41AM +0200, Ard Biesheuvel wrote:
> >
> > Is this the right approach? Or are there better ways to convey this
> > information when instantiating the template?
> > Also, it seems to me that the dm-crypt and fscrypt layers would
> > require major surgery in order to take advantage of this.
>
> Oh and you don't have to make dm-crypt use it from the start.  That
> is, you can just make things simple by doing it one sector at a
> time in the dm-crypt code even though the underlying essiv code
> supports multiple sectors.
>
> Someone who cares about this is sure to come along and fix it later.
>

It also depend on how realistic it is that we will need to support
arbitrary sector sizes in the future. I mean, if we decide today that
essiv() uses an implicit sector size of 4k, we can always add
essiv64k() later, rather than adding lots of complexity now that we
are never going to use. Note that ESSIV is already more or less
deprecated, so there is really no point in inventing these weird and
wonderful things if we want people to move to XTS and plain IV
generation instead.
