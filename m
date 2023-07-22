Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96575D977
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 05:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjGVDrm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jul 2023 23:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGVDrk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jul 2023 23:47:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214AD30F2;
        Fri, 21 Jul 2023 20:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B207961DA6;
        Sat, 22 Jul 2023 03:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADFEC433C7;
        Sat, 22 Jul 2023 03:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689997658;
        bh=BQvfYCJsa6ckjpJhdKcCU11gI07/WqQDP3WMfFiEJog=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kWFnc6LHbDyUpWoyUVkYpoHQjl2ULGloldqdTNEMzlnTFnXIJxBDkDKrmjxmxKscH
         dCKjH+Lu/EM4oLni5k6UXlLLkJASgleGtoVU947kcRJ5+Ue8EBjJorsOhXNAyX9vgl
         20pqWGSlP804cRAKf1kIcHhSyzMapTCsTNPiFU4Y9yaeiz6okKhssntLcg1kbWib53
         dCOMlf0pG52Sz6IY8PtzNEaMj9lOgJWp2hpv+Y2TvUFE9RgStmaGUJaAH/DoeP5A3i
         4y27Vn+Y8u2kZL09J4INR33EW5tZfTUrmXYaKJI8ugfh1pIMrlemkosfNaGaCz6eCM
         7FXuNGaN0zW+A==
Date:   Fri, 21 Jul 2023 20:50:56 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com, linux-mmc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com,
        avmenon@quicinc.com, abel.vesa@linaro.org,
        quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 02/10] qcom_scm: scm call for deriving a software
 secret
Message-ID: <bhsyywrocfv256yi5hxticc72ojxelilezpnj67hauqqexokut@j2ivxaaaupdn>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-3-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719170423.220033-3-quic_gaurkash@quicinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 19, 2023 at 10:04:16AM -0700, Gaurav Kashyap wrote:

The $subject prefix does not match other changes in the scm driver.
Please use git log --oneline drivers/fimware/qcom_scm.c and follow what
other changes uses.

> Inline storage encryption requires deriving a sw secret from
> the hardware wrapped keys. For non-wrapped keys, this can be
> directly done as keys are in the clear.
> 
> However, when keys are hardware wrapped, it can be unwrapped
> by HWKM (Hardware Key Manager) which is accessible only from Qualcomm
> Trustzone. Hence, it also makes sense that the software secret is also
> derived there and returned to the linux kernel . This can be invoked by
> using the crypto profile APIs provided by the block layer.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  drivers/firmware/qcom_scm.c            | 70 ++++++++++++++++++++++++++
>  drivers/firmware/qcom_scm.h            |  1 +
>  include/linux/firmware/qcom/qcom_scm.h |  3 ++
>  3 files changed, 74 insertions(+)
> 
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index fde33acd46b7..51062d5c7f7b 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -1140,6 +1140,76 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>  }
>  EXPORT_SYMBOL(qcom_scm_ice_set_key);
>  
> +/**
> + * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped key
> + * @wrapped_key: the wrapped key used for inline encryption
> + * @wrapped_key_size: size of the wrapped key

Following my reply on patch 7, how about dropping the "_key" suffix on
these.

> + * @sw_secret: the secret to be derived which is exactly the secret size

Similarly the "sw_" prefix doesn't see to add value, please omit it.

> + * @secret_size: size of the secret
> + *
> + * Derive a SW secret from a HW Wrapped key for non HW key operations.
> + * For wrapped keys, the key needs to be unwrapped, in order to derive a
> + * SW secret, which can be done only by the secure EE.

Please spell out SW, HW, and EE in this sentence.

> + *
> + * For more information on sw secret, please refer to "Hardware-wrapped keys"
> + * section of Documentation/block/inline-encryption.rst.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
> +			      u8 *sw_secret, u32 secret_size)

size_t is a better data type for "a size". (Think I forgot to mention
this in the other patch as well).

> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = wrapped_key_size,
> +		.args[3] = secret_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *keybuf, *secretbuf;
> +	dma_addr_t key_phys, secret_phys;
> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *

Unnecessary empty line.

> +	 */
> +	keybuf = dma_alloc_coherent(__scm->dev, wrapped_key_size, &key_phys,
> +				    GFP_KERNEL);

Unwrapping this line takes you to 89 characters, which is less than 100
and easier to read. So please bend the 80-char recommendation for this.

> +	if (!keybuf)
> +		return -ENOMEM;
> +	secretbuf = dma_alloc_coherent(__scm->dev, secret_size, &secret_phys,
> +				    GFP_KERNEL);

Same here

> +	if (!secretbuf) {
> +		ret = -ENOMEM;
> +		goto bail_keybuf;
> +	}
> +
> +	memcpy(keybuf, wrapped_key, wrapped_key_size);
> +	desc.args[0] = key_phys;
> +	desc.args[2] = secret_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(sw_secret, secretbuf, secret_size);
> +
> +	memzero_explicit(secretbuf, secret_size);

Empty line here would provide a nice separation between the zeroing and
the freeing.

> +	dma_free_coherent(__scm->dev, secret_size, secretbuf, secret_phys);
> +
> +bail_keybuf:

Both buffers are keys

err_free_wrapped:

> +	memzero_explicit(keybuf, wrapped_key_size);

And it seems sufficient to move this up together with the other
memzero_explicit() as well.

Regards,
Bjorn
