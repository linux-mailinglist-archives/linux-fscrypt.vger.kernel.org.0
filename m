Return-Path: <linux-fscrypt+bounces-527-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCBE69E01AC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Dec 2024 13:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D13628233B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Dec 2024 12:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF6B20C02B;
	Mon,  2 Dec 2024 12:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="msVinX0e"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3BD20B7FE
	for <linux-fscrypt@vger.kernel.org>; Mon,  2 Dec 2024 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733140996; cv=none; b=W1hySWeZRgOf9VcqSrb9O+K1Rb/95mdTfuWxTZCKSHBNY9t0uAgTgpF2qaUB09IpMs4a1N1hAGMfD7E88Sr9CHsidKG4pdcg6aRZTigNU06dJWX54tRubte0Jyfpt/dqKNwCjAs73gzYObVZWOgLf7DvvqKxJFdfv2IPEXDQOkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733140996; c=relaxed/simple;
	bh=SXqWmFdKruhDvAdboiSEhg1Z6NA3pG4WBm4XMylxPB0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q2QEm3C5VBfRBTP03X2xYGT/meqY+ulbBUrPBT5DhyaOc208oTyy3dUMX6COB1/Kb6oqHnDMrWKjZeZnSaUDyE/UxhWlG72Qn0A5LlTisA4hKl4CkJI5A8++mNpwm8GZhQUYQDW1Px6cudi6AHDB4xN1SwfNxVr/n6n19Hu5dow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=msVinX0e; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-434a9f2da82so35792095e9.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 02 Dec 2024 04:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1733140992; x=1733745792; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/OaNa1GU6C5pLmKUM+e3Rmrgncx6u+ty/51M3vyn6vY=;
        b=msVinX0eg+SNG8oz+pxuhyjeiP5GOVaZUsp3jJ0l/ItLchuUOLk2+DV0ZXpasNK7km
         3R+rlq3JXY08OivHB2mkZmaSHxY/Q7ynXbAWl7uc9uHMmfBMTghPQ3HOE77JDypt5LUT
         C70gS2HAqrSqzfIOIQQ+0mI61tYuuRej3sAeqHh6smvBj2D3IDsSE8yDh7b2i4zSBFTV
         qMsTqpQpJq+X0tNngsSvlQQhtpIh6mp9jVqSRWvVfQhY+6/RgX6rLmu0nvU8xzMxw76c
         37TwYgK7MwRU/ja75g/4bJNuG5ELF9VBVpcNK0HSMJTbnY93YTwqmZUCs5GEBbrO4qCr
         +dSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733140992; x=1733745792;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OaNa1GU6C5pLmKUM+e3Rmrgncx6u+ty/51M3vyn6vY=;
        b=I1ESyyO4ZSLS09wZcN4WWXTx7h+bwCkIOB4+FAWIIrdpLoShVo3c4r0s8Odxc/ZNdI
         2RW4cj46Jz3tN3+cRU3aZz8L/FVMJKnPFSv4r8X74Xr5L3/TWn8v5d/LrA4IJqbqJ2a5
         1KWMQGX5QCpCPNY/tcfpkV6wpZCjFTu6awrCtIzcO2kgBiL89Jv6XSWp6G2Wm30a9DXl
         iOY0LTTcHj/00JPuw7iGSV0Ljok/g30FdYtYW0DKkatdnF5FCR9vSl+r0LZtk2s/aFBJ
         1zgNE+YW4jOg0Hr6SiYqHOMTVqbCa8ZRXGUvylAv7cxjx6sHFl0dYG9XTDDSy7mLKMI0
         hRxw==
X-Forwarded-Encrypted: i=1; AJvYcCVklm1SmCJi1022Z2oKz6OfzhHMIRFEThjsk9cvHlTUZIEfmV0cv4eDdkZj5ZS2IWHky7bTvalZ56ZK5YQK@vger.kernel.org
X-Gm-Message-State: AOJu0YxP+knNBMr+3wVs95rFSb5dqC5mX6fxTPizxMkar0CpnR6HqWcl
	mEOTMS8Gxmfx60mh66nJC0kagG/n5BUGRwU3Rd3+L8ip4pfxA3N2EHIj8BWZiks=
X-Gm-Gg: ASbGnctz8fvCY/NUO+l2o9E6lcuVoCCssSu1std1K+r9vab7sDls07LbvYRMa9ipWVP
	0qj6Gqaa1lF4XIwFoDmuXakpqMkRRj8eEe0WZgPYSO1UeV7EK4gRSmntrQYZpBfnxlDPZXw34wV
	sN3PcrAzEDghQxCwBzbLNDiiy6TMmcm56uVwwG/SksRqHiu8keWwjYy/ovQNgemhupe3wX/ElUt
	cuiSO2Ltq2VYhh13G+EQAhARXW7GJ846BSPK/eD
X-Google-Smtp-Source: AGHT+IGWc47EwqH71rhHjv/KfoAe6eeXRpWu/7Snf36bMmrQREw14b0jX49/ol9dK3YY1FcYfUD0BA==
X-Received: by 2002:a05:600c:3aca:b0:434:a7f1:6545 with SMTP id 5b1f17b1804b1-434a9dfbe52mr188320625e9.27.1733140992113;
        Mon, 02 Dec 2024 04:03:12 -0800 (PST)
Received: from [127.0.1.1] ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0d9bed7sm152396095e9.8.2024.12.02.04.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2024 04:03:11 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Mon, 02 Dec 2024 13:02:33 +0100
Subject: [PATCH RESEND v7 17/17] ufs: host: add support for generating,
 importing and preparing wrapped keys
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241202-wrapped-keys-v7-17-67c3ca3f3282@linaro.org>
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
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.14.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4284;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=3S2Zj/hLbrM4DjwdvlxVSy1kmPJ99K5Qvwb4G0BsQ0U=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnTaHXzRXDCRoQFXnAuSVzn467NjNF+9zLmE0aj
 0uunEU1gB2JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZ02h1wAKCRARpy6gFHHX
 cuOpD/47sYsAvMcTPt3gWFt5Ys+R87FxssehI6pHubn+78bsn3A96WfHX3VZdjGFkUwzq7viptr
 RlKwm+AjcRkZCIAp+ugg5N9+8vPcTORKyP9xbzi7EASkZpDo+IU4OlmiCU4v2zTgcGAcyyrfoZZ
 5Mqwy0vmUjKyZIpos5R7Vo7shS5vI07xLGO+HJdM1HDJKzWrKAvLgFlfxMI3mifhdVSnObs7sIz
 PZ0CGeMWoJohiueJpkAyQXRZfbSFlm74sgWDPkoi6v9jF9xQfmm0fDXDP3mtTwiZ9rmwRUDILhm
 80/0JruiNWEcI6DgtbnR9LCRn9NVRiEcj/CFI6fUpD/g0u1FlzFrOIsV+3vyMqwTigQfduAHnaf
 sKpjFNq+0F+G6zwx+qfv6+m6l0/FqibL/QD368m/6UWEOuA5QdztggCXz/CeAUKS8LnrO1qFpRm
 3NMlOEksrfrnKJDsL5h7Brl5U9AHsY2VotvmZOOv7oBITkFrqej9++l0E1DEoLLnSev9qv0SQ53
 JG5CKq3vK049drq4KYMkWXs/rp3EA3Sa2NOQHBpKztdYLU7AvN67AK6kkGthMVGHTmiamfx7I5V
 SZKIg7FYbj/sALZWC0cI58VEgRQI/d2RllME12D+mExb4lYIMiN+FEzToGsTZKmVFXGfyQzL+jF
 9XB34b80/dF528w==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Extend the UFS core ops to include callbacks for generating, importing
and prepating HW wrapped keys using the lower-level block crypto
operations and implement them for QCom UFS.

Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 34 ++++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h        | 11 +++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0da2674777d2c..58a310e2571b2 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -195,10 +195,41 @@ static int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 wkey[],
 	return qcom_ice_derive_sw_secret(host->ice, wkey, wkey_size, sw_secret);
 }
 
+static int ufs_qcom_ice_generate_key(struct ufs_hba *hba,
+				     u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_generate_key(host->ice, lt_key);
+}
+
+static int ufs_qcom_ice_prepare_key(struct ufs_hba *hba,
+				    const u8 *lt_key, size_t lt_key_size,
+				    u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size,
+				    eph_key);
+}
+
+static int ufs_qcom_ice_import_key(struct ufs_hba *hba,
+				   const u8 *imp_key, size_t imp_key_size,
+				   u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	return qcom_ice_import_key(host->ice, imp_key, imp_key_size,
+				   lt_key);
+}
+
 #else
 
 #define ufs_qcom_ice_program_key NULL
 #define ufs_qcom_ice_derive_sw_secret NULL
+#define ufs_qcom_ice_generate_key NULL
+#define ufs_qcom_ice_prepare_key NULL
+#define ufs_qcom_ice_import_key NULL
 
 static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
 {
@@ -1848,6 +1879,9 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
 	.derive_sw_secret	= ufs_qcom_ice_derive_sw_secret,
+	.generate_key		= ufs_qcom_ice_generate_key,
+	.prepare_key		= ufs_qcom_ice_prepare_key,
+	.import_key		= ufs_qcom_ice_import_key,
 	.reinit_notify		= ufs_qcom_reinit_notify,
 	.mcq_config_resource	= ufs_qcom_mcq_config_resource,
 	.get_hba_mac		= ufs_qcom_get_hba_mac,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dc8c055eae79a..df51c0a96c675 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -326,6 +326,9 @@ struct ufs_pwr_mode_info {
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
  * @derive_sw_secret: derive sw secret from a wrapped key
+ * @generate_key: generate a storage key and return longterm wrapped key
+ * @prepare_key: unwrap longterm key and return ephemeral wrapped key
+ * @import_key: import sw storage key and return longterm wrapped key
  * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
@@ -379,6 +382,14 @@ struct ufs_hba_variant_ops {
 	int	(*derive_sw_secret)(struct ufs_hba *hba, const u8 wkey[],
 				    unsigned int wkey_size,
 				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+	int	(*generate_key)(struct ufs_hba *hba,
+				u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*prepare_key)(struct ufs_hba *hba,
+			       const u8 *lt_key, size_t lt_key_size,
+			       u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*import_key)(struct ufs_hba *hba,
+			      const u8 *imp_key, size_t imp_key_size,
+			      u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,
 				    void *prdt, unsigned int num_segments);

-- 
2.45.2


