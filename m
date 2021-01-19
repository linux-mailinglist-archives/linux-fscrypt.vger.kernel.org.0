Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CBE2FC1A2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jan 2021 21:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387750AbhASUwx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jan 2021 15:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730250AbhASUwm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jan 2021 15:52:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44D72206EC;
        Tue, 19 Jan 2021 20:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611089520;
        bh=djekidYjWvjMH8tnXNd3fJu3gvlpUyA2n41tvRbo6M0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jO3hOngn1UoYu0GIbbF4eh/bIy/NyhHX5dJ/WxEQAxsGr6/h/wYLkMGDTywBo53lD
         V8pDMwPa4NLzx1LwlcDQ8vPPzjwUzGW8AXpLyQR/8Gnyr/hz1HTOSxoy4yO/MYAfwm
         JXYRKtGFgkVkU8oq0LE1qIxFg2n4pNqaY8OmDLw4Rb5SfxB8C4nOzWeKlIM7g3ZX21
         tM0wPucHX6GMWHXBztxBD1FN3L9XTLuR8P+m8OAMRb4I4lft3gEPB0DXr5uAAJRB78
         nU0QT/N5ofF+ri7rMQ1IOCBKW/fp2fzsR/JCMD1buNHHq/FBIB1HOFKVAaJVFKKmev
         LllxjvlKAYacw==
Date:   Tue, 19 Jan 2021 12:51:58 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
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
Subject: Re: [PATCH v4 1/9] mmc: add basic support for inline encryption
Message-ID: <YAdGbqU12cbJr78K@sol.localdomain>
References: <20210104184542.4616-1-ebiggers@kernel.org>
 <20210104184542.4616-2-ebiggers@kernel.org>
 <CAPDyKFq717teu2HPZLCn9QVxLOwZHdi_iS+Ji69S0kYX1o52PQ@mail.gmail.com>
 <YAHXPREJaKjK/z7+@sol.localdomain>
 <CAPDyKFopKy6dwENJ6YQQ0KRPQdT25R_zmhrNH7jyu=+p6bKpNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFopKy6dwENJ6YQQ0KRPQdT25R_zmhrNH7jyu=+p6bKpNA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 18, 2021 at 03:21:01PM +0100, Ulf Hansson wrote:
> > > Eric, again, my apologies for the delay. Overall, I think this looks good.
> > >
> > > My only hesitation to merge this as is, is that I want to make sure
> > > you have thought of the life cycle issues for the struct
> > > blk_keyslot_manager ksm. It's being used both from the mmc core/block
> > > device driver and the mmc host driver. I am looking at this right now
> > > and will get back to you very soon, if I find some issues with it.
> > >
> > > If you have some time, feel free to elaborate around how this is
> > > intended to work.
> > >
> > > Kind regards
> > > Uffe
> >
> > The blk_keyslot_manager is initialized early on when the other host structures
> > (struct mmc_host, struct cqhci_host, struct sdhci_host, struct sdhci_msm_host)
> > are initialized, prior to mmc_add_host().
> >
> > It is destroyed when the struct mmc_host is freed by mmc_free_host().
> >
> > So it should just work; it's the same lifecycle as the existing host structures.
> > Is there something you think I'm overlooking?
> 
> I think so, but let me elaborate a bit.
> 
> As I understand it, to initialize the data structures, blk_ksm_init()
> is getting called and via cqhci_init().
> 
> To hook up the block request queue, blk_ksm_register() is called via
> mmc_setup_queue(), which means this happens when the mmc block device
> driver is probed.

Well, the call to blk_ksm_register() happens in mmc_crypto_setup_queue(), when
allocating the request_queue for a particular mmc_card.  As far as I can tell,
the mmc_host has already been initialized and added then, so we don't have to
worry about cases where the mmc_host has only been partially initialized.
And in particular, MMC_CAP2_CRYPTO will have its final value.

> 
> To free up the data structures, blk_ksm_destroy() is called from
> mmc_free_host().
> 
> To me, this can be made more consistent. For example, it looks like
> blk_ksm_destroy() could be called, even if blk_ksm_init() hasn't been
> called (depending on the probe error path of the mmc host).

blk_ksm_destroy() is a no-op on an all-zeroed struct, so it's fine to call it
unnecessarily.  We could call it unconditionally, if that would be clearer.

> There are a couple of options to better deal with this.
> 1) Extend the blk_ksm interface with a devm_blk_ksm_init() function
> (thus let it deal with lifecycle problems for us) and simply drop the
> call to blk_ksm_destroy().

This would require adding APIs to devm to support zeroing buffers on free and to
use kvmalloc() instead of kmalloc().  It looks like these new APIs wouldn't be
useful for many drivers (since almost everyone else just wants regular kmalloc
with no special behavior on free), so they don't seem worth adding yet.

> 2) Extend the cqhci interface with a cleanup function (perhaps
> "cqhci_deinit") and let it call blk_ksm_destroy().

The blk_keyslot_manager is part of struct mmc_host, so it makes more sense for
mmc_core to be responsible for freeing it.

We could move it to cqhci_host, but that would require adding multiple new
function pointers to mmc_cqe_ops for use by mmc_crypto_set_initial_state(),
mmc_crypto_free_host(), and mmc_crypto_setup_queue(), as these all currently
need access to the blk_keyslot_manager.

I think that making mmc_core directly aware of the blk_keyslot_manager is the
right call, as it avoids excessive callbacks, and it avoids tying the inline
encryption support too closely to CQHCI.  (Keep in mind that in the future, MMC
hosts could support inline encryption using other interfaces besides CQHCI.)

> 3) Convert to let blk_ksm_init() to be called from mmc_add_host() and
> blk_ksm_destroy() from mmc_remove_host().

That won't work because the driver has to fill in the crypto capabilities in the
blk_keyslot_manager after calling blk_ksm_init().  mmc_add_host() is too late to
do that.  mmc_add_host() happens after the driver has already initialized the
host structures and is finally registering them with the driver model.

> 
> Moreover, even if there seems to be no real need to call
> blk_ksm_unregister() for the mmc block device driver, perhaps we
> should still do it to be consistent with blk_ksm_register()?

blk_ksm_unregister() isn't exported to modules.  Its only purpose is for the
block layer to disable inline encryption support on a disk if blk-integrity
support is registered on the same disk.  So it shouldn't (and can't) be called
by drivers.

We probably should just remove blk_ksm_unregister() and make
blk_integrity_register() set the ->ksm pointer to NULL directly.  Also maybe
blk_ksm_register() should be renamed to something like
"queue_set_keyslot_manager()" to avoid implying that "unregister" is needed.

However those would be block layer changes, not related to this patchset.

> 
> Then a final concern. It looks like the mmc core relies on checking
> "host->caps2 & MMC_CAP2_CRYPTO", when it calls blk_ksm_register() and
> blk_ksm_reprogram_all_keys(), for example. Normally, host->caps2 bits
> are considered as static configurations and set during the host driver
> probe path, which may not be a good match for this case. Instead, it
> seems like we should set a new separate flag, to indicate for the mmc
> core that blk_ksm_init has been enabled. Otherwise it looks like we
> could end up calling blk_ksm_reprogram_all_keys(), even if
> blk_ksm_init() hasn't been called.

MMC_CAP2_CRYPTO *is* a static configuration that is set during the host driver
probe path.  So I don't understand your concern here.

It's true that during the host driver probe path, MMC_CAP2_CRYPTO initially
means "the hardware might support crypto", and then cqhci_crypto_init() clears
it if it decides that the hardware doesn't support crypto after all, after which
the bit really does mean "the hardware supports crypto".

That seems fine because this all happens while the host structures are being
initialized, before they are registered with the driver model and MMC cards are
detected.  So AFAICS there can't be any concurrent calls to
mmc_crypto_set_initial_state() or mmc_crypto_setup_queue().  Do you think
otherwise?

- Eric
