Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FE52CCFDA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 07:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgLCGwm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Dec 2020 01:52:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:59362 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgLCGwm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Dec 2020 01:52:42 -0500
IronPort-SDR: rKdbBGNDOYAkQ/sa8minLkFe+r+5UDSVtax63GXXkPq2vTsya0bSU0kqRYTlYqYoDDjQ8l04r6
 Z1WJhDm0ngVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="173305213"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="173305213"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 22:52:01 -0800
IronPort-SDR: Hc4mqGeLU21jeldmrMMeEYCgP18C1OjEMA2aaaJPbP8mP8sQ3xdezJB+g7O2RjrORWOF+TmQ7o
 nFGlh4SfZVCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="335844750"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by orsmga006.jf.intel.com with ESMTP; 02 Dec 2020 22:51:52 -0800
Subject: Re: [PATCH v2 9/9] mmc: sdhci-msm: add Inline Crypto Engine support
To:     Eric Biggers <ebiggers@kernel.org>, linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-10-ebiggers@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <5f595d4f-3cc8-b2ae-40b2-b9f9985bb1c5@intel.com>
Date:   Thu, 3 Dec 2020 08:51:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201203020516.225701-10-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/12/20 4:05 am, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add support for Qualcomm Inline Crypto Engine (ICE) to sdhci-msm.
> 
> The standard-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual MMC requests, are already handled by
> cqhci-crypto.c, which itself is wired into the blk-crypto framework.
> However, ICE requires vendor-specific init, enable, and resume logic,
> and it requires that keys be programmed and evicted by vendor-specific
> SMC calls.  Make the sdhci-msm driver handle these details.
> 
> This is heavily inspired by the similar changes made for UFS, since the
> UFS and eMMC ICE instances are very similar.  See commit df4ec2fa7a4d
> ("scsi: ufs-qcom: Add Inline Crypto Engine support").
> 
> I tested this on a Sony Xperia 10, which uses the Snapdragon 630 SoC,
> which has basic upstream support.  Mainly, I used android-xfstests
> (https://github.com/tytso/xfstests-bld/blob/master/Documentation/android-xfstests.md)
> to run the ext4 and f2fs encryption tests in a Debian chroot:
> 
> 	android-xfstests -c ext4,f2fs -g encrypt -m inlinecrypt
> 
> These tests included tests which verify that the on-disk ciphertext is
> identical to that produced by a software implementation.  I also
> verified that ICE was actually being used.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/Kconfig     |   1 +
>  drivers/mmc/host/sdhci-msm.c | 265 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 262 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 31481c9fcc2ec..4f8ff5a690fba 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -544,6 +544,7 @@ config MMC_SDHCI_MSM
>  	depends on MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_IO_ACCESSORS
>  	select MMC_CQHCI
> +	select QCOM_SCM if MMC_CRYPTO && ARCH_QCOM
>  	help
>  	  This selects the Secure Digital Host Controller Interface (SDHCI)
>  	  support present in Qualcomm SOCs. The controller supports
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 3451eb3255135..ce6c3edbef530 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -13,6 +13,7 @@
>  #include <linux/pm_opp.h>
>  #include <linux/slab.h>
>  #include <linux/iopoll.h>
> +#include <linux/qcom_scm.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/interconnect.h>
>  #include <linux/pinctrl/consumer.h>
> @@ -256,10 +257,12 @@ struct sdhci_msm_variant_info {
>  struct sdhci_msm_host {
>  	struct platform_device *pdev;
>  	void __iomem *core_mem;	/* MSM SDCC mapped address */
> +	void __iomem *ice_mem;	/* MSM ICE mapped address (if available) */
>  	int pwr_irq;		/* power irq */
>  	struct clk *bus_clk;	/* SDHC bus voter clock */
>  	struct clk *xo_clk;	/* TCXO clk needed for FLL feature of cm_dll*/
> -	struct clk_bulk_data bulk_clks[4]; /* core, iface, cal, sleep clocks */
> +	/* core, iface, cal, sleep, and ice clocks */
> +	struct clk_bulk_data bulk_clks[5];
>  	unsigned long clk_rate;
>  	struct mmc_host *mmc;
>  	struct opp_table *opp_table;
> @@ -1785,6 +1788,235 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
>  	__sdhci_msm_set_clock(host, clock);
>  }
>  
> +/*****************************************************************************\
> + *                                                                           *
> + * Inline Crypto Engine (ICE) support                                        *
> + *                                                                           *
> +\*****************************************************************************/
> +
> +#ifdef CONFIG_MMC_CRYPTO
> +
> +#define AES_256_XTS_KEY_SIZE			64
> +
> +/* QCOM ICE registers */
> +
> +#define QCOM_ICE_REG_VERSION			0x0008
> +
> +#define QCOM_ICE_REG_FUSE_SETTING		0x0010
> +#define QCOM_ICE_FUSE_SETTING_MASK		0x1
> +#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
> +#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
> +
> +#define QCOM_ICE_REG_BIST_STATUS		0x0070
> +#define QCOM_ICE_BIST_STATUS_MASK		0xF0000000
> +
> +#define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
> +
> +#define sdhci_msm_ice_writel(host, val, reg)	\
> +	writel((val), (host)->ice_mem + (reg))
> +#define sdhci_msm_ice_readl(host, reg)	\
> +	readl((host)->ice_mem + (reg))
> +
> +static bool sdhci_msm_ice_supported(struct sdhci_msm_host *msm_host)
> +{
> +	struct device *dev = mmc_dev(msm_host->mmc);
> +	u32 regval = sdhci_msm_ice_readl(msm_host, QCOM_ICE_REG_VERSION);
> +	int major = regval >> 24;
> +	int minor = (regval >> 16) & 0xFF;
> +	int step = regval & 0xFFFF;
> +
> +	/* For now this driver only supports ICE version 3. */
> +	if (major != 3) {
> +		dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
> +			 major, minor, step);
> +		return false;
> +	}
> +
> +	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
> +		 major, minor, step);
> +
> +	/* If fuses are blown, ICE might not work in the standard way. */
> +	regval = sdhci_msm_ice_readl(msm_host, QCOM_ICE_REG_FUSE_SETTING);
> +	if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
> +		      QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
> +		      QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
> +		dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static inline struct clk *sdhci_msm_ice_get_clk(struct device *dev)
> +{
> +	return devm_clk_get(dev, "ice");
> +}
> +
> +static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
> +			      struct cqhci_host *cq_host)
> +{
> +	struct mmc_host *mmc = msm_host->mmc;
> +	struct device *dev = mmc_dev(mmc);
> +	struct resource *res;
> +	int err;
> +
> +	if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
> +		return 0;
> +
> +	res = platform_get_resource_byname(msm_host->pdev, IORESOURCE_MEM,
> +					   "ice");
> +	if (!res) {
> +		dev_warn(dev, "ICE registers not found\n");
> +		goto disable;
> +	}
> +
> +	if (!qcom_scm_ice_available()) {
> +		dev_warn(dev, "ICE SCM interface not found\n");
> +		goto disable;
> +	}
> +
> +	msm_host->ice_mem = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(msm_host->ice_mem)) {
> +		err = PTR_ERR(msm_host->ice_mem);
> +		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
> +		return err;
> +	}
> +
> +	if (!sdhci_msm_ice_supported(msm_host))
> +		goto disable;
> +
> +	mmc->caps2 |= MMC_CAP2_CRYPTO;
> +	return 0;
> +
> +disable:
> +	dev_warn(dev, "Disabling inline encryption support\n");
> +	return 0;
> +}
> +
> +static void sdhci_msm_ice_low_power_mode_enable(struct sdhci_msm_host *msm_host)
> +{
> +	u32 regval;
> +
> +	regval = sdhci_msm_ice_readl(msm_host, QCOM_ICE_REG_ADVANCED_CONTROL);
> +	/*
> +	 * Enable low power mode sequence
> +	 * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
> +	 */
> +	regval |= 0x7000;
> +	sdhci_msm_ice_writel(msm_host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
> +}
> +
> +static void sdhci_msm_ice_optimization_enable(struct sdhci_msm_host *msm_host)
> +{
> +	u32 regval;
> +
> +	/* ICE Optimizations Enable Sequence */
> +	regval = sdhci_msm_ice_readl(msm_host, QCOM_ICE_REG_ADVANCED_CONTROL);
> +	regval |= 0xD807100;
> +	/* ICE HPG requires delay before writing */
> +	udelay(5);
> +	sdhci_msm_ice_writel(msm_host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
> +	udelay(5);
> +}
> +
> +/* Poll until all BIST (built-in self test) bits are reset */
> +static int sdhci_msm_ice_wait_bist_status(struct sdhci_msm_host *msm_host)
> +{
> +	u32 regval;
> +	int err;
> +
> +	err = readl_poll_timeout(msm_host->ice_mem + QCOM_ICE_REG_BIST_STATUS,
> +				 regval, !(regval & QCOM_ICE_BIST_STATUS_MASK),
> +				 50, 5000);
> +	if (err)
> +		dev_err(mmc_dev(msm_host->mmc),
> +			"Timed out waiting for ICE self-test to complete\n");
> +	return err;
> +}
> +
> +static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
> +{
> +	if (!(msm_host->mmc->caps2 & MMC_CAP2_CRYPTO))
> +		return;
> +	sdhci_msm_ice_low_power_mode_enable(msm_host);
> +	sdhci_msm_ice_optimization_enable(msm_host);
> +	sdhci_msm_ice_wait_bist_status(msm_host);
> +}
> +
> +static int __maybe_unused sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
> +{
> +	if (!(msm_host->mmc->caps2 & MMC_CAP2_CRYPTO))
> +		return 0;
> +	return sdhci_msm_ice_wait_bist_status(msm_host);
> +}
> +
> +/*
> + * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requires
> + * vendor-specific SCM calls for this; it doesn't support the standard way.
> + */
> +static int sdhci_msm_program_key(struct cqhci_host *cq_host,
> +				 const union cqhci_crypto_cfg_entry *cfg,
> +				 int slot)
> +{
> +	struct device *dev = mmc_dev(cq_host->mmc);
> +	union cqhci_crypto_cap_entry cap;
> +	union {
> +		u8 bytes[AES_256_XTS_KEY_SIZE];
> +		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
> +	} key;
> +	int i;
> +	int err;
> +
> +	if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
> +		return qcom_scm_ice_invalidate_key(slot);
> +
> +	/* Only AES-256-XTS has been tested so far. */
> +	cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
> +	if (cap.algorithm_id != CQHCI_CRYPTO_ALG_AES_XTS ||
> +	    cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256) {
> +		dev_err_ratelimited(dev,
> +				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
> +				    cap.algorithm_id, cap.key_size);
> +		return -EINVAL;
> +	}
> +
> +	memcpy(key.bytes, cfg->crypto_key, AES_256_XTS_KEY_SIZE);
> +
> +	/*
> +	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
> +	 * do the same, in order for the final key be correct.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(key.words); i++)
> +		__cpu_to_be32s(&key.words[i]);
> +
> +	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
> +				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> +				   cfg->data_unit_size);
> +	memzero_explicit(&key, sizeof(key));
> +	return err;
> +}
> +#else /* CONFIG_MMC_CRYPTO */
> +static inline struct clk *sdhci_msm_ice_get_clk(struct device *dev)
> +{
> +	return NULL;
> +}
> +
> +static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
> +				     struct cqhci_host *cq_host)
> +{
> +	return 0;
> +}
> +
> +static inline void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
> +{
> +}
> +
> +static inline int __maybe_unused
> +sdhci_msm_ice_resume(struct sdhci_msm_host *msm_host)
> +{
> +	return 0;
> +}
> +#endif /* !CONFIG_MMC_CRYPTO */
> +
>  /*****************************************************************************\
>   *                                                                           *
>   * MSM Command Queue Engine (CQE)                                            *
> @@ -1803,6 +2035,16 @@ static u32 sdhci_msm_cqe_irq(struct sdhci_host *host, u32 intmask)
>  	return 0;
>  }
>  
> +static void sdhci_msm_cqe_enable(struct mmc_host *mmc)
> +{
> +	struct sdhci_host *host = mmc_priv(mmc);
> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
> +
> +	sdhci_cqe_enable(mmc);
> +	sdhci_msm_ice_enable(msm_host);
> +}
> +
>  static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)
>  {
>  	struct sdhci_host *host = mmc_priv(mmc);
> @@ -1835,8 +2077,11 @@ static void sdhci_msm_cqe_disable(struct mmc_host *mmc, bool recovery)
>  }
>  
>  static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
> -	.enable		= sdhci_cqe_enable,
> +	.enable		= sdhci_msm_cqe_enable,
>  	.disable	= sdhci_msm_cqe_disable,
> +#ifdef CONFIG_MMC_CRYPTO
> +	.program_key	= sdhci_msm_program_key,
> +#endif
>  };
>  
>  static int sdhci_msm_cqe_add_host(struct sdhci_host *host,
> @@ -1872,6 +2117,10 @@ static int sdhci_msm_cqe_add_host(struct sdhci_host *host,
>  
>  	dma64 = host->flags & SDHCI_USE_64_BIT_DMA;
>  
> +	ret = sdhci_msm_ice_init(msm_host, cq_host);
> +	if (ret)
> +		goto cleanup;
> +
>  	ret = cqhci_init(cq_host, host->mmc, dma64);
>  	if (ret) {
>  		dev_err(&pdev->dev, "%s: CQE init: failed (%d)\n",
> @@ -2321,6 +2570,11 @@ static int sdhci_msm_probe(struct platform_device *pdev)
>  		clk = NULL;
>  	msm_host->bulk_clks[3].clk = clk;
>  
> +	clk = sdhci_msm_ice_get_clk(&pdev->dev);
> +	if (IS_ERR(clk))
> +		clk = NULL;
> +	msm_host->bulk_clks[4].clk = clk;
> +
>  	ret = clk_bulk_prepare_enable(ARRAY_SIZE(msm_host->bulk_clks),
>  				      msm_host->bulk_clks);
>  	if (ret)
> @@ -2531,12 +2785,15 @@ static __maybe_unused int sdhci_msm_runtime_resume(struct device *dev)
>  	 * Whenever core-clock is gated dynamically, it's needed to
>  	 * restore the SDR DLL settings when the clock is ungated.
>  	 */
> -	if (msm_host->restore_dll_config && msm_host->clk_rate)
> +	if (msm_host->restore_dll_config && msm_host->clk_rate) {
>  		ret = sdhci_msm_restore_sdr_dll_config(host);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	dev_pm_opp_set_rate(dev, msm_host->clk_rate);
>  
> -	return ret;
> +	return sdhci_msm_ice_resume(msm_host);
>  }
>  
>  static const struct dev_pm_ops sdhci_msm_pm_ops = {
> 

