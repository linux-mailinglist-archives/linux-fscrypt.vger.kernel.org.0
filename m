Return-Path: <linux-fscrypt+bounces-1154-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wH2bCNHalWn3VQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1154-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:29:21 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DB51576A2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 632BD300E255
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D8233C1A5;
	Wed, 18 Feb 2026 15:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OTCZI03x"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B14133A9F0
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771428558; cv=pass; b=kqMSyjrHy1UcxgATytq57PJyZjTRfNDMgRy7L2sXfjyr3drN5VnIJ9VlaUl5RgcSYTjRZ85m72QrtKh5YHRhBZ2QQlQfh1CHAFofpIiOGy0z95pdA4lKFau9SUORPWVSZe8vDby16gK03mLctTgajpCWz2wUih/+ps0oIzM6esE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771428558; c=relaxed/simple;
	bh=Xw6XgmdIpQZDlm085QhR4rp5zC/ULWblnm5MmRiePL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JK1tTZyO98DpGwjY0JMTdkgDpGdA8xk6TrRNnQQDG91PdJ4A/DHbzBb0B8HoEK5/OQOPb92OKFhy1HaZEGJO7ArtzYwGMlhdPcUscyprnry1Vxjk4HI5I3ybIWGi3ojU0dTSww3sng4BMq9IliO26GB5m0CFX8f5XgLJ8ep5lFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OTCZI03x; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4362197d174so3672041f8f.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 07:29:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771428555; cv=none;
        d=google.com; s=arc-20240605;
        b=LDyzwgoduezah5K8Is+pXd2tc/1U3qpX9BSvibTqTI6IrmZbRV83afjHBgi06iCDiE
         0HQD1i0gG5bCKxXNVRvJ7k6pOXudI/c+PIi3y+hosYawlxG46OBWRVPFDFshEQny/yu4
         QqNDGPBFOMxfHwTUGN9U3SjEFLTFOlTOciNUqAU3ZnvVxaCo+3iqjQMLyJ4LMrUOReyb
         VGNDgDa4CVLrDoExZPmC/JykU+xS4cd0izowQUbDMR7J1pHrGc8gT1nN/cNf9B4oN/Id
         g7qosBgl33tkNP0vuO965TaNJt3qDCEou3n3lhqtyWBS+4PV4DaBxid7Ykphd0dtMcBX
         ZZtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IfnkV8+TTocY722rADKQN5PafR7KaeSPS4WRdn+Mx7I=;
        fh=vATjChtPm8PFEOBA3bqHBg8mw2odkXOBbWhWP6tR7Ys=;
        b=OHZgTWWaLbJ0IuxwNzs9OdUpAEi74oDMiPuCMgocy4dyHsAn0Z4J9AtrvLWg+Q1+S8
         4CPLjcQMYwo/NfA/HMLmXT1kwLIH3qZSD7biBWebiQ/pzPyXZphwC9wiLEXTtYqyLhHg
         YU+b5KDlT9TbhL3cMPU2Jl80OWuS99IO/HMiSkmMiVXekzNLBq3pnVNwbO23qyRl4Jbv
         RuLZrix9ooW+u0NsBPG6PGQyy1iEgeJLevptzw4DkbYFSEekZWANy8pg7MHCwgLjImZj
         OZW8X8erqHwrcllMblfMPs/67US++cB704ut/eOSMzfrv0QB10Ga6rCcce5JQhfq524k
         exhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771428555; x=1772033355; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IfnkV8+TTocY722rADKQN5PafR7KaeSPS4WRdn+Mx7I=;
        b=OTCZI03xtwImN3PgfzkrArAbcmpXovUOREuBZW7tfsNKznt39oFPIjB0O288sSUEv7
         xgBXFkMvFpyd1gnrqo2KBt+TSPHYDRpJDxSbRnWxs7U0U0u/Jbju9+3s91KATLsYWd1i
         1ZEz2utoNdS8S8f/bLWkCUwOENNDXQRwCJu0WZWmfy0IUH4taQQfOndR929xwzzrPoaN
         3SOObtxMWJj+nlytWlIM1bHUrY/vz373nx6gSkklLI14DEx1fW9EagtiL0IgXpIqgWmL
         RDhU3xM6p9d7pX0nrG/AtaUXHhDPfH2blrziBSUlumIYWlIU7HY74JhGlVK+dA22FzmV
         sqOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771428555; x=1772033355;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IfnkV8+TTocY722rADKQN5PafR7KaeSPS4WRdn+Mx7I=;
        b=eT5st6sfv7YOZsdPVf6XFb96WLnWAw8NGz9+bUc6KeJy4LLQ6fO54PAiq2gTJKIVT/
         ab3v9lK26r/Ia+gIflbX2BvYg+dQohu7sv0WC8CYK3SkYmT1X5HFuQoqoEaUOOX2v61u
         l/t/ZodJPOdRh2DXUuwJNTqJSscMkfHkiZBL53/4TN1kIynVKGC1zCgKJTrhEHdcLe1w
         pH+0Ei7h1YcTQKzXIP91OI2y/8OZWsO/BKelcdnrx57qCY87q7UPXpq6PeoLx24bq9i7
         ZO3ndilikvAGlCdWnyhdjt1dS4pXhePmmn4Xh02IAjiamtahjo66YtITew5ra0Ag5WB7
         3R9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWiwYvVn2cnE6erJM20fdQh4NwBREUm/eo1uAy6tsP8DOS78GOzOhVgC5BGneFxcU/oBfbN3fVU8vU8azvu@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6F8p/yuOyql2Qwg9dBmx1o3tK6h2FdrLylKsOGGOQOzPjNY7f
	+b49L6ZeN1KdwIdD9pTkqoKwKvAubMWine8JG/hHwqUnQgFdNzLVwfQU/Q1W+nOOx9Ogg/tl3AG
	FS3bKzCyrnE0Lbmh8mlgF9LFGBzJ+8/GyOuCWXZaoxQ==
X-Gm-Gg: AZuq6aJGQMqyyelX4X3GKiM9Qs1+bHWIYGd6LqhRkZEjPCnlBxi7yonSq5X4gegHYd1
	pNPunqOVM2gf1H368+2jhzOwf1qeLQoROwqZojlmpLaglHjFaEcAtB7En1/ky6RW7SeV+Q9pill
	IIn7g5iwVAB0kHZkOHbjaH16oR37M7pmi19il3zeKg9Rels/AxYrfyNTDaF/SDhMRDDiIszkUdB
	+RaG2nUJ/+vY7aUri/aUR706u4oehIChFPYpROOVRMFXH7bY87wOTU5ly4OnpCNV+e/oK6uQfiZ
	XvGqEDre3lVgxOg8D/jUTNWPt3LdHXy/vEJIWXHlwN5G+zwzsPIon1tzOy3DlwVOFLVUoSrURGf
	S080z
X-Received: by 2002:a05:6000:184e:b0:436:1a4b:de36 with SMTP id
 ffacd0b85a97d-43958e0314amr3758228f8f.22.1771428555325; Wed, 18 Feb 2026
 07:29:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-21-neelx@suse.com>
 <20260208151928.3245396-1-clm@meta.com>
In-Reply-To: <20260208151928.3245396-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 16:29:04 +0100
X-Gm-Features: AaiRm50zFeoPQy5g-1sCqoWhFtnHsBpdcK0A8x2pR40ySP5fMnh-3gELSlgrEnw
Message-ID: <CAPjX3FdiskLiELriX5gE2YEDMMwz5QQbNDnkAuFVov1a=WL_jQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:dkim,meta.com:email];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1154-lists,linux-fscrypt=lfdr.de];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 69DB51576A2
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:20, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We're going to need these to update the file extent items once the
> > writes are complete.  Add them and add the pieces necessary to assign
> > them and free everything.
> >
>
> Hi everyone,
>
> I'm running the btrfs for-next branch, along with the encryption patch set
> through my AI review prompts:
>
> https://github.com/masoncl/review-prompts
>
> I'm working on some btrfs specific instructions, but hopefully these reviews
> are already useful.  I've kept the headers to make it easier to double check
> that I'm actually replying to the right email, but please let me know if any
> parts of this are incorrect:
>
> commit 61cd57301840de69a3f6573374d41ad4b4bcf348
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: add fscrypt_info and encryption_type to ordered_extent
>
> This commit adds encryption-related fields (encryption_type and
> fscrypt_info) to struct btrfs_ordered_extent to support fscrypt
> integration in btrfs.
>
> > diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> > index 5df02c707aee6..7a5701937184e 100644
> > --- a/fs/btrfs/ordered-data.c
> > +++ b/fs/btrfs/ordered-data.c
> > @@ -192,6 +192,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
> >       }
> >       entry->inode = inode;
> >       entry->compress_type = compress_type;
> > +     entry->encryption_type = BTRFS_ENCRYPTION_NONE;
> >       entry->truncated_len = (u64)-1;
> >       entry->qgroup_rsv = qgroup_rsv;
>
> This isn't a bug, but the fscrypt_info field isn't explicitly initialized
> to NULL here. While kmem_cache_zalloc() at line 175 does zero the memory,
> all the other important fields in this function are explicitly initialized
> (compress_type, encryption_type, truncated_len, qgroup_rsv, refs). Would
> adding an explicit 'entry->fscrypt_info = NULL;' improve consistency?

`entry->fscrypt_info` is set in the very next patch "[21/43] btrfs:
plumb through setting the fscrypt_info for ordered extents". The
series is meant to be applied as a whole. It's just factored into
implementation steps.

> >       entry->flags = flags;
> > @@ -630,6 +631,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
> >               btrfs_add_delayed_iput(entry->inode);
> >               list_for_each_entry_safe(sum, tmp, &entry->list, list)
> >                       kvfree(sum);
> > +             fscrypt_put_extent_info(entry->fscrypt_info);
> >               kmem_cache_free(btrfs_ordered_extent_cache, entry);
> >       }
> >  }
> > diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
> > index 1e6b0b182b295..ce19198e7f844 100644
> > --- a/fs/btrfs/ordered-data.h
> > +++ b/fs/btrfs/ordered-data.h
> > @@ -124,6 +124,9 @@ struct btrfs_ordered_extent {
> >       /* compression algorithm */
> >       int compress_type;
> >
> > +     /* encryption mode */
> > +     u8 encryption_type;
> > +
>
> This isn't a bug, but placing the u8 encryption_type field between two int
> fields creates 3 bytes of padding. This is minor, but in a filesystem with
> many ordered extents, it could add up. The current placement does have the
> advantage of grouping encryption-related fields together logically, though.

This was actually changed from int (as Dave suggested, IIRC). But I
did not move it.
I guess we can do this:

--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -127,18 +127,18 @@ struct btrfs_ordered_extent {
     /* flags (described above) */
     unsigned long flags;

-    /* compression algorithm */
-    int compress_type;
-
-    /* encryption mode */
-    u8 encryption_type;
-
     /* Qgroup reserved space */
     int qgroup_rsv;

     /* reference count */
     refcount_t refs;

+    /* compression algorithm */
+    int compress_type;
+
+    /* encryption mode */
+    u8 encryption_type;
+
     /* the inode we belong to */
     struct btrfs_inode *inode;


> >       /* Qgroup reserved space */
> >       int qgroup_rsv;
> >
> > @@ -133,6 +136,9 @@ struct btrfs_ordered_extent {
> >       /* the inode we belong to */
> >       struct btrfs_inode *inode;
> >
> > +     /* the fscrypt_info for this extent, if necessary */
> > +     struct fscrypt_extent_info *fscrypt_info;
> > +
> >       /* list of checksums for insertion when the extent io is done */
> >       struct list_head list;
>
> How does btrfs_split_ordered_extent() handle the new fscrypt_info field?
> Looking at that function in ordered-data.c, it calls alloc_ordered_extent()
> which initializes encryption_type to BTRFS_ENCRYPTION_NONE and fscrypt_info
> to NULL. If the original ordered extent has encryption_type set to

Ditto. This is changed in the next patch [21/43].
alloc_ordered_extent() correctly sets these fields.

Thanks.

--nX

> BTRFS_ENCRYPTION_FSCRYPT with a non-NULL fscrypt_info pointer, the split
> creates an inconsistency where the two extents representing parts of the
> same encrypted data have different encryption metadata.
>
> The function already has an assertion preventing splits of compressed
> extents at line 1244:
>
>     ASSERT(!(flags & (1U << BTRFS_ORDERED_COMPRESSED)))
>
> Should there be similar protection for encrypted extents, or if splits must
> be supported, should the function call fscrypt_get_extent_info() to
> properly handle the reference count and copy the encryption_type to the new
> extent?
>

