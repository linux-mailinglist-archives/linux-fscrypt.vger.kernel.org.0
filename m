Return-Path: <linux-fscrypt+bounces-317-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8EC291F003
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 83CC41F216FD
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6674913D53D;
	Tue,  2 Jul 2024 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fshTbrA8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760313D248;
	Tue,  2 Jul 2024 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905291; cv=none; b=DcuScJvnoua4yYyNmCkKo/TQMNfL6kCJco1pFlZBgr+a9v4kxre4uenLdDMDbKwpvly5rdFCqlI1FE9tAdqW/s3u0b971BysYX+MU5WGFvsVQohZZHSLD94mcevER4kxFj8BhPdkRE/K520VVNrS5YMLijiHGSDqonf31ATmVlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905291; c=relaxed/simple;
	bh=ieP2E7kwi8hLXMi6bItVP7C6DXuj3MzTyed1o0xIdRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MAkMiAlYtRc+xmZM0ObSjDEnPoagTmDeYMaCv1b9kKrHyYMs+vXSwmDGH4Q2IO8BjwhNkJPGix9ETAG/enbvCiK2tXBbPdWwjPeeRMfQ41zi6raS8Edro/tCqQShVFpYo+CTQSKv+oxPjeuy9milPKS1dAAHPQYlFM4j/G4u/tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fshTbrA8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64367C116B1;
	Tue,  2 Jul 2024 07:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905290;
	bh=ieP2E7kwi8hLXMi6bItVP7C6DXuj3MzTyed1o0xIdRU=;
	h=From:To:Cc:Subject:Date:From;
	b=fshTbrA8SNd27T7GauVYX6YlI5W1HW4OO22Yww1SuNJDMztSCXa3JwD04IMTWbUS7
	 I7uFfZsZC/BcYV+XCNkVeC1VMVo/MNzOOlv1bCRZ0oyPkvL+CO6B9A6SihqaGhItA7
	 vZQW1qn/yNzOw0E6Ca4fBBXea1RzornM32my87Uj486vYgdJMV663PwmA4VKcpdeLl
	 kdfIQ4KRZ7dIVnEGsZ5g8wDuddOpAoiQsu3dVMnA6dHn++qDkCpCpFk6EmLZdxYb7z
	 We2vk4cTEBi3MwjcCcZzQbDnvO6jftNZrP52XTNl9gFaVVLMOxeY+2StSisDdIwxyX
	 wl0mZ19nHaJNg==
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
Subject: [PATCH v2 0/6] Basic inline encryption support for ufs-exynos
Date: Tue,  2 Jul 2024 00:25:04 -0700
Message-ID: <20240702072510.248272-1-ebiggers@kernel.org>
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
 drivers/ufs/host/ufs-exynos.c    | 228 ++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h             |  28 ++++
 5 files changed, 308 insertions(+), 21 deletions(-)


base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
-- 
2.45.2


