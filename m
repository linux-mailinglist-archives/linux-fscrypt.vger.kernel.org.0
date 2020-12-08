Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1A2D3704
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Dec 2020 00:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbgLHXkt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 18:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731797AbgLHXkt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 18:40:49 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFD2C061794
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 15:40:09 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id b26so198385pfi.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 15:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f2Rw+12cZC2KSwMyweXqKWzxEzMTuwN2X3XRonxyDdA=;
        b=Mz0jCmzBsRIsp6HP7rMkXmC1oAS36LfYs+kRAsDygVnppOCLwWPX8MoRymHuRZNfkH
         ScZb8P92S4iqLty1mCDmarNyP459J1Wub5rvM5f0mkh44nbbZ/RNtPCT28DE4VL8v+i/
         4j/1wTvGoV/rXDAiWm2HHWNolbvmIF3hB1Mwmda5xumQk9PFu8WsAQaz+g66Ln/86BS1
         qPPD0WS7g+OtrfTmXXWjPyl1zFOJNWnA2i+AiyNDbXMHsXlR2VRC+Z0XfXKuoeuzjLK4
         /5/IRpRMbY1x5tnucGzrbbQYcg7IjpQtav10fk9czuwx3kSDH2zf2v4tFMsJdLyR51Vz
         02qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f2Rw+12cZC2KSwMyweXqKWzxEzMTuwN2X3XRonxyDdA=;
        b=SzfGpqUy7f533tFuVkOfP+SfOfV3hXd3XU0sWngAAtE3FuEwV1w0MDtGwQCvgyiKgn
         EbdEjnpnrC/95/P/wDDds9Oo6LBtQmhAO3TjSyuxsf6NkaZFeyIQ9KZ/imq0bETmqtKH
         2Y3D/GWDRCe1jBEbps50VN7UzbD1RpF0Iy+9ClbjW1xL4pc/2BkZXBDu7YOu6QOwV8X4
         pY/iaFT6CM+uQEQQusEPrsM7huVdn2JEAq3tM+FgMWYkhgzJ+lBBYAHX/hIE2Y/U9Np9
         0ACR5/VFWS2jFDte1H8B19b1LFfh6dMGsVGSowh+abyKUWFYmFdk8ZnxFIxrZGCHSeli
         AZ4g==
X-Gm-Message-State: AOAM530OffGeW7YjHEJiBsRnL+4O13NoQ7F4u3mLuI8D5q+tW7g8979P
        c4mxAmmCd3MTV3eVTIPdZfVrmg==
X-Google-Smtp-Source: ABdhPJwJSPIK2+J8m6zel41LGCYs14ViXvidllaMUKjG9MhQuooGx+n8TJqn7++xeEVbbG6dQ/YtSw==
X-Received: by 2002:a63:5f49:: with SMTP id t70mr422693pgb.288.1607470808422;
        Tue, 08 Dec 2020 15:40:08 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id e13sm72326pgh.54.2020.12.08.15.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 15:40:07 -0800 (PST)
Date:   Tue, 8 Dec 2020 23:40:04 +0000
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
Subject: Re: [PATCH v2 1/9] mmc: add basic support for inline encryption
Message-ID: <X9AO1Azlf4SSNuxR@google.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203020516.225701-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 06:05:08PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for adding CQHCI crypto engine (inline encryption)
> support, add the code required to make mmc_core and mmc_block aware of
> inline encryption.  Specifically:
> 
> - Add a capability flag MMC_CAP2_CRYPTO to struct mmc_host.  Drivers
>   will set this if the host and driver support inline encryption.
> 
> - Embed a blk_keyslot_manager in struct mmc_host.  Drivers will
>   initialize this if the host and driver support inline encryption.
>   mmc_block registers this keyslot manager with the request_queue of any
>   MMC card attached to the host.  mmc_core destroys this keyslot manager
>   when freeing the mmc_host.
> 
> - Make mmc_block copy the crypto keyslot and crypto data unit number
>   from struct request to struct mmc_request, so that drivers will have
>   access to them.
> 
> - If the MMC host is reset, reprogram all the keyslots to ensure that
>   the software state stays in sync with the hardware state.
> 
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/mmc/core/Kconfig  |  8 ++++++
>  drivers/mmc/core/Makefile |  1 +
>  drivers/mmc/core/block.c  |  3 +++
>  drivers/mmc/core/core.c   |  3 +++
>  drivers/mmc/core/crypto.c | 54 +++++++++++++++++++++++++++++++++++++++
>  drivers/mmc/core/crypto.h | 46 +++++++++++++++++++++++++++++++++
>  drivers/mmc/core/host.c   |  2 ++
>  drivers/mmc/core/queue.c  |  3 +++
>  include/linux/mmc/core.h  |  6 +++++
>  include/linux/mmc/host.h  |  7 +++++
>  10 files changed, 133 insertions(+)
>  create mode 100644 drivers/mmc/core/crypto.c
>  create mode 100644 drivers/mmc/core/crypto.h
> 
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index c12fe13e4b147..ae8b69aee6190 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -81,3 +81,11 @@ config MMC_TEST
>  	  This driver is only of interest to those developing or
>  	  testing a host driver. Most people should say N here.
>  
> +config MMC_CRYPTO
> +	bool "MMC Crypto Engine Support"
> +	depends on BLK_INLINE_ENCRYPTION
> +	help
> +	  Enable Crypto Engine Support in MMC.
> +	  Enabling this makes it possible for the kernel to use the crypto
> +	  capabilities of the MMC device (if present) to perform crypto
> +	  operations on data being transferred to/from the device.
> diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
> index 95ffe008ebdf8..6a907736cd7a5 100644
> --- a/drivers/mmc/core/Makefile
> +++ b/drivers/mmc/core/Makefile
> @@ -18,3 +18,4 @@ obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
>  mmc_block-objs			:= block.o queue.o
>  obj-$(CONFIG_MMC_TEST)		+= mmc_test.o
>  obj-$(CONFIG_SDIO_UART)		+= sdio_uart.o
> +mmc_core-$(CONFIG_MMC_CRYPTO)	+= crypto.o
> diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
> index 8d3df0be0355c..eaf2f10743260 100644
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -51,6 +51,7 @@
>  #include "block.h"
>  #include "core.h"
>  #include "card.h"
> +#include "crypto.h"
>  #include "host.h"
>  #include "bus.h"
>  #include "mmc_ops.h"
> @@ -1247,6 +1248,8 @@ static void mmc_blk_data_prep(struct mmc_queue *mq, struct mmc_queue_req *mqrq,
>  
>  	memset(brq, 0, sizeof(struct mmc_blk_request));
>  
> +	mmc_crypto_prepare_req(mqrq);
> +
>  	brq->mrq.data = &brq->data;
>  	brq->mrq.tag = req->tag;
>  
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index d42037f0f10d7..275de270232b3 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -37,6 +37,7 @@
>  
>  #include "core.h"
>  #include "card.h"
> +#include "crypto.h"
>  #include "bus.h"
>  #include "host.h"
>  #include "sdio_bus.h"
> @@ -992,6 +993,8 @@ void mmc_set_initial_state(struct mmc_host *host)
>  		host->ops->hs400_enhanced_strobe(host, &host->ios);
>  
>  	mmc_set_ios(host);
> +
> +	mmc_crypto_set_initial_state(host);
>  }
>  
>  /**
> diff --git a/drivers/mmc/core/crypto.c b/drivers/mmc/core/crypto.c
> new file mode 100644
> index 0000000000000..4f47eb4740db0
> --- /dev/null
> +++ b/drivers/mmc/core/crypto.c
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * MMC crypto engine (inline encryption) support
> + *
> + * Copyright 2020 Google LLC
> + */
> +
> +#include <linux/blk-crypto.h>
> +#include <linux/mmc/host.h>
> +
> +#include "core.h"
> +#include "crypto.h"
> +#include "queue.h"
> +
> +void mmc_crypto_set_initial_state(struct mmc_host *host)
> +{
> +	/* Reset might clear all keys, so reprogram all the keys. */
> +	if (host->caps2 & MMC_CAP2_CRYPTO)
> +		blk_ksm_reprogram_all_keys(&host->ksm);
> +}
> +
> +void mmc_crypto_free_host(struct mmc_host *host)
> +{
> +	if (host->caps2 & MMC_CAP2_CRYPTO)
> +		blk_ksm_destroy(&host->ksm);
> +}
> +
> +void mmc_crypto_setup_queue(struct request_queue *q, struct mmc_host *host)
> +{
> +	if (host->caps2 & MMC_CAP2_CRYPTO)
> +		blk_ksm_register(&host->ksm, q);
> +}
> +EXPORT_SYMBOL_GPL(mmc_crypto_setup_queue);
> +
> +void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq)
> +{
> +	struct request *req = mmc_queue_req_to_req(mqrq);
> +	struct mmc_request *mrq = &mqrq->brq.mrq;
> +
> +	if (!req->crypt_keyslot)
> +		return;
> +
> +	mrq->crypto_enabled = true;
> +	mrq->crypto_key_slot = blk_ksm_get_slot_idx(req->crypt_keyslot);
> +
> +	/*
> +	 * For now we assume that all MMC drivers set max_dun_bytes_supported=4,
> +	 * which is the limit for CQHCI crypto.  So all DUNs should be 32-bit.
> +	 */
> +	WARN_ON_ONCE(req->crypt_ctx->bc_dun[0] > U32_MAX);
> +
> +	mrq->data_unit_num = req->crypt_ctx->bc_dun[0];
> +}
> +EXPORT_SYMBOL_GPL(mmc_crypto_prepare_req);
> diff --git a/drivers/mmc/core/crypto.h b/drivers/mmc/core/crypto.h
> new file mode 100644
> index 0000000000000..4780639b832f4
> --- /dev/null
> +++ b/drivers/mmc/core/crypto.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * MMC crypto engine (inline encryption) support
> + *
> + * Copyright 2020 Google LLC
> + */
> +
> +#ifndef _MMC_CORE_CRYPTO_H
> +#define _MMC_CORE_CRYPTO_H
> +
> +struct mmc_host;
> +struct mmc_queue_req;
> +struct request_queue;
> +
> +#ifdef CONFIG_MMC_CRYPTO
> +
> +void mmc_crypto_set_initial_state(struct mmc_host *host);
> +
> +void mmc_crypto_free_host(struct mmc_host *host);
> +
> +void mmc_crypto_setup_queue(struct request_queue *q, struct mmc_host *host);
> +
> +void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq);
> +
> +#else /* CONFIG_MMC_CRYPTO */
> +
> +static inline void mmc_crypto_set_initial_state(struct mmc_host *host)
> +{
> +}
> +
> +static inline void mmc_crypto_free_host(struct mmc_host *host)
> +{
> +}
> +
> +static inline void mmc_crypto_setup_queue(struct request_queue *q,
> +					  struct mmc_host *host)
> +{
> +}
> +
> +static inline void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq)
> +{
> +}
> +
> +#endif /* !CONFIG_MMC_CRYPTO */
> +
> +#endif /* _MMC_CORE_CRYPTO_H */
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 96b2ca1f1b06d..d962b9ca0e37a 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -25,6 +25,7 @@
>  #include <linux/mmc/slot-gpio.h>
>  
>  #include "core.h"
> +#include "crypto.h"
>  #include "host.h"
>  #include "slot-gpio.h"
>  #include "pwrseq.h"
> @@ -532,6 +533,7 @@ EXPORT_SYMBOL(mmc_remove_host);
>   */
>  void mmc_free_host(struct mmc_host *host)
>  {
> +	mmc_crypto_free_host(host);
>  	mmc_pwrseq_free(host);
>  	put_device(&host->class_dev);
>  }
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index de7cb0369c308..d96db852bb91a 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -19,6 +19,7 @@
>  #include "block.h"
>  #include "core.h"
>  #include "card.h"
> +#include "crypto.h"
>  #include "host.h"
>  
>  #define MMC_DMA_MAP_MERGE_SEGMENTS	512
> @@ -405,6 +406,8 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
>  	mutex_init(&mq->complete_lock);
>  
>  	init_waitqueue_head(&mq->wait);
> +
> +	mmc_crypto_setup_queue(mq->queue, host);
>  }
>  
>  static inline bool mmc_merge_capable(struct mmc_host *host)
> diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
> index 29aa507116261..ab19245e99451 100644
> --- a/include/linux/mmc/core.h
> +++ b/include/linux/mmc/core.h
> @@ -162,6 +162,12 @@ struct mmc_request {
>  	bool			cap_cmd_during_tfr;
>  
>  	int			tag;
> +
> +#ifdef CONFIG_MMC_CRYPTO
> +	bool			crypto_enabled;
> +	int			crypto_key_slot;
> +	u32			data_unit_num;
> +#endif
>  };
>  
>  struct mmc_card;
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index c079b932330f2..550460bf1b37c 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -15,6 +15,7 @@
>  #include <linux/mmc/card.h>
>  #include <linux/mmc/pm.h>
>  #include <linux/dma-direction.h>
> +#include <linux/keyslot-manager.h>
>  
>  struct mmc_ios {
>  	unsigned int	clock;			/* clock rate */
> @@ -377,6 +378,7 @@ struct mmc_host {
>  #define MMC_CAP2_CQE_DCMD	(1 << 24)	/* CQE can issue a direct command */
>  #define MMC_CAP2_AVOID_3_3V	(1 << 25)	/* Host must negotiate down from 3.3V */
>  #define MMC_CAP2_MERGE_CAPABLE	(1 << 26)	/* Host can merge a segment over the segment size */
> +#define MMC_CAP2_CRYPTO		(1 << 27)	/* Host supports inline encryption */
>  
>  	int			fixed_drv_type;	/* fixed driver type for non-removable media */
>  
> @@ -471,6 +473,11 @@ struct mmc_host {
>  	bool			cqe_enabled;
>  	bool			cqe_on;
>  
> +	/* Inline encryption support */
> +#ifdef CONFIG_MMC_CRYPTO
> +	struct blk_keyslot_manager ksm;
> +#endif
> +
>  	/* Host Software Queue support */
>  	bool			hsq_enabled;
>  
> -- 
> 2.29.2
> 
Looks good to me. Please feel free to add
Reviewed-by: Satya Tangirala <satyat@google.com>
