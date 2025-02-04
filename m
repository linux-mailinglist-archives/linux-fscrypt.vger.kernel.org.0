Return-Path: <linux-fscrypt+bounces-593-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E537BA26BDA
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 07:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66C701884898
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 06:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0602063E0;
	Tue,  4 Feb 2025 06:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="garOtrXB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1572205E3B;
	Tue,  4 Feb 2025 06:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738649005; cv=none; b=WUVk7pdBDqk3CkEH3PaoXwXmCEZn8bagzU5jzHyfllTJOzC200nxUiz5aDWpq43x1fP47Ji57Wp4VayYeQ1uDMGp7mcajO/JqSPIMWfKXHvjKxyrY5rFYCdU0rn8I4zxf9+flyy3DJi8TGSU2gBu4KaUcPTOVrG14pNHo72He8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738649005; c=relaxed/simple;
	bh=YXruEiMk7Z0SmUMhsRZ5knXXsH2CoZdEoFSRKJf1RGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRfMUxg6OALoTmrKwcS0Mro2JK4wWTfrQ0Ojuew1Sp2UZ1mb1rtEEp8WybXlVMUv+Yw2YLuBrirRNdOi2flA51p3Lkc6XXf08sLbAQZGFx9QHtga8Yvz88al1lAiTUdq6MQbJ101xuCrbMUDpD/8DSbFNGEQThJzYHWO5iKS5is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=garOtrXB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE01C4CEEC;
	Tue,  4 Feb 2025 06:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738649004;
	bh=YXruEiMk7Z0SmUMhsRZ5knXXsH2CoZdEoFSRKJf1RGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=garOtrXBfk87XX+HKV3vl1JuwQYttO4QQ1AKchE5eO/0jiReyy1XvWDD2yZGLa9FC
	 AeKmy+jUsslnY2mPcu5mEUS2c2H2bCHjQWof2mTJgn93SLPnVMi5LEeBC6WJcpadnk
	 u2DOpDfoE7IluiD1NS0ecBDa051JLaGewLijvwGI2eN6QM4y5FmrBT8Krub6mQAAY1
	 Zt/MpKhOFfwK5m6oLaqZs2K6rlQzhNYy6gzAJPG/FvI3ILHbh0NflYxDC7Xmq2OP0c
	 49B9SNkzewZfyYQob96/Zyxm1qXzL4tfODbRqxSLgBPgjVdd4wwy4Gq447+twUUlW8
	 wy9WykkXhfD1w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH v11 7/7] ufs: qcom: add support for wrapped keys
Date: Mon,  3 Feb 2025 22:00:41 -0800
Message-ID: <20250204060041.409950-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>
References: <20250204060041.409950-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 51 ++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index f34527fb02fb2..dc3eb6f29f5b2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -132,15 +132,10 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
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
@@ -150,11 +145,11 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
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
@@ -218,13 +213,57 @@ static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
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
2.48.1


