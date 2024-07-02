Return-Path: <linux-fscrypt+bounces-320-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 180AA91F00C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CADB7287412
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9693F14885D;
	Tue,  2 Jul 2024 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RXZ0Kzbq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6988A148847;
	Tue,  2 Jul 2024 07:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905292; cv=none; b=q5JMMliehAOUQMHnf0AxeiD8i210IPScURbgJMYreu6OlzX+ZS7HtWxwn1Y6B+ehepnzTGG3df30+v5mwotKcdJaWMwr+ZQXbLq1WdYc9S88qToMUAoTlHPUinf4JIf84uUd1HQMqhCWkHFvmyytXZFOxwo1OL5Va4Jw5eQb+fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905292; c=relaxed/simple;
	bh=fgtjDmvA7l/lm4vzhuNJpYhxPFnEHAPhYNU28MhUq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvoqRryoebugIY5YIAXlz3JugKp76FSCLgYITQrNZ1DWCnvrX/ZrPX95psJw95VQiMjxFE7b+ykOwig8mgrRGaODIsp4BN8IM93YZiJTKmkl+Gij8/4AosczvPNbP4Ieq0+P1L0jhCX3gShgJBUVUTMoX6mJjj/XxrL4+rojBXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RXZ0Kzbq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28A2C32781;
	Tue,  2 Jul 2024 07:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905292;
	bh=fgtjDmvA7l/lm4vzhuNJpYhxPFnEHAPhYNU28MhUq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXZ0Kzbq+ULcJ0rUMo8CHKuAVDH/E8mMtJIphdMZxWjICSsip3kxl2CDDjk3L4AqR
	 mNGs/PenbzPMgeq6UKk1+7I6tPe1R7RPg2AWhR494E43fTmKWOCGVmS7SC+ALPWtZy
	 5Zkq7knL/PfRBGFXrdvi2J9ew8nWy5e2HyztK7yiBEJAqudofgflTK5dp7rYXJtAn6
	 SIgoEO13d/PU/v0JVA2kSnb5yNVnccJ2SXAls/W0E+scIuYF6v1XGG6qB/wpshdRbt
	 INvJzBsjr+qErmGcfkLXBAuRgSuazlp3URx23ptchVt/0hB1B8/Ucp4p911HuMTCkC
	 G8mPV9q/WVbJQ==
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
Subject: [PATCH v2 3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
Date: Tue,  2 Jul 2024 00:25:07 -0700
Message-ID: <20240702072510.248272-4-ebiggers@kernel.org>
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

Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE which tells the UFS core to not
use the crypto enable bit defined by the UFS specification.  This is
needed to support inline encryption on the "Exynos" UFS controller.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 8 ++++++++
 include/ufs/ufshcd.h             | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index b4980fd91cee..a714dad82cd1 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -108,17 +108,25 @@ static int ufshcd_crypto_keyslot_evict(struct blk_crypto_profile *profile,
 	union ufs_crypto_cfg_entry cfg = {};
 
 	return ufshcd_program_key(hba, &cfg, slot);
 }
 
+/*
+ * Reprogram the keyslots if needed, and return true if CRYPTO_GENERAL_ENABLE
+ * should be used in the host controller initialization sequence.
+ */
 bool ufshcd_crypto_enable(struct ufs_hba *hba)
 {
 	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
 		return false;
 
 	/* Reset might clear all keys, so reprogram all the keys. */
 	blk_crypto_reprogram_all_keys(&hba->crypto_profile);
+
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE)
+		return false;
+
 	return true;
 }
 
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index b354a7eee478..4b7ad23a4420 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -650,10 +650,17 @@ enum ufshcd_quirks {
 	 * nonstandard way and/or needs to override blk_crypto_ll_ops.  If
 	 * enabled, the standard code won't initialize the blk_crypto_profile;
 	 * ufs_hba_variant_ops::init() must do it instead.
 	 */
 	UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE		= 1 << 22,
+
+	/*
+	 * This quirk needs to be enabled if the host controller supports inline
+	 * encryption but does not support the CRYPTO_GENERAL_ENABLE bit, i.e.
+	 * host controller initialization fails if that bit is set.
+	 */
+	UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE		= 1 << 23,
 };
 
 enum ufshcd_caps {
 	/* Allow dynamic clk gating */
 	UFSHCD_CAP_CLK_GATING				= 1 << 0,
-- 
2.45.2


