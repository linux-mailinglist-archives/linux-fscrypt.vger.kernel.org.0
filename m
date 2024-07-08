Return-Path: <linux-fscrypt+bounces-338-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBF892ACB5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79020282AE5
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04D6815359A;
	Mon,  8 Jul 2024 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vt4BR5tU"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAD3153567;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482935; cv=none; b=rAbf1xTfdlpYtKeRb2gF7yvrneIjK/na5fFn9ldciyQSMA2g5kwxEIWsun0nz66B8/QajxVHGnQ+Losyscvrw7+JCEOCtHPq4CLuaEVDSSvJZ+skHngRlmJT5SJNysU/dWIvV0fAq5Z0gpKV3kj7yGZ0pVv6559dTbU6BczoFNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482935; c=relaxed/simple;
	bh=dDCEMtiEd1ETccjZ1d+UHqbSUKfoBV882EVsY8bVJcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtTHNTZjbAAy8KtoioQKnQfd+lxFwsaQh5Dzh0hEtr9QzXTn2ALUi53WLUaf1nQVPvDnJTuXXJrQazTl1Fic7IxGYDdGCZ28m/ZNpDqf00rw64WTwJ4UiMktHmz7zE3DtM/ZwTgH71Udj1gAWQwWqnt3ZId7WAGw0voiCmOFpU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vt4BR5tU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697D2C4AF0D;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482935;
	bh=dDCEMtiEd1ETccjZ1d+UHqbSUKfoBV882EVsY8bVJcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vt4BR5tUomvsnksPL9Fp/T73UBjtMVZIhMox8bUPrXWFALSn1RcuWVGytQHRMbnjE
	 FCddr3koUBSXsC2q/gOZ/PwxTdwfcRBynM9O+ujRy+RFpui+RkslnClas7kdZ1abT0
	 sM0PAtysRSgApOGfeyRc3IBMDRkWy35bdOw9vqj2Q6wMYPLPleCsp4JYEzswVwOT6W
	 hFLgYrVVEXIWvq+/LX99p1HmAIcPpkd9wp/kysuGxus0teQ3eD3lx0g8vER4p9lI+9
	 X9tAK4jpcT6zOQgwgzRv6IzkE6JwYs3K1ExuNbUrVLyBUPlCSFUBQiy1eSU7Nr9Jxp
	 wVdHajTULHeGw==
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
Subject: [PATCH v3 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
Date: Mon,  8 Jul 2024 16:53:26 -0700
Message-ID: <20240708235330.103590-3-ebiggers@kernel.org>
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

Fold ufshcd_clear_keyslot() into its only remaining caller.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
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


