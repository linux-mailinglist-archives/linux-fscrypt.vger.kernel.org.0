Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9E7136748
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2020 07:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgAJGS3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jan 2020 01:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:52848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731465AbgAJGS2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jan 2020 01:18:28 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88D920838;
        Fri, 10 Jan 2020 06:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578637107;
        bh=CXnjOYm1iTDjojjdsIRWTNlwicfcXj4LVXbnFJeFR2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmb0Iyc9tu/rxA/ezfektn4+xbD8O/KI0wSPSI6WPESopr4jFdCCoLqlj1ssipQ5D
         +iQVFzbMgld/0e+uZf4U7ONdoaINq/8u9n4qsttx1wep3Uh8KjmwhNTZjkGT7vDQnu
         A0jG1DmClF5SdOEZwAkqU5xwfK8UYIRoFfhHwLmw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 4/5] scsi: ufs: add program_key() variant op
Date:   Thu,  9 Jan 2020 22:16:33 -0800
Message-Id: <20200110061634.46742-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110061634.46742-1-ebiggers@kernel.org>
References: <20200110061634.46742-1-ebiggers@kernel.org>
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
key programming procedure.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 24 ++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h        |  5 +++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 2c34beb47f8e0..4b9e4d5770643 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -117,15 +117,21 @@ static int ufshcd_crypto_cfg_entry_write_key(union ufs_crypto_cfg_entry *cfg,
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
+	int err;
 
 	pm_runtime_get_sync(hba->dev);
 	ufshcd_hold(hba, false);
+
+	if (hba->vops->program_key) {
+		err = hba->vops->program_key(hba, cfg, slot);
+		goto out;
+	}
+
 	/* Clear the dword 16 */
 	ufshcd_writel(hba, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	/* Ensure that CFGE is cleared before programming the key */
@@ -145,15 +151,20 @@ static void ufshcd_program_key(struct ufs_hba *hba,
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	wmb();
+	err = 0;
+out:
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
+	return err;
 }
 
 static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 {
 	union ufs_crypto_cfg_entry cfg = { 0 };
+	int err;
 
-	ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, &cfg, slot);
+	WARN_ON_ONCE(err);
 }
 
 /* Clear all keyslots at driver init time */
@@ -198,10 +209,11 @@ static int ufshcd_crypto_keyslot_program(struct keyslot_manager *ksm,
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
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b6f0d08a98a8b..cd0969b93d070 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -280,6 +280,8 @@ struct ufs_pwr_mode_info {
 	struct ufs_pa_layer_attr info;
 };
 
+union ufs_crypto_cfg_entry;
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
@@ -307,6 +309,7 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
+ * @program_key: program an inline encryption key into a keyslot
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -336,6 +339,8 @@ struct ufs_hba_variant_ops {
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
 	void	(*device_reset)(struct ufs_hba *hba);
+	int	(*program_key)(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int slot);
 };
 
 /* clock gating state  */
-- 
2.24.1

