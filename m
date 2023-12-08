Return-Path: <linux-fscrypt+bounces-70-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9556C809E27
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 09:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2EA21C20C7D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 08:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D0AC12B8E;
	Fri,  8 Dec 2023 08:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Dmrvpn6X"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9632E171C;
	Fri,  8 Dec 2023 00:33:18 -0800 (PST)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B88CCdm017745;
	Fri, 8 Dec 2023 08:33:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=s9YJ0/5J+OYeH8kQUcQ78n8ox5YkNEpfvV4LxpEjAWM=;
 b=Dmrvpn6XIOApSXNoDwjHP3beKb36wOXSv8w4gl4o2v7yLNElWfh64fo9SBCiutpmNt5Q
 rHxw0dit6ON18gpMaLrz1yj4O9L78gYjj0Xoq9J7jJMFUE6Da0m0zVaD6iLOoUcUimDX
 ALug8MUzBZt29U3mC8uG3o1z9yZJyE/9YRKtppd9iLXmulPYdP7zqZt71TyppQ+dBLOZ
 LvdXuOO1J8NBSNmwOejrLrnSAlDaGRuBxFVLuhuTx2zQLfeFUZH9m19SXAC36jmGyYM3
 tak9yIjnhA1XL8gX4NtS2ZVYwUAVZaAKSlK0nKkPUlXleTUYJKkNIgnFYvmbxzjgwZfX Lw== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3utynu4c6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 08:33:15 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3B88XEH7002134
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Dec 2023 08:33:14 GMT
Received: from [10.216.14.21] (10.80.80.8) by nalasex01b.na.qualcomm.com
 (10.47.209.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.40; Fri, 8 Dec
 2023 00:29:23 -0800
Message-ID: <3973b4f2-2173-427a-8ad5-8b954e3b43cd@quicinc.com>
Date: Fri, 8 Dec 2023 13:59:19 +0530
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/12] ufs: host: support for generate, import and
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
 <20231122053817.3401748-11-quic_gaurkash@quicinc.com>
From: Om Prakash Singh <quic_omprsing@quicinc.com>
In-Reply-To: <20231122053817.3401748-11-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01b.na.qualcomm.com (10.47.209.197)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: ldAH3tmugLUrumfkWT8_TTgqC7Np9Rd5
X-Proofpoint-ORIG-GUID: ldAH3tmugLUrumfkWT8_TTgqC7Np9Rd5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_04,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=628
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 phishscore=0 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312080069



On 11/22/2023 11:08 AM, Gaurav Kashyap wrote:
> Implements the vops for generate, prepare and import key apis in ufs 
> qcom and call the respective ICE module apis for them. Signed-off-by: 
> Gaurav Kashyap <quic_gaurkash@quicinc.com> ---
Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>

