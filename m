Return-Path: <linux-fscrypt+bounces-291-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D588D58E1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 05:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C99D8B23139
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 03:08:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4F178C66;
	Fri, 31 May 2024 03:08:08 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A5F36134;
	Fri, 31 May 2024 03:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717124888; cv=none; b=TswiXIjgVi/3FdCXLIIYFsFEpQ9jAQdp8UeXTMNmoezkOOkDDx9xruVkSTKLuvcByABGY70CEs/CrrEqkoKMMxz/O3XJXXB4LrGcqTjaJCoLsAlCtnw7/MSMiRiqGGtrQAXk4Nd9bTl7faQWe9VS4eG2JIRKspCBT5L5vJvsMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717124888; c=relaxed/simple;
	bh=YRSUgk6swjRvnBPRLMjfQT2uYJPFNmeIsKM0ICz4PlU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFoIluQIPdQERnOzP7FNpK3wvdlwpESuenUL9au7FAvhsXUpcZcH0LbEMFniXohKDLBRnw1ztadket32adhvr92BDXPKTalNqHMvuHCB6D/lChj/jV4EAa46I9Yr4Hhu6snmTOQENn/YPEmctZYan9q28sP4WX65MzmQYnd2NZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44V2wIL9001103;
	Thu, 30 May 2024 20:07:50 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yf5pd80wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 30 May 2024 20:07:50 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 20:07:45 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 20:07:41 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <ebiggers@kernel.org>
CC: <coreteam@netfilter.org>, <davem@davemloft.net>, <fw@strlen.de>,
        <jaegeuk@kernel.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizhi.xu@windriver.com>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: [PATCH V2] ext4: add casefolded feature check before setup encrypted info
Date: Fri, 31 May 2024 11:07:40 +0800
Message-ID: <20240531030740.1024475-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531010513.GA9629@sol.localdomain>
References: <20240531010513.GA9629@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: yI9wjQvpvni-JHf5Al8qA9yHzSaM7lnS
X-Proofpoint-ORIG-GUID: yI9wjQvpvni-JHf5Al8qA9yHzSaM7lnS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2405310023

Due to the current file system not supporting the casefolded feature, only 
i_crypt_info was initialized when creating encrypted information, without actually
setting the sighash. Therefore, when creating an inode, if the system does not 
support the casefolded feature, encrypted information will not be created.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ext4/ialloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e9bbb1da2d0a..47b75589fdf4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -983,7 +983,8 @@ struct inode *__ext4_new_inode(struct mnt_idmap *idmap,
 		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
 
 	if (!(i_flags & EXT4_EA_INODE_FL)) {
-		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
+		if (ext4_has_feature_casefold(inode->i_sb))
+			err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
 		if (err)
 			goto out;
 	}
-- 
2.43.0


