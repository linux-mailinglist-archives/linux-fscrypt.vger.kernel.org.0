Return-Path: <linux-fscrypt+bounces-670-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13939AD8FE1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 16:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D6EB3A1E3D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 14:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C911DE4CA;
	Fri, 13 Jun 2025 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpFPf1B0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EBC19CD0B;
	Fri, 13 Jun 2025 14:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749825787; cv=none; b=snnfulKvSVUJZHtjWkwMgVBQsrXraPmqTsnntheDGvzmssQ8/2vvl5INUq4OZS1w3jYhztR4qAn6IVEykc5DT6QXmdTTISyJISZeyIzN5uPMgB9WbRHHLdjcV8PTWPfkh99h2xNRolaLCLGuEgufu3G5HZmHQ+435UprgahASqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749825787; c=relaxed/simple;
	bh=X8uCzsD5itqoI7POYg9wvCv44Y1Bhh9aSVeaZS08ftY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fciH7g8cN8LxkNsg5qXrGfrZQWbFmdlV3DfvBpKx5vykjaRK1YYdX3rTuyt0TUPMg32eCc2mi7iDTiXFLdCl7Z+Iqay+FKihwjYqGhllE9Mu4O2l20Df8d89TfzcXkp2wWIYIIztjLZ5qmbDCW4huZnVW+Lcs2SpBVhWjuWYMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpFPf1B0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40697C4CEE3;
	Fri, 13 Jun 2025 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749825786;
	bh=X8uCzsD5itqoI7POYg9wvCv44Y1Bhh9aSVeaZS08ftY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cpFPf1B01lZLa94UVQa51/VgBj9RwtCQJaDlD3SVGhwXzEGZYdDlaAcrCnvBSQri7
	 9DNPosHAUVOyrQMIbBB/+2Wjlt+ohCPB/fNLZk9Q9MK4uf3fMpdAqz2An/+VcoUyuX
	 xKHKE1bm45MNSEB8bBx2L8WTP1QSY8pnf1lkhFMeMCcomHCxZl3A9uBXRB8jHsJjbs
	 9IkOmrjHo4lZU7OafX32/ep8bZb8Mp/wowKzwXA/DF1zUYwF5qBR7tCgJKUp9eSzUx
	 K8fUOcYr8aBDNj2Y1dVSRMJgqyx/oJy1V4XkrJ4m94l2lylSW2dTEnDF+6knaZvHE8
	 U80TOWjguDBUg==
Date: Fri, 13 Jun 2025 07:42:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Maxime MERE <maxime.mere@foss.st.com>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250613144239.GA1287@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <8f4c2f36-71af-4c84-bcee-2554cea991d0@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f4c2f36-71af-4c84-bcee-2554cea991d0@foss.st.com>

On Fri, Jun 13, 2025 at 11:01:03AM +0200, Maxime MERE wrote:
> Hello,
> 
> On 6/11/25 22:58, Eric Biggers wrote:
> > To protect users from these buggy and seemingly unhelpful drivers that I
> > have no way of testing, let's make fscrypt not use them.  Unfortunately
> > there is no direct support for doing so in the Crypto API, but we can
> > achieve something very close to it by disallowing algorithms that have
> > ASYNC, ALLOCATES_MEMORY, or KERN_DRIVER_ONLY set.
> 
> I agree that software drivers are more efficient and less prone to bugs than
> hardware drivers. However, I would like to highlight the fact that certain
> ST products (the STM32MP2x series) have features that allow the loading of a
> secret key via an internal bus from a Secure OS to the CRYP peripheral
> (usable by the kernel). This enables cryptographic operations to be
> delegated to the non-secure side (the kernel) without exposing the key.
> 
> If fscrypt no longer supports hardware drivers, then this type of
> functionality could not be used, which I find unfortunate because it is
> something that might interest users.

What?  fscrypt doesn't support that anyway, and there isn't any path forward to
supporting it in a way that would actually improve security.  (Considering how
fscrypt's key derivation etc. works.)

fscrypt does support hardware wrapped *inline encryption* keys, which is
actually designed properly and does work.

Honestly, the responses to this thread so far have made it even more clear that
this patch is the right decision.

- Eric

