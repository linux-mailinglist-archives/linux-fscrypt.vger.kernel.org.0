Return-Path: <linux-fscrypt+bounces-378-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A767196FA97
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Sep 2024 20:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36625288063
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Sep 2024 18:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801671DEFC8;
	Fri,  6 Sep 2024 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="HW7aMjrv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507081DA2FD
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Sep 2024 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725646058; cv=none; b=o7c4TgtxyUvxNfNV8cz73/otcI1FlRqJjQita5bST4rW4IMGGKWfTCFz14TDWFjD+lTQJDLpXYfbr8mDh+e/n0QPTkQedimXh7skuVBT9V+hqRyL/ZhjF4CQiE7kxIUZv9MBwv0YUJdR22xdC9bzI6AqmUomAbStRfcKmuuj8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725646058; c=relaxed/simple;
	bh=irgDTLyY3hYaEVaiJ6407O5na2PpR2QjbQwIs1hQLGM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EZQQZfyCqESQBnvTd93x3JkfDhc//0BqxyjZ0y5eSIGq5Y5pRff1LFVPY8w9sy6h8bAnAIPFgf49BecSgW3fzWd9lsOqWa3/4viyZXOJ2M66giehmDJPXj94HoHdaJtC0fANshoBNt/G6dynWunyvMyp7yl7b/csvAxEnIf7eXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=HW7aMjrv; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42cacabd2e0so1625865e9.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 06 Sep 2024 11:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1725646054; x=1726250854; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hMNoELwUf2k93lrx+eZDH/Ei7XJIQhd3J2WS1OSTX/I=;
        b=HW7aMjrvOErN0ZCuNrXiosjLGeELStrVQynvSZLbcGaCHmh2ZIUp4ORJc+r0RuBEh9
         WWTftFPEiatceb+/jD05cgbuagrE0mY0R4qDfnRNoJiqOhVvVW1JoJoGA0YS+Omb6MYz
         kjDsyNFQmoZBJ8YcC5wx5Vd/FUq4IcelhOeFB0phg8imI8RQ8BGaCaGCidzojbUO5vid
         Tncdi3MjfaelPW7C62XPFph76wcVuhCx0IPHV/yiwEKeDE3GjSD5zzQH7H20LksJBkLP
         ocioGe/8ZtyIJ6dWuFltxDQrsOfFihEWtJARBRSg49Ow1MV4yo3BXNJTmMe8vwt/tKsd
         LdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725646054; x=1726250854;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMNoELwUf2k93lrx+eZDH/Ei7XJIQhd3J2WS1OSTX/I=;
        b=egoV0BgSoe5BaZ7O0mS+gENaJvfj7qv6wr55TdpxRIy8v2/aAnUxIaCNnWQesV6aqH
         4Tv41wHrIHq7xD9uX4ckluT/ycwrIZpa4265gzkkl6q5NA61DsbHZ38fEP5ojSbpyg2d
         wxRyPDeYq7mOABZx3B9IykfF7N8Fr1vkmbNSGFknSBGTgjEIWxORnNajL8LFlMHCxmKD
         a3O5oRhChnBGzjjaCpKRSoLJdR9wjzxx/6NjFLE+0Z7Nd0pcBkDu0mzBsCLxY0J5txj5
         HNF6hcnKQeJWCdjsRbek6ckJwIEFV3VMhi8pIlPvLYC/Hgom3E4yzRSsCj+cnSB2nHtN
         sNxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhevvwCKz/Xxjvy7LyIzIrbKnN1aWd3ON7QAR6PVd8HKu7Wi3t6JWVvp4+NWWxO4I1Vxen3EUlfAXOBir8@vger.kernel.org
X-Gm-Message-State: AOJu0YwcqYVzrOcZXPUSBpv0M3KS4welrorKbMCoCAHb2DVoj/n8/3Uh
	1umfG0zUrGxWJ7nJjijDqY4vF8v3iBL+A2XdpWuJ3veAQkozxC7Rk7vBoiuAmyg=
X-Google-Smtp-Source: AGHT+IEiGm6nQGX6c15xmiCG1B0tjaL/VWsr7CPQKnWha4io2gcnqwe+GXdp83VzUx/Gfb61dB/R8g==
X-Received: by 2002:a05:600c:5493:b0:426:622d:9e6b with SMTP id 5b1f17b1804b1-42c9f9d7517mr24964255e9.23.1725646053442;
        Fri, 06 Sep 2024 11:07:33 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:b9fc:a1e7:588c:1e37])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42cac8543dbsm5880485e9.42.2024.09.06.11.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 11:07:32 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 06 Sep 2024 20:07:08 +0200
Subject: [PATCH v6 05/17] ice, ufs, mmc: use the blk_crypto_key struct when
 programming the key
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240906-wrapped-keys-v6-5-d59e61bc0cb4@linaro.org>
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
In-Reply-To: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
 Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9551;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=0s11nFj+40N+OJOi/aj0JqlyNsih24DQx9OQTYByd0c=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBm20TWdBCEgl2M+4Y5IpLk2Zn9Rr5Yw4lp7gTYL
 G6Vi0KEs5mJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZttE1gAKCRARpy6gFHHX
 clF2EACm09NercIXgcRvHAZ2TcAW6UvFQp3BLObznaALdVlbrsF4YY29zMXML05l/5tv3CQWVVq
 MYnUNNXx8lONrJrGGqimhgDXLIbHuC9AfRps95/m4oq0F+FNpMa/A1Pr1H31h/btHLpA8RWXEmo
 5+FSc7sRSr1nn0tpEdxxxTY/5xqesg2yrkOuc+/k9/ES+vbFk0PpT7I29bL2hJNTAE3KfYvf4nj
 zq/GKA5elvY+EKjH5O26zMJ3O2SN3NGPpxuffb0Uye+tNLUhB8ptClRr6zbLHBgn+oEdfecdGws
 DxtGBdqeD31oDtiewsPrg2Xk+9eBhsTXk1F/dGa5dk+PdJLQH+pL6Gw3APbri2SaXHPPd80wA9O
 sk3+omhNGH0CnIsVOPi+MqGP7GsC3yCYyDF0Ie1nWPCEIALX3QzOYLjghOZ81D1ovbzQoE1/bcD
 hsI6dFIiBZszBJux0lyAmEH+ydhGiQ2+ZWCG09aggduITrDWg/jSJWCIyWEatxnpFuR9l6PBrgr
 nDlXcz8msF+GdcOs8lGqvgTQNYv8pyMJQP9mDQg8JkOaQTgsC4uJiLYbHGu7k/jSIvAP5pLiSzZ
 JC6vydzmI7L5XOfhMSdJn2EFfwZ3oeukJUW5mYJGGXh6IXlmYYXBtl9lrhgMG75ZKrn/68ubdqh
 tFvsPchj0Ftk4ag==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Gaurav Kashyap <quic_gaurkash@quicinc.com>

The program key ops in the storage controller does not pass on the
blk_crypto_key structure to ICE, this is okay with raw keys of standard
AES XTS sizes. However, wrapped keyblobs can be of any size and in
preparation for that, modify the ICE and storage controller APIs to
accept blk_crypto_key which can carry larger keys and indicate their
size.

Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/mmc/host/cqhci-crypto.c  | 7 ++++---
 drivers/mmc/host/cqhci.h         | 2 ++
 drivers/mmc/host/sdhci-msm.c     | 6 ++++--
 drivers/soc/qcom/ice.c           | 6 +++---
 drivers/ufs/core/ufshcd-crypto.c | 7 ++++---
 drivers/ufs/host/ufs-qcom.c      | 6 ++++--
 include/soc/qcom/ice.h           | 5 +++--
 include/ufs/ufshcd.h             | 1 +
 8 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 6652982410ec..91da6de1d650 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -32,6 +32,7 @@ cqhci_host_from_crypto_profile(struct blk_crypto_profile *profile)
 }
 
 static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
+				    const struct blk_crypto_key *bkey,
 				    const union cqhci_crypto_cfg_entry *cfg,
 				    int slot)
 {
@@ -39,7 +40,7 @@ static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
 	int i;
 
 	if (cq_host->ops->program_key)
-		return cq_host->ops->program_key(cq_host, cfg, slot);
+		return cq_host->ops->program_key(cq_host, bkey, cfg, slot);
 
 	/* Clear CFGE */
 	cqhci_writel(cq_host, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
@@ -99,7 +100,7 @@ static int cqhci_crypto_keyslot_program(struct blk_crypto_profile *profile,
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	err = cqhci_crypto_program_key(cq_host, &cfg, slot);
+	err = cqhci_crypto_program_key(cq_host, key, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
 	return err;
@@ -113,7 +114,7 @@ static int cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
 	 */
 	union cqhci_crypto_cfg_entry cfg = {};
 
-	return cqhci_crypto_program_key(cq_host, &cfg, slot);
+	return cqhci_crypto_program_key(cq_host, NULL, &cfg, slot);
 }
 
 static int cqhci_crypto_keyslot_evict(struct blk_crypto_profile *profile,
diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
index fab9d74445ba..06099fd32f23 100644
--- a/drivers/mmc/host/cqhci.h
+++ b/drivers/mmc/host/cqhci.h
@@ -12,6 +12,7 @@
 #include <linux/completion.h>
 #include <linux/wait.h>
 #include <linux/irqreturn.h>
+#include <linux/blk-crypto.h>
 #include <asm/io.h>
 
 /* registers */
@@ -291,6 +292,7 @@ struct cqhci_host_ops {
 	void (*post_disable)(struct mmc_host *mmc);
 #ifdef CONFIG_MMC_CRYPTO
 	int (*program_key)(struct cqhci_host *cq_host,
+			   const struct blk_crypto_key *bkey,
 			   const union cqhci_crypto_cfg_entry *cfg, int slot);
 #endif
 	void (*set_tran_desc)(struct cqhci_host *cq_host, u8 **desc,
diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e113b99a3eab..f661d855b77e 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1859,6 +1859,7 @@ static __maybe_unused int sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_host)
  * vendor-specific SCM calls for this; it doesn't support the standard way.
  */
 static int sdhci_msm_program_key(struct cqhci_host *cq_host,
+				 const struct blk_crypto_key *bkey,
 				 const union cqhci_crypto_cfg_entry *cfg,
 				 int slot)
 {
@@ -1866,6 +1867,7 @@ static int sdhci_msm_program_key(struct cqhci_host *cq_host,
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
 	union cqhci_crypto_cap_entry cap;
+	u8 ice_key_size;
 
 	/* Only AES-256-XTS has been tested so far. */
 	cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
@@ -1873,11 +1875,11 @@ static int sdhci_msm_program_key(struct cqhci_host *cq_host,
 		cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256)
 		return -EINVAL;
 
+	ice_key_size = QCOM_ICE_CRYPTO_KEY_SIZE_256;
 	if (cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE)
 		return qcom_ice_program_key(msm_host->ice,
 					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
+					    ice_key_size, bkey,
 					    cfg->data_unit_size, slot);
 	else
 		return qcom_ice_evict_key(msm_host->ice, slot);
diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
index 50be7a9274a1..4393262a1bf2 100644
--- a/drivers/soc/qcom/ice.c
+++ b/drivers/soc/qcom/ice.c
@@ -164,8 +164,8 @@ EXPORT_SYMBOL_GPL(qcom_ice_suspend);
 
 int qcom_ice_program_key(struct qcom_ice *ice,
 			 u8 algorithm_id, u8 key_size,
-			 const u8 crypto_key[], u8 data_unit_size,
-			 int slot)
+			 const struct blk_crypto_key *bkey,
+			 u8 data_unit_size, int slot)
 {
 	struct device *dev = ice->dev;
 	union {
@@ -184,7 +184,7 @@ int qcom_ice_program_key(struct qcom_ice *ice,
 		return -EINVAL;
 	}
 
-	memcpy(key.bytes, crypto_key, AES_256_XTS_KEY_SIZE);
+	memcpy(key.bytes, bkey->raw, AES_256_XTS_KEY_SIZE);
 
 	/* The SCM call requires that the key words are encoded in big endian */
 	for (i = 0; i < ARRAY_SIZE(key.words); i++)
diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 7d3a3e228db0..33083e0cad6e 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -18,6 +18,7 @@ static const struct ufs_crypto_alg_entry {
 };
 
 static int ufshcd_program_key(struct ufs_hba *hba,
+			      const struct blk_crypto_key *bkey,
 			      const union ufs_crypto_cfg_entry *cfg, int slot)
 {
 	int i;
@@ -27,7 +28,7 @@ static int ufshcd_program_key(struct ufs_hba *hba,
 	ufshcd_hold(hba);
 
 	if (hba->vops && hba->vops->program_key) {
-		err = hba->vops->program_key(hba, cfg, slot);
+		err = hba->vops->program_key(hba, bkey, cfg, slot);
 		goto out;
 	}
 
@@ -89,7 +90,7 @@ static int ufshcd_crypto_keyslot_program(struct blk_crypto_profile *profile,
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	err = ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, key, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
 	return err;
@@ -107,7 +108,7 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	 */
 	union ufs_crypto_cfg_entry cfg = {};
 
-	return ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, NULL, &cfg, slot);
 }
 
 /*
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c87fdc849c62..58018fc8999d 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -150,6 +150,7 @@ static inline int ufs_qcom_ice_suspend(struct ufs_qcom_host *host)
 }
 
 static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+				    const struct blk_crypto_key *bkey,
 				    const union ufs_crypto_cfg_entry *cfg,
 				    int slot)
 {
@@ -157,6 +158,7 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 	union ufs_crypto_cap_entry cap;
 	bool config_enable =
 		cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE;
+	u8 ice_key_size;
 
 	/* Only AES-256-XTS has been tested so far. */
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
@@ -164,11 +166,11 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
 		return -EOPNOTSUPP;
 
+	ice_key_size = QCOM_ICE_CRYPTO_KEY_SIZE_256;
 	if (config_enable)
 		return qcom_ice_program_key(host->ice,
 					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
+					    ice_key_size, bkey,
 					    cfg->data_unit_size, slot);
 	else
 		return qcom_ice_evict_key(host->ice, slot);
diff --git a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h
index 5870a94599a2..9dd835dba2a7 100644
--- a/include/soc/qcom/ice.h
+++ b/include/soc/qcom/ice.h
@@ -7,6 +7,7 @@
 #define __QCOM_ICE_H__
 
 #include <linux/types.h>
+#include <linux/blk-crypto.h>
 
 struct qcom_ice;
 
@@ -30,8 +31,8 @@ int qcom_ice_resume(struct qcom_ice *ice);
 int qcom_ice_suspend(struct qcom_ice *ice);
 int qcom_ice_program_key(struct qcom_ice *ice,
 			 u8 algorithm_id, u8 key_size,
-			 const u8 crypto_key[], u8 data_unit_size,
-			 int slot);
+			 const struct blk_crypto_key *bkey,
+			 u8 data_unit_size, int slot);
 int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
 struct qcom_ice *of_qcom_ice_get(struct device *dev);
 #endif /* __QCOM_ICE_H__ */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 3f68ae3e4330..0beb010bb8da 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -370,6 +370,7 @@ struct ufs_hba_variant_ops {
 				struct devfreq_dev_profile *profile,
 				struct devfreq_simple_ondemand_data *data);
 	int	(*program_key)(struct ufs_hba *hba,
+			       const struct blk_crypto_key *bkey,
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	int	(*fill_crypto_prdt)(struct ufs_hba *hba,
 				    const struct bio_crypt_ctx *crypt_ctx,

-- 
2.43.0


