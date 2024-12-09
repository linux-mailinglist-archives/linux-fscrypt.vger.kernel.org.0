Return-Path: <linux-fscrypt+bounces-543-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70ED69E8AC8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61F02164487
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A72819C56C;
	Mon,  9 Dec 2024 04:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6piNQnD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CE419C566;
	Mon,  9 Dec 2024 04:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720227; cv=none; b=Ou9JykLgt5jCg2xJRMaejswEcFgWbrIsY5gN5Zkf5hXTOENHgTcTZpzK/8ktd55heqfKQkheQcl7KpdtzvTcos8d7Fb+QUbgfkZDmoeWd/6aD8CMRYnOYjI8ZxwN0wtL48v8UPWey9mzwZRFKf8JkUd9RkDJq3HxjUcBeseax7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720227; c=relaxed/simple;
	bh=yUfSugXPgQzw+K+tiazu/rUo5KvmiZ91WFLNZDhbTLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHxpJDKjXTQRNa7XrUe7y0vA4aekFHCd5+2MAl4ynJ2hpK4AkoZsUM7B+yAKFyPllSE4NvHogKe0Hgrego15AWb/1FZMFcv2Bfg75gEspw43oAIxSdATdV67e0/OfH6AE3hV+rpopU4LluiC5ORT7fO4t8Lm+WeKPpQWsqK7kuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6piNQnD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18562C4CEE2;
	Mon,  9 Dec 2024 04:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720226;
	bh=yUfSugXPgQzw+K+tiazu/rUo5KvmiZ91WFLNZDhbTLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6piNQnDXfsUCyrOIgqH2GLk6nqxQu2rZt33o7Es8VX023V3BDfndhlgz76PMD2c+
	 1JmJZyXdJ2ANz/OAIsK9kw8JM9Hsl5DkGPQmN1ooD9hxaUdjY0MwFAMZiBEuUm2Tv0
	 Zoq4IGy6o49ySikkZI6NUueJFqCCLbXg262Fkn2liue9rDGVXIywt5xHw9miK7C8H4
	 r/p9zsg5t/mhoT1IEBTJgh86whSA7zWxh+Lpe8tsdhQmLlQ4TMLcJ6XYr21AIpdFQb
	 5uBTqTVQ2Yt8hdy7OI1G9DMI72WsSHdNkjygw34k2Iv2mUp/TepING7/6KylnE9mlU
	 17P3GbrxOxsIg==
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
Subject: [PATCH v9 11/12] soc: qcom: ice: add HWKM support to the ICE driver
Date: Sun,  8 Dec 2024 20:55:29 -0800
Message-ID: <20241209045530.507833-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209045530.507833-1-ebiggers@kernel.org>
References: <20241209045530.507833-1-ebiggers@kernel.org>
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
index 27b24fb8e8809..ac79d9e18b3cf 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1833,10 +1833,15 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
 	msm_host->ice = ice;
 
+	if (qcom_ice_using_hwkm(ice)) {
+		dev_warn(dev, "HWKM mode unsupported; disabling inline encryption support\n");
+		return 0;
+	}
+
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
 
 	/* The number of keyslots supported is (CFGC+1) */
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 78780fd508f0b..bfdda3339dfe9 100644
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
+		 "Use HWKM for wrapped keys support if available on the platform");
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
+ * @lt_key: longterm wrapped key that was generated or imported.
+ * @lt_key_size: size of the longterm wrapped_key
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
 
+	engine->use_hwkm = qcom_scm_has_wrapped_key_support() &&
+			   qcom_ice_use_wrapped_keys;
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
index 865193d9bc474..c2fd025d04384 100644
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
index 4cecc7f088b4b..f352c78d27a15 100644
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


