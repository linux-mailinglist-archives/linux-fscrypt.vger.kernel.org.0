Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17062FEB43
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 14:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbhAUNOW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 08:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731415AbhAUNKG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 08:10:06 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C25C061575
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 05:09:25 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id e15so1002594vsa.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 05:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gaXxUTVvevX2GJZfVR9eHzSRwPgexu+rkLnmYUsiQfs=;
        b=JBzjLkLcIBLh6GRlo8Fc8DJPvvz2K8sm6ag6QR582Vz0fnH42q0+qQhfjZcsBpvs86
         m6W0MmSnk33Mq7ifHTY2LtdlYUqBAJCCGsGegYFeo63RlPPmzBgAfmgmo/UEBisY+nIB
         6hXP3P4IJpLa7BS++6u3pw/3eozSlDMfz420BphIuzi7mMfQKQFx9XZIe/OUX2bZiSWL
         WXQ06tZ72pNZHfZsOxlXZsE+32p/o90JBdxUxmxB46DEGIttPYnq8DHU0cjwWaGWe8lC
         CU7Ol7rAfeq2Y2ZxD85aP3SBIJAYjpqPFQ1uNtWAKyD2CEjZK+MUB0BW5HqJkvk3UH9/
         mR2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gaXxUTVvevX2GJZfVR9eHzSRwPgexu+rkLnmYUsiQfs=;
        b=mYUfq+XIhHSRncQB41AUSaYsMnASyi2EORc7EFcruK1+cQRW3DtMoo2Ben+8LdxeuF
         1u19vKk4KacEbO9aSjsv34RKEgEviG/QqrGPrEcC8LSbp8pxmVtKTzcSE6XfcwDJc7th
         SbFzkd7BidCpDmTJsbcpim8rVWW6tWF7uk2zxWbeMagFu2UBz2TrONQP1PqsVDCob9L/
         MukiT+Ps0NdoRQSUSLdIPILLobKo65BQHUm1yhSvZjiSbiFlJFp/gC/mdOx2gpQScvYO
         GaMb89D8NbH32q26HPDfLwCkdC9dxR4gbu9RuUSoYUqjO0wTwJkvBd6EqccabxxdB+CA
         4CYw==
X-Gm-Message-State: AOAM530+cBSASGKjkpL+xhhwCy9x3BFb4QhOPjLN5l2pAMzABhGigHoX
        +0OZ1G6QVQGdUMjoAW3Ukk6zmmXl+zid7ilQsL37dg==
X-Google-Smtp-Source: ABdhPJxrlHFqkJYSdrouGyAIgqYI+w6Sirh81pDpcKIetl7JIBSn7kW8Kt1CL8abMF0a0/p/WX8DESVSojmGkxVprGU=
X-Received: by 2002:a67:f997:: with SMTP id b23mr9521509vsq.34.1611234564605;
 Thu, 21 Jan 2021 05:09:24 -0800 (PST)
MIME-Version: 1.0
References: <20210104184542.4616-1-ebiggers@kernel.org> <20210104184542.4616-2-ebiggers@kernel.org>
 <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com>
 <YAHXPREJaKjK/z7+@sol.localdomain> <CAPDyKFopKy6dwENJ6YQQ0KRPQdT25R_zmhrNH7jyu=+p6bKpNA@mail.gmail.com>
 <YAdGbqU12cbJr78K@sol.localdomain> <YAlG2j0RbKbcyzMD@sol.localdomain>
In-Reply-To: <YAlG2j0RbKbcyzMD@sol.localdomain>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 21 Jan 2021 14:08:48 +0100
Message-ID: <CAPDyKFpQG88TQF_2hAxMZd4MbgKeHCCxUO1hnvjh_3rG-wMVBQ@mail.gmail.com>
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

On Thu, 21 Jan 2021 at 10:18, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jan 19, 2021 at 12:51:58PM -0800, Eric Biggers wrote:
> > On Mon, Jan 18, 2021 at 03:21:01PM +0100, Ulf Hansson wrote:
> > > > > Eric, again, my apologies for the delay. Overall, I think this looks good.
> > > > >
> > > > > My only hesitation to merge this as is, is that I want to make sure
> > > > > you have thought of the life cycle issues for the struct
> > > > > blk_keyslot_manager ksm. It's being used both from the mmc core/block
> > > > > device driver and the mmc host driver. I am looking at this right now
> > > > > and will get back to you very soon, if I find some issues with it.
> > > > >
> > > > > If you have some time, feel free to elaborate around how this is
> > > > > intended to work.
> > > > >
> > > > > Kind regards
> > > > > Uffe
> > > >
> > > > The blk_keyslot_manager is initialized early on when the other host structures
> > > > (struct mmc_host, struct cqhci_host, struct sdhci_host, struct sdhci_msm_host)
> > > > are initialized, prior to mmc_add_host().
> > > >
> > > > It is destroyed when the struct mmc_host is freed by mmc_free_host().
> > > >
> > > > So it should just work; it's the same lifecycle as the existing host structures.
> > > > Is there something you think I'm overlooking?
> > >
> > > I think so, but let me elaborate a bit.
> > >
> > > As I understand it, to initialize the data structures, blk_ksm_init()
> > > is getting called and via cqhci_init().
> > >
> > > To hook up the block request queue, blk_ksm_register() is called via
> > > mmc_setup_queue(), which means this happens when the mmc block device
> > > driver is probed.
> >
> > Well, the call to blk_ksm_register() happens in mmc_crypto_setup_queue(), when
> > allocating the request_queue for a particular mmc_card.  As far as I can tell,
> > the mmc_host has already been initialized and added then, so we don't have to
> > worry about cases where the mmc_host has only been partially initialized.
> > And in particular, MMC_CAP2_CRYPTO will have its final value.
> >
> > >
> > > To free up the data structures, blk_ksm_destroy() is called from
> > > mmc_free_host().
> > >
> > > To me, this can be made more consistent. For example, it looks like
> > > blk_ksm_destroy() could be called, even if blk_ksm_init() hasn't been
> > > called (depending on the probe error path of the mmc host).
> >
> > blk_ksm_destroy() is a no-op on an all-zeroed struct, so it's fine to call it
> > unnecessarily.  We could call it unconditionally, if that would be clearer.
> >
> > > There are a couple of options to better deal with this.
> > > 1) Extend the blk_ksm interface with a devm_blk_ksm_init() function
> > > (thus let it deal with lifecycle problems for us) and simply drop the
> > > call to blk_ksm_destroy().
> >
> > This would require adding APIs to devm to support zeroing buffers on free and to
> > use kvmalloc() instead of kmalloc().  It looks like these new APIs wouldn't be
> > useful for many drivers (since almost everyone else just wants regular kmalloc
> > with no special behavior on free), so they don't seem worth adding yet.
> >
> > > 2) Extend the cqhci interface with a cleanup function (perhaps
> > > "cqhci_deinit") and let it call blk_ksm_destroy().
> >
> > The blk_keyslot_manager is part of struct mmc_host, so it makes more sense for
> > mmc_core to be responsible for freeing it.
> >
> > We could move it to cqhci_host, but that would require adding multiple new
> > function pointers to mmc_cqe_ops for use by mmc_crypto_set_initial_state(),
> > mmc_crypto_free_host(), and mmc_crypto_setup_queue(), as these all currently
> > need access to the blk_keyslot_manager.
> >
> > I think that making mmc_core directly aware of the blk_keyslot_manager is the
> > right call, as it avoids excessive callbacks, and it avoids tying the inline
> > encryption support too closely to CQHCI.  (Keep in mind that in the future, MMC
> > hosts could support inline encryption using other interfaces besides CQHCI.)
> >
> > > 3) Convert to let blk_ksm_init() to be called from mmc_add_host() and
> > > blk_ksm_destroy() from mmc_remove_host().
> >
> > That won't work because the driver has to fill in the crypto capabilities in the
> > blk_keyslot_manager after calling blk_ksm_init().  mmc_add_host() is too late to
> > do that.  mmc_add_host() happens after the driver has already initialized the
> > host structures and is finally registering them with the driver model.
> >
> > >
> > > Moreover, even if there seems to be no real need to call
> > > blk_ksm_unregister() for the mmc block device driver, perhaps we
> > > should still do it to be consistent with blk_ksm_register()?
> >
> > blk_ksm_unregister() isn't exported to modules.  Its only purpose is for the
> > block layer to disable inline encryption support on a disk if blk-integrity
> > support is registered on the same disk.  So it shouldn't (and can't) be called
> > by drivers.
> >
> > We probably should just remove blk_ksm_unregister() and make
> > blk_integrity_register() set the ->ksm pointer to NULL directly.  Also maybe
> > blk_ksm_register() should be renamed to something like
> > "queue_set_keyslot_manager()" to avoid implying that "unregister" is needed.
> >
> > However those would be block layer changes, not related to this patchset.
> >
> > >
> > > Then a final concern. It looks like the mmc core relies on checking
> > > "host->caps2 & MMC_CAP2_CRYPTO", when it calls blk_ksm_register() and
> > > blk_ksm_reprogram_all_keys(), for example. Normally, host->caps2 bits
> > > are considered as static configurations and set during the host driver
> > > probe path, which may not be a good match for this case. Instead, it
> > > seems like we should set a new separate flag, to indicate for the mmc
> > > core that blk_ksm_init has been enabled. Otherwise it looks like we
> > > could end up calling blk_ksm_reprogram_all_keys(), even if
> > > blk_ksm_init() hasn't been called.
> >
> > MMC_CAP2_CRYPTO *is* a static configuration that is set during the host driver
> > probe path.  So I don't understand your concern here.
> >
> > It's true that during the host driver probe path, MMC_CAP2_CRYPTO initially
> > means "the hardware might support crypto", and then cqhci_crypto_init() clears
> > it if it decides that the hardware doesn't support crypto after all, after which
> > the bit really does mean "the hardware supports crypto".
> >
> > That seems fine because this all happens while the host structures are being
> > initialized, before they are registered with the driver model and MMC cards are
> > detected.  So AFAICS there can't be any concurrent calls to
> > mmc_crypto_set_initial_state() or mmc_crypto_setup_queue().  Do you think
> > otherwise?
>
> I've sent out a new version of this patchset that uses the new function
> devm_blk_ksm_init() I've proposed, so that the blk_keyslot_manager no longer
> needs to be explicitly destroyed.
>
> Please let me know if you still have any other concerns.
>
> I think you may have been assuming that the blk_keyslot_manager doesn't get
> initialized until the CQE is enabled, and thus would have a separate lifetime
> from the other host structures?  That's not what happens; it just gets
> initialized on the driver probe path.  See e.g.:
>
>         sdhci_msm_probe()
>           => sdhci_msm_cqe_add_host()
>              => cqhci_init()
>                 => cqhci_crypto_init()
>                    => devm_blk_ksm_init()
>
> And we don't leave MMC_CAP2_CRYPTO set but the blk_keyslot_manager
> uninitialized, as that combination doesn't make sense.

I think we still can (but we shouldn't), but see my reply on the latest version.

Besides that minor thing, the latest version looks good to me. Thanks
for doing the conversion to devm_blk_ksm_init() - it certainly
simplifies the lifecycle issue for this case.

Kind regards
Uffe
