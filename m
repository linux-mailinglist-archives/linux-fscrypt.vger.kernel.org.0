Return-Path: <linux-fscrypt+bounces-1702-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MrgIOJc2RWri8goAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1702-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Jul 2026 17:47:35 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 500976EF5D5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Jul 2026 17:47:35 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=dkBMw1p6;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1702-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1702-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5CDE33009B12
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jul 2026 15:47:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6250C3DBD64;
	Wed,  1 Jul 2026 15:47:33 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36DE360ED8
	for <linux-fscrypt@vger.kernel.org>; Wed,  1 Jul 2026 15:47:31 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920853; cv=pass; b=BABmOJ21ce2+lAU/sA1wZ5r3nTV2wdMm1/3tl02+6YkSeHbLp4Trt3BX6MTFfLBB3bMToJ3EXozBLA2+pglK9sAULyXxRVY/w6zwAXqTZBfulvTZBopeuH1djg6q7Uliojpwtw5qxv6OURERwJQqRRudBxhb3qed+WaWjQkPayM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920853; c=relaxed/simple;
	bh=ZayiJGGDGLIh792t6ySSC3WVRP3ob4FSzMOllOM6HdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W53nBGzDHVHJ/c3mODl+fjJaZBvFWi3Zr/hOa0REg6Qu+ccYMNm6iRIxjy65UFLRRm+tWUme2PPd7aIA5ojPf+rqIMfVzFAbpz7Uhrl9/bhDWJBmAL3IH8tAGQVWdBJw6gc8WoCs+otjQJQnTxzVPs4HrlL0f7ZZEphMMotAc0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dkBMw1p6; arc=pass smtp.client-ip=209.85.221.53
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4728c12ba97so535445f8f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jul 2026 08:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782920850; cv=none;
        d=google.com; s=arc-20260327;
        b=bi+X3CHP0RpZ7Fo/pzrL1+NnlDhbH6gRrgSOO2AezPHy+bQNdM7bPX+RDF6lDrwuaA
         Fxa5bHW50oEwLKthLrZBq/zvN5Ou7GYGExJfUQfNLVbCmyBzfalPDFX9d9MOYWKJT9Ak
         bEHRLj8/b9ISzh80fIaiG5sZCQ+RN2h8HgFuls9iiyRKCbMCxWrW32LkBqP0DJnIQVpr
         QebIxwWLfKtbGurj2Bug+MphF3l/arITCfQfIyEO/uLeT6qM6Gry6nqx7zr3/XLy2tFI
         HyRBUJ1tALRJP+MpTaiGlORgvgbK+fXTBMMJhZMyWxQdkx/6dwC8XWmL7htOLGPucgUB
         ljJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        fh=Q2EKriTB15RqK+m04nBRx3jKbO7byg4FfLZNmP6RvRM=;
        b=XweRb4svPnMiD/Chp1d1VI7DXWEsqAhaFLRXysaWGvUc18lEyYT5OfTRG/R+5bMh15
         RHEJOACSFKiMcLmxk2EZVq3Eljcw0K1ugDM6unclYiJNggVoAJ5C6R2flDLJ3rOm+frO
         5K0Gwx7ZmWHwMj9lSYgqH5lsyhikFD9mAi1lW8tYW/TtIn5QQtMt3GuCHm8PLbWm6ASx
         yVwRMqq9KoIdz4u94m3ML/JxLRa+T93mYpGCWukos/W5EQ/kkNxIll6Cit2UFsB2I0cE
         1+N2LjNT0QlFP5hKmfpe9n05Ke9H4SEw1D7MYvVw2wnXUIGny1yRNfXI2Y1X+YAFaJL0
         ZPjg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782920850; x=1783525650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        b=dkBMw1p6skgcQ2ZRazuuTc+Aev5k4AOwCNpNvbieuGnlhD1TELmtNULGyBIWomzOQ2
         ipNl7JWgh6C3piifWFipqmjja4cHaTSgy9dmVmR61uIf1yxr4LBSuAcmLJ6tlOnbJ5t+
         W6azQrfReuyutyPiAU3LnLRFoPibCliF3iwXWvePEninlqjgaKtoqLc39eMbjMHNil4K
         mPSCooTZvzWDfSZsLPpopE54U1PbO1mUQLI8RELY9kG0MbJcOs91AeXH6wejXiZ4kWiu
         oXoweJvwiPMKKJlamQqpkcI06aY24cjW/dQIX8bBSEJrpbenzsb/pdQrXfVF8FFUl1iw
         0Iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920850; x=1783525650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3u/rPeftjMRMwQ9b5uvwxw83sWJlfLit/lDQul6EARM=;
        b=AnCnw7G2dd/KmSDg5d/ZWVq9/+89FMtg0RUIMPPJkkPK9Gw/202AApVoNoBmrMMSvM
         DHHucUVtodwXrkNQlCMKLa7dBfPsAlILdUB3600UR3QaXMrepGaryBObdI3AFPEfiUuo
         i5DTTrf08dHm0iMlXeteGGz30U3mCt2dJ56LVQ1Eq1JFStiKCivE8YBfnV5dh5Q+Iijk
         5Aze6sJe29lFdOeZx3wl56EaM4XEh4ghMXjpCiRZykAD/Z+boK6WRvLKsGWyuc6mTx4w
         eoIjjEjMi8ec9I+Ij/wTrmKD5VaL6E1lNQfyqzsk/V3GzFh0bEBthukMb9rcUkmGfeNa
         HfaQ==
X-Forwarded-Encrypted: i=1; AHgh+RqQaTvR2R5dquGAG3XFng9zD1ZEmXMrWT1k/wTQWnTlEJJO/PBvA7kyzB0H3gxNNbJMXzWP8H9Y9C9BtNQ2@vger.kernel.org
X-Gm-Message-State: AOJu0YzU5BIhYFQJzDo4ThTD/VqnqH+HQpQesY51EFBRy98P7Coeuyax
	0tL5Pbyj28kvdWkobOM6wrAx2bE3Vr0BTilwyYBqs1ayVLTA9EFFqNQ4IoFBiXOzok5NOezHfOk
	m+Gr1BAokbUmYPqK4P98WR9kSgD2kTL5ibSNY3Vc5ShGLEEwrKNxhi49YAw==
X-Gm-Gg: AfdE7cmLz61SsooytCSNkFLlxfcISQiswj7Q2IJg0z8JRmTk6pFEFyxDHKnwOopa3iJ
	g3Lg+N8n91r0qBe57g6G9D3yMN6YaClS93O+FGlAdp+4UQsDWlUY8UrdhLIRwZT2xZa+F/3HXjD
	3+njOBotJZgepIc+5RC97gD73YxI7rxnA7D/Qg/IJObmUHy0ONZ/PzDMbcT/2l1qcbLXk1LsMat
	Aj22mZUrJUttCalgQXi2xOqbjZDkw2sLkaefunRRpYA0ybX6783Uh0EZxmCc1m+o0AQbwxj8jx3
	Utt0a++0VEc6odBTlKx0CfywSuAPL7LEI86NeW9DG1DUqiT85bctSBgfk0C2qBdHNb5YOw==
X-Received: by 2002:a5d:5f82:0:b0:470:258b:b20a with SMTP id
 ffacd0b85a97d-477571cb896mr3856098f8f.10.1782920850225; Wed, 01 Jul 2026
 08:47:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-2-neelx@suse.com>
 <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
In-Reply-To: <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 1 Jul 2026 17:47:18 +0200
X-Gm-Features: AVVi8Cd_RK7AMtLvO_coxJa_GY90chqP4rpiM_IRla7w7nRmF5pUhXw0QeBOrFI
Message-ID: <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:josef@toxicpanda.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-1702-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:from_mime,vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 500976EF5D5

On Fri, 26 Jun 2026 at 01:41, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Fscrypt will use our entire inline extent range for symlinks, which
> > uncovered a bug in btrfs check where we set the maximum inline extent
> > size to
> >
> > min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> >
> > which isn't correct, we have always allowed sectorsize sized inline
> > extents, so fix check to use the correct maximum inline extent size.
>
> No, we only allow sector sized inline extent when it is compressed.
> The de-compressed size can be sector sized, but the compressed size
> still can not reach sector size.
>
> So this doesn't seems correct to me.

With encryption it's the other way around. Even shorter data (symlink
path) is always padded to multiple of the cipher block size (16 bytes
with AES). Inlining a full sector size is perfectly valid. The dump
from my test looks like this:

~~~
    item 45 key (290 DIR_ITEM 3363472967) itemoff 11425 itemsize 62
        location key (300 INODE_ITEM 0) type SYMLINK
        transid 14 data_len 0 name_len 32
        name: \243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+

    item 58 key (290 DIR_INDEX 11) itemoff 10077 itemsize 62
        location key (300 INODE_ITEM 0) type SYMLINK
        transid 14 data_len 0 name_len 32
        name: \243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+

    item 86 key (300 INODE_ITEM 0) itemoff 7197 itemsize 160
        generation 14 transid 14 size 4096 nbytes 4096
        block group 0 mode 120777 links 1 uid 0 gid 0 rdev 0
        sequence 1829 flags 0x1000(ENCRYPT)
        atime 1782916271.8000000 (2026-07-01 16:31:11)
        ctime 1782916271.8000000 (2026-07-01 16:31:11)
        mtime 1782916271.8000000 (2026-07-01 16:31:11)
        otime 1782916271.8000000 (2026-07-01 16:31:11)
    item 87 key (300 INODE_REF 290) itemoff 7155 itemsize 42
        index 11 namelen 32 name:
\243\365@;\312\321\240\367\377\234_{\245\vW\
\035\rS\222ryN\323\031g\243\nt3\321+
    item 88 key (300 FSCRYPT_INODE_CTX 0) itemoff 7115 itemsize 40
        value: 02010403000000005f0642cd89f66ce3ed930fe3ac518b7381bcd7600f7a=
e1f08195bda44461ed5d
    item 89 key (300 EXTENT_DATA 0) itemoff 2998 itemsize 4117
        generation 14 type 0 (inline)
        inline extent data size 4096 ram_bytes 4096 compression 0 (none)
~~~

Perhaps this would better be folded into patch 7?

Or do you rather mean special-casing for compression (with the limits
as you mentioned) and encryption (with full sector size allowed)?

--nX

> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 5e29e2c5..dedb4db4 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_root =
*root,
> >       u64 disk_bytenr =3D 0;
> >       u64 extent_offset =3D 0;
> >       u64 mask =3D gfs_info->sectorsize - 1;
> > -     u32 max_inline_size =3D min_t(u32, mask,
> > +     u32 max_inline_size =3D min_t(u32, gfs_info->sectorsize,
> >                               BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> >       u8 compression;
> >       int extent_type;
>

