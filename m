Return-Path: <linux-fscrypt+bounces-455-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FDC977981
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Sep 2024 09:23:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9139C28967B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Sep 2024 07:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12881BC097;
	Fri, 13 Sep 2024 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oqs8q5F0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1A018C902
	for <linux-fscrypt@vger.kernel.org>; Fri, 13 Sep 2024 07:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726212194; cv=none; b=k61ls/6NgfIpt4R0gQFRpLyczMHK7CWh+zGWamboXDf9egSqfg1FIgBdRirzFILAkVB6dG42aASOJrlIHztGsH0EG4to5npZaPnTxcM4ISKYXtiig6EwOWH1jXaK8r60THEh9rl3VZnuzMjniWYNdjtI/V9LW0iWyxHBkxvEVm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726212194; c=relaxed/simple;
	bh=UoQvQHYGxHBDOs2/dmrweaC1tYX8GUXP716exDgc0XM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=auWIwXY8/h1xjjbL5isENdI4CFurr5+Ct7iO55QC8i1Ij0Ns3y2CJFjcJCA8YWdEnbsQP8XqMjsX8Aw67bvKtHu4CiFBd4lmLE4jJ/APch5voeUPaRKcVCqSjjAMojvUgA4Vm2X9bAlqxipmzBioxuA+5dZmrEOnlV1A8kCDxpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oqs8q5F0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42cbface8d6so7471625e9.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 13 Sep 2024 00:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726212191; x=1726816991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hc7XAJGHyBbhpa7pUAxA88nI2GB75BPUQErsezn/2vI=;
        b=oqs8q5F0WJLIvKrzdLZUrLEZuBIncnCgNBauScugmHO0z6Z7L5tQCMi02auUlkCu0C
         hdPpxvcpM0PkdqePjq0FNY7medb4SqqiwmYMX/UxfznG/+EkP38xvtxepxOlUKzZb6Ia
         BLQtnoDLjAeNOfonkUQlCODaWc6Gd2J27WZaSpoVcTTrtgnGsp2snWLHdgp7OstUVOmR
         ye+Bf1NdeeRXUOIRB5hMQBKVIq8ZGbfvPGcKy1a/1B8x2u/ZcbqNtCe2PXhSOSs3tY8l
         mXZU7lZr3ppBkBrnfeVUj4v0aFbJm/oc/ZYouidDFivwrx4kKlBYhXeToMCg8KxfJN0y
         NbZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726212191; x=1726816991;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:subject:reply-to:from:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hc7XAJGHyBbhpa7pUAxA88nI2GB75BPUQErsezn/2vI=;
        b=Lx9zP99eNNcBH3UH6fsxpq3Ywc6PauGqiRvpJ18UWvvLODwgHks8jWvFOqmFH05KuC
         2Y2K5S3+WGMJglApDOqNfXnDw3CrByWtWIivsPVCrZtT1NONTNctzz4MwGsnSZ5jk/At
         5Bu21ST0ijmfM/bNnrLiTB2QQDELktnexlyLNxsb5Zbv4HNZU4mJft6t5jSnXNazAW3N
         OOYbg0P4St17WkUzgWVqat+XEtlhMS5CS8u8koKrHOoY0u6DpYsdSj36sxHRNKSvvRRG
         jU+DUsC/i9tS1v7OJ4Ulx8sF7ImftW0ZrmxQB1b8YQBTt6Pzg/TPkw+S2f1hj+c67R8S
         KzxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeOn1aNNQCjZZ0zzHPXi6+AF5B+O8QAUPyNX/+vJvrYOXwd/TWwHDNG9sxxPiSgiTb5R7viN+pKYFcogN6@vger.kernel.org
X-Gm-Message-State: AOJu0Yw15MGi4zhnmZv6VJ5kWbAEIulUDr1wP0Eeax0Odz2W4Lx/rhOZ
	2CuRt+x0Sdad2warHbCUmbvzVInEP/8UfHRLetJs5LrKXIaFOdE+zPyJLGO7Qu4=
X-Google-Smtp-Source: AGHT+IEGeVMesYuQRs6//xfsVlQ05Zrqp5vZ+akDeM/9fyQLz5ToIyJ2Nzu6idt5KlUBsg7GpBh5Bg==
X-Received: by 2002:adf:e2d1:0:b0:374:bcdc:6257 with SMTP id ffacd0b85a97d-378d6243b93mr1166797f8f.54.1726212190403;
        Fri, 13 Sep 2024 00:23:10 -0700 (PDT)
Received: from [192.168.7.202] ([212.114.21.58])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378956655fcsm15975167f8f.38.2024.09.13.00.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2024 00:23:09 -0700 (PDT)
Message-ID: <f416c319-07ef-4b81-946d-ab72a368c8b7@linaro.org>
Date: Fri, 13 Sep 2024 09:23:08 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE
 driver
To: Eric Biggers <ebiggers@kernel.org>,
 "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
Cc: "dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>,
 Bartosz Golaszewski <brgl@bgdev.pl>, Jens Axboe <axboe@kernel.dk>,
 Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson
 <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
 "bartosz.golaszewski" <bartosz.golaszewski@linaro.org>
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-9-d59e61bc0cb4@linaro.org>
 <7uoq72bpiqmo2olwpnudpv3gtcowpnd6jrifff34ubmfpijgc6@k6rmnalu5z4o>
 <66953e65-2468-43b8-9ccf-54671613c4ab@linaro.org>
 <ivibs6qqxhbikaevys3iga7s73xq6dzq3u43gwjri3lozkrblx@jxlmwe5wiq7e>
 <98cc8d71d5d9476297a54774c382030d@quicinc.com>
 <CAA8EJpp_HY+YmMCRwdteeAHnSHtjuHb=nFar60O_PwLwjk0mNA@mail.gmail.com>
 <9bd0c9356e2b471385bcb2780ff2425b@quicinc.com>
 <20240912231735.GA2211970@google.com>
Content-Language: en-US, fr
Autocrypt: addr=neil.armstrong@linaro.org; keydata=
 xsBNBE1ZBs8BCAD78xVLsXPwV/2qQx2FaO/7mhWL0Qodw8UcQJnkrWmgTFRobtTWxuRx8WWP
 GTjuhvbleoQ5Cxjr+v+1ARGCH46MxFP5DwauzPekwJUD5QKZlaw/bURTLmS2id5wWi3lqVH4
 BVF2WzvGyyeV1o4RTCYDnZ9VLLylJ9bneEaIs/7cjCEbipGGFlfIML3sfqnIvMAxIMZrvcl9
 qPV2k+KQ7q+aXavU5W+yLNn7QtXUB530Zlk/d2ETgzQ5FLYYnUDAaRl+8JUTjc0CNOTpCeik
 80TZcE6f8M76Xa6yU8VcNko94Ck7iB4vj70q76P/J7kt98hklrr85/3NU3oti3nrIHmHABEB
 AAHNKk5laWwgQXJtc3Ryb25nIDxuZWlsLmFybXN0cm9uZ0BsaW5hcm8ub3JnPsLAkQQTAQoA
 OwIbIwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgBYhBInsPQWERiF0UPIoSBaat7Gkz/iuBQJk
 Q5wSAhkBAAoJEBaat7Gkz/iuyhMIANiD94qDtUTJRfEW6GwXmtKWwl/mvqQtaTtZID2dos04
 YqBbshiJbejgVJjy+HODcNUIKBB3PSLaln4ltdsV73SBcwUNdzebfKspAQunCM22Mn6FBIxQ
 GizsMLcP/0FX4en9NaKGfK6ZdKK6kN1GR9YffMJd2P08EO8mHowmSRe/ExAODhAs9W7XXExw
 UNCY4pVJyRPpEhv373vvff60bHxc1k/FF9WaPscMt7hlkbFLUs85kHtQAmr8pV5Hy9ezsSRa
 GzJmiVclkPc2BY592IGBXRDQ38urXeM4nfhhvqA50b/nAEXc6FzqgXqDkEIwR66/Gbp0t3+r
 yQzpKRyQif3OwE0ETVkGzwEIALyKDN/OGURaHBVzwjgYq+ZtifvekdrSNl8TIDH8g1xicBYp
 QTbPn6bbSZbdvfeQPNCcD4/EhXZuhQXMcoJsQQQnO4vwVULmPGgtGf8PVc7dxKOeta+qUh6+
 SRh3vIcAUFHDT3f/Zdspz+e2E0hPV2hiSvICLk11qO6cyJE13zeNFoeY3ggrKY+IzbFomIZY
 4yG6xI99NIPEVE9lNBXBKIlewIyVlkOaYvJWSV+p5gdJXOvScNN1epm5YHmf9aE2ZjnqZGoM
 Mtsyw18YoX9BqMFInxqYQQ3j/HpVgTSvmo5ea5qQDDUaCsaTf8UeDcwYOtgI8iL4oHcsGtUX
 oUk33HEAEQEAAcLAXwQYAQIACQUCTVkGzwIbDAAKCRAWmrexpM/4rrXiB/sGbkQ6itMrAIfn
 M7IbRuiSZS1unlySUVYu3SD6YBYnNi3G5EpbwfBNuT3H8//rVvtOFK4OD8cRYkxXRQmTvqa3
 3eDIHu/zr1HMKErm+2SD6PO9umRef8V82o2oaCLvf4WeIssFjwB0b6a12opuRP7yo3E3gTCS
 KmbUuLv1CtxKQF+fUV1cVaTPMyT25Od+RC1K+iOR0F54oUJvJeq7fUzbn/KdlhA8XPGzwGRy
 4zcsPWvwnXgfe5tk680fEKZVwOZKIEuJC3v+/yZpQzDvGYJvbyix0lHnrCzq43WefRHI5XTT
 QbM0WUIBIcGmq38+OgUsMYu4NzLu7uZFAcmp6h8g
Organization: Linaro
In-Reply-To: <20240912231735.GA2211970@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/09/2024 01:17, Eric Biggers wrote:
> On Thu, Sep 12, 2024 at 10:17:03PM +0000, Gaurav Kashyap (QUIC) wrote:
>>
>> On Monday, September 9, 2024 11:29 PM PDT, Dmitry Baryshkov wrote:
>>> On Tue, 10 Sept 2024 at 03:51, Gaurav Kashyap (QUIC)
>>> <quic_gaurkash@quicinc.com> wrote:
>>>>
>>>> Hello Dmitry and Neil
>>>>
>>>> On Monday, September 9, 2024 2:44 AM PDT, Dmitry Baryshkov wrote:
>>>>> On Mon, Sep 09, 2024 at 10:58:30AM GMT, Neil Armstrong wrote:
>>>>>> On 07/09/2024 00:07, Dmitry Baryshkov wrote:
>>>>>>> On Fri, Sep 06, 2024 at 08:07:12PM GMT, Bartosz Golaszewski wrote:
>>>>>>>> From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
>>>>>>>>
>>>>>>>> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary
>>>>>>>> key management hardware called Hardware Key Manager (HWKM).
>>>>>>>> Add
>>>>> HWKM
>>>>>>>> support to the ICE driver if it is available on the platform.
>>>>>>>> HWKM primarily provides hardware wrapped key support where
>>> the
>>>>>>>> ICE
>>>>>>>> (storage) keys are not available in software and instead
>>>>>>>> protected in
>>>>> hardware.
>>>>>>>>
>>>>>>>> When HWKM software support is not fully available (from
>>>>>>>> Trustzone), there can be a scenario where the ICE hardware
>>>>>>>> supports HWKM, but it cannot be used for wrapped keys. In this
>>>>>>>> case, raw keys have to be used without using the HWKM. We
>>>>>>>> query the TZ at run-time to find out whether wrapped keys
>>>>>>>> support is
>>>>> available.
>>>>>>>>
>>>>>>>> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
>>>>>>>> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
>>>>>>>> Signed-off-by: Bartosz Golaszewski
>>>>>>>> <bartosz.golaszewski@linaro.org>
>>>>>>>> ---
>>>>>>>>    drivers/soc/qcom/ice.c | 152
>>>>> +++++++++++++++++++++++++++++++++++++++++++++++--
>>>>>>>>    include/soc/qcom/ice.h |   1 +
>>>>>>>>    2 files changed, 149 insertions(+), 4 deletions(-)
>>>>>>>>
>>>>>>>>    int qcom_ice_enable(struct qcom_ice *ice)
>>>>>>>>    {
>>>>>>>> + int err;
>>>>>>>> +
>>>>>>>>            qcom_ice_low_power_mode_enable(ice);
>>>>>>>>            qcom_ice_optimization_enable(ice);
>>>>>>>> - return qcom_ice_wait_bist_status(ice);
>>>>>>>> + if (ice->use_hwkm)
>>>>>>>> +         qcom_ice_enable_standard_mode(ice);
>>>>>>>> +
>>>>>>>> + err = qcom_ice_wait_bist_status(ice); if (err)
>>>>>>>> +         return err;
>>>>>>>> +
>>>>>>>> + if (ice->use_hwkm)
>>>>>>>> +         qcom_ice_hwkm_init(ice);
>>>>>>>> +
>>>>>>>> + return err;
>>>>>>>>    }
>>>>>>>>    EXPORT_SYMBOL_GPL(qcom_ice_enable);
>>>>>>>> @@ -150,6 +282,10 @@ int qcom_ice_resume(struct qcom_ice
>>> *ice)
>>>>>>>>                    return err;
>>>>>>>>            }
>>>>>>>> + if (ice->use_hwkm) {
>>>>>>>> +         qcom_ice_enable_standard_mode(ice);
>>>>>>>> +         qcom_ice_hwkm_init(ice); }
>>>>>>>>            return qcom_ice_wait_bist_status(ice);
>>>>>>>>    }
>>>>>>>>    EXPORT_SYMBOL_GPL(qcom_ice_resume);
>>>>>>>> @@ -157,6 +293,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
>>>>>>>>    int qcom_ice_suspend(struct qcom_ice *ice)
>>>>>>>>    {
>>>>>>>>            clk_disable_unprepare(ice->core_clk);
>>>>>>>> + ice->hwkm_init_complete = false;
>>>>>>>>            return 0;
>>>>>>>>    }
>>>>>>>> @@ -206,6 +343,12 @@ int qcom_ice_evict_key(struct qcom_ice
>>>>>>>> *ice,
>>>>> int slot)
>>>>>>>>    }
>>>>>>>>    EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>>>>>>>> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice) {  return
>>>>>>>> +ice->use_hwkm; }
>>>>> EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
>>>>>>>> +
>>>>>>>>    static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>>>>>>                                            void __iomem *base)
>>>>>>>>    {
>>>>>>>> @@ -240,6 +383,7 @@ static struct qcom_ice
>>>>>>>> *qcom_ice_create(struct
>>>>> device *dev,
>>>>>>>>                    engine->core_clk = devm_clk_get_enabled(dev, NULL);
>>>>>>>>            if (IS_ERR(engine->core_clk))
>>>>>>>>                    return ERR_CAST(engine->core_clk);
>>>>>>>> + engine->use_hwkm = qcom_scm_has_wrapped_key_support();
>>>>>>>
>>>>>>> This still makes the decision on whether to use HW-wrapped keys
>>>>>>> on behalf of a user. I suppose this is incorrect. The user must
>>>>>>> be able to use raw keys even if HW-wrapped keys are available on
>>>>>>> the platform. One of the examples for such use-cases is if a
>>>>>>> user prefers to be able to recover stored information in case of
>>>>>>> a device failure (such recovery will be impossible if SoC is
>>>>>>> damaged and HW-
>>>>> wrapped keys are used).
>>>>>>
>>>>>> Isn't that already the case ? the
>>> BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
>>>>> size
>>>>>> is here to select HW-wrapped key, otherwise the ol' raw key is passed.
>>>>>> Just look the next patch.
>>>>>>
>>>>>> Or did I miss something ?
>>>>>
>>>>> That's a good question. If use_hwkm is set, ICE gets programmed to
>>>>> use hwkm (see qcom_ice_hwkm_init() call above). I'm not sure if it
>>>>> is expected to work properly if after such a call we pass raw key.
>>>>>
>>>>
>>>> Once ICE has moved to a HWKM mode, the firmware key programming
>>> currently does not support raw keys.
>>>> This support is being added for the next Qualcomm chipset in Trustzone to
>>> support both at he same time, but that will take another year or two to hit
>>> the market.
>>>> Until that time, due to TZ (firmware) limitations , the driver can only
>>> support one or the other.
>>>>
>>>> We also cannot keep moving ICE modes, due to the HWKM enablement
>>> being a one-time configurable value at boot.
>>>
>>> So the init of HWKM should be delayed until the point where the user tells if
>>> HWKM or raw keys should be used.
>>
>> Ack.
>> I'll work with Bartosz to look into moving to HWKM mode only during the first key program request
>>
> 
> That would mean the driver would have to initially advertise support for both
> HW-wrapped keys and raw keys, and then it would revoke the support for one of
> them later (due to the other one being used).  However, runtime revocation of
> crypto capabilities is not supported by the blk-crypto framework
> (Documentation/block/inline-encryption.rst), and there is no clear path to
> adding such support.  Upper layers may have already checked the crypto
> capabilities and decided to use them.  It's too late to find out that the
> support was revoked in the middle of an I/O request.  Upper layer code
> (blk-crypto, fscrypt, etc.) is not prepared for this.  And even if it was, the
> best it could do is cleanly fail the I/O, which is too late as e.g. it may
> happen during background writeback and cause user data to be thrown away.
> 
> So, the choice of support for HW-wrapped vs. raw will need to be made ahead of
> time, rather than being implicitly set by the first use.  That is most easily
> done using a module parameter like qcom_ice.hw_wrapped_keys=1.  Yes, it's a bit
> inconvenient, but there's no realistic way around this currently.

Considering the arguments, I'll vote in favor of a module parameter, since using
hw_wrapped_keys is a system design choice, it's fine to enable it via a module
parameter. It will complicate CI, but in the actual case we just can't disable
RAW keys support just because the firmware can potentially use wrapper keys.

Neil

> 
> - Eric


