Return-Path: <linux-fscrypt+bounces-640-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C612A7C6A7
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 01:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B25CF3BBC67
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 23:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564A922173D;
	Fri,  4 Apr 2025 23:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbna1okn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127BE221729;
	Fri,  4 Apr 2025 23:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743808592; cv=none; b=U/Dbu2G3GT5v7EmiR2Pj71ynURoGYL/wvPSYQZhK+ebzZ80R4Qha85ra/Oh+Uy7SL1YfugU1uM2n/1KPYNCWu/xB61RtnNZSuVUsdE4J3pK2xmj/hiyUfVY7jG5N/iKKWp6fcKdJfLPaFvsWjYz4nVzhQyPXc21B9DF6rtlOa+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743808592; c=relaxed/simple;
	bh=pLcNof6JbapOHK594mGu5j5X53Jvg5ctd3e5BUNyfVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwzt1YgSLTB1qW3KQDWUKVUlbM8k/a5ts5CnsX39lvxIX8pqhXamuWgzx/ASQUV9bVU0aIre9+JhYNPEg8YJyYzQGuZWZjXk4tZlphyYJd4q1q57aO8UeItywyNuvYyhDE/giw+HKjXky7kYfXUGZDl2dnjA0uX8jofY9+2Zr68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbna1okn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F98C4CEF2;
	Fri,  4 Apr 2025 23:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743808591;
	bh=pLcNof6JbapOHK594mGu5j5X53Jvg5ctd3e5BUNyfVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbna1oknD/ZvI3sOJ9ta/LdvxqmsuirwvEnENV50pL1QcyK7da3vftEpZj6/Cxgb4
	 q1k77iXUU72vUtTLAksT9nyhStbjPVq03hV/lrtcnUoP0WoMKGQBh80iUGQiCR1pvQ
	 HdzMCvMXYkygICv20K3WhoQcK8WSd+0OGhPZKZNzJn/EnPrWDNRd9W1nCu8raxlSq2
	 xm3K7T3cb0x+sq6VaKm7tRVu+zOFWZ0HaWjD9HJDyVGh/yLgC7oLEpdNzmJJThGwm/
	 It7aOt1YqU8wEfxfseXbChNlUT38umNQhrthUzYD9SIuk/LyzsvALf5rS65hGjfgRO
	 lAlf2IH9X6Lfg==
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
Subject: [PATCH v13 3/3] ufs: qcom: add support for wrapped keys
Date: Fri,  4 Apr 2025 16:15:32 -0700
Message-ID: <20250404231533.174419-4-ebiggers@kernel.org>
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

Wire up the wrapped key support for ufs-qcom by implementing the needed
methods in struct blk_crypto_ll_ops and setting the appropriate flag in
blk_crypto_profile::key_types_supported.

For more information about this feature and how to use it, refer to
the sections about hardware-wrapped keys in
Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

Based on patches by Gaurav Kashyap <quic_gaurkash@quicinc.com>.
Reworked to use the custom crypto profile support.

Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 51 ++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 85040861ddc6e..46cca52aa6f11 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -154,15 +154,10 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	}
 
 	if (IS_ERR_OR_NULL(ice))
 		return PTR_ERR_OR_ZERO(ice);
 
-	if (qcom_ice_get_supported_key_type(ice) != BLK_CRYPTO_KEY_TYPE_RAW) {
-		dev_warn(dev, "Wrapped keys not supported. Disabling inline encryption support.\n");
-		return 0;
-	}
-
 	host->ice = ice;
 
 	/* Initialize the blk_crypto_profile */
 
 	caps.reg_val = cpu_to_le32(ufshcd_readl(hba, REG_UFS_CCAP));
@@ -172,11 +167,11 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	if (err)
 		return err;
 
 	profile->ll_ops = ufs_qcom_crypto_ops;
 	profile->max_dun_bytes_supported = 8;
-	profile->key_types_supported = BLK_CRYPTO_KEY_TYPE_RAW;
+	profile->key_types_supported = qcom_ice_get_supported_key_type(ice);
 	profile->dev = dev;
 
 	/*
 	 * Currently this driver only supports AES-256-XTS.  All known versions
 	 * of ICE support it, but to be safe make sure it is really declared in
@@ -240,13 +235,57 @@ static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
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
2.49.0


