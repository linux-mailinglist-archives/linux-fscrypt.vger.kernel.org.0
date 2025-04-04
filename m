Return-Path: <linux-fscrypt+bounces-638-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11CC8A7C69D
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 01:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD1EF7A9422
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 23:15:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40FE1221546;
	Fri,  4 Apr 2025 23:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ke4RpOuR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063E52206A2;
	Fri,  4 Apr 2025 23:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743808591; cv=none; b=HvXLEsEXDhbX7NjZtkXrHNqJ6bji9QDByoCRXnGQ08cY8os5EoV3B24qvI3hY7GJbCtuU+lm7ecQviqBSVDaJQpRvzwCPf0kkHgbU6JVjYWizefskjwL3cL13q4YWaVUfz6GlmxX2xihsL1J7zmTE6ZQRTY4wOm/605hra+I9E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743808591; c=relaxed/simple;
	bh=jxR0YUjCGyxvTiCsuxxeOrtJDSm69Jli91V4OF+mxcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX5YmUkblmgGJFgbWJ3pkhOAFhmWTUhOlg1Ztod7hzQV9zQaUIziacWCFhfIYnz/6QHRXq499TqGZ73Lcxwr5bJyDtD0Hfom6VZAQvQ9VUWphYmBvc0hIyMXz1pl6jAxTbh2Gs5kLEVRDJK7ypZwAiIwFzVMwPWq59lYzAroW5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ke4RpOuR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A9AC4CEE4;
	Fri,  4 Apr 2025 23:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743808590;
	bh=jxR0YUjCGyxvTiCsuxxeOrtJDSm69Jli91V4OF+mxcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke4RpOuRmclK4L6r9+WooSBwD00x1EZqpeKLHMkDRmhkradwcKCH8ojC/Z88vujhe
	 7zzJHoW0GQb4RG0ygqRQ34wRYs4ICSPLaInUrUNyUS0ZKh3nCscPUAUfsfe0a7//St
	 48DPhaQ2Yx9A3pYppD6+EXFJ4CwE9zjIo9Vys212J5mQ2ufeoebFiupczHEbyC5UWv
	 1Az9YSppWwUCNniiYCwCQd0iV+cYeRr5JLG0fpOY6WZW8gjI38zZ8cZ8NLsIPXE19v
	 dEclbN9E9QPAsoDXb86AAViD1XAF58BcDg7AMHezgWTuEeYrctUveHbpcPd5p8fkgo
	 HWV/YySkviMjw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v13 1/3] soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
Date: Fri,  4 Apr 2025 16:15:30 -0700
Message-ID: <20250404231533.174419-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250404231533.174419-1-ebiggers@kernel.org>
References: <20250404231533.174419-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

qcom_ice_program_key() currently accepts the key as an array of bytes,
algorithm ID, key size enum, and data unit size.  However both callers
have a struct blk_crypto_key which contains all that information.  Thus
they both have similar code that converts the blk_crypto_key into the
form that qcom_ice_program_key() wants.  Once wrapped key support is
added, the key type would need to be added to the arguments too.

Therefore, this patch changes qcom_ice_program_key() to take in all this
information as a struct blk_crypto_key directly.  The calling code is
updated accordingly.  This ends up being much simpler, and it makes the
key type be passed down automatically once wrapped key support is added.

Based on a patch by Gaurav Kashyap <quic_gaurkash@quicinc.com> that
replaced the byte array argument only.  This patch makes the
blk_crypto_key replace other arguments like the algorithm ID too,
ensuring that there remains only one source of truth.

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/sdhci-msm.c | 11 +----------
 drivers/soc/qcom/ice.c       | 23 ++++++++++++-----------
 drivers/ufs/host/ufs-qcom.c  | 11 +----------
 include/soc/qcom/ice.h       | 22 +++-------------------
 4 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 57bd49eea7772..5694ad0a35567 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1960,20 +1960,11 @@ static int sdhci_msm_ice_keyslot_program(struct blk_crypto_profile *profile,
 					 unsigned int slot)
 {
 	struct sdhci_msm_host *msm_host =
 		sdhci_msm_host_from_crypto_profile(profile);
 
-	/* Only AES-256-XTS has been tested so far. */
-	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
-		return -EOPNOTSUPP;
-
-	return qcom_ice_program_key(msm_host->ice,
-				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-				    key->bytes,
-				    key->crypto_cfg.data_unit_size / 512,
-				    slot);
+	return qcom_ice_program_key(msm_host->ice, slot, key);
 }
 
 static int sdhci_msm_ice_keyslot_evict(struct blk_crypto_profile *profile,
 				       const struct blk_crypto_key *key,
 				       unsigned int slot)
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 2310afa77b76b..5cadf5e3cf982 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -160,41 +160,42 @@ int qcom_ice_suspend(struct qcom_ice *ice)
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_ice_suspend);
 
-int qcom_ice_program_key(struct qcom_ice *ice,
-			 u8 algorithm_id, u8 key_size,
-			 const u8 crypto_key[], u8 data_unit_size,
-			 int slot)
+int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
+			 const struct blk_crypto_key *blk_key)
 {
 	struct device *dev = ice->dev;
 	union {
 		u8 bytes[AES_256_XTS_KEY_SIZE];
 		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
 	} key;
 	int i;
 	int err;
 
 	/* Only AES-256-XTS has been tested so far. */
-	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
-	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256) {
-		dev_err_ratelimited(dev,
-				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
-				    algorithm_id, key_size);
+	if (blk_key->crypto_cfg.crypto_mode !=
+	    BLK_ENCRYPTION_MODE_AES_256_XTS) {
+		dev_err_ratelimited(dev, "Unsupported crypto mode: %d\n",
+				    blk_key->crypto_cfg.crypto_mode);
 		return -EINVAL;
 	}
 
-	memcpy(key.bytes, crypto_key, AES_256_XTS_KEY_SIZE);
+	if (blk_key->size != AES_256_XTS_KEY_SIZE) {
+		dev_err_ratelimited(dev, "Incorrect key size\n");
+		return -EINVAL;
+	}
+	memcpy(key.bytes, blk_key->bytes, AES_256_XTS_KEY_SIZE);
 
 	/* The SCM call requires that the key words are encoded in big endian */
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
 		__cpu_to_be32s(&key.words[i]);
 
 	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
 				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
-				   data_unit_size);
+				   blk_key->crypto_cfg.data_unit_size / 512);
 
 	memzero_explicit(&key, sizeof(key));
 
 	return err;
 }
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 1b37449fbffc5..b111b37cef109 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -215,21 +215,12 @@ static int ufs_qcom_ice_keyslot_program(struct blk_crypto_profile *profile,
 {
 	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	int err;
 
-	/* Only AES-256-XTS has been tested so far. */
-	if (key->crypto_cfg.crypto_mode != BLK_ENCRYPTION_MODE_AES_256_XTS)
-		return -EOPNOTSUPP;
-
 	ufshcd_hold(hba);
-	err = qcom_ice_program_key(host->ice,
-				   QCOM_ICE_CRYPTO_ALG_AES_XTS,
-				   QCOM_ICE_CRYPTO_KEY_SIZE_256,
-				   key->bytes,
-				   key->crypto_cfg.data_unit_size / 512,
-				   slot);
+	err = qcom_ice_program_key(host->ice, slot, key);
 	ufshcd_release(hba);
 	return err;
 }
 
 static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index fdf1b5c21eb9a..24573e4250395 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -4,35 +4,19 @@
  */
 
 #ifndef __QCOM_ICE_H__
 #define __QCOM_ICE_H__
 
+#include <linux/blk-crypto.h>
 #include <linux/types.h>
 
 struct qcom_ice;
 
-enum qcom_ice_crypto_key_size {
-	QCOM_ICE_CRYPTO_KEY_SIZE_INVALID	= 0x0,
-	QCOM_ICE_CRYPTO_KEY_SIZE_128		= 0x1,
-	QCOM_ICE_CRYPTO_KEY_SIZE_192		= 0x2,
-	QCOM_ICE_CRYPTO_KEY_SIZE_256		= 0x3,
-	QCOM_ICE_CRYPTO_KEY_SIZE_512		= 0x4,
-};
-
-enum qcom_ice_crypto_alg {
-	QCOM_ICE_CRYPTO_ALG_AES_XTS		= 0x0,
-	QCOM_ICE_CRYPTO_ALG_BITLOCKER_AES_CBC	= 0x1,
-	QCOM_ICE_CRYPTO_ALG_AES_ECB		= 0x2,
-	QCOM_ICE_CRYPTO_ALG_ESSIV_AES_CBC	= 0x3,
-};
-
 int qcom_ice_enable(struct qcom_ice *ice);
 int qcom_ice_resume(struct qcom_ice *ice);
 int qcom_ice_suspend(struct qcom_ice *ice);
-int qcom_ice_program_key(struct qcom_ice *ice,
-			 u8 algorithm_id, u8 key_size,
-			 const u8 crypto_key[], u8 data_unit_size,
-			 int slot);
+int qcom_ice_program_key(struct qcom_ice *ice, unsigned int slot,
+			 const struct blk_crypto_key *blk_key);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
 struct qcom_ice *devm_of_qcom_ice_get(struct device *dev);
 
 #endif /* __QCOM_ICE_H__ */
-- 
2.49.0


