Return-Path: <linux-fscrypt+bounces-1619-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Hn5IooRHmrugwkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1619-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:11:06 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E848762639C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:11:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87325300E27F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 23:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68F7371CEA;
	Mon,  1 Jun 2026 23:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dh4paw87"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95334368291;
	Mon,  1 Jun 2026 23:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355356; cv=none; b=osnUT3ZkFQ3mxK7Lwm169foWN/Em6PYeRzndK1LdYEL+hdVJhx92IWD69efX4Lh0ETuaXwDDO9pJ+Tj10gdbnX+FYZoLJVXMe8TkJu4zUeWxR9kPL8DFMUOMRnpQLx9YAKA8HRLeoL76xu+6Ou6nu0NKOKd6H3/W9u0Krh1ICBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355356; c=relaxed/simple;
	bh=QEUHe17jF1z/s4sTeRaJ/QC8yl4gpkRqsb5vh1X8ePc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffLy/N3VHr0/9MSGUC86WURtJGElHT6b/9M03QFliRy0qmetRO2WyLoHDke/BTJEg+v0k7Fdvo6wodta8T06bkpZJmtJrp8HvCRBYu9zSFwaZgbcauluSgirN0O0EHbXMxFI8E1+r8all9GDQS76m/vephT6+cUfi8OwHCy5KDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dh4paw87; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2820C1F00893;
	Mon,  1 Jun 2026 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780355355;
	bh=EcIn0JdagysY/ulwgXnUitaA4RFu9sTCNRYjyUXx0VY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dh4paw87gPjL1nWquFRrRbXZ1U3vy6bT4vLBk17pSnekG1UwdGgVFhLugNvNqSrcr
	 py31cXJz1g15guUMhwz8aOmswAxKQKLmH9jJwsKwsNn24MCN8AG3n8bpISlmBA/NPW
	 3nZ+Il5c8aWf3K7LTom9VfV+xDvEv8pFg+dAqgQl5B5F7adYL6HOKUP9wFCe5xLpKx
	 urWKdvrN5HVVqIRyQMOowFrNhc1W3twPOlNYIZTnG+5QPI/jiPitofD5RM3ruw9f5p
	 SQQUm3e4qb02hhy+Fpu9wgQ3MZdwkBCZrHHZiQxcV8z05vx2al49/6aZb2BX+MP+D3
	 40FK/cjVIwvzg==
Date: Mon, 1 Jun 2026 16:09:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/43] blk-crypto: add a process bio callback
Message-ID: <20260601230913.GD25574@quark>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1619-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: E848762639C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:39AM +0200, Daniel Vacek wrote:
> @@ -330,6 +330,17 @@ static void __blk_crypto_fallback_encrypt_bio(struct bio *src_bio,
>  		}
>  	}
>  
> +	/* Process the encrypted bio before we submit it. */
> +	if (bc->bc_key->crypto_cfg.process_bio) {
> +		blk_status_t status;
> +
> +		status = bc->bc_key->crypto_cfg.process_bio(src_bio, enc_bio);
> +		if (status != BLK_STS_OK) {
> +			enc_bio->bi_status = status;
> +			goto out_free_enc_bio;
> +		}
> +	}

This looks very out of place in this function, because this function
potentially submits multiple encrypted bios whereas this code assumes
there's just one.  I think we could at least use a comment here, as well
as a WARN_ON_ONCE(!bc->bc_key->crypto_cfg.process_bio) in the case where
an additional bio is being submitted.

> +	/*
> +	 * We cannot split bio's that have process_bio, as they require the original bio.
> +	 * The upper layer must make sure to limit the submitted bio's appropriately.
> +	 */
> +	if (bio_segments(src_bio) > BIO_MAX_VECS && bc->bc_key->crypto_cfg.process_bio) {

Checks should be reversed so that the expensive bio_segments() check
only gets done if process_bio is non-NULL.

(Sashiko spotted this too, by the way)

> + * @process_bio: the call back if the upper layer needs to process the encrypted
> + *		 bio

or NULL if no such callback is needed.

> + * @proces_bio: optional callback to process encrypted bios.

Typo.

By the way, after writing kerneldoc you should run the kerneldoc
checker, as it will find things like this:

$ scripts/kernel-doc -v -none include/linux/blk-crypto.h 
Info: include/linux/blk-crypto.h:79 Scanning doc for struct blk_crypto_config
Warning: include/linux/blk-crypto.h:95 struct member 'process_bio' not described in 'blk_crypto_config'

