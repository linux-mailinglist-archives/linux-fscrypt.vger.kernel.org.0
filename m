Return-Path: <linux-fscrypt+bounces-1536-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGxBJ0ZdwmlKcAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1536-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Mar 2026 10:45:42 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D29305D52
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Mar 2026 10:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B56730BBCC8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Mar 2026 09:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E77A3DA7E3;
	Tue, 24 Mar 2026 09:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LR/xx7SI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA7F3DB63E
	for <linux-fscrypt@vger.kernel.org>; Tue, 24 Mar 2026 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774345022; cv=pass; b=aMtqbaaytyHE6vQ7/8IseJ1wmdt3VsCI853JFl9q3esNrRil/TgAghmJIU+qBr7CxGZgxPVX4bTdvcW5xIZfzDFdy3GC2YX8+MZPkYuUThV2bSJBmms74mcfU9br95EjUy87+GekVAsLyPpOaanBYmt48sPz2LraCDfUG+EPlyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774345022; c=relaxed/simple;
	bh=JV481TRX/Dx8xXrjNX9tltXZwt52q0seBxFVj0eKdEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9G5EI4++jGNi3eLQ50lMZW6AIjORqASM5oNdbeC+doU8Gd5XyYh/DgzdGlYIPkTSUlr4e3G9sI5juBcxv4TPGsy8gd9cqKxSqa963bxqUvdXTspvD5VtNQvxF1xbM5ZW5v8u4eCvL60wcMNWNubV0hS84CHeBhmZyhZbr5FAa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LR/xx7SI; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439c56e822eso983951f8f.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 24 Mar 2026 02:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774345017; cv=none;
        d=google.com; s=arc-20240605;
        b=kmobp6ucaEPP6W3lmOpysWyZI071Gnt+p8Ne58y2vSDtTIHzdJ54Nm/6nPWa5dxFJh
         99rWzlfM4Wxarb2HaksidLZT5e//TUItKfNVqCq5PPPF0B6np3yM3yCNrhdHh8YX3UMT
         dPXkCkueTGmX1ZZX24O/8UQRdFaejEE7cW0M8ZZW8aE5oHOWO4TqU0tiF5JZCIfMgTCb
         +RcCRS/zJ1pInjsZG3f8/LOqpO8qb6JsK52iSU+Nz1bWRw/xvmaxtfUJYGszeFdQBIc1
         awMx/CsjZZas4h/A0x+hjnkZ+6jxYFHBhJdUCkXw+dOx0j8qEzSHX0mFcOi073uY1bRl
         ovVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        fh=zRJF1wQJe0XelCFDuRqfFj5fh0UJIk0sH1htbuZpEc0=;
        b=TMWJZDd0W9JWrTeZFeuIDA7tbtZza3dCMySuKHzZrb+SPj8wq3rbiBxERiaj7Lxysh
         QH+Vc0XcDpfnVL2649tNJ6XXcEXrkyqRKrC1CMRN6rn+jhoQQJfqVKPMXQS4D6FtlgJN
         j0BoWsEyXA2IPKorBBeMBz3txIthVveWPUAGWzpmh2f+CgcM/dUBAgDuBWfwDmWGi08V
         XvWUkwuW0B0+Tvwsrw6XzNcK5Ex36fxWr4wRzoFSkLu/6zPmQPoxD/g8pnreFiCCY0SX
         MI3dU2V/mGDXRvfl0AmAKMU/NAJwBgmNcTmIjHnCT2C9RnTqe/z7dgF71FlUYHD/kToH
         UVBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774345017; x=1774949817; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        b=LR/xx7SI5kncamtwfDMCZsdLzL9v2Vv+1wsvvSda4nYW33Dgt20Mwkq1nG278aI1h3
         QfOJpdmD6BSzA3Oqrr3lvmc3YSishR6XKUjKNqErydpJB/08lKKtkRrR7fjOn+K20yA0
         f2mEuXbkDWSUeT+FDPsVFKUMP73alN7cNy8NHTMcCLqsrGqwrl6mvm8vZbYK+o4a/+wM
         pZF8CyL72yj0UlFTqcGIoq4aj2alY/7p46cWd+QrxCNXGrZjAoJ5kZDzZ94RZEocUmOM
         Qx86u2UQbXXm6eYKnp6FD9sf2RK4r9xew6NLUI2bkBgA5jHBRygvDTuFNmq4DGnlVjIy
         eCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774345017; x=1774949817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ub5wN9amaO/DAAvFXES2RrEzabJn769sowl2xsPaADQ=;
        b=ecn82UKQ4xczlDNN8EK197RJVwxIU+tRxkI11T6/PQN23QwoxXuYBw8NO4P4KXxXq1
         hRCqmgXcNJE+duoCM0XaNe7p1fhVvnicxsmpdeqMCrWDnFawSGLUhKNMrcLWyEy+2Nk9
         hlpWqvB/wGHW7C5QJ+otuRdGvmyLXA4iXzydw+5Ez0TbJ0I0k2sngqxVc09hNTYMmUSt
         fw/2vs/JwpTx1zqndXzVrglxQFy+HeeSVd43els5TLNs+PGNXASuVDJSJYG5jAfUpElb
         VdFfMdd11a7WBreHGYMeWnqNQPpQFXnc1GRO1RPWjWBPqvYf+H1zIKjvp0wDe6yj248K
         srMg==
X-Forwarded-Encrypted: i=1; AJvYcCUUj7aQP1BOkUz8FuxoFYk7uYjEvFHSMroE8YYviq1QTWSUE7QfEgA+dzae7V8XrN0/JOW9DLEhR6SvU16o@vger.kernel.org
X-Gm-Message-State: AOJu0YxZS1fJ1FK0v3c9E7jzPAe4XEBEwd7CdlKAUIqM9MK9hnqpVF6o
	t16dickjjUf/91GL4SUcw4av147GXYP1JcXUuKcxciFZOIrRBdv9owSD8VViI+4xxwYBfWzHtvT
	4kdOjbutOL4XafZFmIpC+lFRjlMnlXvAV1BbyPWvK+A==
X-Gm-Gg: ATEYQzyMSC0wHsGu/w4uR+Jo4GZvBZQ1+HxWrNMqwovfJjcuyoRCEMkIrF6TyV/xIYm
	DtOd56AE169wfHxukSqQQAZjI8dZXukTKvCQBJmiNZXGbrD1oYyQpPa1U5lyPkwT4kdX+GC0dWV
	LJLK/N+zomAYS02zuUN/5y3cjY3Rm4Pm1Ot1hS8DYn1ShHknHrvadVqFkLGZAIT/K3oARY6CprV
	3d8SWlOoUa2hX05PGj4sIM2dJIqiBbF2Lwtc+N6jK3okQC7s5C6pPQV+6ltYOFiVQrZ0osYpzDg
	+gWk1tA+SxJci8/S25r6Q9TPCAdJjL6675wsBydlb+WdQA6NIRGWxEV4/U4xdeUb3S9twQR3mwI
	XDLES
X-Received: by 2002:a05:6000:22c2:b0:43b:3caa:a20e with SMTP id
 ffacd0b85a97d-43b6426b68emr24185879f8f.32.1774345017497; Tue, 24 Mar 2026
 02:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-33-neelx@suse.com>
 <20260208151126.3129410-1-clm@meta.com>
In-Reply-To: <20260208151126.3129410-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 24 Mar 2026 10:36:46 +0100
X-Gm-Features: AQROBzAcrSb8NLZh900STza2vyMCNtV9c0i8E1h6tC3jXGjIJZj-4KJUOFxGeHU
Message-ID: <CAPjX3FchHbyQMUqogjyf4tUpT49HnO==_E6Uj=Zz7BXYUhJvsg@mail.gmail.com>
Subject: Re: [PATCH v6 32/43] btrfs: implement process_bio cb for fscrypt
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1536-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,meta.com:email,toxicpanda.com:email]
X-Rspamd-Queue-Id: 01D29305D52
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 8 Feb 2026 at 16:12, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We are going to be checksumming the encrypted data, so we have to
> > implement the ->process_bio fscrypt callback.  This will provide us with
> > the original bio and the encrypted bio to do work on.  For WRITE's this
> > will happen after the encrypted bio has been encrypted.  For READ's this
> > will happen after the read has completed and before the decryption step
> > is done.
> >
> > For write's this is straightforward, we can just pass in the encrypted
> > bio to btrfs_csum_one_bio and then the csums will be added to the bbio
> > as normal.
> >
> > For read's this is relatively straightforward, but requires some care.
> > We assume (because that's how it works currently) that the encrypted bio
> > match the original bio, this is important because we save the iter of
> > the bio before we submit.  If this changes in the future we'll need a
> > hook to give us the bi_iter of the decryption bio before it's submitted.
> > We check the csums before decryption.  If it doesn't match we simply
> > error out and we let the normal path handle the repair work.
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
> commit 2b25418669e46c939ff864b1144e2c27d618920c
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: implement process_bio cb for fscrypt
>
> This commit implements the ->process_bio fscrypt callback for btrfs,
> enabling checksum verification of encrypted data before decryption and
> checksum generation after encryption.
>
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 3b420866f3b82..c28f3f53bad28 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -300,6 +300,34 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
> >       return fbio;
> >  }
> >
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> > +{
> > +     struct btrfs_inode *inode = bbio->inode;
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +     struct bvec_iter iter = bbio->saved_iter;
> > +     struct btrfs_device *dev = bbio->bio.bi_private;
> > +     const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
> > +     const u32 nr_steps = iter.bi_size / step;
> > +     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
>
> Can paddrs[] overflow here? BTRFS_MAX_BLOCKSIZE is 64KB, so the array
> has 16 elements (64KB / 4KB). However, nr_steps is calculated from
> iter.bi_size which can be much larger than 64KB for merged bios.
>
> If a bio has bi_size > 64KB, the loop below will write beyond the array
> bounds when filling paddrs[slot].

Indeed, that's very true and I can easily reproduce it.

> > +     phys_addr_t paddr;
> > +     unsigned int slot = 0;
> > +
> > +     /*
> > +      * We have to use a copy of iter in case there's an error,
> > +      * btrfs_check_read_bio will handle submitting the repair bios.
> > +      */
> > +     btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> > +             ASSERT(slot < nr_steps);
> > +             paddrs[slot] = paddr;
> > +             slot++;
> > +     }
> > +     if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))
>
> Does this verify checksums for all sectors in the bio? Looking at
> btrfs_data_csum_ok() in inode.c, it verifies one sector's worth of data
> (one blocksize). The function is called with bio_offset=0, meaning it
> only checksums the first sector.
>
> However, the bio can contain multiple sectors (iter.bi_size could be
> much larger than one sectorsize). If the bio has multiple sectors,
> shouldn't this call btrfs_data_csum_ok() for each sector, or pass the
> actual bio size so all sectors are verified?
>
> The existing btrfs_check_read_bio() function loops through all sectors
> and verifies each one individually.

This is also correct. Both points fixed this way:

--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -343,11 +343,13 @@ blk_status_t
btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
     struct btrfs_fs_info *fs_info = inode->root->fs_info;
     struct bvec_iter iter = bbio->saved_iter;
     struct btrfs_device *dev = bbio->bio.bi_private;
-    const u32 step = min(fs_info->sectorsize, PAGE_SIZE);
+    const u32 blocksize = fs_info->sectorsize;
+    const u32 step = min(blocksize, PAGE_SIZE);
     const u32 nr_steps = iter.bi_size / step;
     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
     phys_addr_t paddr;
     unsigned int slot = 0;
+    u32 offset = 0;

     /*
      * We have to use a copy of iter in case there's an error,
@@ -357,9 +359,13 @@ blk_status_t
btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *
         ASSERT(slot < nr_steps);
         paddrs[slot] = paddr;
         slot++;
+        offset += step;
+        if (IS_ALIGNED(offset, blocksize)) {
+            if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
+                return BLK_STS_IOERR;
+            slot = 0;
+        }
     }
-    if (!btrfs_data_csum_ok(bbio, dev, 0, paddrs))
-            return BLK_STS_IOERR;

     /*
      * Read repair is slightly different for encrypted bio's.  This

Thanks!

--nX


> > +                     return BLK_STS_IOERR;
> > +
> > +     bbio->csum_ok = true;
> > +     return BLK_STS_OK;
> > +}
>
> [ ... ]
>
>

