Return-Path: <linux-fscrypt+bounces-305-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B79818FC134
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jun 2024 03:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79F752834A4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Jun 2024 01:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067644414;
	Wed,  5 Jun 2024 01:17:24 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D75A2107;
	Wed,  5 Jun 2024 01:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717550243; cv=none; b=Gz0in5xG7w4wu6SqJ8afpSZTxUmnWAwUtKtnuUYJParsDb6TjpxijvFsvzyovfwl4QXjlqaFxVZlI+EbzmC/ypgzNwlC43BRm0Y3bJbvYPDZNKvKfRjsiMOHTAU+0bpvCGlKLvhpMoZrlyOHL+LhOd/Q0CtvHLMWWLfhSqu4NhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717550243; c=relaxed/simple;
	bh=HLpoLdstnucicsvT5jMONV0hC5aA5fX3wp6EmkQr7ro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fey+Z0FdNFjJnP/PlhgyizvOAQQOCH9ITAykAYr+OzlvvtzJ6XTiiOFO8rTolNebV5MfgI/ht96LyJWlB3iWuM2wqQwz+oPua4wawxSwgLbBy5Cx78aj3ydNELa2OmmOx/+LaYi97RdOWnb1JpnyzOyiJamhDEODBBhj+XRVzmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45518rnG006051;
	Wed, 5 Jun 2024 01:16:52 GMT
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yfruxbkk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 05 Jun 2024 01:16:52 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 4 Jun 2024 18:16:51 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Tue, 4 Jun 2024 18:16:45 -0700
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
Subject: Re: [PATCH V5] ext4: check hash version and filesystem casefolded consistent
Date: Wed, 5 Jun 2024 09:16:44 +0800
Message-ID: <20240605011644.1878-1-lizhi.xu@windriver.com>
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
X-Proofpoint-ORIG-GUID: eSwt-QjaTDEty4IdYCpGVD27kbz6EKap
X-Proofpoint-GUID: eSwt-QjaTDEty4IdYCpGVD27kbz6EKap
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-04_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406050008

On Tue, 04 Jun 2024 15:06:32 -0400, Gabriel Krisman Bertazi wrote:
> >> > When mounting the ext4 filesystem, if the hash version and casefolded are not
> >> > consistent, exit the mounting.
> >> >
> >> > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> >> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> >> > ---
> >> >  fs/ext4/super.c | 5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> >
> >> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> > index c682fb927b64..0ad326504c50 100644
> >> > --- a/fs/ext4/super.c
> >> > +++ b/fs/ext4/super.c
> >> > @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >> >  		goto failed_mount;
> >> >  
> >> >  	ext4_hash_info_init(sb);
> >> > +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
> >> > +	    !ext4_has_feature_casefold(sb)) {
> >> 
> >> Can we ever have DX_HASH_SIPHASH set up in the super block?  I thought
> >> it was used solely for directories where ext4_hash_in_dirent(inode) is
> >> true.
> > The value of s'def_hash_version is obtained by reading the super block from the
> > buffer cache of the block device in ext4_load_super().
> 
> Yes, I know.  My point is whether this check should just be:
Based on the existing information, it cannot be confirmed that it is incorrect
to separately determine the value of s_def_hash_version as DX_HASH_SIPHASH.
Additionally, I have come up with a better solution, and I will issue the next
fixed version in a while.
> 
> if (es->s_def_hash_version == DX_HASH_SIPHASH)
> 	goto failed_mount;
> 
> Since, IIUC, DX_HASH_SIPHASH is done per-directory and not written to
> the sb.
> 
> >> If this is only for the case of a superblock corruption, perhaps we
> >> should always reject the mount, whether casefold is enabled or not?
> > Based on the existing information, it cannot be confirmed whether the superblock
> > is corrupt, but one thing is clear: if the default hash version of the superblock
> > is set to DX_HASH_SIPHASH, but the casefold feature is not set at the same time,
> > it is definitely an error.

Lizhi

