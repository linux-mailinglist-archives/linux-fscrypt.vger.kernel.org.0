Return-Path: <linux-fscrypt+bounces-1626-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMzTHgRFHmomiQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1626-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:50:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 358FD627676
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 04:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4715D30561E5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 02:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29E0368958;
	Tue,  2 Jun 2026 02:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SU1ecd97"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33A2367B9B;
	Tue,  2 Jun 2026 02:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780368614; cv=none; b=bTGbj6I8qCaOey65pHqIMKHtHpnLoJvbfz5XEbQKK0crMpEyz73GgAzKSTqMhp2Wn0K9v7mwX/gMmUduIB4SZCAevk1U5rxCV3F5R4vBl0nNJJwcRBv4Z2ptlmkZ24gfY8yYkapCz1Hqvng8U+Rrj6pA0yqTDfYKjGhvurARF0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780368614; c=relaxed/simple;
	bh=7jbdNRqxofTaBD1pRqp6MTJ3bcSqjdg10wLnPkproQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7uIphRSSHgHMwl2svWKdIM9Sz1wIpTWcSNBvQoA+V2WHnsSCKolhzMwnZE92cL0FuJtqBKLzbpG+6Z4lKgb99bGNAgbpWTRF324et8tBNhiDF0SBl2uaN/q+z3zv1jIyj9C1aK3XaYYLepG65+f6T9qFUuaIyludGVcfoKfuVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SU1ecd97; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FD91F00893;
	Tue,  2 Jun 2026 02:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780368613;
	bh=5sPThLWLbpzXTZMO3mucEtpwYdUl7X7p67ksmsJjIPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SU1ecd97UK15fwT66sX9eoCVGh6sXpsdUsZXpTpS3MMsElpVXIQHJI5VkmyBMcTqE
	 BBBl135hNLHa2mK52U9mguGpFxsbf0BnBZgYMWQOYE0yvpODNPc5Fw53zlsEdg3H2S
	 uY7NWfli8ZGFlKWyv351oe6H4fyEgCex/usxuG9WIJmMY7XuriXR3KL1ocd+0PwT0C
	 FVwf7eihqn0acKldwteOWgzheZCbB4/8Dl8FumsPto4NjQQPjznSXfPEu6vAGwrTCG
	 cY0fvCvcC6nJlRV/Zj8bxEojgdAq/0oy2xeyzWV13YIrFVP+uZz8aE/iwq2rJpTM9N
	 88eVlBnHoyyFQ==
Date: Mon, 1 Jun 2026 19:48:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/43] blk-crypto: add a process bio callback
Message-ID: <20260602024849.GE2295@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-6-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-6-neelx@suse.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1626-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 358FD627676
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:39AM +0200, Daniel Vacek wrote:
>  /*
>   * Supported types of keys.  Must be bitflags due to their use in
>   * blk_crypto_profile::key_types_supported.
> @@ -77,12 +85,14 @@ enum blk_crypto_key_type {
>   *	filesystem block size or the disk sector size.
>   * @dun_bytes: the maximum number of bytes of DUN used when using this key
>   * @key_type: the type of this key -- either raw or hardware-wrapped
> + * @proces_bio: optional callback to process encrypted bios.
>   */
>  struct blk_crypto_config {
>  	enum blk_crypto_mode_num crypto_mode;
>  	unsigned int data_unit_size;
>  	unsigned int dun_bytes;
>  	enum blk_crypto_key_type key_type;
> +	blk_crypto_process_bio_t process_bio;
>  };

This new field needs to be initialized in
fscrypt_select_encryption_impl().  Otherwise it breaks native inline
encryption for ext4 and f2fs.

- Eric

