Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB88E229825
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jul 2020 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVMV7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jul 2020 08:21:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgGVMV6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jul 2020 08:21:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06MCGUjq172539;
        Wed, 22 Jul 2020 12:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=i0nYeTghHBapGoZ21md4P88Jr8qUqrATcpSnBShWXK4=;
 b=LhBZHjbrlGfoEsvSqr2ZNB7VpOhRrMxaW5lKDs1hMTwiILxJzH2NCA3gTKFd+3sWTt0M
 ASwoHu1ZT1ptK1/iQkSpN59fjcs3ac2vUlkvtCMDicKfpYD9wMyGx31a1Qh+9ezUuFM8
 78U3Y5dQ9j8D+NG5z+PHDdss1FNahVkIQUkOPNHQKFbBd2029Y102qXKqRr3e+PhssHb
 BDjyLANgkLeOhXVu27bxD2ksh9UZKzms6C+WG/z2H2pOjFgMcP4AurrDFK4jarAOyotw
 zp40t1yJNT7S4tOHXpZcPPYEBKYfCPn3962Y+WzN0afymKYiyhbaQ8WrbP0aDcs5ZAWK 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32brgrjxff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 12:21:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06MCEFJ3018310;
        Wed, 22 Jul 2020 12:21:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32ehx0c6nx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 12:21:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06MCLgpl020123;
        Wed, 22 Jul 2020 12:21:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jul 2020 12:21:42 +0000
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        linux-fscrypt@vger.kernel.org, Andy Gross <agross@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
Subject: Re: [PATCH v6 0/5] Inline crypto support on DragonBoard 845c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mu3rg379.fsf@ca-mkp.ca.oracle.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
        <159539205429.31352.16564389172198122676.b4-ty@oracle.com>
        <20200722052541.GB39383@sol.localdomain>
Date:   Wed, 22 Jul 2020 08:21:39 -0400
In-Reply-To: <20200722052541.GB39383@sol.localdomain> (Eric Biggers's message
        of "Tue, 21 Jul 2020 22:25:41 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220093
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220093
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


Eric,

> Seems that something went wrong when you applied patch 5.  It's
> supposed to add the file ufs-qcom-ice.c, but the committed version
> doesn't have that file.

Not sure what happened there, I recall it being a clean b4 am.

I fixed it up. Sorry about that!

-- 
Martin K. Petersen	Oracle Linux Engineering
