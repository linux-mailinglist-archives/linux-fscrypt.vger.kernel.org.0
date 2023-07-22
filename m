Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E1C75D96F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 05:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjGVDhR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jul 2023 23:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGVDhQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jul 2023 23:37:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1BC359C;
        Fri, 21 Jul 2023 20:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 639C261DA6;
        Sat, 22 Jul 2023 03:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2525C433C7;
        Sat, 22 Jul 2023 03:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689997033;
        bh=YcMmx76O+AbG3FqQogXCowvd6U6/PqPiFJRuS8CopFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLUEXC3aWRLHdVgxvyF73gFRrDdMaVHbQvEU5vQSG1GsdolPOdPO327093w+joqg/
         c8Y6m2EgkIVcJaMjxPW0tpY6kC+V3/6GuDeniaX4mH+PFUHX6iFwv0tsSWesZWnDpN
         bWQjKUBCQxg1GMJIy9dVN9QaYYR1s0YUVi5zkhoHPWLOOJI2D6xSNDkKogTXikVmG8
         +zwawE9RGvvLsby84r2ENftPNtCDAX14TJ7kLD90jsoXS6Skugy5TPnxSGW8xQjOTv
         4wnx7oSml54m7ET+b+YXBYzn1cwmICy2ooObdbWvFzj3RLDNVgxP7hnerfGfhhuKcW
         7Hkdmo9A645pg==
Date:   Fri, 21 Jul 2023 20:40:32 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com, linux-mmc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com,
        avmenon@quicinc.com, abel.vesa@linaro.org,
        quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 07/10] qcom_scm: scm call for create, prepare and
 import keys
Message-ID: <uezt2yq7i4msohz27g2j6apngjp6frvxlj2qt46vg7hnds5hrs@quyhskyzui4b>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-8-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719170423.220033-8-quic_gaurkash@quicinc.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 19, 2023 at 10:04:21AM -0700, Gaurav Kashyap wrote:
> Storage encryption has two IOCTLs for creating, importing
> and preparing keys for encryption. For wrapped keys, these
> IOCTLs need to interface with the secure environment, which
> require these SCM calls.
> 
> generate_key: This is used to generate and return a longterm
>               wrapped key. Trustzone achieves this by generating
> 	      a key and then wrapping it using hwkm, returning
> 	      a wrapped keyblob.
> import_key:   The functionality is similar to generate, but here,
>               a raw key is imported into hwkm and a longterm wrapped
> 	      keyblob is returned.
> prepare_key:  The longterm wrapped key from import or generate
>               is made further secure by rewrapping it with a per-boot
> 	      ephemeral wrapped key before installing it to the linux
> 	      kernel for programming to ICE.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/firmware/qcom_scm.c            | 222 +++++++++++++++++++++++++
>  drivers/firmware/qcom_scm.h            |   3 +
>  include/linux/firmware/qcom/qcom_scm.h |  10 ++
>  3 files changed, 235 insertions(+)
> 
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index 51062d5c7f7b..44dd1857747b 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -1210,6 +1210,228 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
>  }
>  EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
>  
> +/**
> + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> + * @longterm_wrapped_key: the wrapped key returned after key generation

"longterm" was long enough that you didn't feel it made sense in the
description ;)

Jokes aside, please follow the convention described in:
https://www.kernel.org/doc/html/v4.10/process/coding-style.html#naming

"key" or "wrapped_key" sounds sufficient to me.

> + * @longterm_wrapped_key_size: size of the wrapped key to be returned.
> + *
> + * Qualcomm wrapped keys need to be generated in a trusted environment.
> + * A generate key  IOCTL call is used to achieve this. These are longterm
> + * in nature as they need to be generated and wrapped only once per
> + * requirement.
> + *
> + * This SCM calls adds support for the generate key IOCTL to interface
> + * with the secure environment to generate and return a wrapped key..

I'm afraid I don't fully understand this sentence, please rework it.

> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
> +			    u32 longterm_wrapped_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(2, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),

Leaving this line unwrapped brings you to 71 characters, you have 80
(with stretch of 100) as the limit.

> +		.args[1] = longterm_wrapped_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *longterm_wrapped_keybuf;

"buf" or "tmp" sounds sufficient.

> +	dma_addr_t longterm_wrapped_key_phys;

"phys" or "addr"

> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *
> +	 */
> +	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				  longterm_wrapped_key_size,
> +				  &longterm_wrapped_key_phys, GFP_KERNEL);
> +	if (!longterm_wrapped_keybuf)
> +		return -ENOMEM;
> +
> +	desc.args[0] = longterm_wrapped_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	memcpy(longterm_wrapped_key, longterm_wrapped_keybuf,
> +	       longterm_wrapped_key_size);

The idiomatic way is to not touch the output buffer if the call fails,
any particular reason for you to not follow this here?

> +
> +	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
> +			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);

With better choice of variable names you might be able to leave this
unwrapped (remember the guideline is 80, but you can go over that
slightly if it benefits readability)

> +
> +	if (!ret)
> +		return longterm_wrapped_key_size;

It's also idiomatic to return early on errors. So please swap this
around to make the successful exit at the end.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_generate_ice_key);
> +
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

wrapped, wrapped_size, ephemeral, ephemeral_size perhaps?

> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = longterm_wrapped_key_size,
> +		.args[3] = ephemeral_wrapped_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *longterm_wrapped_keybuf, *ephemeral_wrapped_keybuf;
> +	dma_addr_t longterm_wrapped_key_phys, ephemeral_wrapped_key_phys;
> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *
> +	 */
> +	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				  longterm_wrapped_key_size,
> +				  &longterm_wrapped_key_phys, GFP_KERNEL);
> +	if (!longterm_wrapped_keybuf)
> +		return -ENOMEM;
> +	ephemeral_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				   ephemeral_wrapped_key_size,
> +				   &ephemeral_wrapped_key_phys, GFP_KERNEL);
> +	if (!ephemeral_wrapped_keybuf) {
> +		ret = -ENOMEM;
> +		goto bail_keybuf;
> +	}
> +
> +	memcpy(longterm_wrapped_keybuf, longterm_wrapped_key,
> +	       longterm_wrapped_key_size);
> +	desc.args[0] = longterm_wrapped_key_phys;
> +	desc.args[2] = ephemeral_wrapped_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(ephemeral_wrapped_key, ephemeral_wrapped_keybuf,
> +		       ephemeral_wrapped_key_size);
> +
> +	memzero_explicit(ephemeral_wrapped_keybuf, ephemeral_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, ephemeral_wrapped_key_size,
> +			  ephemeral_wrapped_keybuf,
> +			  ephemeral_wrapped_key_phys);
> +
> +bail_keybuf:

Which "key"?

Perhaps

err_free_longterm_buf:

> +	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);

I don't see a reason to memzero_explicit(longterm_buf) in the
bail_keybuf. Move this up and memzero_explicit() both buffers at the
same time, then dma_free_coherent() them.

> +	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
> +			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
> +
> +	if (!ret)
> +		return ephemeral_wrapped_key_size;

As above, flip the two cases.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_prepare_ice_key);
> +
> +/**
> + * qcom_scm_import_ice_key() - Import a wrapped key for encryption
> + * @imported_key: the raw key that is imported
> + * @imported_key_size: size of the key to be imported
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

Same thing with naming here, please.

> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = imported_key_size,
> +		.args[3] = longterm_wrapped_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *imported_keybuf, *longterm_wrapped_keybuf;
> +	dma_addr_t imported_key_phys, longterm_wrapped_key_phys;
> +	int ret;

Declaration above and comment below are two separate "paragraphs", so a
empty line between them would be good.

> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *
> +	 */
> +	imported_keybuf = dma_alloc_coherent(__scm->dev, imported_key_size,
> +			  &imported_key_phys, GFP_KERNEL);
> +	if (!imported_keybuf)
> +		return -ENOMEM;
> +	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				  longterm_wrapped_key_size,
> +				  &longterm_wrapped_key_phys, GFP_KERNEL);
> +	if (!longterm_wrapped_keybuf) {
> +		ret = -ENOMEM;
> +		goto bail_keybuf;
> +	}
> +
> +	memcpy(imported_keybuf, imported_key, imported_key_size);
> +	desc.args[0] = imported_key_phys;
> +	desc.args[2] = longterm_wrapped_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(longterm_wrapped_key, longterm_wrapped_keybuf,
> +		       longterm_wrapped_key_size);
> +
> +	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
> +			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
> +bail_keybuf:
> +	memzero_explicit(imported_keybuf, imported_key_size);

As above, please move this together with the other memzero_explicit().

> +	dma_free_coherent(__scm->dev, imported_key_size, imported_keybuf,
> +			  imported_key_phys);
> +
> +	if (!ret)

And flip these.

Regards,
Bjorn
