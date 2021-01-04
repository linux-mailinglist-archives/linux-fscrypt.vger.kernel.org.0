Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D922E9D6E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  4 Jan 2021 19:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbhADStt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Jan 2021 13:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADSts (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Jan 2021 13:49:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5359722473;
        Mon,  4 Jan 2021 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609786111;
        bh=kmA/xxePTPbCO9z0nO1yxfDx5F/u4uwra8yUdU6e8Qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMOb/Mv/Zaxdef5iWPk1kRFMs5V5CCemjiOhhS2xBBqCilyXozBL7U2LnDDGOpxa3
         GXhh6FYJwjggQcrb87IEH/0ECXeCzMbnzv+aGEvxNa4tIEB9DLBkc1nddkfiLwlouv
         Mpt7rV0w2jkEYcQ2gxjXgUJvuWlbm+zjsUyOcQoHyozXO1EHmkLYAcCqJl2x4pj1zL
         MIqItMgKcuaBvcCzCSQ8VQ9wh8747CdWrriFDLwrkPLtwX1nIq78oBF5q2UzGWTmvx
         g2/IPXQpJxV7U7Y8WvcWLy/YteUWJacGvuPovCZu0JWviZ/w6bJn0rMqf83OGo269v
         QsH/qGLfwys8g==
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
Subject: [PATCH v4 7/9] dt-bindings: mmc: sdhci-msm: add ICE registers and clock
Date:   Mon,  4 Jan 2021 10:45:40 -0800
Message-Id: <20210104184542.4616-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104184542.4616-1-ebiggers@kernel.org>
References: <20210104184542.4616-1-ebiggers@kernel.org>
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
index 3b602fd6180bf..4f2e138439506 100644
--- a/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
+++ b/Documentation/devicetree/bindings/mmc/sdhci-msm.txt
@@ -30,10 +30,12 @@ Required properties:
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
@@ -46,6 +48,7 @@ Required properties:
 	"xo"	- TCXO clock (optional)
 	"cal"	- reference clock for RCLK delay calibration (optional)
 	"sleep"	- sleep clock for RCLK delay calibration (optional)
+	"ice" - clock for Inline Crypto Engine (optional)
 
 - qcom,ddr-config: Certain chipsets and platforms require particular settings
 	for the DDR_CONFIG register. Use this field to specify the register
-- 
2.30.0

