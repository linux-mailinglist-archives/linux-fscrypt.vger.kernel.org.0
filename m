Return-Path: <linux-fscrypt+bounces-1546-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OVwOCxP3mndqAkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1546-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 16:29:00 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 249CA3FB35D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 16:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D7883011F1F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 14:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 098083E5EF9;
	Tue, 14 Apr 2026 14:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="gGyqYRpo"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B762C11FA;
	Tue, 14 Apr 2026 14:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776176597; cv=none; b=bcYTISh7Ii37FGjpCALcYI7TDnA2Y1eSpJFOu3ZC6/upbTvP53qBdjuMQ1g0U7IhRgPw19khPL8LpZZLeS/xSBpjsJTGP2mkjkIzP1v0pLhMQKhybvYRKSUkbshR8XgWik4O3qPZgpGnzhKQxptbLYoGf7m4iHRELgUaCfu7oWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776176597; c=relaxed/simple;
	bh=ODB+YGZ09V5IQ5oRevNOIZkdLcQEXsVTN/E8mUsER9Q=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/psC00PjAcuwbm9J4V0uZDGyRjioiKYVT+sqmAKArXhknEOh1RC/qtfWbwr9+5UBS7gyV7jhUUxHj11as756NmIkq9HflsfiO1VoObgjr07b48p7LQUBtaFLRR4Y1N0+szAFkT8iOaM8BeBuZKSnc4vUxsO0gp69BP/KnkOE5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=gGyqYRpo; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 5695F31D294;
	Tue, 14 Apr 2026 15:23:10 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1776176590;
	bh=7HHijSC02lyJ7JT26dDEcMH3mIViAKfEQX/oiIsbBHY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gGyqYRpoRMMTfu+KVEl9eSi/rSJBD5Xlny18SQiCotDZE2KQ/b93OIv6LjSIB+Dgo
	 bUioevdKmE6bSSKVbPk/LufQkWO1+u/o6torDYs+r6Jnk0A9QOX8zQJkitWvTia+6z
	 E272YGf8J0ZjdQSatbgXb0q7imN/yCvATNq6Bq7o=
Message-ID: <368482e0-7a4a-445d-9313-fd6b825ed33b@harmstone.com>
Date: Tue, 14 Apr 2026 15:23:09 +0100
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v6 24/43] btrfs: add extent encryption context tree item
 type
To: Daniel Vacek <neelx@suse.com>, Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260206182336.1397715-1-neelx@suse.com>
 <20260206182336.1397715-25-neelx@suse.com>
 <20260208151728.3212554-1-clm@meta.com>
 <CAPjX3FdgJKQyM0tdCksgLAtVyjos_nx3TRg6rvjYB1wE2QH1Cw@mail.gmail.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <CAPjX3FdgJKQyM0tdCksgLAtVyjos_nx3TRg6rvjYB1wE2QH1Cw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[harmstone.com,none];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[harmstone.com:s=mail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1546-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[harmstone.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mark@harmstone.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[harmstone.com:dkim,harmstone.com:mid,meta.com:email,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,toxicpanda.com:email]
X-Rspamd-Queue-Id: 249CA3FB35D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 18/02/2026 5.25 pm, Daniel Vacek wrote:
> On Sun, 8 Feb 2026 at 16:17, Chris Mason <clm@meta.com> wrote:
>> Daniel Vacek <neelx@suse.com> wrote:
>>> From: Josef Bacik <josef@toxicpanda.com>
>>>
>>> The fscrypt encryption context will be stored as a new tree item type.
>>> This gives us flexibility to include different things in the future.
>>>
>>> Also update the tree-checker to validate the new item type.
>>
>> Hi everyone,
>>
>> I'm running the btrfs for-next branch, along with the encryption patch set
>> through my AI review prompts:
>>
>> https://github.com/masoncl/review-prompts
>>
>> I'm working on some btrfs specific instructions, but hopefully these reviews
>> are already useful.  I've kept the headers to make it easier to double check
>> that I'm actually replying to the right email, but please let me know if any
>> parts of this are incorrect:
>>
>> commit 203bfb91a4db9c826fa7f72034c13a1810a1b605
>> Author: Josef Bacik <josef@toxicpanda.com>
>>
>> btrfs: add extent encryption context tree item type
>>
>> The fscrypt encryption context will be stored as a new tree item type.
>> This gives us flexibility to include different things in the future.
>> Also update the tree-checker to validate the new item type.
>>
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 3c0db279f592e..639462164d089 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>
>> [ ... ]
>>
>>> @@ -496,6 +503,60 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>>>                args->extent_inserted = true;
>>>        }
>>>
>>> +     if (first_ctx <= last_ctx) {
>>> +             int slot, nritems;
>>> +
>>> +             btrfs_release_path(path);
>>> +
>>> +             key.objectid = ino;
>>> +             key.type = BTRFS_FSCRYPT_CTX_KEY;
>>> +             key.offset = first_ctx;
>>> +
>>> +             ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
>>> +             if (ret < 0)
>>> +                     goto out_ctx;
>>
>> [ ... ]
>>
>>> +out_ctx:
>>> +             if (args->path && args->extent_inserted) {
>>> +                     btrfs_release_path(path);
>>> +
>>> +                     key.objectid = ino;
>>> +                     key.type = BTRFS_EXTENT_DATA_KEY;
>>> +                     key.offset = args->start;
>>> +                     ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
>>> +             }
>>> +     }
>>> +
>>
>> Can btrfs_search_slot() at line 556 overwrite an error that occurred
>> earlier in the out_ctx path?
>>
>> If btrfs_search_slot() at line 515 fails and execution jumps to out_ctx,
>> but args->path and args->extent_inserted are both true, the second
>> btrfs_search_slot() call will overwrite the original error stored in ret.
>>
>> If this second search succeeds (returns 0 or >0), the function returns
>> success to the caller despite the fscrypt context cleanup having failed.
>> This could lead to inconsistent filesystem state where extent data was
>> inserted but the corresponding fscrypt context items were not properly
>> cleaned up.
> 
> Right, the original error should be returned. We do not care that much
> about the latter if the former failed.
> This should do the trick:
> 
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -549,12 +549,16 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>           }
>   out_ctx:
>           if (args->path && args->extent_inserted) {
> +            int err;
> +
>               btrfs_release_path(path);
> 
>               key.objectid = ino;
>               key.type = BTRFS_EXTENT_DATA_KEY;
>               key.offset = args->start;
> -            ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
> +            err = btrfs_search_slot(trans, root, &key, path, 0, 0);
> +            if (err && ret >= 0)
> +                ret = err;
>           }
>       }
> 
> 
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index 9675dbcd78a3b..776901f297fea 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>
>> [ ... ]
>>
>>> +static int check_fscrypt_context(struct extent_buffer *leaf,
>>> +                              struct btrfs_key *key, int slot,
>>> +                              struct btrfs_key *prev_key)
>>> +{
>>> +     u32 sectorsize = leaf->fs_info->sectorsize;
>>> +     u32 item_size = btrfs_item_size(leaf, slot);
>>> +
>>> +     if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>>> +             file_extent_err(leaf, slot,
>>> +"unaligned file_offset for encryption context, have %llu should be aligned to %u",
>>> +                     key->offset, sectorsize);
>>> +             return -EUCLEAN;
>>> +     }
>>> +
>>> +     /*
>>> +      * Previous key must have the same key->objectid (ino).
>>> +      * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
>>> +      * But if objectids mismatch, it means we have a missing
>>> +      * INODE_ITEM.
>>> +      */
>>
>> This isn't a bug, but the comment says "It can be XATTR_ITEM, INODE_ITEM
>> or just another EXTENT_DATA" - can EXTENT_DATA actually be the previous
>> key type?
>>
>> For BTRFS_FSCRYPT_CTX_KEY (type=42), EXTENT_DATA (type=108) cannot be a
>> previous key because keys are sorted by (objectid, type, offset) and
>> 108 > 42.
>>
>> The correct previous key types would be: XATTR_ITEM, INODE_ITEM,
>> FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.
> 
> Spot on! The comment is wrong. I realized that later but never fixed it here.
> This is because of the redesign. In v5 the crypt context was embedded
> in the extent data item, so they could have been next to each other.
> This should look better:
> 
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -220,10 +220,9 @@ static int check_fscrypt_context(struct
> extent_buffer *leaf,
>       }
> 
>       /*
> -     * Previous key must have the same key->objectid (ino).
> -     * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
> -     * But if objectids mismatch, it means we have a missing
> -     * INODE_ITEM.
> +     * Previous key must have the same key->objectid (ino).  It can be
> +     * XATTR_ITEM, INODE_ITEM, FSCRYPT_INODE_CTX_KEY, or another
> FSCRYPT_CTX_KEY.
> +     * But if objectids mismatch, it means we have a missing INODE_ITEM.
>        */
>       if (unlikely(!check_prev_ino(leaf, key, slot, prev_key)))
>           return -EUCLEAN;
> 
>>> @@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>>>        u32 item_size = btrfs_item_size(leaf, slot);
>>>        u64 extent_end;
>>>        u8 policy;
>>> +     u8 fe_type;
>>>
>>>        if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>>>                file_extent_err(leaf, slot,
>>
>> [ ... ]
>>
>>> @@ -298,6 +333,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>>>                return 0;
>>>        }
>>>
>>> +     if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
>>> +             /*
>>> +              * Only regular and prealloc extents should have an encryption
>>> +              * context.
>>> +              */
>>> +             if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
>>> +                          fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
>>> +                     file_extent_err(leaf, slot,
>>> +             "invalid type for encrypted file extent, have %u", fe_type);
>>> +                     return -EUCLEAN;
>>> +             }
>>> +     }
>>
>> Can this validation check detect encrypted inline extents? Looking at
>> the function flow, inline extents (BTRFS_FILE_EXTENT_INLINE) are handled
>> at lines 310-333 and return before reaching this check.
>>
>> If a corrupted filesystem has an encrypted inline extent, it would pass
>> tree-checker validation. Should the encryption check be moved to also
>> cover the inline extent path, or should inline extents explicitly reject
>> BTRFS_ENCRYPTION_FSCRYPT?
> 
> Inline extents are not encrypted.

Hi Daniel,

I've been playing around with this, and from what I gather:

* max_inline seems to be forced to 0, meaning that inline encrypted 
extents won't be created
* symlinks still use inline extents, but AFAICS their values get munged 
by fscrypt

Which suggests that we ought to be setting the encrypted flag on for 
inline extents in symlinks.

Please tell me if I've misunderstood any of this.

Thanks

Mark

> Thanks.
> 
> --nX
> 
> On Sun, 8 Feb 2026 at 16:17, Chris Mason <clm@meta.com> wrote:
>>
>> Daniel Vacek <neelx@suse.com> wrote:
>>> From: Josef Bacik <josef@toxicpanda.com>
>>>
>>> The fscrypt encryption context will be stored as a new tree item type.
>>> This gives us flexibility to include different things in the future.
>>>
>>> Also update the tree-checker to validate the new item type.
>>
>> Hi everyone,
>>
>> I'm running the btrfs for-next branch, along with the encryption patch set
>> through my AI review prompts:
>>
>> https://github.com/masoncl/review-prompts
>>
>> I'm working on some btrfs specific instructions, but hopefully these reviews
>> are already useful.  I've kept the headers to make it easier to double check
>> that I'm actually replying to the right email, but please let me know if any
>> parts of this are incorrect:
>>
>> commit 203bfb91a4db9c826fa7f72034c13a1810a1b605
>> Author: Josef Bacik <josef@toxicpanda.com>
>>
>> btrfs: add extent encryption context tree item type
>>
>> The fscrypt encryption context will be stored as a new tree item type.
>> This gives us flexibility to include different things in the future.
>> Also update the tree-checker to validate the new item type.
>>
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index 3c0db279f592e..639462164d089 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>
>> [ ... ]
>>
>>> @@ -496,6 +503,60 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
>>>                args->extent_inserted = true;
>>>        }
>>>
>>> +     if (first_ctx <= last_ctx) {
>>> +             int slot, nritems;
>>> +
>>> +             btrfs_release_path(path);
>>> +
>>> +             key.objectid = ino;
>>> +             key.type = BTRFS_FSCRYPT_CTX_KEY;
>>> +             key.offset = first_ctx;
>>> +
>>> +             ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
>>> +             if (ret < 0)
>>> +                     goto out_ctx;
>>
>> [ ... ]
>>
>>> +out_ctx:
>>> +             if (args->path && args->extent_inserted) {
>>> +                     btrfs_release_path(path);
>>> +
>>> +                     key.objectid = ino;
>>> +                     key.type = BTRFS_EXTENT_DATA_KEY;
>>> +                     key.offset = args->start;
>>> +                     ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
>>> +             }
>>> +     }
>>> +
>>
>> Can btrfs_search_slot() at line 556 overwrite an error that occurred
>> earlier in the out_ctx path?
>>
>> If btrfs_search_slot() at line 515 fails and execution jumps to out_ctx,
>> but args->path and args->extent_inserted are both true, the second
>> btrfs_search_slot() call will overwrite the original error stored in ret.
>>
>> If this second search succeeds (returns 0 or >0), the function returns
>> success to the caller despite the fscrypt context cleanup having failed.
>> This could lead to inconsistent filesystem state where extent data was
>> inserted but the corresponding fscrypt context items were not properly
>> cleaned up.
>>
>>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>>> index 9675dbcd78a3b..776901f297fea 100644
>>> --- a/fs/btrfs/tree-checker.c
>>> +++ b/fs/btrfs/tree-checker.c
>>
>> [ ... ]
>>
>>> +static int check_fscrypt_context(struct extent_buffer *leaf,
>>> +                              struct btrfs_key *key, int slot,
>>> +                              struct btrfs_key *prev_key)
>>> +{
>>> +     u32 sectorsize = leaf->fs_info->sectorsize;
>>> +     u32 item_size = btrfs_item_size(leaf, slot);
>>> +
>>> +     if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>>> +             file_extent_err(leaf, slot,
>>> +"unaligned file_offset for encryption context, have %llu should be aligned to %u",
>>> +                     key->offset, sectorsize);
>>> +             return -EUCLEAN;
>>> +     }
>>> +
>>> +     /*
>>> +      * Previous key must have the same key->objectid (ino).
>>> +      * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
>>> +      * But if objectids mismatch, it means we have a missing
>>> +      * INODE_ITEM.
>>> +      */
>>
>> This isn't a bug, but the comment says "It can be XATTR_ITEM, INODE_ITEM
>> or just another EXTENT_DATA" - can EXTENT_DATA actually be the previous
>> key type?
>>
>> For BTRFS_FSCRYPT_CTX_KEY (type=42), EXTENT_DATA (type=108) cannot be a
>> previous key because keys are sorted by (objectid, type, offset) and
>> 108 > 42.
>>
>> The correct previous key types would be: XATTR_ITEM, INODE_ITEM,
>> FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.
>>
>>> @@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>>>        u32 item_size = btrfs_item_size(leaf, slot);
>>>        u64 extent_end;
>>>        u8 policy;
>>> +     u8 fe_type;
>>>
>>>        if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
>>>                file_extent_err(leaf, slot,
>>
>> [ ... ]
>>
>>> @@ -298,6 +333,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
>>>                return 0;
>>>        }
>>>
>>> +     if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
>>> +             /*
>>> +              * Only regular and prealloc extents should have an encryption
>>> +              * context.
>>> +              */
>>> +             if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
>>> +                          fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
>>> +                     file_extent_err(leaf, slot,
>>> +             "invalid type for encrypted file extent, have %u", fe_type);
>>> +                     return -EUCLEAN;
>>> +             }
>>> +     }
>>
>> Can this validation check detect encrypted inline extents? Looking at
>> the function flow, inline extents (BTRFS_FILE_EXTENT_INLINE) are handled
>> at lines 310-333 and return before reaching this check.
>>
>> If a corrupted filesystem has an encrypted inline extent, it would pass
>> tree-checker validation. Should the encryption check be moved to also
>> cover the inline extent path, or should inline extents explicitly reject
>> BTRFS_ENCRYPTION_FSCRYPT?
>>
> 


