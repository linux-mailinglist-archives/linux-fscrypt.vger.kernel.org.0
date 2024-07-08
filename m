Return-Path: <linux-fscrypt+bounces-337-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3412992ACB4
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38D6282AA9
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21B515357F;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bp0kX3Bu"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C4A153519;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482935; cv=none; b=UjB17qV66PU1zcRm9AgVeLGOFB630yXp21u3dU1Ew1JpHNjZUF2rJzBFN4FO64rZ/82ywupmPbkJ0T0sfaY3MrqbKUdK4KdplVe+/6v5k/BQNLdJIWHCmslKFC0vVxKiR/YDrrhfmtGst1VV5FWhxjw5nVUen7Rkh2NpncgDVR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482935; c=relaxed/simple;
	bh=3peJxhHK/vVgaboxdpncX7cnMfoAypiLOG3NRGzdzLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcYB7vgWhr+xQsgrhlZ2cxv5gsHCUsPfOPpaQlgxZpBhIHb+0fCEN+MRwuEUL60H24mizB+wTknhOa4Nx54Fo25Eo6fs7tgQW20mPL7nYA9mtWR37WjU/VDEv35k78Egbkh2hGHuZLxCINCR3Q/8bT8lr/Qgzj0k3G9dzGZdoRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bp0kX3Bu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E0DC4AF0B;
	Mon,  8 Jul 2024 23:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482935;
	bh=3peJxhHK/vVgaboxdpncX7cnMfoAypiLOG3NRGzdzLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp0kX3BucPrcX65x5RrZYmT1onIaVc8w5U936gCpepdmo/MAZZDI8U391JTEOE8NG
	 DivUTXUavoyx4WbUWEHan7zUgb4+b/uGIhhDlQVkKRQo4oI6pIOLqJ5X3vgy68vpN7
	 koFAe/1qS3WurmrvHCPYEkfX0ki8jT8qmkcfVTqmCkiMrp+mTrHmfNt4Zqr5ronKNg
	 bH1mGNqNNBUeFziWgvqT2+grDhhSU57KZX8O8NrOAqU7LcqFkFrQDooDawJ+8IYxqV
	 4WEImaUzj6AFhTJYpUUwVSuCAn5Vu87tXss8Rtve+PYEM0Fkvku4Y66IHbBadnxD4w
	 Ys9IUQEebX5TQ==
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
Subject: [PATCH v3 1/6] scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
Date: Mon,  8 Jul 2024 16:53:25 -0700
Message-ID: <20240708235330.103590-2-ebiggers@kernel.org>
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

Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE which lets UFS host drivers
initialize the blk_crypto_profile themselves rather than have it be
initialized by ufshcd-core according to the UFSHCI standard.  This is
needed to support inline encryption on the "Exynos" UFS controller which
has a nonstandard interface.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 10 +++++++---
 include/ufs/ufshcd.h             |  9 +++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index f2c4422cab86..debc925ae439 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -157,10 +157,13 @@ int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba)
 {
 	int cap_idx;
 	int err = 0;
 	enum blk_crypto_mode_num blk_mode_num;
 
+	if (hba->quirks & UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE)
+		return 0;
+
 	/*
 	 * Don't use crypto if either the hardware doesn't advertise the
 	 * standard crypto capability bit *or* if the vendor specific driver
 	 * hasn't advertised that crypto is supported.
 	 */
@@ -226,13 +229,14 @@ void ufshcd_init_crypto(struct ufs_hba *hba)
 	int slot;
 
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return;
 
-	/* Clear all keyslots - the number of keyslots is (CFGC + 1) */
-	for (slot = 0; slot < hba->crypto_capabilities.config_count + 1; slot++)
-		ufshcd_clear_keyslot(hba, slot);
+	/* Clear all keyslots. */
+	for (slot = 0; slot < hba->crypto_profile.num_slots; slot++)
+		hba->crypto_profile.ll_ops.keyslot_evict(&hba->crypto_profile,
+							 NULL, slot);
 }
 
 void ufshcd_crypto_register(struct ufs_hba *hba, struct request_queue *q)
 {
 	if (hba->caps & UFSHCD_CAP_CRYPTO)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bad88bd91995..b354a7eee478 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -641,10 +641,19 @@ enum ufshcd_quirks {
 	/*
 	 * Some host does not implement SQ Run Time Command (SQRTC) register
 	 * thus need this quirk to skip related flow.
 	 */
 	UFSHCD_QUIRK_MCQ_BROKEN_RTC			= 1 << 21,
+
+	/*
+	 * This quirk needs to be enabled if the host controller supports inline
+	 * encryption but it needs to initialize the crypto capabilities in a
+	 * nonstandard way and/or needs to override blk_crypto_ll_ops.  If
+	 * enabled, the standard code won't initialize the blk_crypto_profile;
+	 * ufs_hba_variant_ops::init() must do it instead.
+	 */
+	UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE		= 1 << 22,
 };
 
 enum ufshcd_caps {
 	/* Allow dynamic clk gating */
 	UFSHCD_CAP_CLK_GATING				= 1 << 0,
-- 
2.45.2


