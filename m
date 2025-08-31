Return-Path: <linux-fscrypt+bounces-806-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98BCDB3D3E5
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 16:24:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 459374403B2
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 14:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ABAE2459D1;
	Sun, 31 Aug 2025 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="cERAsCNE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736BE24418E
	for <linux-fscrypt@vger.kernel.org>; Sun, 31 Aug 2025 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756650240; cv=none; b=umNaQQfncTWxOkq8gXxKqpBVYSXIQFm8zHZWu8eK5egnmSrg6usUnnynuJts4cCF0DEIk0sG74y3gFwYvEHeGeSOikO5vjzJ6+ds+f5z6hmFC9BzCoSM4JfZoLOwGO7MRmHSyfLYhBZ2iVlDpMwQPclIo0aM07LIMxqSj227RM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756650240; c=relaxed/simple;
	bh=y1zF5JL1EodDQ2qLLuAywaO3QqUb5aQbBUe2g574maM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=khJbPhCGP3LSeENwMpls4hMBap0UKmxJpmDhF8j+aQuD1ASLqzfxAVS1tha1AXjHt0oOcrq64Nup4+AQNys+LYo9TZwCDJwOs4EnvEY9gUWBOsxncEqdVoqKpbnOAa0/IFAunnNLfiuJfjzvHaOK1wOkhmkIUeQg+FHmq3QOb8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=cERAsCNE; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-248a61a27acso25453325ad.1
        for <linux-fscrypt@vger.kernel.org>; Sun, 31 Aug 2025 07:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1756650237; x=1757255037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAUHWa+mrkdnS2M1tLNwmvLfuGzsdxZRu47bXM4nV+w=;
        b=cERAsCNE7bDngNBedrvfghgtRKi9GrpXmYY52s0mF/sNMobctPGpyV3bbjUJKDNo7x
         Jd2vv46AFdEkqn3DQXglyuge/0nB1+4vZhvGb26dFAjOvanEQu2JhK/XLhkVA2EhBZGJ
         2XuU5K61Pdcdln6mxMTQiJ8NR8eMUCMc2WT/xAd53qfCK8JBjUQib8Wg3VASzHTK7Z1E
         q2cMJ/HQqW4Rxha/Aw87daog1lK2lPXM7k3nlLnbmxhvGhovttYfgqOuyxn0eAKwFzT6
         KKt0DcrqCoCc/gU34zcA4td8NzfUOFFYEUTnF6D4+gml4OecW/6jC7Mtad1UKf4GOuWz
         iGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756650237; x=1757255037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lAUHWa+mrkdnS2M1tLNwmvLfuGzsdxZRu47bXM4nV+w=;
        b=g7J9NJPSGGvNBzpUSFtEdfKhJBwng91XcLVhrQrWEnlJuF1ouNuZCtRqXvriwaFJrv
         5P6cQ9oo+0qcCPkgebhs8ZgsyYuJPKFhrSQCMDqpD8wa9Hzr2u7T2RqwcLhiLG8fXeAK
         XUJck9Da3IDtpJBJY5nNtHWeJSyqrDzkici4f2HGgRhqqN0EAJ+QLPZugAj1zMeQFVln
         fWzTHsVxvgKPLDlYB3TQERcFddvNfAsPCRnGb1jdOw5zk/wnZzebbABb3o4J/V8UoZu0
         Nu4wGL5bFlxaBh8xluXS5HYW7cDliVpy6KFC1h0+D3CjNO3rJAVkzBw2Gh3FLXMGjNKD
         JxRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu6ObZURgdrST4inhDFlVj78PeeyAjBpu6UvnUHpaWuYgLrGwDkMR1RR3EOjtAm3ZnAe59zhyHrtSA6ki5@vger.kernel.org
X-Gm-Message-State: AOJu0YyJt4Jzb2LEl3brZ58Gircj3jfLl9hccDtaL1dnqWl4HFiOi3MT
	X/fxtwfECroIjvPgQ3uW7JEQZIDR0VWDqLbwLKvjqxyvrkIO5FzBEuLKHSRVEbtiIXg=
X-Gm-Gg: ASbGncuUoFVY7iWXEQx+ajIQ0aYdtyrOrdI3Y0sW4PrkGSUqgK6cmPjIp2D2zyPDx5x
	fmX0VFeekHkMueyIO87IqbHGK0arYQTQ+ScKFsAovkfkikGKkwHnfj0b+xXk3Sr25tq8lyQHw8h
	hOddUaBkMUzVFBZqhz2jWL46+KRDX5B1PU7TsCxEE0L56xTW2BTHtQR8Gdq+fO0R5A/g+4QStHj
	Qpw20kBOdv6XjaMaqsrLznMu4kitvJRq247OGMhzxs3pm9fiAJe0ccTkJKzFYQ4QSvpSv4S/LX5
	k9FQxQC23ao2RC5vLLVKfTN/jkKidcaVB84RbcisbuucBjHgWr/ZtN8N66JE130iQqGjK36GEG3
	N6tqb/if5jTwoZzFX14i6XxDxMSXnvAlrWIEaw5kbz1g6ZxYtpSQqeLH4NhDdg+BsGtHW
X-Google-Smtp-Source: AGHT+IFQ56DB3b4SdGl+LhNjvjjBhfPxTg7gFDUHSGh44e9FA9yjLxRBEUKtF6n7IdgfuIaXIBG+5A==
X-Received: by 2002:a17:903:32d2:b0:248:aa0d:bb30 with SMTP id d9443c01a7336-2494486f180mr66609385ad.2.1756650236666;
        Sun, 31 Aug 2025 07:23:56 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:c382:54ef:4bb4:90ef])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24906598815sm76233755ad.117.2025.08.31.07.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 07:23:56 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: ebiggers@kernel.org
Cc: 409411716@gms.tku.edu.tw,
	jaegeuk@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH] fscrypt: optimize fscrypt_base64url_encode() with block processing
Date: Sun, 31 Aug 2025 22:23:52 +0800
Message-Id: <20250831142352.16372-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250830162431.GA1431@quark>
References: <20250830162431.GA1431@quark>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Eric,

>On Sat, Aug 30, 2025 at 09:28:32PM +0800, Guan-Chun Wu wrote:
>> Previously, fscrypt_base64url_encode() processed input one byte at a
>> time, using a bitstream, accumulating bits and emitting characters when
>> 6 bits were available. This was correct but added extra computation.
>> 
>> This patch processes input in 3-byte blocks, mapping directly to 4 output
>> characters. Any remaining 1 or 2 bytes are handled according to Base64 URL
>> rules. This reduces computation and improves performance.
>> 
>> Performance test (5 runs) for fscrypt_base64url_encode():
>> 
>> 64B input:
>> -------------------------------------------------------
>> | Old method | 131 | 108 | 114 | 122 | 123 | avg ~120 ns |
>> -------------------------------------------------------
>> | New method |  84 |  81 |  84 |  82 |  84 | avg ~83 ns  |
>> -------------------------------------------------------
>> 
>> 1KB input:
>> --------------------------------------------------------
>> | Old method | 1152 | 1121 | 1142 | 1147 | 1148 | avg ~1142 ns |
>> --------------------------------------------------------
>> | New method |  767 |  752 |  765 |  771 |  776 | avg ~766 ns  |
>> --------------------------------------------------------
>> 
>> Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
>
>Thanks!
>
>> Tested on Linux 6.8.0-64-generic x86_64
>> with Intel Core i7-10700 @ 2.90GHz
>> 
>> Test is executed in the form of kernel module.
>> 
>> Test script:
>
>Is there any chance you'd be interested in creating an fscrypt KUnit
>test (in a separate patch) which tests fscrypt_base64url_encode() and
>fscrypt_base64url_decode()?

I’m interested in adding a KUnit test as a separate patch
to cover both fscrypt_base64url_encode() and fscrypt_base64url_decode().

Per Thomas’s suggestion, I’d also like to explore a generic Base64 helper in lib/
(with encoding table and optional padding), with tests in lib/test/
covering both the standard and URL-safe variants.

>
>> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
>> index 010f9c0a4c2f..adaa16905498 100644
>> --- a/fs/crypto/fname.c
>> +++ b/fs/crypto/fname.c
>> @@ -204,20 +204,31 @@ static const char base64url_table[65] =
>>  static int fscrypt_base64url_encode(const u8 *src, int srclen, char *dst)
>>  {
>>  	u32 ac = 0;
>> -	int bits = 0;
>> -	int i;
>> +	int i = 0;
>>  	char *cp = dst;
>>  
>> -	for (i = 0; i < srclen; i++) {
>> -		ac = (ac << 8) | src[i];
>> -		bits += 8;
>> -		do {
>> -			bits -= 6;
>> -			*cp++ = base64url_table[(ac >> bits) & 0x3f];
>> -		} while (bits >= 6);
>> +	while (i + 2 < srclen) {
>> +		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
>> +		*cp++ = base64url_table[(ac >> 18) & 0x3f];
>> +		*cp++ = base64url_table[(ac >> 12) & 0x3f];
>> +		*cp++ = base64url_table[(ac >> 6) & 0x3f];
>> +		*cp++ = base64url_table[ac & 0x3f];
>> +		i += 3;
>> +	}
>
>To make it a bit easier to understand, how about updating src and srclen
>as we go along?
>
>	while (srclen >= 3) {
>		ac = ((u32)src[0] << 16) | ((u32)src[1] << 8) | (u32)src[2];
>		*cp++ = base64url_table[ac >> 18];
>		*cp++ = base64url_table[(ac >> 12) & 0x3f];
>		*cp++ = base64url_table[(ac >> 6) & 0x3f];
>		*cp++ = base64url_table[ac & 0x3f];
>		src += 3;
>		srclen -= 3;
>	}
>
>	switch (srclen) {
>	case 2:
>		ac = ((u32)src[0] << 16) | ((u32)src[1] << 8);
>		*cp++ = base64url_table[ac >> 18];
>		*cp++ = base64url_table[(ac >> 12) & 0x3f];
>		*cp++ = base64url_table[(ac >> 6) & 0x3f];
>		break;
>	case 1:
>		ac = ((u32)src[0] << 16);
>		*cp++ = base64url_table[ac >> 18];
>		*cp++ = base64url_table[(ac >> 12) & 0x3f];
>		break;
>	}
>
>'srclen >= 3' is much more readable than 'i + 2 < srclen', IMO.
>
>Also, instead of '(ac >> 18) & 0x3f', we can just use 'ac >> 18', since
>'ac' is a 24-bit value.
>
>- Eric

Thanks, Eric. I'll update the loop condition to use 'srclen >= 3' for
better readability, and drop the redundant '& 0x3f' when shifting the
24-bit accumulator.

