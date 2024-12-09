Return-Path: <linux-fscrypt+bounces-532-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DEC9E8A91
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 05:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B4C51885282
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2024 04:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69482192B95;
	Mon,  9 Dec 2024 04:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJ8Z59pT"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2381922C0;
	Mon,  9 Dec 2024 04:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733720219; cv=none; b=l2RL2x6tCL531wBoZrucyigJCb5T91Wa1XffVPxQ7t+SGLsaetjMjdhT4MjyMaeNyG8Ch3E72SN0rXi7CK6l6azQ/qQJ5ze2TtxUACqGUZ7w9iGu/Yrjn2eqHzHcfXiiLUfA/b6NYdOfeOVfLItfWZC2Rne2+D3KDb/fBYCjBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733720219; c=relaxed/simple;
	bh=Q4qXw6u0QnVWnTLxcFvhi8tAx/uPHNBoJYh1c3lbTGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tp7Or7/LmH1WePvCaV3zdoCdjMq58rDljKExrooTARimbhV5MVRaNxg28AEaszgj9y3sd0sWtmcCb6CON6DpetWbqZwY9kfeR4X2f1jC3GOysEXRH6dlXD/LsrKussGN8IWz43DyOgvld6DUvNuG+HVUcZvYQ5iidNqBiP6GL9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJ8Z59pT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAD2C4CED1;
	Mon,  9 Dec 2024 04:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733720218;
	bh=Q4qXw6u0QnVWnTLxcFvhi8tAx/uPHNBoJYh1c3lbTGA=;
	h=From:To:Cc:Subject:Date:From;
	b=UJ8Z59pTP1FvU+F/ffL2U5GeXaTz2WS6b5mYydTseoix8Rs3scr0mpy2aqbDpDK4q
	 4Wiz9nnSeecyHGvvNI7HQCtAVY1B/nLMWpZKXb6zTQ92Qo+DmHeAKdhyStZKUAq2hF
	 5vgS1lHK3+pzBtQ7yagOw3I1zegoA5SuuuVJ3UHg5fEEGTP/v/YSoRmzBnzEgimE60
	 iV6ADyWoh/Q1OjLMvYIA7GJVKu/lek4MMlRnyAWxmgX9akXwmVmfhs1QpKtz9q2ZLF
	 uTra7No/X2l4WqMIi6HUZh/0YtBRFCyERBXKv2JqRSahCtVv2SQrRAwUJfzLa6WJ9z
	 lU2liyyLF4csg==
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
Subject: [PATCH v9 00/12] Support for hardware-wrapped inline encryption keys
Date: Sun,  8 Dec 2024 20:55:18 -0800
Message-ID: <20241209045530.507833-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is also available in git via:

    git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v9

This is a reworked version of the patchset
https://lore.kernel.org/linux-fscrypt/20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org/T/#u
that was recently sent by Bartosz Golaszewski.  It turned out there were a lot
of things I wanted to fix, and it would have taken much too long to address them
in a code review.  For now this is build-tested only; I've errored on the side
of sending this out early since others are working on this too.  Besides many
miscellaneous fixes and cleanups, I've made the following notable changes:

- ufs-qcom and sdhci-msm now just initialize the blk_crypto_profile themselves,
  like what ufs-exynos was doing.  This avoids needing to add all the
  host-specific hooks for wrapped key support to the MMC and UFS core drivers.

- When passing the blk_crypto_key further down the stack, it now replaces
  parameters like the algorithm ID, to avoid creating two sources of truth.

- The module parameter qcom_ice.use_wrapped_keys should work correctly now.

- The fscrypt support no longer uses a policy flag to indicate when a file is
  protected by a HW-wrapped key, since it was already implied by the file's key
  identifier being that of a HW-wrapped key.  Originally there was an issue
  where raw and HW-wrapped keys could share key identifiers, but I had fixed
  that earlier by introducing a new HKDF context byte.

- The term "standard keys" is no longer used.  Now "raw keys" is consistently
  used instead.  I've found that people find the term "raw keys" to be more
  intuitive.  Also HW-wrapped keys could in principle be standardized.

- I've reordered the patchset to place preparatory patches that don't depend on
  the actual HW-wrapped key support first.

My current thinking is that for 6.14 we should just aim to get the preparatory
patches 1-5 merged via the ufs and mmc trees, while the actual HW-wrapped key
support continues to be finalized and properly tested.  But let me know if
anyone has any other thoughts.

A quick intro to the patchset for anyone who hasn't been following along:

This patchset adds support for hardware-wrapped inline encryption keys, a
security feature supported by some SoCs and that has already seen a lot of
real-world use downstream.  It adds the block and fscrypt framework for the
feature as well as support for it with UFS on Qualcomm SoCs.

This feature is described in full detail in the included Documentation changes.
But to summarize, hardware-wrapped keys are inline encryption keys that are
wrapped (encrypted) by a key internal to the hardware so that they can only be
unwrapped (decrypted) by the hardware.  Initially keys are wrapped with a
permanent hardware key, but during actual use they are re-wrapped with a
per-boot ephemeral key for improved security.  The hardware supports importing
keys as well as generating keys itself.

This differs from the existing support for hardware-wrapped keys in the kernel
crypto API (which also goes by names such as "hardware-bound keys", depending on
the driver) in the same way that the crypto API differs from blk-crypto: the
crypto API is for general crypto operations, whereas blk-crypto is for inline
storage encryption.

This feature is already being used by Android downstream for several years
(https://source.android.com/docs/security/features/encryption/hw-wrapped-keys),
but on other platforms userspace support will be provided via fscryptctl and
tests via xfstests (I have some old patches for this that need to be updated).

Eric Biggers (10):
  ufs: crypto: add ufs_hba_from_crypto_profile()
  ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
  mmc: crypto: add mmc_from_crypto_profile()
  mmc: sdhci-msm: convert to use custom crypto profile
  soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
  blk-crypto: add basic hardware-wrapped key support
  blk-crypto: show supported key types in sysfs
  blk-crypto: add ioctls to create and prepare hardware-wrapped keys
  fscrypt: add support for hardware-wrapped keys
  ufs: qcom: add support for wrapped keys

Gaurav Kashyap (2):
  firmware: qcom: scm: add calls for wrapped key support
  soc: qcom: ice: add HWKM support to the ICE driver

 Documentation/ABI/stable/sysfs-block          |  18 +
 Documentation/block/inline-encryption.rst     | 251 +++++++++++-
 Documentation/filesystems/fscrypt.rst         | 201 +++++++--
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 block/blk-crypto-fallback.c                   |   7 +-
 block/blk-crypto-internal.h                   |  10 +
 block/blk-crypto-profile.c                    | 103 +++++
 block/blk-crypto-sysfs.c                      |  35 ++
 block/blk-crypto.c                            | 196 ++++++++-
 block/ioctl.c                                 |   5 +
 drivers/firmware/qcom/qcom_scm.c              | 214 ++++++++++
 drivers/firmware/qcom/qcom_scm.h              |   4 +
 drivers/md/dm-table.c                         |   1 +
 drivers/mmc/host/cqhci-crypto.c               |  38 +-
 drivers/mmc/host/cqhci.h                      |   8 +-
 drivers/mmc/host/sdhci-msm.c                  | 102 +++--
 drivers/soc/qcom/ice.c                        | 383 +++++++++++++++++-
 drivers/ufs/core/ufshcd-crypto.c              |  33 +-
 drivers/ufs/host/ufs-exynos.c                 |   3 +-
 drivers/ufs/host/ufs-qcom.c                   | 137 +++++--
 fs/crypto/fscrypt_private.h                   |  75 +++-
 fs/crypto/hkdf.c                              |   4 +-
 fs/crypto/inline_crypt.c                      |  42 +-
 fs/crypto/keyring.c                           | 157 +++++--
 fs/crypto/keysetup.c                          |  63 ++-
 fs/crypto/keysetup_v1.c                       |   4 +-
 include/linux/blk-crypto-profile.h            |  73 ++++
 include/linux/blk-crypto.h                    |  73 +++-
 include/linux/firmware/qcom/qcom_scm.h        |   8 +
 include/linux/mmc/host.h                      |   8 +
 include/soc/qcom/ice.h                        |  34 +-
 include/uapi/linux/blk-crypto.h               |  44 ++
 include/uapi/linux/fs.h                       |   6 +-
 include/uapi/linux/fscrypt.h                  |   7 +-
 include/ufs/ufshcd.h                          |  11 +-
 35 files changed, 2091 insertions(+), 269 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: f486c8aa16b8172f63bddc70116a0c897a7f3f02
-- 
2.47.1


