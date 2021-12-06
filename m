Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2441946AE05
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359495AbhLFXCu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:50 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:25287 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376929AbhLFXCo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831555; x=1670367555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Ue4j4uhm1swKWHsP5swU+lpTqR0o0aLaH/vHm0ED9Xc=;
  b=ad6rULnG6q02l8dIRnJ7OwVqPpCyFrwDlqOQvwGawN6eW1em7u2j1Enf
   1RT8POt1x87ra9/twRa96J1mFqHzsXqsAF7/CyTvrTw6Ui7/ZKpW1n9xJ
   U1gpItjSvEdYbclYsqutrKsxEvOCu/bv7atHNO50w18W09sLzn7yfFiF9
   o=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 06 Dec 2021 14:59:14 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:14 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:13 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:13 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 10/10] arm64: dts: qcom: sm8350: add ice and hwkm mappings
Date:   Mon, 6 Dec 2021 14:57:25 -0800
Message-ID: <20211206225725.77512-11-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add register mappings for ICE (Inline Crypto Engine) and
HWKM (Hardware Key Manager) slave, which are both part
of the UFS controller for sm8350.

These are required for inline storage encryption using
hardware wrapped key.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index e91cd8a5e535..8e15524731b3 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1019,7 +1019,10 @@
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sm8350-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
-			reg = <0 0x01d84000 0 0x3000>;
+			reg = <0 0x01d84000 0 0x3000>,
+			      <0 0x01d88000 0 0x8000>,
+			      <0 0x01d90000 0 0x9000>;
+			reg-names = "ufs_mem", "ice", "ice_hwkm";
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
-- 
2.17.1

