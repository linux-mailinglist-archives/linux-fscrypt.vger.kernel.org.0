Return-Path: <linux-fscrypt+bounces-18-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E4087F3D8D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 06:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 801291C20E4E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 05:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282671862A;
	Wed, 22 Nov 2023 05:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="Fkpvjr35"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE81490;
	Tue, 21 Nov 2023 21:40:16 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM4gQAQ002640;
	Wed, 22 Nov 2023 05:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=VKy4AqQmSGgASyr/o7WdXxPJW8Vw4XQPgGkyX5tbYbI=;
 b=Fkpvjr35MsgfARBRx0vNe/Ilua8Q7+cnTdw3PXf9QsKFs3UZx6Nl+L4uuJCnH3vrz6r3
 IYWfSkGrVUBQHTmMrXF1HbQtSO0wYfuKi391mkSh0HkoGyLjHvivFXKdJbK4/b6yPP87
 N81hYJIxi5sf3vqtjkz98D0ynQrTIEHVxs+xXwSARmP179KN4FI1OHabvPVgt1fXauZr
 CLLT19X7dnniFnfNrTfdxRiOeuq8fLTxjxAHqsBeAcfmhoks4sV+QRbPYGHfRWEx9aVE
 fCgju+FhkSNigJHBk1ajIwJMqAtP9HreGK+zY9MhDotUhGM2U1ns3KPfdBFXUd9ppJ6O Wg== 
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uguwxte40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:13 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AM5eCi6018749
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:12 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 21 Nov 2023 21:40:01 -0800
From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
To: <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>, <neil.armstrong@linaro.org>,
        <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>,
        Gaurav Kashyap
	<quic_gaurkash@quicinc.com>
Subject: [PATCH v3 04/12] soc: qcom: ice: support for hardware wrapped keys
Date: Tue, 21 Nov 2023 21:38:09 -0800
Message-ID: <20231122053817.3401748-5-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: cOynB6aPtvNRxd2MlM6jRt2YK6I7zs6_
X-Proofpoint-ORIG-GUID: cOynB6aPtvNRxd2MlM6jRt2YK6I7zs6_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_03,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 impostorscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220040

Now that HWKM support is added to ICE, extend the ICE
driver to support hardware wrapped keys programming coming
in from the storage controllers (ufs and emmc). The patches that follow
will add ufs and emmc support.

Derive software secret support is also added by forwarding the
call the corresponding scm api.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/soc/qcom/ice.c | 114 +++++++++++++++++++++++++++++++++++++----
 include/soc/qcom/ice.h |   4 ++
 2 files changed, 107 insertions(+), 11 deletions(-)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index adf9cab848fa..ee7c0beef3d2 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -27,6 +27,8 @@
 #define QCOM_ICE_REG_BIST_STATUS		0x0070
 #define QCOM_ICE_REG_ADVANCED_CONTROL		0x1000
 #define QCOM_ICE_REG_CONTROL			0x0
+#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16		0x4040
+
 /* QCOM ICE HWKM registers */
 #define QCOM_ICE_REG_HWKM_TZ_KM_CTL			0x1000
 #define QCOM_ICE_REG_HWKM_TZ_KM_STATUS			0x1004
@@ -37,6 +39,7 @@
 #define QCOM_ICE_REG_HWKM_BANK0_BBAC_3			0x500C
 #define QCOM_ICE_REG_HWKM_BANK0_BBAC_4			0x5010
 
+/* QCOM ICE HWKM BIST vals */
 #define QCOM_ICE_HWKM_BIST_DONE_V1_VAL		0x11
 #define QCOM_ICE_HWKM_BIST_DONE_V2_VAL		0x287
 
@@ -47,6 +50,8 @@
 #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK	0x2
 #define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK	0x4
 
+#define QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET	0x80
+
 #define QCOM_ICE_HWKM_REG_OFFSET	0x8000
 #define HWKM_OFFSET(reg)		((reg) + QCOM_ICE_HWKM_REG_OFFSET)
 
@@ -67,6 +72,16 @@ struct qcom_ice {
 	bool hwkm_init_complete;
 };
 
+union crypto_cfg {
+	__le32 regval;
+	struct {
+		u8 dusize;
+		u8 capidx;
+		u8 reserved;
+		u8 cfge;
+	};
+};
+
 static bool qcom_ice_check_supported(struct qcom_ice *ice)
 {
 	u32 regval = qcom_ice_readl(ice, QCOM_ICE_REG_VERSION);
@@ -237,6 +252,8 @@ static void qcom_ice_hwkm_init(struct qcom_ice *ice)
 	/* Clear HWKM response FIFO before doing anything */
 	qcom_ice_writel(ice, 0x8,
 			HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
+
+	ice->hwkm_init_complete = true;
 }
 
 int qcom_ice_enable(struct qcom_ice *ice)
@@ -284,6 +301,51 @@ int qcom_ice_suspend(struct qcom_ice *ice)
 }
 EXPORT_SYMBOL_GPL(qcom_ice_suspend);
 
+/*
+ * HW dictates the internal mapping between the ICE and HWKM slots,
+ * which are different for different versions, make the translation
+ * here. For v1 however, the translation is done in trustzone.
+ */
+static int translate_hwkm_slot(struct qcom_ice *ice, int slot)
+{
+	return (ice->hwkm_version == 1) ? slot : (slot * 2);
+}
+
+static int qcom_ice_program_wrapped_key(struct qcom_ice *ice,
+					const struct blk_crypto_key *key,
+					u8 data_unit_size, int slot)
+{
+	int hwkm_slot;
+	int err;
+	union crypto_cfg cfg;
+
+	hwkm_slot = translate_hwkm_slot(ice, slot);
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.dusize = data_unit_size;
+	cfg.capidx = QCOM_SCM_ICE_CIPHER_AES_256_XTS;
+	cfg.cfge = 0x80;
+
+	/* Clear CFGE */
+	qcom_ice_writel(ice, 0x0, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
+				  QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);
+
+	/* Call trustzone to program the wrapped key using hwkm */
+	err = qcom_scm_ice_set_key(hwkm_slot, key->raw, key->size,
+				   QCOM_SCM_ICE_CIPHER_AES_256_XTS, data_unit_size);
+	if (err) {
+		pr_err("%s:SCM call Error: 0x%x slot %d\n", __func__, err,
+		       slot);
+		return err;
+	}
+
+	/* Enable CFGE after programming key */
+	qcom_ice_writel(ice, cfg.regval, QCOM_ICE_LUT_KEYS_CRYPTOCFG_R16 +
+					 QCOM_ICE_LUT_KEYS_CRYPTOCFG_OFFSET * slot);
+
+	return err;
+}
+
 int qcom_ice_program_key(struct qcom_ice *ice,
 			 u8 algorithm_id, u8 key_size,
 			 const struct blk_crypto_key *bkey,
@@ -299,24 +361,31 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 
 	/* Only AES-256-XTS has been tested so far. */
 	if (algorithm_id != QCOM_ICE_CRYPTO_ALG_AES_XTS ||
-	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256) {
+	    (key_size != QCOM_ICE_CRYPTO_KEY_SIZE_256 &&
+	    key_size != QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED)) {
 		dev_err_ratelimited(dev,
 				    "Unhandled crypto capability; algorithm_id=%d, key_size=%d\n",
 				    algorithm_id, key_size);
 		return -EINVAL;
 	}
 
-	memcpy(key.bytes, bkey->raw, AES_256_XTS_KEY_SIZE);
-
-	/* The SCM call requires that the key words are encoded in big endian */
-	for (i = 0; i < ARRAY_SIZE(key.words); i++)
-		__cpu_to_be32s(&key.words[i]);
+	if (bkey->crypto_cfg.key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		if (!ice->use_hwkm)
+			return -EINVAL;
+		err = qcom_ice_program_wrapped_key(ice, bkey, data_unit_size,
+						   slot);
+	} else {
+		memcpy(key.bytes, bkey->raw, AES_256_XTS_KEY_SIZE);
 
-	err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
-				   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
-				   data_unit_size);
+		/* The SCM call requires that the key words are encoded in big endian */
+		for (i = 0; i < ARRAY_SIZE(key.words); i++)
+			__cpu_to_be32s(&key.words[i]);
 
-	memzero_explicit(&key, sizeof(key));
+		err = qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+					   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+					   data_unit_size);
+		memzero_explicit(&key, sizeof(key));
+	}
 
 	return err;
 }
@@ -324,7 +393,21 @@ EXPORT_SYMBOL_GPL(qcom_ice_program_key);
 
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot)
 {
-	return qcom_scm_ice_invalidate_key(slot);
+	int hwkm_slot = slot;
+
+	if (ice->use_hwkm) {
+		hwkm_slot = translate_hwkm_slot(ice, slot);
+	/*
+	 * Ignore calls to evict key when HWKM is supported and hwkm init
+	 * is not yet done. This is to avoid the clearing all slots call
+	 * during a storage reset when ICE is still in legacy mode. HWKM slave
+	 * in ICE takes care of zeroing out the keytable on reset.
+	 */
+		if (!ice->hwkm_init_complete)
+			return 0;
+	}
+
+	return qcom_scm_ice_invalidate_key(hwkm_slot);
 }
 EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
 
@@ -334,6 +417,15 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice)
 }
 EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
 
+int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
+			      unsigned int wkey_size,
+			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	return qcom_scm_derive_sw_secret(wkey, wkey_size,
+					 sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
+}
+EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 1f52e82e3e1c..dabe0d3a1fd0 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -17,6 +17,7 @@ enum qcom_ice_crypto_key_size {
 	QCOM_ICE_CRYPTO_KEY_SIZE_192		= 0x2,
 	QCOM_ICE_CRYPTO_KEY_SIZE_256		= 0x3,
 	QCOM_ICE_CRYPTO_KEY_SIZE_512		= 0x4,
+	QCOM_ICE_CRYPTO_KEY_SIZE_WRAPPED	= 0x5,
 };
 
 enum qcom_ice_crypto_alg {
@@ -35,5 +36,8 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 			 u8 data_unit_size, int slot);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
 bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
+int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wkey[],
+			      unsigned int wkey_size,
+			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */
-- 
2.25.1


