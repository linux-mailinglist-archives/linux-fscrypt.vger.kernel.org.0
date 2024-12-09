Return-Path: <linux-fscrypt+bounces-536-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 226CA9E8AA5
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1F1D280E0F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6011990C7;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iehn/caW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C21990AB;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720221; cv=none; b=bDv80+42SgAfE0UewENOeTkVDcyRDBtG/pK352LOhmOP2QFgL3RlkZg/cAA8L4cAU5uD5J20Eugc2Mf4lOOUw1YfNVc5jaoXOO0td+6wHaBsdF8y6AAWT17Otd5k/5H8DIq7gkeaT4NDGg9c8sTCIuY4C00k9MyNSbCs8vEKNJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720221; c=relaxed/simple;
	bh=bqjVC9jfgoAxzoc2mSbQ9x1KraTebcSxekuFkhsi7ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo20U+QAVbFfUXc8WpyZtPriUYMZxDvrv7qjA7iWdcMvOkN5/15cCaXeLfJ/yGL0DaKDCMBL3oTYbWbbVbtZLMZcfo51TNlKxyZj23Yo/YW5EfojOKGmKtkCPDOTXKhat1UpmW1q9hCHGXm3h+Jk/9PSynsPy65N26UjdZoVb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iehn/caW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3ABC4CEE3;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720221;
	bh=bqjVC9jfgoAxzoc2mSbQ9x1KraTebcSxekuFkhsi7ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iehn/caWDGA6+2GBjEP4rL13iNJv8fFEv0aUj+3B0GVQlCRyB0buHkMp6fsQzAxdi
	 a6L6pSJHurukyvNUdummdTXnN5ADsSQ6uK8Yy69WHs2Ms6rjPkD1phAagqIM4vOfjR
	 8wWDLg8WGw6yFci8O3FFrHJhXYDpXKMAExkTIbMsMdhSep7DfWiDrJp7hwo6V8V+D8
	 15oiqiXdIqZaD/qG+qJ4unUerVSuUi3vfT/MiDa02XNNszQEnWOIWw+NQptDr1NO8X
	 c/NW8UrwAUe6r1xXr2dK8w4eR4tiXy6NN9l3cNkPlcxNZjj9yzJN+lI/W8sXcqkkde
	 QS6orrywNNjqw==
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
Subject: [PATCH v9 04/12] mmc: sdhci-msm: convert to use custom crypto profile
Date: Sun,  8 Dec 2024 20:55:22 -0800
Message-ID: <20241209045530.507833-5-ebiggers@kernel.org>
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

As is being done in ufs-qcom, make the sdhci-msm driver override the
full crypto profile rather than "just" key programming and eviction.
This makes it much more straightforward to add support for
hardware-wrapped inline encryption keys.  It also makes it easy to pass
the original blk_crypto_key down to qcom_ice_program_key() once it is
updated to require the key in that form.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-crypto.c |  25 ++++----
 drivers/mmc/host/cqhci.h        |   8 +--
 drivers/mmc/host/sdhci-msm.c    | 103 +++++++++++++++++++++++++-------
 3 files changed, 96 insertions(+), 40 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 2951911d3f780..4736564286859 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -26,20 +26,17 @@ static inline struct cqhci_host *
 cqhci_host_from_crypto_profile(struct blk_crypto_profile *profile)
 {
 	return mmc_from_crypto_profile(profile)->cqe_private;
 }
 
-static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
-				    const union cqhci_crypto_cfg_entry *cfg,
-				    int slot)
+static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
+				     const union cqhci_crypto_cfg_entry *cfg,
+				     int slot)
 {
 	u32 slot_offset = cq_host->crypto_cfg_register + slot * sizeof(*cfg);
 	int i;
 
-	if (cq_host->ops->program_key)
-		return cq_host->ops->program_key(cq_host, cfg, slot);
-
 	/* Clear CFGE */
 	cqhci_writel(cq_host, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 
 	/* Write the key */
 	for (i = 0; i < 16; i++) {
@@ -50,11 +47,10 @@ static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
 	cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[17]),
 		     slot_offset + 17 * sizeof(cfg->reg_val[0]));
 	/* Write dword 16, which includes the new value of CFGE */
 	cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[16]),
 		     slot_offset + 16 * sizeof(cfg->reg_val[0]));
-	return 0;
 }
 
 static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
 					const struct blk_crypto_key *key,
 					unsigned int slot)
@@ -67,11 +63,10 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
 			&cqhci_crypto_algs[key->crypto_cfg.crypto_mode];
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
 	int cap_idx = -1;
 	union cqhci_crypto_cfg_entry cfg = {};
-	int err;
 
 	BUILD_BUG_ON(CQHCI_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < cq_host->crypto_capabilities.num_crypto_cap; i++) {
 		if (ccap_array[i].algorithm_id == alg->alg &&
 		    ccap_array[i].key_size == alg->key_size &&
@@ -94,25 +89,26 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
 		       key->raw + key->size/2, key->size/2);
 	} else {
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	err = cqhci_crypto_program_key(cq_host, &cfg, slot);
+	cqhci_crypto_program_key(cq_host, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return err;
+	return 0;
 }
 
 static int cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
 {
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
 	union cqhci_crypto_cfg_entry cfg = {};
 
-	return cqhci_crypto_program_key(cq_host, &cfg, slot);
+	cqhci_crypto_program_key(cq_host, &cfg, slot);
+	return 0;
 }
 
 static int cqhci_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 				      const struct blk_crypto_key *key,
 				      unsigned int slot)
@@ -175,10 +171,13 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
 
 	if (!(mmc->caps2 & MMC_CAP2_CRYPTO) ||
 	    !(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
 		goto out;
 
+	if (cq_host->ops->uses_custom_crypto_profile)
+		goto profile_initialized;
+
 	cq_host->crypto_capabilities.reg_val =
 			cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
 
 	cq_host->crypto_cfg_register =
 		(u32)cq_host->crypto_capabilities.config_array_ptr * 0x100;
@@ -223,13 +222,15 @@ int cqhci_crypto_init(struct cqhci_host *cq_host)
 			continue;
 		profile->modes_supported[blk_mode_num] |=
 			cq_host->crypto_cap_array[cap_idx].sdus_mask * 512;
 	}
 
+profile_initialized:
+
 	/* Clear all the keyslots so that we start in a known state. */
 	for (slot = 0; slot < num_keyslots; slot++)
-		cqhci_crypto_clear_keyslot(cq_host, slot);
+		profile->ll_ops.keyslot_evict(profile, NULL, slot);
 
 	/* CQHCI crypto requires the use of 128-bit task descriptors. */
 	cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
 
 	return 0;
diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
index fab9d74445ba7..ce189a1866b9d 100644
--- a/drivers/mmc/host/cqhci.h
+++ b/drivers/mmc/host/cqhci.h
@@ -287,17 +287,15 @@ struct cqhci_host_ops {
 	void (*disable)(struct mmc_host *mmc, bool recovery);
 	void (*update_dcmd_desc)(struct mmc_host *mmc, struct mmc_request *mrq,
 				 u64 *data);
 	void (*pre_enable)(struct mmc_host *mmc);
 	void (*post_disable)(struct mmc_host *mmc);
-#ifdef CONFIG_MMC_CRYPTO
-	int (*program_key)(struct cqhci_host *cq_host,
-			   const union cqhci_crypto_cfg_entry *cfg, int slot);
-#endif
 	void (*set_tran_desc)(struct cqhci_host *cq_host, u8 **desc,
 			      dma_addr_t addr, int len, bool end, bool dma64);
-
+#ifdef CONFIG_MMC_CRYPTO
+	bool uses_custom_crypto_profile;
+#endif
 };
 
 static inline void cqhci_writel(struct cqhci_host *host, u32 val, int reg)
 {
 	if (unlikely(host->ops->write_l))
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e00208535bd1c..7ab7d30ccfa3d 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1805,16 +1805,23 @@ static void sdhci_msm_set_clock(struct sdhci_host *host, unsigned int clock)
  *                                                                           *
 \*****************************************************************************/
 
 #ifdef CONFIG_MMC_CRYPTO
 
+static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward decl */
+
 static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 			      struct cqhci_host *cq_host)
 {
 	struct mmc_host *mmc = msm_host->mmc;
+	struct blk_crypto_profile *profile = &mmc->crypto_profile;
 	struct device *dev = mmc_dev(mmc);
 	struct qcom_ice *ice;
+	union cqhci_crypto_capabilities caps;
+	union cqhci_crypto_cap_entry cap;
+	int err;
+	int i;
 
 	if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
 		return 0;
 
 	ice = of_qcom_ice_get(dev);
@@ -1825,12 +1832,42 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
 	msm_host->ice = ice;
-	mmc->caps2 |= MMC_CAP2_CRYPTO;
 
+	/* Initialize the blk_crypto_profile */
+
+	caps.reg_val = cpu_to_le32(cqhci_readl(cq_host, CQHCI_CCAP));
+
+	/* The number of keyslots supported is (CFGC+1) */
+	err = devm_blk_crypto_profile_init(dev, &mmc->crypto_profile,
+					   caps.config_count + 1);
+	if (err)
+		return err;
+
+	profile->ll_ops = sdhci_msm_crypto_ops;
+	profile->max_dun_bytes_supported = 4;
+	profile->dev = dev;
+
+	/*
+	 * Currently this driver only supports AES-256-XTS.  All known versions
+	 * of ICE support it, but to be safe make sure it is really declared in
+	 * the crypto capability registers.  The crypto capability registers
+	 * also give the supported data unit size(s).
+	 */
+	for (i = 0; i < caps.num_crypto_cap; i++) {
+		cap.reg_val = cpu_to_le32(cqhci_readl(cq_host,
+						      CQHCI_CRYPTOCAP +
+						      i * sizeof(__le32)));
+		if (cap.algorithm_id == CQHCI_CRYPTO_ALG_AES_XTS &&
+		    cap.key_size == CQHCI_CRYPTO_KEY_SIZE_256)
+			profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] |=
+				cap.sdus_mask * 512;
+	}
+
+	mmc->caps2 |= MMC_CAP2_CRYPTO;
 	return 0;
 }
 
 static void sdhci_msm_ice_enable(struct sdhci_msm_host *msm_host)
 {
@@ -1852,39 +1889,59 @@ static __maybe_unused int sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
 		return qcom_ice_suspend(msm_host->ice);
 
 	return 0;
 }
 
-/*
- * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requires
- * vendor-specific SCM calls for this; it doesn't support the standard way.
- */
-static int sdhci_msm_program_key(struct cqhci_host *cq_host,
-				 const union cqhci_crypto_cfg_entry *cfg,
-				 int slot)
+static inline struct sdhci_msm_host *
+sdhci_msm_host_from_crypto_profile(struct blk_crypto_profile *profile)
 {
-	struct sdhci_host *host = mmc_priv(cq_host->mmc);
+	struct mmc_host *mmc = mmc_from_crypto_profile(profile);
+	struct sdhci_host *host = mmc_priv(mmc);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
-	union cqhci_crypto_cap_entry cap;
+
+	return msm_host;
+}
+
+/*
+ * Program a key into a QC ICE keyslot.  QC ICE requires a QC-specific SCM call
+ * for this; it doesn't support the standard way.
+ */
+static int sdhci_msm_ice_keyslot_program(struct blk_crypto_profile *profile,
+					 const struct blk_crypto_key *key,
+					 unsigned int slot)
+{
+	struct sdhci_msm_host *msm_host =
+		sdhci_msm_host_from_crypto_profile(profile);
 
 	/* Only AES-256-XTS has been tested so far. */
-	cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
-	if (cap.algorithm_id != CQHCI_CRYPTO_ALG_AES_XTS ||
-		cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256)
-		return -EINVAL;
+	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
+		return -EOPNOTSUPP;
 
-	if (cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE)
-		return qcom_ice_program_key(msm_host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(msm_host->ice, slot);
+	return qcom_ice_program_key(msm_host->ice,
+				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				    key->raw,
+				    key->crypto_cfg.data_unit_size / 512,
+				    slot);
 }
 
+static int sdhci_msm_ice_keyslot_evict(struct blk_crypto_profile *profile,
+				       const struct blk_crypto_key *key,
+				       unsigned int slot)
+{
+	struct sdhci_msm_host *msm_host =
+		sdhci_msm_host_from_crypto_profile(profile);
+
+	return qcom_ice_evict_key(msm_host->ice, slot);
+}
+
+static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops = {
+	.keyslot_program	= sdhci_msm_ice_keyslot_program,
+	.keyslot_evict		= sdhci_msm_ice_keyslot_evict,
+};
+
 #else /* CONFIG_MMC_CRYPTO */
 
 static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 				     struct cqhci_host *cq_host)
 {
@@ -1986,11 +2043,11 @@ static void sdhci_msm_set_timeout(struct sdhci_host *host, struct mmc_command *c
 
 static const struct cqhci_host_ops sdhci_msm_cqhci_ops = {
 	.enable		= sdhci_msm_cqe_enable,
 	.disable	= sdhci_msm_cqe_disable,
 #ifdef CONFIG_MMC_CRYPTO
-	.program_key	= sdhci_msm_program_key,
+	.uses_custom_crypto_profile = true,
 #endif
 };
 
 static int sdhci_msm_cqe_add_host(struct sdhci_host *host,
 				struct platform_device *pdev)
-- 
2.47.1


