Return-Path: <linux-fscrypt+bounces-84-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 993F4810C15
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Dec 2023 09:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E690281172
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Dec 2023 08:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C451CA9C;
	Wed, 13 Dec 2023 08:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SeiNWAzM"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E63DC;
	Wed, 13 Dec 2023 00:11:37 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BD5UX0D010227;
	Wed, 13 Dec 2023 08:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	qcppdkim1; bh=+ChEAqS33Z56IRd3N2DhM7q96imu5cTHGBUgzTDjZzM=; b=Se
	iNWAzMnIrCbWkaTTuP0oa/90zfkiLLIEtcTgHivou9Qz2g+NKOu3PsmLcQbDMGug
	rCUMU5BHh76lwr2q07Gg9lHunr5f+jumU+KW1J+0zMMFUXS2uIgEP+hzCJ9v5PoU
	ASFtljsbtTF6Hn+il2HMBH/LZ6Oj3tYjCuyNsLODxYIC6kWj53zyL1RfrIEYUekL
	MlOZ1gw3W0ggAKnpKUzBiRdu7Yh8HjD+0P7ySFY1fBTuxvn+0jDsxa4VDQAT0Jxw
	xXwGyCoSwouLRP+y237AqOLq2A6OicSqUTAQebPMg8mN5s42kC+z7HUjxnKxJ4He
	/CliYlxG0Tc9mHI4AtaQ==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uy4dhgn1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 08:11:32 +0000 (GMT)
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3BD8BVf5013183
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 08:11:31 GMT
Received: from [10.214.66.81] (10.80.80.8) by nasanex01c.na.qualcomm.com
 (10.45.79.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Wed, 13 Dec
 2023 00:11:24 -0800
Message-ID: <4c0c6caa-c85c-d802-9383-501c92a53008@quicinc.com>
Date: Wed, 13 Dec 2023 13:41:13 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 07/12] qcom_scm: scm call for create, prepare and
 import keys
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-8-quic_gaurkash@quicinc.com>
Content-Language: en-US
From: Mukesh Ojha <quic_mojha@quicinc.com>
In-Reply-To: <20231122053817.3401748-8-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: b36LWEngtMGOO-36NHtAclj3ULX_6LxR
X-Proofpoint-GUID: b36LWEngtMGOO-36NHtAclj3ULX_6LxR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2311290000
 definitions=main-2312130058



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> Storage encryption has two IOCTLs for creating, importing
> and preparing keys for encryption. For wrapped keys, these
> IOCTLs need to interface with the secure environment, which
> require these SCM calls.
> 
> generate_key: This is used to generate and return a longterm
>                wrapped key. Trustzone achieves this by generating
> 	      a key and then wrapping it using hwkm, returning
> 	      a wrapped keyblob.
> import_key:   The functionality is similar to generate, but here,
>                a raw key is imported into hwkm and a longterm wrapped
> 	      keyblob is returned.
> prepare_key:  The longterm wrapped key from import or generate
>                is made further secure by rewrapping it with a per-boot
> 	      ephemeral wrapped key before installing it to the linux
> 	      kernel for programming to ICE.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>

[..]
> ---
>   drivers/firmware/qcom/qcom_scm.c       | 205 +++++++++++++++++++++++++
>   drivers/firmware/qcom/qcom_scm.h       |   3 +
>   include/linux/firmware/qcom/qcom_scm.h |   5 +
>   3 files changed, 213 insertions(+)
> 
> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> index 6dfb913f3e33..259b3c316019 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -1285,6 +1285,211 @@ int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
>   }
>   EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
>   
> +/**
> + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> + * @lt_key: the wrapped key returned after key generation
> + * @lt_key_size: size of the wrapped key to be returned.
> + *
> + * Qualcomm wrapped keys need to be generated in a trusted environment.
> + * A generate key  IOCTL call is used to achieve this. These are longterm

nit: remove space after key

> + * in nature as they need to be generated and wrapped only once per
> + * requirement.
> + *
> + * This SCM calls adds support for the create key IOCTL to interface

Just starting with "Adds support... " would do.

> + * with the secure environment to generate and return a wrapped key..
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(2, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),

Keep this in one line.

> +		.args[1] = lt_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *lt_key_buf;
> +	dma_addr_t lt_key_phys; > +	int ret;

reverse x-mas tree is the everyone looks to be following..

dma_addr_t lt_key_phys;
void *lt_key_buf;
int ret;

> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *

Extra *

> +	 */
> +	lt_key_buf = dma_alloc_coherent(__scm->dev, lt_key_size, &lt_key_phys, GFP_KERNEL);
> +	if (!lt_key_buf)
> +		return -ENOMEM;
> +
> +	desc.args[0] = lt_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	memcpy(lt_key, lt_key_buf, lt_key_size);

Do you really want to copy the key buf if the scm call fails ?

> +
> +	memzero_explicit(lt_key_buf, lt_key_size);
> +
> +	dma_free_coherent(__scm->dev, lt_key_size, lt_key_buf, lt_key_phys);
> +
> +	if (!ret)

why this is here instead of just after qcom_scm_call() ?

> +		return lt_key_size;

You said, you will return 0 on success.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
> +
> +/**
> + * qcom_scm_prepare_ice_key() - Get per boot ephemeral wrapped key
> + * @lt_key: the longterm wrapped key
> + * @lt_key_size: size of the wrapped key
> + * @eph_key: ephemeral wrapped key to be returned
> + * @eph_key_size: size of the ephemeral wrapped key
> + *
> + * Qualcomm wrapped keys (longterm keys) are rewrapped with a per-boot
> + * ephemeral key for added protection. These are ephemeral in nature as
> + * they are valid only for that boot. A create key IOCTL is used to
> + * achieve this. These are the keys that are installed into the kernel
> + * to be then unwrapped and programmed into ICE.
> + *
> + * This SCM call adds support for the create key IOCTL to interface
> + * with the secure environment to rewrap the wrapped key with an
> + * ephemeral wrapping key.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
> +			     u8 *eph_key, size_t eph_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = lt_key_size,
> +		.args[3] = eph_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *lt_key_buf, *eph_key_buf;
> +	dma_addr_t lt_key_phys, eph_key_phys;
> +	int ret;

One variable and R-XMAS is the norm..
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *

extra *

> +	 */
> +	lt_key_buf = dma_alloc_coherent(__scm->dev, lt_key_size, &lt_key_phys, GFP_KERNEL);
> +	if (!lt_key_buf)
> +		return -ENOMEM;
> +	eph_key_buf = dma_alloc_coherent(__scm->dev, eph_key_size, &eph_key_phys, GFP_KERNEL);
> +	if (!eph_key_buf) {
> +		ret = -ENOMEM;
> +		goto err_free_longterm;
> +	}
> +
> +	memcpy(lt_key_buf, lt_key, lt_key_size);
> +	desc.args[0] = lt_key_phys;
> +	desc.args[2] = eph_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(eph_key, eph_key_buf, eph_key_size);
> +
> +	memzero_explicit(eph_key_buf, eph_key_size);
> +
> +	dma_free_coherent(__scm->dev, eph_key_size, eph_key_buf, eph_key_phys);
> +
> +err_free_longterm:
> +	memzero_explicit(lt_key_buf, lt_key_size);
> +
> +	dma_free_coherent(__scm->dev, lt_key_size, lt_key_buf, lt_key_phys);
> +
> +	if (!ret)
> +		return eph_key_size;

you said, this will return 0 on success..
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
> +
> +/**
> + * qcom_scm_import_ice_key() - Import a wrapped key for encryption
> + * @imp_key: the raw key that is imported
> + * @imp_key_size: size of the key to be imported
> + * @lt_key: the wrapped key to be returned
> + * @lt_key_size: size of the wrapped key
> + *
> + * Conceptually, this is very similar to generate, the difference being,
> + * here we want to import a raw key and return a longterm wrapped key
> + * from it. The same create key IOCTL is used to achieve this.
> + *
> + * This SCM call adds support for the create key IOCTL to interface with
> + * the secure environment to import a raw key and generate a longterm
> + * wrapped key.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_import_ice_key(const u8 *imp_key, size_t imp_key_size,
> +			    u8 *lt_key, size_t lt_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = imp_key_size,
> +		.args[3] = lt_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *imp_key_buf, *lt_key_buf;
> +	dma_addr_t imp_key_phys, lt_key_phys;
> +	int ret;
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *

Extra  *

> +	 */
> +	imp_key_buf = dma_alloc_coherent(__scm->dev, imp_key_size, &imp_key_phys, GFP_KERNEL);
> +	if (!imp_key_buf)
> +		return -ENOMEM;
> +	lt_key_buf = dma_alloc_coherent(__scm->dev, lt_key_size, &lt_key_phys, GFP_KERNEL);
> +	if (!lt_key_buf) {
> +		ret = -ENOMEM;
> +		goto err_free_longterm;
> +	}
> +
> +	memcpy(imp_key_buf, imp_key, imp_key_size);
> +	desc.args[0] = imp_key_phys;
> +	desc.args[2] = lt_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(lt_key, lt_key_buf, lt_key_size);
> +
> +	memzero_explicit(lt_key_buf, lt_key_size);
> +

Why there is unnecessary line gap everywhere between lines ?

> +	dma_free_coherent(__scm->dev, lt_key_size, lt_key_buf, lt_key_phys);
> +
> +err_free_longterm:
> +	memzero_explicit(imp_key_buf, imp_key_size);
> +
> +	dma_free_coherent(__scm->dev, imp_key_size, imp_key_buf, imp_key_phys);
> +
> +	if (!ret)
> +		return lt_key_size;

same as above comment on return value..

-Mukesh

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
> +
>   /**
>    * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
>    *
> diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
> index c75456aa6ac5..d89ab5446ba5 100644
> --- a/drivers/firmware/qcom/qcom_scm.h
> +++ b/drivers/firmware/qcom/qcom_scm.h
> @@ -122,6 +122,9 @@ int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
>   #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
>   #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
>   #define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
> +#define QCOM_SCM_ES_GENERATE_ICE_KEY	0x08
> +#define QCOM_SCM_ES_PREPARE_ICE_KEY	0x09
> +#define QCOM_SCM_ES_IMPORT_ICE_KEY	0xA
>   
>   #define QCOM_SCM_SVC_HDCP		0x11
>   #define QCOM_SCM_HDCP_INVOKE		0x01
> diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
> index c65f2d61492d..477aeec6255e 100644
> --- a/include/linux/firmware/qcom/qcom_scm.h
> +++ b/include/linux/firmware/qcom/qcom_scm.h
> @@ -105,6 +105,11 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>   			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
>   int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
>   			      u8 *sw_secret, size_t sw_secret_size);
> +int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size);
> +int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
> +			     u8 *eph_key, size_t eph_size);
> +int qcom_scm_import_ice_key(const u8 *imp_key, size_t imp_size,
> +			    u8 *lt_key, size_t lt_key_size);
>   
>   bool qcom_scm_hdcp_available(void);
>   int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);

