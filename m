Return-Path: <linux-fscrypt+bounces-321-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2504991F00E
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D5221F21704
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08961149E1A;
	Tue,  2 Jul 2024 07:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epyvH89j"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D8F148FE8;
	Tue,  2 Jul 2024 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905292; cv=none; b=ExinTio5tzRxQhEp0+mFkie9VwYsDDi+DQWOn2k/8JtkzN/GLKvQgJ4yu6Gj2i0yxgjyKjIVMzEzFeg/zXmjFDeCUpuhyihqreK+tjueR8DCptk4GmUvdXxmTKmiFCuNmFJRtcYgSr3RbD9h6dQ6YFzOUJFdKhLJsn/69iFD1YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905292; c=relaxed/simple;
	bh=wdxbvwn5OEVGWzjc/DjUQGsj3FbSX6NwjB9wj/GVnns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qC/6qPwyTXVvcX98ZxXaGcD0f9Y2jPKXRHHHu8eLWw7BjjwouaO/T1aXMxhnv+galYHCyrh/5l2A2R+Wl2tyU51ii/3M+wiFR6qv3yO4oRTMy2YjuaFiS7puspdnPU2DbGM6hurJcoqEM530GrsvF9sWODYxZpQASJZ3bl1X+1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epyvH89j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB60C4AF0D;
	Tue,  2 Jul 2024 07:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905292;
	bh=wdxbvwn5OEVGWzjc/DjUQGsj3FbSX6NwjB9wj/GVnns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epyvH89jEcnMF90ecf5KGnNt6C9kRJN2KahjZvlgK/nEN/zopRvvExKOnMpBwRY1+
	 qEPhu20iHLdjTFm/bd5qf+8jG5yHc5pAgQXkm4Zqcm1oOmzRC7FpGtn8f8vl0Bt8/B
	 rkTQC5oY8x58BIB7I9QSbPVmaLExgC/jWLHRGQi5Cl+Z59BPfb5/n+h6JOxjwzHjtK
	 cfkmeqkfTiIynX0yhkbfsg0aJPRQx5/Emy4vmYlaqrWlOPkEC8Dngx6wrfyIidKVjq
	 x8ijGcE0xum2YNKiiMfhCKjl/tKbRDVszeAG9kzUNbqnJMn05+Pu9d5H3i5BRazULc
	 s2Xux91YaV63w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: [PATCH v2 4/6] scsi: ufs: core: Add fill_crypto_prdt variant op
Date: Tue,  2 Jul 2024 00:25:08 -0700
Message-ID: <20240702072510.248272-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702072510.248272-1-ebiggers@kernel.org>
References: <20240702072510.248272-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a variant op to allow host drivers to initialize nonstandard
crypto-related fields in the PRDT.  This is needed to support inline
encryption on the "Exynos" UFS controller.

Note that this will be used together with the support for overriding the
PRDT entry size that was already added by commit ada1e653a5ea ("scsi:
ufs: core: Allow UFS host drivers to override the sg entry size").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.h | 19 +++++++++++++++++++
 drivers/ufs/core/ufshcd.c        |  2 +-
 include/ufs/ufshcd.h             |  4 ++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-crypto.h
index be8596f20ba2..3eb8df42e194 100644
--- a/drivers/ufs/core/ufshcd-crypto.h
+++ b/drivers/ufs/core/ufshcd-crypto.h
@@ -35,10 +35,23 @@ ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp,
 	h->cci = lrbp->crypto_key_slot;
 	h->dunl = cpu_to_le32(lower_32_bits(lrbp->data_unit_num));
 	h->dunu = cpu_to_le32(upper_32_bits(lrbp->data_unit_num));
 }
 
+static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
+					  struct ufshcd_lrb *lrbp)
+{
+	struct scsi_cmnd *cmd = lrbp->cmd;
+	const struct bio_crypt_ctx *crypt_ctx = scsi_cmd_to_rq(cmd)->crypt_ctx;
+
+	if (crypt_ctx && hba->vops && hba->vops->fill_crypto_prdt)
+		return hba->vops->fill_crypto_prdt(hba, crypt_ctx,
+						   lrbp->ucd_prdt_ptr,
+						   scsi_sg_count(cmd));
+	return 0;
+}
+
 bool ufshcd_crypto_enable(struct ufs_hba *hba);
 
 int ufshcd_hba_init_crypto_capabilities(struct ufs_hba *hba);
 
 void ufshcd_init_crypto(struct ufs_hba *hba);
@@ -52,10 +65,16 @@ static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
 
 static inline void
 ufshcd_prepare_req_desc_hdr_crypto(struct ufshcd_lrb *lrbp,
 				   struct request_desc_header *h) { }
 
+static inline int ufshcd_crypto_fill_prdt(struct ufs_hba *hba,
+					  struct ufshcd_lrb *lrbp)
+{
+	return 0;
+}
+
 static inline bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	return false;
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..744af9708e51 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2634,11 +2634,11 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	if (sg_segments < 0)
 		return sg_segments;
 
 	ufshcd_sgl_to_prdt(hba, lrbp, sg_segments, scsi_sglist(cmd));
 
-	return 0;
+	return ufshcd_crypto_fill_prdt(hba, lrbp);
 }
 
 /**
  * ufshcd_enable_intr - enable interrupts
  * @hba: per adapter instance
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 4b7ad23a4420..59aa6c831a41 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -319,10 +319,11 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
+ * @fill_crypto_prdt: initialize crypto-related fields in the PRDT
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
  * @get_hba_mac: called to get vendor specific mac value, mandatory for mcq mode
  * @op_runtime_config: called to config Operation and runtime regs Pointers
@@ -363,10 +364,13 @@ struct ufs_hba_variant_ops {
 	void	(*config_scaling_param)(struct ufs_hba *hba,
 				struct devfreq_dev_profile *profile,
 				struct devfreq_simple_ondemand_data *data);
 	int	(*program_key)(struct ufs_hba *hba,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
+	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
+				    const struct bio_crypt_ctx *crypt_ctx,
+				    void *prdt, unsigned int num_segments);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
 	void	(*reinit_notify)(struct ufs_hba *);
 	int	(*mcq_config_resource)(struct ufs_hba *hba);
 	int	(*get_hba_mac)(struct ufs_hba *hba);
-- 
2.45.2


