Return-Path: <linux-fscrypt+bounces-299-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E478D6F83
	for <lists+linux-fscrypt@lfdr.de>; Sat,  1 Jun 2024 13:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A8091F21930
	for <lists+linux-fscrypt@lfdr.de>; Sat,  1 Jun 2024 11:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27ED824AA;
	Sat,  1 Jun 2024 11:38:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8419335A7;
	Sat,  1 Jun 2024 11:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717241911; cv=none; b=XfDPAPtoDc4DmSEUX+km/HvakQaOldDVsOA1f8ypyWvloE6RkxsQIwlVCpxLKKhBmFXHGtbbgCTrxn3VIzgdb+6vnmDZO7E20/aLRczJbv3wFv4yYZFz/EALMHcFea39PE7G9jlVcMkKNNeAPqtf2062D2glwDLPpFdEWtkA2sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717241911; c=relaxed/simple;
	bh=uAJlqDMiuKeV1HJo6t1t12QkEwDuIC/XqQuiy4tqFGg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYvWJ1UL/j4itSc6sOp2xSj7wVOXXyNVNXLHEEqEzPITMMPv5afzPOoYJax2sy4ifRxBkkHRabRnqNGPl7SNl3JB5R8aBhNpvq38g8ngami6kBpEWCVUU/Fag4svCcG902G63V+mz031DkNUvX18mEMy+I5cGZtRGKdy+OdhrPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 451Ao3b6025787;
	Sat, 1 Jun 2024 11:37:57 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yfrux8a77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sat, 01 Jun 2024 11:37:56 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 1 Jun 2024 04:37:55 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Sat, 1 Jun 2024 04:37:50 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <lkp@intel.com>
CC: <coreteam@netfilter.org>, <davem@davemloft.net>, <ebiggers@kernel.org>,
        <fw@strlen.de>, <jaegeuk@kernel.org>, <kadlec@netfilter.org>,
        <kuba@kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <llvm@lists.linux.dev>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>,
        <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
Subject: [PATCH V5] ext4: check hash version and filesystem casefolded consistent
Date: Sat, 1 Jun 2024 19:37:49 +0800
Message-ID: <20240601113749.473058-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531185519.GB1153@sol.localdomain>
References: <20240531185519.GB1153@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SajYroC-HqTmjkX9D0lmFQznohzPr4mF
X-Proofpoint-GUID: SajYroC-HqTmjkX9D0lmFQznohzPr4mF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-01_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406010091

When mounting the ext4 filesystem, if the hash version and casefolded are not
consistent, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ext4/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c682fb927b64..0ad326504c50 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount;
 
 	ext4_hash_info_init(sb);
+	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
+	    !ext4_has_feature_casefold(sb)) {
+		err = -EINVAL;
+		goto failed_mount;
+	}
 
 	err = ext4_handle_clustersize(sb);
 	if (err)
-- 
2.43.0


