Return-Path: <linux-fscrypt+bounces-319-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7C791F009
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C436286DFE
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE52F1487CC;
	Tue,  2 Jul 2024 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FvKBArn0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44C1148301;
	Tue,  2 Jul 2024 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905291; cv=none; b=F2Bks4rFXM6/sJuVpVVanWxTb5TH5S5piyxs+x+nCWjq2zHR2q/oQKJ4suJb8x/yg1gr5qZA7VUnM/7z+XygqP9DrSxD/nIw/n7yeV40j68P7af45mvOVDij00MwtDz4Ye/V6dc70jHp+jNKUPSS06C4/mpPr7QNS5CxIb+LxDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905291; c=relaxed/simple;
	bh=YA5Wzxud6EXdeHJeBEt5IKmz1fvFGpRCpVtCdnLGIDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP5b6NBAt9l5NpEdBCHpyfttPJaA0GCFrYFg6N+I8LPTtoui2YesY2closipfEEvHQj174hZy1BtmQxw5ujSwVGFkWoEZ0YMUeGtvGHuCBWoJjfr3H9Q2uccOFWrYwEbWiOOGBBaD8DSk6zgmEhi9gH+ZOtTh7dFvIvyPubGinc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FvKBArn0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47843C4AF0C;
	Tue,  2 Jul 2024 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905291;
	bh=YA5Wzxud6EXdeHJeBEt5IKmz1fvFGpRCpVtCdnLGIDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvKBArn0M8H+HXBQE8CbIgHD8R9y0P7iO3rPe08qacn4yjGAuJB+wnaDL2YAd39ZP
	 eT2zkI/wBWs6uuKGCMXfGuHLPwv+bRan+hGXpWrTEWiNQ5t4Ca2BXQNWVwG2O55j7B
	 NeBQ3ejm8RznqDj4y8OTz1ycX+wjPZ0ovTDWAHjAY6xtmvRzxetti+MRuy89AbB+06
	 ca9b6gh/8fFF0MeCTWv0u20rEDoKyKZxz8nq6YQuV0bzJcKYZhs53beB0hTbIvbc6m
	 yQTAXDQ/GkTP0LigNh5DiFfkTCnfq17hqdMsBKBP/pBylE50EkyBZEZ0wxAI58b4/F
	 dY4zKHYG7af0Q==
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
Subject: [PATCH v2 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
Date: Tue,  2 Jul 2024 00:25:06 -0700
Message-ID: <20240702072510.248272-3-ebiggers@kernel.org>
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


