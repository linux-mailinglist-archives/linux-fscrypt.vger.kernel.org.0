Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F2444B86
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 00:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhKCXWc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Nov 2021 19:22:32 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:34649 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230310AbhKCXW3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Nov 2021 19:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635981592; x=1667517592;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uWdfw0XmJ834AUovZZ/JbeOAxouPkUBpMCRDh1E8t+Y=;
  b=WnEl7l0EergUk4o1wlMnXpHrbppkvnnsYIEcEHKka497uuLgpZKyeFyB
   87Mbvl5xfCAoZdEGy+/0NN0Gx/ltBg1tpw+wFu2ek8eEk2WLRbKJglGOs
   LPF/fnJcMKfxtQWoPHY/Dd970dEnx+KRPTJD1II5RPofYuWR+f6lOWpgk
   Q=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 03 Nov 2021 16:19:52 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 16:19:51 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Wed, 3 Nov 2021 16:19:50 -0700
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 3 Nov 2021
 16:19:49 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <asutoshd@codeaurora.org>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 4/4] soc: qcom: add wrapped key support for ICE
Date:   Wed, 3 Nov 2021 16:18:40 -0700
Message-ID: <20211103231840.115521-5-quic_gaurkash@quicinc.com>
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

Add support for wrapped keys in ufs and common ICE library.
Qualcomm's ICE solution uses a hardware block called Hardware
Key Manager (HWKM) to handle wrapped keys.

This patch adds the following changes to support this.
1. Link to HWKM library for initialization.
2. Most of the key management is done from Trustzone via scm calls.
   Added calls to this from the ICE library.
3. Added support for this framework in UFS.
4. Added support for deriving SW secret as it cannot be done in
   linux kernel for wrapped keys.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufs-qcom-ice.c   |  34 +++++++++-
 drivers/scsi/ufs/ufs-qcom.c       |   1 +
 drivers/scsi/ufs/ufs-qcom.h       |   5 ++
 drivers/scsi/ufs/ufshcd-crypto.c  |  47 ++++++++++---
 drivers/scsi/ufs/ufshcd.h         |   5 ++
 drivers/soc/qcom/qti-ice-common.c | 108 ++++++++++++++++++++++++++----
 include/linux/qti-ice-common.h    |   7 +-
 7 files changed, 180 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index 6608a9015eab..79d642190997 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -45,6 +45,21 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	}
 	mmio.ice_mmio = host->ice_mmio;
 
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice_hwkm");
+	if (!res) {
+		dev_warn(dev, "ICE HWKM registers not found\n");
+		goto disable;
+	}
+
+	host->ice_hwkm_mmio = devm_ioremap_resource(dev, res);
+	if (IS_ERR(host->ice_hwkm_mmio)) {
+		err = PTR_ERR(host->ice_hwkm_mmio);
+		dev_err(dev, "Failed to map ICE registers; err=%d\n", err);
+		return err;
+	}
+	mmio.ice_hwkm_mmio = host->ice_hwkm_mmio;
+#endif
 	if (!qti_ice_init(&mmio))
 		goto disable;
 
@@ -60,6 +75,9 @@ static void get_ice_mmio_data(struct ice_mmio_data *data,
 			      const struct ufs_qcom_host *host)
 {
 	data->ice_mmio = host->ice_mmio;
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+	data->ice_hwkm_mmio = host->ice_hwkm_mmio;
+#endif
 }
 
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
@@ -88,6 +106,7 @@ int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
  * vendor-specific SCM calls for this; it doesn't support the standard way.
  */
 int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+			     const struct blk_crypto_key *key,
 			     const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	union ufs_crypto_cap_entry cap;
@@ -108,6 +127,17 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
-	return qti_ice_keyslot_program(&mmio, cfg->crypto_key, AES_256_XTS_KEY_SIZE,
-				       slot, cfg->data_unit_size, cfg->crypto_cap_idx);
+	return qti_ice_keyslot_program(&mmio, key, slot,
+				       cfg->data_unit_size, cfg->crypto_cap_idx);
+}
+
+/*
+ * Derive a SW secret from the wrapped key to be used in fscrypt. The key
+ * is unwrapped in QTI and a SW key is then derived.
+ */
+int ufs_qcom_ice_derive_sw_secret(const u8 *wrapped_key,
+				  unsigned int wrapped_key_size,
+				  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	return qti_ice_derive_sw_secret(wrapped_key, wrapped_key_size, sw_secret);
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
index 8208e3a3ef59..420fdc1dfeaa 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -207,6 +207,7 @@ struct ufs_qcom_host {
 	struct ufs_hw_version hw_ver;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	void __iomem *ice_mmio;
+	void __iomem *ice_hwkm_mmio;
 #endif
 
 	u32 dev_ref_clk_en_mask;
@@ -252,7 +253,11 @@ int ufs_qcom_ice_init(struct ufs_qcom_host *host);
 int ufs_qcom_ice_enable(struct ufs_qcom_host *host);
 int ufs_qcom_ice_resume(struct ufs_qcom_host *host);
 int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+			     const struct blk_crypto_key *key,
 			     const union ufs_crypto_cfg_entry *cfg, int slot);
+int ufs_qcom_ice_derive_sw_secret(const u8 *wrapped_key,
+				  unsigned int wrapped_key_size,
+				  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 #else
 static inline int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 0ed82741f981..965a8cc6c183 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -18,6 +18,7 @@ static const struct ufs_crypto_alg_entry {
 };
 
 static int ufshcd_program_key(struct ufs_hba *hba,
+				  const struct blk_crypto_key *key,
 			      const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
@@ -27,7 +28,7 @@ static int ufshcd_program_key(struct ufs_hba *hba,
 	ufshcd_hold(hba, false);
 
 	if (hba->vops && hba->vops->program_key) {
-		err = hba->vops->program_key(hba, cfg, slot);
+		err = hba->vops->program_key(hba, key, cfg, slot);
 		goto out;
 	}
 
@@ -80,16 +81,18 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 	cfg.crypto_cap_idx = cap_idx;
 	cfg.config_enable = UFS_CRYPTO_CONFIGURATION_ENABLE;
 
-	if (ccap_array[cap_idx].algorithm_id == UFS_CRYPTO_ALG_AES_XTS) {
-		/* In XTS mode, the blk_crypto_key's size is already doubled */
-		memcpy(cfg.crypto_key, key->raw, key->size/2);
-		memcpy(cfg.crypto_key + UFS_CRYPTO_KEY_MAX_SIZE/2,
-		       key->raw + key->size/2, key->size/2);
-	} else {
-		memcpy(cfg.crypto_key, key->raw, key->size);
+	if (key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		if (ccap_array[cap_idx].algorithm_id == UFS_CRYPTO_ALG_AES_XTS) {
+			/* In XTS mode, the blk_crypto_key's size is already doubled */
+			memcpy(cfg.crypto_key, key->raw, key->size/2);
+			memcpy(cfg.crypto_key + UFS_CRYPTO_KEY_MAX_SIZE/2,
+			       key->raw + key->size/2, key->size/2);
+		} else {
+			memcpy(cfg.crypto_key, key->raw, key->size);
+		}
 	}
 
-	err = ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, key, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
 	return err;
@@ -103,7 +106,7 @@ static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
-	return ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, NULL, &cfg, slot);
 }
 
 static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
@@ -126,9 +129,29 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
 	return true;
 }
 
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
+					 const u8 *wrapped_key,
+					 unsigned int wrapped_key_size,
+					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->derive_secret)
+		return  hba->vops->derive_secret(wrapped_key,
+							wrapped_key_size, sw_secret);
+
+	return 0;
+}
+#endif
+
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
+#endif
 };
 
 static enum blk_crypto_mode_num
@@ -190,7 +213,11 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
 	hba->crypto_profile.max_dun_bytes_supported = 8;
+#if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
+	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+#else
 	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
+#endif
 	hba->crypto_profile.dev = hba->dev;
 
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index df5439b12208..ff712358225d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -320,6 +320,7 @@ struct ufs_pwr_mode_info {
  * @device_reset: called to issue a reset pulse on the UFS device
  * @program_key: program or evict an inline encryption key
  * @event_notify: called to notify important events
+ * @derive_secret: derive sw secret from wrapped inline encryption key
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -353,9 +354,13 @@ struct ufs_hba_variant_ops {
 					struct devfreq_dev_profile *profile,
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
+			       const struct blk_crypto_key *crypto_key,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	int (*derive_secret)(const u8 *wrapped_key,
+					 unsigned int wrapped_key_size,
+					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 };
 
 /* clock gating state  */
diff --git a/drivers/soc/qcom/qti-ice-common.c b/drivers/soc/qcom/qti-ice-common.c
index b344a4cab5d4..ffec27087543 100644
--- a/drivers/soc/qcom/qti-ice-common.c
+++ b/drivers/soc/qcom/qti-ice-common.c
@@ -13,6 +13,23 @@
 
 #define QTI_ICE_MAX_BIST_CHECK_COUNT    100
 
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
@@ -27,6 +44,11 @@ static bool qti_ice_supported(const struct ice_mmio_data *mmio)
 		return false;
 	}
 
+	if ((major >=4) || ((major == 3) && (minor == 2) && (step >= 1)))
+		hwkm_version = 2;
+	else
+		hwkm_version = 1;
+
 	pr_info("Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
 		 major, minor, step);
 
@@ -97,8 +119,51 @@ int qti_ice_resume(const struct ice_mmio_data *mmio)
 }
 EXPORT_SYMBOL(qti_ice_resume);
 
+static int qti_ice_program_wrapped_key(const struct ice_mmio_data *mmio,
+                const struct blk_crypto_key *crypto_key,
+                unsigned int slot, u8 data_unit_mask, int capid)
+{
+	int err = 0;
+	union crypto_cfg cfg;
+
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
+	qti_ice_writel(mmio->ice_mmio, 0x0,(QTI_ICE_LUT_KEYS_CRYPTOCFG_R_16 +
+				QTI_ICE_LUT_KEYS_CRYPTOCFG_OFFSET*slot));
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
+	wmb();
+
+	return err;
+}
+
 int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
-                const u8* crypto_key, unsigned int crypto_key_size,
+                const struct blk_crypto_key *crypto_key,
                 unsigned int slot, u8 data_unit_mask, int capid)
 {
 	int err = 0;
@@ -108,20 +173,26 @@ int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
 		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
 	} key;
 
-	memcpy(key.bytes, crypto_key, crypto_key_size);
-	/*
-	 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
-	 * do the same, in order for the final key be correct.
-	 */
-	for (i = 0; i < ARRAY_SIZE(key.words); i++)
-		__cpu_to_be32s(&key.words[i]);
-
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
-				   capid, data_unit_mask);
-	if (err)
-		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err, slot);
+	if (crypto_key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		err = qti_ice_program_wrapped_key(mmio, crypto_key, slot,
+                        data_unit_mask, capid);
+	} else {
+		memcpy(key.bytes, crypto_key->raw, crypto_key->size);
+		/*
+		 * The SCM call byte-swaps the 32-bit words of the key.  So we have to
+		 * do the same, in order for the final key be correct.
+		 */
+		for (i = 0; i < ARRAY_SIZE(key.words); i++)
+			__cpu_to_be32s(&key.words[i]);
+
+		err = qcom_scm_ice_set_key(slot, key.bytes, 
+				AES_256_XTS_KEY_SIZE, capid, data_unit_mask);
+		if (err)
+			pr_err("%s:SCM call Error: 0x%x slot %d\n",
+							__func__, err, slot);
+		memzero_explicit(&key, sizeof(key));
+	}
 
-	memzero_explicit(&key, sizeof(key));
 	return err;
 }
 EXPORT_SYMBOL(qti_ice_keyslot_program);
@@ -132,4 +203,13 @@ int qti_ice_keyslot_evict(unsigned int slot)
 }
 EXPORT_SYMBOL(qti_ice_keyslot_evict);
 
+int qti_ice_derive_sw_secret(const u8 *wrapped_key,
+			     unsigned int wrapped_key_size,
+			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+    return qcom_scm_derive_sw_secret(wrapped_key, wrapped_key_size,
+				     sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
+}
+EXPORT_SYMBOL(qti_ice_derive_sw_secret);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
index b0a50a1c6876..73365764a595 100644
--- a/include/linux/qti-ice-common.h
+++ b/include/linux/qti-ice-common.h
@@ -8,23 +8,28 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/blk-crypto.h>
 
 #define AES_256_XTS_KEY_SIZE    64
 
 struct ice_mmio_data {
 	void __iomem *ice_mmio;
+	void __iomem *ice_hwkm_mmio;
 };
 
 int qti_ice_init(const struct ice_mmio_data *mmio);
 int qti_ice_enable(const struct ice_mmio_data *mmio);
 int qti_ice_resume(const struct ice_mmio_data *mmio);
 int qti_ice_keyslot_program(const struct ice_mmio_data *mmio,
-                const u8* key, unsigned int key_size,
+                const struct blk_crypto_key *crypto_key,
                 unsigned int slot, u8 data_unit_mask, int capid);
 int qti_ice_keyslot_evict(unsigned int slot);
 
 #if IS_ENABLED(CONFIG_QTI_HW_WRAPPED_KEYS)
 int qti_ice_hwkm_init(const struct ice_mmio_data *mmio, int version);
+int qti_ice_derive_sw_secret(const u8 *wrapped_key,
+					 unsigned int wrapped_key_size,
+					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 #else
 static inline int qti_ice_hwkm_init(const struct ice_mmio_data *mmio,
 					int version) { return -ENODEV; }
-- 
2.17.1

