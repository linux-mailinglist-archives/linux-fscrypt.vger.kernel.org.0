Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF2B444B80
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 00:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhKCXW1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Nov 2021 19:22:27 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4756 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhKCXW0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Nov 2021 19:22:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635981590; x=1667517590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=CWgzDFgrRvUk/uk2a/JrYphlhenWdze50BxsUZFep0s=;
  b=ICySOIdO8c+T6vvvP177JHDbE+Z0Z3pWF5l4fZb8pXhq+OdlIbqoRrGL
   5k57pQh2XplKm+cwLSFCj2k/wk6OklwTi0YjwKFA9xnU0anfvrUxUQQ9M
   bVkoQSM7jDNWSXbqBqi5UojEtcp8MfIQgFKRJuHJTmCGwsWWsoJ3C+E8D
   o=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 03 Nov 2021 16:19:49 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 16:19:49 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Wed, 3 Nov 2021 16:19:48 -0700
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 3 Nov 2021
 16:19:48 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <asutoshd@codeaurora.org>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 3/4] soc: qcom: add HWKM library for storage encryption
Date:   Wed, 3 Nov 2021 16:18:39 -0700
Message-ID: <20211103231840.115521-4-quic_gaurkash@quicinc.com>
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

Wrapped keys should utilize hardware to protect the keys
used for storage encryption. Qualcomm's Inline Crypto Engine
supports a hardware block called Hardware Key Manager (HWKM)
for key management.

Although most of the interactions to this hardware block happens
via a secure execution environment, some initializations for the
slave present in ICE can be done from the kernel.

This can also be a placeholder for when the hardware provides more
capabilites to be acessed from the linux kernel in the future.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/soc/qcom/Kconfig        |   7 ++
 drivers/soc/qcom/Makefile       |   1 +
 drivers/soc/qcom/qti-ice-hwkm.c |  77 ++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-regs.h | 112 ++++++++++++++++++++++++++++++++
 include/linux/qti-ice-common.h  |   6 ++
 5 files changed, 203 insertions(+)
 create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 39f223ed8cdd..d441d5b81c53 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -216,4 +216,11 @@ config QTI_ICE_COMMON
 	help
 	  Enable the common ICE library that can be used
 	  by UFS and EMMC drivers for ICE functionality.
+
+config QTI_HW_WRAPPED_KEYS
+	tristate "QTI HW Wrapped Keys"
+	depends on QTI_ICE_COMMON
+	help
+	  Enable wrapped key functionality for storage
+	  encryption.
 endmenu
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 57840b19b7ee..56d1f4b8d436 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_QCOM_RPMHPD) += rpmhpd.o
 obj-$(CONFIG_QCOM_RPMPD) += rpmpd.o
 obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
 obj-$(CONFIG_QTI_ICE_COMMON) += qti-ice-common.o
+obj-$(CONFIG_QTI_HW_WRAPPED_KEYS) += qti-ice-hwkm.o
diff --git a/drivers/soc/qcom/qti-ice-hwkm.c b/drivers/soc/qcom/qti-ice-hwkm.c
new file mode 100644
index 000000000000..d65873745999
--- /dev/null
+++ b/drivers/soc/qcom/qti-ice-hwkm.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * HWKM ICE library for storage encryption.
+ *
+ * Copyright (c) 2021, Linux Foundation. All rights reserved.
+ */
+
+#include <linux/qti-ice-common.h>
+#include "qti-ice-regs.h"
+
+static int qti_ice_hwkm_bist_status(const struct ice_mmio_data *mmio, int version)
+{
+	if (!qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BIST_DONE_V1 : BIST_DONE_V2) ||
+        !qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? CRYPTO_LIB_BIST_DONE_V1 :
+			CRYPTO_LIB_BIST_DONE_V2) ||
+        !qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BOOT_CMD_LIST1_DONE_V1 :
+			BOOT_CMD_LIST1_DONE_V2) ||
+        !qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? BOOT_CMD_LIST0_DONE_V1 :
+			BOOT_CMD_LIST0_DONE_V2) ||
+        !qti_ice_hwkm_testb(mmio->ice_hwkm_mmio, QTI_HWKM_ICE_RG_TZ_KM_STATUS,
+			(version == 1) ? KT_CLEAR_DONE_V1 :
+			KT_CLEAR_DONE_V2))
+		return -EINVAL;
+	return 0;
+}
+
+static int qti_ice_hwkm_init_sequence(const struct ice_mmio_data *mmio,
+                                      int version)
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
+int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version)
+{
+	if (!mmio->ice_hwkm_mmio)
+		return -EINVAL;
+
+	return qti_ice_hwkm_init_sequence(mmio, version);
+}
+EXPORT_SYMBOL(qti_ice_hwkm_init);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/soc/qcom/qti-ice-regs.h b/drivers/soc/qcom/qti-ice-regs.h
index 47c625c9d536..4c8d9fd62e42 100644
--- a/drivers/soc/qcom/qti-ice-regs.h
+++ b/drivers/soc/qcom/qti-ice-regs.h
@@ -137,9 +137,121 @@
 			 QTI_ICE_QTIC_DBG_OPEN_EVENT |		\
 			 QTI_ICE_KEYS_RAM_RESET_COMPLETED)
 
+/* Read/write macros for ICE address space */
 #define qti_ice_writel(mmio, val, reg)		\
 	writel_relaxed((val), mmio + (reg))
 #define qti_ice_readl(mmio, reg)		\
 	readl_relaxed(mmio + (reg))
 
+/* Registers for ICE HWKM Slave */
+
+#define HWKM_VERSION_STEP_REV_MASK 			0xFFFF
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
index 433422b34a7d..b0a50a1c6876 100644
--- a/include/linux/qti-ice-common.h
+++ b/include/linux/qti-ice-common.h
@@ -23,4 +23,10 @@ int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
                 unsigned int slot, u8 data_unit_mask, int capid);
 int qti_ice_keyslot_evict(unsigned int slot);
 
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version);
+#else
+static inline int qti_ice_hwkm_init(const struct ice_mmio_data *mmio,
+					int version) { return -ENODEV; }
+#endif /* CONFIG_QTI_HW_WRAPPED_KEYS */
 #endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

