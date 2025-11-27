Return-Path: <linux-fscrypt+bounces-994-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2394BC8C99C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 02:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 257884E1EEA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 01:53:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B68F2192F4;
	Thu, 27 Nov 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMO45soF"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4F1E1A17;
	Thu, 27 Nov 2025 01:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764208415; cv=none; b=Sx3FNurcm68SFwOr1QhWyt1xuuUBMrBNnE0nG4OC4PTgtC+ePmeeO27LK9Ktwm3I5gJyMwFYSAuIKhwUjECHhGy58vywwOXc05Fh7syDTcR0gAprDRI+B/LgTkDem51foiEha21AtXiJ+iFCzcayk7suUcEbaNHqxh5i46K5Zas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764208415; c=relaxed/simple;
	bh=gV/ScPBZZNk5yz68ysPFBc/JvaoRbOE0FWA+8mjBR7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dfFdxrERCYGhOpRyCifvuY1afeguHwNVzn/cHg/ptFNT8NdVxy+60ssQfNq1NgMIsQkbxO9+wAlOLox93GaDQ8CGj+By7OXQnmEGozmseGng5TzLOXPLst9TpRO1cgbkNQM6EBUh75B4NEUlTWTcdk2pNFQ9SLyDqV3iYVJXXF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMO45soF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FC1C4CEF8;
	Thu, 27 Nov 2025 01:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764208415;
	bh=gV/ScPBZZNk5yz68ysPFBc/JvaoRbOE0FWA+8mjBR7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pMO45soFRSoHAqiA2BJCz2rFuUl/XQATA2O21WYKVy5uw3/wGwsyjB222dV/3ulIw
	 yTuPriCn8BaZMc1yBtfEhVh2PyGcBSH1BpCDiNF5th/eYEez4cS46lq/B9tavGSHbq
	 to0OPAz5P/bJkmtxjxfu05Awqem4w5r3dM5mGMGU4Zw2xzk8tONwPcqc/o7DUZMUPO
	 /YGdGzH74g8UXzWj6Q/7Lnklwio8Q8f7uZmv+vqZ0C1M4Zz7ks5yyX9xThav3f86BX
	 T3a26jfs8MdI+FJmTOk9RuD6EKeuzLfVCtt72rWhDec1yeli/9EbddICskaxR0Ts/8
	 B2Lgxeu4t2HYw==
Date: Wed, 26 Nov 2025 17:51:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH RFC] crypto/hkdf: Fix salt length short issue in FIPS mode
Message-ID: <20251127015141.GA29380@sol>
References: <20251126134222.22083-1-litian@redhat.com>
 <20251126174158.GA71370@quark>
 <CAHhBTWuOy1nC1rYqye8BzE+unoC+3M9Dsw+Mj54=3eeFwqyTXw@mail.gmail.com>
 <20251127011446.GA1548@sol>
 <CAHhBTWsTqP3LzJV+=_usvttJcMFoLYSY5Sqt2H-U-oki3Hu0Mw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhBTWsTqP3LzJV+=_usvttJcMFoLYSY5Sqt2H-U-oki3Hu0Mw@mail.gmail.com>

On Thu, Nov 27, 2025 at 09:24:43AM +0800, Li Tian wrote:
> > Why do you think the salt needs to be at least 32 bytes?
> 
> Forgive my inaccuracy. Under FIPS, salt needs to be at least the hash length
> (32bytes for sha256 and 64bytes for sha512) because NIST requires that the
> HMAC key used in Extract has *full security strength*. 32 is just the
> number I
> tested with.
> 
> Li Tian

It seems that you're confusing the salt with the input keying material.
The entropy for the key comes from the input keying material.  The salt
is a non-secret value that usually is just set to all-zeroes.  In fact,
both users of HKDF in the kernel just set it to all-zeroes.

- Eric

