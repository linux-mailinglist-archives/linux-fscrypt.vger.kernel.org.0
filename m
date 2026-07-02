Return-Path: <linux-fscrypt+bounces-1707-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id p4bSAtz5RWo0HQsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1707-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 07:40:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 982296F398B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 07:40:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=SmLVturZ;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1707-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1707-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CD03C3002309
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 05:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C611343888;
	Thu,  2 Jul 2026 05:40:26 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731F830C608
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 05:40:23 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782970826; cv=pass; b=XFF8gclY6CNJ3topNdZEAdsQ/i//uJcdSzBl9eVOommohnC4lTTLq5hvcsh3e6g2Tu/83DPiH3JO/tpXeosVqIGEejMF6Tisyu2MJjNEDXnHucG48xwvp3KGUi9nK4xHMfLMQVBPp6h8mVkjpaMPeph0tcVg5k8yqZyPGHACwI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782970826; c=relaxed/simple;
	bh=i2ojhQoVEcDFgHQgtSuWOz0d+zf2mBSXnkjH+DpM2q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8uH2SUGiTcumFiNW7NNsWx9dHaOZmvjtGd41GQXbn40mNaM9r5Y0BTAp49kVDpigMMt7RK55611HYUFNI4mV1VqvwZRQpFjN1vLvCHiG+tM27V5NFH3bi9S4++o3+zCu4RZfQB5Pv3WeE1o3WNcc3V/I3ObdKT7g+4BL48SPLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SmLVturZ; arc=pass smtp.client-ip=209.85.221.51
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47122683cf3so1019007f8f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 22:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782970822; cv=none;
        d=google.com; s=arc-20260327;
        b=bZGdh8dvzQU54m9USJH698MdTm13hqlX4k7xiiSK9jEx60u3CNs8kT2HZlxl6ndwsp
         PS46W5Fy97TA6tpgfytODT6KlBh+nQrzYjfUgGdMizPrwbtwusVlIPN0I6RgneqMjR0l
         jeo0LCcyEe0PxA9q51GAhXjn4vzli/IoUJiNBUMsXh5MH5WkPJb+3+m08mmcejyN3SL2
         CpBj8X5AT9wcDWlsBdLDZdIKkce/Np6q883By4JklCOAshwmjZaaCePCFtR1DrEM3kH2
         jzsIifSA76UJ2KZyToClkVJ+qWuoYC2cYi3uDngTigQ/5VhzmmKQQO8JlnctPQbIf0Ii
         B3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        fh=eKu+VnvuBjLmWgR7L8qixiHdlrJJ/LQkhklmvUGjZMo=;
        b=TPWKCS+d3Q/DfpVTqI2Svg5ha1GXAMhYwDDwo+8PUQkgAgECOWBznwfFVp/aDngLzp
         N5Lh81SKGHC3ppWkE9kVKhcNhRDru7JfB1bmiGv/a0QUjQYeqpQIg5ZC0Zzb/USjM/RR
         GfQIh4B8dRJIDRLTxY0rQrGFqTleVxpx2EABn9/5lJi2jE+yPeGcJNI9Phn4aM2FYixn
         6Qbw0hKqN7cun0rsSOzWn56Z6hxHwn0dP3mAOBd5YDtnnhICtQykYz00dlZaYYqOsb/y
         TRBIILoeeDj7Lzo1ITUol/AaRoHY90qEH2MxAPl7k0168h0hU+PmIpIHnLKYqRkaEbq0
         qRUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782970822; x=1783575622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        b=SmLVturZ6+BTQGwcifIB5XHuY7ufo8luvhiwdKc/Sry4RMjHLaS1436WPhmcVQuRxN
         8x6lKu5jBqbVpTMykhUEupJNMxk+igi03TcDWYDj065o/cj1C1Z6pdIHLVYwqQOq6u++
         MdwiKWThHPfhzG8qVEnmhmoc//hXe8h0nbvXZ37KrxS00A1ECkjPT7e5ueT/M+J7mnTC
         3HgWkpqXjciMF88FVhHg6CFKDN6OHaBnYx9Gm/C3H1dBR5ntlTV5kj1jHhXqYTyGCbkK
         SrhvCW94szjjmkKN35kNAIaE5VBuXLC5H4DQ/SbXfmxdUp8worSmBpS+PN5/mkeIOL1h
         Xzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782970822; x=1783575622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2YEzrB90Y1Du4fo3AHklyEGKwgWUetGfW0hMbewDp1I=;
        b=KcukcuG8EaMdoSeeDb7XYQxceD0aYFtxxSURhhfkwbSY6VdATTqyN+Zdxt6Xo+xMHi
         gzjibtyggtBlIUsPQbCkFflEyDT71Zz40KUvAuUn0k9/Wx41mVek0ZnY0bqsSPPRYFN8
         VsfnPnjRKdaHyD0hn72vieypwBPkyZ7mL720vCubCIkcZM7kJmEiy+ux1fdkLWRqXjMN
         srmDLHaHX1xUQ978OZBFxjV3WXpq/8TUucj8/3gBAYEUecz8NteG98YsdTtcVsRQS1TO
         oXNQkpqDsrlgEKntNMEavbdgdWgLssCTuAvei3A08tL4rHxy3N9p7vKBA0a2oNs1y7PH
         kRKQ==
X-Forwarded-Encrypted: i=1; AHgh+RqYqVUeg2YjxHZA7/olENKNxhyUhrsTYwToLquHulcrPzbi3BWTCmYvgMQB2kHNv61p1D8ANjiWmsM5su/g@vger.kernel.org
X-Gm-Message-State: AOJu0YzEOE8NuUWyXyQ4IMoQBLTfr1chTW439r81AX/pwCMVmUEfM+Ic
	KwOkwBYGryWe/8vL3CRa2fMNb07+yR1nw1e54mOlD3flP5wKEH00e4Wh3qxXFvHHZJU7wyDKOWU
	raMLr2PZ/c6TyRSpyjnFMunRFbDngITF4JcO0YRrrbA==
X-Gm-Gg: AfdE7cknkzi5AVdhJU3xyP6ePVjQyV5SzjupBydtBhigXjncxc7/ytUrTx75gmIoQ1W
	ko+154e40iUGwycOdT9U/zuEvhb3qNGoe6voW1m1Sg9w6yt4OVVsm8zYeTdeHeVCykD/WWs1/RB
	/8yAgXLTR6WD5K4pVJ0tOYq/sdQjqdDoSYKDFyL/a0wiygVDH+5RhzYq36iAGUA5cO1wvX3oGMQ
	nRpxI0SwkTqpzkiS+jxHeTi1jP9UxYSTL/VKv01LA2xyNu/ypX61SrgG4LaAL7Kn8tfSUGg+p+8
	Uu67t7LEoMfOO+dLy5Koh+9TtBCqrjp2SJ+5qXvuyvPwuiPRTNiNy0Lhj+i26ji/6cb9ww==
X-Received: by 2002:a05:6000:29d7:b0:476:5c84:e830 with SMTP id
 ffacd0b85a97d-47757e57f36mr5188843f8f.9.1782970821945; Wed, 01 Jul 2026
 22:40:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
In-Reply-To: <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 07:40:11 +0200
X-Gm-Features: AVVi8Ccbl2nIrhORZiJeUEZoHUN6evrMkvyqiKTwAG9k151BYKk05_HGbsTeivM
Message-ID: <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:quwenruo.btrfs@gmx.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmx.com];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1707-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,suse.com:dkim,suse.com:email,suse.com:from_mime,vger.kernel.org:from_smtp,mail.gmail.com:mid,gmx.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 982296F398B

On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> > On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>
> >>> Encrypted file extents now have the 'encryption' field set to an
> >>> encryption type.  Let's print it.
> >>>
> >>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>> ---
> >>>    check/main.c               | 1 -
> >>>    kernel-shared/print-tree.c | 2 ++
> >>>    2 files changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/check/main.c b/check/main.c
> >>> index dedb4db4..a32247b3 100644
> >>> --- a/check/main.c
> >>> +++ b/check/main.c
> >>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>                if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >>>                    (btrfs_file_extent_compression(eb, fi) ||
> >>> -                  btrfs_file_extent_encryption(eb, fi) ||
> >>
> >> May I ask why preallocated file extent would have encryption value set=
?
> >>
> >> My common sense says that encryption policy should only be set for
> >> regular file extents.
> >
> > There's nothing wrong with pre-allocating encrypted files. Unlike
> > compression, the exact size is known beforehand.
>
> IN that case, does it mean even a hole will have encryption value set?
>
> This looks weird. Is there any special reason for setting encryption
> value for hole/preallocated range?
>
> Can't we only set the encryption value only for regular,
> non-preallocated extents?

What's so weird about it? Since the inode is encrypted, related parts are t=
oo.

--nX

> Thanks,
> Qu
>
> >
> > Simillar to NOCOW, the encrypted data will be stored with the next writ=
e.
> >
> > --nX
> >
> >> Thanks,
> >> Qu
> >>
> >>>                     btrfs_file_extent_other_encoding(eb, fi)))
> >>>                        rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>                if (compression && rec->nodatasum)
> >>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> >>> index 0afa3696..159f0825 100644
> >>> --- a/kernel-shared/print-tree.c
> >>> +++ b/kernel-shared/print-tree.c
> >>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_=
buffer *eb,
> >>>        printf("\t\textent compression %hhu (%s)\n",
> >>>                        btrfs_file_extent_compression(eb, fi),
> >>>                        compress_str);
> >>> +     printf("\t\textent encryption %hhu\n",
> >>> +                     btrfs_file_extent_encryption(eb, fi));
> >>>    }
> >>>
> >>>    /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
> >>
> >
>

