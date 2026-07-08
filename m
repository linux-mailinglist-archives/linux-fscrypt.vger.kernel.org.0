Return-Path: <linux-fscrypt+bounces-1754-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zs/QEJvZTWpp/AEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1754-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:01:15 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A46D3721AB3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 07:01:14 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=A3L2wzBp;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1754-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1754-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8512A301CD92
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2026 05:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F523B42E2;
	Wed,  8 Jul 2026 05:01:06 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DDA19E992
	for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jul 2026 05:01:03 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783486866; cv=pass; b=bWmC2kD8/9THnJxHZVNZ0dPmMMzuzmi0BAtxoYh5P/jpQP/lXgygUM8GVPhedzRDyspFmzXdbqdDy2CpyaO7uclvWjROZd0u1f94Bkdu5SQ65npWyg4Qb42sH3Ke0gEYAZ2KJ4oEF6N8Lt60atNO3UTDhEyR6EvHOovtEtd5H6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783486866; c=relaxed/simple;
	bh=Yq9AY+SNDRIVA05sdWC8oX8eKkAjkemflouZuU3HZjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxNsWbh8aYgmZq5DGVGjgqnHqYsg3VkC3FIs1DOaXcSoB0sjvLfSQKxTKc1/cgpB4TJpPHc7l8ZAl9kj5dLsT0yYDfjd0z7A4tLBtrjRNCoS6WjfZdF0wPwuvs8f1/XiSRgIMYKaYFuopc1IVpJHwEIoJ/lgk5Mpr1PX9tYSc/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A3L2wzBp; arc=pass smtp.client-ip=209.85.221.54
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47362928f65so194035f8f.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2026 22:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783486862; cv=none;
        d=google.com; s=arc-20260327;
        b=BonU144DcD84l6x3E2SYs2bETAHvZDyxgz6L0nhA0JXQKPvEO7XG8MWdrGyKV5JQMu
         d9G0TuVBaonO0FR/UMCIbIxKt5o/6yMiBZA82C3OxxvCfcucjyMr04XmNt86SyxfEPLC
         8CpSDCBVsTrD15N2ShBl6hlYvJUkKvr3eeND39s9Zyc69LBhPkr7Uk08ggUXePcVHAdb
         W1tz74fLGJkBiT01FbmW2k17c2duAOhHOucEXWpWyLI4kzz8QUO0UKmMcD92O34T54J/
         JUzGNWVCUPYzI+KQF2jc7fFf4vMSO3zcrVVqK7/VH/WfSiIOIAOlzIBQC00PxKQKW+SX
         mrQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        fh=BX2BcR+5LJXNXfleHrHGMihAKWNdAA7Xv0RQiEpR1VE=;
        b=hY276eOt8eOD0nKo7RZNg0K5Se2sLkjvQVE7lTig9vebG+fhFyYDP4gTqNxvq9iH+S
         b6XwkUUD0YOZ76Yxz1DUlwneveSOEuozpgQsBKsjwC7adGP1Lp0X7ImoywlJsiMqvVE7
         b6klALv1CcLPEZL5+8vruq2UL5tPs6NGII0ODpDChJA/O0asXIApmpJ1cK6Zc7PRQfZa
         peQWigIr9ctPcRLjF+2xWfK93CIf9YAs7rX5V9entgAHQ6meIesml1eFtrHUse5kcm4D
         C2nB+GpOVcGokcUcAn87ueeZtasiC6tN5CAbc9Cenenx9uBsvcA5zqnBN3MLitHS9FKN
         5jpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783486862; x=1784091662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        b=A3L2wzBpE5DB0z1DRCIdyzwO+XzrhX5GQLA/50q+407a9uw5Qz+meCKiEqj78T+JjS
         ggSGcgv/Ozwx2AUpCtcyOynMVaCxPUQua3sMOFB8ro63Gg3zvFLRLpI/M9Zgk+OWNj7U
         6A++Z9ABP52mvooUL+8kUAxiI1rZhvp3E1Jx7O8kPJG5ZPf0xvaxzqB4dtXIpVKNEFst
         bxuNFi3XT8WYZ6CEbEzUch0hrgvAJyLCuYXNiRed60g9FShEUFfSRgQNOMg36/vEjyRe
         Bsx/IXPDEuYfA1/kCTH99P/0AT18eVJ4FcMu/B8vsExe29Qg4mNp81Fm4yxGxyWRWFUC
         YeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783486862; x=1784091662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        b=qYFpKa+g+jmqr/OhKSWuDCqMhmosRWhiKc8ITdtnH234v8f8L3xxjUbwAl5oIb1gmq
         p++fXm+Js5TcMyP8Tmqty65shio8s3l3Bb5NJT0eBBuvfCZJgC1F0el43nOL2OKvKmVt
         BHuHxU1lSD04357rpuIbkTVCd8TUA3o+jJ2peMKtmHOZL1/uyZGnivBk+RkuH2a1u4Y0
         2YlfG6CVF7OguMhgkeZMncUskOvSv2eDlADLxVeLHzVhrll84IQNq3IiLld8P/uNyLDr
         Oa2hw4pxnG417yGHHSHpXtZlXnqIthiWlg67Xql3SaT5QsxuUs7pF6NyJwMUbUnZDA4I
         Qtcg==
X-Forwarded-Encrypted: i=1; AHgh+Rr9tV3+firw0tWJv9LpWMM6kHERBb79mPv0HurzXaqmzZimybhDFFYd4sFMfKK4gkrxJTdVY1s9BQ1dnvNa@vger.kernel.org
X-Gm-Message-State: AOJu0YwaWCN551JBLvUfrxXqx4J0RIWYfY1Otls+1x8LCWVz6A7flua7
	CsAC1CHtWnYf5Oxd7/L6u2xgglD/qlZAxHtD6ie9aa7+HNKD5lMEmgRsjKzqNSj+tOUAOKlm+bO
	boWZ+x6hhNAgdpUZO1SFsZaVjBnFyt5UPvMYZq344jA==
X-Gm-Gg: AfdE7claGkBjtzTeY7PXQwASxCrTD5hJu4C9mFms1QPwUuJz8ybtXvMs+muUmV4/FKr
	qXEYpsa4ljuH892iYvt+ZPVqtWJm0/CXwRSEP18YYW9++4yzxb/d6nl8ZfPoqOFBMtmJx2DbOrI
	4j9MVqCDPXS5QuWeXsyDdaPbY2YjMpAgl2qgpweamLHhPNiwTE3spxjwgIw0IwHx/IhKoTV6pzA
	okCPLivsInsXilwCslKhgMnoGaTuXkrbNoTC8XrZ26bpk7BlGFCqcAPfD1mL0qHE+QtE3RKQUOY
	ID4I/RBjrU1fyBUcpL89VPFQhzlQ4Li68mn3yp2ZaODbFSmFo3BeAtg1LaTHlbFoLWYyFg==
X-Received: by 2002:a5d:6f1a:0:b0:472:326c:a4a1 with SMTP id
 ffacd0b85a97d-47df07642f5mr642502f8f.22.1783486862187; Tue, 07 Jul 2026
 22:01:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com> <20260707142736.2330146-7-neelx@suse.com>
 <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
In-Reply-To: <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 8 Jul 2026 07:00:51 +0200
X-Gm-Features: AVVi8CfQEofeX37aIKCi9YTeycJWpcevUfQhSGfD3fO0im6r8VhzmfSih0bLW3Y
Message-ID: <CAPjX3FfsH7tG3jy3nezrr0371EWsYx1hJEkT+b8CQF2iaMrMoQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] btrfs-progs: check: update inline extent length checking
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-1754-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dorminy.me:email,suse.com:from_mime,suse.com:email,suse.com:dkim,vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A46D3721AB3

On Wed, 8 Jul 2026 at 00:43, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/7 23:57, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > As part of the encryption changes, encrypted inline file extents record
> > their actual data length in ram_bytes, like compressed inline file
> > extents, while the item's length records the actual size. As such,
> > encrypted inline extents must be treated like compressed ones for
> > inode length consistency checking.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c | 31 +++++++++++++++++--------------
> >   1 file changed, 17 insertions(+), 14 deletions(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 9447b01e..cadcfef0 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1720,9 +1720,7 @@ static int process_file_extent(struct btrfs_root =
*root,
> >       u64 disk_bytenr =3D 0;
> >       u64 extent_offset =3D 0;
> >       u64 mask =3D gfs_info->sectorsize - 1;
> > -     u32 max_inline_size =3D min_t(u32, mask,
> > -                             BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> > -     u8 compression;
> > +     u8 compression, encryption;
> >       int extent_type;
> >       int ret;
> >
> > @@ -1747,25 +1745,30 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >       fi =3D btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> >       extent_type =3D btrfs_file_extent_type(eb, fi);
> >       compression =3D btrfs_file_extent_compression(eb, fi);
> > +     encryption  =3D btrfs_file_extent_encryption(eb, fi);
> >
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> > -             num_bytes =3D btrfs_file_extent_ram_bytes(eb, fi);
> > -             if (num_bytes =3D=3D 0)
> > +             u32 max_inline_size =3D min_t(u32, mask,
> > +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_in=
fo));
> > +             u64 num_disk_bytes =3D btrfs_file_extent_inline_item_len(=
eb, slot);
> > +             u64 num_decoded_bytes =3D btrfs_file_extent_ram_bytes(eb,=
 fi);
> > +             if (num_decoded_bytes =3D=3D 0)
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> > -             if (compression) {
> > -                     if (btrfs_file_extent_inline_item_len(eb, slot) >
> > -                         max_inline_size ||
> > -                         num_bytes > gfs_info->sectorsize)
> > +             if (compression || encryption) {
> > +                     if (encryption)
> > +                             max_inline_size =3D min_t(u32, gfs_info->=
sectorsize,
> > +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_in=
fo));
>
> The change looks good to me now.
>
> However I'm just curious, is it possible to limit the encrypted data
> size to sectorsize-1?
>
> Or it is some fscrypt limit internal requiring a power-of-2 size or just
> lack of interface?

The encrypted data has the granularity of the cipher block size. With
AES, it's 16 bytes. Hence why.
Eventually the best we could do would be sectorsize-16. But then, if
the cipher changed in the future...

--nX

> Anyway I won't object this new change.
>
> Thanks,
> Qu
>
> > +                     if (num_disk_bytes > max_inline_size ||
> > +                         num_decoded_bytes > gfs_info->sectorsize)
> >                               rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LA=
RGE;
> >               } else {
> > -                     if (num_bytes > max_inline_size)
> > +                     if (num_decoded_bytes > max_inline_size)
> >                               rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LA=
RGE;
> > -                     if (btrfs_file_extent_inline_item_len(eb, slot) !=
=3D
> > -                         num_bytes)
> > +                     if (num_disk_bytes !=3D num_decoded_bytes)
> >                               rec->errors |=3D I_ERR_INLINE_RAM_BYTES_W=
RONG;
> >               }
> > -             rec->found_size +=3D num_bytes;
> > -             num_bytes =3D (num_bytes + mask) & ~mask;
> > +             rec->found_size +=3D num_decoded_bytes;
> > +             num_bytes =3D (num_decoded_bytes + mask) & ~mask;
> >       } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG ||
> >                  extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> >               num_bytes =3D btrfs_file_extent_num_bytes(eb, fi);
>

