Return-Path: <linux-fscrypt+bounces-60-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5296E809ACB
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 05:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7CB2B20D5D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 04:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E124C80;
	Fri,  8 Dec 2023 04:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mArfYJ/5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FF94C60;
	Fri,  8 Dec 2023 04:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51637C433C7;
	Fri,  8 Dec 2023 04:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702008409;
	bh=d1dSKVuv7omD6A9Bip/nz2tMSkQkLiKHF183X5i3/Kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mArfYJ/5hM+0ueNAbtVVWr40g0rD/+LAOy3hzjuaFfhW14E+8XLMf6mCg5B51f3k/
	 ZETUt7BHD5U0stOP4z6YtHqvoU3APwbaH2UgKgjG6zxb1dlFGZ7bBtY2giHcvvHplp
	 B5Ho//VLOphAnXLO7nWX5sE8cSP/NVtpMq2P8F873V+dlZwZdkhjDMrANchwbVGQcS
	 56JmmqUPsEoLeoUsUwS1mBlMgb/olELnyJybQ+LuJvtVcGRsBq/QcC1ZXYxkhYUZhd
	 wOj9f9hWdfe9mtksduujnL5K8+N49T4urQvobUUCFuyVuLoR7FTIxhXvh1MgIqQgdZ
	 rccEF6ptgAQlg==
Date: Thu, 7 Dec 2023 20:11:24 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	ebiggers@google.com, neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com, abel.vesa@linaro.org, 
	quic_spuppala@quicinc.com, kernel@quicinc.com
Subject: Re: [PATCH v3 03/12] soc: qcom: ice: add hwkm support in ice
Message-ID: <up5gjtun7a2hfwvz47422xjxwt2mhxtn6m4yal5jxa4aneqn3m@7msl7k23hjhb>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-4-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122053817.3401748-4-quic_gaurkash@quicinc.com>

On Tue, Nov 21, 2023 at 09:38:08PM -0800, Gaurav Kashyap wrote:
> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary
> key management hardware called Hardware Key Manager (HWKM).
> This patch integrates HWKM support in ICE when it is
> available. HWKM primarily provides hardware wrapped key support
> where the ICE (storage) keys are not available in software and
> protected in hardware.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/soc/qcom/ice.c | 133 ++++++++++++++++++++++++++++++++++++++++-
>  include/soc/qcom/ice.h |   1 +
>  2 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 6f941d32fffb..adf9cab848fa 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -26,6 +26,19 @@
>  #define QCOM_ICE_REG_FUSE_SETTING		0x0010
>  #define QCOM_ICE_REG_BIST_STATUS		0x0070
>  #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
> +#define QCOM_ICE_REG_CONTROL			0x0
> +/* QCOM ICE HWKM registers */
> +#define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
> +#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
> +#define QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS	0x2008
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0			0x5000
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1			0x5004
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2			0x5008
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3			0x500C
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4			0x5010
> +
> +#define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
> +#define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
>  
>  /* BIST ("built-in self-test") status flags */
>  #define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
> @@ -34,6 +47,9 @@
>  #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>  #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>  
> +#define QCOM_ICE_HWKM_REG_OFFSET	0x8000
> +#define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
> +
>  #define qcom_ice_writel(engine, val, reg)	\
>  	writel((val), (engine)->base + (reg))
>  
> @@ -46,6 +62,9 @@ struct qcom_ice {
>  	struct device_link *link;
>  
>  	struct clk *core_clk;
> +	u8 hwkm_version;
> +	bool use_hwkm;
> +	bool hwkm_init_complete;
>  };
>  
>  static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -63,8 +82,26 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
>  		return false;
>  	}
>  
> +	if (major >= 4 || (major == 3 && minor == 2 && step >= 1))
> +		ice->hwkm_version = 2;
> +	else if (major == 3 && minor == 2)
> +		ice->hwkm_version = 1;
> +	else
> +		ice->hwkm_version = 0;
> +
> +	if (ice->hwkm_version == 0)
> +		ice->use_hwkm = false;
> +
>  	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
>  		 major, minor, step);
> +	if (!ice->hwkm_version)
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not supported");

So for a version < 3.2.0, we will dev_info() three times, one stating
the version found, one stating that HWKM is not supported, and then
below one saying that HWKM is not used.

> +	else
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) version = %d",
> +			 ice->hwkm_version);

And for version >= 3.2.0 we will dev_info() two times.


To the vast majority of readers of the kernel log none of these
info-prints are useful - it's just spam.

I'd prefer that it was turned into dev_dbg(), which those who want to
know (e.g. during bringup) can enable. But that's a separate change,
please start by consolidating your information into a single line
printed in the log.

> +
> +	if (!ice->use_hwkm)
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not used");
>  
>  	/* If fuses are blown, ICE might not work in the standard way. */
>  	regval = qcom_ice_readl(ice, QCOM_ICE_REG_FUSE_SETTING);
> @@ -113,10 +150,14 @@ static void qcom_ice_optimization_enable(struct qcom_ice *ice)
>   * fails, so we needn't do it in software too, and (c) properly testing
>   * storage encryption requires testing the full storage stack anyway,
>   * and not relying on hardware-level self-tests.
> + *
> + * However, we still care about if HWKM BIST failed (when supported) as
> + * important functionality would fail later, so disable hwkm on failure.
>   */
>  static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
>  {
>  	u32 regval;
> +	u32 bist_done_val;

The "val" suffix indicates that this would be a "value", but it's
actually a register offset. "bist_done_reg" would be better.

>  	int err;
>  
>  	err = readl_poll_timeout(ice->base + QCOM_ICE_REG_BIST_STATUS,
> @@ -125,15 +166,95 @@ static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
>  	if (err)
>  		dev_err(ice->dev, "Timed out waiting for ICE self-test to complete\n");
>  
> +	if (ice->use_hwkm) {
> +		bist_done_val = (ice->hwkm_version == 1) ?
> +				 QCOM_ICE_HWKM_BIST_DONE_V1_VAL :
> +				 QCOM_ICE_HWKM_BIST_DONE_V2_VAL;
> +		if (qcom_ice_readl(ice,
> +				   HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_STATUS)) !=
> +				   bist_done_val) {
> +			dev_warn(ice->dev, "HWKM BIST error\n");

Sounds like a error to me, wouldn't dev_err() be suitable?

> +			ice->use_hwkm = false;
> +		}
> +	}
>  	return err;
>  }
>  
> +static void qcom_ice_enable_standard_mode(struct qcom_ice *ice)
> +{
> +	u32 val = 0;
> +
> +	if (!ice->use_hwkm)
> +		return;
> +
> +	/*
> +	 * When ICE is in standard (hwkm) mode, it supports HW wrapped
> +	 * keys, and when it is in legacy mode, it only supports standard
> +	 * (non HW wrapped) keys.
> +	 *
> +	 * Put ICE in standard mode, ICE defaults to legacy mode.
> +	 * Legacy mode - ICE HWKM slave not supported.
> +	 * Standard mode - ICE HWKM slave supported.
> +	 *
> +	 * Depending on the version of HWKM, it is controlled by different
> +	 * registers in ICE.
> +	 */
> +	if (ice->hwkm_version >= 2) {
> +		val = qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
> +		val = val & 0xFFFFFFFE;
> +		qcom_ice_writel(ice, val, QCOM_ICE_REG_CONTROL);
> +	} else {
> +		qcom_ice_writel(ice, 0x7,
> +				HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
> +	}
> +}
> +
> +static void qcom_ice_hwkm_init(struct qcom_ice *ice)
> +{
> +	if (!ice->use_hwkm)
> +		return;
> +
> +	/* Disable CRC checks. This HWKM feature is not used. */
> +	qcom_ice_writel(ice, 0x6,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
> +
> +	/*
> +	 * Give register bank of the HWKM slave access to read and modify
> +	 * the keyslots in ICE HWKM slave. Without this, trustzone will not
> +	 * be able to program keys into ICE.
> +	 */
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_0));

This line is 86 characters long if left unwrapped. You're allowed to go
over 80 characters if it makes the code more readable, so please do so
for these and below.

> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_1));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_2));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_3));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_4));
> +
> +	/* Clear HWKM response FIFO before doing anything */
> +	qcom_ice_writel(ice, 0x8,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
> +}
> +
>  int qcom_ice_enable(struct qcom_ice *ice)
>  {
> +	int err;
> +
>  	qcom_ice_low_power_mode_enable(ice);
>  	qcom_ice_optimization_enable(ice);
>  
> -	return qcom_ice_wait_bist_status(ice);
> +	qcom_ice_enable_standard_mode(ice);
> +
> +	err = qcom_ice_wait_bist_status(ice);
> +	if (err)
> +		return err;
> +
> +	qcom_ice_hwkm_init(ice);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_enable);
>  
> @@ -149,6 +270,8 @@ int qcom_ice_resume(struct qcom_ice *ice)
>  		return err;
>  	}
>  
> +	qcom_ice_enable_standard_mode(ice);
> +	qcom_ice_hwkm_init(ice);
>  	return qcom_ice_wait_bist_status(ice);
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_resume);
> @@ -205,6 +328,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>  
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
> +{
> +	return ice->use_hwkm;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> +
>  static struct qcom_ice *qcom_ice_create(struct device *dev,
>  					void __iomem *base)
>  {
> @@ -239,6 +368,8 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>  		engine->core_clk = devm_clk_get_enabled(dev, NULL);
>  	if (IS_ERR(engine->core_clk))
>  		return ERR_CAST(engine->core_clk);
> +	engine->use_hwkm = of_property_read_bool(dev->of_node,
> +						 "qcom,ice-use-hwkm");

Under what circumstances would we, with version >= 3.2, not specify this
flag?

Thanks,
Bjorn

>  
>  	if (!qcom_ice_check_supported(engine))
>  		return ERR_PTR(-EOPNOTSUPP);
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 9dd835dba2a7..1f52e82e3e1c 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>  			 const struct blk_crypto_key *bkey,
>  			 u8 data_unit_size, int slot);
>  int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>  struct qcom_ice *of_qcom_ice_get(struct device *dev);
>  #endif /* __QCOM_ICE_H__ */
> -- 
> 2.25.1
> 
> 

