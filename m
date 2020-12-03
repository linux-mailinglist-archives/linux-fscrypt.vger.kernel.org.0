Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C062CCBFD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 03:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgLCCIo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 21:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgLCCIo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 21:08:44 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
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
Subject: [PATCH v2 0/9] eMMC inline encryption support
Date:   Wed,  2 Dec 2020 18:05:07 -0800
Message-Id: <20201203020516.225701-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
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
However, I don't have the hardware to do this yet.

This patchset is based on v5.10-rc6, and it can also be retrieved from
tag "mmc-crypto-v2" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

Changed since v1:
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
  arm64: dts: qcom: sdm630: add ICE registers and clocks
  mmc: sdhci-msm: add Inline Crypto Engine support

 .../devicetree/bindings/mmc/sdhci-msm.txt     |   3 +
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |  10 +-
 drivers/firmware/qcom_scm.c                   |  16 +-
 drivers/mmc/core/Kconfig                      |   8 +
 drivers/mmc/core/Makefile                     |   1 +
 drivers/mmc/core/block.c                      |   3 +
 drivers/mmc/core/core.c                       |   3 +
 drivers/mmc/core/crypto.c                     |  54 ++++
 drivers/mmc/core/crypto.h                     |  46 +++
 drivers/mmc/core/host.c                       |   2 +
 drivers/mmc/core/queue.c                      |   3 +
 drivers/mmc/host/Kconfig                      |   1 +
 drivers/mmc/host/Makefile                     |   2 +
 drivers/mmc/host/{cqhci.c => cqhci-core.c}    |  69 ++++-
 drivers/mmc/host/cqhci-crypto.c               | 245 ++++++++++++++++
 drivers/mmc/host/cqhci-crypto.h               |  47 ++++
 drivers/mmc/host/cqhci.h                      |  85 +++++-
 drivers/mmc/host/sdhci-msm.c                  | 265 +++++++++++++++++-
 include/linux/mmc/core.h                      |   6 +
 include/linux/mmc/host.h                      |   7 +
 20 files changed, 851 insertions(+), 25 deletions(-)
 create mode 100644 drivers/mmc/core/crypto.c
 create mode 100644 drivers/mmc/core/crypto.h
 rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (94%)
 create mode 100644 drivers/mmc/host/cqhci-crypto.c
 create mode 100644 drivers/mmc/host/cqhci-crypto.h

-- 
2.29.2

