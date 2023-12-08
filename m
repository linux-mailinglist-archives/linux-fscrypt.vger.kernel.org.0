Return-Path: <linux-fscrypt+bounces-66-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22009809C8D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 07:42:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAA6F1F2106D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 06:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCDB363AD;
	Fri,  8 Dec 2023 06:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="PL6ge/nj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6A61723;
	Thu,  7 Dec 2023 22:42:41 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B86KZ04011091;
	Fri, 8 Dec 2023 06:42:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=KzzN6S733xQH5Xrq7RBS+FTw1kHcnk6Z6QkJm+rY9ks=;
 b=PL6ge/njeVWwOAdSJVduGkvZoSZ+8B6/JScVmURya1XzzZWJO3ycYRB14kThgv8Kj28V
 0R4zSTP7peThZDiYo3wj/aR4eNVJqsFZGtS2DGwiaonBTcOKcEmrXJ+IwqJzsF1pqGAn
 p2S8J8QeXDI/yBQwt86bldNOJXF0PJEgZfj7XvrEyUG4nI2ftMfMR4JezWN/uwzIPNzp
 qyheIb48iI5YBR7ihT156ox4xvSkfctO8df1gAsVp0dum1+3CsbMpyjX/nI1wzfa8zM8
 VxtWwxEWHiwLJ9vCwUmATWRQs5r/0wPZiBfaZnM0DbD5raukLT0t6/g2/5S5JZ2kvQwD Ig== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uubd82rpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 06:42:39 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B86gcZ8021524
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 06:42:38 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Thu, 7 Dec
 2023 22:38:49 -0800
Message-ID: <30a12c5e-8336-43e8-9bca-1180e046af1e@quicinc.com>
Date: Fri, 8 Dec 2023 12:08:45 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/12] qcom_scm: scm call for deriving a software
 secret
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-3-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-3-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: iP9lA8ykY04IaEM6H1mVekqFd9XzQWba
X-Proofpoint-ORIG-GUID: iP9lA8ykY04IaEM6H1mVekqFd9XzQWba
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_02,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=845 impostorscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080052



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> Inline storage encryption requires deriving a sw secret from
> the hardware wrapped keys. For non-wrapped keys, this can be
> directly done as keys are in the clear.
> 
> However, when keys are hardware wrapped, it can be unwrapped
> by HWKM (Hardware Key Manager) which is accessible only from Qualcomm
> Trustzone. Hence, it also makes sense that the software secret is also
> derived there and returned to the linux kernel . This can be invoked by
> using the crypto profile APIs provided by the block layer.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/firmware/qcom/qcom_scm.c       | 71 ++++++++++++++++++++++++++
>   drivers/firmware/qcom/qcom_scm.h       |  1 +
>   include/linux/firmware/qcom/qcom_scm.h |  2 +
>   3 files changed, 74 insertions(+)
> 
> diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> index 520de9b5633a..6dfb913f3e33 100644
> --- a/drivers/firmware/qcom/qcom_scm.c
> +++ b/drivers/firmware/qcom/qcom_scm.c
> @@ -1214,6 +1214,77 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>   }
>   EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
>   
> +/**
> + * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
> + * @wkey: the hardware wrapped key inaccessible to software
> + * @wkey_size: size of the wrapped key
> + * @sw_secret: the secret to be derived which is exactly the secret size
> + * @sw_secret_size: size of the sw_secret
> + *
> + * Derive a software secret from a hardware wrapped key for software crypto
> + * operations.
> + * For wrapped keys, the key needs to be unwrapped, in order to derive a
> + * software secret, which can be done in the hardware from a secure execution
> + * environment.
> + *
> + * For more information on sw secret, please refer to "Hardware-wrapped keys"
> + * section of Documentation/block/inline-encryption.rst.
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
> +			      u8 *sw_secret, size_t sw_secret_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = wkey_size,
> +		.args[3] = sw_secret_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *wkey_buf, *secret_buf;
> +	dma_addr_t wkey_phys, secret_phys;
> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 */
> +	wkey_buf = dma_alloc_coherent(__scm->dev, wkey_size, &wkey_phys, GFP_KERNEL);
> +	if (!wkey_buf)
> +		return -ENOMEM;
> +	secret_buf = dma_alloc_coherent(__scm->dev, sw_secret_size, &secret_phys, GFP_KERNEL);
> +	if (!secret_buf) {
> +		ret = -ENOMEM;
> +		goto err_free_wrapped;
> +	}
> +
> +	memcpy(wkey_buf, wkey, wkey_size);
> +	desc.args[0] = wkey_phys;
> +	desc.args[2] = secret_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(sw_secret, secret_buf, sw_secret_size);
> +
> +	memzero_explicit(secret_buf, sw_secret_size);
> +
> +	dma_free_coherent(__scm->dev, sw_secret_size, secret_buf, secret_phys);
> +
> +err_free_wrapped:
> +	memzero_explicit(wkey_buf, wkey_size);
In error handling case the operation is being performed on unallocated 
memory.
> +
> +	dma_free_coherent(__scm->dev, wkey_size, wkey_buf, wkey_phys);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
> +
>   /**
>    * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
>    *
> diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
> index 4532907e8489..c75456aa6ac5 100644
> --- a/drivers/firmware/qcom/qcom_scm.h
> +++ b/drivers/firmware/qcom/qcom_scm.h
> @@ -121,6 +121,7 @@ int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
>   #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
>   #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
>   #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
> +#define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
>   
>   #define QCOM_SCM_SVC_HDCP		0x11
>   #define QCOM_SCM_HDCP_INVOKE		0x01
> diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
> index ccaf28846054..c65f2d61492d 100644
> --- a/include/linux/firmware/qcom/qcom_scm.h
> +++ b/include/linux/firmware/qcom/qcom_scm.h
> @@ -103,6 +103,8 @@ bool qcom_scm_ice_available(void);
>   int qcom_scm_ice_invalidate_key(u32 index);
>   int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
>   			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
> +int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
> +			      u8 *sw_secret, size_t sw_secret_size);
>   
>   bool qcom_scm_hdcp_available(void);
>   int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);

