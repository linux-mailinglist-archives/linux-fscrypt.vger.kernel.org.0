Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459AA2FEB1B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 14:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729502AbhAUNHT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 08:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731646AbhAUNGB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 08:06:01 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F43EC0613D3
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 05:05:15 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id g13so631700uaw.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 05:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zs8otNEnodQlCwRuZV4QbyTSoADBt7nRM1nLFJp+hCs=;
        b=IftLdmqf25p8SfozIdIq/orjME1uvPGKWxJU4iMUkin7IJFAdJ5yXH7zxXkxEC7Umx
         CIVG8sAXOEEQyr3vhdoDVOBdc5lSl12yINoHxZp7GihHC6r853RJ3w1J6DYOqKNO3RHS
         c9npwOeH322mQW5w/iFlYcq3uv6LVIuRRyEnY93AbOgXkKOSoxx4uY3Rv+IhZhGF3BQq
         TE2N05OPn7Z0Ko0SLauKz8PRuNw1rumNF6n9f6VhID2luiA11u/C8zWM1Isuvkpo0k8J
         7elRS4qVf7JF0C92xx98kPnwcjDdtKqk7R+Y8MVEPFZhHmjNMEAcucmyuT0g0Cj67Id+
         T7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zs8otNEnodQlCwRuZV4QbyTSoADBt7nRM1nLFJp+hCs=;
        b=cKNhtoXKoL06swmKny6pOY71T0Hj9AsZi9XOmXj5Qd9B6U4JlDb5RY8ngHZ2eCNufs
         eH5WEGRpu2m/lxvRRMKgYO1R0p/M8dTX/jGMjR0+qAgsmEbAL8PLo/XEBjDJ6BNyTlFH
         /kpydz2IYs+kckymrP45fweu6GLS5M/AhIBgOg6Y/ZMLVJ932SrwxTpVsqwjgFjVB9I9
         xG3iUzN1FQmv3Tp6Tnq6ZcK3zPP9ieApxPph40j3Yjk48USUbDyHVyFvxRXn4LbXGE0q
         NqymdkAtwOedeE4ACvHC3Y18Grikq5+u9ugyb1N4osQDjc3FjujxnhYjZFOQ1rPtWYbu
         L3Lw==
X-Gm-Message-State: AOAM533HfkmuXn9xoibrTekm6s18S+0Y97ghhyO7xxYZxKfm450XVH0M
        xbL9PqjLYT2KwCoGzxysFvsyFLbb/qbNpwlEg5TEvg==
X-Google-Smtp-Source: ABdhPJwysZ3fBRI9GVtPW4ca2ku0COm0pzo5GLDulvb+vkV2WaAFeR7ReYXmS9Hm40m6ULURedt7Df7SMi1Vn2XGTYM=
X-Received: by 2002:ab0:78d:: with SMTP id c13mr9071679uaf.129.1611234313956;
 Thu, 21 Jan 2021 05:05:13 -0800 (PST)
MIME-Version: 1.0
References: <20210121090140.326380-1-ebiggers@kernel.org> <20210121090140.326380-5-ebiggers@kernel.org>
In-Reply-To: <20210121090140.326380-5-ebiggers@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 21 Jan 2021 14:04:37 +0100
Message-ID: <CAPDyKFqCz=N9R6RpEoMO+zoKhJbds1rbvgzHJ2z+6k2U2Wq6Yg@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mmc: cqhci: add support for inline encryption
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 21 Jan 2021 at 10:03, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add support for eMMC inline encryption using the blk-crypto framework
> (Documentation/block/inline-encryption.rst).
>
> eMMC inline encryption support is specified by the upcoming JEDEC eMMC
> v5.2 specification.  It is only specified for the CQ interface, not the
> non-CQ interface.  Although the eMMC v5.2 specification hasn't been
> officially released yet, the crypto support was already agreed on
> several years ago, and it was already implemented by at least two major
> hardware vendors.  Lots of hardware in the field already supports and
> uses it, e.g. Snapdragon 630 to give one example.
>
> eMMC inline encryption support is very similar to the UFS inline
> encryption support which was standardized in the UFS v2.1 specification
> and was already upstreamed.  The only major difference is that eMMC
> limits data unit numbers to 32 bits, unlike UFS's 64 bits.
>
> Like we did with UFS, make the crypto support opt-in by individual
> drivers; don't enable it automatically whenever the hardware declares
> crypto support.  This is necessary because in every case we've seen,
> some extra vendor-specific logic is needed to use the crypto support.
>
> Co-developed-by: Satya Tangirala <satyat@google.com>
> Signed-off-by: Satya Tangirala <satyat@google.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Satya Tangirala <satyat@google.com>
> Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

[...]

> +/**
> + * cqhci_crypto_init - initialize CQHCI crypto support
> + * @cq_host: a cqhci host
> + *
> + * If the driver previously set MMC_CAP2_CRYPTO and the CQE declares
> + * CQHCI_CAP_CS, initialize the crypto support.  This involves reading the
> + * crypto capability registers, initializing the keyslot manager, clearing all
> + * keyslots, and enabling 128-bit task descriptors.
> + *
> + * Return: 0 if crypto was initialized or isn't supported; whether
> + *        MMC_CAP2_CRYPTO remains set indicates which one of those cases it is.
> + *        Also can return a negative errno value on unexpected error.
> + */
> +int cqhci_crypto_init(struct cqhci_host *cq_host)
> +{
> +       struct mmc_host *mmc = cq_host->mmc;
> +       struct device *dev = mmc_dev(mmc);
> +       struct blk_keyslot_manager *ksm = &mmc->ksm;
> +       unsigned int num_keyslots;
> +       unsigned int cap_idx;
> +       enum blk_crypto_mode_num blk_mode_num;
> +       unsigned int slot;
> +       int err = 0;
> +
> +       if (!(mmc->caps2 & MMC_CAP2_CRYPTO) ||
> +           !(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
> +               goto out;
> +
> +       cq_host->crypto_capabilities.reg_val =
> +                       cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
> +
> +       cq_host->crypto_cfg_register =
> +               (u32)cq_host->crypto_capabilities.config_array_ptr * 0x100;
> +
> +       cq_host->crypto_cap_array =
> +               devm_kcalloc(dev, cq_host->crypto_capabilities.num_crypto_cap,
> +                            sizeof(cq_host->crypto_cap_array[0]), GFP_KERNEL);
> +       if (!cq_host->crypto_cap_array) {
> +               err = -ENOMEM;
> +               goto out;
> +       }
> +
> +       /*
> +        * CCAP.CFGC is off by one, so the actual number of crypto
> +        * configurations (a.k.a. keyslots) is CCAP.CFGC + 1.
> +        */
> +       num_keyslots = cq_host->crypto_capabilities.config_count + 1;
> +
> +       err = devm_blk_ksm_init(dev, ksm, num_keyslots);
> +       if (err)
> +               goto out;
> +
> +       ksm->ksm_ll_ops = cqhci_ksm_ops;
> +       ksm->dev = dev;
> +
> +       /* Unfortunately, CQHCI crypto only supports 32 DUN bits. */
> +       ksm->max_dun_bytes_supported = 4;
> +
> +       /*
> +        * Cache all the crypto capabilities and advertise the supported crypto
> +        * modes and data unit sizes to the block layer.
> +        */
> +       for (cap_idx = 0; cap_idx < cq_host->crypto_capabilities.num_crypto_cap;
> +            cap_idx++) {
> +               cq_host->crypto_cap_array[cap_idx].reg_val =
> +                       cpu_to_le32(cqhci_readl(cq_host,
> +                                               CQHCI_CRYPTOCAP +
> +                                               cap_idx * sizeof(__le32)));
> +               blk_mode_num = cqhci_find_blk_crypto_mode(
> +                                       cq_host->crypto_cap_array[cap_idx]);
> +               if (blk_mode_num == BLK_ENCRYPTION_MODE_INVALID)
> +                       continue;
> +               ksm->crypto_modes_supported[blk_mode_num] |=
> +                       cq_host->crypto_cap_array[cap_idx].sdus_mask * 512;
> +       }
> +
> +       /* Clear all the keyslots so that we start in a known state. */
> +       for (slot = 0; slot < num_keyslots; slot++)
> +               cqhci_crypto_clear_keyslot(cq_host, slot);
> +
> +       /* CQHCI crypto requires the use of 128-bit task descriptors. */
> +       cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
> +
> +       return 0;
> +
> +out:
> +       mmc->caps2 &= ~MMC_CAP2_CRYPTO;
> +       return err;
> +}
> diff --git a/drivers/mmc/host/cqhci-crypto.h b/drivers/mmc/host/cqhci-crypto.h
> new file mode 100644
> index 0000000000000..60b58ee0e6256
> --- /dev/null
> +++ b/drivers/mmc/host/cqhci-crypto.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * CQHCI crypto engine (inline encryption) support
> + *
> + * Copyright 2020 Google LLC
> + */
> +
> +#ifndef LINUX_MMC_CQHCI_CRYPTO_H
> +#define LINUX_MMC_CQHCI_CRYPTO_H
> +
> +#include <linux/mmc/host.h>
> +
> +#include "cqhci.h"
> +
> +#ifdef CONFIG_MMC_CRYPTO
> +
> +int cqhci_crypto_init(struct cqhci_host *host);
> +
> +/*
> + * Returns the crypto bits that should be set in bits 64-127 of the
> + * task descriptor.
> + */
> +static inline u64 cqhci_crypto_prep_task_desc(struct mmc_request *mrq)
> +{
> +       if (!mrq->crypto_enabled)
> +               return 0;
> +
> +       return CQHCI_CRYPTO_ENABLE_BIT |
> +              CQHCI_CRYPTO_KEYSLOT(mrq->crypto_key_slot) |
> +              mrq->data_unit_num;
> +}
> +
> +#else /* CONFIG_MMC_CRYPTO */
> +
> +static inline int cqhci_crypto_init(struct cqhci_host *host)
> +{
> +       return 0;

The host calling this function may have MMC_CAP2_CRYPTO set for it.

When CONFIG_MMC_CRYPTO is set, cqhci_crypto_init() may unset
MMC_CAP2_CRYPTO if initialization fails. It seems like we should unset
MMC_CAP2_CRYPTO in this stub function as well, right?

> +}
> +
> +static inline u64 cqhci_crypto_prep_task_desc(struct mmc_request *mrq)
> +{
> +       return 0;
> +}
> +
> +#endif /* !CONFIG_MMC_CRYPTO */
> +
> +#endif /* LINUX_MMC_CQHCI_CRYPTO_H */

[...]

Kind regards
Uffe
