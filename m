Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5721F79D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 18:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGNQqv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 12:46:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40612 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbgGNQqu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 12:46:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EGasv0125440;
        Tue, 14 Jul 2020 16:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=STENSvjdyHh6CPVEDHay/y6E889RtcXRcudhfxvQCA4=;
 b=DSRDN1y/qdi7ll0t8s2TZ7q3jwbge6Pw0BXP3FjQTbRd9fhitMDwH5QeK/FaXwhv/HMj
 ikRz4C4QBje33LyJyUA4dfX2kTKmq9p2FIL8AlRyOLEXXu9UiJLvh7MOO62MbqUIhjgq
 /hAQI5ywr0fPt33J5rgt9vAirb9dwrD9kLIK7yP59jMt1ZTQN7BdjYPZfvMQ9vBuNZ6F
 gkRteLFsTyGOppdmlx+//n/hwoaaYnGtdpXnruSVyDzrg5xqHzgrqFIpj6Mdxnf4OjgX
 4xV2k9bCWwnp7/6t4WxGFG+4ywA5nBnjVU1ADpaKpkBMUXxPUpxZq2s3nssZKxgiZ1FO qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32762ned81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 16:46:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EGba88104025;
        Tue, 14 Jul 2020 16:46:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb4mayp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 16:46:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EGkY5u003391;
        Tue, 14 Jul 2020 16:46:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 09:46:33 -0700
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        SCSI <linux-scsi@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a702qc34.fsf@ca-mkp.ca.oracle.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
        <20200710072013.177481-4-ebiggers@kernel.org>
        <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
        <20200714161516.GA1064009@gmail.com>
        <CAL_Jsq+t1h4w8C361vguw1co_vnbMKs3q4qWR4=jwAKr1Vm80g@mail.gmail.com>
        <20200714164353.GB1064009@gmail.com>
Date:   Tue, 14 Jul 2020 12:46:29 -0400
In-Reply-To: <20200714164353.GB1064009@gmail.com> (Eric Biggers's message of
        "Tue, 14 Jul 2020 09:43:53 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=1 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140121
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


Eric,

> Martin: how about you take patches 1-2 and 4-5 through the scsi tree
> for 5.9, and then we get the DTS patch taken through the QCOM tree for
> 5.10?

Sure!

-- 
Martin K. Petersen	Oracle Linux Engineering
