Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920661F7CBC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jun 2020 20:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgFLSEh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 12 Jun 2020 14:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgFLSEh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 12 Jun 2020 14:04:37 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B49DC08C5C1
        for <linux-fscrypt@vger.kernel.org>; Fri, 12 Jun 2020 11:04:37 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id p70so9450002oic.12
        for <linux-fscrypt@vger.kernel.org>; Fri, 12 Jun 2020 11:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=C2JVbomNdU20rKNp8HqRg4cB8xPBeKRwrKV7atfiB90=;
        b=EGWTlEbUPecTWcU1DtFitXJ8IW4qpiS4AK2f62xdDbiJVJsLU2+B8GP9qBACvNj418
         Lx0z65tzMSDl+9cetAt7f2UzCc7d+f4IwWjOjX2II3e0bMdk94q0tuQ7wdV+n77+QUpZ
         yOxB+AmCckAh3oSrExh4yEIWebhExUmqe6q/1U8+2GuJvnUXbFlY86W2tx0FdtLyLruk
         d77CJzn/pVIriGbbvwYlXXtyNXQ2WbVJftKfXYScRdQ5unl0w9slodrmGOWdswxUr+K/
         B07pwC8iA1Cf2jOW9P6jBmygaFTyDYzOLX7bJC35mBGlbZ3dRsCn9J94EtZIZ0pZ//Pj
         rj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=C2JVbomNdU20rKNp8HqRg4cB8xPBeKRwrKV7atfiB90=;
        b=Xywi7r6FQ4cEVMuJD2+g5iVPtE0Gd/6xTW275SdkDW4QyNqiJpugNPEkRuXpeTYQGK
         XWsYBKyQ4MZmdB7vgSr3RwxBRHpqFFUl7+DFvKXrAF6xIwFx4NPtNr1h6MkQzWkHLtbK
         JXvnwloyCqJQj90FHf/VWZXyhIYlEq8c0la0FNZ+xuk95f7wCUpZ5phC8Tz9iY7M+Z7j
         9vj+ytzAM/Ked5oQPixUBLG59fGqzOMjpM7mUu3tf0Aa8oqQHD8WwZK1V+FMxKCvcx1f
         1MGmUwSsXAi2UQVLTVz/udy/aO4Vn1nT9uFilNOAaWeJZcTfmZwzMDhRDG4WgMeG7oSa
         6WrA==
X-Gm-Message-State: AOAM531TXDuLP5byCHybE45Gc77VIWCym4dgsm5dxpj/0EDAKbcZyW4n
        2e/9Gfcvw5h5O3Yt3CemhjWpYg==
X-Google-Smtp-Source: ABdhPJx4zAiM/pQwXDriFT+tjCkvYSEFghRPGBHeIUcuheSsw+Ou+mhIgm/nlsl4kW57khKcPjtz0g==
X-Received: by 2002:aca:498f:: with SMTP id w137mr153788oia.28.1591985076448;
        Fri, 12 Jun 2020 11:04:36 -0700 (PDT)
Received: from Steevs-MBP.hackershack.net (cpe-173-175-113-3.satx.res.rr.com. [173.175.113.3])
        by smtp.gmail.com with ESMTPSA id m9sm1538830oon.14.2020.06.12.11.04.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 11:04:35 -0700 (PDT)
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Thara Gopinath <thara.gopinath@linaro.org>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
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
 <150ddaaf-12ec-231e-271a-c65b1d88d30f@kali.org>
 <20200508202513.GA233206@gmail.com>
From:   Steev Klimaszewski <steev@kali.org>
Message-ID: <1aa17b19-0ca7-1ff1-b945-442e56ef942a@kali.org>
Date:   Fri, 12 Jun 2020 13:04:33 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200508202513.GA233206@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 5/8/20 3:25 PM, Eric Biggers wrote:
> On Fri, May 08, 2020 at 03:18:23PM -0500, Steev Klimaszewski wrote:
>> On 5/7/20 1:08 PM, Eric Biggers wrote:
>>> On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
>>>> Hi Thara,
>>>>
>>>> On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
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
>>>> Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
>>>>
>>>> A basic manual test would be:
>>>>
>>>> 1. Build a kernel with:
>>>>
>>>> 	CONFIG_BLK_INLINE_ENCRYPTION=y
>>>> 	CONFIG_FS_ENCRYPTION=y
>>>> 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
>>> Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
>>>
>>> - Eric
>>
> The original patchset is at
> https://lkml.kernel.org/r/20200430115959.238073-1-satyat@google.com/
>
> Yes, v12 is the latest version, and yes that's a bug.  The export needs double
> underscores.  Satya will fix it when he sends out v13.
>
> - Eric

Hi Eric,


I've been testing this on a Lenovo Yoga C630 installed to a partition on
the UFS drive, using a 5.7(ish) kernel with fscrypt/inline-encryption
and a few patches on top that are still in flux for c630 support.  The
sources I use can be found at
https://github.com/steev/linux/tree/linux-5.7.y-c630-fscrypt and the
config I'm using can be found at
https://dev.gentoo.org/~steev/files/lenovo-yoga-c630-5.7.0-rc7-fs-inline-encryption.config.


Everything seems to be working here.  I've run the tests you've
mentioned and haven't seen any issues.


-- Steev

