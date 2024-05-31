Return-Path: <linux-fscrypt+bounces-295-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B7438D5D4E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 10:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4095FB224DA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 08:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1275C155740;
	Fri, 31 May 2024 08:57:08 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EA843154;
	Fri, 31 May 2024 08:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145828; cv=none; b=paP0dVHoklQ2o2GtqvRbACJSPW+6aaNFjal8RNod+Jv7pUmAH1+SS2iBqKhz0dDUSyyrQ/qG7vRsAjw6A2D+Xhh1QeW0/jVXJ3goSEjHKit6JAboSbX4aLWDzSkDaT/ROjO8GSd3YPnA4F7LiV9KZlj8BS5qDWkVe6p5rvkka0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145828; c=relaxed/simple;
	bh=kPaFz5uK0ZOx/rIMQz/T/Y/SU8NEW+MLiaH5hug2usI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PkG6KFxOVBkAHc7mrtzu5bELm+so2l9OJVK2/cc6YtR0ZJtynLv1rg0A5su0ndwLhKW3NRigOE3Ko/fT0e5LK7NZJkJcP3NMsFeD4a39kC+DObrPsatIcjFYEla6FVCSnxPlwEErMzJ3thUOvLN3z0tAwOtgu0GqTujVyWF2jeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44V4tQal022085;
	Fri, 31 May 2024 08:56:54 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yf5ydg88n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 31 May 2024 08:56:53 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 01:56:52 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 01:56:48 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <ebiggers@kernel.org>
CC: <adilger.kernel@dilger.ca>, <coreteam@netfilter.org>,
        <davem@davemloft.net>, <fw@strlen.de>, <jaegeuk@kernel.org>,
        <kadlec@netfilter.org>, <kuba@kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: [PATCH V3] ext4: check hash version and filesystem casefolded consistent
Date: Fri, 31 May 2024 16:56:47 +0800
Message-ID: <20240531085647.2918240-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531033407.GB6505@sol.localdomain>
References: <20240531033407.GB6505@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BCm3wry5b9WNN3q2iVIUrHzGri0mMOPg
X-Proofpoint-GUID: BCm3wry5b9WNN3q2iVIUrHzGri0mMOPg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2405310066

When mounting the ext4 filesystem, if the hash version and casefolded are not
consistent, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ext4/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c682fb927b64..c0036e3922c2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5262,6 +5262,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount;
 
 	ext4_hash_info_init(sb);
+	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
+	    !ext4_has_feature_casefold(sb))
+		goto failed_mount;
 
 	err = ext4_handle_clustersize(sb);
 	if (err)
-- 
2.43.0


