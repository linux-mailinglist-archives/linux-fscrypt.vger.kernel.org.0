Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC32FE5E6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 10:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbhAUJJX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 04:09:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728464AbhAUJEy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 04:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58C43239EB;
        Thu, 21 Jan 2021 09:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611219839;
        bh=G16sIENRX9EMyT17x8UvaimcQGeqHoMJpMYb9LmaK3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgPMthSBk0qpFP6x4IFsXfwMgIEoDzujoULxDVYpQ7/eiI2ZpI3368rqPAZ1oMQKi
         GAoarxqazOLpraBkzXqlyMRrYsrDyN23M37AoVUFTTMcFlgrlZdVhw6Em6QW7pJxes
         8+SyYc5LIg8yyISGjFWevHjbZCtojUqxJTBvBISAaZnKljButUXsbr3YlY8ZNCGWfo
         tSzck/KEkk8IZjh4qm0ZtMfqnmJzFT34c+H/KrexJRT57c+WqMkpKlrJrUBKRlMlcb
         lxTOThktqU3lU7q0id7azE826IBIxmatZk7h0iB6DKyGQISKGq+SCyk1IIE4snnzat
         vtagF+DaaJdnQ==
From:   Eric Biggers <ebiggers@kernel.org>
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
Subject: [PATCH v5 8/9] arm64: dts: qcom: sdm630: add ICE registers and clocks
Date:   Thu, 21 Jan 2021 01:01:39 -0800
Message-Id: <20210121090140.326380-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210121090140.326380-1-ebiggers@kernel.org>
References: <20210121090140.326380-1-ebiggers@kernel.org>
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
index 37d5cc32f6b62..afb3d20c31fa0 100644
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
2.30.0

