Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878DB473A07
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 02:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhLNBIm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 20:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbhLNBIk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 20:08:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E60BC061574;
        Mon, 13 Dec 2021 17:08:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29DE8B8049B;
        Tue, 14 Dec 2021 01:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F15C34600;
        Tue, 14 Dec 2021 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639444118;
        bh=FteiA30kfkShJ4fDZk0nXaXA3DrH16cw48CWaVRSY8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M/FyZ+d+uslqvgWdCR7Tbdt6OGsVx5R2UZ4M9m8uquH3KM5Z48lpCd+nTwaG1t+gs
         1frdwKkvb8//Im83a8WVV8nFgYQaHMhvoMVTiAgRbc7BQOUFksm9rJJC8lLesBVSSX
         UodvOsel5grf39wOhZGU3tjSkCc2Q10a5utEopM24Dv/URHgX3h0FC/aIL5cHkmfjn
         bZ3Z5W0z0X3dOp4v3Efk6gnQDu/qWCqfZDq81HY9NVUDmBjFLDwGIjQwluLWG3QkAG
         64JUcPQ77n16D6k3G969QdhuaObjeHswD6QTjWA5nymn9sC6XsHses5PRTlY9lHLg+
         bhnb1NeKR7UZg==
Date:   Mon, 13 Dec 2021 17:08:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 04/10] soc: qcom: add HWKM library for storage encryption
Message-ID: <YbfulLPhUNhd04xY@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-5-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-5-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:19PM -0800, Gaurav Kashyap wrote:
> Wrapped keys should utilize hardware to protect the keys
> used for storage encryption. Qualcomm's Inline Crypto Engine

"should utilize" => "utilize"?

> supports a hardware block called Hardware Key Manager (HWKM)
> for key management.
> 
> Although most of the interactions to this hardware block happens
> via a secure execution environment, some initializations for the
> slave present in ICE can be done from the kernel.
> 
> This can also be a placeholder for when the hardware provides more
> capabilities to be accessed from the linux kernel in the future.
> 

This commit message doesn't explain what this commit actually does.  Can you
make that clearer?

> diff --git a/drivers/soc/qcom/qti-ice-hwkm.c b/drivers/soc/qcom/qti-ice-hwkm.c
> new file mode 100644
> index 000000000000..3be6b350cd88
> --- /dev/null
> +++ b/drivers/soc/qcom/qti-ice-hwkm.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * HWKM ICE library for storage encryption.
> + *
> + * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
> + */
> +
> +#include <linux/qti-ice-common.h>
> +#include "qti-ice-regs.h"
> +
> +static int qti_ice_hwkm_bist_status(const struct ice_mmio_data *mmio, int version)
> +{
> +	if (!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
> +			(version == 1) ? BIST_DONE_V1 : BIST_DONE_V2) ||
> +	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
> +			(version == 1) ? CRYPTO_LIB_BIST_DONE_V1 :
> +			CRYPTO_LIB_BIST_DONE_V2) ||
> +	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
> +			(version == 1) ? BOOT_CMD_LIST1_DONE_V1 :
> +			BOOT_CMD_LIST1_DONE_V2) ||
> +	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
> +			(version == 1) ? BOOT_CMD_LIST0_DONE_V1 :
> +			BOOT_CMD_LIST0_DONE_V2) ||
> +	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
> +			(version == 1) ? KT_CLEAR_DONE_V1 :
> +			KT_CLEAR_DONE_V2))
> +		return -EINVAL;
> +	return 0;
> +}

Long "if" statements are hard to read.  It would be more readable to have a
separate "if" and "return -EINVAL" for each of these checks.

> +static void qti_ice_hwkm_configure_ice_registers(
> +				const struct ice_mmio_data *mmio)
> +{
> +	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
> +			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_0);
> +	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
> +			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_1);
> +	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
> +			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_2);
> +	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
> +			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_3);
> +	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
> +			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_4);
> +}
> +
> +static int qti_ice_hwkm_init_sequence(const struct ice_mmio_data *mmio,
> +				      int version)
> +{
> +	u32 val = 0;
> +
> +	/*
> +	 * Put ICE in standard mode, ICE defaults to legacy mode.
> +	 * Legacy mode - ICE HWKM slave not supported.
> +	 * Standard mode - ICE HWKM slave supported.
> +	 *
> +	 * Depending on the version of HWKM, it is controlled by different
> +	 * registers in ICE.
> +	 */
> +	if (version >= 2) {
> +		val = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_CONTROL);
> +		val = val & 0xFFFFFFFE;
> +		qti_ice_writel(mmio->ice_mmio, val, QTI_ICE_REGS_CONTROL);
> +	} else {
> +		qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0x7,
> +				    QTI_HWKM_ICE_RG_TZ_KM_CTL);
> +	}

So to use wrapped keys, ICE needs to be in "standard mode", and to use standard
keys it needs to be in "legacy mode"?  That's confusing.  It would be helpful to
explain this more clearly in a comment.

> +
> +	/* Check BIST status */
> +	if (qti_ice_hwkm_bist_status(mmio, version))
> +		return -EINVAL;

Please spell out what BIST stands for.  It's "Built-In Self Test", right?

> +
> +	/*
> +	 * Give register bank of the HWKM slave access to read and modify
> +	 * the keyslots in ICE HWKM slave. Without this, trustzone will not
> +	 * be able to program keys into ICE.
> +	 */
> +	qti_ice_hwkm_configure_ice_registers(mmio);
> +
> +	/* Disable CRC check */
> +	qti_ice_hwkm_clearb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_CTL,
> +			    CRC_CHECK_EN);
> +
> +	/* Set RSP_FIFO_FULL bit */
> +	qti_ice_hwkm_setb(mmio->ice_hwkm_mmio,
> +			QTI_HWKM_ICE_RG_BANK0_BANKN_IRQ_STATUS, RSP_FIFO_FULL);

Please expand on comments as much as possible, so that people can understand not
just what the code is doing but why it is doing it.  E.g., why does the CRC
check need to be disabled, and why does the RSP_FIFO_FULL bit need to be set?

> +/**
> + * qti_ice_hwkm_init() - Initialize ICE HWKM hardware
> + * @ice_mmio_data: contains ICE register mapping for i/o
> + * @version: version of hwkm hardware
> + *
> + * Perform HWKM initialization in the ICE slave by going
> + * through the slave initialization routine.The registers
> + * can vary slightly based on the version.
> + *
> + * Return: 0 on success; err on failure.
> + */
> +
> +int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version)
> +{
> +	if (!mmio->ice_hwkm_mmio)
> +		return -EINVAL;
> +
> +	return qti_ice_hwkm_init_sequence(mmio, version);
> +}
> +EXPORT_SYMBOL_GPL(qti_ice_hwkm_init);

This function is only called from within the same kernel module, so it doesn't
need to be an exported symbol.

> +MODULE_LICENSE("GPL v2");

The main source file for this module (qti-ice-common.c) already has a
MODULE_LICENSE, so there shouldn't be a duplicate one here.  MODULE_LICENSE is
for the whole module, not for individual source files.

> +
> +#define qti_ice_hwkm_readl(hwkm_mmio, reg)		\
> +	(readl_relaxed(hwkm_mmio + (reg)))
> +#define qti_ice_hwkm_writel(hwkm_mmio, val, reg)	\
> +	(writel_relaxed((val), hwkm_mmio + (reg)))

Why readl_relaxed() and writel_relaxed(), instead of readl() and writel()?

> +static inline bool qti_ice_hwkm_testb(void __iomem *ice_hwkm_mmio,
> +				      u32 reg, u8 nr)
> +{
> +	u32 val = qti_ice_hwkm_readl(ice_hwkm_mmio, reg);
> +
> +	val = (val >> nr) & 0x1;
> +	if (val == 0)
> +		return false;
> +	return true;
> +}

This is unnecessarily verbose.  It could be just:

	return qti_ice_hwkm_readl(ice_hwkm_mmio, reg) & (1U << nr);

- Eric
