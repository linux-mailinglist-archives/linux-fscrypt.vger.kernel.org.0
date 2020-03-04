Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E2E178AEA
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 07:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbgCDGuP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 01:50:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbgCDGuN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 01:50:13 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DD0E21744;
        Wed,  4 Mar 2020 06:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583304612;
        bh=6bHnxuhMBRQZTkaKvHiy0J1a+Is311SFjl6unYWy58g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHLf3otV+hdM+2gpwqBYvdjHULHxg2QaJTgdi2WfIDHQaP+8AqhKfp9nHFlwsr1xk
         7yT7Kf2ofXOrHSwYMYdrNXO7Hp3y0p6J29ZLtrF4M2ZRl3EeEEWN9Sjo61D46GKnqJ
         i7j7jKyyTS3N5RtEHjiAtN8n+5LkngsTtlQHkC90=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [RFC PATCH v2 3/4] scsi: ufs: add program_key() variant op
Date:   Tue,  3 Mar 2020 22:49:41 -0800
Message-Id: <20200304064942.371978-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304064942.371978-1-ebiggers@kernel.org>
References: <20200304064942.371978-1-ebiggers@kernel.org>
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
 drivers/scsi/ufs/ufshcd-crypto.c | 34 +++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index cd7ca50a1dd9..7c50d1d4f58c 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -131,14 +131,20 @@ static int ufshcd_crypto_cfg_entry_write_key(union ufs_crypto_cfg_entry *cfg,
 	return -EINVAL;
 }
 
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
@@ -151,23 +157,28 @@ static void ufshcd_program_key(struct ufs_hba *hba,
 	/* Dword 16 must be written last */
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
+out:
 	ufshcd_release(hba);
+	return err;
 }
 
-static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
+static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 {
 	union ufs_crypto_cfg_entry cfg = { 0 };
 
-	ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, &cfg, slot);
 }
 
 /* Clear all keyslots at driver init time */
 static void ufshcd_clear_all_keyslots(struct ufs_hba *hba)
 {
 	int slot;
+	int err;
 
-	for (slot = 0; slot < ufshcd_num_keyslots(hba); slot++)
-		ufshcd_clear_keyslot(hba, slot);
+	for (slot = 0; slot < ufshcd_num_keyslots(hba); slot++) {
+		err = ufshcd_clear_keyslot(hba, slot);
+		WARN_ON_ONCE(err);
+	}
 }
 
 static int ufshcd_crypto_keyslot_program(struct keyslot_manager *ksm,
@@ -203,10 +214,11 @@ static int ufshcd_crypto_keyslot_program(struct keyslot_manager *ksm,
 	if (err)
 		return err;
 
-	ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return 0;
+
+	return err;
 }
 
 static int ufshcd_crypto_keyslot_evict(struct keyslot_manager *ksm,
@@ -223,9 +235,7 @@ static int ufshcd_crypto_keyslot_evict(struct keyslot_manager *ksm,
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
-	ufshcd_clear_keyslot(hba, slot);
-
-	return 0;
+	return ufshcd_clear_keyslot(hba, slot);
 }
 
 void ufshcd_crypto_enable(struct ufs_hba *hba)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c8f948aa5e3d..c2656575e24b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -306,6 +306,7 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
+ * @program_key: program or evict an inline encryption key
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -335,6 +336,8 @@ struct ufs_hba_variant_ops {
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
 	void	(*device_reset)(struct ufs_hba *hba);
+	int	(*program_key)(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int slot);
 };
 
 /* clock gating state  */
-- 
2.25.1

