Return-Path: <linux-fscrypt+bounces-521-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA669E03B2
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Dec 2024 14:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3DE1B30458
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Dec 2024 12:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF28220968D;
	Mon,  2 Dec 2024 12:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="Fxs178FS"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD31208978
	for <linux-fscrypt@vger.kernel.org>; Mon,  2 Dec 2024 12:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140984; cv=none; b=A0/XmKF2sI6y32Eku6CieLIWxUUvhVjNA/5tyniSrZyyLbH5PG9ecKFfglutygAPkLEcSJMBuHMaoySHCL/4Nh3/MEHPlkq650tQG3T3oud6mxoHr8huiKvWiScukFZsuVnALhgR5B31DDFcFQxmFCLggK5tEAwbE4wKeTLS7OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140984; c=relaxed/simple;
	bh=QjUMBAWkjky6GHRxx2Gd0Kb/brgb9vo6Utawe6cSi0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mWXftxaGFVx7ZycJZTazxZmY7Rs2GmM7xn0MS6gSwSjBje2pDvJkxVKO7EnKhK90GjkGc8VIgpYhZ2XSnWGti2nLKGUvjFizZhfmI2q7SgSkg7B8u1yjV3vwPAviXD4fR4I42jfmtZ1RGAL2X9zAnUAP1u3zRs5b1NUnNL4edOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=Fxs178FS; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-434a0fd9778so38304845e9.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 02 Dec 2024 04:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140980; x=1733745780; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PYd9QLS1DFmWBH98/OcoHCVn4HW80u7O0xy+afAXA98=;
        b=Fxs178FSSqWiueExvoEFdNUXGnLZy6av/tpqoeOJvBYLxBr6c6YzQ2vVPiqaAQUwVB
         jxdJ7VoXngXqkbMZAG7RXJq9xLsUiUA1DW6Eg2TsiVifAMJ/vyQoktnkbiK+PLzpIMmH
         wnt1RNiHc7OOQyR9PHdfdOo+dvx3peEeYmY09EDQZFSZiAxW9Wc2IZtYbiN9RroMlv0i
         bXRRrd5k/3EH125m9X/XF02CD7ak0MM/ON+28DYnhP/XW34xdMadkQCKl7AJeDnmq8jA
         7lFhaJrIdMNidpQGF8nf4mXLyjukt9LpqcJ0KwMdiqGW11YsI1P+5k61uJdNpVG4UCpL
         UbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140980; x=1733745780;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYd9QLS1DFmWBH98/OcoHCVn4HW80u7O0xy+afAXA98=;
        b=Rd3sKdU80yDaE2vgSlyVOH13vU+tbx4Kz54txbQxVOJIgiLY+bvwaw5MPmjen36J4a
         xuj8Der9BdsDiw/iieszEMmu12mgHrl1154L0jQKmm2VpzcuJf4PkFhp32LUslgwtdiA
         75X5yleaNSlikK+9JzitVR1rJ/gdjK+ZXv2gjFj37rTpocqKVIHyMO6Inu+WiW2MKc2u
         sllq1rkiZE/v3JN9ZxxmVVc6t9AtxehIAn0xdQoi3YEAM4gLG8qnAruGYeMC4h0uUpOv
         DKwC29sUx4J9hFKHbzJ8hb3iPinGlQ762h8EIJsuA7h01ueRPlZVjcHSWh4fkRo49AzR
         Wh2w==
X-Forwarded-Encrypted: i=1; AJvYcCWW3NRG5tpO8q6k7heg4CqZgw6PRt5k1DtFRyLMKN7+vL+PQX4wJjLRunZasPU3PVvBm8u1UCryeeKEdtL9@vger.kernel.org
X-Gm-Message-State: AOJu0YwSVtTsOhnpTpcN9z537GGifIMoP5kaXMPGifrJELTTjZtZMcQN
	vuBug6C/Kh8RRxSzVuInJaUnK9tagf58pMorusuzRXaHpu62ZptVdwvcvCBFbNs=
X-Gm-Gg: ASbGnctXhFxRu6dh58LLW1gzLkkDg52iB4CnU8gHPs+uRVsj4rkOBZHZtwfw1cK9IGj
	UV4xmMGo/LGHNTm1aZ4vxpkFWd1mM25/ZNZZiZNh/ew/sZMWxSeRoArB093oqBSY5qx4z21xUHt
	TJsy9m4ScI0tWeGnPHQ9PlYfTCTwOGyPp0vFbKCba48NDQD32XEtDHjTYkxiiGFJabpSnv93dto
	tk0vipASox/hHh1G9+Xu7YTllBoNpWaZKDiXiI/
X-Google-Smtp-Source: AGHT+IH0sFHTrv69HUdG+L8j6VdCnN8rBYNeyeTlRD+CzCFrwH/SAYb29NCJbhplyj0igslu9w0Q2A==
X-Received: by 2002:a05:600c:588c:b0:434:a7e3:db50 with SMTP id 5b1f17b1804b1-434a9df26cbmr164746035e9.21.1733140979519;
        Mon, 02 Dec 2024 04:02:59 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:02:59 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:27 +0100
Subject: [PATCH RESEND v7 11/17] soc: qcom: ice: add support for
 generating, importing and preparing keys
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-11-67c3ca3f3282@linaro.org>
References: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
In-Reply-To: <20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4969;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=wBmla9vpsk6IBou1zRMUSL0Tc/0bcTxXP/Te/sINSVg=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHVlurYu6yUto1xPH8+t0uD32/BAubsZIDSD
 KpG+fHxPN6JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1QAKCRARpy6gFHHX
 cnYzD/4iS5EmKewFMxerNwnCDZ06zB2aegC187jsiQelALVuMOCjEtjnIdq+IBsg+5Bd95kxxut
 AjMNK+unKpUaISzjphujFll8jvVmldtEYZQ3A1kC0uiKhSymgaLeBKIDx9oipPlzVjK5f84J6ay
 Ey72wMbnEhKM0OAT153STQnYD4aIqHCRnlvdsISbnaPCe9PmsJV8L0XowD+04nJ1W0JTQu+HBll
 X6OSinVUm52afgcSR6cuCKK1Sg1tLxgGXxXYmj9TrdXgXx0rZPBH2sa9TCxUl2fadX+hazHxa7q
 PUCRMczS1ZdaEIrdjC8RV6rPxvly9GxSCjYCmNI5yDgtIkox3eOmB+jKTLOERWTcAKYCT/dZfKm
 Y0mIz+EEWaZRQhOtsNFQgZoZxLUB8e7vIhlZFh1NmOnuy3dNhCQmosgpYSn3nHwO5xccu6KkWUO
 jgr6md2l7GCiQZl70zPFFRImvlbO+xTEc9VZyc59fkpf9KoHVhcyCysgB90TeL0IF/hSnki6LH8
 9oiv/s0/cf65N2m16fRQ1q2S4gGmhnnekolXyTiRbOisI7FgG0vYyZRO0ni8D2La+EkXhEMVKIj
 o8GThV5BypWpTOq0KnJA8XwlULQiwYBmOWpdO2lKvMaRMAZDkyk0vS8z9rwA5LsgOUSiuWYRpvr
 VIB7GYqgN9RV3gA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

With the new SCM calls that interface with TrustZone and allow us to use
the Hardware Key Manager functionality, we can now add support for
hardware wrapped keys to the Qualcomm ICE SoC driver.

Upcoming patches will connect that layer with the block layer ioctls.

Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/soc/qcom/ice.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  8 +++++
 2 files changed, 89 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index e83e74e39e44f..6f0c6fcaf0f3d 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -22,6 +22,13 @@
 
 #define AES_256_XTS_KEY_SIZE			64
 
+/*
+ * Wrapped key sizes that HWKM expects and manages is different for different
+ * versions of the hardware.
+ */
+#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
+	((v) == 1 ? 68 : 100)
+
 /* QCOM ICE registers */
 #define QCOM_ICE_REG_VERSION			0x0008
 #define QCOM_ICE_REG_FUSE_SETTING		0x0010
@@ -454,6 +461,80 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
 }
 EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
 
+/**
+ * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: long-term wrapped key to be generated, which is
+ *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to generate a wrapped key for storage
+ * encryption using hwkm.
+ *
+ * Returns: 0 on success, -errno on failure.
+ */
+int qcom_ice_generate_key(struct qcom_ice *ice,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+
+	if (!qcom_scm_generate_ice_key(lt_key, wk_size))
+		return wk_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
+
+/**
+ * qcom_ice_prepare_key() - Prepare a long-term wrapped key for inline encryption
+ * @ice: ICE driver data
+ * @lt_key: longterm wrapped key that was generated or imported.
+ * @lt_key_size: size of the longterm wrapped_key
+ * @eph_key: wrapped key returned which has been wrapped with a per-boot ephemeral key,
+ *           size of which is BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to prepare a wrapped key for storage
+ * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
+ * key using hwkm.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_ice_prepare_key(struct qcom_ice *ice, const u8 *lt_key, size_t lt_key_size,
+			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+
+	if (!qcom_scm_prepare_ice_key(lt_key, lt_key_size, eph_key, wk_size))
+		return wk_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
+
+/**
+ * qcom_ice_import_key() - Import a raw key for inline encryption
+ * ice: ICE driver data
+ * @imp_key: raw key that has to be imported
+ * @imp_key_size: size of the imported key
+ * @lt_key: longterm wrapped key that is imported, which is
+ *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to import a raw key for storage encryption
+ * and generate a longterm wrapped key using hwkm.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_ice_import_key(struct qcom_ice *ice, const u8 *imp_key, size_t imp_key_size,
+			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
+
+	if (!qcom_scm_import_ice_key(imp_key, imp_key_size, lt_key, wk_size))
+		return wk_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(qcom_ice_import_key);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index dabe0d3a1fd05..dcf277d196ff6 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -39,5 +39,13 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
 int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
 			      unsigned int wkey_size,
 			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+int qcom_ice_generate_key(struct qcom_ice *ice,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+			 const u8 *lt_key, size_t lt_key_size,
+			 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_import_key(struct qcom_ice *ice,
+			const u8 *imp_key, size_t imp_key_size,
+			u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */

-- 
2.45.2


