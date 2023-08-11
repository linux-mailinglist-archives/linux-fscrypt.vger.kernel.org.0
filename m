Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD3D77847E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Aug 2023 02:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjHKA1Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 20:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjHKA1Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 20:27:24 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED792718;
        Thu, 10 Aug 2023 17:27:24 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37B03Iiq025172;
        Fri, 11 Aug 2023 00:27:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=MRXzDHmf0jpToFYvEYjb8jcM+QLXtNMavgjF9THlYLE=;
 b=BOTSZ0fDNVkSQ2MXuhqZkVBJtcu1xuqjVkD3kqNgj0R6g+84iJIVm4Ls62c6pBKoI7W7
 p/dcoq7qe40pDjetHpPopEW2LbWcuryw8NcuK8KJanGLYKXpK53W4fB4rvW/JIeHwCDD
 GyXBg4t6oYOX+fJ4wrn2E33Bj+xaYFNsN2LU+0yb2Dx7rMpulEtUUEC+eeYuExbOq+mk
 0YsFkN+xXVl7/9F6w71K45gensKmlVcH2G2WClIUm7FwTWHsv3nyCeC/o1ddy4sIbHgd
 SZj0Y1A3vjtNFT6gGklKFuo/dRJBjtGus+6fVv3LAcB9N0mVB2oAuqQjhoXUgGoyf1OA +A== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sd90603vk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 00:27:20 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37B0RJsh004329
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 00:27:19 GMT
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 10 Aug 2023 17:27:18 -0700
Received: from nalasex01a.na.qualcomm.com ([fe80::25d0:9235:354f:5fa9]) by
 nalasex01a.na.qualcomm.com ([fe80::25d0:9235:354f:5fa9%4]) with mapi id
 15.02.1118.030; Thu, 10 Aug 2023 17:27:18 -0700
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
Thread-Index: AQHZumN+a5RI3WgcJ0CO2LlDH5s476/Ca+iAgBIbBxCADxLrAIAAxjXQ
Date:   Fri, 11 Aug 2023 00:27:18 +0000
Message-ID: <371088f78c6d4febbbfaf3c1a12cf19f@quicinc.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230720025541.GA2607@sol.localdomain>
 <ca11701e403f48b6839b26c47a1b537f@quicinc.com>
 <20230810053642.GD923@sol.localdomain>
In-Reply-To: <20230810053642.GD923@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.52.103.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: tNmSuQfPNm_Uwa1dtOWpKf-UlFsAkBQ8
X-Proofpoint-ORIG-GUID: tNmSuQfPNm_Uwa1dtOWpKf-UlFsAkBQ8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_19,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308110002
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Wednesday, August 9, 2023 10:37 PM
To: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-mmc@vg=
er.kernel.org; linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; =
Om Prakash Singh <omprsing@qti.qualcomm.com>; Prasad Sodagudi (QUIC) <quic_=
psodagud@quicinc.com>; Arun Menon (SSG) <avmenon@quicinc.com>; abel.vesa@li=
naro.org; Seshu Madhavi Puppala (QUIC) <quic_spuppala@quicinc.com>
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and=
 ufs

On Tue, Aug 01, 2023 at 05:31:59PM +0000, Gaurav Kashyap (QUIC) wrote:
>=20
> According to your cover letter, this feature requires a custom TrustZone =
image to work on SM8550.  Will that image be made available outside Qualcom=
m?
> --> Unfortunately, I don't think there is a way to do that. You can still=
 request for one through our customer engineering team like before.

I think it's already been shown that that is not a workable approach.

> Also, can you please make available a git branch somewhere that contains =
your patchset?  It sounds like this depends on https://git.kernel.org/pub/s=
cm/fs/fscrypt/linux.git/log/?h=3Dwrapped-keys-v7, but actually a version of=
 it that you've rebased, which I don't have access to.
> Without being able to apply your patchset, I can't properly review it.
> --> As for the fscrypt patches,
>       I have not changed much functionally from the v7 patch, just merge =
conflicts.
>       I will update this thread once I figure out a git location.
>=20

Any update on this?  Most kernel developers just create a GitHub repo if th=
ey don't have kernel.org access.

>> Here are the git links
>> https://github.com/quic-gaurkash/linux/tree/fscrypt
>> https://github.com/quic-gaurkash/linux/tree/wrapped_keys_ice_ufs

- Eric
