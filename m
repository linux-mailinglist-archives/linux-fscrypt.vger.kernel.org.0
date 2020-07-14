Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D5221F7EB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 19:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgGNRMH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 13:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgGNRMG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 13:12:06 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF7022574;
        Tue, 14 Jul 2020 17:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594746725;
        bh=Ss0W8KMmNbTjpQXnkbERKjIoYNpAGVedFfrvuIYkMCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDY2KmWuSJA8VbGBa0GBaLWfEHQMIk7DwMuzaI/5eY2QKy5HzTBVEj/gKrm+bHO9t
         ltEMDgMfR4O99UiB7ug86hsxdLl8oObgLVisu95h8h9BrpDSZ5UmSfzID08mg5FV+X
         eIkmHL0a1XOUPTnac4OgKujAZFPzHmSGYqL/PkhI=
Date:   Tue, 14 Jul 2020 10:12:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
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
Message-ID: <20200714171203.GC1064009@gmail.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
 <20200714161516.GA1064009@gmail.com>
 <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
 <20200714164353.GB1064009@gmail.com>
 <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 14, 2020 at 10:59:44AM -0600, Rob Herring wrote:
> On Tue, Jul 14, 2020 at 10:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> > > On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > > > >
> > > > > Eric,
> > > > >
> > > > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > > > >
> > > > > I would like to see an Acked-by for this patch before I merge it.
> > > > >
> > > >
> > > > Andy, Bjorn, or Rob: can you give Acked-by?
> > >
> > > DTS changes should go in via the QCom tree.
> > >
> >
> > So, the DTS patch can't be applied without the driver patches since then the
> > driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.
> 
> That sounds broken, but there's no context here for me to comment
> further. DTS changes should work with old/stable kernels. I'd suggest
> you get a review from Bjorn on the driver first.
> 

The "breaking" change is that the dev_ref_clk_ctrl registers are now identified
by name instead of assumed to be index 1.

A reviewer had complained about the device-mapper bindings of this driver before
(https://lkml.kernel.org/r/158334171487.7173.5606223900174949177@swboyd.mtv.corp.google.com).
Changing to identifying the registers by name seemed like an improvement.

If needed I can add a hole at index 1 to make the DTS changes work with
old/stable kernels too, but I didn't know that is a requirement.  (Normally for
Linux kernel development, kernel-internal refactoring is always allowed
upstream.)  If I do this, would this hack have to be carried forever, or would
we be able to fix it up eventually?  Is there any deprecation period for DTS, or
do the latest DTS have to work with a 20 year old kernel?

- Eric
