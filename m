Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C312B2A0E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Nov 2020 01:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgKNAkg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 19:40:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgKNAkg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 19:40:36 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C741522265;
        Sat, 14 Nov 2020 00:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314436;
        bh=D1zRQPyp66MkJgSaN2fKWLPCwy5olTbfmofE42dOHWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lg2LBV8uPC3Eg/NZ9ktGi0UCh1CwzK/kG52D/bhLaAdlReyljRksV3HPyJ9RjFkd5
         T+76HpF6zsdko6z672HK3jiA9mrUdmZBg6z3+CwgUT52yUvbHCWM8K6FCpIt92t6p2
         uCDeKS6QKsCrkEjDyj8kZlF7dbDz4PtKE7gYDJNU=
Date:   Fri, 13 Nov 2020 16:40:34 -0800
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
Subject: Re: [PATCH 8/8] mmc: sdhci-msm: add Inline Crypto Engine support
Message-ID: <X68ngpy5BzzqbWOM@sol.localdomain>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <20201112194011.103774-9-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112194011.103774-9-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Nov 12, 2020 at 11:40:11AM -0800, Eric Biggers wrote:
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 31481c9fcc2ec..2ede2c86f173b 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -544,6 +544,7 @@ config MMC_SDHCI_MSM
>  	depends on MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_IO_ACCESSORS
>  	select MMC_CQHCI
> +	select QCOM_SCM if MMC_CRYPTO
>  	help
>  	  This selects the Secure Digital Host Controller Interface (SDHCI)
>  	  support present in Qualcomm SOCs. The controller supports

The kernel test robot reported linkage errors caused by QCOM_SCM being selected
without its dependency (ARM || ARM64).  I'll probably fix this by doing:

	select QCOM_SCM if MMC_CRYPTO && ARCH_QCOM

- Eric
