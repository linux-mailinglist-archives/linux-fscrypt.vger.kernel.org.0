Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB1821F76C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgGNQf0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 12:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgGNQf0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 12:35:26 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B607422507;
        Tue, 14 Jul 2020 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594744525;
        bh=YkrzgjhT6Y5ztQ5k7rLOb4P38fegcqh0JR44lmXRkNU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UsVCDyeM22yh72ei3RgUCPFWrpzewyrJAF4+jgdA0Qc8mJ67b9veaFyEGuKK/nWgc
         imMfNUi75Lr3FucO06wkmsYqsqfytGYueBkPtFM3MDZ+9Tw7XlQTO5D2nZD1+ClW7P
         Fr03dsSOZ8fgLHd+EUxo5Fz4K6Yv6MRDqbj8APHM=
Received: by mail-oi1-f178.google.com with SMTP id r8so14404566oij.5;
        Tue, 14 Jul 2020 09:35:25 -0700 (PDT)
X-Gm-Message-State: AOAM532Vqi5qVqyp7YD5+NxAxMMSB2m28pWd+U3sAy9170Z9/y9R8X83
        fSHuy+Xsqbl+ibipwtiD6kjZYaq17U80vzKIuQ==
X-Google-Smtp-Source: ABdhPJxvjuliOYQ6o2rYm9WqDVOAc+kfhoaI6r8uyA22P8OiGyoYcvJLyiliWp1gkVrWUxMgdV0ZGQuU2MUA99cINIE=
X-Received: by 2002:aca:30d2:: with SMTP id w201mr4438284oiw.147.1594744525129;
 Tue, 14 Jul 2020 09:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200710072013.177481-1-ebiggers@kernel.org> <20200710072013.177481-4-ebiggers@kernel.org>
 <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com> <20200714161516.GA1064009@gmail.com>
In-Reply-To: <20200714161516.GA1064009@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 14 Jul 2020 10:35:12 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
Message-ID: <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
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

On Tue, Jul 14, 2020 at 10:15 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jul 14, 2020 at 10:16:04AM -0400, Martin K. Petersen wrote:
> >
> > Eric,
> >
> > > Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> > > Crypto Engine) to the device tree node for the UFS host controller on
> > > sdm845, so that the ufs-qcom driver will be able to use inline crypto.
> >
> > I would like to see an Acked-by for this patch before I merge it.
> >
>
> Andy, Bjorn, or Rob: can you give Acked-by?

DTS changes should go in via the QCom tree.

Rob
