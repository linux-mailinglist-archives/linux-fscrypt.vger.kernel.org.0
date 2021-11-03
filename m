Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE19A444B74
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 00:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhKCXWR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Nov 2021 19:22:17 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:29974 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229561AbhKCXWR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Nov 2021 19:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635981580; x=1667517580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+t2cANEa/1IoTC56pQvmn/ysdJ4N4sZXsTm8V9FS5Xs=;
  b=XfWVvA5ag6cpR0wkD22+dZ0RtADZPQICwNeaB88IrbQi86Po4quCW2qh
   Xel+OMAZ0rv7Du76bd1oazEi4LAicpnb+8+UNLFUchuu2MQKcG74Zhej9
   08auW+U0quzb32ocSH6BB5nKN/662PWcVkAkhaTa3SMKzTBy3jsWeFIAg
   E=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 03 Nov 2021 16:19:40 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 16:19:39 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Wed, 3 Nov 2021 16:19:39 -0700
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 3 Nov 2021
 16:19:39 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <asutoshd@codeaurora.org>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 1/4] ufs: move ICE functionality to a common library
Date:   Wed, 3 Nov 2021 16:18:37 -0700
Message-ID: <20211103231840.115521-2-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The Inline Crypto Engine functionality is not limited to
ufs and it can be used by other storage controllers like emmc
which have the HW capabilities. It would be better to move this
functionality to a common location.

Moreover, when wrapped key functionality is added, it would
reduce the effort required to add it for all storage
controllers.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufs-qcom-ice.c   | 172 ++++--------------------------
 drivers/soc/qcom/Kconfig          |   7 ++
 drivers/soc/qcom/Makefile         |   1 +
 drivers/soc/qcom/qti-ice-common.c | 135 +++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-regs.h   | 145 +++++++++++++++++++++++++
 include/linux/qti-ice-common.h    |  26 +++++
 6 files changed, 334 insertions(+), 152 deletions(-)
 create mode 100644 drivers/soc/qcom/qti-ice-common.c
 create mode 100644 drivers/soc/qcom/qti-ice-regs.h
 create mode 100644 include/linux/qti-ice-common.h

diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index bbb0ad7590ec..6608a9015eab 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -8,96 +8,18 @@
 
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
 	struct device *dev = hba->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct resource *res;
+	struct ice_mmio_data mmio;
 	int err;
 
 	if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
@@ -121,8 +43,9 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
 		return err;
 	}
+	mmio.ice_mmio = host->ice_mmio;
 
-	if (!qcom_ice_supported(host))
+	if (!qti_ice_init(&mmio))
 		goto disable;
 
 	return 0;
@@ -133,71 +56,31 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
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
+static void get_ice_mmio_data(struct ice_mmio_data *data,
+			      const struct ufs_qcom_host *host)
 {
-	u32 regval;
-
-	/* ICE Optimizations Enable Sequence */
-	regval = qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
-	regval |= 0xD807100;
-	/* ICE HPG requires delay before writing */
-	udelay(5);
-	qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
-	udelay(5);
+	data->ice_mmio = host->ice_mmio;
 }
 
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
+	struct ice_mmio_data mmio;
+
 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
 		return 0;
-	qcom_ice_low_power_mode_enable(host);
-	qcom_ice_optimization_enable(host);
-	return ufs_qcom_ice_resume(host);
-}
-
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
+	get_ice_mmio_data(&mmio, host);
+	return qti_ice_enable(&mmio);
 }
 
 int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
 {
-	int err;
+	struct ice_mmio_data mmio;
 
 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
 		return 0;
 
-	err = qcom_ice_wait_bist_status(host);
-	if (err) {
-		dev_err(host->hba->dev, "BIST status error (%d)\n", err);
-		return err;
-	}
-	return 0;
+	get_ice_mmio_data(&mmio, host);
+	return qti_ice_resume(&mmio);
 }
 
 /*
@@ -208,16 +91,13 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 			     const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	union ufs_crypto_cap_entry cap;
-	union {
-		u8 bytes[AES_256_XTS_KEY_SIZE];
-		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
-	} key;
-	int i;
-	int err;
+	struct ice_mmio_data mmio;
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
-		return qcom_scm_ice_invalidate_key(slot);
+		return qti_ice_keyslot_evict(slot);
 
+	get_ice_mmio_data(&mmio, host);
 	/* Only AES-256-XTS has been tested so far. */
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
@@ -228,18 +108,6 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
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
+	return qti_ice_keyslot_program(&mmio, cfg->crypto_key, AES_256_XTS_KEY_SIZE,
+				       slot, cfg->data_unit_size, cfg->crypto_cap_idx);
 }
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 79b568f82a1c..39f223ed8cdd 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -209,4 +209,11 @@ config QCOM_APR
 	  application processor and QDSP6. APR is
 	  used by audio driver to configure QDSP6
 	  ASM, ADM and AFE modules.
+
+config QTI_ICE_COMMON
+	tristate "QTI common ICE functionality"
+	depends on SCSI_UFS_CRYPTO && SCSI_UFS_QCOM
+	help
+	  Enable the common ICE library that can be used
+	  by UFS and EMMC drivers for ICE functionality.
 endmenu
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index ad675a6593d0..57840b19b7ee 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
 obj-$(CONFIG_QCOM_RPMHPD) += rpmhpd.o
 obj-$(CONFIG_QCOM_RPMPD) += rpmpd.o
 obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
+obj-$(CONFIG_QTI_ICE_COMMON) += qti-ice-common.o
diff --git a/drivers/soc/qcom/qti-ice-common.c b/drivers/soc/qcom/qti-ice-common.c
new file mode 100644
index 000000000000..b344a4cab5d4
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-common.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Common ICE library for storage encryption.
+ *
+ * Copyright (c) 2021, Linux Foundation. All rights reserved.
+ */
+
+#include <linux/qti-ice-common.h>
+#include <linux/module.h>
+#include <linux/qcom_scm.h>
+#include <linux/delay.h>
+#include "qti-ice-regs.h"
+
+#define QTI_ICE_MAX_BIST_CHECK_COUNT    100
+
+static bool qti_ice_supported(const struct ice_mmio_data *mmio)
+{
+	u32 regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_VERSION);
+	int major = regval >> 24;
+	int minor = (regval >> 16) & 0xFF;
+	int step = regval & 0xFFFF;
+
+	/* For now this driver only supports ICE version 3 and higher. */
+	if (major < 3) {
+		pr_warn("Unsupported ICE version: v%d.%d.%d\n",
+			 major, minor, step);
+		return false;
+	}
+
+	pr_info("Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
+		 major, minor, step);
+
+	/* If fuses are blown, ICE might not work in the standard way. */
+	regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_FUSE_SETTING);
+	if (regval & (QTI_ICE_FUSE_SETTING_MASK |
+		      QTI_ICE_FORCE_HW_KEY0_SETTING_MASK |
+		      QTI_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
+		pr_warn("Fuses are blown; ICE is unusable!\n");
+		return false;
+	}
+	return true;
+}
+
+int qti_ice_init(const struct ice_mmio_data *mmio)
+{
+	return qti_ice_supported(mmio);
+}
+EXPORT_SYMBOL(qti_ice_init);
+
+static void qti_ice_low_power_and_optimization_enable(
+                            const struct ice_mmio_data *mmio)
+{
+	u32 regval = qti_ice_readl(mmio, QTI_ICE_REGS_ADVANCED_CONTROL);
+
+	/* Enable low power mode sequence
+	 * [0]-0,[1]-0,[2]-0,[3]-7,[4]-0,[5]-0,[6]-0,[7]-0,
+	 * Enable CONFIG_CLK_GATING, STREAM2_CLK_GATING and STREAM1_CLK_GATING
+	 */
+	regval |= 0x7000;
+	/* Optimization enable sequence*/
+	regval |= 0xD807100;
+	qti_ice_writel(mmio, regval, QTI_ICE_REGS_ADVANCED_CONTROL);
+	/* Memory barrier - to ensure write completion before next transaction */
+	wmb();
+}
+
+static int qti_ice_wait_bist_status(const struct ice_mmio_data *mmio)
+{
+	int count;
+	u32 regval;
+
+	for (count = 0; count < QTI_ICE_MAX_BIST_CHECK_COUNT; count++) {
+		regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_BIST_STATUS);
+		if (!(regval & QTI_ICE_BIST_STATUS_MASK))
+			break;
+		udelay(50);
+	}
+
+	if (regval) {
+		pr_err("%s: wait bist status failed, reg %d\n", __func__, regval);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+int qti_ice_enable(const struct ice_mmio_data *mmio)
+{
+	qti_ice_low_power_and_optimization_enable(mmio);
+	return qti_ice_wait_bist_status(mmio);
+}
+EXPORT_SYMBOL(qti_ice_enable);
+
+int qti_ice_resume(const struct ice_mmio_data *mmio)
+{
+	return qti_ice_wait_bist_status(mmio);
+}
+EXPORT_SYMBOL(qti_ice_resume);
+
+int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
+                const u8* crypto_key, unsigned int crypto_key_size,
+                unsigned int slot, u8 data_unit_mask, int capid)
+{
+	int err = 0;
+	int i = 0;
+	union {
+		u8 bytes[AES_256_XTS_KEY_SIZE];
+		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
+	} key;
+
+	memcpy(key.bytes, crypto_key, crypto_key_size);
+	/*
+	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
+	 * do the same, in order for the final key be correct.
+	 */
+	for (i = 0; i < ARRAY_SIZE(key.words); i++)
+		__cpu_to_be32s(&key.words[i]);
+
+	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+				   capid, data_unit_mask);
+	if (err)
+		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err, slot);
+
+	memzero_explicit(&key, sizeof(key));
+	return err;
+}
+EXPORT_SYMBOL(qti_ice_keyslot_program);
+
+int qti_ice_keyslot_evict(unsigned int slot)
+{
+	return qcom_scm_ice_invalidate_key(slot);
+}
+EXPORT_SYMBOL(qti_ice_keyslot_evict);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/soc/qcom/qti-ice-regs.h b/drivers/soc/qcom/qti-ice-regs.h
new file mode 100644
index 000000000000..47c625c9d536
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-regs.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef _QTI_INLINE_CRYPTO_ENGINE_REGS_H_
+#define _QTI_INLINE_CRYPTO_ENGINE_REGS_H_
+
+#include <linux/io.h>
+
+/* QTI ICE Registers from SWI */
+#define QTI_ICE_REGS_CONTROL			        0x0000
+#define QTI_ICE_REGS_RESET				0x0004
+#define QTI_ICE_REGS_VERSION			        0x0008
+#define QTI_ICE_REGS_FUSE_SETTING			0x0010
+#define QTI_ICE_REGS_PARAMETERS_1			0x0014
+#define QTI_ICE_REGS_PARAMETERS_2		    	0x0018
+#define QTI_ICE_REGS_PARAMETERS_3			0x001C
+#define QTI_ICE_REGS_PARAMETERS_4			0x0020
+#define QTI_ICE_REGS_PARAMETERS_5			0x0024
+
+/* Register bits for ICE version */
+#define QTI_ICE_CORE_STEP_REV_MASK 			0xFFFF
+#define QTI_ICE_CORE_STEP_REV 				0 /* bit 15-0 */
+#define QTI_ICE_CORE_MAJOR_REV_MASK 			0xFF000000
+#define QTI_ICE_CORE_MAJOR_REV 				24 /* bit 31-24 */
+#define QTI_ICE_CORE_MINOR_REV_MASK 			0xFF0000
+#define QTI_ICE_CORE_MINOR_REV 				16 /* bit 23-16 */
+
+#define QTI_ICE_BIST_STATUS_MASK 			(0xF0000000)	/* bits 28-31 */
+
+#define QTI_ICE_FUSE_SETTING_MASK			0x1
+#define QTI_ICE_FORCE_HW_KEY0_SETTING_MASK		0x2
+#define QTI_ICE_FORCE_HW_KEY1_SETTING_MASK		0x4
+
+/* QTI ICE v3.X only */
+#define QTI_ICE_INVALID_CCFG_ERR_STTS			0x0030
+#define QTI_ICE_GENERAL_ERR_STTS 			0x0040
+#define QTI_ICE_GENERAL_ERR_MASK			0x0044
+#define QTI_ICE_REGS_NON_SEC_IRQ_CLR			0x0048
+#define QTI_ICE_REGS_STREAM1_ERROR_SYNDROME1		0x0050
+#define QTI_ICE_REGS_STREAM1_ERROR_SYNDROME2		0x0054
+#define QTI_ICE_REGS_STREAM2_ERROR_SYNDROME1		0x0058
+#define QTI_ICE_REGS_STREAM2_ERROR_SYNDROME2		0x005C
+#define QTI_ICE_REGS_STREAM1_BIST_ERROR_VEC		0x0060
+#define QTI_ICE_REGS_STREAM2_BIST_ERROR_VEC		0x0064
+#define QTI_ICE_REGS_STREAM1_BIST_FINISH_VEC		0x0068
+#define QTI_ICE_REGS_STREAM2_BIST_FINISH_VEC		0x006C
+#define QTI_ICE_REGS_BIST_STATUS			0x0070
+#define QTI_ICE_REGS_BYPASS_STATUS			0x0074
+#define QTI_ICE_REGS_ADVANCED_CONTROL			0x1000
+#define QTI_ICE_REGS_ENDIAN_SWAP			0x1004
+#define QTI_ICE_REGS_TEST_BUS_CONTROL			0x1010
+#define QTI_ICE_REGS_TEST_BUS_REG			0x1014
+#define QTI_ICE_REGS_STREAM1_COUNTERS1			0x1100
+#define QTI_ICE_REGS_STREAM1_COUNTERS2			0x1104
+#define QTI_ICE_REGS_STREAM1_COUNTERS3			0x1108
+#define QTI_ICE_REGS_STREAM1_COUNTERS4			0x110C
+#define QTI_ICE_REGS_STREAM1_COUNTERS5_MSB		0x1110
+#define QTI_ICE_REGS_STREAM1_COUNTERS5_LSB		0x1114
+#define QTI_ICE_REGS_STREAM1_COUNTERS6_MSB		0x1118
+#define QTI_ICE_REGS_STREAM1_COUNTERS6_LSB		0x111C
+#define QTI_ICE_REGS_STREAM1_COUNTERS7_MSB		0x1120
+#define QTI_ICE_REGS_STREAM1_COUNTERS7_LSB		0x1124
+#define QTI_ICE_REGS_STREAM1_COUNTERS8_MSB		0x1128
+#define QTI_ICE_REGS_STREAM1_COUNTERS8_LSB		0x112C
+#define QTI_ICE_REGS_STREAM1_COUNTERS9_MSB		0x1130
+#define QTI_ICE_REGS_STREAM1_COUNTERS9_LSB		0x1134
+#define QTI_ICE_REGS_STREAM2_COUNTERS1			0x1200
+#define QTI_ICE_REGS_STREAM2_COUNTERS2			0x1204
+#define QTI_ICE_REGS_STREAM2_COUNTERS3			0x1208
+#define QTI_ICE_REGS_STREAM2_COUNTERS4			0x120C
+#define QTI_ICE_REGS_STREAM2_COUNTERS5_MSB		0x1210
+#define QTI_ICE_REGS_STREAM2_COUNTERS5_LSB		0x1214
+#define QTI_ICE_REGS_STREAM2_COUNTERS6_MSB		0x1218
+#define QTI_ICE_REGS_STREAM2_COUNTERS6_LSB		0x121C
+#define QTI_ICE_REGS_STREAM2_COUNTERS7_MSB		0x1220
+#define QTI_ICE_REGS_STREAM2_COUNTERS7_LSB		0x1224
+#define QTI_ICE_REGS_STREAM2_COUNTERS8_MSB		0x1228
+#define QTI_ICE_REGS_STREAM2_COUNTERS8_LSB		0x122C
+#define QTI_ICE_REGS_STREAM2_COUNTERS9_MSB		0x1230
+#define QTI_ICE_REGS_STREAM2_COUNTERS9_LSB		0x1234
+
+#define QTI_ICE_STREAM1_PREMATURE_LBA_CHANGE		(1L << 0)
+#define QTI_ICE_STREAM2_PREMATURE_LBA_CHANGE		(1L << 1)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_LBO		(1L << 2)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_LBO		(1L << 3)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DUN		(1L << 4)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DUN		(1L << 5)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DUS		(1L << 6)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DUS		(1L << 7)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_DBO		(1L << 8)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_DBO		(1L << 9)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_ENC_SEL		(1L << 10)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_ENC_SEL		(1L << 11)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_CONF_IDX		(1L << 12)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_CONF_IDX		(1L << 13)
+#define QTI_ICE_STREAM1_NOT_EXPECTED_NEW_TRNS		(1L << 14)
+#define QTI_ICE_STREAM2_NOT_EXPECTED_NEW_TRNS		(1L << 15)
+
+#define QTI_ICE_NON_SEC_IRQ_MASK				\
+			(QTI_ICE_STREAM1_PREMATURE_LBA_CHANGE |	\
+			 QTI_ICE_STREAM2_PREMATURE_LBA_CHANGE |	\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_LBO |	\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_LBO |	\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_DUN |	\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DUN |	\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DUS |	\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_DBO |	\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_DBO |	\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_ENC_SEL |	\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_ENC_SEL |	\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_CONF_IDX |\
+			 QTI_ICE_STREAM1_NOT_EXPECTED_NEW_TRNS |\
+			 QTI_ICE_STREAM2_NOT_EXPECTED_NEW_TRNS)
+
+/* QTI ICE registers from secure side */
+#define QTI_ICE_TEST_BUS_REG_SECURE_INTR 		(1L << 28)
+#define QTI_ICE_TEST_BUS_REG_NON_SECURE_INTR 		(1L << 2)
+
+#define QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 		0x4040
+#define QTI_ICE_LUT_KEYS_CRYPTOCFG_R_17 		0x4044
+#define QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET		0x80
+
+#define QTI_ICE_LUT_KEYS_QTI_ICE_SEC_IRQ_STTS		0x6200
+#define QTI_ICE_LUT_KEYS_QTI_ICE_SEC_IRQ_MASK		0x6204
+#define QTI_ICE_LUT_KEYS_QTI_ICE_SEC_IRQ_CLR		0x6208
+
+#define QTI_ICE_STREAM1_PARTIALLY_SET_KEY_USED		(1L << 0)
+#define QTI_ICE_STREAM2_PARTIALLY_SET_KEY_USED		(1L << 1)
+#define QTI_ICE_QTIC_DBG_OPEN_EVENT			(1L << 30)
+#define QTI_ICE_KEYS_RAM_RESET_COMPLETED		(1L << 31)
+
+#define QTI_ICE_SEC_IRQ_MASK					\
+			(QTI_ICE_STREAM1_PARTIALLY_SET_KEY_USED |\
+			 QTI_ICE_STREAM2_PARTIALLY_SET_KEY_USED |\
+			 QTI_ICE_QTIC_DBG_OPEN_EVENT |		\
+			 QTI_ICE_KEYS_RAM_RESET_COMPLETED)
+
+#define qti_ice_writel(mmio, val, reg)		\
+	writel_relaxed((val), mmio + (reg))
+#define qti_ice_readl(mmio, reg)		\
+	readl_relaxed(mmio + (reg))
+
+#endif /* _QTI_INLINE_CRYPTO_ENGINE_REGS_H_ */
diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
new file mode 100644
index 000000000000..433422b34a7d
--- /dev/null
+++ b/include/linux/qti-ice-common.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef _QTI_ICE_COMMON_H
+#define _QTI_ICE_COMMON_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+
+#define AES_256_XTS_KEY_SIZE    64
+
+struct ice_mmio_data {
+	void __iomem *ice_mmio;
+};
+
+int qti_ice_init(const struct ice_mmio_data *mmio);
+int qti_ice_enable(const struct ice_mmio_data *mmio);
+int qti_ice_resume(const struct ice_mmio_data *mmio);
+int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
+                const u8* key, unsigned int key_size,
+                unsigned int slot, u8 data_unit_mask, int capid);
+int qti_ice_keyslot_evict(unsigned int slot);
+
+#endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

