Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14B6473A71
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 02:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhLNBuz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 20:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhLNBuz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 20:50:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4670C061574;
        Mon, 13 Dec 2021 17:50:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5765D61278;
        Tue, 14 Dec 2021 01:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7172DC34603;
        Tue, 14 Dec 2021 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639446653;
        bh=cp/fn7dvOAdl7F1HUi+PAiqgPbHHi+9aUkOj8BC5hXw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fv0ZOezLJxreXQuApYU7z6JJ8hj5vR702sGoAslra+C4qQYvi/HClUC8l270q8K3F
         qtWRvBUAiakdDg52Cuhh1Wi6rsBvLrZdb8R76/d5YXHfZljpiYHvcCf9JZd5p/TDhG
         XXpspi18gnPQaZqyCVnb6ECSip682SIZivEgt1K3mQRKEIp0hbt59HTmPYVjFBm685
         avjVHfVwUtNVCqHtSGNjejGAanWcyEH7msRKa+KZc3cOLHXWGk4hqzKYBBgo5oBsG1
         XX3ValpEx6pB+d0gvn77c0wwcjiqgFQAy5yqniaybCbzICmOul7lPzh8TvmrfrE1M6
         QS6dW7uyfp0hg==
Date:   Mon, 13 Dec 2021 17:50:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 07/10] qcom_scm: scm call for create, prepare and import
 keys
Message-ID: <Ybf4ezgCbjugYsZz@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-8-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-8-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:22PM -0800, Gaurav Kashyap wrote:
> +/**
> + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> + * @longterm_wrapped_key: the wrapped key returned after key generation
> + * @longterm_wrapped_key_size: size of the wrapped key to be returned.
> + *
> + * Qualcomm wrapped keys need to be generated in a trusted environment.
> + * A generate key  IOCTL call is used to achieve this. These are longterm
> + * in nature as they need to be generated and wrapped only once per
> + * requirement.
> + *
> + * This SCM calls adds support for the generate key IOCTL to interface
> + * with the secure environment to generate and return a wrapped key..
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
> +			    u32 longterm_wrapped_key_size)

Isn't longterm_wrapped_key_size really a maximum size?  How does this function
indicate the size of the resulting key?

> +/**
> + * qcom_scm_prepare_ice_key() - Get per boot ephemeral wrapped key
> + * @longterm_wrapped_key: the wrapped key
> + * @longterm_wrapped_key_size: size of the wrapped key
> + * @ephemeral_wrapped_key: ephemeral wrapped key to be returned
> + * @ephemeral_wrapped_key_size: size of the ephemeral wrapped key
> + *
> + * Qualcomm wrapped keys (longterm keys) are rewrapped with a per-boot
> + * ephemeral key for added protection. These are ephemeral in nature as
> + * they are valid only for that boot. A create key IOCTL is used to
> + * achieve this. These are the keys that are installed into the kernel
> + * to be then unwrapped and programmed into ICE.
> + *
> + * This SCM call adds support for the create key IOCTL to interface
> + * with the secure environment to rewrap the wrapped key with an
> + * ephemeral wrapping key.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
> +			     u32 longterm_wrapped_key_size,
> +			     u8 *ephemeral_wrapped_key,
> +			     u32 ephemeral_wrapped_key_size)

Similarly here.  Isn't ephemeral_wrapped_key_size really a maximum size?  How
does this function indicate the size of the resulting ephemeral wrapped key?

> +/**
> + * qcom_scm_import_ice_key() - Import a wrapped key for encryption
> + * @imported_key: the raw key that is imported
> + * @imported_key_size: size of the key to be imported

imported_key and imported_key_size should be called raw_key and raw_key_size.

> + * @longterm_wrapped_key: the wrapped key to be returned
> + * @longterm_wrapped_key_size: size of the wrapped key
> + *
> + * Conceptually, this is very similar to generate, the difference being,
> + * here we want to import a raw key and return a longterm wrapped key
> + * from it. THe same create key IOCTL is used to achieve this.
> + *
> + * This SCM call adds support for the create key IOCTL to interface with
> + * the secure environment to import a raw key and generate a longterm
> + * wrapped key.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
> +			    u8 *longterm_wrapped_key,
> +			    u32 longterm_wrapped_key_size)

And likewise, isn't longterm_wrapped_key_size really a maximum size?  How does
this function indicate the size of the resulting key?

> diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
> index 08bb2a4c80db..efd0ede1fb37 100644
> --- a/drivers/firmware/qcom_scm.h
> +++ b/drivers/firmware/qcom_scm.h
> @@ -111,6 +111,9 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
>  #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
>  #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
>  #define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
> +#define QCOM_SCM_ES_GENERATE_ICE_KEY	0x08
> +#define QCOM_SCM_ES_PREPARE_ICE_KEY	0x09
> +#define QCOM_SCM_ES_IMPORT_ICE_KEY	0xA

Writing "0xA" here looks weird.  It should be "0x0A" to match the others.

- Eric
