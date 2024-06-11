Return-Path: <linux-fscrypt+bounces-313-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A5090470B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07DDD1C23227
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F97155C92;
	Tue, 11 Jun 2024 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChUN+Hl1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DF5155C80;
	Tue, 11 Jun 2024 22:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145342; cv=none; b=Db3U1TM5b5M9xHozcs5oZITV5I77GrNiAsUIq3FcN7dj7sIejC/XacD22xxyca+Quo5Jw/qbqH5l2BfSeQj+ahuNVB4h0IKCBsnk+smV3COhRppu893/MzThbmAW0vRU5LKR7ZyK+f2swQzBDGaXj5U50fn8r3UglVMjkAl3WD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145342; c=relaxed/simple;
	bh=uLgd/ay0FcbtDF6bgTmIf7jaAQbU5UzGDgBMZx7c9fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urj/fHujzXLFXR68crWeL9UtvVhM0b37qWARYs4SWUm/m6CAq9aSbyOMApI8vC4uigC2PEeG/Btam/RLfaKxH8h4l3EMKs9IuEgPxuTEM/wbTdkH7EPBkfcPXV8xCKPoekdB/k1HxH8DKdmN8XKOK2pO3fTwRrOAUqYXNgQ9h74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChUN+Hl1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E10C4AF1C;
	Tue, 11 Jun 2024 22:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145341;
	bh=uLgd/ay0FcbtDF6bgTmIf7jaAQbU5UzGDgBMZx7c9fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChUN+Hl1lGVFVM2zroVMq8JmvgZE/tkv0jYMA6kaTf9oG5FY8tcNDN075fwc0Y7qC
	 ZIeJ2/LxZk7SsLhGQfPX8G/7IIH2TrHqwSupoprqYjUXmDqpSnB+A0E25PpxmUqg66
	 Ry0OOnhKBMsv6kqppb6eM1/YNs980azI68ufX4EQObibaWQdkEBVPFmuHwNhj/Njau
	 c4ARDJAzncpOHSQbIhp0Z9HeX4HK1bRCvxeYZQ2SihcG45QNepWOKXVW7SNh7RzksM
	 AqX15lcxPFq4XB6gw7CWO6VjLVU2WuNEHmf/9A2g09jgmG9kIJUG1NyN2A5h8juG8P
	 z1Y6z+hMau9pg==
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
Subject: [PATCH 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
Date: Tue, 11 Jun 2024 15:34:18 -0700
Message-ID: <20240611223419.239466-6-ebiggers@kernel.org>
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

Since the nonstandard inline encryption support on Exynos SoCs requires
that raw cryptographic keys be copied into the PRDT, it is desirable to
zeroize those keys after each request to keep them from being left in
memory.  Therefore, add a quirk bit that enables the zeroization.

We could instead do the zeroization unconditionally.  However, using a
quirk bit avoids adding the zeroization overhead to standard devices.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.h | 17 +++++++++++++++++
 drivers/ufs/core/ufshcd.c        |  1 +
 include/ufs/ufshcd.h             |  8 ++++++++
 3 files changed, 26 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index 3eb8df42e194..89bb97c14c15 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -48,10 +48,24 @@ static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
 						   lrbp->ucd_prdt_ptr,
 						   scsi_sg_count(cmd));
 	return 0;
 }
 
+static inline void ufshcd_crypto_clear_prdt(struct ufs_hba *hba,
+					    struct ufshcd_lrb *lrbp)
+{
+	if (!(hba->quirks & UFSHCD_QUIRK_KEYS_IN_PRDT))
+		return;
+
+	if (!(scsi_cmd_to_rq(lrbp->cmd)->crypt_ctx))
+		return;
+
+	/* Zeroize the PRDT because it can contain cryptographic keys. */
+	memzero_explicit(lrbp->ucd_prdt_ptr,
+			 ufshcd_sg_entry_size(hba) * scsi_sg_count(lrbp->cmd));
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
 int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);
 
 void ufshcd_init_crypto(struct ufs_hba *hba);
@@ -71,10 +85,13 @@ static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
 					  struct ufshcd_lrb *lrbp)
 {
 	return 0;
 }
 
+static inline void ufshcd_crypto_clear_prdt(struct ufs_hba *hba,
+					    struct ufshcd_lrb *lrbp) { }
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e8a044149562..8ac4fb141b01 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5472,10 +5472,11 @@ void ufshcd_release_scsi_cmd(struct ufs_hba *hba,
 			     struct ufshcd_lrb *lrbp)
 {
 	struct scsi_cmnd *cmd = lrbp->cmd;
 
 	scsi_dma_unmap(cmd);
+	ufshcd_crypto_clear_prdt(hba, lrbp);
 	ufshcd_release(hba);
 	ufshcd_clk_scaling_update_busy(hba);
 }
 
 /**
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 59aa6c831a41..fe0073b37224 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -661,10 +661,18 @@ enum ufshcd_quirks {
 	 * This quirk needs to be enabled if the host controller supports inline
 	 * encryption but does not support the CRYPTO_GENERAL_ENABLE bit, i.e.
 	 * host controller initialization fails if that bit is set.
 	 */
 	UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE		= 1 << 23,
+
+	/*
+	 * This quirk needs to be enabled if the host controller driver copies
+	 * cryptographic keys into the PRDT in order to send them to hardware,
+	 * and therefore the PRDT should be zeroized after each request (as per
+	 * the standard best practice for managing keys).
+	 */
+	UFSHCD_QUIRK_KEYS_IN_PRDT			= 1 << 24,
 };
 
 enum ufshcd_caps {
 	/* Allow dynamic clk gating */
 	UFSHCD_CAP_CLK_GATING				= 1 << 0,
-- 
2.45.2


