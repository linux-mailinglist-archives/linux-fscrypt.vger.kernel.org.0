Return-Path: <linux-fscrypt+bounces-1620-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GpqMh4ZHmokhQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1620-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:43:26 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAC4626660
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:43:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4F4153023A4D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 23:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F3538E8A4;
	Mon,  1 Jun 2026 23:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YS8So822"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2EB369D65;
	Mon,  1 Jun 2026 23:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780357404; cv=none; b=k701kYs/tt+tVh9ukOCtQoPABvMY9XPryQeUDdSdKEk1C+L4952ZuV66qdjy7YImfDiVF1Sx+1fc14BKWO33wxWqGev3Xkp5rqx4U0y/nSQF3VTGvBW6sptLHQzDBH85tOzLeDs09vcGAFC53ak9cHRHxcqTnolkZZGDffdiXfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780357404; c=relaxed/simple;
	bh=dyyVbCYfhF0ne7fVBeLpfHYmemWTvM+zrxzAGG0dV4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNtT4EzV3fnN/WUa6oG2wOjjIdaSm7FYYGCdzJRc9uAqyrrFx0wOjcky90UqI0kggK/Rg35AYVN3cDqPeCr07LioyHfhqhdBNPkmStKJ/vn3zMop0WlsMQ1Yr2EtM7L3oW7bFdiX23wt6gMwp94t2PGTYo4KsjW60LDWLMZ9LEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YS8So822; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3911F00893;
	Mon,  1 Jun 2026 23:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780357403;
	bh=+gK9RZcJQHg70lk9XCvhC2rBm1ZbkmW6WyWwQi+sjSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YS8So822tXldNNp08c59d/L3DIO8UolYxXsGDzxUQZI9fWdEXREGViW180dGtgTXu
	 X1SE2oHVjiDRdMyOkrZP/nGBCAnBAWajobUwYNkY0BjkY3ge8rJmcNioFAzwhUZYwB
	 d7pXq7ocrVlje0DlSS9Nk5D0cMg/mIrdqASYEH2V8+blalGws264fPrGc9L9u6En+9
	 S7jXz1qgQaoBUgO95eAmuFBs6VL6rVFuyknIwCWQbr5Yb8omij1BZNLkC1CrL1B9hC
	 MARATmllFWXsEbSJ1lKidMziAtCP1cBPLaQnPfkGB7SEe1ebjwXsxvS4pEo9i2HUKh
	 XrfPuYpplpbYQ==
Date: Mon, 1 Jun 2026 16:43:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 08/43] fscrypt: add documentation about extent
 encryption
Message-ID: <20260601234321.GE25574@quark>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-9-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-9-neelx@suse.com>
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
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1620-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,toxicpanda.com:email]
X-Rspamd-Queue-Id: 4BAC4626660
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:42AM +0200, Daniel Vacek wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Add a couple of sections to the fscrypt documentation about per-extent
> encryption.

A few things that were missed:

- "Contents encryption" section should be updated to document how
  extents are encrypted

- btrfs should be added to the list of filesystems in the introduction
  section and in the "Tests" section

- "Read-only kernel memory compromise" should be updated to mention the
  new limitation which extent-based encryption creates.
  Maybe after the sentence "Per-file keys for in-use files will *not* be
  removed or wiped.", insert "On filesystems that use per-extent
  encryption, master keys for in-use files will not be wiped either."

The list of filesystems can also be found in the help text for the
CONFIG_FS_ENCRYPTION kconfig.  That should be updated too.

> +For certain file systems, such as btrfs, it's desired to derive a
> +per-extent encryption key.  This is to enable features such as snapshots

It's necessary, not just "desired".  The per-file keys just don't work
when multiple files can share the same extents.

> +Currently the inode's master key and encryption policy must match the
> +extent, so you cannot share extents between inodes that were encrypted
> +differently.

Here's another instance of "the inode".  It should say something like:
Currently, each extent's master key and encryption mode always match the
corresponding values from each inode that shares the extent.

> +The extent encryption context mirrors the important parts of the above
> +`Encryption context`_, with a few omissions.  The struct is defined as
> +follows::
> +
> +        struct fscrypt_extent_context {
> +                u8 version;
> +                u8 encryption_mode;
> +                u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> +                u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> +        };
> +
> +Currently all fields much match the containing inode's encryption
> +context, with the exception of the nonce.
> +
> +Additionally extent encryption is only supported with
> +FSCRYPT_EXTENT_CONTEXT_V2 using the standard policy; all other policies
> +are disallowed.

FSCRYPT_EXTENT_CONTEXT_V2 should say FSCRYPT_EXTENT_CONTEXT_V1.

Both version and nonce are exceptions, not just nonce.

Unclear what "the standard policy" is.

- Eric

