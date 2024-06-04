Return-Path: <linux-fscrypt+bounces-303-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B899A8FAEF5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 11:37:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E894C1C209C3
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 09:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DB83143C41;
	Tue,  4 Jun 2024 09:37:17 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BBB8BFA;
	Tue,  4 Jun 2024 09:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493837; cv=none; b=qmlYNHPMgakT94u2cbPrg/UPkOpoVbGZLBoYrUNcibQqA1j1AjvrqUf/b1ihZlQKZWolyAymzrMpvIReCaSIgqRoRPdRKOqorgpYBP+WmJfR7nfh+jN6n0ZhFDB56WCUvOBc6SHrmDuSQcJF/Qy5bVQ6V0Lq1XJh4PiWl7nY/C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493837; c=relaxed/simple;
	bh=af2fEpd+Md2eU+XT2qqgm8Gs0Ji9V0aPy63zg4vev+o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r81VgLweyEuOobj0/eb0sIJkEkevhYgqJuD6lFKXCZ1+IfudEuo3S/NZrGEw8Yf8fd2jXUvdS0t6Pvd73jhhXs3FI3dqHF/Ka3SlihnKWE7woJeRvtnIVErdNPXtcTg897AI6ud9cxreCFjZb4GAqpbYnonTqSuibaonwjfEbyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4549UYmV011658;
	Tue, 4 Jun 2024 09:36:43 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yfruxat3p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jun 2024 09:36:42 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 02:36:41 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 02:36:36 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <dan.carpenter@linaro.org>
CC: <adilger.kernel@dilger.ca>, <coreteam@netfilter.org>,
        <davem@davemloft.net>, <ebiggers@kernel.org>, <fw@strlen.de>,
        <jaegeuk@kernel.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <lkp@intel.com>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>,
        <oe-kbuild@lists.linux.dev>, <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: Re: [PATCH V3] ext4: check hash version and filesystem casefolded consistent
Date: Tue, 4 Jun 2024 17:36:35 +0800
Message-ID: <20240604093635.538480-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <638bf33d-7ab0-4ff0-aece-ab877cff1694@moroto.mountain>
References: <638bf33d-7ab0-4ff0-aece-ab877cff1694@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mq-ShY-sh6m8qUd6uHmR57w9omC2Phuz
X-Proofpoint-GUID: mq-ShY-sh6m8qUd6uHmR57w9omC2Phuz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_03,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406040077

On Tue, 4 Jun 2024 12:27:06 +0300, Dan Carpenter wrote: 
> kernel test robot noticed the following build warnings:
> 
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Lizhi-Xu/ext4-check-hash-version-and-filesystem-casefolded-consistent/20240531-170046
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
> patch link:    https://lore.kernel.org/r/20240531085647.2918240-1-lizhi.xu%40windriver.com
> patch subject: [PATCH V3] ext4: check hash version and filesystem casefolded consistent
> config: i386-randconfig-141-20240601 (https://download.01.org/0day-ci/archive/20240602/202406020752.Ii2MU4KP-lkp@intel.com/config)
> compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202406020752.Ii2MU4KP-lkp@intel.com/
> 
> smatch warnings:
> fs/ext4/super.c:5287 __ext4_fill_super() warn: missing error code 'err'
> 
> vim +/err +5287 fs/ext4/super.c
> 
> d4fab7b28e2f5d7 Theodore Ts'o           2023-04-27  5280  	err = ext4_block_group_meta_init(sb, silent);
> d4fab7b28e2f5d7 Theodore Ts'o           2023-04-27  5281  	if (err)
> 0d1ee42f27d30ee Alexandre Ratchov       2006-10-11  5282  		goto failed_mount;
> 0b8e58a140cae2b Andreas Dilger          2009-06-03  5283
> db9345d9e6f075e Jason Yan               2023-03-23  5284  	ext4_hash_info_init(sb);
> 66b3f078839bbdb Lizhi Xu                2024-05-31  5285  	if (es->s_def_hash_version == DX_HASH_SIPHASH &&
> 66b3f078839bbdb Lizhi Xu                2024-05-31  5286  	    !ext4_has_feature_casefold(sb))
> 66b3f078839bbdb Lizhi Xu                2024-05-31 @5287  		goto failed_mount;
This warning has been resolved in the following patch: 
https://lore.kernel.org/all/20240601113749.473058-1-lizhi.xu@windriver.com/

Lizhi

