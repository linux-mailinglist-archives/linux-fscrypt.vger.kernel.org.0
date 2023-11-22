Return-Path: <linux-fscrypt+bounces-20-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8479F7F3D94
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 06:41:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F02F1C2102E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 05:41:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68ADB1A58E;
	Wed, 22 Nov 2023 05:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="AmY9ox3E"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FB712A;
	Tue, 21 Nov 2023 21:40:17 -0800 (PST)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM4gYFQ005861;
	Wed, 22 Nov 2023 05:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=AAJoxpdaUffiCAunX+fZ0lrVAqo9MTSADa7gjopRCjw=;
 b=AmY9ox3EFFYKALwigyJ9jjSG6r2qfu8n7CeT60oQr9SHs3VXmS6AGSjk/6fFNw7GIA8L
 sY/PAr7GMx5aHeT0/qo6jVzA8bu9onMUvGojgoem9g37VBbC5EjcCpvnTXuwqST2l9/e
 2KYDdYIwx8MN9NOXCo+3ud+loIPYRp6sqarTOekZZqceSC8SYXOwX0+juMmQrq/gVypK
 OPzFn3h0sGFPekVbwbatHl7YrkvPJ0ZFX3FJDt4MSOmh1EjqtEdbIkmCilRRmhkYeOQs
 FPYKMZfSBEFnPhBPiz8uVxIApgz4pTfU2+s+0/gBa4YyMcIp9LUdVaxwMvg1sJsRWcST Rw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uh0b49cv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:15 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AM5eEKw025905
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:14 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 21 Nov 2023 21:40:03 -0800
From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
To: <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>, <neil.armstrong@linaro.org>,
        <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>,
        Gaurav Kashyap
	<quic_gaurkash@quicinc.com>
Subject: [PATCH v3 11/12] arm64: dts: qcom: sm8650: add hwkm support to ufs ice
Date: Tue, 21 Nov 2023 21:38:16 -0800
Message-ID: <20231122053817.3401748-12-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: kC3wuowlLOCVCVPKJB7-_2UY0tajXtOg
X-Proofpoint-GUID: kC3wuowlLOCVCVPKJB7-_2UY0tajXtOg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_03,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=646 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220040

The Inline Crypto Engine (ICE) for UFS supports the
Hardware Key Manager (hwkm) to securely manage storage
keys. Enable using this hardware on sm8650.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index bbebe15437aa..b61066210e09 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -763,7 +763,8 @@ rng: rng@10c3000 {
 		ice: crypto@1d88000 {
 			compatible = "qcom,sm8650-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-			reg = <0 0x01d88000 0 0x8000>;
+			reg = <0 0x01d88000 0 0x10000>;
+			qcom,ice-use-hwkm;
 
 			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 		};
-- 
2.25.1


