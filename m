Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC40176BB46
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Aug 2023 19:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbjHARcH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 1 Aug 2023 13:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjHARcG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 1 Aug 2023 13:32:06 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4A9F5;
        Tue,  1 Aug 2023 10:32:04 -0700 (PDT)
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371GA2kK001406;
        Tue, 1 Aug 2023 17:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=Q0zQgRy1fF8lD/XmdYNJfM4tnpsCfZTsWpnSrfRcajY=;
 b=gjhpkX+1dEGa2VffzW/khy6jFURA4E5PUtk8XMrv/PHRLzL9aSh+8DJ9tji9kcEf9257
 v8DNWGfo/9E/zzh3EURer/SMsTP2HZiqaVfidTf0Qwbvr8XKzpzRcPrgZSHJdzEM9na2
 0r1vVKLJOUddzlxf47rNzgpWvEfAKYnslWSq0xBljUDF0RNUjcw00955BwFHUQAxjrCH
 EdEXx8gCPi+6YbhVxpQyUVIky/kNLS4yxqPufCxzQorLPDnUexnzFGTy2lB7swOwJIaB
 dQFWDwq9G+UHVToFYn3QflxjTjN5w967AhikA8bxTD5l/+oYMcejfVtBZhrEGbSiuthd 2g== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3s75b305wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 17:32:00 +0000
Received: from nalasex01b.na.qualcomm.com (nalasex01b.na.qualcomm.com [10.47.209.197])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 371HVxeK028158
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 1 Aug 2023 17:31:59 GMT
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nalasex01b.na.qualcomm.com (10.47.209.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 1 Aug 2023 10:31:59 -0700
Received: from nalasex01a.na.qualcomm.com ([fe80::25d0:9235:354f:5fa9]) by
 nalasex01a.na.qualcomm.com ([fe80::25d0:9235:354f:5fa9%4]) with mapi id
 15.02.1118.030; Tue, 1 Aug 2023 10:31:59 -0700
From:   "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "Om Prakash Singh" <omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)" <quic_psodagud@quicinc.com>,
        "Arun Menon (SSG)" <avmenon@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>
Subject: RE: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Thread-Topic: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Thread-Index: AQHZumN+a5RI3WgcJ0CO2LlDH5s476/Ca+iAgBIbBxA=
Date:   Tue, 1 Aug 2023 17:31:59 +0000
Message-ID: <ca11701e403f48b6839b26c47a1b537f@quicinc.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230720025541.GA2607@sol.localdomain>
In-Reply-To: <20230720025541.GA2607@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.110.47.159]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: rEOTZeAVO7KVUd7mTmyYXt70nJ9OESWH
X-Proofpoint-ORIG-GUID: rEOTZeAVO7KVUd7mTmyYXt70nJ9OESWH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_14,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308010157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hey Eric, thanks for your reply. Pleasure working with you again.

Please find answers inline

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Wednesday, July 19, 2023 7:56 PM
To: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-mmc@vg=
er.kernel.org; linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; =
Om Prakash Singh <omprsing@qti.qualcomm.com>; Prasad Sodagudi (QUIC) <quic_=
psodagud@quicinc.com>; Arun Menon (SSG) <avmenon@quicinc.com>; abel.vesa@li=
naro.org; Seshu Madhavi Puppala (QUIC) <quic_spuppala@quicinc.com>
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and=
 ufs

Hi Gaurav,

On Wed, Jul 19, 2023 at 10:04:14AM -0700, Gaurav Kashyap wrote:
> These patches add support to Qualcomm ICE (Inline Crypto Enginr) for=20
> hardware wrapped keys using Qualcomm Hardware Key Manager (HWKM) and=20
> are made on top of a rebased version  Eric Bigger's set of changes to=20
> support wrapped keys in fscrypt and block below:
> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=3Dwrapped-key
> s-v7 (The rebased patches are not uploaded here)
>=20
> Ref v1 here:
> https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkas
> h@quicinc.com/
>=20
> Explanation and use of hardware-wrapped-keys can be found here:
> Documentation/block/inline-encryption.rst
>=20
> This patch is organized as follows:
>=20
> Patch 1 - Prepares ICE and storage layers (UFS and EMMC) to pass around w=
rapped keys.
> Patch 2 - Adds a new SCM api to support deriving software secret when=20
> wrapped keys are used Patch 3-4 - Adds support for wrapped keys in the=20
> ICE driver. This includes adding HWKM support Patch 5-6 - Adds support=20
> for wrapped keys in UFS Patch 7-10 - Supports generate, prepare and=20
> import functionality in ICE and UFS
>=20
> NOTE: MMC will have similar changes to UFS and will be uploaded in a diff=
erent patchset
>       Patch 3, 4, 8, 10 will have MMC equivalents.
>=20
> Testing:
> Test platform: SM8550 MTP
> Engineering trustzone image is required to test this feature only for=20
> SM8550. For SM8650 onwards, all trustzone changes to support this will=20
> be part of the released images.
> The engineering changes primarily contain hooks to generate, import=20
> and prepare keys for HW wrapped disk encryption.
>=20
> The changes were tested by mounting initramfs and running the=20
> fscryptctl tool (Ref:=20
> https://github.com/ebiggers/fscryptctl/tree/wip-wrapped-keys) to=20
> generate and prepare keys, as well as to set policies on folders, which c=
onsequently invokes disk encryption flows through UFS.
>=20
> Gaurav Kashyap (10):
>   ice, ufs, mmc: use blk_crypto_key for program_key
>   qcom_scm: scm call for deriving a software secret
>   soc: qcom: ice: add hwkm support in ice
>   soc: qcom: ice: support for hardware wrapped keys
>   ufs: core: support wrapped keys in ufs core
>   ufs: host: wrapped keys support in ufs qcom
>   qcom_scm: scm call for create, prepare and import keys
>   ufs: core: add support for generate, import and prepare keys
>   soc: qcom: support for generate, import and prepare key
>   ufs: host: support for generate, import and prepare key
>=20
>  drivers/firmware/qcom_scm.c            | 292 +++++++++++++++++++++++
>  drivers/firmware/qcom_scm.h            |   4 +
>  drivers/mmc/host/cqhci-crypto.c        |   7 +-
>  drivers/mmc/host/cqhci.h               |   2 +
>  drivers/mmc/host/sdhci-msm.c           |   6 +-
>  drivers/soc/qcom/ice.c                 | 309 +++++++++++++++++++++++--
>  drivers/ufs/core/ufshcd-crypto.c       |  92 +++++++-
>  drivers/ufs/host/ufs-qcom.c            |  63 ++++-
>  include/linux/firmware/qcom/qcom_scm.h |  13 ++
>  include/soc/qcom/ice.h                 |  18 +-
>  include/ufs/ufshcd.h                   |  25 ++
>  11 files changed, 797 insertions(+), 34 deletions(-)


Thank you for continuing to work on this!

According to your cover letter, this feature requires a custom TrustZone im=
age to work on SM8550.  Will that image be made available outside Qualcomm?
--> Unfortunately, I don't think there is a way to do that. You can still r=
equest for one through our customer engineering team like before.

Also according to your cover letter, this feature will work on SM8650 out o=
f the box.  That's great to hear.  However, SM8650 does not appear to be pu=
blicly available yet or have any upstream kernel support.  Do you know appr=
oximately when a SM8650 development board will become available to the gene=
ral public?
--> I meant it will be available in the future releases. As of today, I don=
't have any information on the timelines

Also, can you please make available a git branch somewhere that contains yo=
ur patchset?  It sounds like this depends on https://git.kernel.org/pub/scm=
/fs/fscrypt/linux.git/log/?h=3Dwrapped-keys-v7, but actually a version of i=
t that you've rebased, which I don't have access to.
Without being able to apply your patchset, I can't properly review it.
--> As for the fscrypt patches,
      I have not changed much functionally from the v7 patch, just merge co=
nflicts.
      I will update this thread once I figure out a git location.

Thanks!

- Eric
