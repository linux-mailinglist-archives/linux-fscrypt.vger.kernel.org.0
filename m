Return-Path: <linux-fscrypt+bounces-1701-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jXsEEBQ9QGr7dwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1701-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 23:13:56 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6406D2AD9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 23:13:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eFYDeZlv;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1701-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1701-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A96783026CBB
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 21:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1BF03803D9;
	Sat, 27 Jun 2026 21:13:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D782137FF46;
	Sat, 27 Jun 2026 21:13:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782594801; cv=none; b=gnBHpab3mn/Jl3oEYrWoG1Gbh0aaa539PaAQY7YWKniCmA7ggy3FMMgPlxtUmIFxg9opttz+GwxlLUT+afGM9nUkWuS8P8PayxuIUmbJx3GLdPQQdeI54vObg10ssBtfQpd7GtA9diWE2PXYbVLci9uIkIk2aAWE28/YQYZm32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782594801; c=relaxed/simple;
	bh=tFvNBQiZI6UzZK8AohNh5zELWhljVKkiMtsyGcDqHwU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Ew8n4lDnx1MHWQXNpvWNTwVFoXRq1eGc8eQhpUzC46RcIIEhW7Z5PhMvaak+s/3fYVpDVwQ6zDwuE+MizTkjyDBnp+jDMeu6xgl/T05fSmX+VrIW+8ga9ccogH6wR+vdt3a2ljDnSSJQb4Xm8vYNkrqTNLvN0CEpdXDfNUq7sH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFYDeZlv; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB711F000E9;
	Sat, 27 Jun 2026 21:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782594800;
	bh=EX5VmE3YSsvEq2Umd1hn19zoxghX3Y31VGqWDH4SHN0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=eFYDeZlv5uuSrw6TJWzSqcwJQFhruz+ul1pICLmA/g0SkPtBLQJYUxlr1WUsmkYEg
	 ClE4OGURZJtm9krS4vwzBEmGTZnFzI6zQFw6nE/8wOJi4sPdGWhC2lw/S54rkvgCMD
	 fSxNMhmQb29BGs/LOBTmZK05uSgxWdSXmfRF3+F7EXZTJs34oS5DhkBil8KXrJ8YVD
	 zuhwQGTVP6pepTCaQ/pgqRIlGlFi0wT0ycbLgcIjg3bKui1arURogt1zchcmNoA+Sl
	 F2cnY2kR0TuQrF4zJ1/tQRqQvwfo4uX1SfqzqMlg51jzKSDlMgnPOky0wCbBDT0/bb
	 MbDkGtdfoyDyA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BA53938452;
	Sat, 27 Jun 2026 21:13:07 +0000 (UTC)
Subject: Re: [GIT PULL] fscrypt fixes for 7.2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260627004314.GA2075@quark>
References: <20260627004314.GA2075@quark>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260627004314.GA2075@quark>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus
X-PR-Tracked-Commit-Id: 696c030e1e3438955aba443b308ee8b6faa3983e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6ca693ea903df5748809f61b290831004036978d
Message-Id: <178259478645.1431938.819006475632242246.pr-tracker-bot@kernel.org>
Date: Sat, 27 Jun 2026 21:13:06 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Mohammed EL Kadiri <med08elkadiri@gmail.com>, Luis Henriques <luis@igalia.com>, syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1701-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_CC(0.00)[linux-foundation.org,vger.kernel.org,mit.edu,kernel.org,gmail.com,igalia.com,syzkaller.appspotmail.com];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:torvalds@linux-foundation.org,m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:med08elkadiri@gmail.com,m:luis@igalia.com,m:syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[pr-tracker-bot@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,linux-fscrypt@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[linux-fscrypt,f55b043dacf43776b50c];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CB6406D2AD9

The pull request you sent on Fri, 26 Jun 2026 17:43:14 -0700:

> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6ca693ea903df5748809f61b290831004036978d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

