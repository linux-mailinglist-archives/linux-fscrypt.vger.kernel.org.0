Return-Path: <linux-fscrypt+bounces-680-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01AA3AE8D2C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 20:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91B1D5A5EA2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 18:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484C92D9EC7;
	Wed, 25 Jun 2025 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfXX4gyz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9AD2D5415;
	Wed, 25 Jun 2025 18:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750877877; cv=none; b=fGKT2aVW0gqqwzbL+kEOZsVEfT745RWS7GsHRZNGN55AjMEaIZ5fXI9IwfT5ZwaQbmSeBAO5DPH4guiE5PbnoYn6PxGNG3tdBhnDqWlOec7ADgAJ3AeoPcjpEQEuqydDHcr60/1jzVFkyzcBM0Ygu2fU/4oGLjHE2sjjt7aQYK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750877877; c=relaxed/simple;
	bh=9dMCTDJZVMzbS/zBD503nWWVWKm2FovKnQMyh9fpcro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okQ7WTg+XMkAU2h4Noh3vqRaAp2X0m8IktTgCIjJ5IJVxuePsmgpH7fRSdKW6vGF2PBCN0tx924DFi6qR4fo8dib9zsfy22xAVQLxqKvdPVyEZxxQ3uEO/TGWfQDfCIsiQx5qrKJVSqB2hnJdMyliwJwg1xnh+COxAZjK1+V5k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfXX4gyz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47806C4CEF0;
	Wed, 25 Jun 2025 18:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750877876;
	bh=9dMCTDJZVMzbS/zBD503nWWVWKm2FovKnQMyh9fpcro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RfXX4gyzdrSzcJwCnXlcD7dGqdLurOrI0ukuDS2ni26iDSAkow3zKchchRI+UwGL1
	 CVKaafO3G5sw5GHlEXIh3Nd6XqMu1XckZgzUk0fTVra8Q6hu2OyuukS/LyKTM99iQ0
	 GU2vTn4zkFANEHPM7nlTTgGrUFfu7jYUY1z36LgXLui0nbyr5/AcWl2u2YAECr2NSc
	 NhAF455t2SLxIKM4WhoJQbgB2AKEVaCyIXCBcGKejkf6AvfaxoxjTBZWNaOA7ihAlm
	 rGX+iUEeloK2dGYQQToMRuwVDS6n9Jc0QxIW8RytzIg/Rs/1sFMntTZ5pnUBMgDuyL
	 pIg6KkFWyV51A==
Date: Wed, 25 Jun 2025 11:57:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Maxime MERE <maxime.mere@foss.st.com>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250625185721.GB1703@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <8f4c2f36-71af-4c84-bcee-2554cea991d0@foss.st.com>
 <20250613144239.GA1287@sol>
 <c1671c5e-d824-4131-861e-470d09371e05@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1671c5e-d824-4131-861e-470d09371e05@foss.st.com>

On Wed, Jun 25, 2025 at 06:29:17PM +0200, Maxime MERE wrote:
> 
> 
> On 6/13/25 16:42, Eric Biggers wrote:
> > Honestly, the responses to this thread so far have made it even more clear that
> > this patch is the right decision.
> 
> The chaining system I previously presented is just an example intended to
> demonstrate the value of hardware drivers in the context of ST platforms.
> 
> The key point is that our hardware IP allows us to securely embed encryption
> keys directly in hardware, making sure they are never visible or accessible
> from Linux, which runs in a non-secure environment. Our software
> architectures rely on a Secure OS running in parallel with Linux, similar to
> what is done on Android. This Secure OS is responsible for sensitive
> cryptographic operations.
> 
> This Secure OS can manages the keys with a dedicated hardware peripheral
> (SAES). The Linux side never sees the keys directly. Instead, the Secure OS
> prepares the keys and shares them securely with the cryptographic engine
> (CRYP) through a dedicated hardware bus.
> 
> This architecture improves security boundary: keys isolated from the
> non-secure Linux environment. But decryption can be processed by the linux
> kernel.

Can you please stop hijacking this thread with what is basically an irrelevant
marketing blurb?  The STM32 driver actually just stores the keys in memory.  See
stm32_cryp_ctx::key in drivers/crypto/stm32/stm32-cryp.c, and struct
stm32_hash_ctx::key in drivers/crypto/stm32/stm32-hash.c.

So even if the STM32 crypto engine technically supports hardware keys, the
potential benefits of that are not actually being realized in Linux.

And for applications like fscrypt that derive a large number of keys, it isn't
actually possible to use hardware keys even if the driver supported it, without
key wrapping and proper integration with the key hierarchy.  (FWIW, the
hardware-wrapped inline encryption keys feature does do that, but that is very
different from what we're talking about here.)

Also, the STM32 driver does not actually fully support any of fscrypt's file
contents encryption modes.  It does support AES-256-ECB and AES-128-CBC, so it
can be used for AES-256-XTS and AES-128-CBC-ESSIV when the CPU handles the XTS
masking or IV encryption respectively.  But to do that, the CPU needs access to
part of the secret keys.

- Eric

