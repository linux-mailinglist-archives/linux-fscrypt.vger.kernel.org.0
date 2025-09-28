Return-Path: <linux-fscrypt+bounces-851-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 115F5BA692A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 28 Sep 2025 08:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C15A33BE816
	for <lists+linux-fscrypt@lfdr.de>; Sun, 28 Sep 2025 06:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8EA829B77E;
	Sun, 28 Sep 2025 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9Fl7gB4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413DD1F3B96
	for <linux-fscrypt@vger.kernel.org>; Sun, 28 Sep 2025 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759041445; cv=none; b=lVurT0G/qDRo06sk9fXab0xVLRMrTjeq8+j4reV98kKGxQyawyY5w54Cf7/Kdz3RUjSO6WKpu0CPGaklKUeB7DZXUihshYqedUPX1OP8dubcT6C6qps/1AK4WatTA7WxixapzV8rW6oRA5CmrzPSwyKK42mDRNd1XP/JxYTu2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759041445; c=relaxed/simple;
	bh=VnTZ8yvEWXTdhFclZzhAdRzUA5UjrJMBqGbTF9AuniA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bb91XHmuU5mNbuSrbP2CEqEBdJhZ6JhK0LajZlV2X1W9kTN8mnkonQT5eMJOTu7yw/OfiRaWZ8O2EGnL8QeZ0jvNYjMX5FENPA4FsxmT/oKl3meE1UbXWGp9vuljC17OvCpsVc5zaCDAhiveHFeIrFiN0UvRvmkiUd1jn5/dBDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9Fl7gB4; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27d3540a43fso38989635ad.3
        for <linux-fscrypt@vger.kernel.org>; Sat, 27 Sep 2025 23:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759041442; x=1759646242; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ubpMuP7II5ikdJvb/5K0JndDDuxFjf1Jocs0VnGSPuA=;
        b=a9Fl7gB4cBdY6n6IkUVblSjwTa20MW01xKbFzYLYtfnwkTlzlnRy+IyhZ/xQEXkbEC
         VdlbJO5pBn8bdQoSIkOZmEUFhOR4IYd3PlnmWXRVRrxvD85B+W5qJrZHeiwYLm3xb1e5
         9cBEe2MOyT3Cd3ZGWJ/fDpO7g00C+yIZ/HLBI85GUXXhv0tIExCn6n4g68Am5DnU6fQD
         xxBSxYjo0U6XpXAwjcdUOQoAVrBWxHePNp3iEUwXAKUfD3Zedbb+bW4vg2L7G/6ZXiOO
         tUJnVigmwypJl5CeDZqOeaTQXCsrnCvn1NvA+aJawctJOcaC+Ig7cSxaYsRiw3l0iYKe
         9mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759041442; x=1759646242;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ubpMuP7II5ikdJvb/5K0JndDDuxFjf1Jocs0VnGSPuA=;
        b=BwWUIMmufTve29eAQKHSvrJ1b2b2VZN8moEdVwptjfsNkxIfb0+faU/yrqt0mZu18P
         4GLy/SQR+bRRmUZrzRqv+cyRFlkzPJooxkaj50VID5LwmtA5UuDZxi+gGysgTg2+UCdm
         fDrsYeThIs/s+GLvoCkbCf0paCJ9+oLlLRWzdKs400S2kUyxUJ4bz0/ya0oQ5nBp3bUT
         YhBSA+xfqWBedH6m488sPdBLiWhwYU+kpzRnm71TSWP3BD6nwymv30+nLNBeLuGTBMte
         lcGMdyBsUW17G3ucLf4yxpyU74lyi+JstKyusxV7w1moLiK5fT6VkY9okR/n7FaJR657
         Zkrg==
X-Forwarded-Encrypted: i=1; AJvYcCXu5nJiyD9QC/dwji6YLthPmeEPXprZR4bvB/GLKn86Oz18VfhDa5B1yGlX/NJQNxv/BHm8nN9eBtGupuWS@vger.kernel.org
X-Gm-Message-State: AOJu0YyqwocvOsJ85QOuiFtqPcvBFN4izivCpNcjX4ro6JsAckCNugOZ
	nBHLaAeoVhXhOMqaDCWyzbivnVf1up3qVbNM5n7FM812SbHvrpCWItON
X-Gm-Gg: ASbGncs8eTiIr3wIBz1cUsHtyJSgcZ9FsjJms8k2/kcVRCrasW5xVsJXVUMdMrziiIt
	G+v8J3WXoQFDI/3xuVvkC2P3ZvnzdfjRz2lVKrfyxymJ01nhvn5tjZQUNpyM8MfaHQRET/E1qWl
	4936N/id3vIciWqHy1//CP1aIS4oFTn7ArfpzlglGsHKXwfL3QwnaJlL7Z1ZPxwAuYuuAUbqgBk
	W9nYyf4wu+QblhVF2u0b7XCmAzQ3YTsQi5YCNP7/HMPxY8qM1s1Leh6bIHH3y3H6ARiOsRa1Ngt
	u65qd0fhTjZhN5ElnqS5XuquMZCx7fVcQm3MyXyBLeOoywG4ezGxCVMESDhWYNI8/XDw5RM+NGQ
	HzB4KEMGl7JczQxFzpszzc6/O7AHGhPuDQvtwjTNYaWap1R9c526R29e/U865JxrrWb62SbU=
X-Google-Smtp-Source: AGHT+IHkOtF5578eCGnpU9nMgKsLzoxz/q9Ij/omuAZkxTc208StOe4e409+y8TjhW4sjjzmHwt/2w==
X-Received: by 2002:a17:902:e54a:b0:270:b6d5:f001 with SMTP id d9443c01a7336-27ed4a0d542mr138016595ad.23.1759041442474;
        Sat, 27 Sep 2025 23:37:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cf9d3sm97700695ad.15.2025.09.27.23.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 23:37:22 -0700 (PDT)
Date: Sun, 28 Sep 2025 14:37:17 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
	axboe@kernel.dk, ceph-devel@vger.kernel.org, ebiggers@kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aNjXnYorbInXF6FM@visitorckw-System-Product-Name>
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

Ah, David also mentioned this earlier, but I forgot about it while
writing the code. Sorry for that. I'll rectify it.

Regards,
Kuan-Wei

> 
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

