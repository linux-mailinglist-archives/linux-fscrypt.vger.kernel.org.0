Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0444CCB19
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Mar 2022 02:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiCDBEA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Mar 2022 20:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiCDBEA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Mar 2022 20:04:00 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A981C57B3D;
        Thu,  3 Mar 2022 17:03:13 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id z4so6148327pgh.12;
        Thu, 03 Mar 2022 17:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WAaNwNjFdmAb/ELfLocE3xhHUoy30BjGXW+a5GnVwQs=;
        b=lfMypBV/tdx7sqonCx4+Vh7DaCCbwltXbwpJvR67DXWmiDFs0+iOSdjye74Q4QWz/g
         +OSGgVlY+nO4JSWn7xS6RdFfI58xvyEUjrC5DFo2s9FGjqCg1c+uvjVtj8neOeLRi13X
         g7x6Fwyn3/8/qfnQQecYau2L6HbetUzhKWDwqycNCA3rkuj3RewzhLijaTQ2oFpBfK9b
         gHKyoj90NfgbQ8aiq2XfbknV7iKL2wf1ZCmocnIvNYF2eK2F7djNMxWDKwkEIXHXRkFo
         f7CUMtfr3h+gfh6ukngnuKmPhQOH9vLoNRtmGX/L0DZKvayGCOLr750YYywXmcc8Xgv+
         YoEA==
X-Gm-Message-State: AOAM532pSe7MH+J9nK2T/nGQ3oNeraPyawtIgEPCdxHhrewc5FcUaEzb
        ga983JI9TSH99NncVzNGFjWKoLy+NzA=
X-Google-Smtp-Source: ABdhPJw5hH+28BVGYnJiZ5SMub/SuIM/BnXRVSbAWZuE2Xt6mp7mIAUqBW2hE2/QE7KeWyVb9Y7cvw==
X-Received: by 2002:a63:1003:0:b0:378:7d70:2ec5 with SMTP id f3-20020a631003000000b003787d702ec5mr22504677pgl.351.1646355792997;
        Thu, 03 Mar 2022 17:03:12 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id il17-20020a17090b165100b001bcd92fd355sm3329276pjb.28.2022.03.03.17.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 17:03:12 -0800 (PST)
Message-ID: <c1da8aec-7bb9-dd88-7500-a09d29bbc1e4@acm.org>
Date:   Thu, 3 Mar 2022 17:03:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 3/3] fscrypt: add support for hardware-wrapped keys
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
References: <20220228070520.74082-1-ebiggers@kernel.org>
 <20220228070520.74082-4-ebiggers@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220228070520.74082-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2/27/22 23:05, Eric Biggers wrote:
> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
> index 9f4428be3e362..884c5bf526a05 100644
> --- a/include/uapi/linux/fscrypt.h
> +++ b/include/uapi/linux/fscrypt.h
> @@ -20,6 +20,7 @@
>   #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
>   #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
>   #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
> +#define FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY	0x20
>   
>   /* Encryption algorithms */
>   #define FSCRYPT_MODE_AES_256_XTS		1
> @@ -115,7 +116,7 @@ struct fscrypt_key_specifier {
>    */
>   struct fscrypt_provisioning_key_payload {
>   	__u32 type;
> -	__u32 __reserved;
> +	__u32 flags;
>   	__u8 raw[];
>   };
>   
> @@ -124,7 +125,9 @@ struct fscrypt_add_key_arg {
>   	struct fscrypt_key_specifier key_spec;
>   	__u32 raw_size;
>   	__u32 key_id;
> -	__u32 __reserved[8];
> +#define FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED			0x00000001
> +	__u32 flags;
> +	__u32 __reserved[7];
>   	__u8 raw[];
>   };

Is it allowed to use _Static_assert() in UAPI header files? There are already 
some static_assert() checks under include/linux to verify the size of certain 
data structures. gcc supports _Static_assert() since version 4.6. That is older 
than the minimum required gcc version to build the kernel.

Thanks,

Bart.
