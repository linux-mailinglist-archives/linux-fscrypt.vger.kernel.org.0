Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A352C3D11
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Nov 2020 10:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKYJ5V (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Nov 2020 04:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgKYJ5V (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Nov 2020 04:57:21 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89FAC061A4D
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Nov 2020 01:57:19 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id u24so880010vsl.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Nov 2020 01:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t0REdB3olCexNERcSHnzJwkFu42mj1xmlom0KLliQ/I=;
        b=Y1MuhRmqz4Ac5OM43sgbecc7Bv0lPYZlg6hUu79nriANbuJ7cc3DV+kbp7m1OHR8rB
         BN4fs6A3GfeN5ImPMKR0alrZMeCFRUrn7ErNv424xjNVe4MtBMQ4NXvleHyLoO3REg8r
         QeP0Yg57+0ikm3CRLXyclKSiJe/0Lf1nuzOBmOE/1ozh85a6VxBmaxQO2BLqKw4pshe8
         ew0/TQ9zLUeXlszjngC0w6Unskivab/rbt8kLsO9DPYTd4fgwFWEtTCzxw6PrldRrYtD
         ypJBfBmWNKMfJo2FmB5PEso5RNtN+gZzIjVFDBzKa1p+EYysVkvHUFLfvG9SfA4Jdj+n
         S4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t0REdB3olCexNERcSHnzJwkFu42mj1xmlom0KLliQ/I=;
        b=GTLkIyvcgJrnoUEWoXWtW+V+6qdyJmf0Ri7HNnSkx0m0/zTIzW2n7+UOAAQI03T1zL
         ENlE1iOuapDsuo1DA8QtrokRZTT2knwY9zJZdPvn6QuXvPif3GeJo9KDpYmwrisPrsL/
         smPSRMb5ALYK+Wr5whfqrmJgXw8SnMD8vXALp2PVKS2fNHiNaWYOe1aMQ12bQ2S+cyp9
         Cii0Fr960+mgtR6LG+EaQ0nEeWILDUO+lCYpVaF4swr/d3f7VPmk+m/RZhmczNkYXmB6
         waXhlDMrrYlf2jZCoS24UYVNN/rrCke6BMAMxcD66WUL5OONTgpGdcdVj96LNTzOnlnK
         wuAg==
X-Gm-Message-State: AOAM530O5B3OxRlDJ3LWJ85fZku6YHoJbWlCG94R8M3JSkD1vn/s66/p
        hf0vsKLgq2sjKvctpN3Bh+dc1MNWeS9m5zr6NA4fmg==
X-Google-Smtp-Source: ABdhPJzwbR3dPmM+DDvpmCIiGlOOwtZSknMvs/ZVop/d6QS3ZX9tdcZ8DRnaSlHSuFaOAu8Ffbe8WFpIzV7zBj+q5kU=
X-Received: by 2002:a05:6102:322a:: with SMTP id x10mr473721vsf.19.1606298239005;
 Wed, 25 Nov 2020 01:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20201112194011.103774-1-ebiggers@kernel.org> <X7gQ9Y44iIgkiM64@sol.localdomain>
In-Reply-To: <X7gQ9Y44iIgkiM64@sol.localdomain>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 25 Nov 2020 10:56:42 +0100
Message-ID: <CAPDyKFrXtqqj3RXJ4m666e_danpp2neRD_M+FCaMWPC+Ow2jsA@mail.gmail.com>
Subject: Re: [PATCH 0/8] eMMC inline encryption support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 20 Nov 2020 at 19:54, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Nov 12, 2020 at 11:40:03AM -0800, Eric Biggers wrote:
> > Hello,
> >
> > This patchset adds support for eMMC inline encryption, as specified by
> > the upcoming version of the eMMC specification and as already
> > implemented and used on many devices.  Building on that, it then adds
> > Qualcomm ICE support and wires it up for the Snapdragon 630 SoC.
> >
> > Inline encryption hardware improves the performance of storage
> > encryption and reduces power usage.  See
> > Documentation/block/inline-encryption.rst for more information about
> > inline encryption and the blk-crypto framework (upstreamed in v5.8)
> > which supports it.  Most mobile devices already use UFS or eMMC inline
> > encryption hardware; UFS support was already upstreamed in v5.9.
> >
> > Patches 1-3 add support for the standard eMMC inline encryption.
> >
> > However, as with UFS, host controller-specific patches are needed on top
> > of the standard support.  Therefore, patches 4-8 add Qualcomm ICE
> > (Inline Crypto Engine) support and wire it up on the Snapdragon 630 SoC.
> >
> > To test this I took advantage of the recently upstreamed support for the
> > Snapdragon 630 SoC, plus work-in-progress patches from the SoMainline
> > project (https://github.com/SoMainline/linux/tree/konrad/v5.10-rc3).  In
> > particular, I was able to run the fscrypt xfstests for ext4 and f2fs in
> > a Debian chroot.  Among other things, these tests verified that the
> > correct ciphertext is written to disk (the same as software encryption).
> >
> > It will also be possible to add support for Mediatek eMMC inline
> > encryption hardware in mtk-sd, and it should be easier than the Qualcomm
> > hardware since the Mediatek hardware follows the standard more closely.
> > I.e., patches 1-3 should be almost enough for the Mediatek hardware.
> > However, I don't have the hardware to do this yet.
> >
> > This patchset is based on v5.10-rc3, and it can also be retrieved from
> > tag "mmc-crypto-v1" of
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> >
> > Note: the fscrypt inline encryption support is partially broken in
> > v5.10-rc3, so for testing a fscrypt fix needs to be applied too:
> > https://lkml.kernel.org/r/20201111015224.303073-1-ebiggers@kernel.org
> >
> > Eric Biggers (8):
> >   mmc: add basic support for inline encryption
> >   mmc: cqhci: rename cqhci.c to cqhci-core.c
> >   mmc: cqhci: add support for inline encryption
> >   mmc: cqhci: add cqhci_host_ops::program_key
> >   firmware: qcom_scm: update comment for ICE-related functions
> >   dt-bindings: mmc: sdhci-msm: add ICE registers and clock
> >   arm64: dts: qcom: sdm630: add ICE registers and clocks
> >   mmc: sdhci-msm: add Inline Crypto Engine support
>
> Any comments on this patchset?

I have been busy, but just wanted to let you know that I am moving to
start reviewing this series shortly.

I also need to catch up on the eMMC spec a bit, before I can provide
you with comments.

Kind regards
Uffe
