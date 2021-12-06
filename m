Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1463D46ADD4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  6 Dec 2021 23:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376573AbhLFXCD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 6 Dec 2021 18:02:03 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:24676 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359564AbhLFXCD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 6 Dec 2021 18:02:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1638831514; x=1670367514;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=zoqnyRmkSd5RO5BU5otfubBRWktBekjMrFhDCqc/zdw=;
  b=y/Dd/yc/PbinDqbqiETddAsC7OlZiMCBwNvAkV/Gvj43GbNWXp4Ma8td
   yL9z6wvS7Ri7tJsGZ8UiVIqp4sT3NTAfcrQOkpsLWls7t3mMMhfx5+ZEe
   6wubAngCRhG8lxbAQ+ERw8N1bsumss8wLA9pogm3yTFikDCUWJWg7vIx3
   A=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 06 Dec 2021 14:58:33 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 14:58:33 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 6 Dec 2021 14:58:32 -0800
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 6 Dec 2021
 14:58:32 -0800
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <quic_neersoni@quicinc.com>, <dineshg@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 00/10] Add wrapped key support for Qualcomm ICE
Date:   Mon, 6 Dec 2021 14:57:15 -0800
Message-ID: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These patches add support to Qualcomm ICE for hardware
wrapped keys and are made on top of Eric Bigger's set of changes to
support wrapped keys.
Found here: https://lore.kernel.org/linux-block/20210916174928.65529-1-ebiggers@kernel.org).
Explanation and use of hardware-wrapped-keys can be found here:
Documentation/block/inline-encryption.rst

The first patch however is not related to wrapped keys. It is
for moving ICE functionality into a shared library which both ufs and
sdhci can use. The patch for sdhc-msm will be uploaded later.

Wrapped keys are supported in Qualcomm's ICE engine using
a proprietary hardware module known as Hardware Key Manager (HWKM).
The patches are revolved around that and testing for them
can be done only on a HWKM supported Qualcomm device.

Testing:
Test platform: SM8350 HDK/MTP
Engineering trustzone image (based on sm8350) is required to test
this feature. This is because of version changes of HWKM.
HWKM version 2 and moving forward has a lot of restrictions on the
key management due to which the launched SM8350 solution (based on v1)
cannot be used and some modifications are required in trustzone.

The ideal scenario is to test by mounting initramfs on an upstream
kernel and then using the fscrypt tool to setup directories with
encryption policies. Testing and development for that is still under way.

All the SCM calls however were individually tested from UFS by invoking
a test API on bootup which is not part of these patchsets.

Gaurav Kashyap (10):
  soc: qcom: new common library for ICE functionality
  scsi: ufs: qcom: move ICE functionality to common library
  qcom_scm: scm call for deriving a software secret
  soc: qcom: add HWKM library for storage encryption
  scsi: ufs: prepare to support wrapped keys
  soc: qcom: add wrapped key support for ICE
  qcom_scm: scm call for create, prepare and import keys
  scsi: ufs: add support for generate, import and prepare keys
  soc: qcom: support for generate, import and prepare key
  arm64: dts: qcom: sm8350: add ice and hwkm mappings

 arch/arm64/boot/dts/qcom/sm8350.dtsi |   5 +-
 drivers/firmware/qcom_scm.c          | 286 +++++++++++++++++++
 drivers/firmware/qcom_scm.h          |   4 +
 drivers/scsi/ufs/Kconfig             |   1 +
 drivers/scsi/ufs/ufs-qcom-ice.c      | 227 +++++----------
 drivers/scsi/ufs/ufs-qcom.c          |   4 +
 drivers/scsi/ufs/ufs-qcom.h          |  22 +-
 drivers/scsi/ufs/ufshcd-crypto.c     |  96 ++++++-
 drivers/scsi/ufs/ufshcd.h            |  20 +-
 drivers/soc/qcom/Kconfig             |   7 +
 drivers/soc/qcom/Makefile            |   1 +
 drivers/soc/qcom/qti-ice-common.c    | 402 +++++++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-hwkm.c      | 111 ++++++++
 drivers/soc/qcom/qti-ice-regs.h      | 264 ++++++++++++++++++
 include/linux/qcom_scm.h             |  30 +-
 include/linux/qti-ice-common.h       |  40 +++
 16 files changed, 1345 insertions(+), 175 deletions(-)
 create mode 100644 drivers/soc/qcom/qti-ice-common.c
 create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c
 create mode 100644 drivers/soc/qcom/qti-ice-regs.h
 create mode 100644 include/linux/qti-ice-common.h

-- 
2.17.1

