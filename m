Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE22A46ADFB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347563AbhLFXCs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:48 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:25283 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377040AbhLFXCj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831550; x=1670367550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=9pDqBy7b4J82ylZCzc4TAkcjhQdpn6D73KXKK36EV68=;
  b=EHdJQK49Bgp/TgU+5c2ZXnDJgWT6rV+TAZgk5A5cBacrv3deJZa5+yHk
   jtujRv2EmlFhWAKnqLYgs03Fx61Rb7k7zy6veuosoUxdwMXrNjJaWGT0b
   sHXOplE0atNudDKW2TzhvxyLSVlGeNo6+UotJ6VueHVJXYpx4V0fIQQYs
   M=;
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 06 Dec 2021 14:59:09 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:59:09 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:59:09 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:59:08 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 07/10] qcom_scm: scm call for create, prepare and import keys
Date:   Mon, 6 Dec 2021 14:57:22 -0800
Message-ID: <20211206225725.77512-8-quic_gaurkash@quicinc.com>
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
 drivers/firmware/qcom_scm.c | 213 ++++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h |   3 +
 include/linux/qcom_scm.h    |  24 +++-
 3 files changed, 239 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 4a7703846788..cca5c1ac5666 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1135,6 +1135,219 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
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
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_import_ice_key);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index 08bb2a4c80db..efd0ede1fb37 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -111,6 +111,9 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
 #define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
+#define QCOM_SCM_ES_GENERATE_ICE_KEY	0x08
+#define QCOM_SCM_ES_PREPARE_ICE_KEY	0x09
+#define QCOM_SCM_ES_IMPORT_ICE_KEY	0xA
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index ccd764bdc357..865e4b4392a1 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -106,6 +106,16 @@ extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
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
@@ -175,7 +185,19 @@ static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 static inline int qcom_scm_derive_sw_secret(const u8 *wrapped_key,
 					u32 wrapped_key_size, u8 *sw_secret,
 					u32 secret_size) { return -ENODEV; }
-
+static inline int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
+				     u32 longterm_wrapped_key_size)
+		{ return -ENODEV; }
+static inline int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
+				    u32 longterm_wrapped_key_size,
+				    u8 *ephemeral_wrapped_key,
+				    u32 ephemeral_wrapped_key_size)
+		{ return -ENODEV; }
+static inline int qcom_scm_import_ice_key(const u8 *imported_key,
+				   u32 imported_key_size,
+				   u8 *longterm_wrapped_key,
+				   u32 longterm_wrapped_key_size)
+		{ return -ENODEV; }
 static inline bool qcom_scm_hdcp_available(void) { return false; }
 static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
 		u32 *resp) { return -ENODEV; }
-- 
2.17.1

