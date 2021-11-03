Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD43444B6F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 00:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhKCXVs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Nov 2021 19:21:48 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:37911 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKCXVr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Nov 2021 19:21:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1635981551; x=1667517551;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=k64ynEfu975pQWgOL6O+bE+0nql5whpTZa6mWxc4sNg=;
  b=vfYdhCCNio9Nj2sUAo43ZeQe+DGyJ83NDjaVhjxrMQfAgM+8J2FR4ylD
   bAzjjvdbLmtmxYBaVatQ/3G594CDBse3NudnQLNCH06JQqdfGBFuiusEy
   1EbVWdcpAc/fbGwarCLMwqbProBS4a1SFH484AQKf9G4m2UCbGJL/CG3P
   E=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 03 Nov 2021 16:19:11 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 16:19:10 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7;
 Wed, 3 Nov 2021 16:19:09 -0700
Received: from gabriel.qualcomm.com (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Wed, 3 Nov 2021
 16:19:09 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <thara.gopinath@linaro.org>,
        <asutoshd@codeaurora.org>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH 0/4] Adds wrapped key support for inline storage encryption
Date:   Wed, 3 Nov 2021 16:18:36 -0700
Message-ID: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This currently has 4 patches with another coming in shortly for MMC.

1. Moves ICE functionality to a common library, so that different storage controllers can use it.
2. Adds a SCM call for derive raw secret needed for wrapped keys.
3. Adds a hardware key manager library needed for wrapped keys.
4. Adds wrapped key support in ufs for storage encryption

Gaurav Kashyap (4):
  ufs: move ICE functionality to a common library
  qcom_scm: scm call for deriving a software secret
  soc: qcom: add HWKM library for storage encryption
  soc: qcom: add wrapped key support for ICE

 drivers/firmware/qcom_scm.c       |  61 +++++++
 drivers/firmware/qcom_scm.h       |   1 +
 drivers/scsi/ufs/ufs-qcom-ice.c   | 200 ++++++-----------------
 drivers/scsi/ufs/ufs-qcom.c       |   1 +
 drivers/scsi/ufs/ufs-qcom.h       |   5 +
 drivers/scsi/ufs/ufshcd-crypto.c  |  47 ++++--
 drivers/scsi/ufs/ufshcd.h         |   5 +
 drivers/soc/qcom/Kconfig          |  14 ++
 drivers/soc/qcom/Makefile         |   2 +
 drivers/soc/qcom/qti-ice-common.c | 215 +++++++++++++++++++++++++
 drivers/soc/qcom/qti-ice-hwkm.c   |  77 +++++++++
 drivers/soc/qcom/qti-ice-regs.h   | 257 ++++++++++++++++++++++++++++++
 include/linux/qcom_scm.h          |   5 +
 include/linux/qti-ice-common.h    |  37 +++++
 14 files changed, 766 insertions(+), 161 deletions(-)
 create mode 100644 drivers/soc/qcom/qti-ice-common.c
 create mode 100644 drivers/soc/qcom/qti-ice-hwkm.c
 create mode 100644 drivers/soc/qcom/qti-ice-regs.h
 create mode 100644 include/linux/qti-ice-common.h

-- 
2.17.1

