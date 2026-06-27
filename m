Return-Path: <linux-fscrypt+bounces-1700-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id keK2HpFBP2q3QQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1700-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 05:20:49 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDFC6D0D6A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 05:20:48 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwNWZlfg;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1700-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1700-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0803F302DFA0
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jun 2026 03:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AB3F282F17;
	Sat, 27 Jun 2026 03:20:45 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB0C81D5ADE;
	Sat, 27 Jun 2026 03:20:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782530444; cv=none; b=Px/nQEDw8qWfp/ubwyYuUpTsJI3O3EiOMWvwGP2xlk+jONm7jqOaP4VpXXUc44a3gWGfbl7qyj+sRNMj2PN9uXKdX0niMM02IouTDikfYMNYROjn0Ok22lszQsB0BWJM5hPTOQUis1szbr50n1ww429YBq5edUe6f+0rOD8G3GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782530444; c=relaxed/simple;
	bh=cycMDWNG4DyPiR5UzMbSkNRHzx8AKI7W9DYmVznlaoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ofvz57y6kjNjXmIL5hFBlxKRZ+AySZc8fQmQSytQ/Srr5GwY5qlpO9vzFR7KbrYbHt5EyDdU6JCcWCXXN3KMmqWSzpeK/DEAe0ZV5xQNBTLDhbMGc47eX1Hh9tYyu9eA4Qy4AzK5q6Zvf1U5iylx4sQugiJIn+qw7dV/i5VeVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwNWZlfg; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367E51F000E9;
	Sat, 27 Jun 2026 03:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782530443;
	bh=dLn5Ye/u1rkql2w2rInqXApZ9x5R/AHA3OMUU94o6YE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RwNWZlfg/u8BGWxx70gLerjkoDuAWoqh350agTA5BGW6G2ZyOiGmFDrvT0FEgPC/Q
	 MWnERkC/kPYhzsnBr9N/tC2S//IWxsBHh0P1NMJVoC5TBDNL9VBhZWUp93MpXhUdZU
	 e35Hfvvjn8GdmJ7ehxt++jhjAu1Kd5UGgo5LN5K8Y9K4m7qIAd/A0wkopkuM4BZ6O9
	 VMN98Z4G3nsjIqtP3LcUMJdyvJmr1az68lTKibMbD+QfgVAheQw1kJppCrD+w9qwVl
	 CPYvAkVfM5LPwPpXUT88ZvjQy+xNscLAvzgcZb2nV3DgYwxGLqOz6EM28P8ivo9Tpm
	 mFBqXsnyZ3qCQ==
Date: Fri, 26 Jun 2026 23:20:42 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Luis Henriques <luis@igalia.com>, linux-fscrypt@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, linux-fsdevel@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com, 
	Mohammed EL Kadiri <med08elkadiri@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Replace mk_users keyring with simple list
Message-ID: <20260626-capable-inventive-rhino-b9b8fa@lemur>
References: <20260618221921.87896-1-ebiggers@kernel.org>
 <87tsqpd8d8.fsf@wotan.olymp>
 <20260626190232.GA1719948@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260626190232.GA1719948@google.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:luis@igalia.com,m:linux-fscrypt@vger.kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:jarkko@kernel.org,m:linux-fsdevel@vger.kernel.org,m:keyrings@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:syzbot+f55b043dacf43776b50c@syzkaller.appspotmail.com,m:med08elkadiri@gmail.com,m:stable@vger.kernel.org,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1700-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER(0.00)[mricon@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mricon@kernel.org,linux-fscrypt@vger.kernel.org];
	FREEMAIL_CC(0.00)[igalia.com,vger.kernel.org,mit.edu,kernel.org,syzkaller.appspotmail.com,gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt,f55b043dacf43776b50c];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BFDFC6D0D6A

On Fri, Jun 26, 2026 at 07:02:32PM +0000, Eric Biggers wrote:
> It applies on top of
> "[PATCH] fscrypt: Fix key setup in edge case with multiple data unit sizes"
> (https://lore.kernel.org/linux-fscrypt/20260618180652.52742-1-ebiggers@kernel.org/).
> This time I tried just relying on the prerequisite-patch-id footer (as
> generated by 'git format-patch') to express the dependency.  But
> evidently that still doesn't work: for one, 'b4 am' just ignores it.

FWIW, you have to use "b4 shazam" for it to apply the specified dependencies,
as "b4 am" just creates a mbox file and stuffing it full of deps is not really
the right approach.

HTH.

-K

