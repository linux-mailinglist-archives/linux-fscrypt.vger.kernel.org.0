Return-Path: <linux-fscrypt+bounces-304-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E068FBC16
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 21:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC15DB20D4A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Jun 2024 19:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2BE14AD23;
	Tue,  4 Jun 2024 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xpVmld3U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Sub/LDfg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xpVmld3U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Sub/LDfg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1A214AD0D;
	Tue,  4 Jun 2024 19:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717528010; cv=none; b=FtHm1Hm8gG23o+HxgPo+daI5Z2RYIRx7GU2KdAWQxWihrFbI40uPI8JDD9hXFZCzFst9WnIBFGtPQ5swTBupYdlUgfUh/XfRLFP+/ia9LDdO9KcO0/ARQkI/pwTn5Ccud4axRDkLqRo630SypdojwaMeoTiiijt77k02Ls3Ex7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717528010; c=relaxed/simple;
	bh=w+z51GOxz6CgOvEKGk3Y4qP1o260i7X7s60eVfx6w8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=IKcbQ1rtaR3MZ+T4V80c66IJIjTLrICeyDES8QMqTTm3jvwIud+OaeGrVHE4arlAS1kWNl+w+2L4I6A6Tdh4bEhs9fdgxpGV33RVfSLNissEeW7NL1xXM+msZ6kIH1n878GvnN5FLjaWebmCmQAJBkDGpaV5/n6IL1RXgKxg/SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xpVmld3U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Sub/LDfg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xpVmld3U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Sub/LDfg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 398E21F37C;
	Tue,  4 Jun 2024 19:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717528007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXBboWW451VBPbHdzoF/IPP9YUNWIilu8/IAXa2j64I=;
	b=xpVmld3U5rCSlYA+RS3LZvZSmgEP04a9DhPwJTUWgJ6Mqdan4i7dfYHA4JH+u4Rr6GzE2P
	GK06r+QZDHElrI4eDogAq3kYyd9GvsOpXf6dfJEn6QoPPmuva1wI+ic/K/tU2OmKmqdaad
	52fu0xlxtHW7AmnDbEecQpzxYKdW6ok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717528007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXBboWW451VBPbHdzoF/IPP9YUNWIilu8/IAXa2j64I=;
	b=Sub/LDfgBk8LEnfeHQ5e0GjMGwc+RlDeU1LiGDsIpcv2LArYPL7mmsyoi6FdC4RTqmZ3EU
	ajAGh0JzEvzQgqBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717528007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXBboWW451VBPbHdzoF/IPP9YUNWIilu8/IAXa2j64I=;
	b=xpVmld3U5rCSlYA+RS3LZvZSmgEP04a9DhPwJTUWgJ6Mqdan4i7dfYHA4JH+u4Rr6GzE2P
	GK06r+QZDHElrI4eDogAq3kYyd9GvsOpXf6dfJEn6QoPPmuva1wI+ic/K/tU2OmKmqdaad
	52fu0xlxtHW7AmnDbEecQpzxYKdW6ok=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717528007;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TXBboWW451VBPbHdzoF/IPP9YUNWIilu8/IAXa2j64I=;
	b=Sub/LDfgBk8LEnfeHQ5e0GjMGwc+RlDeU1LiGDsIpcv2LArYPL7mmsyoi6FdC4RTqmZ3EU
	ajAGh0JzEvzQgqBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6E1B13A93;
	Tue,  4 Jun 2024 19:06:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pNiQMsZlX2YBYQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 04 Jun 2024 19:06:46 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: <adilger.kernel@dilger.ca>,  <coreteam@netfilter.org>,
  <davem@davemloft.net>,  <ebiggers@kernel.org>,  <fw@strlen.de>,
  <jaegeuk@kernel.org>,  <kadlec@netfilter.org>,  <kuba@kernel.org>,
  <linux-ext4@vger.kernel.org>,  <linux-fscrypt@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <lkp@intel.com>,
  <llvm@lists.linux.dev>,  <netdev@vger.kernel.org>,
  <netfilter-devel@vger.kernel.org>,  <oe-kbuild-all@lists.linux.dev>,
  <pablo@netfilter.org>,
  <syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com>,
  <syzkaller-bugs@googlegroups.com>,  <tytso@mit.edu>
Subject: Re: [PATCH V5] ext4: check hash version and filesystem casefolded
 consistent
In-Reply-To: <20240604011718.3360272-1-lizhi.xu@windriver.com> (Lizhi Xu's
	message of "Tue, 4 Jun 2024 09:17:17 +0800")
Organization: SUSE
References: <87plsym65w.fsf@mailhost.krisman.be>
	<20240604011718.3360272-1-lizhi.xu@windriver.com>
Date: Tue, 04 Jun 2024 15:06:32 -0400
Message-ID: <87le3kle87.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[340581ba9dceb7e06fb3];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email]

Lizhi Xu <lizhi.xu@windriver.com> writes:

> On Mon, 03 Jun 2024 10:50:51 -0400, Gabriel Krisman Bertazi wrote:
>> > When mounting the ext4 filesystem, if the hash version and casefolded are not
>> > consistent, exit the mounting.
>> >
>> > Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
>> > Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
>> > ---
>> >  fs/ext4/super.c | 5 +++++
>> >  1 file changed, 5 insertions(+)
>> >
>> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> > index c682fb927b64..0ad326504c50 100644
>> > --- a/fs/ext4/super.c
>> > +++ b/fs/ext4/super.c
>> > @@ -5262,6 +5262,11 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>> >  		goto failed_mount;
>> >  
>> >  	ext4_hash_info_init(sb);
>> > +	if (es->s_def_hash_version == DX_HASH_SIPHASH && 
>> > +	    !ext4_has_feature_casefold(sb)) {
>> 
>> Can we ever have DX_HASH_SIPHASH set up in the super block?  I thought
>> it was used solely for directories where ext4_hash_in_dirent(inode) is
>> true.
> The value of s'def_hash_version is obtained by reading the super block from the
> buffer cache of the block device in ext4_load_super().

Yes, I know.  My point is whether this check should just be:

if (es->s_def_hash_version == DX_HASH_SIPHASH)
	goto failed_mount;

Since, IIUC, DX_HASH_SIPHASH is done per-directory and not written to
the sb.

>> If this is only for the case of a superblock corruption, perhaps we
>> should always reject the mount, whether casefold is enabled or not?
> Based on the existing information, it cannot be confirmed whether the superblock
> is corrupt, but one thing is clear: if the default hash version of the superblock
> is set to DX_HASH_SIPHASH, but the casefold feature is not set at the same time,
> it is definitely an error.


-- 
Gabriel Krisman Bertazi

