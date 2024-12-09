Return-Path: <linux-fscrypt+bounces-537-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CAC19E8AAA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E0E41642F9
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05AEE1991D2;
	Mon,  9 Dec 2024 04:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDItb8Jz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43801991C9;
	Mon,  9 Dec 2024 04:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720222; cv=none; b=VtZQw5d2qMxfqsXHuYBLjBzSfN1BKKYDNYGR+cgC0Qgs0AzIuSygFasBehKrDEq8vPm6uz/CKOvUHVAsIbCn4+x41NhMiou++dQyDTmxyUY0XRI2Ggpvgtzgnx33rZta2sfQReXwFaKQE/nznyW6KoMydujk1tXc/wDMQwiZckw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720222; c=relaxed/simple;
	bh=ZweEoiVNeRw4qgQBQf6Ehu9c8g3ZN+76feLZJsrMhd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMe93RnTmzvu0+2mKtGtVaiBaQ6Bsk3rqITmZR6/UgtCfVjNCPQuUSbhE5RHc0kuJqoWa2Ed6w03yXVoLaWBKFSj+bh1GndFij95SI/0H44PAane34U8xNeKGfwvCPdj9oAlz9Dze0Ref+4YMNj4LvdaKINaNwZEzlPJNniSh8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDItb8Jz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA9BC4CEE2;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720222;
	bh=ZweEoiVNeRw4qgQBQf6Ehu9c8g3ZN+76feLZJsrMhd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDItb8JzAtRXAl5AWdNW1GuU2E2ku4TJhOWIqFS3wRqiWJ9LsP799iRaAELeDFjjK
	 QVJ/Idu5u8kWcptRYRjeGkUO27I0Knhp7d89roHDK76Qd0Od99a7k0u5vF7w5gXCAq
	 RSFmSDG4//kFOlVmqK3kcwXa8Lv7CpKtKigwn11r27kSYtsi9zvSEekAANknOjxAcw
	 khilnGTLrOmUF6yFlG3nrcDFwSyB6yCXDd6jH0Fv9B7tahpIgOxYHr6togg33I+yVO
	 8A3/LRIkUm+MQv2Mp4jGO1kfGoQaMlkkUNMVTCWJ63mizPatuIKF5UUY5GWgQ6Q/l4
	 8/gB9QWaHXrNA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v9 05/12] firmware: qcom: scm: add calls for wrapped key support
Date: Sun,  8 Dec 2024 20:55:23 -0800
Message-ID: <20241209045530.507833-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241209045530.507833-1-ebiggers@kernel.org>
References: <20241209045530.507833-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

Add helper functions for the SCM calls required to support
hardware-wrapped inline storage encryption keys.  These SCM calls manage
wrapped keys via Qualcomm's Hardware Key Manager (HWKM), which can only
be accessed from TrustZone.

QCOM_SCM_ES_GENERATE_ICE_KEY and QCOM_SCM_ES_IMPORT_ICE_KEY create a new
long-term wrapped key, with the former making the hardware generate the
key and the latter importing a raw key.  QCOM_SCM_ES_PREPARE_ICE_KEY
converts the key to ephemerally-wrapped form so that it can be used for
inline storage encryption.  These are planned to be wired up to new
ioctls via the blk-crypto framework; see the proposed documentation for
the hardware-wrapped keys feature for more information.

Similarly there's also QCOM_SCM_ES_DERIVE_SW_SECRET which derives a
"software secret" from an ephemerally-wrapped key and will be wired up
to the corresponding operation in the blk_crypto_profile.

These will all be used by the ICE driver in drivers/soc/qcom/ice.c.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
[EB: merged related patches, fixed error handling, fixed naming, fixed
     docs for size parameters, fixed qcom_scm_has_wrapped_key_support(),
     improved comments, improved commit message.]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/firmware/qcom/qcom_scm.c       | 214 +++++++++++++++++++++++++
 drivers/firmware/qcom/qcom_scm.h       |   4 +
 include/linux/firmware/qcom/qcom_scm.h |   8 +
 3 files changed, 226 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 72bf87ddcd969..180220d663f8b 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1277,10 +1277,224 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
+bool qcom_scm_has_wrapped_key_support(void)
+{
+	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_DERIVE_SW_SECRET) &&
+	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_GENERATE_ICE_KEY) &&
+	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_PREPARE_ICE_KEY) &&
+	       __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_IMPORT_ICE_KEY);
+}
+EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
+
+/**
+ * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
+ * @eph_key: an ephemerally-wrapped key
+ * @eph_key_size: size of @eph_key in bytes
+ * @sw_secret: output buffer for the software secret
+ * @sw_secret_size: size of the software secret to derive in bytes
+ *
+ * Derive a software secret from an ephemerally-wrapped key for software crypto
+ * operations.  This is done by calling into the secure execution environment,
+ * which then calls into the hardware to unwrap and derive the secret.
+ *
+ * For more information on sw_secret, see the "Hardware-wrapped keys" section of
+ * Documentation/block/inline-encryption.rst.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+			      u8 *sw_secret, size_t sw_secret_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd = QCOM_SCM_ES_DERIVE_SW_SECRET,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW, QCOM_SCM_VAL,
+					 QCOM_SCM_RW, QCOM_SCM_VAL),
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	int ret;
+
+	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+								eph_key_size,
+								GFP_KERNEL);
+	if (!eph_key_buf)
+		return -ENOMEM;
+
+	void *sw_secret_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+								  sw_secret_size,
+								  GFP_KERNEL);
+	if (!sw_secret_buf)
+		return -ENOMEM;
+
+	memcpy(eph_key_buf, eph_key_buf, eph_key_size);
+	desc.args[0] = qcom_tzmem_to_phys(eph_key_buf);
+	desc.args[1] = eph_key_size;
+	desc.args[2] = qcom_tzmem_to_phys(sw_secret_buf);
+	desc.args[3] = sw_secret_size;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(sw_secret, sw_secret_buf, sw_secret_size);
+
+	memzero_explicit(eph_key_buf, eph_key_size);
+	memzero_explicit(sw_secret_buf, sw_secret_size);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_scm_derive_sw_secret);
+
+/**
+ * qcom_scm_generate_ice_key() - Generate a wrapped key for storage encryption
+ * @lt_key: output buffer for the long-term wrapped key
+ * @lt_key_size: size of @lt_key in bytes.  Must be the exact wrapped key size
+ *		 used by the SoC.
+ *
+ * Generate a key using the built-in HW module in the SoC.  The resulting key is
+ * returned wrapped with the platform-specific Key Encryption Key.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_GENERATE_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(2, QCOM_SCM_RW, QCOM_SCM_VAL),
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	int ret;
+
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+							       lt_key_size,
+							       GFP_KERNEL);
+	if (!lt_key_buf)
+		return -ENOMEM;
+
+	desc.args[0] = qcom_tzmem_to_phys(lt_key_buf);
+	desc.args[1] = lt_key_size;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(lt_key, lt_key_buf, lt_key_size);
+
+	memzero_explicit(lt_key_buf, lt_key_size);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_scm_generate_ice_key);
+
+/**
+ * qcom_scm_prepare_ice_key() - Re-wrap a key with the per-boot ephemeral key
+ * @lt_key: a long-term wrapped key
+ * @lt_key_size: size of @lt_key in bytes
+ * @eph_key: output buffer for the ephemerally-wrapped key
+ * @eph_key_size: size of @eph_key in bytes.  Must be the exact wrapped key size
+ *		  used by the SoC.
+ *
+ * Given a long-term wrapped key, re-wrap it with the per-boot ephemeral key for
+ * added protection.  The resulting key will only be valid for the current boot.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
+			     u8 *eph_key, size_t eph_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_PREPARE_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO, QCOM_SCM_VAL,
+					 QCOM_SCM_RW, QCOM_SCM_VAL),
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	int ret;
+
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+							       lt_key_size,
+							       GFP_KERNEL);
+	if (!lt_key_buf)
+		return -ENOMEM;
+
+	void *eph_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+								eph_key_size,
+								GFP_KERNEL);
+	if (!eph_key_buf)
+		return -ENOMEM;
+
+	memcpy(lt_key_buf, lt_key, lt_key_size);
+	desc.args[0] = qcom_tzmem_to_phys(lt_key_buf);
+	desc.args[1] = lt_key_size;
+	desc.args[2] = qcom_tzmem_to_phys(eph_key_buf);
+	desc.args[3] = eph_key_size;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(eph_key, eph_key_buf, eph_key_size);
+
+	memzero_explicit(lt_key_buf, lt_key_size);
+	memzero_explicit(eph_key_buf, eph_key_size);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_scm_prepare_ice_key);
+
+/**
+ * qcom_scm_import_ice_key() - Import key for storage encryption
+ * @raw_key: the raw key to import
+ * @raw_key_size: size of @raw_key in bytes
+ * @lt_key: output buffer for the long-term wrapped key
+ * @lt_key_size: size of @lt_key in bytes.  Must be the exact wrapped key size
+ *		 used by the SoC.
+ *
+ * Import a raw key and return a long-term wrapped key.  Uses the SoC's HWKM to
+ * wrap the raw key using the platform-specific Key Encryption Key.
+ *
+ * Return: 0 on success; -errno on failure.
+ */
+int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
+			    u8 *lt_key, size_t lt_key_size)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_ES,
+		.cmd =  QCOM_SCM_ES_IMPORT_ICE_KEY,
+		.arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RO, QCOM_SCM_VAL,
+					 QCOM_SCM_RW, QCOM_SCM_VAL),
+		.owner = ARM_SMCCC_OWNER_SIP,
+	};
+	int ret;
+
+	void *raw_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+								raw_key_size,
+								GFP_KERNEL);
+	if (!raw_key_buf)
+		return -ENOMEM;
+
+	void *lt_key_buf __free(qcom_tzmem) = qcom_tzmem_alloc(__scm->mempool,
+							       lt_key_size,
+							       GFP_KERNEL);
+	if (!lt_key_buf)
+		return -ENOMEM;
+
+	memcpy(raw_key_buf, raw_key, raw_key_size);
+	desc.args[0] = qcom_tzmem_to_phys(raw_key_buf);
+	desc.args[1] = raw_key_size;
+	desc.args[2] = qcom_tzmem_to_phys(lt_key_buf);
+	desc.args[3] = lt_key_size;
+
+	ret = qcom_scm_call(__scm->dev, &desc, NULL);
+	if (!ret)
+		memcpy(lt_key, lt_key_buf, lt_key_size);
+
+	memzero_explicit(raw_key_buf, raw_key_size);
+	memzero_explicit(lt_key_buf, lt_key_size);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(qcom_scm_import_ice_key);
+
 /**
  * qcom_scm_hdcp_available() - Check if secure environment supports HDCP.
  *
  * Return true if HDCP is supported, false if not.
  */
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index e36b2f67607fc..097369d38b84e 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -126,10 +126,14 @@ struct qcom_tzmem_pool *qcom_scm_get_tzmem_pool(void);
 #define QCOM_SCM_OCMEM_UNLOCK_CMD	0x02
 
 #define QCOM_SCM_SVC_ES			0x10	/* Enterprise Security */
 #define QCOM_SCM_ES_INVALIDATE_ICE_KEY	0x03
 #define QCOM_SCM_ES_CONFIG_SET_ICE_KEY	0x04
+#define QCOM_SCM_ES_DERIVE_SW_SECRET	0x07
+#define QCOM_SCM_ES_GENERATE_ICE_KEY	0x08
+#define QCOM_SCM_ES_PREPARE_ICE_KEY	0x09
+#define QCOM_SCM_ES_IMPORT_ICE_KEY	0x0a
 
 #define QCOM_SCM_SVC_HDCP		0x11
 #define QCOM_SCM_HDCP_INVOKE		0x01
 
 #define QCOM_SCM_SVC_LMH			0x13
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index 4621aec0328c2..983e1591bbba7 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -103,10 +103,18 @@ int qcom_scm_ocmem_unlock(enum qcom_scm_ocmem_client id, u32 offset, u32 size);
 
 bool qcom_scm_ice_available(void);
 int qcom_scm_ice_invalidate_key(u32 index);
 int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 			 enum qcom_scm_ice_cipher cipher, u32 data_unit_size);
+bool qcom_scm_has_wrapped_key_support(void);
+int qcom_scm_derive_sw_secret(const u8 *eph_key, size_t eph_key_size,
+			      u8 *sw_secret, size_t sw_secret_size);
+int qcom_scm_generate_ice_key(u8 *lt_key, size_t lt_key_size);
+int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
+			     u8 *eph_key, size_t eph_key_size);
+int qcom_scm_import_ice_key(const u8 *raw_key, size_t raw_key_size,
+			    u8 *lt_key, size_t lt_key_size);
 
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);
 
 int qcom_scm_iommu_set_pt_format(u32 sec_id, u32 ctx_num, u32 pt_fmt);
-- 
2.47.1


