Return-Path: <linux-fscrypt+bounces-1151-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5WXJHEPHlWkFUwIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1151-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:05:55 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16318156F79
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1EAED3006834
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 14:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521FE32E72B;
	Wed, 18 Feb 2026 14:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dyNzfm15"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB6A305E32
	for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771423551; cv=pass; b=Ngde8fqbOoUMYvSQvIpaxQH9JHge2wu5EQbuOOIZ2ZWm/GuqirIk2Eyn+QCQAxhsMcCb6OYR8qwZXyNFgjgh/zTBPp+l+KXIzhkKBgDVvB2baUR4JtBna57Lt+oN1sYOP19hM4fF2NYVb9ODa2T+iaks9PuJbrEyQ7ktxkkY2Eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771423551; c=relaxed/simple;
	bh=0IPQfandQcQcgM/09gru9lXRdDMyChSp6OWGiSUPAb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlT37TQXUuPf76LpmT7L1zuWanViEqi4NMP6g/OpfBqysRdIJ7HmVLCCqAd4PXlSdKiTwCyfJq8+9rcnc3KqIr+ADD9kIjCC0RFtw914/VGR/VUj6WBzY3x1RHxq8BJqLBzIdlOQ6D0sfn6kKLsiFsgEY7BI18i6BKH4X6yfEsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dyNzfm15; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4837634de51so19200445e9.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 18 Feb 2026 06:05:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771423548; cv=none;
        d=google.com; s=arc-20240605;
        b=gzzCuI/e7kI0kFZe36lDIJP/M3T1wcapi7M8HS9khZDmL3lXJlonGHC5kmI0Qg7xrD
         Tik1mfIWYbmMWJAlFaqy8GsFGsHYBuug9JTRikWM04eoMfOF0nb8nnGUPaU+n6m5/4yb
         DPEIjvbgde6NbNjJunQwFXuRL50+bpM6MU6c4RJd7hgVP4h4nNeEqlQwdnwKSg759nY+
         p5iv7g9ZjZnHqsmGZsikskXw4Bwn/8CqQBq5GwWZ9LLUVnzh892iBFnZGYU5LyJ2hA31
         691bzreKycIZt7i1PvjVMct1s4YlV6U7romTRwZQ6nsoubA/pUeVNOObsqZpd5Os7wZm
         wCPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZG0K+ScZHI1JMARqHPSZnWOCAEhLzuWZYvaV9Vd0R8Y=;
        fh=egRgfaEX7c4SxXNFP/TtAOZiC6gGHyuqEIlcjxTUc9c=;
        b=bEY5IXtHyAGhVgaRrTKiuGlt3ZAcMMwY7YNtEY+bxxIQDHvGLMW0lW8GBVNeaaKmaT
         tMZtn+X25alKUVOdkm7qtOEcx76Pmv3ZH1LvQAdnzdJ2iWWF+L3TgyIBI0J9h5t3eRGM
         FC6adfyl8czBs5OaGOqPJfVwP1bHSuYDo/F5Q2uOTx4H8DzJ72cobfVBkZ67jyj6lxRn
         w4GWeHmkhRJ4ndZtmHMl4KHQccgEHQGEGeMj5L78NmQbFWaNecW7qhgVMLGvkcOQL8VO
         3a0BUDL/W1dej2Nq6Qy+Y0Rp9gHhPYbze/i26WV3enXd4vIjJzGJoOZ47jzELnKsDOc0
         Bh0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771423548; x=1772028348; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZG0K+ScZHI1JMARqHPSZnWOCAEhLzuWZYvaV9Vd0R8Y=;
        b=dyNzfm150yPWPRdOJcw6LyIJ4XntfMbNBXzov9rUmvcdHnJDvKWPkDWKM3TztbQvkE
         pzEt9TUbqJp65oD4B77ioqUynrlzYLn4RZ+H64gYMUrB2MeWJd4s1rIK5JbOW2RD43UE
         st7c9uQNIxiivA9EkzF1m38q0WkSvzgO2S2AzbYTuGk62vGvKWPRdnMxX+FTPBDarXgB
         p9MkVWtwB3vh5JcDYLpxCA1oyzao1FNWEPWfybwJCOoybp6PybozGDyn40WyaQVRyAbm
         ireEeWHy7PjmfuVBZX7ScZguZ+rcLi2uPECCeyQ3ZK4tQ+rg9aL351fOslGxCqx14fCf
         j4rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771423548; x=1772028348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZG0K+ScZHI1JMARqHPSZnWOCAEhLzuWZYvaV9Vd0R8Y=;
        b=QDAkUb9C6+pOv4pu5eJQ9ysJV/slCiR+JjumTFeAvQwD20o0qTEb3bubRUTclZj417
         4dPsXp24YljV9iTBzcDLHxblcvyPJCDf88Cke20RmEzFbDVu6WnNIjNefmLWN+t5RJYw
         danQIPmw3a3u2uYcVOc9uvcm0lTI5+txvbGVKMASRcm+18P2yh6GUCLpB/qqbyEKeMnT
         NtmKpiwz2VpAFg+lIBzPyDsGKWy0OeXIklWSrhqP78mHEaG/kQTPHiyT2vBwlmwBSoJS
         5wz+y1OHcmIrHNf74zwuqxWPHDjfiz5JDS4l0PKvunfnEzCBY7gW2tPPFWQoslDMbTQd
         AD7A==
X-Forwarded-Encrypted: i=1; AJvYcCVVMwsFGZpcCMIplofsHyvxhzNVdzXsMJy2RAwCpj+vpB+rXojvmgpKI0rlN5oFvu39cVnupHiP8Yjqn1cA@vger.kernel.org
X-Gm-Message-State: AOJu0YxKw4QWyRCR2i0OXXz00WAdR8gnrQFTB+NiFMo5fLLWsjVqSDdP
	9Kj92Wv3vqZ8PpDDnZbEj8IWDGob9RATqj/YrhaWX/FoiYMplAiWj3D6NSsxG/qgQtMR+bBjtxE
	uhYs/+ETjfcZIUZkAknvdBstvX0iSOYhHngQkt8CjVyeRYSQieEjXVbk=
X-Gm-Gg: AZuq6aI1xp8qb6dp9oCo3uHO+2FuYI+JmZ0oGyZDgk2usrUU33k3c7UaZNquYFckDhA
	Ox4ODqY2OfMfsThFa1/k1ozmtRoyX0cdfUUcZoJ6MdvnO1J7+lRlK45BZo+48D90YcocwatLgyX
	NbUqHPNvIjnfRQIIXtATqb/xMJd5TtmzM+LbYE3pcJOGfr3mEXeVrXBqs2ZE3jjOX7Z2mh+Pavw
	6RyQwYxKzyIncVRxl6RXK/bpBcq3J6g7z80UUYcI85HvgX+ckvXpLm95Ya+EQBtTzHCh0EGjwEG
	g4jCTCRAx5kuw8qq1Mf948/K7Iw7mueiDiXF+tMbKa1t0HJ/CJfg7opvxjy+U2YouMGRWDjifDd
	cNTkt
X-Received: by 2002:a05:600c:6912:b0:483:709e:f22d with SMTP id
 5b1f17b1804b1-4837108fc46mr300110235e9.27.1771423547925; Wed, 18 Feb 2026
 06:05:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-14-neelx@suse.com>
 <20260208153607.3466929-1-clm@meta.com>
In-Reply-To: <20260208153607.3466929-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 18 Feb 2026 15:05:37 +0100
X-Gm-Features: AaiRm510tlnOinFS7nG7T90JA_M8mhwdBINiTRaMYypuSLi3O4tUUbZEt6vztBA
Message-ID: <CAPjX3FdE9nLWE12KRxpXyj9Hy-Z1JSmWcDMBgT0fuyQsfafAHw@mail.gmail.com>
Subject: Re: [PATCH v6 13/43] btrfs: adapt readdir for encrypted and nokey names
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:email,suse.com:dkim,mail.gmail.com:mid,meta.com:email,osandov.com:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1151-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 16318156F79
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:36, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Omar Sandoval <osandov@osandov.com>
> >
> > Deleting an encrypted file must always be permitted, even if the user
> > does not have the appropriate key. Therefore, for listing an encrypted
> > directory, so-called 'nokey' names are provided, and these nokey names
> > must be sufficient to look up and delete the appropriate encrypted
> > files. See 'struct fscrypt_nokey_name' for more information on the
> > format of these names.
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
> commit e264482bd61ca8096981d81cc5e7c839284ac969
> Author: Omar Sandoval <osandov@osandov.com>
>
> btrfs: adapt readdir for encrypted and nokey names
>
> This commit adapts the btrfs readdir implementation to handle encrypted
> filenames and nokey names, enabling directory listing and deletion of
> encrypted files even without the encryption key.
>
> > diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> > index 1739a0b29c49d..c19213fab3dda 100644
> > --- a/fs/btrfs/delayed-inode.c
> > +++ b/fs/btrfs/delayed-inode.c
>
> [ ... ]
>
> > @@ -1820,7 +1823,25 @@ bool btrfs_readdir_delayed_dir_index(struct dir_context *ctx,
> >               d_type = fs_ftype_to_dtype(btrfs_dir_flags_to_ftype(di->type));
> >               btrfs_disk_key_to_cpu(&location, &di->location);
> >
> > -             over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
> > +             if (di->type & BTRFS_FT_ENCRYPTED) {
> > +                     int ret;
> > +                     struct fscrypt_str iname = FSTR_INIT(name, name_len);
> > +
> > +                     fstr->len = fstr_len;
> > +                     /*
> > +                      * The hash is only used when the encryption key is not
> > +                      * available. But if we have delayed insertions, then we
> > +                      * must have the encryption key available or we wouldn't
> > +                      * have been able to create entries in the directory.
> > +                      * So, we don't calculate the hash.
> > +                      */
> > +                     ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname, fstr);
> > +                     if (ret)
> > +                             return ret;
> > +                     over = !dir_emit(ctx, fstr->name, fstr->len, location.objectid, d_type);
> > +             } else {
> > +                     over = !dir_emit(ctx, name, name_len, location.objectid, d_type);
> > +             }
>
> Does the return statement at line 1840 cause silent error loss?
>
> The function btrfs_readdir_delayed_dir_index returns bool, but
> 'return ret;' returns an int error code from fscrypt_fname_disk_to_usr.
> Since ret is negative on error (e.g., -EUCLEAN from fname_decrypt
> failures), this converts to 'true' in bool context.
>
> The caller btrfs_real_readdir at inode.c:6410 interprets true as "stop
> iteration normally":
>
>     if (btrfs_readdir_delayed_dir_index(inode, &fstr, ctx, &ins_list))
>         goto nopos;
>
> The nopos label at line 6417 sets ret = 0, which means readdir()
> completes successfully with incomplete results when crypto operations
> fail on encrypted directory entries.

This still seems correct to me. While rebasing, however, I missed that
the return type changed in 41e4ea0bf555 ("btrfs: make
btrfs_readdir_delayed_dir_index() return a bool instead").
If I'm not mistaken, we can just `return true;` here:

--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1837,7 +1837,7 @@ bool btrfs_readdir_delayed_dir_index(const
struct inode *inode,
              */
             ret = fscrypt_fname_disk_to_usr(inode, 0, 0, &iname, fstr);
             if (ret)
-                return ret;
+                return true;
             over = !dir_emit(ctx, fstr->name, fstr->len,
location.objectid, d_type);
         } else {
             over = !dir_emit(ctx, name, name_len, location.objectid, d_type);

> [ ... ]
>
> > diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> > index 085a83ae9e62f..6e10dd4a4e9e1 100644
> > --- a/fs/btrfs/dir-item.c
> > +++ b/fs/btrfs/dir-item.c
>
> [ ... ]
>
> > @@ -227,6 +228,47 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
> >       return di;
> >  }
> >
> > +/*
> > + * Lookup for a directory item by fscrypt_name.
> > + *
> > + * @trans:   The transaction handle to use.
> > + * @root:    The root of the target tree.
> > + * @path:    Path to use for the search.
> > + * @dir:     The inode number (objectid) of the directory.
> > + * @name:    The fscrypt_name associated to the directory entry
> > + * @mod:     Used to indicate if the tree search is meant for a read only
> > + *           lookup or for a deletion lookup, so its value should be 0 or
> > + *           -1, respectively.
> > + *
> > + * Returns: NULL if the dir item does not exists, an error pointer if an error
> > + * happened, or a pointer to a dir item if a dir item exists for the given name.
> > + */
> > +struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *trans,
> > +                                                struct btrfs_root *root,
> > +                                                struct btrfs_path *path, u64 dir,
> > +                                                struct fscrypt_name *name, int mod)
> > +{
> > +     struct btrfs_key key;
> > +     struct btrfs_dir_item *di = NULL;
> > +     int ret = 0;
> > +
> > +     key.objectid = dir;
> > +     key.type = BTRFS_DIR_ITEM_KEY;
> > +     key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
> > +     /* XXX get the right hash for no-key names */
>
> Can this dereference a NULL pointer for long nokey names?
>
> When btrfs_unlink() calls fscrypt_setup_filename() with lookup=1 for a
> nokey encrypted filename, fname->disk_name.name is NULL for long nokey
> names (see fscrypt_setup_filename lines 370-375 in fs/crypto/fname.c).
>
> The call chain is: btrfs_unlink -> btrfs_unlink_inode ->
> __btrfs_unlink_inode (line 4396) -> btrfs_lookup_dir_item_fname.
>
> This passes NULL to btrfs_name_hash() at line 257, which calls
> crc32c(NULL, len), causing a kernel crash. The XXX comment at line 258
> acknowledges this is unhandled.
>
> Note: This issue is addressed in a later commit in the patch series
> (fabad1c3ea821 'btrfs: handle nokey names').

Yes, this is handled right in the next commit.

Thanks.

--nX

