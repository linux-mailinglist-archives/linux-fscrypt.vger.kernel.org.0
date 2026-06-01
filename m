Return-Path: <linux-fscrypt+bounces-1615-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QD9rEB7nHWp0fwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1615-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 22:10:06 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6DB1624EEF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 22:10:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A1DBA3009098
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 20:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F12836F90F;
	Mon,  1 Jun 2026 20:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQKE199v"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62723346A15;
	Mon,  1 Jun 2026 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780344603; cv=none; b=fz1B5Vfd26PwcyM52VZotyTubCTs3xTrfZ5zw+wQyOh9ZGLUE6LOrQqQcQbgEgFrh8b48/7BAsfMcFlA8ZxW+kI6HgKaNtCpYtqv34wfzV3s9DPGt0qCuQmXg8ccHnVc+PI4bfr1kjzj0Ts4RnVhn9TBoxRVB/dalWJf0lXig3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780344603; c=relaxed/simple;
	bh=J4NLWYrtXzrmKbdnFr/CbFj7YfswH0ljO2anTMr1bNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IiIWTzFlvUQW8MitYWuL0uzZgBdiXcUzvPI4S2DPwyY4qmdeXc/ceRhJCtNO8AjjziI9csbUrE7Ruvs+xn2IdnbGdNy0SFMjvp6n5yzklgPNJ3AbFwTLqQ573C2aGK9u+17jPqC/+BFwZKmilaMlOFRL55+TWVokzSCRW9ue3f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQKE199v; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4281F00893;
	Mon,  1 Jun 2026 20:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780344602;
	bh=lgRwmaM2uhQrAN5Dh3SfBfVPEi6TBqO8y6rbloJlsMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PQKE199vAOWAvJe7WVAmi91wznp187zXk5/D04V8u7lJrExjhjsUUUseYEkwr5u3g
	 upUXYsuJNhP1Ikw93hBc27ec+V+c2t7cPtaSJkcNVrHOPAa9CcdT1Z9d8+bJWMHUTq
	 Ob26pSHmiixhtlgM6UTkplSzcubx63KzZtJj0hHrPdNUDMOUlFA7v0ajC5l52ucxC6
	 dLVXqepaaa9bBS/HG4XYgMfScQ1+eCqtiJdTAq548SEh1hzZbRHW3sRc4dZNdNzLJO
	 e9t7N2edt5ErfLBek2A9b+KycAYPsH6qnHLBVFOYQIdOC0MT/BNZwTIy1Im2YxzdLI
	 uwj2V+p3msG7A==
Date: Mon, 1 Jun 2026 20:09:59 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Sterba <dsterba@suse.cz>
Cc: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
Message-ID: <20260601200959.GA1275569@google.com>
References: <20260513085340.3673127-1-neelx@suse.com>
 <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
 <20260531002812.GA2302@sol>
 <20260601185730.GE880787@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601185730.GE880787@twin.jikos.cz>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-1615-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_TWELVE(0.00)[12];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: D6DB1624EEF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jun 01, 2026 at 08:57:30PM +0200, David Sterba wrote:
> On Sat, May 30, 2026 at 05:28:12PM -0700, Eric Biggers wrote:
> > On Fri, May 22, 2026 at 09:00:46AM +0200, Daniel Vacek wrote:
> 
> > It's been really hard to find time to review this huge patchset.  I've
> > started going through it and will try to leave comments next week.
> 
> Thank you. The patchset is huge but we'd like your feedback namely on
> the crypto layer changes, i.e. the first 8 patches.

I know, but properly reviewing those patches requires reviewing their
usage in btrfs too.  Plus the whole feature needs to be solid: if
there's a problem with it that's my problem too.  And some problems,
e.g. any in the on-disk format, would be unfixable later, so we have to
get them right from the beginning.

> It's too late for 7.2 also because you've asked for some changes.

I think the Sashiko reviews alone make it very clear that this needs
some more work.  So if you're considering this to be ready and just
waiting for me, I don't think that's the best way to move this forwards.

> I'm not sure if it was mentioned before wrt how to get this merged. My
> preferred way is to get your Ack for the crypto changes and then we can
> add it to linux-next via our btrfs git.

That will be fine once it's ready.

- Eric

