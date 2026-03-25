Return-Path: <linux-fscrypt+bounces-1538-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGmLGmnww2lZvAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1538-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 15:25:45 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3DC326B98
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 15:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCCF4313313C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Mar 2026 14:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FB03DDDBB;
	Wed, 25 Mar 2026 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="He8b1eWY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D599F3B27E0
	for <linux-fscrypt@vger.kernel.org>; Wed, 25 Mar 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774448276; cv=pass; b=twAMFabbCjInX0HWHLjgzd6y4SZCd4WwWE1fCgs+Ywgzf/rdYIpCrTCp2r/YHaQgNepzF47iwIRvF1DEm8d5QQT9eqnvkBAtfvIWzf1tRcIlL+tXNzDEn9OTYUsLQ6/f05sryFO7j82z40vHmOfkKNXZfyqByJtsaZIkVqmYq8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774448276; c=relaxed/simple;
	bh=JI+TEE49zQK3cKPmCz6svi6GFaT2s7u6w0MtCQyVKb4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EyOwyeTtns5XSCP8AgC0xyaF7pGCvfeKp+Et8yhRGhUtVNrBzWDSL8ba7Fio1fd0ydkiN0YGMh1fueV349tq4tB3CW4KwH8OmkuiqEnKGIywT76hKcsxGGAasv+6lLGWKUO02nNjU2Mh53UDubEZtnaIhoF0rOPRLEH6ilioIKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=He8b1eWY; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43a03cb1df9so2709630f8f.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Mar 2026 07:17:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774448273; cv=none;
        d=google.com; s=arc-20240605;
        b=RHwyua1PUCB049GkN56X0L64tCQbLP33nut+YkXDFvn7k7ShhT5KGMusbRvzGJkGMe
         L88oZezfv85wj+kSmGbfmSp851Qw0ksXbfX1Tv3c1Hjmuy8hI1KwA1qeQOcH3ef1frKs
         lTtq7oJyC4qwP5Ogs3BcJF8iKTRwfbDPY9Ku72/O+xirwVJRjIZo+l83Qnsf0S98lDEp
         XSdszDwyUhuRXcOcDqfRsqKp3HArOoTALycg/vFjZI7An1VemNquUe3+KW7mOhF5WeKA
         SfzYG9ClgAqJOSBUdvm7DnkBON5FsveoEO391WlLwmDdVRFO9VO+AgDL8aIvouGbd93G
         utAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5n8QXWW6p9E8l82xzEfoMSbTtP2cvmaz+gb8I7NDwzo=;
        fh=xC4LGWAyTbCpPFNbXWo2dDCXC7BTYSfctD1Wky9qwTE=;
        b=Yuyv8deZ9jqOB3uhXWZwmdzWljZliqKYpQcvqUzX2Xn3Ak/TpI+yCyeXTbzqaVZTMU
         l0UxserdxEJO5fpDr5oDcic6nXFAEX8vxiy9VocxFw9URwdCLDOPPRHjsuDERRukE3mA
         Jw4xU5sdympObTOj53O8TTtN7iadflTe2atfpgIUCXC25MmP09wtLo5E2guj52lS8hDg
         jOyurQPhlqWRCATCZAQ08Fp5+rpZS6XZsJg+D4CLr4/pcQn9pE3HYsRbk3L6lFhel4nG
         yO8+dZ8/VrybAUZp5LzOXF72VSz6HeCJs9HGx2nRHQd/9x3hI8LoGxML0aeXAcOVwhjB
         3YSQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774448273; x=1775053073; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5n8QXWW6p9E8l82xzEfoMSbTtP2cvmaz+gb8I7NDwzo=;
        b=He8b1eWY0jASt4uLuF6oCfL1o9EBtkcoL/seGoFNRov2X0T2vI57qN9LsdTbolUsjd
         gGdJf7M7Cpzy7/8lRIQmGMlPM2n4D4RRRn4dG8mSEv5WcDNj4ZfrnXfpo7TPheCsTLrn
         cSiDQVqBLIgxCq/4ndiP4aSrw98h3YOalF/b0D+DhCJEN+2J/w0VCt+5dT6x4xohB+We
         zeoYEQSoVE4z691qKVDVObHLbxFHW/zIyXLK4VQGTLMTG2oqrSfBjJt/34V4HaUAoxOl
         8SYfF9tJnyLr9uxo/Ifuhy5V7mCUdhCpy1Lod4EBRcutAx/cEtrAP29TMps1udKBPcR5
         NilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774448273; x=1775053073;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5n8QXWW6p9E8l82xzEfoMSbTtP2cvmaz+gb8I7NDwzo=;
        b=A4SjuRKKsj7y9wFu5fqOcxYwyWE4UHxplk0AJVqjTEQG3VWU7vBE7wk7zJwFQfeob4
         OrFzkFVuMzc060JBomzWug1BKWYUTSlQOE8W6QSy84jeLi/BfQoSRjIyuHXOGW8S9nrA
         D6OUsvBGhOK69RtpFJZ5AQ3BR0mQ9uwxTvWF9G4Pm/xEoT2ddxI3A5C+N8DmtYYToxtt
         tUi+UjUE3VqF0TsypZieEeG5cWX05ZPBBOT43g7QZM7nSrviNhHkrsNGCv1OclZlpjFa
         9g7vTL7Fx9oT8Y4RtFjB8x1K1XV3IyFFgPIWkpftZPIyM02+5zLzZOID4ldkRzk6sUVN
         926g==
X-Forwarded-Encrypted: i=1; AJvYcCUVyXytRTrL2N87XpCmUDUNDdRihx+t6yX/B+bYLWE5kf2gGrRY+5JNpHVYWkZYEwoBAaNP6H9/zAhCfpXU@vger.kernel.org
X-Gm-Message-State: AOJu0YzCmHhymrYtgAflDXpmQQ7QHx3/JP5N64SIvvEoDEduTlO0iLtR
	2sXT8Ip5z6oIEHRLv9hdzLoROPoc2RjkEYETGtrDIXzfHUxbuL9KcDl1uriJnInoVB9mKn9lZz4
	QLFMS3OjeKY9uppwQ/PDjZZvSFyGUaGDddGmHBi7cqA==
X-Gm-Gg: ATEYQzzfniX2RL94jim/QSsbpSWdKlT7qRPUeCEB75RrGuo9NLUQ4A8iTWb8g2yCW33
	2FafIiXnWa2D2pYk3mPt1ezqTeSklTaubxwL+NTy9GhgLUW+EiT1d6gxrhRdzaTgDrxi+vZLlMo
	Y+zYUFb5NUtanmwqF152XZEM4aT6wUhktrJQA2veQitiQWrjEk0zFX/4Q5mElUN+CnrYsG4zfDz
	dz7/WNk5nl2t7NWESYvZ0vo35zbTp7qNYn7n3lv/Mm4WpH1/Tgcogg6GXxR92eB4+8gBIDUZdcz
	8CVNvj24yWfpiqVGRSiiCwNzdygBHN8w6YgsAYe34E8YMPU/XMvYTQZSMyj0mdGVQc1SO55+aAA
	xQGz6
X-Received: by 2002:a05:6000:2084:b0:43b:3f2d:7d3c with SMTP id
 ffacd0b85a97d-43b88a21758mr5567679f8f.2.1774448273072; Wed, 25 Mar 2026
 07:17:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-34-neelx@suse.com>
 <20260208150854.3090411-1-clm@meta.com>
In-Reply-To: <20260208150854.3090411-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 25 Mar 2026 15:17:41 +0100
X-Gm-Features: AQROBzCA2SzXEdLH4PwF7MzsDSpXTmv7zxyVpq6_W8dQnpHa9Q-YU8fXQyJUEFs
Message-ID: <CAPjX3Fc28BffC9C2Fbd7S_+4Ch7xvX18k6MpehPy_fm+02cA8w@mail.gmail.com>
Subject: Re: [PATCH v6 33/43] btrfs: implement read repair for encryption
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1538-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,meta.com:email,mail.gmail.com:mid,suse.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BE3DC326B98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, 8 Feb 2026 at 16:09, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > In order to do read repair we will allocate sectorsize bio's and read
> > them one at a time, repairing any sectors that don't match their csum.
> > In order to do this we re-submit the IO's after it's failed, and at this
> > point we still need the fscrypt_extent_info for these new bio's.
> >
> > Add the fscrypt_extent_info to the read part of the union in the
> > btrfs_bio, and then pass this through all the places where we do reads.
> > Additionally add the orig_start, because we need to be able to put the
> > correct extent offset for the encryption context.
> >
> > With these in place we can utilize the normal read repair path.  The
> > only exception is that the actual repair of the bad copies has to be
> > triggered from the ->process_bio callback, because this is the encrypted
> > data.  If we waited until the end_io we would have the decrypted data
> > and we don't want to write that to the disk.  This is the only change to
> > the normal read repair path, we trigger the fixup of the broken sectors
> > in ->process_bio, and then we skip that part if we successfully repair
> > the sector in ->process_bio once we get to the endio.
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
> commit 096c17a6a951ed0c1100e863c4ee3a95bab0ad51
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: implement read repair for encryption
>
> This commit implements read repair functionality for encrypted btrfs
> files by adding fscrypt_extent_info tracking to the btrfs_bio structure
> and handling repair operations before decryption occurs.
>
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index c28f3f53bad28..e82de96b533cb 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
>
> [ ... ]
>
> > @@ -293,6 +323,13 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
> >       repair_bbio = btrfs_bio(repair_bio);
> >       btrfs_bio_init(repair_bbio, failed_bbio->inode, failed_bbio->file_offset + bio_offset,
> >                      NULL, fbio);
> > +     repair_bbio->fscrypt_info = fscrypt_get_extent_info(failed_bbio->fscrypt_info);
> > +     repair_bbio->orig_start = failed_bbio->orig_start;
> > +
> > +     btrfs_set_bio_crypt_ctx_from_extent(repair_bio, repair_bbio->inode,
> > +                                         failed_bbio->fscrypt_info,
> > +                                         repair_bbio->file_offset -
> > +                                         failed_bbio->orig_start);
> >
> >       mirror = next_repair_mirror(fbio, failed_bbio->mirror_num);
> >       btrfs_debug(fs_info, "submitting repair read to mirror %d", mirror);
>
> [ ... ]
>
> > @@ -214,17 +244,17 @@ static void btrfs_end_repair_bio(struct btrfs_bio *repair_bbio,
> >                       goto done;
> >               }
> >
> > +             btrfs_set_bio_crypt_ctx_from_extent(&repair_bbio->bio,
> > +                                                 repair_bbio->inode,
> > +                                                 repair_bbio->fscrypt_info,
> > +                                                 repair_bbio->file_offset -
> > +                                                 repair_bbio->orig_start);
> > +
> >               btrfs_submit_bbio(repair_bbio, mirror);
> >               return;
> >       }
> >
> > -     do {
> > -             mirror = prev_repair_mirror(fbio, mirror);
> > -             btrfs_repair_io_failure(fs_info, btrfs_ino(inode),
> > -                               repair_bbio->file_offset, fs_info->sectorsize,
> > -                               logical, paddrs, step, mirror);
> > -     } while (mirror != fbio->bbio->mirror_num);
> > -
> > +     handle_repair(repair_bbio, paddrs);
> >  done:
> >       btrfs_repair_done(fbio);
> >       bio_put(&repair_bbio->bio);
>
> Does this leak the fscrypt_extent_info reference acquired at line 326?
> In repair_one_sector(), repair_bbio->fscrypt_info is set via
> fscrypt_get_extent_info(failed_bbio->fscrypt_info), but when
> btrfs_end_repair_bio() completes at the done label, it calls
> bio_put(&repair_bbio->bio) without calling
> fscrypt_put_extent_info(repair_bbio->fscrypt_info) first.

repair_one_sector() is called from btrfs_check_read_bio() which always
has (bbio a.k.a. failed_bbio)->fscrypt_info NULL. So there is no
object which could leak due to refcounting imbalance. Encrypted read
bbio passes through btrfs_check_encrypted_read_bio() instead which
does not yet implement repair.

Moreover btrfs_end_repair_bio() is called before repair_one_sector().
And when it is called btrfs_check_read_bio() returns and no
repair_one_sector() is caled at all.
The fscrypt_put_extent_info() is eventually called from
btrfs_simple_end_io() => simple_end_io_work() => btrfs_bio_end_io().
So this looks clean, unless I missed something.

> > diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> > index 456d32db9e9e9..7a8ff4378cba0 100644
> > --- a/fs/btrfs/bio.h
> > +++ b/fs/btrfs/bio.h
>
> [ ... ]
>
> > diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> > index 5a39f707c2933..afc461d7642e4 100644
> > --- a/fs/btrfs/compression.c
> > +++ b/fs/btrfs/compression.c
> > @@ -562,6 +562,8 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bbio)
> >       cb->compress_type = btrfs_extent_map_compression(em);
> >       cb->orig_bbio = bbio;
> >       cb->bbio.csum_search_commit_root = bbio->csum_search_commit_root;
> > +     cb->bbio.fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
> > +     cb->bbio.orig_start = 0;
> >
> >       btrfs_set_bio_crypt_ctx_from_extent(&cb->bbio.bio, inode, em->fscrypt_info, 0);
> >       btrfs_free_extent_map(em);
>
> Does this leak the fscrypt_extent_info reference in the compressed read
> path? At line 565, fscrypt_get_extent_info() acquires a reference and
> stores it in cb->bbio.fscrypt_info. Looking at end_bbio_compressed_read()
> in compression.c, it calls btrfs_bio_end_io(cb->orig_bbio, status) which
> releases the ORIGINAL bbio's fscrypt_info, but then calls bio_put(cb_bio)
> without calling fscrypt_put_extent_info(cb->bbio.fscrypt_info). The error
> path in cleanup_compressed_bio() also calls bio_put() without releasing
> the cb->bbio.fscrypt_info reference.

IIUC, the fscrypt_info is put in btrfs_bio_end_io() before calling
end_bbio_compressed_read(). So again, this looks clean to me.

--nX

> [ ... ]
>
>

