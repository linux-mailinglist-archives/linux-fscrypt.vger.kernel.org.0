Return-Path: <linux-fscrypt+bounces-1711-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id iYwBENYORmoaIgsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1711-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:10:14 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 751BB6F4090
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:10:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=Hde8pGFA;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1711-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1711-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 985B7305A218
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 07:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 460B138F24D;
	Thu,  2 Jul 2026 07:05:50 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C19236492D
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 07:05:48 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975950; cv=pass; b=LuUtxvrUEMEcIsMK46HOrkgE44HqJ3kF/uJqRR2bOxi1mYciuPY1XR9L+6+aF2zMfu+j2VWMfM78+eNSsTRNhR/3gqdHTrYIz1hypm1jCNwcOG+26MSAiaHY4JpznaZrIiYCx2s4psy6G4DM1nayyHv4hforYcI8xnir329lMJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975950; c=relaxed/simple;
	bh=5Rdgd0oa19t4IWPA978XuKzOlbIgUoOIcrjdEGt9x2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VRaSsF+Y2ox7mJhXfVGbyJzSZEcOGLVS2bMgfVf1EPkvOeJMwy6QQ1qJ0bNG1spRNN0CvDqzqRbkoXP00Y85oHfW0r4Eioh8hfb022yFfxT+4S1nSjz2iwpCWS2j4wcWxxP7PTvoiT8QtXqq3DVN73Ew5yJ4EiVFq3bjoK3iX5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hde8pGFA; arc=pass smtp.client-ip=209.85.221.42
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-472055b0efaso984641f8f.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Jul 2026 00:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782975947; cv=none;
        d=google.com; s=arc-20260327;
        b=KqikepshhbXI0rW+ypO4O40Ldbc/r7MvWd+8+ZuRghvoAHqWwerzS1FSWWDMUWdSDK
         fXFwLMp3Jai6OQ0Db/hPI0xVZEs7zRFxhWb3Bd6iWXfZcWBHu0mD8d0YXh7QFxGiIsFr
         e1RTmkMZW1omc+SZzs9+CoEjBCG/KIE2Va4kKdC94xQYqRyLXiwlvM/P4EkFjsUc38UU
         7MeEI0reOuzsh4e4aNY8amCqAeJdE/MZJizmwaeJVlp3nVdkX/vPl1E+oWGbUcZiyrh0
         /m8g8xNh6kPy6+8K4+tRijUrYpxhytS9+2GfqYxufDmQozaI9MOH6on7Fa7GBzeFluRc
         k9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        fh=36zysdPnbpMz0vzfwbf4CIeesRlnbszQ+rCgwPL7b38=;
        b=Xqf1ZpFWdbK4K7Z+6UhUVO2YhxKy8gwOOZvrozRxG7o9iklXKGtqJ0+0wPTbeo+0R+
         D/IRW1uHxXDwysB9NEVZ/baeWrFAmzxag6H+x1A4kug9CL5Tzh3Eq3CiQ4MJ7qZGEgpg
         8KwSQU3mx90TAnS99troEGawP83rAsXIOGIPkXMmi85eP+L2lw5ZaT/Z5PXbCxUj4u4f
         UceAG1xmMXPGYcp+5489y0qT8YexPy1yIZCOgP0xYQWlgoFu9ToJjt92jNV/Dof54XUx
         95aSTniKnlYFX9RlVdooBo6d5v5X6/pKRy2ovx8MF7Wy6jel8nBaVFQ6hQrkzISZbjsy
         obSg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782975947; x=1783580747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        b=Hde8pGFAWeDmF45A1gLD1fxbLvui97NjReaet6dSVTphzxJc8MEirOAoZitlEWfE3G
         tCbW59hM/3zetdZARn4+UHUD2hUv3ilScwPLrcVUcwlg7nsEqSYagyl+c+bDz8gwqKha
         zuYJQxqo+5OtPvV1RNy/fRmiEZ3+z4z+ItmjM/gPWVCrMemhnbJBJjwDRc9svcJPsU/v
         lhQQaWOWmumJqXhZJFJ+cCvAht4Cj65IfLSyvUMaEICdT7w54EIeH72VQYUlhIy8vi+d
         ks0dC158vs0ErFcQgs0zzLNKkiuL2LFEmEvo52zZXHQEKsVey65uKiUazJkqTJGB8mok
         loQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782975947; x=1783580747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        b=OHHl60vxWmTitKTYefGyqvroNSZBX0aKjC+ah/z2x7IqcrIceXEvHwTJVkHJGjBDLU
         GCoFwXsUaVpjJ7fQRVb3EwaaVbHjT4+ysrP7Jx1y+iYAU+cDr1bsr5TL+RWYhJcokmBO
         dOF3ieRflEWaDj6CUSQcKbJqpeQ4+Is+vk0sPPv7JZ1k/dVkc7HTJoTCEntuiS7vJjyg
         H5d5xi3cjGnRpKvF0JtYzu/VEOXM+eK8UwnjNpKrFmNlvNQnegO7VlWeUO6nNlesnEi4
         JFFr9SJX5LMi+OsQQSXR/U5eQNFBE65x7IqhLfibjLWW7hwQlTnRxwzfu0uX+ivvjpsv
         Mytw==
X-Forwarded-Encrypted: i=1; AHgh+Rq0gEuhzAEHba7VPSytXrLTJ7jE8LDbBmlY6dy8aQJKVc3klcjDL9z4u1QJhtjpiTSoWGDSnNZPAtt7E4yv@vger.kernel.org
X-Gm-Message-State: AOJu0YyTboBZYybXN1PHUKhYeFt2qa423sQqwM1g3fXpI2JmJArDw3Mr
	WVam8Buit0PyWRl/8q+otFAFoxK7vKYw9ZcV9AQUXMEeGrS/X2jl/P2/+xf5M4HT+C7YiuRCnSA
	yslYVutIIV/bfUwQDs+BqtKkFXJ5t5cL2jdhNJ9Cvsg==
X-Gm-Gg: AfdE7cnsexCzKts6SfW6zWtTb+RFZACLu4/isOOJKqrN44DchPQYzV+sq6Z+/nqIRDV
	bYDwnzvqy/eLN/rgTYcCEs9M/hlZE0LRtzTexOwD14S7vMOb2SBgvlVEjlREON3sAO71b/KGMs8
	Oufc2n39gmZUaHzNZIodOnE7QCImXJjEn/w6n2ijTtAiIaf/bRoCafuVg5S9feJcDhPAEJsvz6B
	PD1Dm13bNu8X/3gN0lUuCjIaqNIXEyG51TxkgVaMJSrjbV2yB5qip5x7Ca+FFn66S+Hgqry3JqD
	jwAWvnkRbBZMSdJNF+f+7nHz+TLNGbPJ9OCtjAdQ/lvFey7y40rN8W2T9W8ly3Gj2AlsVV+xz5p
	UxgaQ
X-Received: by 2002:a05:6000:27c9:20b0:460:70ff:fe14 with SMTP id
 ffacd0b85a97d-47759754d50mr5044463f8f.42.1782975947019; Thu, 02 Jul 2026
 00:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com> <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com> <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
 <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
In-Reply-To: <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 09:05:36 +0200
X-Gm-Features: AVVi8CdmQJ1si16nsSG-71wzJzip3TI8_lACH6aKFmJbH2cStZ_5YfsOBnxj31U
Message-ID: <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:quwenruo.btrfs@gmx.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmx.com];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1711-lists,linux-fscrypt=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,suse.com:dkim,suse.com:email,suse.com:from_mime,mail.gmail.com:mid,vger.kernel.org:from_smtp,dorminy.me:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 751BB6F4090

On Thu, 2 Jul 2026 at 08:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 16:18, Daniel Vacek =E5=86=99=E9=81=93:
> > On Thu, 2 Jul 2026 at 08:19, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/7/2 15:10, Daniel Vacek =E5=86=99=E9=81=93:
> >>> On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
> >>>> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> >>>>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> >>>>>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>>>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>>>>
> >>>>>>> Encrypted file extents now have the 'encryption' field set to an
> >>>>>>> encryption type.  Let's print it.
> >>>>>>>
> >>>>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>>>>>> ---
> >>>>>>>      check/main.c               | 1 -
> >>>>>>>      kernel-shared/print-tree.c | 2 ++
> >>>>>>>      2 files changed, 2 insertions(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/check/main.c b/check/main.c
> >>>>>>> index dedb4db4..a32247b3 100644
> >>>>>>> --- a/check/main.c
> >>>>>>> +++ b/check/main.c
> >>>>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs=
_root *root,
> >>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>>>                  if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLO=
C &&
> >>>>>>>                      (btrfs_file_extent_compression(eb, fi) ||
> >>>>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
> >>>>>>
> >>>>>> May I ask why preallocated file extent would have encryption value=
 set?
> >>>>>>
> >>>>>> My common sense says that encryption policy should only be set for
> >>>>>> regular file extents.
> >>>>>
> >>>>> There's nothing wrong with pre-allocating encrypted files. Unlike
> >>>>> compression, the exact size is known beforehand.
> >>>>
> >>>> IN that case, does it mean even a hole will have encryption value se=
t?
> >>>>
> >>>> This looks weird. Is there any special reason for setting encryption
> >>>> value for hole/preallocated range?
> >>>>
> >>>> Can't we only set the encryption value only for regular,
> >>>> non-preallocated extents?
> >>>
> >>> What's so weird about it? Since the inode is encrypted, related parts=
 are too.
> >>
> >> Inodes can have PREALLOC flags, but the file extents are not all
> >> preallocated.
> >>
> >> Inode can also have COMPRESS flag, but the file extents are not all
> >> compressed either.
> >>
> >> Inode flags are independent from file extent flags from the very begin=
ning.
> >
> > Encryption is not compression. I'm not sure it makes sense to compare
> > them this way.
> > We don't want to have some parts of a file encrypted and some plain.
> > A file is either fully encrypted or not at all.
>
> Then you're only cheating yourself.
>
> A simple tree dump can always show which range is hole and which is
> preallocated.

Yeah, that's true. I'm curious how other FSes handle this. Let me see.
Or do you know from the top of your head?

--nX

> > In that sense we are being a bit more strict than what you may be used =
to. See?
> >
> > --nX
> >
> >>>
> >>> --nX
> >>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>
> >>>>> Simillar to NOCOW, the encrypted data will be stored with the next =
write.
> >>>>>
> >>>>> --nX
> >>>>>
> >>>>>> Thanks,
> >>>>>> Qu
> >>>>>>
> >>>>>>>                       btrfs_file_extent_other_encoding(eb, fi)))
> >>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>>>                  if (compression && rec->nodatasum)
> >>>>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tre=
e.c
> >>>>>>> index 0afa3696..159f0825 100644
> >>>>>>> --- a/kernel-shared/print-tree.c
> >>>>>>> +++ b/kernel-shared/print-tree.c
> >>>>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct ext=
ent_buffer *eb,
> >>>>>>>          printf("\t\textent compression %hhu (%s)\n",
> >>>>>>>                          btrfs_file_extent_compression(eb, fi),
> >>>>>>>                          compress_str);
> >>>>>>> +     printf("\t\textent encryption %hhu\n",
> >>>>>>> +                     btrfs_file_extent_encryption(eb, fi));
> >>>>>>>      }
> >>>>>>>
> >>>>>>>      /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOC=
K") */
> >>>>>>
> >>>>>
> >>>>
> >>
> >
>
>

