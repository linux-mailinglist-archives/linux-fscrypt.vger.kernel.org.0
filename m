Return-Path: <linux-fscrypt+bounces-852-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 478F5BA767B
	for <lists+linux-fscrypt@lfdr.de>; Sun, 28 Sep 2025 20:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4A621763BD
	for <lists+linux-fscrypt@lfdr.de>; Sun, 28 Sep 2025 18:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B481259CB2;
	Sun, 28 Sep 2025 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q9GL2V4j"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5DB223DFF
	for <linux-fscrypt@vger.kernel.org>; Sun, 28 Sep 2025 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085862; cv=none; b=RtqV0ZjraWZIvn6spt+49p5oTuE/NOHOtFB4jYT78BOae1ddHfw1YTNv+DGghJGbAGUKgCo14wdkQjD81I7yyQuAsJTMEjZnlrvxoVqAsCzKVIM0WogatJDSIUsMYEBTWzXfEl18nh1QdeD1jApZQxXZadT2Swb5cgu1Cndx1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085862; c=relaxed/simple;
	bh=ODBJzFhKiIsXXG5/GMJYfh0owtM2QlHLhb+LFU0LClY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot5taEc5gWjWIT2vWTRD1r0rsWZp8n3Jrd/9mXp8sAQEbMMxYNGGT+G2jkXiFgpHfOm+rp+VhYW9mTxdNtlZXs9qNnd+YxcRgVd+7JFMnBJ6UzU9h+p0nkeuBvAA5QiAQGIocVa2+mXOSsWagaLhDJYG5aXDMbE8H2KKMoGbYCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q9GL2V4j; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e42deffa8so25698535e9.0
        for <linux-fscrypt@vger.kernel.org>; Sun, 28 Sep 2025 11:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759085859; x=1759690659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zmGgp8LZB8H7aPG6SX5XQzX0Iik7pnp4RAkYSd2NXzI=;
        b=Q9GL2V4jKB5V+gexC4MKH9kQpcSbZ+02RVLZFXBu7l4rC6dslLO03SHeisaFGl+oG5
         ObF6iSIN33pjcSQuURCOW5eL0C2bCv5x35xS+1riA4dBaFTZ5/m5lGkefWTz1lGrF4Pm
         4VUqeFpgOxMtjxn4ZXSvOPirmfTXCJH8xfmvRV3hdvfrv80aLcAuW9EXSG1FzQNbduTB
         SqgAamI9zyWLLXgltdKR8RzAyc9VtPjv2oB1dKmFs/GdTffDKGDLBdAMGO2psQ+IJVYc
         WJSFD6U/X8cypGckMw4Aq4ozkbCQBn+Kw9kot/ofKHTzW4uRXE/HF2tYVKJU02KuTWQM
         5hPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759085859; x=1759690659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zmGgp8LZB8H7aPG6SX5XQzX0Iik7pnp4RAkYSd2NXzI=;
        b=lAWMoqX5FZinoy1QvrYa3nFnLXF/Qaz+WcsRaz/8mLoMUT7Mmy9xcFh3Tb96+20TZr
         jkSj+P4hR1E1sbL3GNzq6NJ9ByjJxoMtSpHN5arEu14zFpDCYm2nk0LNNt2EhaSmKAbQ
         aiiRcgnNWjw9cv3zYUZJW6tlcHZlqYZmZjGxQQxZwDpDM/WMtNEvpAy+6z8Z3OD/XnYn
         iBdVxdfgbJE9QVJyGTSlwMDDPL1YD2eFN2Ao4/80JHsCLsMob2eaPzAWQ+c4dQrig3Md
         jmhDWJxUCESP3YaQpGKvhGjcnCRa8N0afVfZtsc7P94F9okBp/DQZchUuzHe9wrSlEth
         LSKw==
X-Forwarded-Encrypted: i=1; AJvYcCUfVjjEf4FavHC+y5nkCW13+pZ1YwMDoF1ON5J45hZx7JikahwfwEcG2tT+UQnmFtvcwpHn8hFf8y0gcz52@vger.kernel.org
X-Gm-Message-State: AOJu0YyFFzYpc/5X2uLuisb4gMzcxxfF4g82LwbSXgcPrnTP3qjcBMKe
	KoRg9yHiSwHkBX3n8h4McGC/JoHEbemxxslGLm21mxG5PBK1fBuqyOf9
X-Gm-Gg: ASbGncvS7LLqxARYg5I4gAUp1Jv+IqwLL5kFDoYALyO539TsSwylXra7foX9CNhwj0q
	Ti0dKOkgrI88QieLuzKKBiLjeJN5REQcRl7mJ4SjgnDPNd6aOMWQQtZ8u8keHonKdHqcRGB7y3c
	5iulCiMYzhWMc1UwpIKOKq84xB9Kew8KKzHQssh+KL35HiD/MdDcnAo3qSwPorpGec7hivV3ZLt
	gV2bfr5L5xPnR9zLfBWS7y2d0fIMo6XhiavB6iCOEhDP7WNdBQApYlKxDB599WuhDeZVJ0fUDSp
	psbI3edI2qg4xBgRZ0K7floMHUTAiriM3gIAihsM72efO8UgsrdGsHqfIl61sk7I2ac5XuQgXgg
	oyML2cn3xPj9sDxRVUFBUblUPPVzhfi8rRPzEI/dQ3EqtZpc79gmrbprva+I4+PlDOojO1IL4vP
	w=
X-Google-Smtp-Source: AGHT+IFdXSUmu1jDu9C+PMSkYOzc5SUURLTfRIaH+ROSnCKAviW3HCbfr6MunNZeaSZVBZNwp+b1tQ==
X-Received: by 2002:a05:600c:4508:b0:46e:3e72:a56 with SMTP id 5b1f17b1804b1-46e3e720b94mr81111745e9.1.1759085858562;
        Sun, 28 Sep 2025 11:57:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9ac5basm222579525e9.7.2025.09.28.11.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 11:57:38 -0700 (PDT)
Date: Sun, 28 Sep 2025 19:57:36 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with
 reverse lookup tables
Message-ID: <20250928195736.71bec9ae@pumpkin>
In-Reply-To: <20250926065556.14250-1-409411716@gms.tku.edu.tw>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
	<20250926065556.14250-1-409411716@gms.tku.edu.tw>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Sep 2025 14:55:56 +0800
Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Replace the use of strchr() in base64_decode() with precomputed reverse
> lookup tables for each variant. This avoids repeated string scans and
> improves performance. Use -1 in the tables to mark invalid characters.
> 
> Decode:
>   64B   ~1530ns  ->  ~75ns    (~20.4x)
>   1KB  ~27726ns  -> ~1165ns   (~23.8x)
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
> ---
>  lib/base64.c | 66 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 61 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/base64.c b/lib/base64.c
> index 1af557785..b20fdf168 100644
> --- a/lib/base64.c
> +++ b/lib/base64.c
> @@ -21,6 +21,63 @@ static const char base64_tables[][65] = {
>  	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
>  };
>  
> +static const s8 base64_rev_tables[][256] = {
> +	[BASE64_STD] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,  -1,  63,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},

Using:
	[BASE64_STD] = {
	[0 ... 255] = -1,
	['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12,
		13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
	['a'] = 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 48, 50, 51,
	['0'] = 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
	['+'] = 62,
	['/'] = 63};
would be more readable.
(Assuming no one has turned on a warning that stops you defaulting the entries to -1.)

The is also definitely scope for a #define to common things up.
Even if it has to have the values for all the 5 special characters (-1 if not used)
rather than the characters for 62 and 63.

	David

> +	[BASE64_URLSAFE] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  -1,  -1,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  63,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},
> +	[BASE64_IMAP] = {
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  62,  63,  -1,  -1,  -1,
> +	 52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,
> +	 15,  16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  38,  39,  40,
> +	 41,  42,  43,  44,  45,  46,  47,  48,  49,  50,  51,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	 -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,
> +	},
> +};
> +
>  /**
>   * base64_encode() - Base64-encode some binary data
>   * @src: the binary data to encode
> @@ -82,11 +139,9 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  	int bits = 0;
>  	int i;
>  	u8 *bp = dst;
> -	const char *base64_table = base64_tables[variant];
> +	s8 ch;
>  
>  	for (i = 0; i < srclen; i++) {
> -		const char *p = strchr(base64_table, src[i]);
> -
>  		if (src[i] == '=') {
>  			ac = (ac << 6);
>  			bits += 6;
> @@ -94,9 +149,10 @@ int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base6
>  				bits -= 8;
>  			continue;
>  		}
> -		if (p == NULL || src[i] == 0)
> +		ch = base64_rev_tables[variant][(u8)src[i]];
> +		if (ch == -1)
>  			return -1;
> -		ac = (ac << 6) | (p - base64_table);
> +		ac = (ac << 6) | ch;
>  		bits += 6;
>  		if (bits >= 8) {
>  			bits -= 8;


