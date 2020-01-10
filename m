Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE4D13673F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2020 07:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgAJGS0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jan 2020 01:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgAJGS0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jan 2020 01:18:26 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67DDD20673;
        Fri, 10 Jan 2020 06:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578637104;
        bh=E83v9s/velUj5ZMKMl2BVwEb+LgFHUZZtzb8Bqy9gU4=;
        h=From:To:Cc:Subject:Date:From;
        b=xyN7PM3sGWyQc+Q3C57MHsA5e3wjktENkcTqPjjN48EhTVMfLAOcEH7WXcehyQGC6
         CqtX3KktH3VHkouuRDRBfqb+OHlpZenFzzhBLqVYkQH/7WfrzKZ0q/vtCiat2KM09/
         /73s9E3NXSaD1yHiJUh5GvaXRcpQoPXGGxrOfGV8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 0/5] Inline crypto support on DragonBoard 845c
Date:   Thu,  9 Jan 2020 22:16:29 -0800
Message-Id: <20200110061634.46742-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
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

This is based on top of the patchset "[PATCH v6 0/9] Inline Encryption
Support" by Satya Tangirala, which adds support for the UFS standard
inline crypto, the block layer changes needed to use inline crypto, and
support for inline crypto in fscrypt (ext4 and f2fs encryption).  Link:
https://lkml.kernel.org/r/20191218145136.172774-1-satyat@google.com

This new patchset is mostly a RFC showing hardware inline crypto working
on a publicly available development board that runs the mainline Linux
kernel.  While patches 1-2 could be applied now, patches 3-5 depend on
the main "Inline Encryption Support" patchset being merged first.

Most of the logic needed to use ICE is already handled by ufshcd-crypto
and the blk-crypto framework, which are introduced by the "Inline
Encryption Support" patchset.  Therefore, this new patchset just adds
the vendor-specific parts.  I also only implemented support for version
3 of the ICE hardware, which seems to be easier to use than older
versions; and for now I only implemented UFS support, not eMMC.

Due to these factors, I was able to greatly simplify the driver from the
vendor's original.  It seems to work fine in some preliminary testing
with fscrypt, and with a blk-crypto self-test I'm also working on.  But
I'd appreciate feedback from anyone who may be more familiar with this
hardware as to whether I might have missed anything important.

This patchset is also available in git at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/tag/?h=db845c-crypto-v1

Eric Biggers (5):
  firmware: qcom_scm: Add support for programming inline crypto keys
  arm64: dts: sdm845: add Inline Crypto Engine registers and clock
  scsi: ufs: add quirk to disable inline crypto support
  scsi: ufs: add program_key() variant op
  scsi: ufs-qcom: add Inline Crypto Engine support

 MAINTAINERS                          |   2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi |  13 +-
 drivers/firmware/qcom_scm-32.c       |  14 ++
 drivers/firmware/qcom_scm-64.c       |  31 ++++
 drivers/firmware/qcom_scm.c          |  78 +++++++++
 drivers/firmware/qcom_scm.h          |   9 +
 drivers/scsi/ufs/Kconfig             |   1 +
 drivers/scsi/ufs/Makefile            |   4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c      | 247 +++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.c          |  14 +-
 drivers/scsi/ufs/ufs-qcom.h          |  35 ++++
 drivers/scsi/ufs/ufshcd-crypto.c     |  27 ++-
 drivers/scsi/ufs/ufshcd.h            |  12 ++
 include/linux/qcom_scm.h             |  17 ++
 14 files changed, 490 insertions(+), 14 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c

-- 
2.24.1

