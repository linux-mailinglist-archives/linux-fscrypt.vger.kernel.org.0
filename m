Return-Path: <linux-fscrypt+bounces-1703-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id +Ch/EPA5RWqK8woAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1703-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Jul 2026 18:01:52 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3446EF74F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Jul 2026 18:01:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=bUy2m3y2;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1703-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1703-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7403430668F3
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jul 2026 15:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B92A49550B;
	Wed,  1 Jul 2026 15:59:27 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B32A4949FB
	for <linux-fscrypt@vger.kernel.org>; Wed,  1 Jul 2026 15:59:25 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782921567; cv=pass; b=QeSrDUQZs2Oz+8G5BPwTbamyyQ68RhFGS8MGpTjVAj13QBEyGACyO7kxrxO/Fiph40d3dWzFTnJaCHOHR2wf6jaWu7qRGcv8y86FREtbD0i1itDKHB6ra5rl37DjkqvbLhStR3Lg47fPwwDOBkB7CqYhHQJDC8RXEPStDNzrXsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782921567; c=relaxed/simple;
	bh=3gfXHnjws9axdf6nCz5nV3PmyOopoA4D+Kf9VBGW8vE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3kDGTs8lbEXh+BaZzxn6AH3VTfVxW+jWgfIVPU/2fqmJbrfZ6oe+5RH7uHh78KrzBtjCQCFd5DP8yGpCiqAmM20gVVNcCh8JJw4VpbiwD/qs86ZUrCERqIkqxXy1qAJNMMXOtID4sHQT6a39gR4fn7SmjH6SmzS2/jS1gp8dX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bUy2m3y2; arc=pass smtp.client-ip=209.85.221.41
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45fd464d51fso411075f8f.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 08:59:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782921564; cv=none;
        d=google.com; s=arc-20260327;
        b=k1rRye7TWWaBtKLJVDkXfwcg8QcFc967f/WRIlgfVrBk/NX1X6Yl3muB4djc49Cw6D
         r4k+kbYfsavg/WiqW7dCfQbfyeJ5NMUrUZIboSI35Ix0mXrjlk+CNilAWCQ8QQG5LjBO
         IUdzGQrYUgVJHp3lx+wBI9OlRDVg5nSWW2spExEYiJOosLpFny40LRFjWWb2M7TQn7Fy
         0c3WXcHrvh01ytTCupBXiRlORZQdDUL2M4pBHYunZAgrFaI7wtsweyxwFPHUUInDgq4o
         B3/FQPJkKwfQDs9gi/MvLSLhGIYOvh8ciFHiubTZdB0cmgZoe0ra/QyJTNf2MfRDALf3
         oS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        fh=ffCbPlKlma+R9TH4t94Fcd9fwYx0tx0zcAY24LmbMzk=;
        b=C109S725KeTfVUveWOATaUxJcOIXEiby4z7fHPaZLfIyqlsSSXSpKACKM8hsd3s1Cb
         Q7bowKsCYsmfZNefDmWL9HxT82cKn2pr6NuKfTNXCpjkWHLgEeNBwL+VVE6q156fFAw+
         p6gF+CrHhskEBx5g4JLbae+E1qw0WeOP9GJiR0ZBwFE1gPBEbZJvcuS3r+oU/3x4J1N6
         OQm63gzNGIV+5xf8zmaMlp+Y/aKoS+f1MvmbnoJ1q/LMNzYhDqs0pvUrdK+AlKPkj1Yk
         VzWiUjFkBupnzfQsfwf84u+7j33kWvh5gkrKYI8XNafbs50+iU5UoNt9lmtVibrKh3pt
         o33A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782921564; x=1783526364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        b=bUy2m3y2WvL4oT828J2EuoqTp9n9kiFRbP9K/cFq1I6gbkfiXum1VWy2f7xFMdHTj1
         s20wT9fld+BOn9LjLkyth2WQpUrbIxsns9Vc+8/3LmQUvdKT1kGyS9RzfS2cLFwiPcYY
         qpNoThinH5iyCDmOyszgAK5evHRtlPX1eNO0IipQcNOIs0BNIxIwmbC04BKbFuVXDT9I
         czMkoZucp1uGwv4VqYkAUgjR8xKsd+9dS+x+wpBjRhjvK4nlZ/iulQAyxfh1twlfi0X2
         5po+MM/29DGzBlydm9YM4Ou2RILNcqVuCcRccFhpcjzqF4daqJcYwCNTfNxOoN0tCjvd
         ekAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782921564; x=1783526364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        b=F4ujqYV1Lcg4pV1xmt4o4/QDCpuk/1nmyT12V9L8yDahiW/IoaOm6urMZ3wPOnlX/h
         GZLgsSGM0CNe7RFHaKaHFBARwdo9SxXZJZ8efJXNcnbfS1i7PAcfzeAA3Gkp/nzOvotC
         ej9fDG5pJOYWx5Rl0X/WkjMyYEK5Cxp5WZguqjggJlVPzikMx0R5Mhgn5QGhCap4yAsg
         +jbx5RFTJf/8iBMrIfEgsy1uQ6xhBekckZBEaPi2Zyr+TwrHpnZOrsjVYhRj80Le1bMI
         NqdbtW61xLoMwv9KC/kpaVw9aT2tj26HVaY3fnUyMGYssXmTVbo8zbsxk2xJXXlEh/Zd
         +oAA==
X-Forwarded-Encrypted: i=1; AHgh+Rof9tBIrL3QjRgDYd+daeo3jNquTaB7QeLMSjRDlbyd+8QyIcfJYWagb2JpFJAR/qj3zefLPQ9St/CeWp3G@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+bR15Q/HaNTEReP4JperUIjqULQeTJOrqUsAhMuZIou7q2rkZ
	EFKHqqGMfVjg1bP6bzI6+T6a224wO6tNO5cJ0aZMkn7lnaQwQ1gTd5IK5bZyv2MVvFS2yd3exNr
	ZjlbxRmqeAjk+T+Z/6Fym7PcjSaU7teOi9DDWWk9r3g==
X-Gm-Gg: AfdE7cmgRO26KkpAhDh9PnysC5TshtWbu8qJ/UC2Cl+Wx/D8TAXi3YMOy2jTu7Hrfd2
	sFkHH9hWvDmKEGDuICEbAPCGfeQZAMuzIGLbSrbd8j8FrFCnLHqChezqs7jyTRpyeGFgtvKPUyc
	ogMTOYJguUjyGKSUlKTgdI0Q4CwzaiDtGWIo+CcT4dmSOleFJBg4yn3e7JL411UgzOxK7z3MlPm
	Lt4+9O+eKhnnpRPan7G8VX05vGBa7RrXodt4rDOWFZUdbB4MNgyHSvJTY6LEXnoI99EzDFz5XSR
	tRds0ciEgFiPM/37ytI4GSsT07IzV3H5fU/xR5rYXO4zRVyI4bqMALl6YDFYV335AG/mBA==
X-Received: by 2002:a05:6000:2f88:b0:466:6ed8:1e1b with SMTP id
 ffacd0b85a97d-4775798c679mr3930825f8f.21.1782921563954; Wed, 01 Jul 2026
 08:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
In-Reply-To: <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 1 Jul 2026 17:59:13 +0200
X-Gm-Features: AVVi8Cdo6n7AN_ocezQXRVlNNdLexrSHHboCqCKpvPgpBol1AWXQvwhVWZqS-Ns
Message-ID: <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
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
	TAGGED_FROM(0.00)[bounces-1703-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,dorminy.me:email,suse.com:dkim,suse.com:email,suse.com:from_mime,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EB3446EF74F

On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Encrypted file extents now have the 'encryption' field set to an
> > encryption type.  Let's print it.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c               | 1 -
> >   kernel-shared/print-tree.c | 2 ++
> >   2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index dedb4db4..a32247b3 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root =
*root,
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >                   (btrfs_file_extent_compression(eb, fi) ||
> > -                  btrfs_file_extent_encryption(eb, fi) ||
>
> May I ask why preallocated file extent would have encryption value set?
>
> My common sense says that encryption policy should only be set for
> regular file extents.

There's nothing wrong with pre-allocating encrypted files. Unlike
compression, the exact size is known beforehand.

Simillar to NOCOW, the encrypted data will be stored with the next write.

--nX

> Thanks,
> Qu
>
> >                    btrfs_file_extent_other_encoding(eb, fi)))
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (compression && rec->nodatasum)
> > diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> > index 0afa3696..159f0825 100644
> > --- a/kernel-shared/print-tree.c
> > +++ b/kernel-shared/print-tree.c
> > @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_bu=
ffer *eb,
> >       printf("\t\textent compression %hhu (%s)\n",
> >                       btrfs_file_extent_compression(eb, fi),
> >                       compress_str);
> > +     printf("\t\textent encryption %hhu\n",
> > +                     btrfs_file_extent_encryption(eb, fi));
> >   }
> >
> >   /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
>

