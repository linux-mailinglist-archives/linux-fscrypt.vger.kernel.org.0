Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBB2FA2DC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jan 2021 15:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404497AbhAROWm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jan 2021 09:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392836AbhAROWZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jan 2021 09:22:25 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2758C061574
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Jan 2021 06:21:39 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id 186so6807934vsz.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Jan 2021 06:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Vm6t4j1UkDFvwn0ow87G236Agmhfjw2bgz8G0c2yDI=;
        b=YXqE56R8iZgWt/xrgnWS0ADg7SYiBItKyNtuwN2h7t8q8wy0w5JqyNKlBWWFXshlUJ
         CXagI21LIShLrGMg/Fe+mnuli1luaaTSzLB/NMpARZXTfROfsDQ/iYpdulrKRaH44omv
         S3dWkuVPoYR3IwAGyg2u+a7pE2le0xJ5aSX6UQ02k2X7P8OC5oRR/2mBDYU/RO97xmR/
         ue7BsAGWAwxc8eN2KmJVGqjUnBQuKE1bW5qwFvFfZ9cFLuc1KyfyJOPJVDZ+37g+WL2K
         0rvDzQ7f2IYdc6wYIYYbseljKuikW3Le4bFcVJON3qyVmain2Bxgg3VOyYtwlTCcLffH
         Uw4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Vm6t4j1UkDFvwn0ow87G236Agmhfjw2bgz8G0c2yDI=;
        b=GimtV4fAdoTfBzRq4TZC8GJ7y29VDH0qw6rcWXQLiidnvZLjD5NwbUjHowigZLt3ba
         Rb9iLOE91qDtPOjWDxlqoJNEQZub8+BCj+LygignBhEYON4gZSHsWN1WP1DDcB0m0ifg
         YsKwyrOYGITg10M1RNiLyvxUaqNYoUixZk8GXbppj2e4iIz2S6hv3p07RMWoz8WSbQ5M
         l0J/C0E0V2pi0+CjRDFxCD8NMlU5UXHhyijh2SDDdDN81xuGsamX1t/Dgc6W4l6a7uFm
         TADePwbLW0jPfTvyfhMyZGLTENjqO0xYexhRF4VCsANW7G3KteYgAAWpVzIyqCbwsuwg
         0WMw==
X-Gm-Message-State: AOAM530pe4MWF3o7kpKkXVS831FgnUKLUIHE0/uK/dJ39ZWdkFG/ABh2
        hDJyNgQ5mLUnJwDx9bx/yEWS6xKRcHHnrBRzQGYOyA==
X-Google-Smtp-Source: ABdhPJz90QZK3nqwzH2xdCIh6J4iWnuKhWdk04HEQs0XckljNnog8h9RjU13Vc2Neznz6h0kc0sFbd9aNjuBi9ia6Z0=
X-Received: by 2002:a67:7f41:: with SMTP id a62mr17276352vsd.55.1610979698621;
 Mon, 18 Jan 2021 06:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20210104184542.4616-1-ebiggers@kernel.org> <20210104184542.4616-2-ebiggers@kernel.org>
 <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com> <YAHXPREJaKjK/z7+@sol.localdomain>
In-Reply-To: <YAHXPREJaKjK/z7+@sol.localdomain>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Mon, 18 Jan 2021 15:21:01 +0100
Message-ID: <CAPDyKFopKy6dwENJ6YQQ0KRPQdT25R_zmhrNH7jyu=+p6bKpNA@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] mmc: add basic support for inline encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 15 Jan 2021 at 18:56, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Jan 15, 2021 at 10:22:03AM +0100, Ulf Hansson wrote:
> > On Mon, 4 Jan 2021 at 19:48, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > In preparation for adding CQHCI crypto engine (inline encryption)
> > > support, add the code required to make mmc_core and mmc_block aware of
> > > inline encryption.  Specifically:
> > >
> > > - Add a capability flag MMC_CAP2_CRYPTO to struct mmc_host.  Drivers
> > >   will set this if the host and driver support inline encryption.
> > >
> > > - Embed a blk_keyslot_manager in struct mmc_host.  Drivers will
> > >   initialize this if the host and driver support inline encryption.
> > >   mmc_block registers this keyslot manager with the request_queue of any
> > >   MMC card attached to the host.  mmc_core destroys this keyslot manager
> > >   when freeing the mmc_host.
> > >
> > > - Make mmc_block copy the crypto keyslot and crypto data unit number
> > >   from struct request to struct mmc_request, so that drivers will have
> > >   access to them.
> > >
> > > - If the MMC host is reset, reprogram all the keyslots to ensure that
> > >   the software state stays in sync with the hardware state.
> > >
> > > Co-developed-by: Satya Tangirala <satyat@google.com>
> > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > > Reviewed-by: Satya Tangirala <satyat@google.com>
> > > Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >
> > Eric, again, my apologies for the delay. Overall, I think this looks good.
> >
> > My only hesitation to merge this as is, is that I want to make sure
> > you have thought of the life cycle issues for the struct
> > blk_keyslot_manager ksm. It's being used both from the mmc core/block
> > device driver and the mmc host driver. I am looking at this right now
> > and will get back to you very soon, if I find some issues with it.
> >
> > If you have some time, feel free to elaborate around how this is
> > intended to work.
> >
> > Kind regards
> > Uffe
>
> The blk_keyslot_manager is initialized early on when the other host structures
> (struct mmc_host, struct cqhci_host, struct sdhci_host, struct sdhci_msm_host)
> are initialized, prior to mmc_add_host().
>
> It is destroyed when the struct mmc_host is freed by mmc_free_host().
>
> So it should just work; it's the same lifecycle as the existing host structures.
> Is there something you think I'm overlooking?

I think so, but let me elaborate a bit.

As I understand it, to initialize the data structures, blk_ksm_init()
is getting called and via cqhci_init().

To hook up the block request queue, blk_ksm_register() is called via
mmc_setup_queue(), which means this happens when the mmc block device
driver is probed.

To free up the data structures, blk_ksm_destroy() is called from
mmc_free_host().

To me, this can be made more consistent. For example, it looks like
blk_ksm_destroy() could be called, even if blk_ksm_init() hasn't been
called (depending on the probe error path of the mmc host).

There are a couple of options to better deal with this.
1) Extend the blk_ksm interface with a devm_blk_ksm_init() function
(thus let it deal with lifecycle problems for us) and simply drop the
call to blk_ksm_destroy().
2) Extend the cqhci interface with a cleanup function (perhaps
"cqhci_deinit") and let it call blk_ksm_destroy().
3) Convert to let blk_ksm_init() to be called from mmc_add_host() and
blk_ksm_destroy() from mmc_remove_host().

Moreover, even if there seems to be no real need to call
blk_ksm_unregister() for the mmc block device driver, perhaps we
should still do it to be consistent with blk_ksm_register()?

Then a final concern. It looks like the mmc core relies on checking
"host->caps2 & MMC_CAP2_CRYPTO", when it calls blk_ksm_register() and
blk_ksm_reprogram_all_keys(), for example. Normally, host->caps2 bits
are considered as static configurations and set during the host driver
probe path, which may not be a good match for this case. Instead, it
seems like we should set a new separate flag, to indicate for the mmc
core that blk_ksm_init has been enabled. Otherwise it looks like we
could end up calling blk_ksm_reprogram_all_keys(), even if
blk_ksm_init() hasn't been called.

Kind regards
Uffe
