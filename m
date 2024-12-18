Return-Path: <linux-fscrypt+bounces-575-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3B69F7CA4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Dec 2024 14:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66BB616C410
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Dec 2024 13:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11163225772;
	Thu, 19 Dec 2024 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sUHdSiUH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA80122576A
	for <linux-fscrypt@vger.kernel.org>; Thu, 19 Dec 2024 13:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734616131; cv=none; b=V9pwzYhSulJyD8s9yetlBwvtLV183yb5rrY90qWEyHq5GLRlEA4LCSFY7zNF5ySGWeiIyow/BUigIVB8kUku8byR3uINrZzTQckvPxjJCHaAdzfZGUGxJgnjVC2b3KLUE3u7ffLI5zYw7ldGC5EGOgI2qI9SrZr3JwalV9TuWlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734616131; c=relaxed/simple;
	bh=sahhmOB/L93DxUlxEH50L3Z1bk881nM3T+bWQjC7PFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bvRLgs4ljnaY7UELbdq6g3T3n4mvj4pchodGM6z3EHjUX9hIAfnbDiRDfmEcdf7PaEV6Z+8iQEYpFiCoTfcTZqs70fQyFlQBhng+NOwUOLLn5yuo1p8nDirlsTvEuJNLS7QuSWR/LKV8ag5136v5qvw9PIVHwhGIvcp+WYrSdqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sUHdSiUH; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e3c8f39cab1so648814276.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 19 Dec 2024 05:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734616128; x=1735220928; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9/oPhJKsqUFgIAKQVmgKj7TTGgtA7Tgbo3jvbs+K6JE=;
        b=sUHdSiUHdhJA8Pn+UXQHQnhxpUJAaNLoqkU3hq348d8wXXnrJyurbTkSrrck2U23Dt
         +riXjlY6VwZ/zd3vdT/Yx9YnxA5DEswor2zH75acGWhON+VM1AZHy23b1wL9GUvXSFtD
         wdlzm2kFDAfNF1UId03AjHMOzqtgl0Qv/4wOSkDLOjneHigtTjdodPGoL2fPjPUEKWIN
         zEoMc6R1gCveiGiZi63AByI8YRUstnnjEHYinYype9726YQ1Gcd9dQsI9cPSFWkRfpRP
         rcU4TAv5nzU0scliy3z6zt3PV8MU52tB4l/I5jGdKhSAVcXVNHt8d+TrcFJf2XdEVBLc
         H+VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734616128; x=1735220928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9/oPhJKsqUFgIAKQVmgKj7TTGgtA7Tgbo3jvbs+K6JE=;
        b=GBL5QX1INWhUS3X20lj9Jk1WwSgEnQT0MCK0cn0GcINt8Rq6K1om4Ow2OtPNq1Nu3S
         6GExPopkPnSz0wkMB3EhS7Wu8bY1xjoylTw5SmzE8PFQiQFVMP7CXJrxuH4AcYjU8Cwx
         OOMEVQMs/PjfyBCpnTPfF0X4JZEnagi7fze5Q0o5xL43A+XjgVo2ppCxrEIfuJJnETBT
         K16mM9JhYYs29/6pjUcpa9EjwHQmcIP8XdgYA3VzlI2UUTB5NAbPw0h6spb8c+JKA+I5
         9V0i4Hn4VVc+2i/jfBbSGuBUfxyBszyFb7p+rcGl3pqAAp8O3uEt+U3i+YVbxwXpY8Su
         ZkUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQayCEfrBpOwslHo3CT4lDZD/ZpmYJScwRWKtuEERU8LocC63LE5nvdMx+vl6t+gIpGe1CvHVDD8O+1C5U@vger.kernel.org
X-Gm-Message-State: AOJu0YxZjjNu13b47v0+mV7KRVzbrzQLOsOa+NnrHEheXQj8YuhR9dVS
	AV0Pcbo674Guu4Y3S1NJgI37KZ3vdzPD/K9Tea2ah7dmrNg0GOSrDrOmdPetXESWL4XTFoyVYwA
	BMYTxkX22jtHzMcsn8R+OE+dFLa5PtW19khRLXQ==
X-Gm-Gg: ASbGncuPjp4m8vin5KlyhlyHx2tM0QRo6XVyvCiCsBd8tk2AFLw1yhnDmQYz0eBI2Ni
	zHC0Q25ybtNBYnRwByGQ21C3h+uZydblLPHdDA98=
X-Google-Smtp-Source: AGHT+IEL6+x5PDw1SNoOjHOHyS6xS4ms/4nC8sKsqaKP4OKhBDk2JVPqXDkWfwWPbWyA+4ai6GVf5aMOhYgqUQZLN0o=
X-Received: by 2002:a25:2e41:0:b0:e38:9227:bf06 with SMTP id
 3f1490d57ef6-e5376537618mr2906083276.2.1734616127811; Thu, 19 Dec 2024
 05:48:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213041958.202565-1-ebiggers@kernel.org> <20241213041958.202565-8-ebiggers@kernel.org>
In-Reply-To: <20241213041958.202565-8-ebiggers@kernel.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 19 Dec 2024 14:48:11 +0100
Message-ID: <CAPDyKFoE5Rq5Kw6+X4fTu0g=yfw5znNkA5GDaZi6c=UW82VWUw@mail.gmail.com>
Subject: Re: [PATCH v10 07/15] mmc: sdhci-msm: convert to use custom crypto profile
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Gaurav Kashyap <quic_gaurkash@quicinc.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bjorn Andersson <andersson@kernel.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, 
	Konrad Dybcio <konradybcio@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Dec 2024 at 05:20, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> As is being done in ufs-qcom, make the sdhci-msm driver override the
> full crypto profile rather than "just" key programming and eviction.
> This makes it much more straightforward to add support for
> hardware-wrapped inline encryption keys.  It also makes it easy to pass
> the original blk_crypto_key down to qcom_ice_program_key() once it is
> updated to require the key in that form.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied for next, thanks!

Kind regards
Uffe


> ---
>  drivers/mmc/host/cqhci-crypto.c | 33 ++++++------
>  drivers/mmc/host/cqhci.h        |  8 ++-
>  drivers/mmc/host/sdhci-msm.c    | 94 ++++++++++++++++++++++++++-------
>  3 files changed, 94 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
> index 2951911d3f78..cb8044093402 100644
> --- a/drivers/mmc/host/cqhci-crypto.c
> +++ b/drivers/mmc/host/cqhci-crypto.c
> @@ -26,20 +26,17 @@ static inline struct cqhci_host *
>  cqhci_host_from_crypto_profile(struct blk_crypto_profile *profile)
>  {
>         return mmc_from_crypto_profile(profile)->cqe_private;
>  }
>
> -static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
> -                                   const union cqhci_crypto_cfg_entry *cfg,
> -                                   int slot)
> +static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
> +                                    const union cqhci_crypto_cfg_entry *cfg,
> +                                    int slot)
>  {
>         u32 slot_offset = cq_host->crypto_cfg_register + slot * sizeof(*cfg);
>         int i;
>
> -       if (cq_host->ops->program_key)
> -               return cq_host->ops->program_key(cq_host, cfg, slot);
> -
>         /* Clear CFGE */
>         cqhci_writel(cq_host, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
>
>         /* Write the key */
>         for (i = 0; i < 16; i++) {
> @@ -50,11 +47,10 @@ static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
>         cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[17]),
>                      slot_offset + 17 * sizeof(cfg->reg_val[0]));
>         /* Write dword 16, which includes the new value of CFGE */
>         cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[16]),
>                      slot_offset + 16 * sizeof(cfg->reg_val[0]));
> -       return 0;
>  }
>
>  static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
>                                         const struct blk_crypto_key *key,
>                                         unsigned int slot)
> @@ -67,11 +63,10 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
>                         &cqhci_crypto_algs[key->crypto_cfg.crypto_mode];
>         u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
>         int i;
>         int cap_idx = -1;
>         union cqhci_crypto_cfg_entry cfg = {};
> -       int err;
>
>         BUILD_BUG_ON(CQHCI_CRYPTO_KEY_SIZE_INVALID != 0);
>         for (i = 0; i < cq_host->crypto_capabilities.num_crypto_cap; i++) {
>                 if (ccap_array[i].algorithm_id == alg->alg &&
>                     ccap_array[i].key_size == alg->key_size &&
> @@ -94,25 +89,26 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
>                        key->raw + key->size/2, key->size/2);
>         } else {
>                 memcpy(cfg.crypto_key, key->raw, key->size);
>         }
>
> -       err = cqhci_crypto_program_key(cq_host, &cfg, slot);
> +       cqhci_crypto_program_key(cq_host, &cfg, slot);
>
>         memzero_explicit(&cfg, sizeof(cfg));
> -       return err;
> +       return 0;
>  }
>
>  static int cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
>  {
>         /*
>          * Clear the crypto cfg on the device. Clearing CFGE
>          * might not be sufficient, so just clear the entire cfg.
>          */
>         union cqhci_crypto_cfg_entry cfg = {};
>
> -       return cqhci_crypto_program_key(cq_host, &cfg, slot);
> +       cqhci_crypto_program_key(cq_host, &cfg, slot);
> +       return 0;
>  }
>
>  static int cqhci_crypto_keyslot_evict(struct blk_crypto_profile *profile,
>                                       const struct blk_crypto_key *key,
>                                       unsigned int slot)
> @@ -165,20 +161,22 @@ cqhci_find_blk_crypto_mode(union cqhci_crypto_cap_entry cap)
>  int cqhci_crypto_init(struct cqhci_host *cq_host)
>  {
>         struct mmc_host *mmc = cq_host->mmc;
>         struct device *dev = mmc_dev(mmc);
>         struct blk_crypto_profile *profile = &mmc->crypto_profile;
> -       unsigned int num_keyslots;
>         unsigned int cap_idx;
>         enum blk_crypto_mode_num blk_mode_num;
>         unsigned int slot;
>         int err = 0;
>
>         if (!(mmc->caps2 & MMC_CAP2_CRYPTO) ||
>             !(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
>                 goto out;
>
> +       if (cq_host->ops->uses_custom_crypto_profile)
> +               goto profile_initialized;
> +
>         cq_host->crypto_capabilities.reg_val =
>                         cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
>
>         cq_host->crypto_cfg_register =
>                 (u32)cq_host->crypto_capabilities.config_array_ptr * 0x100;
> @@ -193,13 +191,12 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>
>         /*
>          * CCAP.CFGC is off by one, so the actual number of crypto
>          * configurations (a.k.a. keyslots) is CCAP.CFGC + 1.
>          */
> -       num_keyslots = cq_host->crypto_capabilities.config_count + 1;
> -
> -       err = devm_blk_crypto_profile_init(dev, profile, num_keyslots);
> +       err = devm_blk_crypto_profile_init(
> +               dev, profile, cq_host->crypto_capabilities.config_count + 1);
>         if (err)
>                 goto out;
>
>         profile->ll_ops = cqhci_crypto_ops;
>         profile->dev = dev;
> @@ -223,13 +220,15 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
>                         continue;
>                 profile->modes_supported[blk_mode_num] |=
>                         cq_host->crypto_cap_array[cap_idx].sdus_mask * 512;
>         }
>
> +profile_initialized:
> +
>         /* Clear all the keyslots so that we start in a known state. */
> -       for (slot = 0; slot < num_keyslots; slot++)
> -               cqhci_crypto_clear_keyslot(cq_host, slot);
> +       for (slot = 0; slot < profile->num_slots; slot++)
> +               profile->ll_ops.keyslot_evict(profile, NULL, slot);
>
>         /* CQHCI crypto requires the use of 128-bit task descriptors. */
>         cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
>
>         return 0;
> diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
> index fab9d74445ba..ce189a1866b9 100644
> --- a/drivers/mmc/host/cqhci.h
> +++ b/drivers/mmc/host/cqhci.h
> @@ -287,17 +287,15 @@ struct cqhci_host_ops {
>         void (*disable)(struct mmc_host *mmc, bool recovery);
>         void (*update_dcmd_desc)(struct mmc_host *mmc, struct mmc_request *mrq,
>                                  u64 *data);
>         void (*pre_enable)(struct mmc_host *mmc);
>         void (*post_disable)(struct mmc_host *mmc);
> -#ifdef CONFIG_MMC_CRYPTO
> -       int (*program_key)(struct cqhci_host *cq_host,
> -                          const union cqhci_crypto_cfg_entry *cfg, int slot);
> -#endif
>         void (*set_tran_desc)(struct cqhci_host *cq_host, u8 **desc,
>                               dma_addr_t addr, int len, bool end, bool dma64);
> -
> +#ifdef CONFIG_MMC_CRYPTO
> +       bool uses_custom_crypto_profile;
> +#endif
>  };
>
>  static inline void cqhci_writel(struct cqhci_host *host, u32 val, int reg)
>  {
>         if (unlikely(host->ops->write_l))
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 319f0ebbe652..4610f067faca 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1805,16 +1805,23 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
>   *                                                                           *
>  \*****************************************************************************/
>
>  #ifdef CONFIG_MMC_CRYPTO
>
> +static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
> +
>  static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>                               struct cqhci_host *cq_host)
>  {
>         struct mmc_host *mmc = msm_host->mmc;
> +       struct blk_crypto_profile *profile = &mmc->crypto_profile;
>         struct device *dev = mmc_dev(mmc);
>         struct qcom_ice *ice;
> +       union cqhci_crypto_capabilities caps;
> +       union cqhci_crypto_cap_entry cap;
> +       int err;
> +       int i;
>
>         if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
>                 return 0;
>
>         ice = of_qcom_ice_get(dev);
> @@ -1825,12 +1832,41 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>
>         if (IS_ERR_OR_NULL(ice))
>                 return PTR_ERR_OR_ZERO(ice);
>
>         msm_host->ice = ice;
> -       mmc->caps2 |= MMC_CAP2_CRYPTO;
>
> +       /* Initialize the blk_crypto_profile */
> +
> +       caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
> +
> +       /* The number of keyslots supported is (CFGC+1) */
> +       err = devm_blk_crypto_profile_init(dev, profile, caps.config_count + 1);
> +       if (err)
> +               return err;
> +
> +       profile->ll_ops = sdhci_msm_crypto_ops;
> +       profile->max_dun_bytes_supported = 4;
> +       profile->dev = dev;
> +
> +       /*
> +        * Currently this driver only supports AES-256-XTS.  All known versions
> +        * of ICE support it, but to be safe make sure it is really declared in
> +        * the crypto capability registers.  The crypto capability registers
> +        * also give the supported data unit size(s).
> +        */
> +       for (i = 0; i < caps.num_crypto_cap; i++) {
> +               cap.reg_val = cpu_to_le32(cqhci_readl(cq_host,
> +                                                     CQHCI_CRYPTOCAP +
> +                                                     i * sizeof(__le32)));
> +               if (cap.algorithm_id == CQHCI_CRYPTO_ALG_AES_XTS &&
> +                   cap.key_size == CQHCI_CRYPTO_KEY_SIZE_256)
> +                       profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] |=
> +                               cap.sdus_mask * 512;
> +       }
> +
> +       mmc->caps2 |= MMC_CAP2_CRYPTO;
>         return 0;
>  }
>
>  static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
>  {
> @@ -1852,39 +1888,59 @@ static __maybe_unused int sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
>                 return qcom_ice_suspend(msm_host->ice);
>
>         return 0;
>  }
>
> -/*
> - * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requires
> - * vendor-specific SCM calls for this; it doesn't support the standard way.
> - */
> -static int sdhci_msm_program_key(struct cqhci_host *cq_host,
> -                                const union cqhci_crypto_cfg_entry *cfg,
> -                                int slot)
> +static inline struct sdhci_msm_host *
> +sdhci_msm_host_from_crypto_profile(struct blk_crypto_profile *profile)
>  {
> -       struct sdhci_host *host = mmc_priv(cq_host->mmc);
> +       struct mmc_host *mmc = mmc_from_crypto_profile(profile);
> +       struct sdhci_host *host = mmc_priv(mmc);
>         struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>         struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
> -       union cqhci_crypto_cap_entry cap;
>
> -       if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
> -               return qcom_ice_evict_key(msm_host->ice, slot);
> +       return msm_host;
> +}
> +
> +/*
> + * Program a key into a QC ICE keyslot.  QC ICE requires a QC-specific SCM call
> + * for this; it doesn't support the standard way.
> + */
> +static int sdhci_msm_ice_keyslot_program(struct blk_crypto_profile *profile,
> +                                        const struct blk_crypto_key *key,
> +                                        unsigned int slot)
> +{
> +       struct sdhci_msm_host *msm_host =
> +               sdhci_msm_host_from_crypto_profile(profile);
>
>         /* Only AES-256-XTS has been tested so far. */
> -       cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
> -       if (cap.algorithm_id != CQHCI_CRYPTO_ALG_AES_XTS ||
> -               cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256)
> -               return -EINVAL;
> +       if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
> +               return -EOPNOTSUPP;
>
>         return qcom_ice_program_key(msm_host->ice,
>                                     QCOM_ICE_CRYPTO_ALG_AES_XTS,
>                                     QCOM_ICE_CRYPTO_KEY_SIZE_256,
> -                                   cfg->crypto_key,
> -                                   cfg->data_unit_size, slot);
> +                                   key->raw,
> +                                   key->crypto_cfg.data_unit_size / 512,
> +                                   slot);
>  }
>
> +static int sdhci_msm_ice_keyslot_evict(struct blk_crypto_profile *profile,
> +                                      const struct blk_crypto_key *key,
> +                                      unsigned int slot)
> +{
> +       struct sdhci_msm_host *msm_host =
> +               sdhci_msm_host_from_crypto_profile(profile);
> +
> +       return qcom_ice_evict_key(msm_host->ice, slot);
> +}
> +
> +static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops = {
> +       .keyslot_program        = sdhci_msm_ice_keyslot_program,
> +       .keyslot_evict          = sdhci_msm_ice_keyslot_evict,
> +};
> +
>  #else /* CONFIG_MMC_CRYPTO */
>
>  static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>                                      struct cqhci_host *cq_host)
>  {
> @@ -1986,11 +2042,11 @@ static void sdhci_msm_set_timeout(struct sdhci_host *host, struct mmc_command *c
>
>  static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
>         .enable         = sdhci_msm_cqe_enable,
>         .disable        = sdhci_msm_cqe_disable,
>  #ifdef CONFIG_MMC_CRYPTO
> -       .program_key    = sdhci_msm_program_key,
> +       .uses_custom_crypto_profile = true,
>  #endif
>  };
>
>  static int sdhci_msm_cqe_add_host(struct sdhci_host *host,
>                                 struct platform_device *pdev)
> --
> 2.47.1
>

