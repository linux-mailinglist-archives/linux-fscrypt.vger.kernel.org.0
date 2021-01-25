Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B723031DE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jan 2021 03:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbhAYSl0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jan 2021 13:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbhAYSlK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jan 2021 13:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A1982063A;
        Mon, 25 Jan 2021 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611600029;
        bh=hh8b0e0c4loqqFoN+PWjxQCkQrYyCAkBlcpa1rAA1QY=;
        h=From:To:Cc:Subject:Date:From;
        b=Ub0exa77R2jvKdBW5JYmLGIwsruOb6XnIBAGZI3kLwdsJDHdapC0WwaKzxa4VLrFi
         VODw8ehplEKjqNmtk2QX5JWk7w1of6OK3NwNZMiq3XvVx+LoSoOp8/vMnxrryNLQQE
         CAT5OjuoY+GM+w0drYE58ffed0soxL+PJwroi5T0vtnruugKY+zpLeII/ZcZ2oDs63
         N0l6JWjbtYVXA2Tat+LE4Mcf3lUPSJN7hu1jODKxsM6rcH/DRTGBdA5o004xfn0pzA
         a6P/nxQQ4Xs0NYtnO4UxspybKIeKlwrZoeROp1WrGfqu3ymIrD62sIbbbDz/G6HZW/
         BKoB2TAixQcsQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH v6 0/9] eMMC inline encryption support
Date:   Mon, 25 Jan 2021 10:38:01 -0800
Message-Id: <20210125183810.198008-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset adds support for eMMC inline encryption, as specified by
the upcoming version of the eMMC specification and as already
implemented and used on many devices.  Building on that, it then adds
Qualcomm ICE support and wires it up for the Snapdragon 630 SoC.

Inline encryption hardware improves the performance of storage
encryption and reduces power usage.  See
Documentation/block/inline-encryption.rst for more information about
inline encryption and the blk-crypto framework (upstreamed in v5.8)
which supports it.  Most mobile devices already use UFS or eMMC inline
encryption hardware; UFS support was already upstreamed in v5.9.

Patches 1-4 add support for the standard eMMC inline encryption.

However, as with UFS, host controller-specific patches are needed on top
of the standard support.  Therefore, patches 5-9 add Qualcomm ICE
(Inline Crypto Engine) support and wire it up on the Snapdragon 630 SoC.

To test this I took advantage of the recently upstreamed support for the
Snapdragon 630 SoC, plus work-in-progress patches from the SoMainline
project (https://github.com/SoMainline/linux/tree/konrad/v5.10-rc3).  In
particular, I was able to run the fscrypt xfstests for ext4 and f2fs in
a Debian chroot.  Among other things, these tests verified that the
correct ciphertext is written to disk (the same as software encryption).

It will also be possible to add support for Mediatek eMMC inline
encryption hardware in mtk-sd, and it should be easier than the Qualcomm
hardware since the Mediatek hardware follows the standard more closely.
I.e., patches 1-4 should be almost enough for the Mediatek hardware.

This patchset is based on the "next" branch of
https://git.kernel.org/pub/scm/linux/kernel/git/ulfh/mmc.git,
plus the patch "block/keyslot-manager: introduce devm_blk_ksm_init()"
(https://lkml.kernel.org/r/20210121082155.111333-2-ebiggers@kernel.org).
It can also be retrieved from tag "mmc-crypto-v6" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

Changed in v6:
  - Define MMC_CAP2_CRYPTO to 0 when !CONFIG_MMC_CRYPTO.
  - Moved the sdm630 device tree update to the end of the series,
    since it will go in through a different tree.
  - Added an Acked-by.

Changed in v5:
  - Use the proposed resource-managed variant of blk_ksm_init().
  - Removed an unnecessary call to devm_kfree().

Changed in v4:
  - Added Acked-by and Reviewed-and-tested-by tags.
  - Rebased onto v5.11-rc2.

Changed in v3:
  - Improved comment for sdhci_msm_ice_wait_bist_status()
  - Removed an unhelpful comment in union cqhci_crypto_cfg_entry.
  - Fixed the commit message of "mmc: cqhci: initialize upper 64 bits of
    128-bit task descriptors".
  - Added Reviewed-by's and Acked-by's.

Changed in v2:
  - Only select QCOM_SCM if ARCH_QCOM.  (Fixes a build break.)
  - Split most of the cqhci_prep_task_desc() change into its own patch.
  - Made sdhci_msm_ice_wait_bist_status() use readl_poll_timeout().
  - Added a couple more comments.
  - Added some Acked-by's.

Eric Biggers (9):
  mmc: add basic support for inline encryption
  mmc: cqhci: rename cqhci.c to cqhci-core.c
  mmc: cqhci: initialize upper 64 bits of 128-bit task descriptors
  mmc: cqhci: add support for inline encryption
  mmc: cqhci: add cqhci_host_ops::program_key
  firmware: qcom_scm: update comment for ICE-related functions
  dt-bindings: mmc: sdhci-msm: add ICE registers and clock
  mmc: sdhci-msm: add Inline Crypto Engine support
  arm64: dts: qcom: sdm630: add ICE registers and clocks

 .../devicetree/bindings/mmc/sdhci-msm.txt     |   3 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |  10 +-
 drivers/firmware/qcom_scm.c                   |  16 +-
 drivers/mmc/core/Kconfig                      |   8 +
 drivers/mmc/core/Makefile                     |   1 +
 drivers/mmc/core/block.c                      |   3 +
 drivers/mmc/core/core.c                       |   3 +
 drivers/mmc/core/crypto.c                     |  48 +++
 drivers/mmc/core/crypto.h                     |  40 +++
 drivers/mmc/core/host.c                       |   1 +
 drivers/mmc/core/queue.c                      |   3 +
 drivers/mmc/host/Kconfig                      |   1 +
 drivers/mmc/host/Makefile                     |   2 +
 drivers/mmc/host/{cqhci.c => cqhci-core.c}    |  69 ++++-
 drivers/mmc/host/cqhci-crypto.c               | 242 +++++++++++++++
 drivers/mmc/host/cqhci-crypto.h               |  47 +++
 drivers/mmc/host/cqhci.h                      |  84 +++++-
 drivers/mmc/host/sdhci-msm.c                  | 276 +++++++++++++++++-
 include/linux/mmc/core.h                      |   6 +
 include/linux/mmc/host.h                      |  11 +
 20 files changed, 849 insertions(+), 25 deletions(-)
 create mode 100644 drivers/mmc/core/crypto.c
 create mode 100644 drivers/mmc/core/crypto.h
 rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (94%)
 create mode 100644 drivers/mmc/host/cqhci-crypto.c
 create mode 100644 drivers/mmc/host/cqhci-crypto.h

-- 
2.30.0

