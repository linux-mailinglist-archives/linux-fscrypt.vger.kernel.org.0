Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0FFB473A28
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 02:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbhLNB1A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 20:27:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56166 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbhLNB1A (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 20:27:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D226260C59;
        Tue, 14 Dec 2021 01:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC26BC34603;
        Tue, 14 Dec 2021 01:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639445219;
        bh=zt2+hoNU8j4WQtFz0q9MROR0AY43kdQuKz9CL7ydxVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B8rIu3TbaU6maI1aj3Yzxue/CVW0XFGU+qVNF/CcPZBp3oBxyKI7VOVptxuJpqtID
         jKtUV7wy45NY3Mieg4rqv0RXk/btJ0e9bewBRvXxe3f0p4lscNE6KPX72DvnXjdLN8
         icCA19cgAupf2UVXQ3e0Cc2V56xWcKMZ4aqDtrxr6OOXOawqulXRrwYHwxtx5Wi5Lz
         mSMpnumR5jLG+BvOJrixb4cdciGQ+86jwTMicdNWhMVKF4f9Mw+8pQmgOIXgNH4yOk
         TI4xnjVPrdfwl9NwRcH334+/0O8B+qN2eKMJg0tXUYVvmR1DYYrVJJUw8oth+Hvrxc
         3h2OP5Subd/ng==
Date:   Mon, 13 Dec 2021 17:26:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 05/10] scsi: ufs: prepare to support wrapped keys
Message-ID: <Ybfy4UQCi8RkkE2Y@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-6-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-6-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:20PM -0800, Gaurav Kashyap wrote:
> Adds support in ufshcd-core for wrapped keys.
> 1. Change program key vop to support wrapped key sizes by
>    using blk_crypto_key directly instead of using ufs_crypto_cfg
>    which is not suitable for wrapped keys.
> 2. Add derive_sw_secret vop and derive_sw_secret crypto_profile op.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 52 +++++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h        |  9 +++++-
>  2 files changed, 49 insertions(+), 12 deletions(-)

There will be a build error if the patch series is applied just up to here,
since this patch changes the prototype of ufs_hba_variant_ops::program_key but
doesn't update ufs_qcom which implements it.

Every intermediate step needs to be buildable, and that's more important than
keeping changes to different drivers separate.

So I recommend having one patch that does the program_key change, in both
ufshcd-crypto.c and ufs-qcom-ice.c.

Adding derive_sw_secret should be a separate patch, and maybe should be combined
with the other new methods.

> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
> index 0ed82741f981..9d68621a0eb4 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -18,16 +18,23 @@ static const struct ufs_crypto_alg_entry {
>  };
>  
>  static int ufshcd_program_key(struct ufs_hba *hba,
> +			      const struct blk_crypto_key *key,
>  			      const union ufs_crypto_cfg_entry *cfg, int slot)
>  {
>  	int i;
>  	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
>  	int err = 0;
> +	bool evict = false;
>  
>  	ufshcd_hold(hba, false);
>  
>  	if (hba->vops && hba->vops->program_key) {
> -		err = hba->vops->program_key(hba, cfg, slot);
> +		if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
> +			evict = true;
> +		err = hba->vops->program_key(hba, key, slot,
> +					     cfg->data_unit_size,
> +					     cfg->crypto_cap_idx,
> +					     evict);
>  		goto out;
>  	}

This is a little weird because here we've already gone through the trouble of
creating a 'union ufs_crypto_cfg_entry', only to throw it away in the
->program_key case and just use the original blk_crypto_key instead.

I think that this should be refactored a bit to make it so that a
'ufs_crypto_cfg_entry' is only be initialized if program_key is not implemented.

Also, note that 'struct blk_crypto_key' includes the data unit size.  So there's
no need to pass the data unit size as a separate argument to program_key.

> +static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
> +				const u8 *wrapped_key,
> +				unsigned int wrapped_key_size,
> +				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->derive_secret)
> +		return  hba->vops->derive_secret(hba, wrapped_key,
> +						 wrapped_key_size, sw_secret);

There's a weird double space here.

> @@ -190,7 +215,12 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
>  	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
>  	/* UFS only supports 8 bytes for any DUN */
>  	hba->crypto_profile.max_dun_bytes_supported = 8;
> -	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
> +	if (hba->hw_wrapped_keys_supported)
> +		hba->crypto_profile.key_types_supported =
> +				BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
> +	else
> +		hba->crypto_profile.key_types_supported =
> +				BLK_CRYPTO_KEY_TYPE_STANDARD;

"hw_wrapped_keys_supported" is confusing because it doesn't just mean that
wrapped keys are supported, but also that standard keys are *not* supported.
"use_hw_wrapped_keys" would be clearer.

However, given that wrapped keys aren't specified by the UFS standard, I think
this better belongs as a bit in hba->quirks, like
UFSHCD_QUIRK_USES_WRAPPED_CRYPTO_KEYS.

> +	int	(*derive_secret)(struct ufs_hba *hba, const u8 *wrapped_key,
> +				 unsigned int wrapped_key_size,
> +				 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);

This probably should be called derive_sw_secret, not just derive_secret.

- Eric
