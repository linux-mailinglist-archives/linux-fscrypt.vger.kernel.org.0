Return-Path: <linux-fscrypt+bounces-908-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 20915C2E452
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 23:33:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 51D0834AF20
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 22:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9121B2900A8;
	Mon,  3 Nov 2025 22:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uzi+TVBb"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25C2367B8
	for <linux-fscrypt@vger.kernel.org>; Mon,  3 Nov 2025 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762209181; cv=none; b=X1nJjHoD9Xg0HLO6STG1punaDha4edWPtlunQkEazzel4YY5wdUunH5Om4cVI11QTk7aFmcrY8EvFiMRmbgV206/Y61MUJ9pnQmLoL9UXYEdF3rUEeJzUA8HqaOR6Qv8cWLJjPrRiLjOhp+99pR/60r+LbjXmQPzczDWWnVu99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762209181; c=relaxed/simple;
	bh=ucVRbf+wTw4gEeS0lYnYs0f0LoZ0+GbkcH9eR8ZB+hk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lxmCUeVkNJILkdkF6ZCFA1MLGYXzMfQEQhnpf3hZido+ngIjkO8IyKGucDpdigWL9I4IUHiK2N3cYgE6b6wrqUxj5FpDit2/oakTWvIxjsCrypQo+V/PoOgi7xT2+ayJ91IH9giP6bvlnJglV6ESvr4ok7ZMBHyvjAt749ob6Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Uzi+TVBb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477549b3082so1269185e9.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 03 Nov 2025 14:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762209178; x=1762813978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UC87VmjlqhE8ixV0hmOfrgnisqW5ZkS1j7Z41QROyHU=;
        b=Uzi+TVBbpCgE3AhJGNuPVIfMCXsn4xCegKq0torOYHJjd+zE6IY0u92cFiyeUo4UH8
         ubjG9+v0xo0KVvbrcJJ+K2hHeyi9pw/e7MEukLwwIhhf7i0b4cyDsKgZXuj70qCZoKRh
         hAdKzUWvbngw7Xq76UzQLShwIjZXYIicq2faY1U+FAe88viQooGMRkCpwhG7QB0zSql5
         zhtZdc/MBqO1MJhV37yVvUN8nkpubPCWwzpa2DJOOjN8uZ2eroenGr9yuJ517pCJPko0
         lpH30OsJnAZIo4rFjSyGqbePPpYXB0McGzZtvZZpyTFQUX1/8MiaIaNcCoC8RmwJVVbh
         V3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762209178; x=1762813978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UC87VmjlqhE8ixV0hmOfrgnisqW5ZkS1j7Z41QROyHU=;
        b=wY93EHA4DOk9zkvwt0jsKUerHH6cf8c+p9aPLGjYSMixT3eAK9/9N9QgAgnxrA+BCQ
         VHOS7hpFTWBsSWLJGDvTT5C9LSuJVcxcuYlJSU7sr3z+tKYGwmvv07WejvdjRTK91ayX
         KhzUcEl8jl0lg+HaGzpxeaVyUtTDIoARdkcwoOO446Y5s38Qt5DdVcwzkykNfuoBnHLT
         dvqi2tGU+OfK896p1kcO1N+ERLYW4Jmk6w28DgSQ5ofJutDUYISWQAHGLxr+J7kt1JVm
         f+VWgSu7cZFPPfw6cxQcMmXsKxrncMVaz1unhAGxLzZKTVmtd9SUYiE2qjqFLJhduIWn
         8Mnw==
X-Forwarded-Encrypted: i=1; AJvYcCX9ZNSti3CMxAJjYGDgVwg36ML10KKwFiyfWvUDmf1eVG10PixJTihFZIlZ8z7IBcbqzRabUwnYZNe7N+Yq@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy0q8daZv3/LT2rkt8QfeqcRzusIAbUGDL7eFE2EIm2xAcBtgr
	FYsDYB/b8Qq4TR+KJS0b6zX7zza5cHKc8ejw3xgZ9mFvKawPX0YNFx7Y
X-Gm-Gg: ASbGncvn2wqGHt5UePGYvwB0CEo8+lZH8RToFrJlFcltWL1pR+KGkvV7QZSBpzksgLs
	6JKK4+q64VzP6YesyWEvQdDiqtcE7Hho+R4jA1RMPiD/VijVUxh/DTzkh7PU4d3wRH7xyiJvIIa
	LMiknyyjqO8jr+15+1FgujqMG6xLMOLSlGvehEQu5M9X2nbO1rAGav/qQVKa56AMuAhFN1yHSlj
	WPcO8JRTw7yclR4dsaYzTnQkkWnDomWLoRHQnH2Ur2NkTUQqA9sxDbw0c5yMrObSjoha0cyVG3L
	BsqSwNIXcqBgaWlCJlMEXIIFaeFCcioGSnuIgklnFxLh3vdhnNaQaS9D5IWhHWE9dhktF2bm+PG
	b7gLFC1djSO6kCMZ7z5o4IkEzj3bzbRupo20aVtFYjOFw2mjLepDMCKbI5HhkROd0ww+DyvQsCW
	UUwft8icibKR9rH6Z45WGJAJ2Rv/gVo0PZTMqU6tfHvw==
X-Google-Smtp-Source: AGHT+IFfkjzMjTqHnS48aZjcHtd5R1GU/wOXp/DRSahKGZnuUsfaydy8LykadRRj1SHbjISGDLOeSg==
X-Received: by 2002:a5d:5f95:0:b0:429:b7cd:47ff with SMTP id ffacd0b85a97d-429bd6a8e04mr12790816f8f.40.1762209177618;
        Mon, 03 Nov 2025 14:32:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1a8528sm1151043f8f.21.2025.11.03.14.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 14:32:57 -0800 (PST)
Date: Mon, 3 Nov 2025 22:32:55 +0000
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
Message-ID: <20251103223255.3de9f9d7@pumpkin>
In-Reply-To: <aQkEbZrabOzPBClg@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
	<20251103132213.5feb4586@pumpkin>
	<aQi_JHjSi46uUcjB@smile.fi.intel.com>
	<aQjxjlJvLnx_zRx8@smile.fi.intel.com>
	<20251103192908.1d716a7b@pumpkin>
	<aQkEbZrabOzPBClg@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 21:37:17 +0200
Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> On Mon, Nov 03, 2025 at 07:29:08PM +0000, David Laight wrote:
> > On Mon, 3 Nov 2025 20:16:46 +0200
> > Andy Shevchenko <andriy.shevchenko@intel.com> wrote:  
> > > On Mon, Nov 03, 2025 at 04:41:41PM +0200, Andy Shevchenko wrote:  
> > > > On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:    
> 
> ...
> 
> > > > Pragma will be hated.  
> > 
> > They have been used in a few other places.
> > and to disable more 'useful' warnings.  
> 
> You can go with pragma, but even though it just hides the potential issues.
> Not my choice.

In this case you really want the version that has '[ 0 .. 255 ] = -1,',
everything else is unreadable and difficult to easily verify.

> 
> > > > I believe there is a better way to do what you want. Let me cook a PoC.    
> > > 
> > > I tried locally several approaches and the best I can come up with is the pre-generated
> > > (via Python script) pieces of C code that we can copy'n'paste instead of that shortened
> > > form. So basically having a full 256 tables in the code is my suggestion to fix the build
> > > issue. Alternatively we can generate that at run-time (on the first run) in
> > > the similar way how prime_numbers.c does. The downside of such an approach is loosing
> > > the const specifier, which I consider kinda important.
> > > 
> > > Btw, in the future here might be also the side-channel attack concerns appear, which would
> > > require to reconsider the whole algo to get it constant-time execution.  
> > 
> > The array lookup version is 'reasonably' time constant.  
> 
> The array doesn't fit the cacheline.

Ignoring all the error characters it is 2 (64 byte) cache lines (if aligned
on a 32 byte boundary).
They'll both be resident for any sane input, I doubt an attacker can determine
when the second one is loaded.
In any case you can load both at the start just to make sure.

> 
> > One option is to offset all the array entries by 1 and subtract 1 after reading the entry.  
> 
> Yes, I was thinking of it, but found a bit weird.
> 
> > That means that the 'error' characters have zero in the array (not -1).
> > At least the compiler won't error that!
> > The extra 'subtract 1' is probably just measurable.  
> 
> > But I'd consider raising a bug on gcc :-)  
> 
> And clang? :-)

clang is probably easier to get fixed.
The warning can be disabled for 'old' compilers - only one build 'tool'
needs to detect errors.

One solution is to disable the warnings in the compilers, but get sparse
(which I think is easier to change?) to do a sane check that allows
the entire array to default to non-zero while still checking for
other errors.

> > One of the uses of ranged designated initialisers for arrays is to change the
> > default value - as been done here.
> > It shouldn't cause a warning.  
> 
> This is prone to mistakes when it's not the default rewrite. I fixed already
> twice such an issue in drivers/hid in the past few months.

I was thinking that if the first initialiser is [ low ... high ] = value
then it should be valid to change any value.
I'm not sure what you fixed, clearly [ 4 ] = 5, [ 4 ] = 6, is an error,
but it might be sane to allow any update of a 'range' initialiser.

	David


