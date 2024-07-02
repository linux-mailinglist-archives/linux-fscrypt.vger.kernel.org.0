Return-Path: <linux-fscrypt+bounces-322-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E9591F012
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 452FD1C23035
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F60F14B06C;
	Tue,  2 Jul 2024 07:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTyWE3Un"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A0E14AD2E;
	Tue,  2 Jul 2024 07:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905293; cv=none; b=M/WOFeF6cyOdTq+6zXPGjwnJBhpmSl8N6AWAhISgvsAY3bqhYawzRUNcD194a2eTe8sOckBfPfKhHzTnlpGyR3fUUNt1vexqcvqVZnMiZcS2fYA5rqVSR3UdjqdZYPGLowFCubpb5u2i3xR7IFqrojY//HpI4TaMTeKvUXB7sN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905293; c=relaxed/simple;
	bh=svMpBL3wAjAMA7+OPjxWHPcVj1+DZNudRpOxqsqEagw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdQ1iwVM+ggAanKPjf85YjrHbAzWn92wXNoGroMoc1qtsh9aSe+7BTb2DXsDaWCIOX5znD7UxISTCEuH5wuqJmoN+cfTM9WQDCOm7rTZJ4IfoByC0sIEHWF6L9+r5ZCdtw5nxu0FTOSh8Y9JkllhZWhXy6K1mSTadDQwJswLfPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTyWE3Un; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9664DC4AF0C;
	Tue,  2 Jul 2024 07:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905292;
	bh=svMpBL3wAjAMA7+OPjxWHPcVj1+DZNudRpOxqsqEagw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTyWE3UnZP1aSUzOP0NKm0+1SqXu87VEQL+AFcOVxVFpvDptJ0gcFjSid+FDZ89br
	 AUqzAfKRh33CHdKtjMAaSJKCjNZ2VkqhPrrRTTPRDruaTyDrFkXp0zWXyJJVjEZ27C
	 Dcw5necq3RdUW5ffBJ1eM9LWojZ9uuEJWfhjD631GmYnHzPJst5HkECU2NWh+wkwo3
	 w9/AQVxgxhoUu0Hj/LnB/0VputcIRFmZUONejdxv4ldo1/eO2NCNCyh9Awdew3u1NN
	 8Q4gSTIbgYiWo9YgEyVkbn8dOgclL6tZb319LLTVnjIQLrw4CpAr3UV59ewMbGBLZm
	 W/sNXgF+GhYjg==
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
Subject: [PATCH v2 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
Date: Tue,  2 Jul 2024 00:25:09 -0700
Message-ID: <20240702072510.248272-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702072510.248272-1-ebiggers@kernel.org>
References: <20240702072510.248272-1-ebiggers@kernel.org>
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
index 744af9708e51..958cc73d8e79 100644
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


