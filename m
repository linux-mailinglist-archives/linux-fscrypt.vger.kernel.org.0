Return-Path: <linux-fscrypt+bounces-14-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D2A7F3D7E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 06:40:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B0391C2100F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 05:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80BFE15480;
	Wed, 22 Nov 2023 05:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="aLk+zLXk"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C9618C;
	Tue, 21 Nov 2023 21:40:10 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM4u8rG016527;
	Wed, 22 Nov 2023 05:40:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=93z+vUlFL3zac8xz5d801XPSydcKKD4BdbQWC478ukc=;
 b=aLk+zLXkAYZoCQWC1L6y731KPJq3sFePbOZ3GezuZCJ1Rr69hJZ45XEv/ONzsF0AiO+0
 M8kBtJAMEICOfB1BIg0B0UldaAMfiwSsun3urFIAol9Dju4J1ILEI7JZXgl9mBV5qb6g
 MufLM2xBSYBt2mbgYMtq8ACl4qRVkHJw/5jd87UBfpHRymLjIiEy16rXGihDoP1f6JDs
 IjMAmol8VsfI5myeLHMQmQMehI/dQGRY9QsRPiHQYpYZzhklbDDnP31L4vJ29JdbWZAQ
 KFo/RKrV92UE5q+sFQ+CfRBxcaCgXRFiAitDTTqUFSxDYd+vYjS+/ElBY07vdKpDoBlc 4w== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ugr85u3e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:07 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AM5e6rD007072
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:07 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 21 Nov 2023 21:40:00 -0800
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
Subject: [PATCH v3 02/12] qcom_scm: scm call for deriving a software secret
Date: Tue, 21 Nov 2023 21:38:07 -0800
Message-ID: <20231122053817.3401748-3-quic_gaurkash@quicinc.com>
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
X-Proofpoint-GUID: 4DjbseLBP3oGwAVrR_P03XWZztbvUR2c
X-Proofpoint-ORIG-GUID: 4DjbseLBP3oGwAVrR_P03XWZztbvUR2c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_02,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=799 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220040

Inline storage encryption requires deriving a sw secret from
the hardware wrapped keys. For non-wrapped keys, this can be
directly done as keys are in the clear.

However, when keys are hardware wrapped, it can be unwrapped
by HWKM (Hardware Key Manager) which is accessible only from Qualcomm
Trustzone. Hence, it also makes sense that the software secret is also
derived there and returned to the linux kernel . This can be invoked by
using the crypto profile APIs provided by the block layer.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 71 ++++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.h       |  1 +
 include/linux/firmware/qcom/qcom_scm.h |  2 +
 3 files changed, 74 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 520de9b5633a..6dfb913f3e33 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1214,6 +1214,77 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
+/**
+ * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
+ * @wkey: the hardware wrapped key inaccessible to software
+ * @wkey_size: size of the wrapped key
+ * @sw_secret: the secret to be derived which is exactly the secret size
+ * @sw_secret_size: size of the sw_secret
+ *
+ * Derive a software secret from a hardware wrapped key for software crypto
+ * operations.
+ * For wrapped keys, the key needs to be unwrapped, in order to derive a
+ * software secret, which can be done in the hardware from a secure execution
+ * environment.
+ *
+ * For more information on sw secret, please refer to "Hardware-wrapped keys"
+ * section of Documentation/block/inline-encryption.rst.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
+			      u8 *sw_secret, size_t sw_secret_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
+					 QCOM_SCM_VAL, QCOM_SCM_RW,
+					 QCOM_SCM_VAL),
+		.args[1] = wkey_size,
+		.args[3] = sw_secret_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	void *wkey_buf, *secret_buf;
+	dma_addr_t wkey_phys, secret_phys;
+	int ret;
+
+	/*
+	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
+	 * get a physical address, while guaranteeing that we can zeroize the
+	 * key material later using memzero_explicit().
+	 */
+	wkey_buf = dma_alloc_coherent(__scm->dev, wkey_size, &wkey_phys, GFP_KERNEL);
+	if (!wkey_buf)
+		return -ENOMEM;
+	secret_buf = dma_alloc_coherent(__scm->dev, sw_secret_size, &secret_phys, GFP_KERNEL);
+	if (!secret_buf) {
+		ret = -ENOMEM;
+		goto err_free_wrapped;
+	}
+
+	memcpy(wkey_buf, wkey, wkey_size);
+	desc.args[0] = wkey_phys;
+	desc.args[2] = secret_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(sw_secret, secret_buf, sw_secret_size);
+
+	memzero_explicit(secret_buf, sw_secret_size);
+
+	dma_free_coherent(__scm->dev, sw_secret_size, secret_buf, secret_phys);
+
+err_free_wrapped:
+	memzero_explicit(wkey_buf, wkey_size);
+
+	dma_free_coherent(__scm->dev, wkey_size, wkey_buf, wkey_phys);
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index 4532907e8489..c75456aa6ac5 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -121,6 +121,7 @@ int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+#define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index ccaf28846054..c65f2d61492d 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -103,6 +103,8 @@ bool qcom_scm_ice_available(void);
 int qcom_scm_ice_invalidate_key(u32 index);
 int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
+int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
+			      u8 *sw_secret, size_t sw_secret_size);
 
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);
-- 
2.25.1


