Return-Path: <linux-fscrypt+bounces-370-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 071CF96DCBB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Sep 2024 16:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 361F41C21430
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Sep 2024 14:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6728F1A01C5;
	Thu,  5 Sep 2024 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="SZ8wiUoc"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8364C634
	for <linux-fscrypt@vger.kernel.org>; Thu,  5 Sep 2024 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725548075; cv=none; b=a+XBv1GLc25MV/Z+kDeaai9AXoy1SoynnVSrom7tZl1ilhyrWqN8xXhYUk5SSB6D5+UwSQFE7t+Mk9b0aaISrfXUvZRHgIX6wMPdbDzUfAyUXysR6lmQyJ57ww1L9bzMRDv77DQD26QkMoGnZ+6qfIj7+jwbddXX9bN1NtPjs5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725548075; c=relaxed/simple;
	bh=hQXOjtem9QT9NkzuckCjeRjdSYhJcKGqfmHQV5n2Xts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IhODw4vBy7SKyFECGPnrphAhp9ezxsPXJBJ+M85ZWjvpgcSLOe/5npbv6QfM/riOfWMFxAf2Z/OM0DHF15GOQXZxwj6XP6uYkrjniM08SPEeQZVMrVMA/RX1LG7vEAsu0gJMKLr73WGfI9JkKgvvvgGCrb1w4CggpIbqVST9P2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=SZ8wiUoc; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from cwcc.thunk.org (pool-173-48-102-194.bstnma.fios.verizon.net [173.48.102.194])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 485Ers2g004660
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 5 Sep 2024 10:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1725548041; bh=dvurbpJwB8Tw+mYM9BXpV2kEkmbOWYuTyKXwPTQf+K4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=SZ8wiUoc6OsaYUZaBr/28CTxYn8KmxOhfXr4IFkzlBRtJLylgqf9jT5eMkcGzCpu4
	 CXBeJUnq+51ihqcat13uTXlwLgsdZdnL6/SpWeaiNmHPt5z+Z0DMJcfV4UfvSsVTRj
	 2qRaTib2Ct/PJ0oLKHc4m3Ms9Oe0MLC5/TJ5NeYMReSRWm/N0YrzXNdeDe6ABGs4UI
	 idH2b3LKAIUffn3kQ7kB1ZLYRU5qZE9hpPlKIKycjW3FCDs7rNoEKdejAskxouv3an
	 Tce+f4219T/JqONTk99mOkXhnqu9VJX3uYkavDo6CXQG/pBRO0hmLj8suI8MKAkQ//
	 pYe3MvYAoGOCQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id DF13615C1942; Thu, 05 Sep 2024 10:53:54 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Lizhi Xu <lizhi.xu@windriver.com>,
        adilger.kernel@dilger.ca, coreteam@netfilter.org, davem@davemloft.net,
        ebiggers@kernel.org, fw@strlen.de, jaegeuk@kernel.org,
        kadlec@netfilter.org, kuba@kernel.org, linux-ext4@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        lkp@intel.com, llvm@lists.linux.dev, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
        pablo@netfilter.org,
        syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ext4: Fix error message when rejecting the default hash
Date: Thu,  5 Sep 2024 10:53:42 -0400
Message-ID: <172554793835.1268668.10009711670793037549.b4-ty@mit.edu>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <87jzg1en6j.fsf_-_@mailhost.krisman.be>
References: <87le3kle87.fsf@mailhost.krisman.be> <20240605012335.44086-1-lizhi.xu@windriver.com> <172433877724.370733.16770771071139702263.b4-ty@mit.edu> <87jzg1en6j.fsf_-_@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 27 Aug 2024 16:16:36 -0400, Gabriel Krisman Bertazi wrote:
> "Theodore Ts'o" <tytso@mit.edu> writes:
> 
> > On Wed, 05 Jun 2024 09:23:35 +0800, Lizhi Xu wrote:
> >> When mounting the ext4 filesystem, if the default hash version is set to
> >> DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.
> >>
> >>
> >
> > Applied, thanks!
> >
> > [1/1] fs/ext4: Filesystem without casefold feature cannot be mounted with spihash
> >       commit: 985b67cd86392310d9e9326de941c22fc9340eec
> 
> [...]

Applied, thanks!

[1/1] ext4: Fix error message when rejecting the default hash
      commit: a2187431c395cdfbf144e3536f25468c64fc7cfa

Best regards,
-- 
Theodore Ts'o <tytso@mit.edu>

