Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC14202BD8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Jun 2020 19:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgFURlD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 21 Jun 2020 13:41:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730475AbgFURlC (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 21 Jun 2020 13:41:02 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F3E2310F;
        Sun, 21 Jun 2020 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592761261;
        bh=nCi8YGKGnKvUjOkxSjdKKtF5aIDrlrcbTYRZcwgVapk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0G/7h1Ab/oejaa6/t+MVNlnNIYsLt67RQThtQwMfZigd+nnJHKgt+LBMcqP3cAups
         0l3mcjnblFkorU9tHwJsiPGhAK2NlTF/RZE2WGWyYhEk+xBWRbhTL2FoJW90FA6R6B
         jwsYcPcRjtXLZhdFxqiq/+9KKwYBZOuDJeawvslo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v5 5/5] scsi: ufs-qcom: add Inline Crypto Engine support
Date:   Sun, 21 Jun 2020 10:37:13 -0700
Message-Id: <20200621173713.132879-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621173713.132879-1-ebiggers@kernel.org>
References: <20200621173713.132879-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.

The standards-compliant parts, such as querying the crypto capabilities
and enabling crypto for individual UFS requests, are already handled by
ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
However, ICE requires vendor-specific init, enable, and resume logic,
and it requires that keys be programmed and evicted by vendor-specific
SMC calls.  Make the ufs-qcom driver handle these details.

I tested this on Dragonboard 845c, which is a publicly available
development board that uses the Snapdragon 845 SoC and runs the upstream
Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
phones.  This testing included (among other things) verifying that the
expected ciphertext was produced, both manually using ext4 encryption
and automatically using a block layer self-test I've written.

I've also tested that this driver works nearly as-is on the Snapdragon
765 and Snapdragon 865 SoCs.  And others have tested it on Snapdragon
850, Snapdragon 855, and Snapdragon 865 (see the Tested-by tags).

This is based very loosely on the vendor-provided driver in the kernel
source code for the Pixel 3, but I've greatly simplified it.  Also, for
now I've only included support for major version 3 of ICE, since that's
all I have the hardware to test with the mainline kernel.  Plus it
appears that version 3 is easier to use than older versions of ICE.

For now, only allow using AES-256-XTS.  The hardware also declares
support for AES-128-XTS, AES-{128,256}-ECB, and AES-{128,256}-CBC
(BitLocker variant).  But none of these others are really useful, and
they'd need to be individually tested to be sure they worked properly.

This commit also changes the name of the loadable module from "ufs-qcom"
to "ufs_qcom", as this is necessary to compile it from multiple source
files (unless we were to rename ufs-qcom.c).

Tested-by: Steev Klimaszewski <steev@kali.org> # Lenovo Yoga C630
Tested-by: Thara Gopinath <thara.gopinath@linaro.org> # db845c, sm8150-mtp, sm8250-mtp
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS                     |   2 +-
 drivers/scsi/ufs/Kconfig        |   1 +
 drivers/scsi/ufs/Makefile       |   4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c | 245 ++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.c     |  12 +-
 drivers/scsi/ufs/ufs-qcom.h     |  27 ++++
 6 files changed, 288 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 68f21d46614c..aa9c924facc6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2271,7 +2271,7 @@ F:	drivers/pci/controller/dwc/pcie-qcom.c
 F:	drivers/phy/qualcomm/
 F:	drivers/power/*/msm*
 F:	drivers/reset/reset-qcom-*
-F:	drivers/scsi/ufs/ufs-qcom.*
+F:	drivers/scsi/ufs/ufs-qcom*
 F:	drivers/spi/spi-geni-qcom.c
 F:	drivers/spi/spi-qcom-qspi.c
 F:	drivers/spi/spi-qup.c
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 4c0a9661049a..c67ee3cd6c92 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,6 +99,7 @@ config SCSI_UFS_DWC_TC_PLATFORM
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
+	select QCOM_SCM
 	select RESET_CONTROLLER
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 197e178f44bc..13fda1b697b2 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -3,7 +3,9 @@
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) += tc-dwc-g210-pci.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) += cdns-pltfrm.o
-obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
+obj-$(CONFIG_SCSI_UFS_QCOM) += ufs_qcom.o
+ufs_qcom-y += ufs-qcom.o
+ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) += ufs-qcom-ice.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
new file mode 100644
index 000000000000..dcfaa0b5e5de
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm ICE (Inline Crypto Engine) support.
+ *
+ * Copyright (c) 2014-2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2019 Google LLC
+ */
+
+#include <linux/platform_device.h>
+#include <linux/qcom_scm.h>
+
+#include "ufshcd-crypto.h"
+#include "ufs-qcom.h"
+
+#define AES_256_XTS_KEY_SIZE			64
+
+/* QCOM ICE registers */
+
+#define QCOM_ICE_REG_CONTROL			0x0000
+#define QCOM_ICE_REG_RESET			0x0004
+#define QCOM_ICE_REG_VERSION			0x0008
+#define QCOM_ICE_REG_FUSE_SETTING		0x0010
+#define QCOM_ICE_REG_PARAMETERS_1		0x0014
+#define QCOM_ICE_REG_PARAMETERS_2		0x0018
+#define QCOM_ICE_REG_PARAMETERS_3		0x001C
+#define QCOM_ICE_REG_PARAMETERS_4		0x0020
+#define QCOM_ICE_REG_PARAMETERS_5		0x0024
+
+/* QCOM ICE v3.X only */
+#define QCOM_ICE_GENERAL_ERR_STTS		0x0040
+#define QCOM_ICE_INVALID_CCFG_ERR_STTS		0x0030
+#define QCOM_ICE_GENERAL_ERR_MASK		0x0044
+
+/* QCOM ICE v2.X only */
+#define QCOM_ICE_REG_NON_SEC_IRQ_STTS		0x0040
+#define QCOM_ICE_REG_NON_SEC_IRQ_MASK		0x0044
+
+#define QCOM_ICE_REG_NON_SEC_IRQ_CLR		0x0048
+#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME1	0x0050
+#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME2	0x0054
+#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME1	0x0058
+#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME2	0x005C
+#define QCOM_ICE_REG_STREAM1_BIST_ERROR_VEC	0x0060
+#define QCOM_ICE_REG_STREAM2_BIST_ERROR_VEC	0x0064
+#define QCOM_ICE_REG_STREAM1_BIST_FINISH_VEC	0x0068
+#define QCOM_ICE_REG_STREAM2_BIST_FINISH_VEC	0x006C
+#define QCOM_ICE_REG_BIST_STATUS		0x0070
+#define QCOM_ICE_REG_BYPASS_STATUS		0x0074
+#define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
+#define QCOM_ICE_REG_ENDIAN_SWAP		0x1004
+#define QCOM_ICE_REG_TEST_BUS_CONTROL		0x1010
+#define QCOM_ICE_REG_TEST_BUS_REG		0x1014
+
+/* BIST ("built-in self-test"?) status flags */
+#define QCOM_ICE_BIST_STATUS_MASK		0xF0000000
+
+#define QCOM_ICE_FUSE_SETTING_MASK		0x1
+#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
+#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
+
+#define qcom_ice_writel(host, val, reg)	\
+	writel((val), (host)->ice_mmio + (reg))
+#define qcom_ice_readl(host, reg)	\
+	readl((host)->ice_mmio + (reg))
+
+static bool qcom_ice_supported(struct ufs_qcom_host *host)
+{
+	struct device *dev = host->hba->dev;
+	u32 regval = qcom_ice_readl(host, QCOM_ICE_REG_VERSION);
+	int major = regval >> 24;
+	int minor = (regval >> 16) & 0xFF;
+	int step = regval & 0xFFFF;
+
+	/* For now this driver only supports ICE version 3. */
+	if (major != 3) {
+		dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
+			 major, minor, step);
+		return false;
+	}
+
+	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
+		 major, minor, step);
+
+	/* If fuses are blown, ICE might not work in the standard way. */
+	regval = qcom_ice_readl(host, QCOM_ICE_REG_FUSE_SETTING);
+	if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
+		      QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
+		      QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
+		dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
+		return false;
+	}
+	return true;
+}
+
+int ufs_qcom_ice_init(struct ufs_qcom_host *host)
+{
+	struct ufs_hba *hba = host->hba;
+	struct device *dev = hba->dev;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *res;
+	int err;
+
+	if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
+	      MASK_CRYPTO_SUPPORT))
+		return 0;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice");
+	if (!res) {
+		dev_warn(dev, "ICE registers not found\n");
+		goto disable;
+	}
+
+	if (!qcom_scm_ice_available()) {
+		dev_warn(dev, "ICE SCM interface not found\n");
+		goto disable;
+	}
+
+	host->ice_mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(host->ice_mmio)) {
+		err = PTR_ERR(host->ice_mmio);
+		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
+		return err;
+	}
+
+	if (!qcom_ice_supported(host))
+		goto disable;
+
+	return 0;
+
+disable:
+	dev_warn(dev, "Disabling inline encryption support\n");
+	hba->caps &= ~UFSHCD_CAP_CRYPTO;
+	return 0;
+}
+
+static void qcom_ice_low_power_mode_enable(struct ufs_qcom_host *host)
+{
+	u32 regval;
+
+	regval = qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
+	/*
+	 * Enable low power mode sequence
+	 * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
+	 */
+	regval |= 0x7000;
+	qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
+}
+
+static void qcom_ice_optimization_enable(struct ufs_qcom_host *host)
+{
+	u32 regval;
+
+	/* ICE Optimizations Enable Sequence */
+	regval = qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
+	regval |= 0xD807100;
+	/* ICE HPG requires delay before writing */
+	udelay(5);
+	qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
+	udelay(5);
+}
+
+int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+{
+	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
+		return 0;
+	qcom_ice_low_power_mode_enable(host);
+	qcom_ice_optimization_enable(host);
+	return ufs_qcom_ice_resume(host);
+}
+
+/* Poll until all BIST bits are reset */
+static int qcom_ice_wait_bist_status(struct ufs_qcom_host *host)
+{
+	int count;
+	u32 reg;
+
+	for (count = 0; count < 100; count++) {
+		reg = qcom_ice_readl(host, QCOM_ICE_REG_BIST_STATUS);
+		if (!(reg & QCOM_ICE_BIST_STATUS_MASK))
+			break;
+		udelay(50);
+	}
+	if (reg)
+		return -ETIMEDOUT;
+	return 0;
+}
+
+int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
+{
+	int err;
+
+	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
+		return 0;
+
+	err = qcom_ice_wait_bist_status(host);
+	if (err) {
+		dev_err(host->hba->dev, "BIST status error (%d)\n", err);
+		return err;
+	}
+	return 0;
+}
+
+/*
+ * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requires
+ * vendor-specific SCM calls for this; it doesn't support the standard way.
+ */
+int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+			     const union ufs_crypto_cfg_entry *cfg, int slot)
+{
+	union ufs_crypto_cap_entry cap;
+	union {
+		u8 bytes[AES_256_XTS_KEY_SIZE];
+		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
+	} key;
+	int i;
+	int err;
+
+	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
+		return qcom_scm_ice_invalidate_key(slot);
+
+	/* Only AES-256-XTS has been tested so far. */
+	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
+	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
+	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256) {
+		dev_err_ratelimited(hba->dev,
+				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
+				    cap.algorithm_id, cap.key_size);
+		return -EINVAL;
+	}
+
+	memcpy(key.bytes, cfg->crypto_key, AES_256_XTS_KEY_SIZE);
+
+	/*
+	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
+	 * do the same, in order for the final key be correct.
+	 */
+	for (i = 0; i < ARRAY_SIZE(key.words); i++)
+		__cpu_to_be32s(&key.words[i]);
+
+	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+				   cfg->data_unit_size);
+	memzero_explicit(&key, sizeof(key));
+	return err;
+}
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index bd0b4ed7b37a..139c3ae05e95 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -365,7 +365,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 		/* check if UFS PHY moved from DISABLED to HIBERN8 */
 		err = ufs_qcom_check_hibern8(hba);
 		ufs_qcom_enable_hw_clk_gating(hba);
-
+		ufs_qcom_ice_enable(host);
 		break;
 	default:
 		dev_err(hba->dev, "%s: invalid status %d\n", __func__, status);
@@ -613,6 +613,10 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			return err;
 	}
 
+	err = ufs_qcom_ice_resume(host);
+	if (err)
+		return err;
+
 	hba->is_sys_suspended = false;
 	return 0;
 }
@@ -1071,6 +1075,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
 	hba->caps |= UFSHCD_CAP_CLK_SCALING;
 	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
 	hba->caps |= UFSHCD_CAP_WB_EN;
+	hba->caps |= UFSHCD_CAP_CRYPTO;
 
 	if (host->hw_ver.major >= 0x2) {
 		host->caps = UFS_QCOM_CAP_QUNIPRO |
@@ -1298,6 +1303,10 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	ufs_qcom_set_caps(hba);
 	ufs_qcom_advertise_quirks(hba);
 
+	err = ufs_qcom_ice_init(host);
+	if (err)
+		goto out_variant_clear;
+
 	ufs_qcom_set_bus_vote(hba, true);
 	ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
 
@@ -1736,6 +1745,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
+	.program_key		= ufs_qcom_ice_program_key,
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 2d95e7cc7187..97247d17e258 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -227,6 +227,9 @@ struct ufs_qcom_host {
 	void __iomem *dev_ref_clk_ctrl_mmio;
 	bool is_dev_ref_clk_enabled;
 	struct ufs_hw_version hw_ver;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+	void __iomem *ice_mmio;
+#endif
 
 	u32 dev_ref_clk_en_mask;
 
@@ -264,4 +267,28 @@ static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
 		return false;
 }
 
+/* ufs-qcom-ice.c */
+
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+int ufs_qcom_ice_init(struct ufs_qcom_host *host);
+int ufs_qcom_ice_enable(struct ufs_qcom_host *host);
+int ufs_qcom_ice_resume(struct ufs_qcom_host *host);
+int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+			     const union ufs_crypto_cfg_entry *cfg, int slot);
+#else
+static inline int ufs_qcom_ice_init(struct ufs_qcom_host *host)
+{
+	return 0;
+}
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
+{
+	return 0;
+}
+static inline int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
+{
+	return 0;
+}
+#define ufs_qcom_ice_program_key NULL
+#endif /* !CONFIG_SCSI_UFS_CRYPTO */
+
 #endif /* UFS_QCOM_H_ */
-- 
2.27.0

