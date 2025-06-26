Return-Path: <linux-fscrypt+bounces-682-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A0D6AE9415
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Jun 2025 04:37:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4396F1C2762B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Jun 2025 02:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F361F8AD3;
	Thu, 26 Jun 2025 02:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5khl0MZ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62F1F5828;
	Thu, 26 Jun 2025 02:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750905425; cv=none; b=cfu47cwqjP6mBj/Yj8PGL9nPbxPeBYy8LHdzssAWKkUsF02mnUbPkHzKwE481DEc7KFbJ+p85TPUwwldtoQ/9TfNl67xo1je3bYqseQO+2J9mXloHFM1WpI/D0FGNX1cjlLFffBy7HU9gPS8B9cKClVRNk4pPRZWM+z451DTrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750905425; c=relaxed/simple;
	bh=3JMG6iB8TJvIJcGTwj3LS7AOTxOpDIfMUVTPuJlJB1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkiMFP23rCTekDqivtAGhR6huFQn4fscOv0sbu6lyEsrrqyZK9JYHZ5n2aHarjHetEp37VE6XsZ8CM9XzyXkdLFyJAPsQ7w7VkjIODYxeRnf78onDqCJnRYAufevfq6Qtqs/wGkmHCqFgU2u8RrMH/jThjV8QFWdtfI/8Wsk7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5khl0MZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BE1C4CEEA;
	Thu, 26 Jun 2025 02:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750905424;
	bh=3JMG6iB8TJvIJcGTwj3LS7AOTxOpDIfMUVTPuJlJB1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q5khl0MZs0YrWvdZchwUX1U8I1eBplhj+0tYpxr8rentRjTAoVs7bPlp+FAbfTRvL
	 JhCVPANA5DFDFgLXppQGBuXsjHW7Xz7xWcK709Ocg2i1mh1rJyUgd601mvbHuidnOs
	 J988JDLYvhXyk48jfkHfr9MRohCkHot3o8lP0zemiipe4KzF9cFFy42mBjU+DsGfHq
	 O69fJjbacyWap17eWJ+Grp8TQ/miRrSE6LaMds95gGAynho5fbgUfqKzSvfhd6EExi
	 uvpSKAP/X3v6eXj9pxZTQA2xDOoqO19oLIYkdNjy7/Ij3KwUmEdHlwUSHVxEc19mOf
	 p7iABbX9Eblrw==
Date: Wed, 25 Jun 2025 19:36:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Maxime MERE <maxime.mere@foss.st.com>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250626023629.GA4797@sol>
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
> Regarding robustness and maintenance, ST ensures regular updates of its
> drivers and can fix any reported bugs. We have conducted internal tests with
> dm-crypt that demonstrate the proper functioning of these drivers for this
> type of application.

In addition to the bug I mentioned earlier where the STM32 crypto driver
produced incorrect ciphertext (https://github.com/google/fscryptctl/issues/32),
the following fix shows that the STM32 crypto driver computed incorrect hash
values for years (2017 through 2023):

    https://git.kernel.org/linus/e6af5c0c4d32a27e

While these bugs may be fixed now, they show a serious lack of testing.  They
also show that these sorts of drivers are really hard to get right.

I absolutely do not want fscrypt using anything like this.  I want the crypto to
be done correctly.

(And also efficiently, which clearly these offloads don't actually do either.)

BTW, it seems all the hardware offload crypto drivers have quality issues like
this.  I gave other examples in the thread, for example the Intel QAT driver
causing data corruption.  So my intent isn't to single out the STM32 driver per
se.  (And of course this patch applies to all drivers.)  I'm just responding to
STM32 because of the people pushing it in this thread for some reason.

- Eric

