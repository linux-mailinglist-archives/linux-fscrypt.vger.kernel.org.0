Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC08577854E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Aug 2023 04:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjHKCT6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 22:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjHKCT6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 22:19:58 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9753E2724;
        Thu, 10 Aug 2023 19:19:57 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37B1xvgf020538;
        Fri, 11 Aug 2023 02:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=qcppdkim1; bh=vBR7HgckOBL8Gr8JQ1V2+7FWLv7X9l13BJtRZ89G2iM=;
 b=gfGk2nSwCstE7/LBQ7qa1SDN9ZDYNfSGiM2mQJbFX7tKxJg4Tj5vVtFCIFzIMY2ze/+6
 QdsUry9lBY1VMxrxZgIsmyhbF0V7xDDUyah5AsU9ORPqKfhr+Jg6i15QEjQLo9NqlBeB
 OTnbW/zX79dbwipUXJP4PxoSIYS7qXk9+S9Or0yCjwqx2MKk0HvouWvtshoBUKcTy68d
 B9Di+2ASUxP+KMFgwMmNO25GKOxMMEWSnZrtucbtCLraEy+kjPhIFYsxxC/Gmw9vUEGi
 WghOeBVXR7wlYSiZLv2hC9n44WxUQHsJbu/M5/xLxcn/HU0U+P/oM0JD6TvNPa8gt/K2 1Q== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3sd90608ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 02:19:53 +0000
Received: from nalasex01c.na.qualcomm.com (nalasex01c.na.qualcomm.com [10.47.97.35])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 37B2Jq45011080
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Aug 2023 02:19:52 GMT
Received: from hu-bjorande-lv.qualcomm.com (10.49.16.6) by
 nalasex01c.na.qualcomm.com (10.47.97.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Thu, 10 Aug 2023 19:19:52 -0700
Date:   Thu, 10 Aug 2023 19:19:50 -0700
From:   Bjorn Andersson <quic_bjorande@quicinc.com>
To:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
CC:     Eric Biggers <ebiggers@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Om Prakash Singh <omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)" <quic_psodagud@quicinc.com>,
        "Arun Menon (SSG)" <avmenon@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>
Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Message-ID: <20230811021950.GQ1428172@hu-bjorande-lv.qualcomm.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230720025541.GA2607@sol.localdomain>
 <ca11701e403f48b6839b26c47a1b537f@quicinc.com>
 <20230810053642.GD923@sol.localdomain>
 <371088f78c6d4febbbfaf3c1a12cf19f@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <371088f78c6d4febbbfaf3c1a12cf19f@quicinc.com>
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01c.na.qualcomm.com (10.47.97.35)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: s5UTdnchEBXw_-T3x-mxWF8YOCgmGGFj
X-Proofpoint-ORIG-GUID: s5UTdnchEBXw_-T3x-mxWF8YOCgmGGFj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-10_20,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 clxscore=1011 spamscore=0
 mlxlogscore=694 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308110020
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 11, 2023 at 12:27:18AM +0000, Gaurav Kashyap (QUIC) wrote:
> 

Gaurav, it is impossible to decode what part of this message is from
Eric and what is from you. You must use a proper email client, and
follow proper etiquette on these mailing lists.

> 
> -----Original Message-----
> From: Eric Biggers <ebiggers@kernel.org> 
> Sent: Wednesday, August 9, 2023 10:37 PM
> To: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>
> Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-mmc@vger.kernel.org; linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; Om Prakash Singh <omprsing@qti.qualcomm.com>; Prasad Sodagudi (QUIC) <quic_psodagud@quicinc.com>; Arun Menon (SSG) <avmenon@quicinc.com>; abel.vesa@linaro.org; Seshu Madhavi Puppala (QUIC) <quic_spuppala@quicinc.com>
> Subject: Re: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and ufs
> 
> On Tue, Aug 01, 2023 at 05:31:59PM +0000, Gaurav Kashyap (QUIC) wrote:
> > 
> > According to your cover letter, this feature requires a custom TrustZone image to work on SM8550.  Will that image be made available outside Qualcomm?
> > --> Unfortunately, I don't think there is a way to do that. You can still request for one through our customer engineering team like before.
> 
> I think it's already been shown that that is not a workable approach.
> 

I agree.

Regards,
Bjorn
