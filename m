Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F98759BDB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbjGSRH5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjGSRHx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:07:53 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5ECB7;
        Wed, 19 Jul 2023 10:07:51 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JH0DsZ002694;
        Wed, 19 Jul 2023 17:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=ZWf3H0GEqy6NzOdDGree0WkkScLY1sCT8P7aGx9Ebdo=;
 b=afztzPPNeGWWFb/4iEGAJuxMNEDxiKqZdGFRGXnd8n3XA34OSM7kSltFeeCz9wFbmlLu
 MjvaKTPtThcQ1epIaJ9vZLt8LfuP6JH5TkYgosm1yjZ74Nhz1g9N15aO3v5FdWFk/Cx/
 gvmBHHuvISoLhFH+I25Dlyn9pQQyusx81L0kJrTVJw89ILl/cT5lIPyApx3tL8naOzX6
 /0kCSGD9QD0rWRpowWGilHzeRagjZImjpv8mAgtgaHbsu3FrOB1x9OnTtWgEyqypJ33P
 aAbAAqGcGXVS4kItWObKWgMnYKLThIdN+nkTr3vhWmq7fEVDL43EORSguEntGe/h3WeS NA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rx1hx2ama-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:48 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JH7lKh022209
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:47 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 10:07:46 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 02/10] qcom_scm: scm call for deriving a software secret
Date:   Wed, 19 Jul 2023 10:04:16 -0700
Message-ID: <20230719170423.220033-3-quic_gaurkash@quicinc.com>
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
X-Proofpoint-GUID: dm3-M_1hdMgQ51dNem42Y9zSkfijpc8E
X-Proofpoint-ORIG-GUID: dm3-M_1hdMgQ51dNem42Y9zSkfijpc8E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_11,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 mlxlogscore=828 adultscore=0 clxscore=1015 mlxscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307190154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
 drivers/firmware/qcom_scm.c            | 70 ++++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h            |  1 +
 include/linux/firmware/qcom/qcom_scm.h |  3 ++
 3 files changed, 74 insertions(+)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index fde33acd46b7..51062d5c7f7b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1140,6 +1140,76 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL(qcom_scm_ice_set_key);
 
+/**
+ * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped key
+ * @wrapped_key: the wrapped key used for inline encryption
+ * @wrapped_key_size: size of the wrapped key
+ * @sw_secret: the secret to be derived which is exactly the secret size
+ * @secret_size: size of the secret
+ *
+ * Derive a SW secret from a HW Wrapped key for non HW key operations.
+ * For wrapped keys, the key needs to be unwrapped, in order to derive a
+ * SW secret, which can be done only by the secure EE.
+ *
+ * For more information on sw secret, please refer to "Hardware-wrapped keys"
+ * section of Documentation/block/inline-encryption.rst.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
+			      u8 *sw_secret, u32 secret_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
+					 QCOM_SCM_VAL, QCOM_SCM_RW,
+					 QCOM_SCM_VAL),
+		.args[1] = wrapped_key_size,
+		.args[3] = secret_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	void *keybuf, *secretbuf;
+	dma_addr_t key_phys, secret_phys;
+	int ret;
+
+	/*
+	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
+	 * get a physical address, while guaranteeing that we can zeroize the
+	 * key material later using memzero_explicit().
+	 *
+	 */
+	keybuf = dma_alloc_coherent(__scm->dev, wrapped_key_size, &key_phys,
+				    GFP_KERNEL);
+	if (!keybuf)
+		return -ENOMEM;
+	secretbuf = dma_alloc_coherent(__scm->dev, secret_size, &secret_phys,
+				    GFP_KERNEL);
+	if (!secretbuf) {
+		ret = -ENOMEM;
+		goto bail_keybuf;
+	}
+
+	memcpy(keybuf, wrapped_key, wrapped_key_size);
+	desc.args[0] = key_phys;
+	desc.args[2] = secret_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(sw_secret, secretbuf, secret_size);
+
+	memzero_explicit(secretbuf, secret_size);
+	dma_free_coherent(__scm->dev, secret_size, secretbuf, secret_phys);
+
+bail_keybuf:
+	memzero_explicit(keybuf, wrapped_key_size);
+	dma_free_coherent(__scm->dev, wrapped_key_size, keybuf, key_phys);
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index e6e512bd57d1..c145cdc71ff8 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -119,6 +119,7 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+#define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 250ea4efb7cb..20f5d0b7dfd4 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -109,6 +109,9 @@ extern int qcom_scm_ice_invalidate_key(u32 index);
 extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 				enum qcom_scm_ice_cipher cipher,
 				u32 data_unit_size);
+extern int qcom_scm_derive_sw_secret(const u8 *wrapped_key,
+				     u32 wrapped_key_size, u8 *sw_secret,
+				     u32 secret_size);
 
 extern bool qcom_scm_hdcp_available(void);
 extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
-- 
2.25.1

