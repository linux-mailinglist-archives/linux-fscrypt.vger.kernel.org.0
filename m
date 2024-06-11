Return-Path: <linux-fscrypt+bounces-314-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51EA790470C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3470B22FE8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8EFB155C87;
	Tue, 11 Jun 2024 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inm5qZPs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6B3155A5D;
	Tue, 11 Jun 2024 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145342; cv=none; b=b0hWVfVmzATSibmcrL0Kbu1KWoOhs53Y00/zDketENyiOegK9nXSuOSjpsb5iWTnOcGbdaWcjf1RtBf4l5YjPUd+A8Y4aR6yA2iOup2DHoWds2xEskJeLwRKhUT5mAXZc1c05vrc+aFdTwBs12UK3+5R5Y5zRjG6ZWmTdkiNbzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145342; c=relaxed/simple;
	bh=4tEuqrAcgZtsBsOs4iafGri1iafX3gtInXu87ZPA0rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCQ9wsKUOtle9vfp8vyNo8pah4FcKMODNAdTA26XcUCcn5TG9KZOjfvwXi0C9OIDgpe/KAMvxupeJ1XyTPgwEML0plH8xisRPydBYwYXkoPJFDGQuoqDaa7KDSv0/hWM+OE5UQrGBmOpu0S1ISaN5juGBHHiVLx58WZYsIO8u64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inm5qZPs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199AAC4AF48;
	Tue, 11 Jun 2024 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145342;
	bh=4tEuqrAcgZtsBsOs4iafGri1iafX3gtInXu87ZPA0rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inm5qZPsymf3Ss/IffBaKSwvlrD7s8xrQxZ2jle/1XKc+PMPjIRHS80cnplK3P+YW
	 1SZRmJTJU/xv0WYMnYMA9cNBP5O4awNfDdML8a4PTM6HkiHJQxVlkgnT5Gn/tMcfqk
	 XponH0F96DImIUZB3v+sPq2iAsG/sxmp4s97W0upPKyDx4CSso0PNHR+XFu3RsVSNR
	 w1dmc8m8rZGLOxivugmM0By8j4FFSyJry+rHFcSlDW0bteLQ1izlxqtXVW/kkeBfbT
	 lqI4XOQ7kp+q8V5IMA69rAZDvEMdDepwRDBXpyE3rDJF/7DPFPA4N198akuWoKx9hu
	 CgjSj9oSqTb3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: [PATCH 6/6] scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)
Date: Tue, 11 Jun 2024 15:34:19 -0700
Message-ID: <20240611223419.239466-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240611223419.239466-1-ebiggers@kernel.org>
References: <20240611223419.239466-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add support for Flash Memory Protector (FMP), which is the inline
encryption hardware on Exynos and Exynos-based SoCs.

Specifically, add support for the "traditional FMP mode" that works on
many Exynos-based SoCs including gs101.  This is the mode that uses
"software keys" and is compatible with the upstream kernel's existing
inline encryption framework in the block and filesystem layers.  I plan
to add support for the wrapped key support on gs101 at a later time.

Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
xfstests on a filesystem mounted with the 'inlinecrypt' mount option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-exynos.c | 219 +++++++++++++++++++++++++++++++++-
 1 file changed, 218 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 88d125d1ee3c..969c4eedbe2d 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -6,10 +6,13 @@
  * Author: Seungwon Jeon  <essuuj@gmail.com>
  * Author: Alim Akhtar <alim.akhtar@samsung.com>
  *
  */
 
+#include <asm/unaligned.h>
+#include <crypto/aes.h>
+#include <linux/arm-smccc.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -1149,10 +1152,221 @@ static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
 		ufs->rx_sel_idx = 0;
 	hba->priv = (void *)ufs;
 	hba->quirks = ufs->drv_data->quirks;
 }
 
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+
+/*
+ * Support for Flash Memory Protector (FMP), which is the inline encryption
+ * hardware on Exynos and Exynos-based SoCs.  The interface to this hardware is
+ * not compatible with the standard UFS crypto.  It requires that encryption be
+ * configured in the PRDT using a nonstandard extension.
+ */
+
+enum fmp_crypto_algo_mode {
+	FMP_BYPASS_MODE = 0,
+	FMP_ALGO_MODE_AES_CBC = 1,
+	FMP_ALGO_MODE_AES_XTS = 2,
+};
+enum fmp_crypto_key_length {
+	FMP_KEYLEN_256BIT = 1,
+};
+#define FMP_DATA_UNIT_SIZE	SZ_4K
+
+/* This is the nonstandard format of PRDT entries when FMP is enabled. */
+struct fmp_sg_entry {
+
+	/*
+	 * This is the standard PRDT entry, but with nonstandard bitfields in
+	 * the high bits of the 'size' field, i.e. the last 32-bit word.  When
+	 * these nonstandard bitfields are zero, the data segment won't be
+	 * encrypted or decrypted.  Otherwise they specify the algorithm and key
+	 * length with which the data segment will be encrypted or decrypted.
+	 */
+	struct ufshcd_sg_entry base;
+
+	/* The initialization vector (IV) with all bytes reversed */
+	__be64 file_iv[2];
+
+	/*
+	 * The key with all bytes reversed.  For XTS, the two halves of the key
+	 * are given separately and are byte-reversed separately.
+	 */
+	__be64 file_enckey[4];
+	__be64 file_twkey[4];
+
+	/* Unused */
+	__be64 disk_iv[2];
+	__be64 reserved[2];
+};
+
+#define SMC_CMD_FMP_SECURITY		0xC2001810
+#define SMC_CMD_SMU			0xC2001850
+#define SMC_CMD_FMP_SMU_RESUME		0xC2001860
+#define SMU_EMBEDDED			0
+#define SMU_INIT			0
+#define CFG_DESCTYPE_3			3
+
+static inline long exynos_smc(unsigned long cmd, unsigned long arg0,
+			      unsigned long arg1, unsigned long arg2)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(cmd, arg0, arg1, arg2, 0, 0, 0, 0, &res);
+	return res.a0;
+}
+
+static void exynos_ufs_fmp_init(struct ufs_hba *hba)
+{
+	struct blk_crypto_profile *profile = &hba->crypto_profile;
+	long ret;
+
+	/*
+	 * Check for the standard crypto support bit, since it's available even
+	 * though the rest of the interface to FMP is nonstandard.
+	 *
+	 * This check should have the effect of preventing the driver from
+	 * trying to use FMP on old Exynos SoCs that don't have FMP.
+	 */
+	if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
+	      MASK_CRYPTO_SUPPORT))
+		return;
+
+	/*
+	 * This call (which sets DESCTYPE to 0x3 in the FMPSECURITY0 register)
+	 * is needed to make the hardware use the larger PRDT entry size.
+	 */
+	BUILD_BUG_ON(sizeof(struct fmp_sg_entry) != 128);
+	ret = exynos_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3);
+	if (ret) {
+		dev_warn(hba->dev,
+			 "SMC_CMD_FMP_SECURITY failed on init: %ld.  Disabling FMP support.\n",
+			 ret);
+		return;
+	}
+	ufshcd_set_sg_entry_size(hba, sizeof(struct fmp_sg_entry));
+
+	/*
+	 * This is needed to initialize FMP.  Without it, errors occur when
+	 * inline encryption is used.
+	 */
+	ret = exynos_smc(SMC_CMD_SMU, SMU_INIT, SMU_EMBEDDED, 0);
+	if (ret) {
+		dev_err(hba->dev,
+			"SMC_CMD_SMU(SMU_INIT) failed: %ld.  Disabling FMP support.\n",
+			ret);
+		return;
+	}
+
+	/* Advertise crypto capabilities to the block layer. */
+	ret = devm_blk_crypto_profile_init(hba->dev, profile, 0);
+	if (ret) {
+		/* Only ENOMEM should be possible here. */
+		dev_err(hba->dev, "Failed to initialize crypto profile: %ld\n",
+			ret);
+		return;
+	}
+	profile->max_dun_bytes_supported = AES_BLOCK_SIZE;
+	profile->dev = hba->dev;
+	profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] =
+		FMP_DATA_UNIT_SIZE;
+
+	/* Advertise crypto support to ufshcd-core. */
+	hba->caps |= UFSHCD_CAP_CRYPTO;
+
+	/* Advertise crypto quirks to ufshcd-core. */
+	hba->quirks |= UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE |
+		       UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE |
+		       UFSHCD_QUIRK_KEYS_IN_PRDT;
+
+}
+
+static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
+{
+	long ret;
+
+	ret = exynos_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3);
+	if (ret)
+		dev_err(hba->dev,
+			"SMC_CMD_FMP_SECURITY failed on resume: %ld\n", ret);
+
+	ret = exynos_smc(SMC_CMD_FMP_SMU_RESUME, 0, SMU_EMBEDDED, 0);
+	if (ret)
+		dev_err(hba->dev, "SMC_CMD_FMP_SMU_RESUME failed: %ld\n", ret);
+}
+
+static inline __be64 fmp_key_word(const u8 *key, int j)
+{
+	return cpu_to_be64(get_unaligned_le64(
+			key + AES_KEYSIZE_256 - (j + 1) * sizeof(u64)));
+}
+
+/* Fill the PRDT for a request according to the given encryption context. */
+static int exynos_ufs_fmp_fill_prdt(struct ufs_hba *hba,
+				    const struct bio_crypt_ctx *crypt_ctx,
+				    void *prdt, unsigned int num_segments)
+{
+	struct fmp_sg_entry *fmp_prdt = prdt;
+	const u8 *enckey = crypt_ctx->bc_key->raw;
+	const u8 *twkey = enckey + AES_KEYSIZE_256;
+	u64 dun_lo = crypt_ctx->bc_dun[0];
+	u64 dun_hi = crypt_ctx->bc_dun[1];
+	unsigned int i;
+
+	/* If FMP wasn't enabled, we shouldn't get any encrypted requests. */
+	if (WARN_ON_ONCE(!(hba->caps & UFSHCD_CAP_CRYPTO)))
+		return -EIO;
+
+	/* Configure FMP on each segment of the request. */
+	for (i = 0; i < num_segments; i++) {
+		struct fmp_sg_entry *prd = &fmp_prdt[i];
+		int j;
+
+		/* Each segment must be exactly one data unit. */
+		if (prd->base.size != cpu_to_le32(FMP_DATA_UNIT_SIZE - 1)) {
+			dev_err(hba->dev,
+				"data segment is misaligned for FMP\n");
+			return -EIO;
+		}
+
+		/* Set the algorithm and key length. */
+		prd->base.size |= cpu_to_le32((FMP_ALGO_MODE_AES_XTS << 28) |
+					      (FMP_KEYLEN_256BIT << 26));
+
+		/* Set the IV. */
+		prd->file_iv[0] = cpu_to_be64(dun_hi);
+		prd->file_iv[1] = cpu_to_be64(dun_lo);
+
+		/* Set the key. */
+		for (j = 0; j < AES_KEYSIZE_256 / sizeof(u64); j++) {
+			prd->file_enckey[j] = fmp_key_word(enckey, j);
+			prd->file_twkey[j] = fmp_key_word(twkey, j);
+		}
+
+		/* Increment the data unit number. */
+		dun_lo++;
+		if (dun_lo == 0)
+			dun_hi++;
+	}
+	return 0;
+}
+
+#else /* CONFIG_SCSI_UFS_CRYPTO */
+
+static void exynos_ufs_fmp_init(struct ufs_hba *hba)
+{
+}
+
+static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
+{
+}
+
+#define exynos_ufs_fmp_fill_prdt NULL
+
+#endif /* !CONFIG_SCSI_UFS_CRYPTO */
+
 static int exynos_ufs_init(struct ufs_hba *hba)
 {
 	struct device *dev = hba->dev;
 	struct platform_device *pdev = to_platform_device(dev);
 	struct exynos_ufs *ufs;
@@ -1196,10 +1410,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	}
 
 	exynos_ufs_priv_init(hba, ufs);
 
+	exynos_ufs_fmp_init(hba);
+
 	if (ufs->drv_data->drv_init) {
 		ret = ufs->drv_data->drv_init(dev, ufs);
 		if (ret) {
 			dev_err(dev, "failed to init drv-data\n");
 			goto out;
@@ -1430,11 +1646,11 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (!ufshcd_is_link_active(hba))
 		phy_power_on(ufs->phy);
 
 	exynos_ufs_config_smu(ufs);
-
+	exynos_ufs_fmp_resume(hba);
 	return 0;
 }
 
 static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
 						 enum ufs_notify_change_status status)
@@ -1696,10 +1912,11 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
 	.setup_xfer_req			= exynos_ufs_specify_nexus_t_xfer_req,
 	.setup_task_mgmt		= exynos_ufs_specify_nexus_t_tm_req,
 	.hibern8_notify			= exynos_ufs_hibern8_notify,
 	.suspend			= exynos_ufs_suspend,
 	.resume				= exynos_ufs_resume,
+	.fill_crypto_prdt		= exynos_ufs_fmp_fill_prdt,
 };
 
 static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = {
 	.name				= "exynosauto_ufs_vh",
 	.init				= exynosauto_ufs_vh_init,
-- 
2.45.2


