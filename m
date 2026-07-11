Return-Path: <linux-fscrypt+bounces-1756-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1hMBDXvCUmpfTQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1756-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2026 00:23:55 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 754327430C2
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2026 00:23:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1756-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1756-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 097C8300DE03
	for <lists+linux-fscrypt@lfdr.de>; Sat, 11 Jul 2026 22:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277412D0617;
	Sat, 11 Jul 2026 22:23:52 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8020022083
	for <linux-fscrypt@vger.kernel.org>; Sat, 11 Jul 2026 22:23:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783808632; cv=none; b=GkaKl4cXqAIB4XrQ40pf+MCXAVQT/02EofWNQkrpQYgogOBfxkYELGcMze30IDJsC2SomZ2YnasVjDls22jY57Yaw5oHKskJ+UQEZybMJyJtsBlktLRmPi5Ok2StPCMw88O/FmI+48wtMRDfUNHRtYZsTV9+BVSGhEITL1yc8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783808632; c=relaxed/simple;
	bh=tes96vTe7hlnidlQ0gKOpy4qDww/ODfIT1aShvTrEqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nC7xo/ZUCS7fhQ4V7x36oNDkF26rrPIR8le3MKRK7UXRd79uDEkqz0aqHcCVH4V4PY36wMQzef+UNEagr0tY/XBRo72MrCAtkgZutj92ydn+3ZEWLbjor4zceq16npKMv+sZeY3TEKlu5hMnlblQiU10Q+ieSeIcbcsQ6oKe4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.44
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7eb3865ea6fso1535847a34.2
        for <linux-fscrypt@vger.kernel.org>; Sat, 11 Jul 2026 15:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783808629; x=1784413429;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVpr5T21CCx1Zl2kG6RORQEOUOP3r3jC95g556ounXU=;
        b=Bwvf6FJ19p7OBrffmSktLqV7xng68b+7JVOb9jNSFuqi/9MEjKa2YEYDgaBiZcSQhm
         XMFAgs2wvS4qRcGeul8WfWIjS/629oJBDsEf9zlSXpnP89wbfSMeSa0PCWV5WyxAhgiV
         zykOcbobwJ5/vEJKOLuxItuoPPprYf7Bn2Pbmlup8TvyyB+3jSH0rDc8yJS1TlKVR0wA
         9LAfl3aEXDwm25kD+qol5KYXuJunnQY4Igs5gKy1kerwN0Zc2D0gjjX/YiqgxoCyX48y
         BviOe1JWzj/quJnPQG4tEXyiOOwMMt9DZpEJAJYm5In+1FnJTzdiypJP0mSQgkNbouEM
         Lr7g==
X-Forwarded-Encrypted: i=1; AFNElJ8/h+5l1Hm04K+HzsNGX1Zw/NjFreLJafojNgRbQHNx7NIwwcHxy16/kY5rCfjfwslDD4H+1xO7nfZguTEj@vger.kernel.org
X-Gm-Message-State: AOJu0YwhYj4vgGbuGiYRnv1KqcHfH6T6lEMDJBASmEt+kVcBj/WJRSo3
	mYDU1vdSfNZeGW2lj9e+Tdj3jC2qOlRT1HpjwrVjnZ59DXJucLxpGckVx9Rraw==
X-Gm-Gg: AfdE7cnWyTwF6x3XX85xLJqiQkbG03YMbO2MlEyyIn0C+zp4GqrkoYDLE0lpdUu3W2D
	ueecyF1pHFRbjjNEHQoqlVB3XYJV/bzsmDLUjSrUw59my2zzb1DBW30DYtHELjuU4eqKZZ5jbHh
	66VGJQyhqqD7PMthN5UwWJrRdtd0oi08sSvAr++1U++BT1Be33tzE/+vQDwrdYgllWn9P1AhUSB
	tMZHyYv9hrD8qa4taXSUFQrCkVAJvkfz8kFTRZb9y4ueAL0pdI1TuOiBRQzn9ShDaKxv88+kXMr
	JTHq5UhS/DdLkp5lq4cbxmuIV+CPX37iDg4RTxfFHDQgwLTO2XDdmd4m2hx+8+1mYU/c3TsXMaw
	WCsw50fv2zC+xZuH9BYLDHrZoQE3P/oadMSJZgRu2rsTsbMg1H0aba0vMo3edl1QJOsBz7oRtpf
	XBrcvMaRR6NvpcBX+IaVxuecFp0PJ866ilKAcAg1K1O67NxYCV7wEMlNG05DxKrEb54xOttOpKz
	rAYLD2bDJi6Sd4VPyiB4OEgOXbZM/GnXDRRFOWJINFUqJ19EgMbHkd3gpWKHTk=
X-Received: by 2002:a05:6830:3e05:b0:7e9:dbc1:4cab with SMTP id 46e09a7af769-7ec097c2880mr2775652a34.21.1783808629342;
        Sat, 11 Jul 2026 15:23:49 -0700 (PDT)
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com. [209.85.210.43])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcb2630casm10109599a34.18.2026.07.11.15.23.48
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2026 15:23:49 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso1615319a34.3
        for <linux-fscrypt@vger.kernel.org>; Sat, 11 Jul 2026 15:23:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/A7lcXAED1d5bCpgcVdYDEQnxqMEb7Nrivpeq8X15IUgTyFkvguBDE9RAU6oI7NlHMTfarr7TFowIYRgwA@vger.kernel.org
X-Received: by 2002:a05:6830:6814:b0:7eb:cc5f:a6df with SMTP id
 46e09a7af769-7ec097c7090mr2928517a34.18.1783808628786; Sat, 11 Jul 2026
 15:23:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com>
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sat, 11 Jul 2026 18:23:12 -0400
X-Gmail-Original-Message-ID: <CAEg-Je8ZqV8Jm64kNPBc80xKrBb2KB4EFobKR3yFUL9moZdN8w@mail.gmail.com>
X-Gm-Features: AVVi8CfR3PeMaJTeWSlo9zUp2JvungwA_UpiA5kgfOaZbQhIb6w8K5_rdloldzc
Message-ID: <CAEg-Je8ZqV8Jm64kNPBc80xKrBb2KB4EFobKR3yFUL9moZdN8w@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] btrfs-progs: fscrypt updates
To: Daniel Vacek <neelx@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1756-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[gompa.dev];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:neelx@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[neal@gompa.dev,linux-fscrypt@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neal@gompa.dev,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp,mail.gmail.com:mid,gompa.dev:from_mime,gompa.dev:email,suse.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 754327430C2

On Tue, Jul 7, 2026 at 11:00=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> This series is a rebase of an older set of fscrypt related changes from
> Sweet Tea Dorminy and Josef Bacik found here:
> https://github.com/josefbacik/btrfs-progs/tree/fscrypt
>
> It passed all my tests. Hopefully nothing blows. Enjoy testing.
>
> v3:
>  * dropped first patch and improved inline extent length checking
>  * correctly squashed the context key definitions into "btrfs-progs: add
>    inode encryption contexts"
>  * inline extents also show the encryption field now in tree dump
>
> v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@sus=
e.com/
>  * works with v7 of the kernel fscrypt series
>  * the on-disk format changed and parts of the series had to be reworked
>    - particularly the encryption context is now stored as dedicated item
>      and not glued onto extent data item
>  * also parses the ENCRYPT inode item flag
>
> Daniel Vacek (1):
>   btrfs-progs: recognize ENCRYPT inode item flag
>
> Sweet Tea Dorminy (6):
>   btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs-progs: start tracking extent encryption context info
>   btrfs-progs: add inode encryption contexts
>   btrfs-progs: print encryptin type field of file extents
>   btrfs-progs: handle fscrypt context items
>   btrfs-progs: check: update inline extent length checking
>
>  check/main.c                    | 34 ++++++++++++++++++---------------
>  kernel-shared/ctree.h           |  1 +
>  kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
>  kernel-shared/tree-checker.c    | 17 ++++++++++-------
>  kernel-shared/uapi/btrfs.h      |  1 +
>  kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
>  libbtrfsutil/btrfs.h            |  1 +
>  7 files changed, 69 insertions(+), 24 deletions(-)
>

These look reasonable to me too.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

