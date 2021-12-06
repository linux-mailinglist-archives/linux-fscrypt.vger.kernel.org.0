Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6948046AE00
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358903AbhLFXCt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:49 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:16498 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377123AbhLFXCl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831552; x=1670367552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ECagi/BaTQQeNMjMZWtRvSI3lnAfi1QCeUU8K69Xtrc=;
  b=QVoeE1ap3nytNDbvoJ7JPdryF15qrlIBxmU/X64RlD1FTNKkusLCtPOj
   iDv49cQAzXwA52JjjmpYCTtZ4HZy4JYMpkkqE6qKswXV9Yk6fHQUMjkhT
   Dmsxj4t+EZXGvdkQ5EQlGMoYxu1P0z3JcltsuUXLNnR/erLPFwk5v9NaL
   s=;
Received: from ironmsg08-lv.qualcomm.com ([10.47.202.152])
  by alexa-out.qualcomm.com with ESMTP; 06 Dec 2021 14:59:11 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg08-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:11 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:10 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:10 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 08/10] scsi: ufs: add support for generate, import and prepare keys
Date:   Mon, 6 Dec 2021 14:57:23 -0800
Message-ID: <20211206225725.77512-9-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch contains two changes in UFS for wrapped keys.
1. Implements the blk_crypto_profile ops for generate, import
   and prepare key apis.
2. Adds UFS vops for generate, import and prepare keys so
   that vendors can hooks to them.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 50 ++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h        | 11 +++++++
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 9d68621a0eb4..2bea9b924f77 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -136,9 +136,9 @@ bool ufshcd_crypto_enable(struct ufs_hba *hba)
 }
 
 static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
-				const u8 *wrapped_key,
-				unsigned int wrapped_key_size,
-				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+					  const u8 *wrapped_key,
+					  unsigned int wrapped_key_size,
+					  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
 {
 	struct ufs_hba *hba =
 		container_of(profile, struct ufs_hba, crypto_profile);
@@ -146,6 +146,47 @@ static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
 	if (hba->vops && hba->vops->derive_secret)
 		return  hba->vops->derive_secret(hba, wrapped_key,
 						 wrapped_key_size, sw_secret);
+	return 0;
+}
+
+static int ufshcd_crypto_generate_key(struct blk_crypto_profile *profile,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->generate_key)
+		return  hba->vops->generate_key(longterm_wrapped_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_prepare_key(struct blk_crypto_profile *profile,
+		const u8 *longterm_wrapped_key,
+		size_t longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->prepare_key)
+		return  hba->vops->prepare_key(longterm_wrapped_key,
+			longterm_wrapped_key_size, ephemerally_wrapped_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_import_key(struct blk_crypto_profile *profile,
+		const u8 *imported_key,
+		size_t imported_key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->import_key)
+		return  hba->vops->import_key(imported_key,
+			imported_key_size, longterm_wrapped_key);
 
 	return -EOPNOTSUPP;
 }
@@ -154,6 +195,9 @@ static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
 	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
+	.generate_key		= ufshcd_crypto_generate_key,
+	.prepare_key		= ufshcd_crypto_prepare_key,
+	.import_key		= ufshcd_crypto_import_key,
 };
 
 static enum blk_crypto_mode_num
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 095c2d660aa7..88cd21dec0d9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -321,6 +321,10 @@ struct ufs_pwr_mode_info {
  * @program_key: program or evict an inline encryption key
  * @event_notify: called to notify important events
  * @derive_secret: derive sw secret from wrapped inline encryption key
+ * @generate_key: generate a longterm wrapped key for inline encryption
+ * @prepare_key: prepare the longterm wrapped key for inline encryption
+ *               by rewrapping with a ephemeral wrapping key.
+ * @import_key: import a raw key and return a longterm wrapped key.
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -362,6 +366,13 @@ struct ufs_hba_variant_ops {
 	int	(*derive_secret)(struct ufs_hba *hba, const u8 *wrapped_key,
 				 unsigned int wrapped_key_size,
 				 u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+	int	(*generate_key)(u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*prepare_key)(const u8 *longterm_wrapped_key,
+			       unsigned int longterm_wrapped_key_size,
+			       u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*import_key)(const u8 *imported_key,
+			       unsigned int imported_key_size,
+			       u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 };
 
 /* clock gating state  */
-- 
2.17.1

