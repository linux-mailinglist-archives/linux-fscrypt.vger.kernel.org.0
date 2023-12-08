Return-Path: <linux-fscrypt+bounces-71-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56D3E809E29
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 09:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 731241C20C6D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 08:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECEE134BD;
	Fri,  8 Dec 2023 08:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="J7MhzpG8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964A11724;
	Fri,  8 Dec 2023 00:33:18 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B88SLix003999;
	Fri, 8 Dec 2023 08:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=j6GaBLldicDw/0P7tgcpOsjF79gmOmP68u8D6awqG98=;
 b=J7MhzpG8/WSamw7EsDiZjG+QAFdkHHBeOSrqnc1NOxAMvYM0/Uqy4TUCF3Q2ZY5SscJX
 0yQxJeUGJLeijkW3rRQNb1wW05hg85ZT5sLjSw+j9xSHd1n8qJ8BIqAHc6ScOmhFJ1f3
 HtzUs0mESOfrYLYELQb7405ju1mbvsKEHifGAqYBBAoCY2sg1h0Gx+iiwu/DDXmebXR3
 jAex4pm6R7cOYGE2A4MdfbuTBVj2MPnxwVPtlU2R1bfJgUpl5x+jXUy0yveK2ZCLeQSa
 3Ht618RJyL3PiYzKrk4RDC3GoaBRKE4gxim1rCdhrEo7+1ZFesCmut2dxbynL8EA3hWT /g== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uuj96hn31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 08:33:15 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B88XEH8002134
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 08:33:14 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 8 Dec
 2023 00:26:41 -0800
Message-ID: <180d6f11-82aa-439f-914d-981454a7599b@quicinc.com>
Date: Fri, 8 Dec 2023 13:56:38 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/12] soc: qcom: support for generate, import and
 prepare key
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-10-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-10-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: nr8BJ9Tj-FqXCsfIe5Rt1ERp2tek8Nbf
X-Proofpoint-ORIG-GUID: nr8BJ9Tj-FqXCsfIe5Rt1ERp2tek8Nbf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 mlxlogscore=882 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080069



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> Implements the ICE apis for generate, prepare and import key
> apis and hooks it up the scm calls defined for them.

We can avoid mentioning below text as it is also possibility to have 
HWKM Linux driver.
> Key management has to be done from Qualcomm Trustzone as only
> it can interface with HWKM.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/soc/qcom/ice.c | 66 ++++++++++++++++++++++++++++++++++++++++++
>   include/soc/qcom/ice.h |  8 +++++
>   2 files changed, 74 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index ee7c0beef3d2..b00f314521ca 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -21,6 +21,13 @@
>   
>   #define AES_256_XTS_KEY_SIZE			64
>   
> +/*
> + * Wrapped key sizes from HWKm is different for different versions of
"HWKM"
> + * HW. It is not expected to change again in the future.
we can avoid mentioning "It is not expected to change again in the future"
> + */
> +#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
> +	((v) == 1 ? 68 : 100)
> +
>   /* QCOM ICE registers */
>   #define QCOM_ICE_REG_VERSION			0x0008
>   #define QCOM_ICE_REG_FUSE_SETTING		0x0010
> @@ -426,6 +433,65 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
>   }
>   EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
>   
> +/**
> + * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
> + * @lt_key: longterm wrapped key that is generated, which is
> + *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to generate a wrapped key for storage
> + * encryption using hwkm.
> + *
> + * Return: 0 on success; err on failure.
> + */
> +int qcom_ice_generate_key(struct qcom_ice *ice,
> +			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	return qcom_scm_generate_ice_key(lt_key,
> +					 QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
> +
> +/**
> + * qcom_ice_prepare_key() - Prepare a longterm wrapped key for inline encryption
> + * @lt_key: longterm wrapped key that is generated or imported.
> + * @lt_key_size: size of the longterm wrapped_key
> + * @eph_key: wrapped key returned which has been wrapped with a per-boot ephemeral key,
> + *           size of which is BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to prepare a wrapped key for storage
> + * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
> + * key using hwkm.
> + *
> + * Return: 0 on success; err on failure.
avoid Return value documentation as it is not adding any specific 
information.
> + */
> +int qcom_ice_prepare_key(struct qcom_ice *ice, const u8 *lt_key, size_t lt_key_size,
> +			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	return qcom_scm_prepare_ice_key(lt_key, lt_key_size, eph_key,
> +					QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
> +
> +/**
> + * qcom_ice_import_key() - Import a raw key for inline encryption
> + * @imp_key: raw key that has to be imported
> + * @imp_key_size: size of the imported key
> + * @lt_key: longterm wrapped key that is imported, which is
> + *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
> + *
> + * Make a scm call into trustzone to import a raw key for storage encryption
> + * and generate a longterm wrapped key using hwkm.
> + *
> + * Return: 0 on success; err on failure.
> + */
> +int qcom_ice_import_key(struct qcom_ice *ice, const u8 *imp_key, size_t imp_key_size,
> +			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	return qcom_scm_import_ice_key(imp_key, imp_key_size, lt_key,
> +				       QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> +
>   static struct qcom_ice *qcom_ice_create(struct device *dev,
>   					void __iomem *base)
>   {
> diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
> index dabe0d3a1fd0..dcf277d196ff 100644
> --- a/include/soc/qcom/ice.h
> +++ b/include/soc/qcom/ice.h
> @@ -39,5 +39,13 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>   int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
>   			      unsigned int wkey_size,
>   			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
> +int qcom_ice_generate_key(struct qcom_ice *ice,
> +			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +int qcom_ice_prepare_key(struct qcom_ice *ice,
> +			 const u8 *lt_key, size_t lt_key_size,
> +			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +int qcom_ice_import_key(struct qcom_ice *ice,
> +			const u8 *imp_key, size_t imp_key_size,
> +			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
>   struct qcom_ice *of_qcom_ice_get(struct device *dev);
>   #endif /* __QCOM_ICE_H__ */

