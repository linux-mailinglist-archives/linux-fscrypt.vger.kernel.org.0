Return-Path: <linux-fscrypt+bounces-557-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F36E9F0390
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FD3A281728
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510EE18A959;
	Fri, 13 Dec 2024 04:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol59l+I+"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC6F18A931;
	Fri, 13 Dec 2024 04:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063625; cv=none; b=JHwg1AIiU6L0ND4i/7COAejR61A9nFaUL5gIFiA03XFGzT7F0bBjTjcuD60WQsgWOvv1b7aE7EmAMjJvrGkguM4BZDAeYVmTBdD/MJXDfr+1ltMC1yjMrLs62/K7BV6sgQfuBA1NH+hgShI2LArmZI7w9hiIZF7QOkbZ3g0rUb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063625; c=relaxed/simple;
	bh=uuDhiSijNMYjt2UeBFhL1ivhimZY+9X82SMTtUIe7vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hI3RwyLTFhQC2Bj85kysJMQzXc9gQqL1wXTuAAjTfHlEJq5BEsD6eXCkr6frLi1/G03hv6+JzDUrQs0P1JipPVDerHwrsC8SqvNdr7GxsqbYx7quBy1LRtYj5FAuNJOkZlrPTjv4KJ02iLrz6+dCZsqXyw2g8wwGdBmQez/EuTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol59l+I+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF11C4CEDD;
	Fri, 13 Dec 2024 04:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063624;
	bh=uuDhiSijNMYjt2UeBFhL1ivhimZY+9X82SMTtUIe7vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ol59l+I+2MPBFrtlhC2cEf0ZBFeZoYLWNSOtYgQFCDrb/LHiSpGbngpBurZTd3IdJ
	 /f0V4O/8ZsOjc8x5NQOhUKQYFfyfe9Bs3vjFNs8ZyR7r8frBaYZ/gyFKPCtwSsHI0P
	 WJNNCP/3m/SbDmhXxkrQair46bFZWZV0D9loin1gq6BRpAtWeXKMG7TSCX3aimtufO
	 Tsn56dP6MSBX2abSmxBJ1yykopAhc16N1KSLF9f9WyQl10foO76NgC65X6rFo6EZFW
	 6m2mUmFS8CVQf9nA/3f37YxC2cRQ8QXMSFiVqix8Uzj2tQgylD/yLT8YgCaVHpnkVP
	 HhKX0dd2EIrMw==
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
	stable@vger.kernel.org,
	Abel Vesa <abel.vesa@linaro.org>
Subject: [PATCH v10 05/15] mmc: sdhci-msm: fix crypto key eviction
Date: Thu, 12 Dec 2024 20:19:48 -0800
Message-ID: <20241213041958.202565-6-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

Commit c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
introduced an incorrect check of the algorithm ID into the key eviction
path, and thus qcom_ice_evict_key() is no longer ever called.  Fix it.

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/sdhci-msm.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index e00208535bd1..319f0ebbe652 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1865,24 +1865,24 @@ static int sdhci_msm_program_key(struct cqhci_host *cq_host,
 	struct sdhci_host *host = mmc_priv(cq_host->mmc);
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_msm_host *msm_host = sdhci_pltfm_priv(pltfm_host);
 	union cqhci_crypto_cap_entry cap;
 
+	if (!(cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE))
+		return qcom_ice_evict_key(msm_host->ice, slot);
+
 	/* Only AES-256-XTS has been tested so far. */
 	cap = cq_host->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != CQHCI_CRYPTO_ALG_AES_XTS ||
 		cap.key_size != CQHCI_CRYPTO_KEY_SIZE_256)
 		return -EINVAL;
 
-	if (cfg->config_enable & CQHCI_CRYPTO_CONFIGURATION_ENABLE)
-		return qcom_ice_program_key(msm_host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(msm_host->ice, slot);
+	return qcom_ice_program_key(msm_host->ice,
+				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				    cfg->crypto_key,
+				    cfg->data_unit_size, slot);
 }
 
 #else /* CONFIG_MMC_CRYPTO */
 
 static inline int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
-- 
2.47.1


