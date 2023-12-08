Return-Path: <linux-fscrypt+bounces-67-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93AC7809D75
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 08:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C64B22812F2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 07:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C749C107B0;
	Fri,  8 Dec 2023 07:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ZeRQxXpa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2141170F;
	Thu,  7 Dec 2023 23:48:47 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B878CRC014935;
	Fri, 8 Dec 2023 07:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=lMTM0OXyu+Cf3oCMk4pky0LhhGI6Ct6D1sYnx2Lfuhw=;
 b=ZeRQxXpaA/+WKSJOT7QYeMeMigmLnavYwXZ2IAQEHZE0h/O0FcAbIs6GwXOD72wr4kVf
 JhZma4IFQgodt8H4SITCIguWW144oPmMo6ze6b73rIyGmoLE8pD9A24gq8849LUYDifG
 Cm7MXWzdS2Uch16hWfIx/8aWsRuSw0KOrSpZk6dnD44kiySBa074qw/yz13tQDXYyLN/
 QBezahN0qGs8vLw9g+jg011G1mvVSzhFl8NMSn//5mOApdQ2adCaXQQ8gqzOjo9fBkLd
 8q8dhTQa3cqztWTHoMrSqJaN1Lewn+1QUaK2uYhH4x8OgKhhuW98EbpX47X4JRqhF0iu Lw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uu8p0b941-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 07:48:45 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B87miio012467
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 07:48:44 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Thu, 7 Dec
 2023 23:45:56 -0800
Message-ID: <0de13ec3-2b74-46bb-a32a-9066e637d5b1@quicinc.com>
Date: Fri, 8 Dec 2023 13:15:52 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] soc: qcom: ice: support for hardware wrapped
 keys
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-5-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-5-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: NefX6si5aumcVSH3C8-A1mPUZulpBoeW
X-Proofpoint-ORIG-GUID: NefX6si5aumcVSH3C8-A1mPUZulpBoeW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_03,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080062



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
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
>   drivers/soc/qcom/ice.c | 114 +++++++++++++++++++++++++++++++++++++----
>   include/soc/qcom/ice.h |   4 ++
>   2 files changed, 107 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index adf9cab848fa..ee7c0beef3d2 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -27,6 +27,8 @@
>   #define QCOM_ICE_REG_BIST_STATUS		0x0070
>   #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
>   #define QCOM_ICE_REG_CONTROL			0x0
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16		0x4040
> +
>   /* QCOM ICE HWKM registers */
>   #define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
>   #define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
> @@ -37,6 +39,7 @@
>   #define QCOM_ICE_REG_HWKM_BANK0_BBAC_3			0x500C
>   #define QCOM_ICE_REG_HWKM_BANK0_BBAC_4			0x5010
>   
> +/* QCOM ICE HWKM BIST vals */
>   #define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
>   #define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
>   
> @@ -47,6 +50,8 @@
>   #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>   #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>   
> +#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET	0x80
> +
>   #define QCOM_ICE_HWKM_REG_OFFSET	0x8000
>   #define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
>   
> @@ -67,6 +72,16 @@ struct qcom_ice {
>   	bool hwkm_init_complete;
>   };
>   
> +union crypto_cfg {
> +	__le32 regval;
> +	struct {
> +		u8 dusize;
> +		u8 capidx;
> +		u8 reserved;
> +		u8 cfge;
> +	};
> +};
> +
>   static bool qcom_ice_check_supported(struct qcom_ice *ice)
>   {
>   	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
> @@ -237,6 +252,8 @@ static void qcom_ice_hwkm_init(struct qcom_ice *ice)
>   	/* Clear HWKM response FIFO before doing anything */
>   	qcom_ice_writel(ice, 0x8,
>   			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
> +
> +	ice->hwkm_init_complete = true;
This this change should go with previous patch 3/12.
>   }
>   
>   int qcom_ice_enable(struct qcom_ice *ice)
> @@ -284,6 +301,51 @@ int qcom_ice_suspend(struct qcom_ice *ice)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_suspend);
>   
> +/*
> + * HW dictates the internal mapping between the ICE and HWKM slots,
> + * which are different for different versions, make the translation
> + * here. For v1 however, the translation is done in trustzone.
> + */
> +static int translate_hwkm_slot(struct qcom_ice *ice, int slot)
> +{
> +	return (ice->hwkm_version == 1) ? slot : (slot * 2);
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
use macro for constant value "0x80"
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
> @@ -299,24 +361,31 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>   
>   	/* Only AES-256-XTS has been tested so far. */
>   	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
> -	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256) {
> +	    (key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256 &&
> +	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED)) {
Can you please check the logic with && operation. the condition will 
always be false.
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
> +		if (!ice->use_hwkm)
> +			return -EINVAL;
having error log in failure case would help in debugging.
> +		err = qcom_ice_program_wrapped_key(ice, bkey, data_unit_size,
> +						   slot);
> +	} else {
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
> @@ -324,7 +393,21 @@ EXPORT_SYMBOL_GPL(qcom_ice_program_key);
>   
>   int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>   {
> -	return qcom_scm_ice_invalidate_key(slot);
> +	int hwkm_slot = slot;
> +
> +	if (ice->use_hwkm) {
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
> @@ -334,6 +417,15 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
>   
> +int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
> +			      unsigned int wkey_size,
> +			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
> +{
> +	return qcom_scm_derive_sw_secret(wkey, wkey_size,
> +					 sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
> +
>   static struct qcom_ice *qcom_ice_create(struct device *dev,
>   					void __iomem *base)
>   {
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index 1f52e82e3e1c..dabe0d3a1fd0 100644
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
> +int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
> +			      unsigned int wkey_size,
> +			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
>   struct qcom_ice *of_qcom_ice_get(struct device *dev);
>   #endif /* __QCOM_ICE_H__ */

