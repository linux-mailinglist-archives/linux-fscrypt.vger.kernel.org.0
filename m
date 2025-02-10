Return-Path: <linux-fscrypt+bounces-603-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0366EA2F9EA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 21:25:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2DB03A5114
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 20:25:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 614A32505AD;
	Mon, 10 Feb 2025 20:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hywtByuz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B02B2505A2;
	Mon, 10 Feb 2025 20:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219110; cv=none; b=h9U+bHBi1CTTBmIlcbGdV0mN5g2uZhj5DBywX6E6ZhCuTq3LNggiVxYKXJnfoMq8J8umpfYV6Y7SwPTL1r51U1+qU9CpzOg0FcoqhhVPgQ0A10Uylvt2uDhw02L6eUgfzCkumVWI/57l1lF4GIpbil8e1Kh7o77pvXejdX0GiXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219110; c=relaxed/simple;
	bh=CrncsEXtKBOS33NxA2irXrMZFCZSatGEzGJb7/H8YKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvrT/oMo3n1xUWZgwnNrjKMKuib0+cZEa7UARfLPqBe0DFe5c1OQL39OjQS3WomR/0srifQYULKZFEcys4YtJU/pK4R2Zi75UuGsGtk8IBMeZ2PoAB1DBkQ6LEicMGsdPV+TYBzVYJsIhh7AI+IkWn5aHnh7Z6ozXOuVoz//fxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hywtByuz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B584C4CEE8;
	Mon, 10 Feb 2025 20:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739219109;
	bh=CrncsEXtKBOS33NxA2irXrMZFCZSatGEzGJb7/H8YKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hywtByuzCYhpShr4B7DjNulK2Saym9CskiuwoDMLrO2JJPyDihGWVAcb6pjps4niw
	 JC7zvD9PP+ehJQxtsUTLndPu9prhQr14Qmwfsdlzzv5K6CiI5oH5kJWpUSqNHCiFph
	 fVApC9GvcYv6h1KqzCb4xoloTx1gLJXI7T1hbUqkWANj8ByOJfkBfMUVoSknEG5R2I
	 +C3AkCCAhkTeHGcpgjHevmyAO5OgiNqf8xokj/yTfCXidenP819TyTSl2EgU+CZ/7C
	 6JLjtvEw7lW1r8gjivNIYejGO0mNagv+I4TwbTOdJTGkyN9512/CjsY27lTjylLK6n
	 fksCTwZEtnRDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v12 2/4] soc: qcom: ice: add HWKM support to the ICE driver
Date: Mon, 10 Feb 2025 12:23:34 -0800
Message-ID: <20250210202336.349924-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210202336.349924-1-ebiggers@kernel.org>
References: <20250210202336.349924-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Qualcomm's Inline Crypto Engine (ICE) version 3.2 and later includes a
key management hardware block called the Hardware Key Manager (HWKM).
Add support for HWKM to the ICE driver.  HWKM provides hardware-wrapped
key support where the ICE (storage) keys are not exposed to software and
instead are protected in hardware.  Later patches will wire up this
feature to ufs-qcom and sdhci-msm using the support added in this patch.

HWKM and legacy mode are currently mutually exclusive.  The selection of
which mode to use has to be made before the storage driver(s) registers
any inline encryption capable disk(s) with the block layer (i.e.,
generally at boot time) so that the appropriate crypto capabilities can
be advertised to upper layers.  Therefore, make the ICE driver select
HWKM mode when the all of the following are true:

- The new module parameter qcom_ice.use_wrapped_keys=1 is specified.
- HWKM is present and is at least v2, i.e. ICE is v3.2.1 or later.
- The SCM calls needed to fully use HWKM are supported by TrustZone.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
[EB: merged related patches; fixed the module parameter to work
     correctly; dropped unnecessary support for HWKM v1; fixed error
     handling; improved log messages, comments, and commit message;
     fixed naming; merged enable and init functions; and other cleanups]
Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/sdhci-msm.c |   5 +
 drivers/soc/qcom/ice.c       | 327 +++++++++++++++++++++++++++++++++--
 drivers/ufs/host/ufs-qcom.c  |   5 +
 include/soc/qcom/ice.h       |  12 ++
 4 files changed, 339 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 2c926f566d05..2772e34490cc 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1880,10 +1880,15 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
+	if (qcom_ice_get_supported_key_type(ice) != BLK_CRYPTO_KEY_TYPE_RAW) {
+		dev_warn(dev, "Wrapped keys not supported. Disabling inline encryption support.\n");
+		return 0;
+	}
+
 	msm_host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 78780fd508f0..e4ae8e09092b 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -18,36 +18,86 @@
 
 #include <linux/firmware/qcom/qcom_scm.h>
 
 #include <soc/qcom/ice.h>
 
-#define AES_256_XTS_KEY_SIZE			64
+#define AES_256_XTS_KEY_SIZE			64   /* for raw keys only */
+#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE		100  /* assuming HWKM v2 */
 
 /* QCOM ICE registers */
+
+#define QCOM_ICE_REG_CONTROL			0x0000
+#define QCOM_ICE_LEGACY_MODE_ENABLED		BIT(0)
+
 #define QCOM_ICE_REG_VERSION			0x0008
+
 #define QCOM_ICE_REG_FUSE_SETTING		0x0010
+#define QCOM_ICE_FUSE_SETTING_MASK		BIT(0)
+#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	BIT(1)
+#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	BIT(2)
+
 #define QCOM_ICE_REG_BIST_STATUS		0x0070
+#define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
+
 #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
 
-/* BIST ("built-in self-test") status flags */
-#define QCOM_ICE_BIST_STATUS_MASK		GENMASK(31, 28)
+#define QCOM_ICE_REG_CRYPTOCFG_BASE		0x4040
+#define QCOM_ICE_REG_CRYPTOCFG_SIZE		0x80
+#define QCOM_ICE_REG_CRYPTOCFG(slot) (QCOM_ICE_REG_CRYPTOCFG_BASE + \
+				      QCOM_ICE_REG_CRYPTOCFG_SIZE * (slot))
+union crypto_cfg {
+	__le32 regval;
+	struct {
+		u8 dusize;
+		u8 capidx;
+		u8 reserved;
+#define QCOM_ICE_HWKM_CFG_ENABLE_VAL		BIT(7)
+		u8 cfge;
+	};
+};
+
+/* QCOM ICE HWKM (Hardware Key Manager) registers */
+
+#define HWKM_OFFSET				0x8000
+
+#define QCOM_ICE_REG_HWKM_TZ_KM_CTL		(HWKM_OFFSET + 0x1000)
+#define QCOM_ICE_HWKM_DISABLE_CRC_CHECKS_VAL	(BIT(1) | BIT(2))
 
-#define QCOM_ICE_FUSE_SETTING_MASK		0x1
-#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
-#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
+#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS		(HWKM_OFFSET + 0x1004)
+#define QCOM_ICE_HWKM_KT_CLEAR_DONE		BIT(0)
+#define QCOM_ICE_HWKM_BOOT_CMD_LIST0_DONE	BIT(1)
+#define QCOM_ICE_HWKM_BOOT_CMD_LIST1_DONE	BIT(2)
+#define QCOM_ICE_HWKM_CRYPTO_BIST_DONE_V2	BIT(7)
+#define QCOM_ICE_HWKM_BIST_DONE_V2		BIT(9)
+
+#define QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS (HWKM_OFFSET + 0x2008)
+#define QCOM_ICE_HWKM_RSP_FIFO_CLEAR_VAL	BIT(3)
+
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0		(HWKM_OFFSET + 0x5000)
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1		(HWKM_OFFSET + 0x5004)
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2		(HWKM_OFFSET + 0x5008)
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3		(HWKM_OFFSET + 0x500C)
+#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4		(HWKM_OFFSET + 0x5010)
 
 #define qcom_ice_writel(engine, val, reg)	\
 	writel((val), (engine)->base + (reg))
 
 #define qcom_ice_readl(engine, reg)	\
 	readl((engine)->base + (reg))
 
+static bool qcom_ice_use_wrapped_keys;
+module_param_named(use_wrapped_keys, qcom_ice_use_wrapped_keys, bool, 0660);
+MODULE_PARM_DESC(use_wrapped_keys,
+		 "Support wrapped keys instead of raw keys, if available on the platform");
+
 struct qcom_ice {
 	struct device *dev;
 	void __iomem *base;
 
 	struct clk *core_clk;
+	bool use_hwkm;
+	bool hwkm_init_complete;
 };
 
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
@@ -73,10 +123,39 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
 		      QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
 		dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
 		return false;
 	}
 
+	/*
+	 * Check for HWKM support and decide whether to use it or not.  ICE
+	 * v3.2.1 and later have HWKM v2.  ICE v3.2.0 has HWKM v1.  Earlier ICE
+	 * versions don't have HWKM at all.  However, for HWKM to be fully
+	 * usable by Linux, the TrustZone software also needs to support certain
+	 * SCM calls including the ones to generate and prepare keys.  That
+	 * effectively makes the earliest supported SoC be SM8650, which has
+	 * HWKM v2.  Therefore, this driver doesn't include support for HWKM v1,
+	 * and it checks for the SCM call support before it decides to use HWKM.
+	 *
+	 * Also, since HWKM and legacy mode are mutually exclusive, and
+	 * ICE-capable storage driver(s) need to know early on whether to
+	 * advertise support for raw keys or wrapped keys, HWKM cannot be used
+	 * unconditionally.  A module parameter is used to opt into using it.
+	 */
+	if ((major >= 4 ||
+	     (major == 3 && (minor >= 3 || (minor == 2 && step >= 1)))) &&
+	    qcom_scm_has_wrapped_key_support()) {
+		if (qcom_ice_use_wrapped_keys) {
+			dev_info(dev, "Using HWKM. Supporting wrapped keys only.\n");
+			ice->use_hwkm = true;
+		} else {
+			dev_info(dev, "Not using HWKM. Supporting raw keys only.\n");
+		}
+	} else if (qcom_ice_use_wrapped_keys) {
+		dev_warn(dev, "A supported HWKM is not present. Ignoring qcom_ice.use_wrapped_keys=1.\n");
+	} else {
+		dev_info(dev, "A supported HWKM is not present. Supporting raw keys only.\n");
+	}
 	return true;
 }
 
 static void qcom_ice_low_power_mode_enable(struct qcom_ice *ice)
 {
@@ -120,21 +199,75 @@ static int qcom_ice_wait_bist_status(struct qcom_ice *ice)
 	int err;
 
 	err = readl_poll_timeout(ice->base + QCOM_ICE_REG_BIST_STATUS,
 				 regval, !(regval & QCOM_ICE_BIST_STATUS_MASK),
 				 50, 5000);
-	if (err)
+	if (err) {
 		dev_err(ice->dev, "Timed out waiting for ICE self-test to complete\n");
+		return err;
+	}
 
-	return err;
+	if (ice->use_hwkm &&
+	    qcom_ice_readl(ice, QCOM_ICE_REG_HWKM_TZ_KM_STATUS) !=
+	    (QCOM_ICE_HWKM_KT_CLEAR_DONE |
+	     QCOM_ICE_HWKM_BOOT_CMD_LIST0_DONE |
+	     QCOM_ICE_HWKM_BOOT_CMD_LIST1_DONE |
+	     QCOM_ICE_HWKM_CRYPTO_BIST_DONE_V2 |
+	     QCOM_ICE_HWKM_BIST_DONE_V2)) {
+		dev_err(ice->dev, "HWKM self-test error!\n");
+		/*
+		 * Too late to revoke use_hwkm here, as it was already
+		 * propagated up the stack into the crypto capabilities.
+		 */
+	}
+	return 0;
+}
+
+static void qcom_ice_hwkm_init(struct qcom_ice *ice)
+{
+	u32 regval;
+
+	if (!ice->use_hwkm)
+		return;
+
+	BUILD_BUG_ON(QCOM_ICE_HWKM_WRAPPED_KEY_SIZE >
+		     BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE);
+	/*
+	 * When ICE is in HWKM mode, it only supports wrapped keys.
+	 * When ICE is in legacy mode, it only supports raw keys.
+	 *
+	 * Put ICE in HWKM mode.  ICE defaults to legacy mode.
+	 */
+	regval = qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
+	regval &= ~QCOM_ICE_LEGACY_MODE_ENABLED;
+	qcom_ice_writel(ice, regval, QCOM_ICE_REG_CONTROL);
+
+	/* Disable CRC checks.  This HWKM feature is not used. */
+	qcom_ice_writel(ice, QCOM_ICE_HWKM_DISABLE_CRC_CHECKS_VAL,
+			QCOM_ICE_REG_HWKM_TZ_KM_CTL);
+
+	/*
+	 * Allow the HWKM slave to read and write the keyslots in the ICE HWKM
+	 * slave.  Without this, TrustZone cannot program keys into ICE.
+	 */
+	qcom_ice_writel(ice, GENMASK(31, 0), QCOM_ICE_REG_HWKM_BANK0_BBAC_0);
+	qcom_ice_writel(ice, GENMASK(31, 0), QCOM_ICE_REG_HWKM_BANK0_BBAC_1);
+	qcom_ice_writel(ice, GENMASK(31, 0), QCOM_ICE_REG_HWKM_BANK0_BBAC_2);
+	qcom_ice_writel(ice, GENMASK(31, 0), QCOM_ICE_REG_HWKM_BANK0_BBAC_3);
+	qcom_ice_writel(ice, GENMASK(31, 0), QCOM_ICE_REG_HWKM_BANK0_BBAC_4);
+
+	/* Clear the HWKM response FIFO. */
+	qcom_ice_writel(ice, QCOM_ICE_HWKM_RSP_FIFO_CLEAR_VAL,
+			QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS);
+	ice->hwkm_init_complete = true;
 }
 
 int qcom_ice_enable(struct qcom_ice *ice)
 {
 	qcom_ice_low_power_mode_enable(ice);
 	qcom_ice_optimization_enable(ice);
-
+	qcom_ice_hwkm_init(ice);
 	return qcom_ice_wait_bist_status(ice);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_enable);
 
 int qcom_ice_resume(struct qcom_ice *ice)
@@ -146,23 +279,68 @@ int qcom_ice_resume(struct qcom_ice *ice)
 	if (err) {
 		dev_err(dev, "failed to enable core clock (%d)\n",
 			err);
 		return err;
 	}
-
+	qcom_ice_hwkm_init(ice);
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
 
+static unsigned int translate_hwkm_slot(struct qcom_ice *ice, unsigned int slot)
+{
+	return slot * 2;
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
+	int err;
+
+	if (!ice->use_hwkm) {
+		dev_err_ratelimited(dev, "Got wrapped key when not using HWKM\n");
+		return -EINVAL;
+	}
+	if (!ice->hwkm_init_complete) {
+		dev_err_ratelimited(dev, "HWKM not yet initialized\n");
+		return -EINVAL;
+	}
+
+	/* Clear CFGE before programming the key. */
+	qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
+
+	/* Call into TrustZone to program the wrapped key using HWKM. */
+	err = qcom_scm_ice_set_key(translate_hwkm_slot(ice, slot), bkey->bytes,
+				   bkey->size, cfg.capidx, cfg.dusize);
+	if (err) {
+		dev_err_ratelimited(dev,
+				    "qcom_scm_ice_set_key failed; err=%d, slot=%u\n",
+				    err, slot);
+		return err;
+	}
+
+	/* Set CFGE after programming the key. */
+	qcom_ice_writel(ice, le32_to_cpu(cfg.regval),
+			QCOM_ICE_REG_CRYPTOCFG(slot));
+	return 0;
+}
+
 int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 			 const struct blk_crypto_key *blk_key)
 {
 	struct device *dev = ice->dev;
 	union {
@@ -178,10 +356,18 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 		dev_err_ratelimited(dev, "Unsupported crypto mode: %d\n",
 				    blk_key->crypto_cfg.crypto_mode);
 		return -EINVAL;
 	}
 
+	if (blk_key->crypto_cfg.key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED)
+		return qcom_ice_program_wrapped_key(ice, slot, blk_key);
+
+	if (ice->use_hwkm) {
+		dev_err_ratelimited(dev, "Got raw key when using HWKM\n");
+		return -EINVAL;
+	}
+
 	if (blk_key->size != AES_256_XTS_KEY_SIZE) {
 		dev_err_ratelimited(dev, "Incorrect key size\n");
 		return -EINVAL;
 	}
 	memcpy(key.bytes, blk_key->bytes, AES_256_XTS_KEY_SIZE);
@@ -200,14 +386,135 @@ int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 }
 EXPORT_SYMBOL_GPL(qcom_ice_program_key);
 
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
+	if (ice->hwkm_init_complete)
+		slot = translate_hwkm_slot(ice, slot);
 	return qcom_scm_ice_invalidate_key(slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
+/**
+ * qcom_ice_get_supported_key_type() - Get the supported key type
+ * @ice: ICE driver data
+ *
+ * Return: the blk-crypto key type that the ICE driver is configured to use.
+ * This is the key type that ICE-capable storage drivers should advertise as
+ * supported in the crypto capabilities of any disks they register.
+ */
+enum blk_crypto_key_type qcom_ice_get_supported_key_type(struct qcom_ice *ice)
+{
+	if (ice->use_hwkm)
+		return BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+	return BLK_CRYPTO_KEY_TYPE_RAW;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_get_supported_key_type);
+
+/**
+ * qcom_ice_derive_sw_secret() - Derive software secret from wrapped key
+ * @ice: ICE driver data
+ * @eph_key: an ephemerally-wrapped key
+ * @eph_key_size: size of @eph_key in bytes
+ * @sw_secret: output buffer for the software secret
+ *
+ * Use HWKM to derive the "software secret" from a hardware-wrapped key that is
+ * given in ephemerally-wrapped form.
+ *
+ * Return: 0 on success; -EBADMSG if the given ephemerally-wrapped key is
+ *	   invalid; or another -errno value.
+ */
+int qcom_ice_derive_sw_secret(struct qcom_ice *ice,
+			      const u8 *eph_key, size_t eph_key_size,
+			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	int err = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
+					    sw_secret,
+					    BLK_CRYPTO_SW_SECRET_SIZE);
+	if (err == -EIO || err == -EINVAL)
+		err = -EBADMSG; /* probably invalid key */
+	return err;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
+
+/**
+ * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: output buffer for the long-term wrapped key
+ *
+ * Use HWKM to generate a new key and return it as a long-term wrapped key.
+ *
+ * Return: the size of the resulting wrapped key on success; -errno on failure.
+ */
+int qcom_ice_generate_key(struct qcom_ice *ice,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int err;
+
+	err = qcom_scm_generate_ice_key(lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE);
+	if (err)
+		return err;
+
+	return QCOM_ICE_HWKM_WRAPPED_KEY_SIZE;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
+
+/**
+ * qcom_ice_prepare_key() - Prepare a wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: a long-term wrapped key
+ * @lt_key_size: size of @lt_key in bytes
+ * @eph_key: output buffer for the ephemerally-wrapped key
+ *
+ * Use HWKM to re-wrap a long-term wrapped key with the per-boot ephemeral key.
+ *
+ * Return: the size of the resulting wrapped key on success; -EBADMSG if the
+ *	   given long-term wrapped key is invalid; or another -errno value.
+ */
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+			 const u8 *lt_key, size_t lt_key_size,
+			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int err;
+
+	err = qcom_scm_prepare_ice_key(lt_key, lt_key_size,
+				       eph_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE);
+	if (err == -EIO || err == -EINVAL)
+		err = -EBADMSG; /* probably invalid key */
+	if (err)
+		return err;
+
+	return QCOM_ICE_HWKM_WRAPPED_KEY_SIZE;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
+
+/**
+ * qcom_ice_import_key() - Import a raw key for inline encryption
+ * @ice: ICE driver data
+ * @raw_key: the raw key to import
+ * @raw_key_size: size of @raw_key in bytes
+ * @lt_key: output buffer for the long-term wrapped key
+ *
+ * Use HWKM to import a raw key and return it as a long-term wrapped key.
+ *
+ * Return: the size of the resulting wrapped key on success; -errno on failure.
+ */
+int qcom_ice_import_key(struct qcom_ice *ice,
+			const u8 *raw_key, size_t raw_key_size,
+			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int err;
+
+	err = qcom_scm_import_ice_key(raw_key, raw_key_size,
+				      lt_key, QCOM_ICE_HWKM_WRAPPED_KEY_SIZE);
+	if (err)
+		return err;
+
+	return QCOM_ICE_HWKM_WRAPPED_KEY_SIZE;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_import_key);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
 	struct qcom_ice *engine;
 
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 9330022e98ee..f34527fb02fb 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -132,10 +132,15 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
+	if (qcom_ice_get_supported_key_type(ice) != BLK_CRYPTO_KEY_TYPE_RAW) {
+		dev_warn(dev, "Wrapped keys not supported. Disabling inline encryption support.\n");
+		return 0;
+	}
+
 	host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 4cecc7f088b4..c0e32afd7fb8 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -15,7 +15,19 @@ int qcom_ice_enable(struct qcom_ice *ice);
 int qcom_ice_resume(struct qcom_ice *ice);
 int qcom_ice_suspend(struct qcom_ice *ice);
 int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
 			 const struct blk_crypto_key *blk_key);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
+enum blk_crypto_key_type qcom_ice_get_supported_key_type(struct qcom_ice *ice);
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
2.48.1


