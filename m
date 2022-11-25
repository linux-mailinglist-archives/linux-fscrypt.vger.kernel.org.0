Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2D638FEC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Nov 2022 19:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKYShM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Nov 2022 13:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiKYShL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Nov 2022 13:37:11 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBA951332
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Nov 2022 10:37:09 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z17so30977pff.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 25 Nov 2022 10:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwNmDYJLvH0fNlAuB17otvNLFcfDDeVwQfBxy2OZKy4=;
        b=DFWOdgVffQEaPKJgFNPxYGixrCEmD68TAlRQCfTZRHihIZKPahl9mmNUwVV6MabUob
         67IYLgEHD7HngVHsUObZQB9M23ycSG0fWkBGg5tLbVwADl5+xopvDWnvdzkmRzWjD7zb
         F/6ck0k4eukDauNYWv/l7P3TZDaB/kKMeoLlpFmUbaDBveGybMhdjtVsqtIwNF7NZFJD
         KWRCcbFSHjXns0w246dLkmeRZETWDJ89FsiVQN0dz29HvUj2ybvYJpmQ41zM6tHxX5nF
         GfhxadRcwJgNtGoPgcUpFh8+BJkny2DQ+e97JOdEuQ9r/bwpLPGMVWR4gCL5Jp42oLgh
         ky5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwNmDYJLvH0fNlAuB17otvNLFcfDDeVwQfBxy2OZKy4=;
        b=DLWhqRNE7BUpPZ8HGEFjrabg0vnwqNgTzQD+M9DOEMsIuqTlosGWNiUfkWGCxPF1+j
         scT5Xff++nXFAMPx1TftDeH6sCdbuzjqMTjZ60IAnxtLqIi7X/Q/ctoY7Ex61vp1GrrB
         9y+tFQiUg4Zf4As72OTUtFQ8ns14PkdXPuSwmvxYHB43RDNY5slgKk+1E5MwDb0fXpDj
         dkCsNymauwZd1EarN/igVtyDqOOvQkK6QK2zUeG5HGIcySpBZYoJUk6rfC/+rrltXUks
         nUPliP5x6qdLZTbCRAcvJEBZjgFFQK+wUzfvE+MmK6y7plnV1giKjo5xY0nRCh8B8t54
         FofA==
X-Gm-Message-State: ANoB5plQ0VBbpsG+Q4VlzujExacvioEQul6yD/KjbRCL9hjBB4vbfWc0
        oFPP4zslcrwfWyie+zqX2i5Chw==
X-Google-Smtp-Source: AA0mqf7DlfJmrpCywLPdyGNskOM1iXNX+AUH0PDt/4/XJNMU0kw/iZ1yC/EsSkaxwZfb9Dz10i2amw==
X-Received: by 2002:a63:4d49:0:b0:46f:5bd0:492f with SMTP id n9-20020a634d49000000b0046f5bd0492fmr35299298pgl.186.1669401429087;
        Fri, 25 Nov 2022 10:37:09 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id e15-20020a170902ed8f00b00177efb56475sm3765743plj.85.2022.11.25.10.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 10:37:08 -0800 (PST)
Message-ID: <69b144a9-a8d6-08ba-24e8-76bbe7970294@kernel.dk>
Date:   Fri, 25 Nov 2022 11:37:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3 1/2] blk-crypto: Add support for SM4-XTS blk crypto
 mode
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-2-tianjia.zhang@linux.alibaba.com>
 <Y4EK4iEmvPWRNRm9@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y4EK4iEmvPWRNRm9@sol.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11/25/22 11:35 AM, Eric Biggers wrote:
> On Fri, Nov 25, 2022 at 08:16:29PM +0800, Tianjia Zhang wrote:
>> SM4 is a symmetric algorithm widely used in China, and SM4-XTS is also
>> used to encrypt length-preserving data, these algoritms are mandatory
>> in many scenarios. This patch enables the use of SM4-XTS algorithm in
>> block inline encryption, and provides support for fscrypt.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>  block/blk-crypto.c         | 6 ++++++
>>  include/linux/blk-crypto.h | 1 +
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/block/blk-crypto.c b/block/blk-crypto.c
>> index a496aaef85ba..e44709fc6a08 100644
>> --- a/block/blk-crypto.c
>> +++ b/block/blk-crypto.c
>> @@ -36,6 +36,12 @@ const struct blk_crypto_mode blk_crypto_modes[] = {
>>  		.keysize = 32,
>>  		.ivsize = 32,
>>  	},
>> +	[BLK_ENCRYPTION_MODE_SM4_XTS] = {
>> +		.name = "SM4-XTS",
>> +		.cipher_str = "xts(sm4)",
>> +		.keysize = 32,
>> +		.ivsize = 16,
>> +	},
>>  };
>>  
>>  /*
>> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
>> index 69b24fe92cbf..26b1b71c3091 100644
>> --- a/include/linux/blk-crypto.h
>> +++ b/include/linux/blk-crypto.h
>> @@ -13,6 +13,7 @@ enum blk_crypto_mode_num {
>>  	BLK_ENCRYPTION_MODE_AES_256_XTS,
>>  	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
>>  	BLK_ENCRYPTION_MODE_ADIANTUM,
>> +	BLK_ENCRYPTION_MODE_SM4_XTS,
>>  	BLK_ENCRYPTION_MODE_MAX,
> 
> The commit message should mention that this is needed for the inlinecrypt mount
> option to be supported via blk-crypto-fallback, as it is for the other fscrypt
> modes.  (Since there's no inline encryption hardware that supports SM4-XTS.)
> 
> Anyway, if SM4-XTS support is really being added to fscrypt, then this patch
> looks fine.  Jens, are you okay with me taking it through the fscrypt tree?

Yes, go ahead.

-- 
Jens Axboe


