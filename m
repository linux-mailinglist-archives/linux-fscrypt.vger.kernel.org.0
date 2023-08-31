Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90C978E91A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 31 Aug 2023 11:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234968AbjHaJKY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 31 Aug 2023 05:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237846AbjHaJKX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 31 Aug 2023 05:10:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D51ACEA
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Aug 2023 02:10:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3110ab7110aso429987f8f.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 31 Aug 2023 02:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693473018; x=1694077818; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nFLdRgW4/pacJbc+A452yAnAB3CkyuJxPDrgBZGl12A=;
        b=Jxn0XvRajCiDsKBz/jXfVHOv46Idhw3NTdatld3qghNYfCCQ1nA6V8IVZqZw22dXvs
         X5RzYv2bNRVJkvDEAjWhB8HOadaAW3zpsKWZwDmQiy/uzA0zmajHQs+uoNr0VnVnCJxF
         P+c0eUumRwLuGIvyMIXiBJ07cvMYkTcvNCBplJkK3/GnliZ/NIquownX93a+VCZJZPE9
         ZdZPZYkRL6tXUesLX+CHQFuWFQy4iD4KcamLe/gcxDsSumSXdVJqNMQHqC7GlQg8SNEq
         QLdhwEguW1FkLV911RRKTqbMZ5gPEOAGNda7+R2LzAEZe1z/UjPiwTYxd3SbblIq5DuA
         9Ufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693473018; x=1694077818;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nFLdRgW4/pacJbc+A452yAnAB3CkyuJxPDrgBZGl12A=;
        b=Qw3rUKFvcsWwdSBtlOsBzAbLqczWUBL3BVB8HouweIeq6IOsUD2VRu1Wu7g8rwPXjU
         ZVxMkYCegzjUmsym5hjVzOzNAOjpJh2nVD9yp/6qTJEcRiOJnwxOYd45tfe8SSRyYlHx
         yGwqlsnWNe4T5DRTJ8b1pDBVTTQTZsP8xp7BXn44phywOyBjQGp6l5q1TptxkiYzJqZZ
         LEEz8iAd4pxIuYOoISRzHfCN+6RxZxP5r38/vCx/OiTAtQnVowc2kH0UYy+cIc3qEKKd
         kF6UFFHw0eymiAI3CtVZ6uvb20YeTCKX9tnn1CoDr7VJ1SmpDphEoj7xyv4saq6oqxGE
         4V5Q==
X-Gm-Message-State: AOJu0YzV+PB2LnTnOPWZRztKELJ6ob/afoEE2CJAtYbWG5VSE+6caWJm
        XBEXmsG/MHc6zEarMsRkzLLWSw==
X-Google-Smtp-Source: AGHT+IGKzO/+486Q7YvS0uvNVnoQpdUjp2QursI+uXvKKzIeknBCuPgvAF22+Wr0Jm/QBSgWwhFpIQ==
X-Received: by 2002:a5d:63cb:0:b0:317:7062:32d2 with SMTP id c11-20020a5d63cb000000b00317706232d2mr3618117wrw.54.1693473017848;
        Thu, 31 Aug 2023 02:10:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:a33e:476b:58d7:9689? ([2a01:e0a:982:cbb0:a33e:476b:58d7:9689])
        by smtp.gmail.com with ESMTPSA id f12-20020adffccc000000b003143c9beeaesm1509345wrs.44.2023.08.31.02.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 02:10:17 -0700 (PDT)
Message-ID: <3129d140-ac8e-4af1-9b87-3d04f7a65211@linaro.org>
Date:   Thu, 31 Aug 2023 11:10:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 04/10] soc: qcom: ice: support for hardware wrapped
 keys
Content-Language: en-US, fr
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ebiggers@google.com
Cc:     linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-5-quic_gaurkash@quicinc.com>
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
In-Reply-To: <20230719170423.220033-5-quic_gaurkash@quicinc.com>
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
> Now that HWKM support is added to ICE, extend the ICE
> driver to support hardware wrapped keys programming coming
> in from the storage controllers (ufs and emmc). The patches that follow
> will add ufs and emmc support.
> 
> Derive software secret support is also added by forwarding the
> call the corresponding scm api.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/soc/qcom/ice.c | 121 +++++++++++++++++++++++++++++++++++++----
>   include/soc/qcom/ice.h |   4 ++
>   2 files changed, 114 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 242306d13049..33f67fcfa1bc 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -25,6 +25,8 @@
>   #define QCOM_ICE_REG_BIST_STATUS		0x0070
>   #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
>   #define QCOM_ICE_REG_CONTROL			0x0
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16		0x4040
> +
>   /* QCOM ICE HWKM registers */
>   #define QCOM_ICE_REG_HWKM_TZ_KM_CTL		0x1000
>   #define QCOM_ICE_REG_HWKM_TZ_KM_STATUS		0x1004
> @@ -34,6 +36,7 @@
>   #define QCOM_ICE_REG_HWKM_BANK0_BBAC_3		0x500C
>   #define QCOM_ICE_REG_HWKM_BANK0_BBAC_4		0x5010
>   
> +/* QCOM ICE HWKM BIST vals */
>   #define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
>   #define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
>   
> @@ -44,6 +47,8 @@
>   #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>   #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>   
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET	0x80
> +
>   #define QCOM_ICE_HWKM_REG_OFFSET	0x8000
>   #define HWKM_OFFSET(reg)		(reg + QCOM_ICE_HWKM_REG_OFFSET)
>   
> @@ -60,6 +65,17 @@ struct qcom_ice {
>   
>   	struct clk *core_clk;
>   	u8 hwkm_version;
> +	bool hwkm_init_complete;
> +};
> +
> +union crypto_cfg {
> +	__le32 regval;
> +	struct {
> +		u8 dusize;
> +		u8 capidx;
> +		u8 reserved;
> +		u8 cfge;
> +	};
>   };
>   
>   static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -218,6 +234,8 @@ static void qcom_ice_hwkm_init(struct qcom_ice *ice)
>   			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_3));
>   	qcom_ice_writel(ice, 0xFFFFFFFF,
>   			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_4));
> +
> +	ice->hwkm_init_complete = true;
>   }
>   
>   int qcom_ice_enable(struct qcom_ice *ice)
> @@ -263,6 +281,52 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_suspend);
>   
> +/*
> + * HW dictates the internal mapping between the ICE and HWKM slots,
> + * which are different for different versions, make the translation
> + * here.
> +*/
> +static int translate_hwkm_slot(struct qcom_ice *ice, int slot)
> +{
> +	return (ice->hwkm_version == 1) ?
> +	       (10 + slot * 2) : (slot * 2);
> +}
> +
> +static int qcom_ice_program_wrapped_key(struct qcom_ice *ice,
> +					const struct blk_crypto_key *key,
> +					u8 data_unit_size, int slot)
> +{
> +	int hwkm_slot;
> +	int err;
> +	union crypto_cfg cfg;
> +
> +	hwkm_slot = translate_hwkm_slot(ice, slot);
> +
> +	memset(&cfg, 0, sizeof(cfg));
> +	cfg.dusize = data_unit_size;
> +	cfg.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS;
> +	cfg.cfge = 0x80;
> +
> +	/* Clear CFGE */
> +	qcom_ice_writel(ice, 0x0, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
> +				  QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);
> +
> +	/* Call trustzone to program the wrapped key using hwkm */
> +	err = qcom_scm_ice_set_key(hwkm_slot, key->raw, key->size,
> +				   QCOM_SCM_ICE_CIPHER_AES_256_XTS, data_unit_size);
> +	if (err) {
> +		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err,
> +		       slot);
> +		return err;
> +	}
> +
> +	/* Enable CFGE after programming key */
> +	qcom_ice_writel(ice, cfg.regval, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
> +					 QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);
> +
> +	return err;
> +}
> +
>   int qcom_ice_program_key(struct qcom_ice *ice,
>   			 u8 algorithm_id, u8 key_size,
>   			 const struct blk_crypto_key *bkey,
> @@ -278,24 +342,36 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>   
>   	/* Only AES-256-XTS has been tested so far. */
>   	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
> -	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256) {
> +	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256 ||
> +	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED) {

This should be:
	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
	    (key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256 &&
	     key_size != QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED)) {

Otherwise it would fail on any key_size value.

Neil

>   		dev_err_ratelimited(dev,
>   				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
>   				    algorithm_id, key_size);
>   		return -EINVAL;
>   	}
>   
> -	memcpy(key.bytes, bkey->raw, AES_256_XTS_KEY_SIZE);
> -
> -	/* The SCM call requires that the key words are encoded in big endian */
> -	for (i = 0; i < ARRAY_SIZE(key.words); i++)
> -		__cpu_to_be32s(&key.words[i]);
> +	if (bkey->crypto_cfg.key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
> +		if (!ice->hwkm_version)
> +			return -EINVAL;
> +		err = qcom_ice_program_wrapped_key(ice, bkey, slot,
> +						   data_unit_size);
> +	} else {
> +		if (bkey->size != QCOM_ICE_CRYPTO_KEY_SIZE_256)
> +			dev_err_ratelimited(dev,
> +				    "Incorrect key size; bkey->size=%d\n",
> +				    algorithm_id);
> +		return -EINVAL;
> +		memcpy(key.bytes, bkey->raw, AES_256_XTS_KEY_SIZE);
>   
> -	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
> -				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> -				   data_unit_size);
> +		/* The SCM call requires that the key words are encoded in big endian */
> +		for (i = 0; i < ARRAY_SIZE(key.words); i++)
> +			__cpu_to_be32s(&key.words[i]);
>   
> -	memzero_explicit(&key, sizeof(key));
> +		err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
> +					   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> +					   data_unit_size);
> +		memzero_explicit(&key, sizeof(key));
> +	}
>   
>   	return err;
>   }
> @@ -303,7 +379,21 @@ EXPORT_SYMBOL_GPL(qcom_ice_program_key);
>   
>   int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>   {
> -	return qcom_scm_ice_invalidate_key(slot);
> +	int hwkm_slot = slot;
> +
> +	if (ice->hwkm_version) {
> +		hwkm_slot = translate_hwkm_slot(ice, slot);
> +	/*
> +	 * Ignore calls to evict key when HWKM is supported and hwkm init
> +	 * is not yet done. This is to avoid the clearing all slots call
> +	 * during a storage reset when ICE is still in legacy mode. HWKM slave
> +	 * in ICE takes care of zeroing out the keytable on reset.
> +	 */
> +		if (!ice->hwkm_init_complete)
> +			return 0;
> +	}
> +
> +	return qcom_scm_ice_invalidate_key(hwkm_slot);
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>   
> @@ -313,6 +403,15 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
>   
> +int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wrapped_key[],
> +			      unsigned int wrapped_key_size,
> +			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	return qcom_scm_derive_sw_secret(wrapped_key, wrapped_key_size,
> +					 sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
> +
>   static struct qcom_ice *qcom_ice_create(struct device *dev,
>   					void __iomem *base)
>   {
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 1f52e82e3e1c..22ab8d1a56de 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -17,6 +17,7 @@ enum qcom_ice_crypto_key_size {
>   	QCOM_ICE_CRYPTO_KEY_SIZE_192		= 0x2,
>   	QCOM_ICE_CRYPTO_KEY_SIZE_256		= 0x3,
>   	QCOM_ICE_CRYPTO_KEY_SIZE_512		= 0x4,
> +	QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED	= 0x5,
>   };
>   
>   enum qcom_ice_crypto_alg {
> @@ -35,5 +36,8 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>   			 u8 data_unit_size, int slot);
>   int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
>   bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
> +int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wrapped_key[],
> +			      unsigned int wrapped_key_size,
> +			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
>   struct qcom_ice *of_qcom_ice_get(struct device *dev);
>   #endif /* __QCOM_ICE_H__ */

