Return-Path: <linux-fscrypt+bounces-63-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62399809C33
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 07:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D61E2812E3
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 06:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928EC79E6;
	Fri,  8 Dec 2023 06:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="lc8H7dvH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC93171F;
	Thu,  7 Dec 2023 22:10:57 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B85vapg030422;
	Fri, 8 Dec 2023 06:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=pSU34edO5jTZ1OqNcCuhDDhJsjTwsC62IGDbIYgKSBM=;
 b=lc8H7dvHQsFc7yY8huPvc38RjAodUyWLW7CXFT3fgZe1BgFXBlcVBXsDbW3FvYK98RlJ
 Wg8sAJiWlaPPQIRuwEu0hTuJzTTtkdhfiwCcP32d/HqeZVy/h0zMCqbR9+aOEor6+jYW
 KeGFsF0SJTbyslB+z+cIpF3CbW+NkRBhiT1NbxEbKpqDxFxkgAeT8NY5G65iYjM1F/2I
 78sUi2nc2H3wK9Y1uO6aroD+WDOuyNc3C90yog1YKhcwoo+OF4LCEv7HuuU98bP/2VF8
 n+c0vyHlaSHyxZ3ncz6scZhSzLT7EHiMncmT6zwKFLBPZwSfhoA5d3ux6aPSSvMYrMtW /w== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uubd82q3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 06:10:54 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B86As38028170
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 06:10:54 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Thu, 7 Dec
 2023 22:04:56 -0800
Message-ID: <4ce492fe-f0a6-41cf-8d8f-f088c4f6d59e@quicinc.com>
Date: Fri, 8 Dec 2023 11:34:33 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/12] soc: qcom: ice: add hwkm support in ice
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-4-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-4-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: rfh1smL_zzJ-SwVrVBBF32-9G0VSFjEI
X-Proofpoint-ORIG-GUID: rfh1smL_zzJ-SwVrVBBF32-9G0VSFjEI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_02,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080047



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary
> key management hardware called Hardware Key Manager (HWKM).
> This patch integrates HWKM support in ICE when it is
> available. HWKM primarily provides hardware wrapped key support
> where the ICE (storage) keys are not available in software and
> protected in hardware.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/soc/qcom/ice.c | 133 ++++++++++++++++++++++++++++++++++++++++-
>   include/soc/qcom/ice.h |   1 +
>   2 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index 6f941d32fffb..adf9cab848fa 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -26,6 +26,19 @@
>   #define QCOM_ICE_REG_FUSE_SETTING		0x0010
>   #define QCOM_ICE_REG_BIST_STATUS		0x0070
>   #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
> +#define QCOM_ICE_REG_CONTROL			0x0
> +/* QCOM ICE HWKM registers */
> +#define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
> +#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
> +#define QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS	0x2008
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0			0x5000
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1			0x5004
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2			0x5008
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3			0x500C
> +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4			0x5010
> +
> +#define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
> +#define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
>   
>   /* BIST ("built-in self-test") status flags */
>   #define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
> @@ -34,6 +47,9 @@
>   #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
>   #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
>   
> +#define QCOM_ICE_HWKM_REG_OFFSET	0x8000
> +#define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
> +
>   #define qcom_ice_writel(engine, val, reg)	\
>   	writel((val), (engine)->base + (reg))
>   
> @@ -46,6 +62,9 @@ struct qcom_ice {
>   	struct device_link *link;
>   
>   	struct clk *core_clk;
> +	u8 hwkm_version;
> +	bool use_hwkm;

we can rely on hwkm_version alone to determine if hwkm support is 
available or not.
if hwkm_version = 0 (default) consider hwkm is not enabled

> +	bool hwkm_init_complete;
>   };
>   
>   static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -63,8 +82,26 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
>   		return false;
>   	}
>   
> +	if (major >= 4 || (major == 3 && minor == 2 && step >= 1))
> +		ice->hwkm_version = 2;
> +	else if (major == 3 && minor == 2)
> +		ice->hwkm_version = 1;
> +	else
> +		ice->hwkm_version = 0;
> +
> +	if (ice->hwkm_version == 0)
> +		ice->use_hwkm = false;
> +
hwkm version should pass from device-tree property instead of current 
complex logic. This will be helpful in support future hwkm version also.
ice->hwkm_version == 0, condition can be use for determining if hwkm is 
enabled or not.

>   	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
>   		 major, minor, step);
> +	if (!ice->hwkm_version)
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not supported");
> +	else
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) version = %d",
> +			 ice->hwkm_version);
> +
> +	if (!ice->use_hwkm)
> +		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not used");
>   
>   	/* If fuses are blown, ICE might not work in the standard way. */
>   	regval = qcom_ice_readl(ice, QCOM_ICE_REG_FUSE_SETTING);
> @@ -113,10 +150,14 @@ static void qcom_ice_optimization_enable(struct qcom_ice *ice)
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
> @@ -125,15 +166,95 @@ static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
>   	if (err)
>   		dev_err(ice->dev, "Timed out waiting for ICE self-test to complete\n");
>   
> +	if (ice->use_hwkm) {
> +		bist_done_val = (ice->hwkm_version == 1) ?
> +				 QCOM_ICE_HWKM_BIST_DONE_V1_VAL :
> +				 QCOM_ICE_HWKM_BIST_DONE_V2_VAL;
> +		if (qcom_ice_readl(ice,
> +				   HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_STATUS)) !=
> +				   bist_done_val) {
> +			dev_warn(ice->dev, "HWKM BIST error\n");
> +			ice->use_hwkm = false;
error is not passed to caller. if HWKM is enabled, and BIST failed, ICE 
init also should be considered has failure.

Any reason considering it as warning only ?
> +		}
> +	}
>   	return err;
>   }
>   
> +static void qcom_ice_enable_standard_mode(struct qcom_ice *ice)
> +{
> +	u32 val = 0;
> +
> +	if (!ice->use_hwkm)
> +		return;
> +
> +	/*
> +	 * When ICE is in standard (hwkm) mode, it supports HW wrapped
> +	 * keys, and when it is in legacy mode, it only supports standard
> +	 * (non HW wrapped) keys.
> +	 *
> +	 * Put ICE in standard mode, ICE defaults to legacy mode.
> +	 * Legacy mode - ICE HWKM slave not supported.
> +	 * Standard mode - ICE HWKM slave supported.
> +	 *
> +	 * Depending on the version of HWKM, it is controlled by different
> +	 * registers in ICE.
> +	 */
> +	if (ice->hwkm_version >= 2) {

hwkm_version version >= 2 is not exist. This programming instruction may 
create problem in future.

> +		val = qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
> +		val = val & 0xFFFFFFFE;
> +		qcom_ice_writel(ice, val, QCOM_ICE_REG_CONTROL);
> +	} else {
> +		qcom_ice_writel(ice, 0x7,
void using constant value like "0x7" in code use #define with meaningful 
name that can indicate what operation is being performed.
This comment is applicable for many places.
> +				HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
> +	}
> +}
> +
> +static void qcom_ice_hwkm_init(struct qcom_ice *ice)
> +{
> +	if (!ice->use_hwkm)
> +		return;
> +
> +	/* Disable CRC checks. This HWKM feature is not used. */
> +	qcom_ice_writel(ice, 0x6,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
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
> +
> +	/* Clear HWKM response FIFO before doing anything */
> +	qcom_ice_writel(ice, 0x8,
> +			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
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
new code added in this section is only application when hwkm is enabled.
if (!ice->hwkm_version) {
	qcom_ice_enable_standard_mode(ice);
	qcom_ice_hwkm_init(ice);
}
> +
> +	return err;
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_enable);
>   
> @@ -149,6 +270,8 @@ int qcom_ice_resume(struct qcom_ice *ice)
>   		return err;
>   	}
>   
> +	qcom_ice_enable_standard_mode(ice);
> +	qcom_ice_hwkm_init(ice);
>   	return qcom_ice_wait_bist_status(ice);
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_resume);
> @@ -205,6 +328,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
>   
> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
> +{
> +	return ice->use_hwkm;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> +
>   static struct qcom_ice *qcom_ice_create(struct device *dev,
>   					void __iomem *base)
>   {
> @@ -239,6 +368,8 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>   		engine->core_clk = devm_clk_get_enabled(dev, NULL);
>   	if (IS_ERR(engine->core_clk))
>   		return ERR_CAST(engine->core_clk);
> +	engine->use_hwkm = of_property_read_bool(dev->of_node,
> +						 "qcom,ice-use-hwkm");
>   
>   	if (!qcom_ice_check_supported(engine))
>   		return ERR_PTR(-EOPNOTSUPP);
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

