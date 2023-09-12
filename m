Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237B879CD2F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Sep 2023 12:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjILKHU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 Sep 2023 06:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbjILKHI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 Sep 2023 06:07:08 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3236A19A3
        for <linux-fscrypt@vger.kernel.org>; Tue, 12 Sep 2023 03:06:46 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9a9d6b98845so1281701766b.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 12 Sep 2023 03:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694513204; x=1695118004; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IBiBGq8YC/oHp0cfRWnQ5YGlOgmjdNVAihPt6gGNcNM=;
        b=dR2dofEh4XuswaSIzndsGtc4G9Lo5IjAAN4SKBDvmzwjY2h22OkHIE2UXrNP54vV1c
         ounoZUGiKswVQtcKDZO+BquiTBBUGAKqyaevyuy6joGwJOd1dARjlBr6bxIyhxmxror3
         H7DLUj35S6M2ITsxUsLyEzPmWz3qyT4i3516bPL/xFOS1snx+F1KooisTxfH9HlVxIl3
         cAl4Dpf/M4TeUo/hOAZUb2SFxk8rlKEciKZ+d8g8+kLX/OQBH4OGkn6mD3KMvOWrOU5L
         31BhbfPqQMsOTuTkG62QZJaTqE4QrUIpz/5fmVZ59AdoVNzIuAFMl5UXwltvGekNBg1A
         8aXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694513204; x=1695118004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBiBGq8YC/oHp0cfRWnQ5YGlOgmjdNVAihPt6gGNcNM=;
        b=Ako5eaGQwqlbmjkfMUg/gUch6N4weGY0yO8LB6WI3wiwe5LPWU21S3sbBpSee180C9
         rGMOuVpMzxgrFdg7yRB/ZKd35VA4oC4PKGZRVDWyCC3vd637dNeae7mPVypw9r0k5Fir
         xFVb7JZu1wKDEcFdlqtuTbDvRLhIQoSptvEOmuYETEbiTXXzetNm3JSTZmu0JhFhUP+t
         fKPS/FGBX/opoVxJxhDd58YJz0FgbT/IytQlYHktwkpkVG7GuY3xckH/EamYGz+w80c6
         RJAVXAEVgwMAOnR118QuYrSH1pkKEWS7mg86XTRnR75S6X3Mb8OURKbvcXFZYyWy73+4
         VC+A==
X-Gm-Message-State: AOJu0Yx9YZRDF+yz8/Fk5g6vyLroDCdEeWLoFK3u8qZNOgopDSNruO8L
        8rBYO86WhD5RMlEmASKKXDtY+Q==
X-Google-Smtp-Source: AGHT+IFRiMz1rvx/NGmDmYF9SHj5ttXTISHN66oLEMrxFb0YDiSPZvNprwhgZC4DPQf5c18sfGiofw==
X-Received: by 2002:a17:907:c246:b0:9ad:7cbc:ea5b with SMTP id tj6-20020a170907c24600b009ad7cbcea5bmr2310997ejc.10.1694513204542;
        Tue, 12 Sep 2023 03:06:44 -0700 (PDT)
Received: from [192.168.86.24] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id oy25-20020a170907105900b0099d0c0bb92bsm6583517ejb.80.2023.09.12.03.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 03:06:44 -0700 (PDT)
Message-ID: <cf3816b0-7718-278c-aac2-bdd2dd85ac87@linaro.org>
Date:   Tue, 12 Sep 2023 11:06:42 +0100
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
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20230825210727.GA1366@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric/Gaurav,

Adding more information and some questions to this discussion,

On 25/08/2023 14:07, Eric Biggers wrote:
> Hi Srinivas,
> 
> On Fri, Aug 25, 2023 at 11:19:41AM +0100, Srinivas Kandagatla wrote:
>>
>> On 19/07/2023 18:04, Gaurav Kashyap wrote:
>>> These patches add support to Qualcomm ICE (Inline Crypto Enginr) for hardware
>>> wrapped keys using Qualcomm Hardware Key Manager (HWKM) and are made on top
>>> of a rebased version  Eric Bigger's set of changes to support wrapped keys in
>>> fscrypt and block below:
>>> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7
>>> (The rebased patches are not uploaded here)
>>>
>>> Ref v1 here:
>>> https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkash@quicinc.com/
>>>
>>> Explanation and use of hardware-wrapped-keys can be found here:
>>> Documentation/block/inline-encryption.rst
>>>
>>> This patch is organized as follows:
>>>
>>> Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around wrapped keys.
>>> Patch 2 - Adds a new SCM api to support deriving software secret when wrapped keys are used
>>> Patch 3-4 - Adds support for wrapped keys in the ICE driver. This includes adding HWKM support
>>> Patch 5-6 - Adds support for wrapped keys in UFS
>>> Patch 7-10 - Supports generate, prepare and import functionality in ICE and UFS
>>>
>>> NOTE: MMC will have similar changes to UFS and will be uploaded in a different patchset
>>>         Patch 3, 4, 8, 10 will have MMC equivalents.
>>>
>>> Testing:
>>> Test platform: SM8550 MTP
>>> Engineering trustzone image is required to test this feature only
>>> for SM8550. For SM8650 onwards, all trustzone changes to support this
>>> will be part of the released images.
>>
>> AFAIU, Prior to these proposed changes in scm, HWKM was done with help of
>> TA(Trusted Application) for generate, import, unwrap ... functionality.
>>
>> 1. What is the reason for moving this from TA to new smc calls?
>>
>> Is this because of missing smckinvoke support in upstream?
>>
>> How scalable is this approach? Are we going to add new sec sys calls to
>> every interface to TA?
>>
>> 2. How are the older SoCs going to deal with this, given that you are
>> changing drivers that are common across these?
>>
>> Have you tested these patches on any older platforms?
>>
>> What happens if someone want to add support to wrapped keys to this
>> platforms in upstream, How is that going to be handled?
>>
>> As I understand with this, we will endup with two possible solutions over
>> time in upstream.
> 
> It's true that Qualcomm based Android devices already use HW-wrapped keys on
> SoCs earlier than SM8650.  The problem is that the key generation, import, and
> conversion were added to Android's KeyMint HAL, as a quick way to get the
> feature out the door when it was needed (so to speak).  Unfortunately this
> coupled this feature unnecessarily to the Android KeyMint and the corresponding
> (closed source) userspace HAL provided by Qualcomm, which it's not actually
> related to.  I'd guess that Qualcomm's closed source userspace HAL makes SMC
> calls into Qualcomm's KeyMint TA, but I have no insight into those details.
> 
> The new SMC calls eliminate the dependency on the Android-specific KeyMint.
> They're also being documented by Qualcomm.  So, as this patchset does, they can
> be used by Linux in the implementation of new ioctls which provide a vendor
> independent interface to HW-wrapped key generation, import, and conversion.
> 
> I think the new approach is the only one that is viable outside the Android
> context.  As such, I don't think anyone has any plan to upstream support for

Just bit of history afaiu.

on Qcom SoCs there are 3 ways to talk to Trusted service/Trusted 
application.

1> Adding SCM calls. This is not scalable solution, imagine we keep 
adding new scm calls and static services to the TZ as required and this 
is going to bloat up the tz image size. Not only that, new SoCs would 
need to maintain backward compatibility, which is not going to happen. 
AFAIU this is discouraged in general and Qcom at some point in time will 
move away from this..

2> using QSEECOM: This has some scalable issues, which is now replaced 
with smcinvoke.

3> smcinvoke: This is preferred way to talk to any QTEE service or 
application. The issue is that this is based on some downstream UAPI 
which is not upstream ready yet.

IMO, adding a solution that is just going to live for few years is 
questionable for upstream.

Fixing [3] seems to be much scalable solution along with it we will also 
get support for this feature in all the Qualcomm platforms.

Am interested to hear what Gaurav has to say on this.


--srini


> HW-wrapped keys for older Qualcomm SoCs that lack the new interface.
> 
> - Eric
