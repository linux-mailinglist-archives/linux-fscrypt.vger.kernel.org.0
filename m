Return-Path: <linux-fscrypt+bounces-309-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640829046FE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 039DC2834FA
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5CF155381;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTfeTQiV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE4C15531E;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145340; cv=none; b=lFNzOQJpNui9G9xhemMW1gXyqrdpFQ0yxXaiwb7ITL1ICYkNhFfR8hQEWBzz5wEy9SuApuoZEvgmqSZN0EMwSZFpwNuOGQ+/M9OAJ0W54yROJzNtJq3+4xx3lw6RxGF5ec+q3jRaQahcJqquPhsOf4U748Lbp/Gne7llkT+eqYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145340; c=relaxed/simple;
	bh=7VrPUFJQpUoDtO+PXZdRTKQEsnnIGEdH+lnN9iF3+LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoA25aH0VxJqfPCmYfXKH24Prw2czg1yur7Gz+04hcChYzyFrgXKAK5pWwQ1by1H7vcCFQKm2n7AKw0/WR+PWiyFOb3VxkIfs4uy4R10xM1GDX8sW6gk13xBS4A4YK8l/YhQjrcRdpvylV8JFX/k3WGWzweNJ4FXGG5rU7reTXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTfeTQiV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC723C4AF1C;
	Tue, 11 Jun 2024 22:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145340;
	bh=7VrPUFJQpUoDtO+PXZdRTKQEsnnIGEdH+lnN9iF3+LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTfeTQiVZloNpNJzODcy4AuAc+J0mqfA8rHK7KnlcNNlX1sbgmFjPSZoo20gJdqsH
	 CjnwHeTDcNxTe13vJ4ir8u2MKIRE3sNEH8QeROpDxMyu927Gd+B5DuJP5B14JCGeve
	 bB9HFaT4azs8LNye7oPkRW3CXP/r5o0Z9wbFP8nLfH1jWNqMC79yM8+21R46FWzugX
	 EnBiulhhwtot6n4E8Y9WGtfK0ftLNkzWlnlaiitnSCoX/lwLscPb5twKgi6ARMzz/D
	 w4QItzziqQ65numWJX0k7+t+DDGHchJZMXHVR8noaXdA4CKTHip2nm1rhKux0dGE64
	 1nbbPATzBKC/A==
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
Subject: [PATCH 1/6] scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
Date: Tue, 11 Jun 2024 15:34:14 -0700
Message-ID: <20240611223419.239466-2-ebiggers@kernel.org>
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

Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE which lets UFS host drivers
initialize the blk_crypto_profile themselves rather than have it be
initialized by ufshcd-core according to the UFSHCI standard.  This is
needed to support inline encryption on the "Exynos" UFS controller which
has a nonstandard interface.

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

base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.45.2


