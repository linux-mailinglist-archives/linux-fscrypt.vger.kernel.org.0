Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 626FD473A64
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 02:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbhLNBqE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 20:46:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLNBqE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 20:46:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB2DC061574;
        Mon, 13 Dec 2021 17:46:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 480E7612FA;
        Tue, 14 Dec 2021 01:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5B6C34603;
        Tue, 14 Dec 2021 01:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639446362;
        bh=xv+YpPoMpBN4sEvCWsTNaBxwORF/AuJ77rnCzmMAmPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SgADbkpgLh0RB7iBQynVwP+qXw8jW4PfjPSiX8RMdjuAELkZ3oC122ZWJGxTk3GfH
         2u3X7ZvZaxVmBSsOiSCttylw0xJ8kgEFHn01LU3qDEkGUzpYh2/TJzhqMM4UTQJAZN
         f6RVZorQSJ7lD/GldAR3Wdb2qbb7627htDMmbQPOm4Bx3FwkBCgRn3Ngojz3h41ok2
         XvHChM04bUGe7A7vHRL2uyUadazjsCrTOP4fWDwCTnqzmHzOId0OQmHiBLNtyHej6r
         mpCR1niiTgYpWxaPvyRu1R9fYepCJzEPQ/F57PkZskoC1CwNA9Ro+rSC+LOa9n+wNF
         8h8hcOTr//P/A==
Date:   Mon, 13 Dec 2021 17:46:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 06/10] soc: qcom: add wrapped key support for ICE
Message-ID: <Ybf3WOyhw+MXgXIm@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-7-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-7-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:21PM -0800, Gaurav Kashyap wrote:
> Add support for wrapped keys in ufs and common ICE library.
> Qualcomm's ICE solution uses a hardware block called Hardware
> Key Manager (HWKM) to handle wrapped keys.
> 
> This patch adds the following changes to support this.
> 1. Link to HWKM library for initialization.
> 2. Most of the key management is done from Trustzone via scm calls.
>    Added calls to this from the ICE library.
> 3. Added support for this framework in ufs qcom.
> 4. Added support for deriving SW secret as it cannot be done in
>    linux kernel for wrapped keys.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/scsi/ufs/ufs-qcom-ice.c   |  48 +++++++--
>  drivers/scsi/ufs/ufs-qcom.c       |   1 +
>  drivers/scsi/ufs/ufs-qcom.h       |   7 +-
>  drivers/soc/qcom/qti-ice-common.c | 158 +++++++++++++++++++++++++++---
>  include/linux/qti-ice-common.h    |  11 ++-
>  5 files changed, 198 insertions(+), 27 deletions(-)

If possible, the qti-ice-common changes should be a separate patch that goes
before the ufs-qcom changes.  Are there interdependencies that make this
impossible?  I see the prototype change in qti_ice_keyslot_evict() (see below),
but that could be avoided by using the right prototype from the beginning.

> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
> index 3826643bf537..c8305aab6714 100644
> --- a/drivers/scsi/ufs/ufs-qcom-ice.c
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.c
> @@ -43,6 +43,24 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>  		return err;
>  	}
>  
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice_hwkm");
> +	if (!res) {
> +		dev_warn(dev, "ICE HWKM registers not found\n");
> +		host->ice_data.hw_wrapped_keys_supported = false;
> +		goto init;
> +	}

I don't think a warning is appropriate here, as this is expected behavior on
SoCs that support standard keys rather than wrapped keys.

> +	host->ice_data.ice_hwkm_mmio = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(host->ice_data.ice_hwkm_mmio)) {
> +		err = PTR_ERR(host->ice_data.ice_hwkm_mmio);
> +		dev_err(dev, "Failed to map HWKM registers; err=%d\n", err);
> +		return err;
> +	}
> +	host->ice_data.hw_wrapped_keys_supported = true;

Similar to what I suggested on the previous patch: "hw_wrapped_keys_supported"
should be called something like "using_hw_wrapped_keys", since it means that
standard keys are *not* supported, not just that wrapped keys are supported.

>  int ufs_qcom_ice_program_key(struct ufs_hba *hba,
> -			     const union ufs_crypto_cfg_entry *cfg, int slot)
> +			     const struct blk_crypto_key *key, int slot,
> +			     u8 data_unit_size, int capid, bool evict)
>  {
>  	union ufs_crypto_cap_entry cap;
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  
> -	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
> -		return qti_ice_keyslot_evict(slot);
> +	if (evict)
> +		return qti_ice_keyslot_evict(&host->ice_data, slot);

It probably would be easier if qti_ice_keyslot_evict() took the ice_data
parameter from the beginning.  Then its prototype wouldn't need to change
halfway through the patch series.

>  static bool qti_ice_supported(const struct ice_mmio_data *mmio)
>  {
>  	u32 regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_VERSION);
> @@ -28,6 +45,11 @@ static bool qti_ice_supported(const struct ice_mmio_data *mmio)
>  		return false;
>  	}
>  
> +	if ((major >= 4) || ((major == 3) && (minor == 2) && (step >= 1)))
> +		hwkm_version = 2;
> +	else
> +		hwkm_version = 1;

Is this trying to check whether the ICE version is greater than or equal to
3.2.1?  If so, this isn't quite correct, as it doesn't handle 3.X correctly
where X is greater than 2.

> +	/*
> +	 * HWKM slave in ICE should be initialized before the first
> +	 * time we perform ICE HWKM related operations. This is because
> +	 * ICE by default comes up in legacy mode where HWKM operations
> +	 * won't work.
> +	 */
> +	if (!qti_hwkm_init_done) {
> +		err = qti_ice_hwkm_init(mmio, hwkm_version);
> +		if (err) {
> +			pr_err("%s: Error initializing hwkm, err = %d",
> +							__func__, err);
> +			return -EINVAL;
> +		}
> +		qti_hwkm_init_done = true;
> +	}

This code is duplicated in two places.  Can it be consolidated into a helper
function?  Also, "should be initialized" => "must be initialized"?

> +
> +	memset(&cfg, 0, sizeof(cfg));
> +	cfg.dusize = data_unit_mask;
> +	cfg.capidx = capid;
> +	cfg.cfge = 0x80;
> +
> +	/* Make sure CFGE is cleared */
> +	qti_ice_writel(mmio->ice_mmio, 0x0, (QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 +
> +				QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET*slot));
> +	/* Memory barrier - to ensure write completion before next transaction */
> +	wmb();

Is this memory barrier necessary only because writel_relaxed() is being used?
Using writel() would probably be a better idea, as I've mentioned elsewhere.

Also, what does a "transaction" mean in this context?

> +
> +	/* Call trustzone to program the wrapped key using hwkm */
> +	err =  qcom_scm_ice_set_key(slot, crypto_key->raw, crypto_key->size,
> +				    capid, data_unit_mask);

There's a weird double space here.

> +	if (err)
> +		pr_err("%s:SCM call Error: 0x%x slot %d\n",
> +					__func__, err, slot);
> +
> +	/* Make sure CFGE is enabled after programming the key */
> +	qti_ice_writel(mmio->ice_mmio, cfg.regval,
> +			(QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 +
> +			 QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET*slot));

Shouln't CFGE not be set on failure?

> +int qti_ice_keyslot_evict(const struct ice_mmio_data *mmio, unsigned int slot)
>  {
> +	/*
> +	 * Ignore calls to evict key when wrapped keys are supported and
> +	 * hwkm init is not yet done. This is to avoid the clearing all slots
> +	 * call that comes from ufs during ufs reset. HWKM slave in ICE takes
> +	 * care of zeroing out the keytable on reset.
> +	 */
> +	if (mmio->hw_wrapped_keys_supported && !qti_hwkm_init_done)
> +		return 0;

I guess this is reasonable.  (The alternative would be to not clear the keyslots
in the first place.)  But this is going to be used by MMC too, so the comment
should be worded in a generic way and not be tied to UFS.

> +/**
> + * qti_ice_derive_sw_secret() - Derive SW secret from wrapped key
> + * @wrapped_key: wrapped key from which secret should be derived
> + * @wrapped_key_size: size of the wrapped key
> + * @sw_secret: secret to be returned, which is atmost BLK_CRYPTO_SW_SECRET_SIZE

The resulting sw_secret needs to be *exactly* BLK_CRYPTO_SW_SECRET_SIZE bytes,
not "at most" that many bytes.

- Eric
