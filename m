Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AA821F3B3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jul 2020 16:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGNOQg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 10:16:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57210 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgGNOQg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 10:16:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EECukm087139;
        Tue, 14 Jul 2020 14:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=eeVlu7C/UvyRHqntk10Su87FuUiKG50iJXKH5wMa/uk=;
 b=r8PUJbVZh5MtQEmm8j/sLJsf4vGLzmN99WTl8Q/scf/o41ugGSXYpXbq1JA/bsSvbBIx
 rTzm3S0vM6D3+T+MrPeq2+ilIW5Uo/0wHZ8usThi54KYKDLA0k8qWfyK31mFtUMXt3+x
 fuU79ojyGGhzUesTMxnvI5aasNERwkoCBc2VsI3k3zqyx69F84MWlXjxYO3yG8/2frzI
 QDhAA/CpIn1MrzCMpMEUJTigZXndZBx5uJ5VDxtZrBgLYE8OXW4hqM+xxy6xRshhU1Z3
 p6O0EZiDe+uW+/IjwHhXzHthStL6ctQuRpAzBTEImj66usH+rPLpKUY+AnSohNPUG0fQ +g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3275cm5km7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 14:16:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06EE7ZmI011983;
        Tue, 14 Jul 2020 14:16:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 327qb46y4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 14:16:21 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06EEG8KV017692;
        Tue, 14 Jul 2020 14:16:08 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 07:16:08 -0700
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 3/5] arm64: dts: sdm845: add Inline Crypto Engine
 registers and clock
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft9uqj6u.fsf@ca-mkp.ca.oracle.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
        <20200710072013.177481-4-ebiggers@kernel.org>
Date:   Tue, 14 Jul 2020 10:16:04 -0400
In-Reply-To: <20200710072013.177481-4-ebiggers@kernel.org> (Eric Biggers's
        message of "Fri, 10 Jul 2020 00:20:10 -0700")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=1 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140109
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


Eric,

> Add the vendor-specific registers and clock for Qualcomm ICE (Inline
> Crypto Engine) to the device tree node for the UFS host controller on
> sdm845, so that the ufs-qcom driver will be able to use inline crypto.

I would like to see an Acked-by for this patch before I merge it.

-- 
Martin K. Petersen	Oracle Linux Engineering
