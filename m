Return-Path: <linux-fscrypt+bounces-1715-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zuCSHXCsSmpsFwEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1715-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:11:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F7870ADF4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:11:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FmXo+5G/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1715-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1715-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0F8D83003BEA
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A321369D67;
	Sun,  5 Jul 2026 19:11:39 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C549258EE9;
	Sun,  5 Jul 2026 19:11:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783278699; cv=none; b=bIMU2u6d/0w11yFMcaOJxgyqoLk8P9JWTdqPi8cDTUkIrr9HNG4jgdCqlWE9PlfLyeglSptWg4qE59b3Z7cz+xCbSxDshiMtql9EzpRrS2hTnkzCuZkB1eh+vqLpNqok0AgB9NT+FbaYFBeXAStcBitDQpPUk9icJODmZG7Es+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783278699; c=relaxed/simple;
	bh=HGUX3ITUUdlLZrqd71Xml1egxrLiFnZooAIvTl8X/fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzSUHQMtfwhc4JNHUOEVa8kF5bcqQsc2B2s+FjY2yB/fE1iG8CaavYmhXimksDqB/iuCsDo58fcp1+3yF2iK7QSkTvX6rpzHrHD0pRqZOk6tI4oPnIDnw4xpp+YoEABDqf0lVFRlNYNe0arvzKCkfmYj/vs8Ts/FeCiQMAqzCYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmXo+5G/; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97E81F000E9;
	Sun,  5 Jul 2026 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783278698;
	bh=qgjBNympinMaiD/Apvho4qUjfWRuCG4CHRGDdhecYoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FmXo+5G/bmPTpIMcCl7paLY5gKr9zlHYc5q/bhu2CjSnjIpDFH4zqA4jQjAsyy+FC
	 60yAsyeDXhKs32qIrlSsZZ81+5aD8BuSuh6rOQvNVREutS8L/6+e1M9q/t5ByoP9JV
	 /p+1RoUfg4T+3+m5DH+6tnZpZzNl3Zl/6kQQbUCuBUxo/kJynqOgb2XUDuiZuBmbu7
	 tsLLwX53TrBkLdQE7+PWAL0KfhetHploR+9cL1jAeo5yr5Z56I9t+5uHKHnu+HvKdQ
	 0nuztLShHMosWbwt4rP2jZiDJ1kqc/D2K4Ane2oWbsOvE0rbRDEeosTrl0j91F8AAU
	 ymRPWVYsWUevA==
Date: Sun, 5 Jul 2026 12:11:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Remove FSCRYPT_MODE_MAX
Message-ID: <20260705191136.GB41916@quark>
References: <20260618231404.132829-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618231404.132829-1-ebiggers@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1715-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C5F7870ADF4

On Thu, Jun 18, 2026 at 04:14:04PM -0700, Eric Biggers wrote:
> Now that the arrays of per-mode keys in struct fscrypt_master_key have
> been replaced by a linked list, the definition of FSCRYPT_MODE_MAX
> doesn't do anything useful.  (Previously it was used to size these
> arrays.)  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/crypto/fscrypt_private.h        | 3 ---
>  fs/crypto/keysetup.c               | 5 -----
>  include/uapi/linux/fscrypt.h       | 1 -
>  tools/include/uapi/linux/fscrypt.h | 1 -
>  4 files changed, 10 deletions(-)

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric

