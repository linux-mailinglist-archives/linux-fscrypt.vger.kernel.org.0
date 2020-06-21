Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6985D202BCA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Jun 2020 19:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730477AbgFURk7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 21 Jun 2020 13:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgFURk7 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 21 Jun 2020 13:40:59 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E01221F7;
        Sun, 21 Jun 2020 17:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592761258;
        bh=2WuP/skh00do2CBELmgP2BjUhfAXpwflm1XOnaq3gAc=;
        h=From:To:Cc:Subject:Date:From;
        b=ubwGYsHIoVgXlaRyoXcBBBLDHoHhq+XMSw6IxSxBbVfdgjC6ylw1+ID9Kw+JLG57F
         5TRg/HoZebRmd7n5WGtAcoV/oHPJmCLoW8HIEzVHVtraklWcV6Pd5n0NddcClJHPPq
         JBY8KSOHN2nuQr46R9jKMYxSftcL3BzB1fp12HYU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v5 0/5] Inline crypto support on DragonBoard 845c
Date:   Sun, 21 Jun 2020 10:37:08 -0700
Message-Id: <20200621173713.132879-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset implements UFS inline encryption support on the
DragonBoard 845c, using the Qualcomm Inline Crypto Engine (ICE)
that's present on the Snapdragon 845 SoC.

This is based on top of the patchset
"[PATCH v2 0/3] Inline Encryption support for UFS" by Satya Tangirala.
Link: https://lkml.kernel.org/r/20200618024736.97207-1-satyat@google.com

Most of the logic needed to use ICE is already handled by the blk-crypto
framework (introduced in v5.8-rc1) and by ufshcd-crypto
(the above patchset).  This new patchset just adds the vendor-specific
parts.  I also only implemented support for version 3 of the ICE
hardware, which seems to be easier to use than older versions.

Due to these factors and others, I was able to greatly simplify the
driver from the vendor's original.  It works fine in testing with
fscrypt and with a blk-crypto self-test I'm also working on.

This driver also works on several other Snapdragon SoCs.
See the commit messages for details.

This patchset is also available in git at:
    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
    Tag: db845c-crypto-v5

Changed v4 => v5:
    - Rebased onto v5.8-rc1 + the latest ufshcd-crypto patchset.
    - Refer to the ICE registers by name rather than by index.
    - Added Tested-by and Acked-by tags.

Changed v3 => v4:
    - Rebased onto the v12 inline encryption patchset.
    - A couple small cleanups.

Changed v2 => v3:
    - Rebased onto the v8 inline encryption patchset.  Now the driver
      has to opt into inline crypto support rather than opting out.
    - Switched qcom_scm_ice_set_key() to use dma_alloc_coherent()
      so that we can reliably zeroing the key without assuming that
      bounce buffers aren't used.  Also added a comment.
    - Made the key_size and data_unit_size arguments to
      qcom_scm_ice_set_key() be 'u32' instead of 'int'.

Changed v1 => v2:
    - Rebased onto the v7 inline encryption patchset.
    - Account for all the recent qcom_scm changes.
    - Don't ignore errors from ->program_key().
    - Don't dereference NULL hba->vops.
    - Dropped the patch that added UFSHCD_QUIRK_BROKEN_CRYPTO, as this
      flag is now included in the main inline encryption patchset.
    - Many other cleanups.

Eric Biggers (5):
  firmware: qcom_scm: Add support for programming inline crypto keys
  scsi: ufs-qcom: name the dev_ref_clk_ctrl registers
  arm64: dts: sdm845: add Inline Crypto Engine registers and clock
  scsi: ufs: add program_key() variant op
  scsi: ufs-qcom: add Inline Crypto Engine support

 MAINTAINERS                          |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi |  13 +-
 drivers/firmware/qcom_scm.c          | 101 +++++++++++
 drivers/firmware/qcom_scm.h          |   4 +
 drivers/scsi/ufs/Kconfig             |   1 +
 drivers/scsi/ufs/Makefile            |   4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c      | 245 +++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.c          |  15 +-
 drivers/scsi/ufs/ufs-qcom.h          |  27 +++
 drivers/scsi/ufs/ufshcd-crypto.c     |  27 +--
 drivers/scsi/ufs/ufshcd.h            |   3 +
 include/linux/qcom_scm.h             |  19 +++
 12 files changed, 443 insertions(+), 18 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c

-- 
2.27.0

