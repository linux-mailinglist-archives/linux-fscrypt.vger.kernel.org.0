Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E76759BF5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjGSRIB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjGSRH6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:07:58 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F12510CB;
        Wed, 19 Jul 2023 10:07:56 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JBRZQZ003038;
        Wed, 19 Jul 2023 17:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=H7tmiNb2ByHJOIcqfdDEHf87DkO5fs1A6OPe3xa52Nw=;
 b=m0OyMcvNU4XiMNA+xFErYsInXNHLZmLag3wZ8P1OlOZxtwik4CIdc2vl6b1i+3cw3SIX
 b17cAgYNRnGNco2ymLVLPJHNX6QnVCPiDFeZWsuIgJa9DQrN5DvKsfleetXxzXZjaSh2
 /2LdwzYYbn6sCHHotU5s9wGv6mL++3CIfPBDo4f9pl02gRjCbLfYM1oOILBJJAdN7PWS
 lbAGLiUcMdQ9nPoao6Rg6TG6dghStwNHk15d2sluMT163XrIkA9IAf6VgUDaPoutNt9I
 9QUmNOmgMgQm2TtRmWHfHn5fIzLV3wdHY2l/Bh3NnirDAVE+jn2q6bNTYGdQIUNlvkVN 3Q== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rxexkgtvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:53 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JH7rle010375
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:53 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 10:07:52 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 07/10] qcom_scm: scm call for create, prepare and import keys
Date:   Wed, 19 Jul 2023 10:04:21 -0700
Message-ID: <20230719170423.220033-8-quic_gaurkash@quicinc.com>
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
X-Proofpoint-ORIG-GUID: OpJxd6_GofzlD0BvOSlNHb3YC7JHdaoa
X-Proofpoint-GUID: OpJxd6_GofzlD0BvOSlNHb3YC7JHdaoa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_11,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 suspectscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

Storage encryption has two IOCTLs for creating, importing
and preparing keys for encryption. For wrapped keys, these
IOCTLs need to interface with the secure environment, which
require these SCM calls.

generate_key: This is used to generate and return a longterm
              wrapped key. Trustzone achieves this by generating
	      a key and then wrapping it using hwkm, returning
	      a wrapped keyblob.
import_key:   The functionality is similar to generate, but here,
              a raw key is imported into hwkm and a longterm wrapped
	      keyblob is returned.
prepare_key:  The longterm wrapped key from import or generate
              is made further secure by rewrapping it with a per-boot
	      ephemeral wrapped key before installing it to the linux
	      kernel for programming to ICE.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/firmware/qcom_scm.c            | 222 +++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h            |   3 +
 include/linux/firmware/qcom/qcom_scm.h |  10 ++
 3 files changed, 235 insertions(+)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 51062d5c7f7b..44dd1857747b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1210,6 +1210,228 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
 }
 EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
 
+/**
+ * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
+ * @longterm_wrapped_key: the wrapped key returned after key generation
+ * @longterm_wrapped_key_size: size of the wrapped key to be returned.
+ *
+ * Qualcomm wrapped keys need to be generated in a trusted environment.
+ * A generate key  IOCTL call is used to achieve this. These are longterm
+ * in nature as they need to be generated and wrapped only once per
+ * requirement.
+ *
+ * This SCM calls adds support for the generate key IOCTL to interface
+ * with the secure environment to generate and return a wrapped key..
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
+			    u32 longterm_wrapped_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(2, QCOM_SCM_RW,
+					 QCOM_SCM_VAL),
+		.args[1] = longterm_wrapped_key_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	void *longterm_wrapped_keybuf;
+	dma_addr_t longterm_wrapped_key_phys;
+	int ret;
+
+	/*
+	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
+	 * get a physical address, while guaranteeing that we can zeroize the
+	 * key material later using memzero_explicit().
+	 *
+	 */
+	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
+				  longterm_wrapped_key_size,
+				  &longterm_wrapped_key_phys, GFP_KERNEL);
+	if (!longterm_wrapped_keybuf)
+		return -ENOMEM;
+
+	desc.args[0] = longterm_wrapped_key_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	memcpy(longterm_wrapped_key, longterm_wrapped_keybuf,
+	       longterm_wrapped_key_size);
+
+	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
+	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
+			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
+
+	if (!ret)
+		return longterm_wrapped_key_size;
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_generate_ice_key);
+
+/**
+ * qcom_scm_prepare_ice_key() - Get per boot ephemeral wrapped key
+ * @longterm_wrapped_key: the wrapped key
+ * @longterm_wrapped_key_size: size of the wrapped key
+ * @ephemeral_wrapped_key: ephemeral wrapped key to be returned
+ * @ephemeral_wrapped_key_size: size of the ephemeral wrapped key
+ *
+ * Qualcomm wrapped keys (longterm keys) are rewrapped with a per-boot
+ * ephemeral key for added protection. These are ephemeral in nature as
+ * they are valid only for that boot. A create key IOCTL is used to
+ * achieve this. These are the keys that are installed into the kernel
+ * to be then unwrapped and programmed into ICE.
+ *
+ * This SCM call adds support for the create key IOCTL to interface
+ * with the secure environment to rewrap the wrapped key with an
+ * ephemeral wrapping key.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
+			     u32 longterm_wrapped_key_size,
+			     u8 *ephemeral_wrapped_key,
+			     u32 ephemeral_wrapped_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+					 QCOM_SCM_VAL, QCOM_SCM_RW,
+					 QCOM_SCM_VAL),
+		.args[1] = longterm_wrapped_key_size,
+		.args[3] = ephemeral_wrapped_key_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	void *longterm_wrapped_keybuf, *ephemeral_wrapped_keybuf;
+	dma_addr_t longterm_wrapped_key_phys, ephemeral_wrapped_key_phys;
+	int ret;
+
+	/*
+	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
+	 * get a physical address, while guaranteeing that we can zeroize the
+	 * key material later using memzero_explicit().
+	 *
+	 */
+	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
+				  longterm_wrapped_key_size,
+				  &longterm_wrapped_key_phys, GFP_KERNEL);
+	if (!longterm_wrapped_keybuf)
+		return -ENOMEM;
+	ephemeral_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
+				   ephemeral_wrapped_key_size,
+				   &ephemeral_wrapped_key_phys, GFP_KERNEL);
+	if (!ephemeral_wrapped_keybuf) {
+		ret = -ENOMEM;
+		goto bail_keybuf;
+	}
+
+	memcpy(longterm_wrapped_keybuf, longterm_wrapped_key,
+	       longterm_wrapped_key_size);
+	desc.args[0] = longterm_wrapped_key_phys;
+	desc.args[2] = ephemeral_wrapped_key_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(ephemeral_wrapped_key, ephemeral_wrapped_keybuf,
+		       ephemeral_wrapped_key_size);
+
+	memzero_explicit(ephemeral_wrapped_keybuf, ephemeral_wrapped_key_size);
+	dma_free_coherent(__scm->dev, ephemeral_wrapped_key_size,
+			  ephemeral_wrapped_keybuf,
+			  ephemeral_wrapped_key_phys);
+
+bail_keybuf:
+	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
+	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
+			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
+
+	if (!ret)
+		return ephemeral_wrapped_key_size;
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_prepare_ice_key);
+
+/**
+ * qcom_scm_import_ice_key() - Import a wrapped key for encryption
+ * @imported_key: the raw key that is imported
+ * @imported_key_size: size of the key to be imported
+ * @longterm_wrapped_key: the wrapped key to be returned
+ * @longterm_wrapped_key_size: size of the wrapped key
+ *
+ * Conceptually, this is very similar to generate, the difference being,
+ * here we want to import a raw key and return a longterm wrapped key
+ * from it. THe same create key IOCTL is used to achieve this.
+ *
+ * This SCM call adds support for the create key IOCTL to interface with
+ * the secure environment to import a raw key and generate a longterm
+ * wrapped key.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
+			    u8 *longterm_wrapped_key,
+			    u32 longterm_wrapped_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+					 QCOM_SCM_VAL, QCOM_SCM_RW,
+					 QCOM_SCM_VAL),
+		.args[1] = imported_key_size,
+		.args[3] = longterm_wrapped_key_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	void *imported_keybuf, *longterm_wrapped_keybuf;
+	dma_addr_t imported_key_phys, longterm_wrapped_key_phys;
+	int ret;
+	/*
+	 * Like qcom_scm_ice_set_key(), we use dma_alloc_coherent() to properly
+	 * get a physical address, while guaranteeing that we can zeroize the
+	 * key material later using memzero_explicit().
+	 *
+	 */
+	imported_keybuf = dma_alloc_coherent(__scm->dev, imported_key_size,
+			  &imported_key_phys, GFP_KERNEL);
+	if (!imported_keybuf)
+		return -ENOMEM;
+	longterm_wrapped_keybuf = dma_alloc_coherent(__scm->dev,
+				  longterm_wrapped_key_size,
+				  &longterm_wrapped_key_phys, GFP_KERNEL);
+	if (!longterm_wrapped_keybuf) {
+		ret = -ENOMEM;
+		goto bail_keybuf;
+	}
+
+	memcpy(imported_keybuf, imported_key, imported_key_size);
+	desc.args[0] = imported_key_phys;
+	desc.args[2] = longterm_wrapped_key_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(longterm_wrapped_key, longterm_wrapped_keybuf,
+		       longterm_wrapped_key_size);
+
+	memzero_explicit(longterm_wrapped_keybuf, longterm_wrapped_key_size);
+	dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
+			  longterm_wrapped_keybuf, longterm_wrapped_key_phys);
+bail_keybuf:
+	memzero_explicit(imported_keybuf, imported_key_size);
+	dma_free_coherent(__scm->dev, imported_key_size, imported_keybuf,
+			  imported_key_phys);
+
+	if (!ret)
+		return longterm_wrapped_key_size;
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_import_ice_key);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index c145cdc71ff8..fa6164bef54f 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -120,6 +120,9 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
 #define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
+#define QCOM_SCM_ES_GENERATE_ICE_KEY	0x08
+#define QCOM_SCM_ES_PREPARE_ICE_KEY	0x09
+#define QCOM_SCM_ES_IMPORT_ICE_KEY	0xA
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 20f5d0b7dfd4..104666123e4d 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -112,6 +112,16 @@ extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 extern int qcom_scm_derive_sw_secret(const u8 *wrapped_key,
 				     u32 wrapped_key_size, u8 *sw_secret,
 				     u32 secret_size);
+extern int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
+				     u32 longterm_wrapped_key_size);
+extern int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
+				    u32 longterm_wrapped_key_size,
+				    u8 *ephemeral_wrapped_key,
+				    u32 ephemeral_wrapped_key_size);
+extern int qcom_scm_import_ice_key(const u8 *imported_key,
+				   u32 imported_key_size,
+				   u8 *longterm_wrapped_key,
+				   u32 longterm_wrapped_key_size);
 
 extern bool qcom_scm_hdcp_available(void);
 extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
-- 
2.25.1

