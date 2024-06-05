Return-Path: <linux-fscrypt+bounces-306-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C56FA8FC13D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jun 2024 03:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54E9FB22316
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jun 2024 01:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40552BCF6;
	Wed,  5 Jun 2024 01:24:19 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6268333F7;
	Wed,  5 Jun 2024 01:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717550659; cv=none; b=hi0PILRaQuB3O4Gmu1WCxyXjTBfeD9hjhvCOt5oPdaepT4JwxhToqS1Cag/2ho+n6cj3uZ8xUdR4WUX2zKSMK07NL737qPLCaHE47KIbYnsZ8xlCVAsUn91HaDF6EPmm/Jr+IY0VL79znGMJkAalN4qfgk6VJUTjIMWUlJO3o1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717550659; c=relaxed/simple;
	bh=Id9sImMrkS3WBgztVALbU9ktfSbg5X5ksatQi+bWftI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enZ/MAMrr7f8+icfgLIJOaiReoj5L86AFgWk2PzYlBY2CAz2IItkxNWpM7f9ehomOjCbRHtWcpivRJ22Erzk44Q9n/zWUNs/TVDPSW0ugTpxnjTzYHiD3l2bmS/QJ5y3za22WhIk4VoexmolrRthpniZoe5V2qA9C2XmjEpeHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4550LIkK016063;
	Tue, 4 Jun 2024 18:23:44 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yg35f3a8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 04 Jun 2024 18:23:44 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 18:23:43 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 18:23:36 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <krisman@suse.de>
CC: <adilger.kernel@dilger.ca>, <coreteam@netfilter.org>,
        <davem@davemloft.net>, <ebiggers@kernel.org>, <fw@strlen.de>,
        <jaegeuk@kernel.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizhi.xu@windriver.com>,
        <lkp@intel.com>, <llvm@lists.linux.dev>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <oe-kbuild-all@lists.linux.dev>,
        <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: [PATCH V6] fs/ext4: Filesystem without casefold feature cannot be mounted with spihash
Date: Wed, 5 Jun 2024 09:23:35 +0800
Message-ID: <20240605012335.44086-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87le3kle87.fsf@mailhost.krisman.be>
References: <87le3kle87.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 2upWjM2V16NiGPCPyDb6ZG4I8yCG6TLl
X-Proofpoint-ORIG-GUID: 2upWjM2V16NiGPCPyDb6ZG4I8yCG6TLl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406050009

When mounting the ext4 filesystem, if the default hash version is set to 
DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ext4/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c682fb927b64..d0645af3e66e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3593,6 +3593,14 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			 "mounted without CONFIG_UNICODE");
 		return 0;
 	}
+#else
+	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
+	    !ext4_has_feature_casefold(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem without casefold feature cannot be "
+			 "mounted with spihash");
+		return 0;
+	}
 #endif
 
 	if (readonly)
-- 
2.43.0


