Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDDB78DD13
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Aug 2023 20:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbjH3Srk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Aug 2023 14:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242982AbjH3KAQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Aug 2023 06:00:16 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BB1BB
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Aug 2023 03:00:11 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-50078e52537so8372944e87.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Aug 2023 03:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693389610; x=1693994410; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3xTYLzShSJrMNa33kOQFBwQyF7CcLinjfIsI73sj6mA=;
        b=NhZVFfnZrY4lUb7uBX51m41Wvv2oL8ZuKoDEcP347ewa3qI6U3GfIJLNtwr1jVDnFF
         E8lUHrzatV/ve4JM0dKcLqAecCAs5+WAqyHS2B7NvhP9SiFZ7NcAlhvLKCwR3dPK4peX
         TqkxTDhY4a4C8qfmbfhvHnmBjmEqsTbwHicf/TKHh4gVQcBvV8us5V4Japo+tMnEembw
         VA2Pqny78q90kCaoC5xTx1Ia3W3ZfN2VAUcINRg1t3c60ailf1WO6eH0c2MyAYRThFIG
         U6juh+WNxwBT+Cdt4v521GRG9jB3fiVvoiT6YQchcO1Hd+1hD/KtZ0b1oEY6xPboByFA
         7HPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693389610; x=1693994410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3xTYLzShSJrMNa33kOQFBwQyF7CcLinjfIsI73sj6mA=;
        b=BhCfPjitQktGlNs7CHKsbYokeUziyl0DaTti5GrA5k9x82tzhOZWJdqMEqYNMF4sxO
         FMrODujAN+wCp8pkw03472AscaiuklB+9qgtVR5TpNSre1cbuwlskr7rxzd916jKbLRx
         DYICCyUccLt+JGD4u2fZuRMhjEMHr3VDHUPTGi0AoCCYp7HmJTAeLUNYY56UN81MJGmF
         gq9EQYWjgusqDKAiOZYkGIKki4wMR2HyF63Em0XyZxyeyHxWHnXE9AWNVlHsFCD8lq2c
         CPOHD93lPxIyVsvJVyrbkHmXOPFitoyJyTFeQ2Vv67co1pzxy0m0QAeqkkwrGblozdqg
         a32w==
X-Gm-Message-State: AOJu0YwXBGw3lAGEE5PxXHva9PTG+GWVuGCrycWaCuJDc4VHqJp9lmUx
        WqEUUJUF0L+cFdtIOwIob8I7RQ==
X-Google-Smtp-Source: AGHT+IHCaFP31zkAGHF02AmzezLz996huf1FhuxFlQEm+QFgPfp9jCQOyRrIpXdq64Q6sPBPvdP6GQ==
X-Received: by 2002:a05:6512:2088:b0:500:7881:7b2f with SMTP id t8-20020a056512208800b0050078817b2fmr1125481lfr.54.1693389609676;
        Wed, 30 Aug 2023 03:00:09 -0700 (PDT)
Received: from [192.168.86.24] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id dk24-20020a170906f0d800b0099ddc81903asm7030466ejb.221.2023.08.30.03.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 03:00:08 -0700 (PDT)
Message-ID: <2230571a-114c-0d03-d02a-fa08c2a8d483@linaro.org>
Date:   Wed, 30 Aug 2023 11:00:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
 <20230825210727.GA1366@sol.localdomain>
 <f63ce281-1434-f86f-3f4e-e1958a684bbd@linaro.org>
 <20230829181223.GA2066264@google.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20230829181223.GA2066264@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 29/08/2023 19:12, Eric Biggers wrote:
> 
>>> They're also being documented by Qualcomm.  So, as this patchset does, they can
>>> be used by Linux in the implementation of new ioctls which provide a vendor
>>> independent interface to HW-wrapped key generation, import, and conversion.
>>>
>>> I think the new approach is the only one that is viable outside the Android
>>> context.  As such, I don't think anyone has any plan to upstream support for
>>> HW-wrapped keys for older Qualcomm SoCs that lack the new interface.
>> AFAIU, There are other downstream Qualcomm LE platforms that use wrapped key
>> support with the older interface.
>> What happens to them whey then upgrade the kernel?
>>
>> Does TA interface still continue to work with the changes that went into
>> common drivers (ufs/sd)?
> This is a strange line of questioning for upstream review, as this feature does
> not exist upstream.  This is the first time it will be supported by upstream
> Linux, ever.  Adding support for this feature does not break anything.
These are not unusual questions, what am trying to understand here is 
below questions for better context, big picture and review/test. At the 
end of the day we all want to get these features available in upstream.

1. How backward compatibility of this wrapped key support. I guess the 
answer is NO.

2. secondly reasons behind this change. Am still not really convinced 
with the current technical reasoning to shift from TA based approach to 
this. But I guess this is all done to dump the closed source userspace 
thingy. Am hoping that this can be made available to other older SoCs at 
some point in time.

3. We are adding these apis/callbacks in common code without doing any 
compatible or SoC checks. Is this going to be a issue if someone tries 
fscrypt?

--srini

> 
> Downstream users who implemented a less well designed version of this feature
> can continue to use their existing code.
