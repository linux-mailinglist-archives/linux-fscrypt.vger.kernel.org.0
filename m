Return-Path: <linux-fscrypt+bounces-601-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E228EA2F9E1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 21:25:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91616168B1C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 20:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C4024E4BA;
	Mon, 10 Feb 2025 20:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQPJU1lV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E1225C71C;
	Mon, 10 Feb 2025 20:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219109; cv=none; b=lXfS8oQ79SwNVybzpjEshWD6kx9NYC8TDhOZRnhWyETwcKGM51Inqw+OFA+LfElzkH+p6wM+rwTH3e9ZKBkcS+SP3JmgMHISl5Sle/L+2WV7vs5tWc3ht1B7vjcUVNKql2Vr0sjEysOYlpBrGxaTvyOZBtnWhTuwaAKlnqpawHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219109; c=relaxed/simple;
	bh=vXhVwgAzJRsbMBb4ioYc4lrcIttn/6/nkZ/Jx0CS6GM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nXpzX3pCE/drXvega5vRcuxIK9N0AcPGmF9Fy0dwbYT41atyeez5gGcBSXD8STO9SlSWPBmvZoXeWk0IG2ZaA7z7AymXSqhy/XnQauJndYVH+Zpp73O6Q79u1Xatj58C/RdAQm2iGA4tCbEJSCd/nd4PfaN0LuaQcaRHGwt8hnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQPJU1lV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484BFC4CEE4;
	Mon, 10 Feb 2025 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739219108;
	bh=vXhVwgAzJRsbMBb4ioYc4lrcIttn/6/nkZ/Jx0CS6GM=;
	h=From:To:Cc:Subject:Date:From;
	b=BQPJU1lVvT59yLO19S+0VFvHodslE1bbsNTJRksP19srUIFw/MHoVBh89aQFJP/Nl
	 8NrhHpfkwSJegrDFik1Qi924INyer6fAq+VJLwou4Y4D0D219Bhvyme8kAX0wak5u9
	 6UZPicZqg+oORAPzkYPOP5BPHLKbhoW1Z1g5MzKP2dMwpPz/Olt9HsEd6maKB3hMdF
	 tEYcsOiEeX0venL7NxxwRUDWvOdnaBHiP8pH1pPqzoPYrzHunYZy4PFfoxu7Z6TFRp
	 3XpxT+lnV+DC1K9/IjuKH6M5RxI42O78sgfuSqlHNZv842dAoFtq/wx1KFEeyWjmTv
	 aHKh2ZYgsqgoA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v12 0/4] Driver and fscrypt support for HW-wrapped inline encryption keys
Date: Mon, 10 Feb 2025 12:23:32 -0800
Message-ID: <20250210202336.349924-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is based on linux-block/for-next and is also available at:

    git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v12

Now that the block layer support for hardware-wrapped inline encryption
keys has been applied for 6.15
(https://lore.kernel.org/r/173920649542.40307.8847368467858129326.b4-ty@kernel.dk),
this series refreshes the remaining patches.  They add the support for
hardware-wrapped inline encryption keys to the Qualcomm ICE and UFS
drivers and to fscrypt.  All tested on SM8650 with xfstests.

TBD whether these will land in 6.15 too, or wait until 6.16 when the
block patches that patches 2-4 depend on will have landed.

Changed in v12:
  - Rebased onto linux-block/for-next
  - Fixed endianness error in drivers/soc/qcom/ice.c
  - Added Acked-bys
  - Updated the fscrypt patch to go back to having just
    FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED (as in v8) instead of
    FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V0 and
    FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED_V1.  Upon further discussion it
    seemed the partial V0 compatibility was not going to be as helpful
    as I had hoped, so instead we'll just have the single new version
    that does things properly.  Note, I've updated my wip-wrapped-keys
    branch of fscryptctl accordingly.

Changed in v11:
  - Rebased onto v6.14-rc1.  Dropped the patches that were upstreamed in
    6.14, and put the block patches first in the series again.
  - Significantly cleaned up the patch "soc: qcom: ice: add HWKM support
    to the ICE driver".  Some of the notable changes were dropping the
    unnecessary support for HWKM v1, and replacing qcom_ice_using_hwkm()
    with qcom_ice_get_supported_key_type().
  - Consistently used and documented the EBADMSG error code for invalid
    hardware-wrapped keys.
  - Other minor cleanups.

Changed in v10:
  - Fixed bugs in qcom_scm_derive_sw_secret() and cqhci_crypto_init().
  - Added "ufs: qcom: fix crypto key eviction" and
    "mmc: sdhci-msm: fix crypto key eviction".
  - Split removing ufs_hba_variant_ops::program_key into its own patch.
  - Minor cleanups.
  - Added Tested-by.

Changed in v9 (relative to v7 patchset from Bartosz Golaszewski):
  - ufs-qcom and sdhci-msm now just initialize the blk_crypto_profile
    themselves, like what ufs-exynos was doing.  This avoids needing to
    add all the host-specific hooks for wrapped key support to the MMC
    and UFS core drivers.
  - When passing the blk_crypto_key further down the stack, it now
    replaces parameters like the algorithm ID, to avoid creating two
    sources of truth.
  - The module parameter qcom_ice.use_wrapped_keys should work correctly now.
  - The fscrypt support no longer uses a policy flag to indicate when a
    file is protected by a HW-wrapped key, since it was already implied
    by the file's key identifier being that of a HW-wrapped key.
    Originally there was an issue where raw and HW-wrapped keys could
    share key identifiers, but I had fixed that earlier by introducing a
    new HKDF context byte.
  - The term "standard keys" is no longer used.  Now "raw keys" is
    consistently used instead.  I've found that people find the term
    "raw keys" to be more intuitive.  Also HW-wrapped keys could in
    principle be standardized.
  - I've reordered the patchset to place preparatory patches that don't
    depend on the actual HW-wrapped key support first.

For older changelogs, see
https://lore.kernel.org/r/20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org and
https://lore.kernel.org/r/20231104211259.17448-1-ebiggers@kernel.org

Eric Biggers (3):
  soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
  ufs: qcom: add support for wrapped keys
  fscrypt: add support for hardware-wrapped keys

Gaurav Kashyap (1):
  soc: qcom: ice: add HWKM support to the ICE driver

 Documentation/filesystems/fscrypt.rst | 187 +++++++++++---
 drivers/mmc/host/sdhci-msm.c          |  16 +-
 drivers/soc/qcom/ice.c                | 350 ++++++++++++++++++++++++--
 drivers/ufs/host/ufs-qcom.c           |  57 ++++-
 fs/crypto/fscrypt_private.h           |  75 +++++-
 fs/crypto/hkdf.c                      |   4 +-
 fs/crypto/inline_crypt.c              |  44 +++-
 fs/crypto/keyring.c                   | 138 +++++++---
 fs/crypto/keysetup.c                  |  63 ++++-
 fs/crypto/keysetup_v1.c               |   4 +-
 include/soc/qcom/ice.h                |  34 ++-
 include/uapi/linux/fscrypt.h          |   6 +-
 12 files changed, 809 insertions(+), 169 deletions(-)


base-commit: 352245090aa60dbaa11b4f7da18f31caf42aeb82
-- 
2.48.1


