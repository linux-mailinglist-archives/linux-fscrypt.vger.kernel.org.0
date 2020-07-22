Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F540228F50
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Jul 2020 06:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgGVEn6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Jul 2020 00:43:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbgGVEn6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Jul 2020 00:43:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4hmbZ059418;
        Wed, 22 Jul 2020 04:43:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Oqjo4vAbzhzsBvkd82BOetylmV85I1RVKf/RJM1Wqhs=;
 b=wWyC3aR19A2JHKUcyeRAptLwiAVn8l6/TEjEsIZckpjqKEanicq4IbMnGkcOxBaufL2e
 6uLab/Lja7+EvBW+8FKexkst2iD79+6JTLPMfFZnj/V5ITrn40l/Q+++gnt5yMt6txhG
 LbcHWPq9CsZnKezsJIuLy8tYnhssaqlgO1VjnYdFvv5adcErrHScObF8A/UglLTJgLFW
 8hVg6dJcItwcEmJqCvEArvTsKlM46NK8lHOrvqciDwU6lq6A4mo+5D/lha/Z+5O6odRZ
 trBlgNC5glC8WjW+dcCWR11enMl19y8vpwcP/Y2wdWiEdtgyoToTX6bVDuVyxvu4rDMQ Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32d6ksn367-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jul 2020 04:43:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06M4c1gw050446;
        Wed, 22 Jul 2020 04:43:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32eberxs2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jul 2020 04:43:47 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06M4SXO6017325;
        Wed, 22 Jul 2020 04:28:34 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 21:28:33 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, Steev Klimaszewski <steev@kali.org>,
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
Date:   Wed, 22 Jul 2020 00:28:29 -0400
Message-Id: <159539205429.31352.16564389172198122676.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710072013.177481-1-ebiggers@kernel.org>
References: <20200710072013.177481-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007220032
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 10 Jul 2020 00:20:07 -0700, Eric Biggers wrote:

> This patchset implements UFS inline encryption support on the
> DragonBoard 845c, using the Qualcomm Inline Crypto Engine (ICE)
> that's present on the Snapdragon 845 SoC.
> 
> This is based on top of scsi/5.9/scsi-queue, which contains the
> ufshcd-crypto patches by Satya Tangirala.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/5] scsi: firmware: qcom_scm: Add support for programming inline crypto keys
      https://git.kernel.org/mkp/scsi/c/e10d24786adb
[2/5] scsi: ufs-qcom: Name the dev_ref_clk_ctrl registers
      https://git.kernel.org/mkp/scsi/c/12700db4f9f7
[4/5] scsi: ufs: Add program_key() variant op
      https://git.kernel.org/mkp/scsi/c/a5fedfacb402
[5/5] scsi: ufs-qcom: Add Inline Crypto Engine support
      https://git.kernel.org/mkp/scsi/c/de9063fbd769

-- 
Martin K. Petersen	Oracle Linux Engineering
