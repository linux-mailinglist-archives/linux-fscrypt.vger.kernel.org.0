Return-Path: <linux-fscrypt+bounces-667-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86CFCAD803E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 03:24:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 060503A6DE7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 01:23:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8FD1A23AD;
	Fri, 13 Jun 2025 01:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sopL9OVG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9A572636;
	Fri, 13 Jun 2025 01:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749777841; cv=none; b=U1Runc3y8i8mp62AZIMIjfJYAE16vImdaPFawYPMOeQ+rqrIlv+WVYYTvW7F9KL6JI+6TcyLE3WAHYO+/paExGgfgA/EQGGOP3ETAAMQZDnxe+HEQMDdV8+BOmqahhwjCi59UafrBQ7oi+I/SS37xu8mgBKHaI4Dm1bRTPqlOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749777841; c=relaxed/simple;
	bh=d5rHizoOE6yeSiQobFd52hpxfVk2+AkiKtye4xkZZNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpwcVB8zufKDpRNDoDXfUC6y6crnuQHpNOjxTu2YXtwGE90mX924g12vEPr+KtvUWUOQay0yBU7caYQNu5A7JxW1OUhFO9Y5GTDlymZRJwF9mlD8Mhy70hRpv5rxOvFTncZ7lWq5yWFu1BmMesjpMhgDivgeF+55+yMElTCRcoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sopL9OVG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4CEC4CEEA;
	Fri, 13 Jun 2025 01:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749777840;
	bh=d5rHizoOE6yeSiQobFd52hpxfVk2+AkiKtye4xkZZNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sopL9OVGaKkYBLoQ9K0Gx3mNqKCtmF6HeqAxRPeMFvJLOQNPGNCCbdfRxS2LlfLqu
	 C3Drs4Qu4cFQG2+79qNVN/2U+Mp5r2Ku8fHrvgJywco1pbYG6PtA3ImiR1O4x08klz
	 xDAF1Jfb3fKbHGBJ+46TYP3cVpNrl19/EEmKclh0GQCX86o255XF08PT4Rd7b6JjMQ
	 0pZk7pLaqF1Q6YqyMWUL0yY5F1li1Q6ACzRmSrSgpQrt8hIvANSSWWinXiguz6euWJ
	 eocxM+zUeCV/S4k5Ycq56kPx+45/tXS3yhtnvX35hipDpMVHslTEwlPdsTCo0NKkoz
	 V/KcVAfBqnyXg==
Date: Fri, 13 Jun 2025 01:23:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Simon Richter <Simon.Richter@hogyros.de>, linux-fscrypt@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250613012357.GA3603104@google.com>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <aEqU0iU1tBrLEYUq@gcabiddu-mobl.ger.corp.intel.com>
 <20250612155743.GA3529549@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612155743.GA3529549@google.com>

On Thu, Jun 12, 2025 at 03:57:43PM +0000, Eric Biggers wrote:
> On Thu, Jun 12, 2025 at 09:50:26AM +0100, Giovanni Cabiddu wrote:
> > On Wed, Jun 11, 2025 at 11:25:21PM -0700, Eric Biggers wrote:
> > 
> > ...
> > 
> > > FWIW, here's what happens if you try to use the Intel QAT driver with dm-crypt:
> > > https://lore.kernel.org/r/CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com/
> > 
> > /s/happens/happened/
> > 
> > ... and it got fixed
> > https://lore.kernel.org/all/20220506082327.21605-1-giovanni.cabiddu@intel.com/
> 
> But it reached users in the first place, including stable kernels.  And
> apparently the issues were going on for years and were known to the authors of
> the driver
> (https://lore.kernel.org/linux-crypto/91fe9f87-54d7-4140-4d1a-eac8e2081a7c@gmail.com/).
> 
> We simply don't have issues like this with the AES-NI or VAES XTS code.
> 
> And separately, QAT was reported to be much slower than AES-NI for synchronous use
> (https://lore.kernel.org/linux-crypto/0171515-7267-624-5a22-238af829698f@redhat.com/)
> 
> Later, I added VAES accelerated AES-XTS code which is over twice as fast as
> AES-NI on the latest Intel CPUs, so that likely widened the gap even more.
> 
> Yet, the QAT driver registers its "xts(aes)" implementation with priority 4001,
> compared to priority 800 for the VAES accelerated one.  So the QAT one is the
> one that will be used by fscrypt!
> 
> That seems like a major issue even just from a performance perspective.
> 
> I expect this patch will significantly improve fscrypt performance on Intel
> servers that have QAT.

I was curious, so I actually ran a benchmark on an Intel Emerald Rapids server.
Specifically, I used a kernel module that repeatedly en/decrypted 4096-byte
messages with AES-XTS using crypto_skcipher_en/decrypt().  That's basically what
fscrypt's file contents encryption does, but here I just measured the raw crypto
performance.  I tested both xts-aes-vaes-avx512 and qat_aes_xts.  For both, the
difference between encryption and decryption was within the margin of error, so
I'll give just one number for each.

Results:

    xts-aes-vaes-avx512: 16171 MB/s
    qat_aes_xts: 289 MB/s

So, QAT is 55 times slower than the VAES-optimized software code!

It's even slower than the generic C code:
     
    xts(ecb(aes-generic)): 305 MB/s

Now, it could be argued that this is user error -- I "should" have created lots
of asynchronous crypto requests for 4K blocks, submitted them all at once, and
waited for them to complete.  Thus allowing parallel processing by QAT.

But, that's simply not what fscrypt does.  And even if it did, it could only
plausibly help for large bios.  Short bios, for which latency is really
important, would continue to be massively regressed by using QAT for them.

Even for large bios, it would have to get over 55 times faster to be worth it,
which seems (very?) tenuous.

Also, as is known from dm-crypt which does do async processing, the code that's
needed to do it is quite complex and error-prone.

In any case, async processing would be a theoretical future improvement.  It's
simply not what fscrypt does today, or has ever done.

I also found that, even though I built the QAT driver as a loadable module, it
was loaded automatically on the system and prioritized itself over the VAES-
accelerated AES-XTS.  Thus, it would be what fscrypt uses on Intel servers where
the QAT driver is enabled in kconfig, even just as 'm'.

Even disregarding the historical data corruption issues with QAT, I think this
makes it *very* clear that the QAT driver is harmful to fscrypt users.

And I've seen similar results with the Qualcomm crypto engine
(https://lore.kernel.org/r/20241203180553.16893-1-ebiggers@kernel.org/).
So this isn't even unique to this particular accelerator either.

This has gone on for long enough.

- Eric

