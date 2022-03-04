Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197924CCAFA
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Mar 2022 01:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbiCDA6W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Mar 2022 19:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiCDA6R (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Mar 2022 19:58:17 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2247B113C;
        Thu,  3 Mar 2022 16:57:30 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id w37so6155767pga.7;
        Thu, 03 Mar 2022 16:57:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oBUGJ1WdZlkb4xFjXCpCJoTSHchqi/bGq9el9Zwr8P0=;
        b=04Oo0/+nS1yt3LNd71tz7Mgn8AEhlNxe9Sx4HvvlJToU85bpqXzuGo6Ub55ttd67Ie
         mzUVsvO3kLkeFh74q3zfhmL/e8wVIJDJ7Na+1Vkw7NtqEwgart/cwMjWIc5ii2mu2uCi
         IrcPRZ04OEAFiqpPcHBC+HS84cn0PadyuUga6FGYSLLTjK0bd7UMWg/VUtFvNcO1xvo7
         P3oVVK8c/ELR1cgmunjBZgCZVn6aTfsuurOCPS0PxZfsPux7BkgO+a+xhwUAjhCx+XA9
         qwvgXAoBTrEy/xVIAKvRY2aB9vmxrziYdkYAmf7ZoNrAgLLl9n7nqNQiizbv7vw76Bki
         5rNA==
X-Gm-Message-State: AOAM530E6ESwzfL8kaIv/1+0Pou4qCkSx0B0iziPXYpKi22E5P7HL+ep
        +zxLQWD0Gfp6fXg1N5PKRKNpI77PqGU=
X-Google-Smtp-Source: ABdhPJxvwgHoC6IlFJHO0n1vuNVp/z1hFnemhyMW1EnJxkr10yWMfw5McNT0JWqMCEpCTk4ho+9M5g==
X-Received: by 2002:a63:8bc8:0:b0:37c:8fda:386c with SMTP id j191-20020a638bc8000000b0037c8fda386cmr1729066pge.404.1646355449456;
        Thu, 03 Mar 2022 16:57:29 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id on18-20020a17090b1d1200b001b9cfbfbf00sm3072439pjb.40.2022.03.03.16.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 16:57:28 -0800 (PST)
Message-ID: <3dfbff45-f69a-b916-cea6-d99a111ee592@acm.org>
Date:   Thu, 3 Mar 2022 16:57:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 2/3] block: add ioctls to create and prepare
 hardware-wrapped keys
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
References: <20220228070520.74082-1-ebiggers@kernel.org>
 <20220228070520.74082-3-ebiggers@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220228070520.74082-3-ebiggers@kernel.org>
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
> +int blk_crypto_import_key(struct blk_crypto_profile *profile,
> +			  const u8 *raw_key, size_t raw_key_size,
> +			  u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	int ret = -EOPNOTSUPP;
> +
> +	if (profile &&
> +	    (profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) &&
> +	    profile->ll_ops.import_key) {
> +		blk_crypto_hw_enter(profile);
> +		ret = profile->ll_ops.import_key(profile, raw_key, raw_key_size,
> +						 longterm_wrapped_key);
> +		blk_crypto_hw_exit(profile);
> +	}
> +	return ret;
> +}

For the above and similar functions, please return early if the preconditions 
have not been met.

> +	}
> +	ret = 0;
> +out:
> +	memzero_explicit(raw_key, sizeof(raw_key));
> +	memzero_explicit(longterm_wrapped_key, sizeof(longterm_wrapped_key));
> +	return ret;
> +}

Please leave a blank line above goto labels

Thanks,

Bart.
