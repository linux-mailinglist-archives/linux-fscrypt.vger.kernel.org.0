Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FA51E8293
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2020 17:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgE2PyX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 May 2020 11:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2PyW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 May 2020 11:54:22 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A7CC08C5C6
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2020 08:54:21 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s1so2601719qkf.9
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2020 08:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jAZEmeSRW8ruDxsVIJHiZnQc1uKz6c8cJEE/DAMVmG8=;
        b=Cvi1doDaVIU1tjJPBprDVj0FVwq7jiOaXC7E/40SnLlLuwTTJhJ1xxcZhLqLzEF+Te
         jM7uzW0Za5lm5BgNlPCJ1cgguX9WJTwArV78Pk4g7h4cgWbz+vqtIN9sbjbm37yaXW8W
         dAWgVwE0iTL8Lxn5VsHYbSQnCNvW3nhQ3a/U8Qk+An2Znot/bcO7ZFiygyY6PrjJoxD7
         5V8gOwpS8aL741k7EbSpAoDy/zYoCKC38p/lwWZgckjm/FZe+nMC8clGusUh39CdaYUd
         weJBouQ05n7COyckI4NFb5XKi0ozPiQnloFxpPa/8NmYNrPKKeuz3fPm/fwKA4HiDFTG
         YfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jAZEmeSRW8ruDxsVIJHiZnQc1uKz6c8cJEE/DAMVmG8=;
        b=PgQBrbOHQnfOcQh9o9Kb1ZQImWs82VzXudDtscAMcXuWpMu6B+8B8pFsfz3W7bwjVD
         Ll6TF6ki/rF8iJn3rm8fwTPT/nfjyBvvyW3HHDltHVmjOErdGsy+D2qzC8J5/1H8CweT
         GkadLrI0LacPKSOSeIH7WN2qhTMJ4Nb013V0G6G1W9Lh2SB8FQEN13jtI2G13EIOMniu
         l0mWXaua98u1FYuhhzuzzRmocPrpLR44cirJQ3K7IAg+bNxu8h6WpPBA6TCMCjF2S4Mc
         lkRO+Xd7Wzpmk4DxJETXLynXPYBp0Ynq5wsfrYxsQx47fmTrBNTsyKpggzSa3sebRoJM
         pF5g==
X-Gm-Message-State: AOAM531h/zOUIjD3+ssuw9LHgaep5lK/hCUGbl4jhCLVhDTE9t3M91y3
        iLGmZR95HkTFAX6jA7l2MmmCFA==
X-Google-Smtp-Source: ABdhPJxMNDaOikkYGBrV6CrZ5Mck0KcFjiHViFDUm7sCtJU3LXHFFao7/bkIR5WhKNCY5/HAeuKUng==
X-Received: by 2002:a37:b16:: with SMTP id 22mr7584237qkl.181.1590767660554;
        Fri, 29 May 2020 08:54:20 -0700 (PDT)
Received: from [192.168.1.92] (pool-71-255-246-27.washdc.fios.verizon.net. [71.255.246.27])
        by smtp.gmail.com with ESMTPSA id x41sm8778389qtb.76.2020.05.29.08.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 08:54:19 -0700 (PDT)
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com> <20200507180838.GC236103@gmail.com>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <40600d42-dfa9-b60c-6ce8-0eda6bdf7ddf@linaro.org>
Date:   Fri, 29 May 2020 11:54:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507180838.GC236103@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 5/7/20 2:08 PM, Eric Biggers wrote:
> On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
>> Hi Thara,
>>
>> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
>>>
>>>
>>> On 5/1/20 12:51 AM, Eric Biggers wrote:
>>>> From: Eric Biggers <ebiggers@google.com>
>>>>
>>>> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
>>>>
>>>> The standards-compliant parts, such as querying the crypto capabilities
>>>> and enabling crypto for individual UFS requests, are already handled by
>>>> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
>>>> However, ICE requires vendor-specific init, enable, and resume logic,
>>>> and it requires that keys be programmed and evicted by vendor-specific
>>>> SMC calls.  Make the ufs-qcom driver handle these details.
>>>>
>>>> I tested this on Dragonboard 845c, which is a publicly available
>>>> development board that uses the Snapdragon 845 SoC and runs the upstream
>>>> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
>>>> phones.  This testing included (among other things) verifying that the
>>>> expected ciphertext was produced, both manually using ext4 encryption
>>>> and automatically using a block layer self-test I've written.
>>> Hello Eric,
>>>
>>> I am interested in testing out this series on 845, 855 and if possile on 865
>>> platforms. Can you give me some more details about your testing please.
>>>
>>
>> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
>>
>> A basic manual test would be:
>>
>> 1. Build a kernel with:
>>
>> 	CONFIG_BLK_INLINE_ENCRYPTION=y
>> 	CONFIG_FS_ENCRYPTION=y
>> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> 
> Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.

Hi Eric,

I tested this manually on db845c, sm8150-mtp and sm8250-mtp.(I added the 
dts file entries for 8150 and 8250).

I also ran OsBench test case createfiles[1] on the above platforms. 
Following are the results on a non encrypted and encrypted directory on 
the same file system(lower the number better)

			8250-MTP	8150-MTP	DB845

nonencrypt_dir(us) 	55.3108954	26.8323124    69.5709552
encrypt_dir(us) 	70.0214426	37.5411254    92.3818296



1. https://github.com/mbitsnbites/osbench/blob/master/README.md

-- 
Warm Regards
Thara
