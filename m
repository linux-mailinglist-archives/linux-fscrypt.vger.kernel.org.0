Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2D52E9EFF
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 21:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhADUrJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 15:47:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADUrJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 15:47:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4D02216C4;
        Mon,  4 Jan 2021 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609793188;
        bh=YqIdopmOGx1e+VJgMk2OWtmHGztHh2JIO7mbqBw+ZvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ojDlygvzJm6AJYbApbRtXGu5fn8IHOoEsnavSY9e/5GqTUkwKASrHQkAOWGGsuHaL
         zPgCMvdZ1mG3pkjWKWmrOOcA2HAwQSUkq5PhQULpdHrln3mUhFkSCJz5T58RlfH5Dl
         L4Q+q3hmaW57vJiBmLD1Dza0h6gGx3lBp8r5OM2a3ojps/sWAjZRobLN9lKOLofN5G
         +7Hq0Mz/qS5C9Ipd2xsUOIN0ibiZQ2tdvl7Jx9Pa00tWw4hMEJq4pgUwW3UG2sN+kU
         ogb1tXgieCNFnX/hQ9+mQe5eNv3hiUe6+lOIPFf0BWAw+a91yMokFHel7RisgsH8ft
         pH0Ia0dcFLlug==
Date:   Mon, 4 Jan 2021 12:46:26 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ulf Hansson <ulf.hansson@linaro.org>
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
Subject: Re: [PATCH 0/8] eMMC inline encryption support
Message-ID: <X/N+ouEtmMPYT0Qa@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <X7gQ9Y44iIgkiM64@sol.localdomain>
 <CAPDyKFrXtqqj3RXJ4m666e_danpp2neRD_M+FCaMWPC+Ow2jsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFrXtqqj3RXJ4m666e_danpp2neRD_M+FCaMWPC+Ow2jsA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 25, 2020 at 10:56:42AM +0100, Ulf Hansson wrote:
> On Fri, 20 Nov 2020 at 19:54, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Nov 12, 2020 at 11:40:03AM -0800, Eric Biggers wrote:
> > > Hello,
> > >
> > > This patchset adds support for eMMC inline encryption, as specified by
> > > the upcoming version of the eMMC specification and as already
> > > implemented and used on many devices.  Building on that, it then adds
> > > Qualcomm ICE support and wires it up for the Snapdragon 630 SoC.
> > >
> > > Inline encryption hardware improves the performance of storage
> > > encryption and reduces power usage.  See
> > > Documentation/block/inline-encryption.rst for more information about
> > > inline encryption and the blk-crypto framework (upstreamed in v5.8)
> > > which supports it.  Most mobile devices already use UFS or eMMC inline
> > > encryption hardware; UFS support was already upstreamed in v5.9.
> > >
> > > Patches 1-3 add support for the standard eMMC inline encryption.
> > >
> > > However, as with UFS, host controller-specific patches are needed on top
> > > of the standard support.  Therefore, patches 4-8 add Qualcomm ICE
> > > (Inline Crypto Engine) support and wire it up on the Snapdragon 630 SoC.
> > >
> > > To test this I took advantage of the recently upstreamed support for the
> > > Snapdragon 630 SoC, plus work-in-progress patches from the SoMainline
> > > project (https://github.com/SoMainline/linux/tree/konrad/v5.10-rc3).  In
> > > particular, I was able to run the fscrypt xfstests for ext4 and f2fs in
> > > a Debian chroot.  Among other things, these tests verified that the
> > > correct ciphertext is written to disk (the same as software encryption).
> > >
> > > It will also be possible to add support for Mediatek eMMC inline
> > > encryption hardware in mtk-sd, and it should be easier than the Qualcomm
> > > hardware since the Mediatek hardware follows the standard more closely.
> > > I.e., patches 1-3 should be almost enough for the Mediatek hardware.
> > > However, I don't have the hardware to do this yet.
> > >
> > > This patchset is based on v5.10-rc3, and it can also be retrieved from
> > > tag "mmc-crypto-v1" of
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > >
> > > Note: the fscrypt inline encryption support is partially broken in
> > > v5.10-rc3, so for testing a fscrypt fix needs to be applied too:
> > > https://lkml.kernel.org/r/20201111015224.303073-1-ebiggers@kernel.org
> > >
> > > Eric Biggers (8):
> > >   mmc: add basic support for inline encryption
> > >   mmc: cqhci: rename cqhci.c to cqhci-core.c
> > >   mmc: cqhci: add support for inline encryption
> > >   mmc: cqhci: add cqhci_host_ops::program_key
> > >   firmware: qcom_scm: update comment for ICE-related functions
> > >   dt-bindings: mmc: sdhci-msm: add ICE registers and clock
> > >   arm64: dts: qcom: sdm630: add ICE registers and clocks
> > >   mmc: sdhci-msm: add Inline Crypto Engine support
> >
> > Any comments on this patchset?
> 
> I have been busy, but just wanted to let you know that I am moving to
> start reviewing this series shortly.
> 
> I also need to catch up on the eMMC spec a bit, before I can provide
> you with comments.
> 
> Kind regards
> Uffe

Ulf, are you still planning to review this patchset?  I just sent out v4 of this
patchset based on v5.11-rc2, but not a lot has changed from previous versions,
since people have generally seemed happy with it.  Any chance that you will
apply it for 5.12?  Thanks!

- Eric
