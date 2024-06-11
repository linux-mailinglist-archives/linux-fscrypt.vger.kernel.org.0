Return-Path: <linux-fscrypt+bounces-311-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C86D904705
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E7FB1C2332B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DBC15575C;
	Tue, 11 Jun 2024 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g+j3qSjy"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BD215531E;
	Tue, 11 Jun 2024 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145341; cv=none; b=Gf4jcoamAKEc3TBcuJgi7PeXpL7t51qSTr5LwgCANvyhLED0h+Ctw4KEwsCsE8RrIAEB9MP4zBOnLF5ODFDdBlZeNnbUiq0OLQOZYFsvO8PakFDE/2pAQ1AzPSKL84+GqsoHVuNNtI4cfvLj4h2Cs7lrvz1buR6Tyrvdnzkh75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145341; c=relaxed/simple;
	bh=fgtjDmvA7l/lm4vzhuNJpYhxPFnEHAPhYNU28MhUq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1VIPAWtR1NZzwiSmCTSM/jiofzV2muK4uc7WsFOh+n/IXrOJoZee7hZNYdW2ROF6JkXnwgFFx/PHZSJIMM3GtMCikEdk5xSbn+gjzuGSdvbrIA8DZkl5gIgAycfQ+5Q2uz+TO0yInb1kfcuxXXcN7h0+13NYVv+Q6oaNj7n6fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g+j3qSjy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8664C4AF48;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145341;
	bh=fgtjDmvA7l/lm4vzhuNJpYhxPFnEHAPhYNU28MhUq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+j3qSjyXjXYggClXPG+1G+YJ4/M4terDqPLIESu4Dj61oUA3ven4Odubt1d7hbE8
	 gXY06MbrmJs41jVqOYKsijvEdaAC2049TdH4nsmHPhPExFMssK1ILtN9LTV8ihLvBV
	 G1EQDiS7wHPxd9x2CFgcrPI7P8kkG4pg5v8xkrWNNRSO5PrZMS5pghu1NL1DX3Hjz8
	 6BMj/b3j56+KOSu0ratSincUqPrDcR15VimC6fqMYCNOGXLpTeVxQPV8zBcfrYBwrV
	 2l9SP8n5iul/c4rAshu9L6fQ5rdp9HHkOysAPZdwThEmOg+Ii66wzTr0A+ZUTRuyrv
	 iZB1Eug5LmjXw==
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
Subject: [PATCH 3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
Date: Tue, 11 Jun 2024 15:34:16 -0700
Message-ID: <20240611223419.239466-4-ebiggers@kernel.org>
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

Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not
use the crypto enable bit defined by the UFS specification.  This is
needed to support inline encryption on the "Exynos" UFS controller.

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


