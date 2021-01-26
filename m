Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F6B303D89
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jan 2021 13:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403774AbhAZMp6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jan 2021 07:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391784AbhAZJ7W (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Jan 2021 04:59:22 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01ACC0617A9
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Jan 2021 01:58:40 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id a31so5401413uae.11
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Jan 2021 01:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2s091ZCbXkY5kPsLe1N1zqI9t9bafuafJrjbGry9Cmw=;
        b=me7uH48huC1WigZiogNpzBPm61ucNewUzZWg0f4fVWUAqnmeg73oSGMw4cvVl2YpMt
         m72B812Vm8Ep+efiP0kM/1TqNPHPscNieVwDInZRX0ifjLlx7FYHf0cjb/OWBrgf+ds3
         7Cm4pWLLKay1jkb2Am2XSCfPDKoCsGwe5kZUCEOC7qxwgW3sIxWZc7vU+iaeWgbxrVDa
         Xq70GMRtoA/80D1FIAh2KEknoBJOHZrlCLUt4lij3HI0+7RRLYvLyiQPJLbr2jX9NL2E
         BWfnkt8ZX7GJ10s1XK+eQD4cJd9K9b1tVPCy+zQbvLokDBSOJt2nc+bg6qNEbkTLVDx4
         9Qrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2s091ZCbXkY5kPsLe1N1zqI9t9bafuafJrjbGry9Cmw=;
        b=BNIhochJVAg175N/r+xLDpgJxUlfIPMKQvnV0aMdgxTLr1HK0/hHaQ/hZEsy/n+5oc
         bDqep2xvBqU6WkAGcpQxmj4Kb5UjxwsZe8YazhRc4TkCOo2plgJCyXiVzbL40P4MoC4T
         85JWOy03UupfkQ+r6S0vy92N5FXX4sXNSBBSYNbZiz2fg8nb2ySY3vtCsmmr3/0izd6t
         TUw4/NMcy7Qmxr0Q9h0MfMyy8P2dxxVhwRp36JDnNqPHVEpPriYF9mcD2Iu1CduM4bH/
         ZUrUzXjmFrJFZDZak81NmnoGfv0UtCiYUNZlfgNphjbxL8DPcf8PLSea8huTEUtXcLl0
         TouQ==
X-Gm-Message-State: AOAM532uz8dhBAcfz5u/ELtgM6i62pLJ6LjoKuNcG11w4Gwr/n7AN80t
        LYsfGQFsaEeWhAOZZpqIq2OvK/6JUHnInHfJWaE/5w==
X-Google-Smtp-Source: ABdhPJzoOxmNVPAsa+mo+p6s77bXk9Znkd/2lfcQFCTupY7epko0u8YpeILwE6V0/D1n9mDNs1+v+nrLYpCm/DmzQUA=
X-Received: by 2002:ab0:338c:: with SMTP id y12mr3373917uap.19.1611655120019;
 Tue, 26 Jan 2021 01:58:40 -0800 (PST)
MIME-Version: 1.0
References: <20210126001456.382989-1-ebiggers@kernel.org>
In-Reply-To: <20210126001456.382989-1-ebiggers@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 26 Jan 2021 10:58:03 +0100
Message-ID: <CAPDyKFqLVtiYkjeQmuYOf8K8k=oQSZ18928PPHvJDiUtTw2F-g@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 0/9] eMMC inline encryption support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
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

On Tue, 26 Jan 2021 at 01:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> [Resending because most of the patches didn't make it to the lists for
> some reason...]
>
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
> Patches 1-4 add support for the standard eMMC inline encryption.
>
> However, as with UFS, host controller-specific patches are needed on top
> of the standard support.  Therefore, patches 5-9 add Qualcomm ICE
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
> I.e., patches 1-4 should be almost enough for the Mediatek hardware.
>
> This patchset is based on the "next" branch (commit 42af8761bc84) of
> https://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git,
> plus the patch "block/keyslot-manager: introduce devm_blk_ksm_init()"
> (https://lkml.kernel.org/r/20210121082155.111333-2-ebiggers@kernel.org).
> It can also be retrieved from tag "mmc-crypto-v6" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>
> Changed in v6:
>   - Define MMC_CAP2_CRYPTO to 0 when !CONFIG_MMC_CRYPTO.
>   - Moved the sdm630 device tree update to the end of the series,
>     since it will go in through a different tree.
>   - Added an Acked-by.
>
> Changed in v5:
>   - Use the proposed resource-managed variant of blk_ksm_init().
>   - Removed an unnecessary call to devm_kfree().
>
> Changed in v4:
>   - Added Acked-by and Reviewed-and-tested-by tags.
>   - Rebased onto v5.11-rc2.
>
> Changed in v3:
>   - Improved comment for sdhci_msm_ice_wait_bist_status()
>   - Removed an unhelpful comment in union cqhci_crypto_cfg_entry.
>   - Fixed the commit message of "mmc: cqhci: initialize upper 64 bits of
>     128-bit task descriptors".
>   - Added Reviewed-by's and Acked-by's.
>
> Changed in v2:
>   - Only select QCOM_SCM if ARCH_QCOM.  (Fixes a build break.)
>   - Split most of the cqhci_prep_task_desc() change into its own patch.
>   - Made sdhci_msm_ice_wait_bist_status() use readl_poll_timeout().
>   - Added a couple more comments.
>   - Added some Acked-by's.
>
> Eric Biggers (9):
>   mmc: add basic support for inline encryption
>   mmc: cqhci: rename cqhci.c to cqhci-core.c
>   mmc: cqhci: initialize upper 64 bits of 128-bit task descriptors
>   mmc: cqhci: add support for inline encryption
>   mmc: cqhci: add cqhci_host_ops::program_key
>   firmware: qcom_scm: update comment for ICE-related functions
>   dt-bindings: mmc: sdhci-msm: add ICE registers and clock
>   mmc: sdhci-msm: add Inline Crypto Engine support
>   arm64: dts: qcom: sdm630: add ICE registers and clocks
>
>  .../devicetree/bindings/mmc/sdhci-msm.txt     |   3 +
>  arch/arm64/boot/dts/qcom/sdm630.dtsi          |  10 +-
>  drivers/firmware/qcom_scm.c                   |  16 +-
>  drivers/mmc/core/Kconfig                      |   8 +
>  drivers/mmc/core/Makefile                     |   1 +
>  drivers/mmc/core/block.c                      |   3 +
>  drivers/mmc/core/core.c                       |   3 +
>  drivers/mmc/core/crypto.c                     |  48 +++
>  drivers/mmc/core/crypto.h                     |  40 +++
>  drivers/mmc/core/host.c                       |   1 +
>  drivers/mmc/core/queue.c                      |   3 +
>  drivers/mmc/host/Kconfig                      |   1 +
>  drivers/mmc/host/Makefile                     |   2 +
>  drivers/mmc/host/{cqhci.c => cqhci-core.c}    |  69 ++++-
>  drivers/mmc/host/cqhci-crypto.c               | 242 +++++++++++++++
>  drivers/mmc/host/cqhci-crypto.h               |  47 +++
>  drivers/mmc/host/cqhci.h                      |  84 +++++-
>  drivers/mmc/host/sdhci-msm.c                  | 276 +++++++++++++++++-
>  include/linux/mmc/core.h                      |   6 +
>  include/linux/mmc/host.h                      |  11 +
>  20 files changed, 849 insertions(+), 25 deletions(-)
>  create mode 100644 drivers/mmc/core/crypto.c
>  create mode 100644 drivers/mmc/core/crypto.h
>  rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (94%)
>  create mode 100644 drivers/mmc/host/cqhci-crypto.c
>  create mode 100644 drivers/mmc/host/cqhci-crypto.h
>
> --
> 2.30.0
>

Applied for next (leaving patch9 for arm soc), thanks!

Kind regards
Uffe
