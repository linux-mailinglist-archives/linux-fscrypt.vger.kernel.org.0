Return-Path: <linux-fscrypt+bounces-1611-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMaGIpy/GWoqywgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1611-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 18:32:28 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB01C605A9A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 18:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59C6831A1122
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2026 15:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42CE36AB7C;
	Fri, 29 May 2026 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QLZZHhOm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47D333B97B
	for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780069437; cv=pass; b=IaYZq4kVID69U7jyUaLqdsDa2VIm1FrevQbv/6gTR6EEZ1CNwLRZw4WSl0cCAo7g2bL8+f4/npTDGWthgmNILXNT5MxkFl/aeqdYzbr6knGoYUWK3kAK/xD4ffuR5CNCiQMxNchFFnQfVsFYIgoUgytc6EW9yNy/tvIq1MSL8J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780069437; c=relaxed/simple;
	bh=6BGZKHWpW1Dl8PoL8+e7WbTrHofucG0I+sMBcDZ/tfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WDSaOK6Z6oPpLSHx9KFhUirOtjpFgATUGsYuyCZXCSR4kECMKTvdXRqJrPpj/t6o8ADPfslYO5xgbZNz6d5fnyZbp5dmmifk3+tMnvI1UQCJgSXadq+AJDSI8IysTexPdg0aVm9/webXVGQ7JvFwG9Dg4dWZC2Kg0RzBvFWYOUg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QLZZHhOm; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49068493267so40778415e9.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 29 May 2026 08:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780069433; cv=none;
        d=google.com; s=arc-20240605;
        b=NW7aQYlJM9fgB535ncCsxbE6VwLbXeJp/7/tHnfdJGX/JamPPdRHH0xRFs7yN7VHO3
         GaYXd3hcGjt/wF4L4bxR958+eGnZ66y9jO0iaqAJf4+IbXo2uCfspUnPiVc41QYQLs1x
         ewUwtKVWwm9ZftZWgwOMU6marHhHeiqrzz8kDCy0/fiDW1dhKaxS573R+Tg7UzpWb6Nd
         Y0gxvxxIj+LbuTXtWpM6eVqKcULww5ObzUtuVQqipgraK0whj3Y1VBSZbIlNGS1iRarr
         QwCSxjLQWknbKx+Gt0aHLtoqmbUvC2u6ntKjExgYVTGOHxfhcdtvjIgdFX6isVEqWEGF
         dydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        fh=odxQq6aA04+zdel4sDZ3uvtPUeWqMLPUW8I+Imz9xOg=;
        b=FuzotOEwzvhUE8CweDvZkXBwe5K5LQx4zrYeQYVq3sJJ7bwZ2SpBJ4gNM/soWjUwG6
         tgAfMkS9dX4IlnFsbTG84JKidilOYxItJNJ8YbU2eAiwXSwBDCiUOWvnqSuJh3y0Eygk
         DFBtDTvQswjiMxEXdkEnFg77QCMmg4Pm+qEp8FvR8oLOqnf+iJSoeGr9O9VrSX9LJNtH
         5lVIZ+eqbLGmgEsbYcHckM2NkY1rKeIjP3H9zVrsDVcawxUv7s9ScubUIMik2727aAmj
         H/nuiXrhKlLIN7HxVhGF2YkTIzxJwB5StS4dm43r3cqOIO6Uo6L8MIWOEs/ge5RUS0KM
         W/0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780069433; x=1780674233; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        b=QLZZHhOmpwlCP4LowYEmzfEe4SBEyZsMKXBANxNaaOJ+Hg0GJCAv/fifFswndd3Srv
         shyKwxFL2E4QUxLY7faSYCNZhSonaTSBz5I7rKfay3+i672u/9lnnQroQV+o3jWCk9Tp
         4htAYkHDdqipNHUbh/zpnktVLYeUIk2JR+VrViZbw0QnXcGO7tZOMH+WHF32/ocu+gW6
         DNQrpK1eYLqV8pbDazR6qFxrgKNXy7wfIc9kuK6YhUucrNbdfOdVjyziEUSjnyo6TQa7
         2JkdgkDAZDJ8osymbnbbBaSF953hBFeDhiEhzCASEL1kpYIczHC1IbKNZjdu1oUITylR
         9eZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780069433; x=1780674233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        b=NVqz6q2abQMyc+tvsvjqG8ZsDj6SHio4wh8aI2tU4XjsyZG0BQQMzR435FVhf2Zn22
         atq95kld/8vzMaeX+u324LD50lZrxdxloaGJ9mha5sBXEHh540hDNLEC5k1VbVvrSJLU
         s68uQjesvgC0ycQkXSrUEmsG2LVN51E/THuMxwu1EsJ1Zlxfxv/q+A4WWZFD04XCYGAg
         MAEmM6sSO11ngtgYaKzBWH+IRYV5ygThxZ6JE2qLUB6sdz0LM1nzG2Gdm3iXOaHvea18
         Zmm6Mmsk/bUBkV7lCINr+ov0DBJ8Y253p7T5RioDZaNoNvI74yqTb6+yPEIXBRFqVRjV
         SYFw==
X-Forwarded-Encrypted: i=1; AFNElJ8W6tn72CMImO6CUxUUYhvsft2VVVW0E4nLcBDfGJeIWJ1k7fHMDTPaxljHCismVCgtn1Yq72fL4FVh5K8U@vger.kernel.org
X-Gm-Message-State: AOJu0YzzgZiUznnTvpMn5xL9SpH/UmVeuZ4mAuQAE9RIHEtdsOYymVJr
	vUXshC1bb2Z2h3BtDFaGZ7BI4Ktpdt9OlBNb4UXpx2pzm62ic38w7Xf6UGUWUD0qxG8F6rvVU9w
	fwlwWFjU41EpWFV4s6ymo4aLNCn9TPS1dwigHcKO/aQ==
X-Gm-Gg: Acq92OGcEhZGTAswIY0HFUpp1DTt8INy2Dop3ftXm5teHU52S4FkXiJmFCEeJgOG5vh
	a6n18s3prwZS6RxUUjyVHM/sHhP3V+h1eQxLCxBfvl2RjSpGKd7kbrDjOWH2TY8hiZWqP6SHOLq
	hZc570B4T6AMs6x5PfOeLIM//iMm+SqJuobk3AtVLsbrv0lZgmP05TaQtQN4H38XYI8yr9S2DrF
	RXfwefI5kW6hdZU23VevfdmoJ6FvG9YxPNNz28Fxxx3MEJZmJkSKvdydEsGGgQPxc6Pv8qeYh90
	G4MiGTaRmXh+Wp1KRKJU7riTMAaa1AXMKIV17qe3pQjVckEF0QU1OaxhxIVSln4r2+cTkh2pGJ9
	k/co9jm72bCz7Nvo=
X-Received: by 2002:a05:600c:1d86:b0:48e:60a3:220a with SMTP id
 5b1f17b1804b1-490a28aa789mr4847005e9.0.1780069433114; Fri, 29 May 2026
 08:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-33-neelx@suse.com>
 <ahAfo4DzvH_ob1hv@infradead.org>
In-Reply-To: <ahAfo4DzvH_ob1hv@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 29 May 2026 17:43:41 +0200
X-Gm-Features: AVHnY4LNmQMXMJqOYo-u3g5g_FfS_GaIHTnMIQeq2jow0uPl_gbFF7i0-FQGaO8
Message-ID: <CAPjX3Ff1qSLGNP3979KzLoAJCJcT_1se0WJsBHmDWuvhkOwQxg@mail.gmail.com>
Subject: Re: [PATCH v7 32/43] btrfs: implement process_bio cb for fscrypt
To: Christoph Hellwig <hch@infradead.org>
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
	TAGGED_FROM(0.00)[bounces-1611-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,infradead.org:email,suse.com:email,suse.com:dkim,mail.gmail.com:mid,toxicpanda.com:email]
X-Rspamd-Queue-Id: AB01C605A9A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 22 May 2026 at 11:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 13, 2026 at 10:53:06AM +0200, Daniel Vacek wrote:
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
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > v7 changes:
> >  * Fixed array overflow stack corruption for bios > max blocksize (>64KiB)
> >    as reported by Chris' AI review.
> > v6 changes:
> >  * Adapt to btrfs_data_csum_ok() changes for bs > ps.  Mostly follow
> >    what was done in 052fd7a5cace ("btrfs: make read verification
> >    handle bs > ps cases without large folios").
> >  * Rename bbio::csum_done to csum_ok due to name collision.
> >    With upstream, member name csum_done was used for async csums.
> > v5: https://lore.kernel.org/linux-btrfs/ca32684b01ff8c252be515509137e0a4a0e5db7a.1706116485.git.josef@toxicpanda.com/
> > ---
> >  fs/btrfs/bio.c       | 44 +++++++++++++++++++++++++++++++++++++++++++-
> >  fs/btrfs/bio.h       |  3 +++
> >  fs/btrfs/file-item.c | 14 ++++++++++++--
> >  fs/btrfs/fscrypt.c   | 29 +++++++++++++++++++++++++++++
> >  4 files changed, 87 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 3e2ee19aab50..729c5aff5c3d 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -301,6 +301,40 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
> >       return fbio;
> >  }
> >
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> > +{
> > +     struct btrfs_inode *inode = bbio->inode;
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +     struct bvec_iter iter = bbio->saved_iter;
> > +     struct btrfs_device *dev = bbio->bio.bi_private;
> > +     const u32 blocksize = fs_info->sectorsize;
> > +     const u32 step = min(blocksize, PAGE_SIZE);
> > +     const u32 nr_steps = iter.bi_size / step;
> > +     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
> > +     phys_addr_t paddr;
> > +     unsigned int slot = 0;
> > +     u32 offset = 0;
> > +
> > +     /*
> > +      * We have to use a copy of iter in case there's an error,
> > +      * btrfs_check_read_bio will handle submitting the repair bios.
> > +      */
> > +     btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> > +             ASSERT(slot < nr_steps);
> > +             paddrs[slot] = paddr;
> > +             slot++;
> > +             offset += step;
> > +             if (IS_ALIGNED(offset, blocksize)) {
> > +                     if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
> > +                             return BLK_STS_IOERR;
> > +                     slot = 0;
> > +             }
> > +     }
> > +
> > +     bbio->csum_ok = true;
> > +     return BLK_STS_OK;
> > +}
> > +
> >  static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *dev)
> >  {
> >       struct btrfs_inode *inode = bbio->inode;
> > @@ -330,6 +364,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
> >       /* Clear the I/O error. A failed repair will reset it. */
> >       bbio->bio.bi_status = BLK_STS_OK;
> >
> > +     /* This was an encrypted bio and we've already done the csum check. */
> > +     if (status == BLK_STS_OK && bbio->csum_ok)
> > +             goto out;
> > +
> >       btrfs_bio_for_each_block(paddr, &bbio->bio, iter, step) {
> >               paddrs[(offset / step) % nr_steps] = paddr;
> >               offset += step;
> > @@ -341,6 +379,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
> >                                                        paddrs, fbio);
> >               }
> >       }
> > +out:
> >       if (bbio->csum != bbio->csum_inline)
> >               kvfree(bbio->csum);
> >
> > @@ -859,10 +898,13 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
> >               /*
> >                * Csum items for reloc roots have already been cloned at this
> >                * point, so they are handled as part of the no-checksum case.
> > +              *
> > +              * Encrypted inodes are csum'ed via the ->process_bio callback.
> >                */
> >               if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> >                   !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
> > -                 !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
> > +                 !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap &&
> > +                 !IS_ENCRYPTED(&inode->vfs_inode)) {
> >                       if (should_async_write(bbio) &&
> >                           btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
> >                               goto done;
> > diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> > index 43f7544029ac..456d32db9e9e 100644
> > --- a/fs/btrfs/bio.h
> > +++ b/fs/btrfs/bio.h
> > @@ -43,6 +43,7 @@ struct btrfs_bio {
> >               struct {
> >                       u8 *csum;
> >                       u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
> > +                     bool csum_ok;
> >                       struct bvec_iter saved_iter;
> >               };
> >
> > @@ -130,5 +131,7 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
> >  int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
> >                           u32 length, u64 logical, const phys_addr_t paddrs[],
> >                           unsigned int step, int mirror_num);
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
> > +                                         struct bio *enc_bio);
> >
> >  #endif
> > diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> > index 986914078708..72d9d3243460 100644
> > --- a/fs/btrfs/file-item.c
> > +++ b/fs/btrfs/file-item.c
> > @@ -338,6 +338,14 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
> >       return ret;
> >  }
> >
> > +static inline bool inode_skip_csum(struct btrfs_inode *inode)
> > +{
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +
> > +     return (inode->flags & BTRFS_INODE_NODATASUM) ||
> > +             test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state);
> > +}
> > +
> >  /*
> >   * Lookup the checksum for the read bio in csum tree.
> >   *
> > @@ -357,8 +365,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
> >       int ret = 0;
> >       u32 bio_offset = 0;
> >
> > -     if ((inode->flags & BTRFS_INODE_NODATASUM) ||
> > -         test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
> > +     if (inode_skip_csum(inode))
> >               return 0;
> >
> >       /*
> > @@ -817,6 +824,9 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async)
> >       struct btrfs_ordered_sum *sums;
> >       unsigned nofs_flag;
> >
> > +     if (inode_skip_csum(inode))
> > +             return 0;
> > +
> >       nofs_flag = memalloc_nofs_save();
> >       sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
> >                      GFP_KERNEL);
> > diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> > index 5d34a8b94da5..924ee3df7f32 100644
> > --- a/fs/btrfs/fscrypt.c
> > +++ b/fs/btrfs/fscrypt.c
> > @@ -16,6 +16,7 @@
> >  #include "transaction.h"
> >  #include "volumes.h"
> >  #include "xattr.h"
> > +#include "file-item.h"
> >
> >  /*
> >   * From a given location in a leaf, read a name into a qstr (usually a
> > @@ -212,6 +213,33 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
> >       return devs;
> >  }
> >
> > +static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
> > +                                             struct bio *enc_bio)
> > +{
> > +     struct btrfs_bio *bbio;
> > +
> > +     /*
> > +      * If our bio is from the normal fs_bio_set then we know this is a
> > +      * mirror split and we can skip it, we'll get the real bio on the last
> > +      * mirror and we can process that one.
> > +      */
> > +     if (orig_bio->bi_pool == &fs_bio_set)
> > +             return BLK_STS_OK;
> > +
> > +     bbio = btrfs_bio(orig_bio);
> > +
> > +     if (bio_op(orig_bio) == REQ_OP_READ) {
> > +             /*
> > +              * We have ->saved_iter based on the orig_bio, so if the block
> > +              * layer changes we need to notice this asap so we can update
> > +              * our code to handle the new world order.
> > +              */
> > +             ASSERT(orig_bio == enc_bio);
> > +             return btrfs_check_encrypted_read_bio(bbio, enc_bio);
> > +     }
> > +     return btrfs_csum_one_bio(bbio, enc_bio, false);
>
> Honestly, all this shows that the architecture of the I/O path in this
> series is pretty broken.  It needs all this magic detection, and the
> passing of arguments that mixes the bbio for state and the lower
> encrypted bio without the btrfs context shows something doesn't work
> well.

Well, this is all limited within the scope of the filesystem. Since
btrfs needs to compute the data checksum and the bounce bio (with the
encrypted pages) is created by the lower fscrypt layer, how else could
we accomplish this?

As the blk-crypto is inlined, without the callback the filesystem
never sees the encrypted data at all and it won't be able to get
checksums.

> So let's take a step back, if we think of the I/O pipeline, it should do
> things in this order for writes:
>
>  - encrypt data
>  - generate checksums
>  - do mirroring/striping/parity
>
> and reverse for reads.
>
> All this suggest that the btrfs_bio needs to exist for the encrypted
> data.

My understanding was that fscrypt works differently. The bounce bio is
created inline in the lower layer, agnostic to any filesystem.

>  So I think you'll need to and refactor this, preferably with the
> really annoying two-level callbacks that this really hard to follow (or
> implement).  Your caller is in the file system, and it should be able to
> call fscrypt as helpers instead of going two layers down using direct
> calls and then two layers back up using indirect calls.  The recent
> refactoring that moves the fscrypt fallback above the block layer
> instead of calling it from the bottom should help a lot with that.

Yeah, I may look into that. What you're talking about is a pretty recent change.
This is an old patch [1] from 2023 rebased without many changes since
as there was not much feedback before. So it still follows the
original (former) design.

If fscrypt supported checksumming the encrypted data and returned the
value back to the filesystem, no callbacks would be needed. Though to
me that sounds more invasive than this callback.

[1] https://lore.kernel.org/linux-btrfs/a26514814b4d2a54ff2317369365dc2bf1c280dc.1695750478.git.josef@toxicpanda.com/

--nX

