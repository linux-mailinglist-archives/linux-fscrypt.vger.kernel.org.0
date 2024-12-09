Return-Path: <linux-fscrypt+bounces-535-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F01DA9E8AA0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFA95164442
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E458198E78;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwSAvq9I"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D772198E69;
	Mon,  9 Dec 2024 04:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720221; cv=none; b=RLkmCdWiroQhUd8y5myL4iUXL4Ih1IyN0pG/C51iCHYIpFCf4pWcKM2aFswkLZC36U4gkhGLnb1U7JvMrB3uYeH9P1mLs4d7vc1atNnoXg77wOPYkYZqJ658WORLs/JPvn+v4/0yvuJjKWdmRGulFTswRnwZGVt13I+DgVjzmhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720221; c=relaxed/simple;
	bh=IIyT5D4ce1fMq74iTKkTD8qR0aHoyIZUofIUVRvWCzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XS/eJ84oHNzE7BzyCbNRfj1mguD3hCxdonx28Hv7jSA7VSTZ70A1WGlDgqTsekliGneRaQT2n2wjOjBWUDFaRvrpZkbccaahAyHHANonEl0j+M7Zl49RUZDCWt6okkx9SnpWxr/siaQ+RF01eb8qApfwVotZj1h8IZUbtidnNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwSAvq9I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DEAC4CEE0;
	Mon,  9 Dec 2024 04:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720220;
	bh=IIyT5D4ce1fMq74iTKkTD8qR0aHoyIZUofIUVRvWCzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwSAvq9IO/5bBFQi1UZjIl+9AhxK5K2k9pY+DafLiQ2pXws6ShkHYA5Gk+QbsaAaL
	 b3SzOEz4CB+42E96URRk8cg4RucZwNn7o3Yt6YzaJ542f+byD21K6K/Mx26eHTiVUT
	 FABJCyON6/z3B+tYrd8YAv7Ngax2+9iTCGOB8CgIgzUIhCUUkklx7tZg/rHnrLnJx1
	 hU9w0IOh2u/8WZV2TMKgysZX1pxUPCvtV+Sy/HiPBPNwsZTzTA/5s6Wrla+sc2+BKX
	 GLaXu2d/OiCJfe4crtayGcqkbBNmE7/6GwbV03xxBB3C1cNpeciPZgGe2TEiVVnPPe
	 Wh3qx4S7e3Y1A==
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
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH v9 03/12] mmc: crypto: add mmc_from_crypto_profile()
Date: Sun,  8 Dec 2024 20:55:21 -0800
Message-ID: <20241209045530.507833-4-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

Add a helper function that encapsulates a container_of expression.  For
now there is just one user but soon there will be more.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-crypto.c | 5 +----
 include/linux/mmc/host.h        | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index d5f4b6972f63e..2951911d3f780 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -23,14 +23,11 @@ static const struct cqhci_crypto_alg_entry {
 };
 
 static inline struct cqhci_host *
 cqhci_host_from_crypto_profile(struct blk_crypto_profile *profile)
 {
-	struct mmc_host *mmc =
-		container_of(profile, struct mmc_host, crypto_profile);
-
-	return mmc->cqe_private;
+	return mmc_from_crypto_profile(profile)->cqe_private;
 }
 
 static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
 				    const union cqhci_crypto_cfg_entry *cfg,
 				    int slot)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f166d6611ddb9..68f09a955a902 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -588,10 +588,18 @@ static inline void *mmc_priv(struct mmc_host *host)
 static inline struct mmc_host *mmc_from_priv(void *priv)
 {
 	return container_of(priv, struct mmc_host, private);
 }
 
+#ifdef CONFIG_MMC_CRYPTO
+static inline struct mmc_host *
+mmc_from_crypto_profile(struct blk_crypto_profile *profile)
+{
+	return container_of(profile, struct mmc_host, crypto_profile);
+}
+#endif
+
 #define mmc_host_is_spi(host)	((host)->caps & MMC_CAP_SPI)
 
 #define mmc_dev(x)	((x)->parent)
 #define mmc_classdev(x)	(&(x)->class_dev)
 #define mmc_hostname(x)	(dev_name(&(x)->class_dev))
-- 
2.47.1


