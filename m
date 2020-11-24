Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A672C1B26
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Nov 2020 03:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgKXCBW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Nov 2020 21:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgKXCBV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Nov 2020 21:01:21 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248AE206B2;
        Tue, 24 Nov 2020 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606183280;
        bh=rvk4UvQelAz3FI2aatvLeb1xe7xw9k3Zha3PLJY/zXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aAU5awcoER7aVRCunR3lsNV1wyQ8Ekd1IF7YJK5aQAUcHYR/RT9PNUTiTkH277EtL
         v5mKcf6NkcLgijRlgxzuBW6AfE85Eq9WEKiJy4nRSCKJeAAQKJu58gODS22hbNFhdX
         KQbe0fWsyC5mXgIPJ2Nh966zbr3s7XBVraNEIAjU=
Date:   Mon, 23 Nov 2020 18:01:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH 0/8] eMMC inline encryption support
Message-ID: <X7xpbJf4gDcFdEc/@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
 <ea904bcc-3f01-d968-2a16-f9ff9f012968@intel.com>
 <X7gcsC6IS80sUy4K@sol.localdomain>
 <9010afea-1075-8f72-99c7-c471840685db@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9010afea-1075-8f72-99c7-c471840685db@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Adrian,

On Mon, Nov 23, 2020 at 09:04:12AM +0200, Adrian Hunter wrote:
> On 20/11/20 9:44 pm, Eric Biggers wrote:
> > Hi Adrian,
> > 
> > On Fri, Nov 20, 2020 at 09:29:59PM +0200, Adrian Hunter wrote:
> >> I haven't had a chance to look at it properly, but I do have a couple of
> >> dumb questions.  How do you ensure the host controller is not runtime
> >> suspended when the key is programmed?
> > 
> > This is handled by the block layer, in block/keyslot-manager.c.  It ensures that
> > the device is resumed before calling blk_ksm_ll_ops::keyslot_program() or
> > blk_ksm_ll_ops::keyslot_evict().  See blk_ksm_hw_enter().
> 
> Cool, although cqhci is doing a lazy kind of resume, so maybe not be enabled
> when a key is programmed?  Would that be a problem?
> 
> > 
> >> Are the keys lost when the host controller is reset, and then how do you know
> >> the host controller does not get reset after the key is programmed but before
> >> the I/O is submitted?
> > 
> > As with UFS, keys might be lost when the host controller is reset, so we're
> > reprogramming all the keys when that happens.  See patch 1:
> > 
> >     mmc_set_initial_state()
> >         mmc_crypto_set_initial_state()
> >             blk_ksm_reprogram_all_keys()
> > 
> > (That's the intent, at least.  For MMC, I'm not sure if resets were properly
> > covered by the testing I've done so far.  But the code looks right to me.)
> 
> After reset, cqhci will not necessarily be enabled at this point.  Is that OK?

The hardware that I have (sdm630) appears to allow programming and evicting keys
even while CQHCI_CFG.CQHCI_ENABLE is clear, i.e. even when the CQE is "off".
I tested it using the patch below.

The eMMC specification isn't clear about this point.  But I'm thinking that the
crypto configuration registers (the keyslots) are probably supposed to work like
most of the other CQHCI registers, which can be written to while CQHCI_ENABLE is
clear.  Then setting CQHCI_ENABLE just enables the ability to actually issue
requests.  Likewise, setting CQHCI_CRYPTO_GENERAL_ENABLE just allows using
crypto in requests; it isn't needed to write to the crypto configurations.

For what it's worth, UFS crypto (which has been supported by upstream since
v5.9) works similarly.  Keys can be programmed while the UFS host is powered on,
even before it's "enabled".

But maybe someone interpreted the eMMC specification differently.  Hopefully
Mediatek can give some insight into how they implemented it, and test this
patchset on their hardware too.

Here's the patch I used to verify that sdm630 allows programming and evicting
keys even while the CQE is off:

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index eaf2f1074326..eb2d88d0b3ba 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1406,6 +1406,9 @@ static void mmc_blk_cqe_complete_rq(struct mmc_queue *mq, struct request *req)
 
 	mmc_cqe_check_busy(mq);
 
+	if (mmc_tot_in_flight(mq) == 0 && host->cqe_on)
+		host->cqe_ops->cqe_off(host);
+
 	spin_unlock_irqrestore(&mq->lock, flags);
 
 	if (!mq->cqe_busy)
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 6ce21414d510..70d8dbc6515f 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1971,6 +1971,12 @@ static int sdhci_msm_program_key(struct cqhci_host *cq_host,
 	int i;
 	int err;
 
+	if (!cq_host->mmc->cqe_on) {
+		pr_info("@@@ cqe is off for %s slot %d\n",
+			(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE) ?
+			"program" : "evict", slot);
+	}
+
 	if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
 		return qcom_scm_ice_invalidate_key(slot);
