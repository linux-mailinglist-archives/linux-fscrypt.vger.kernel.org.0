Return-Path: <linux-fscrypt+bounces-287-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DAF58D4644
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 May 2024 09:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9886E1C209E4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 May 2024 07:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C87D94D8C1;
	Thu, 30 May 2024 07:42:24 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F76E4D8A0;
	Thu, 30 May 2024 07:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717054944; cv=none; b=T/W1eDJyk3dURom6n4cqGgGk4KALgyiolEw7aKD4NyuiD2TkyHMnNEelti6lGnTVEEOcjyuNTzycosUTcVyqeJHhPAGoGr9/QMw70wb8AbwpPSmWPUIj23Ygg5Zw7tlZmjLfFL3STXgmddVqK1vc4zg/v7aalCpNzip2MNrO6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717054944; c=relaxed/simple;
	bh=8uoD/V2i37e3JmvFLHSLBq47Yqkgg/BVRFHFyUcAgrY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXH9KNEnaJoujgjfTw/G8XKt+yW9SoeNk/0wx61JvJuWJhXRPns7bqsNB81Ct9KIqJv8ZTprF6W/rdQGnuTVxcIpzBvkxow7xK7FKsfR85u1GfaPe98uJ4C02KIkZi9HNiTn4IGunsz+LQ+hawnqA52RMb4ErWUZ+kJMa2wEXt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44U4YDEi020808;
	Thu, 30 May 2024 07:41:55 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yeg6y06f9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 30 May 2024 07:41:55 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 00:41:54 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 00:41:50 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>
CC: <coreteam@netfilter.org>, <davem@davemloft.net>, <ebiggers@kernel.org>,
        <fw@strlen.de>, <jaegeuk@kernel.org>, <kadlec@netfilter.org>,
        <kuba@kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: [PATCH] ext4: add casefolded file check
Date: Thu, 30 May 2024 15:41:50 +0800
Message-ID: <20240530074150.4192102-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <000000000000cb987006199dc574@google.com>
References: <000000000000cb987006199dc574@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: txGjbBsQOy1SHcZr1cFeLXbYh8MlTv1w
X-Proofpoint-GUID: txGjbBsQOy1SHcZr1cFeLXbYh8MlTv1w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_05,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405300056

The file name that needs to calculate the siphash must have both flags casefolded
and dir at the same time, so before calculating it, confirm that the flag meets
the conditions.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
---
 fs/ext4/hash.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index deabe29da7fb..c8840cfc01dd 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -265,6 +265,10 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
 		__u64	combined_hash;
 
 		if (fscrypt_has_encryption_key(dir)) {
+			if (!IS_CASEFOLDED(dir)) {
+				ext4_warning_inode(dir, "Siphash requires Casefolded file");
+				return -2;
+			}
 			combined_hash = fscrypt_fname_siphash(dir, &qname);
 		} else {
 			ext4_warning_inode(dir, "Siphash requires key");
-- 
2.43.0


