Return-Path: <linux-fscrypt+bounces-566-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BA09F03BF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:22:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72EFB188B5F6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDCC191F98;
	Fri, 13 Dec 2024 04:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xfk9e+BV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DDA191F77;
	Fri, 13 Dec 2024 04:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063632; cv=none; b=iKXvo+/mYsAnfz/rZE1nyztRGUjEC+JiRpdIR93V6gdU2W0ku+vn9YzBY/UKxEPVymtQxRF+xVXIuFlBs6SkvFRMBC2imPq02eYq61qqxUghWVC4PwdU3oqicwXY3upwOpJdEopeMj6P9hIemUyEjCzBhNpfBp050/GRpzqiBKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063632; c=relaxed/simple;
	bh=G3KB0yafW0PaF94PY2juUtVwcuF4t4IpAepw2S7Urrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOn3+X3luVOWYZ4irA/7duE2YMypb0lm8DJHCQAVU4l77Bdgc+6RLa+17GESyqXb6IxMRHDtPo71nfBxvf5Pk+Ug1rp/oRaXPoyAXLbgIEqApvFixuWyTla0HmVKi1SeRZxwjmQ54tfaQTpp5IZJ5NGCxM0CKT+6SBMmoyJlaIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xfk9e+BV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3443AC4CEE7;
	Fri, 13 Dec 2024 04:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063631;
	bh=G3KB0yafW0PaF94PY2juUtVwcuF4t4IpAepw2S7Urrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xfk9e+BVlom1gNIuoFs4Lfjp3VdWIYCpUGh/W5bwO6FDTtEffrnH9E7/oObAy007N
	 gwA+str+i6cJ8AyhRNTc5j5Zd5ghDFZ3QrgaLDjxfT6C/eSPbTExbbxH5yduiVoBLU
	 SyxBdslJbRp9RvNrwkRO3RitrsHHuxt6lrJEQxEAK65esd0MZiVQVd10+RPwoZcxHQ
	 l8Mg7ZSMKJNlhvjea8f8nuWzd5MxMMm/gG1O0rPU3B9uZASyRrHvuefHjmDs3x5EsP
	 CRsaB3eyNEigIKY4WEiTL/Xd8DDy/be9ZkCdeP8UoFAseP1QxE+drtWe1O9BHicFFm
	 sxIhQtqvyXRkQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v10 14/15] soc: qcom: ice: add HWKM support to the ICE driver
Date: Thu, 12 Dec 2024 20:19:57 -0800
Message-ID: <20241213041958.202565-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Qualcomm's ICE (Inline Crypto Engine) contains a proprietary key
management hardware called Hardware Key Manager (HWKM). Add HWKM support
to the ICE driver if it is available on the platform. HWKM primarily
provides hardware wrapped key support where the ICE (storage) keys are
not available in software and instead protected in hardware.

When HWKM software support is not fully available (from Trustzone),
there can be a scenario where the ICE hardware supports HWKM, but it
cannot be used for wrapped keys. In this case, raw keys have to be used
without using the HWKM. We query the TZ at run-time to find out whether
wrapped keys support is available.

The selection of HWKM vs non-HWKM mode has to be made at boot time, so
add a module parameter qcom_ice.use_wrapped_keys=1 that enables HWKM.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
[EB: merged related patches, fixed the module parameter to work
     correctly, fixed error handling, improved log messages, improved
     comments, improved commit message, fixed various names.]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/sdhci-msm.c |   5 +
 drivers/soc/qcom/ice.c       | 360 ++++++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.c  |   5 +
 include/soc/qcom/ice.h       |  12 ++
 4 files changed, 377 insertions(+), 5 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 439e5907f940..35e937e4659d 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1831,10 +1831,15 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
+	if (qcom_ice_using_hwkm(ice)) {
+		dev_warn(dev, "HWKM mode unsupported; disabling inline encryption support\n");
+		return 0;
+	}
+
 	msm_host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 78780fd508f0..23027236fd43 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -20,34 +20,106 @@
 
 #include <soc/qcom/ice.h>
 
 #define AES_256_XTS_KEY_SIZE			64
 
+/*
+ * Wrapped key sizes that HWKM expects and manages is different for different
+ * versions of the hardware.
+ */
+#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
+	((v) == 1 ? 68 : 100)
+
 /* QCOM ICE registers */
 #define QCOM_ICE_REG_VERSION			0x0008
 #define QCOM_ICE_REG_FUSE_SETTING		0x0010
 #define QCOM_ICE_REG_BIST_STATUS		0x0070
 #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
+#define QCOM_ICE_REG_CONTROL			0x0
+#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16		0x4040
+
+/* QCOM ICE HWKM registers */
+#define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
+#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
+#define QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS	0x2008
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0			0x5000
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1			0x5004
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2			0x5008
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3			0x500C
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4			0x5010
+
+/* QCOM ICE HWKM reg vals */
+#define QCOM_ICE_HWKM_BIST_DONE_V1		BIT(16)
+#define QCOM_ICE_HWKM_BIST_DONE_V2		BIT(9)
+#define QCOM_ICE_HWKM_BIST_DONE(ver)		QCOM_ICE_HWKM_BIST_DONE_V##ver
+
+#define QCOM_ICE_HWKM_CRYPTO_BIST_DONE_V1		BIT(14)
+#define QCOM_ICE_HWKM_CRYPTO_BIST_DONE_V2		BIT(7)
+#define QCOM_ICE_HWKM_CRYPTO_BIST_DONE(v)		QCOM_ICE_HWKM_CRYPTO_BIST_DONE_V##v
+
+#define QCOM_ICE_HWKM_BOOT_CMD_LIST1_DONE		BIT(2)
+#define QCOM_ICE_HWKM_BOOT_CMD_LIST0_DONE		BIT(1)
+#define QCOM_ICE_HWKM_KT_CLEAR_DONE			BIT(0)
+
+#define QCOM_ICE_HWKM_BIST_VAL(v)	(QCOM_ICE_HWKM_BIST_DONE(v) |		\
+					QCOM_ICE_HWKM_CRYPTO_BIST_DONE(v) |	\
+					QCOM_ICE_HWKM_BOOT_CMD_LIST1_DONE |	\
+					QCOM_ICE_HWKM_BOOT_CMD_LIST0_DONE |	\
+					QCOM_ICE_HWKM_KT_CLEAR_DONE)
+
+#define QCOM_ICE_HWKM_V1_STANDARD_MODE_VAL	(BIT(0) | BIT(1) | BIT(2))
+#define QCOM_ICE_HWKM_V2_STANDARD_MODE_MASK	GENMASK(31, 1)
+#define QCOM_ICE_HWKM_DISABLE_CRC_CHECKS_VAL	(BIT(1) | BIT(2))
+#define QCOM_ICE_HWKM_RSP_FIFO_CLEAR_VAL	BIT(3)
+
+#define QCOM_ICE_HWKM_CFG_ENABLE_VAL		BIT(7)
 
 /* BIST ("built-in self-test") status flags */
 #define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
 
 #define QCOM_ICE_FUSE_SETTING_MASK		0x1
 #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
 #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
 
+#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET	0x80
+
+#define QCOM_ICE_HWKM_REG_OFFSET	0x8000
+#define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
+
 #define qcom_ice_writel(engine, val, reg)	\
 	writel((val), (engine)->base + (reg))
 
 #define qcom_ice_readl(engine, reg)	\
 	readl((engine)->base + (reg))
 
+#define QCOM_ICE_LUT_CRYPTOCFG_SLOT_OFFSET(slot) \
+	(QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 + \
+	 QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot)
+
+static bool qcom_ice_use_wrapped_keys;
+module_param_named(use_wrapped_keys, qcom_ice_use_wrapped_keys, bool, 0660);
+MODULE_PARM_DESC(use_wrapped_keys,
+		 "Support wrapped keys instead of raw keys, if available on the platform");
+
 struct qcom_ice {
 	struct device *dev;
 	void __iomem *base;
 
 	struct clk *core_clk;
+	u8 hwkm_version;
+	bool use_hwkm;
+	bool hwkm_init_complete;
+};
+
+union crypto_cfg {
+	__le32 regval;
+	struct {
+		u8 dusize;
+		u8 capidx;
+		u8 reserved;
+		u8 cfge;
+	};
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
@@ -61,12 +133,22 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
 		dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
 			 major, minor, step);
 		return false;
 	}
 
-	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
-		 major, minor, step);
+	if (major >= 4 || (major == 3 && minor == 2 && step >= 1))
+		ice->hwkm_version = 2;
+	else if (major == 3 && minor == 2)
+		ice->hwkm_version = 1;
+	else
+		ice->hwkm_version = 0;
+
+	if (ice->hwkm_version == 0)
+		ice->use_hwkm = false;
+
+	dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d, HWKM v%d\n",
+		 major, minor, step, ice->hwkm_version);
 
 	/* If fuses are blown, ICE might not work in the standard way. */
 	regval = qcom_ice_readl(ice, QCOM_ICE_REG_FUSE_SETTING);
 	if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
 		      QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
@@ -111,31 +193,109 @@ static void qcom_ice_optimization_enable(struct qcom_ice *ice)
  * because (a) the BIST is a FIPS compliance thing that never fails in
  * practice, (b) ICE is documented to reject crypto requests if the BIST
  * fails, so we needn't do it in software too, and (c) properly testing
  * storage encryption requires testing the full storage stack anyway,
  * and not relying on hardware-level self-tests.
+ *
+ * However, we still care about if HWKM BIST failed (when supported) as
+ * important functionality would fail later, so disable hwkm on failure.
  */
 static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
 {
 	u32 regval;
+	u32 bist_done_val;
 	int err;
 
 	err = readl_poll_timeout(ice->base + QCOM_ICE_REG_BIST_STATUS,
 				 regval, !(regval & QCOM_ICE_BIST_STATUS_MASK),
 				 50, 5000);
-	if (err)
+	if (err) {
 		dev_err(ice->dev, "Timed out waiting for ICE self-test to complete\n");
+		return err;
+	}
 
+	if (ice->use_hwkm) {
+		bist_done_val = ice->hwkm_version == 1 ?
+				QCOM_ICE_HWKM_BIST_VAL(1) :
+				QCOM_ICE_HWKM_BIST_VAL(2);
+		if (qcom_ice_readl(ice,
+				   HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_STATUS)) !=
+				   bist_done_val) {
+			dev_err(ice->dev, "HWKM BIST error\n");
+			ice->use_hwkm = false;
+			err = -ENODEV;
+		}
+	}
 	return err;
 }
 
+static void qcom_ice_enable_hwkm_mode(struct qcom_ice *ice)
+{
+	u32 val = 0;
+
+	/*
+	 * When ICE is in standard (hwkm) mode, it supports HW wrapped
+	 * keys, and when it is in legacy mode, it only supports raw keys.
+	 *
+	 * Put ICE in standard mode, ICE defaults to legacy mode.
+	 * Legacy mode - ICE HWKM slave not supported.
+	 * Standard mode - ICE HWKM slave supported.
+	 *
+	 * Depending on the version of HWKM, it is controlled by different
+	 * registers in ICE.
+	 */
+	if (ice->hwkm_version >= 2) {
+		val = qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
+		val = val & QCOM_ICE_HWKM_V2_STANDARD_MODE_MASK;
+		qcom_ice_writel(ice, val, QCOM_ICE_REG_CONTROL);
+	} else {
+		qcom_ice_writel(ice, QCOM_ICE_HWKM_V1_STANDARD_MODE_VAL,
+				HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
+	}
+}
+
+static void qcom_ice_hwkm_init(struct qcom_ice *ice)
+{
+	/* Disable CRC checks. This HWKM feature is not used. */
+	qcom_ice_writel(ice, QCOM_ICE_HWKM_DISABLE_CRC_CHECKS_VAL,
+			HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
+
+	/*
+	 * Give register bank of the HWKM slave access to read and modify
+	 * the keyslots in ICE HWKM slave. Without this, trustzone will not
+	 * be able to program keys into ICE.
+	 */
+	qcom_ice_writel(ice, GENMASK(31, 0), HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_0));
+	qcom_ice_writel(ice, GENMASK(31, 0), HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_1));
+	qcom_ice_writel(ice, GENMASK(31, 0), HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_2));
+	qcom_ice_writel(ice, GENMASK(31, 0), HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_3));
+	qcom_ice_writel(ice, GENMASK(31, 0), HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_4));
+
+	/* Clear HWKM response FIFO before doing anything */
+	qcom_ice_writel(ice, QCOM_ICE_HWKM_RSP_FIFO_CLEAR_VAL,
+			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
+	ice->hwkm_init_complete = true;
+}
+
 int qcom_ice_enable(struct qcom_ice *ice)
 {
+	int err;
+
 	qcom_ice_low_power_mode_enable(ice);
 	qcom_ice_optimization_enable(ice);
 
-	return qcom_ice_wait_bist_status(ice);
+	if (ice->use_hwkm)
+		qcom_ice_enable_hwkm_mode(ice);
+
+	err = qcom_ice_wait_bist_status(ice);
+	if (err)
+		return err;
+
+	if (ice->use_hwkm)
+		qcom_ice_hwkm_init(ice);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(qcom_ice_enable);
 
 int qcom_ice_resume(struct qcom_ice *ice)
 {
@@ -147,22 +307,71 @@ int qcom_ice_resume(struct qcom_ice *ice)
 		dev_err(dev, "failed to enable core clock (%d)\n",
 			err);
 		return err;
 	}
 
+	if (ice->use_hwkm) {
+		qcom_ice_enable_hwkm_mode(ice);
+		qcom_ice_hwkm_init(ice);
+	}
 	return qcom_ice_wait_bist_status(ice);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_resume);
 
 int qcom_ice_suspend(struct qcom_ice *ice)
 {
 	clk_disable_unprepare(ice->core_clk);
+	ice->hwkm_init_complete = false;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_ice_suspend);
 
+/* For v1 the ICE slot is calculated in TrustZone. */
+static int translate_hwkm_slot(struct qcom_ice *ice, int slot)
+{
+	return (ice->hwkm_version == 1) ? slot : (slot * 2);
+}
+
+static int qcom_ice_program_wrapped_key(struct qcom_ice *ice, unsigned int slot,
+					const struct blk_crypto_key *bkey)
+{
+	struct device *dev = ice->dev;
+	union crypto_cfg cfg = {
+		.dusize = bkey->crypto_cfg.data_unit_size / 512,
+		.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+		.cfge = QCOM_ICE_HWKM_CFG_ENABLE_VAL,
+	};
+	int hwkm_slot;
+	int err;
+
+	/* It is expected that HWKM init has completed before programming wrapped keys */
+	if (!ice->use_hwkm || !ice->hwkm_init_complete) {
+		dev_err_ratelimited(dev, "HWKM not currently used or initialized\n");
+		return -EINVAL;
+	}
+
+	hwkm_slot = translate_hwkm_slot(ice, slot);
+
+	/* Clear CFGE */
+	qcom_ice_writel(ice, 0x0, QCOM_ICE_LUT_CRYPTOCFG_SLOT_OFFSET(slot));
+
+	/* Call trustzone to program the wrapped key using hwkm */
+	err = qcom_scm_ice_set_key(hwkm_slot, bkey->bytes, bkey->size,
+				   cfg.capidx, cfg.dusize);
+	if (err) {
+		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err,
+		       slot);
+		return err;
+	}
+
+	/* Enable CFGE after programming key */
+	qcom_ice_writel(ice, cfg.regval, QCOM_ICE_LUT_CRYPTOCFG_SLOT_OFFSET(slot));
+
+	return err;
+}
+
 int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 			 const struct blk_crypto_key *blk_key)
 {
 	struct device *dev = ice->dev;
 	union {
@@ -178,10 +387,18 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 		dev_err_ratelimited(dev, "Unsupported crypto mode: %d\n",
 				    blk_key->crypto_cfg.crypto_mode);
 		return -EINVAL;
 	}
 
+	if (blk_key->crypto_cfg.key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED)
+		return qcom_ice_program_wrapped_key(ice, slot, blk_key);
+
+	if (ice->use_hwkm) {
+		dev_err_ratelimited(dev, "Unsupported raw key when in HWKM mode\n");
+		return -EINVAL;
+	}
+
 	if (blk_key->size != AES_256_XTS_KEY_SIZE) {
 		dev_err_ratelimited(dev, "Incorrect key size\n");
 		return -EINVAL;
 	}
 	memcpy(key.bytes, blk_key->bytes, AES_256_XTS_KEY_SIZE);
@@ -200,14 +417,137 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_program_key);
 
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
-	return qcom_scm_ice_invalidate_key(slot);
+	int hwkm_slot = slot;
+
+	if (ice->use_hwkm) {
+		hwkm_slot = translate_hwkm_slot(ice, slot);
+
+		/*
+		 * Ignore calls to evict key when HWKM is supported and hwkm
+		 * init is not yet done. This is to avoid the clearing all
+		 * slots call during a storage reset when ICE is still in
+		 * legacy mode. HWKM slave in ICE takes care of zeroing out
+		 * the keytable on reset.
+		 */
+		if (!ice->hwkm_init_complete)
+			return 0;
+	}
+
+	return qcom_scm_ice_invalidate_key(hwkm_slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
+bool qcom_ice_using_hwkm(struct qcom_ice *ice)
+{
+	return ice->use_hwkm;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_using_hwkm);
+
+/*
+ * Derive a software secret from a hardware-wrapped key. The key is unwrapped in
+ * hardware from TrustZone and a software key/secret is then derived from it.
+ */
+int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
+			      const u8 *eph_key, size_t eph_key_size,
+			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	return qcom_scm_derive_sw_secret(eph_key, eph_key_size,
+					 sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
+
+/**
+ * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: buffer for the resulting long-term wrapped key
+ *
+ * Make an SCM call into TrustZone to generate a wrapped key for storage
+ * encryption using HWKM.
+ *
+ * Return: the size of the resulting wrapped key on success; -errno on failure.
+ */
+int qcom_ice_generate_key(struct qcom_ice *ice,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+	int err;
+
+	if (WARN_ON_ONCE(wk_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE))
+		return -EINVAL;
+
+	err = qcom_scm_generate_ice_key(lt_key, wk_size);
+	if (err)
+		return err;
+
+	return wk_size;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
+
+/**
+ * qcom_ice_prepare_key() - Prepare a wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: a long-term wrapped key
+ * @lt_key_size: size of the long-term wrapped_key
+ * @eph_key: buffer for the resulting ephemerally-wrapped key
+ *
+ * Make an SCM call into TrustZone to prepare a wrapped key for storage
+ * encryption by rewrapping a long-term wrapped key with a per-boot ephemeral
+ * key using HWKM.
+ *
+ * Return: the size of the resulting wrapped key on success; -errno on failure.
+ */
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+			 const u8 *lt_key, size_t lt_key_size,
+			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+	int err;
+
+	if (WARN_ON_ONCE(wk_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE))
+		return -EINVAL;
+
+	err = qcom_scm_prepare_ice_key(lt_key, lt_key_size, eph_key, wk_size);
+	if (err)
+		return err;
+
+	return wk_size;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
+
+/**
+ * qcom_ice_import_key() - Import a raw key for inline encryption
+ * @ice: ICE driver data
+ * @raw_key: raw key that will be imported
+ * @raw_key_size: size of the raw key
+ * @lt_key: buffer for the resulting long-term wrapped key
+ *
+ * Make an SCM call into TrustZone to import a raw key for storage encryption
+ * and generate a long-term wrapped key using HWKM.
+ *
+ * Return: the size of the resulting wrapped key on success; -errno on failure.
+ */
+int qcom_ice_import_key(struct qcom_ice *ice,
+			const u8 *raw_key, size_t raw_key_size,
+			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+	int err;
+
+	if (WARN_ON_ONCE(wk_size > BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE))
+		return -EINVAL;
+
+	err = qcom_scm_import_ice_key(raw_key, raw_key_size, lt_key, wk_size);
+	if (err)
+		return err;
+
+	return wk_size;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_import_key);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
 
@@ -239,13 +579,23 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
 	if (!engine->core_clk)
 		engine->core_clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(engine->core_clk))
 		return ERR_CAST(engine->core_clk);
 
+	engine->use_hwkm = qcom_ice_use_wrapped_keys &&
+			   qcom_scm_has_wrapped_key_support();
+
 	if (!qcom_ice_check_supported(engine))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	if (engine->use_hwkm)
+		dev_info(dev, "QC ICE HWKM (Hardware Key Manager) enabled");
+	else if (qcom_ice_use_wrapped_keys)
+		dev_warn(dev, "HWKM not supported. Not supporting wrapped keys.\n");
+	else
+		dev_info(dev, "HWKM not enabled. Supporting raw keys.");
+
 	dev_dbg(dev, "Registered Qualcomm Inline Crypto Engine\n");
 
 	return engine;
 }
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 4adf017b523d..9c700bbaa12c 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -132,10 +132,15 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
+	if (qcom_ice_using_hwkm(ice)) {
+		dev_warn(dev, "HWKM mode unsupported; disabling inline encryption support\n");
+		return 0;
+	}
+
 	host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4cecc7f088b4..f352c78d27a1 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -15,7 +15,19 @@ int qcom_ice_enable(struct qcom_ice *ice);
 int qcom_ice_resume(struct qcom_ice *ice);
 int qcom_ice_suspend(struct qcom_ice *ice);
 int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 			 const struct blk_crypto_key *blk_key);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
+bool qcom_ice_using_hwkm(struct qcom_ice *ice);
+int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
+			      const u8 *eph_key, size_t eph_key_size,
+			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+int qcom_ice_generate_key(struct qcom_ice *ice,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+			 const u8 *lt_key, size_t lt_key_size,
+			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_import_key(struct qcom_ice *ice,
+			const u8 *raw_key, size_t raw_key_size,
+			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */
-- 
2.47.1


