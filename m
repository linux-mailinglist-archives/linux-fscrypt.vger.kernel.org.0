Return-Path: <linux-fscrypt+bounces-310-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3207904702
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CFFC2852A0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BCE15572F;
	Tue, 11 Jun 2024 22:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gv3UYMHx"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CEE1553B5;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145340; cv=none; b=ZGf4bJEpxHJzvxdTprGPSOhdnFcXgVH4WVEXLQNmvXsVGltRYWwQKyKjYGqAQ8vv/tWRDopmYXxDw8iQCDmUAZH1fcDVtgF7pMH9jMKiU+ZDrD4CvSSasvqzLnVuQ5nO81a/LS2Gca1y4/Rwje+UzisfYeHEoyR506RN8ukEVWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145340; c=relaxed/simple;
	bh=YA5Wzxud6EXdeHJeBEt5IKmz1fvFGpRCpVtCdnLGIDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6or1QjMPBKEXhd+nYaZHWGVvWmbW/o3K0jK/DUoSpRO/A0iqdGhvdnNBkqCJy3EjpvpWKC0xbYIT1CrahfxLQ7TF1bb95hBJv7W6YgGxao0BIwuICgv/EJeywn8ERk4pMQU3wKQK3JTpsr+/i7avypxWSY8w7lkiBXWFJ/0eHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gv3UYMHx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE86C3277B;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145340;
	bh=YA5Wzxud6EXdeHJeBEt5IKmz1fvFGpRCpVtCdnLGIDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gv3UYMHxqi5NnLVeHsp+bmjtr+Ts95v0+HU/iv9gafgpYk8+AlJWBRZlV/mc/Xqok
	 +Al/b0hfatf+VoKkBz6CAYhIS6Am+1TTvC/0DJJ2pBkkanNDAfv93pWe/2R32Aahho
	 5Rw52y4ZNFGth6BLL/DpFaUeXLc7KMjmezLjOcoGgwa/IxlVV8n2E2TmblWkaV+TyH
	 sV/A6Fms8xalSN3ne0IBzMQG425t4ATjLmg++dL6STAGCO/2Jy27UMgtECeHtpTGYw
	 GDeLhV8RuzZRtJeD05ctsuG5ln8b5vlB0sN32P5JL2lV6E59TJqIgoVnYxht+vdwss
	 YrD4cTbJhIL0A==
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
Subject: [PATCH 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
Date: Tue, 11 Jun 2024 15:34:15 -0700
Message-ID: <20240611223419.239466-3-ebiggers@kernel.org>
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

Fold ufshcd_clear_keyslot() into its only remaining caller.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index debc925ae439..b4980fd91cee 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -93,31 +93,25 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 
 	memzero_explicit(&cfg, sizeof(cfg));
 	return err;
 }
 
-static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
+static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
+				       const struct blk_crypto_key *key,
+				       unsigned int slot)
 {
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }
 
-static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
-				       const struct blk_crypto_key *key,
-				       unsigned int slot)
-{
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
-
-	return ufshcd_clear_keyslot(hba, slot);
-}
-
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return false;
 
-- 
2.45.2


