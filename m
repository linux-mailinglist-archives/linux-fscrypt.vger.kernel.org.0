Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64442CBE6E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 14:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgLBNf4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 08:35:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:57152 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgLBNfz (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 08:35:55 -0500
IronPort-SDR: FGjKr/T2llrCp7icYRxZU+ncfbhFRG+cx62lkw2TlKDtvfx0D3YLgHK3scgxtfk8PR4f5pFQR2
 h36EnFVXLYhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="237139830"
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="237139830"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 05:35:14 -0800
IronPort-SDR: 1B/SjGSXmQ/51T99gEuUdjHc3hS13q4zc2A1YmS8mPXtTMuDGX/5si/zMbCL0lOzSHDZsBOtai
 oVJNrZcV0iRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,386,1599548400"; 
   d="scan'208";a="315347349"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.94]) ([10.237.72.94])
  by fmsmga008.fm.intel.com with ESMTP; 02 Dec 2020 05:35:10 -0800
Subject: Re: [PATCH 4/8] mmc: cqhci: add cqhci_host_ops::program_key
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
 <20201112194011.103774-5-ebiggers@kernel.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e2fce27c-b36d-4585-30d0-c7f563f8455f@intel.com>
Date:   Wed, 2 Dec 2020 15:34:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201112194011.103774-5-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/11/20 9:40 pm, Eric Biggers wrote:
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
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/mmc/host/cqhci-crypto.c | 22 +++++++++++++---------
>  drivers/mmc/host/cqhci.h        |  4 ++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
> index b14a5a15f5b52..5e3488c19f70e 100644
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
>  static const struct blk_ksm_ll_ops cqhci_ksm_ops = {
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
> 

