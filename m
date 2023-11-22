Return-Path: <linux-fscrypt+bounces-24-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0C37F3DA5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 06:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA932282AD0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 05:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829161CA88;
	Wed, 22 Nov 2023 05:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="V/96vLGq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B3B1A2;
	Tue, 21 Nov 2023 21:40:18 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM4gVVs024685;
	Wed, 22 Nov 2023 05:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=M3ih5k73hTUGLAHB8pFzvY3VIGT0+mRjjUOBX7AhHKg=;
 b=V/96vLGqwLjvaljeglMBfb6zOidPyjm4BsuRV+ixuUdIpRo4ulQxgzay0oW7vg7DDdQ0
 kWWtCabn6WQj9F/FZLii7zrvnT712E1LHE4v3zHjSWbymOSVscFUqsZCyLOm4ActOsNl
 vKJzykdu+wYXHPYy0cEQ1KPFhwMFlLZFS9Ag1DiJLAuRaajhA1HvJ+pk+dx9ehNn2UHY
 acK8w4Y892F7qiu6D6w0LdCP4AipqhtRlRx3QCjiFTFcimwoIjsHmE6kLoulFd590RZX
 Bs4sRPOwSxVOkBU3TeFlhukMde5KfMRoplx6e0EWR1qNY14TGU0lvJPNctb5dzHa7tXv 7g== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ugr85u3e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:15 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AM5eEKu025905
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:14 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 21 Nov 2023 21:40:04 -0800
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
Subject: [PATCH v3 12/12] dt-bindings: crypto: ice: document the hwkm property
Date: Tue, 21 Nov 2023 21:38:17 -0800
Message-ID: <20231122053817.3401748-13-quic_gaurkash@quicinc.com>
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
X-Proofpoint-GUID: AIKcHt8ulWoxBE92h_6_xVSkozyDMypH
X-Proofpoint-ORIG-GUID: AIKcHt8ulWoxBE92h_6_xVSkozyDMypH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_02,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220040

Add documentation for the ice-use-hwkm property in
qcom ice.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 .../bindings/crypto/qcom,inline-crypto-engine.yaml         | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index ca4f7d1cefaa..93e017dddc9d 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -24,6 +24,13 @@ properties:
   clocks:
     maxItems: 1
 
+  qcom,ice-use-hwkm:
+    type: boolean
+    description:
+      Use the supported Hardware Key Manager (HWKM) in Qualcomm
+      ICE to support wrapped keys. This dictates if wrapped keys
+      have to be used by ICE.
+
 required:
   - compatible
   - reg
-- 
2.25.1


