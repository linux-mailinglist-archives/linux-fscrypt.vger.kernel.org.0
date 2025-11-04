Return-Path: <linux-fscrypt+bounces-912-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E8AC302CF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 10:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 80B004EE4AD
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35FCD271A9A;
	Tue,  4 Nov 2025 09:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLYsQD/x"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAA42951A7
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Nov 2025 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247012; cv=none; b=BdF/pkiRZLP9wbiMgzj9u53WHfUk/8YhFX7W3n4gwAShc5GPKJsIkZ3cJ0xIlbblvDQHwuphyp+JuJSwTmFgfIz/MSQV2OIllrla7W4L/CG/o9FJyjnTksuhRMzVpchD5oehcF+MZ/LPrEdsMRqJP/U3z0/Z465okZQVDLsW1gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247012; c=relaxed/simple;
	bh=9lxtNYjj4jYTq+uB3ZgnfzrzgEkVeMIER5czZKEczLE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJ6hVJ8ZdoSuVJc5qIFSzwusrHJsN/1wkVfA2YaEY7iVPaJgq//CZWpZwS2ID71AMRpTjymWmOgLATKjXmEIpmopZBdNnpNBQ2W5ug3bATupzxoyjK5gRJeHCpBxnU0eykU3L070hhRHEFUj0dSfWUpaohKlaoymjM8/WnQ133M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLYsQD/x; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429b7ba208eso3227911f8f.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 04 Nov 2025 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762247009; x=1762851809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zo+v+I4+4hNzyEdpTLX3lyu2mUDwsgwys0xGnDbMc1Y=;
        b=MLYsQD/xlgQRerOg/DP07fYRJYoH/WN1ESHJnKt5JkpP9kLla2malTOB6vFE9OSpLD
         WJCKkw3twTeCMbSBQVBekOaRz1rLqSapxnkmdZSJcDC3Xe7pC2SrB419g1BZ5Wbzyuy6
         RR9xt82e6hZGcz7Mxfo9bze/iAgKf8cqKPJo6Z4oS7NQA4iPxLR4fnTsB3pb1jhHKddi
         l7XSm3R5LCa3gD6kgsq8ziYEcOh/qgQsJkukJUjkWynhF1LUvNF1l28Earw8LOdGXg90
         ctZ6OL3UfBjgaIOJEFOXyw+RDLJtwXw4b6P6gMz4gJcg6J7fIxLYesqKO25SsH0OCoNk
         1vLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762247009; x=1762851809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zo+v+I4+4hNzyEdpTLX3lyu2mUDwsgwys0xGnDbMc1Y=;
        b=YvThYfXrjXREUWAFP92CO6I2uA6stlppp0ENiqUdp2/6rG+Pf8qxBaqwwk0UqN1DDu
         oP7lGCJl/iNCWmm6cKD0Jhfuhp4vIMY4U6ZqhWji2u1Af9yJ2HrlG8REZo6SQsgAXvt9
         FZjdFx4vaetLjKzeB7F1OdEVOVH7qQODRzR0NJtMghzkq0NkqqEA4nICmOUVEDJ81h96
         Xa43zM6ppif3lBIfM4tuOfOwGrgRmamzYjoDatggsp6jO7zzQIwBg3jwsKRikP6p54fb
         ieKZFAEANyYHgr4HTpXkqYpsWD5cngOMgFDsa/jBnQk5sz05S/Obbt2N0JUVwpwfXMuO
         cfiw==
X-Forwarded-Encrypted: i=1; AJvYcCVA709n9s2gBU2VPZqC6tRPTIEzgIJkmAk332iVsdnQ+fyWHzxxnHomSQwS7SVUzp3M9tCA9viQM5ZjL3WH@vger.kernel.org
X-Gm-Message-State: AOJu0YxAN7BnEm1IG4MApAPzL+Jc17V8R8EdiSkgsk81tyC3MDN92rKV
	S14XBI4RMlxU/atdyE9Kb7aJ6AIEonzCyYE6bq5nbCz2LhPO5dtI+Zc7
X-Gm-Gg: ASbGncuE9MkGFZ7jsFtBlsvjZ9VSfc+xKi9VK4oWr+fb39eyPTtlJf2Q9nQ9YUx0ItV
	Ci8DIDq6je0lToBEDo3G2pRY7rR1F/G1cpTnLqYGp31yYnZq/WBkX3y1qIDXy5I4TuqeHfMC/pZ
	YkOxmVcRafTjK763in7EVGW3DvH7hUQRYLkKvGo1zS7KJ1WeskpytYI7yWVrBEGMmwJzyaXji4q
	eII6Ych80UJbmilbZCbs8H3wkA1UIjdlzP7zMQa1m7bxuGKlMJBP/wLCQFszpgZbmFOXl77Osfg
	n0sDLpi93Nd2QYRq3/Jn5GdixgRYFSYYj6QeJM4tDRSrZAVHXnIvektT97lIe7WFg/kUBbU7+jF
	7VWxafFOYhiK8cJXxC7g85SNRV031+sHcwcLoIpVfvzyw2CkjfQDyMPrVyVban+OEbBjqb4/1lR
	xw6le2y8HJqLs22XG7BVgI8P9+Cf35q+xrYABAHse/2Q==
X-Google-Smtp-Source: AGHT+IFSl8Yus2hXHqquAbsHWOjt30uW3Pr+rVQvYNkob8XHiLc9RfhluHaTs0Iiu4iVjKlOwvYm9A==
X-Received: by 2002:a05:6000:2387:b0:427:6c6:4e31 with SMTP id ffacd0b85a97d-429bd681254mr13032111f8f.22.1762247008372;
        Tue, 04 Nov 2025 01:03:28 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc18efb3sm3529487f8f.3.2025.11.04.01.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 01:03:27 -0800 (PST)
Date: Tue, 4 Nov 2025 09:03:26 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, Andrew Morton <akpm@linux-foundation.org>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <20251104090326.2040fa75@pumpkin>
In-Reply-To: <aQiM7OWWM0dXTT0J@google.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 19:07:24 +0800
Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> +Cc David
> 
> Hi Guan-Chun,
> 
> If we need to respin this series, please Cc David when sending the next
> version.
> 
> On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
...
> Hi David,
> 
> Since I believe many people test and care about W=1 builds, I think we
> need to find another way to avoid this warning? Perhaps we could
> consider what you suggested:
> 
> #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> 	[ 0 ... '+'-1 ] = -1, \
> 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> 	[ '9'+1 ... 'A'-1 ] = -1, \
> 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> 	[ 'Z'+1 ... '_'-1 ] = -1, \
> 	[ '_' ] = val_under, \
> 	[ '_'+1 ... 'a'-1 ] = -1, \
> 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> 	[ 'z'+1 ... 255 ] = -1 \
> }

I've a slightly better version:

#define INIT_62_63(ch, ch_62, ch_63) \
	[ ch ] = ch == ch_62 ? 62 : ch == ch_63 ? 63 : -1

#define BASE64_REV_INIT(ch_62, ch_63) { \
	[ 0 ... '0' - 6 ] = -1, \
	INIT_62_63('+', ch_62, ch_63), \
	INIT_62_63(',', ch_62, ch_63), \
	INIT_62_63('-', ch_62, ch_63), \
	INIT_62_63('.', ch_62, ch_63), \
	INIT_62_63('/', ch_62, ch_63), \
	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
	[ '9' + 1 ... 'A' - 1 ] = -1, \
	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
	[ 'Z' + 1 ... '_' - 1 ] = -1, \
	INIT_62_63('_', ch_62, ch_63), \
	[ '_' + 1 ... 'a' - 1 ] = -1, \
	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ 'z' + 1 ... 255 ] = -1 \
}

that only requires that INIT_62_63() be used for all the characters
that are used for 62 and 63 - it can be used for extra ones (eg '.').
If some code wants to use different characters; the -1 need replacing
with INIT_62_63() but nothing else has to be changed.

I used '0' - 6 (rather than '+' - 1 - or any other expression for 0x2a)
to (possibly) make the table obviously correct without referring to the
ascii code table.

	David




