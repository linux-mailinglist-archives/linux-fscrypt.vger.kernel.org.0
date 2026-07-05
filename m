Return-Path: <linux-fscrypt+bounces-1717-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id j0soGr+sSmqCFwEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1717-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:13:03 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B6470AE18
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:13:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8u58LHp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1717-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1717-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7ABAC300879E
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E40377004;
	Sun,  5 Jul 2026 19:12:20 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CCD282F22;
	Sun,  5 Jul 2026 19:12:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783278740; cv=none; b=m+Xdanwxb1xKJEV3bT8Vh7R7uCFfxmE4UN6nSeqf6u4GHQUBQ3AQN96u8h3J09jTTYIYSrSx3yEK+0p8MLiEfhtXb/TYtF8EK4FrFIb4EjC5on5xHE1yhjhDE0DZOGhPMyfsmYv1cknYCh6CmkSSQWdol8Y86a7NOtE8h7FdC7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783278740; c=relaxed/simple;
	bh=50NrJxqbSb5e4b+na2UDJHqhUiS+q783nmq5MYeMbug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/k8jgKQRycrZZMhG40uVOaNhClYE8n1nA+g53E/7p985VebE9XuXy1AGEBYVoUQQJdm9YPLKx2v+7HOqU11wtqKIvP/fB3pWj8NbZ00HjCvodtpj8bRn45VG8kcmJLe232txapY9w1GXmCqXbqXSyLSAwVk1B2hJ4BGPABQFg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H8u58LHp; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EE61F000E9;
	Sun,  5 Jul 2026 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783278738;
	bh=mVrwpxtlnPRsDChMxLDmownxKUYn+VOZNA8DCKfgNZ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H8u58LHpwuMGXVfsFx4bHjuc0KqA8pBQQNPnul5LuwhGRl1KpdYGKHufgbtoMkZ3M
	 lQRskGxGmpNk+QUJ5zXSQz67yBQrLwibvhYvSpF3h84Ixn8fLWgPuofnT6hhnDzEl3
	 cdHYZ2EdkTAfVDI2DB8XbAnwizll1kq3dVyMD1hmhNdUeOaRcg6lZn6kDIsm/qxQFf
	 eSELWBxvWBbVw95MObZ1eNCyHe2KkswIeo3jqUwUU/AnCAzGHRywCmsjwaXoUTBt11
	 boxg+VDOE4axpG4JUNVwQBm3DuYoMnaaIxxd/0vo3pDGKd9EQL7Upi4FmOgy/NLJlS
	 TdN31I+hR6g5g==
Date: Sun, 5 Jul 2026 12:12:16 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Remove workaround for bug in gcc 7 and earlier
Message-ID: <20260705191216.GD41916@quark>
References: <20260619051008.51223-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619051008.51223-1-ebiggers@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1717-lists,linux-fscrypt=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[quark:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E6B6470AE18

On Thu, Jun 18, 2026 at 10:10:08PM -0700, Eric Biggers wrote:
> Since the kernel's minimum gcc version is now 8.1, the workaround for a
> strange gcc bug in fscrypt_ioctl_set_policy() is no longer needed.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/crypto/policy.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric

