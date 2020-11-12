Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22032B0E3F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Nov 2020 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgKLTlP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Nov 2020 14:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKLTlP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Nov 2020 14:41:15 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2C2D20B80;
        Thu, 12 Nov 2020 19:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605210073;
        bh=POxMZUS5T48EAV5DntjG45pUfxQjt3f8urXPN27veH8=;
        h=From:To:Cc:Subject:Date:From;
        b=hgclmwFLQHe5wnHu5hYDNsm5HC87eCB2WdU3TWgRmzqfTJdxfcC0eWV3zq21eGp6S
         DSDiMY5CK1uh0gsRqxn1Se+eT2x7BDlt2Py2hXN4aD2f61ac1vKFXVDPMVm1JSDBNi
         +MSDib+/s3hKjI8uf4c78Sb6uayIvSMf09IWkv4g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH 0/8] eMMC inline encryption support
Date:   Thu, 12 Nov 2020 11:40:03 -0800
Message-Id: <20201112194011.103774-1-ebiggers@kernel.org>
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

Patches 1-3 add support for the standard eMMC inline encryption.

However, as with UFS, host controller-specific patches are needed on top
of the standard support.  Therefore, patches 4-8 add Qualcomm ICE
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
I.e., patches 1-3 should be almost enough for the Mediatek hardware.
However, I don't have the hardware to do this yet.

This patchset is based on v5.10-rc3, and it can also be retrieved from
tag "mmc-crypto-v1" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

Note: the fscrypt inline encryption support is partially broken in
v5.10-rc3, so for testing a fscrypt fix needs to be applied too:
https://lkml.kernel.org/r/20201111015224.303073-1-ebiggers@kernel.org

Eric Biggers (8):
  mmc: add basic support for inline encryption
  mmc: cqhci: rename cqhci.c to cqhci-core.c
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
 drivers/mmc/host/{cqhci.c => cqhci-core.c}    |  66 ++++-
 drivers/mmc/host/cqhci-crypto.c               | 237 +++++++++++++++
 drivers/mmc/host/cqhci-crypto.h               |  47 +++
 drivers/mmc/host/cqhci.h                      |  85 +++++-
 drivers/mmc/host/sdhci-msm.c                  | 270 +++++++++++++++++-
 include/linux/mmc/core.h                      |   6 +
 include/linux/mmc/host.h                      |   7 +
 20 files changed, 845 insertions(+), 25 deletions(-)
 create mode 100644 drivers/mmc/core/crypto.c
 create mode 100644 drivers/mmc/core/crypto.h
 rename drivers/mmc/host/{cqhci.c => cqhci-core.c} (94%)
 create mode 100644 drivers/mmc/host/cqhci-crypto.c
 create mode 100644 drivers/mmc/host/cqhci-crypto.h


base-commit: f8394f232b1eab649ce2df5c5f15b0e528c92091
-- 
2.29.2

