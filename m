Return-Path: <linux-fscrypt+bounces-828-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA0DB53BDE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 20:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D7D51C20EA9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 18:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6355DDC3;
	Thu, 11 Sep 2025 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iiYH8x+d"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4532DC771;
	Thu, 11 Sep 2025 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757616657; cv=none; b=bQi/d5ZI9SeUmyFs3DEsRo0ipp0BPyNBfkU5tRFVyCE74+ZNcUCUBsGgEaM8RGfbYrPVDu4KAuoA3NgIxlcWMGWzvcgxG/DvCZ4hZPmVTQlSwo6spYfw7hlFLNyK+w+j4d3UMGM9ufwaclMzpQ1nCNbyObpipnU+uToshy9CebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757616657; c=relaxed/simple;
	bh=xc1JrzNtcpZ5N5cyAo3Ece+acfMfTB+qXBHnynrrQKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAo6JswvU/sBUgDUhDXi+/eZeA2Y1QXUv0J/+Bq9n6lH0EPk0knCPuoSJrjhcnEeoMUThtNoLMUd5JaTncTWEOx/MeEMJUk51tmoGqR5a4wgZ3lGvmVyWFnThWEh3V3bcaE4guPJAf7A/pBLjhRScYy6CYX4jeAoFoZdkJcuxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iiYH8x+d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D3C4CEF0;
	Thu, 11 Sep 2025 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757616657;
	bh=xc1JrzNtcpZ5N5cyAo3Ece+acfMfTB+qXBHnynrrQKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iiYH8x+dKSCKyEYrPVn2ChA+yS+4noJxQHsH/BvYVuVhLOE0A/eKZyrdMQw/oCqwL
	 2tJyd4kbpeLaYpEkIM3dsi/VDXtrG4np/qMto+tqQdyzIRGumDHxB6rllbGuTspHOn
	 YirkTGgVQpRQ5PDJBS1KaRsg1pGG1TnayshhzREynV7T2KU0aUfSNkLv+3JzueIl0D
	 uSXUUGNdLDiX5BD4bqXym6/e+NBZVWwc3LxMfFShDLZGGvhlZlAWYQa+AC9huQz2Tq
	 zMXXPk/XOUyihgdFayforOU6xdmyJBVl+pwyx7zdyvV11ay9iHMIznLI5oswe/mpS5
	 96HY4TcwzOqyg==
Date: Thu, 11 Sep 2025 11:49:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
	axboe@kernel.dk, ceph-devel@vger.kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250911184935.GE1376@sol>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
 <20250911181418.GB1376@sol>
 <aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMMYmfVfmkm7Ei+6@visitorckw-System-Product-Name>

On Fri, Sep 12, 2025 at 02:44:41AM +0800, Kuan-Wei Chiu wrote:
> Hi Eric,
> 
> On Thu, Sep 11, 2025 at 11:14:18AM -0700, Eric Biggers wrote:
> > On Thu, Sep 11, 2025 at 03:32:04PM +0800, Guan-Chun Wu wrote:
> > > From: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > 
> > > The base64 decoder previously relied on strchr() to locate each
> > > character in the base64 table. In the worst case, this requires
> > > scanning all 64 entries, and even with bitwise tricks or word-sized
> > > comparisons, still needs up to 8 checks.
> > > 
> > > Introduce a small helper function that maps input characters directly
> > > to their position in the base64 table. This reduces the maximum number
> > > of comparisons to 5, improving decoding efficiency while keeping the
> > > logic straightforward.
> > > 
> > > Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> > > over 1000 runs, tested with KUnit):
> > > 
> > > Decode:
> > >  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
> > >  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> > > 
> > > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > > Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> > > ---
> > >  lib/base64.c | 17 ++++++++++++++++-
> > >  1 file changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/base64.c b/lib/base64.c
> > > index b736a7a43..9416bded2 100644
> > > --- a/lib/base64.c
> > > +++ b/lib/base64.c
> > > @@ -18,6 +18,21 @@
> > >  static const char base64_table[65] =
> > >  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
> > >  
> > > +static inline const char *find_chr(const char *base64_table, char ch)
> > > +{
> > > +	if ('A' <= ch && ch <= 'Z')
> > > +		return base64_table + ch - 'A';
> > > +	if ('a' <= ch && ch <= 'z')
> > > +		return base64_table + 26 + ch - 'a';
> > > +	if ('0' <= ch && ch <= '9')
> > > +		return base64_table + 26 * 2 + ch - '0';
> > > +	if (ch == base64_table[26 * 2 + 10])
> > > +		return base64_table + 26 * 2 + 10;
> > > +	if (ch == base64_table[26 * 2 + 10 + 1])
> > > +		return base64_table + 26 * 2 + 10 + 1;
> > > +	return NULL;
> > > +}
> > > +
> > >  /**
> > >   * base64_encode() - base64-encode some binary data
> > >   * @src: the binary data to encode
> > > @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
> > >  	u8 *bp = dst;
> > >  
> > >  	for (i = 0; i < srclen; i++) {
> > > -		const char *p = strchr(base64_table, src[i]);
> > > +		const char *p = find_chr(base64_table, src[i]);
> > >  
> > >  		if (src[i] == '=') {
> > >  			ac = (ac << 6);
> > 
> > But this makes the contents of base64_table no longer be used, except
> > for entries 62 and 63.  So this patch doesn't make sense.  Either we
> > should actually use base64_table, or we should remove base64_table and
> > do the mapping entirely in code.
> > 
> For base64_decode(), you're right. After this patch it only uses the last
> two entries of base64_table. However, base64_encode() still makes use of
> the entire table.
> 
> I'm a bit unsure why it would be unacceptable if only one of the two
> functions relies on the full base64 table.

Well, don't remove the table then.  But please don't calculate pointers
into it, only to take the offset from the beginning and never actually
dereference them.  You should just generate the offset directly.

- Eric

