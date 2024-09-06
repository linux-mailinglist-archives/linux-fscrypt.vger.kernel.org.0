Return-Path: <linux-fscrypt+bounces-373-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3393C96ED33
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Sep 2024 10:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 524511C20940
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Sep 2024 08:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31302143890;
	Fri,  6 Sep 2024 08:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KWanihuj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653A53C463;
	Fri,  6 Sep 2024 08:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725610207; cv=none; b=ulxEd4hbHkUztzLF1iuRwzcCVXl9jarkPT7w4YbmQNsBjsvIYPzlNUwwpY2CGfdDb5BlZyMFrlQbMYtIeIHC5RGTUFMen2w4uOjgisnJRxsX/524TpkkA98Y+dbKlRLK/BXh1HgvJYjvb1rKlhkpIi6y1vzuKNYjaBSu6QFglUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725610207; c=relaxed/simple;
	bh=fALnnW/t3FQjLfdItOiN0DEm/o7DFeIZxzrYJbReizQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qbBRDdMu0ZrZS/sLf5tZMZFEnEstCBdECXcWKlI+rbIACnJY5Iq2RnRfO5ZO4TeyaRKiYNpQM8lyQsHaJsun8vrFZww24N1kWpToViEdtjVj1lk88zUDbWqQHJ5ba044FvaAAvFlt1i+qWZJOqgBwYn+w//BSablY2rJ/GxSeYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KWanihuj; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2f43de7ad5eso22411151fa.1;
        Fri, 06 Sep 2024 01:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725610203; x=1726215003; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kOHgAzDaCTRrbMzFYdadFS9BXVOGpad+ua9oTd11b8=;
        b=KWanihuj0/HXJP4qv4T3pkttwrN/80z+m8O1Fuu7+IugPri+FAja+f2Kv9cgOtytwn
         be2Dd622c4JytFvHqtJL3V+RainWukhDwgAjX5VhZ+uQFc1PArKI3grySbqISAtAA3ar
         J/ya8gvHB+yD+nNEgL22X5noF+sXBuDIH465PQ2r6xiVOLabh5oT7C+WVjVxDlIkgBko
         NHmbE6nC4m1k8Gkf/8wHCcy4Sil/ojbIWH0/ku0b4cS12zDiLcLc3Ww+y7F3UKy7ecMv
         ZjmcOh4hFn621LnBr5XWp3LMz5fgTrE8rw/VXGA79wt/6cfM91PG+hTdePF+XlH3LEmR
         wehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725610203; x=1726215003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kOHgAzDaCTRrbMzFYdadFS9BXVOGpad+ua9oTd11b8=;
        b=vkZJosYh/FmtwCjYmDDuCYsrPV5b+ctMLOaEUQcoclIX69vgJvkgYoYeluPHYX3iF3
         oO4uPjomhSL/AjuFutxGM3pNpS+d96Hus58zi31nZvlIxD8VTie9Ol1w4iNve/p75+OS
         d+KRcNnEww2PmLCCTaWIztfIVV+tecBzEgsRJ72/bxSthSHKODrzdSgOdjHLtXBRnw+4
         bfq7MZM1AlJVmL3tloa7kRjF8kDVZbAiDGmoSFxYxYwFGe1l8XFymoe1zbda/e06IYQV
         T5DDYWGm9W/7rdtlBKWTnhhOL2ru1nvL30YuUQs7aw1Yh6XDnrB1pkbvupt5O4+0CCps
         WdVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1SM5mMY69zy2jIVz4y+DMorPNiEfJHMSrK0+Vo0RgXfbVhBmC2J4afnEy4G4z7WkyXFYo659ZG7BMQqa5@vger.kernel.org
X-Gm-Message-State: AOJu0YxRI3ylFeKhB7wdfJMb4x636Vmk/ETA586h9g6jyuVFJto3iccH
	Vk1bTsx6cdBnlPLX7dmhs2ZoAOskJ2dvvcNkMMRhMZl446xvYSuuHbaoGzrw2v3oeOqvIIUdh30
	IHNOKpxjP3ePP1XAPBHRyYhMzXzo=
X-Google-Smtp-Source: AGHT+IFgxxD0WGGTJCeWfeHDAV2xeVEHqofFkr82p9R4VpExPKYnTNofpTQZGW9RlU1/YhbGedjnzUulVvcRXkusoxQ=
X-Received: by 2002:a2e:711:0:b0:2f6:2858:a0b4 with SMTP id
 38308e7fff4ca-2f751ee78d9mr8211071fa.19.1725610202526; Fri, 06 Sep 2024
 01:10:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240905122020.872466-1-ubizjak@gmail.com> <20240905122020.872466-7-ubizjak@gmail.com>
 <20240905230219.GB1512@sol.localdomain>
In-Reply-To: <20240905230219.GB1512@sol.localdomain>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Fri, 6 Sep 2024 10:09:50 +0200
Message-ID: <CAFULd4YrEHpmdDUvp7syG6rBV5LO=C8rutORS-PJoUqEYU8-Mg@mail.gmail.com>
Subject: Re: [PATCH 06/18] fscrypt: Include <linux/prandom.h> instead of <linux/random.h>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 6, 2024 at 1:02=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Thu, Sep 05, 2024 at 02:17:14PM +0200, Uros Bizjak wrote:
> > Usage of pseudo-random functions requires inclusion of
> > <linux/prandom.h> header instead of <linux/random.h>.
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
> > Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> > Cc. linux-fscrypt@vger.kernel.org
> > ---
> >  fs/crypto/keyring.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> > index 6681a71625f0..e2c10b3b960b 100644
> > --- a/fs/crypto/keyring.c
> > +++ b/fs/crypto/keyring.c
> > @@ -21,7 +21,7 @@
> >  #include <asm/unaligned.h>
> >  #include <crypto/skcipher.h>
> >  #include <linux/key-type.h>
> > -#include <linux/random.h>
> > +#include <linux/prandom.h>
> >  #include <linux/seq_file.h>
> >
>
> 1. linux-fscrypt wasn't actually Cc'ed on this patch, due to the typo of
>    "Cc." instead of "Cc:".

Uh, thanks for noticing.

> 2. Currently <linux/random.h> includes <linux/prandom.h>, so the issue de=
scribed
>    in the commit message does not exist.  I assume this in changing in a =
later
>    patch that was not sent to me.  The commit message should be rephrased=
 to
>    clarify that this change is needed because of header refactoring, as
>    otherwise it sounds like a bug fix.

Yes, the goal of the patch series is to allow inclusion of
<linux/percpu.h> in linux/prandom.h. The major roadblock to achieve
this is the inclusion of <linux/prandom.h> in linux/random.h, since
this creates circular dependency which doesn't allow the inclusion of
<linux/percpu.h>. Please note that this legacy include is removed in
patch 17. I will mention this in the 0000 commit.

I will also mention header refactoring in individual commits.

OTOH, I think that while particular maintainers are CC'd only on their
individual patches, it is better to send the whole series to all
mentioned mailing lists. Will do that in v2.

> 3. The proposed change does not make sense, because fs/crypto/keyring.c d=
oes not
>    use any "pseudo-random functions".  It does use get_random_once(), whi=
ch is
>    defined in <linux/once.h>.  Currently <linux/random.h> includes
>    <linux/prandom.h> which includes <linux/once.h>.  If the inclusion of
>    prandom.h by random.h is going away, then perhaps random.h should incl=
ude
>    once.h directly so that get_random_once() continues to work?  If not, =
then
>    this file should include once.h.  Either way it should not include pra=
ndom.h.

Due to the tricky nature of the whole series I tried to make
individual patches as mechanical as possible, IOW, change the
inclusion of <linux/random.h> to <linux/prandom.h>.

Looking at fs/crypto/keyring.c, it should still include
<linux/random.h> but should also include <linux/once.h>. The latter
was just accidentally included via <linux/random.h>/<linux/prandom.h>
path which is going away.

Will fix in v2.

Thanks,
Uros.

