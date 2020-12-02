Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EAB2CBE6A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 14:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgLBNfL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 08:35:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:20211 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgLBNfK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 08:35:10 -0500
IronPort-SDR: D47WF9fFIB/GkeYqiSMsrwvXlXWge2miCYR3yX6EiOIMYNwsh9DGjYLRNU8iQnxllgy+eU9ztW
 3l41vN7nlr5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="234619677"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="234619677"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 05:34:29 -0800
IronPort-SDR: NBMyq7oIWsFjS7TakFQZ6eBLoMeiJIdKtPO906uQ+nh4ETOqcNz6DIyk1rSnzWhQG0m9l8WP/V
 xhYcgz3HSY8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="365300010"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga004.fm.intel.com with ESMTP; 02 Dec 2020 05:34:21 -0800
Subject: Re: [PATCH 2/8] mmc: cqhci: rename cqhci.c to cqhci-core.c
To:     Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
References: <20201112194011.103774-1-ebiggers@kernel.org>
 <20201112194011.103774-3-ebiggers@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <a0a77e64-b838-c605-cc1f-8b0c2277d710@intel.com>
Date:   Wed, 2 Dec 2020 15:33:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201112194011.103774-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/11/20 9:40 pm, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Rename cqhci.c to cqhci-core.c so that another source file can be added
> to the cqhci module without having to rename the module.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/Makefile                  | 1 +
>  drivers/mmc/host/{cqhci.c => cqhci-core.c} | 0
>  2 files changed, 1 insertion(+)
>  rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (100%)
> 
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index 451c25fc2c692..20c2f9463d0dc 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -104,6 +104,7 @@ obj-$(CONFIG_MMC_SDHCI_BRCMSTB)		+= sdhci-brcmstb.o
>  obj-$(CONFIG_MMC_SDHCI_OMAP)		+= sdhci-omap.o
>  obj-$(CONFIG_MMC_SDHCI_SPRD)		+= sdhci-sprd.o
>  obj-$(CONFIG_MMC_CQHCI)			+= cqhci.o
> +cqhci-y					+= cqhci-core.o
>  obj-$(CONFIG_MMC_HSQ)			+= mmc_hsq.o
>  
>  ifeq ($(CONFIG_CB710_DEBUG),y)
> diff --git a/drivers/mmc/host/cqhci.c b/drivers/mmc/host/cqhci-core.c
> similarity index 100%
> rename from drivers/mmc/host/cqhci.c
> rename to drivers/mmc/host/cqhci-core.c
> 

