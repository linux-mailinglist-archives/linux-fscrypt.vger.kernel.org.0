Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BC1E89FE
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2020 23:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgE2VZv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 May 2020 17:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgE2VZt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 May 2020 17:25:49 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E8DC08C5CB
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2020 14:25:49 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id w90so3178850qtd.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2020 14:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0NVhJpZVOHuuQ+bSCwQVo2cpvSDBbOMGIQW9zICcowo=;
        b=sShWQ8ck7UwdQzbNXfEGDqaVlJTJYDI2Eg5NaAacCL4Urm6bYmuWp5OHNJCYp2k/yf
         hBMbF6to5RL2zs0hv42KuYGzDlH37+UHm3jJmNRBuqbU9itQf3FXs2HIRTDN0llyIZaR
         hA+CdLEOVGRmpJaLSKfAdaa+zOxvN8NFcBrTR9/dK7xWY52ywdQoCP3tXIUf9XXrqgRx
         8LruET2uArxZb6p4dY9C9f5LSp/ATie2Pk1AABu3YhsIiFSgGoUP2G0rY9q5Ra3fc46H
         dW/l/W3GAnHYOo4YkSjHGd6+4wpV0pfgJjsn/wXfneipvYoJMF7SjlRIHHGTEfNU7PIk
         ZlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0NVhJpZVOHuuQ+bSCwQVo2cpvSDBbOMGIQW9zICcowo=;
        b=XeBPvQOeX763slL2motYK7K0k93OFG4JdhfnLsauF5yPDsH0KoxRBWf/YLeEfQ8/7a
         I369vTQvcQEbptdwCq9bWwyo0sMpie2ojJsJD+j3vXrT7Cz5DBVleDrXGiOq8LAWMt0+
         dyLzRVG+n/hG8uykSHg8yGMf17eDcCS67+D6EvE34/3W3Rsi1l8jUIp7II4RJoSKZUmk
         NKpLRvcN57JnouaRYQHf0C6Cn0B6vRuDy1+deyylki64aJq7wI+s7rQCZEXoxMA0z06K
         KMmvZM0X3xGJy6jD1QKhkX9diGx2NJ3WYUajM/F/qWlxnh3rHiDMWt/Ijxp28zWCR42I
         7i4w==
X-Gm-Message-State: AOAM530UaiSa4S+j5lHqb9tzWQCjvo2wEMxfilirYCduGkTFht43wYI9
        AaUwV5FPLk671vonHwmDbhadxw==
X-Google-Smtp-Source: ABdhPJzCWnh+qgUZ+gmRtXuj/lng/ZiY1JuE9JmrdKcfdhJJzfBAi5DgZbwsyKKm2WIb0OohXni2qQ==
X-Received: by 2002:ac8:6ec2:: with SMTP id f2mr10845034qtv.309.1590787548822;
        Fri, 29 May 2020 14:25:48 -0700 (PDT)
Received: from [192.168.1.92] (pool-71-255-246-27.washdc.fios.verizon.net. [71.255.246.27])
        by smtp.gmail.com with ESMTPSA id e57sm8023438qta.12.2020.05.29.14.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2020 14:25:48 -0700 (PDT)
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
 <40600d42-dfa9-b60c-6ce8-0eda6bdf7ddf@linaro.org>
 <20200529171326.GA82398@gmail.com>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <676394c6-4250-8998-d959-68cd218991e5@linaro.org>
Date:   Fri, 29 May 2020 17:25:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200529171326.GA82398@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 5/29/20 1:13 PM, Eric Biggers wrote:
> On Fri, May 29, 2020 at 11:54:18AM -0400, Thara Gopinath wrote:
>> On 5/7/20 2:08 PM, Eric Biggers wrote:
>>> On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
>>>> Hi Thara,
>>>>
>>>> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
>>>>>
>>>>>
>>>>> On 5/1/20 12:51 AM, Eric Biggers wrote:
>>>>>> From: Eric Biggers <ebiggers@google.com>
>>>>>>
>>>>>> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
>>>>>>
>>>>>> The standards-compliant parts, such as querying the crypto capabilities
>>>>>> and enabling crypto for individual UFS requests, are already handled by
>>>>>> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
>>>>>> However, ICE requires vendor-specific init, enable, and resume logic,
>>>>>> and it requires that keys be programmed and evicted by vendor-specific
>>>>>> SMC calls.  Make the ufs-qcom driver handle these details.
>>>>>>
>>>>>> I tested this on Dragonboard 845c, which is a publicly available
>>>>>> development board that uses the Snapdragon 845 SoC and runs the upstream
>>>>>> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
>>>>>> phones.  This testing included (among other things) verifying that the
>>>>>> expected ciphertext was produced, both manually using ext4 encryption
>>>>>> and automatically using a block layer self-test I've written.
>>>>> Hello Eric,
>>>>>
>>>>> I am interested in testing out this series on 845, 855 and if possile on 865
>>>>> platforms. Can you give me some more details about your testing please.
>>>>>
>>>>
>>>> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
>>>>
>>>> A basic manual test would be:
>>>>
>>>> 1. Build a kernel with:
>>>>
>>>> 	CONFIG_BLK_INLINE_ENCRYPTION=y
>>>> 	CONFIG_FS_ENCRYPTION=y
>>>> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
>>>
>>> Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
>>
>> Hi Eric,
>>
>> I tested this manually on db845c, sm8150-mtp and sm8250-mtp.(I added the dts
>> file entries for 8150 and 8250).
>>
>> I also ran OsBench test case createfiles[1] on the above platforms.
>> Following are the results on a non encrypted and encrypted directory on the
>> same file system(lower the number better)
>>
>> 			8250-MTP	8150-MTP	DB845
>>
>> nonencrypt_dir(us) 	55.3108954	26.8323124    69.5709552
>> encrypt_dir(us) 	70.0214426	37.5411254    92.3818296
>>
>>
>>
>> 1. https://github.com/mbitsnbites/osbench/blob/master/README.md
>>
> 
> Great, thanks for testing.
> 
> Note that the benchmark you ran (creating many small files, then deleting them)
> mostly tests the performance of filenames encryption and directory operations,
> not file contents encryption.  Inline encryption is only used for file contents.
> 
> In fact, since that benchmark doesn't sync the files before deleting them, there
> is no guarantee that any file contents are actually written to disk, and hence
> no guarantee that inline encryption got used at all.

Hi Eric,

The results are particularly interesting if you think a sync is not 
happening. There should not be any performance regression in this case 
between the two directories. I can try some reading/writing performance 
tests rather than creating files testing.

> 
> It would be more relevant to test the performance of reading/writing file data.
> 
> Also, did you try doing any correctness tests?  (See what I suggested earlier.)

I did correctness test as part of manual tests by diffing the content of 
the copied files and verifying them. I did not run any other tests you 
mentioned. Feel free to add my Tested-by in the next version you send out.

> 
> - Eric
> 

-- 
Warm Regards
Thara
