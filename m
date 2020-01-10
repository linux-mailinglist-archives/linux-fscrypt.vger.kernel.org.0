Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6BA136744
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2020 07:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731437AbgAJGS0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jan 2020 01:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgAJGS0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jan 2020 01:18:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081B32077C;
        Fri, 10 Jan 2020 06:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578637105;
        bh=wgmY37dX/k/zvRXL8vp1YklCacQnlAFrnhODoHTytKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd/4PbKOQh4ZqbvuRsSqNt4iHhSONcOSihaUxa7HtIjNOLJMyYqf90KvuLdbIZ7q5
         RqcdqUy/11xZFCRo78R3vdA+Nm9HdYEx+dI5piaie8fZzcHp6dsLi4vaXv/11FoMQO
         ClOfAKm/iU+cjN+7V7sA3x/s8LAvW0HLExaPfqkk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 1/5] firmware: qcom_scm: Add support for programming inline crypto keys
Date:   Thu,  9 Jan 2020 22:16:30 -0800
Message-Id: <20200110061634.46742-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110061634.46742-1-ebiggers@kernel.org>
References: <20200110061634.46742-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add support for the Inline Crypto Engine (ICE) key programming interface
that's needed for the ufs-qcom driver to use inline encryption on
Snapdragon SoCs.  This interface consists of two SMC calls: one to
program a key into a keyslot, and one to invalidate a keyslot.

Although the UFS specification defines a standard way to do this, on
these SoCs the Linux kernel isn't permitted to access the needed crypto
configuration registers directly; these SMC calls must be used instead.

For now I only wired up the 64-bit versions of these calls, as it's all
I'm able to test right now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/firmware/qcom_scm-32.c | 14 ++++++
 drivers/firmware/qcom_scm-64.c | 31 ++++++++++++++
 drivers/firmware/qcom_scm.c    | 78 ++++++++++++++++++++++++++++++++++
 drivers/firmware/qcom_scm.h    |  9 ++++
 include/linux/qcom_scm.h       | 17 ++++++++
 5 files changed, 149 insertions(+)

diff --git a/drivers/firmware/qcom_scm-32.c b/drivers/firmware/qcom_scm-32.c
index 48e2ef794ea3c..95f2b59223fb8 100644
--- a/drivers/firmware/qcom_scm-32.c
+++ b/drivers/firmware/qcom_scm-32.c
@@ -583,6 +583,20 @@ int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 	return ret ? : le32_to_cpu(out);
 }
 
+int __qcom_scm_ice_set_key(struct device *dev, u32 index, dma_addr_t key_phys,
+			   int key_size, enum qcom_scm_ice_cipher_mode mode,
+			   int data_unit_size)
+{
+	/* Untested on 32-bit, so disabled for now. */
+	return -ENODEV;
+}
+
+int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
+{
+	/* Untested on 32-bit, so disabled for now. */
+	return -ENODEV;
+}
+
 int __qcom_scm_set_dload_mode(struct device *dev, bool enable)
 {
 	return qcom_scm_call_atomic2(QCOM_SCM_SVC_BOOT, QCOM_SCM_SET_DLOAD_MODE,
diff --git a/drivers/firmware/qcom_scm-64.c b/drivers/firmware/qcom_scm-64.c
index 3c5850350974d..41d67667556f1 100644
--- a/drivers/firmware/qcom_scm-64.c
+++ b/drivers/firmware/qcom_scm-64.c
@@ -420,6 +420,37 @@ int __qcom_scm_pas_mss_reset(struct device *dev, bool reset)
 	return ret ? : res.a1;
 }
 
+int __qcom_scm_ice_set_key(struct device *dev, u32 index, dma_addr_t key_phys,
+			   int key_size, enum qcom_scm_ice_cipher_mode mode,
+			   int data_unit_size)
+{
+	struct qcom_scm_desc desc = {0};
+	struct arm_smccc_res res;
+
+	desc.args[0] = index;
+	desc.args[1] = key_phys;
+	desc.args[2] = key_size;
+	desc.args[3] = mode;
+	desc.args[4] = data_unit_size;
+	desc.arginfo = QCOM_SCM_ARGS(5, QCOM_SCM_VAL, QCOM_SCM_RW, QCOM_SCM_VAL,
+				     QCOM_SCM_VAL, QCOM_SCM_VAL);
+
+	return qcom_scm_call(dev, QCOM_SCM_SVC_ES,
+			     QCOM_SCM_ES_CONFIG_SET_ICE_KEY, &desc, &res);
+}
+
+int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index)
+{
+	struct qcom_scm_desc desc = {0};
+	struct arm_smccc_res res;
+
+	desc.args[0] = index;
+	desc.arginfo = QCOM_SCM_ARGS(1);
+
+	return qcom_scm_call(dev, QCOM_SCM_SVC_ES,
+			     QCOM_SCM_ES_INVALIDATE_ICE_KEY, &desc, &res);
+}
+
 int __qcom_scm_set_remote_state(struct device *dev, u32 state, u32 id)
 {
 	struct qcom_scm_desc desc = {0};
diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index 1ba0df4b97aba..a37d3f69448a8 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -12,6 +12,7 @@
 #include <linux/dma-direct.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/qcom_scm.h>
 #include <linux/of.h>
@@ -344,6 +345,83 @@ int qcom_scm_pas_shutdown(u32 peripheral)
 }
 EXPORT_SYMBOL(qcom_scm_pas_shutdown);
 
+/**
+ * qcom_scm_ice_available() - Is the ICE key programming interface available?
+ *
+ * Return: true iff the SCM calls wrapped by qcom_scm_ice_set_key() and
+ *	   qcom_scm_ice_invalidate_key() are available.
+ */
+bool qcom_scm_ice_available(void)
+{
+	if (IS_ENABLED(CONFIG_ARM)) /* Not implemented/tested on 32-bit yet. */
+		return false;
+	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_CONFIG_SET_ICE_KEY) &&
+		__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					     QCOM_SCM_ES_INVALIDATE_ICE_KEY);
+}
+EXPORT_SYMBOL(qcom_scm_ice_available);
+
+/**
+ * qcom_scm_ice_set_key() - Set an inline encryption key
+ * @index: the keyslot into which to set the key
+ * @key: the key to program
+ * @key_size: the size of the key in bytes
+ * @mode: the encryption algorithm the key is for
+ * @data_unit_size: the encryption data unit size, i.e. the size of each
+ *		    individual plaintext and ciphertext.  Given in 512-byte
+ *		    units, e.g. 1 = 512 bytes, 8 = 4096 bytes, etc.
+ *
+ * Program a key into a keyslot of Qualcomm ICE (Inline Cryptographic Engine),
+ * where it can then be used to encrypt/decrypt UFS I/O requests inline.
+ *
+ * The UFSHCI standard defines a standard way to do this, but it doesn't work on
+ * these SoCs; only these SCM calls do...
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_ice_set_key(u32 index, const u8 *key, int key_size,
+			 enum qcom_scm_ice_cipher_mode mode, int data_unit_size)
+{
+	u8 *keybuf;
+	dma_addr_t key_phys;
+	int err;
+
+	keybuf = kmemdup(key, key_size, GFP_KERNEL);
+	if (!keybuf)
+		return -ENOMEM;
+
+	key_phys = dma_map_single(__scm->dev, keybuf, key_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(__scm->dev, key_phys)) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = __qcom_scm_ice_set_key(__scm->dev, index, key_phys, key_size,
+				     mode, data_unit_size);
+
+	dma_unmap_single(__scm->dev, key_phys, key_size, DMA_TO_DEVICE);
+out:
+	kzfree(keybuf);
+	return err;
+}
+EXPORT_SYMBOL(qcom_scm_ice_set_key);
+
+/**
+ * qcom_scm_ice_invalidate_key() - Invalidate an inline encryption key
+ * @index: the keyslot to invalidate
+ *
+ * The UFSHCI standard defines a standard way to do this, but it doesn't work on
+ * these SoCs; only these SCM calls do...
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_ice_invalidate_key(u32 index)
+{
+	return __qcom_scm_ice_invalidate_key(__scm->dev, index);
+}
+EXPORT_SYMBOL(qcom_scm_ice_invalidate_key);
+
 static int qcom_scm_pas_reset_assert(struct reset_controller_dev *rcdev,
 				     unsigned long idx)
 {
diff --git a/drivers/firmware/qcom_scm.h b/drivers/firmware/qcom_scm.h
index 81dcf5f1138e7..28bfec9c11f86 100644
--- a/drivers/firmware/qcom_scm.h
+++ b/drivers/firmware/qcom_scm.h
@@ -67,6 +67,15 @@ extern int  __qcom_scm_pas_auth_and_reset(struct device *dev, u32 peripheral);
 extern int  __qcom_scm_pas_shutdown(struct device *dev, u32 peripheral);
 extern int  __qcom_scm_pas_mss_reset(struct device *dev, bool reset);
 
+#define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
+#define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+#define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
+extern int __qcom_scm_ice_set_key(struct device *dev, u32 index,
+				  dma_addr_t key_phys, int key_size,
+				  enum qcom_scm_ice_cipher_mode mode,
+				  int data_unit_size);
+extern int __qcom_scm_ice_invalidate_key(struct device *dev, u32 index);
+
 /* common error codes */
 #define QCOM_SCM_V2_EBUSY	-12
 #define QCOM_SCM_ENOMEM		-5
diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
index d05ddac9a57e8..0f56801ac6e14 100644
--- a/include/linux/qcom_scm.h
+++ b/include/linux/qcom_scm.h
@@ -44,6 +44,13 @@ enum qcom_scm_sec_dev_id {
 	QCOM_SCM_ICE_DEV_ID     = 20,
 };
 
+enum qcom_scm_ice_cipher_mode {
+	QCOM_SCM_ICE_CIPHER_MODE_XTS_128 = 0,
+	QCOM_SCM_ICE_CIPHER_MODE_CBC_128 = 1,
+	QCOM_SCM_ICE_CIPHER_MODE_XTS_256 = 3,
+	QCOM_SCM_ICE_CIPHER_MODE_CBC_256 = 4,
+};
+
 #define QCOM_SCM_VMID_HLOS       0x3
 #define QCOM_SCM_VMID_MSS_MSA    0xF
 #define QCOM_SCM_VMID_WLAN       0x18
@@ -73,6 +80,11 @@ extern int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr,
 				  phys_addr_t size);
 extern int qcom_scm_pas_auth_and_reset(u32 peripheral);
 extern int qcom_scm_pas_shutdown(u32 peripheral);
+extern bool qcom_scm_ice_available(void);
+extern int qcom_scm_ice_set_key(u32 index, const u8 *key, int key_size,
+				enum qcom_scm_ice_cipher_mode mode,
+				int data_unit_size);
+extern int qcom_scm_ice_invalidate_key(u32 index);
 extern int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 			       unsigned int *src,
 			       const struct qcom_scm_vmperm *newvm,
@@ -113,6 +125,11 @@ static inline int qcom_scm_pas_mem_setup(u32 peripheral, phys_addr_t addr,
 static inline int
 qcom_scm_pas_auth_and_reset(u32 peripheral) { return -ENODEV; }
 static inline int qcom_scm_pas_shutdown(u32 peripheral) { return -ENODEV; }
+static inline bool qcom_scm_ice_available(void) { return false; }
+static inline int qcom_scm_ice_set_key(u32 index, const u8 *key, int key_size,
+				       enum qcom_scm_ice_cipher_mode mode,
+				       int data_unit_size) { return -ENODEV; }
+static inline int qcom_scm_ice_invalidate_key(u32 index) { return -ENODEV; }
 static inline int qcom_scm_assign_mem(phys_addr_t mem_addr, size_t mem_sz,
 				      unsigned int *src,
 				      const struct qcom_scm_vmperm *newvm,
-- 
2.24.1

