Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5127521F7C7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 18:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgGNQ75 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 12:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgGNQ75 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 12:59:57 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F6F22573;
        Tue, 14 Jul 2020 16:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594745996;
        bh=hfGULgx6cVGhSXYUjwr08O37iYZjxDOqExPxcVgLX20=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IVz7G9dnWJcklodZApZc+PE5LAOinEhXCAeRs+OuKyMHKcXp6G+gxfBhVLZoEU2sY
         4CU08uJ83+WTma1I/1NOONviXlQFiTvrHqLn9vSGpSzTZj11cVLhZnIcs3jOn6wIqr
         hF+k1mUe7Aq7JpFhneCOfHaWFIQbMw3vp6ahg/00=
Received: by mail-oi1-f180.google.com with SMTP id y22so14447106oie.8;
        Tue, 14 Jul 2020 09:59:56 -0700 (PDT)
X-Gm-Message-State: AOAM530BGP4k/iCXXCGa4o2lgFjlj1PoYolIHYUoN+8A2fnuqSqow4wm
        XY8XrycO8XRQfnisL4Z2k7zQKU3JVF0JWb57Xw==
X-Google-Smtp-Source: ABdhPJwv5DtvHNqkpG1lMxmy6zg7lYTz/pvjdCAG8t+hqEI7IbsYj4R6P0ANEAPuU+Zw88Djpz3Btrixh7w8DMOHHd8=
X-Received: by 2002:aca:bb82:: with SMTP id l124mr4592017oif.106.1594745995936;
 Tue, 14 Jul 2020 09:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200710072013.177481-1-ebiggers@kernel.org> <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com> <20200714161516.GA1064009@gmail.com>
 <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com> <20200714164353.GB1064009@gmail.com>
In-Reply-To: <20200714164353.GB1064009@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 14 Jul 2020 10:59:44 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
Message-ID: <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
To:     Eric Biggers <ebiggers@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 14, 2020 at 10:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> > On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > > >
> > > > Eric,
> > > >
> > > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > > >
> > > > I would like to see an Acked-by for this patch before I merge it.
> > > >
> > >
> > > Andy, Bjorn, or Rob: can you give Acked-by?
> >
> > DTS changes should go in via the QCom tree.
> >
>
> So, the DTS patch can't be applied without the driver patches since then the
> driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.

That sounds broken, but there's no context here for me to comment
further. DTS changes should work with old/stable kernels. I'd suggest
you get a review from Bjorn on the driver first.

Rob
