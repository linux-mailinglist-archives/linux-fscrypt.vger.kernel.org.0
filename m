Return-Path: <linux-fscrypt+bounces-289-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24ABE8D585F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 03:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C44D2282ADC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 May 2024 01:48:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3903EAF9;
	Fri, 31 May 2024 01:48:12 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C18134AB;
	Fri, 31 May 2024 01:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717120092; cv=none; b=NBZ81qT9wc5HVrHeGgnf+Nz7+6Xu4bJT+1j2NHUyy4gMmL3+XoBuCsrbQ/bLKfjGgvRZbeR0bd4M/X7jTSX6mj65odlrz2uNiFg4pqSy/OfcYjbH98qIM72Sap3mM6Sjhvx77DIgy6BtT29pRbS1nua7BeDXqlF7fvCegWaT/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717120092; c=relaxed/simple;
	bh=XXFs9+w+leXFOGcTVJZF03joneWjmglFEMPKRibsnIM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KhKhWsabNk3eGhwU8uJE//AuRoDgDEX+JzMkMMttOcVkrHQKpee2EbNYA8BPMK77wabddG/YLp1ylvAIh/MbUCtRbNIO3ERrvM8GnXhKGQv/LTInYwbi3MP2935V5DS1YDvQjntYVwBAjwcgi+C2Fx/7uaiaJNHb91MhZrkMSnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44V1l1oB006715;
	Thu, 30 May 2024 18:47:52 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3yf56c0023-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 30 May 2024 18:47:52 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 18:47:51 -0700
Received: from pek-lpd-ccm6.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 18:47:48 -0700
From: Lizhi Xu <lizhi.xu@windriver.com>
To: <ebiggers@kernel.org>
CC: <coreteam@netfilter.org>, <davem@davemloft.net>, <fw@strlen.de>,
        <jaegeuk@kernel.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizhi.xu@windriver.com>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>,
        <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
        <syzkaller-bugs@googlegroups.com>, <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add casefolded file check
Date: Fri, 31 May 2024 09:47:47 +0800
Message-ID: <20240531014747.1386219-1-lizhi.xu@windriver.com>
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
X-Proofpoint-ORIG-GUID: IR-rrk4oZSkM4-YLtYKV04o7RY55hJG5
X-Proofpoint-GUID: IR-rrk4oZSkM4-YLtYKV04o7RY55hJG5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-30_21,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 mlxlogscore=957 lowpriorityscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.21.0-2405170001 definitions=main-2405310013

On Thu, 30 May 2024 18:05:13 -0700, Eric Biggers wrote:
> > The file name that needs to calculate the siphash must have both flags casefolded
> > and dir at the same time, so before calculating it, confirm that the flag meets
> > the conditions.
> >
> > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> > ---
> >  fs/ext4/hash.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
> > index deabe29da7fb..c8840cfc01dd 100644
> > --- a/fs/ext4/hash.c
> > +++ b/fs/ext4/hash.c
> > @@ -265,6 +265,10 @@ static int __ext4fs_dirhash(const struct inode *dir, const char *name, int len,
> >  		__u64	combined_hash;
> >
> >  		if (fscrypt_has_encryption_key(dir)) {
> > +			if (!IS_CASEFOLDED(dir)) {
> > +				ext4_warning_inode(dir, "Siphash requires Casefolded file");
> > +				return -2;
> > +			}
> >  			combined_hash = fscrypt_fname_siphash(dir, &qname);
> >  		} else {
> >  			ext4_warning_inode(dir, "Siphash requires key");
> 
> First, this needs to be sent to the ext4 mailing list (and not to irrelevant
> mailing lists such as netdev).  Please use ./scripts/get_maintainer.pl, as is
> recommended by Documentation/process/submitting-patches.rst.
> 
> Second, ext4 already checks for the directory being casefolded before allowing
> siphash.  This is done by dx_probe().  Evidently syzbot found some way around
> that, so what needs to be done is figure out why that happened and what is the
> best fix to prevent it.  This is not necessarily the patch you've proposed, as
> the real issue might actually be a missing check at some earlier time like when
> reading the inode from disk or when mounting the filesystem.
I have confirmed that there is no casefolded feature when creating the directory.
I agree with your statement that it should be checked for casefold features when
mounting or reading from disk.

Lizhi

