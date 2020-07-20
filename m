Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C003B226CD9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jul 2020 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgGTRHR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jul 2020 13:07:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgGTRHQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jul 2020 13:07:16 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 305C2207DF;
        Mon, 20 Jul 2020 17:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595264835;
        bh=B5ArgmwyVC+EJANIQwZaJ8ZAOjT0Xwve9/XQnU5HYQc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QpQNGYKsi4lyU8zzMxaKgrZhfKSd0hpN1Ip06Kl2//oQaw4BJDTRfv4q5e/pZyHdA
         KJA+MEqlFwKiQZxFFKjjDeXmwdbe8c27wakrmL057BOIR6fT53hKvMtN1DpgIzFJkV
         n+7D1sqmUjuU0Ya+zJR+0Tjl+K20ZD0Ertw6FAPg=
Date:   Mon, 20 Jul 2020 10:07:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
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
Message-ID: <20200720170713.GD1292162@gmail.com>
References: <20200714161516.GA1064009@gmail.com>
 <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
 <20200714164353.GB1064009@gmail.com>
 <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
 <20200714171203.GC1064009@gmail.com>
 <20200714173111.GG388985@builder.lan>
 <20200714174345.GE1218486@builder.lan>
 <20200714175718.GD1064009@gmail.com>
 <20200714200027.GH388985@builder.lan>
 <20200715030004.GB38091@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715030004.GB38091@sol.localdomain>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 14, 2020 at 08:00:04PM -0700, Eric Biggers wrote:
> On Tue, Jul 14, 2020 at 01:00:27PM -0700, Bjorn Andersson wrote:
> > On Tue 14 Jul 10:57 PDT 2020, Eric Biggers wrote:
> > 
> > > On Tue, Jul 14, 2020 at 10:43:45AM -0700, Bjorn Andersson wrote:
> > > > On Tue 14 Jul 10:31 PDT 2020, Bjorn Andersson wrote:
> > > > 
> > > > > On Tue 14 Jul 10:12 PDT 2020, Eric Biggers wrote:
> > > > > 
> > > > > > On Tue, Jul 14, 2020 at 10:59:44AM -0600, Rob Herring wrote:
> > > > > > > On Tue, Jul 14, 2020 at 10:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> > > > > > > > > On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > > > > > >
> > > > > > > > > > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > > > > > > > > > >
> > > > > > > > > > > Eric,
> > > > > > > > > > >
> > > > > > > > > > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > > > > > > > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > > > > > > > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > > > > > > > > > >
> > > > > > > > > > > I would like to see an Acked-by for this patch before I merge it.
> > > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > Andy, Bjorn, or Rob: can you give Acked-by?
> > > > > > > > >
> > > > > > > > > DTS changes should go in via the QCom tree.
> > > > > > > > >
> > > > > > > >
> > > > > > > > So, the DTS patch can't be applied without the driver patches since then the
> > > > > > > > driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.
> > > > > > > 
> > > > > > > That sounds broken, but there's no context here for me to comment
> > > > > > > further. DTS changes should work with old/stable kernels. I'd suggest
> > > > > > > you get a review from Bjorn on the driver first.
> > > > > > > 
> > > > > > 
> > > > > > The "breaking" change is that the dev_ref_clk_ctrl registers are now identified
> > > > > > by name instead of assumed to be index 1.
> > > > > > 
> > > > > > A reviewer had complained about the device-mapper bindings of this driver before
> > > > > > (https://lkml.kernel.org/r/158334171487.7173.5606223900174949177@swboyd.mtv.corp.google.com).
> > > > > > Changing to identifying the registers by name seemed like an improvement.
> > > > > > 
> > > > > > If needed I can add a hole at index 1 to make the DTS changes work with
> > > > > > old/stable kernels too, but I didn't know that is a requirement.  (Normally for
> > > > > > Linux kernel development, kernel-internal refactoring is always allowed
> > > > > > upstream.)  If I do this, would this hack have to be carried forever, or would
> > > > > > we be able to fix it up eventually?  Is there any deprecation period for DTS, or
> > > > > > do the latest DTS have to work with a 20 year old kernel?
> > > > > > 
> > > > > 
> > > > > The problem here is that DT binding refactoring is not kernel-internal.
> > > > > It's two different projects living in the same git.
> > > > > 
> > > > > There's a wish from various people that we make sure that new DTS
> > > > > continues to work with existing kernels. This is a nice in theory
> > > > > there's a lot of examples where we simply couldn't anticipate how future
> > > > > bindings would look. A particular example is that this prohibits most
> > > > > advancement in power management.
> > > > > 
> > > > > 
> > > > > But afaict what you describe above would make a new kernel failing to
> > > > > operate with the old DTS and that we have agreed to avoid.
> > > > > So I think the appropriate way to deal with this is to request the reg
> > > > > byname to detect the new binding and if that fails then assume that
> > > > > index 1 is dev_ref_clk_ctrl.
> > > > > 
> > > > 
> > > > I took another look at the git history and I can't find a single dts -
> > > > either upstream or in any downstream tree - that specifies that second
> > > > reg.
> > > > 
> > > > So per my argument below, if you could include a patch that just removes
> > > > the "dev_ref_clk_ctrl_mem" reference from the binding and driver I would
> > > > be happy to r-b that and ack this patch.
> > > > 
> > > > Regards,
> > > > Bjorn
> > > > 
> > > > > 
> > > > > There are cases where we just decide not to be backwards compatible, but
> > > > > it's pretty rare. As for deprecation, I think 1-2 LTS releases is
> > > > > sufficient, at that time scale it doesn't make sense to sit with an old
> > > > > DTB anyways (given the current pace of advancements in the kernel).
> > > > > 
> > > 
> > > Great, I'll remove the driver support for "dev_ref_clk_ctrl" then.  However,
> > > that doesn't solve the problem of the new DTS breaking old drivers, since old
> > > drivers assume that reg[1] is dev_ref_clk_ctrl.
> > > 
> > > This patch makes the DTS look like:
> > > 
> > > 	reg = <0 0x01d84000 0 0x2500>,
> > > 	      <0 0x01d90000 0 0x8000>;
> > > 	reg-names = "std", "ice";
> > > 
> > > The "ice" registers are new and are accessed by name instead of by index.
> > > 
> > > But these also happen to be in reg[1].  Old drivers will see that reg[1] is
> > > present and assume it is dev_ref_clk_ctrl.
> > > 
> > > To work around this, I could leave a blank reg[1] entry:
> > > 
> > > 	reg = <0 0x01d84000 0 0x2500>,
> > > 	      <0 0 0 0>,
> > > 	      <0 0x01d90000 0 0x8000>;
> > > 	reg-names = "std", "dev_ref_clk_ctrl", "ice";
> > > 
> > > Do I need to do that?
> > > 
> > 
> > No, let's not complicate it without good reason. SDM845 has hw_ver.major
> > == 3, so we're not taking the else-path in ufs_qcom_init(). So I should
> > be able to just merge this patch for 5.9 through the qcom tree after
> > all (your code handles that it's not there and the existing code doesn't
> > care).
> > 
> > 
> > The two platforms that I can find that has UFS controller of
> > hw_ver.major == 1 is APQ8084 and MSM8994, so I simply didn't look at an
> > old enough downstream tree (msm-3.10) to find anyone specifying reg[1].
> > The reg specified is however coming from the TLMM (pinctrl-msm) hardware
> > block, so it should not be directly remapped in the UFS driver...
> > 
> > But regardless, that has not been seen in an upstream dts and per your
> > patch 2 we would add that reg by name when that happens.
> > There's recent activity on upstreaming more of the MSM8994 support, so
> > perhaps then it's best to leave this snippet in the driver for now.
> > 
> > 
> > Summary: Martin merges (merged?) patch 1, 2, 4 and 5 in the scsi tree,
> > I'll merge this patch as is in the qcom tree and we'll just leave the
> > dev_ref_clk handling as is for now then.
> > 
> 
> Okay, great.  So an old DTS with the new driver isn't a problem because no DTS
> has ever declared dev_ref_clk_ctrl.  And a new DTS with an old driver is a less
> important case, and also not really a problem here since breakage would only
> occur if we added the ICE registers to an older SoC that has hw_ver.major == 1.
> 
> Maybe you'd like to provide your Acked-by on patches 2 and 5?
> 
> My instinct is always to remove code that has never been used.  But sure, if you
> think the dev_ref_clk_ctrl code might be used soon, we can keep it for now.
> 

Ping?
