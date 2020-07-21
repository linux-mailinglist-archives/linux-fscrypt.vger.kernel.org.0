Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2D422881D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Jul 2020 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgGUSUo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Jul 2020 14:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUSUn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Jul 2020 14:20:43 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70947206C1;
        Tue, 21 Jul 2020 18:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595355642;
        bh=wGA+7C6ar5QUHd0QZw7ELHe+8sc5aAWQcey1cDxWIcg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2JMjTEVL1FsxQ+U8oSPaTFB2N9f0F3iGSp73gJpKCsxPw3zDwy/z4gZU4HcBl4gin
         pe4zubXjweUc2+z07dm/x17ExE5N6zai3rTVNKT35UPMbsQp/QHu2YBVy+CpuHTpvu
         80mfiPgkyzPKLEDDO5qSLCTL07P5Oc0Tu4L3NOfQ=
Date:   Tue, 21 Jul 2020 11:20:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
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
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
Message-ID: <20200721182041.GA39383@sol.localdomain>
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

On Mon, Jul 20, 2020 at 10:07:13AM -0700, Eric Biggers wrote:
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

Martin,

As per the above discussion, Bjorn has included this device tree patch
in his pull request for 5.9:
https://lore.kernel.org/linux-arm-msm/20200721044934.3430084-1-bjorn.andersson@linaro.org/

Could you apply patches 1-2 and 4-5 to the scsi tree now?

Thanks!

- Eric
