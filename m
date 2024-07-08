Return-Path: <linux-fscrypt+bounces-339-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A087492ACBA
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D319B1C216DC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B534715382F;
	Mon,  8 Jul 2024 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd/HR0lF"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C557153824;
	Mon,  8 Jul 2024 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482936; cv=none; b=bnkYnX9SG4TCKRnekuMEhFCUofHOW86BG0o4ehDGnGdn8DeL06ftHVOVXB5DRAYrbjqEC+Hb/CKGiHVIzMTMydV/XIR+hjieWgcesOB6K+Z1z7wlLS363bF51ALbp4Pr8/Cqwxbbdm0DQdk+4c2LVFqbbGf02GxOBfhRf9EzJmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482936; c=relaxed/simple;
	bh=gtwZfwrWX7QVlTTO6ZcXKsCa7LORXzdHB8PDjB63zmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwVb/16mzPchwx5C57csDphfuZX+I0Ad2SQDRM/HrOXxq5WiSXvSMM380QFRChJq0+E88fTfR6gLPI3Vick2FM+PbDgtW59ceEi3a0aWVDNIhp/K0iMt6bzEyooF654Pj+B+5XT5n4K9fIbF0TD06AzYWIXGuvBF0QbmE79pX7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pd/HR0lF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2209C3277B;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482936;
	bh=gtwZfwrWX7QVlTTO6ZcXKsCa7LORXzdHB8PDjB63zmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pd/HR0lFw78JXz16HC/0qqFRhpbwXmyLfOoQnvy6BQFVVsmvGwHrEE/vj3+dzUVeC
	 V8qE6em5jm3CElWGjSnsfjbYc0FGlVR6mnkqUnbXmiUh0WoGd8Bvo7sNNELpzHuWi0
	 hOXUdHCW49OGO4mTRCLNkCxufKBTKhGXiJwInT3zGCBNge7bX14hV2IKEyOVv6sIQ/
	 bOpS9NBJwgFiKiUNVm/WYtGg2Hr0BEBZtqjirEtn/Kn8bfAvUfKXunA/yWryzD6YDu
	 wwK65/3PVxR4tKXvBYRMXJStEH6vfDnB4mvjXzvsVLmVevCTSzj3A1R1QCZpeYKxyo
	 SqFOgaYPT1+0w==
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
Subject: [PATCH v3 3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
Date: Mon,  8 Jul 2024 16:53:27 -0700
Message-ID: <20240708235330.103590-4-ebiggers@kernel.org>
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

Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not
use the crypto enable bit defined by the UFS specification.  This is
needed to support inline encryption on the "Exynos" UFS controller.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 8 ++++++++
 include/ufs/ufshcd.h             | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index b4980fd91cee..a714dad82cd1 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -108,17 +108,25 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	union ufs_crypto_cfg_entry cfg = {};
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }
 
+/*
+ * Reprogram the keyslots if needed, and return true if CRYPTO_GENERAL_ENABLE
+ * should be used in the host controller initialization sequence.
+ */
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return false;
 
 	/* Reset might clear all keys, so reprogram all the keys. */
 	blk_crypto_reprogram_all_keys(&hba->crypto_profile);
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE)
+		return false;
+
 	return true;
 }
 
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index b354a7eee478..4b7ad23a4420 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -650,10 +650,17 @@ enum ufshcd_quirks {
 	 * nonstandard way and/or needs to override blk_crypto_ll_ops.  If
 	 * enabled, the standard code won't initialize the blk_crypto_profile;
 	 * ufs_hba_variant_ops::init() must do it instead.
 	 */
 	UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE		= 1 << 22,
+
+	/*
+	 * This quirk needs to be enabled if the host controller supports inline
+	 * encryption but does not support the CRYPTO_GENERAL_ENABLE bit, i.e.
+	 * host controller initialization fails if that bit is set.
+	 */
+	UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE		= 1 << 23,
 };
 
 enum ufshcd_caps {
 	/* Allow dynamic clk gating */
 	UFSHCD_CAP_CLK_GATING				= 1 << 0,
-- 
2.45.2


