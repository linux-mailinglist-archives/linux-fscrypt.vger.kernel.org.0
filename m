Return-Path: <linux-fscrypt+bounces-555-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 540439F0386
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F137283A2B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E657C18732A;
	Fri, 13 Dec 2024 04:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRiimf/F"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0883188704;
	Fri, 13 Dec 2024 04:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063623; cv=none; b=NQeg1+5/FpxEmBQMhsVwKxUg5OJtdbFQO5cjkErjRzbZp8nC1ip0isnAsSyIqus7XsIe3NI8HkmHKhVX8FhvvxF8daOQ7HcHOidd3mLSdz/d4Q//awYf2WE9ooDe7ZK7Dhx+rIAxmxAwXO6syPgv/eIw0awawJM5vNQM5lISAsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063623; c=relaxed/simple;
	bh=TKrz7gfLUKWQhnXE/Ix3m6ODh2E5Y+Lpg0g9lnlAGcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=joWbOKGyMzUxnW11/Jru2FoeM4mHp1qqUzp+Z0c4rcw6k6VFlWGloeZTEHacAYhKTnCUlAhwlXsPT5G6uyay820g53revxAF9pFequrd/yd5jjUGWdAttrBMLqs5U+8fXHLki/DVqso7N5Oyv+fZyr8u2ZNyB7fzu5oH79aw9eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRiimf/F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EC1C4AF0B;
	Fri, 13 Dec 2024 04:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063623;
	bh=TKrz7gfLUKWQhnXE/Ix3m6ODh2E5Y+Lpg0g9lnlAGcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRiimf/F1becCkNpqdGde7rE/Xjtv6JhKClx4HawYi6i2tPF6XJoYzg1cNpWmvvNg
	 1DDSDtr1sODaYZkKA6ATz1ve99wtE1THj36W6mz2+ZKlGuKxu2ebvU8alklh2UzZtw
	 /SE5UdfLkao/WdEcQArMfvmr05hbh/hd1QYDG7kugTF7nD3xr6ovfM3lstSYTFClYR
	 mYjFcxdNjOBt/1VHCwwssqc0D9SYyWu7UYUW7j9b1BpxlVfC7VDImpx5ApkToYHRxp
	 nSSjGPgkNtzYFOHWFd1DGMHlC1aSLMfo1l+kp5s8bNKrR3EaipR6mKOe0BZYL2UIT7
	 2qpq/6/tyngIQ==
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
Subject: [PATCH v10 03/15] ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
Date: Thu, 12 Dec 2024 20:19:46 -0800
Message-ID: <20241213041958.202565-4-ebiggers@kernel.org>
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

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 91 +++++++++++++++++++++++++++++--------
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index e33ae71245dd..de37d5933ca9 100644
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
@@ -126,12 +133,42 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
 	host->ice = ice;
-	hba->caps |= UFSHCD_CAP_CRYPTO;
 
+	/* Initialize the blk_crypto_profile */
+
+	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
+
+	/* The number of keyslots supported is (CFGC+1) */
+	err = devm_blk_crypto_profile_init(dev, profile, caps.config_count + 1);
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
@@ -147,36 +184,53 @@ static inline int ufs_qcom_ice_suspend(struct ufs_qcom_host *host)
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
-
-	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
-		return qcom_ice_evict_key(host->ice, slot);
+	int err;
 
 	/* Only AES-256-XTS has been tested so far. */
-	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
-	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
-	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
+	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
 		return -EOPNOTSUPP;
 
-	return qcom_ice_program_key(host->ice,
-				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-				    cfg->crypto_key,
-				    cfg->data_unit_size, slot);
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
 
@@ -1820,11 +1874,10 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
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
-- 
2.47.1


