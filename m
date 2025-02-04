Return-Path: <linux-fscrypt+bounces-586-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAB6A26BB3
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 07:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C018F3A3731
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 06:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB301FF7AD;
	Tue,  4 Feb 2025 06:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbqM4/jf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0120F25A655;
	Tue,  4 Feb 2025 06:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738649002; cv=none; b=XvLxBMucFz4L5kUlhp8nEG8GFsmBQ3XRRnFoCTO9SqKtXA/OQUAKmO91Uv0TyoMzuKUFTrlAb2EDehMMatjUFyDTl39KtjLUo5EWwzhMWpPXn78vfYOUHo54Acv7GOBCJnTios43E3bPuwQ+DIRBpMdeog6PDwDX5Rh7WwTVChU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738649002; c=relaxed/simple;
	bh=8mFduILeD8XBrdhkNeuzpSJovgcKN2zlq+Lc0COwgOM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nWGyRC0mYbGOMe+QcabHucYkvs91NUrE3KNXhEfy+JydDs0la1yNGKSW6t1QO3IVixYqgOqn5zRLeCQikgX8DLMdUKB/MMbEJdznKWbh8xOurdUwC/QxPtyZdFUD21hzV8eFlkpYfnLenhWy0vbZw15Xk77TrW+PABS04Cvs2gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbqM4/jf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CC7C4CEDF;
	Tue,  4 Feb 2025 06:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738649000;
	bh=8mFduILeD8XBrdhkNeuzpSJovgcKN2zlq+Lc0COwgOM=;
	h=From:To:Cc:Subject:Date:From;
	b=PbqM4/jfSOcUlHnH9Hae6gjl1HWx7TppDrsjtgdnDS6ZyQWt5T6lxZNlHrV+3KRLc
	 m7gVtlknYz2U99bvp/nklrVX+ojPmxiCr1nmxqsFDPUptxRfK+RHqz8x0svdCXBurm
	 oPnl02Vinc9uctAT1Lasu6AeuS1Z+IhE213KpH8GoIMAiftQTWe0zS1z5bXF70KsbD
	 S8ZC6DrcG4CDh43Kwndamza8TbNRRMK2VOEL/S9tPXROosHjQOlcRmtR1p32elhrU7
	 yMsOeQJ1rz0uMzf7ZnyGNMW/+XTJso2W9eEfQlthwKacsBYPrH7eHp/nF/7BRVyAug
	 nxMNRnPgSsdJw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH v11 0/7] Support for hardware-wrapped inline encryption keys
Date: Mon,  3 Feb 2025 22:00:34 -0800
Message-ID: <20250204060041.409950-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is based on v6.14-rc1 and is also available at:

    git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v11

This patchset adds support for hardware-wrapped inline encryption keys,
a security feature supported by some SoCs.  It adds the block and
fscrypt framework for the feature as well as support for it with UFS on
Qualcomm SoCs.

This feature is described in full detail in the included Documentation
changes.  But to summarize, hardware-wrapped keys are inline encryption
keys that are wrapped (encrypted) by a key internal to the hardware so
that they can only be unwrapped (decrypted) by the hardware.  Initially
keys are wrapped with a permanent hardware key, but during actual use
they are re-wrapped with a per-boot ephemeral key for improved security.
The hardware supports importing keys as well as generating keys itself.

This differs from the existing support for hardware-wrapped keys in the
kernel crypto API (also called "hardware-bound keys" in some places) in
the same way that the crypto API differs from blk-crypto: the crypto API
is for general crypto operations, whereas blk-crypto is for inline
storage encryption.

This feature is already being used by Android downstream for several
years
(https://source.android.com/docs/security/features/encryption/hw-wrapped-keys),
but on other platforms userspace support will be provided via fscryptctl
and tests via xfstests.  The tests have been merged into xfstests, and
they pass on the SM8650 HDK with the upstream kernel plus this patchset.

This is targeting 6.15.  As per the suggestion from Jens
(https://lore.kernel.org/linux-block/c3407d1c-6c5c-42ee-b446-ccbab1643a62@kernel.dk/),
I'd like patches 1-3 to be queued up into a branch that gets pulled into
the block tree.  I'll then take patches 4-7 through the fscrypt tree,
also for 6.15.  If I end up with too many merge conflicts by trying to
take patches 5-7 (given that this is a cross-subsystem feature), my
fallback plan will be to wait until 6.16 to land patches 5-7, when they
will finally be unblocked by the block patches having landed.

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

Eric Biggers (6):
  blk-crypto: add basic hardware-wrapped key support
  blk-crypto: show supported key types in sysfs
  blk-crypto: add ioctls to create and prepare hardware-wrapped keys
  fscrypt: add support for hardware-wrapped keys
  soc: qcom: ice: make qcom_ice_program_key() take struct blk_crypto_key
  ufs: qcom: add support for wrapped keys

Gaurav Kashyap (1):
  soc: qcom: ice: add HWKM support to the ICE driver

 Documentation/ABI/stable/sysfs-block          |  20 +
 Documentation/block/inline-encryption.rst     | 255 ++++++++++++-
 Documentation/filesystems/fscrypt.rst         | 200 ++++++++--
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 block/blk-crypto-fallback.c                   |   7 +-
 block/blk-crypto-internal.h                   |  10 +
 block/blk-crypto-profile.c                    | 101 +++++
 block/blk-crypto-sysfs.c                      |  35 ++
 block/blk-crypto.c                            | 204 +++++++++-
 block/ioctl.c                                 |   5 +
 drivers/md/dm-table.c                         |   1 +
 drivers/mmc/host/cqhci-crypto.c               |   8 +-
 drivers/mmc/host/sdhci-msm.c                  |  17 +-
 drivers/soc/qcom/ice.c                        | 349 ++++++++++++++++--
 drivers/ufs/core/ufshcd-crypto.c              |   7 +-
 drivers/ufs/host/ufs-exynos.c                 |   3 +-
 drivers/ufs/host/ufs-qcom.c                   |  56 ++-
 fs/crypto/fscrypt_private.h                   |  75 +++-
 fs/crypto/hkdf.c                              |   4 +-
 fs/crypto/inline_crypt.c                      |  42 ++-
 fs/crypto/keyring.c                           | 157 ++++++--
 fs/crypto/keysetup.c                          |  63 +++-
 fs/crypto/keysetup_v1.c                       |   4 +-
 include/linux/blk-crypto-profile.h            |  73 ++++
 include/linux/blk-crypto.h                    |  73 +++-
 include/soc/qcom/ice.h                        |  34 +-
 include/uapi/linux/blk-crypto.h               |  44 +++
 include/uapi/linux/fs.h                       |   6 +-
 include/uapi/linux/fscrypt.h                  |   7 +-
 29 files changed, 1654 insertions(+), 208 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1


