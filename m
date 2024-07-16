Return-Path: <linux-fscrypt+bounces-355-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CE1931ED6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jul 2024 04:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8DADDB21D8D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jul 2024 02:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FB115491;
	Tue, 16 Jul 2024 02:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JhYulX4l"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9597E14265;
	Tue, 16 Jul 2024 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721097019; cv=none; b=d18bq2g0AyfhbN0fltpD/rkNeClNdHfSDG6es2gQM2PUqi8CP2U+VCGXNcNTJ4CwIFnZ1eTWR1CgAcIXlogK9vwWQ84JKU+9V12Jlf7Phgdq7Nf11pJhAOFsPrVc8b4w5LgWINE6GXHxTM7b7vMdKAotWrg3eYvoOiIjjgzBn3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721097019; c=relaxed/simple;
	bh=r7BeG+M7Wb2IqW/43sFe+cgMEddiFYxRW4MoQrVWLFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4K6bEkwSBi/3SzlwDoPfRapFxPfsnGe4baU3orB4/s9p3zbwWUHsCOycDdjkBUW7Maxh49quzIb5RvRl0jrflLwmMP/eZIMGDUW2I5Wv6iWtDbmJCQt4hZOp5sgnfoxWdAGYzt2izMbWMcnXpWVVCVUOJw79TWggFvPZGQ6nds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JhYulX4l; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FLAEYu002966;
	Tue, 16 Jul 2024 02:30:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=NVIMiyPj9Tna6v8yf6ZmHWlzRGDvugihZRaZDMrV3ac=; b=
	JhYulX4lGSeslrXQ31oUkf0RjkywUlwQtyTQHEoQN7uacsrs0hsnVb2uC4KOjG+4
	kkhQmQDYBoa5J3FjZ/Tmq3kyNMq7UDEib1dGa9ZioIhqc3K50hwPMKEVh1JeUzgf
	lRTxZjj6DIGGeJtO9cXHTqy3MWfdooFineiSTq+7C1upURsJiTawyi1KQNshijz0
	yQC1MQIrParfis93zmo2Ue0aiXBhXvbn3WsHJ5lPI6rXineieNKed2+WzKpOBvB2
	BkgR/p5fgF6I3MY/g9ZbSVEHuNQlsEmwGf3pd6oKw8QhUYh12dDWu73s6GCXjkS3
	5XU2qVPeXYe2leYC08M4Lw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bh6svney-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G196Oq002613;
	Tue, 16 Jul 2024 02:30:04 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg1exxd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:04 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46G2U3A7027682;
	Tue, 16 Jul 2024 02:30:04 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40bg1exxah-2;
	Tue, 16 Jul 2024 02:30:04 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-samsung-soc@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
        William McVicker <willmcvicker@google.com>
Subject: Re: [PATCH v3 0/6] Basic inline encryption support for ufs-exynos
Date: Mon, 15 Jul 2024 22:29:21 -0400
Message-ID: <172109323557.941202.10485953221148966734.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240708235330.103590-1-ebiggers@kernel.org>
References: <20240708235330.103590-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=669 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160018
X-Proofpoint-GUID: diyzOwlsDqqhjvI7WSuySuffOQT2BrUI
X-Proofpoint-ORIG-GUID: diyzOwlsDqqhjvI7WSuySuffOQT2BrUI

On Mon, 08 Jul 2024 16:53:24 -0700, Eric Biggers wrote:

> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.
> 
> Specifically, add support for the "traditional FMP mode" that works on
> many Exynos-based SoCs including gs101.  This is the mode that uses
> "software keys" and is compatible with the upstream kernel's existing
> inline encryption framework in the block and filesystem layers.  I plan
> to add support for the wrapped key support on gs101 at a later time.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/6] scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
      https://git.kernel.org/mkp/scsi/c/c2a90eee29f4
[2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into its caller
      https://git.kernel.org/mkp/scsi/c/ec99818afb03
[3/6] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE
      https://git.kernel.org/mkp/scsi/c/e95881e0081a
[4/6] scsi: ufs: core: Add fill_crypto_prdt variant op
      https://git.kernel.org/mkp/scsi/c/8ecea3da1567
[5/6] scsi: ufs: core: Add UFSHCD_QUIRK_KEYS_IN_PRDT
      https://git.kernel.org/mkp/scsi/c/4c45dba50a37
[6/6] scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)
      https://git.kernel.org/mkp/scsi/c/c96499fcb403

-- 
Martin K. Petersen	Oracle Linux Engineering

