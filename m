Return-Path: <linux-fscrypt+bounces-906-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FCC8C2DE6C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 20:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC16C1899CE4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 19:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61EBD3191A4;
	Mon,  3 Nov 2025 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6yylscO"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6D028507E
	for <linux-fscrypt@vger.kernel.org>; Mon,  3 Nov 2025 19:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762198154; cv=none; b=F/Pcb/RXb/VU7y3gqKxpkB09RHz42+QYkO1tPbABwjUag9VD5foN6eWeYOSIGiWyDEaRF0m5s0i1HuO0fUv2hRcLnaV/6ovT1Af1cwOHREsgkSgpOhBrvMqc9yUetqVK1g40FXqqlSV3IXvxcD2L4qbM8+QEJ1vRZqyLwwNAIvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762198154; c=relaxed/simple;
	bh=3ixGimuk0/HaHuWo/1PcSWMZCdoIwspA0vWadlpGWeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SoQD1bKrV+yAJQWIKFuhWF3g+/IT4mdO3BK6Z6jn/DuAlU1qW1hzGL7MozN66QqNWi3C89WsKzimFu9n5YeGiCch2MIIZibQbO6Qrlq3JTzB9r6yYN5iQd68fZf9do7H7LF583Bh9OHXjOGtzSNtooTEdCzEhwxZzjWll7f9Zkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6yylscO; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429bccca1e8so2142551f8f.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 03 Nov 2025 11:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762198151; x=1762802951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pw1mz3Wmkjtz3arI75Z8UisY7e4ejFDGm7ZA+8DIcLQ=;
        b=l6yylscOgUvQq2XzBc73m3dsQ4lqZk3PKKfncA6Y0KpUo4bRCqPaboACeCKPcEl3QI
         2G3boR/0mKvFx23w0OSrMG1ts/2QruZd0ksArOh3PiEgDdIy6Gq417THbRE08p0SQJW0
         VVTgaJqec52votxFqdryHYmOUAyxhvkDpq3+H5nwtnMdr+ilYpnKc/gM7j37YCJGWY+u
         sCCRXmwa1o18i7dTSVaARYXi8YS0q/fovveVLhANFXkyoB86TeF9N11PU95qY+YvMzXs
         1BMtz3j0ckoVF64RwMz4l92+6jy8/StJULFLiTBnhdtzNuRuheLvU0wWxethjOmcVxoW
         fnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762198151; x=1762802951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pw1mz3Wmkjtz3arI75Z8UisY7e4ejFDGm7ZA+8DIcLQ=;
        b=vmaLb6AOihcLfsaC0fJoIFI58ETwkqo+NXr7OZ1ntRSwsTUG48CaVV98vRq4xg6C80
         b0wNDT1LJx8VGbyuyrSE+liXQZIKFAGlmZJEeX8tAFljN6mWzfGwW6gThfnHLeTgErGA
         OyjxslZw02/774wj/OlijsJxrHVp4IEzzZCRMQ0sPPMu53NHBxKFKVvjBceTuRMkcCkV
         ZzKLSi/TqWNMy1CLgKKOuiTSdja5KLIj6kn0/KJ1j0tdOcbEZrdMDdmsUCZDAbt43w5O
         EOTl/5b0DfRk+S79LtkPn0ShaNT/rlrHcQx7hztyl4BbpB9OYLhwCT4vKWkDLRWto5+Z
         0kpw==
X-Forwarded-Encrypted: i=1; AJvYcCXEOj8hcYoVR7MDcZf3sieRDUDLQocINhCe9rAhs7OHNwGRAlOi1S3G50xPsVT2dW9eDDL5TFasZyx5iPko@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8PWijGkwyWvft7uej4nn1TffyqjYfo+4TDNySQUvuExp1OiK+
	iQTWzogRpdh3Wky1GgTUclwohjkwCNmDteTzxy7/iWC5kIc+fzHFOoNa
X-Gm-Gg: ASbGnct1pf/zUkGJ8pTDI7gFdX5YIWDy7Do5Obm8kEqsMAhYML54xPr5RASBzY0F66L
	iwxbfl1uKBPK3ZSgzXnUzgRC2f5sy/n/0y5X0l68/1RnXUbuJ4ln6eBakXizzMr6Gisewp8XqZH
	6Z+Ep2YxltsBs2jQiZFGR+CQFeYK+yU6RaTJ1ycsu/VW3FaaQ+6taTwTPYBDZ39WxjROEAK5aRh
	PqXD2OWYie8a8pg0gdIOcr5Hdk5Y/zRMGvp0qmI4HU8+am+ZDlxkNuabfQCR0z/rasX5hPBuk5+
	i0w5uFbnJrlKbiEKpCZmO0pCTxD3N1If85musE6M/WmfWs3ub/fwJDefz1zIoSSZDeK/v2uRP89
	AWHJ8XkX3ZlpTg7cKSGxBUUX4zf7vkx2qRPBowkhIVONElmIud4gipf4wgCM6E74hMe/o0Utp3Q
	l4lpa+Xvgtx/ykgoqXvFvGIbyGZs3MOtbZuazhSVX7BgpHu1RnXOeh
X-Google-Smtp-Source: AGHT+IEIOBDfz+HBIHDphP6uzoI17aYjvF3ZSriDyVBLsupCrmaZDmFmWse/BayuXmJV7U9EbfA7ug==
X-Received: by 2002:a05:6000:2411:b0:427:928:789e with SMTP id ffacd0b85a97d-429bd6d583dmr12073376f8f.61.1762198150371;
        Mon, 03 Nov 2025 11:29:10 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c4af7c7sm175165915e9.7.2025.11.03.11.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:29:10 -0800 (PST)
Date: Mon, 3 Nov 2025 19:29:08 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, Guan-Chun Wu
 <409411716@gms.tku.edu.tw>, Andrew Morton <akpm@linux-foundation.org>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <20251103192908.1d716a7b@pumpkin>
In-Reply-To: <aQjxjlJvLnx_zRx8@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
	<20251103132213.5feb4586@pumpkin>
	<aQi_JHjSi46uUcjB@smile.fi.intel.com>
	<aQjxjlJvLnx_zRx8@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 20:16:46 +0200
Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Mon, Nov 03, 2025 at 04:41:41PM +0200, Andy Shevchenko wrote:
> > On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:  
> > > On Mon, 3 Nov 2025 19:07:24 +0800
> > > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:  
> > > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:  
> > > > > On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:    
> > > > > > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:  
> 
> ...
> 
> > > > > > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > > > > > for this code.
> > > > > >     
> > > > > > > This improves throughput by ~43-52x.    
> > > > > > 
> > > > > > Well that isn't a thing we see every day.    
> > > > > 
> > > > > I agree with the judgement, the problem is that this broke drastically a build:
> > > > > 
> > > > > lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
> > > > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > > > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
> > > > >    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> > > > >       |                  ^
> > > > > lib/base64.c:35:17: note: previous initialization is here
> > > > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > > > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
> > > > >    25 |         [0 ... 255] = -1, \
> > > > >       |                       ^~
> > > > > ...
> > > > > fatal error: too many errors emitted, stopping now [-ferror-limit=]
> > > > > 20 errors generated.
> > > > >     
> > > > Since I didn't notice this build failure, I guess this happens during a
> > > > W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
> > > > to my checklist before sending patches in the future. I also got an
> > > > email from the kernel test robot with a duplicate initialization
> > > > warning from the sparse tool [1], pointing to the same code.
> > > > 
> > > > This implementation was based on David's previous suggestion [2] to
> > > > first default all entries to -1 and then set the values for the 64
> > > > character entries. This was to avoid expanding the large 256 * 3 table
> > > > and improve code readability.
> > > > 
> > > > Since I believe many people test and care about W=1 builds,  
> > > 
> > > Last time I tried a W=1 build it failed horribly because of 'type-limits'.
> > > The kernel does that all the time - usually for its own error tests inside
> > > #define and inline functions.
> > > Certainly some of the changes I've seen to stop W=1 warnings are really
> > > a bad idea - but that is a bit of a digression.
> > > 
> > > Warnings can be temporarily disabled using #pragma.
> > > That might be the best thing to do here with this over-zealous warning.
> > > 
> > > This compiles on gcc and clang (even though the warnings have different names):
> > > #pragma GCC diagnostic push
> > > #pragma GCC diagnostic ignored "-Woverride-init"
> > > int x[16] = { [0 ... 15] = -1, [5] = 5};
> > > #pragma GCC diagnostic pop
> > >   
> > > > I think we need to find another way to avoid this warning?
> > > > Perhaps we could consider what you suggested:
> > > > 
> > > > #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> > > > 	[ 0 ... '+'-1 ] = -1, \
> > > > 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> > > > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > > > 	[ '9'+1 ... 'A'-1 ] = -1, \
> > > > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > > > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > > > 	[ 'Z'+1 ... '_'-1 ] = -1, \
> > > > 	[ '_' ] = val_under, \
> > > > 	[ '_'+1 ... 'a'-1 ] = -1, \
> > > > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > > > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > > 	[ 'z'+1 ... 255 ] = -1 \
> > > > }  
> > > 
> > > I just checked, neither gcc nor clang allow empty ranges (eg [ 6 ... 5 ] = -1).
> > > Which means the coder has to know which characters are adjacent as well
> > > as getting the order right.
> > > Basically avoiding the warning sucks.
> > >   
> > > > Or should we just expand the 256 * 3 table as it was before?  
> > > 
> > > That has much the same issue - IIRC it relies on three big sequential lists.
> > > 
> > > The #pragma may be best - but doesn't solve sparse (unless it processes
> > > them as well).  
> > 
> > Pragma will be hated.

They have been used in a few other places.
and to disable more 'useful' warnings.

> > I believe there is a better way to do what you want. Let me cook a PoC.  
> 
> I tried locally several approaches and the best I can come up with is the pre-generated
> (via Python script) pieces of C code that we can copy'n'paste instead of that shortened
> form. So basically having a full 256 tables in the code is my suggestion to fix the build
> issue. Alternatively we can generate that at run-time (on the first run) in
> the similar way how prime_numbers.c does. The downside of such an approach is loosing
> the const specifier, which I consider kinda important.
> 
> Btw, in the future here might be also the side-channel attack concerns appear, which would
> require to reconsider the whole algo to get it constant-time execution.

The array lookup version is 'reasonably' time constant.
One option is to offset all the array entries by 1 and subtract 1 after reading the entry.
That means that the 'error' characters have zero in the array (not -1).
At least the compiler won't error that!
The extra 'subtract 1' is probably just measurable.

But I'd consider raising a bug on gcc :-)
One of the uses of ranged designated initialisers for arrays is to change the
default value - as been done here.
It shouldn't cause a warning.

	David

> 
> > > > [1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> > > > [2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/  
> 


