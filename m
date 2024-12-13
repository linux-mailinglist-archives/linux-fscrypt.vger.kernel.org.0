Return-Path: <linux-fscrypt+bounces-552-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75ACE9F0377
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D306188B377
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC6D15442D;
	Fri, 13 Dec 2024 04:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5pQ0l6L"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB3853804;
	Fri, 13 Dec 2024 04:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063621; cv=none; b=f336IvhGHRvFzLq86bJeSsLrpqnCScJWac2YIRAMt+aeaxHTkolhksL276L5Baj2H6sqcyTb6yVr5CU1uL9+zOuMXCHSXe70mpg+FF+g7wpI0MnPZtrErn0BfFT+pTBVN5uTRl6Rq9fuPsDZX3odHsbN9W1eF9uWiVyNOqzxAFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063621; c=relaxed/simple;
	bh=vALIOL9+d8VQ7Yzr+SZm3s62VffHG/aGVC+9grri8xE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cf/ry/BdKbv9PYnSaHThPM1OFVIu5zyZCEtidK5X1aQabffRCr1Y/6eMJc542PaxkQ8XVH+AhQ83DfBWg3R/Gpci5VCXOqmrpH31knCk188GosgAdmcrNdizXqA+NimrKcnyjl0IqLHyrAJ+JQLnvrleDggE08wUHiAL4Vhlbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5pQ0l6L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAAEC4CED7;
	Fri, 13 Dec 2024 04:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063621;
	bh=vALIOL9+d8VQ7Yzr+SZm3s62VffHG/aGVC+9grri8xE=;
	h=From:To:Cc:Subject:Date:From;
	b=O5pQ0l6L2ia4t2QI8U5q2UrgUQbBqzcETBpy+tZi4zR04I33dmURRdh5haOFdC4G8
	 vazLUON7miszGMklmCW0TXXfG8ZqiQFKmPbUBTS8gSmFqhYfxe378CQUR4wcJQ/5Ia
	 mo10A2a7DdqJxfl61Vcm8dXBMcsE/EkH1/TnJe/BKN8jcRaOpu2d3rGMLIC0JliMdu
	 YRGTDeDrDeq1qrBJ+h+gx4FT1+h6VYpP43YV/fzQFDrFsmL4DY8HRHr6l/b5em+FP/
	 QgD77wG00KIvoMk0p6zweSnCTnKhWpYOIEQZJU+DtlqangJQHHPX8YIDXBkiTATIf0
	 bnN9F+bZznOlw==
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
Subject: [PATCH v10 00/15] Support for hardware-wrapped inline encryption keys
Date: Thu, 12 Dec 2024 20:19:43 -0800
Message-ID: <20241213041958.202565-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is based on next-20241212 and is also available in git via:

    git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v10

This patchset adds support for hardware-wrapped inline encryption keys, a
security feature supported by some SoCs.  It adds the block and fscrypt
framework for the feature as well as support for it with UFS on Qualcomm SoCs.

This feature is described in full detail in the included Documentation changes.
But to summarize, hardware-wrapped keys are inline encryption keys that are
wrapped (encrypted) by a key internal to the hardware so that they can only be
unwrapped (decrypted) by the hardware.  Initially keys are wrapped with a
permanent hardware key, but during actual use they are re-wrapped with a
per-boot ephemeral key for improved security.  The hardware supports importing
keys as well as generating keys itself.

This differs from the existing support for hardware-wrapped keys in the kernel
crypto API (also called "hardware-bound keys" in some places) in the same way
that the crypto API differs from blk-crypto: the crypto API is for general
crypto operations, whereas blk-crypto is for inline storage encryption.

This feature is already being used by Android downstream for several years
(https://source.android.com/docs/security/features/encryption/hw-wrapped-keys),
but on other platforms userspace support will be provided via fscryptctl and
tests via xfstests (I have some old patches for this that need to be updated).

Maintainers, please consider merging the following preparatory patches for 6.14:

  - UFS / SCSI tree: patches 1-4
  - MMC tree: patches 5-7
  - Qualcomm / MSM tree: patch 8

Changed in v10:
  - Fixed bugs in qcom_scm_derive_sw_secret() and cqhci_crypto_init().
  - Added "ufs: qcom: fix crypto key eviction" and
    "mmc: sdhci-msm: fix crypto key eviction".
  - Split removing ufs_hba_variant_ops::program_key into its own patch.
  - Minor cleanups.
  - Added Tested-by.

Changed in v9 (relative to v7 patchset from Bartosz Golaszewski):
  - ufs-qcom and sdhci-msm now just initialize the blk_crypto_profile
    themselves, like what ufs-exynos was doing.  This avoids needing to add all
    the host-specific hooks for wrapped key support to the MMC and UFS core
    drivers.
  - When passing the blk_crypto_key further down the stack, it now replaces
    parameters like the algorithm ID, to avoid creating two sources of truth.
  - The module parameter qcom_ice.use_wrapped_keys should work correctly now.
  - The fscrypt support no longer uses a policy flag to indicate when a file is
    protected by a HW-wrapped key, since it was already implied by the file's
    key identifier being that of a HW-wrapped key.  Originally there was an
    issue where raw and HW-wrapped keys could share key identifiers, but I had
    fixed that earlier by introducing a new HKDF context byte.
  - The term "standard keys" is no longer used.  Now "raw keys" is consistently
    used instead.  I've found that people find the term "raw keys" to be more
    intuitive.  Also HW-wrapped keys could in principle be standardized.
  - I've reordered the patchset to place preparatory patches that don't depend
    on the actual HW-wrapped key support first.

For older changelogs, see
https://lore.kernel.org/r/20241202-wrapped-keys-v7-0-67c3ca3f3282@linaro.org and
https://lore.kernel.org/r/20231104211259.17448-1-ebiggers@kernel.org

Eric Biggers (13):
  ufs: qcom: fix crypto key eviction
  ufs: crypto: add ufs_hba_from_crypto_profile()
  ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
  ufs: crypto: remove ufs_hba_variant_ops::program_key
  mmc: sdhci-msm: fix crypto key eviction
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
 drivers/mmc/host/cqhci-crypto.c               |  46 +--
 drivers/mmc/host/cqhci.h                      |   8 +-
 drivers/mmc/host/sdhci-msm.c                  | 101 +++--
 drivers/soc/qcom/ice.c                        | 383 +++++++++++++++++-
 drivers/ufs/core/ufshcd-crypto.c              |  33 +-
 drivers/ufs/host/ufs-exynos.c                 |   3 +-
 drivers/ufs/host/ufs-qcom.c                   | 136 +++++--
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
 35 files changed, 2092 insertions(+), 274 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: 3e42dc9229c5950e84b1ed705f94ed75ed208228
-- 
2.47.1


