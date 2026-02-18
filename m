Return-Path: <linux-fscrypt+bounces-1156-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LFtM8nklWneVwIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1156-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 17:11:53 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EBE1579FC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 17:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5BD073017C14
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29BA5343D60;
	Wed, 18 Feb 2026 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PfZdcMqY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583933A9C5
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771431089; cv=pass; b=nayZtAVcZEXEo+BrMSjqn+8i/pYO8mpqPMOnvBGsLog37jfWenq0/Wrc7rKR0zEjphvytwiycZPtMT+6OyYSamioqTt77JbqZr0AKs0vFlDZ+K91JEbYFnbPtBAwG9rqbA4OovCsS08+cEV+wo6uY8yftkm3Q2BeDZbumDp7QOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771431089; c=relaxed/simple;
	bh=Dnfw3O7yWCnVIQEgDYrdHlr08rz6PxDdK3ndz6QSILY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l+Itk2KiHLSO5+mky+rq9Au80u6KyhsaCbw5CR4Otx48WDYgUC9WkwZtk6tzXwCRSwKAsoYHm4wFiR0lGSNSPffpmaTPwqkb86+H1pXCVxUyYMe0V3g11smQlJ1g/s8EMM/OzvtfNvyLp4VsPG255i3pDWOB7RCQbYEhmES69bw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PfZdcMqY; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43626796202so5088168f8f.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 08:11:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771431084; cv=none;
        d=google.com; s=arc-20240605;
        b=jkA49039HIorCIVOIUDTLzFVeIJkvbMGXhAysazcaOI3A1x7ufIf4iYMn1EK4e7/gm
         Y8S6Mvol3+i5g/irc8fMuVoBv2R3hCg6KeK9ks/4RRfZdkymJZl1JBS5onLIdr6TW6lC
         8Ixg6eUzIgmzwbHX4nGqkkYpWcY2kZoyfRbxsDj6G5Z58mgvGgVOQWYV2HvPCjeXx9YK
         63O53PP5fFa88VtIk4bZ2PmYLoHb5AhshXY0eFH57zDWiQBKSYNErEmkQsCMpIIRwKDf
         CyfpeDJJnXbGcuZ/l5mC6klNtZHqqzyzzLG2gvWCD4aGGWXLJ70A2YwqZ2muEajgW8F4
         0U2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=npZADHZ7rRxwkGy8riawRonufvbdSCewmEnndlsCQtE=;
        fh=n3VzHsxxHqd9RSJyG1jKaZEVTordLXxN0wvfaHsyWGM=;
        b=VnxUjNabjt+Ob5XZv3wZ1IUHi9BcO2Kf5j5O9UQFl9sHcIcd1oFjSKRh8Lz/TRdVJy
         qfAlVIyGR54tFnxc4PyvF+/UWLuy7axu9PpMe492Cqu3BRccp3PqPGHgeh+672WMp0bu
         fAHcD82jRW2cJyeaRLIoNWyMQ2ioyla8m3nDZ56Mxmn9nfUSbm/LImbN7AmrDIIOMplg
         mcytSdocjiXFJ88rLSb7a4d1QoGXTbXVQZeUGbkH8p22ys10PjI2FSc8bX/HnIU7Ql0G
         oTerK2JtYg6l0oeYkpCpPqQ5g4JbLxhcoWA6pxGkg85RaNXlVnjUGshB7a92Vv4i3htv
         wRTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771431084; x=1772035884; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=npZADHZ7rRxwkGy8riawRonufvbdSCewmEnndlsCQtE=;
        b=PfZdcMqYwNT7onik+41pV0XW615Gz/ybTHKwKGbSkAOd6Mos1WFO7LFtssv3KsJMAR
         XO1TRVb6Qo9qvBRRnOAWBFni1s0Zr1eQu98HHdBJLIqTgYGHCQqJovzdZJXq5RY7WgBA
         KbyJMtBcWCKZLenWtLsvG4qStEZNU8jXJeRMurhR7RdIDttjb3aOAftogUIVGiwTD2ZU
         nRghyuIC+NU7OcJgVdDcGZ5i7lez+7EHPkSZypqLabQ+eMSL1t2/DOfNeqwydh729w4J
         vA4ZP+FZ3IjJp+guVfb6qPNiGwFesSdjS0Ey9sQ8kUrOWMHj0hurPFY7lF2535atr29C
         kOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771431084; x=1772035884;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npZADHZ7rRxwkGy8riawRonufvbdSCewmEnndlsCQtE=;
        b=hAoE+SKzm4im+Jb7hVPh+NerD+0kI93vKXlr1A0RH/JZMfwGGQWy4PbSoJr75EjBiZ
         kewJ4L4Cr9bCNIDDeN0kiI+IzVL94N3Qc+yeoEIZJZXVItTqASjRkAd6n2O62CQ4UGix
         ZuPdYE8OXrXrINg5KEASZDdCJ8VvWW1cFjekLaU1gCgvzxhjOCYLUhpKJZBQgLqvAQ+R
         AxCqR3FNjuYPCZjzwzLvibfcsg6k2b0eIpvr/fMOKBBcUOAYej9pHIlSUeXh0l71lD6o
         tJ8/oQLZA1MLNAT7a0DV50BEhK4VmFmui3DcLxZlrCeEkDjkVsm2x/WbwmZ8ieDAuL1Q
         Yk/w==
X-Forwarded-Encrypted: i=1; AJvYcCWQ5tDO4BDSDXfutbYikhDqHKBj4+biwdwS3DBmDRlnZC0J0k0iTRj6SbbrYcukKhx267qqCmh010GRJ0Se@vger.kernel.org
X-Gm-Message-State: AOJu0YzyelN0+hz1jykd2lcEoaF6j7fQBFyyiLigVq45Ceb+dwvew6KQ
	OJREdpnbplYhe3Pg+dW7yDSCW6WjBl4Hl0/wJRfs6HoeJcBUeie2IXWu4fubcEzSAOEHkQunDGj
	W2htv0Ovgl8IlgdsnVngV5we5klpDKPb2cRvwga+IrA==
X-Gm-Gg: AZuq6aJXivXPr1cIFl+Ww+31uVY7uhhpLugVzNXMMO+mQENgRluYTcuiXNESYbF0WUz
	aZaDICNNRwiKD8LzRvHUDwNzwvlwYpKP3YLJGEfMpvMtVfo2CHFVGFoZBB9+9ZskLLcsUArWLgE
	YjOfZwqEAK9JxWqMGGJ3XtVyPrORoKzh5Wvl5P2maDbuoPAaoDkwaMZ4NXotv4K4KNwQqckvGD/
	dtSgzVgGRBFZK5GF+0hzG4FXe1IHjR5AIOzXnOABJ/QkTBh5BxKjJ1ZaNhOt4c2S4eY2Dd7HdPo
	MynyNJ0p1NP5ED+b8iokAopdjoSjPUPiZBCY4d3Hydn9t6ZzUDuf4sut+caTQj9zSAaA4xh8GRO
	NKgF3
X-Received: by 2002:a05:6000:2dca:b0:437:6e63:9172 with SMTP id
 ffacd0b85a97d-43958df3516mr4465105f8f.4.1771431084459; Wed, 18 Feb 2026
 08:11:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-21-neelx@suse.com>
 <20260208151928.3245396-1-clm@meta.com> <CAPjX3FdiskLiELriX5gE2YEDMMwz5QQbNDnkAuFVov1a=WL_jQ@mail.gmail.com>
 <989433cb-4ab6-4a79-8dfc-9f5f542e2647@meta.com>
In-Reply-To: <989433cb-4ab6-4a79-8dfc-9f5f542e2647@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 17:11:13 +0100
X-Gm-Features: AaiRm52H6a8Dx1S_J50i9RFK-wqtAs4pqoNkIHGApsZEVneSHeR9ZFaJMuu2lQI
Message-ID: <CAPjX3Ff3qBoBxWzZ+Tg5HgSSEPGrbmmGMmf5MtiE4iU8PtHUMw@mail.gmail.com>
Subject: Re: [PATCH v6 20/43] btrfs: add fscrypt_info and encryption_type to ordered_extent
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:dkim];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1156-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 50EBE1579FC
X-Rspamd-Action: no action

On Wed, 18 Feb 2026 at 16:50, Chris Mason <clm@meta.com> wrote:
> On 2/18/26 10:29 AM, Daniel Vacek wrote:
> > On Sun, 8 Feb 2026 at 16:20, Chris Mason <clm@meta.com> wrote:
> >> Daniel Vacek <neelx@suse.com> wrote:
> >>> From: Josef Bacik <josef@toxicpanda.com>
> >>>
> >>> We're going to need these to update the file extent items once the
> >>> writes are complete.  Add them and add the pieces necessary to assign
> >>> them and free everything.
> >>>
> >>
> >> Hi everyone,
> >>
> >> I'm running the btrfs for-next branch, along with the encryption patch set
> >> through my AI review prompts:
> >>
> >> https://github.com/masoncl/review-prompts
> >>
> >> I'm working on some btrfs specific instructions, but hopefully these reviews
> >> are already useful.  I've kept the headers to make it easier to double check
> >> that I'm actually replying to the right email, but please let me know if any
> >> parts of this are incorrect:
> >>
> >> commit 61cd57301840de69a3f6573374d41ad4b4bcf348
> >> Author: Josef Bacik <josef@toxicpanda.com>
> >>
> >> btrfs: add fscrypt_info and encryption_type to ordered_extent
> >>
> >> This commit adds encryption-related fields (encryption_type and
> >> fscrypt_info) to struct btrfs_ordered_extent to support fscrypt
> >> integration in btrfs.
> >>
> >>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> >>> index 5df02c707aee6..7a5701937184e 100644
> >>> --- a/fs/btrfs/ordered-data.c
> >>> +++ b/fs/btrfs/ordered-data.c
> >>> @@ -192,6 +192,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
> >>>       }
> >>>       entry->inode = inode;
> >>>       entry->compress_type = compress_type;
> >>> +     entry->encryption_type = BTRFS_ENCRYPTION_NONE;
> >>>       entry->truncated_len = (u64)-1;
> >>>       entry->qgroup_rsv = qgroup_rsv;
> >>
> >> This isn't a bug, but the fscrypt_info field isn't explicitly initialized
> >> to NULL here. While kmem_cache_zalloc() at line 175 does zero the memory,
> >> all the other important fields in this function are explicitly initialized
> >> (compress_type, encryption_type, truncated_len, qgroup_rsv, refs). Would
> >> adding an explicit 'entry->fscrypt_info = NULL;' improve consistency?
> >
> > `entry->fscrypt_info` is set in the very next patch "[21/43] btrfs:
> > plumb through setting the fscrypt_info for ordered extents". The
> > series is meant to be applied as a whole. It's just factored into
> > implementation steps.
>
> The prompts try to flag any patch series that don't follow best
> practices around bisectability.  There isn't a ton of instruction about
> what those best practices are beyond if commit A makes bug and then
> commit B fixes the bug, flag it.
>
> This patch set is pretty unusual because you're trying to preserve
> authorship for a number of people, and so there are a lot of small
> judgement calls about when to change patches and when to fix them up
> later.  I sent claude's comments to help highlight places we want to
> decide things, but I don't think there's really a wrong decision.

I understand that. I was checking every commit to ensure it builds
correctly. But not really testing for bugs or regressions.

> >
> >>>       entry->flags = flags;
> >>> @@ -630,6 +631,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
> >>>               btrfs_add_delayed_iput(entry->inode);
> >>>               list_for_each_entry_safe(sum, tmp, &entry->list, list)
> >>>                       kvfree(sum);
> >>> +             fscrypt_put_extent_info(entry->fscrypt_info);
> >>>               kmem_cache_free(btrfs_ordered_extent_cache, entry);
> >>>       }
> >>>  }
> >>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> >>> index 1e6b0b182b295..ce19198e7f844 100644
> >>> --- a/fs/btrfs/ordered-data.h
> >>> +++ b/fs/btrfs/ordered-data.h
> >>> @@ -124,6 +124,9 @@ struct btrfs_ordered_extent {
> >>>       /* compression algorithm */
> >>>       int compress_type;
> >>>
> >>> +     /* encryption mode */
> >>> +     u8 encryption_type;
> >>> +
> >>
> >> This isn't a bug, but placing the u8 encryption_type field between two int
> >> fields creates 3 bytes of padding. This is minor, but in a filesystem with
> >> many ordered extents, it could add up. The current placement does have the
> >> advantage of grouping encryption-related fields together logically, though.
> >
> > This was actually changed from int (as Dave suggested, IIRC). But I
> > did not move it.
> > I guess we can do this:
> >
> > --- a/fs/btrfs/ordered-data.h
> > +++ b/fs/btrfs/ordered-data.h
> > @@ -127,18 +127,18 @@ struct btrfs_ordered_extent {
> >      /* flags (described above) */
> >      unsigned long flags;
> >
> > -    /* compression algorithm */
> > -    int compress_type;
> > -
> > -    /* encryption mode */
> > -    u8 encryption_type;
> > -
> >      /* Qgroup reserved space */
> >      int qgroup_rsv;
> >
> >      /* reference count */
> >      refcount_t refs;
> >
> > +    /* compression algorithm */
> > +    int compress_type;
> > +
> > +    /* encryption mode */
> > +    u8 encryption_type;
> > +
>
> Seems mostly the same?  I'd suggest paholing things to find a good spot.

Hmm, that's what I did. There was a 4 bytes hole.
Nah, I see. I just moved it. It's not a big deal then. The structure's
size remains unchanged in either case. Still plugging a hole. Or am I
missing something?

> >      /* the inode we belong to */
> >      struct btrfs_inode *inode;
> >
> >
> >>>       /* Qgroup reserved space */
> >>>       int qgroup_rsv;
> >>>
> >>> @@ -133,6 +136,9 @@ struct btrfs_ordered_extent {
> >>>       /* the inode we belong to */
> >>>       struct btrfs_inode *inode;
> >>>
> >>> +     /* the fscrypt_info for this extent, if necessary */
> >>> +     struct fscrypt_extent_info *fscrypt_info;
> >>> +
> >>>       /* list of checksums for insertion when the extent io is done */
> >>>       struct list_head list;
> >>
> >> How does btrfs_split_ordered_extent() handle the new fscrypt_info field?
> >> Looking at that function in ordered-data.c, it calls alloc_ordered_extent()
> >> which initializes encryption_type to BTRFS_ENCRYPTION_NONE and fscrypt_info
> >> to NULL. If the original ordered extent has encryption_type set to
> >
> > Ditto. This is changed in the next patch [21/43].
> > alloc_ordered_extent() correctly sets these fields.
>
> It seems unlikely that we're really going to maintain bisectability for
> encryption being on in the middle of this patchset.  So this seems fine
> to me as long as the bug doesn't impact encryption being off.

Yeah, I think it should not. (Famous last words...)

Thanks.

--nX

> -chris
>

