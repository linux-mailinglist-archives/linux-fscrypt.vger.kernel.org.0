Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8201F444B79
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 00:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhKCXWY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Nov 2021 19:22:24 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:4895 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhKCXWY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Nov 2021 19:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635981587; x=1667517587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=4ZYvYoTiiYdoHo7mT3NR1k5ppIMkCL++FAnd9VzklOg=;
  b=ef+3/wsn4pj/vohI+gEE2WImk05sFlUl5STJuY3uqScSiVdCLJaqDjJ0
   XcHqQhjdjSNG5uMvfgjkM+sjZU5GdjH5wrfI6rrZSXxiKru6VtiYG02vh
   Q97NVMdQAosvB4Lp3uzV0eaThJwc2uIvBplg8BCpJsWqw0dlq/lymJiYo
   k=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 03 Nov 2021 16:19:47 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 16:19:46 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Wed, 3 Nov 2021 16:19:46 -0700
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 3 Nov 2021
 16:19:46 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <asutoshd@codeaurora.org>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 2/4] qcom_scm: scm call for deriving a software secret
Date:   Wed, 3 Nov 2021 16:18:38 -0700
Message-ID: <20211103231840.115521-3-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Storage encryption requires fscrypt deriving a sw secret from
the keys inserted into the linux keyring. For non-wrapped keys,
this can be directly done as keys are in the clear.

However, when keys are hardware wrapped, it can be only unwrapped
by Qualcomm Trustzone. Hence, it also makes sense that the software
secret is also derived there and returned to the linux kernel for
wrapped keys. Fscrypt invokes this functionality using the crypto
profile APIs provided by the block layer.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/firmware/qcom_scm.c | 61 +++++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h |  1 +
 include/linux/qcom_scm.h    |  5 +++
 3 files changed, 67 insertions(+)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 2ee97bab7440..cf62e8056c17 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1062,6 +1062,67 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL(qcom_scm_ice_set_key);
 
+/**
+ * qcom_scm_derive_sw_secret() - Derive SW secret from wrapped encryption key
+ * @wrapped_key: the wrapped key used for inline encryption
+ * @wrapped_key_size: size of the wrapped key
+ * @sw_secret: the secret to be derived
+ * @secret_size: size of the secret derived
+ *
+ * Derive a SW secret to be used for inline encryption using Qualcomm ICE.
+ *
+ * Generally, for non-wrapped keys, fscrypt can derive a sw secret from the
+ * key in the clear in the linux keyring.
+ *
+ * However, for wrapped keys, the key needs to be unwrapped, which can be done
+ * only by the secure EE. So, it makes sense for the secure EE to derive the
+ * sw secret and return to the kernel when wrapped keys are used.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_derive_sw_secret(const u8* wrapped_key, u32 wrapped_key_size,
+			      u8 *sw_secret, u32 secret_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_DERIVE_RAW_SECRET,
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
+	keybuf = dma_alloc_coherent(__scm->dev, wrapped_key_size, &key_phys,
+				    GFP_KERNEL);
+	if (!keybuf)
+		return -ENOMEM;
+	secretbuf = dma_alloc_coherent(__scm->dev, secret_size, &secret_phys,
+				    GFP_KERNEL);
+	if (!secretbuf)
+		return -ENOMEM;
+
+	memcpy(keybuf, wrapped_key, wrapped_key_size);
+	desc.args[0] = key_phys;
+	desc.args[2] = secret_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	memcpy(sw_secret, secretbuf, secret_size);
+
+	memzero_explicit(keybuf, wrapped_key_size);
+	dma_free_coherent(__scm->dev, wrapped_key_size, keybuf, key_phys);
+	memzero_explicit(secretbuf, secret_size);
+	dma_free_coherent(__scm->dev, secret_size, secretbuf, secret_phys);
+
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index d92156ceb3ac..de5d4f8fd20d 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -110,6 +110,7 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+#define QCOM_SCM_ES_DERIVE_RAW_SECRET 0x07
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index c0475d1c9885..e1f645d714f9 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -103,6 +103,8 @@ extern int qcom_scm_ice_invalidate_key(u32 index);
 extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 				enum qcom_scm_ice_cipher cipher,
 				u32 data_unit_size);
+extern int qcom_scm_derive_sw_secret(const u8* wrapped_key,
+				u32 wrapped_key_size, u8 *sw_secret, u32 secret_size);
 
 extern bool qcom_scm_hdcp_available(void);
 extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
@@ -169,6 +171,9 @@ static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
 static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 				       enum qcom_scm_ice_cipher cipher,
 				       u32 data_unit_size) { return -ENODEV; }
+static inline int qcom_scm_derive_sw_secret(const u8* wrapped_key,
+					u32 wrapped_key_size, u8 *sw_secret,
+					u32 secret_size) { return -ENODEV; }
 
 static inline bool qcom_scm_hdcp_available(void) { return false; }
 static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
-- 
2.17.1

