Return-Path: <linux-fscrypt+bounces-534-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 425EA9E8A9B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F121C280E5E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCAFF198A01;
	Mon,  9 Dec 2024 04:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxeVfvnB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9317B198845;
	Mon,  9 Dec 2024 04:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720220; cv=none; b=vDS3E09vmnEZSlaUZ9vY9jrZ/YBAwVDrxjFqJjB3wb2BnuG4uonu0UnV0NV4X2AT359fS3V3VObOdKTK3DwmhO4XD9a2rX+4lZRy2Oua6K3C/Zb5zMhz0kBqgHbLq2EI+PZgvYQA4oYRDvkxQTSyMbyR/5J0y5rGij1C1pGaEqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720220; c=relaxed/simple;
	bh=eYJwChcMpK8IYc76dBGzXhayTYwF7J2KrMGjUqCMHAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPQp4q8Xb0XPbv4drIQ1YYMmytti04/FgEGYfrXI2SzaOyYlNgJjPFAR7UmZcQFtVpTDylSRuDz2duCoI3GpJtzNe84YmH0PBVIYCuQOzqL0W+kTJEjISR+f8CDLMRXzcJwuHGQ7FLtNpTnlQCYN3cp7LcGtgz4NDpGcxLHFwlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxeVfvnB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0E9C4CEE4;
	Mon,  9 Dec 2024 04:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720220;
	bh=eYJwChcMpK8IYc76dBGzXhayTYwF7J2KrMGjUqCMHAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxeVfvnBxLbJnJkFzvWTjYhbn61K3qetxS/d0H6GfiCrZ9sP/e/37a5ZAilqQf6GP
	 sgRqQderuLag69B1k2tIeg0QCeibY5tdFWcjh/LPCwIw8dOAQ4W8q1hdoQMivvOj8h
	 WXmufX/K86mWDEmy4GS3Qy13ASSAnca+CSHR+CayAd/P80LQt+qFt3YaPCpave18J2
	 xPYTRMIcLwAubBv/2g6c/SYCyu5vSu5rTNa2nV7iTpqt3fHRNG+gMJb87IeEr/YAti
	 We8U04DkK2M+FPkP2KEjHoMTUkIH50RwxaA0BfdcYLzMnPa5QLZYyd4Gx/UW7JAMYw
	 bNX8j0CQayApQ==
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
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v9 02/12] ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
Date: Sun,  8 Dec 2024 20:55:20 -0800
Message-ID: <20241209045530.507833-3-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

By default the UFS core is responsible for initializing the
blk_crypto_profile, but Qualcomm platforms have their own way of
programming and evicting crypto keys.  So currently
ufs_hba_variant_ops::program_key is used to redirect control flow from
ufshcd_program_key().  This has worked until now, but it's a bit of a
hack, given that the key (and algorithm ID etc.) ends up being converted
from blk_crypto_key => ufs_crypto_cfg_entry => SCM call parameters,
where the intermediate ufs_crypto_cfg_entry step is unnecessary.  Taking
a similar approach with the upcoming wrapped key support, the
implementation of which is similarly platform-specific, would require
adding four new methods to ufs_hba_variant_ops, changing program_key to
take the struct blk_crypto_key, and adding a new UFSHCD_CAP_* flag to
indicate support for wrapped keys.

This patch takes a different approach.  It changes ufs-qcom to use the
existing UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE which was recently added for
ufs-exynos.  This allows it to override the full blk_crypto_profile,
eliminating the need for the existing ufs_hba_variant_ops::program_key
and the hooks that would have been needed for wrapped key support.  It
does require a bit of duplicated code to read the crypto capability
registers, but it's worth the simplification in design with ufs-qcom and
ufs-exynos now using the same method to customize the crypto profile,
and it makes it much easier to add wrapped key support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 20 ++-----
 drivers/ufs/host/ufs-qcom.c      | 94 +++++++++++++++++++++++++-------
 include/ufs/ufshcd.h             |  3 -
 3 files changed, 79 insertions(+), 38 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 0cb425ef618e8..694ff7578fc19 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -15,24 +15,18 @@ static const struct ufs_crypto_alg_entry {
 		.ufs_alg = UFS_CRYPTO_ALG_AES_XTS,
 		.ufs_key_size = UFS_CRYPTO_KEY_SIZE_256,
 	},
 };
 
-static int ufshcd_program_key(struct ufs_hba *hba,
-			      const union ufs_crypto_cfg_entry *cfg, int slot)
+static void ufshcd_program_key(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
-	int err = 0;
 
 	ufshcd_hold(hba);
 
-	if (hba->vops && hba->vops->program_key) {
-		err = hba->vops->program_key(hba, cfg, slot);
-		goto out;
-	}
-
 	/* Ensure that CFGE is cleared before programming the key */
 	ufshcd_writel(hba, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	for (i = 0; i < 16; i++) {
 		ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[i]),
 			      slot_offset + i * sizeof(cfg->reg_val[0]));
@@ -41,13 +35,11 @@ static int ufshcd_program_key(struct ufs_hba *hba,
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[17]),
 		      slot_offset + 17 * sizeof(cfg->reg_val[0]));
 	/* Dword 16 must be written last */
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
-out:
 	ufshcd_release(hba);
-	return err;
 }
 
 static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 					 const struct blk_crypto_key *key,
 					 unsigned int slot)
@@ -58,11 +50,10 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 			&ufs_crypto_algs[key->crypto_cfg.crypto_mode];
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
 	int cap_idx = -1;
 	union ufs_crypto_cfg_entry cfg = {};
-	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
 		if (ccap_array[i].algorithm_id == alg->ufs_alg &&
 		    ccap_array[i].key_size == alg->ufs_key_size &&
@@ -86,14 +77,14 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 		       key->raw + key->size/2, key->size/2);
 	} else {
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	err = ufshcd_program_key(hba, &cfg, slot);
+	ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return err;
+	return 0;
 }
 
 static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 				       const struct blk_crypto_key *key,
 				       unsigned int slot)
@@ -103,11 +94,12 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
-	return ufshcd_program_key(hba, &cfg, slot);
+	ufshcd_program_key(hba, &cfg, slot);
+	return 0;
 }
 
 /*
  * Reprogram the keyslots if needed, and return true if CRYPTO_GENERAL_ENABLE
  * should be used in the host controller initialization sequence.
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 68040b2ab5f82..1c1bbf30bc82a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -110,15 +110,22 @@ static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
 		qcom_ice_enable(host->ice);
 }
 
+static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops; /* forward decl */
+
 static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
 	struct ufs_hba *hba = host->hba;
+	struct blk_crypto_profile *profile = &hba->crypto_profile;
 	struct device *dev = hba->dev;
 	struct qcom_ice *ice;
+	union ufs_crypto_capabilities caps;
+	union ufs_crypto_cap_entry cap;
+	int err;
+	int i;
 
 	ice = of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;
@@ -126,12 +133,43 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
 	host->ice = ice;
-	hba->caps |= UFSHCD_CAP_CRYPTO;
 
+	/* Initialize the blk_crypto_profile */
+
+	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
+
+	/* The number of keyslots supported is (CFGC+1) */
+	err = devm_blk_crypto_profile_init(dev, &hba->crypto_profile,
+					   caps.config_count + 1);
+	if (err)
+		return err;
+
+	profile->ll_ops = ufs_qcom_crypto_ops;
+	profile->max_dun_bytes_supported = 8;
+	profile->dev = dev;
+
+	/*
+	 * Currently this driver only supports AES-256-XTS.  All known versions
+	 * of ICE support it, but to be safe make sure it is really declared in
+	 * the crypto capability registers.  The crypto capability registers
+	 * also give the supported data unit size(s).
+	 */
+	for (i = 0; i < caps.num_crypto_cap; i++) {
+		cap.reg_val = cpu_to_le32(ufshcd_readl(hba,
+						       REG_UFS_CRYPTOCAP +
+						       i * sizeof(__le32)));
+		if (cap.algorithm_id == UFS_CRYPTO_ALG_AES_XTS &&
+		    cap.key_size == UFS_CRYPTO_KEY_SIZE_256)
+			profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] |=
+				cap.sdus_mask * 512;
+	}
+
+	hba->caps |= UFSHCD_CAP_CRYPTO;
+	hba->quirks |= UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE;
 	return 0;
 }
 
 static inline int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
 {
@@ -147,38 +185,53 @@ static inline int ufs_qcom_ice_suspend(struct ufs_qcom_host *host)
 		return qcom_ice_suspend(host->ice);
 
 	return 0;
 }
 
-static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
-				    const union ufs_crypto_cfg_entry *cfg,
-				    int slot)
+static int ufs_qcom_ice_keyslot_program(struct blk_crypto_profile *profile,
+					const struct blk_crypto_key *key,
+					unsigned int slot)
 {
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	union ufs_crypto_cap_entry cap;
-	bool config_enable =
-		cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE;
+	int err;
 
 	/* Only AES-256-XTS has been tested so far. */
-	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
-	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
-	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
+	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
 		return -EOPNOTSUPP;
 
-	if (config_enable)
-		return qcom_ice_program_key(host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(host->ice, slot);
+	ufshcd_hold(hba);
+	err = qcom_ice_program_key(host->ice,
+				   QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				   QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				   key->raw,
+				   key->crypto_cfg.data_unit_size / 512,
+				   slot);
+	ufshcd_release(hba);
+	return err;
 }
 
-#else
+static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
+				      const struct blk_crypto_key *key,
+				      unsigned int slot)
+{
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	int err;
+
+	ufshcd_hold(hba);
+	err = qcom_ice_evict_key(host->ice, slot);
+	ufshcd_release(hba);
+	return err;
+}
 
-#define ufs_qcom_ice_program_key NULL
+static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
+	.keyslot_program	= ufs_qcom_ice_keyslot_program,
+	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
+};
+
+#else
 
 static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
 }
 
@@ -1822,11 +1875,10 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 	.device_reset		= ufs_qcom_device_reset,
 	.config_scaling_param = ufs_qcom_config_scaling_param,
-	.program_key		= ufs_qcom_ice_program_key,
 	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
 	.op_runtime_config	= ufs_qcom_op_runtime_config,
 	.get_outstanding_cqs	= ufs_qcom_get_outstanding_cqs,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 91b4f95d6c8ea..a990ad6a79eaf 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -322,11 +322,10 @@ struct ufs_pwr_mode_info {
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
  * @config_scaling_param: called to configure clock scaling parameters
- * @program_key: program or evict an inline encryption key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: reports maximum number of outstanding commands supported by
@@ -370,12 +369,10 @@ struct ufs_hba_variant_ops {
 	int	(*phy_initialization)(struct ufs_hba *);
 	int	(*device_reset)(struct ufs_hba *hba);
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 				struct devfreq_dev_profile *profile,
 				struct devfreq_simple_ondemand_data *data);
-	int	(*program_key)(struct ufs_hba *hba,
-			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,
 				    void *prdt, unsigned int num_segments);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
-- 
2.47.1


