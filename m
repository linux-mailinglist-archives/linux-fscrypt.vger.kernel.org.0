Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE8228F93
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jul 2020 07:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGVFNj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jul 2020 01:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVFNi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jul 2020 01:13:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893EEC061794
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Jul 2020 22:13:38 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so373463plx.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 21 Jul 2020 22:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyW40mM/OT9V1AufihXDPSdCBk+PNGOJQ8TUvnygyu0=;
        b=UHPnx0lu8znCbPQmSzkqUCxC/yd3EXWaoOYQolSdvOgXpNBJA9xe23Smg2DUnBdVgT
         VTKDVJwC45NDMs5VvD36kvh4r1wYzREgmSRJXVsaqOsSRX9j9GBbtF3/Z9PJq/i0gGR0
         MASYeR/IWw06VwykSfxzn0XrcfFZHb5GvkGWQ+vIW7gdU87SG0o27DIL6A0ehAkIHdwA
         lePlJhGA7mIpQ5BKcBG8AZuYWM3H+gPypPKc3aTH1wR/S7WYHbR6SrOqrOJDsbhzEvOp
         lW684CrCVB6y89gZpMOZ+eSK34erJdROkOEwXqMZm/QIGGCF1RfW8Ovp+R2Hg/Neekv7
         UfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyW40mM/OT9V1AufihXDPSdCBk+PNGOJQ8TUvnygyu0=;
        b=g5hb4klJRvkedbBrE3t+GCwwalysefAseubpWVViszKn0wwFjZ7jr+2g14haXHuk5S
         I8pTOC1DNMflyw9LAG9XWOurUPumKs4BA5Y0lc/alPWn2ALNmDQ1XE8kAE8XnBpS+SyE
         b+RODO6y/YOKZ5L9xcXgKy1DRnRs3kWtCibTuJNO1MTicw19OZc1ScCMdXFJTBtksH6N
         z9EG2/EdcvleIKkxcupYP7vNp+drtqBQgEvdzFb3t4+HycPNaP6MmpIXhTinc2RMLutr
         341nr/dNW8zxGZNN0+kZdsowNs+VbeOS9LJkJMNXv03+sNllnJS2STx/33tpBJadSqjs
         AOtg==
X-Gm-Message-State: AOAM5322hG6LiE2g5bwE2NZWD/RUBRfVxL0igUQy/kp6ZxV5aEKBfGmX
        iBut0zVgoF4vtOC5dp4jEFQoXA==
X-Google-Smtp-Source: ABdhPJwbs0iPpsLwvI243YAKaid8UfyWbgCAV+j9ANH3B1qSZEmXjfSTQtiRG29H/I3S9JzLBUNOkA==
X-Received: by 2002:a17:90a:89:: with SMTP id a9mr8566587pja.171.1595394817896;
        Tue, 21 Jul 2020 22:13:37 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id n2sm19627579pgv.37.2020.07.21.22.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 22:13:37 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:11:43 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andy Gross <agross@kernel.org>,
        SCSI <linux-scsi@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
Message-ID: <20200722051143.GU388985@builder.lan>
References: <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
 <20200714164353.GB1064009@gmail.com>
 <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
 <20200714171203.GC1064009@gmail.com>
 <20200714173111.GG388985@builder.lan>
 <20200714174345.GE1218486@builder.lan>
 <20200714175718.GD1064009@gmail.com>
 <20200714200027.GH388985@builder.lan>
 <20200715030004.GB38091@sol.localdomain>
 <20200720170713.GD1292162@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720170713.GD1292162@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon 20 Jul 10:07 PDT 2020, Eric Biggers wrote:

> On Tue, Jul 14, 2020 at 08:00:04PM -0700, Eric Biggers wrote:
> > On Tue, Jul 14, 2020 at 01:00:27PM -0700, Bjorn Andersson wrote:
> > > On Tue 14 Jul 10:57 PDT 2020, Eric Biggers wrote:
> > > 
> > > > On Tue, Jul 14, 2020 at 10:43:45AM -0700, Bjorn Andersson wrote:
> > > > > On Tue 14 Jul 10:31 PDT 2020, Bjorn Andersson wrote:
> > > > > 
> > > > > > On Tue 14 Jul 10:12 PDT 2020, Eric Biggers wrote:
> > > > > > 
> > > > > > > On Tue, Jul 14, 2020 at 10:59:44AM -0600, Rob Herring wrote:
> > > > > > > > On Tue, Jul 14, 2020 at 10:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> > > > > > > > > > On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > Eric,
> > > > > > > > > > > >
> > > > > > > > > > > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > > > > > > > > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > > > > > > > > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > > > > > > > > > > >
> > > > > > > > > > > > I would like to see an Acked-by for this patch before I merge it.
> > > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Andy, Bjorn, or Rob: can you give Acked-by?
> > > > > > > > > >
> > > > > > > > > > DTS changes should go in via the QCom tree.
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > So, the DTS patch can't be applied without the driver patches since then the
> > > > > > > > > driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.
> > > > > > > > 
> > > > > > > > That sounds broken, but there's no context here for me to comment
> > > > > > > > further. DTS changes should work with old/stable kernels. I'd suggest
> > > > > > > > you get a review from Bjorn on the driver first.
> > > > > > > > 
> > > > > > > 
> > > > > > > The "breaking" change is that the dev_ref_clk_ctrl registers are now identified
> > > > > > > by name instead of assumed to be index 1.
> > > > > > > 
> > > > > > > A reviewer had complained about the device-mapper bindings of this driver before
> > > > > > > (https://lkml.kernel.org/r/158334171487.7173.5606223900174949177@swboyd.mtv.corp.google.com).
> > > > > > > Changing to identifying the registers by name seemed like an improvement.
> > > > > > > 
> > > > > > > If needed I can add a hole at index 1 to make the DTS changes work with
> > > > > > > old/stable kernels too, but I didn't know that is a requirement.  (Normally for
> > > > > > > Linux kernel development, kernel-internal refactoring is always allowed
> > > > > > > upstream.)  If I do this, would this hack have to be carried forever, or would
> > > > > > > we be able to fix it up eventually?  Is there any deprecation period for DTS, or
> > > > > > > do the latest DTS have to work with a 20 year old kernel?
> > > > > > > 
> > > > > > 
> > > > > > The problem here is that DT binding refactoring is not kernel-internal.
> > > > > > It's two different projects living in the same git.
> > > > > > 
> > > > > > There's a wish from various people that we make sure that new DTS
> > > > > > continues to work with existing kernels. This is a nice in theory
> > > > > > there's a lot of examples where we simply couldn't anticipate how future
> > > > > > bindings would look. A particular example is that this prohibits most
> > > > > > advancement in power management.
> > > > > > 
> > > > > > 
> > > > > > But afaict what you describe above would make a new kernel failing to
> > > > > > operate with the old DTS and that we have agreed to avoid.
> > > > > > So I think the appropriate way to deal with this is to request the reg
> > > > > > byname to detect the new binding and if that fails then assume that
> > > > > > index 1 is dev_ref_clk_ctrl.
> > > > > > 
> > > > > 
> > > > > I took another look at the git history and I can't find a single dts -
> > > > > either upstream or in any downstream tree - that specifies that second
> > > > > reg.
> > > > > 
> > > > > So per my argument below, if you could include a patch that just removes
> > > > > the "dev_ref_clk_ctrl_mem" reference from the binding and driver I would
> > > > > be happy to r-b that and ack this patch.
> > > > > 
> > > > > Regards,
> > > > > Bjorn
> > > > > 
> > > > > > 
> > > > > > There are cases where we just decide not to be backwards compatible, but
> > > > > > it's pretty rare. As for deprecation, I think 1-2 LTS releases is
> > > > > > sufficient, at that time scale it doesn't make sense to sit with an old
> > > > > > DTB anyways (given the current pace of advancements in the kernel).
> > > > > > 
> > > > 
> > > > Great, I'll remove the driver support for "dev_ref_clk_ctrl" then.  However,
> > > > that doesn't solve the problem of the new DTS breaking old drivers, since old
> > > > drivers assume that reg[1] is dev_ref_clk_ctrl.
> > > > 
> > > > This patch makes the DTS look like:
> > > > 
> > > > 	reg = <0 0x01d84000 0 0x2500>,
> > > > 	      <0 0x01d90000 0 0x8000>;
> > > > 	reg-names = "std", "ice";
> > > > 
> > > > The "ice" registers are new and are accessed by name instead of by index.
> > > > 
> > > > But these also happen to be in reg[1].  Old drivers will see that reg[1] is
> > > > present and assume it is dev_ref_clk_ctrl.
> > > > 
> > > > To work around this, I could leave a blank reg[1] entry:
> > > > 
> > > > 	reg = <0 0x01d84000 0 0x2500>,
> > > > 	      <0 0 0 0>,
> > > > 	      <0 0x01d90000 0 0x8000>;
> > > > 	reg-names = "std", "dev_ref_clk_ctrl", "ice";
> > > > 
> > > > Do I need to do that?
> > > > 
> > > 
> > > No, let's not complicate it without good reason. SDM845 has hw_ver.major
> > > == 3, so we're not taking the else-path in ufs_qcom_init(). So I should
> > > be able to just merge this patch for 5.9 through the qcom tree after
> > > all (your code handles that it's not there and the existing code doesn't
> > > care).
> > > 
> > > 
> > > The two platforms that I can find that has UFS controller of
> > > hw_ver.major == 1 is APQ8084 and MSM8994, so I simply didn't look at an
> > > old enough downstream tree (msm-3.10) to find anyone specifying reg[1].
> > > The reg specified is however coming from the TLMM (pinctrl-msm) hardware
> > > block, so it should not be directly remapped in the UFS driver...
> > > 
> > > But regardless, that has not been seen in an upstream dts and per your
> > > patch 2 we would add that reg by name when that happens.
> > > There's recent activity on upstreaming more of the MSM8994 support, so
> > > perhaps then it's best to leave this snippet in the driver for now.
> > > 
> > > 
> > > Summary: Martin merges (merged?) patch 1, 2, 4 and 5 in the scsi tree,
> > > I'll merge this patch as is in the qcom tree and we'll just leave the
> > > dev_ref_clk handling as is for now then.
> > > 
> > 
> > Okay, great.  So an old DTS with the new driver isn't a problem because no DTS
> > has ever declared dev_ref_clk_ctrl.  And a new DTS with an old driver is a less
> > important case, and also not really a problem here since breakage would only
> > occur if we added the ICE registers to an older SoC that has hw_ver.major == 1.
> > 
> > Maybe you'd like to provide your Acked-by on patches 2 and 5?
> > 
> > My instinct is always to remove code that has never been used.  But sure, if you
> > think the dev_ref_clk_ctrl code might be used soon, we can keep it for now.
> > 
> 
> Ping?

Sorry, I thought Martin already did pick up the SCSI patches. I've acked
the two patches now.

Let's see what happens on MSM8994 to see if we should alter or remove
the external ref_clk handling.

Regards,
Bjorn
