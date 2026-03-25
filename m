Return-Path: <linux-fscrypt+bounces-1539-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yNoRN1IBxGm0vQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1539-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 16:37:54 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 848553282DD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 16:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8C583300360A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 15:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672183CEBA5;
	Wed, 25 Mar 2026 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AEXc+gia"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB453DBD5F
	for <linux-fscrypt@vger.kernel.org>; Wed, 25 Mar 2026 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774452444; cv=pass; b=XqYbifm2QMZPqAdbwhGQn3yPLIkz8YGhdONdB2ie4nwVz4021yiESUWbP9DuNRlJYchx8/686DJExf39yHhK5exuhYFZAIxWXJkklodWWV20bpd9yqqlLjTpNCJy4betQXQcs0PLykQyydZa/z00RCA65hPA+64xnPtqeaINhe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774452444; c=relaxed/simple;
	bh=gvTYV6danPBvrbbKycCsMx9z3+3xksJLdC9fppoaH9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ASIJkr93bahNB1Cn/X9knlol29G6FmwdKBnP2znkW4n3nFUg/DHkzOxNeafw9DPhwBkVCaTwxbsGmZOBlaW8qUeEw7wGEMes+yyGkVXI24lKHK9MJKHoJkxUp1l0GOa+sT/b/o4gvU09rQOI12EPjTsViAyzFSLKrwK0AcjIWrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AEXc+gia; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439fe4985efso4529305f8f.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Mar 2026 08:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774452441; cv=none;
        d=google.com; s=arc-20240605;
        b=DgaTcLsJATTAD8LpwrhLGbBTt79ydERAhPI+NUr5n1F1q5EYKWXaxRmlTOQm3WYin4
         s1GctwXccLzglcEYPVAwAkxX+9A3A3XMHwyaQFVrlMOVojGWu3N9GHpswvcgJu6mBQeI
         v6wFoW27Na+jI06WwtAbtxuHnIMRS4n79goL9c6/TbjkhSNAvQOVPr0d18I+PjDpblGZ
         8uYoWz77T+OYaXtFbqfpElZ9uk6yBYFsoq6bpVsPVHarK/A/jhuGktVSddnbYaxNWskB
         Mj0J2wk/IGnmpnEnew3So5bO0qGUyGCiHMyMD3jso+6sQprpgjv4zmTtOLCF0YNldTpl
         uEEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        fh=mzlrdNgreaz3pG2ahMjy+kb3wE8OjCidBzCWCvpYjBc=;
        b=Yma3okxYumdnNU/9UooQEZ30mC0HHjYNEtOXpYO61WK0sF87A204dZqOBNhPY5wLE1
         iy/Evh84e1bLbPlO/GFn9vN6dOxNX2wf1RLIqPsJ20//8WVtR6Pi2n/OA4gYBxWlAKk0
         R970sQqgkbusdf06GfE/rci26CgejS7tbkRpuTmFwdZ5JdrQedLay8aJ//jGE1fiGbxS
         q4+yHgGigY7aBGjQD23S0iLsD+xU5gI3sx5CRrUQOOgU6rVM4oFuBk81lDzXFNxuzn9k
         CK9kKWdNLY+xu92q0xmI2zwqmrWNp+HzbdbfhEmjg0IRLMqAhk4QVIrmKU1+7WdL0o83
         CBYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774452441; x=1775057241; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        b=AEXc+gia4X2WLrsXhq+ccPCtrdadkzFqLhLeTTsWZF8bpUj/GXTEskGg0mLZrNfkSQ
         JTxIxfwUUtVmEkTp+p/XdRf4aBQHw4dLLa7VD9I+xhqdI8OMhDNA6wRxa+ihrFtfAyeU
         tsW4DPcoTLmEdeMUtBlR6SaGNeaW0rFq2MG8tLlXqM2mwX17jVnCDc0bXFg/KuXzAstc
         lDQGzmI36TJyyp1W0K3qOmq3HkVkfhOIlLfaN4I1aGCQ7IPpZ+bLP61gGiUgEPMVEpgB
         41VZEns+2sSHjOjGbE+ZpQgSW5dSlgsqz/N3j1WAUMrxdtUqMh93KP/qMfB/7yZnyn/Y
         cLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774452441; x=1775057241;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dWX1QioYHvYuj0Wi+UEogcC2o0+HVIkdhxi+oA65LkU=;
        b=T9Kqp6yr5T+KU66iL/1sZUFUqcFf5O+cyTsIwOvzY+xxgnuoyniKKHLUnzcvaqkUah
         vLpiG8tE25LBjD/oGfqtefem2MFZxn/AWeSlWKLkZ8NKx7WZGN8P5zx7t8CMmrk0+Ej5
         jmIBgfmAKax3wKTTHU85FVoqARfm8igjw8rzZn4ihfrOanJAKnfK+g0m3C1RFZZFdYnU
         9rntMVDLBkyegeWLmU12VZZO/W2RVHq8gY1E8mgCNTzgmJGHY8dfr5YE7+sj2lbjk4Re
         TfAvZbB4OWfy33XQadX4dwsFGo6EuoKchFUCDVwVCz79GkWjvfdQRvKGAR+QbRqfTFb5
         2+gw==
X-Forwarded-Encrypted: i=1; AJvYcCW4NLPGAOBdCKYF9A3YEWGmFyW+YT3zXAOJL5+egvJu37kj1SqKo76sDacQeHbu5N3ubxJhKaAjMp0NTPYx@vger.kernel.org
X-Gm-Message-State: AOJu0YwfxwU8qLtM1Sc6/Z/pwh50gCr1le3MJevhOIcTYjsFzEnfrtEG
	F2Y2IfMat8LosSzz74R0KtrqYqHSyCUMi0QWzJINy6BLxrt5KE6QpZgvEJr2hdz01T2cnfuotEP
	fnaYOzCMtgadxU2QUPZVlflGq5R3oCRN3nJurRMip5A==
X-Gm-Gg: ATEYQzwaF3oT4aMhVdq8Bg2+rjqGqQ94+Gt9/j1t1bPVSFLrJPy76809bttywqXd50I
	AEdtpV8UpWTrYANkx4vn26VRLJrp0zpsaJKGDoUD0/hbcJelQL4kYjAaGEjOErWlpJowpH2y0Mp
	aa/pBmJJChdBmqRvlXUekWm9fGwjmh+n8Vl1C5G8dLYnBS7XmNfga/Wsyv0U7KouQBbZiey/mE9
	6dO8HNFBvh3g+3foevzzfE/9DS0rbEl8z/wza0KSMqMYdJpgHWX5m20l5NkRBreSlbbxc+ih7Dm
	XltUbSvX9KmVIHcpVT6TXsSfalDBLuyg1mOTDQGSsXnWCnl9I5Ytlwgit8af+ZPD5dfJmgxvkpp
	HJjqz
X-Received: by 2002:a5d:5f92:0:b0:43b:47bc:c147 with SMTP id
 ffacd0b85a97d-43b88a1d79emr5535228f8f.45.1774452440680; Wed, 25 Mar 2026
 08:27:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-36-neelx@suse.com>
 <20260208150339.3021113-1-clm@meta.com>
In-Reply-To: <20260208150339.3021113-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 25 Mar 2026 16:27:09 +0100
X-Gm-Features: AQROBzAFWXwvrixpcNfzyjbXsLbgIekQDOVglJXPaG63xqqZ-H6T96gnhiEXVX4
Message-ID: <CAPjX3Ffn_Q1mPs3-6ZpdOTrp6i=2c8ZiJSyR9Mu_MTe_=OQjnA@mail.gmail.com>
Subject: Re: [PATCH v6 35/43] btrfs: make btrfs_ref_to_path handle encrypted filenames
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1539-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,suse.com:dkim,suse.com:email]
X-Rspamd-Queue-Id: 848553282DD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 8 Feb 2026 at 16:04, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We use this helper for inode-resolve and path resolution in send, so
> > update this helper to properly decrypt any encrypted names it finds.
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
>
> commit 473bbb12052f731a4e2ce3c48e7d7e9f2510528b
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: make btrfs_ref_to_path handle encrypted filenames
>
> This commit updates btrfs_ref_to_path() to handle encrypted filenames by
> introducing a new copy_resolved_iref_to_buf() helper that can decrypt
> names when the filesystem has encryption enabled.
>
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 9bb406f7dd302..577c3ef87791a 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
>
> [ ... ]
>
> > @@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> >       return ret;
> >  }
> >
> > +static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
> > +                                  struct extent_buffer *eb, char *dest,
> > +                                  u64 parent, unsigned long name_off,
> > +                                  u32 name_len, s64 *bytes_left)
> > +{
> > +     struct btrfs_fs_info *fs_info = fs_root->fs_info;
> > +     struct fscrypt_str fname = FSTR_INIT(NULL, 0);
> > +     int ret;
> > +
> > +     /* No encryption, just copy the name in. */
> > +     if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
> > +             *bytes_left -= name_len;
> > +             if (*bytes_left >= 0)
> > +                     read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
> > +             return 0;
> > +     }
> > +
> > +     ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
> > +     if (ret)
> > +             goto out;
> > +
> > +     *bytes_left -= fname.len;
> > +     if (*bytes_left >= 0)
> > +             memcpy(dest + *bytes_left, fname.name, fname.len);
> > +out:
> > +     fscrypt_fname_free_buffer(&fname);
> > +     return ret;
> > +}
> > +
> >  /*
> >   * this iterates to turn a name (from iref/extref) into a full filesystem path.
> >   * Elements of the path are separated by '/' and the path is guaranteed to be
> > @@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> >               dest[bytes_left] = '\0';
> >
> >       while (1) {
> > -             bytes_left -= name_len;
> > -             if (bytes_left >= 0)
> > -                     read_extent_buffer(eb, dest + bytes_left,
> > -                                        name_off, name_len);
> > +             ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
> > +                                             name_off, name_len, &bytes_left);
> > +             if (ret)
> > +                     break;
> >               if (eb != eb_in) {
> >                       if (!path->skip_locking)
> >                               btrfs_tree_read_unlock(eb);
>
> Does this code leak the extent buffer when copy_resolved_iref_to_buf()
> fails? Looking at the loop structure in btrfs_ref_to_path(), when
> copy_resolved_iref_to_buf() returns an error and we break at line 2178,
> the cleanup code that follows never executes:
>
>     if (eb != eb_in) {
>         if (!path->skip_locking)
>             btrfs_tree_read_unlock(eb);
>         free_extent_buffer(eb);
>     }
>
> This can happen in subsequent iterations where eb != eb_in (the extent
> buffer was detached from path->nodes[0] and set to NULL in the previous
> iteration). The cleanup at the end of the function (btrfs_release_path()
> at line 2216) cannot free eb since it's no longer in the path.

Right, the break should be placed only after the cleanup.

--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2174,13 +2174,14 @@ char *btrfs_ref_to_path(struct btrfs_root
*fs_root, struct btrfs_path *path,
     while (1) {
         ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
                         name_off, name_len, &bytes_left);
-        if (ret)
-            break;
         if (eb != eb_in) {
             if (!path->skip_locking)
                 btrfs_tree_read_unlock(eb);
             free_extent_buffer(eb);
         }
+        if (ret)
+            break;
+
         ret = btrfs_find_item(fs_root, path, parent, 0,
                 BTRFS_INODE_REF_KEY, &found_key);
         if (ret > 0)

Thanks.

--nX

> This could be triggered when decryption fails in copy_resolved_iref_to_buf()
> due to btrfs_iget() error, fscrypt_fname_alloc_buffer() ENOMEM, or
> fscrypt_prepare_readdir() failure on an encrypted filesystem.
>
> Before this patch, the name copy operation (read_extent_buffer) could not
> fail, so the cleanup always happened before any error check.
>

On Sun, 8 Feb 2026 at 16:04, Chris Mason <clm@meta.com> wrote:
>
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We use this helper for inode-resolve and path resolution in send, so
> > update this helper to properly decrypt any encrypted names it finds.
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
>
> commit 473bbb12052f731a4e2ce3c48e7d7e9f2510528b
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: make btrfs_ref_to_path handle encrypted filenames
>
> This commit updates btrfs_ref_to_path() to handle encrypted filenames by
> introducing a new copy_resolved_iref_to_buf() helper that can decrypt
> names when the filesystem has encryption enabled.
>
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index 9bb406f7dd302..577c3ef87791a 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
>
> [ ... ]
>
> > @@ -2107,6 +2108,39 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> >       return ret;
> >  }
> >
> > +static int copy_resolved_iref_to_buf(struct btrfs_root *fs_root,
> > +                                  struct extent_buffer *eb, char *dest,
> > +                                  u64 parent, unsigned long name_off,
> > +                                  u32 name_len, s64 *bytes_left)
> > +{
> > +     struct btrfs_fs_info *fs_info = fs_root->fs_info;
> > +     struct fscrypt_str fname = FSTR_INIT(NULL, 0);
> > +     int ret;
> > +
> > +     /* No encryption, just copy the name in. */
> > +     if (!btrfs_fs_incompat(fs_info, ENCRYPT)) {
> > +             *bytes_left -= name_len;
> > +             if (*bytes_left >= 0)
> > +                     read_extent_buffer(eb, dest + *bytes_left, name_off, name_len);
> > +             return 0;
> > +     }
> > +
> > +     ret = fscrypt_fname_alloc_buffer(BTRFS_NAME_LEN, &fname);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = btrfs_decrypt_name(fs_root, eb, name_off, name_len, parent, &fname);
> > +     if (ret)
> > +             goto out;
> > +
> > +     *bytes_left -= fname.len;
> > +     if (*bytes_left >= 0)
> > +             memcpy(dest + *bytes_left, fname.name, fname.len);
> > +out:
> > +     fscrypt_fname_free_buffer(&fname);
> > +     return ret;
> > +}
> > +
> >  /*
> >   * this iterates to turn a name (from iref/extref) into a full filesystem path.
> >   * Elements of the path are separated by '/' and the path is guaranteed to be
> > @@ -2138,10 +2172,10 @@ char *btrfs_ref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> >               dest[bytes_left] = '\0';
> >
> >       while (1) {
> > -             bytes_left -= name_len;
> > -             if (bytes_left >= 0)
> > -                     read_extent_buffer(eb, dest + bytes_left,
> > -                                        name_off, name_len);
> > +             ret = copy_resolved_iref_to_buf(fs_root, eb, dest, parent,
> > +                                             name_off, name_len, &bytes_left);
> > +             if (ret)
> > +                     break;
> >               if (eb != eb_in) {
> >                       if (!path->skip_locking)
> >                               btrfs_tree_read_unlock(eb);
>
> Does this code leak the extent buffer when copy_resolved_iref_to_buf()
> fails? Looking at the loop structure in btrfs_ref_to_path(), when
> copy_resolved_iref_to_buf() returns an error and we break at line 2178,
> the cleanup code that follows never executes:
>
>     if (eb != eb_in) {
>         if (!path->skip_locking)
>             btrfs_tree_read_unlock(eb);
>         free_extent_buffer(eb);
>     }
>
> This can happen in subsequent iterations where eb != eb_in (the extent
> buffer was detached from path->nodes[0] and set to NULL in the previous
> iteration). The cleanup at the end of the function (btrfs_release_path()
> at line 2216) cannot free eb since it's no longer in the path.
>
> This could be triggered when decryption fails in copy_resolved_iref_to_buf()
> due to btrfs_iget() error, fscrypt_fname_alloc_buffer() ENOMEM, or
> fscrypt_prepare_readdir() failure on an encrypted filesystem.
>
> Before this patch, the name copy operation (read_extent_buffer) could not
> fail, so the cleanup always happened before any error check.
>

