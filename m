Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE521F78F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 18:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgGNQn4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 12:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgGNQn4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 12:43:56 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A9A320656;
        Tue, 14 Jul 2020 16:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594745035;
        bh=9a0UPMyrJwVE0Mrum4wjTM5UXin960Ej97wbJcnVIIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c8pp9OugeL6aeI/lBs5w61JW7d6mrlOAJDx5jmYbruotQx3vYX4AipJR/7mRD//8b
         ZINWHEeR7z++IB9IujXfYt3+0Sc3L8ZLofHdOoUMgkn+D9ANzCnrxy4i0VqXDTE4PK
         4xCi1ZVtEve3bNAJq7loVowoDWaEOtZHUZU0IX5s=
Date:   Tue, 14 Jul 2020 09:43:53 -0700
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
Message-ID: <20200714164353.GB1064009@gmail.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
 <20200714161516.GA1064009@gmail.com>
 <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > >
> > > Eric,
> > >
> > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > >
> > > I would like to see an Acked-by for this patch before I merge it.
> > >
> >
> > Andy, Bjorn, or Rob: can you give Acked-by?
> 
> DTS changes should go in via the QCom tree.
> 

So, the DTS patch can't be applied without the driver patches since then the
driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.

But the driver patches can be applied without the DTS patch.

Martin: how about you take patches 1-2 and 4-5 through the scsi tree for 5.9,
and then we get the DTS patch taken through the QCOM tree for 5.10?

- Eric
