Return-Path: <linux-fscrypt+bounces-69-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46786809E04
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 09:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA331C209C7
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 08:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC8B11185;
	Fri,  8 Dec 2023 08:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="R4ozkcX7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68811B5;
	Fri,  8 Dec 2023 00:19:21 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B86uL4j032586;
	Fri, 8 Dec 2023 08:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=C2hKHVuo5pBf5bnruKdO8cHrz+iaFEu6konihm1cVvI=;
 b=R4ozkcX7dRMO173or5/GV9MQ5BYUG7Qt5xZ4YXeylmLZDev2Ui4mlUZrniuAn6weCvY1
 K+ndE6S9DGr/u0fg8D9demj9/BHR7x1tMVE66YcU/91/tz/P4y3J3wNvpENHoQBNhu61
 6Tmxl85qPa9vM4hrm9SMVIxfvkDHbojaKZDnf5vGONjhYBsIcJc4ZOHswkDmDlzu2nXz
 TJashaluo3e2BRpo7J0GUbFv7NIVT8gwOcM84HQiqD59KGa6IoSTigZeZVhTkUf0q8DJ
 avDxfsZLqZU/8WXw338hOyOodQUl3gHscCllgnBYyAGgRmWpSupFcST573R78xVh/6Lg Aw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uubdm2xue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 08:19:18 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B88JIAW012238
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 08:19:18 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 8 Dec
 2023 00:19:10 -0800
Message-ID: <e28ffc90-1c78-4ccb-8251-9a22243f7b20@quicinc.com>
Date: Fri, 8 Dec 2023 13:47:40 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/12] ufs: core: add support for generate, import and
 prepare keys
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-9-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-9-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: V8MRZrhASFdP1vKjgUZCPkMZPMEi-77R
X-Proofpoint-GUID: V8MRZrhASFdP1vKjgUZCPkMZPMEi-77R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 clxscore=1015 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080067



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> This patch contains two changes in UFS for wrapped keys.
> 1. Implements the blk_crypto_profile ops for generate, import
>     and prepare key apis.
> 2. Defines UFS vops for generate, import and prepare keys so
>     that vendors can hook into them.

re-write commit message as it is single change.
using numbering in commit message is indication of making multiple 
independent changes in single patch, which should be avoided.

> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>   drivers/ufs/core/ufshcd-crypto.c | 41 ++++++++++++++++++++++++++++++++
>   include/ufs/ufshcd.h             | 11 +++++++++
>   2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
> index 3edbca87c322..cf34f4a9cda8 100644
> --- a/drivers/ufs/core/ufshcd-crypto.c
> +++ b/drivers/ufs/core/ufshcd-crypto.c
> @@ -143,10 +143,51 @@ static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
>   	return -EOPNOTSUPP;
>   }
>   
> +static int ufshcd_crypto_generate_key(struct blk_crypto_profile *profile,
> +				      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->generate_key)
> +		return  hba->vops->generate_key(hba, lt_key);
Please fix double space.
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int ufshcd_crypto_prepare_key(struct blk_crypto_profile *profile,
> +				     const u8 *lt_key, size_t lt_key_size,
> +				     u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->prepare_key)
> +		return  hba->vops->prepare_key(hba, lt_key, lt_key_size, eph_key);
Please fix double space.
> +
> +	return -EOPNOTSUPP;
> +}
> +
> +static int ufshcd_crypto_import_key(struct blk_crypto_profile *profile,
> +				    const u8 *imp_key, size_t imp_key_size,
> +				    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
> +{
> +	struct ufs_hba *hba =
> +		container_of(profile, struct ufs_hba, crypto_profile);
> +
> +	if (hba->vops && hba->vops->import_key)
> +		return  hba->vops->import_key(hba, imp_key, imp_key_size, lt_key);
Please fix double space.
> +
> +	return -EOPNOTSUPP;
> +}
> +
>   static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
>   	.keyslot_program	= ufshcd_crypto_keyslot_program,
>   	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
>   	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
> +	.generate_key		= ufshcd_crypto_generate_key,
> +	.prepare_key		= ufshcd_crypto_prepare_key,
> +	.import_key		= ufshcd_crypto_import_key,
>   };
>   
>   static enum blk_crypto_mode_num
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 86677788b5bd..49657a5d1e34 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -321,6 +321,9 @@ struct ufs_pwr_mode_info {
>    * @config_scaling_param: called to configure clock scaling parameters
>    * @program_key: program or evict an inline encryption key
>    * @derive_sw_secret: derive sw secret from a wrapped key
> + * @generate_key: generate a storage key and return longterm wrapped key
> + * @prepare_key: unwrap longterm key and return ephemeral wrapped key
> + * @import_key: import sw storage key and return longterm wrapped key
>    * @event_notify: called to notify important events
>    * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
>    * @mcq_config_resource: called to configure MCQ platform resources
> @@ -368,6 +371,14 @@ struct ufs_hba_variant_ops {
>   	int	(*derive_sw_secret)(struct ufs_hba *hba, const u8 wkey[],
>   				    unsigned int wkey_size,
>   				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
> +	int	(*generate_key)(struct ufs_hba *hba,
> +				u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +	int	(*prepare_key)(struct ufs_hba *hba,
> +			       const u8 *lt_key, size_t lt_key_size,
> +			       u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
> +	int	(*import_key)(struct ufs_hba *hba,
> +			      const u8 *imp_key, size_t imp_key_size,
> +			      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
>   	void	(*event_notify)(struct ufs_hba *hba,
>   				enum ufs_event_type evt, void *data);
>   	void	(*reinit_notify)(struct ufs_hba *);

