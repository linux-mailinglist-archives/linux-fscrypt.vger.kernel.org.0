Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A012FE5C2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jan 2021 10:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbhAUJFi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 04:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbhAUJEh (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 04:04:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6583239A1;
        Thu, 21 Jan 2021 09:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611219835;
        bh=l9qA1xr6rFaBfchx04jLeHDtxn2wMDoreitB3JMFNSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sd18tMWNe3B95Y+hk7X8Kj+K1O7jBxhMY1+qrrV2n0Mit3sWYdodJbRLZmqc8+lha
         K/G/pszX6cOnb6Lr6pX9v9hf1ifqpFXNf3G2hziHGOtH5WAJ5vKDPl6Ic1q3HUeVo8
         mUR7nI8LGRO039FxBR9dTmeqFmDdCWtPQP0XGBnGAenLx5nOTGaiCcXYVs7qlyYzWc
         offg1JvnttwqZkni6kd9SbbpVDt4W28QpGrtyv2T8D5ByNjvwKq8yY3AnGDN7akZAT
         d7dru3ezKeiYMYP00RgopxZ+5aes34mBBv8lpE1V26Jkt1LFOSJ9LfS62Mi5WRe3Tc
         mlItETQZwjNMQ==
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
Subject: [PATCH v5 2/9] mmc: cqhci: rename cqhci.c to cqhci-core.c
Date:   Thu, 21 Jan 2021 01:01:33 -0800
Message-Id: <20210121090140.326380-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210121090140.326380-1-ebiggers@kernel.org>
References: <20210121090140.326380-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Rename cqhci.c to cqhci-core.c so that another source file can be added
to the cqhci module without having to rename the module.

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/Makefile                  | 1 +
 drivers/mmc/host/{cqhci.c => cqhci-core.c} | 0
 2 files changed, 1 insertion(+)
 rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (100%)

diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 451c25fc2c692..20c2f9463d0dc 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_MMC_SDHCI_BRCMSTB)		+= sdhci-brcmstb.o
 obj-$(CONFIG_MMC_SDHCI_OMAP)		+= sdhci-omap.o
 obj-$(CONFIG_MMC_SDHCI_SPRD)		+= sdhci-sprd.o
 obj-$(CONFIG_MMC_CQHCI)			+= cqhci.o
+cqhci-y					+= cqhci-core.o
 obj-$(CONFIG_MMC_HSQ)			+= mmc_hsq.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
diff --git a/drivers/mmc/host/cqhci.c b/drivers/mmc/host/cqhci-core.c
similarity index 100%
rename from drivers/mmc/host/cqhci.c
rename to drivers/mmc/host/cqhci-core.c
-- 
2.30.0

