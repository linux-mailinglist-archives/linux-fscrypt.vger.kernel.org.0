Return-Path: <linux-fscrypt+bounces-835-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE44EB559C3
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Sep 2025 00:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06AEC7AED83
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Sep 2025 22:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9606127587C;
	Fri, 12 Sep 2025 22:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="le6rxRkY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA30267B89
	for <linux-fscrypt@vger.kernel.org>; Fri, 12 Sep 2025 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757717726; cv=none; b=juMo9nnYCRLAkNYD1AIXJua0LGDMuYi1NhXtoGHJnKd1JZFRsqjMqKePpZoU8qClUQgEed9RfYzsK4LRHenpMW0fI7F8jyqqqWWNj0J3AF16uxkuHn54ApTi7EpBluORLax8P41smfy2R/gQq2Mzf6jq9qVTPsKKDFQgNCN/t9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757717726; c=relaxed/simple;
	bh=L9Ix8GUAXAZWYXV2ZEQHnHNqbdKz5TayVfN6Teb85ss=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pk4xukashhCwNMCZboLQ6ScTqWD5sEWO8z/z4S+oCwSV75fM2F6V/nz5s2GDvdQsqQuYrTiWFFllT5SqvgFZPbRS7tUiwvWpdnMwyrHk7Gm/bgMPxgeCXS+7GuVFTTyjEVtswuirOBA7kxIYRfSjkmzkFVqJm56q0144N62mfCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=le6rxRkY; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3c6abcfd142so1133131f8f.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 12 Sep 2025 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757717723; x=1758322523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQQq41SVVRbn6631nZmi56Z4Of+AjJI4UHPGihR3J2Q=;
        b=le6rxRkYFJCluBSRJ5bFdNxLycE62jaB7IC6Y+ZNBZ3hCHwxODhDl+vMJGRbQTkLf2
         jtUPMkQmuzlyjB3Xc0TJeKvvL3dQZPXlEsreZCDRVXDNSepa4/CCscwzQgpiAmG5znH6
         zlmE/AhRlOMPCkTsRq+GfPvKBFtVFuZyrK34NfjDaTa9yGcBhKWnGQq9OtiPi1Ah3Z9O
         w6k7ZZcP06YHQ875NaAATBhbIwivqDa5b2ECvv/+jbviX2qHUQavfbWZxIqXrjDu4QBo
         MbMThUUZ6Q3FHxpzO5rLfWsU81BjeeSFJnAMBKBLlcVgkvzamYPVKGsXvBWliPbGagn5
         tuWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757717723; x=1758322523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQQq41SVVRbn6631nZmi56Z4Of+AjJI4UHPGihR3J2Q=;
        b=MMuIe2dsvMsq6VjAKmiS3Q80kxrSLH/YY9hLbeYJL/TVSfRzofOccmlVAnLoNfHMc2
         YdQ6fZXprNmlJ7KxHX8MgIJnlecFQ88Ef55R8oY0e2B7q3hC925JRFvZldH78ghwQy4O
         OoN2FxpPaFziWsRPZLN8kvZvnzBwk3yUN4TguUBF5KvzC8vm7eNyrHfu/QpwsfteYHMC
         a3CgnxxrZffZIbw+OW96+VL2Ih6RZhuQazvP+XQTcGObGYLMJREsKfiv2UM8GsHwD4YD
         0PaUZZD58kIsm4xZDazz8Jsf755BKnx0UdG3FMcLVVQ8sLSwDyCKorBo+2aVrSEKvSRi
         nnbA==
X-Forwarded-Encrypted: i=1; AJvYcCWwvTT/kHV5rA2J7yt2LAp0pVxs2mx/EqqFbVoq8Ty047jr8UORbgL5NKcwK+EMVhwAWAxDUBC8m4cji8Xg@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy3U9FBBKFLm9K9HRNksoMMBRzHM6AXhdfLbHx0wy7NDxJbc5u
	EiswNm2qkrUHHCVW5wOC+P3dtAEEvrhh3wNIi4AOPFGPSx+8dzH9/Fdu
X-Gm-Gg: ASbGnctlV9fpnkyv42+J/+wQnEPMzvbKdTxvnSMWukfb/qjBRCdHNDbfnNfPmU99OA9
	r9CMcDdbKO3yxw2brW6jsqKdiIvXeHMt5kc9Kym0BotlGPK8IAa58ackbRGa565ooa6jHdA2qGc
	yUJKtW2PvmebraDZSHIqYmD3+DWiccFwotOCFD8U6o0juop3kv7OJ/gKqfQ5Swp0BHctAnvL28y
	1Fl0BFkuUVhL02ydtpVdITNfdCiW//NQUhYpfMr6pdgNyTWJeS4erdBYECx/V6qJn5yLyCaXzBj
	9xVUTRZvJFpgiKZ3dW4cg1rT0llxzkoQEdQ/wtXlxuyRUhR1nNtvPy0K2Yz2djYAuBQBnKkIDq/
	/bw2Kh2AUBAA4rFAf9AZVx4l3g//y9IkVPjD7QFVt9+NlN1MEwrtvC4EdTWWYjhhrU6HwmS7B3H
	sAXpXtnw==
X-Google-Smtp-Source: AGHT+IHIf0xPTQSq2SGK+xjb3mFSGDk7HN3L2nA4JQ5Js7XJrtXXtnD62hWKhZUN18BtSlP72hjvRw==
X-Received: by 2002:a05:6000:420f:b0:3e5:955d:a81b with SMTP id ffacd0b85a97d-3e7659c4248mr4152680f8f.34.1757717722835;
        Fri, 12 Sep 2025 15:55:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01578272sm84954695e9.9.2025.09.12.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 15:55:22 -0700 (PDT)
Date: Fri, 12 Sep 2025 23:54:56 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <20250912235456.6ba2c789@pumpkin>
In-Reply-To: <20250911073204.574742-1-409411716@gms.tku.edu.tw>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
	<20250911073204.574742-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Sep 2025 15:32:04 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

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

That's still going to be really horrible with random data.
You'll get a lot of mispredicted branch penalties.
I think they are about 20 clocks each on my Zen-5.
A 256 byte lookup table might be better.
However if you assume ascii then 'ch' can be split 3:5 bits and
the top three used to determine the valid values for the low bits
(probably using shifts of constants rather than actual arrays).
So apart from the outlying '+' and '/' (and IIRC there is a variant
that uses different characters) which can be picked up in the error
path; it ought to be possible to code with no conditionals at all.

To late at night to write (and test) an implementation.

	David




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


