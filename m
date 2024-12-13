Return-Path: <linux-fscrypt+bounces-561-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7709F03A5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91414188B3A0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C329618E37D;
	Fri, 13 Dec 2024 04:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/QArGwD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EE618E368;
	Fri, 13 Dec 2024 04:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063628; cv=none; b=a/G7fZIlBzRZGK++n86UQIHSOPljkVou8Hg+np8yK35BRVHxtrLcuBJLqw6aPdztggoccdsoUzlzyiMGp5C1EQ5Tkec7S7itgFjhM30vb0/5UjWImPx5Myv0AUixkvsoHYf6YxFfB3KPT+zuse42Z9rAC8+lTypnR4wlgwM9c9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063628; c=relaxed/simple;
	bh=upmhR6UpaCEsr2nmxCkRFfUzAUQhy1gG+fn5Qp9xlEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9LvNL8tsSnEcO42niC7ZMQgc+TOkOXr6c0RvloIaSv3aMH9j9Xg0Xr5FJaAKNm3CdMIQEA821f/Mz9+PMBBZHYa7LHP6gaaRSYDnEWNFwaaTWLdrQ71gPgy/3+Y1sj+XKVWlwmaqAd+9gn5Vomq4UqksPC9L7jqN1S0N6mC8eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/QArGwD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44557C4AF0E;
	Fri, 13 Dec 2024 04:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063626;
	bh=upmhR6UpaCEsr2nmxCkRFfUzAUQhy1gG+fn5Qp9xlEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/QArGwDj8UnZklwF3nqNd9kEchoSISRzrJjvGggMafixQGjetNu5JEsARse1dJVU
	 1MoxQ61lSVNhQGmqvYwFdYINKT+Q5Lx7a7qoqiCGswTJ0wLnfMuaD0tToK1xWPM1we
	 HK9FIdCqlF+IOAm2wot0ceHVnpoXV291+A4zT2LmybvL+azXh6x75idJi8/XP+606W
	 eQh+SG6rmTqUlG+62mteuwFJX7f51aPA/cvn8eyWam+tl6qbubgUHR01qdjt0k83tD
	 7yoQpGSXRfRLR0AX7X6aMuYi2Sxw7hheJ1YqyXpJ37GH3Ofpq5R3zmRfyDVBVaJ12y
	 ciMvuoJk2BtSw==
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
Subject: [PATCH v10 08/15] firmware: qcom: scm: add calls for wrapped key support
Date: Thu, 12 Dec 2024 20:19:51 -0800
Message-ID: <20241213041958.202565-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
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
index 72bf87ddcd96..36f3ddcb9020 100644
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
+	memcpy(eph_key_buf, eph_key, eph_key_size);
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
index e36b2f67607f..097369d38b84 100644
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
index 4621aec0328c..983e1591bbba 100644
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


