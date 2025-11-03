Return-Path: <linux-fscrypt+bounces-902-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A38E5C2C110
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 14:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5ECB04E27BC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 13:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A6D23AE66;
	Mon,  3 Nov 2025 13:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cbI0vP1O"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A345323EAB7
	for <linux-fscrypt@vger.kernel.org>; Mon,  3 Nov 2025 13:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762176140; cv=none; b=cIPCClC7KTysLpA6NzD6l1l+GRLDLSAsPzxZu5aVpUBmLHTRYBbU9XufJlJlfTnQj+ziI1iNJc9NqveG1ddn9vEYfUb1S3X81r9qu3A01mu4AbyEQDeQ3RlArH+2OXyou2TBRNFniikgrqawGLsLlf0o62qXElZZLoRlGJO8I3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762176140; c=relaxed/simple;
	bh=vTCp1c6K07tuYqBXiIVPzUAUBSikRxyELemYd1Cs2TM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DOJ3Ltahx5kbTXwNeRBj4wsvN49JOo/xGbeW5SOrb1/a6p18mPPYbsT+E8T0g3DFfIjktTkzB6PS8pQJA8FhZWdQF0Yg/Epe7b2mGMizjT0dHXHdM+dxhu6Q5i/uNPQ3k2NM3BsPsEfBt4PDm8BuseIZ0wfhlM+/oRqwVL5AeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cbI0vP1O; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4711b95226dso56307275e9.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 03 Nov 2025 05:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762176137; x=1762780937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oU/T5nNyfq8t3z/6aX8Pq77WNXNGQPZda7D2dIXoYg=;
        b=cbI0vP1OWpABJ8KWd65QMDHSyxkdmJQJpDtCCa2GHG0rGx4sDoMZqDcSnTX42bl3nN
         M3SyhTUeImN6MzTq5dgr41m7/zZmMdpqeteASCB1GLxenWeWz8lGPP7yL3nXrIdo8aNf
         zOvADI2hvv8suZGA4FsIvhiFk/8awfuZ6CoFfYVn5ub1Jcn1mGUAwKcL/mqjcEvMGi+m
         iU4exRRP99u3GShAwlAb6OmbgLY/d66rSx2eFMEWy05hIHtzm64SM0+fVTsm8XalGooJ
         fKQ0NR7G3e9JlelLFIDB39gQNfZbUv5BEvB3ZyQRFgL57lvK3lFNrkoStU1EvK7UbV0c
         pqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762176137; x=1762780937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6oU/T5nNyfq8t3z/6aX8Pq77WNXNGQPZda7D2dIXoYg=;
        b=EDErmC5uh1eu2rH2NSCFax3DoxtDzEAq7sN0OwE7xFNHB0+BK6y87Juirpp2lGH3G7
         ltFiBoFcqgY/jaDJ6eLUyM37+gVGW03HnkStFbQM7x6lIL03f17co24Pw8LqANK8h5Le
         snWvAD0UjCqNl6XwgX0ljUX0Qqm91KuPaCyIG7Wf9pkgOKYytusVRvEn/iul/73xMjXf
         gfBUBwdyjytfkKJoiKjVM8tb4CUBKgEawdjBoTU/79OIuibra2KLik8yZlAABcn3Re2+
         c9Zr3w/JxmL3GD+UP9jb3ThYug4L0Wfw6PXWJhu3gHlpEz5vxVcUG7HTCcrPfVCKA0CX
         CbMg==
X-Forwarded-Encrypted: i=1; AJvYcCXoISvHE1pXzMxs4tzLB+ssBZyXxqDMbOszNjjnVBFl5YR7xjG5NtKS7uT9oU0y0Y8oZLz6N7jbEFgrqs84@vger.kernel.org
X-Gm-Message-State: AOJu0Yx39hSbB3x01V3nn9980mH/mhIWUXRvZXYb/QOFPne479ut4Bjr
	iBem9onZstD9AbhEC79jrwL1/EOxmfVBC3ky6vq5eZlYx4P8jATacX6X
X-Gm-Gg: ASbGncs7BxvWowIoT/8no0LeqbsMSvdd817Yyt/+iQDyoaQl+4VFl/i3AFRThwLOuJ8
	pGE3o7VQmDMZhcHGbx9M060m1BmbW59gpMbu618nErytshgg5zmbklxr7F/aXANIZ3cCj3fgk1o
	HbNnYN7VIhlRALAN96fJ0w+4Vv/B1otaOnpUXMYPKFI8qIYqkS0V1NRHo2jaeBSv8a6YVfyt2nW
	hKCMuBpKCmtxlb79SiNZT8Rii1gTwm40pdD9mh5OMZEEvVi7TjXypU6qNHXEbo9IgZJ1hVeI2f7
	rKruinCwj4jVDToSl5abXKFdik6oD3TXr4LnA/wAwVvW6JEg9qZJOWWGirL11DjL51Y0G00nw4e
	xZp46ehObeUImmKG3GzTNj7ORv5Sqc604uD+RaKPu92xsswhjFw1MMExePSs2AO5/PBfYM4ax88
	JyeeHgnnsTs3Lsxk61XeXAb8E2dnV7HWTTLRJvMl5QAHatZUfINWTz
X-Google-Smtp-Source: AGHT+IGmfb0M4Cm7RDj+H+Xzo+z1lsCQ6IyOZoyheCRQy3wOXge1WeLvunZiTMuWXTbYqWvedDGTjw==
X-Received: by 2002:a05:600c:530e:b0:477:1bb6:17e5 with SMTP id 5b1f17b1804b1-47751697433mr13329465e9.30.1762176136522;
        Mon, 03 Nov 2025 05:22:16 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c110e77esm20067573f8f.10.2025.11.03.05.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 05:22:15 -0800 (PST)
Date: Mon, 3 Nov 2025 13:22:13 +0000
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
Message-ID: <20251103132213.5feb4586@pumpkin>
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
> > On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:  
> > > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > >   
> > > > This series introduces a generic Base64 encoder/decoder to the kernel
> > > > library, eliminating duplicated implementations and delivering significant
> > > > performance improvements.
> > > > 
> > > > The Base64 API has been extended to support multiple variants (Standard,
> > > > URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
> > > > a variant parameter and an option to control padding. As part of this
> > > > series, users are migrated to the new interface while preserving their
> > > > specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
> > > > and NVMe is updated to BASE64_STD.
> > > > 
> > > > On the encoder side, the implementation processes input in 3-byte blocks,
> > > > mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
> > > > streaming and reduces loop overhead, achieving about a 2.7x speedup compared
> > > > to previous implementations.
> > > > 
> > > > On the decoder side, replace strchr() lookups with per-variant reverse tables
> > > > and process input in 4-character groups. Each group is mapped to numeric values
> > > > and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
> > > > rejecting invalid '=' usage and enforcing tail rules.  
> > > 
> > > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > > for this code.
> > >   
> > > > This improves throughput by ~43-52x.  
> > > 
> > > Well that isn't a thing we see every day.  
> > 
> > I agree with the judgement, the problem is that this broke drastically a build:
> > 
> > lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
> >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
> >    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> >       |                  ^
> > lib/base64.c:35:17: note: previous initialization is here
> >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
> >    25 |         [0 ... 255] = -1, \
> >       |                       ^~
> > ...
> > fatal error: too many errors emitted, stopping now [-ferror-limit=]
> > 20 errors generated.
> >   
> Since I didn't notice this build failure, I guess this happens during a
> W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
> to my checklist before sending patches in the future. I also got an
> email from the kernel test robot with a duplicate initialization
> warning from the sparse tool [1], pointing to the same code.
> 
> This implementation was based on David's previous suggestion [2] to
> first default all entries to -1 and then set the values for the 64
> character entries. This was to avoid expanding the large 256 * 3 table
> and improve code readability.
> 
> Hi David,
> 
> Since I believe many people test and care about W=1 builds,

Last time I tried a W=1 build it failed horribly because of 'type-limits'.
The kernel does that all the time - usually for its own error tests inside
#define and inline functions.
Certainly some of the changes I've seen to stop W=1 warnings are really
a bad idea - but that is a bit of a digression.

Warnings can be temporarily disabled using #pragma.
That might be the best thing to do here with this over-zealous warning.

This compiles on gcc and clang (even though the warnings have different names):
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Woverride-init"
int x[16] = { [0 ... 15] = -1, [5] = 5};
#pragma GCC diagnostic pop

> I think we need to find another way to avoid this warning?
> Perhaps we could consider what you suggested:
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

I just checked, neither gcc nor clang allow empty ranges (eg [ 6 ... 5 ] = -1).
Which means the coder has to know which characters are adjacent as well
as getting the order right.
Basically avoiding the warning sucks.

> Or should we just expand the 256 * 3 table as it was before?

That has much the same issue - IIRC it relies on three big sequential lists.

The #pragma may be best - but doesn't solve sparse (unless it processes
them as well).

	David

> 
> [1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> [2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/
> 
> Regards,
> Kuan-Wei


