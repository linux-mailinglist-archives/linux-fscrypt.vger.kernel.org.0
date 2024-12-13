Return-Path: <linux-fscrypt+bounces-554-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378749F0381
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51BFC16A13B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6E4187555;
	Fri, 13 Dec 2024 04:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBqUsaoE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D928918732A;
	Fri, 13 Dec 2024 04:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063623; cv=none; b=Rdvd3sTNC/CVRBaQlAYKWq9/OAqJfsiKKtoRkEwnY65/s1Frg6nZy9cpo6lYbkhEE0bdQyedd+2ANa+4FtPOpMdbBnYrKvNNds1ZJ4KqUKQwruOa3zpZRzPG/BvcxZwCER5gF1UhCKZ7VOl0y7KCJ24wyXM8E++Qn1qPbbrQWTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063623; c=relaxed/simple;
	bh=sWlPdRA3JhhJRNlUGaRBJ2FOJw2AMcEzS76jT8Xqc60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM5TxAoovmp2jEuB/m/5QTIiMugW99RcKwplkEkkjgwdgRCf7O6BxBKt9RqEkyhDlhkZJKT8DLq+aw8R5vbJIpoRcGGO2qa1aUIZEgSrhzDL+P8s2TXHz5I/Pf8QQsfZgkl5mDDviAULYTj5iAuac29NR5yzU4QCtNxOBDXZZxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBqUsaoE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCAAC4CED7;
	Fri, 13 Dec 2024 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063622;
	bh=sWlPdRA3JhhJRNlUGaRBJ2FOJw2AMcEzS76jT8Xqc60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBqUsaoE6H3y/JI0JzBpfMvFT9E7xJWUOIZHoajRu8Q/lYbi7mXAUmSxF9jpJFnW1
	 rZGL3h8D0/Gzhw3JH3Ij6q3rN8e9iiVNgee1tS+W19YmmfezG275LZbs+LDueMgaKb
	 X2pwr/GytWECl4DJ90ZcMnewxdwaTZ5Hjo4HULkHfYGvB0gous2V0Qb5DsVyCvBq5B
	 tZDq4Npvom14j9zOVg9kLRpC48xIk1L8g+SMzAIdO6qlw/KG974RQofxCWUj+S8mkM
	 JXfgFhCgI6JR3yAMLLu2AjnT+eTSWm/oYEoqfTZOqXSoz9izAp2MGQiPep5lKzoKzL
	 N/HV0pgzf595g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v10 02/15] ufs: crypto: add ufs_hba_from_crypto_profile()
Date: Thu, 12 Dec 2024 20:19:45 -0800
Message-ID: <20241213041958.202565-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a helper function that encapsulates a container_of expression.  For
now there are two users but soon there will be more.

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 6 ++----
 include/ufs/ufshcd.h             | 8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index a714dad82cd1..0cb425ef618e 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -50,12 +50,11 @@ static int ufshcd_program_key(struct ufs_hba *hba,
 
 static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 					 const struct blk_crypto_key *key,
 					 unsigned int slot)
 {
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
 	const union ufs_crypto_cap_entry *ccap_array = hba->crypto_cap_array;
 	const struct ufs_crypto_alg_entry *alg =
 			&ufs_crypto_algs[key->crypto_cfg.crypto_mode];
 	u8 data_unit_mask = key->crypto_cfg.data_unit_size / 512;
 	int i;
@@ -97,12 +96,11 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 
 static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 				       const struct blk_crypto_key *key,
 				       unsigned int slot)
 {
-	struct ufs_hba *hba =
-		container_of(profile, struct ufs_hba, crypto_profile);
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 4ff117fd27cd..55b81996b6e1 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1211,10 +1211,18 @@ static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
 
 #define ufshcd_set_sg_entry_size(hba, sg_entry_size)                   \
 	({ (void)(hba); BUILD_BUG_ON(sg_entry_size != sizeof(struct ufshcd_sg_entry)); })
 #endif
 
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+static inline struct ufs_hba *
+ufs_hba_from_crypto_profile(struct blk_crypto_profile *profile)
+{
+	return container_of(profile, struct ufs_hba, crypto_profile);
+}
+#endif
+
 static inline size_t ufshcd_get_ucd_size(const struct ufs_hba *hba)
 {
 	return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
 }
 
-- 
2.47.1


