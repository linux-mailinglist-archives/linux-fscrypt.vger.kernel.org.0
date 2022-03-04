Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F34CCAEE
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Mar 2022 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbiCDAyr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Mar 2022 19:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiCDAyq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Mar 2022 19:54:46 -0500
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0699A13DE21;
        Thu,  3 Mar 2022 16:54:00 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id s11so6180638pfu.13;
        Thu, 03 Mar 2022 16:54:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YJwEZHpBOkrX91NRDhiBnL9TsivdhXedQE1MEXdFkGk=;
        b=KLqrmsV0QMDFisEQB581pHpZA0EGa9UiO3CkbzHNOLMFnxj91kwkuw2WUOmut/cUHN
         nsbxWH+4ijCJTsCaBks4mFTZsPmVVsrPGEbnSfFFiR7JcRGFrYFYOruemTxwDZnCH7fJ
         zQtxl6g4+Rms0YodOQpQEXORNmg/g7Y1LWOGKH1+ZHo6mLNnNkzu2mxcCIBgZusZwVOx
         o0iVQmtj+HW8pPuljIBUiM+rD1OoJhZpUalYj15k7VwZWmAYOdbaRO7Ry2viyIDvD0vt
         VFB+SUc366GmdWzOLE4z897D9QcCR3/XeMJkQS8RIoQWuq76qlMsF5Od8Em1cvPuOK3z
         0ksg==
X-Gm-Message-State: AOAM530u1mkxOBZNGjel/zsl7R0We785t3M94/vqJ5SMjwrSlu+RgvFe
        Py1zLpHO+BS4SzjtAysxZaw=
X-Google-Smtp-Source: ABdhPJwrunTYNLwCSAFqvfBGbiuz/Fhz9cSPhSzz+gpBillc7qLhh3XO4rOBM76VfXVVCsK+o8PRkg==
X-Received: by 2002:aa7:970e:0:b0:4f6:6c73:24c3 with SMTP id a14-20020aa7970e000000b004f66c7324c3mr6208291pfg.32.1646355239206;
        Thu, 03 Mar 2022 16:53:59 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s2-20020a056a001c4200b004f41e1196fasm3699345pfw.17.2022.03.03.16.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 16:53:58 -0800 (PST)
Message-ID: <ac499ff9-eeb4-4f25-bb59-3f37477190ed@acm.org>
Date:   Thu, 3 Mar 2022 16:53:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 1/3] block: add basic hardware-wrapped key support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
References: <20220228070520.74082-1-ebiggers@kernel.org>
 <20220228070520.74082-2-ebiggers@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220228070520.74082-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2/27/22 23:05, Eric Biggers wrote:
> -static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
> +static u8 blank_key[BLK_CRYPTO_MAX_STANDARD_KEY_SIZE];
>   
>   static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
>   {
> @@ -539,7 +539,7 @@ static int blk_crypto_fallback_init(void)
>   	if (blk_crypto_fallback_inited)
>   		return 0;
>   
> -	prandom_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
> +	prandom_bytes(blank_key, BLK_CRYPTO_MAX_STANDARD_KEY_SIZE);

Please use sizeof(blank_key) to make it easier for readers to verify that the 
length argument is correct.

> +int blk_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
> +				const u8 *wrapped_key,
> +				unsigned int wrapped_key_size,
> +				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	int err = -EOPNOTSUPP;
> +
> +	if (profile &&
> +	    (profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) &&
> +	    profile->ll_ops.derive_sw_secret) {
> +		blk_crypto_hw_enter(profile);
> +		err = profile->ll_ops.derive_sw_secret(profile, wrapped_key,
> +						       wrapped_key_size,
> +						       sw_secret);
> +		blk_crypto_hw_exit(profile);
> +	}
> +	return err;
> +}

Please use the common kernel style: return early if the preconditions have not 
been met. That helps to keep the indentation level low.

> @@ -68,7 +71,10 @@ static int __init bio_crypt_ctx_init(void)
>   
>   	/* Sanity check that no algorithm exceeds the defined limits. */
>   	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++) {
> -		BUG_ON(blk_crypto_modes[i].keysize > BLK_CRYPTO_MAX_KEY_SIZE);
> +		BUG_ON(blk_crypto_modes[i].keysize >
> +		       BLK_CRYPTO_MAX_STANDARD_KEY_SIZE);
> +		BUG_ON(blk_crypto_modes[i].security_strength >
> +		       blk_crypto_modes[i].keysize);
>   		BUG_ON(blk_crypto_modes[i].ivsize > BLK_CRYPTO_MAX_IV_SIZE);
>   	}

Does the following advice from Linus Torvalds apply to the above code: "because 
there is NO EXCUSE to knowingly kill the kernel"? See also 
https://lkml.org/lkml/2016/10/4/1.

Thanks,

Bart.
