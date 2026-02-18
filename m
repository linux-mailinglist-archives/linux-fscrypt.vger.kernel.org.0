Return-Path: <linux-fscrypt+bounces-1157-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mFWMHAX2lWn1XQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1157-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 18:25:25 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1450215843A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 18:25:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6E86B3004F24
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 17:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E223446A0;
	Wed, 18 Feb 2026 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ST60dWro"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7933D4FE
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771435523; cv=pass; b=c4h94XwunH2mzeCMQLVJdO6aAtZaXAwRu8J/kClEvA4p9mVK6Clpi2faHAyZq9CaBqugs4Vc3uVNLh4H/j+7FiRK7WhpfPA0CEy6JJ5iB0emR4CCPyTxFns41UyN3eh/F4Ac4X1DP5PHpsR8XUen9w43oen5+FChOtMPpLe7Hdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771435523; c=relaxed/simple;
	bh=N+tav2HTy87uvDs4cm+LHcXfnxXGxM0ESG6Aqemj0F4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lszEco4ij/Ot4VT5PXv5BNrNwZFn77EURpOX+D9UvytaTN9OUwQeoSA3IVbpToqDd7mrcUFGox0MLcfdzhtWSuTPvDLmt3wEULvV6oeGkj7Uf7C2FZhGcSvq6TCeHnLI9lY6exiv/X17Zv//h0o5pGBB9onzZ7W7UXphmE1gQZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ST60dWro; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-435f177a8f7so73924f8f.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 09:25:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771435519; cv=none;
        d=google.com; s=arc-20240605;
        b=STv8D5S48mbOEmdasvu/PUBnuZqbACZauXtaBUeAEQaMkYClmrPRsMVaKA7ivIaY3X
         4AW6aOhiFmzpJR1+7B/LbXe0vGv3pxbdoj3VCohZunPo+AugtOTrCnn0CQoesMfXr1Sk
         qxfEOgNaGiNN3JV1zP+1WNE4v5wrou6PEteD7lUHoa4ijXummc3Kl3fk/COSwUks7UIT
         efmMZQvkPez51EiHbhv9XC6elnvOxY1pfHj9bNzkjbBOWWYqLLycCZ9A1COzNKKMLT+d
         uhgR7bc2z7GUVCSYdG3GZgzsbLkDZPlxEa9p8heJmtfeFeL4bwGPotT1lX1fAY11sVKs
         +m6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D6PV26WrJgM8OsqISNWJ5AfIh8Z/AmyWHm0tc1qPxzY=;
        fh=wcHchwdHUENmhq/Cr14pwYt+5fFriLSb2K7YS5C4ijY=;
        b=hsegVOI7CmvBJAFin0Bdi7zLsMjXenu6zaCN0DknyX3EPA5R637/KN7eofAlpRg7vf
         CbRVBIScrLkcBjlUOekxLueAE6x3BkHFm+cuBWdSU48F1y/R2WGL7wtt5QcVMYGHHgAF
         BwMZ0Pl53pvC/WMWOlGiS5HRQnE7+7I6rA14/CCNorCHY8L/ywA/ij7Wl9aLfFPQfrfz
         3ej5mlRBlzkIcmVX/r3YLoKM0TiuvNMfOEdHp2LJosq5hLPEx8ABumgolWVU2dcuHG0W
         rRj5cxJo+W6KDSETCboNE/FYJt21K8IiJDLqp8XlC1ELh1yX7js/lfNhxGnKwpKedqPO
         1Elg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771435519; x=1772040319; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D6PV26WrJgM8OsqISNWJ5AfIh8Z/AmyWHm0tc1qPxzY=;
        b=ST60dWro0wvwS2dgKYtI4A8AaDQy7wm+Qg3slO8Ahg9ZTnnZrLBfNxma2LnoswIn9W
         NLiOluW/rk20qQProSW3lRAhxJEjvY1hthDuLpjl07A1hgMMgnD3f2TmT9r7xn6wsfyX
         KJxXceqaQkAp6M//qKERt3dhbSD9KDyj7REFt4/yYj6a4F7XCq5GYCihzF7LTB94MFTq
         bV5/t8ujS6fzY7YhSxLLOlVsUIqv6YPuKf1iVGRckVMz3KMVcDn8aBy//PsD3KzgmbmJ
         0fXK30LPk5pLxkC5XdJKN7UFG0ox8b34T1xuhztJsGS8gVDjsWlPMASh6DgUrhbg2IzI
         ur8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771435519; x=1772040319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6PV26WrJgM8OsqISNWJ5AfIh8Z/AmyWHm0tc1qPxzY=;
        b=LE89G7O4vhv0PIYo8LG86bG90pbR/Jj7GCiMqpKP4sBEOEcJ68ctcX4nkQ5hZQNwiv
         3FODCTEI/Fj6oarCv6nmDpHoIxWZHygV+CrSTlCAPnTw7Gdof3U5CCQ1sTmWvpEQguEo
         OJ8P07q+NcnYwlkbbuzG2NDkRUjHP9LVnzy1ByklBl6aMQPWKjsM4Cz4rd0FI2mOB4AO
         NIwVpECx2nF/IuMZJXw0V8xmrTZNREQxdTvh5D4ZRqZNcmqaFUg5ry4YFW+FAaaFtTWy
         ceCX5qtxH+AB98s47LYEFuFAaJgttDysllR7/AxUP5XrjIDa7AdWo7AnjqbEtAqe5UTE
         mLtg==
X-Forwarded-Encrypted: i=1; AJvYcCVN8XnC57X5KIt0JY2roDzc5lrxruQU3bGfrbnUuRY3axaMYRmxaGJkrcmGMqC1uQHSyAgqjBNBZOY/Qf3g@vger.kernel.org
X-Gm-Message-State: AOJu0YzQuef/wuvKnSkpavOGu2SBcNEqq44zO/JAkpYOFnQZEgeVRDMr
	2odfmuxU5tWyvKofDW+vqKH2use6ZnmcJJ9Dm/IKv5+toar+zXAzjG878t/gpGg3J3YlBNhDQor
	QHYYUIIR0Rh+2GFHollVPrqKni0LLYLWIGHEN2K1MTA==
X-Gm-Gg: AZuq6aJa7/O81sxTjcasTv/nub2GqqHXkmwTVrZbz3zhgE7XKZez7U0DdixYfeskk6R
	qd8aZskgfr5N/ezYn8CsOSIpZjW02RbW49Q+/i3VF6SPALX1jiLOloXJxGBlsmGwGPOsYqNBHLf
	SnHaY+NjjPlrtKCVk1q1ChRnC9jWWxgo7SVxr0TDYPYvfAJM2X3P0lxztrhjAYl058xBTFVTOsj
	M6e9jWl5eQG4enCPZQ+gREdWNtG9VHZS92hLmj7TLKLCDKH5VamRcBrzNR3q+cFPmQ8sdQoOlR+
	pX5LJfwTvgSFg0YrP5pSSs5BWjTjGAJcU8RiJfTvmc4PVOb9BbTnLxRIi3jzKFKyCIQHZr0Ox+m
	VFPPs
X-Received: by 2002:a05:6000:402b:b0:437:6e6e:6f95 with SMTP id
 ffacd0b85a97d-4379db70171mr28853405f8f.27.1771435519063; Wed, 18 Feb 2026
 09:25:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-25-neelx@suse.com>
 <20260208151728.3212554-1-clm@meta.com>
In-Reply-To: <20260208151728.3212554-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 18:25:07 +0100
X-Gm-Features: AaiRm507L4YZn8mKVfmFL0jTM398GIfUhQk4fH9ld-lHWQu5maDHhF9XOU_HEIA
Message-ID: <CAPjX3FdgJKQyM0tdCksgLAtVyjos_nx3TRg6rvjYB1wE2QH1Cw@mail.gmail.com>
Subject: Re: [PATCH v6 24/43] btrfs: add extent encryption context tree item type
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
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1157-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,suse.com:email,suse.com:dkim,meta.com:email]
X-Rspamd-Queue-Id: 1450215843A
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:17, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > The fscrypt encryption context will be stored as a new tree item type.
> > This gives us flexibility to include different things in the future.
> >
> > Also update the tree-checker to validate the new item type.
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
> commit 203bfb91a4db9c826fa7f72034c13a1810a1b605
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: add extent encryption context tree item type
>
> The fscrypt encryption context will be stored as a new tree item type.
> This gives us flexibility to include different things in the future.
> Also update the tree-checker to validate the new item type.
>
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 3c0db279f592e..639462164d089 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
>
> [ ... ]
>
> > @@ -496,6 +503,60 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
> >               args->extent_inserted = true;
> >       }
> >
> > +     if (first_ctx <= last_ctx) {
> > +             int slot, nritems;
> > +
> > +             btrfs_release_path(path);
> > +
> > +             key.objectid = ino;
> > +             key.type = BTRFS_FSCRYPT_CTX_KEY;
> > +             key.offset = first_ctx;
> > +
> > +             ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
> > +             if (ret < 0)
> > +                     goto out_ctx;
>
> [ ... ]
>
> > +out_ctx:
> > +             if (args->path && args->extent_inserted) {
> > +                     btrfs_release_path(path);
> > +
> > +                     key.objectid = ino;
> > +                     key.type = BTRFS_EXTENT_DATA_KEY;
> > +                     key.offset = args->start;
> > +                     ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
> > +             }
> > +     }
> > +
>
> Can btrfs_search_slot() at line 556 overwrite an error that occurred
> earlier in the out_ctx path?
>
> If btrfs_search_slot() at line 515 fails and execution jumps to out_ctx,
> but args->path and args->extent_inserted are both true, the second
> btrfs_search_slot() call will overwrite the original error stored in ret.
>
> If this second search succeeds (returns 0 or >0), the function returns
> success to the caller despite the fscrypt context cleanup having failed.
> This could lead to inconsistent filesystem state where extent data was
> inserted but the corresponding fscrypt context items were not properly
> cleaned up.

Right, the original error should be returned. We do not care that much
about the latter if the former failed.
This should do the trick:

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -549,12 +549,16 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
         }
 out_ctx:
         if (args->path && args->extent_inserted) {
+            int err;
+
             btrfs_release_path(path);

             key.objectid = ino;
             key.type = BTRFS_EXTENT_DATA_KEY;
             key.offset = args->start;
-            ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
+            err = btrfs_search_slot(trans, root, &key, path, 0, 0);
+            if (err && ret >= 0)
+                ret = err;
         }
     }


> > diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> > index 9675dbcd78a3b..776901f297fea 100644
> > --- a/fs/btrfs/tree-checker.c
> > +++ b/fs/btrfs/tree-checker.c
>
> [ ... ]
>
> > +static int check_fscrypt_context(struct extent_buffer *leaf,
> > +                              struct btrfs_key *key, int slot,
> > +                              struct btrfs_key *prev_key)
> > +{
> > +     u32 sectorsize = leaf->fs_info->sectorsize;
> > +     u32 item_size = btrfs_item_size(leaf, slot);
> > +
> > +     if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
> > +             file_extent_err(leaf, slot,
> > +"unaligned file_offset for encryption context, have %llu should be aligned to %u",
> > +                     key->offset, sectorsize);
> > +             return -EUCLEAN;
> > +     }
> > +
> > +     /*
> > +      * Previous key must have the same key->objectid (ino).
> > +      * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
> > +      * But if objectids mismatch, it means we have a missing
> > +      * INODE_ITEM.
> > +      */
>
> This isn't a bug, but the comment says "It can be XATTR_ITEM, INODE_ITEM
> or just another EXTENT_DATA" - can EXTENT_DATA actually be the previous
> key type?
>
> For BTRFS_FSCRYPT_CTX_KEY (type=42), EXTENT_DATA (type=108) cannot be a
> previous key because keys are sorted by (objectid, type, offset) and
> 108 > 42.
>
> The correct previous key types would be: XATTR_ITEM, INODE_ITEM,
> FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.

Spot on! The comment is wrong. I realized that later but never fixed it here.
This is because of the redesign. In v5 the crypt context was embedded
in the extent data item, so they could have been next to each other.
This should look better:

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -220,10 +220,9 @@ static int check_fscrypt_context(struct
extent_buffer *leaf,
     }

     /*
-     * Previous key must have the same key->objectid (ino).
-     * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
-     * But if objectids mismatch, it means we have a missing
-     * INODE_ITEM.
+     * Previous key must have the same key->objectid (ino).  It can be
+     * XATTR_ITEM, INODE_ITEM, FSCRYPT_INODE_CTX_KEY, or another
FSCRYPT_CTX_KEY.
+     * But if objectids mismatch, it means we have a missing INODE_ITEM.
      */
     if (unlikely(!check_prev_ino(leaf, key, slot, prev_key)))
         return -EUCLEAN;

> > @@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
> >       u32 item_size = btrfs_item_size(leaf, slot);
> >       u64 extent_end;
> >       u8 policy;
> > +     u8 fe_type;
> >
> >       if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
> >               file_extent_err(leaf, slot,
>
> [ ... ]
>
> > @@ -298,6 +333,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
> >               return 0;
> >       }
> >
> > +     if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
> > +             /*
> > +              * Only regular and prealloc extents should have an encryption
> > +              * context.
> > +              */
> > +             if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
> > +                          fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
> > +                     file_extent_err(leaf, slot,
> > +             "invalid type for encrypted file extent, have %u", fe_type);
> > +                     return -EUCLEAN;
> > +             }
> > +     }
>
> Can this validation check detect encrypted inline extents? Looking at
> the function flow, inline extents (BTRFS_FILE_EXTENT_INLINE) are handled
> at lines 310-333 and return before reaching this check.
>
> If a corrupted filesystem has an encrypted inline extent, it would pass
> tree-checker validation. Should the encryption check be moved to also
> cover the inline extent path, or should inline extents explicitly reject
> BTRFS_ENCRYPTION_FSCRYPT?

Inline extents are not encrypted.

Thanks.

--nX

On Sun, 8 Feb 2026 at 16:17, Chris Mason <clm@meta.com> wrote:
>
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > The fscrypt encryption context will be stored as a new tree item type.
> > This gives us flexibility to include different things in the future.
> >
> > Also update the tree-checker to validate the new item type.
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
> commit 203bfb91a4db9c826fa7f72034c13a1810a1b605
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: add extent encryption context tree item type
>
> The fscrypt encryption context will be stored as a new tree item type.
> This gives us flexibility to include different things in the future.
> Also update the tree-checker to validate the new item type.
>
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 3c0db279f592e..639462164d089 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
>
> [ ... ]
>
> > @@ -496,6 +503,60 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
> >               args->extent_inserted = true;
> >       }
> >
> > +     if (first_ctx <= last_ctx) {
> > +             int slot, nritems;
> > +
> > +             btrfs_release_path(path);
> > +
> > +             key.objectid = ino;
> > +             key.type = BTRFS_FSCRYPT_CTX_KEY;
> > +             key.offset = first_ctx;
> > +
> > +             ret = btrfs_search_slot(trans, root, &key, path, modify_tree, !!modify_tree);
> > +             if (ret < 0)
> > +                     goto out_ctx;
>
> [ ... ]
>
> > +out_ctx:
> > +             if (args->path && args->extent_inserted) {
> > +                     btrfs_release_path(path);
> > +
> > +                     key.objectid = ino;
> > +                     key.type = BTRFS_EXTENT_DATA_KEY;
> > +                     key.offset = args->start;
> > +                     ret = btrfs_search_slot(trans, root, &key, path, 0, 0);
> > +             }
> > +     }
> > +
>
> Can btrfs_search_slot() at line 556 overwrite an error that occurred
> earlier in the out_ctx path?
>
> If btrfs_search_slot() at line 515 fails and execution jumps to out_ctx,
> but args->path and args->extent_inserted are both true, the second
> btrfs_search_slot() call will overwrite the original error stored in ret.
>
> If this second search succeeds (returns 0 or >0), the function returns
> success to the caller despite the fscrypt context cleanup having failed.
> This could lead to inconsistent filesystem state where extent data was
> inserted but the corresponding fscrypt context items were not properly
> cleaned up.
>
> > diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> > index 9675dbcd78a3b..776901f297fea 100644
> > --- a/fs/btrfs/tree-checker.c
> > +++ b/fs/btrfs/tree-checker.c
>
> [ ... ]
>
> > +static int check_fscrypt_context(struct extent_buffer *leaf,
> > +                              struct btrfs_key *key, int slot,
> > +                              struct btrfs_key *prev_key)
> > +{
> > +     u32 sectorsize = leaf->fs_info->sectorsize;
> > +     u32 item_size = btrfs_item_size(leaf, slot);
> > +
> > +     if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
> > +             file_extent_err(leaf, slot,
> > +"unaligned file_offset for encryption context, have %llu should be aligned to %u",
> > +                     key->offset, sectorsize);
> > +             return -EUCLEAN;
> > +     }
> > +
> > +     /*
> > +      * Previous key must have the same key->objectid (ino).
> > +      * It can be XATTR_ITEM, INODE_ITEM or just another EXTENT_DATA.
> > +      * But if objectids mismatch, it means we have a missing
> > +      * INODE_ITEM.
> > +      */
>
> This isn't a bug, but the comment says "It can be XATTR_ITEM, INODE_ITEM
> or just another EXTENT_DATA" - can EXTENT_DATA actually be the previous
> key type?
>
> For BTRFS_FSCRYPT_CTX_KEY (type=42), EXTENT_DATA (type=108) cannot be a
> previous key because keys are sorted by (objectid, type, offset) and
> 108 > 42.
>
> The correct previous key types would be: XATTR_ITEM, INODE_ITEM,
> FSCRYPT_INODE_CTX_KEY, or another FSCRYPT_CTX_KEY.
>
> > @@ -214,6 +248,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
> >       u32 item_size = btrfs_item_size(leaf, slot);
> >       u64 extent_end;
> >       u8 policy;
> > +     u8 fe_type;
> >
> >       if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
> >               file_extent_err(leaf, slot,
>
> [ ... ]
>
> > @@ -298,6 +333,19 @@ static int check_extent_data_item(struct extent_buffer *leaf,
> >               return 0;
> >       }
> >
> > +     if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
> > +             /*
> > +              * Only regular and prealloc extents should have an encryption
> > +              * context.
> > +              */
> > +             if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
> > +                          fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
> > +                     file_extent_err(leaf, slot,
> > +             "invalid type for encrypted file extent, have %u", fe_type);
> > +                     return -EUCLEAN;
> > +             }
> > +     }
>
> Can this validation check detect encrypted inline extents? Looking at
> the function flow, inline extents (BTRFS_FILE_EXTENT_INLINE) are handled
> at lines 310-333 and return before reaching this check.
>
> If a corrupted filesystem has an encrypted inline extent, it would pass
> tree-checker validation. Should the encryption check be moved to also
> cover the inline extent path, or should inline extents explicitly reject
> BTRFS_ENCRYPTION_FSCRYPT?
>

