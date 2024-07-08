Return-Path: <linux-fscrypt+bounces-342-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0576A92ACC3
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B1F1C21613
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA28153BF8;
	Mon,  8 Jul 2024 23:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtBEJBhj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D83154452;
	Mon,  8 Jul 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482937; cv=none; b=Ao1L364nmplzXRniMcBwuqk/pq9kIpjrcd592YmWXoihP75GVB0NPAAaTvn5tKtlLWpiVjWpDBrOLZhcYHVb7KcUpfdbMSJISAMNbyknsGU4oX3c3rgxn4h2kEr+pHYwsIqGhfUVLSlSaJe193AM0Pqzc/wyTUZ23ZbSbx3O8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482937; c=relaxed/simple;
	bh=fn4+rFShGxtB+sfBV9P66AuRTIb1pLwJLIPS6WImPAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlvXs3qjDibaCdk9cDNqlYa1yCEsIy5YJB8jaGlmIHGNFfbi4pU87ciezVaLDRJ9owFp3j/opTVv1wyJwyVKHeNeEo6VYI0w5R3lGso2livlPkwrR6p8dJzSz/jGLsdQhyhJ6/Y0P8mqBhNgUsjq5d/5gjVi79xcC8XcDXtuHcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtBEJBhj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25905C4AF0B;
	Mon,  8 Jul 2024 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482937;
	bh=fn4+rFShGxtB+sfBV9P66AuRTIb1pLwJLIPS6WImPAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtBEJBhjg0b2BpTqelGWJJToLLk9hHSLZ7B8Y0pTuFSUBfe6Jx3LqteyKIYks3wIz
	 jKzngT+4g4m4bUxjiT+PnMb8TA7OLWm/ajQL4cN+uupghEAlRFW4CNG0VBc6epykfU
	 hDXTaSSQ05Zmef8c5JjbamliQkzIcbZZglf85/Yq6b6X0QfNZmUCIwxWZ2q8LYyB7A
	 e5PnTEhpk3dQT8umAqNiDG4UE2VMA2vVK2tQr4Q2l68xtxdNdsZ4XGoF0ycK6alLuO
	 AY+4PZa8db9r5uOdWjHFBzxwkqhGO+V3aHZikyktWmw2fj2hEYZQN9FsSwLaqpZq8H
	 ucTSDG/Zdm3bA==
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
Subject: [PATCH v3 6/6] scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)
Date: Mon,  8 Jul 2024 16:53:30 -0700
Message-ID: <20240708235330.103590-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240708235330.103590-1-ebiggers@kernel.org>
References: <20240708235330.103590-1-ebiggers@kernel.org>
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
 drivers/ufs/host/ufs-exynos.c | 240 +++++++++++++++++++++++++++++++++-
 1 file changed, 234 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 88d125d1ee3c..16ad3528d80b 100644
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
@@ -23,16 +26,17 @@
 #include <ufs/ufshci.h>
 #include <ufs/unipro.h>
 
 #include "ufs-exynos.h"
 
+#define DATA_UNIT_SIZE		4096
+
 /*
  * Exynos's Vendor specific registers for UFSHCI
  */
 #define HCI_TXPRDT_ENTRY_SIZE	0x00
 #define PRDT_PREFECT_EN		BIT(31)
-#define PRDT_SET_SIZE(x)	((x) & 0x1F)
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
 #define HCI_UTRL_NEXUS_TYPE	0x40
 #define HCI_UTMRL_NEXUS_TYPE	0x44
@@ -1041,12 +1045,12 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 
 	exynos_ufs_establish_connt(ufs);
 	exynos_ufs_fit_aggr_timeout(ufs);
 
 	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
-	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
-	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
+	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
+	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
 	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
 	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
 	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
 
 	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
@@ -1149,10 +1153,231 @@ static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
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
+
+/**
+ * struct fmp_sg_entry - nonstandard format of PRDT entries when FMP is enabled
+ *
+ * @base: The standard PRDT entry, but with nonstandard bitfields in the high
+ *	bits of the 'size' field, i.e. the last 32-bit word.  When these
+ *	nonstandard bitfields are zero, the data segment won't be encrypted or
+ *	decrypted.  Otherwise they specify the algorithm and key length with
+ *	which the data segment will be encrypted or decrypted.
+ * @file_iv: The initialization vector (IV) with all bytes reversed
+ * @file_enckey: The first half of the AES-XTS key with all bytes reserved
+ * @file_twkey: The second half of the AES-XTS key with all bytes reserved
+ * @disk_iv: Unused
+ * @reserved: Unused
+ */
+struct fmp_sg_entry {
+	struct ufshcd_sg_entry base;
+	__be64 file_iv[2];
+	__be64 file_enckey[4];
+	__be64 file_twkey[4];
+	__be64 disk_iv[2];
+	__be64 reserved[2];
+};
+
+#define SMC_CMD_FMP_SECURITY	\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_SIP, 0x1810)
+#define SMC_CMD_SMU		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_SIP, 0x1850)
+#define SMC_CMD_FMP_SMU_RESUME	\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_64, \
+			   ARM_SMCCC_OWNER_SIP, 0x1860)
+#define SMU_EMBEDDED			0
+#define SMU_INIT			0
+#define CFG_DESCTYPE_3			3
+
+static void exynos_ufs_fmp_init(struct ufs_hba *hba, struct exynos_ufs *ufs)
+{
+	struct blk_crypto_profile *profile = &hba->crypto_profile;
+	struct arm_smccc_res res;
+	int err;
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
+	 * The below sequence of SMC calls to enable FMP can be found in the
+	 * downstream driver source for gs101 and other Exynos-based SoCs.  It
+	 * is the only way to enable FMP that works on SoCs such as gs101 that
+	 * don't make the FMP registers accessible to Linux.  It probably works
+	 * on other Exynos-based SoCs too, and might even still be the only way
+	 * that works.  But this hasn't been properly tested, and this code is
+	 * mutually exclusive with exynos_ufs_config_smu().  So for now only
+	 * enable FMP support on SoCs with EXYNOS_UFS_OPT_UFSPR_SECURE.
+	 */
+	if (!(ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE))
+		return;
+
+	/*
+	 * This call (which sets DESCTYPE to 0x3 in the FMPSECURITY0 register)
+	 * is needed to make the hardware use the larger PRDT entry size.
+	 */
+	BUILD_BUG_ON(sizeof(struct fmp_sg_entry) != 128);
+	arm_smccc_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3,
+		      0, 0, 0, 0, &res);
+	if (res.a0) {
+		dev_warn(hba->dev,
+			 "SMC_CMD_FMP_SECURITY failed on init: %ld.  Disabling FMP support.\n",
+			 res.a0);
+		return;
+	}
+	ufshcd_set_sg_entry_size(hba, sizeof(struct fmp_sg_entry));
+
+	/*
+	 * This is needed to initialize FMP.  Without it, errors occur when
+	 * inline encryption is used.
+	 */
+	arm_smccc_smc(SMC_CMD_SMU, SMU_INIT, SMU_EMBEDDED, 0, 0, 0, 0, 0, &res);
+	if (res.a0) {
+		dev_err(hba->dev,
+			"SMC_CMD_SMU(SMU_INIT) failed: %ld.  Disabling FMP support.\n",
+			res.a0);
+		return;
+	}
+
+	/* Advertise crypto capabilities to the block layer. */
+	err = devm_blk_crypto_profile_init(hba->dev, profile, 0);
+	if (err) {
+		/* Only ENOMEM should be possible here. */
+		dev_err(hba->dev, "Failed to initialize crypto profile: %d\n",
+			err);
+		return;
+	}
+	profile->max_dun_bytes_supported = AES_BLOCK_SIZE;
+	profile->dev = hba->dev;
+	profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] =
+		DATA_UNIT_SIZE;
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
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3,
+		      0, 0, 0, 0, &res);
+	if (res.a0)
+		dev_err(hba->dev,
+			"SMC_CMD_FMP_SECURITY failed on resume: %ld\n", res.a0);
+
+	arm_smccc_smc(SMC_CMD_FMP_SMU_RESUME, 0, SMU_EMBEDDED, 0, 0, 0, 0, 0,
+		      &res);
+	if (res.a0)
+		dev_err(hba->dev,
+			"SMC_CMD_FMP_SMU_RESUME failed: %ld\n", res.a0);
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
+		if (prd->base.size != cpu_to_le32(DATA_UNIT_SIZE - 1)) {
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
+static void exynos_ufs_fmp_init(struct ufs_hba *hba, struct exynos_ufs *ufs)
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
@@ -1196,10 +1421,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	}
 
 	exynos_ufs_priv_init(hba, ufs);
 
+	exynos_ufs_fmp_init(hba, ufs);
+
 	if (ufs->drv_data->drv_init) {
 		ret = ufs->drv_data->drv_init(dev, ufs);
 		if (ret) {
 			dev_err(dev, "failed to init drv-data\n");
 			goto out;
@@ -1211,11 +1438,11 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 		goto out;
 	exynos_ufs_specify_phy_time_attr(ufs);
 	if (!(ufs->opts & EXYNOS_UFS_OPT_UFSPR_SECURE))
 		exynos_ufs_config_smu(ufs);
 
-	hba->host->dma_alignment = SZ_4K - 1;
+	hba->host->dma_alignment = DATA_UNIT_SIZE - 1;
 	return 0;
 
 out:
 	hba->priv = NULL;
 	return ret;
@@ -1330,11 +1557,11 @@ static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
 		 * The maximum segment size must be set after scsi_host_alloc()
 		 * has been called and before LUN scanning starts
 		 * (ufshcd_async_scan()). Note: this callback may also be called
 		 * from other functions than ufshcd_init().
 		 */
-		hba->host->max_segment_size = SZ_4K;
+		hba->host->max_segment_size = DATA_UNIT_SIZE;
 
 		if (ufs->drv_data->pre_hce_enable) {
 			ret = ufs->drv_data->pre_hce_enable(ufs);
 			if (ret)
 				return ret;
@@ -1430,11 +1657,11 @@ static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (!ufshcd_is_link_active(hba))
 		phy_power_on(ufs->phy);
 
 	exynos_ufs_config_smu(ufs);
-
+	exynos_ufs_fmp_resume(hba);
 	return 0;
 }
 
 static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
 						 enum ufs_notify_change_status status)
@@ -1696,10 +1923,11 @@ static const struct ufs_hba_variant_ops ufs_hba_exynos_ops = {
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


