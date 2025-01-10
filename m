Return-Path: <linux-fscrypt+bounces-584-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F52A09D0E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 22:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D2F3A78F7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2025 21:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A761A222594;
	Fri, 10 Jan 2025 21:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="alymwtPW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403821506D;
	Fri, 10 Jan 2025 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543876; cv=none; b=rhGAwPnsD7PCyaCYqj8win2vN6b3G9yqHIB1awk/RvzLP9+sVMlJheHWV9gzaHsLdXE8kRYiRH1xc1M8WVRnTUYySuxnHq+C7QsF0QimSUHuLjUV7ff8vKepEAK0vPR58qmyFKC/AkPbwXq3KzhKFXdEor7Es892+FSMkyWoMhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543876; c=relaxed/simple;
	bh=gHTVtfqFaTl7kz/Aqg4ejB+gR6umXsXipAaIlpaZrss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dyQxVmQtfDJL/iG0tj7UeQRZ/UXiWTBGKUGrRSOZ4K2fImM4X6QBIXCCGpYdwZ9kYCh8V56G4p2ch0y5fENt7uCHDuSdPV1AutFSTyJZHBsvMwtUJvccUGxmsmXDVQ9v0UXrjTYdS5eN9ETvCd6sObs6VCpNMCgtY1sdZ3WdvMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=alymwtPW; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBw3H022284;
	Fri, 10 Jan 2025 21:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ajGyttwmIKtn5/bP/iQzmbsjuv7wkTTYbWgojMBY5Lo=; b=
	alymwtPWo/Aa6GaIoOEB1dotH9qAXc9sw1nafmX2o3cheLtUSxD9DbliFnqquIOl
	mM4e3yzamBPWDFto4xs2f+4Q0Yr1u3dzd20DazV+8JD/RK/PDA7AqSPOLm5G60bq
	ER0BAv5LgXgqfMjDH45g+Ihvl/rIQ51j/QO1spohV7lmKusXuVlsqxuEfZZEScVA
	G8wALYVns7zEliH/6DML4qkEMMbvmjX0zWQujxJ13fEKlTs1cu/BLG42yA6dVx0v
	1YfpuZg3zjpa0vbrmwqKTl/+f4spLZK0RSn3kpB3rFhWvAvsxp+OMSmfZdmMkbGX
	8eQtqklXupnyHZEnNLaacw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc0su-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKnpxi027091;
	Fri, 10 Jan 2025 21:17:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:30 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ1s034137;
	Fri, 10 Jan 2025 21:17:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-3;
	Fri, 10 Jan 2025 21:17:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: (subset) [PATCH v10 00/15] Support for hardware-wrapped inline encryption keys
Date: Fri, 10 Jan 2025 16:16:45 -0500
Message-ID: <173654330182.638636.6890747703522161816.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: r9072SpeA4o0_1k9_Mso4XzKCRb-DUpt
X-Proofpoint-GUID: r9072SpeA4o0_1k9_Mso4XzKCRb-DUpt

On Thu, 12 Dec 2024 20:19:43 -0800, Eric Biggers wrote:

> This patchset is based on next-20241212 and is also available in git via:
> 
>     git fetch https://git.kernel.org/pub/scm/fs/fscrypt/linux.git wrapped-keys-v10
> 
> This patchset adds support for hardware-wrapped inline encryption keys, a
> security feature supported by some SoCs.  It adds the block and fscrypt
> framework for the feature as well as support for it with UFS on Qualcomm SoCs.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[02/15] ufs: crypto: add ufs_hba_from_crypto_profile()
        https://git.kernel.org/mkp/scsi/c/75d0c649eca4
[03/15] ufs: qcom: convert to use UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
        https://git.kernel.org/mkp/scsi/c/30b32c647cf3
[04/15] ufs: crypto: remove ufs_hba_variant_ops::program_key
        https://git.kernel.org/mkp/scsi/c/409f21010d92

-- 
Martin K. Petersen	Oracle Linux Engineering

