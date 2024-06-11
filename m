Return-Path: <linux-fscrypt+bounces-308-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07C5F9046FF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Jun 2024 00:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 830B9B22E6E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2024 22:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69FB915534E;
	Tue, 11 Jun 2024 22:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t/d8c8k6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DE15278E;
	Tue, 11 Jun 2024 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718145340; cv=none; b=DQuyWTPBuelVYvVbzidRX7Q7v+IDBka1GnpF1gbhojy2hnMJid5j7S651LVFcx2QHnwO02INafi+wBheM5YsgNfx5UTS5jFLRHDoLLKhniegETfFRg59qBXtPZK3hzcngP0VqHYV6f6ItOdUJyJMuzwxBgQl0sVeEtVkF5A3DcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718145340; c=relaxed/simple;
	bh=jhcGhk+DePzUr0NbvedFL8JRSaN6fflfQ2K8RF5QEsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OQDWlHfNiEIgbCQbdxdfM0nQp359L9MZf7ACOdfijLP9PaVfTuKp7mlSlHHd0jrkwkh+oaUZHkyQJKJohwSeuKjIBa1dL+FRttAB+YktByyKp3P/zG6XRj4WkKJUQQKljBBNAjluGOhcT8ZQoKGzCeHmIqWP3MoZY5r2ulmpkIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t/d8c8k6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82945C2BD10;
	Tue, 11 Jun 2024 22:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718145339;
	bh=jhcGhk+DePzUr0NbvedFL8JRSaN6fflfQ2K8RF5QEsw=;
	h=From:To:Cc:Subject:Date:From;
	b=t/d8c8k65PYEPcIh+M5+dUSxjH9aPVVREZz77zRaU6G/y4f48kz6PAukDifkZ0/FR
	 DXLn3Wo7jdmcnR1AbPJ1aJ4/tOyBttz7GWJA8wXPbYP8sLpzb4rH7eTwWViQjaPGQM
	 P8Z6QD/1OOoBPmcEM1Btn9Iz7H/nh1hGAIsiip39dd4IlIkg/6EoQ8jwDoxZqouBcI
	 tI9cTtdcNTkvUg954aNaWSKoSUs43yU4+sUUHl3u4foghs3KS7z7ZdxzBK0s78ojlD
	 rQ6aviADyWbfJgBjpk3YihEnMS1mGn2hY67LMIcBk1PKSqZgM/AXOnvQyEhP7Oapgo
	 dszFQpHQ9d0Og==
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
Subject: [PATCH 0/6] Basic inline encryption support for ufs-exynos
Date: Tue, 11 Jun 2024 15:34:13 -0700
Message-ID: <20240611223419.239466-1-ebiggers@kernel.org>
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

This patchset applies to v6.10-rc3, and it has no prerequisites that
aren't already upstream.

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
 drivers/ufs/host/ufs-exynos.c    | 219 ++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h             |  28 ++++
 5 files changed, 304 insertions(+), 16 deletions(-)


base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
-- 
2.45.2


