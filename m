Return-Path: <linux-fscrypt+bounces-300-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B53A8D856E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jun 2024 16:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED7D61F22DCD
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jun 2024 14:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27A412F5A0;
	Mon,  3 Jun 2024 14:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SDeMR4vU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EtXdY/cY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SDeMR4vU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="EtXdY/cY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011682D8E;
	Mon,  3 Jun 2024 14:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717426262; cv=none; b=pnqHvEYnpOsFr2eZv+Bqu2DAOUjukWa/X1BkR7pWF3YeTsqKwj6eN0hTXBTFcN1KIJ2mZNIN9BpDxFWtrQ5opuCxU97IAXgaqiXdRwzutvga60hR15DW/hXpXAE/Zpk+/i+dcEOQN02mNDxaw+PbEuUOvhqTeaPi+vbySkBDmWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717426262; c=relaxed/simple;
	bh=zG98KLJbkM25RRn+j3UuuXqg165jOeRk2KEUp6rpJ8I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nv3SjxouzSnNxCmzz4nzuf1QB0jR3vddeJrUegI3O3mxYSMILrEJkEP/wNz12TRAjIFxJDdr9fi5rtO2LV9hIPSfCI8xPX4aoIjjuC6Sllas5823rFalqiQYOK9pqd3H2i4rAuweu0JgtPD08mI52brljHg/kBsyUr6c6TizxH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SDeMR4vU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EtXdY/cY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SDeMR4vU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=EtXdY/cY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 25F8420041;
	Mon,  3 Jun 2024 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717426258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oe7YXIZQ2xQOr2btlbRQ08j1/YVZeKV53iC/f6cqlfw=;
	b=SDeMR4vUjc/iiTjnSjIxaV3KqI4m+Fqopb1EOGNnw/9s5+CEXaC8dmFLl6VN5WTGy9TsJs
	z2hGnUUsGddeCq8i3DsmdQTslbD1r8Dtx/K+Ha+71eaadY6Tabf8+2DlPch+xL608XHU+3
	0f3TMd3/nxeRO++zBmJIgwUODsKJtnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717426258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oe7YXIZQ2xQOr2btlbRQ08j1/YVZeKV53iC/f6cqlfw=;
	b=EtXdY/cYXTA1Cs9Y0HwyWtAG3TQRjf5bD+HdC+5tdH7VsZpHYIfONy3IDXpRl5Qf9NVrf+
	wfvEITRAl3DsckCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717426258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oe7YXIZQ2xQOr2btlbRQ08j1/YVZeKV53iC/f6cqlfw=;
	b=SDeMR4vUjc/iiTjnSjIxaV3KqI4m+Fqopb1EOGNnw/9s5+CEXaC8dmFLl6VN5WTGy9TsJs
	z2hGnUUsGddeCq8i3DsmdQTslbD1r8Dtx/K+Ha+71eaadY6Tabf8+2DlPch+xL608XHU+3
	0f3TMd3/nxeRO++zBmJIgwUODsKJtnE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717426258;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oe7YXIZQ2xQOr2btlbRQ08j1/YVZeKV53iC/f6cqlfw=;
	b=EtXdY/cYXTA1Cs9Y0HwyWtAG3TQRjf5bD+HdC+5tdH7VsZpHYIfONy3IDXpRl5Qf9NVrf+
	wfvEITRAl3DsckCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2F0113A93;
	Mon,  3 Jun 2024 14:50:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jlr0LFHYXWaLbAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 03 Jun 2024 14:50:57 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: <lkp@intel.com>,  <coreteam@netfilter.org>,  <davem@davemloft.net>,
  <ebiggers@kernel.org>,  <fw@strlen.de>,  <jaegeuk@kernel.org>,
  <kadlec@netfilter.org>,  <kuba@kernel.org>,
  <linux-fscrypt@vger.kernel.org>,  <linux-kernel@vger.kernel.org>,
  <llvm@lists.linux.dev>,  <netdev@vger.kernel.org>,
  <netfilter-devel@vger.kernel.org>,  <oe-kbuild-all@lists.linux.dev>,
  <pablo@netfilter.org>,
  <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
  <syzkaller-bugs@googlegroups.com>,  <tytso@mit.edu>,
  <adilger.kernel@dilger.ca>,  <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH V5] ext4: check hash version and filesystem casefolded
 consistent
In-Reply-To: <20240601113749.473058-1-lizhi.xu@windriver.com> (Lizhi Xu's
	message of "Sat, 1 Jun 2024 19:37:49 +0800")
References: <20240531185519.GB1153@sol.localdomain>
	<20240601113749.473058-1-lizhi.xu@windriver.com>
Date: Mon, 03 Jun 2024 10:50:51 -0400
Message-ID: <87plsym65w.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-2.71)[98.71%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[340581ba9dceb7e06fb3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.51
X-Spam-Flag: NO

Lizhi Xu <lizhi.xu@windriver.com> writes:

> When mounting the ext4 filesystem, if the hash version and casefolded are not
> consistent, exit the mounting.
>
> Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/ext4/super.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c682fb927b64..0ad326504c50 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  		goto failed_mount;
>  
>  	ext4_hash_info_init(sb);
> +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
> +	    !ext4_has_feature_casefold(sb)) {

Can we ever have DX_HASH_SIPHASH set up in the super block?  I thought
it was used solely for directories where ext4_hash_in_dirent(inode) is
true.

If this is only for the case of a superblock corruption, perhaps we
should always reject the mount, whether casefold is enabled or not?

-- 
Gabriel Krisman Bertazi

