Return-Path: <linux-fscrypt+bounces-538-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1472F9E8AAF
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06643164345
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C13F31993A3;
	Mon,  9 Dec 2024 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZRmOXNOn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD7419938D;
	Mon,  9 Dec 2024 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720223; cv=none; b=mt+PhdUumiVG8nugGBjD9cK3OJ7T777Hv0v0Awwohl07EZrqRtKgrfRog5cOjre0SxPpCJ4LJwhnDLEu2YfiDotbzVt0z/G6BgXW49u3u7JpuaMw6PAhUe+TdZg3ugZwZFvqjokFiwWY8hfS5zYmdrMmOxtNg1Vw9nLbnvEEptw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720223; c=relaxed/simple;
	bh=+wNCYcOvSOCYD0EEwEY5XJgAsCk/392L+5X1q4y2o00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lll97MMIOhFBZd5VdLFXySS4j6vmAaXzkJORXBa6oGZ8qdqAxISsn8NDQ+8vwVscDD/c6uX+srlDsv2pS29NW1GxLtD0GEPSEDwpxi2+TRN7+aB2syPsjex16v6TQyNKpxym5hxlGMNZUuDIET1JuS417i/Bm2NGIQUVYUxSi5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZRmOXNOn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBBCC4CEE3;
	Mon,  9 Dec 2024 04:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720223;
	bh=+wNCYcOvSOCYD0EEwEY5XJgAsCk/392L+5X1q4y2o00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRmOXNOnxiJjx2HvgwYbRl+PqwxcKybPBtebYt1Q3uVBSRypVZkwjdaHhu7iOgHKr
	 k6qhWPMG3W9Jys0KArHXosFgHJTGKBDVa3fBDko8CtZ+ccUNo8W5fpCT6p/GXbXdC1
	 vrZnfCh2/NqYu4zDzP0WwJhl63dfSmKp1+ppQ2l+i9ghtvNdekKS40ivgAuDQqN+dT
	 w8FHWH+Y/I7BneCjpsNb/BmuThoKkruDkeaRaAz5stIGTZ5tmaaYf8UKpTUnJCf/w5
	 AGa9D2piXq0tCVSQSBZnl9qfLknoaSXSuwPH0RL0u3um2skSHtYy4/hAtz0xtEcDGp
	 Msbffv+R4ZAJw==
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
Subject: [PATCH v9 06/12] soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
Date: Sun,  8 Dec 2024 20:55:24 -0800
Message-ID: <20241209045530.507833-7-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/sdhci-msm.c | 11 +----------
 drivers/soc/qcom/ice.c       | 23 ++++++++++++-----------
 drivers/ufs/host/ufs-qcom.c  | 11 +----------
 include/soc/qcom/ice.h       | 22 +++-------------------
 4 files changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 7ab7d30ccfa3d..8684a5f3357ba 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1911,20 +1911,11 @@ static int sdhci_msm_ice_keyslot_program(struct blk_crypto_profile *profile,
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
-				    key->raw,
-				    key->crypto_cfg.data_unit_size / 512,
-				    slot);
+	return qcom_ice_program_key(msm_host->ice, slot, key);
 }
 
 static int sdhci_msm_ice_keyslot_evict(struct blk_crypto_profile *profile,
 				       const struct blk_crypto_key *key,
 				       unsigned int slot)
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 393d2d1d275f1..04d5884574c54 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -159,41 +159,42 @@ int qcom_ice_suspend(struct qcom_ice *ice)
 
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
+	memcpy(key.bytes, blk_key->raw, AES_256_XTS_KEY_SIZE);
 
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
index 1c1bbf30bc82a..c0e72d2de378a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -193,21 +193,12 @@ static int ufs_qcom_ice_keyslot_program(struct blk_crypto_profile *profile,
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
-				   key->raw,
-				   key->crypto_cfg.data_unit_size / 512,
-				   slot);
+	err = qcom_ice_program_key(host->ice, slot, key);
 	ufshcd_release(hba);
 	return err;
 }
 
 static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 5870a94599a25..4cecc7f088b4b 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -4,34 +4,18 @@
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
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */
-- 
2.47.1


