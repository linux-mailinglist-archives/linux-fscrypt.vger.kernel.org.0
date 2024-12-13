Return-Path: <linux-fscrypt+bounces-556-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CE489F038B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCD6F284BAA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFD2189BA2;
	Fri, 13 Dec 2024 04:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeNmXOMP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55701189528;
	Fri, 13 Dec 2024 04:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063624; cv=none; b=JtrdEyqfdClxryURa6H44KZFtZS0qdIlihVe72p/EgoGekky73j0wAJNkml5yh5QLIZSaKNpM5bjTY9yQVSRxRlNnfwCdrNP3Nfy32NmJGcxw9Tmqkv0oyDEaQlyRYqIuKoVYFDC3iK8It35T4zYhx+KFtlrrgdTNEUorq0b5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063624; c=relaxed/simple;
	bh=pbBX38LppzeThXEP+qC3ypedVPluXHmsd11elwK2D6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDOQmBvIyWc91QxhkU+FKhQcYbq+MHzfjITN+HXm4IHB/JedPUvwFA1/Ny3ddb7VQ86SrS2lSge0SlQPJmo4XzeO6Q069ISejJBL23WQ4FAQGlzmpL6BqLoOS4KJRgVwTPG4t2l9oMWq/bl5z+nLIXGDxUAYerzOYCDBj0RNY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeNmXOMP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D1C4CED1;
	Fri, 13 Dec 2024 04:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063623;
	bh=pbBX38LppzeThXEP+qC3ypedVPluXHmsd11elwK2D6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeNmXOMPsKtD9lOfKNQ9awLddyqgBTqrhCChGdaJh+in/BWTasPzMy3J1KVam/WZ3
	 vtjiU6zUXkZy8pUfOSclkj2pc9c1C/XMNRRY1G5YHnD2k+ulwY3CweqNg70nYpyVcG
	 TYrpWfCb03CV9CWUanzBJ0LT0XZio9IfMfTrVZQ7VNgSNQi7Vpy59WaLPKtUduPaOw
	 TVKE73R5iqW8Ivl/0YAZ+5jZ5wToDB1ZJP3R7sPYyGvYXmOUu//6xmAZsWkOROD9sy
	 j3su8t+PQftxwhihhJ5Xo8Q3FYUbYzKA0uF1VJFAeyFMFJOQzkIOH76M6ys/A7zjxR
	 /LTi+R76SIrYA==
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
Subject: [PATCH v10 04/15] ufs: crypto: remove ufs_hba_variant_ops::program_key
Date: Thu, 12 Dec 2024 20:19:47 -0800
Message-ID: <20241213041958.202565-5-ebiggers@kernel.org>
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

There are no longer any implementations of
ufs_hba_variant_ops::program_key, so remove it.

As a result, ufshcd_program_key() no longer can return an error, so also
clean it up to return void.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 20 ++++++--------------
 include/ufs/ufshcd.h             |  3 ---
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 0cb425ef618e..694ff7578fc1 100644
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
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 55b81996b6e1..2606561053f4 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -324,11 +324,10 @@ struct ufs_pwr_mode_info {
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
@@ -372,12 +371,10 @@ struct ufs_hba_variant_ops {
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


