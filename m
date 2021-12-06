Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2285646ADD9
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376656AbhLFXCP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:15 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:25256 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1359564AbhLFXCP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831526; x=1670367526;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=OK/BCH/proGH0PCKGvXS8Kk1FOt/6gx4f6czFZ3Bdxk=;
  b=DmApUZZDlNKmlqa1LaRYROEFdpFuPb7IiSPAarOaQL8YA7qpeKJASVX7
   Jo0K3lQp/5RDTwnGGcHdy+RmHIlkHw/JeudWAnknm5IyuQL7M/hv1ACUS
   RKLcggSsdz4RutjSQb/K41ELegjOiGTjuQXRyteH6/YLw6vYRiMGuhGAR
   o=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 06 Dec 2021 14:58:45 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:58:45 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:58:45 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:58:44 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 01/10] soc: qcom: new common library for ICE functionality
Date:   Mon, 6 Dec 2021 14:57:16 -0800
Message-ID: <20211206225725.77512-2-quic_gaurkash@quicinc.com>
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

Add a new library which congregates all the ICE
functionality so that all storage controllers containing
ICE can utilize it.

Currently, ufs and sdhci-msm have their own support for
ICE, this common library allows code to be shared.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/soc/qcom/Kconfig          |   7 ++
 drivers/soc/qcom/Makefile         |   1 +
 drivers/soc/qcom/qti-ice-common.c | 199 ++++++++++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-regs.h   | 145 ++++++++++++++++++++++
 include/linux/qti-ice-common.h    |  24 ++++
 5 files changed, 376 insertions(+)
 create mode 100644 drivers/soc/qcom/qti-ice-common.c
 create mode 100644 drivers/soc/qcom/qti-ice-regs.h
 create mode 100644 include/linux/qti-ice-common.h

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 79b568f82a1c..a900f5ab6263 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -209,4 +209,11 @@ config QCOM_APR
 	  application processor and QDSP6. APR is
 	  used by audio driver to configure QDSP6
 	  ASM, ADM and AFE modules.
+
+config QTI_ICE_COMMON
+	tristate "QTI common ICE functionality"
+	depends on ARCH_QCOM
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
index 000000000000..0c5b529201c5
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-common.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Common ICE library for storage encryption.
+ *
+ * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
+ */
+
+#include <linux/qti-ice-common.h>
+#include <linux/module.h>
+#include <linux/qcom_scm.h>
+#include <linux/delay.h>
+#include "qti-ice-regs.h"
+
+#define QTI_ICE_MAX_BIST_CHECK_COUNT    100
+#define QTI_AES_256_XTS_KEY_RAW_SIZE	64
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
+/**
+ * qti_ice_init() - Initialize ICE functionality
+ * @ice_mmio_data: contains ICE register mapping for i/o
+ *
+ * Initialize ICE by checking the version for ICE support and
+ * also checking the fuses blown.
+ *
+ * Return: 0 on success; -EINVAL on failure.
+ */
+int qti_ice_init(const struct ice_mmio_data *mmio)
+{
+	if (!qti_ice_supported(mmio))
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qti_ice_init);
+
+static void qti_ice_low_power_and_optimization_enable(
+				const struct ice_mmio_data *mmio)
+{
+	u32 regval = qti_ice_readl(mmio->ice_mmio,
+				   QTI_ICE_REGS_ADVANCED_CONTROL);
+
+	/* Enable low power mode sequence
+	 * [0]-0,[1]-0,[2]-0,[3]-7,[4]-0,[5]-0,[6]-0,[7]-0,
+	 * Enable CONFIG_CLK_GATING, STREAM2_CLK_GATING and STREAM1_CLK_GATING
+	 */
+	regval |= 0x7000;
+	/* Optimization enable sequence*/
+	regval |= 0xD807100;
+	qti_ice_writel(mmio->ice_mmio, regval, QTI_ICE_REGS_ADVANCED_CONTROL);
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
+		regval = qti_ice_readl(mmio->ice_mmio,
+				       QTI_ICE_REGS_BIST_STATUS);
+		if (!(regval & QTI_ICE_BIST_STATUS_MASK))
+			break;
+		udelay(50);
+	}
+
+	if (regval) {
+		pr_err("%s: wait bist status failed, reg %d\n",
+			__func__, regval);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+/**
+ * qti_ice_enable() - Enable ICE functionality
+ * @ice_mmio_data: contains ICE register mapping for i/o
+ *
+ * Performs two operations two enable ICE functionality.
+ * 1. Enable low power mode and optimization.
+ * 2. Wait for and check if BIST has completed.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_enable(const struct ice_mmio_data *mmio)
+{
+	qti_ice_low_power_and_optimization_enable(mmio);
+	return qti_ice_wait_bist_status(mmio);
+}
+EXPORT_SYMBOL_GPL(qti_ice_enable);
+
+/**
+ * qti_ice_resume() - Resume ICE functionality
+ * @ice_mmio_data: contains ICE register mapping for i/o
+ *
+ * This is called from storage controller after suspend.
+ * It must be ensured that BIST is complete before resuming.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_resume(const struct ice_mmio_data *mmio)
+{
+	return qti_ice_wait_bist_status(mmio);
+}
+EXPORT_SYMBOL_GPL(qti_ice_resume);
+
+/**
+ * qti_ice_keyslot_program() - Program a key to an ICE slot
+ * @ice_mmio_data: contains ICE register mapping for i/o
+ * @crypto_key: key to be program, this can be wrapped or raw
+ * @crypto_key_size: size of the key to be programmed
+ * @slot: the keyslot at which the key should be programmed.
+ * @data_unit_mask: mask for the dun which is part of the
+ *                  crypto configuration.
+ * @capid: capability index indicating the algorithm for the
+ *         crypto configuration
+ *
+ * Program the passed in key to a slot in ICE.
+ * The key that is passed in can either be a raw key or wrapped.
+ * In both cases, due to access control of ICE for Qualcomm chipsets,
+ * a scm call is used to program the key into ICE from trustzone.
+ * Trustzone can differentiate between raw and wrapped keys.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
+			    const u8 *crypto_key, unsigned int crypto_key_size,
+			    unsigned int slot, u8 data_unit_mask, int capid)
+{
+	int err = 0;
+	int i = 0;
+	union {
+		u8 bytes[QTI_AES_256_XTS_KEY_RAW_SIZE];
+		u32 words[QTI_AES_256_XTS_KEY_RAW_SIZE / sizeof(u32)];
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
+	err = qcom_scm_ice_set_key(slot, key.bytes,
+				   QTI_AES_256_XTS_KEY_RAW_SIZE,
+				   capid, data_unit_mask);
+	if (err)
+		pr_err("%s:SCM call Error: 0x%x slot %d\n",
+			__func__, err, slot);
+
+	memzero_explicit(&key, sizeof(key));
+	return err;
+}
+EXPORT_SYMBOL_GPL(qti_ice_keyslot_program);
+
+/**
+ * qti_ice_keyslot_evict() - Evict a key from a keyslot
+ * @slot: keyslot from which key needs to be evicted.
+ *
+ * Make a scm call into trustzone to evict an ICE key
+ * from its keyslot.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_keyslot_evict(unsigned int slot)
+{
+	return qcom_scm_ice_invalidate_key(slot);
+}
+EXPORT_SYMBOL_GPL(qti_ice_keyslot_evict);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/soc/qcom/qti-ice-regs.h b/drivers/soc/qcom/qti-ice-regs.h
new file mode 100644
index 000000000000..582b73fd60fc
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-regs.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
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
+#define QTI_ICE_REGS_PARAMETERS_2			0x0018
+#define QTI_ICE_REGS_PARAMETERS_3			0x001C
+#define QTI_ICE_REGS_PARAMETERS_4			0x0020
+#define QTI_ICE_REGS_PARAMETERS_5			0x0024
+
+/* Register bits for ICE version */
+#define QTI_ICE_CORE_STEP_REV_MASK			0xFFFF
+#define QTI_ICE_CORE_STEP_REV				0 /* bit 15-0 */
+#define QTI_ICE_CORE_MAJOR_REV_MASK			0xFF000000
+#define QTI_ICE_CORE_MAJOR_REV				24 /* bit 31-24 */
+#define QTI_ICE_CORE_MINOR_REV_MASK			0xFF0000
+#define QTI_ICE_CORE_MINOR_REV				16 /* bit 23-16 */
+
+#define QTI_ICE_BIST_STATUS_MASK			(0xF0000000)	/* bits 28-31 */
+
+#define QTI_ICE_FUSE_SETTING_MASK			0x1
+#define QTI_ICE_FORCE_HW_KEY0_SETTING_MASK		0x2
+#define QTI_ICE_FORCE_HW_KEY1_SETTING_MASK		0x4
+
+/* QTI ICE v3.X only */
+#define QTI_ICE_INVALID_CCFG_ERR_STTS			0x0030
+#define QTI_ICE_GENERAL_ERR_STTS			0x0040
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
+#define QTI_ICE_TEST_BUS_REG_SECURE_INTR		(1L << 28)
+#define QTI_ICE_TEST_BUS_REG_NON_SECURE_INTR		(1L << 2)
+
+#define QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16			0x4040
+#define QTI_ICE_LUT_KEYS_CRYPTOCFG_R_17			0x4044
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
index 000000000000..5a7c6fa99dc1
--- /dev/null
+++ b/include/linux/qti-ice-common.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
+ */
+
+#ifndef _QTI_ICE_COMMON_H
+#define _QTI_ICE_COMMON_H
+
+#include <linux/types.h>
+#include <linux/device.h>
+
+struct ice_mmio_data {
+	void __iomem *ice_mmio;
+};
+
+int qti_ice_init(const struct ice_mmio_data *mmio);
+int qti_ice_enable(const struct ice_mmio_data *mmio);
+int qti_ice_resume(const struct ice_mmio_data *mmio);
+int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
+			    const u8 *key, unsigned int key_size,
+			    unsigned int slot, u8 data_unit_mask, int capid);
+int qti_ice_keyslot_evict(unsigned int slot);
+
+#endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

