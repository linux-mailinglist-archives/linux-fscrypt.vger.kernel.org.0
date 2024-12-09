Return-Path: <linux-fscrypt+bounces-544-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 805EA9E8ACF
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B7771884B29
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EF619CC24;
	Mon,  9 Dec 2024 04:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EsVg4WV7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FE19CC11;
	Mon,  9 Dec 2024 04:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720227; cv=none; b=M1Ymw3tWDFT1Qk9boYAABY7vTtyu9qRX92C5Hp0TPi5uzJI4Sz55oysjWXnaMwoq6gsTwLqW92ZlwB03eDiaXp8idBlLlJ05SrUGTeL977giPWg7Us6oywIFIbkDloI33/D8+7PoDpT+37I2c2IsDqQzGsaTVf1IjkluhoFWCXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720227; c=relaxed/simple;
	bh=h4J36v6CLWXCLcu3mJF/vTOs8+nN5GQZcSNjUHzexkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pscRwl8EF6xIWJOBdNkZE8zxJWV/VPyCC9N2ow61cmGHUefZfgkiQkd1vR5TPHATZs43sq47mcCMkSLK6k7+EBELq4FzrtPd9uc4ZKdhlC/S3fnVlaoTSIDDeQ426kdwXNiBfj/nLmgQpUldRhCKkv+NdqQ4WTFHjcVn/77O5As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EsVg4WV7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB295C4CEE3;
	Mon,  9 Dec 2024 04:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720227;
	bh=h4J36v6CLWXCLcu3mJF/vTOs8+nN5GQZcSNjUHzexkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsVg4WV7pnb8yQv8ULijDaularEr2tiKgsouk7jcjVdb/6wN0CwQZCiUulQ/fBM/m
	 7eQ367e2knT36veRWFRerBtiD30EfaqqSobTH81dKKbfXFJYxrqRJ6npq+AzPajQab
	 he1T0x1z6/WFaDssIqUOqbcmGAnzgtsdVuD31PI2lkwvTcA+v6kIzVy/14oIQQXhl2
	 3ph4/8XvU0r50t7dcGrdcmKXVayBPu2tkFhjmHbG/QtBDRjLdfKDw2YdcbdU/fbbD8
	 v1MTXwDFlKR6g0wysihgn2nrmcRAQN344wsfde738Ms7//nH0NoC482ob3zAmLd5Xz
	 HRFTijVn+WPdQ==
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
Subject: [PATCH v9 12/12] ufs: qcom: add support for wrapped keys
Date: Sun,  8 Dec 2024 20:55:30 -0800
Message-ID: <20241209045530.507833-13-ebiggers@kernel.org>
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

Wire up the wrapped key support for ufs-qcom by implementing the needed
methods in struct blk_crypto_ll_ops and setting the appropriate flags in
blk_crypto_profile::key_types_supported.

For more information about this feature and how to use it, refer to
the sections about hardware-wrapped keys in
Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

Based on patches by Gaurav Kashyap <quic_gaurkash@quicinc.com>.
Reworked to use the custom crypto profile support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 54 ++++++++++++++++++++++++++++++++-----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c2fd025d04384..ee11f4b49807e 100644
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
@@ -151,11 +146,14 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
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
@@ -219,13 +217,57 @@ static int ufs_qcom_ice_keyslot_evict(struct blk_crypto_profile *profile,
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


