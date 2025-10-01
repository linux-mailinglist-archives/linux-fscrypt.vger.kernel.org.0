Return-Path: <linux-fscrypt+bounces-857-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 385BABAFFAA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 01 Oct 2025 12:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 113217A2ABB
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Oct 2025 10:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B72A829AAEA;
	Wed,  1 Oct 2025 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="zcfH2aon"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B4F1E9905
	for <linux-fscrypt@vger.kernel.org>; Wed,  1 Oct 2025 10:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759313925; cv=none; b=D4xjHlTkI/PlCB0MRjFKBjY9yo9B2U9yW/2OJf+WYMxoap99gaurAZ3WKuwOHg62a82v7zM1K/5KsD0XlvtI0SPM72icsKaBQa/OW40WcygIt5QllowwWKetExb5xdizBcKQrPhDTbZ+l6csS/4L0Efq7rO0Kl0KB8fykYBWOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759313925; c=relaxed/simple;
	bh=2jldrv1cxNT7hzEfL36BPqU35TGryZTltmK0m7lz1ck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UVaixjNoL3vu0j3zrfJIKUYlFUz5tk5MvnmE8OzZh5We1OC0AT7bWjimN2GDrEoZVE5sxuMxN7ghjmpzRP7dQxZ6fL6wx5/b4dc0KjTiIOPu1X2gch9djL73rjm9V3qoM+XaYe11ALSAUQdZmNHyYdrVj7rYhr5C0SucO7W5SWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=zcfH2aon; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3306b83ebdaso6863438a91.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Oct 2025 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1759313921; x=1759918721; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oN9puFkb46cQNIS5IreI+mnmbbovgsA4IsgTPeMWaYs=;
        b=zcfH2aongeFYFzovTKgoSYdoB9MQcMIqBCKAIc9pSJM1X7mELsP4QWpu0MzubfzChS
         42dCvqgwg7A6eqE+MdSzBLWDYUZjjezXZKSeeAl4oN9yW5pXTHJ3m8sC3Gf3eHRwXVGK
         BkPD1CJ2can9SZAL6u3IZPDwh3m8W3Rcv1PjfrEV6of8XejwwZigRVDCJJdMm/FSJ9Ks
         XFKMoH2er0E9bWDsfBMUwNOfVRwJBMPVFFDZPE7uOoYBhBQ7zSGwtjFSTs6g4Ynf99TW
         jDa2wOGTK7AFkGm6QwiRAepn8H/WFCdhwSbICB9M5hO+xflPfQnsut9B5TkmZXJeyjiu
         v+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759313921; x=1759918721;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oN9puFkb46cQNIS5IreI+mnmbbovgsA4IsgTPeMWaYs=;
        b=XHraBnUDc5g4vBDrybKe9HdnX168P5z9iRb9XHG6wIdqhTouZg8PaiFQGArvuFvYae
         8o3FfNmyCMuScQZ2XjP27Xt36n4KufAmjeMXAuTFlIvAS+2DV3Ej6iT7B/j/JPnOF+Ay
         xI2rFZ9EvhX6N/E6wDO3OvZQF7dHq3GOjSIO60zHdVi1SSRo6KVZK7OjECsHkwfwsqrg
         2tcF3egblC71As1lO+nbTRqpgo62UF2Eyllc03RJXew4CtqpKg9XqwbPZdHMGi3xAD4d
         6Nx13od/jq4UwgrBHOPFcAmPWGes1vVVlKtESoifzT/qKm5RlPZ/A9KsyGGHjeG8f+nW
         2f+g==
X-Forwarded-Encrypted: i=1; AJvYcCX0qKTMNyxUK4oyDsmKOoGrPzJGse31YIjCuTOf8pK2O2WbkRr3J5BA7y4VsexFtvo/aTv9dKSxwzXJluSS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2iar8Hy0olro85lekNp1dt/19Vu70jKOAflcPZFmiMBspK0uP
	OueygZPt16D35hGO79S23uPynJf0QFtz9rVQDPtbnsY1w0H6nHTJfznl+Ii9cmja79A=
X-Gm-Gg: ASbGncsyucVMnFtFDg5eXgimWL6rf2gL2kCxlW0FUIOi9ZYo+NKNao8J3nDMqqrXqrh
	OwlBtY7pGEkma7O09F1E46dmIQYXSgLbH/g3YBMoKM1xmGVsALdYtl5063JR5owxTBxKpKYLkNJ
	hXEpd19b/DRbDgqdOVX3xZ3qPa6YMdRHQYXDIPqQ4LrfPnrZ4JYVBYjRDuStNVp8vd3+1zVLp8x
	A/5Yy8jth/sPf58eTiUCi8ccEZpGC084vvL3sol4/GfP/VzqlRltjzadZHqR0HhI1BksV6RAORb
	MgNcf4rrll6KCReFcx/k/+R0TyBzUww1xKc4aK/v/To+2fucqkja2YdvwEbY6poAalVZIDmb+C0
	jwxtehggrp2Yu7Afv5lxIvJdC/m/y/YqLJFlSsNjBDP6JbhApEJRQqN3FuENpuVcA52ui
X-Google-Smtp-Source: AGHT+IFs4kOlgU8X0QG7s3rpttQScpOUbtBqzYPxpTiDMADf9+c+J2mflBuEXTDwUDvWGGyPG/XFLw==
X-Received: by 2002:a17:90b:1652:b0:32a:e706:b7b6 with SMTP id 98e67ed59e1d1-339a6e75590mr2927307a91.11.1759313921134;
        Wed, 01 Oct 2025 03:18:41 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:6af7:94e4:3a78:e342])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6f20ebbsm1965811a91.24.2025.10.01.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 03:18:39 -0700 (PDT)
Date: Wed, 1 Oct 2025 18:18:35 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com,
	idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065556.14250-1-409411716@gms.tku.edu.tw>
 <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>

On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote:
> On Thu, Sep 25, 2025 at 11:59 PM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> >
> > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> >
> > Replace the use of strchr() in base64_decode() with precomputed reverse
> > lookup tables for each variant. This avoids repeated string scans and
> > improves performance. Use -1 in the tables to mark invalid characters.
> >
> > Decode:
> >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > ---
> >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 61 insertions(+), 5 deletions(-)
> >
> > diff --git a/lib/base64.c b/lib/base64.c
> > index 1af557785..b20fdf168 100644
> > --- a/lib/base64.c
> > +++ b/lib/base64.c
> > @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
> >         [BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
> >  };
> >
> > +static const s8 base64_rev_tables[][256] = {
> > +       [BASE64_STD] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> > +       [BASE64_URLSAFE] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> > +       [BASE64_IMAP] = {
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > +       },
> 
> Do we actually need 3 separate lookup tables? It looks like all 3
> variants agree on the value of any characters they have in common. So
> we could combine them into a single lookup table that would work for a
> valid base64 string of any variant. The only downside I can see is
> that base64 strings which are invalid in some variants might no longer
> be rejected by base64_decode().
>

In addition to the approach David mentioned, maybe we can use a common
lookup table for A–Z, a–z, and 0–9, and then handle the variant-specific
symbols with a switch.

For example:

static const s8 base64_rev_common[256] = {
    [0 ... 255] = -1,
    ['A'] = 0, ['B'] = 1, /* ... */, ['Z'] = 25,
    ['a'] = 26, /* ... */, ['z'] = 51,
    ['0'] = 52, /* ... */, ['9'] = 61,
};

static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
    s8 v = base64_rev_common[c];
    if (v != -1)
        return v;

    switch (variant) {
    case BASE64_STD:
        if (c == '+') return 62;
        if (c == '/') return 63;
        break;
    case BASE64_IMAP:
    	if (c == '+') return 62;
        if (c == ',') return 63;
        break;
    case BASE64_URLSAFE:
        if (c == '-') return 62;
        if (c == '_') return 63;
	break;
    }
    return -1;
}

What do you think?

Best regards,
Guan-Chun

> > +};
> > +
> >  /**
> >   * base64_encode() - Base64-encode some binary data
> >   * @src: the binary data to encode
> > @@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
> >         int bits = 0;
> >         int i;
> >         u8 *bp = dst;
> > -       const char *base64_table = base64_tables[variant];
> > +       s8 ch;
> >
> >         for (i = 0; i < srclen; i++) {
> > -               const char *p = strchr(base64_table, src[i]);
> > -
> >                 if (src[i] == '=') {
> >                         ac = (ac << 6);
> >                         bits += 6;
> > @@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
> >                                 bits -= 8;
> >                         continue;
> >                 }
> > -               if (p == NULL || src[i] == 0)
> > +               ch = base64_rev_tables[variant][(u8)src[i]];
> > +               if (ch == -1)
> 
> Checking for < 0 can save an additional comparison here.
> 
> Best,
> Caleb
> 
> >                         return -1;
> > -               ac = (ac << 6) | (p - base64_table);
> > +               ac = (ac << 6) | ch;
> >                 bits += 6;
> >                 if (bits >= 8) {
> >                         bits -= 8;
> > --
> > 2.34.1
> >
> >

