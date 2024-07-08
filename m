Return-Path: <linux-fscrypt+bounces-336-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A8092ACB1
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Jul 2024 01:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD9CC1C216BA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 23:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7DB14F118;
	Mon,  8 Jul 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIvLZBh9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519E93A27B;
	Mon,  8 Jul 2024 23:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720482935; cv=none; b=t/pJCzA3xj/eeqkzwjwEjrhmSS2JyrFa8R2RtvuhkykJVl2GDj7UhbULot+OnG1gT0xEbcbg18mYCM1Pd6JiwKBtjkNFCN/4nCCJ6qzKSDDPwJQ7mslHNxf8C1PaO/pTez4d4g2sY+Sl/4B2nXlN0fulSUvJWmQal1XM3gWszg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720482935; c=relaxed/simple;
	bh=4eLoOGMlNiXI0uXZXhcDQoeJVinC1toydpbMDt2g5A8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RadQ7Ljln+mDUrhKYMwX3GnrSlejhY4DFk88/aXe+qBu6DrytZgb89epsJV9VFl5hHz+ec4dwvp2MSx4SVDzZhOwbZY7fetbuaEtTfUuQAtPH3OIrAg29FOgFFpETd4+7ih5ZfGX7pTdPL8wrTFAkOy2VISLqkl91zei966jBFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIvLZBh9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89748C116B1;
	Mon,  8 Jul 2024 23:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720482934;
	bh=4eLoOGMlNiXI0uXZXhcDQoeJVinC1toydpbMDt2g5A8=;
	h=From:To:Cc:Subject:Date:From;
	b=ZIvLZBh9EXLn6HB4NsuIujz2PJKxK9O5n9Qgn9Zjk/weaqkhzkMV+ASk804pdbhaT
	 UrqgpuXHh1JSiK5euxrh/r/Vvme0Uka9CBq2le1ngfIo03Phpnym15gFVCUkaRVhok
	 qgdGIrPg+5eOaxsswZp7HhTztpPytowzRf5zJVtW+RsJ66pLbWpCCaOBqewPMKlR2g
	 T9UyZ0QOqUFOjMqKjA310NAVkU/kP9xYMB6MgmvCVgdYprvotGlN58ZqiIgsCq1N+w
	 JCs6ye/CcPNQUDTZCyNAi3rip9t/nvjjdj+XuA45fSKSiM1o3Of8Ig4sUG7GBpSscI
	 v2jwTno2fc+tQ==
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
Subject: [PATCH v3 0/6] Basic inline encryption support for ufs-exynos
Date: Mon,  8 Jul 2024 16:53:24 -0700
Message-ID: <20240708235330.103590-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for Flash Memory Protector (FMP), which is the inline
encryption hardware on Exynos and Exynos-based SoCs.

Specifically, add support for the "traditional FMP mode" that works on
many Exynos-based SoCs including gs101.  This is the mode that uses
"software keys" and is compatible with the upstream kernel's existing
inline encryption framework in the block and filesystem layers.  I plan
to add support for the wrapped key support on gs101 at a later time.

Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
xfstests on a filesystem mounted with the 'inlinecrypt' mount option.

This patchset applies to v6.10-rc6, and it has no prerequisites that
aren't already upstream.

Changed in v3:
  - Made the FMP support depend on EXYNOS_UFS_OPT_UFSPR_SECURE, since
    the !EXYNOS_UFS_OPT_UFSPR_SECURE case has not yet been tested
  - Replaced LOG2_DATA_UNIT_SIZE with ilog2(DATA_UNIT_SIZE)
  - Added Reviewed-by tags

Changed in v2:
  - Added DATA_UNIT_SIZE macro
  - Changed a comment into kerneldoc
  - Used ARM_SMCCC_CALL_VAL() to define SMC codes
  - Used arm_smccc_smc() directly instead of via a wrapper function

Eric Biggers (6):
  scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
  scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
  scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
  scsi: ufs: core: Add fill_crypto_prdt variant op
  scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
  scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)

 drivers/ufs/core/ufshcd-crypto.c |  34 +++--
 drivers/ufs/core/ufshcd-crypto.h |  36 +++++
 drivers/ufs/core/ufshcd.c        |   3 +-
 drivers/ufs/host/ufs-exynos.c    | 240 ++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h             |  28 ++++
 5 files changed, 320 insertions(+), 21 deletions(-)


base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
-- 
2.45.2


