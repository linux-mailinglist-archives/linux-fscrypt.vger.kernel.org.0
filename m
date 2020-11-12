Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB882B0E4A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Nov 2020 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKLTlU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Nov 2020 14:41:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbgKLTlT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Nov 2020 14:41:19 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDD1C2224D;
        Thu, 12 Nov 2020 19:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605210078;
        bh=XuB23iO36k+GP1DHJGnD9nU9YqX6jZ1kEKmKKvY0hvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVIPKiFLCZOTwjlgTBkK0In1iil2wX43RblcbO2PKwalNWlzYOqmJdMs3hwiV6GsM
         btd2fwWLtSkjAeBCFGZCva14hDZHkgvjI7V8q5wVqI86X9i4f/MpV3M2IF+tm7VNG6
         rSSu9MBAR+fcEQ0sgftPmpMyIJZBnrwBzBk88C3I=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH 6/8] dt-bindings: mmc: sdhci-msm: add ICE registers and clock
Date:   Thu, 12 Nov 2020 11:40:09 -0800
Message-Id: <20201112194011.103774-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201112194011.103774-1-ebiggers@kernel.org>
References: <20201112194011.103774-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document the bindings for the registers and clock for the MMC instance
of the Inline Crypto Engine (ICE) on Snapdragon SoCs.  These bindings
are needed in order for sdhci-msm to support inline encryption.

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
2.29.2

