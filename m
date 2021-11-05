Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30154445CEA
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Nov 2021 01:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbhKEALF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 20:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232040AbhKEALE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 20:11:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA8AF61213;
        Fri,  5 Nov 2021 00:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636070905;
        bh=o7fFEo7v95r3iaFFPQHwPY1pIQpE9DbEFCqQaOJe6Lw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfTCFDU4zWT1NbEWL4TbXNmTbeYHhbEpOvZnCEgSFp1XjOi+oe8VVSXRRwecpV8yc
         6UGhRvK1ypR4w8u5zjLj4qClt2sJTiYOVEtCjxRhI6uPHilBxNGTjnzq2a3DKNUIUu
         IOGSrUNFLvydShYxr1XPzSK7+k2VVWFE+fsv/moiZVf/0FQPdnPzF55b/5ZqgdWj73
         iz7vhHFqILa/+NpK3Ho77WNPSFMc+zY4t1gwgmG34jf+Evis8AcJqJdX5u01ujWxf0
         lxVYYQ+mR0XdkvP9U8OvCZmQ4p2rZq4AV8zY1wSNt2mvsEMN5gJ6JfA6BSpe0yDtKt
         fLzIbRnWuwM7g==
Date:   Thu, 4 Nov 2021 17:08:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        asutoshd@codeaurora.org
Subject: Re: [PATCH 4/4] soc: qcom: add wrapped key support for ICE
Message-ID: <YYR1+LgBnSQ+pVhr@gmail.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <20211103231840.115521-5-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103231840.115521-5-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 03, 2021 at 04:18:40PM -0700, Gaurav Kashyap wrote:
> Add support for wrapped keys in ufs and common ICE library.
> Qualcomm's ICE solution uses a hardware block called Hardware
> Key Manager (HWKM) to handle wrapped keys.
> 
> This patch adds the following changes to support this.
> 1. Link to HWKM library for initialization.
> 2. Most of the key management is done from Trustzone via scm calls.
>    Added calls to this from the ICE library.
> 3. Added support for this framework in UFS.
> 4. Added support for deriving SW secret as it cannot be done in
>    linux kernel for wrapped keys.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/scsi/ufs/ufs-qcom-ice.c   |  34 +++++++++-
>  drivers/scsi/ufs/ufs-qcom.c       |   1 +
>  drivers/scsi/ufs/ufs-qcom.h       |   5 ++
>  drivers/scsi/ufs/ufshcd-crypto.c  |  47 ++++++++++---
>  drivers/scsi/ufs/ufshcd.h         |   5 ++
>  drivers/soc/qcom/qti-ice-common.c | 108 ++++++++++++++++++++++++++----
>  include/linux/qti-ice-common.h    |   7 +-
>  7 files changed, 180 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
> index 6608a9015eab..79d642190997 100644
> --- a/drivers/scsi/ufs/ufs-qcom-ice.c
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.c
> @@ -45,6 +45,21 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
>  	}
>  	mmio.ice_mmio = host->ice_mmio;
>  
> +#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice_hwkm");
> +	if (!res) {
> +		dev_warn(dev, "ICE HWKM registers not found\n");
> +		goto disable;
> +	}
> +
> +	host->ice_hwkm_mmio = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(host->ice_hwkm_mmio)) {
> +		err = PTR_ERR(host->ice_hwkm_mmio);
> +		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
> +		return err;
> +	}
> +	mmio.ice_hwkm_mmio = host->ice_hwkm_mmio;
> +#endif

The driver shouldn't completely disable ICE support just because HW wrapped keys
aren't supported by the hardware or by the device tree file.  Instead, it should
declare support for standard keys only.  I.e. CONFIG_QTI_HW_WRAPPED_KEYS
shouldn't force the use of HW wrapped keys, it should just add support for them.

> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index 0ed82741f981..965a8cc6c183 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c

ufshcd-crypto.c is part of ufshcd-core, not ufs_qcom.  It should be changed in a
separate patch.

> @@ -18,6 +18,7 @@ static const struct ufs_crypto_alg_entry {
>  };
>  
>  static int ufshcd_program_key(struct ufs_hba *hba,
> +				  const struct blk_crypto_key *key,
>  			      const union ufs_crypto_cfg_entry *cfg, int slot)
>  {
>  	int i;
> @@ -27,7 +28,7 @@ static int ufshcd_program_key(struct ufs_hba *hba,
>  	ufshcd_hold(hba, false);
>  
>  	if (hba->vops && hba->vops->program_key) {
> -		err = hba->vops->program_key(hba, cfg, slot);
> +		err = hba->vops->program_key(hba, key, cfg, slot);
>  		goto out;
>  	}

vops->program_key shouldn't take in both a key and a cfg.  It should be just one
or the other.  'cfg' doesn't appear to work for HW wrapped keys, and it seems
the existing user doesn't really need a 'cfg' in the first place, so it would
have to be just 'key'.

> +#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)

As noted above, ufshcd-crypto isn't specific to ufs_qcom.  It therefore must not
contain references to CONFIG_QTI_HW_WRAPPED_KEYS, as that kconfig option is
specific to Qualcomm platforms.

> +static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
> +					 const u8 *wrapped_key,
> +					 unsigned int wrapped_key_size,
> +					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->derive_secret)
> +		return  hba->vops->derive_secret(wrapped_key,
> +							wrapped_key_size, sw_secret);
> +
> +	return 0;
> +}

The fallback case should return -EOPNOTSUPP, which indicates that the operation
is not supported, rather than 0 which indicates that it succeeded.

> @@ -190,7 +213,11 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>  	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
>  	/* UFS only supports 8 bytes for any DUN */
>  	hba->crypto_profile.max_dun_bytes_supported = 8;
> +#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
> +	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
> +#else
>  	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
> +#endif
>  	hba->crypto_profile.dev = hba->dev;

My comments from above apply to this too.  Checking a Qualcomm-specific kconfig
option isn't appropriate here.  Also the supported key types shouldn't be static
from the kconfig; they should be determined by the actual hardware capabilities.

Note that in the Android kernels, for the division of work between ufshcd-core
and host drivers, we ended up going with a solution where the UFS host drivers
can just override the whole blk_crypto_profile (previously called
blk_keyslot_manager).  You may have to do the same, although it would be
preferable to find a way to share more code.

Also, at runtime, does any of the Qualcomm hardware support multiple key types,
and if so can they be used at the same time?

- Eric
