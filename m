Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E3146ADEA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376916AbhLFXCb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:31 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:37432 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376698AbhLFXCa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831541; x=1670367541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ALRFuY7so6mPcA8kT5aKmUe7cZ+s4fYanplfvm5bsRs=;
  b=u/CmK6ZkkbWxxzKaLpHnv0TsbvgNyXumUhbuOwPnE97Y8aef/yPzO1Pk
   kgA9Mi3DU63zWwevsdlYRMWBzoGF0iSrmHVe5DdrDTxhp8nh/NDWExeko
   rIDoSK7NxyO4Mj18b9VLqs/YLvPd+4jCjoRkx5m/qAT7OLO+V4SZ5yf/F
   g=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Dec 2021 14:59:01 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:01 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:01 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:00 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 04/10] soc: qcom: add HWKM library for storage encryption
Date:   Mon, 6 Dec 2021 14:57:19 -0800
Message-ID: <20211206225725.77512-5-quic_gaurkash@quicinc.com>
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

Wrapped keys should utilize hardware to protect the keys
used for storage encryption. Qualcomm's Inline Crypto Engine
supports a hardware block called Hardware Key Manager (HWKM)
for key management.

Although most of the interactions to this hardware block happens
via a secure execution environment, some initializations for the
slave present in ICE can be done from the kernel.

This can also be a placeholder for when the hardware provides more
capabilities to be accessed from the linux kernel in the future.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/soc/qcom/Makefile       |   2 +-
 drivers/soc/qcom/qti-ice-hwkm.c | 111 +++++++++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-regs.h | 119 ++++++++++++++++++++++++++++++++
 include/linux/qti-ice-common.h  |   1 +
 4 files changed, 232 insertions(+), 1 deletion(-)
 create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c

diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 57840b19b7ee..e73fefb4f533 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -26,4 +26,4 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
 obj-$(CONFIG_QCOM_RPMHPD) += rpmhpd.o
 obj-$(CONFIG_QCOM_RPMPD) += rpmpd.o
 obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
-obj-$(CONFIG_QTI_ICE_COMMON) += qti-ice-common.o
+obj-$(CONFIG_QTI_ICE_COMMON) += qti-ice-common.o qti-ice-hwkm.o
diff --git a/drivers/soc/qcom/qti-ice-hwkm.c b/drivers/soc/qcom/qti-ice-hwkm.c
new file mode 100644
index 000000000000..3be6b350cd88
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-hwkm.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HWKM ICE library for storage encryption.
+ *
+ * Copyright (c) 2021, Qualcomm Innovation Center. All rights reserved.
+ */
+
+#include <linux/qti-ice-common.h>
+#include "qti-ice-regs.h"
+
+static int qti_ice_hwkm_bist_status(const struct ice_mmio_data *mmio, int version)
+{
+	if (!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BIST_DONE_V1 : BIST_DONE_V2) ||
+	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? CRYPTO_LIB_BIST_DONE_V1 :
+			CRYPTO_LIB_BIST_DONE_V2) ||
+	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BOOT_CMD_LIST1_DONE_V1 :
+			BOOT_CMD_LIST1_DONE_V2) ||
+	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BOOT_CMD_LIST0_DONE_V1 :
+			BOOT_CMD_LIST0_DONE_V2) ||
+	!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? KT_CLEAR_DONE_V1 :
+			KT_CLEAR_DONE_V2))
+		return -EINVAL;
+	return 0;
+}
+
+static void qti_ice_hwkm_configure_ice_registers(
+				const struct ice_mmio_data *mmio)
+{
+	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
+			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_0);
+	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
+			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_1);
+	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
+			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_2);
+	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
+			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_3);
+	qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0xffffffff,
+			    QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_4);
+}
+
+static int qti_ice_hwkm_init_sequence(const struct ice_mmio_data *mmio,
+				      int version)
+{
+	u32 val = 0;
+
+	/*
+	 * Put ICE in standard mode, ICE defaults to legacy mode.
+	 * Legacy mode - ICE HWKM slave not supported.
+	 * Standard mode - ICE HWKM slave supported.
+	 *
+	 * Depending on the version of HWKM, it is controlled by different
+	 * registers in ICE.
+	 */
+	if (version >= 2) {
+		val = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_CONTROL);
+		val = val & 0xFFFFFFFE;
+		qti_ice_writel(mmio->ice_mmio, val, QTI_ICE_REGS_CONTROL);
+	} else {
+		qti_ice_hwkm_writel(mmio->ice_hwkm_mmio, 0x7,
+				    QTI_HWKM_ICE_RG_TZ_KM_CTL);
+	}
+
+	/* Check BIST status */
+	if (qti_ice_hwkm_bist_status(mmio, version))
+		return -EINVAL;
+
+	/*
+	 * Give register bank of the HWKM slave access to read and modify
+	 * the keyslots in ICE HWKM slave. Without this, trustzone will not
+	 * be able to program keys into ICE.
+	 */
+	qti_ice_hwkm_configure_ice_registers(mmio);
+
+	/* Disable CRC check */
+	qti_ice_hwkm_clearb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_CTL,
+			    CRC_CHECK_EN);
+
+	/* Set RSP_FIFO_FULL bit */
+	qti_ice_hwkm_setb(mmio->ice_hwkm_mmio,
+			QTI_HWKM_ICE_RG_BANK0_BANKN_IRQ_STATUS, RSP_FIFO_FULL);
+
+	return 0;
+}
+
+/**
+ * qti_ice_hwkm_init() - Initialize ICE HWKM hardware
+ * @ice_mmio_data: contains ICE register mapping for i/o
+ * @version: version of hwkm hardware
+ *
+ * Perform HWKM initialization in the ICE slave by going
+ * through the slave initialization routine.The registers
+ * can vary slightly based on the version.
+ *
+ * Return: 0 on success; err on failure.
+ */
+
+int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version)
+{
+	if (!mmio->ice_hwkm_mmio)
+		return -EINVAL;
+
+	return qti_ice_hwkm_init_sequence(mmio, version);
+}
+EXPORT_SYMBOL_GPL(qti_ice_hwkm_init);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/soc/qcom/qti-ice-regs.h b/drivers/soc/qcom/qti-ice-regs.h
index 582b73fd60fc..256c6feb9072 100644
--- a/drivers/soc/qcom/qti-ice-regs.h
+++ b/drivers/soc/qcom/qti-ice-regs.h
@@ -137,9 +137,128 @@
 			 QTI_ICE_QTIC_DBG_OPEN_EVENT |		\
 			 QTI_ICE_KEYS_RAM_RESET_COMPLETED)
 
+/* Read/write macros for ICE address space */
 #define qti_ice_writel(mmio, val, reg)		\
 	writel_relaxed((val), mmio + (reg))
 #define qti_ice_readl(mmio, reg)		\
 	readl_relaxed(mmio + (reg))
 
+/* Registers for ICE HWKM Slave */
+
+#define HWKM_VERSION_STEP_REV_MASK			0xFFFF
+#define HWKM_VERSION_STEP_REV				0 /* bit 15-0 */
+#define HWKM_VERSION_MAJOR_REV_MASK			0xFF000000
+#define HWKM_VERSION_MAJOR_REV				24 /* bit 31-24 */
+#define HWKM_VERSION_MINOR_REV_MASK			0xFF0000
+#define HWKM_VERSION_MINOR_REV				16 /* bit 23-16 */
+
+/* QTI HWKM ICE slave config and status registers */
+
+#define QTI_HWKM_ICE_RG_IPCAT_VERSION			0x0000
+#define QTI_HWKM_ICE_RG_KEY_POLICY_VERSION		0x0004
+#define QTI_HWKM_ICE_RG_SHARED_STATUS			0x0008
+#define QTI_HWKM_ICE_RG_KEYTABLE_SIZE			0x000C
+
+#define QTI_HWKM_ICE_RG_TZ_KM_CTL			0x1000
+#define QTI_HWKM_ICE_RG_TZ_KM_STATUS			0x1004
+#define QTI_HWKM_ICE_RG_TZ_KM_STATUS_IRQ_MASK		0x1008
+#define QTI_HWKM_ICE_RG_TZ_KM_BOOT_STAGE_OTP		0x100C
+#define QTI_HWKM_ICE_RG_TZ_KM_DEBUG_CTL			0x1010
+#define QTI_HWKM_ICE_RG_TZ_KM_DEBUG_WRITE		0x1014
+#define QTI_HWKM_ICE_RG_TZ_KM_DEBUG_READ		0x1018
+#define QTI_HWKM_ICE_RG_TZ_TPKEY_RECEIVE_CTL		0x101C
+#define QTI_HWKM_ICE_RG_TZ_TPKEY_RECEIVE_STATUS		0x1020
+#define QTI_HWKM_ICE_RG_TZ_KM_COMMON_IRQ_ROUTING	0x1024
+
+/* HWKM_ICEMEM_SLAVE_ICE_KM_RG_TZ_KM_CTL */
+#define CRC_CHECK_EN					0
+#define KEYTABLE_HW_WR_ACCESS_EN			1
+#define KEYTABLE_HW_RD_ACCESS_EN			2
+#define BOOT_INIT0_DISABLE				3
+#define BOOT_INIT1_DISABLE				4
+#define ICE_LEGACY_MODE_EN_OTP				5
+
+/* HWKM_ICEMEM_SLAVE_ICE_KM_RG_TZ_KM_STATUS for v2 and above*/
+#define KT_CLEAR_DONE_V2				0
+#define BOOT_CMD_LIST0_DONE_V2				1
+#define BOOT_CMD_LIST1_DONE_V2				2
+#define LAST_ACTIVITY_BANK_V2				3
+#define CRYPTO_LIB_BIST_ERROR_V2			6
+#define CRYPTO_LIB_BIST_DONE_V2				7
+#define BIST_ERROR_V2					8
+#define BIST_DONE_V2					9
+#define LAST_ACTIVITY_BANK_MASK_V2			0x38
+
+/* HWKM_ICEMEM_SLAVE_ICE_KM_RG_TZ_KM_STATUS for v1*/
+#define KT_CLEAR_DONE_V1				0
+#define BOOT_CMD_LIST0_DONE_V1				1
+#define BOOT_CMD_LIST1_DONE_V1				2
+#define KEYTABLE_KEY_POLICY_V1				3
+#define KEYTABLE_INTEGRITY_ERROR_V1			4
+#define KEYTABLE_KEY_SLOT_ERROR_V1			5
+#define KEYTABLE_KEY_SLOT_NOT_EVEN_ERROR_V1		6
+#define KEYTABLE_KEY_SLOT_OUT_OF_RANGE_V1		7
+#define KEYTABLE_KEY_SIZE_ERROR_V1			8
+#define KEYTABLE_OPERATION_ERROR_V1			9
+#define LAST_ACTIVITY_BANK_V1				10
+#define CRYPTO_LIB_BIST_ERROR_V1			13
+#define CRYPTO_LIB_BIST_DONE_V1				14
+#define BIST_ERROR_V1					15
+#define BIST_DONE_V1					16
+
+/* HWKM_ICEMEM_SLAVE_ICE_KM_RG_TZ_TPKEY_RECEIVE_CTL */
+#define TPKEY_EN					8
+
+/* QTI HWKM ICE slave register bank 0 */
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_CTL			0x2000
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_STATUS		0x2004
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_IRQ_STATUS		0x2008
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_IRQ_MASK		0x200C
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_ESR			0x2010
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_ESR_IRQ_MASK	0x2014
+#define QTI_HWKM_ICE_RG_BANK0_BANKN_ESYNR		0x2018
+
+/* QTI HWKM access control registers for Bank 0 */
+#define QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_0		0x5000
+#define QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_1		0x5004
+#define QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_2		0x5008
+#define QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_3		0x500C
+#define QTI_HWKM_ICE_RG_BANK0_AC_BANKN_BBAC_4		0x5010
+
+/* QTI_HWKM_ICE_RG_BANKN_IRQ_STATUS */
+#define ARB_GRAN_WINNER					0
+#define CMD_DONE_BIT					1
+#define RSP_FIFO_NOT_EMPTY				2
+#define RSP_FIFO_FULL					3
+#define RSP_FIFO_UNDERFLOW				4
+#define CMD_FIFO_UNDERFLOW				5
+
+/* Read/write macros for ICE HWKM address space */
+
+#define qti_ice_hwkm_readl(hwkm_mmio, reg)		\
+	(readl_relaxed(hwkm_mmio + (reg)))
+#define qti_ice_hwkm_writel(hwkm_mmio, val, reg)	\
+	(writel_relaxed((val), hwkm_mmio + (reg)))
+#define qti_ice_hwkm_setb(hwkm_mmio, reg, nr) {		\
+	u32 val = qti_ice_hwkm_readl(hwkm_mmio, reg);	\
+	val |= (0x1 << nr);				\
+	qti_ice_hwkm_writel(hwkm_mmio, val, reg);	\
+}
+#define qti_ice_hwkm_clearb(hwkm_mmio, reg, nr) {	\
+	u32 val = qti_ice_hwkm_readl(hwkm_mmio, reg);	\
+	val &= ~(0x1 << nr);				\
+	qti_ice_hwkm_writel(hwkm_mmio, val, reg);	\
+}
+
+static inline bool qti_ice_hwkm_testb(void __iomem *ice_hwkm_mmio,
+				      u32 reg, u8 nr)
+{
+	u32 val = qti_ice_hwkm_readl(ice_hwkm_mmio, reg);
+
+	val = (val >> nr) & 0x1;
+	if (val == 0)
+		return false;
+	return true;
+}
+
 #endif /* _QTI_INLINE_CRYPTO_ENGINE_REGS_H_ */
diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
index 5a7c6fa99dc1..51dfe3c12092 100644
--- a/include/linux/qti-ice-common.h
+++ b/include/linux/qti-ice-common.h
@@ -20,5 +20,6 @@ int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
 			    const u8 *key, unsigned int key_size,
 			    unsigned int slot, u8 data_unit_mask, int capid);
 int qti_ice_keyslot_evict(unsigned int slot);
+int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version);
 
 #endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

