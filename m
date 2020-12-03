Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738432CCC2C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 03:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387694AbgLCCJ2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 21:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387618AbgLCCJ0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 21:09:26 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH v2 8/9] arm64: dts: qcom: sdm630: add ICE registers and clocks
Date:   Wed,  2 Dec 2020 18:05:15 -0800
Message-Id: <20201203020516.225701-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203020516.225701-1-ebiggers@kernel.org>
References: <20201203020516.225701-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add the registers and clock for the Inline Crypto Engine (ICE) to the
device tree node for the sdhci-msm host controller on sdm630.  This
allows sdhci-msm to support inline encryption on sdm630.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index deb928d303c22..21aee33518b54 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -808,8 +808,9 @@ spmi_bus: spmi@800f000 {
 		sdhc_1: sdhci@c0c4000 {
 			compatible = "qcom,sdm630-sdhci", "qcom,sdhci-msm-v5";
 			reg = <0x0c0c4000 0x1000>,
-				<0x0c0c5000 0x1000>;
-			reg-names = "hc", "cqhci";
+				<0x0c0c5000 0x1000>,
+				<0x0c0c8000 0x8000>;
+			reg-names = "hc", "cqhci", "ice";
 
 			interrupts = <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
 					<GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>;
@@ -817,8 +818,9 @@ sdhc_1: sdhci@c0c4000 {
 
 			clocks = <&gcc GCC_SDCC1_APPS_CLK>,
 					<&gcc GCC_SDCC1_AHB_CLK>,
-					<&xo_board>;
-			clock-names = "core", "iface", "xo";
+					<&xo_board>,
+					<&gcc GCC_SDCC1_ICE_CORE_CLK>;
+			clock-names = "core", "iface", "xo", "ice";
 
 			pinctrl-names = "default", "sleep";
 			pinctrl-0 = <&sdc1_clk_on &sdc1_cmd_on &sdc1_data_on &sdc1_rclk_on>;
-- 
2.29.2

