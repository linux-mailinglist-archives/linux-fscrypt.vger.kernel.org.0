Return-Path: <linux-fscrypt+bounces-533-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 671A29E8A96
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3290E188555D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3376C195385;
	Mon,  9 Dec 2024 04:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qr5kenwq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00485194C96;
	Mon,  9 Dec 2024 04:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720220; cv=none; b=QSE+QRK4NenxEOasqnnfrmnyXYjwxr0cA3Ch5HJhuDG+sNzgE0CFQdVC8AatR1uh1sLpCNMbpqmW5nevxl7Xgv58HyqSV48WX/VMBO37Z65EQm5PBER+NiSHhLrlAghgYdw5LSmMN+k8YqXQ3FEOmk7DQQ5dyvGK1WwPNh0nEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720220; c=relaxed/simple;
	bh=gQxL93tDqeQ81DXvyKU5Qq7RuWyMVm0Ywpf4ghREIMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEixG1EQDWNzHENoLWD+AIPmsBCMbN2miLOB6uRjOE0gEncb20E/F6lPEMzr7OP/aDSF9Z5h3BeCRkqRYhRH4dc1CPsVQp3rVbz5hM0eUVcaJSMd5ixb8sEm0S7WSZ4zzaXhO8ytnnLi7bx2Hk8Thkr232RD7CybR6JQ6mKXrPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qr5kenwq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E318DC4CEDF;
	Mon,  9 Dec 2024 04:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720219;
	bh=gQxL93tDqeQ81DXvyKU5Qq7RuWyMVm0Ywpf4ghREIMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr5kenwqysiWhiX+f6geZf4nH7oz07Jw+hXafL00bQahJ8Xd2qHe7XGKwX5RYi4Zc
	 zHEtoq29/pQ6s+pWbwbZoSW4Y9J94uRjvGDuW8zXfGi8PJJZERMkvKGGo8THu0izAP
	 IooBmluizx1cRtKVCj5RH9SVe6zQg6PzD9cvvnvotv5/41a5GI9eBhkhJVNPMpMHpQ
	 F4fTt/B3+7AudfMW29w0ymYHoP7HD4RcNDLgY/KiLh7kGTft0JCDOmVrkCsZ61xSAz
	 wDvjShYyKqR6Hsw9KQyk5p/ZMBmZnlAOuYrWOyaMTMSGgdg6MmXwHaeOvmkec/5WQs
	 f+oaAs6omzB3Q==
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
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v9 01/12] ufs: crypto: add ufs_hba_from_crypto_profile()
Date: Sun,  8 Dec 2024 20:55:19 -0800
Message-ID: <20241209045530.507833-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209045530.507833-1-ebiggers@kernel.org>
References: <20241209045530.507833-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 6 ++----
 include/ufs/ufshcd.h             | 8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index a714dad82cd1f..0cb425ef618e8 100644
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
index d7aca9e61684f..91b4f95d6c8ea 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1200,10 +1200,18 @@ static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
 
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
 

base-commit: f486c8aa16b8172f63bddc70116a0c897a7f3f02
-- 
2.47.1


