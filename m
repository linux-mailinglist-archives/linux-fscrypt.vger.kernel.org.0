Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417C621B00D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jul 2020 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGJHV6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jul 2020 03:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgGJHVu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jul 2020 03:21:50 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55FD1207FF;
        Fri, 10 Jul 2020 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594365709;
        bh=o22e2TW6JQjy0MLmd7zcmQD+bUiFHpfzuZIB5OEGOAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Or3dTAjGEL13asNZ8v9n5QxdYgntUZLfirZ0Xde0i3oAjU5doEFqSTESBj7tqnRMY
         hxiYaQpW+5Ba0ONpRqSIphvy3oKFXC1v1rKJIfc8HDWOMcjQKHUomYGsymqlDRO8y6
         67NEztd5r9KraWxa3ikX9xytWv/EPEAMP2nW94M8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v6 4/5] scsi: ufs: add program_key() variant op
Date:   Fri, 10 Jul 2020 00:20:11 -0700
Message-Id: <20200710072013.177481-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710072013.177481-1-ebiggers@kernel.org>
References: <20200710072013.177481-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

On Snapdragon SoCs, the Linux kernel isn't permitted to directly access
the standard UFS crypto configuration registers.  Instead, programming
and evicting keys must be done through vendor-specific SMC calls.

To support this hardware, add a ->program_key() method to
'struct ufs_hba_variant_ops'.  This allows overriding the UFS standard
key programming / eviction procedure.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 27 +++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 98ff87c38aa7..d2edbd960ebf 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -17,14 +17,20 @@ static const struct ufs_crypto_alg_entry {
 	},
 };
 
-static void ufshcd_program_key(struct ufs_hba *hba,
-			       const union ufs_crypto_cfg_entry *cfg,
-			       int slot)
+static int ufshcd_program_key(struct ufs_hba *hba,
+			      const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
+	int err = 0;
 
 	ufshcd_hold(hba, false);
+
+	if (hba->vops && hba->vops->program_key) {
+		err = hba->vops->program_key(hba, cfg, slot);
+		goto out;
+	}
+
 	/* Ensure that CFGE is cleared before programming the key */
 	ufshcd_writel(hba, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	for (i = 0; i < 16; i++) {
@@ -37,7 +43,9 @@ static void ufshcd_program_key(struct ufs_hba *hba,
 	/* Dword 16 must be written last */
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
+out:
 	ufshcd_release(hba);
+	return err;
 }
 
 static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
@@ -52,6 +60,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 	int i;
 	int cap_idx = -1;
 	union ufs_crypto_cfg_entry cfg = { 0 };
+	int err;
 
 	BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
@@ -79,13 +88,13 @@ static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return 0;
+	return err;
 }
 
-static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
+static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 {
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
@@ -93,7 +102,7 @@ static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 	 */
 	union ufs_crypto_cfg_entry cfg = { 0 };
 
-	ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, &cfg, slot);
 }
 
 static int ufshcd_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
@@ -102,9 +111,7 @@ static int ufshcd_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
 {
 	struct ufs_hba *hba = container_of(ksm, struct ufs_hba, ksm);
 
-	ufshcd_clear_keyslot(hba, slot);
-
-	return 0;
+	return ufshcd_clear_keyslot(hba, slot);
 }
 
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 656c0691c858..b2ef18f1b746 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -281,6 +281,7 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
+ * @program_key: program or evict an inline encryption key
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -314,6 +315,8 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
+	int	(*program_key)(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int slot);
 };
 
 /* clock gating state  */
-- 
2.27.0

