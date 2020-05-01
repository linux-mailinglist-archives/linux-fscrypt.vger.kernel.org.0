Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677E41C0D91
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 May 2020 06:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgEAEwP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 1 May 2020 00:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728189AbgEAEwL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 1 May 2020 00:52:11 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 913EC208D6;
        Fri,  1 May 2020 04:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588308731;
        bh=bT880EEXs0fKR4ILh2vk5kOLo3OK3oN9QMj2UANXsic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ihecekw1FRZOL29oZvdmSR+oXN5m9XYzF+b/W+PictBeMx0QhgsWWljtQIOW0wwYX
         l44SxXEQ8iSXH+9lVE1vD2egMfYXmAKoP35I0AnJemVfuRy3fQBtbpl5e5Y4e5LBlS
         Bf7xZPnIzinG9H3kPyIbO9CPrw0/BSeNmzUhli7Q=
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
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH v4 3/4] scsi: ufs: add program_key() variant op
Date:   Thu, 30 Apr 2020 21:51:10 -0700
Message-Id: <20200501045111.665881-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501045111.665881-1-ebiggers@kernel.org>
References: <20200501045111.665881-1-ebiggers@kernel.org>
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
index 65a3115d2a2d47..717a7eb6298839 100644
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
index 8de208b74f95fc..0d424f59952169 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -319,6 +319,7 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
+ * @program_key: program or evict an inline encryption key
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -351,6 +352,8 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 					struct devfreq_dev_profile *profile,
 					void *data);
+	int	(*program_key)(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int slot);
 };
 
 /* clock gating state  */
-- 
2.26.2

