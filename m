Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5112446ADF4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376987AbhLFXCf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:35 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:36329 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376873AbhLFXCc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831544; x=1670367544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=9qedNGE1JEVmN4kcgOxpqxc9N60VuBMS8Us4NYfi29c=;
  b=C4zFofd3AowluFztbb18k3W36LPYpFma5cnGx6TgCP7FpTBsTyS9yVlV
   GvCJVSbX4+bgEIPZjbwyDYSL6NsY5vGhRKFm75G0BfEB8dKt5Iezl7NXA
   Qj7O1kHbAWaQu52v4zY+QqIopjCrhiAXWiAahhmZRTIW9yhm3K+/CxYP1
   Q=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 06 Dec 2021 14:59:03 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:03 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:02 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:02 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 05/10] scsi: ufs: prepare to support wrapped keys
Date:   Mon, 6 Dec 2021 14:57:20 -0800
Message-ID: <20211206225725.77512-6-quic_gaurkash@quicinc.com>
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

Adds support in ufshcd-core for wrapped keys.
1. Change program key vop to support wrapped key sizes by
   using blk_crypto_key directly instead of using ufs_crypto_cfg
   which is not suitable for wrapped keys.
2. Add derive_sw_secret vop and derive_sw_secret crypto_profile op.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 52 +++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h        |  9 +++++-
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 0ed82741f981..9d68621a0eb4 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -18,16 +18,23 @@ static const struct ufs_crypto_alg_entry {
 };
 
 static int ufshcd_program_key(struct ufs_hba *hba,
+			      const struct blk_crypto_key *key,
 			      const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
 	int err = 0;
+	bool evict = false;
 
 	ufshcd_hold(hba, false);
 
 	if (hba->vops && hba->vops->program_key) {
-		err = hba->vops->program_key(hba, cfg, slot);
+		if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
+			evict = true;
+		err = hba->vops->program_key(hba, key, slot,
+					     cfg->data_unit_size,
+					     cfg->crypto_cap_idx,
+					     evict);
 		goto out;
 	}
 
@@ -80,16 +87,18 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
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
@@ -103,7 +112,7 @@ static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
-	return ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, NULL, &cfg, slot);
 }
 
 static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
@@ -126,9 +135,25 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
 	return true;
 }
 
+static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
+				const u8 *wrapped_key,
+				unsigned int wrapped_key_size,
+				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->derive_secret)
+		return  hba->vops->derive_secret(hba, wrapped_key,
+						 wrapped_key_size, sw_secret);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
+	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
 };
 
 static enum blk_crypto_mode_num
@@ -190,7 +215,12 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 	hba->crypto_profile.ll_ops = ufshcd_crypto_ops;
 	/* UFS only supports 8 bytes for any DUN */
 	hba->crypto_profile.max_dun_bytes_supported = 8;
-	hba->crypto_profile.key_types_supported = BLK_CRYPTO_KEY_TYPE_STANDARD;
+	if (hba->hw_wrapped_keys_supported)
+		hba->crypto_profile.key_types_supported =
+				BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+	else
+		hba->crypto_profile.key_types_supported =
+				BLK_CRYPTO_KEY_TYPE_STANDARD;
 	hba->crypto_profile.dev = hba->dev;
 
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index df5439b12208..095c2d660aa7 100644
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
@@ -353,9 +354,14 @@ struct ufs_hba_variant_ops {
 					struct devfreq_dev_profile *profile,
 					void *data);
 	int	(*program_key)(struct ufs_hba *hba,
-			       const union ufs_crypto_cfg_entry *cfg, int slot);
+			       const struct blk_crypto_key *crypto_key,
+			       int slot, u8 data_unit_size, int capid,
+			       bool evict);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	int	(*derive_secret)(struct ufs_hba *hba, const u8 *wrapped_key,
+				 unsigned int wrapped_key_size,
+				 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 };
 
 /* clock gating state  */
@@ -906,6 +912,7 @@ struct ufs_hba {
 	union ufs_crypto_cap_entry *crypto_cap_array;
 	u32 crypto_cfg_register;
 	struct blk_crypto_profile crypto_profile;
+	bool hw_wrapped_keys_supported;
 #endif
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs_root;
-- 
2.17.1

