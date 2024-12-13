Return-Path: <linux-fscrypt+bounces-567-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 371129F03C3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:22:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8DFC3188B3DD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 283391925B8;
	Fri, 13 Dec 2024 04:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V08LK1oO"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0FE19258E;
	Fri, 13 Dec 2024 04:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063633; cv=none; b=pwZhQ4HeJFtm+fTl9+QXjfagLpATFA4rvWtjm9T5CD0d1hEmYCFRotp2ufJ9SVrF2NCg18za7JfR++unlnAnsi4Pu7A2TCAtjXcI2/GKQvzZnaDJFuHbKMMCYswfswWSvyXY/J8eSCyKySEC4NNF0qR+QzxOp7y01j73BYQSyeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063633; c=relaxed/simple;
	bh=CabWA9BaaCRJ5kUMUib1srOSTchr0i1t04gMY0qbEWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDgFJ0IwgPYOQ7eEMvRaQatXiLp3i85tqbk67QTNHKaiAiUos9UvatiH3/HSsxpyn/cprkMIBLLJqbVtLKH/B8l382/Ds/qEjXmUb/G5J8z126LjEWBYOUag/5ZWoTg5Y4WmPeDpzZMXvgrmSoGH3xNsWNOgzScRv1ERPupn8iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V08LK1oO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E668CC4CED2;
	Fri, 13 Dec 2024 04:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063632;
	bh=CabWA9BaaCRJ5kUMUib1srOSTchr0i1t04gMY0qbEWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V08LK1oOmILKcGiM/+h75Vixxd2jhjEZ4FH8mLoJzU9O40KLPjXe4Q5ShoqNWTqEb
	 BN5Ie6Qh5Kec49+ILvAiKwhgBDdsNp7DrfY/3xppZbXfwjsW51kplcLjpOqPgTY7p/
	 JLEPNYWDfiJ4XUF3RfT94jmF80FvbgdlJJm9cBFr2BgXeKMommRtfRZCUwAuOfb5bZ
	 BFLNQZFAm57/aDUJF1GNqJbPSb6pm/xP1D+mpN3g/q3Dud9cde6pKReytsO9O+v6JM
	 jebO1ZGELijIzSFzV5uz4U+GzCY3ebpdLTpcaUeJpn/spmYPNVx+hY6HmLBfponC8v
	 dzTczgtuVdC5g==
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
Subject: [PATCH v10 15/15] ufs: qcom: add support for wrapped keys
Date: Thu, 12 Dec 2024 20:19:58 -0800
Message-ID: <20241213041958.202565-16-ebiggers@kernel.org>
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

Wire up the wrapped key support for ufs-qcom by implementing the needed
methods in struct blk_crypto_ll_ops and setting the appropriate flags in
blk_crypto_profile::key_types_supported.

For more information about this feature and how to use it, refer to
the sections about hardware-wrapped keys in
Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

Based on patches by Gaurav Kashyap <quic_gaurkash@quicinc.com>.
Reworked to use the custom crypto profile support.

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 54 ++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 9c700bbaa12c..c9cca4348dab 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -132,15 +132,10 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
-	if (qcom_ice_using_hwkm(ice)) {
-		dev_warn(dev, "HWKM mode unsupported; disabling inline encryption support\n");
-		return 0;
-	}
-
 	host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
@@ -150,11 +145,14 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	if (err)
 		return err;
 
 	profile->ll_ops = ufs_qcom_crypto_ops;
 	profile->max_dun_bytes_supported = 8;
-	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
+	if (qcom_ice_using_hwkm(ice))
+		profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+	else
+		profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
 	profile->dev = dev;
 
 	/*
 	 * Currently this driver only supports AES-256-XTS.  All known versions
 	 * of ICE support it, but to be safe make sure it is really declared in
@@ -218,13 +216,57 @@ static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
 	err = qcom_ice_evict_key(host->ice, slot);
 	ufshcd_release(hba);
 	return err;
 }
 
+static int ufs_qcom_ice_derive_sw_secret(struct blk_crypto_profile *profile,
+					 const u8 *eph_key, size_t eph_key_size,
+					 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_derive_sw_secret(host->ice, eph_key, eph_key_size,
+					 sw_secret);
+}
+
+static int ufs_qcom_ice_import_key(struct blk_crypto_profile *profile,
+				   const u8 *raw_key, size_t raw_key_size,
+				   u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_import_key(host->ice, raw_key, raw_key_size, lt_key);
+}
+
+static int ufs_qcom_ice_generate_key(struct blk_crypto_profile *profile,
+				     u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_generate_key(host->ice, lt_key);
+}
+
+static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
+				    const u8 *lt_key, size_t lt_key_size,
+				    u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba = ufs_hba_from_crypto_profile(profile);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
+	.derive_sw_secret	= ufs_qcom_ice_derive_sw_secret,
+	.import_key		= ufs_qcom_ice_import_key,
+	.generate_key		= ufs_qcom_ice_generate_key,
+	.prepare_key		= ufs_qcom_ice_prepare_key,
 };
 
 #else
 
 static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
-- 
2.47.1


