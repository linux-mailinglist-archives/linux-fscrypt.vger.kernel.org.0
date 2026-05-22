Return-Path: <linux-fscrypt+bounces-1609-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QF9eNAtPEGq5VwYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1609-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 14:41:47 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4A35B44A6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 14:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 840063000881
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 12:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07E03793A5;
	Fri, 22 May 2026 12:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tl+2esFa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5068376A00;
	Fri, 22 May 2026 12:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779452285; cv=none; b=YqMij1JdNvh5i62zOat8Sc1RY/v9zAPlvHLgrgwj0in88STgH/T9eeBLUSL0fngbiMHN47leLTpvt2/ia9ScURZfRgfDzFrBFMvscs1PdCZX08MCdxhZU++49Ma6pNRbOIqo1tKkvxKfHq7BYE/UhksgWIVhcd6jHfKdXTRRxIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779452285; c=relaxed/simple;
	bh=+bwVQxCtYAARuViyAu2lWTqAKz2VlyDWQ46QRjxS+YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCUV+rxVRFnwPZDdWT1RjjyhNaRdftfhsuBVLRb/xQ6HEH+T51BAEl3p7ADVZLoHKB1JA0o8pe5PCjm7ySZO7q/La5imWL19ahga3doPjsC814j7n8iB5aNNdXo8t6dHOfhhYgpq0ohnTuoObl/lrA6nxgQhef94FUw3k336mdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tl+2esFa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xcNjjov5dS8ZNSpJFINCrXwPB3eKvqxYhbVIIDTuLiA=; b=tl+2esFaipW1sJZ2uB/0GOaOZ1
	vFu7CkHLdq/Nr+vvVPkb4umgmvD53pPdu4DYhG/xx7IGiPW56aSXCSN2t9Oym6VE+KGd+ft6UDALz
	JEloYbHdTwHQWZMw91r7au7IUH9aBlH2/EWOe7hhyl+xD297uCrhiztVxHK5MpZ13owa8Om7cmSaw
	BxYhCNYr/FPk09PocC8vMhh4JsUuWxNFaZJ7YxEIeAHSEyAdAgI63wlDqhOl7Ziiu1oSPVIU8Tx8C
	WMXZdqn8GzgFkGlcJ2eYnJ2Zrxhph7hsHMtEjyvKrGlGXWOSEh8pN1unw6cSOyrv6Q/5hpX2kU8qI
	z4a9+4ZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQOpB-0000000Al38-49AR;
	Fri, 22 May 2026 12:17:57 +0000
Date: Fri, 22 May 2026 05:17:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v7 17/43] btrfs: add get_devices hook for fscrypt
Message-ID: <ahBJdSKMly8rv04F@infradead.org>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-18-neelx@suse.com>
 <ahAfvPa_yl6AKZoW@infradead.org>
 <CAPjX3FeoGzNOBnmY5ie34irNaAOZiFqV_Ccf7dXFrZJeUXh8PA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3FeoGzNOBnmY5ie34irNaAOZiFqV_Ccf7dXFrZJeUXh8PA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1609-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 9D4A35B44A6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 22, 2026 at 02:00:28PM +0200, Daniel Vacek wrote:
> > How does this handled adding/removing devices at runtime?
> 
> When called, this callback returns the list of bdevs opened by the
> given superblock. If devices are added or removed, this function
> returns a different list.
> In other words it always returns a valid list.
> 
> This is called from `fscrypt_get_devices()`, which is called from
> `fscrypt_select_encryption_impl()` or
> `fscrypt_prepare_inline_crypt_key()` or
> `fscrypt_destroy_inline_crypt_key()`. All these functions walk the
> returned list and discard it immediately afterwards.
> 
> Note that with btrfs at this point we're only using the inline crypto fallback.
> Is there any particular reason you asked this question?

Well, assume you have a single device fs, and then you add a device
later, you will not get the blk_crypto_config_supported call for this
device, and it will not be taken into account.

Now can btrfs even support hardware inline encryption?  The way the bio
processing is special cased I somehow doubt it.  But the concept of a
static device list just doesn't work for btrfs, so I think the fscrypt
side of this will need refactoring not to rely on it.  If we never
support hardware inline encryption on such dynamic file systems that
would be relative easy, if we need to support that case things might
get a lot more complicated.


