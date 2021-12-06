Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B3846ADF6
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376955AbhLFXCp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:45 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:34326 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377028AbhLFXCg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831547; x=1670367547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3DbJocESiVT640e7qeul3nWqq5xIH+alIHva07yq8SU=;
  b=dzU9EX4+OuctoSqrvwEeRnlK0ARu/6R/VuuikmCNy500gZp6qFa9+vtW
   LmVOAGj86lQ8zs1PtziYXd+G7JguQBd9RZLayUx6C2eXqnjk5HlyComi5
   0Cw0y3FF65Ie16tWxdBQRMMwwL+30EX8dTCQLijFYtCDmQZjXn380JiLL
   Y=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Dec 2021 14:59:07 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:07 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:07 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:06 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 06/10] soc: qcom: add wrapped key support for ICE
Date:   Mon, 6 Dec 2021 14:57:21 -0800
Message-ID: <20211206225725.77512-7-quic_gaurkash@quicinc.com>
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

Add support for wrapped keys in ufs and common ICE library.
Qualcomm's ICE solution uses a hardware block called Hardware
Key Manager (HWKM) to handle wrapped keys.

This patch adds the following changes to support this.
1. Link to HWKM library for initialization.
2. Most of the key management is done from Trustzone via scm calls.
   Added calls to this from the ICE library.
3. Added support for this framework in ufs qcom.
4. Added support for deriving SW secret as it cannot be done in
   linux kernel for wrapped keys.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufs-qcom-ice.c   |  48 +++++++--
 drivers/scsi/ufs/ufs-qcom.c       |   1 +
 drivers/scsi/ufs/ufs-qcom.h       |   7 +-
 drivers/soc/qcom/qti-ice-common.c | 158 +++++++++++++++++++++++++++---
 include/linux/qti-ice-common.h    |  11 ++-
 5 files changed, 198 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index 3826643bf537..c8305aab6714 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -43,6 +43,24 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 		return err;
 	}
 
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice_hwkm");
+	if (!res) {
+		dev_warn(dev, "ICE HWKM registers not found\n");
+		host->ice_data.hw_wrapped_keys_supported = false;
+		goto init;
+	}
+
+	host->ice_data.ice_hwkm_mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(host->ice_data.ice_hwkm_mmio)) {
+		err = PTR_ERR(host->ice_data.ice_hwkm_mmio);
+		dev_err(dev, "Failed to map HWKM registers; err=%d\n", err);
+		return err;
+	}
+	host->ice_data.hw_wrapped_keys_supported = true;
+
+init:
+	hba->hw_wrapped_keys_supported =
+				host->ice_data.hw_wrapped_keys_supported;
 	if (qti_ice_init(&host->ice_data))
 		goto disable;
 
@@ -54,7 +72,6 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	return 0;
 }
 
-
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
@@ -76,16 +93,17 @@ int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
  * vendor-specific SCM calls for this; it doesn't support the standard way.
  */
 int ufs_qcom_ice_program_key(struct ufs_hba *hba,
-			     const union ufs_crypto_cfg_entry *cfg, int slot)
+			     const struct blk_crypto_key *key, int slot,
+			     u8 data_unit_size, int capid, bool evict)
 {
 	union ufs_crypto_cap_entry cap;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
-	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
-		return qti_ice_keyslot_evict(slot);
+	if (evict)
+		return qti_ice_keyslot_evict(&host->ice_data, slot);
 
 	/* Only AES-256-XTS has been tested so far. */
-	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
+	cap = hba->crypto_cap_array[capid];
 	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256) {
 		dev_err_ratelimited(hba->dev,
@@ -94,7 +112,21 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	return qti_ice_keyslot_program(&host->ice_data, cfg->crypto_key,
-				       UFS_CRYPTO_KEY_SIZE_256, slot,
-				       cfg->data_unit_size, cfg->crypto_cap_idx);
+	return qti_ice_keyslot_program(&host->ice_data, key, slot,
+				       data_unit_size, capid);
+}
+
+/*
+ * Derive a SW secret from the wrapped key to be used in fscrypt. The key
+ * is unwrapped in QTI and a SW key is then derived.
+ */
+int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 *wrapped_key,
+				  unsigned int wrapped_key_size,
+				  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qti_ice_derive_sw_secret(&host->ice_data,
+					wrapped_key, wrapped_key_size,
+					sw_secret);
 }
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9d9770f1db4f..9f85332fbe64 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1495,6 +1495,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
+	.derive_secret		= ufs_qcom_ice_derive_sw_secret,
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 8efacc0d7888..e7da3d1dc3c7 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -253,7 +253,12 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host);
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host);
 int ufs_qcom_ice_resume(struct ufs_qcom_host *host);
 int ufs_qcom_ice_program_key(struct ufs_hba *hba,
-			     const union ufs_crypto_cfg_entry *cfg, int slot);
+			     const struct blk_crypto_key *key,
+			     int slot, u8 data_unit_size, int capid,
+			     bool evict);
+int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 *wrapped_key,
+				  unsigned int wrapped_key_size,
+				  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 #else
 static inline int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
diff --git a/drivers/soc/qcom/qti-ice-common.c b/drivers/soc/qcom/qti-ice-common.c
index 0c5b529201c5..76703afa4834 100644
--- a/drivers/soc/qcom/qti-ice-common.c
+++ b/drivers/soc/qcom/qti-ice-common.c
@@ -14,6 +14,23 @@
 #define QTI_ICE_MAX_BIST_CHECK_COUNT    100
 #define QTI_AES_256_XTS_KEY_RAW_SIZE	64
 
+/*
+ * ICE resets during power collapse and HWKM has to be
+ * reconfigured which can be kept track with this flag.
+ */
+static bool qti_hwkm_init_done;
+static int hwkm_version;
+
+union crypto_cfg {
+	__le32 regval;
+	struct {
+		u8 dusize;
+		u8 capidx;
+		u8 reserved;
+		u8 cfge;
+	};
+};
+
 static bool qti_ice_supported(const struct ice_mmio_data *mmio)
 {
 	u32 regval = qti_ice_readl(mmio->ice_mmio, QTI_ICE_REGS_VERSION);
@@ -28,6 +45,11 @@ static bool qti_ice_supported(const struct ice_mmio_data *mmio)
 		return false;
 	}
 
+	if ((major >= 4) || ((major == 3) && (minor == 2) && (step >= 1)))
+		hwkm_version = 2;
+	else
+		hwkm_version = 1;
+
 	pr_info("Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
 		 major, minor, step);
 
@@ -131,6 +153,58 @@ int qti_ice_resume(const struct ice_mmio_data *mmio)
 }
 EXPORT_SYMBOL_GPL(qti_ice_resume);
 
+static int qti_ice_program_wrapped_key(const struct ice_mmio_data *mmio,
+				       const struct blk_crypto_key *crypto_key,
+				       unsigned int slot, u8 data_unit_mask,
+				       int capid)
+{
+	int err = 0;
+	union crypto_cfg cfg;
+
+	/*
+	 * HWKM slave in ICE should be initialized before the first
+	 * time we perform ICE HWKM related operations. This is because
+	 * ICE by default comes up in legacy mode where HWKM operations
+	 * won't work.
+	 */
+	if (!qti_hwkm_init_done) {
+		err = qti_ice_hwkm_init(mmio, hwkm_version);
+		if (err) {
+			pr_err("%s: Error initializing hwkm, err = %d",
+							__func__, err);
+			return -EINVAL;
+		}
+		qti_hwkm_init_done = true;
+	}
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.dusize = data_unit_mask;
+	cfg.capidx = capid;
+	cfg.cfge = 0x80;
+
+	/* Make sure CFGE is cleared */
+	qti_ice_writel(mmio->ice_mmio, 0x0, (QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 +
+				QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET*slot));
+	/* Memory barrier - to ensure write completion before next transaction */
+	wmb();
+
+	/* Call trustzone to program the wrapped key using hwkm */
+	err =  qcom_scm_ice_set_key(slot, crypto_key->raw, crypto_key->size,
+				    capid, data_unit_mask);
+	if (err)
+		pr_err("%s:SCM call Error: 0x%x slot %d\n",
+					__func__, err, slot);
+
+	/* Make sure CFGE is enabled after programming the key */
+	qti_ice_writel(mmio->ice_mmio, cfg.regval,
+			(QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 +
+			 QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET*slot));
+	/* Memory barrier - to ensure write completion before next transaction */
+	wmb();
+
+	return err;
+}
+
 /**
  * qti_ice_keyslot_program() - Program a key to an ICE slot
  * @ice_mmio_data: contains ICE register mapping for i/o
@@ -151,7 +225,7 @@ EXPORT_SYMBOL_GPL(qti_ice_resume);
  * Return: 0 on success; err on failure.
  */
 int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
-			    const u8 *crypto_key, unsigned int crypto_key_size,
+			    const struct blk_crypto_key *crypto_key,
 			    unsigned int slot, u8 data_unit_mask, int capid)
 {
 	int err = 0;
@@ -161,22 +235,28 @@ int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
 		u32 words[QTI_AES_256_XTS_KEY_RAW_SIZE / sizeof(u32)];
 	} key;
 
-	memcpy(key.bytes, crypto_key, crypto_key_size);
-	/*
-	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
-	 * do the same, in order for the final key be correct.
-	 */
-	for (i = 0; i < ARRAY_SIZE(key.words); i++)
-		__cpu_to_be32s(&key.words[i]);
+	if (crypto_key->crypto_cfg.key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		if (!mmio->hw_wrapped_keys_supported)
+			return -EINVAL;
+		err = qti_ice_program_wrapped_key(mmio, crypto_key, slot,
+						  data_unit_mask, capid);
+	} else {
+		memcpy(key.bytes, crypto_key->raw, crypto_key->size);
+		/*
+		 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
+		 * do the same, in order for the final key be correct.
+		 */
+		for (i = 0; i < ARRAY_SIZE(key.words); i++)
+			__cpu_to_be32s(&key.words[i]);
 
-	err = qcom_scm_ice_set_key(slot, key.bytes,
-				   QTI_AES_256_XTS_KEY_RAW_SIZE,
-				   capid, data_unit_mask);
-	if (err)
-		pr_err("%s:SCM call Error: 0x%x slot %d\n",
-			__func__, err, slot);
+		err = qcom_scm_ice_set_key(slot, key.bytes,
+			QTI_AES_256_XTS_KEY_RAW_SIZE, capid, data_unit_mask);
+		if (err)
+			pr_err("%s:SCM call Error: 0x%x slot %d\n",
+							__func__, err, slot);
+		memzero_explicit(&key, sizeof(key));
+	}
 
-	memzero_explicit(&key, sizeof(key));
 	return err;
 }
 EXPORT_SYMBOL_GPL(qti_ice_keyslot_program);
@@ -190,10 +270,56 @@ EXPORT_SYMBOL_GPL(qti_ice_keyslot_program);
  *
  * Return: 0 on success; err on failure.
  */
-int qti_ice_keyslot_evict(unsigned int slot)
+int qti_ice_keyslot_evict(const struct ice_mmio_data *mmio, unsigned int slot)
 {
+	/*
+	 * Ignore calls to evict key when wrapped keys are supported and
+	 * hwkm init is not yet done. This is to avoid the clearing all slots
+	 * call that comes from ufs during ufs reset. HWKM slave in ICE takes
+	 * care of zeroing out the keytable on reset.
+	 */
+	if (mmio->hw_wrapped_keys_supported && !qti_hwkm_init_done)
+		return 0;
 	return qcom_scm_ice_invalidate_key(slot);
 }
 EXPORT_SYMBOL_GPL(qti_ice_keyslot_evict);
 
+/**
+ * qti_ice_derive_sw_secret() - Derive SW secret from wrapped key
+ * @wrapped_key: wrapped key from which secret should be derived
+ * @wrapped_key_size: size of the wrapped key
+ * @sw_secret: secret to be returned, which is atmost BLK_CRYPTO_SW_SECRET_SIZE
+ *
+ * Make a scm call into trustzone to derive a sw secret from the
+ * given wrapped key.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_derive_sw_secret(const struct ice_mmio_data *mmio,
+			     const u8 *wrapped_key,
+			     unsigned int wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	int err = 0;
+
+	/*
+	 * HWKM slave in ICE should be initialized before the first
+	 * time we perform ICE HWKM related operations. This is because
+	 * ICE by default comes up in legacy mode where HWKM operations
+	 * won't work.
+	 */
+	if (!qti_hwkm_init_done) {
+		err = qti_ice_hwkm_init(mmio, qti_hwkm_version);
+		if (err) {
+			pr_err("%s: Error initializing hwkm, err = %d",
+							__func__, err);
+			return -EINVAL;
+		}
+		qti_hwkm_init_done = true;
+	}
+	return qcom_scm_derive_sw_secret(wrapped_key, wrapped_key_size,
+					 sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
+}
+EXPORT_SYMBOL_GPL(qti_ice_derive_sw_secret);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
index 51dfe3c12092..e329afeba113 100644
--- a/include/linux/qti-ice-common.h
+++ b/include/linux/qti-ice-common.h
@@ -8,18 +8,25 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/blk-crypto.h>
 
 struct ice_mmio_data {
 	void __iomem *ice_mmio;
+	void __iomem *ice_hwkm_mmio;
+	bool hw_wrapped_keys_supported;
 };
 
 int qti_ice_init(const struct ice_mmio_data *mmio);
 int qti_ice_enable(const struct ice_mmio_data *mmio);
 int qti_ice_resume(const struct ice_mmio_data *mmio);
 int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
-			    const u8 *key, unsigned int key_size,
+			    const struct blk_crypto_key *crypto_key,
 			    unsigned int slot, u8 data_unit_mask, int capid);
-int qti_ice_keyslot_evict(unsigned int slot);
+int qti_ice_keyslot_evict(const struct ice_mmio_data *mmio, unsigned int slot);
 int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version);
+int qti_ice_derive_sw_secret(const struct ice_mmio_data *mmio,
+			     const u8 *wrapped_key,
+			     unsigned int wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 
 #endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

