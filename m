Return-Path: <linux-fscrypt+bounces-1752-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vG6FLlvUTWoX+wEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1752-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 06:38:51 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 193347219DC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 08 Jul 2026 06:38:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=KH3XvfV3;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1752-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1752-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3AB303020A50
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2026 04:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF59F3AE19B;
	Wed,  8 Jul 2026 04:38:36 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2344538228A
	for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jul 2026 04:38:33 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783485516; cv=pass; b=riWPQgEKXoOKKDkKwMrOUUORgmX7uCG32QnoaRQACaDpNAwehRY+9/PVbGqbwl9HMJP9xowtN9ZjhBr/HziCm+1SXFAykwIadZf0EAOR4EBEgBd1x+tQKdAiYmZVGIKYGTQpvhnzSuy5whrHL1H0bSxl3i75PBjqYYGPMk3KJWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783485516; c=relaxed/simple;
	bh=4grEvqA8v78lMwC7X3s28Pu+9LYDK0ama6zo80Xg2rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZE7/MISLGTUIBRl0PuUnSwxexl2KBbWR3PEgiSQMsRDSUpDckv3CBs+F9oMwt5EVfuQCGJfnr8TnxWUqtj8k9OeTBjIxrY6QkPO/sStJgmqVMupxCbRcsb9twgxfO05QMa3PGCeDHCx5/Ff8Xnr/sidLL+fgoJzkB+jptdARiIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KH3XvfV3; arc=pass smtp.client-ip=209.85.221.49
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47de0093c42so188226f8f.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2026 21:38:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783485512; cv=none;
        d=google.com; s=arc-20260327;
        b=Ma58iwnK4L0l4mrHPIQhO0K9YlVb6dNvgqx+JhclJFt9J8zfV8OqO1s3+ogPYlB6Zw
         50B3f0lKkxHBJj6z61XjhRjVB4yWAcv9qJrPjU8U9CTKI/X2LyEnPsarb1dqoOG6iSXy
         JX/aQbJwTU1VNWe5N9YP1myvl9ja98VGlRX03jrkuBVeGzRcAZjrHb1XIZ+0re0ZyD6L
         H/gNlGBe6hAJjm1MYEe70yDEPe4ubFtboRXYHMymohLsb7TEZpROz3fFF0Zhbfo+6oKY
         8j01zfAnGje9XL3IT650N5mJD4n5KC6VRDUO8yQ0FYFJ35VJAbCm9bM6EhaSSKzjoJGE
         0sOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        fh=edOdrwUK3BZ38H+mXSIuDrypbk/IOM3vvxmYuDbmd5Y=;
        b=h4fR+jnRgyvkJMtImuG41J/ViX3onwvYStGWzWeQzUyGB9xFacaFtgdaOhhCgwIb0g
         VbQG40Qe+Rj5jn7+eFfi1KeH66Ti60mNHVgcxI773qAi47Tp7CBI9mVTXcfssi/HMOwu
         h9TdqvhiE0z6r6bnJPi6T6w12APrDqGDzT7KqHABdbRPDbkYnsZNkLf7b9/9QvEoWkfF
         MjicPtJhPmh6EqwxDC7v5hp7b5pK/8Dh2g7e27697OfdL4hoJkqhJnsroc+XlQpNKteF
         O1WwAI7OayRzgdCm7Cf3qCCrGR2P1x3TnLBkYcBzMrrSa5tj3tD5lmn2FmrXJ1OY9xmj
         slrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783485512; x=1784090312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        b=KH3XvfV3DiCE9z7QyzEx9gkKgrPwKtQIHf0sKau+pM3o+1+2BTESUmrzevxCALPq9A
         /r2fNshfA+TpsM8LBHGoKWUpaLXD+G6JLIo+NI16W0SzDk+sA2qzBQlehASD9KjLO+to
         tidQo/WoWXDNkbdeZmO4afK0tEM5Ex+9b+XMB+B5dLC/IL6AVK4xvv5WX6bDZAFB1ekj
         kRYlkX99R7WHtt+czsdNUY7ZE2pIF6ONhdYxJWV7ltr5i1MzFDR9YFTjBNHpcy6CK5Wt
         syRuye7NV+9mtC/WGLhb7iDBPgZ1UhJEpWe3j0tMDSkPhuMpdGBkiaWMtPE/rU1PrCtY
         woUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783485512; x=1784090312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        b=Dre22dG9GSsEmjxAOkovTC43hwSCnY1k0nthClvUjSWf0iH8XBlb/WDv+Aa7L8jhD8
         opeYtWCvRdFkUzR/goSi3fqONIAnobcJehWal46Wm3hYhDVS9k5pSYH6etIl3JbPXXzL
         2kXx76Iv1njDBGyi3H3mqdqNVuHfYp9C8tj2X3v9wQ7qR9jFDc6J+YM8QMKVGrr0hmhd
         Vh1Bqi33D+ym3yZXRiUkrDkCBReKe2gkxyoKJ8Rc0mlpeF8UPYkpVQh0nJ4Y5M48m/8+
         DkQM92Quwb9IIUNpG9s88iXvF9lerSumd3Hx3oJ3+IQrs8piMay0b2ko7DMsKOjdAJ2K
         0TvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCpCnK462gmO+3xSYvUgv7/FYi1fY6s8maDtcb4DPa3PbYhA7Ws14O90kV8hCy29ZA6B4dLBx+cuoJep/E@vger.kernel.org
X-Gm-Message-State: AOJu0YzNfhL8RSYqMQzxMPWcOyAs3N6frowpeV80LOvmVn4APztG7O3K
	UHwdbeTZ9g09xYPNwpogJArQQtHPT2lfShv7X1wB7CdiUGi1AYLT2xPT7iKsFZQhMFZBcnfw95j
	LnespfyULhsv0P2RYG2CJipE1iXZqRfTR1xS/WUGWeQ==
X-Gm-Gg: AfdE7ckpq2hJWdzAO1pLQa36yvtWNk+WLx879b3tosPplvuDSIhs4l9ae3LPXNI8S0r
	dG6UZny6DSxjO0hxwtHlU3XwweA+0aIkNLjgfMlLD/nzwcSL7XPwlV3Y32eNbB+UHEymH7Qb/e7
	Rx6Yx+gaJzqlKxLyRcUnjjQrP/O5ek+nvjzza5ZBcYx1SyJvrPduR2Rx57XSqm3/7CjcjC0n65/
	e4Nb/HFOs2+S1Dfyh5S35kiBL1TCQzEIf0pmOjypBgYaUZO9PeJupvZAJunn7ZMZuQCei/JZqCz
	BzmRHTuAtkOFWgFa4h7SAjANAZkQ+XBBmSX8Z3kx4KPD1/ow62ZpxJ5wgrdQPOBLocyl5g==
X-Received: by 2002:a05:6000:25c8:b0:47a:d4d6:a21c with SMTP id
 ffacd0b85a97d-47df073b08bmr579527f8f.2.1783485512489; Tue, 07 Jul 2026
 21:38:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com> <20260707142736.2330146-5-neelx@suse.com>
 <8ef7b7fa-b3ef-4a7b-b882-d851e9c9eb09@suse.com>
In-Reply-To: <8ef7b7fa-b3ef-4a7b-b882-d851e9c9eb09@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 8 Jul 2026 06:38:21 +0200
X-Gm-Features: AVVi8Ce9Wze29QgTRYSDCuR6ZKAi7umkxbAcP53q_tjq4n9DG7Ko-vw9QXIE-aA
Message-ID: <CAPjX3FfYxEepvr=PeZ_tcpn96+=-TNm7L7pCyH0DX5X29-1sfQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] btrfs-progs: print encryptin type field of file extents
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-1752-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:from_mime,suse.com:email,suse.com:dkim,vger.kernel.org:from_smtp,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 193347219DC

On Wed, 8 Jul 2026 at 00:40, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/7 23:57, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Encrypted file extents now have the 'encryption' field set to an
> > encryption type.  Let's print it.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c               | 1 -
> >   kernel-shared/print-tree.c | 7 +++++--
> >   2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 5e29e2c5..7f438302 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root =
*root,
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >                   (btrfs_file_extent_compression(eb, fi) ||
> > -                  btrfs_file_extent_encryption(eb, fi) ||
>
> I think this is a leaf-over change?

For now it is to match the kernel part to allow for wider testing in
the open. If we decide to change the kernel we can revert this later.

--nX

> Thanks,
> Qu
>
> >                    btrfs_file_extent_other_encoding(eb, fi)))
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (compression && rec->nodatasum)
> > diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> > index 0afa3696..2c0168b0 100644
> > --- a/kernel-shared/print-tree.c
> > +++ b/kernel-shared/print-tree.c
> > @@ -445,11 +445,12 @@ static void print_file_extent_item(struct extent_=
buffer *eb,
> >                       extent_type, file_extent_type_to_str(extent_type)=
);
> >
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> > -             printf("\t\tinline extent data size %u ram_bytes %llu com=
pression %hhu (%s)\n",
> > +             printf("\t\tinline extent data size %u ram_bytes %llu com=
pression %hhu (%s) encryption %hhu\n",
> >                               btrfs_file_extent_inline_item_len(eb, slo=
t),
> >                               btrfs_file_extent_ram_bytes(eb, fi),
> >                               btrfs_file_extent_compression(eb, fi),
> > -                             compress_str);
> > +                             compress_str,
> > +                             btrfs_file_extent_encryption(eb, fi));
> >               return;
> >       }
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> > @@ -471,6 +472,8 @@ static void print_file_extent_item(struct extent_bu=
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

