Return-Path: <linux-fscrypt+bounces-1631-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAqpCCVaHmoKiwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1631-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 06:20:53 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id CF395628063
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 06:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B6813011048
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 04:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F653905F0;
	Tue,  2 Jun 2026 04:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUhkUdUh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA038F942;
	Tue,  2 Jun 2026 04:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780374039; cv=none; b=k/cenNHXHTf+Q25RLd0AoDuYsRDluKd5ZPXR9cL9roCmz3r4ETi3uSReynJjx/r5yFR+uZfQ+eKQ5in21atPizViX0BW4ImCvr10QyzE9eK5sCy9qPYPn2dMvNfCchGjn+GNkx5Sui/8L6apkQfOys3jOvWAHnK0JTo4Mtk26XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780374039; c=relaxed/simple;
	bh=fXRkNSigYN8SxfCNusyJyb+AdKJMHrzz/h0LJMVEAgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQMU+c2rSEYi6GTpM29H6KVoZeiG/BeshJYtqHlAkfErGiE70O73qyrtGN/G0XjPSqcdybhX0KzBiL3afTjjH/jAQKvgWXUvLQHTcycU/tYC/u0IUw2m6Uvb3vLfzLRnzx7CNNY5iFyuuWM1Y+5p/ZJxTP5pwqHoebZyy2yB7PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUhkUdUh; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344E21F00893;
	Tue,  2 Jun 2026 04:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780374037;
	bh=PgtazFpr0YW8aVw5BGlYVVCLlIVT1nUCJjctJqGMihE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GUhkUdUhHp4A2Xm0avr3tvagw8m7UYKmwlXsbXC6aThadip4Fb/0RFxGOONXr7zK1
	 cN8O59inazTeW2NO+arzGSqcd7nsz6GvyAKdCqOpO6C3wEpVgsphBgyJjnZcVHFACh
	 /iV91Fjtbeg3lSqjh6aQxh131oA5GABQ8OXivbTf1uUy67MLAS1yeN2RBBSL3p6O+d
	 5NSuyPdivLnljQTEEqCzrtwHd1CUj6TiRCE96gEDrl/OBDvcGoZoelYAlyiMbKCudf
	 6OinSG49YbljCDfcSZAQAr0oAPfa5b0m3VldS1WTWdnCD5LjsDh2ejn355x1jTXgF9
	 9+n9TOtOEPHlQ==
Date: Mon, 1 Jun 2026 21:19:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Sterba <dsterba@suse.cz>
Cc: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
Message-ID: <20260602041913.GA83438@sol>
References: <20260513085340.3673127-1-neelx@suse.com>
 <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
 <20260531002812.GA2302@sol>
 <20260601185730.GE880787@twin.jikos.cz>
 <20260602022553.GA2295@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602022553.GA2295@sol>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1631-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: CF395628063
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jun 01, 2026 at 07:25:53PM -0700, Eric Biggers wrote:
> On Mon, Jun 01, 2026 at 08:57:30PM +0200, David Sterba wrote:
> > The testing is not straightforward as it needs 3 projects to
> > synchronize, kernel, fstests and btrfs-progs. Testing may need to use
> > custom git branches for all of them. For btrfs-progs the changes will ge
> > it in soon. For fstests it can be a chicken-egg problem, as they don't
> > accept tests for unmerged code. We've been using our fstests [1] with
> > additional fixups (not upstreamable, related to CI workarounds). Though
> > I'm not sure if Daniel has updated the branch with his most recent
> > version.
> > 
> > [1] https://github.com/btrfs/fstests branch staging
> 
> Where are the btrfs-progs changes, then?  I'd like to try this out, but
> there's no way to do it without the btrfs-progs changes.

Please make sure to test with debugging options enabled as well.  Trying
it with KASAN enabled, right away there's an out-of-bounds write in
base64_encode(), because btrfs_real_readdir() has an incorrect buffer
size calculation:

    nokey_len = DIV_ROUND_UP(name_len * 4, 3);

The other filesystems do it right by using fscrypt_fname_alloc_buffer().

Of course it turns out this is in the Sashiko comments as well, quoted
below:

    Is it possible for this check to allow a heap buffer overflow in the
    filldir buffer?

    The length check estimates the fscrypt nokey name size using
    DIV_ROUND_UP(name_len * 4, 3). However, fscrypt_fname_disk_to_usr()
    prepends an 8-byte dirhash before base64 encoding. Furthermore, if
    the name length exceeds 149 bytes, it hashes the name and encodes
    exactly 189 bytes, yielding a 252-byte output.

    If the remaining buffer space is large enough to pass this nokey_len
    check but smaller than the actual bytes produced by
    fscrypt_fname_disk_to_usr(), it looks like
    fscrypt_fname_disk_to_usr() could write past the end of the
    PAGE_SIZE allocation.

I think I've done enough with this series for now.  I'll take a look
again once it's in a better shape.

- Eric

