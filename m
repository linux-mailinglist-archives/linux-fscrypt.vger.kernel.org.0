Return-Path: <linux-fscrypt+bounces-1668-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qixLJ07CO2pZcQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1668-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 13:41:02 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D83D6BDB8F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 13:41:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hF6NfODF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GY8PcayC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hF6NfODF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GY8PcayC;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1668-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1668-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1336C30185AA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 11:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B6FE377ED2;
	Wed, 24 Jun 2026 11:41:00 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A73369D6D
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jun 2026 11:40:59 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782301260; cv=none; b=FtH8OVLd4HWBVnnATOb/IDB2dz7OjsUo/+2nV+Gwd5U2ELwhZ1ECfOGoOR32vRwiJB7ZM4298+2BuqAOB+DDPjIlL4vS7ms0Zrm4bMO4lvqqiqS1nN7aD/meqAoWdz15S2M0D4HJ/dJe66kLlO6wRjOPBAx16rQ+BsPGjvyj3pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782301260; c=relaxed/simple;
	bh=K1fFXIxaesd+eFthXGatCw4ranSCgFqT9wKribOcSsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXdJM6RSlxaZKMJzKzgCqf8VHWcMSNoD7CuXyT2o0gtuD6tI+5oQz5C5DaO8uUfrSyJlqRyowclrCfCdgvv/U9BztiE81/CAeiaGZrOyippLQwv2JTDKe9xSccBtvUV7VTeNbE6ABCh4MiFabS5iaSk8JtYe+7jKyL0UCOM/zOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hF6NfODF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GY8PcayC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hF6NfODF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=GY8PcayC; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 684BF71314;
	Wed, 24 Jun 2026 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782301257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1FWZgxDjSUCom9Re05WOOJuJNeJjEZN52wMGosALaUs=;
	b=hF6NfODFPkCXvzr0SSHA/NliEy6UInLzHmobMqkJkWJfYWzdB1aaFCcQ3SiNrr4QQigZ61
	IOck3SKBclnNectWeI+wu8MiofOCvj0ZXWfpy+xmlOOYlUfZExVRabhPdzvAJwfpomETeR
	45DUjs7WXol1xxnSafaemMVirLgl+FA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782301257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1FWZgxDjSUCom9Re05WOOJuJNeJjEZN52wMGosALaUs=;
	b=GY8PcayCGoSTcAmLpIduGlP87R01qakK2tGhInNlAk5tsyVp1pmYg7EgUSRtXuSA9+T442
	xJqVt0prij7hymBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782301257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1FWZgxDjSUCom9Re05WOOJuJNeJjEZN52wMGosALaUs=;
	b=hF6NfODFPkCXvzr0SSHA/NliEy6UInLzHmobMqkJkWJfYWzdB1aaFCcQ3SiNrr4QQigZ61
	IOck3SKBclnNectWeI+wu8MiofOCvj0ZXWfpy+xmlOOYlUfZExVRabhPdzvAJwfpomETeR
	45DUjs7WXol1xxnSafaemMVirLgl+FA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782301257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1FWZgxDjSUCom9Re05WOOJuJNeJjEZN52wMGosALaUs=;
	b=GY8PcayCGoSTcAmLpIduGlP87R01qakK2tGhInNlAk5tsyVp1pmYg7EgUSRtXuSA9+T442
	xJqVt0prij7hymBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C833779A8;
	Wed, 24 Jun 2026 11:40:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PNKTFknCO2p9HgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 11:40:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EADF4A093E; Wed, 24 Jun 2026 13:40:56 +0200 (CEST)
Date: Wed, 24 Jun 2026 13:40:56 +0200
From: Jan Kara <jack@suse.cz>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Subject: Re: [PATCH 10/16] fs/buffer: Remove fs-layer decryption code
Message-ID: <hu7h6ga2ndrsedjvjbemdevjzrhvtz7jx2hbc2rtmkskufckmi@yf3a6t4hhike>
References: <20260624050334.124606-1-ebiggers@kernel.org>
 <20260624050334.124606-11-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624050334.124606-11-ebiggers@kernel.org>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1668-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,suse.com:email,suse.cz:dkim,suse.cz:email,suse.cz:from_mime];
	DMARC_NA(0.00)[suse.cz];
	FORGED_SENDER(0.00)[jack@suse.cz,linux-fscrypt@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jack@suse.cz,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0D83D6BDB8F

On Tue 23-06-26 22:03:28, Eric Biggers wrote:
> Now that fscrypt's file contents en/decryption is always implemented
> using blk-crypto when the filesystem is block-based, the fs-layer
> decryption code in fs/buffer.c is unused code.  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Fine by me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/buffer.c | 45 ++++++++-------------------------------------
>  1 file changed, 8 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 9af5f061a1f8..21dd9596a941 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -334,82 +334,53 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
>  
>  still_busy:
>  	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
>  }
>  
> -struct postprocess_bh_ctx {
> +struct verify_bh_ctx {
>  	struct work_struct work;
>  	struct buffer_head *bh;
>  	struct fsverity_info *vi;
>  };
>  
>  static void verify_bh(struct work_struct *work)
>  {
> -	struct postprocess_bh_ctx *ctx =
> -		container_of(work, struct postprocess_bh_ctx, work);
> +	struct verify_bh_ctx *ctx =
> +		container_of(work, struct verify_bh_ctx, work);
>  	struct buffer_head *bh = ctx->bh;
>  	bool valid;
>  
>  	valid = fsverity_verify_blocks(ctx->vi, bh->b_folio, bh->b_size,
>  				       bh_offset(bh));
>  	end_buffer_async_read(bh, valid);
>  	kfree(ctx);
>  }
>  
> -static void decrypt_bh(struct work_struct *work)
> -{
> -	struct postprocess_bh_ctx *ctx =
> -		container_of(work, struct postprocess_bh_ctx, work);
> -	struct buffer_head *bh = ctx->bh;
> -	int err;
> -
> -	err = fscrypt_decrypt_pagecache_blocks(bh->b_folio, bh->b_size,
> -					       bh_offset(bh));
> -	if (err == 0 && ctx->vi) {
> -		/*
> -		 * We use different work queues for decryption and for verity
> -		 * because verity may require reading metadata pages that need
> -		 * decryption, and we shouldn't recurse to the same workqueue.
> -		 */
> -		INIT_WORK(&ctx->work, verify_bh);
> -		fsverity_enqueue_verify_work(&ctx->work);
> -		return;
> -	}
> -	end_buffer_async_read(bh, err == 0);
> -	kfree(ctx);
> -}
> -
>  /*
>   * I/O completion handler for block_read_full_folio() - folios
>   * which come unlocked at the end of I/O.
>   */
>  static void bh_end_async_read(struct bio *bio)
>  {
>  	struct buffer_head *bh;
>  	bool uptodate = bio_endio_bh(bio, &bh);
>  	struct inode *inode = bh->b_folio->mapping->host;
> -	bool decrypt = fscrypt_inode_uses_fs_layer_crypto(inode);
>  	struct fsverity_info *vi = NULL;
>  
>  	/* needed by ext4 */
>  	if (bh->b_folio->index < DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
>  		vi = fsverity_get_info(inode);
>  
> -	/* Decrypt (with fscrypt) and/or verify (with fsverity) if needed. */
> -	if (uptodate && (decrypt || vi)) {
> -		struct postprocess_bh_ctx *ctx = kmalloc_obj(*ctx, GFP_ATOMIC);
> +	/* Verify (with fsverity) if needed. */
> +	if (vi && uptodate) {
> +		struct verify_bh_ctx *ctx = kmalloc_obj(*ctx, GFP_ATOMIC);
>  
>  		if (ctx) {
>  			ctx->bh = bh;
>  			ctx->vi = vi;
> -			if (decrypt) {
> -				INIT_WORK(&ctx->work, decrypt_bh);
> -				fscrypt_enqueue_decrypt_work(&ctx->work);
> -			} else {
> -				INIT_WORK(&ctx->work, verify_bh);
> -				fsverity_enqueue_verify_work(&ctx->work);
> -			}
> +			INIT_WORK(&ctx->work, verify_bh);
> +			fsverity_enqueue_verify_work(&ctx->work);
>  			return;
>  		}
>  		uptodate = false;
>  	}
>  	end_buffer_async_read(bh, uptodate);
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

