Return-Path: <linux-fscrypt+bounces-824-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD2BB53B40
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 20:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17EF81CC3C76
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 18:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8902136996F;
	Thu, 11 Sep 2025 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHF/RmRF"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E02435CEB6;
	Thu, 11 Sep 2025 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757614540; cv=none; b=Z5V4Z6JICv1+ZZexwAJSjUwvaekCaBAxLaBFLJpqtDw3EXtj9KCKgpOMDi7biZBbvRsLPaw1MBNbk6RbxGcOiHPJR/e8lzGAt8Yvo0uoOXUygCZM5EISby+U3h6knCtvDUPZBo9no+5ECUCX5AfMge086zC4NszEMTR2JjKWETg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757614540; c=relaxed/simple;
	bh=a2Lob0n3/+GCVE61Fr7ySrkcY2m5OqzFFOAuvId4MiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRii2xACpnN8jzDBNexlT2L0HV4vk99Ars4EEH38hOPExMZNr1JglMnlq7KGQ6Fxz3cEOts/Cjnv5AxfE3faRTKTMWkXfWtrqXV8i8UIS6fy3PK0P80aRB0m990DspSeFMirh4ldMrE/fL1W/wyShP1Po+NhrpQHrPs/6cTKOVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHF/RmRF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC65C4CEF0;
	Thu, 11 Sep 2025 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757614540;
	bh=a2Lob0n3/+GCVE61Fr7ySrkcY2m5OqzFFOAuvId4MiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YHF/RmRFumOOHkEnaB3xMYiqo0WcAPOUsR5NQ2XhQl2SJLAVBfc3/wjdHBHX8Wmbe
	 KQVdxrNGKmWY3qjbhOJzzbYoQ2Q5sjebQoSSnx7vv4VBXx0lAc1fDEKsY760hrlSnB
	 cw0Cc6hS1Ykvt7RXoXZHMCn8MkIP3zzIZQxrLMkYrj7Yqnd5FYs9DRrBQBYLsM9/i5
	 Ttq9vEAAXQhJPUxn4tJq3w2kSNphEY2nNwbwJlSRhVN8rrpjajtaojIRtId1AT7kxM
	 nrIuRYtF5Z6Y8vUInleEY8memGNegfHCnpeDFpjJm5uAL8eDpW7AqF7lVG6duhuZ0j
	 ioWusQwGr+YtA==
Date: Thu, 11 Sep 2025 11:14:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250911181418.GB1376@sol>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911073204.574742-1-409411716@gms.tku.edu.tw>

On Thu, Sep 11, 2025 at 03:32:04PM +0800, Guan-Chun Wu wrote:
> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> The base64 decoder previously relied on strchr() to locate each
> character in the base64 table. In the worst case, this requires
> scanning all 64 entries, and even with bitwise tricks or word-sized
> comparisons, still needs up to 8 checks.
> 
> Introduce a small helper function that maps input characters directly
> to their position in the base64 table. This reduces the maximum number
> of comparisons to 5, improving decoding efficiency while keeping the
> logic straightforward.
> 
> Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
> over 1000 runs, tested with KUnit):
> 
> Decode:
>  - 64B input: avg ~1530ns -> ~126ns (~12x faster)
>  - 1KB input: avg ~27726ns -> ~2003ns (~14x faster)
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index b736a7a43..9416bded2 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -18,6 +18,21 @@
>  static const char base64_table[65] =
>  	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
>  
> +static inline const char *find_chr(const char *base64_table, char ch)
> +{
> +	if ('A' <= ch && ch <= 'Z')
> +		return base64_table + ch - 'A';
> +	if ('a' <= ch && ch <= 'z')
> +		return base64_table + 26 + ch - 'a';
> +	if ('0' <= ch && ch <= '9')
> +		return base64_table + 26 * 2 + ch - '0';
> +	if (ch == base64_table[26 * 2 + 10])
> +		return base64_table + 26 * 2 + 10;
> +	if (ch == base64_table[26 * 2 + 10 + 1])
> +		return base64_table + 26 * 2 + 10 + 1;
> +	return NULL;
> +}
> +
>  /**
>   * base64_encode() - base64-encode some binary data
>   * @src: the binary data to encode
> @@ -78,7 +93,7 @@ int base64_decode(const char *src, int srclen, u8 *dst)
>  	u8 *bp = dst;
>  
>  	for (i = 0; i < srclen; i++) {
> -		const char *p = strchr(base64_table, src[i]);
> +		const char *p = find_chr(base64_table, src[i]);
>  
>  		if (src[i] == '=') {
>  			ac = (ac << 6);

But this makes the contents of base64_table no longer be used, except
for entries 62 and 63.  So this patch doesn't make sense.  Either we
should actually use base64_table, or we should remove base64_table and
do the mapping entirely in code.

- Eric

