Return-Path: <linux-fscrypt+bounces-829-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09F55B53C07
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 21:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73ABF3B36E4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 19:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3456E25A2C3;
	Thu, 11 Sep 2025 19:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fvrkqwEJ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F2E258EFC
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 19:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757617254; cv=none; b=mg8JuwyVEcZ/PV+cFHY+QEV4fQZKk+zg9fIoscZG0BkBN3YZQiaF7GXVVwHpcaOXPzaUs/E9KDny+LwmFTJ2YhlB2dIyuZ9jrxm4eN8v2vL+evdEduU1rOCz7Yx2jNEN+zeO1G9Vs9BotoMobCMpv/5qNdAL89aIcMvPYgRGivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757617254; c=relaxed/simple;
	bh=CMQbWvL35NGiKpRsKtPmgoLpczTG57AawYwSUnRe08I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EV6wFo9/5968/XWls7XkT3DKIBXTHD5d+LpSkDwy81GHIB4qwFQaX838XbKmtcjpw7IZBg1lQ36e9vGnMzDJCE3vCLvNcfTCKNx+DsGc+Rger3n3Ct+S1WJv9gkP5/SpmEgBNUAXMrX5GkFEyrrB1gBMc/TD5bp7/nvOnBHBedU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fvrkqwEJ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7722f2f2aa4so1339830b3a.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757617252; x=1758222052; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tF1OTr2rtCxy3jTEKLVALatHVlDvvfc6+FzIrMIIxc4=;
        b=fvrkqwEJEBXaGtXnPKVpZjXRogDl2sRl5XFL/z3EhlUYNsWS/iUenkeQxK2O18JYQN
         kuTbtQg34JDgnEfLYFnzoWP1J9E1TItNMbOYdv2CpgD1GFCN3SQ0V2XUtEbBsi5tQGBe
         OHEW0bbfhvW4Q6Gt3mhSxRsmhO4qqhFYKhP+Fxyf434GuIUu6o139SLi8HBEacqTdY8R
         UusgJ4dDuMyZVFQ7WwQ0BDu5ARo+KzYEoI9YZALidF5qutfa3KddZtPMT7E+jwTBK4qe
         YpnANLsU0QaChQIEbb1qVIiBE3I2jTMjJ8Zg3OAIlW0EbXIBxSMVnf/lh7H2sQGyNVkg
         PESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757617252; x=1758222052;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tF1OTr2rtCxy3jTEKLVALatHVlDvvfc6+FzIrMIIxc4=;
        b=UbxiNZ6OgkovU+zWAlI9i/nANlTTFDtZiHbqKzVji8vVP8Pe/0GwjGBkqEEHyCOlkM
         FBVBNHyP/RyuF2bmwiDt8fZMc8zaw/r0jpRLdnXPVjfVL9k/xv3A/2JvpR+kEcroH7Co
         RH4NAZHkjrX+hU/yNBSrPJ/9fd1fPJ+fsBg0vfEICc9AkQPmppaWft2WAIIAEsSCX5Z4
         /wjJDyys1hlClMrTm/L1e0cwLYb7fHEoi9Ldi/g1yUI4vPFNs4pE0+HfIUhnJGUCiF5o
         XHLe3paC/lk29BD/woBRrRiFQ4Y/ZcqgDxFZFy2fIGHpdMpSFPSSST+BaOy6OmhzvuLn
         LGhA==
X-Forwarded-Encrypted: i=1; AJvYcCXvjm4ELzVm9di0r+h3uXNKIjRjutPYmQwfhSbzZGxhlQ76EFYWeKoooPxVjA51tSapiwqk2zf9meWb15Ue@vger.kernel.org
X-Gm-Message-State: AOJu0YyxTuSs11zlw+EQAltfn6RPDw1KGC6OrHZyxlsayYrIk6CH2Bup
	Yd15vlsQ2j7GiyIcOVmkjSpZvIJPMj8Ith2UGHcCsXHiDxdtFp3pUyHi
X-Gm-Gg: ASbGncv88xFJv8SLwTLZC5p3YYGW8azN205x4clLlo3pK1jm7Q8WwBdCkxdUjLZLW8Z
	Ss998v5zN64GSgE6Wecb/uWGZviYhXAbuwbY/1sJ9vVpckUCdWcSGTS3Xilv0FTBOjWB8wc0uIL
	ztmfEcA6inln9mh5Nj8c85UwGTwbWaxzIiOERzPayNxqcAlp5z0pFMEbuLlsgnpvEAYnzCHggBq
	ZtHgOvwgQKOxrusYQ1R2uc6Bitzvc0L/4ZVe/UEPB+HvLeB7Dvt5PEukKB0D9jFsxlxwGIgzr/x
	KEqdHckI67JRdGf9xIj4HUjKNCrIU86bpIHzqb2Gn9R05DVUJZGvRUCkQoMBV7aqntg5vdVOn44
	ArD2ggdEGGhC57Hut3RwK7Q6lR1ik6lJAslYVQ3Iv+Q2yiCV8GxmBS1e8DQ4pf38DDQWzg1AFdt
	FRD74Oog==
X-Google-Smtp-Source: AGHT+IFKgGjLknGkp8jc1chBYIIHFKqurKXfUj4cl8o1arPPk6MKDJNmBOPLMnF+vJ6NN+q1YLvRog==
X-Received: by 2002:a05:6a00:2307:b0:772:4b05:78c1 with SMTP id d2e1a72fcca58-77612079eeamr536333b3a.3.1757617251633;
        Thu, 11 Sep 2025 12:00:51 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607b340ffsm2810127b3a.76.2025.09.11.12.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 12:00:51 -0700 (PDT)
Date: Fri, 12 Sep 2025 03:00:47 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
	axboe@kernel.dk, ceph-devel@vger.kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <aMMcX8jEoBjBUeyj@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
 <20250911181418.GB1376@sol>
 <aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>
 <20250911184935.GE1376@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911184935.GE1376@sol>

On Thu, Sep 11, 2025 at 11:49:35AM -0700, Eric Biggers wrote:
> On Fri, Sep 12, 2025 at 02:44:41AM +0800, Kuan-Wei Chiu wrote:
> > Hi Eric,
> > 
> > On Thu, Sep 11, 2025 at 11:14:18AM -0700, Eric Biggers wrote:
> > > On Thu, Sep 11, 2025 at 03:32:04PM +0800, Guan-Chun Wu wrote:
> > > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > 
> > > > The base64 decoder previously relied on strchr() to locate each
> > > > character in the base64 table. In the worst case, this requires
> > > > scanning all 64 entries, and even with bitwise tricks or word-sized
> > > > comparisons, still needs up to 8 checks.
> > > > 
> > > > Introduce a small helper function that maps input characters directly
> > > > to their position in the base64 table. This reduces the maximum number
> > > > of comparisons to 5, improving decoding efficiency while keeping the
> > > > logic straightforward.
> > > > 
> > > > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > > > over 1000 runs, tested with KUnit):
> > > > 
> > > > Decode:
> > > >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> > > >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> > > > 
> > > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > > ---
> > > >  lib/base64.c | 17 ++++++++++++++++-
> > > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/lib/base64.c b/lib/base64.c
> > > > index b736a7a43..9416bded2 100644
> > > > --- a/lib/base64.c
> > > > +++ b/lib/base64.c
> > > > @@ -18,6 +18,21 @@
> > > >  static const char base64_table[65] =
> > > >  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > > >  
> > > > +static inline const char *find_chr(const char *base64_table, char ch)
> > > > +{
> > > > +	if ('A' <= ch && ch <= 'Z')
> > > > +		return base64_table + ch - 'A';
> > > > +	if ('a' <= ch && ch <= 'z')
> > > > +		return base64_table + 26 + ch - 'a';
> > > > +	if ('0' <= ch && ch <= '9')
> > > > +		return base64_table + 26 * 2 + ch - '0';
> > > > +	if (ch == base64_table[26 * 2 + 10])
> > > > +		return base64_table + 26 * 2 + 10;
> > > > +	if (ch == base64_table[26 * 2 + 10 + 1])
> > > > +		return base64_table + 26 * 2 + 10 + 1;
> > > > +	return NULL;
> > > > +}
> > > > +
> > > >  /**
> > > >   * base64_encode() - base64-encode some binary data
> > > >   * @src: the binary data to encode
> > > > @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
> > > >  	u8 *bp = dst;
> > > >  
> > > >  	for (i = 0; i < srclen; i++) {
> > > > -		const char *p = strchr(base64_table, src[i]);
> > > > +		const char *p = find_chr(base64_table, src[i]);
> > > >  
> > > >  		if (src[i] == '=') {
> > > >  			ac = (ac << 6);
> > > 
> > > But this makes the contents of base64_table no longer be used, except
> > > for entries 62 and 63.  So this patch doesn't make sense.  Either we
> > > should actually use base64_table, or we should remove base64_table and
> > > do the mapping entirely in code.
> > > 
> > For base64_decode(), you're right. After this patch it only uses the last
> > two entries of base64_table. However, base64_encode() still makes use of
> > the entire table.
> > 
> > I'm a bit unsure why it would be unacceptable if only one of the two
> > functions relies on the full base64 table.
> 
> Well, don't remove the table then.  But please don't calculate pointers
> into it, only to take the offset from the beginning and never actually
> dereference them.  You should just generate the offset directly.
> 
Agreed. Thanks for the review.
I'll make that change in the next version.

Regards,
Kuan-Wei


