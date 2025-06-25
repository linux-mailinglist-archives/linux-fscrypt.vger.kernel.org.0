Return-Path: <linux-fscrypt+bounces-675-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C12E2AE7722
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 08:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A0421BC0F11
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 06:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF0551DE4E1;
	Wed, 25 Jun 2025 06:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bgakoUfA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C718A6C4;
	Wed, 25 Jun 2025 06:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750833207; cv=none; b=q0Mtvqg49RjpPKy1CdxWbcdX9NfASH7u8UH4hkzttNpRqH1NpytXWJ37LyN9BePeb2N+XJ2Kgwq28Fc1plGTKaZfLLkt9RTNDJElQq0q8GaUDO6XKA3jrYgakE/lSMV8kXAN8JKiVTUQl1u+fkK4Fmue0p51KQQaK/ihAEpRz9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750833207; c=relaxed/simple;
	bh=KvBZdCVe3bjcds3toNzSaotNrJRp/h1SfSaoHVQtlow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TrXVgB4LgvkYBGSgSYUjJp/+4VJK5bEka0fU3lDXN8fMWcLIyhiN45JWFTwI+Is1TCVmXmcg/DwaokWmNkiRaQ8mCAylvk3vKgxgzyjdzKisS0se4DCq9U2ujylgThLVk7jA+G6iVvkswxPYKgA4TnLC2I4e2Wq3vnP3BZWv/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bgakoUfA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B4DC4CEEA;
	Wed, 25 Jun 2025 06:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750833207;
	bh=KvBZdCVe3bjcds3toNzSaotNrJRp/h1SfSaoHVQtlow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bgakoUfAtI3aZ6TL8fY22KKltCf5IxNhnzJ2oiyuuI/GEIHZVXnwJ10tWdkSvPitL
	 /7bgjo9d0xQe1/8gpM9TBWDxFi/Ea0rEL81mSYagOjUKrHIXs7lqZdbBqzmHFzyv8u
	 ZWO+dWfZgHmJ/TMTmP0277ODQYtrlhMqpajvswJ8zCCo09C9Bj7uSHR7SGVz+9SwGl
	 KSwIFk6u+iudkaHqeTJb2dbajWY0742z1b6HWGCzoj5/myPz3cCTRLT7guhEKxa1Ue
	 qWBczEoXOLdeLmUv9Qp8JOrF2q6gevGPPGRKDXQ/LfFR2ZmiDmtFXt9weQocqTrCp1
	 Hz6xQ9sygvLRQ==
Date: Tue, 24 Jun 2025 23:32:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250625063252.GD8962@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612062521.GA1838@sol>

On Wed, Jun 11, 2025 at 11:25:21PM -0700, Eric Biggers wrote:
> On Thu, Jun 12, 2025 at 12:59:14AM +0000, Eric Biggers wrote:
> > On Thu, Jun 12, 2025 at 09:21:26AM +0900, Simon Richter wrote:
> > > Hi,
> > > 
> > > On 6/12/25 05:58, Eric Biggers wrote:
> > > 
> > > > But
> > > > otherwise this style of hardware offload is basically obsolete and has
> > > > been superseded by hardware-accelerated crypto instructions directly on
> > > > the CPU as well as inline storage encryption (UFS/eMMC).
> > > 
> > > For desktop, yes, but embedded still has quite a few of these, for example
> > > the STM32 crypto offload engine
> 
> By the way, I noticed you specifically mentioned STM32.  I'm not sure if you
> looked at the links I had in my commit message, but one of them
> (https://github.com/google/fscryptctl/issues/32) was actually for the STM32
> driver being broken and returning the wrong results, which broke filename
> encryption.  The user fixed the issue by disabling the STM32 driver, and they
> seemed okay with that.
> 
> That doesn't sound like something useful, IMO.  It sounds more like something
> actively harmful to users.
> 
> Here's another one I forgot to mention:
> https://github.com/google/fscryptctl/issues/9
> 
> I get blamed for these issues, because it's fscrypt that breaks.

Since two people were pushing the STM32 crypto engine in this thread:

I measured decryption throughput on 4 KiB messages on an STM32MP157F-DK2.  This
is an embedded evaluation board that includes an STM32 crypto engine and has an
800 MHz Cortex-A7 processor.  Cortex-A7 doesn't have AES instructions:

    AES-128-CBC-ESSIV:
        essiv(stm32-cbc-aes,sha256-arm):
            3.1 MB/s
        essiv(cbc-aes-neonbs,sha256-arm): 
            15.5 MB/s

    AES-256-XTS:
        xts(stm32-ecb-aes):
            3.1 MB/s
        xts-aes-neonbs:
            11.0 MB/s
            
    Adiantum:
        adiantum(xchacha12-arm,aes-arm,nhpoly1305-neon):
            53.1 MB/s

That was the synchronous throughput.  However, submitting multiple requests
asynchronously (which again, fscrypt doesn't actually do) barely helps.
Apparently the STM32 crypto engine has only one hardware queue.

I already strongly suspected that these non-inline crypto engines aren't worth
using.  But I didn't realize they are quite this bad.  Even with AES on a
Cortex-A7 CPU that lacks AES instructions, the CPU is much faster!

But of course Adiantum is even faster, as it was specifically designed for CPUs
that don't have AES instructions.

- Eric

