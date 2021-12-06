Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E56146AE07
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377028AbhLFXCu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:50 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:15870 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377162AbhLFXCo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831555; x=1670367555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=NmElV7T+xzPa6AFGYUpxLexgr3R7EJAkax7bo6Hf2K0=;
  b=HSMzcP5U8wku5t0X37e2TEqc7X5MsGdXZQE/93HYImdzDH6SChTucqTx
   xi7ohUrsDDQO54NUNyxJllUgwtaRzSxUalCW5Sfy//Q7KZhX36cE2JUqW
   c/rOx7vhmE9biAKTl8ZPgvTKNpTIKG5Z83SGH+pPXPepDvPkwUVMlH8AM
   Q=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 06 Dec 2021 14:59:12 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:12 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:12 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:11 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 09/10] soc: qcom: support for generate, import and prepare key
Date:   Mon, 6 Dec 2021 14:57:24 -0800
Message-ID: <20211206225725.77512-10-quic_gaurkash@quicinc.com>
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

Implements the vops for generate, prepare and import key
apis and hooks it up the scm calls defined for them.
Key management has to be done from Qualcomm Trustzone as only
it can interface with HWKM.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/scsi/ufs/ufs-qcom-ice.c   | 22 ++++++++
 drivers/scsi/ufs/ufs-qcom.c       |  3 ++
 drivers/scsi/ufs/ufs-qcom.h       | 12 +++++
 drivers/soc/qcom/qti-ice-common.c | 89 ++++++++++++++++++++++++++++---
 include/linux/qti-ice-common.h    |  8 +++
 5 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ice.c
index c8305aab6714..7f0485553d75 100644
--- a/drivers/scsi/ufs/ufs-qcom-ice.c
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -130,3 +130,25 @@ int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 *wrapped_key,
 					wrapped_key, wrapped_key_size,
 					sw_secret);
 }
+
+int ufs_qcom_ice_generate_key(
+	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qti_ice_generate_key(longterm_wrapped_key);
+}
+
+int ufs_qcom_ice_prepare_key(const u8 *longterm_wrapped_key,
+		unsigned int longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qti_ice_prepare_key(longterm_wrapped_key, longterm_wrapped_key_size,
+				   ephemerally_wrapped_key);
+}
+
+int ufs_qcom_ice_import_key(const u8 *imported_key,
+		unsigned int imported_key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qti_ice_import_key(imported_key, imported_key_size,
+				   longterm_wrapped_key);
+}
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 9f85332fbe64..cbd472844065 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1496,6 +1496,9 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.config_scaling_param = ufs_qcom_config_scaling_param,
 	.program_key		= ufs_qcom_ice_program_key,
 	.derive_secret		= ufs_qcom_ice_derive_sw_secret,
+	.generate_key		= ufs_qcom_ice_generate_key,
+	.prepare_key		= ufs_qcom_ice_prepare_key,
+	.import_key		= ufs_qcom_ice_import_key,
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index e7da3d1dc3c7..1f8ed9adb28f 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -259,6 +259,14 @@ int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 int ufs_qcom_ice_derive_sw_secret(struct ufs_hba *hba, const u8 *wrapped_key,
 				  unsigned int wrapped_key_size,
 				  u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+int ufs_qcom_ice_generate_key(
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int ufs_qcom_ice_prepare_key(const u8 *longterm_wrapped_key,
+		unsigned int longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int ufs_qcom_ice_import_key(const u8 *imported_key,
+		unsigned int imported_key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 #else
 static inline int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 {
@@ -273,6 +281,10 @@ static inline int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
 	return 0;
 }
 #define ufs_qcom_ice_program_key NULL
+#define ufs_qcom_ice_derive_sw_secret NULL
+#define ufs_qcom_ice_generate_key NULL
+#define ufs_qcom_ice_prepare_key NULL
+#define ufs_qcom_ice_import_key NULL
 #endif /* !CONFIG_SCSI_UFS_CRYPTO */
 
 #endif /* UFS_QCOM_H_ */
diff --git a/drivers/soc/qcom/qti-ice-common.c b/drivers/soc/qcom/qti-ice-common.c
index 76703afa4834..cc035f1a1d42 100644
--- a/drivers/soc/qcom/qti-ice-common.c
+++ b/drivers/soc/qcom/qti-ice-common.c
@@ -13,13 +13,21 @@
 
 #define QTI_ICE_MAX_BIST_CHECK_COUNT    100
 #define QTI_AES_256_XTS_KEY_RAW_SIZE	64
+#define QTI_HWKM_WRAPPED_KEY_SIZE_V1	68
+#define QTI_HWKM_WRAPPED_KEY_SIZE_V2	100
 
 /*
  * ICE resets during power collapse and HWKM has to be
  * reconfigured which can be kept track with this flag.
  */
 static bool qti_hwkm_init_done;
-static int hwkm_version;
+static int qti_hwkm_version;
+
+/*
+ * Size of the wrapped key returned by HWKM, which varies with
+ * hwkm version
+ */
+static unsigned int qti_hwkm_wrapped_key_size;
 
 union crypto_cfg {
 	__le32 regval;
@@ -45,10 +53,13 @@ static bool qti_ice_supported(const struct ice_mmio_data *mmio)
 		return false;
 	}
 
-	if ((major >= 4) || ((major == 3) && (minor == 2) && (step >= 1)))
-		hwkm_version = 2;
-	else
-		hwkm_version = 1;
+	if ((major >= 4) || ((major == 3) && (minor == 2) && (step >= 1))) {
+		qti_hwkm_wrapped_key_size = QTI_HWKM_WRAPPED_KEY_SIZE_V2;
+		qti_hwkm_version = 2;
+	} else {
+		qti_hwkm_wrapped_key_size = QTI_HWKM_WRAPPED_KEY_SIZE_V1;
+		qti_hwkm_version = 1;
+	}
 
 	pr_info("Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
 		 major, minor, step);
@@ -168,7 +179,7 @@ static int qti_ice_program_wrapped_key(const struct ice_mmio_data *mmio,
 	 * won't work.
 	 */
 	if (!qti_hwkm_init_done) {
-		err = qti_ice_hwkm_init(mmio, hwkm_version);
+		err = qti_ice_hwkm_init(mmio, qti_hwkm_version);
 		if (err) {
 			pr_err("%s: Error initializing hwkm, err = %d",
 							__func__, err);
@@ -322,4 +333,70 @@ int qti_ice_derive_sw_secret(const struct ice_mmio_data *mmio,
 }
 EXPORT_SYMBOL_GPL(qti_ice_derive_sw_secret);
 
+/**
+ * qti_ice_generate_key() - Generate a wrapped key for inline encryption
+ * @longterm_wrapped_key: wrapped key that is generated, which is at most
+ *                        BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to generate a wrapped key for storage
+ * encryption using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_generate_key(
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_generate_ice_key(longterm_wrapped_key,
+			       qti_hwkm_wrapped_key_size);
+}
+EXPORT_SYMBOL_GPL(qti_ice_generate_key);
+
+/**
+ * qti_ice_prepare_key() - Prepare a longterm wrapped key for inline encryption
+ * @longterm_wrapped_key: wrapped key that is generated,
+ * @longterm_wrapped_key_size: size of the longterm wrapped_key
+ * @ephemerally_wrapped_key: wrapped key returned which has been wrapped with
+ *                           a per-boot ephemeral key, size of which is at most
+ *                           BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE
+ *
+ * Make a scm call into trustzone to prepare a wrapped key for storage
+ * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
+ * key using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_prepare_key(const u8 *longterm_wrapped_key,
+		unsigned int longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_prepare_ice_key(longterm_wrapped_key,
+				    longterm_wrapped_key_size,
+				    ephemerally_wrapped_key,
+				    qti_hwkm_wrapped_key_size);
+}
+EXPORT_SYMBOL_GPL(qti_ice_prepare_key);
+
+/**
+ * qti_ice_import_key() - Importa raw key for inline encryption
+ * @imported_key: raw key that has to be imported
+ * @imported_key_size: size of the imported key
+ * @longterm_wrapped_key: longterm wrapped key returned which has been wrapped
+ *                        after imporint the raw key using hwkm.
+ *
+ * Make a scm call into trustzone to import a raw key for storage encryption
+ * and generating a longterm wrapped key using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qti_ice_import_key(const u8 *imported_key,
+		unsigned int imported_key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_import_ice_key(imported_key,
+				    imported_key_size,
+				    longterm_wrapped_key,
+				    qti_hwkm_wrapped_key_size);
+}
+EXPORT_SYMBOL_GPL(qti_ice_import_key);
+
 MODULE_LICENSE("GPL v2");
diff --git a/include/linux/qti-ice-common.h b/include/linux/qti-ice-common.h
index e329afeba113..cae5275ee1d9 100644
--- a/include/linux/qti-ice-common.h
+++ b/include/linux/qti-ice-common.h
@@ -28,5 +28,13 @@ int qti_ice_derive_sw_secret(const struct ice_mmio_data *mmio,
 			     const u8 *wrapped_key,
 			     unsigned int wrapped_key_size,
 			     u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+int qti_ice_generate_key(
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qti_ice_prepare_key(const u8 *longterm_wrapped_key,
+		unsigned int longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qti_ice_import_key(const u8 *imported_key,
+		unsigned int imported__key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 
 #endif /* _QTI_ICE_COMMON_H */
-- 
2.17.1

