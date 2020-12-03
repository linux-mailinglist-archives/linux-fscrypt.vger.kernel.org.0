Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E7E2CCB87
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 02:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgLCBSL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 20:18:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727351AbgLCBSL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 20:18:11 -0500
Date:   Wed, 2 Dec 2020 17:17:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606958250;
        bh=T69XyqdOWUHSstTcJMG2jQvg/tn2n26dzZ7Wc4I/z8Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=cW1PJtvz1PRASeEWhUc0wyW2t6eO5QSOMdjXvSHstUH907uCJ0SiV+jdDfxOgeNty
         28b1QG6MKw8LG7VkwxXn7XA1NnZQMLXx1IgQuTb8MJzzt03cOdhAvF3RMeWjTLhjwz
         p8jquBCqFjjjiPUkN8qOYmM8u7pRw2XhZ5VULfR3erFFb3Cz60LT9DoqvdZtfLEVA/
         C4l2cE8KX1vJM/KRso+an9S+Ab/faaZyv59C6brYnLQofzhdt3Et8+39qzQca0JSDm
         bQoOtVVrcMRBtjU+O6HvMrUpTZi4mnxXQyufzmEGIoR65HdUYmwxSq+k5Ok/G/w72r
         T9yX3A/2b2cNg==
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
Subject: Re: [PATCH 3/8] mmc: cqhci: add support for inline encryption
Message-ID: <X8g8px5KaEyrbcmK@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <20201112194011.103774-4-ebiggers@kernel.org>
 <48269904-d031-c2fd-59c5-78f7948b032a@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48269904-d031-c2fd-59c5-78f7948b032a@intel.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 03:14:25PM +0200, Adrian Hunter wrote:
> >  static void cqhci_prep_task_desc(struct mmc_request *mrq,
> > -					u64 *data, bool intr)
> > +				 struct cqhci_host *cq_host, int tag)
> 
> It would be neater if the changes to cqhci_prep_task_desc() parameters could
> be a separate patch.
> 

I'll move it to a separate patch
"mmc: cqhci: initialize upper 64 bits of 128-bit task descriptors".

> > @@ -709,6 +724,27 @@ static void cqhci_error_irq(struct mmc_host *mmc, u32 status, int cmd_error,
> >  		}
> >  	}
> >  
> > +	/*
> > +	 * Handle "Invalid Crypto Configuration Error".  This should never
> > +	 * happen, since the block layer ensures that all crypto-enabled I/O
> > +	 * requests have a valid keyslot before they reach the driver.
> > +	 */
> > +	if (status & CQHCI_IS_ICCE) {
> > +		tdpe = cqhci_readl(cq_host, CQHCI_TDPE);
> > +		WARN_ONCE(1,
> > +			  "%s: cqhci: invalid crypto configuration error. IRQ status: 0x%08x TDPE: 0x%08x\n",
> > +			  mmc_hostname(mmc), status, tdpe);
> > +		while (tdpe != 0) {
> > +			tag = __ffs(tdpe);
> > +			tdpe &= ~(1 << tag);
> > +			slot = &cq_host->slot[tag];
> > +			if (!slot->mrq)
> > +				continue;
> > +			slot->flags = cqhci_error_flags(data_error, cmd_error);
> > +			cqhci_recovery_needed(mmc, slot->mrq, true);
> > +		}
> > +	}
> > +
> 
> What about GCE?

I don't think anything more is needed for GCE (General Crypto Error).  As per
the eMMC specification, GCE occurs during the execution of a task, and task
error information is stored in the TERRI register -- just like some of the
non-crypto related errors.  This patch already updates cqhci_irq() to call
cqhci_error_irq() if the GCE bit is set, and cqhci_error_irq() already handles
task errors by checking the TERRI register.  Also, cqhci_irq() already
acknowledges all interrupts, including GCE.

So I think GCE is handled correctly, though I don't currently have a way to
actually test it.

- Eric
