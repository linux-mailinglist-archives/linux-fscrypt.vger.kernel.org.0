Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4386378E879
	for <lists+linux-fscrypt@lfdr.de>; Thu, 31 Aug 2023 10:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbjHaIkZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 31 Aug 2023 04:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240330AbjHaIkV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 31 Aug 2023 04:40:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89572E54
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Aug 2023 01:39:48 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-31ad779e6b3so416205f8f.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Aug 2023 01:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693471168; x=1694075968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=964YURPHIDahuD+Ho9xAvPp19oa0tTryVvoT/t7+K9Q=;
        b=sOl4rtaMMBg89mRlejQsdnSycJr5n0iOEmXF6ApWGQd292w3rC5U6mAeCta3h9aOsb
         nkryduLHYmK9jE6w0dHIZECv10sr8zjv1WUUDgTY35RSC+Pxsil8hpqYZbJAtrguivwa
         kfQ4mJteW2cZhsKLGRkiWlrXJEOmtvJTWArY//PrmVNh6OE9gp3cKvo9EsQBFDEyhKRW
         ZXtIQWgj1NLx6956FyA1jYoiR9Eh1TmUL6sJB4Hukl55Vqpge7ABFbreu8SWMy9mdmo3
         za7foao7Jz73kTjxcqEhT71FvvialmaFJnj011f80dbuUAbXBOJ5M0doikcmJq/Yobkj
         6Q/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693471168; x=1694075968;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=964YURPHIDahuD+Ho9xAvPp19oa0tTryVvoT/t7+K9Q=;
        b=gkaP1+fSX10e2KSlvuuJObRVljlzQ6457Tbkz6uRTBpaR/CTJIg7BNp90VeHmC3nlf
         opD8cJzESutcK7KWUb4ZRcXkN311LXfFowTDVTCy0wNB1wDFR4rZzOfCYU3yLrZc7Epp
         MvWIKm3pD9naD7CpnJGoULt77RwHHPJDmcgi4HNhY5Yg1i6b3gwrUi/uuanRjrpXglhF
         0GTUT77/ytxZjOtdkVvWiUY65MJmsWDNxkz6UCJONFSXp1gE/yquqe9f3r0zF8pNakJi
         j3Ey+c9LCz/NVC1Az8prh6iKd/XYZbcraee0aREueAoOJN7EjOi4ZZjsy9APMFBcOkdX
         L9Nw==
X-Gm-Message-State: AOJu0YxpyUHb0Xdpw0Zq119nAv5QApWq8Rq4iN1r/xT/K3vxf69sIq94
        7VQp/4dr2C0chzmRGgpKp/6Ipw==
X-Google-Smtp-Source: AGHT+IH622REtHgmfxDFuzcoi34tnDSwqboEnVjqvA2kcj4uGSAMqD5HLM53K+dY2PEgmSqqO+zw6g==
X-Received: by 2002:a05:6000:128d:b0:319:6d03:13ae with SMTP id f13-20020a056000128d00b003196d0313aemr2858867wrx.55.1693471167638;
        Thu, 31 Aug 2023 01:39:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:a33e:476b:58d7:9689? ([2a01:e0a:982:cbb0:a33e:476b:58d7:9689])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d4d88000000b003179d7ed4f3sm1428151wru.12.2023.08.31.01.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 01:39:26 -0700 (PDT)
Message-ID: <fcbf6dee-aa6a-4af8-9ff1-495adbcb5a57@linaro.org>
Date:   Thu, 31 Aug 2023 10:39:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 03/10] soc: qcom: ice: add hwkm support in ice
Content-Language: en-US, fr
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com
Cc:     linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-4-quic_gaurkash@quicinc.com>
From:   Neil Armstrong <neil.armstrong@linaro.org>
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
Organization: Linaro Developer Services
In-Reply-To: <20230719170423.220033-4-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

On 19/07/2023 19:04, Gaurav Kashyap wrote:
> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary
> key management hardware called Hardware Key Manager (HWKM).
> This patch integrates HWKM support in ICE when it is
> available. HWKM primarily provides hardware wrapped key support
> where the ICE (storage) keys are not available in software and
> protected in hardware.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/soc/qcom/ice.c | 112 ++++++++++++++++++++++++++++++++++++++++-
>   include/soc/qcom/ice.h |   1 +
>   2 files changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index d19f674bb1b6..242306d13049 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -24,6 +24,18 @@
>   #define QCOM_ICE_REG_FUSE_SETTING		0x0010
>   #define QCOM_ICE_REG_BIST_STATUS		0x0070
>   #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
> +#define QCOM_ICE_REG_CONTROL			0x0
> +/* QCOM ICE HWKM registers */
> +#define QCOM_ICE_REG_HWKM_TZ_KM_CTL		0x1000
> +#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS		0x1004
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0		0x5000
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1		0x5004
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2		0x5008
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3		0x500C
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4		0x5010
> +
> +#define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
> +#define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
>   
>   /* BIST ("built-in self-test") status flags */
>   #define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
> @@ -32,6 +44,9 @@
>   #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>   #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>   
> +#define QCOM_ICE_HWKM_REG_OFFSET	0x8000
> +#define HWKM_OFFSET(reg)		(reg + QCOM_ICE_HWKM_REG_OFFSET)

The current upstream ICE memory region is only 0x8000, so you should
probably check the memory region size before enabling HWKM otherwise
you'll access unmapped memory for non-updated DT.

Neil

> +
>   #define qcom_ice_writel(engine, val, reg)	\
>   	writel((val), (engine)->base + (reg))
>   
> @@ -44,6 +59,7 @@ struct qcom_ice {
>   	struct device_link *link;
>   
>   	struct clk *core_clk;
> +	u8 hwkm_version;
>   };
>   
>   static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -61,8 +77,20 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
>   		return false;
>   	}
>   
> +	if ((major >= 4) || ((major == 3) && (minor == 2) && (step >= 1)))
> +		ice->hwkm_version = 2;
> +	else if ((major == 3) && (minor == 2))
> +		ice->hwkm_version = 1;
> +	else
> +		ice->hwkm_version = 0;
> +
>   	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
>   		 major, minor, step);
> +	if (!ice->hwkm_version)
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not supported");
> +	else
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) version = %d",
> +			 ice->hwkm_version);
>   
>   	/* If fuses are blown, ICE might not work in the standard way. */
>   	regval = qcom_ice_readl(ice, QCOM_ICE_REG_FUSE_SETTING);
> @@ -111,10 +139,14 @@ static void qcom_ice_optimization_enable(struct qcom_ice *ice)
>    * fails, so we needn't do it in software too, and (c) properly testing
>    * storage encryption requires testing the full storage stack anyway,
>    * and not relying on hardware-level self-tests.
> + *
> + * However, we still care about if HWKM BIST failed (when supported) as
> + * important functionality would fail later, so disable hwkm on failure.
>    */
>   static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
>   {
>   	u32 regval;
> +	u32 bist_done_val;
>   	int err;
>   
>   	err = readl_poll_timeout(ice->base + QCOM_ICE_REG_BIST_STATUS,
> @@ -123,15 +155,87 @@ static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
>   	if (err)
>   		dev_err(ice->dev, "Timed out waiting for ICE self-test to complete\n");
>   
> +	if (ice->hwkm_version) {
> +		bist_done_val = (ice->hwkm_version == 1) ?
> +				 QCOM_ICE_HWKM_BIST_DONE_V1_VAL :
> +				 QCOM_ICE_HWKM_BIST_DONE_V2_VAL;
> +		if (qcom_ice_readl(ice,
> +				   HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_STATUS)) !=
> +				   bist_done_val) {
> +			dev_warn(ice->dev, "HWKM BIST error\n");
> +			ice->hwkm_version = 0;
> +		}
> +	}
>   	return err;
>   }
>   
> +static void qcom_ice_enable_standard_mode(struct qcom_ice *ice)
> +{
> +	u32 val = 0;
> +
> +	if (!ice->hwkm_version)
> +		return;
> +
> +	/*
> +         * When ICE is in standard (hwkm) mode, it supports HW wrapped
> +         * keys, and when it is in legacy mode, it only supports standard
> +         * (non HW wrapped) keys.
> +         *
> +	 * Put ICE in standard mode, ICE defaults to legacy mode.
> +	 * Legacy mode - ICE HWKM slave not supported.
> +	 * Standard mode - ICE HWKM slave supported.
> +	 *
> +	 * Depending on the version of HWKM, it is controlled by different
> +	 * registers in ICE.
> +	 */
> +	if (ice->hwkm_version >= 2) {
> +		val = qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
> +		val = val & 0xFFFFFFFE;
> +		qcom_ice_writel(ice, val, QCOM_ICE_REG_CONTROL);
> +	} else {
> +		qcom_ice_writel(ice, 0x7,
> +				HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
> +	}
> +}
> +
> +static void qcom_ice_hwkm_init(struct qcom_ice *ice)
> +{
> +	if (!ice->hwkm_version)
> +		return;
> +
> +	/*
> +	 * Give register bank of the HWKM slave access to read and modify
> +	 * the keyslots in ICE HWKM slave. Without this, trustzone will not
> +	 * be able to program keys into ICE.
> +	 */
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_0));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_1));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_2));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_3));
> +	qcom_ice_writel(ice, 0xFFFFFFFF,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_4));
> +}
> +
>   int qcom_ice_enable(struct qcom_ice *ice)
>   {
> +	int err;
> +
>   	qcom_ice_low_power_mode_enable(ice);
>   	qcom_ice_optimization_enable(ice);
>   
> -	return qcom_ice_wait_bist_status(ice);
> +	qcom_ice_enable_standard_mode(ice);
> +
> +	err = qcom_ice_wait_bist_status(ice);
> +	if (err)
> +		return err;
> +
> +	qcom_ice_hwkm_init(ice);
> +
> +	return err;
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_enable);
>   
> @@ -203,6 +307,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>   
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
> +{
> +	return (ice->hwkm_version > 0);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> +
>   static struct qcom_ice *qcom_ice_create(struct device *dev,
>   					void __iomem *base)
>   {
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 9dd835dba2a7..1f52e82e3e1c 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>   			 const struct blk_crypto_key *bkey,
>   			 u8 data_unit_size, int slot);
>   int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>   struct qcom_ice *of_qcom_ice_get(struct device *dev);
>   #endif /* __QCOM_ICE_H__ */

