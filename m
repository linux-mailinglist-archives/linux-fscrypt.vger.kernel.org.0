Return-Path: <linux-fscrypt+bounces-1709-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tU5+GaIKRmq8IAsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1709-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:52:18 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B0BC6F3ECE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 08:52:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=aPDqirgh;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1709-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1709-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D0C333049DCB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 06:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585A338B14F;
	Thu,  2 Jul 2026 06:48:47 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F938D6A2
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 06:48:45 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782974927; cv=pass; b=rrw3IWucSc9vMHlaUhLSaZ2+Kb6jNizV3CPN6i920FBz1dk2X27pIEg+VnSS2tiLpfnu16mYYdcY7lfC1NKzv1FYQyHg1iFL0/s5K+HmDa9Q2UNmCbfHBBSqEaIWq6A7KFcxKFtQHzwgxifyzDQPoaSfKVfZvgVAA8lXIabLYUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782974927; c=relaxed/simple;
	bh=f38kDZ5kLL1N0e6g1n07vOzVkYS7WpEx21iV/YNxNl4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JEUkiaSHvOTYQD0n0WnkNfnSlWf3bfmtkY5NXTM4E2kZZ83vR0iDq9RYLIjNS0fP/zJbayotPyzIrycZua1y1FVN6+V/SSdBLlyVkbdk93h/8inuorHg+FzrPPMbyr/e+GXyq0xcTdF24ru563fMEc9tIhxbMubo1SKQk7/Ojio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aPDqirgh; arc=pass smtp.client-ip=209.85.128.52
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso8030465e9.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 23:48:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782974924; cv=none;
        d=google.com; s=arc-20260327;
        b=jr6gW6a+2cu1HVm9wGA82GfMRMDuTl7V1Moee8MrLUh7/djoD+HgJdzbm79z/MPRck
         m3OdQwHsQeVBc2SGEs7LpMIw2dk3P2R1L5OOW1onGf34DvcWjzNbjmIueiqdH6Yqi5n+
         /AM0Ya8rvpBwda/q+w5Kglny9s3ZZG6HVfRPZSYaozlYsfRegiQErfDFCyiMSB9UjQP/
         ftVLHesMefwe4nuGrjZy6qbXMOuHikEMOmfm4Qcnfpa7yVKOhoZDB3Hlw89yWuDbFltC
         szOGpeXBh6Hf3H9PefZBr4SDWGaa/v1ad+iAX0k0Umf700TccFUKxvKljyGxD15KJS7w
         1k8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R/gPE3LoyzHO2jW68dMLTjZShTbM2tCu0da4zTgp09s=;
        fh=jI3v2BPkCXSzGIwDjtV4djqKLSFUZsxOJG8gYg0mVzI=;
        b=BR8XYXmjuOd36cwcpaenI8NnLPBbvpRySYIx/Bi50zuaGIHT10xbc+x3MSum61GqLC
         DsMdG9nzr9j9dppyw7I7jwkqxYdevQeBLt45iuQs2piEZoK/2/Zzmmsyh2O8O7JVT+Jo
         n4OMoJzvb+amuxH/q8BDb18gi+wog2vrj8QkoMCvyCJN4Lh9poGV1nmDiKnCUv3LQwNz
         IB8MU8d0NVgsDkqoEMrWFF0iw8nvXGV/u4Ci0uCzgzPbqH/cPRipWcMkIq338l6wqjTG
         ZSbemBvZXAPh4SSz4qqjChKcGWb974YID0BdZRX4TVp+Y1P6f/9V8COXIPlydIhhjWDK
         D5zA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782974924; x=1783579724; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/gPE3LoyzHO2jW68dMLTjZShTbM2tCu0da4zTgp09s=;
        b=aPDqirgh8X++q3/GDtJ54AlLUmOavW1N2h6O9++RIJAz7m9av4n6Zd3LBmNd8K61E6
         t/EEbF+1ca3vll2pg5Mphrjdlf6thHRd7PBM7t+I2L6N5zcy9JvnmJDz0BPkMTZpHUK+
         8pCXfyH4lOGogVz8bZ3P260bTQ0TCm6avV7ypRw53w+hr5A293LVk4ZKaWTjDnbdv21r
         OBfEF2i+6J7zVCnAUZIRdg3Zn1bbBISWfX7YUj1OCam+DXtoixiPZb4MxdIdoHAkGOnV
         xsIkWWLTySBIyYDRf6fwx5vJ97ynPtX0a8XjpCDsCatJZ91lUFpvgQBfxM42P/oqsvZy
         hN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782974924; x=1783579724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R/gPE3LoyzHO2jW68dMLTjZShTbM2tCu0da4zTgp09s=;
        b=C4JhXS2YrTVT44HUHwyFUEKBbDtRFes+iVSB4Syedk/iBa6ZH+ZFlQemvofoSzwobT
         G1ZXQ1yIKrZQY+18MNJhjjSe2lc5hv5hXnWUoEADFQO54COJNHTHYcHSitLdrvuGaxwJ
         F1xGsvZLCWpRkri6zLt6lYDnL0tjB8xYWjnidWHWcMLZC+JWDK1HRSQSKVDboo8wCYb9
         GnruPzh2XeiltVA/5Ur0h/nPLvNh2F605Y5f+VSqkmdj0YgjjFgXFm4yMghJOQ6Zboq5
         5uT/+cuKoCbrLQvfX+opcAAh3qY1iRlGHhH67s+4vEPRusE+6M6/8FSD8a8eVNce+3+7
         rQiw==
X-Forwarded-Encrypted: i=1; AFNElJ+FQSN+UFKAmljpOjGLoYDD6ApcHVDH02LhYkCFVvKkOX1letCTCsVUdYqfdrU2KPJxIDHBsGH6125MdzJO@vger.kernel.org
X-Gm-Message-State: AOJu0YxUwrwBA2MK8iKK1681rYy0rQlQr2/TUPX1W60Yz8yPeAkqmt1e
	+7ifNOAh7N2mrjjMB0q8pUaaeun5kpFbtPZyj5Z/tpd6HD/GHJF2V6/281zxrN2qxvF22rlDvD1
	BvCHPPnabWcH3rFwU15HG0ccPm8HoqSDoLW104S1D+70tkfsYJqN2dDE=
X-Gm-Gg: AfdE7cmtGox7GDJt6fJk8OwoOiDRa3Ji7BOTZ/uEuvBjGODBb4RhjXIDgTPcE3Kvrmo
	/EN0Pot9bokqf2sh4PbIXeryYibfpFcqWajfZVgTyAzvoZ916d0pZAIKOWpmcB5gVzqQhewMW3h
	T+o0j7d/lfr6FzEJPR0Y/+h4j+sZC47JHFfuSGtQgkvJgCNDxc9Yrb5Mwd3GGdElqscL9hF1Sl4
	rMXe/qeBEi4P6UW/vXWQuOL1+5YroSKMIUpeYIitAoWriHpA6ul+K/SpK01P7iw46pEyNz+4hMK
	f08uSypKepUddtQ2ZKytqi2ePjUiNf1n26zcWy/ErioS811ebK9fr4u8sedqp2AL/XYYgA==
X-Received: by 2002:a05:600c:3f07:b0:492:4a56:690b with SMTP id
 5b1f17b1804b1-493c2b9e2a0mr64803355e9.35.1782974924158; Wed, 01 Jul 2026
 23:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com> <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
In-Reply-To: <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 08:48:32 +0200
X-Gm-Features: AVVi8CdKNA5zdrN9pSAjuD-ClXfgzCcZSwE_x499qOHMeLWU5SxYMtcKjSPiR8w
Message-ID: <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <wqu@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.com>, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmx.com,suse.com,vger.kernel.org,dorminy.me];
	TAGGED_FROM(0.00)[bounces-1709-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:wqu@suse.com,m:quwenruo.btrfs@gmx.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RWL_MAILSPIKE_POSSIBLE(0.00)[104.64.211.4:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dorminy.me:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid,vger.kernel.org:from_smtp,gmx.com:email,suse.com:dkim,suse.com:email,suse.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5B0BC6F3ECE

On Thu, 2 Jul 2026 at 08:19, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/2 15:10, Daniel Vacek =E5=86=99=E9=81=93:
> > On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> >>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> >>>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>>
> >>>>> Encrypted file extents now have the 'encryption' field set to an
> >>>>> encryption type.  Let's print it.
> >>>>>
> >>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>>>> ---
> >>>>>     check/main.c               | 1 -
> >>>>>     kernel-shared/print-tree.c | 2 ++
> >>>>>     2 files changed, 2 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/check/main.c b/check/main.c
> >>>>> index dedb4db4..a32247b3 100644
> >>>>> --- a/check/main.c
> >>>>> +++ b/check/main.c
> >>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_r=
oot *root,
> >>>>>                         rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>                 if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &=
&
> >>>>>                     (btrfs_file_extent_compression(eb, fi) ||
> >>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
> >>>>
> >>>> May I ask why preallocated file extent would have encryption value s=
et?
> >>>>
> >>>> My common sense says that encryption policy should only be set for
> >>>> regular file extents.
> >>>
> >>> There's nothing wrong with pre-allocating encrypted files. Unlike
> >>> compression, the exact size is known beforehand.
> >>
> >> IN that case, does it mean even a hole will have encryption value set?
> >>
> >> This looks weird. Is there any special reason for setting encryption
> >> value for hole/preallocated range?
> >>
> >> Can't we only set the encryption value only for regular,
> >> non-preallocated extents?
> >
> > What's so weird about it? Since the inode is encrypted, related parts a=
re too.
>
> Inodes can have PREALLOC flags, but the file extents are not all
> preallocated.
>
> Inode can also have COMPRESS flag, but the file extents are not all
> compressed either.
>
> Inode flags are independent from file extent flags from the very beginnin=
g.

Encryption is not compression. I'm not sure it makes sense to compare
them this way.
We don't want to have some parts of a file encrypted and some plain.
A file is either fully encrypted or not at all.
In that sense we are being a bit more strict than what you may be used to. =
See?

--nX

> >
> > --nX
> >
> >> Thanks,
> >> Qu
> >>
> >>>
> >>> Simillar to NOCOW, the encrypted data will be stored with the next wr=
ite.
> >>>
> >>> --nX
> >>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>                      btrfs_file_extent_other_encoding(eb, fi)))
> >>>>>                         rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>                 if (compression && rec->nodatasum)
> >>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.=
c
> >>>>> index 0afa3696..159f0825 100644
> >>>>> --- a/kernel-shared/print-tree.c
> >>>>> +++ b/kernel-shared/print-tree.c
> >>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct exten=
t_buffer *eb,
> >>>>>         printf("\t\textent compression %hhu (%s)\n",
> >>>>>                         btrfs_file_extent_compression(eb, fi),
> >>>>>                         compress_str);
> >>>>> +     printf("\t\textent encryption %hhu\n",
> >>>>> +                     btrfs_file_extent_encryption(eb, fi));
> >>>>>     }
> >>>>>
> >>>>>     /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK")=
 */
> >>>>
> >>>
> >>
>

