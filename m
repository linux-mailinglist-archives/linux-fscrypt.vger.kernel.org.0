Return-Path: <linux-fscrypt+bounces-73-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA92809E7E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 09:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D4121C20B42
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 08:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB92711193;
	Fri,  8 Dec 2023 08:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="TqUnNlwp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075BA171C;
	Fri,  8 Dec 2023 00:47:54 -0800 (PST)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B88haBG031366;
	Fri, 8 Dec 2023 08:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=sJFSWpBix3ucYjDy7sX1k4wYmjCFS/pCIXxw8fhDtOs=;
 b=TqUnNlwpjnKpeH/rMRGMV0Nuw2EsvaCC4S322rEDPn+EwqdU1zjXLzJhSzEFLEoq44He
 DdSer7SE2FrF4+bC4AZPoNhfQKya0XLvGsADmO4oG9Iw+5KAOoPAjsRWHsTIxosCXJiD
 3GLnGqKVPzVBsoCAIhmMv8JB64RYqhb+7Gnz8l+6v/vguRPgCc85YdD60kDSEvUwbTpc
 J9Jd/oTL2BdySy6Cjqm4HJr+yDgYEcfJ0B3NPHluxn9FmAXPpP1Q2D7BzWAKJ5+q4lxp
 IXlZ5bMDw1Nw31ZVVJRa8UuPd9zRcQ8GpLJqKeI/QFBbByQIr4Dosmf8I0jfoIIqvGtw QA== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uuphg9154-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 08:47:47 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B88lkGD008964
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 08:47:46 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 8 Dec
 2023 00:45:59 -0800
Message-ID: <c8885f86-1bb5-4322-9a0a-1a6227e34fa3@quicinc.com>
Date: Fri, 8 Dec 2023 14:15:55 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/12] arm64: dts: qcom: sm8650: add hwkm support to
 ufs ice
Content-Language: en-US
To: Bjorn Andersson <andersson@kernel.org>,
        Gaurav Kashyap
	<quic_gaurkash@quicinc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>, <neil.armstrong@linaro.org>,
        <srinivas.kandagatla@linaro.org>, <linux-mmc@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <omprsing@qti.qualcomm.com>, <quic_psodagud@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        <kernel@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-12-quic_gaurkash@quicinc.com>
 <blzia6asujby2xsfg2na6piwcgfkorodugebvflstjfexeyfvj@t5ifq3kxquhw>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <blzia6asujby2xsfg2na6piwcgfkorodugebvflstjfexeyfvj@t5ifq3kxquhw>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: YFtx0sXkLhCp189oQP_LKcLjktbtQuCB
X-Proofpoint-GUID: YFtx0sXkLhCp189oQP_LKcLjktbtQuCB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=920 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080071



On 12/8/2023 9:21 AM, Bjorn Andersson wrote:
> On Tue, Nov 21, 2023 at 09:38:16PM -0800, Gaurav Kashyap wrote:
>> The Inline Crypto Engine (ICE) for UFS supports the
>> Hardware Key Manager (hwkm) to securely manage storage
>> keys. Enable using this hardware on sm8650.
> 
> I'm unable to understand why the size of the reg changes based on this
> motivation.
> 
> Regards,
> Bjorn
>
Actual size of register space size is 0x18000 (as per IPCAT). But all 
registers space are not used.

HWKM register offset is start at 0x8000. Hence needed to expand reg map 
size.


>>
>> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
>> ---
>>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> index bbebe15437aa..b61066210e09 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> @@ -763,7 +763,8 @@ rng: rng@10c3000 {
>>   		ice: crypto@1d88000 {
>>   			compatible = "qcom,sm8650-inline-crypto-engine",
>>   				     "qcom,inline-crypto-engine";
>> -			reg = <0 0x01d88000 0 0x8000>;
>> +			reg = <0 0x01d88000 0 0x10000>;
>> +			qcom,ice-use-hwkm;
>>   
>>   			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
>>   		};
>> -- 
>> 2.25.1
>>
>>
> 

