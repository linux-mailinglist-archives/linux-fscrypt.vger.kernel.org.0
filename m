Return-Path: <linux-fscrypt+bounces-328-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6AE927723
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2024 15:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2193A2815A5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2024 13:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278921AE85D;
	Thu,  4 Jul 2024 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xPK6/BPS"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0A1ACE62
	for <linux-fscrypt@vger.kernel.org>; Thu,  4 Jul 2024 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720099579; cv=none; b=hjWtsMKa1Uzay3oo1yfRkyPKc1jkLV3ai6ct09lK6C3AsO3kjqLzza/mpwa7/j192k+3mip4/q0WeuiflTkttdaqFWWbaCr0vZJGcmjSLh66QdthDKmuyv8XqzrH1QYSubH4z+EItlhOGIDwyNjLY2MAxbkVHKPDPw2hWmCp+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720099579; c=relaxed/simple;
	bh=6KE36sYsIPrhU1snmLsl5853/tRFRTAQdUtKyGHqJ3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qH4pfL3s8lZPxnkBG8XQK6iST8iAtpcSQeUPEQ1oUhGQu/Zjn9juHru+gAM81Y381bIa5Nnr+CBArUUfZccuLm0R3IpDEARQsYAOdpZA93DGKONj5DLNSMnRDKJwxx1su5FF4WbzO2tj01Zno2BDGtgmMk1odyn4fDyNzBG7UVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xPK6/BPS; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5c47ad9967cso325496eaf.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2024 06:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720099576; x=1720704376; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4+4WShCgGhWUJoyoAZy3V3wltgHAWP7TeUYDDY3MbU4=;
        b=xPK6/BPS0Gt+NL3I33NwVpsC12xWntG+8aBgIExevVtHmPx8baHlVuBtibv8Xxz5eB
         vi0CwTN72A17R65ejDBBM68aaoVHOdwfJZ0jQfkr+5U3EAYb7Rb4wE/RnIVwrzizfhiK
         5gIEtK3170gsKRIeArqf2DJKaGW0tee2PrNHrsRd+gKnrKtUfSaIgpF2hPPalq7y/2Q/
         QWYcuVbwaN1pQCxzwMZWvGLhcqVFHP7SWflD0HQ13e9NC3aSYgYw2TfzA/avxXES06u+
         Gtzn8R+c6DQepUFrDT2XPHidE8EVPaBY8rn0so7N6ix9+RAYK9016agjrTdgF4C2UScb
         Acuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720099576; x=1720704376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+4WShCgGhWUJoyoAZy3V3wltgHAWP7TeUYDDY3MbU4=;
        b=VzjuPTQ0311jHKY8LLwAa5TG2DVJeI7/fBdo/+TndgoV1LZhuvxUDf/t4uYi/WUbgu
         r60Yn8zMUhe+KudnEBx0wHxuK19Df48/lLqr7muGIgfHnF3U+7ue3x1YH+1spKt3k3WG
         +1sjzmPbj0WV6iK5fua7tdwnGpMXoBXLgMQplF/+DWFxBccFPerFc0GLW0uQzh69FDHE
         3u5CcWAhhenEE4WFjOdg2jDgIypDYef/B1dSt2RpA9sdSy2OHUZ/5VjN2OhYPwkme6rh
         +yjHTftrAIRgBM4RmVp0DkMUivP8pV6lrRBU14gMWxctgXUkWFPhGxFrBFTNzaD5PzqH
         Orew==
X-Forwarded-Encrypted: i=1; AJvYcCXbaKqxBsccksOGKYbaqNzcRbQ33d1+THYRLOxxot0jqvpoMhHHI+/WTCPy9qULDxc5gdp1CV6qY0+T6EZGVT7P+6Eb5RhsmZJa9uY0bg==
X-Gm-Message-State: AOJu0YzDhRatHRTar6yE7rtZM84LKm9vSUXNB0K5xLQWurHhBSSNRZVc
	37CnEBha5v0e/uPB7WRpCNoBBN26Yen+cW0VnMcatwgweySFYBl7teN+q5xtVhjmrqt3EFo/Zai
	kSDT6CEzkMPP3wqhVlJW1EIZAZ+bny6A9YqGDXQ==
X-Google-Smtp-Source: AGHT+IHNOzppQBMIFNBfAhjmhqm5j30FIyzr+PKbgP+CO8B6eDJXi+MpFuJ9ilhBNnPP/bTnrmBOj8I4qCtkXH7n5Vs=
X-Received: by 2002:a4a:54c4:0:b0:5ba:f20c:3629 with SMTP id
 006d021491bc7-5c646f35f57mr1595882eaf.4.1720099576204; Thu, 04 Jul 2024
 06:26:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-7-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-7-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Thu, 4 Jul 2024 14:26:05 +0100
Message-ID: <CADrjBPoWVq-eu4Wa6_hrkk067tnZGC82UCJDyjSRGoG254w6vg@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

Thanks for your contribution, it's great to see new features like this
being posted upstream for gs101 :)

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.
>
> Specifically, add support for the "traditional FMP mode" that works on
> many Exynos-based SoCs including gs101.  This is the mode that uses
> "software keys" and is compatible with the upstream kernel's existing
> inline encryption framework in the block and filesystem layers.  I plan
> to add support for the wrapped key support on gs101 at a later time.
>
> Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/ufs/host/ufs-exynos.c | 228 +++++++++++++++++++++++++++++++++-
>  1 file changed, 222 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 88d125d1ee3c..dd545ef7c361 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -6,10 +6,13 @@
>   * Author: Seungwon Jeon  <essuuj@gmail.com>
>   * Author: Alim Akhtar <alim.akhtar@samsung.com>
>   *
>   */
>
> +#include <asm/unaligned.h>
> +#include <crypto/aes.h>
> +#include <linux/arm-smccc.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> @@ -23,16 +26,18 @@
>  #include <ufs/ufshci.h>
>  #include <ufs/unipro.h>
>
>  #include "ufs-exynos.h"
>
> +#define DATA_UNIT_SIZE         4096
> +#define LOG2_DATA_UNIT_SIZE    12
> +
>  /*
>   * Exynos's Vendor specific registers for UFSHCI
>   */
>  #define HCI_TXPRDT_ENTRY_SIZE  0x00
>  #define PRDT_PREFECT_EN                BIT(31)
> -#define PRDT_SET_SIZE(x)       ((x) & 0x1F)
>  #define HCI_RXPRDT_ENTRY_SIZE  0x04
>  #define HCI_1US_TO_CNT_VAL     0x0C
>  #define CNT_VAL_1US_MASK       0x3FF
>  #define HCI_UTRL_NEXUS_TYPE    0x40
>  #define HCI_UTMRL_NEXUS_TYPE   0x44
> @@ -1041,12 +1046,12 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
>
>         exynos_ufs_establish_connt(ufs);
>         exynos_ufs_fit_aggr_timeout(ufs);
>
>         hci_writel(ufs, 0xa, HCI_DATA_REORDER);
> -       hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
> -       hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
> +       hci_writel(ufs, LOG2_DATA_UNIT_SIZE, HCI_TXPRDT_ENTRY_SIZE);
> +       hci_writel(ufs, LOG2_DATA_UNIT_SIZE, HCI_RXPRDT_ENTRY_SIZE);
>         hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
>         hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
>         hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
>
>         if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
> @@ -1149,10 +1154,218 @@ static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
>                 ufs->rx_sel_idx = 0;
>         hba->priv = (void *)ufs;
>         hba->quirks = ufs->drv_data->quirks;
>  }
>
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +
> +/*
> + * Support for Flash Memory Protector (FMP), which is the inline encryption
> + * hardware on Exynos and Exynos-based SoCs.  The interface to this hardware is
> + * not compatible with the standard UFS crypto.  It requires that encryption be
> + * configured in the PRDT using a nonstandard extension.
> + */
> +
> +enum fmp_crypto_algo_mode {
> +       FMP_BYPASS_MODE = 0,
> +       FMP_ALGO_MODE_AES_CBC = 1,
> +       FMP_ALGO_MODE_AES_XTS = 2,
> +};
> +enum fmp_crypto_key_length {
> +       FMP_KEYLEN_256BIT = 1,
> +};
> +
> +/**
> + * struct fmp_sg_entry - nonstandard format of PRDT entries when FMP is enabled
> + *
> + * @base: The standard PRDT entry, but with nonstandard bitfields in the high
> + *     bits of the 'size' field, i.e. the last 32-bit word.  When these
> + *     nonstandard bitfields are zero, the data segment won't be encrypted or
> + *     decrypted.  Otherwise they specify the algorithm and key length with
> + *     which the data segment will be encrypted or decrypted.
> + * @file_iv: The initialization vector (IV) with all bytes reversed
> + * @file_enckey: The first half of the AES-XTS key with all bytes reserved
> + * @file_twkey: The second half of the AES-XTS key with all bytes reserved
> + * @disk_iv: Unused
> + * @reserved: Unused
> + */
> +struct fmp_sg_entry {
> +       struct ufshcd_sg_entry base;
> +       __be64 file_iv[2];
> +       __be64 file_enckey[4];
> +       __be64 file_twkey[4];
> +       __be64 disk_iv[2];
> +       __be64 reserved[2];
> +};
> +
> +#define SMC_CMD_FMP_SECURITY   \
> +       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
> +                          ARM_SMCCC_OWNER_SIP, 0x1810)
> +#define SMC_CMD_SMU            \
> +       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
> +                          ARM_SMCCC_OWNER_SIP, 0x1850)
> +#define SMC_CMD_FMP_SMU_RESUME \
> +       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
> +                          ARM_SMCCC_OWNER_SIP, 0x1860)
> +#define SMU_EMBEDDED                   0
> +#define SMU_INIT                       0
> +#define CFG_DESCTYPE_3                 3
> +
> +static void exynos_ufs_fmp_init(struct ufs_hba *hba)
> +{
> +       struct blk_crypto_profile *profile = &hba->crypto_profile;
> +       struct arm_smccc_res res;
> +       int err;
> +
> +       /*
> +        * Check for the standard crypto support bit, since it's available even
> +        * though the rest of the interface to FMP is nonstandard.
> +        *
> +        * This check should have the effect of preventing the driver from
> +        * trying to use FMP on old Exynos SoCs that don't have FMP.
> +        */
> +       if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
> +             MASK_CRYPTO_SUPPORT))
> +               return;
> +

Do you know how these FMP registers (FMPSECURITY0 etc) relate to the
UFSPR* registers set in the existing exynos_ufs_config_smu()? The
UFS_LINK spec talks about UFSPR(FMP), so I had assumed the FMP support
would be writing these same registers but via SMC call.

I think by the looks of things

#define UFSPRSECURITY 0x010
#define UFSPSBEGIN0 0x200
#define UFSPSEND0 0x204
#define UFSPSLUN0 0x208
#define UFSPSCTRL0 0x20C

relates to the following registers in gs101 spec

FMPSECURITY0 0x0010
FMPSBEGIN0 0x2000
FMPSEND0 0x2004
FMPSLUN0 0x2008
FMPSCTRL0 0x200C

And the SMC calls your calling set those same registers as
exynos_ufs_config_smu() function. Although it is hard to be certain as
I don't have access to the firmware code. Certainly the comment below
about FMPSECURITY0 implies that :)

With that in mind I think exynos_ufs_fmp_init() function in this patch
needs to be better integrated with the EXYNOS_UFS_OPT_UFSPR_SECURE
flag and the existing exynos_ufs_config_smu() function that is
currently just disabling decryption on platforms where it can access
the UFSPR(FMP) regs via mmio.

Thanks,

Peter

p.s. Also whilst reviewing this I noticed a bug where I don't check
EXYNOS_UFS_OPT_UFSPR_SECURE flag in exynos_ufs_resume() before calling
exynos_ufs_config_smu(). I'll send a patch to fix that.

[..]

