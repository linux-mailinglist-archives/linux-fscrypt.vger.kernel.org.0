Return-Path: <linux-fscrypt+bounces-553-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CA49F037B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A388188B308
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669D418595B;
	Fri, 13 Dec 2024 04:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eR7CdVY1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D89A183CC2;
	Fri, 13 Dec 2024 04:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063622; cv=none; b=DVwsL4oIMNJniOpjYO4o1hrNquHZXiiLqVvhLGAh3yfXDCa77QQ8nC+OkOpqzuWEX8yixwNvs3dvinKghcXbUOo84yYP+RA1qUsjP3HzjcNTLxh2c588/6ifpemfge8pWesvyUHCg7Dt7l9fyxWKCtylrfFwh76uQiY7BqyBPbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063622; c=relaxed/simple;
	bh=AaC+1vxEA/0Ps6XkTxxgdz9OUQfUnIhVy82NSH4smXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsMLEfpysJ48SXyJuIpjQ1q086YL03DI6oswTUHuwDO5PKIytnt8ccILrPSyPEFDAp8KVbFOpEoBAqSGD4dGnCFGDwx2OTlCe14girKKVAXfOBijGofDJl2yldv14PUuxzmSjRJxCV9N/owGA5Sfl3IkdKB3ZMzBXx57hhhe+/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eR7CdVY1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD7C4CEDE;
	Fri, 13 Dec 2024 04:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063621;
	bh=AaC+1vxEA/0Ps6XkTxxgdz9OUQfUnIhVy82NSH4smXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eR7CdVY14cqeqeRCQeWuyQ8ya0c67uDNCdXjoAIF+23TplyE1PaCmc0r8eJry6vZ6
	 NV2CJZMsPao0GVt4hPy5tKpdyqtupd/ol9yfbHekwmrCCp3v1X04SfgCBBLB+v+9WV
	 ImMTVTWtJa2gZhF9JJ5uAEcQWsUD59c+KTnsqF9H9MPhic0mKpYtwi8Trd/Esgi9GB
	 MVc1stra3gUv6uXidl8PWQcp4S+ZXA+04AYLq3Y/j45GLW57gHScQZ/y5nOZOqY0dR
	 5US36MNaLIzLlNAfz3cOzizq/Im5e3cG9tiTGz3s5qu4KGnthWmgmbXrG0sf1cU+jW
	 lf70MaKDcTDeQ==
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
Subject: [PATCH v10 01/15] ufs: qcom: fix crypto key eviction
Date: Thu, 12 Dec 2024 20:19:44 -0800
Message-ID: <20241213041958.202565-2-ebiggers@kernel.org>
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

Commit 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
introduced an incorrect check of the algorithm ID into the key eviction
path, and thus qcom_ice_evict_key() is no longer ever called.  Fix it.

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-qcom.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 68040b2ab5f8..e33ae71245dd 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -153,27 +153,25 @@ static int ufs_qcom_ice_program_key(struct ufs_hba *hba,
 				    const union ufs_crypto_cfg_entry *cfg,
 				    int slot)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	union ufs_crypto_cap_entry cap;
-	bool config_enable =
-		cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE;
+
+	if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
+		return qcom_ice_evict_key(host->ice, slot);
 
 	/* Only AES-256-XTS has been tested so far. */
 	cap = hba->crypto_cap_array[cfg->crypto_cap_idx];
 	if (cap.algorithm_id != UFS_CRYPTO_ALG_AES_XTS ||
 	    cap.key_size != UFS_CRYPTO_KEY_SIZE_256)
 		return -EOPNOTSUPP;
 
-	if (config_enable)
-		return qcom_ice_program_key(host->ice,
-					    QCOM_ICE_CRYPTO_ALG_AES_XTS,
-					    QCOM_ICE_CRYPTO_KEY_SIZE_256,
-					    cfg->crypto_key,
-					    cfg->data_unit_size, slot);
-	else
-		return qcom_ice_evict_key(host->ice, slot);
+	return qcom_ice_program_key(host->ice,
+				    QCOM_ICE_CRYPTO_ALG_AES_XTS,
+				    QCOM_ICE_CRYPTO_KEY_SIZE_256,
+				    cfg->crypto_key,
+				    cfg->data_unit_size, slot);
 }
 
 #else
 
 #define ufs_qcom_ice_program_key NULL
-- 
2.47.1


