Return-Path: <linux-fscrypt+bounces-666-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4544DAD7766
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 18:03:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BC281880991
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 15:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D28248884;
	Thu, 12 Jun 2025 15:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kj3syDB7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAFE1B0416;
	Thu, 12 Jun 2025 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749743868; cv=none; b=YBVBbOfgsUnIZmknKmtpNWGTOjIKLY/kEf9gda5PfGm4hPIHrM6h+RbRHAOIY2L+cAyGU7PNI1q10q9HCmkAj0LZCq50ZFxKePdKUkE1IpithLZx1sQcUr+2lAON+8wW0jYHvtDy8w5JYDnqVWe7yKtdgZ1uoEXlczTxEKmUqlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749743868; c=relaxed/simple;
	bh=I+yj5RaeRFm4XV7nYay72iV3VtIk9fY58cl2ElhN9GY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOKhmzG43I3qO2lwg4hVwPF+3YhQShu0tpZ3mhYYGxZFT4eOaxkZxOkzqE6YmRg2AJR1ZriaMyqEAu7MwEgG+whGfGGRlUTTe0E85Cj7lRrlqizyG1PgwSmAdyiM2isWhXe8GHGk9QAo0+HOEnbyt0PTztQp4DDiLPhJvB1mZJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kj3syDB7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E397C4CEEB;
	Thu, 12 Jun 2025 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749743865;
	bh=I+yj5RaeRFm4XV7nYay72iV3VtIk9fY58cl2ElhN9GY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kj3syDB7EWGXmmPQEn6faQJJCP8Zx4/ZbWfx7JOkjzRF0b8VXypiFh+vqdaR8hl+p
	 ioh5TDwlCz6GFe+gIMxEfYVqfpLapRk1/3/fdNPt56AIGQrTtOVSuQlX6VXMXgbPgz
	 1H1mS98XcOEm0C/62bgT59L+f+uAFOvphLCOqS1N5Ff2+I9VbhNd/R7nmixjuliDT+
	 0ECTov3sUQ13ituxxnl50KKaOAe7VR/jHdHqVUmefGy91C/DN+y0FzI6a5iphvbODD
	 q/NVOs5UaO1MPd6POp4EdPrhAFHt+ixI/0LAvQGsIFBVVj8kPrXJc2LfkO+5YDX4IB
	 YlD+RzbQxcOtg==
Date: Thu, 12 Jun 2025 15:57:43 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Simon Richter <Simon.Richter@hogyros.de>, linux-fscrypt@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250612155743.GA3529549@google.com>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <aEqU0iU1tBrLEYUq@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEqU0iU1tBrLEYUq@gcabiddu-mobl.ger.corp.intel.com>

On Thu, Jun 12, 2025 at 09:50:26AM +0100, Giovanni Cabiddu wrote:
> On Wed, Jun 11, 2025 at 11:25:21PM -0700, Eric Biggers wrote:
> 
> ...
> 
> > FWIW, here's what happens if you try to use the Intel QAT driver with dm-crypt:
> > https://lore.kernel.org/r/CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com/
> 
> /s/happens/happened/
> 
> ... and it got fixed
> https://lore.kernel.org/all/20220506082327.21605-1-giovanni.cabiddu@intel.com/

But it reached users in the first place, including stable kernels.  And
apparently the issues were going on for years and were known to the authors of
the driver
(https://lore.kernel.org/linux-crypto/91fe9f87-54d7-4140-4d1a-eac8e2081a7c@gmail.com/).

We simply don't have issues like this with the AES-NI or VAES XTS code.

And separately, QAT was reported to be much slower than AES-NI for synchronous use
(https://lore.kernel.org/linux-crypto/0171515-7267-624-5a22-238af829698f@redhat.com/)

Later, I added VAES accelerated AES-XTS code which is over twice as fast as
AES-NI on the latest Intel CPUs, so that likely widened the gap even more.

Yet, the QAT driver registers its "xts(aes)" implementation with priority 4001,
compared to priority 800 for the VAES accelerated one.  So the QAT one is the
one that will be used by fscrypt!

That seems like a major issue even just from a performance perspective.

I expect this patch will significantly improve fscrypt performance on Intel
servers that have QAT.

- Eric

