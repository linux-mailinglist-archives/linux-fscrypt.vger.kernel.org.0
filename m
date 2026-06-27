Return-Path: <linux-fscrypt+bounces-1699-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JRiDDKkcP2q6OwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1699-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 02:43:21 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E026D0A11
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 02:43:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WDvyQJG9;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1699-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1699-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECA703019811
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 00:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E921C84A0;
	Sat, 27 Jun 2026 00:43:17 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77B015E8B;
	Sat, 27 Jun 2026 00:43:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782520997; cv=none; b=UlAuMgg74243aesEBG9yeGgs6HcoiHB35dS66NqN5uxiGMZl7AYYrvONZa1rWO2AWJQEy/vYZOupnRoN2gUxz00c9EJjYXF9nDtTiinY2bgrp1JzvOXJIpp2cH89axsqmXiezpJuE0LidPVn9X3uAx6wp3ZCGtUYzdsgY6ZJ4p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782520997; c=relaxed/simple;
	bh=1erZvWAO8GPRGbyc75Uq33HBKs82JDiPBulHV7KhsYo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KSkPGuLn87TGh++Ymde0gZe7tB7ja2ceftUKg2REPXuk+0jwnZMJ6cV3DvB//3uIcL8psLz31AlGwirkRZuwdj4liluobzoVYNlmC433DPp9CYset0KM48xTPQ0cW/kkrB0qIDIMN02wHBD/auegJ4NaqENXrjE5la2O/y6fVqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDvyQJG9; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE6B1F000E9;
	Sat, 27 Jun 2026 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782520996;
	bh=aWCzpncU7+6ITCn+zmFtEweahB9AkfncfcsrB7kCr/o=;
	h=Date:From:To:Cc:Subject;
	b=WDvyQJG9u2RYz5DIfB3fBE88IREtRlLglshGDWwkFEW4Uf+RYGk3noucwzptp/B4L
	 Ips1w9iDBC6r186wkw2P3FYiZvTVByvyrYjERV5q8aglaGFslYT4JQFR1CFS1BVr6d
	 jRfzeS4GSLxHSZgvALzJvku6Y/IK2arg5Fou5QgQCU8zrzBcn1NzjSHGcTcWAK6+Xs
	 2PHPeAuPgzfF1izaFJ+EAxOxTmfObcd+DDpe3/H48I5DKQcWtd+8BlCs1UKZJtfqT4
	 ZGwkRRIk0uGC7pi2Y+HBlu5KIW7xTTuLXKC/qa6+hgYgrTixxr7itc7Pvy+BXEpaeZ
	 YUoJq5UyX2KvQ==
Date: Fri, 26 Jun 2026 17:43:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Mohammed EL Kadiri <med08elkadiri@gmail.com>,
	Luis Henriques <luis@igalia.com>,
	syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com
Subject: [GIT PULL] fscrypt fixes for 7.2
Message-ID: <20260627004314.GA2075@quark>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1699-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:med08elkadiri@gmail.com,m:luis@igalia.com,m:syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,kernel.org,gmail.com,igalia.com,syzkaller.appspotmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	TAGGED_RCPT(0.00)[linux-fscrypt,f55b043dacf43776b50c];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,quark:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 74E026D0A11

The following changes since commit 1dc18801be29bc54709aa355b8acd80e183b03cd:

  Merge tag 'i2c-7.2-part2' of git://git.kernel.org/pub/scm/linux/kernel/git/andi.shyti/linux (2026-06-22 09:30:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

for you to fetch changes up to 696c030e1e3438955aba443b308ee8b6faa3983e:

  fscrypt: Replace mk_users keyring with simple list (2026-06-22 12:12:11 -0700)

----------------------------------------------------------------

- Fix a bug where in a specific edge case, file contents en/decryption
  could be done with the wrong data unit size.

- Fix the data structure used for keeping track of users that have added
  an fscrypt key to be a simple list instead of a 'struct key' keyring.

  This fixes issues such as a lockdep report found by syzbot and
  possible unintended interactions with the keyctl() system calls.

----------------------------------------------------------------
Eric Biggers (2):
      fscrypt: Fix key setup in edge case with multiple data unit sizes
      fscrypt: Replace mk_users keyring with simple list

 fs/crypto/fscrypt_private.h |  84 ++++++++++------
 fs/crypto/inline_crypt.c    |   8 +-
 fs/crypto/keyring.c         | 239 +++++++++++++++++++-------------------------
 fs/crypto/keysetup.c        | 118 ++++++++++++++--------
 4 files changed, 233 insertions(+), 216 deletions(-)

