Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0283136741
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2020 07:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgAJGS1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jan 2020 01:18:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:52766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731435AbgAJGS0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jan 2020 01:18:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 932C22080D;
        Fri, 10 Jan 2020 06:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578637106;
        bh=PSpS8uYTU84sHXAsvl8HtD5TiRFl4Kwd6+AyfcXUQTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBdqEQ4H3Yzhbq882wdCgkTvQxJOGsJ26LOVmSsU7TtQLDmUlqwTtbnYgyii6UgxC
         lpagS6yzkdb1juq5s8NpDP1Z+el4LjQv5acBC9QgE9UaHvwsHKpNIV6+IcIXhNBySH
         +zxe5kseoC/5kwox8DExGCBS7/rQGTh1gf2ywDzk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 2/5] arm64: dts: sdm845: add Inline Crypto Engine registers and clock
Date:   Thu,  9 Jan 2020 22:16:31 -0800
Message-Id: <20200110061634.46742-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110061634.46742-1-ebiggers@kernel.org>
References: <20200110061634.46742-1-ebiggers@kernel.org>
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
index ddb1f23c936fe..0fecc0791959e 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1367,7 +1367,9 @@ cache-controller@1100000 {
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
@@ -1385,7 +1387,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				"ref_clk",
 				"tx_lane0_sync_clk",
 				"rx_lane0_sync_clk",
-				"rx_lane1_sync_clk";
+				"rx_lane1_sync_clk",
+				"ice_core_clk";
 			clocks =
 				<&gcc GCC_UFS_PHY_AXI_CLK>,
 				<&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -1394,7 +1397,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<&rpmhcc RPMH_CXO_CLK>,
 				<&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				<&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
-				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
+				<&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>,
+				<&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
 			freq-table-hz =
 				<50000000 200000000>,
 				<0 0>,
@@ -1403,7 +1407,8 @@ ufs_mem_hc: ufshc@1d84000 {
 				<0 0>,
 				<0 0>,
 				<0 0>,
-				<0 0>;
+				<0 0>,
+				<0 300000000>;
 
 			status = "disabled";
 		};
-- 
2.24.1

