Return-Path: <linux-fscrypt+bounces-865-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 965A9BC2390
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Oct 2025 19:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6BD764EE651
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Oct 2025 17:11:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8FC2E8E11;
	Tue,  7 Oct 2025 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e34NBtAz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E178F2E8B8E;
	Tue,  7 Oct 2025 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759857099; cv=none; b=VGomJfdmREsFiq18R0rjhYLJlXEASH9EXTswllTyMoOAG9ncC9R8vzZaMGHMrzNYf+CySUGreWMFjGrswjNxtBZyiS0yj9rQzDCDVaq28vFzLlBs/la8GEPbWz17Ak2p9puW9q2CdYLiacjfR/fWUNxISchAUpKF/Fhr6FsqJ0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759857099; c=relaxed/simple;
	bh=qB0CeIsBa+dsxVohjzzl7Hm4/75YJ2F3WRhsBvhR0FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UX2hd/7ab9uEIPw7Ryk1eGTjJOSsPbRg9tXuCgj/z0pQynpmXKmTrbp+/LLuAyxBu6zwHYmO4xVTUzVEA0aOmGZd3SdHjy5CNZv2062BJc5IWh2yRqn2qy4nfzPWBZTmU3Xin7d8eloJW480D0g+XlEF7nkQqYSgQboFz8taj/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e34NBtAz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97EFC4CEF1;
	Tue,  7 Oct 2025 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759857098;
	bh=qB0CeIsBa+dsxVohjzzl7Hm4/75YJ2F3WRhsBvhR0FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e34NBtAzpJjCXgycFsm17YgoM4R1NKDmdI2Bu48/8tZDv5+6UqQuyS+6dEbsABeOD
	 Dx5m8qA0964rdOSroPyXlo0PlqAHOfQXHFaFqI/f93jDTdsdaNOPKQFLKo41qwo3kh
	 xxBmcPpUfeCPFsuhkSIVYuBN2/uD1FWMCJbJXwrRuRX0n/e7jodiaOxTlwDvYO79f4
	 Rc71M0yOJDyZ7L4Wafb/gKS9yJZ6IMo99pyfJiTUItq/QeCudlo9CH//lTGaFImMBm
	 548wtXvcRjOXK+JUXwTI80MSSU2fIZPcq9lRfmepkt2CQy9WKLKA15Co8bkjbmN0PN
	 p4JrQfZ2P5HCQ==
Date: Tue, 7 Oct 2025 17:11:36 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	David Laight <david.laight.linux@gmail.com>,
	akpm@linux-foundation.org, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, hch@lst.de, home7438072@gmail.com,
	idryomov@gmail.com, jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <20251007171136.GA2094443@google.com>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
 <20250926065556.14250-1-409411716@gms.tku.edu.tw>
 <CADUfDZruZWyrsjRCs_Y5gjsbfU7dz_ALGG61pQ8qCM7K2_DjmA@mail.gmail.com>
 <aNz/+xLDnc2mKsKo@wu-Pro-E500-G6-WS720T>
 <CADUfDZq4c3dRgWpevv3+29frvd6L8G9RRdoVFpFnyRsF3Eve1Q@mail.gmail.com>
 <20251005181803.0ba6aee4@pumpkin>
 <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
 <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>

On Tue, Oct 07, 2025 at 07:57:16AM -0700, Caleb Sander Mateos wrote:
> On Tue, Oct 7, 2025 at 1:28 AM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> >
> > On Sun, Oct 05, 2025 at 06:18:03PM +0100, David Laight wrote:
> > > On Wed, 1 Oct 2025 09:20:27 -0700
> > > Caleb Sander Mateos <csander@purestorage.com> wrote:
> > >
> > > > On Wed, Oct 1, 2025 at 3:18 AM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > > > >
> > > > > On Fri, Sep 26, 2025 at 04:33:12PM -0700, Caleb Sander Mateos wrote:
> > > > > > On Thu, Sep 25, 2025 at 11:59 PM Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > > > > > >
> > > > > > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > > > >
> > > > > > > Replace the use of strchr() in base64_decode() with precomputed reverse
> > > > > > > lookup tables for each variant. This avoids repeated string scans and
> > > > > > > improves performance. Use -1 in the tables to mark invalid characters.
> > > > > > >
> > > > > > > Decode:
> > > > > > >   64B   ~1530ns  ->  ~75ns    (~20.4x)
> > > > > > >   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> > > > > > >
> > > > > > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > > > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > > > > ---
> > > > > > >  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
> > > > > > >  1 file changed, 61 insertions(+), 5 deletions(-)
> > > > > > >
> > > > > > > diff --git a/lib/base64.c b/lib/base64.c
> > > > > > > index 1af557785..b20fdf168 100644
> > > > > > > --- a/lib/base64.c
> > > > > > > +++ b/lib/base64.c
> > > > > > > @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
> > > > > > >         [BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
> > > > > > >  };
> > > > > > >
> > > > > > > +static const s8 base64_rev_tables[][256] = {
> > > > > > > +       [BASE64_STD] = {
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> > > > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +       },
> > > > > > > +       [BASE64_URLSAFE] = {
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> > > > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> > > > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +       },
> > > > > > > +       [BASE64_IMAP] = {
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> > > > > > > +        52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> > > > > > > +        15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> > > > > > > +        41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +        -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> > > > > > > +       },
> > > > > >
> > > > > > Do we actually need 3 separate lookup tables? It looks like all 3
> > > > > > variants agree on the value of any characters they have in common. So
> > > > > > we could combine them into a single lookup table that would work for a
> > > > > > valid base64 string of any variant. The only downside I can see is
> > > > > > that base64 strings which are invalid in some variants might no longer
> > > > > > be rejected by base64_decode().
> > > > > >
> > > > >
> > > > > In addition to the approach David mentioned, maybe we can use a common
> > > > > lookup table for A–Z, a–z, and 0–9, and then handle the variant-specific
> > > > > symbols with a switch.
> > >
> > > It is certainly possible to generate the initialiser from a #define to
> > > avoid all the replicated source.
> > >
> > > > >
> > > > > For example:
> > > > >
> > > > > static const s8 base64_rev_common[256] = {
> > > > >     [0 ... 255] = -1,
> > > > >     ['A'] = 0, ['B'] = 1, /* ... */, ['Z'] = 25,
> > >
> > > If you assume ASCII (I doubt Linux runs on any EBCDIC systems) you
> > > can assume the characters are sequential and miss ['B'] = etc to
> > > reduce the the line lengths.
> > > (Even EBCDIC has A-I J-R S-Z and 0-9 as adjacent values)
> > >
> > > > >     ['a'] = 26, /* ... */, ['z'] = 51,
> > > > >     ['0'] = 52, /* ... */, ['9'] = 61,
> > > > > };
> > > > >
> > > > > static inline int base64_rev_lookup(u8 c, enum base64_variant variant) {
> > > > >     s8 v = base64_rev_common[c];
> > > > >     if (v != -1)
> > > > >         return v;
> > > > >
> > > > >     switch (variant) {
> > > > >     case BASE64_STD:
> > > > >         if (c == '+') return 62;
> > > > >         if (c == '/') return 63;
> > > > >         break;
> > > > >     case BASE64_IMAP:
> > > > >         if (c == '+') return 62;
> > > > >         if (c == ',') return 63;
> > > > >         break;
> > > > >     case BASE64_URLSAFE:
> > > > >         if (c == '-') return 62;
> > > > >         if (c == '_') return 63;
> > > > >         break;
> > > > >     }
> > > > >     return -1;
> > > > > }
> > > > >
> > > > > What do you think?
> > > >
> > > > That adds several branches in the hot loop, at least 2 of which are
> > > > unpredictable for valid base64 input of a given variant (v != -1 as
> > > > well as the first c check in the applicable switch case).
> > >
> > > I'd certainly pass in the character values for 62 and 63 so they are
> > > determined well outside the inner loop.
> > > Possibly even going as far as #define BASE64_STD ('+' << 8 | '/').
> > >
> > > > That seems like it would hurt performance, no?
> > > > I think having 3 separate tables
> > > > would be preferable to making the hot loop more branchy.
> > >
> > > Depends how common you think 62 and 63 are...
> > > I guess 63 comes from 0xff bytes - so might be quite common.
> > >
> > > One thing I think you've missed is that the decode converts 4 characters
> > > into 24 bits - which then need carefully writing into the output buffer.
> > > There is no need to check whether each character is valid.
> > > After:
> > >       val_24 = t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
> > > val_24 will be negative iff one of b[0..3] is invalid.
> > > So you only need to check every 4 input characters, not for every one.
> > > That does require separate tables.
> > > (Or have a decoder that always maps "+-" to 62 and "/,_" to 63.)
> > >
> > >       David
> > >
> >
> > Thanks for the feedback.
> > For the next revision, we’ll use a single lookup table that maps both +
> > and - to 62, and /, _, and , to 63.
> > Does this approach sound good to everyone?
> 
> Sounds fine to me. Perhaps worth pointing out that the decision to
> accept any base64 variant in the decoder would likely be permanent,
> since users may come to depend on it. But I don't see any issue with
> it as long as all the base64 variants agree on the values of their
> common symbols.

No thanks.  fs/crypto/ needs to have a correct Base64 decoder which
rejects invalid inputs, so that multiple filenames aren't accepted for
the same file.  If lib/ won't provide that, then please keep fs/crypto/
as-is.

- Eric

