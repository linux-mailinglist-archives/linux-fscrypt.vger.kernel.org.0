Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43368202BD1
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Jun 2020 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbgFURlA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 21 Jun 2020 13:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730475AbgFURlA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 21 Jun 2020 13:41:00 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C3C22225B;
        Sun, 21 Jun 2020 17:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592761259;
        bh=DpdZuYaBF1BQMfln7LmSIl8AzkzjHHKWXXI1D6rQFWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PllB5jTWMgwGEny3higmXUb80lhDYKunMDNzRkVblTjjjV0LFxExMpuKgNHY1FCDk
         +6F2jiCxiSewZVmQrdp2h4a9fAGKLI29+GdvnbpDaQZnaFWVQ0httG6n5vD24pQjpx
         626CRzt0uyePhKVxHViTb8WMhANLn3+s1vBnG2aM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v5 1/5] firmware: qcom_scm: Add support for programming inline crypto keys
Date:   Sun, 21 Jun 2020 10:37:09 -0700
Message-Id: <20200621173713.132879-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621173713.132879-1-ebiggers@kernel.org>
References: <20200621173713.132879-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support for the Inline Crypto Engine (ICE) key programming interface
that's needed for the ufs-qcom driver to use inline encryption on
Snapdragon SoCs.  This interface consists of two SCM calls: one to
program a key into a keyslot, and one to invalidate a keyslot.

Although the UFS specification defines a standard way to do this, on
these SoCs the Linux kernel isn't permitted to access the needed crypto
configuration registers directly; these SCM calls must be used instead.

Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/firmware/qcom_scm.c | 101 ++++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h |   4 ++
 include/linux/qcom_scm.h    |  19 +++++++
 3 files changed, 124 insertions(+)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 0e7233a20f34..1a8eb1b42b1e 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -923,6 +923,107 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size)
 }
 EXPORT_SYMBOL(qcom_scm_ocmem_unlock);
 
+/**
+ * qcom_scm_ice_available() - Is the ICE key programming interface available?
+ *
+ * Return: true iff the SCM calls wrapped by qcom_scm_ice_invalidate_key() and
+ *	   qcom_scm_ice_set_key() are available.
+ */
+bool qcom_scm_ice_available(void)
+{
+	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_INVALIDATE_ICE_KEY) &&
+		__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					     QCOM_SCM_ES_CONFIG_SET_ICE_KEY);
+}
+EXPORT_SYMBOL(qcom_scm_ice_available);
+
+/**
+ * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
+ * @index: the keyslot to invalidate
+ *
+ * The UFSHCI standard defines a standard way to do this, but it doesn't work on
+ * these SoCs; only this SCM call does.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_ice_invalidate_key(u32 index)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd = QCOM_SCM_ES_INVALIDATE_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(1),
+		.args[0] = index,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+
+	return qcom_scm_call(__scm->dev, &desc, NULL);
+}
+EXPORT_SYMBOL(qcom_scm_ice_invalidate_key);
+
+/**
+ * qcom_scm_ice_set_key() - Set an inline encryption key
+ * @index: the keyslot into which to set the key
+ * @key: the key to program
+ * @key_size: the size of the key in bytes
+ * @cipher: the encryption algorithm the key is for
+ * @data_unit_size: the encryption data unit size, i.e. the size of each
+ *		    individual plaintext and ciphertext.  Given in 512-byte
+ *		    units, e.g. 1 = 512 bytes, 8 = 4096 bytes, etc.
+ *
+ * Program a key into a keyslot of Qualcomm ICE (Inline Crypto Engine), where it
+ * can then be used to encrypt/decrypt UFS I/O requests inline.
+ *
+ * The UFSHCI standard defines a standard way to do this, but it doesn't work on
+ * these SoCs; only this SCM call does.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd = QCOM_SCM_ES_CONFIG_SET_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(5, QCOM_SCM_VAL, QCOM_SCM_RW,
+					 QCOM_SCM_VAL, QCOM_SCM_VAL,
+					 QCOM_SCM_VAL),
+		.args[0] = index,
+		.args[2] = key_size,
+		.args[3] = cipher,
+		.args[4] = data_unit_size,
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	void *keybuf;
+	dma_addr_t key_phys;
+	int ret;
+
+	/*
+	 * 'key' may point to vmalloc()'ed memory, but we need to pass a
+	 * physical address that's been properly flushed.  The sanctioned way to
+	 * do this is by using the DMA API.  But as is best practice for crypto
+	 * keys, we also must wipe the key after use.  This makes kmemdup() +
+	 * dma_map_single() not clearly correct, since the DMA API can use
+	 * bounce buffers.  Instead, just use dma_alloc_coherent().  Programming
+	 * keys is normally rare and thus not performance-critical.
+	 */
+
+	keybuf = dma_alloc_coherent(__scm->dev, key_size, &key_phys,
+				    GFP_KERNEL);
+	if (!keybuf)
+		return -ENOMEM;
+	memcpy(keybuf, key, key_size);
+	desc.args[1] = key_phys;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+
+	memzero_explicit(keybuf, key_size);
+
+	dma_free_coherent(__scm->dev, key_size, keybuf, key_phys);
+	return ret;
+}
+EXPORT_SYMBOL(qcom_scm_ice_set_key);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index d9ed670da222..38ea614d29fe 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -103,6 +103,10 @@ extern int scm_legacy_call(struct device *dev, const struct qcom_scm_desc *desc,
 #define QCOM_SCM_OCMEM_LOCK_CMD		0x01
 #define QCOM_SCM_OCMEM_UNLOCK_CMD	0x02
 
+#define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
+#define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
+#define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
 
diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index 3d6a24697761..2e1193a3fb5f 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -44,6 +44,13 @@ enum qcom_scm_sec_dev_id {
 	QCOM_SCM_ICE_DEV_ID     = 20,
 };
 
+enum qcom_scm_ice_cipher {
+	QCOM_SCM_ICE_CIPHER_AES_128_XTS = 0,
+	QCOM_SCM_ICE_CIPHER_AES_128_CBC = 1,
+	QCOM_SCM_ICE_CIPHER_AES_256_XTS = 3,
+	QCOM_SCM_ICE_CIPHER_AES_256_CBC = 4,
+};
+
 #define QCOM_SCM_VMID_HLOS       0x3
 #define QCOM_SCM_VMID_MSS_MSA    0xF
 #define QCOM_SCM_VMID_WLAN       0x18
@@ -88,6 +95,12 @@ extern int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
 extern int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset,
 				 u32 size);
 
+extern bool qcom_scm_ice_available(void);
+extern int qcom_scm_ice_invalidate_key(u32 index);
+extern int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+				enum qcom_scm_ice_cipher cipher,
+				u32 data_unit_size);
+
 extern bool qcom_scm_hdcp_available(void);
 extern int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
 			     u32 *resp);
@@ -138,6 +151,12 @@ static inline int qcom_scm_ocmem_lock(enum qcom_scm_ocmem_client id, u32 offset,
 static inline int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id,
 		u32 offset, u32 size) { return -ENODEV; }
 
+static inline bool qcom_scm_ice_available(void) { return false; }
+static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
+static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
+				       enum qcom_scm_ice_cipher cipher,
+				       u32 data_unit_size) { return -ENODEV; }
+
 static inline bool qcom_scm_hdcp_available(void) { return false; }
 static inline int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt,
 		u32 *resp) { return -ENODEV; }
-- 
2.27.0

