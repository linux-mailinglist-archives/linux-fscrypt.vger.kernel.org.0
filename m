Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9BD473975
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 01:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242388AbhLNAUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 19:20:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbhLNAUt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 19:20:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50024612C7;
        Tue, 14 Dec 2021 00:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9E4C34600;
        Tue, 14 Dec 2021 00:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639441248;
        bh=ePD2l1Wc65z3t8P+boLOjl1ci+wAuJ39q4mpx44dT98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SLzWuoJIZ2wD+sJQihaZfjfcRClLNcO4k3Gtae5jIAiyCdW6s5uiF3U+M9pyb7sHa
         gg5eIYLjhmcUlff6DhJrflN7S4wZzXLpV5ejqYfAFh0tGvJdrOO1bxyKuI8s/A0fKe
         lCVbqh0aIxMCDYZ93YNntuXsKUK32ZWxKayBxrL+xJ9uLd1YbwLNxRQiBdA6CVs1/m
         RzB1KgMEsAmnHy3QsunhMsfyku8BeIPdLv+FpfYs5r5ylEWP07qxffw8NbFFzr85Rz
         75180Q/uXy3cnp+GMlBbbe+R7DZRQb199o1CCoLq0xuqJsK+uWmTWhTdiXY7bouJgl
         EhXubkqZDZAxA==
Date:   Mon, 13 Dec 2021 16:20:46 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 01/10] soc: qcom: new common library for ICE functionality
Message-ID: <YbfjXtQgLSLOFvBr@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-2-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-2-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:16PM -0800, Gaurav Kashyap wrote:
> Add a new library which congregates all the ICE
> functionality so that all storage controllers containing
> ICE can utilize it.

In commit messages and comments, please spell out "Inline Crypto Engine (ICE)"
the first time it appears, so that people know what ICE means.

> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 79b568f82a1c..a900f5ab6263 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -209,4 +209,11 @@ config QCOM_APR
>  	  application processor and QDSP6. APR is
>  	  used by audio driver to configure QDSP6
>  	  ASM, ADM and AFE modules.
> +
> +config QTI_ICE_COMMON
> +	tristate "QTI common ICE functionality"

Since this is a library, it shouldn't be user-selectable, but rather just be
selected by the other options that need it.  Putting a string after "tristate"
makes it user-selectable; the string is the prompt string.  The line should just
be "tristate", without a string afterwards.

> diff --git a/drivers/soc/qcom/qti-ice-common.c b/drivers/soc/qcom/qti-ice-common.c
> new file mode 100644
> index 000000000000..0c5b529201c5
> --- /dev/null
> +++ b/drivers/soc/qcom/qti-ice-common.c
> @@ -0,0 +1,199 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Common ICE library for storage encryption.
> + *
> + * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
> + */
> +
> +#include <linux/qti-ice-common.h>
> +#include <linux/module.h>
> +#include <linux/qcom_scm.h>
> +#include <linux/delay.h>
> +#include "qti-ice-regs.h"
> +
> +#define QTI_ICE_MAX_BIST_CHECK_COUNT    100
> +#define QTI_AES_256_XTS_KEY_RAW_SIZE	64
> +
> +static bool qti_ice_supported(const struct ice_mmio_data *mmio)
> +{
> +	u32 regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_VERSION);
> +	int major = regval >> 24;
> +	int minor = (regval >> 16) & 0xFF;
> +	int step = regval & 0xFFFF;
> +
> +	/* For now this driver only supports ICE version 3 and higher. */
> +	if (major < 3) {
> +		pr_warn("Unsupported ICE version: v%d.%d.%d\n",
> +			 major, minor, step);
> +		return false;
> +	}

For log messages associated with a device, the dev_*() functions should be used
instead of pr_*().  How about including the relevant 'struct device *' in the
struct ice_mmio_data?

This comment applies to everywhere in qti-ice-common that is logging anything.

> +/**
> + * qti_ice_init() - Initialize ICE functionality
> + * @ice_mmio_data: contains ICE register mapping for i/o
> + *
> + * Initialize ICE by checking the version for ICE support and
> + * also checking the fuses blown.
> + *
> + * Return: 0 on success; -EINVAL on failure.
> + */
> +int qti_ice_init(const struct ice_mmio_data *mmio)
> +{
> +	if (!qti_ice_supported(mmio))
> +		return -EINVAL;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qti_ice_init);

Be more specific about what "failure" means here.  It means that the driver
doesn't support the ICE hardware, right?  -ENODEV would be a more appropriate
error code for this.  -EINVAL is a very generic error.

> +static void qti_ice_low_power_and_optimization_enable(
> +				const struct ice_mmio_data *mmio)
> +{
> +	u32 regval = qti_ice_readl(mmio->ice_mmio,
> +				   QTI_ICE_REGS_ADVANCED_CONTROL);
> +
> +	/* Enable low power mode sequence
> +	 * [0]-0,[1]-0,[2]-0,[3]-7,[4]-0,[5]-0,[6]-0,[7]-0,
> +	 * Enable CONFIG_CLK_GATING, STREAM2_CLK_GATING and STREAM1_CLK_GATING
> +	 */
> +	regval |= 0x7000;
> +	/* Optimization enable sequence*/
> +	regval |= 0xD807100;
> +	qti_ice_writel(mmio->ice_mmio, regval, QTI_ICE_REGS_ADVANCED_CONTROL);
> +	/* Memory barrier - to ensure write completion before next transaction */
> +	wmb();
> +}

This part changed slightly from the original code in
drivers/scsi/ufs/ufs-qcom-ice.c and drivers/mmc/host/sdhci-msm.c.  What is the
reason for these changes?  To be fair, I can't properly explain this part of the
original code; I just did what some existing ICE code was doing.  But if it
wasn't the correct or best way, it would be super useful to understand *why*
this different version is really the correct/best way.

Also note that the line "regval |= 0x7000;" is redundant.

> +static int qti_ice_wait_bist_status(const struct ice_mmio_data *mmio)
> +{
> +	int count;
> +	u32 regval;
> +
> +	for (count = 0; count < QTI_ICE_MAX_BIST_CHECK_COUNT; count++) {
> +		regval = qti_ice_readl(mmio->ice_mmio,
> +				       QTI_ICE_REGS_BIST_STATUS);
> +		if (!(regval & QTI_ICE_BIST_STATUS_MASK))
> +			break;
> +		udelay(50);
> +	}
> +
> +	if (regval) {
> +		pr_err("%s: wait bist status failed, reg %d\n",
> +			__func__, regval);
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}

The copy of this in drivers/mmc/host/sdhci-msm.c is a bit nicer in that it uses
the readl_poll_timeout() helper function, and it has a longer comment explaining
it.  So I think you should use that version rather than the UFS version.

> +/**
> + * qti_ice_keyslot_program() - Program a key to an ICE slot
> + * @ice_mmio_data: contains ICE register mapping for i/o
> + * @crypto_key: key to be program, this can be wrapped or raw
> + * @crypto_key_size: size of the key to be programmed
> + * @slot: the keyslot at which the key should be programmed.
> + * @data_unit_mask: mask for the dun which is part of the
> + *                  crypto configuration.
> + * @capid: capability index indicating the algorithm for the
> + *         crypto configuration
> + *
> + * Program the passed in key to a slot in ICE.
> + * The key that is passed in can either be a raw key or wrapped.
> + * In both cases, due to access control of ICE for Qualcomm chipsets,
> + * a scm call is used to program the key into ICE from trustzone.
> + * Trustzone can differentiate between raw and wrapped keys.

How does TrustZone differentiate between raw and wrapped keys?  I thought you
had mentioned that only one is supported at a time on a particular SoC.

> +int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
> +			    const u8 *crypto_key, unsigned int crypto_key_size,
> +			    unsigned int slot, u8 data_unit_mask, int capid)
> +{
> +	int err = 0;
> +	int i = 0;
> +	union {
> +		u8 bytes[QTI_AES_256_XTS_KEY_RAW_SIZE];
> +		u32 words[QTI_AES_256_XTS_KEY_RAW_SIZE / sizeof(u32)];
> +	} key;
> +
> +	memcpy(key.bytes, crypto_key, crypto_key_size);

This is assuming that wrapped keys aren't longer than raw AES-256-XTS keys,
which isn't necessarily true.

> +#define qti_ice_writel(mmio, val, reg)		\
> +	writel_relaxed((val), mmio + (reg))
> +#define qti_ice_readl(mmio, reg)		\
> +	readl_relaxed(mmio + (reg))

Previously, writel() and readl() were used instead of writel_relaxed() and
readl_relaxed().  What is the reason for this change?  My understanding is that
the *_relaxed() functions are harder to use correctly, so they shouldn't be used
unless it's been carefully thought through and the extra performance is needed.

- Eric
