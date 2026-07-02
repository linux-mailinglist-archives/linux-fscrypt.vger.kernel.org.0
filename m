Return-Path: <linux-fscrypt+bounces-1706-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8GkOHHX4RWriHAsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1706-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 07:34:45 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0688C6F393E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 07:34:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=QKNWFPDB;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1706-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1706-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 72E683004F12
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 05:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F229342CA7;
	Thu,  2 Jul 2026 05:34:44 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3973403F9
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 05:34:41 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782970484; cv=pass; b=aSjbM4GtXNxRve+C1lkfe0sJ416Cdz75KROks0k21/KT/raNNSs99OSc7oLDCsse796HvO817cstyyjChF3cEtPPkH7jG6YBBI8V46XPIgznXANOM7w8N2UFrm88uDqjlfoxOH8HOMOSPz8yvSssKbV54J2x+EbKx2rIsQXbNiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782970484; c=relaxed/simple;
	bh=ItnPtemJpDXlGtts7MlHqHToeHX5qB8k3Tzsfi3ttJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxIa8a5p2Kn9MRCXYhddmVKLiPd7zxTYyXy2UHatYNSRyJcr+ytITGZRAmZkHiyMCmtiWkgRcsmZR6T7Gj6sEJ8bbuM1caR/I+F8Ge0FLAsGgFf5iQo7Wcxz5jz1G59lHy0VSbAR7b54ArRrokDBp5tLirMPAyBVtUzqbehHYtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QKNWFPDB; arc=pass smtp.client-ip=209.85.221.45
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-470174001a0so1022339f8f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 22:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782970480; cv=none;
        d=google.com; s=arc-20260327;
        b=KjAvFeNemABhcUrB6dMtnYpLt5t4L1Be+3ClQeXrr4QOatqYqxaaBzbhylY54oYZFM
         J3rOQ1F00M1nm5xYBePxIcBWY5L9fkXaYN3QVVfjpiB0Za1PV93XVEyh6/myMlghJZ6b
         SSaO5bV75zs7dOyEUueeKOtfCvDcbU8c1LUKlvwoFwY49xZXkqJjaniUA5cW42FSAiOW
         +m5nanU9uw7JYzmo3ejMFCObYlWgf8duUrsAjZuKc54oGuKg9ZylHuYkLh1/foY6qQiU
         DaYSUmkL42aKChK6e9643JlGDv3YOguXkPkN1+0NpabCtYA7HwgkPEns3pUouR59/NAb
         zV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        fh=IPN1pYmtseyZQLO3N4SUSd4UiNBFL7zbUOZ1UfaHrIU=;
        b=WoL9LmazZWbRFq19NcLllGaUViRuBJmjMOTxfWSdKpVGOg+2PPbSwZjmZ7NnBp3/Lt
         bK5pSWGvAbPekn2uK8CP+DF9QI4Mnj0MtCF7MScGN37j++rCLOoyvO9BRKryKJPQREz7
         YOQdymOb63UaEf22zkUtnUThfFFM53jIKdw+LcyTydwdaEsAl/iYxlTgZmRqNxBdtJyo
         5M9CnzkZ69vC4mJnYsjYUFN8gT5oysnDd/5UZjJPyXTIZ6NR2IheHeE9e17rpD4TzI89
         XvLYjDdPEoxpmtzgvR/jsEZqnfGvOfFWARtTrTifcJPRs54aSVMvdy0lcQiyOsALxpTg
         UBJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782970480; x=1783575280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        b=QKNWFPDBSn1Cy5ieD1DhuE6LxCJmwLGvvxkGZCwnxJ3p+joOgef1o9Z9WjfD38qgEd
         lPxFyHl3M3uFXYcmeBJiLDlmek5vij7ORn721xRdORRp2Fu5r9RA5+SUHfECIxgmvcez
         DIA9TbKM9/kNkA1dtsTBnTCdtW/Sz5GFFlwcT348pF/MyEU0nmR97tGLGU9da5buNdyd
         nq9evbx6+2mlDrKsg9vCkvo8m/cUoTrjn+6fpNbiG2rvd6iggqU1dJzTyjG2KTG8hTgF
         OIKU26oK77EvDSXIuEmMBIESDal/wbtx4AIZaQ9mngifJqPo3dcWiN95pvbbaUFDjIH+
         2WMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782970480; x=1783575280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        b=JMOAfIX0mGwa9N9xc87nX+/Er0j1GGxNsX+X9/pQMQe3S+0n5yOaL71NNw9ZnXCKJ3
         TKkSvLSbEZlKOQG7YeZYRsH7Vi0nct61MUFvs6zJbEXlsaUryRYSVU1sFa31WLtz1H/d
         Y1N0v2b2sWMXYEssP4HrkYG0JUgIofplHiLNsMlc4llPSIZwXF8/wUQHbey301XghHnt
         M9F6QPrh162rTNwDtEDz7kWAuLh4zm6YLVkvpUqiiKP+vF6rIFw32QIm80RYVIV3A8Zx
         ipVw36HD160vfaKEwW1m40jgP6EFzVmPJRB1g4E2joDYl6Y+AiNSFnm+Z705K3yrRLqX
         r1+w==
X-Forwarded-Encrypted: i=1; AHgh+Rrh3b5bMv1kL0V/sz2ddlSdHsMz7jMCod0wcvmupBe0zmGi72SSvpkLuReQ+XANVG50uO4aKm9r497mH8/X@vger.kernel.org
X-Gm-Message-State: AOJu0YyfehSz8vnybo47r4yKDeyIyg7EU2mDr/S1mbL3JUdfNeCoFg/m
	2hwlXfDHE4Gao2Puj0S4TkBmAxKX6H7j6qdsclJ4NS+Im8mNMRQgSzYHKPjx8eseR/zLDxwmGuh
	kP2mb7fOy2iivQWX5KrbEkyXoDPWuUTQgdv42JnOVtCJ9VP1fg0dGQAk=
X-Gm-Gg: AfdE7cmlugD0rHiUj4vHh8l2ktnx138jhSWd3dnwj1q+W08m4WGyTmKZ9FQuciAjHiq
	hglNSwMv6qonDNvJGyw5OlFCAyfyt+WVdQvO+oMHCJwk991emauVe+Hv0uooC0+PKyTXHKVOHt+
	P6QnAzi+Kh0csbFMLzlHpxvvwE06fg6h2S2akeX8yJ4XYISnNeqDfiCsXFFfIGCNnLE6Bpc3nly
	mOABZQG7Y2fTfEnkc6djWjVV1r3Oprqt84L0vhXdvOn+t5WzzNm07XWUsgLuhJL/w+rZSqj+0wn
	umcU11mA8JIr0HHERs+UOZt9ndbbPf16qnkJtvNk9//yxraKvZhXGWdkVdQwG7YskovRIg==
X-Received: by 2002:a05:6000:468a:b0:475:f0f0:9ec9 with SMTP id
 ffacd0b85a97d-477b5a526f4mr3430690f8f.52.1782970480175; Wed, 01 Jul 2026
 22:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-2-neelx@suse.com>
 <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com> <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
 <2da4b215-165f-4bd6-a2da-07c9012586b7@gmx.com>
In-Reply-To: <2da4b215-165f-4bd6-a2da-07c9012586b7@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 07:34:28 +0200
X-Gm-Features: AVVi8CcG5zLelgQO4v3GpjE5Ypjk5fHhbLOCXs6uMnb_UaodAS4nCGHym-UkL70
Message-ID: <CAPjX3Fe_S2oJeEo_qpXv5VgWYq-DNe_Lj5JU0M7m1p-MN8jVdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:quwenruo.btrfs@gmx.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:josef@toxicpanda.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmx.com];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1706-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,toxicpanda.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0688C6F393E

On Thu, 2 Jul 2026 at 00:22, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 01:17, Daniel Vacek =E5=86=99=E9=81=93:
> > On Fri, 26 Jun 2026 at 01:41, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>> From: Josef Bacik <josef@toxicpanda.com>
> >>>
> >>> Fscrypt will use our entire inline extent range for symlinks, which
> >>> uncovered a bug in btrfs check where we set the maximum inline extent
> >>> size to
> >>>
> >>> min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> >>>
> >>> which isn't correct, we have always allowed sectorsize sized inline
> >>> extents, so fix check to use the correct maximum inline extent size.
> >>
> >> No, we only allow sector sized inline extent when it is compressed.
> >> The de-compressed size can be sector sized, but the compressed size
> >> still can not reach sector size.
> >>
> >> So this doesn't seems correct to me.
> >
> > With encryption it's the other way around. Even shorter data (symlink
> > path) is always padded to multiple of the cipher block size (16 bytes
> > with AES). Inlining a full sector size is perfectly valid. The dump
> > from my test looks like this:
> >
> > ~~~
> >      item 45 key (290 DIR_ITEM 3363472967) itemoff 11425 itemsize 62
> >          location key (300 INODE_ITEM 0) type SYMLINK
> >          transid 14 data_len 0 name_len 32
> >          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >
> >      item 58 key (290 DIR_INDEX 11) itemoff 10077 itemsize 62
> >          location key (300 INODE_ITEM 0) type SYMLINK
> >          transid 14 data_len 0 name_len 32
> >          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >
> >      item 86 key (300 INODE_ITEM 0) itemoff 7197 itemsize 160
> >          generation 14 transid 14 size 4096 nbytes 4096
> >          block group 0 mode 120777 links 1 uid 0 gid 0 rdev 0
> >          sequence 1829 flags 0x1000(ENCRYPT)
> >          atime 1782916271.8000000 (2026-07-01 16:31:11)
> >          ctime 1782916271.8000000 (2026-07-01 16:31:11)
> >          mtime 1782916271.8000000 (2026-07-01 16:31:11)
> >          otime 1782916271.8000000 (2026-07-01 16:31:11)
> >      item 87 key (300 INODE_REF 290) itemoff 7155 itemsize 42
> >          index 11 namelen 32 name:
> > \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >      item 88 key (300 FSCRYPT_INODE_CTX 0) itemoff 7115 itemsize 40
> >          value: 02010403000000005f0642cd89f66ce3ed930fe3ac518b7381bcd76=
00f7ae1f08195bda44461ed5d
> >      item 89 key (300 EXTENT_DATA 0) itemoff 2998 itemsize 4117
> >          generation 14 type 0 (inline)
> >          inline extent data size 4096 ram_bytes 4096 compression 0 (non=
e)
> > ~~~
> >
> > Perhaps this would better be folded into patch 7?
> >
> > Or do you rather mean special-casing for compression (with the limits
> > as you mentioned) and encryption (with full sector size allowed)?
>
> In that case, I'd prefer the limit to be only loosen for encryption.
>
> So we won't have unexpected non-encrypted inlined extents to reach the
> limit.
>
> BTW, it would be great if the progs dump-tree also prints encryption
> value for the inlined extent.

Makes sense. I'll drop this one and rework patch 7 then. Thanks.

--nX

> Thanks,
> Qu
>
> >
> > --nX
> >
> >>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>> ---
> >>>    check/main.c | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/check/main.c b/check/main.c
> >>> index 5e29e2c5..dedb4db4 100644
> >>> --- a/check/main.c
> >>> +++ b/check/main.c
> >>> @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >>>        u64 disk_bytenr =3D 0;
> >>>        u64 extent_offset =3D 0;
> >>>        u64 mask =3D gfs_info->sectorsize - 1;
> >>> -     u32 max_inline_size =3D min_t(u32, mask,
> >>> +     u32 max_inline_size =3D min_t(u32, gfs_info->sectorsize,
> >>>                                BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> >>>        u8 compression;
> >>>        int extent_type;
> >>
> >
>

