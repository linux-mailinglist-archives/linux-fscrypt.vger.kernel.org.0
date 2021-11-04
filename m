Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7776445C8D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Nov 2021 00:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhKDXIN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 19:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhKDXIN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 19:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B4AC611CE;
        Thu,  4 Nov 2021 23:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636067134;
        bh=2Ipe1kss9nj6sde/9a2sy00aG/fgD2aHfh41B1wB9jQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q//q2ZUQAXzviqDlnsUFEbP942XyqQnXJFpp2Rk7GT1iF5NkYxO9a6uL+6IieTdq7
         c92Cnr9hGjwXFeFG17srOi8/Z3T2vZFn9BBLGKj/zcM7dUv6xUs6s5zs0vTMym9GQD
         NJJGhfRzUIkDz/WCfRmZFteU6SdjrlgIUj4CEKmy8X4AT2bLHRtFOSJ3UAGAXjdoGY
         ElUu2+iPUB8YXJ5coI7oPxMpzMPZc7ahDKZmYRfwxA1T13UFwSBzT2G04Dd4Mu/cJI
         t9qr0tLexodAsd+oo9O/GBi9vg+KzgDx1PdQVPj3/XjETaHc1VcoBUhXmJZwimarNJ
         xw/VPjgaVXXUg==
Date:   Thu, 4 Nov 2021 16:05:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        asutoshd@codeaurora.org
Subject: Re: [PATCH 1/4] ufs: move ICE functionality to a common library
Message-ID: <YYRnPN6e2/YMS9Zt@gmail.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <20211103231840.115521-2-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103231840.115521-2-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 03, 2021 at 04:18:37PM -0700, Gaurav Kashyap wrote:
> The Inline Crypto Engine functionality is not limited to
> ufs and it can be used by other storage controllers like emmc
> which have the HW capabilities. It would be better to move this
> functionality to a common location.

I think you should be a bit more concrete here: both sdhci-msm and ufs-qcom
already have ICE support, and this common library allows code to be shared.

> Moreover, when wrapped key functionality is added, it would
> reduce the effort required to add it for all storage
> controllers.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/scsi/ufs/ufs-qcom-ice.c   | 172 ++++--------------------------
>  drivers/soc/qcom/Kconfig          |   7 ++
>  drivers/soc/qcom/Makefile         |   1 +
>  drivers/soc/qcom/qti-ice-common.c | 135 +++++++++++++++++++++++
>  drivers/soc/qcom/qti-ice-regs.h   | 145 +++++++++++++++++++++++++
>  include/linux/qti-ice-common.h    |  26 +++++
>  6 files changed, 334 insertions(+), 152 deletions(-)
>  create mode 100644 drivers/soc/qcom/qti-ice-common.c
>  create mode 100644 drivers/soc/qcom/qti-ice-regs.h
>  create mode 100644 include/linux/qti-ice-common.h

This should be split up into two patches: one that adds the library, and one
that converts ufs-qcom to use it.  There should also be a third patch that
converts sdhci-msm to use it.

> +static void get_ice_mmio_data(struct ice_mmio_data *data,
> +			      const struct ufs_qcom_host *host)
> +{
> +	data->ice_mmio = host->ice_mmio;
> +}

I think the struct ice_mmio_data should just be a field of struct ufs_qcom_host.
Then you wouldn't have to keep initializing a new one.

> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
> index 79b568f82a1c..39f223ed8cdd 100644
> --- a/drivers/soc/qcom/Kconfig
> +++ b/drivers/soc/qcom/Kconfig
> @@ -209,4 +209,11 @@ config QCOM_APR
>  	  application processor and QDSP6. APR is
>  	  used by audio driver to configure QDSP6
>  	  ASM, ADM and AFE modules.
> +
> +config QTI_ICE_COMMON
> +	tristate "QTI common ICE functionality"
> +	depends on SCSI_UFS_CRYPTO && SCSI_UFS_QCOM
> +	help
> +	  Enable the common ICE library that can be used
> +	  by UFS and EMMC drivers for ICE functionality.

"Libraries" should not be user-selectable.  Instead, they should be selected by
the kconfig options that need them.  That also means that the "depends on"
clause should not be here.

So it should look more like:

config QTI_ICE_COMMON
	tristate
	help
	  Enable the common ICE library that can be used
	  by UFS and EMMC drivers for ICE functionality.

If the library itself has dependencies (perhaps ARCH_QCOM?), then add those.

> +
> +int qti_ice_init(const struct ice_mmio_data *mmio)
> +{
> +	return qti_ice_supported(mmio);
> +}
> +EXPORT_SYMBOL(qti_ice_init);

Please use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.

The exported functions could also use kerneldoc comments.

> diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
> new file mode 100644
> index 000000000000..433422b34a7d
> --- /dev/null
> +++ b/include/linux/qti-ice-common.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (c) 2021, The Linux Foundation. All rights reserved.
> + */
> +
> +#ifndef _QTI_ICE_COMMON_H
> +#define _QTI_ICE_COMMON_H
> +
> +#include <linux/types.h>
> +#include <linux/device.h>
> +
> +#define AES_256_XTS_KEY_SIZE    64

Is the definition of AES_256_XTS_KEY_SIZE needed in this header?  It's not
properly "namespaced", so it's sort of the odd thing out in this header.

- Eric
