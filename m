Return-Path: <linux-fscrypt+bounces-301-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AA38FA76F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 03:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E39228103A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 01:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356628F54;
	Tue,  4 Jun 2024 01:18:00 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D146FD5;
	Tue,  4 Jun 2024 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717463880; cv=none; b=UXcd/lXO43be06IRnhPj+9hfYXmzpGEhzaFhV/hl4pClP8vw6sXE+R5vaFIdKitHA5hIRkR5kui3yD25esK73AxLui3FAx7Ml5cj4ZHVRF4Nx0uXBm/uLXt/m1ngGLWx+C/EJEoeFtMRqaHEIt8kI/jherNADAlJSA1n9kxtMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717463880; c=relaxed/simple;
	bh=OzRQPXtvsFdD9jyp6q+9LTW2h0h6y9O369n2NTJKpDE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKb5g+0H4C3YkGsT6ZHnaKu9jOzKcdak4VM9Cb7uFD3CXiqQrWCZU5ZzwlNeVSH4EYGpj7c+qS3p101K1mGWYzEZsyT5pHP9Z0Kbi1Za8V1NuqNYprwNFtuPTLoHdKUHEqh7GmmEzsriBybFt4eTxnBS9TWZY2SHOvU6rI6WCs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 453NrBxt028282;
	Mon, 3 Jun 2024 18:17:24 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yg35f24n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 03 Jun 2024 18:17:24 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 18:17:23 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 18:17:18 -0700
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
Date: Tue, 4 Jun 2024 09:17:17 +0800
Message-ID: <20240604011718.3360272-1-lizhi.xu@windriver.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87plsym65w.fsf@mailhost.krisman.be>
References: <87plsym65w.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: gfcExZLBCFyH3mjBVyUMLZjSXIlULXV0
X-Proofpoint-ORIG-GUID: gfcExZLBCFyH3mjBVyUMLZjSXIlULXV0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 mlxscore=0 phishscore=0
 clxscore=1011 malwarescore=0 spamscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2406040008

On Mon, 03 Jun 2024 10:50:51 -0400, Gabriel Krisman Bertazi wrote:
> > When mounting the ext4 filesystem, if the hash version and casefolded are not
> > consistent, exit the mounting.
> >
> > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/ext4/super.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index c682fb927b64..0ad326504c50 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >  		goto failed_mount;
> >  
> >  	ext4_hash_info_init(sb);
> > +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
> > +	    !ext4_has_feature_casefold(sb)) {
> 
> Can we ever have DX_HASH_SIPHASH set up in the super block?  I thought
> it was used solely for directories where ext4_hash_in_dirent(inode) is
> true.
The value of s'def_hash_version is obtained by reading the super block from the
buffer cache of the block device in ext4_load_super().
> 
> If this is only for the case of a superblock corruption, perhaps we
> should always reject the mount, whether casefold is enabled or not?
Based on the existing information, it cannot be confirmed whether the superblock
is corrupt, but one thing is clear: if the default hash version of the superblock
is set to DX_HASH_SIPHASH, but the casefold feature is not set at the same time,
it is definitely an error.

Lizhi

