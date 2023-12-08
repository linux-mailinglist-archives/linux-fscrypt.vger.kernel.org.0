Return-Path: <linux-fscrypt+bounces-68-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 476DD809DC7
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 09:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6209B20A83
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 07:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5314110944;
	Fri,  8 Dec 2023 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="SyLG3rBj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E84435A5;
	Thu,  7 Dec 2023 23:59:27 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B87vo3g012930;
	Fri, 8 Dec 2023 07:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=iYObFqKSCtyk4kLsupha60eckv7V1mIxUPQFYzg53KU=;
 b=SyLG3rBjWyR0AougwnjknfiYBPLjKx5pUtLrY7rrUcLb7vEmZcDBYbnSdeKKedHOmuSo
 fzTsQ0DuAbyCORz53qFE1TzjiMCkzDPLFrn63E1+xiD+kOmebhaVE1w2OuyWep51gr1s
 UwOB78xXU+TIdACTWEJk/Eo2lATHLk/1oIR4mHL/1/TnomLP3lzKSZ82KIA579qwzyu+
 OHcmaEpGMyldsGj5L9A2Hwd5Yyo17QPl8TuMAYoG/vybbHYznMi0zxe3lDOH7S7tLcT7
 YzMakM30mntqSQOU1SCptE7aTWzBIFZUYXmVB6hDcMrR7T9J/qdr08DriV+s+2CFBMX3 cA== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uu8p0b9pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 07:59:24 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B87wx5a010599
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 07:58:59 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Thu, 7 Dec
 2023 23:55:04 -0800
Message-ID: <0f0649c6-4a2c-49b5-a4ac-356b7a67c582@quicinc.com>
Date: Fri, 8 Dec 2023 13:24:59 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/12] ufs: host: wrapped keys support in ufs qcom
Content-Language: en-US
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>, <linux-scsi@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ebiggers@google.com>,
        <neil.armstrong@linaro.org>, <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-7-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-7-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: nqQhXKxJ9XV8p1snuQlt0YNTBQXZSHIP
X-Proofpoint-ORIG-GUID: nqQhXKxJ9XV8p1snuQlt0YNTBQXZSHIP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxlogscore=617 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080065



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> 1. Implement derive software secret defined in ufs core. 2. Use the 
> wrapped keys quirk when hwkm is supported. The assumption here is that 
> if Qualcomm ICE supports HWKM, then all ICE keys will be treated as 
> hardware wrapped keys.
As per convention need to submit this in two separate patch

