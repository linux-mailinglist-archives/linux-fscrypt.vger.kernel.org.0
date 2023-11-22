Return-Path: <linux-fscrypt+bounces-30-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB18D7F4E9C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 18:44:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 632CCB20C52
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 17:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B12756B75;
	Wed, 22 Nov 2023 17:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="oez6Ptxm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC60D42;
	Wed, 22 Nov 2023 09:43:57 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AMHfJYh026759;
	Wed, 22 Nov 2023 17:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=ZaNRIg3lKd62YeBy/yihCk/EXDyr33s6vGch1Rp/wgU=;
 b=oez6PtxmupPpXCeqY/gdkqMTddKW4u/Dzc1c+u2sMtXIBqpYf0shkhI7KJZDjbd/dKeU
 JYIlITDtQ0dAPDTkbybzheHmKdkqO9UaqMeqxyi5ViimcePZWUUh3H6O2TK+/22qrCfw
 Fd5KSaORXEdffdgDIHElGYaAAIP09yYoGO5GrD3bEpEPdwVZzwCD5q3BgyDr4cgO4aq4
 XHdPrKhxvgnvCZIWsMIpUtlhZVEnoQavbluwVfQMZmFvUKkGkhs32N+ZJ6uKMx+50XNB
 XjOeK5WPIXUKtnbBxb2nMf9yg9u4yq+KPLiSzEhkgmFjWNQiIPq5lpw81WbGlsexy+wU 7Q== 
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uhgajrytt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 17:43:54 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AMHhrYU017931
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 17:43:53 GMT
Received: from [10.110.98.138] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Wed, 22 Nov
 2023 09:43:49 -0800
Message-ID: <edf9399c-f272-cf2b-15dd-385002fc4fcb@quicinc.com>
Date: Wed, 22 Nov 2023 09:43:37 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
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
From: Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <20231122053817.3401748-3-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: UzMkdLUar2xqfmpaebXBe5jOF_EyfTf3
X-Proofpoint-ORIG-GUID: UzMkdLUar2xqfmpaebXBe5jOF_EyfTf3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_12,2023-11-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=384
 priorityscore=1501 lowpriorityscore=0 spamscore=0 bulkscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220129

On 11/21/2023 9:38 PM, Gaurav Kashyap wrote:
> +
> +	dma_free_coherent(__scm->dev, wkey_size, wkey_buf, wkey_phys);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(qcom_scm_derive_sw_secret);

GPL please. 

-- 
---Trilok Soni


