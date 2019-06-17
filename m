Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8648F47E4A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jun 2019 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfFQJYn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jun 2019 05:24:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40160 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfFQJYn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jun 2019 05:24:43 -0400
Received: by mail-io1-f65.google.com with SMTP id n5so19600602ioc.7
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jun 2019 02:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIqikUxxUkznt/nPhZHSPquXqmCjr0iAh/jFh9d8P3A=;
        b=fLsvWmEGUkcftWJR9NozAsTm7Mo72HiPUuzSfhlKYGihIuydPz99+gbl4pOBPFGByl
         5CIEpGGJJQNDSYPn0PzRtpPQdNDaJidhuYmvMJ/qGYxqEfY75Ezgbf7dY+eDXGIi/ZT4
         j1+zcJYVZnCg87OeiZ34VLfHtpO9w63q8EK1sfhoSH9VoZD7yjbChUCDRgZsvl0hhxVX
         8mVAzAd/n8cw3ugcUssXJybA9+gInlaL9G+E1+j7TXyz0lAyz/+7aiTCD/vvXBZw9zl1
         bw8N6Y2lGCJ2qPBrnrH3K52Sdi6Jl3gZsF5b80N2DmKrM8/CWHDEk6w4hYqV2GgZPAOG
         KzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIqikUxxUkznt/nPhZHSPquXqmCjr0iAh/jFh9d8P3A=;
        b=fmEq/nkYNFYvKpvZ03EE7qA+k0Gp8ymwIR5n2HscdX/fkfzZAhRhG3sSnkAhJ69AO7
         Zxtql4F5gugD/2u2RNUGSRN4ZYnvMkr/sJ+8KV8pLRrkzypi6eXse10m5/0A9vO6TnnC
         kMnT6uRE+6WTy0OaxEUmfoevuw+1rFdxV8Zy8EXkrW0f5LWZ4D8O6cILn87g0ME0zQfp
         h2TrMMW5YZq7+KkCZ/m2UVRPB7ApyO/wiqSPVuvqe1v63Gf59gRUPLlMIgXARv9lQ+KG
         LYmxoW0hRLzaVxzZ/jYDQOTdA0gqM+QmZLsx+qq3N6ImP7vvjTBpzM3KisNV1Oy8bpTh
         s3LA==
X-Gm-Message-State: APjAAAW/QqVkSp1SVLNjBMiZFxcHjK9DwycgcUJSsCWW14Bi6vgcNA5l
        uKdasCsl6MIwgacwADYISJ+EFtMUuzGllQt4d+bUrg==
X-Google-Smtp-Source: APXvYqxU96w28abtHE8iCpMU+y7SrZIpL//Bw34gn+u4ZU8wsAw3pX+V1uOspSgWJpQNL5A2E/SEDtf0TJoK9q0SimM=
X-Received: by 2002:a5d:9456:: with SMTP id x22mr868694ior.71.1560763482317;
 Mon, 17 Jun 2019 02:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <20190616204419.GE923@sol.localdomain> <CAOtvUMf86_TGYLoAHWuRW0Jz2=cXbHHJnAsZhEvy6SpSp_xgOQ@mail.gmail.com>
 <CAKv+Gu_r_WXf2y=FVYHL-T8gFSV6e4TmGkLNJ-cw6UjK_s=A=g@mail.gmail.com> <20190617092012.gk7wrazxh7bwfmjk@gondor.apana.org.au>
In-Reply-To: <20190617092012.gk7wrazxh7bwfmjk@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 11:24:31 +0200
Message-ID: <CAKv+Gu_34nOAcTBJPi7cR2W7w-1c27ofgoDaXZtuZh8qaaQJSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] crypto: switch to shash for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 17 Jun 2019 at 11:20, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jun 17, 2019 at 11:15:01AM +0200, Ard Biesheuvel wrote:
> >
> > Ah yes, thanks for reminding me. There was some debate in the past
> > about this, but I don't remember the details.
>
> I think there were some controversy regarding whether the resulting
> code lived in drivers/md or crypto.  I think as long as drivers/md
> is the only user of the said code then having it in drivers/md should
> be fine.
>
> However, if we end up using/reusing the same code for others such as
> fs/crypto then it might make more sense to have them in crypto.
>

Agreed. We could more easily test it in isolation and ensure parity
between different implementations, especially now that we have Eric's
improved testing framework that tests against generic implementations.
