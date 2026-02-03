Return-Path: <linux-fscrypt+bounces-1077-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADNGJwNAgmlHRQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1077-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Feb 2026 19:35:47 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 01419DDAC2
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Feb 2026 19:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F068030EE74E
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Feb 2026 18:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C423590C3;
	Tue,  3 Feb 2026 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BMp0LuU6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/jianvj6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1xqZqDho";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZGVRnDb4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81A51A9F87
	for <linux-fscrypt@vger.kernel.org>; Tue,  3 Feb 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770143411; cv=none; b=C+7EiavYIntQiA5nLRoszUCKqvotVM4pjWvW16VBgJzX4+ZLFsW3WwhQcCsdj7XrnJuf0VQ01hFdYYKl5IbiX+RwYkUu0i+i7RW7JGulERU1YC2leIe3F/bHOlHGOPCWbYJlJVINjrohSkZCdL3IQ8RsIGcweWNo3EBSNMQa35k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770143411; c=relaxed/simple;
	bh=tbAUumX2b3s0TXzKVDoXvXb54lsPwdJJXwlj8bTxXts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJB0Hkk0UlZfJqJ161NmMCaDd12DGs3BBIQ4Dduk2c/ysPBfjFgbwPChCciS4slgGCq9y9Nfl0yx7gsCZrBrKaVoANht2Q+csWYT05+Mtkx9m/Dt7VnIlYFCe7WSdG0MMffTtrN7CgWNYv5JixdDzS25tYWxbSLGIZwh1qHNJmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BMp0LuU6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/jianvj6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1xqZqDho; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZGVRnDb4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E41443E6D0;
	Tue,  3 Feb 2026 18:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770143408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=BMp0LuU6c7tESb/HwI8YWgpAgaqRM5VBaoTI6PpyN0hEz5nmO+0wBRFXL0LFTD4wf+qHav
	HFVzs0iDbjc/XPiPXKkTO1zWZClkqF2sH5FvInXKlmhvsGEjJQ8RuPD3QhRmVT1UYA7Tni
	Rd2jPvgI+blpt3ZXaDKFfCi17HJ2OMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770143408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=/jianvj6eZ6jroFLLEXpskoB0on5wdunnaNV675eJ7wsLUsBcK3tmtWPpjizl0wWmLefyw
	IPfUQFEQGp2DWyCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1xqZqDho;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ZGVRnDb4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770143407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=1xqZqDhoroY+aWb+YP4sj8N2OVG7zUUNNQjcEDfMDroz2db8qqPhEd5RTMpB8ZzmWPsW8i
	yykjFFC9sRAtSIQzcwXcoc1g5j/hZbe5I2culWruG7Xc3pbo6OiF/2hlDg4pVI8tNvjiPv
	z/AJqvkwcLdwEd+i9yUq8ZGd5+PD5KQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770143407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oUJSBz9YfynC+iGlMIj3lZdp588PvIwvXy4YD3LexCo=;
	b=ZGVRnDb4u8RrkKi2WfehmiHmUmk2lo4RNtEV2jf0cLif9mz7nx3rFYHFNCcIAP0Si240n4
	Rx6uIlrZPg6ZeiBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B6EF73EA62;
	Tue,  3 Feb 2026 18:30:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IGVOLK8+gmkiJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 03 Feb 2026 18:30:07 +0000
Message-ID: <d9dc2ee1-283d-4467-ad36-a6a4aa557589@suse.cz>
Date: Tue, 3 Feb 2026 19:30:07 +0100
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vernon Yang <vernon2gm@gmail.com>,
 =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
 syzkaller@googlegroups.com, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 linux-fscrypt@vger.kernel.org
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo> <aYIh1wPm7BrId9dk@infradead.org>
 <6f5881df-0e0b-4278-808b-7c0cffa12a30@suse.cz>
 <aYIpVq-jTKyTQE8G@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aYIpVq-jTKyTQE8G@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1077-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_CC(0.00)[oracle.com,gmail.com,googlegroups.com,linux-foundation.org,gentwo.org,google.com,linux.dev,kvack.org,vger.kernel.org,kernel.org,lists.sourceforge.net,mit.edu];
	DMARC_NA(0.00)[suse.cz];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vbabka@suse.cz,linux-fscrypt@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:mid,suse.cz:dkim]
X-Rspamd-Queue-Id: 01419DDAC2
X-Rspamd-Action: no action

On 2/3/26 17:59, Christoph Hellwig wrote:
> On Tue, Feb 03, 2026 at 05:55:27PM +0100, Vlastimil Babka wrote:
>> On 2/3/26 17:27, Christoph Hellwig wrote:
>> > On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
>> >> Maybe the changelog could be rephrased a bit,
>> >> but overall LGTM, thanks!
>> > 
>> > 
>> > No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
>> > the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.
>> 
>> So that means as long as there's __GFP_RECLAIM, __GFP_NOFAIL isn't wrong,
>> just redundant.
> 
> Given how picky the rest of the mm is about __GFP_NOFAIL, silently
> accepting it where it has no (or a weird and unexpected) effect
> seems like a disservice to the users.

OK then. But I don't think we need to add checks to the mempool hot paths.
If somebody uses __GFP_NOFAIL, eventually it will trickle to the existing
warning that triggered here. If it's using slab then eventually that will
reach the page allocator too. Maybe not with some custom alloc functions,
but meh.

This f2fs_encrypt_one_page() case is weird though (and the relevant parts
seem to be identical in current mainline).
It uses GFP_NOFS, so __GFP_RECLAIM is there. It only adds __GFP_NOFAIL in
case fscrypt_encrypt_pagecache_blocks() already failed with -ENOMEM.

That means fscrypt_alloc_bounce_page() returns NULL, which is either the
WARN_ON_ONCE(!fscrypt_bounce_page_pool) case (but the report doesn't include
such a warning), or mempool_alloc() failed - but that shouldn't happen with
GFP_NOFS?

(Also the !fscrypt_bounce_page_pool is therefore an infinite retry loop,
isn't it? Which would be truly a bug, unless I'm missing something.)

Ah but fscrypt_encrypt_pagecache_blocks() can also return -ENOMEM due to
fscrypt_crypt_data_unit() returning it.

And there theoretically in v6.12.11 skcipher_request_alloc() could return
-ENOMEM. In practice I assume this report was achieved by fault injection.
But that possibility is gone with mainline commit 52e7e0d88933 ("fscrypt:
Switch to sync_skcipher and on-stack requests") anyway.

I think the whole "goto retry_encrypt;" loop in f2fs_encrypt_one_page()
should just be removed.



