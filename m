Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FC2BB498
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Nov 2020 20:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbgKTSys (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 20 Nov 2020 13:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732125AbgKTSys (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 20 Nov 2020 13:54:48 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBA5D22464;
        Fri, 20 Nov 2020 18:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605898487;
        bh=vuiELE5XGU2+DhDJPR79jq8faVGdeHJnuOWD7QrME9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0Dx9cKYv4iEpn1EMXfrXA/dGLwaMcH8S9IDWos5qfxCz3UdK8HCjW15M9S93qimK7
         f1TjQ42Fs9XTNNkwEpK6KE4o/O7nbIZzL4fo34vJj1+nQU3QoJjl2335Hln3UqJuRY
         1+h3qaep5AIRzRiOTMNs6jb+4fpsgIZwGcaPUBgw=
Date:   Fri, 20 Nov 2020 10:54:45 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
Message-ID: <X7gQ9Y44iIgkiM64@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112194011.103774-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Nov 12, 2020 at 11:40:03AM -0800, Eric Biggers wrote:
> Hello,
> 
> This patchset adds support for eMMC inline encryption, as specified by
> the upcoming version of the eMMC specification and as already
> implemented and used on many devices.  Building on that, it then adds
> Qualcomm ICE support and wires it up for the Snapdragon 630 SoC.
> 
> Inline encryption hardware improves the performance of storage
> encryption and reduces power usage.  See
> Documentation/block/inline-encryption.rst for more information about
> inline encryption and the blk-crypto framework (upstreamed in v5.8)
> which supports it.  Most mobile devices already use UFS or eMMC inline
> encryption hardware; UFS support was already upstreamed in v5.9.
> 
> Patches 1-3 add support for the standard eMMC inline encryption.
> 
> However, as with UFS, host controller-specific patches are needed on top
> of the standard support.  Therefore, patches 4-8 add Qualcomm ICE
> (Inline Crypto Engine) support and wire it up on the Snapdragon 630 SoC.
> 
> To test this I took advantage of the recently upstreamed support for the
> Snapdragon 630 SoC, plus work-in-progress patches from the SoMainline
> project (https://github.com/SoMainline/linux/tree/konrad/v5.10-rc3).  In
> particular, I was able to run the fscrypt xfstests for ext4 and f2fs in
> a Debian chroot.  Among other things, these tests verified that the
> correct ciphertext is written to disk (the same as software encryption).
> 
> It will also be possible to add support for Mediatek eMMC inline
> encryption hardware in mtk-sd, and it should be easier than the Qualcomm
> hardware since the Mediatek hardware follows the standard more closely.
> I.e., patches 1-3 should be almost enough for the Mediatek hardware.
> However, I don't have the hardware to do this yet.
> 
> This patchset is based on v5.10-rc3, and it can also be retrieved from
> tag "mmc-crypto-v1" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> 
> Note: the fscrypt inline encryption support is partially broken in
> v5.10-rc3, so for testing a fscrypt fix needs to be applied too:
> https://lkml.kernel.org/r/20201111015224.303073-1-ebiggers@kernel.org
> 
> Eric Biggers (8):
>   mmc: add basic support for inline encryption
>   mmc: cqhci: rename cqhci.c to cqhci-core.c
>   mmc: cqhci: add support for inline encryption
>   mmc: cqhci: add cqhci_host_ops::program_key
>   firmware: qcom_scm: update comment for ICE-related functions
>   dt-bindings: mmc: sdhci-msm: add ICE registers and clock
>   arm64: dts: qcom: sdm630: add ICE registers and clocks
>   mmc: sdhci-msm: add Inline Crypto Engine support

Any comments on this patchset?

- Eric
