Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7569178AD7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 07:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgCDGuM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 01:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725271AbgCDGuM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 01:50:12 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83FC2146E;
        Wed,  4 Mar 2020 06:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583304611;
        bh=hKHt3mWDAi5/2pwURoereWV15TLyzLsiROBqLj0xwTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=llE169QOK5XHbqB7oK9wDxmveaSDKg7JD7a/z3DgIWoVSAfZ4nx48C9niMI0FQd1O
         Hg4mvU8+0ZavXlT3jn/1ronBlCgTRAHEwvvOHTuozdsfXJlyZGt5ZsvjiMZUcUl49N
         nTqSIrI8qJWmxzO3B8VvV8mZi8DKPZ4i5MwFcLZY=
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
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [RFC PATCH v2 0/4] Inline crypto support on DragonBoard 845c
Date:   Tue,  3 Mar 2020 22:49:38 -0800
Message-Id: <20200304064942.371978-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
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

This is based on top of the patchset "[PATCH v7 0/9] Inline Encryption
Support" by Satya Tangirala, which adds support for the UFS standard
inline crypto, the block layer changes needed to use inline crypto, and
support for inline crypto in fscrypt (ext4 and f2fs encryption).  Link:
https://lkml.kernel.org/r/20200221115050.238976-1-satyat@google.com

This new patchset is mostly a RFC showing hardware inline crypto working
on a publicly available development board that runs the mainline Linux
kernel.  While patches 1-2 could be applied now, patches 3-4 depend on
the main "Inline Encryption Support" patchset being merged first.

Most of the logic needed to use ICE is already handled by ufshcd-crypto
and the blk-crypto framework, which are introduced by the "Inline
Encryption Support" patchset.  Therefore, this new patchset just adds
the vendor-specific parts.  I also only implemented support for version
3 of the ICE hardware, which seems to be easier to use than older
versions; and for now I only implemented UFS support, not eMMC.

Due to these factors, I was able to greatly simplify the driver from the
vendor's original.  It seems to work fine in testing with fscrypt and
with a blk-crypto self-test I'm also working on.  But I'd appreciate
feedback from anyone who may be more familiar with this hardware as to
whether I might have missed anything important.

This patchset is also available in git at:
    Repo: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
    Tag: db845c-crypto-v2

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
 drivers/firmware/qcom_scm.c          |  96 +++++++++++
 drivers/firmware/qcom_scm.h          |   4 +
 drivers/scsi/ufs/Kconfig             |   1 +
 drivers/scsi/ufs/Makefile            |   4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c      | 245 +++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.c          |  18 +-
 drivers/scsi/ufs/ufs-qcom.h          |  27 +++
 drivers/scsi/ufs/ufshcd-crypto.c     |  34 ++--
 drivers/scsi/ufs/ufshcd.h            |   3 +
 include/linux/qcom_scm.h             |  19 +++
 12 files changed, 440 insertions(+), 26 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c

-- 
2.25.1

