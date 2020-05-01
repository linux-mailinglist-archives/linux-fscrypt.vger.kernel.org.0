Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4F51C0D85
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 May 2020 06:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgEAEwK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 1 May 2020 00:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727922AbgEAEwJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 1 May 2020 00:52:09 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D57EA2073E;
        Fri,  1 May 2020 04:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588308729;
        bh=fwTbx3jF7Z0eOL7Ky1F644zwZxDT3uqvpQUjubd7yQo=;
        h=From:To:Cc:Subject:Date:From;
        b=yzqKeFWGfOvplqDishgMV5MSwR1HBWShRbBe36MDhjXPJINmxH6Vn8o4UYAoLsnBc
         RYZywE4vH5gr4ax7Fm/Unf6cYbPFuex4DJm4QIBlETVvgf0Hlh04vESD/oOnVtTfmY
         onfhZ2iSFlayZ2ZfK3uQkATFrdNInA95BCqmqx8A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH v4 0/4] Inline crypto support on DragonBoard 845c
Date:   Thu, 30 Apr 2020 21:51:07 -0700
Message-Id: <20200501045111.665881-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset implements UFS inline crypto support on the DragonBoard
845c, using the Qualcomm Inline Crypto Engine (ICE) that's present on
the Snapdragon 845 SoC.

This is based on top of the patchset "[PATCH v12 00/11] Inline Encryption
Support" by Satya Tangirala, which adds support for the UFS standard
inline crypto, the block layer changes needed to use inline crypto, and
support for inline crypto in fscrypt (ext4 and f2fs encryption).  Link:
https://lkml.kernel.org/r/20200430115959.238073-1-satyat@google.com

This new patchset is mostly a RFC showing hardware inline crypto working
on a publicly available development board that runs the mainline Linux
kernel.  While patches 1-2 could be applied now, patches 3-4 depend on
the main "Inline Encryption Support" patchset being merged first.

Most of the logic needed to use ICE is already handled by ufshcd-crypto
and the blk-crypto framework, which are introduced by the "Inline
Encryption Support" patchset.  Therefore, this new patchset just adds
the vendor-specific parts.  I also only implemented support for version
3 of the ICE hardware, which seems to be easier to use than older
versions.

Due to these factors and others, I was able to greatly simplify the
driver from the vendor's original.  It works fine in testing with
fscrypt and with a blk-crypto self-test I'm also working on.

This driver also works nearly as-is on Snapdragon 765 and Snapdragon
865, which are very recent SoCs, having just been announced in Dec 2019
(though these newer SoCs currently lack upstream kernel support).

This patchset is also available in git at:
    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
    Tag: db845c-crypto-v4

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

Eric Biggers (4):
  firmware: qcom_scm: Add support for programming inline crypto keys
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
 drivers/scsi/ufs/ufs-qcom.c          |  12 +-
 drivers/scsi/ufs/ufs-qcom.h          |  27 +++
 drivers/scsi/ufs/ufshcd-crypto.c     |  27 +--
 drivers/scsi/ufs/ufshcd.h            |   3 +
 include/linux/qcom_scm.h             |  19 +++
 12 files changed, 441 insertions(+), 17 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c

-- 
2.26.2

