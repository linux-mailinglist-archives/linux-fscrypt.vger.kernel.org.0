Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A4D2DD829
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 19:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgLQSUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 13:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbgLQSUu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 13:20:50 -0500
Date:   Thu, 17 Dec 2020 10:20:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608229209;
        bh=9cPO9+D2N3FGyZSbf5zsTU2pLaw+QPvmEFMIrPhPLC4=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=QehPFQI+9OmEvBAkIA027Y/qhvWQjTeG5EszoFvJyZ5JgxQmj5rQ4Xxfq4u9due25
         YQK8KprZq8+bysB5az6ho39O8YDoV7ynTI6juX36p0kqEdBwefhaSEfb8kiDpOIUTt
         trd6J1zkzeRQNUWalE7EVzFM4Z8ycdZVjiNuolh+bo7JKLup3ZbKZtKhIZw4BQ5d/w
         GKiOgyZ4BoCof+aVIUS6u15KfrqSPVX42Gh3tnqvuUpZtcaOAEuorOSix3VWUIPwmY
         SIm+gjs8YGf6okydwUE1TpwEkpgXPAIdvvTRLbwFpqc7C+95jXtkbWIhF1fqgliiJE
         PMYSt6k7blyKQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Peng.Zhou" <peng.zhou@mediatek.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        kuohong.wang@mediatek.com, gray.jia@mediatek.com,
        StanleyChu <stanley.chu@mediatek.com>
Subject: Re: [PATCH 0/8] eMMC inline encryption support
Message-ID: <X9uhVj080rvyhAVl@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
 <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
 <X7gcsC6IS80sUy4K@sol.localdomain>
 <9010afea-1075-8f72-99c7-c471840685db@intel.com>
 <X7xpbJf4gDcFdEc/@sol.localdomain>
 <1606294991.31568.5.camel@mtkswgap22>
 <1608196892.11508.0.camel@mbjsdccf07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608196892.11508.0.camel@mbjsdccf07>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 05:21:32PM +0800, Peng.Zhou wrote:
> 
> On Wed, 2020-11-25 at 17:03 +0800, Stanley Chu wrote:
> > Hi Eric,
> > 
> > On Mon, 2020-11-23 at 18:01 -0800, Eric Biggers wrote:
> > > Hi Adrian,
> > > 
> > > On Mon, Nov 23, 2020 at 09:04:12AM +0200, Adrian Hunter wrote:
> > > > On 20/11/20 9:44 pm, Eric Biggers wrote:
> > > > > Hi Adrian,
> > > > > 
> > > > > On Fri, Nov 20, 2020 at 09:29:59PM +0200, Adrian Hunter wrote:
> > > > >> I haven't had a chance to look at it properly, but I do have a couple of
> > > > >> dumb questions.  How do you ensure the host controller is not runtime
> > > > >> suspended when the key is programmed?
> > > > > 
> > > > > This is handled by the block layer, in block/keyslot-manager.c.  It ensures that
> > > > > the device is resumed before calling blk_ksm_ll_ops::keyslot_program() or
> > > > > blk_ksm_ll_ops::keyslot_evict().  See blk_ksm_hw_enter().
> > > > 
> > > > Cool, although cqhci is doing a lazy kind of resume, so maybe not be enabled
> > > > when a key is programmed?  Would that be a problem?
> > > > 
> > > > > 
> > > > >> Are the keys lost when the host controller is reset, and then how do you know
> > > > >> the host controller does not get reset after the key is programmed but before
> > > > >> the I/O is submitted?
> > > > > 
> > > > > As with UFS, keys might be lost when the host controller is reset, so we're
> > > > > reprogramming all the keys when that happens.  See patch 1:
> > > > > 
> > > > >     mmc_set_initial_state()
> > > > >         mmc_crypto_set_initial_state()
> > > > >             blk_ksm_reprogram_all_keys()
> > > > > 
> > > > > (That's the intent, at least.  For MMC, I'm not sure if resets were properly
> > > > > covered by the testing I've done so far.  But the code looks right to me.)
> > > > 
> > > > After reset, cqhci will not necessarily be enabled at this point.  Is that OK?
> > > 
> > > The hardware that I have (sdm630) appears to allow programming and evicting keys
> > > even while CQHCI_CFG.CQHCI_ENABLE is clear, i.e. even when the CQE is "off".
> > > I tested it using the patch below.
> > > 
> > > The eMMC specification isn't clear about this point.  But I'm thinking that the
> > > crypto configuration registers (the keyslots) are probably supposed to work like
> > > most of the other CQHCI registers, which can be written to while CQHCI_ENABLE is
> > > clear.  Then setting CQHCI_ENABLE just enables the ability to actually issue
> > > requests.  Likewise, setting CQHCI_CRYPTO_GENERAL_ENABLE just allows using
> > > crypto in requests; it isn't needed to write to the crypto configurations.
> > > 
> > > For what it's worth, UFS crypto (which has been supported by upstream since
> > > v5.9) works similarly.  Keys can be programmed while the UFS host is powered on,
> > > even before it's "enabled".
> > > 
> > > But maybe someone interpreted the eMMC specification differently.  Hopefully
> > > Mediatek can give some insight into how they implemented it, and test this
> > > patchset on their hardware too.
> > 
> > MediaTek CQHCI also works in this way.
> > 
> > Complete test is on-going now and we will update the results as soon as
> > possible.
> > 
> > Thanks,
> > Stanley Chu
> > 
> > > 
> > > Here's the patch I used to verify that sdm630 allows programming and evicting
> > > keys even while the CQE is off:
> > > 
> > > diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> > > index eaf2f1074326..eb2d88d0b3ba 100644
> > > --- a/drivers/mmc/core/block.c
> > > +++ b/drivers/mmc/core/block.c
> > > @@ -1406,6 +1406,9 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
> > >  
> > >  	mmc_cqe_check_busy(mq);
> > >  
> > > +	if (mmc_tot_in_flight(mq) == 0 && host->cqe_on)
> > > +		host->cqe_ops->cqe_off(host);
> > > +
> > >  	spin_unlock_irqrestore(&mq->lock, flags);
> > >  
> > >  	if (!mq->cqe_busy)
> > > diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> > > index 6ce21414d510..70d8dbc6515f 100644
> > > --- a/drivers/mmc/host/sdhci-msm.c
> > > +++ b/drivers/mmc/host/sdhci-msm.c
> > > @@ -1971,6 +1971,12 @@ static int sdhci_msm_program_key(struct cqhci_host *cq_host,
> > >  	int i;
> > >  	int err;
> > >  
> > > +	if (!cq_host->mmc->cqe_on) {
> > > +		pr_info("@@@ cqe is off for %s slot %d\n",
> > > +			(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE) ?
> > > +			"program" : "evict", slot);
> > > +	}
> > > +
> > >  	if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
> > >  		return qcom_scm_ice_invalidate_key(slot);
> > 
> > 
> 
> Hi Eric,
> 
> I also have a question about reprogramming keys scenarios, if some SoC
> vensors' eMMC host will power down or something else like that keys will
> be lost after runtime suspend, that means we must do reprogramming keys
> in runtime resume, right? Do you think that we should add it in
> cqhci-core layer(such as __cqhci_enable()) or every SoC vendor's host
> driver resume path?
> 

The keys should only be lost on reset, not on runtime suspend.  So I believe the
code I've proposed is sufficient.

- Eric
