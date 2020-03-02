Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976181761C5
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Mar 2020 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgCBSCe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Mar 2020 13:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgCBSCe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Mar 2020 13:02:34 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05EF21D56;
        Mon,  2 Mar 2020 18:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583172153;
        bh=FtRqmbetKtzAhjYcG5f4Oa0sNs/qid5+5M0b5btzGXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aFeNoIFDszMPgvo966bttNOOPowGZjl/VVfDXEcrJi0so2an1200uOYyaWsv48ldC
         dzPZ0wic/6rn1UtkodXalYFqQcXtOx/eM//smEXWhvfrZCvfBZqmJf7T17G3ncpaFi
         2KQ09Y5RU+F9ezU8baBANM6Rgk203ig1r50yyNkc=
Date:   Mon, 2 Mar 2020 10:02:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, satyat@google.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, light.hsieh@mediatek.com
Subject: Re: [RFC PATCH v1] scsi: ufs-mediatek: add inline encryption support
Message-ID: <20200302180231.GB98133@gmail.com>
References: <20200302091138.10341-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200302091138.10341-1-stanley.chu@mediatek.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 02, 2020 at 05:11:38PM +0800, Stanley Chu wrote:
> Add inline encryption support to ufs-mediatek.
> 
> The standards-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual UFS requests, are already handled by
> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> 
> However MediaTek UFS host requires a vendor-specific hce_enable operation
> to allow crypto-related registers being accessed normally in kernel.
> After this step, MediaTek UFS host can work as standard-compliant host
> for inline-encryption related functions.
> 
> This patch is rebased to the latest wip-inline-encryption branch in
> Eric Biggers's git:
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/

Please don't use a random work-in-progress branch from my git repository (which
hasn't been updated to the v7 patchset yet and will be rebased); use instead:

	Repo: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
	Tag: inline-encryption-v7

Also, this patch doesn't apply to either branch anyway:

Applying: scsi: ufs-mediatek: add inline encryption support
Using index info to reconstruct a base tree...
error: patch failed: drivers/scsi/ufs/ufs-mediatek.c:15
error: drivers/scsi/ufs/ufs-mediatek.c: patch does not apply
error: patch failed: drivers/scsi/ufs/ufs-mediatek.h:58
error: drivers/scsi/ufs/ufs-mediatek.h: patch does not apply
error: Did you hand edit your patch?

> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 53eae5fe2ade..12d01fd3d5e1 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -15,6 +15,7 @@
>  #include <linux/soc/mediatek/mtk_sip_svc.h>
>  
>  #include "ufshcd.h"
> +#include "ufshcd-crypto.h"
>  #include "ufshcd-pltfrm.h"
>  #include "ufs_quirks.h"
>  #include "unipro.h"
> @@ -24,6 +25,9 @@
>  	arm_smccc_smc(MTK_SIP_UFS_CONTROL, \
>  		      cmd, val, 0, 0, 0, 0, 0, &(res))
>  
> +#define ufs_mtk_crypto_ctrl(res, enable) \
> +	ufs_mtk_smc(UFS_MTK_SIP_CRYPTO_CTRL, enable, res)
> +
>  #define ufs_mtk_ref_clk_notify(on, res) \
>  	ufs_mtk_smc(UFS_MTK_SIP_REF_CLK_NOTIFICATION, on, res)
>  
> @@ -66,7 +70,27 @@ static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
>  	}
>  }
>  
> -static int ufs_mtk_bind_mphy(struct ufs_hba *hba)
> +static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
> +{
> +	struct arm_smccc_res res;
> +
> +	ufs_mtk_crypto_ctrl(res, 1);
> +	if (res.a0) {
> +		dev_info(hba->dev, "%s: crypto enable failed, err: %lu\n",
> +			 __func__, res.a0);
> +	}
> +}
> +
> +static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
> +				     enum ufs_notify_change_status status)
> +{
> +	if (status == PRE_CHANGE && ufshcd_hba_is_crypto_supported(hba))
> +		ufs_mtk_crypto_enable(hba);
> +
> +	return 0;
> +}
> +
> +int ufs_mtk_bind_mphy(struct ufs_hba *hba)
>  {
>  	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>  	struct device *dev = hba->dev;
> @@ -494,6 +518,7 @@ static struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
>  	.name                = "mediatek.ufshci",
>  	.init                = ufs_mtk_init,
>  	.setup_clocks        = ufs_mtk_setup_clocks,
> +	.hce_enable_notify   = ufs_mtk_hce_enable_notify,
>  	.link_startup_notify = ufs_mtk_link_startup_notify,
>  	.pwr_change_notify   = ufs_mtk_pwr_change_notify,
>  	.apply_dev_quirks    = ufs_mtk_apply_dev_quirks,
> diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
> index fccdd979d6fb..5ebaa59898bf 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.h
> +++ b/drivers/scsi/ufs/ufs-mediatek.h
> @@ -58,6 +58,7 @@
>   */
>  #define MTK_SIP_UFS_CONTROL               MTK_SIP_SMC_CMD(0x276)
>  #define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
> +#define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
>  #define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)

But if this is all that's needed to get inline crypto working with Mediatek UFS,
that's great news.

Thanks!

- Eric
