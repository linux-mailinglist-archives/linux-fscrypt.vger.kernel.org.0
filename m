Return-Path: <linux-fscrypt+bounces-1164-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wICtOe4bmmnZYgMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1164-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 21:56:14 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 809E816DDC0
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 21:56:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E2D4302BE38
	for <lists+linux-fscrypt@lfdr.de>; Sat, 21 Feb 2026 20:56:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B29530DECB;
	Sat, 21 Feb 2026 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R83rW+PC"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244D11F5821;
	Sat, 21 Feb 2026 20:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771707370; cv=none; b=jBJSpgY10HoYGGtLZ2z1siHYvC5gPBjy2wnFcHkJ3yDAbOJowZdslnlUIyq2a6eeEKao29TwSka1xLxhVNWCqKKxe3QoMQIAhYOrZQnlAki+tL7Y9CqpjRo+doQ09SONHSWH6VFzE0u9p3a4p3gtUESkfb6YTWdj5J+jAQAqgIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771707370; c=relaxed/simple;
	bh=rsSXrdyQc75M2GNaYQZdLOdCAC0nOdlAv9gh6twIN4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iC0xSyOX3kk4W5UVvz4Z9jZqg8zUdaNlyL/H0dBsVSNZ7YxsJVB5WwR7Jsba9DeOEz2qUP64OWqwZpyivNsCnMfWJb8MWm4bzMLxmZzUSZeLAuj59OriEhWC14cZVtuRkmniu7FJQXZdhqomJ6t0cKTNJbr7fV+/POLz6IFpgh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R83rW+PC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70505C4CEF7;
	Sat, 21 Feb 2026 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771707369;
	bh=rsSXrdyQc75M2GNaYQZdLOdCAC0nOdlAv9gh6twIN4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R83rW+PCuqF4+GKyjgRmDSAyoPIY32hvDY3TWItfqw1b0NU6Fj1+9YKi2Z1KD8Ra7
	 Zwlpw0i466ZVmH2mZkftkYZC0Qpzmfik4zhifneiyU3tARuq3ErJ+W4DxvFFKjg09M
	 YAsYlarlZP+Rw1TSeHbNPM32z784KPW2bp9nTblNTpFTBE/pKcvavT1In4nxALfKrA
	 2q+BidmFj8ybCFy6T0sMG8gbuArxOiG1wjXHlJWLpkENW8gBu4OkBVHaboaN+YnPs0
	 R1JuiAlEDuGmIxs1J3GqC23C6zeJfwl08pDciQLT4IDvfEbpERJtArGCk7asppSa3c
	 puGV6+0oRmrbw==
Date: Sat, 21 Feb 2026 12:56:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
Message-ID: <20260221205606.GA23260@quark>
References: <20260206182336.1397715-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1164-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 809E816DDC0
X-Rspamd-Action: no action

On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> Hello,
> 
> These are the remaining parts from former series [1] from Omar, Sweet Tea
> and Josef.  Some bits of it were split into the separate set [2] before.
> 
> Notably, at this stage encryption is not supported with RAID5/6 setup
> and send is also isabled for now.

Where does this series apply to?  There's no base-commit or git tree,
and it doesn't apply to mainline or btrfs/for-next.

- Eric

