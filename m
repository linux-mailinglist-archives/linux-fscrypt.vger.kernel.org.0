Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835A73047DD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jan 2021 20:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbhAZFzQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jan 2021 00:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbhAYSmC (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jan 2021 13:42:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE2F20758;
        Mon, 25 Jan 2021 18:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611600033;
        bh=cX3hhlW1d9/YsB6hj6Qe4lavdDpm38z9XYx4ck60cDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPFhw0lNoxlrY49GsAZvAKUOpZK4XPzgwFXYyf9Rd+k8SQJZ5bb0vUMvSOXDc7mSz
         hiCFTMXK2ywDnUr5Kxj6KYJPC88m6eLkDSDDx0MXHeblF5mz51tPmZGVwQx6PpvwdV
         Olkqew5uV8eWaEhzUeOfXtJ+JaSUgnemaEQmVGL1dFHV19mBpx7xVJIywhWUFu2DB4
         BJKL438zUQmalSA7Mr1L0MMtCt8pOvTkxySAwDZ89o6x3iEs5/AoPLuVQMKRzd0Ndk
         rGJbqUqfVAnPCV2DvnFxuM1YHZgZfcguzNzJE+TYHhaCYg+qdV4teXI8WuqdoIcQPP
         4QQDJ3u21P6KA==
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
        Konrad Dybcio <konradybcio@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v6 7/9] dt-bindings: mmc: sdhci-msm: add ICE registers and clock
Date:   Mon, 25 Jan 2021 10:38:08 -0800
Message-Id: <20210125183810.198008-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183810.198008-1-ebiggers@kernel.org>
References: <20210125183810.198008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document the bindings for the registers and clock for the MMC instance
of the Inline Crypto Engine (ICE) on Snapdragon SoCs.  These bindings
are needed in order for sdhci-msm to support inline encryption.

Reviewed-by: Satya Tangirala <satyat@google.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/devicetree/bindings/mmc/sdhci-msm.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
index 9fa8a24fbc97d..4c7fa6a4ed15c 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
@@ -31,10 +31,12 @@ Required properties:
 	- SD Core register map (required for controllers earlier than msm-v5)
 	- CQE register map (Optional, CQE support is present on SDHC instance meant
 	                    for eMMC and version v4.2 and above)
+	- Inline Crypto Engine register map (optional)
 - reg-names: When CQE register map is supplied, below reg-names are required
 	- "hc" for Host controller register map
 	- "core" for SD core register map
 	- "cqhci" for CQE register map
+	- "ice" for Inline Crypto Engine register map (optional)
 - interrupts: Should contain an interrupt-specifiers for the interrupts:
 	- Host controller interrupt (required)
 - pinctrl-names: Should contain only one value - "default".
@@ -47,6 +49,7 @@ Required properties:
 	"xo"	- TCXO clock (optional)
 	"cal"	- reference clock for RCLK delay calibration (optional)
 	"sleep"	- sleep clock for RCLK delay calibration (optional)
+	"ice" - clock for Inline Crypto Engine (optional)
 
 - qcom,ddr-config: Certain chipsets and platforms require particular settings
 	for the DDR_CONFIG register. Use this field to specify the register
-- 
2.30.0

