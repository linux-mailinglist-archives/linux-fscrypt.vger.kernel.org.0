Return-Path: <linux-fscrypt+bounces-1697-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id owmSANHMPmqfLwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1697-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 21:02:41 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 601156CFD69
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 21:02:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e5bWxkNz;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1697-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1697-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 28FBF302BBE3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Jun 2026 19:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054093BB11D;
	Fri, 26 Jun 2026 19:02:36 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB72F3BAD80;
	Fri, 26 Jun 2026 19:02:34 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782500555; cv=none; b=kjsGhsf7T4KWU9E2WHMMa+YDUE7OsteIyOQubEgw2BCzooWNImPugMCuneq0peuNJvM3Gryuf4vknlHwmCk1hzjvW6OsFlZy0z/bALzkZvMqNNCWA5yjqMMtmCwQcLHvdY3C2EkpHjFru/4yidZ5xSC+6sDjCoqRQRtoALxLxto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782500555; c=relaxed/simple;
	bh=wYG9vxHJQnok4hRaaItI0c/491Uiob2sFG40NG146XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LYXlba6yRJHVfr3G4Q0pKHy3ADa40Zpu2M8VPum0VpRs3nqB3T1tSbannoMIsADWO5gVUC8l5a4SNwPuTI7DpOd8QWS53HDoTtNouwSXAD6sIJs9iercaWuoHFoHX38kk+FbazH3kGO+/T0E2ZGD4nA4Mz2/ZwAwEvl2lsD1XuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5bWxkNz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC01F000E9;
	Fri, 26 Jun 2026 19:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782500554;
	bh=zeUUj+anazIq+ujYMyuB6v00pSzE1NMl9SDGFG9i/cI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e5bWxkNzromH2sWRes0RrSGnX0Vu//XBwM+2IApMfir10C/62iPb3QsD66O5KKgc9
	 veoKE/j/jzGAMBKNZtEs85HBu/zdxuqI23vafnwNaVY8tlPtzkjkfIAxFxcS1Xdn8E
	 crjyMlTCVVQQU1qOhE7cgFKq6noWYS+OZ3Z8EU4xrQ9Z0vqyGRSeStDw5YWrzekBMl
	 EPP2vO/r57UPqvB/A4e5FStS+DMAi8vkl2tL85+X4CepdT4ie6ZEDaF0Y4ltgHGOxD
	 Qi3WyrHUTbkRIDtiEdbHUBCGVgrwXUOihKOymr9+294oV0RibQTe1MJYLbSRGHVXcz
	 9pAwye1ntFutA==
Date: Fri, 26 Jun 2026 19:02:32 +0000
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
Message-ID: <20260626190232.GA1719948@google.com>
References: <20260618221921.87896-1-ebiggers@kernel.org>
 <87tsqpd8d8.fsf@wotan.olymp>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tsqpd8d8.fsf@wotan.olymp>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1697-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 601156CFD69

On Fri, Jun 26, 2026 at 09:16:35AM +0100, Luis Henriques wrote:
> Hi Eric!
> 
> On Thu, Jun 18 2026, Eric Biggers wrote:
> 
> > Change mk_users (the set of user claims to an fscrypt master key) from a
> > 'struct key' keyring to a simple linked list.
> >
> > It's still a collection of 'struct key' for quota tracking.  It was
> > originally thought to be natural that a collection of 'struct key'
> > should be held in a 'struct key' keyring.  In reality, it's just been
> > causing problems, similar to how using 'struct key' for the filesystem
> > keyring caused problems and was removed in commit d7e7b9af104c
> > ("fscrypt: stop using keyrings subsystem for fscrypt_master_key").
> >
> > Commit d3a7bd420076 ("fscrypt: clear keyring before calling key_put()")
> > fixed mk_users cleanup to be synchronous.  But that apparently wasn't
> > enough: the keyring subsystem's redundant locking is still generating
> > lockdep false positives due to the interaction with filesystem reclaim.
> >
> > With the simple list, the redundant locking and lockdep issue goes away.
> >
> > Of course, searching a linked list is linear-time whereas the
> > 'struct key' keyring used a fancy constant-time associative array.  But
> > that's fine here, since in practice there's just one entry in the list.
> > In fact the new code is much faster in practice, since it's much smaller
> > and doesn't have to convert the kuid_t into a string to search for it.
> >
> > Reported-by: syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=f55b043dacf43776b50c
> > Reported-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
> > Closes: https://lore.kernel.org/keyrings/20260614150041.21172-1-med08elkadiri@gmail.com/
> > Fixes: 23c688b54016 ("fscrypt: allow unprivileged users to add/remove keys for v2 policies")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >
> > I'm planning to take this via the fscrypt tree for 7.2
> 
> I was hoping to have some more time to test this patch, but I don't think
> that will happen any time soon.
> 
> I've done a review of the patch and couldn't find any obvious problem.
> Though, again, a more in-depth review would require more time as it has
> been a while since I took a look into this code.
> 
> I just wonder if this is really stable material.  It's a bit intrusive
> (doesn't even apply cleanly in mainline), but above all it's fixing a
> lockdep false positive.  Other than syzbot, has this been seen in the
> wild?

Thanks!

It applies on top of
"[PATCH] fscrypt: Fix key setup in edge case with multiple data unit sizes"
(https://lore.kernel.org/linux-fscrypt/20260618180652.52742-1-ebiggers@kernel.org/).
This time I tried just relying on the prerequisite-patch-id footer (as
generated by 'git format-patch') to express the dependency.  But
evidently that still doesn't work: for one, 'b4 am' just ignores it.

Since this patch has "Reported-by: syzbot" as well as "Fixes", the
stable maintainers will apply it anyway.  If I actually wanted to stop
that, I'd have to actively oppose the backport, likely multiple times
indefinitely since people will continue to try to backport it.  And
syzkaller would continue to get the lockdep warning on stable kernels.

So I'd rather just get it out the way and backport it the same time as
"fscrypt: Fix key setup in edge case with multiple data unit sizes",
which similarly tweaks some data structures in struct fscrypt_master_key
and needs to be backported too.  "fscrypt: stop using keyrings subsystem
for fscrypt_master_key" several years ago was backported too.

- Eric

