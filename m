Return-Path: <linux-fscrypt+bounces-1614-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4D7HDyXWHWq6fAkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1614-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 20:57:41 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A70624545
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 20:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1C5D1300C0E1
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 18:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4091736A03A;
	Mon,  1 Jun 2026 18:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lRv9FZWv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Orov3lwY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lRv9FZWv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Orov3lwY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D952E36494B
	for <linux-fscrypt@vger.kernel.org>; Mon,  1 Jun 2026 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780340259; cv=none; b=uuCjuXTBATdD9aHbWEiPn8bd3ExU8wzUoW3aK4h6lnmQS3vPimng2IhUqVJqx51QtXePBkA4Wsh4ILK9SS5PabELMDCFddobVe+LkQCzEh4dvWmrxbdrPU/euC3D3ObHzNzcRBsUKvZ/97NNUtbjVknvw4qPODvYvqXQy/AV8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780340259; c=relaxed/simple;
	bh=89tOA/vg8ODxo9Bd1kZAVRxj1Qun7rG5iGCntXOsfwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2IQVrufIm3xoPflKtnKcYM8VNEBA7l864uSbXNNTHL2Srd27lzZjLVv67i/nDQl2CYtjytW6RdvuX6oRjuw9Go0D+auJ6iP8m6/w7+j7nPA2118s0nWeYqxmgwMB8dGfDxeXfjSFhYpDvhTeAwBn7WtkEW/xm2YaHxxdPzGih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lRv9FZWv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Orov3lwY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lRv9FZWv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Orov3lwY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23A346B645;
	Mon,  1 Jun 2026 18:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780340256;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2BQBHJyYMWnTxoTg7lZFROZPbjpK0REybaOLyY1zGMo=;
	b=lRv9FZWvI94VUYOpxJMCy2kLL6Bu6+3EsNZUzAnvNuCKo1QUuQkOI3zKss9ofXNX+YfLe3
	q9w0lHsP9TeeJn46LjTjLKEt38KlHUn7A7uVTNCLmx3d55vxFi3wMomNejbBeSOEYjhxGT
	YMVAcWgJVLsKq3fmuW/i901rtAqBWc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780340256;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2BQBHJyYMWnTxoTg7lZFROZPbjpK0REybaOLyY1zGMo=;
	b=Orov3lwYX6ld8pYiDK+atsNbPbR+/S5KpgtJ9aR09hUcycQjEor5HwTw3n2Xj68UjjUL2p
	7ZW8RpYU3TeQjwCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780340256;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2BQBHJyYMWnTxoTg7lZFROZPbjpK0REybaOLyY1zGMo=;
	b=lRv9FZWvI94VUYOpxJMCy2kLL6Bu6+3EsNZUzAnvNuCKo1QUuQkOI3zKss9ofXNX+YfLe3
	q9w0lHsP9TeeJn46LjTjLKEt38KlHUn7A7uVTNCLmx3d55vxFi3wMomNejbBeSOEYjhxGT
	YMVAcWgJVLsKq3fmuW/i901rtAqBWc0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780340256;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2BQBHJyYMWnTxoTg7lZFROZPbjpK0REybaOLyY1zGMo=;
	b=Orov3lwYX6ld8pYiDK+atsNbPbR+/S5KpgtJ9aR09hUcycQjEor5HwTw3n2Xj68UjjUL2p
	7ZW8RpYU3TeQjwCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E462779A7;
	Mon,  1 Jun 2026 18:57:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1jo9AyDWHWrlDgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 01 Jun 2026 18:57:36 +0000
Date: Mon, 1 Jun 2026 20:57:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
Message-ID: <20260601185730.GE880787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260513085340.3673127-1-neelx@suse.com>
 <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
 <20260531002812.GA2302@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531002812.GA2302@sol>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1614-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	HAS_REPLYTO(0.00)[dsterba@suse.cz];
	RCVD_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dsterba@suse.cz,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,sashiko.dev:url,suse.cz:replyto,suse.cz:dkim]
X-Rspamd-Queue-Id: D6A70624545
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, May 30, 2026 at 05:28:12PM -0700, Eric Biggers wrote:
> On Fri, May 22, 2026 at 09:00:46AM +0200, Daniel Vacek wrote:

> It's been really hard to find time to review this huge patchset.  I've
> started going through it and will try to leave comments next week.

Thank you. The patchset is huge but we'd like your feedback namely on
the crypto layer changes, i.e. the first 8 patches. As this is outside
of btrfs code we can't fix it incrementally later on. The current size
of btrfs-only can be slightly reduced but a lot of must stay so it's
clear how the fscrypt API is used.

I'm not sure if it was mentioned before wrt how to get this merged. My
preferred way is to get your Ack for the crypto changes and then we can
add it to linux-next via our btrfs git.

It's too late for 7.2 also because you've asked for some changes. So the
target is 7.3, hopefully giving all of us enough time to have the
mergeable version in ~7.2-rc3 timeframe.

If you have other ideas how to proceed with the merge process, please
let me know.

> In the mean time it would be really helpful if you went through the
> Sashiko reviews
> (https://sashiko.dev/#/patchset/20260513085340.3673127-1-neelx%40suse.com)
> and address the ones that make sense to.  It found 93 issues including
> 16 critical ones, which is kind of a lot.  Some of them are the same
> things I'm noticing already.  Same for the issue that Christoph noticed
> where new devices can be added; Sashiko had already found that too.
> 
> If I'm going to have to use my limited human review time to point out
> issues that were already found, that's not a great use of time.
> 
> I also don't see any information about how this was tested (and will
> continue to be tested in the future).

The testing is not straightforward as it needs 3 projects to
synchronize, kernel, fstests and btrfs-progs. Testing may need to use
custom git branches for all of them. For btrfs-progs the changes will ge
it in soon. For fstests it can be a chicken-egg problem, as they don't
accept tests for unmerged code. We've been using our fstests [1] with
additional fixups (not upstreamable, related to CI workarounds). Though
I'm not sure if Daniel has updated the branch with his most recent
version.

[1] https://github.com/btrfs/fstests branch staging

