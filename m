Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDD1759C05
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjGSRID (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjGSRIA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:08:00 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852821BB;
        Wed, 19 Jul 2023 10:07:58 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36J9XW9G028241;
        Wed, 19 Jul 2023 17:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=JMznsxooVNul9VRu0QmMIpXao0bHsI/ubHq2T4F+iiA=;
 b=d/oeFt9yRpNMy2rmedkEPgdhu0AXGebmlWmr8QGuhx7W3zqQGelc7vlHssaF6TVlUK+o
 Q0GPr+aNJuDRgbdxv1SKoWssaXruEtYsqHpfQ1Z/ET44i1fwolnN6m5O5ouTzCNsXZf2
 1rjsUkRtPCF7Bt2wHbN47vILE0kG03j529mGDZ9QdhmbVg3LUOpdhmPZVYAHY0dk186e
 F9B8W1AvxvWlthWu88r0+dbsgbHW/qmKIGLHS9qnmax0qEKpgKIUEUnQoK+z987Di3aD
 OyxOeYzjcI9byy7KgfKvJPhH9eoQW5j4Iz3QslQs9W91vFS4XeICdrSagX8mpsDeO3x2 Tw== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rxd98h398-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:55 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JH7tHH010460
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:55 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 10:07:54 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 09/10] soc: qcom: support for generate, import and prepare key
Date:   Wed, 19 Jul 2023 10:04:23 -0700
Message-ID: <20230719170423.220033-10-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: srvzfonvEtBfR2apB79_tkdRjbYa0XU8
X-Proofpoint-ORIG-GUID: srvzfonvEtBfR2apB79_tkdRjbYa0XU8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_12,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=908 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Implements the ICE apis for generate, prepare and import key
apis and hooks it up the scm calls defined for them.
Key management has to be done from Qualcomm Trustzone as only
it can interface with HWKM.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/soc/qcom/ice.c | 72 ++++++++++++++++++++++++++++++++++++++++++
 include/soc/qcom/ice.h |  8 +++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 33f67fcfa1bc..16f7af74ddb0 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -19,6 +19,13 @@
 
 #define AES_256_XTS_KEY_SIZE			64
 
+/*
+ * Wrapped key sizes from HWKm is different for different versions of
+ * HW. It is not expected to change again in the future.
+ */
+#define QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(v)	\
+	((v) == 1 ? 68 : 100)
+
 /* QCOM ICE registers */
 #define QCOM_ICE_REG_VERSION			0x0008
 #define QCOM_ICE_REG_FUSE_SETTING		0x0010
@@ -412,6 +419,71 @@ int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wrapped_key[],
 }
 EXPORT_SYMBOL_GPL(qcom_ice_derive_sw_secret);
 
+/**
+ * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
+ * @longterm_wrapped_key: wrapped key that is generated, which is
+ *                        BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to generate a wrapped key for storage
+ * encryption using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qcom_ice_generate_key(struct qcom_ice *ice,
+	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_generate_ice_key(longterm_wrapped_key,
+				QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+}
+EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
+
+/**
+ * qcom_ice_prepare_key() - Prepare a longterm wrapped key for inline encryption
+ * @longterm_wrapped_key: wrapped key that is generated,
+ * @longterm_wrapped_key_size: size of the longterm wrapped_key
+ * @ephemerally_wrapped_key: wrapped key returned which has been wrapped with
+ *                           a per-boot ephemeral key, size of which is
+ *                           BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to prepare a wrapped key for storage
+ * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
+ * key using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+	const u8 *longterm_wrapped_key, unsigned int longterm_wrapped_key_size,
+	u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_prepare_ice_key(longterm_wrapped_key,
+				longterm_wrapped_key_size,
+				ephemerally_wrapped_key,
+				QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+}
+EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
+
+/**
+ * qcom_ice_import_key() - Import a raw key for inline encryption
+ * @imported_key: raw key that has to be imported
+ * @imported_key_size: size of the imported key
+ * @longterm_wrapped_key: wrapped key that is imported, which is
+ *                        BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
+ *
+ * Make a scm call into trustzone to import a raw key for storage encryption
+ * and generating a longterm wrapped key using hwkm.
+ *
+ * Return: 0 on success; err on failure.
+ */
+int qcom_ice_import_key(struct qcom_ice *ice,
+	const u8 *imported_key, unsigned int imported_key_size,
+	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	return qcom_scm_import_ice_key(imported_key, imported_key_size,
+				longterm_wrapped_key,
+				QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version));
+}
+EXPORT_SYMBOL_GPL(qcom_ice_import_key);
+
 static struct qcom_ice *qcom_ice_create(struct device *dev,
 					void __iomem *base)
 {
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 22ab8d1a56de..ce41ec442657 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -39,5 +39,13 @@ bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
 int qcom_ice_derive_sw_secret(struct qcom_ice *ice, const u8 wrapped_key[],
 			      unsigned int wrapped_key_size,
 			      u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+int qcom_ice_generate_key(struct qcom_ice *ice,
+	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_prepare_key(struct qcom_ice *ice,
+	const u8 *longterm_wrapped_key, unsigned int longterm_wrapped_key_size,
+	u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+int qcom_ice_import_key(struct qcom_ice *ice,
+	const u8 *imported_key, unsigned int imported_key_size,
+	u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */
-- 
2.25.1

