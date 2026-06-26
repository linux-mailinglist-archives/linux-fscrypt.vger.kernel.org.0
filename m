Return-Path: <linux-fscrypt+bounces-1698-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id B+qnM1PhPmolMgkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1698-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 22:30:11 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD9B6CFFFA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 22:30:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dde0JfY9;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1698-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1698-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8262D3022A8A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 20:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0305D3BB9FD;
	Fri, 26 Jun 2026 20:29:54 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE83BB10B;
	Fri, 26 Jun 2026 20:29:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782505793; cv=none; b=cyO6r4YBlFcKaEcV6EpDzu5mjtixnITXVdKXOgH1C0pNGQvyNs3QAuEU/kzvp7jtgaCDcMgoO9hkgf0up5zAdp2sjL50yHgIwueLGa/PvwwYxDQeHnIp6H3qF0lH83q6RunXWnz5XPwvghIZeqF7rOPNuKf/NqwjPgBubB19Qus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782505793; c=relaxed/simple;
	bh=/hymBU9Tt2JbH1g4ywAkUCAHDuDsaRVBRCmYIBJfEMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=adJIEttfQWOUkWTkwRVjOQ3rSgojsK58rlx/4w227AQZ1nfa+OvFWdNukrU+JpIGHacfygNuDIrjYgFc6o4AEgRpMPH/u/6/U64VEC5A2nfY2H+PCp0FGGiWMkk7O4cz6767cZsMzcSekmPUDr6x/7nnyO56+6oemMyh+Zp4HEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dde0JfY9; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E996D1F000E9;
	Fri, 26 Jun 2026 20:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782505792;
	bh=fmn3Xyqj2lzX64Sh5nR6byc0sMpEYjfG6FOf09H0vh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dde0JfY9Mxh//TAm69PplV82PfP4OW9pAr1X7zAsEdHnCJ2sQ2j3eeG/4DIdeyc+A
	 z84eZnZbFY1160QL7mdCUbxt/pW1nrAchvMHpEMwOEtayrkG1phOH9pCRgwpJLCf6S
	 1j3IYILFYoTfDzo5sEfdCmdVw4D4O1V43k4wUxkEbj0D//KAzh1ltmLrQx3pq7Mpia
	 IaQvER7yh7/MTnxiu7lnMokPqsBZ+cucaqrH2NpHzzLlN7hRMwesV6QTrrynPL84hu
	 E8+LP2+sY9gMbWvTty94Dm5i4WqhMlMDjoGyA1k7nl/yuqxn1afWhWv2n4t/hkjsmN
	 ZcMGifponSoTQ==
Date: Fri, 26 Jun 2026 20:29:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Luis Henriques <luis@igalia.com>
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-fsdevel@vger.kernel.org,
	keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Replace mk_users keyring with simple list
Message-ID: <20260626202949.GA2368695@google.com>
References: <20260618221921.87896-1-ebiggers@kernel.org>
 <87tsqpd8d8.fsf@wotan.olymp>
 <20260626190232.GA1719948@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626190232.GA1719948@google.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1698-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,kernel.org,syzkaller.appspotmail.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:luis@igalia.com,m:linux-fscrypt@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:jarkko@kernel.org,m:linux-fsdevel@vger.kernel.org,m:keyrings@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,m:med08elkadiri@gmail.com,m:stable@vger.kernel.org,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[linux-fscrypt,f55b043dacf43776b50c];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,appspotmail.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2DD9B6CFFFA

On Fri, Jun 26, 2026 at 07:02:32PM +0000, Eric Biggers wrote:
> On Fri, Jun 26, 2026 at 09:16:35AM +0100, Luis Henriques wrote:
> > Hi Eric!
> > 
> > On Thu, Jun 18 2026, Eric Biggers wrote:
> > 
> > > Change mk_users (the set of user claims to an fscrypt master key) from a
> > > 'struct key' keyring to a simple linked list.
> > >
> > > It's still a collection of 'struct key' for quota tracking.  It was
> > > originally thought to be natural that a collection of 'struct key'
> > > should be held in a 'struct key' keyring.  In reality, it's just been
> > > causing problems, similar to how using 'struct key' for the filesystem
> > > keyring caused problems and was removed in commit d7e7b9af104c
> > > ("fscrypt: stop using keyrings subsystem for fscrypt_master_key").
> > >
> > > Commit d3a7bd420076 ("fscrypt: clear keyring before calling key_put()")
> > > fixed mk_users cleanup to be synchronous.  But that apparently wasn't
> > > enough: the keyring subsystem's redundant locking is still generating
> > > lockdep false positives due to the interaction with filesystem reclaim.
> > >
> > > With the simple list, the redundant locking and lockdep issue goes away.
> > >
> > > Of course, searching a linked list is linear-time whereas the
> > > 'struct key' keyring used a fancy constant-time associative array.  But
> > > that's fine here, since in practice there's just one entry in the list.
> > > In fact the new code is much faster in practice, since it's much smaller
> > > and doesn't have to convert the kuid_t into a string to search for it.
> > >
> > > Reported-by: syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=f55b043dacf43776b50c
> > > Reported-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
> > > Closes: https://lore.kernel.org/keyrings/20260614150041.21172-1-med08elkadiri@gmail.com/
> > > Fixes: 23c688b54016 ("fscrypt: allow unprivileged users to add/remove keys for v2 policies")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > ---
> > >
> > > I'm planning to take this via the fscrypt tree for 7.2
> > 
> > I was hoping to have some more time to test this patch, but I don't think
> > that will happen any time soon.
> > 
> > I've done a review of the patch and couldn't find any obvious problem.
> > Though, again, a more in-depth review would require more time as it has
> > been a while since I took a look into this code.
> > 
> > I just wonder if this is really stable material.  It's a bit intrusive
> > (doesn't even apply cleanly in mainline), but above all it's fixing a
> > lockdep false positive.  Other than syzbot, has this been seen in the
> > wild?
> 
> Thanks!
> 
> It applies on top of
> "[PATCH] fscrypt: Fix key setup in edge case with multiple data unit sizes"
> (https://lore.kernel.org/linux-fscrypt/20260618180652.52742-1-ebiggers@kernel.org/).
> This time I tried just relying on the prerequisite-patch-id footer (as
> generated by 'git format-patch') to express the dependency.  But
> evidently that still doesn't work: for one, 'b4 am' just ignores it.
> 
> Since this patch has "Reported-by: syzbot" as well as "Fixes", the
> stable maintainers will apply it anyway.  If I actually wanted to stop
> that, I'd have to actively oppose the backport, likely multiple times
> indefinitely since people will continue to try to backport it.  And
> syzkaller would continue to get the lockdep warning on stable kernels.
> 
> So I'd rather just get it out the way and backport it the same time as
> "fscrypt: Fix key setup in edge case with multiple data unit sizes",
> which similarly tweaks some data structures in struct fscrypt_master_key
> and needs to be backported too.  "fscrypt: stop using keyrings subsystem
> for fscrypt_master_key" several years ago was backported too.

FWIW, I would also not be surprised if the old code would also fail
fuzzing in other ways, like keyctl() being used to directly manipulate
the keyrings from underneath what fs/crypto/ assumes.  I remember at
least considering that scenario when adding this code years ago, but I
think the reasoning was quite subtle and I may have missed something.

The 'struct key' keyrings just have a lot of obscure sharp corners.
Whereas simple lists, hash tables, etc. are much easier to evaluate.

- Eric

