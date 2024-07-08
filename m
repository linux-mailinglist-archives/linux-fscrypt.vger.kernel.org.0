Return-Path: <linux-fscrypt+bounces-341-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A250692ACC0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58B4F1F21DB6
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2D615442D;
	Mon,  8 Jul 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bHXatD5d"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20826153BF8;
	Mon,  8 Jul 2024 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482937; cv=none; b=HVS9IQpEvuFMn3tLFWonqLRx029DV5gIauUK2fCFJwA8mHmGJCG/PswcB4pF63yRRlOFAp031okUXo55kwh6oxpSlrsVTh93BwRrlm1HOf8DRMXnom15HyRZaWRiGV1afNlKnhjmGtfQtjfCCR/1oM2rSaZv5Zs+PKiCvo1MJq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482937; c=relaxed/simple;
	bh=ljiOjOKdDPurbwkC+k5RmPU8HCQ6cLVAVZZCs9ki6bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxkWfQUznBwka/7budO7V+ZCJ7QnvdqJMzplECP++9FnY+WY3/My6bf87Y2DkHQ8IQKWFmw8CoEoCGv467UFnbL+c3AmeLHyOovrsan34Vf8eYP4wDJDCy+GAs1jJwIH1gbVTguB/Nc4UBlABjf3v2s0UizemfWPJAMKJnikuEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bHXatD5d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1233C116B1;
	Mon,  8 Jul 2024 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482937;
	bh=ljiOjOKdDPurbwkC+k5RmPU8HCQ6cLVAVZZCs9ki6bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHXatD5dpl49krbqLDezDVtfEkoR+8ecPxsXll7PQFPtn+msX+DxX3CbvLfBDVqH5
	 DheVTGH97GG5ORlOQeg4ZHyyUd1fft89jxUIrPIl2v2ylITSkR22nSmZWWW6tyFS7k
	 XvLNXVV3HTg+VHOvlB8sq+9iFGVlNXxUKqtKMUdTbG/R4nZDOA10w/DB+vxAWKSXc4
	 tpNQGtlGWzHS2GfzKi4bqNLd1r6J8vviklfTSnbFQVR0Kf2tYT+COHjtVeXFeSHX8K
	 n/MHCEpfJXIagXfSFvugBdxR+vZmEF1iE/AEp23f1l3epRHG+g88lSN+D7e0ozzg81
	 dKhv8Iq/quLkg==
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
Subject: [PATCH v3 5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
Date: Mon,  8 Jul 2024 16:53:29 -0700
Message-ID: <20240708235330.103590-6-ebiggers@kernel.org>
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

Since the nonstandard inline encryption support on Exynos SoCs requires
that raw cryptographic keys be copied into the PRDT, it is desirable to
zeroize those keys after each request to keep them from being left in
memory.  Therefore, add a quirk bit that enables the zeroization.

We could instead do the zeroization unconditionally.  However, using a
quirk bit avoids adding the zeroization overhead to standard devices.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
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


