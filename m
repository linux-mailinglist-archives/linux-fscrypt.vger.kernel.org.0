Return-Path: <linux-fscrypt+bounces-1740-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id giUPFjW+SmoiHAEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1740-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:27:33 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D214A70B549
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:27:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ONkvNfO7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1740-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1740-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 166ED300C32C
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 20:27:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E61E136920C;
	Sun,  5 Jul 2026 20:27:30 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA360360ECD;
	Sun,  5 Jul 2026 20:27:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783283250; cv=none; b=PqLfQm5Gp1UIgmioahsZGRqQ3wzzFemQYEZQ3ySLKCzEYs3YDZOcnQEQ2S1rxUYIicuhrf27qTTWIgKaMIiMn2HCn+CFa6lckEqunwqMTZT602mc8hONU1YkepssU71UalZLzgwnBlz4Z49otRpeKJa+ylKD9n1mCpmKLwDWus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783283250; c=relaxed/simple;
	bh=AjxYSwb2WqgdMSAz7BWGA1/J/Zc1qyh5EKzw7fDuMCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLV70AKLAmROEfJR8fjoGxt6e3hbd8kKQfBWJuh7j4oOWRGzcU/xqOkelYAR9Ebv52mGlowv2Tq5ixStjRhLx89J6pdLHJzz/T6g/gpDkbeEz75EbziN7hElekYqXaBiPkn+lBvZ3FlMjONdswA5yIOnDxS5khSMFKkjAbFeoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ONkvNfO7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB921F000E9;
	Sun,  5 Jul 2026 20:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783283249;
	bh=aJn2MZML+MCpXCm1e6eEUa6PDLxWsVXQhSkdQWF+JNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ONkvNfO7vIPU2gSxzCAj2/U9qxr7COrOU3XVQNuoO3cyO4Gb2EB2KBrhR/KthBiDL
	 lIxVNbcyenO7dxge1RD+HatAJg84Rq3H+it1iXBGk1WTDVNIXVr3CC+TIhHlmrrHrV
	 mnP89jhTtAH09EIjmBbOUynb+MhUtYRbyVhkrrOzOHX/zNC8VeVVjPjDF7SdCcu17/
	 rAowTxvRBxDL9piPQHKRlG9+iuM2LAtakBYEiQ7CdfzyZLLC4hHX3U0hSLAK4GiEow
	 MEBZ7LheP/9kIL0fq3lroWPvTxZDICd0FUWpupJsIMcgBEu3U54C3066mKVgf97Q6O
	 P3I8XwjHeCHkg==
Date: Sun, 5 Jul 2026 13:27:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2 08/17] ext4: Make ext4_bio_write_folio() return void
Message-ID: <20260705202727.GJ41916@quark>
References: <20260705194555.75030-1-ebiggers@kernel.org>
 <20260705194555.75030-9-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705194555.75030-9-ebiggers@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1740-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,quark:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D214A70B549

On Sun, Jul 05, 2026 at 12:45:45PM -0700, Eric Biggers wrote:
> @@ -2724,9 +2711,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 * through a pin.
>  			 */
>  			if (!mpd->can_map) {
> -				err = mpage_submit_folio(mpd, folio);
> -				if (err < 0)
> -					goto out;
> +				mpage_submit_folio(mpd, folio);
>  				/* Pending dirtying of journalled data? */
>  				if (folio_test_checked(folio)) {
>  					err = mpage_journal_page_buffers(handle,

Sashiko found a subtle bug here, where removing this assignment to 'err'
can leak a positive 'err' value of 1 from ext4_journal_ensure_credits()
into the caller of mpage_prepare_extent_to_map() in certain cases.

I'll fix that by leaving an assignment of 0 to 'err' here.

Really, positive values shouldn't be stored in a variable named 'err' in
the first place though.

- Eric

