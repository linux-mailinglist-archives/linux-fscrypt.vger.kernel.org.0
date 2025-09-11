Return-Path: <linux-fscrypt+bounces-821-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD7A4B53895
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 18:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 623F6AC0CA2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 16:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82932352FE9;
	Thu, 11 Sep 2025 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BubZYe3h"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35663126D3
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606563; cv=none; b=TJTm7E5cWVla2OWKXOAsiLCHZQavaja69H5TT61O/8aGBhb7O36j90KKsXqixCROQ3joZJH1dh/ZzpGSjpRjdMPEbHyqoXjW56Cpl3uoVtiw2Qdxw4OcCOFpY+6GNqrC6jBLynekzcuevt8u+RS0cTvcUhAVS9I6DYsqsWFlfjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606563; c=relaxed/simple;
	bh=br6EOEaEXU1W5/Rb/Lht5jWrh+9mdSaxvvkmi3rL+Gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qf0WkUDXIbd8kg9ntkDlto5BMC17C95nn8qYyOQlztAVzeXKdC0O+nL+7ku2nejGedH/EdhqPFiVH0IpqszvrwtX5Yhyos+WzOrY6uGBnsybokSYoa6vVEc1POzbIyfumOgGldsj51GMZpKQstmh1s6Sr+SG4ZjIMTI+fEXB7uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BubZYe3h; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7725d367d44so90843b3a.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757606561; x=1758211361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6obS77W4gL8mbr6C+eeuSSKKzH7RwZdvT4ZIG8wkffg=;
        b=BubZYe3hKelZ7gW5zAwsslrfefs8LcKZXEtM++XFeYYrWKyk2TN8F79rxKK++iHRrY
         iMbt8/apuklxainSeioD3ABaz3JjE+mLfcALfgfU+s4zVqQx1KssSrwZj++Zim1P7xGm
         NjHdLPiKFTlbcxQeWKnWfJ5IWBaNUBsHmf0xIEnV5ww/ywkWSjoBc2Aqa1WR5UQvJioS
         2JbviwHvVkmCTTf0SzfKBBp5aCvhdOUIvoHthay5GbB/GQ+XVAN/F3CqynEM2TMSzVhI
         7mBQ4qN151KMxxP52cNLlVK7BkmVXCRWGJv1aKyWOLdxDqyGvMM4WMxKTX0KhW6FsNJP
         znmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606561; x=1758211361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6obS77W4gL8mbr6C+eeuSSKKzH7RwZdvT4ZIG8wkffg=;
        b=rlOSjwpOHWubKbnQHH2XaeWN1xik23bZZ06emfUj+QOB7TQFAn7Q+poCNayl9/JMbq
         OlR1lx4vgFNJwulYn+kx6VJS2NztCA7JCX8jfcuEEjJYJMZXNls6ifHniH6SDFMFS7j5
         mBWC3MJUFF4ff7VO5ADHLmOwmqT9boLuFuAZXtV1HlPxlNF9FdkxQ7oixrSvV3lYyWWM
         k5WtlCG3osuwRE9XYGEgim86vEPaTHgeeOeXFvEza65FKZbEFLXINsmSJEyLP86BT9of
         /aQW/tCxI5JcJ/IgC/6xe/rPznB9/Z0pj58zgudaHnX70CagcfCvQ1V5/LRs8iT2OwQ2
         ndUw==
X-Forwarded-Encrypted: i=1; AJvYcCX2kpSqHfU2PsKf31jOCaB1Wtwlre1IXmuBOHPULwlR+vtAZhuLEfP6DjvbHbumoRQwv0/rMPaDrytNW9ne@vger.kernel.org
X-Gm-Message-State: AOJu0YxMoQ/I+4eOacIdEMDC65RUX4arsB3I28wJEEeX2eek+TvCyReX
	2HfsidtGXiKD0VWNJKMo6biaN4/gY7K2IXGy7Xn7egifi5aSBXTfI9ya1DcN3nl8Ke6NR7qaDwq
	+ThKBClWujtcxflvfIozkXPlxQCVEjAbwf56DEYDaJA==
X-Gm-Gg: ASbGnct39hIkUeNIMQN0rWJc2CUHSYKitJzwh8l4Jv6RM+GrbimaNWGEUQnDHhw97Q9
	Llr+0b/w0Z4kIXQKONztYq3+ijtfKOd5l5soen9TrVysIftkYcWQiKcDd4EJsWJkUWx/0ol30xQ
	r2bYD+7tcI8iQavRqUJ+T0KqyKsdA8vvClvtG2HyYbMGSMEzFdGceXyGyT3TKfC2Z7sqQk9RGdP
	bfeUVaprPCVcrDsHUqYHRbpw0/sZ0XSnH59gZaEg7o8O1cOyg==
X-Google-Smtp-Source: AGHT+IFBr1IxqXcIUO6bB0xT/+wQnm8xy0aPESUSNVEBROoDUbw28I831Lcf+8PW91sQeC1Tp7s6n5Wn1luV5rDxNOA=
X-Received: by 2002:a17:902:f708:b0:25c:8005:3f04 with SMTP id
 d9443c01a7336-25d217ec277mr163925ad.0.1757606559660; Thu, 11 Sep 2025
 09:02:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw> <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
In-Reply-To: <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Sep 2025 09:02:26 -0700
X-Gm-Features: Ac12FXzfe0LPetqhsRB28hxh2v9SigeWVoVMRD9W7aqYfRcyJIKVJDep7LH3j1c
Message-ID: <CADUfDZo43a2w64umSCeqJyHrsujh2jHFTQADC5kGuX+d27RnVw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better performance
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org, 
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com, 
	jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 8:50=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Sep 11, 2025 at 12:33=E2=80=AFAM Guan-Chun Wu <409411716@gms.tku.=
edu.tw> wrote:
> >
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > The base64 decoder previously relied on strchr() to locate each
> > character in the base64 table. In the worst case, this requires
> > scanning all 64 entries, and even with bitwise tricks or word-sized
> > comparisons, still needs up to 8 checks.
> >
> > Introduce a small helper function that maps input characters directly
> > to their position in the base64 table. This reduces the maximum number
> > of comparisons to 5, improving decoding efficiency while keeping the
> > logic straightforward.
> >
> > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > over 1000 runs, tested with KUnit):
> >
> > Decode:
> >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/lib/base64.c b/lib/base64.c
> > index b736a7a43..9416bded2 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -18,6 +18,21 @@
> >  static const char base64_table[65] =3D
> >         "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789=
+/";
>
> Does base64_table still need to be NUL-terminated?
>
> >
> > +static inline const char *find_chr(const char *base64_table, char ch)
>
> Don't see a need to pass in base64_table, the function could just
> access the global variable directly.

Never mind, I see the following patches pass in different base64_table valu=
es.

