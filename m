Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B90A46ADDE
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376699AbhLFXC1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:27 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:37432 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376698AbhLFXC0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831537; x=1670367537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WGylPRUG0UYIpdxPi0FmgRwNxnArJ+vsqepiE4sU9QM=;
  b=aNeTaqqhsF4lInvqRQRcYuhe7m3IydKU2amQpwDBynwtep3GxH5V+e2B
   iVD4kgzgCno8jPhXIiP6G7R8AbgwsNUACDbGpXHflk4Tv3maYybXsRDDi
   JdDye8PftkHj/4XE42G7ZVkV22fPvfLA/ptBztB4Rni6VtEUy6RSRldRg
   o=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Dec 2021 14:58:57 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:58:57 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:58:56 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:58:56 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 02/10] scsi: ufs: qcom: move ICE functionality to common library
Date:   Mon, 6 Dec 2021 14:57:17 -0800
Message-ID: <20211206225725.77512-3-quic_gaurkash@quicinc.com>
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

Remove the ICE support in UFS and use the shared library
for crypto functionality.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/Kconfig        |   1 +
 drivers/scsi/ufs/ufs-qcom-ice.c | 169 +++-----------------------------
 drivers/scsi/ufs/ufs-qcom.h     |   3 +-
 3 files changed, 15 insertions(+), 158 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 432df76e6318..622a4c3fbf70 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -101,6 +101,7 @@ config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
 	select QCOM_SCM if SCSI_UFS_CRYPTO
+	select QTI_ICE_COMMON if SCSI_UFS_CRYPTO
 	select RESET_CONTROLLER
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index bbb0ad7590ec..3826643bf537 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -8,90 +8,11 @@
 
 #include <linux/platform_device.h>
 #include <linux/qcom_scm.h>
+#include <linux/qti-ice-common.h>
 
 #include "ufshcd-crypto.h"
 #include "ufs-qcom.h"
 
-#define AES_256_XTS_KEY_SIZE			64
-
-/* QCOM ICE registers */
-
-#define QCOM_ICE_REG_CONTROL			0x0000
-#define QCOM_ICE_REG_RESET			0x0004
-#define QCOM_ICE_REG_VERSION			0x0008
-#define QCOM_ICE_REG_FUSE_SETTING		0x0010
-#define QCOM_ICE_REG_PARAMETERS_1		0x0014
-#define QCOM_ICE_REG_PARAMETERS_2		0x0018
-#define QCOM_ICE_REG_PARAMETERS_3		0x001C
-#define QCOM_ICE_REG_PARAMETERS_4		0x0020
-#define QCOM_ICE_REG_PARAMETERS_5		0x0024
-
-/* QCOM ICE v3.X only */
-#define QCOM_ICE_GENERAL_ERR_STTS		0x0040
-#define QCOM_ICE_INVALID_CCFG_ERR_STTS		0x0030
-#define QCOM_ICE_GENERAL_ERR_MASK		0x0044
-
-/* QCOM ICE v2.X only */
-#define QCOM_ICE_REG_NON_SEC_IRQ_STTS		0x0040
-#define QCOM_ICE_REG_NON_SEC_IRQ_MASK		0x0044
-
-#define QCOM_ICE_REG_NON_SEC_IRQ_CLR		0x0048
-#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME1	0x0050
-#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME2	0x0054
-#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME1	0x0058
-#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME2	0x005C
-#define QCOM_ICE_REG_STREAM1_BIST_ERROR_VEC	0x0060
-#define QCOM_ICE_REG_STREAM2_BIST_ERROR_VEC	0x0064
-#define QCOM_ICE_REG_STREAM1_BIST_FINISH_VEC	0x0068
-#define QCOM_ICE_REG_STREAM2_BIST_FINISH_VEC	0x006C
-#define QCOM_ICE_REG_BIST_STATUS		0x0070
-#define QCOM_ICE_REG_BYPASS_STATUS		0x0074
-#define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
-#define QCOM_ICE_REG_ENDIAN_SWAP		0x1004
-#define QCOM_ICE_REG_TEST_BUS_CONTROL		0x1010
-#define QCOM_ICE_REG_TEST_BUS_REG		0x1014
-
-/* BIST ("built-in self-test"?) status flags */
-#define QCOM_ICE_BIST_STATUS_MASK		0xF0000000
-
-#define QCOM_ICE_FUSE_SETTING_MASK		0x1
-#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
-#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
-
-#define qcom_ice_writel(host, val, reg)	\
-	writel((val), (host)->ice_mmio + (reg))
-#define qcom_ice_readl(host, reg)	\
-	readl((host)->ice_mmio + (reg))
-
-static bool qcom_ice_supported(struct ufs_qcom_host *host)
-{
-	struct device *dev = host->hba->dev;
-	u32 regval = qcom_ice_readl(host, QCOM_ICE_REG_VERSION);
-	int major = regval >> 24;
-	int minor = (regval >> 16) & 0xFF;
-	int step = regval & 0xFFFF;
-
-	/* For now this driver only supports ICE version 3. */
-	if (major != 3) {
-		dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
-			 major, minor, step);
-		return false;
-	}
-
-	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
-		 major, minor, step);
-
-	/* If fuses are blown, ICE might not work in the standard way. */
-	regval = qcom_ice_readl(host, QCOM_ICE_REG_FUSE_SETTING);
-	if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
-		      QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
-		      QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
-		dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
-		return false;
-	}
-	return true;
-}
-
 int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
 	struct ufs_hba *hba = host->hba;
@@ -115,14 +36,14 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 		goto disable;
 	}
 
-	host->ice_mmio = devm_ioremap_resource(dev, res);
-	if (IS_ERR(host->ice_mmio)) {
-		err = PTR_ERR(host->ice_mmio);
+	host->ice_data.ice_mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(host->ice_data.ice_mmio)) {
+		err = PTR_ERR(host->ice_data.ice_mmio);
 		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
 		return err;
 	}
 
-	if (!qcom_ice_supported(host))
+	if (qti_ice_init(&host->ice_data))
 		goto disable;
 
 	return 0;
@@ -133,71 +54,21 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	return 0;
 }
 
-static void qcom_ice_low_power_mode_enable(struct ufs_qcom_host *host)
-{
-	u32 regval;
-
-	regval = qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
-	/*
-	 * Enable low power mode sequence
-	 * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
-	 */
-	regval |= 0x7000;
-	qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
-}
-
-static void qcom_ice_optimization_enable(struct ufs_qcom_host *host)
-{
-	u32 regval;
-
-	/* ICE Optimizations Enable Sequence */
-	regval = qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
-	regval |= 0xD807100;
-	/* ICE HPG requires delay before writing */
-	udelay(5);
-	qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
-	udelay(5);
-}
 
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
 		return 0;
-	qcom_ice_low_power_mode_enable(host);
-	qcom_ice_optimization_enable(host);
-	return ufs_qcom_ice_resume(host);
-}
 
-/* Poll until all BIST bits are reset */
-static int qcom_ice_wait_bist_status(struct ufs_qcom_host *host)
-{
-	int count;
-	u32 reg;
-
-	for (count = 0; count < 100; count++) {
-		reg = qcom_ice_readl(host, QCOM_ICE_REG_BIST_STATUS);
-		if (!(reg & QCOM_ICE_BIST_STATUS_MASK))
-			break;
-		udelay(50);
-	}
-	if (reg)
-		return -ETIMEDOUT;
-	return 0;
+	return qti_ice_enable(&host->ice_data);
 }
 
 int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
 {
-	int err;
-
 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
 		return 0;
 
-	err = qcom_ice_wait_bist_status(host);
-	if (err) {
-		dev_err(host->hba->dev, "BIST status error (%d)\n", err);
-		return err;
-	}
-	return 0;
+	return qti_ice_resume(&host->ice_data);
 }
 
 /*
@@ -208,15 +79,10 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 			     const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	union ufs_crypto_cap_entry cap;
-	union {
-		u8 bytes[AES_256_XTS_KEY_SIZE];
-		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
-	} key;
-	int i;
-	int err;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
-		return qcom_scm_ice_invalidate_key(slot);
+		return qti_ice_keyslot_evict(slot);
 
 	/* Only AES-256-XTS has been tested so far. */
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
@@ -228,18 +94,7 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	memcpy(key.bytes, cfg->crypto_key, AES_256_XTS_KEY_SIZE);
-
-	/*
-	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
-	 * do the same, in order for the final key be correct.
-	 */
-	for (i = 0; i < ARRAY_SIZE(key.words); i++)
-		__cpu_to_be32s(&key.words[i]);
-
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
-				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
-				   cfg->data_unit_size);
-	memzero_explicit(&key, sizeof(key));
-	return err;
+	return qti_ice_keyslot_program(&host->ice_data, cfg->crypto_key,
+				       UFS_CRYPTO_KEY_SIZE_256, slot,
+				       cfg->data_unit_size, cfg->crypto_cap_idx);
 }
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 8208e3a3ef59..8efacc0d7888 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -7,6 +7,7 @@
 
 #include <linux/reset-controller.h>
 #include <linux/reset.h>
+#include <linux/qti-ice-common.h>
 
 #define MAX_UFS_QCOM_HOSTS	1
 #define MAX_U32                 (~(u32)0)
@@ -206,7 +207,7 @@ struct ufs_qcom_host {
 	bool is_dev_ref_clk_enabled;
 	struct ufs_hw_version hw_ver;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
-	void __iomem *ice_mmio;
+	struct ice_mmio_data ice_data;
 #endif
 
 	u32 dev_ref_clk_en_mask;
-- 
2.17.1

