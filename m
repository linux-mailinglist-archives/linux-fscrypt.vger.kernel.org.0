Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9432D3721
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Dec 2020 00:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgLHXs4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 18:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730264AbgLHXs4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 18:48:56 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA4AC061793
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 15:48:16 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id y8so158256plp.8
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 15:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FfUL0NQVwp+fYicHEXBFwaet5ZQ4vWJM8eE/XNqu1eg=;
        b=J+awbhWg7z6323slV5BG3qDxKE+JHIPokFgTa6uyI0YXngvDuz65CNS+J6bk4kLTvL
         hD19ArgbKemxNlJu0mrcpKKNpOwFJc4+JUjylxEIcr507m/uaYiVKEDRNV1c9U1p/0IN
         mc9kYVW8qhUuCqzUKBSNJ63WlAll/XVcP4CzYMmxvQZDkUFdQyKc9Y5IACITSd3yF/BF
         du76JnSlHDuoB5tMSLil0GD4aSbhqxw99Oi0UKsRokgUhrovbXbd2s6DxFD4ptF9F4Pi
         OehBPZRDrHfScri6BGphMHPLSf5Vrtcjo3/UIW6pgoRpk2SSN7TdgTbkHSmjA7ffvnyG
         t3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FfUL0NQVwp+fYicHEXBFwaet5ZQ4vWJM8eE/XNqu1eg=;
        b=un5h1Pzbyba1YzU1AA8zm2jJRrnsrKPQP3N9yPMz3gleLlARBnIvuN7PA9RQVyMbbf
         /PBpjaVTWxNA8Gpu2f6cPSz8+MacsSDLiBgv2UuKx07BkTS3RaRNx6QHbeq7NtfJDqus
         WtUUY3imnaicnJhuYNcM8ip3r9srNdFiGdQezTi1Gsgm8XeKgDJBKIXFspqzVLMflhPS
         +tn0fRhVZhE8Hy8qNmUzz8gei38qxfFHjk1CRUjnxQjALP98bBSg3fznLmUcch8sVIXT
         yU/FyFqmcvyxdxWF9CSgVi2Ap48VA67eQWjzc4nUNpEFTiWWY548zGIDBuIvyWLKL5NV
         SQ4g==
X-Gm-Message-State: AOAM533YRQOSaJpOn4bQV/8T80vINIAFtaGQ2KCNubKDY5p8BiJLOxXv
        5P0if+0jE7hhwqq0+RKWnJsW5g==
X-Google-Smtp-Source: ABdhPJxBxVxgIVYqLKZSO0W/cdIjRUFtpJCo23ZXLTFg0m9m7n+5B78wO6SZzQZ+n4pwJO/0kqE01g==
X-Received: by 2002:a17:902:ab8b:b029:da:f377:e7d7 with SMTP id f11-20020a170902ab8bb02900daf377e7d7mr429315plr.4.1607471295641;
        Tue, 08 Dec 2020 15:48:15 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id c6sm274883pjr.55.2020.12.08.15.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:48:15 -0800 (PST)
Date:   Tue, 8 Dec 2020 23:48:11 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
Subject: Re: [PATCH v2 5/9] mmc: cqhci: add cqhci_host_ops::program_key
Message-ID: <X9AQu2EhgG9znKY+@google.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203020516.225701-6-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 06:05:12PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On Snapdragon SoCs, the Linux kernel isn't permitted to directly access
> the standard CQHCI crypto configuration registers.  Instead, programming
> and evicting keys must be done through vendor-specific SMC calls.
> 
> To support this hardware, add a ->program_key() method to
> 'struct cqhci_host_ops'.  This allows overriding the standard CQHCI
> crypto key programming / eviction procedure.
> 
> This is inspired by the corresponding UFS crypto support, which uses
> these same SMC calls.  See commit 1bc726e26ef3 ("scsi: ufs: Add
> program_key() variant op").
> 
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/mmc/host/cqhci-crypto.c | 22 +++++++++++++---------
>  drivers/mmc/host/cqhci.h        |  4 ++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
> index 98f141c8480ce..0aaa948d240b1 100644
> --- a/drivers/mmc/host/cqhci-crypto.c
> +++ b/drivers/mmc/host/cqhci-crypto.c
> @@ -30,13 +30,16 @@ cqhci_host_from_ksm(struct blk_keyslot_manager *ksm)
>  	return mmc->cqe_private;
>  }
>  
> -static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
> -				     const union cqhci_crypto_cfg_entry *cfg,
> -				     int slot)
> +static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
> +				    const union cqhci_crypto_cfg_entry *cfg,
> +				    int slot)
>  {
>  	u32 slot_offset = cq_host->crypto_cfg_register + slot * sizeof(*cfg);
>  	int i;
>  
> +	if (cq_host->ops->program_key)
> +		return cq_host->ops->program_key(cq_host, cfg, slot);
> +
>  	/* Clear CFGE */
>  	cqhci_writel(cq_host, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
>  
> @@ -51,6 +54,7 @@ static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
>  	/* Write dword 16, which includes the new value of CFGE */
>  	cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[16]),
>  		     slot_offset + 16 * sizeof(cfg->reg_val[0]));
> +	return 0;
>  }
>  
>  static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
> @@ -67,6 +71,7 @@ static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
>  	int i;
>  	int cap_idx = -1;
>  	union cqhci_crypto_cfg_entry cfg = {};
> +	int err;
>  
>  	BUILD_BUG_ON(CQHCI_CRYPTO_KEY_SIZE_INVALID != 0);
>  	for (i = 0; i < cq_host->crypto_capabilities.num_crypto_cap; i++) {
> @@ -93,13 +98,13 @@ static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
>  		memcpy(cfg.crypto_key, key->raw, key->size);
>  	}
>  
> -	cqhci_crypto_program_key(cq_host, &cfg, slot);
> +	err = cqhci_crypto_program_key(cq_host, &cfg, slot);
>  
>  	memzero_explicit(&cfg, sizeof(cfg));
> -	return 0;
> +	return err;
>  }
>  
> -static void cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
> +static int cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
>  {
>  	/*
>  	 * Clear the crypto cfg on the device. Clearing CFGE
> @@ -107,7 +112,7 @@ static void cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
>  	 */
>  	union cqhci_crypto_cfg_entry cfg = {};
>  
> -	cqhci_crypto_program_key(cq_host, &cfg, slot);
> +	return cqhci_crypto_program_key(cq_host, &cfg, slot);
>  }
>  
>  static int cqhci_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
> @@ -116,8 +121,7 @@ static int cqhci_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
>  {
>  	struct cqhci_host *cq_host = cqhci_host_from_ksm(ksm);
>  
> -	cqhci_crypto_clear_keyslot(cq_host, slot);
> -	return 0;
> +	return cqhci_crypto_clear_keyslot(cq_host, slot);
>  }
>  
>  /*
> diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
> index 5c18734624fea..ece997dd8bcc7 100644
> --- a/drivers/mmc/host/cqhci.h
> +++ b/drivers/mmc/host/cqhci.h
> @@ -287,6 +287,10 @@ struct cqhci_host_ops {
>  				 u64 *data);
>  	void (*pre_enable)(struct mmc_host *mmc);
>  	void (*post_disable)(struct mmc_host *mmc);
> +#ifdef CONFIG_MMC_CRYPTO
> +	int (*program_key)(struct cqhci_host *cq_host,
> +			   const union cqhci_crypto_cfg_entry *cfg, int slot);
> +#endif
>  };
>  
>  static inline void cqhci_writel(struct cqhci_host *host, u32 val, int reg)
> -- 
> 2.29.2
> 
Looks good to me. Please feel free to add
Reviewed-by: Satya Tangirala <satyat@google.com>
