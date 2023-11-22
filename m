Return-Path: <linux-fscrypt+bounces-15-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31ACE7F3D81
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 06:40:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1C81281E1E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Nov 2023 05:40:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9733F15ADC;
	Wed, 22 Nov 2023 05:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="L6oBALYP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AED185;
	Tue, 21 Nov 2023 21:40:09 -0800 (PST)
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AM4p8LP007735;
	Wed, 22 Nov 2023 05:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=ALkmVqSwKcwZgm9a7GoAzNkFsdYW5KY0EUWloUNk+TA=;
 b=L6oBALYPyL1GVRxxZ5Sep4lBDQX0oDz15h3uoSWdzNthw3+Jz6BMvc0DyxDZ0c3427q4
 zak+3+ojg5cEVTR6pQQAk2irp6z8NSqLbT2EH0KgT6snkrapEzc0ScKjeotYH+FV2YrC
 6ciZAaRJFMrh7fVqGcIWzLbaGRFtlJxbrEZBdfM07r2j2Sz4TCBmZzliSYkBqxKs8J8N
 i9JDSoGkK4AYRQVH5atH+ljtep8b3Eqw0bJSyMnuudOYl7lSM4RlPbHcRQAtddwCZNGT
 l23yhXOJ2fuhp/BK8GVqT7QF7S+STu7gwJjE86IPdkWrLHlpsy0ELjfpJtKnBN55Q7Y/ VA== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ugr85u3dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:06 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 3AM5e5HZ021849
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Nov 2023 05:40:05 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 21 Nov 2023 21:40:00 -0800
From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
To: <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>, <neil.armstrong@linaro.org>,
        <srinivas.kandagatla@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <abel.vesa@linaro.org>,
        <quic_spuppala@quicinc.com>, <kernel@quicinc.com>,
        Gaurav Kashyap
	<quic_gaurkash@quicinc.com>
Subject: [PATCH v3 00/12] Hardware wrapped key support for qcom ice and ufs
Date: Tue, 21 Nov 2023 21:38:05 -0800
Message-ID: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: rVGZF4_I0t8DKili-JgQ8PmHjYA69Xb8
X-Proofpoint-ORIG-GUID: rVGZF4_I0t8DKili-JgQ8PmHjYA69Xb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-22_02,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311220040

These are the third iteration of patches that add support to Qualcomm ICE (Inline Crypto Engine) for hardware wrapped keys using Qualcomm Hardware Key Manager (HWKM)

They patches do the following:
- Address comments from v2 (Found here: https://lore.kernel.org/all/20230719170423.220033-1-quic_gaurkash@quicinc.com/)
- Rebased and tested on top of Eric's latest patchset: https://lore.kernel.org/all/20231104211259.17448-1-ebiggers@kernel.org/
- Rebased and tested on top of SM8650 patches from Linaro: https://lore.kernel.org/all/?q=sm8650

Information about patches copied over from v2:

"
Explanation and use of hardware-wrapped-keys can be found here:
Documentation/block/inline-encryption.rst

This patch is organized as follows:

Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around wrapped keys.
Patch 2 - Adds a new SCM api to support deriving software secret when wrapped keys are used
Patch 3-4 - Adds support for wrapped keys in the ICE driver. This includes adding HWKM support
Patch 5-6 - Adds support for wrapped keys in UFS
Patch 7-10 - Supports generate, prepare and import functionality in ICE and UFS

NOTE: MMC will have similar changes to UFS and will be uploaded in a different patchset
      Patch 3, 4, 8, 10 will have MMC equivalents.
"

Testing: 
Test platform: SM8650 MTP

The changes were tested by mounting initramfs and running the fscryptctl
tool (Ref: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to
generate and prepare keys, as well as to set policies on folders, which
consequently invokes disk encryption flows through UFS.

Tested both standard and wrapped keys (Removing qcom,ice-use-hwkm from dtsi will support using standard keys)

Steps to test:

The following configs were enabled:
CONFIG_BLK_INLINE_ENCRYPTION=y
CONFIG_QCOM_INLINE_CRYPTO_ENGINE=m
CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
CONFIG_SCSI_UFS_CRYPTO=y

Flash boot image, boot to shell and run the following commands

Creating and preparing keys
- mkfs.ext4 -F -O encrypt,stable_inodes /dev/disk/by-partlabel/userdata
- mount /dev/disk/by-partlabel/userdata -o inlinecrypt /mnt
- ./fscryptctl generate_hw_wrapped_key /dev/disk/by-partlabel/userdata > /mnt/key.longterm 
Note: import_hw_wrapped_key currently has a big which just got fixed, so it will be functional in the next SM8650 release
(It might already be available by the time the boards are available to public)
- ./fscryptctl prepare_hw_wrapped_key /dev/disk/by-partlabel/userdata < /mnt/key.longterm > /tmp/key.ephemeral
- ./fscryptctl add_key --hw-wrapped-key < /tmp/key.ephemeral /mnt

Create a folder and associate created keys with the folder
- rm -rf /mnt/dir
- mkdir /mnt/dir
- ./fscryptctl set_policy --hw-wrapped-key --iv-ino-lblk-64 "$keyid" /mnt/dir
- dmesg > /mnt/dir/test.txt
- sync

- Reboot
- mount /dev/disk/by-partlabel/userdata -o inlinecrypt /mnt
- ls /mnt/dir (You should see an encrypted file)
- ./fscryptctl prepare_hw_wrapped_key /dev/disk/by-partlabel/userdata < /mnt/key.longterm > /tmp/key.ephemeral
- ./fscryptctl add_key --hw-wrapped-key < /tmp/key.ephemeral /mnt
- cat /mnt/dir/test.txt

Gaurav Kashyap (12):
  ice, ufs, mmc: use blk_crypto_key for program_key
  qcom_scm: scm call for deriving a software secret
  soc: qcom: ice: add hwkm support in ice
  soc: qcom: ice: support for hardware wrapped keys
  ufs: core: support wrapped keys in ufs core
  ufs: host: wrapped keys support in ufs qcom
  qcom_scm: scm call for create, prepare and import keys
  ufs: core: add support for generate, import and prepare keys
  soc: qcom: support for generate, import and prepare key
  ufs: host: support for generate, import and prepare key
  arm64: dts: qcom: sm8650: add hwkm support to ufs ice
  dt-bindings: crypto: ice: document the hwkm property

 .../crypto/qcom,inline-crypto-engine.yaml     |   7 +
 arch/arm64/boot/dts/qcom/sm8650.dtsi          |   3 +-
 drivers/firmware/qcom/qcom_scm.c              | 276 +++++++++++++++
 drivers/firmware/qcom/qcom_scm.h              |   4 +
 drivers/mmc/host/cqhci-crypto.c               |   7 +-
 drivers/mmc/host/cqhci.h                      |   2 +
 drivers/mmc/host/sdhci-msm.c                  |   6 +-
 drivers/soc/qcom/ice.c                        | 321 +++++++++++++++++-
 drivers/ufs/core/ufshcd-crypto.c              |  87 ++++-
 drivers/ufs/host/ufs-qcom.c                   |  61 +++-
 include/linux/firmware/qcom/qcom_scm.h        |   7 +
 include/soc/qcom/ice.h                        |  18 +-
 include/ufs/ufshcd.h                          |  22 ++
 13 files changed, 784 insertions(+), 37 deletions(-)

-- 
2.25.1


