Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4533759CC3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjGSRsn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjGSRsn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:48:43 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25AE1BF6;
        Wed, 19 Jul 2023 10:48:41 -0700 (PDT)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JHKwsd016118;
        Wed, 19 Jul 2023 17:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=qmfK0acunX87SRjr5i+zJqpgvPTCAPosGAy5Rg+8G2A=;
 b=PBuFrEv8hwRkL9TqRBwRkJbK0LVgEiW1ZbIxcvTQPoPi7i+5A5C2oPuxF/xBFBHPitnE
 Qjyl7ZW1CG125IDwG0JO86hz++ObYtABjtLq+mlEBmOfVgdl0fEJESDKFg8U/oKXAwIc
 nwOFMAEXOH+O1G5xxVQfo0hdVPrwreMNJU8P3NTz39bmdcnbvAL/QQxTwx5Mp/zsmA+3
 6VqWaBv0xfm7kq4YZXapYftcoaTiPh9VEZwFaJlxYS48T540yr2+TSDUrq7+jHTu/Ve4
 1nc3HOlzEBEpPRlPuAi1+L9G+W+rbkf9VftekGQq8GIRJn4jAi6I1Plp1/nIxxlY+0Fp IA== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rxg3v8pvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:48:38 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JHmb0f019294
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:48:37 GMT
Received: from [10.110.1.206] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.30; Wed, 19 Jul
 2023 10:48:36 -0700
Message-ID: <62207b82-92c1-e666-67e4-420a112c281f@quicinc.com>
Date:   Wed, 19 Jul 2023 10:48:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 07/10] qcom_scm: scm call for create, prepare and
 import keys
Content-Language: en-US
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-8-quic_gaurkash@quicinc.com>
From:   Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <20230719170423.220033-8-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: UgsBkGTjh5i6zOiE0cC31J2HwV-7ii2c
X-Proofpoint-ORIG-GUID: UgsBkGTjh5i6zOiE0cC31J2HwV-7ii2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_12,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=939 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307190160
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 7/19/2023 10:04 AM, Gaurav Kashyap wrote:
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
> ---
>   drivers/firmware/qcom_scm.c            | 222 +++++++++++++++++++++++++
>   drivers/firmware/qcom_scm.h            |   3 +
>   include/linux/firmware/qcom/qcom_scm.h |  10 ++
>   3 files changed, 235 insertions(+)
> 
> diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> index 51062d5c7f7b..44dd1857747b 100644
> --- a/drivers/firmware/qcom_scm.c
> +++ b/drivers/firmware/qcom_scm.c
> @@ -1210,6 +1210,228 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
>   }
>   EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
>   
> +/**
> + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> + * @longterm_wrapped_key: the wrapped key returned after key generation
> + * @longterm_wrapped_key_size: size of the wrapped key to be returned.
> + *
> + * Qualcomm wrapped keys need to be generated in a trusted environment.
> + * A generate key  IOCTL call is used to achieve this. These are longterm
> + * in nature as they need to be generated and wrapped only once per
> + * requirement.
> + *
> + * This SCM calls adds support for the generate key IOCTL to interface
> + * with the secure environment to generate and return a wrapped key..
> + *
> + * Return: 0 on success; -errno on failure.
> + */
> +int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
> +			    u32 longterm_wrapped_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(2, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = longterm_wrapped_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *longterm_wrapped_keybuf;
> +	dma_addr_t longterm_wrapped_key_phys;
> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *
> +	 */
> +	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				  longterm_wrapped_key_size,
> +				  &longterm_wrapped_key_phys, GFP_KERNEL);
> +	if (!longterm_wrapped_keybuf)
> +		return -ENOMEM;
> +
> +	desc.args[0] = longterm_wrapped_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	memcpy(longterm_wrapped_key, longterm_wrapped_keybuf,
> +	       longterm_wrapped_key_size);
> +
> +	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
> +			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
> +
> +	if (!ret)
> +		return longterm_wrapped_key_size;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_generate_ice_key);
> +
> +/**
> + * qcom_scm_prepare_ice_key() - Get per boot ephemeral wrapped key
> + * @longterm_wrapped_key: the wrapped key
> + * @longterm_wrapped_key_size: size of the wrapped key
> + * @ephemeral_wrapped_key: ephemeral wrapped key to be returned
> + * @ephemeral_wrapped_key_size: size of the ephemeral wrapped key
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
> +int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
> +			     u32 longterm_wrapped_key_size,
> +			     u8 *ephemeral_wrapped_key,
> +			     u32 ephemeral_wrapped_key_size)
> +{
> +	struct qcom_scm_desc desc = {
> +		.svc = QCOM_SCM_SVC_ES,
> +		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
> +		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
> +					 QCOM_SCM_VAL, QCOM_SCM_RW,
> +					 QCOM_SCM_VAL),
> +		.args[1] = longterm_wrapped_key_size,
> +		.args[3] = ephemeral_wrapped_key_size,
> +		.owner = ARM_SMCCC_OWNER_SIP,
> +	};
> +
> +	void *longterm_wrapped_keybuf, *ephemeral_wrapped_keybuf;
> +	dma_addr_t longterm_wrapped_key_phys, ephemeral_wrapped_key_phys;
> +	int ret;
> +
> +	/*
> +	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
> +	 * get a physical address, while guaranteeing that we can zeroize the
> +	 * key material later using memzero_explicit().
> +	 *
> +	 */
> +	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				  longterm_wrapped_key_size,
> +				  &longterm_wrapped_key_phys, GFP_KERNEL);
> +	if (!longterm_wrapped_keybuf)
> +		return -ENOMEM;
> +	ephemeral_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
> +				   ephemeral_wrapped_key_size,
> +				   &ephemeral_wrapped_key_phys, GFP_KERNEL);
> +	if (!ephemeral_wrapped_keybuf) {
> +		ret = -ENOMEM;
> +		goto bail_keybuf;
> +	}
> +
> +	memcpy(longterm_wrapped_keybuf, longterm_wrapped_key,
> +	       longterm_wrapped_key_size);
> +	desc.args[0] = longterm_wrapped_key_phys;
> +	desc.args[2] = ephemeral_wrapped_key_phys;
> +
> +	ret = qcom_scm_call(__scm->dev, &desc, NULL);
> +	if (!ret)
> +		memcpy(ephemeral_wrapped_key, ephemeral_wrapped_keybuf,
> +		       ephemeral_wrapped_key_size);
> +
> +	memzero_explicit(ephemeral_wrapped_keybuf, ephemeral_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, ephemeral_wrapped_key_size,
> +			  ephemeral_wrapped_keybuf,
> +			  ephemeral_wrapped_key_phys);
> +
> +bail_keybuf:
> +	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
> +	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
> +			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
> +
> +	if (!ret)
> +		return ephemeral_wrapped_key_size;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_prepare_ice_key);

EXPORT_SYMBOL_GPL everywhere please. I understand that other places in 
this file uses EXPORT_SYMBOL but new additions can be _GPL. I will see 
if someone from my team can covert other symbols to _GPL as well in this 
file.

---Trilok Soni
