Return-Path: <linux-fscrypt+bounces-558-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D0A9F0397
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19170188B383
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECAB18BC3B;
	Fri, 13 Dec 2024 04:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s1k0roxD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B079149C53;
	Fri, 13 Dec 2024 04:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063625; cv=none; b=p9BYyFHkvCybZ17A8CdNRUuySrLuTmP8lUk4tyFmKlw/6yL6g+ilnvJ0p1MeamtFtwGKj3ZaP6OW01g6mc5/JFGom24UYaOu2CYKZotPpIXCgxCdzYgDqnwzGjul+r29hANSUM1iUW9RcVeBHESlVzCqG61/0MgKrN6dpCqoJ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063625; c=relaxed/simple;
	bh=ST8yJd4YKyC9ff9j/2CdRB3RjxotfxK2/uyoOpiToMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLsKoVpRI0SkvPoN0gr7Ha2/uik1gnhZybVydEtBDEdwUBjhiLvf7r/cB32GnHumPDdGF23HA6o5sIQtNUs+kCy1av63LdxT+pVWCKSoA19YsVDhl7CPksXvXKXpja6ZwpmZxDyGLrYU7ol4fl1y5yk+F9FS+u3QSsI2kgpcRZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s1k0roxD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C0AC4CED7;
	Fri, 13 Dec 2024 04:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063625;
	bh=ST8yJd4YKyC9ff9j/2CdRB3RjxotfxK2/uyoOpiToMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1k0roxD1w/rn1+suL2zQLX06jFqZVeNFUPU77KVvnyLorinHTS2bBIJ8hrLXYGjt
	 qtJNik7cZk8SKlm+p27fFXSqNzH4igC4OKtSMW+Kw3Xy1FGEYl8dSSfO4LrG7o8b9x
	 dE8CCfXTgGc+hAp4tGMxtAzedLrLsOVG1Q3darLG5XjfaYGNAPzQ5FaTO2IxjVA6DN
	 RKjzf4ll2vDsOOpl2G8QBD4nLmB9sCfo0ubtmM1kS9MMoSlhP765W9piZrBRIovXXE
	 77+iSCG7Lwzl/MI/DhbP2GMl/p1Fq7Updy0fHmbxZJDqCMxZs5vxWNk1W5i5yYcBID
	 BtW/JL4x74I9w==
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
Subject: [PATCH v10 06/15] mmc: crypto: add mmc_from_crypto_profile()
Date: Thu, 12 Dec 2024 20:19:49 -0800
Message-ID: <20241213041958.202565-7-ebiggers@kernel.org>
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

Add a helper function that encapsulates a container_of expression.  For
now there is just one user but soon there will be more.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-crypto.c | 5 +----
 include/linux/mmc/host.h        | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index d5f4b6972f63..2951911d3f78 100644
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
index f166d6611ddb..68f09a955a90 100644
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


