Return-Path: <linux-fscrypt+bounces-1470-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iPA9CGvlpmnjZAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1470-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Mar 2026 14:43:07 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8A01F0872
	for <lists+linux-fscrypt@lfdr.de>; Tue, 03 Mar 2026 14:43:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4757A303D5C6
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Mar 2026 13:42:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A3F2C11C6;
	Tue,  3 Mar 2026 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SPVwXEK9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EA22DECB2
	for <linux-fscrypt@vger.kernel.org>; Tue,  3 Mar 2026 13:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772545340; cv=pass; b=UTrb59yJhyGAxKfl9pyccfhrj/TakWzn7URXEBdc4FvXbH4OzoXNxXKMBHEuR6zzb4mDQ3F/Lqfg/fQXvrGQRWPMXX2yZZU+rkwRLJBIi9CVTMD/ntXqUS6Kk1PUEQFp5w/l5JskKTR5d/tGWNgmLbetyU/YT3IfX7YdXAcRrt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772545340; c=relaxed/simple;
	bh=wgYWEoqsML2P5iIsD4BqeYCULYtO2ps0y8epzXQyMd0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FFu2KZdJtIgW+MrlHYjE+CkR+vQVqQ+aXO47Fagnr2CwIaAbw2N8WEmIzVhRq9ioQFX8CYyMwkpbzYTkWU8DDFawz963VcP56y8R3QRE0gY3CvPfJdNmyXSmSQs4C1qBWK0Jr45iy8Oc9bjjzlv27xoRAPRrKkRTu1Y9pTNzTO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SPVwXEK9; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso2100127f8f.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 Mar 2026 05:42:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772545334; cv=none;
        d=google.com; s=arc-20240605;
        b=FO2yl/wYLK2lrhDD8bHh5fajEfswD8l9kVaYhj/hJbdO6VAqas9F2QvlrLFFNH0KP/
         Bp0iPwb0n78weka2bhE1OWENfWDNVEgXyaYyjYPEFZlgMRUNLPBbGx2XKHseCA1G0f4R
         ivwM/Mkw2agJ17iJhtmm/qPRKnSlbiYrC69lIRmnSWmZKSnUmBQksw95cOsEGtQWma0l
         Lp1PeW7sFVzwKXKATqTSSWoJetx7TkYvI8KXZNdbGit7tFJBB2MGSHJSUr/F7UB7+GZx
         X7QIsXIJYzdxDd7Q1mzexA84Os2naf2BFynWIffQ67cn7W+TYP4YoTGdqempiF8MTc+Z
         hfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YJaqiIjGfzl7r+r7hHRF7Oqm8KAWNGUWa5R8il4nFL8=;
        fh=8S+8KcTFTQaiVPhVLGE3z8CY/NvxVUYnfmzcs3ZSV5U=;
        b=Vf+xmywOZob6cTIHotwxM7xENpEhHpyc8NJqcoPDTQOngZkQdZ9637r+NoyoAo4rYz
         BFbQaKTZ4BB+eXf/NnPMEBVtgtK7YHTVtKn/kBO0XcGz5GbgqEJ6PO18HNuAQTU/2EFa
         UJ0GkW3qJWCVttKXNj+Gjim+K43oefbanIMTZ9qfqYy3T73zLjGLq8BSUt8XqW+5XfW+
         dbhvfN2mytMR/LDakFFIm+O8teyp7ccMqw7AEun1XVzcacUPtz8vE9izvgcUER4S2KVf
         7AhxWk6JluzfsOiPxfo4QKW8EkQFZamRl9ZulpyPaFp7SWe6HWQzDQ8dPe1QcN1GpGQh
         ZFgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772545334; x=1773150134; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YJaqiIjGfzl7r+r7hHRF7Oqm8KAWNGUWa5R8il4nFL8=;
        b=SPVwXEK9iCmnZ4Cp7rDazWQT0c9sKx/n3NcAo1znEacaYh2DHSSw4kfg1+7jT5CGGM
         3uY3vregmeSIUHb+MDcuBw/c4JtuOJjYqM8c3VnyQuwhoU4XdgZDCltlROTMArbcM/Mi
         UrpJjkaArEvOqd1GKYid6DBE1M0sfvNO8ShGWryABlcw8Yl8eckTFTS65bQyjLllNPoy
         uWZznh5m8mOJc5TteptL0JKYfq3Hkk7npZa4njIl418sWhIlFLLUQ48PGM+iZLd3Gk80
         T+sQFAa7wGDwqq/BgdN3hUqTHHEbby9ZiPRrojbMOoSf1CgR0JWlQcAghijOaj6p/Tak
         gG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772545334; x=1773150134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJaqiIjGfzl7r+r7hHRF7Oqm8KAWNGUWa5R8il4nFL8=;
        b=MVgQywCOw0BIopNWT+FysM+43dsoykrc9L/fgyAm+x9trDXAxW0bzcMYCUfrC8JTnX
         JOxKKEl2ZYD657uu8yxuJMvaC8fStrSwRfeo0CdHdxDIYA4+Ryxnt1rc1eCBvHDT3nqQ
         DajjGQxZzhLZFuIBf8wZTiyEmCX+5aSF/bHJYx/Jj+hVKl6/Mr4Zf/K4idZkjoJweYyB
         i9UX9AWi+wMM5SZMLptFzWojCxGaGWGj4TiqGy3gP8d1BPpryHT5MC+GggOS4USKf1jj
         1Ry4/02C1rIZXgWnC6XSHEfMyPpoUZJQw2Zup2B5ZUiqtaFSsJDs2rrEtKojzcETOQfA
         3d2Q==
X-Forwarded-Encrypted: i=1; AJvYcCViIZN4iCN45BlIFI78Yy3rvSAGPudp94cM3BwR+7jmnzANvyvXfXGTJKHJwvTWOjyCsegXq7Y5w8rTJuv2@vger.kernel.org
X-Gm-Message-State: AOJu0YxvHpUA9bZFI5OIwkcafct7zpRKRH2Sx3b3/QFgfVJLbfWFBtA1
	dOrNHVIq0J7N1paoMhYMIik9+U7VGrPZ+X/sIqfK3dPvI//JcTBQ5eyvrrmFw3I1bLqLN3DyCbl
	syMQq7/SR7E0txVzFdptZtS5qQkQwX3viI6V1lvhGWw==
X-Gm-Gg: ATEYQzyE6pFCoounTp6BIf0u44c4Z7zJr/E4VqnRhXWVXCReU/0ijoM2ztbVqjVS2mZ
	u21rE6R9okrPPUcbWBkoQYzCpx9V6CAR4hvHD5QFXCkxmX4dpHnQCF/Pbo/n5V9qS4IA8mSjn3a
	/HDlR8w98A0dV49/j4r+NZQBzytXx83kYamk5AceRwMoJVum5Pj0PWpiZs24/e+fkvpRlqzjTOi
	/oW/MAadanTXkTzShPSxUsPXcpd+pRtYkQXJ1IBVVSBUBMJIVBr4PwF41JhNeEz069eP6th+qaD
	S5u2CcSxmQVveJ2Qe3P3kuvT1Y33Ur5FAnkW+9o26/cXNfSPEtPzppm0lGYwzSwTe1tbh5qWudj
	GBnvO
X-Received: by 2002:a05:6000:103:b0:439:ba75:7dab with SMTP id
 ffacd0b85a97d-439ba75808amr8599438f8f.9.1772545334391; Tue, 03 Mar 2026
 05:42:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-29-neelx@suse.com>
 <20260208151350.3147841-1-clm@meta.com>
In-Reply-To: <20260208151350.3147841-1-clm@meta.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 3 Mar 2026 14:42:02 +0100
X-Gm-Features: AaiRm53vOiLHz-pIgqzqpiZzKddGUEkGBHvzwx_BwVSRp9P3mvJA2QJFOq5bVis
Message-ID: <CAPjX3FfS-0Jx8NmMX1deQfUbhMv4sNWWLE4n_HbsD5PWrLte+A@mail.gmail.com>
Subject: Re: [PATCH v6 28/43] btrfs: populate ordered_extent with the orig offset
To: Chris Mason <clm@meta.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8C8A01F0872
X-Rspamd-Server: lfdr
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
	TAGGED_FROM(0.00)[bounces-1470-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,suse.com:dkim,suse.com:email,toxicpanda.com:email]
X-Rspamd-Action: no action

On Sun, 8 Feb 2026 at 16:14, Chris Mason <clm@meta.com> wrote:
> Daniel Vacek <neelx@suse.com> wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > For extent encryption we have to use a logical block nr as input for the
> > IV.  For btrfs we're using the offset into the extent we're operating
> > on.  For most ordered extents this is the same as the file_offset,
> > however for prealloc and NOCOW we have to use the original offset.
> >
> > Add this as an argument and plumb it through everywhere, this will be
> > used when setting up the bio.
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
> commit 0e7f6a617a2642bbdf97bcd639fb887fa88189ad
> Author: Josef Bacik <josef@toxicpanda.com>
>
> btrfs: populate ordered_extent with the orig offset
>
> This commit adds orig_offset tracking to btrfs_ordered_extent and
> btrfs_file_extent structures for extent encryption support, where the
> offset into the extent is needed for IV generation.
>
> > diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> > index d3789109ca851..2d89ac05b1b38 100644
> > --- a/fs/btrfs/direct-io.c
> > +++ b/fs/btrfs/direct-io.c
> > @@ -155,6 +155,7 @@ static struct extent_map *btrfs_create_dio_extent(struct btrfs_inode *inode,
> >               file_extent->fscrypt_info = em->fscrypt_info;
> >       }
> >
> > +     file_extent->orig_offset = start - file_extent->offset;
> >       ordered = btrfs_alloc_ordered_extent(inode, start, file_extent,
> >                                            (1U << type) |
> >                                            (1U << BTRFS_ORDERED_DIRECT));
>
> [ ... ]
>
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index fbb968d4010b7..8078049f690e1 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
>
> [ ... ]
>
> > @@ -2296,6 +2298,8 @@ static noinline int run_delalloc_nocow(struct btrfs_inode *inode,
> >                       cow_start = (u64)-1;
> >               }
> >
> > +             nocow_args.file_extent.orig_offset =
> > +                     found_key.offset - nocow_args.file_extent.offset;
> >               ret = nocow_one_range(inode, locked_folio, &cached_state,
> >                                     &nocow_args, cur_offset,
> >                                     extent_type == BTRFS_FILE_EXTENT_PREALLOC);
>
> Should this calculation use cur_offset instead of found_key.offset?

IIUC, no. We need to keep the offset from the original extent
precisely to keep the data consistent. That's the whole point.

--nX


> Looking at the DIO path in btrfs_create_dio_extent() (direct-io.c line
> 158), the orig_offset is calculated as:
>
>     file_extent->orig_offset = start - file_extent->offset;
>
> where 'start' is the current write position. In run_delalloc_nocow(),
> found_key.offset represents where the extent item is stored, while
> cur_offset represents the current write position (analogous to 'start'
> in the DIO path).
>
> When writing to a position within an existing extent (not at its start),
> using found_key.offset - file_extent.offset could produce incorrect
> values. For consistency with the DIO path, would the formula be:
>
>     nocow_args.file_extent.orig_offset =
>         cur_offset - nocow_args.file_extent.offset;
>
> This would ensure that NOCOW writes calculate orig_offset the same way
> as DIO writes, which matters for encryption IV generation where an
> incorrect offset would cause data corruption on reads.
>

