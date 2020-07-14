Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DABB21F851
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 19:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgGNRgb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 13:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgGNRgb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 13:36:31 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C6DF22519;
        Tue, 14 Jul 2020 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594748190;
        bh=nNcqUpzi94LM116BWU52pZn9hPQ9CNKuFPYI2/uycic=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=W/tKAhPkETMF2ADLxi23k1+Ew3m2mVI5YL7wkmIEnxpSFoAbxduLOHffNOpNOQp79
         y542vMn2QktXL/uP6bTzTnv9DrzzOuAwnQslvbKhzcHuxtYp+hMyJtwW4aHNfgc+FM
         MdzA6Mmzl3yfLHI9g6Wh6nqnQXGJfFrwZiB7LZl4=
Received: by mail-ot1-f52.google.com with SMTP id 5so13602693oty.11;
        Tue, 14 Jul 2020 10:36:30 -0700 (PDT)
X-Gm-Message-State: AOAM532N6siH6iSUCpbK7zg9oSG5S/ziUCuMGIfEux28fjqneExTc+Ak
        JygAvz5CctiTjHT5k6ZtRLv/NpAVGPECF3dUmw==
X-Google-Smtp-Source: ABdhPJzj0TshwAVkfvhUGCqxwsS+bux7PibltkQtZCZRLT5+8mxVMb2aX2E0nP0K7FYQIH5cfAp8qMEWnlgCOZCTs8g=
X-Received: by 2002:a05:6830:3104:: with SMTP id b4mr5184342ots.192.1594748189603;
 Tue, 14 Jul 2020 10:36:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200710072013.177481-1-ebiggers@kernel.org> <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com> <20200714161516.GA1064009@gmail.com>
 <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
 <20200714164353.GB1064009@gmail.com> <CAL_JsqK-wUuo6azYseC35R=Q509=h9-v4gFvcvy8wXrDgSw5ZQ@mail.gmail.com>
 <20200714171203.GC1064009@gmail.com>
In-Reply-To: <20200714171203.GC1064009@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 14 Jul 2020 11:36:15 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKOq+PdjUPVYqdC7QcjGxp-KbAG_O9e+zrfY7k-wRr1QQ@mail.gmail.com>
Message-ID: <CAL_JsqKOq+PdjUPVYqdC7QcjGxp-KbAG_O9e+zrfY7k-wRr1QQ@mail.gmail.com>
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

On Tue, Jul 14, 2020 at 11:12 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jul 14, 2020 at 10:59:44AM -0600, Rob Herring wrote:
> > On Tue, Jul 14, 2020 at 10:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Tue, Jul 14, 2020 at 10:35:12AM -0600, Rob Herring wrote:
> > > > On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > >
> > > > > On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> > > > > >
> > > > > > Eric,
> > > > > >
> > > > > > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > > > > > Crypto Engine) to the device tree node for the UFS host controller on
> > > > > > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> > > > > >
> > > > > > I would like to see an Acked-by for this patch before I merge it.
> > > > > >
> > > > >
> > > > > Andy, Bjorn, or Rob: can you give Acked-by?
> > > >
> > > > DTS changes should go in via the QCom tree.
> > > >
> > >
> > > So, the DTS patch can't be applied without the driver patches since then the
> > > driver would misinterpret the ICE registers as the dev_ref_clk_ctrl registers.
> >
> > That sounds broken, but there's no context here for me to comment
> > further. DTS changes should work with old/stable kernels. I'd suggest
> > you get a review from Bjorn on the driver first.
> >
>
> The "breaking" change is that the dev_ref_clk_ctrl registers are now identified
> by name instead of assumed to be index 1.
>
> A reviewer had complained about the device-mapper bindings of this driver before
> (https://lkml.kernel.org/r/158334171487.7173.5606223900174949177@swboyd.mtv.corp.google.com).
> Changing to identifying the registers by name seemed like an improvement.
>
> If needed I can add a hole at index 1 to make the DTS changes work with
> old/stable kernels too, but I didn't know that is a requirement.  (Normally for
> Linux kernel development, kernel-internal refactoring is always allowed
> upstream.)

dtb <-> kernel is an ABI and not an internal interface. The dts files
are hosted in the kernel for convenience as that's where the vast
majority of h/w support is. The DT parts are also generated as a
standalone repo[1] using git-filter-branch for other projects to use.

>  If I do this, would this hack have to be carried forever, or would
> we be able to fix it up eventually?  Is there any deprecation period for DTS, or
> do the latest DTS have to work with a 20 year old kernel?

With the above being said, it's up to the individual platform
maintainers to decide whether breaking the ABI is okay or how long to
worry about compatibility. My only requirement is documenting that a
change does break compatibility. Given this is probably an optional
driver, they may not care.

BTW, we have broken (and fixed) 1998 era PowerMac G3s not too long
ago. That's the opposite direction with old DT (firmware really) and
new kernel.

Rob

[1] https://git.kernel.org/pub/scm/linux/kernel/git/devicetree/devicetree-rebasing.git/
