Return-Path: <linux-fscrypt+bounces-1621-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOFfFMUZHmokhQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1621-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:46:13 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2FE6266BC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 01:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1EDB3020A65
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 23:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC907391E6D;
	Mon,  1 Jun 2026 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYn5XAhI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E078238E8D9;
	Mon,  1 Jun 2026 23:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780357497; cv=none; b=kIQtQfRnZH5oG2MovWIY0EN4sWS8uxvItITEl0e8aZ6wreEEQQAUD5gghP8DaYdbG555rbMmyX/46ULT8rOe7u/Vnk1kGBAep/BJi/AvmagMfMqqoSK4gbOdNTYebMMv2rYXlupQSV9Td7A4CwF/i3UZviuzSOl6n/LPs0uGGEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780357497; c=relaxed/simple;
	bh=cCb524vOddz8Hiye01fLD0AwPPojC5wz3lc/rB0xB4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UoUXonXpQg4IhuTql8CGFHzWYzPcccEWa4tjfHu5j8x9WcNOG8JT5nT1UelTNI2tu/N8jOFt6qTVxsGww59KbrJG6IANUEHsSZbM051a+60w1LiIowO+mpBitCH4yep8r0tb27zekWuVAXsbLTx+OvkA2aem7GxxYg98jfjXFlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYn5XAhI; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2AC1F00893;
	Mon,  1 Jun 2026 23:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780357496;
	bh=fIDKssFBzilaWK1Rmz+aCBZVd9dtI7u6nXWjJMNn0bk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hYn5XAhIINtA/yDZ1dCkDJ5BRJUrr4gKl4genkV7zxDX07tEHECbc7PlSJIj/llay
	 NF2MpN3ewKDvFkHytEVwIW6lSMXwYr09DUOgaJwxzIokk7Haix5/OO4BCEzYHWCNdS
	 9NLBauGlQwN3VBDKw0CwfDuOk3PBEVqjx3WtBzef8viWU33NQTVDr0XOvw9cDju0eE
	 zGdXuJQ0F9WLr1ieDmGum5KmnZVifo9aG9oqkOGL1Ra1inNf4jeiAXHjZLTVXd6y/L
	 k2ZyP61vYpaxbuiPO6x//K2BvqT4iE6vkHJ0js5lPMUC2Eoyy6FguAju9eo1qXK5t8
	 X3BoOCh6As5aQ==
Date: Mon, 1 Jun 2026 16:44:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH v7 13/43] btrfs: adapt readdir for encrypted and nokey
 names
Message-ID: <20260601234454.GF25574@quark>
References: <20260513085340.3673127-1-neelx@suse.com>
 <20260513085340.3673127-14-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085340.3673127-14-neelx@suse.com>
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
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1621-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: AB2FE6266BC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 13, 2026 at 10:52:47AM +0200, Daniel Vacek wrote:
> +	/*
> +	 * TODO: This should maybe be using the crypto API, not the fallback,
> +	 * but fscrypt uses the fallback and this is only used in emulation of
> +	 * fscrypt's buffer sha256 method.
> +	 */

You can delete this TODO.  The SHA-256 library functions just do the
right thing now.

- Eric

