Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FE818370E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCLRNy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 13:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCLRNx (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 13:13:53 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9097D2071C;
        Thu, 12 Mar 2020 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584033233;
        bh=E4/rRRNMZhyvwK1fBhXf9QpgGMywRQnUXlraggEcBg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTLXIRUH8ioxQfSNhrZg2Xkytswy/fxOXZFH5SQREb29kD47fBCJwo3K+u/bnaJr5
         if7Ay9lqzH1Xv7JGt1Ob4cbqZSb5atrskWcL3yN2y0d7dm/+CNjT2Ed/qhGvZaMeyG
         9dH3oUJ31w8uIX3/6loYkOJP9OskVgLJ2L9BveaI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH v3 2/4] arm64: dts: sdm845: add Inline Crypto Engine registers and clock
Date:   Thu, 12 Mar 2020 10:12:57 -0700
Message-Id: <20200312171259.151442-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200312171259.151442-1-ebiggers@kernel.org>
References: <20200312171259.151442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add the vendor-specific registers and clock for Qualcomm ICE (Inline
Crypto Engine) to the device tree node for the UFS host controller on
sdm845, so that the ufs-qcom driver will be able to use inline crypto.

Use a separate register range rather than extending the main UFS range
because there's a gap between the two, and the ICE registers are
vendor-specific.  (Actually, the hardware claims that the ICE range also
includes the array of standard crypto configuration registers; however,
on this SoC the Linux kernel isn't permitted to access them directly.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index d42302b8889b6..dd6b4e596fcfe 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1367,7 +1367,9 @@ system-cache-controller@1100000 {
 		ufs_mem_hc: ufshc@1d84000 {
 			compatible = "qcom,sdm845-ufshc", "qcom,ufshc",
 				     "jedec,ufs-2.0";
-			reg = <0 0x01d84000 0 0x2500>;
+			reg = <0 0x01d84000 0 0x2500>,
+			      <0 0 0 0>,
+			      <0 0x01d90000 0 0x8000>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
@@ -1387,7 +1389,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				"ref_clk",
 				"tx_lane0_sync_clk",
 				"rx_lane0_sync_clk",
-				"rx_lane1_sync_clk";
+				"rx_lane1_sync_clk",
+				"ice_core_clk";
 			clocks =
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -1396,7 +1399,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
-				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
+				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 			freq-table-hz =
 				<50000000 200000000>,
 				<0 0>,
@@ -1405,7 +1409,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 0>;
+				<0 0>,
+				<0 300000000>;
 
 			status = "disabled";
 		};
-- 
2.25.1

