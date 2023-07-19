Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA878759BD1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjGSRHg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjGSRHf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:07:35 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7BB7;
        Wed, 19 Jul 2023 10:07:31 -0700 (PDT)
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JDMxSF013739;
        Wed, 19 Jul 2023 17:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=qcppdkim1;
 bh=1BQj/4/ShoOHhtfTts2VeEpZMxDNQ2NwBUEEeZrAF0E=;
 b=fll4EbiGh2qumdTB46D5wS7zKohJQsAj94fue18SgIrQm1o7lmExD06FsIekVvloNnv9
 jU05TlL8e54Bu9tmWnF2IXe/tgMyi6idC4zAUk4oieGNhv94pja0e/V5Lulkl0TtEG1D
 GIkaId6gvntrl+0IMN/ZQLGl1dhfC6Ebso2nVmgJtiPIRR200+7l/IDXfs/O9gkaZXNy
 fLhm++34GbqD0gs5Cim7g+yYVAl8sYCoZWW547BjFHI2cCPYncP9s29HrlzE2roOT18D
 lO2Q9EB1mFH0YoIDFOrbwjqk9K4hq2xousZofYA0Qlo7BTMFrXmaRZhOLxG2aUyCCsxA 3g== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rxexkgtu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:28 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JH7RZr026518
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:27 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 10:07:27 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and ufs
Date:   Wed, 19 Jul 2023 10:04:14 -0700
Message-ID: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: AdU09At96WesfPGF559znTNbLYI2Xiq8
X-Proofpoint-GUID: AdU09At96WesfPGF559znTNbLYI2Xiq8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_11,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1011 suspectscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These patches add support to Qualcomm ICE (Inline Crypto Enginr) for hardware
wrapped keys using Qualcomm Hardware Key Manager (HWKM) and are made on top
of a rebased version  Eric Bigger's set of changes to support wrapped keys in
fscrypt and block below:
https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=wrapped-keys-v7
(The rebased patches are not uploaded here)

Ref v1 here:
https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkash@quicinc.com/

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

Testing:
Test platform: SM8550 MTP
Engineering trustzone image is required to test this feature only
for SM8550. For SM8650 onwards, all trustzone changes to support this
will be part of the released images.
The engineering changes primarily contain hooks to generate, import and
prepare keys for HW wrapped disk encryption.

The changes were tested by mounting initramfs and running the fscryptctl
tool (Ref: https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to
generate and prepare keys, as well as to set policies on folders, which
consequently invokes disk encryption flows through UFS.

Gaurav Kashyap (10):
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

 drivers/firmware/qcom_scm.c            | 292 +++++++++++++++++++++++
 drivers/firmware/qcom_scm.h            |   4 +
 drivers/mmc/host/cqhci-crypto.c        |   7 +-
 drivers/mmc/host/cqhci.h               |   2 +
 drivers/mmc/host/sdhci-msm.c           |   6 +-
 drivers/soc/qcom/ice.c                 | 309 +++++++++++++++++++++++--
 drivers/ufs/core/ufshcd-crypto.c       |  92 +++++++-
 drivers/ufs/host/ufs-qcom.c            |  63 ++++-
 include/linux/firmware/qcom/qcom_scm.h |  13 ++
 include/soc/qcom/ice.h                 |  18 +-
 include/ufs/ufshcd.h                   |  25 ++
 11 files changed, 797 insertions(+), 34 deletions(-)

-- 
2.25.1

