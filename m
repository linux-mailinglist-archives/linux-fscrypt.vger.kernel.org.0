Return-Path: <linux-fscrypt+bounces-664-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09623AD67F8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 08:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B8393AE1CA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 06:25:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37271F1538;
	Thu, 12 Jun 2025 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKL18zga"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A518211F;
	Thu, 12 Jun 2025 06:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749709547; cv=none; b=rx68tkwBttmXHVtMPoQrKTlPioYm7yKcpPWExQ/1wa82NjL62wyvISO5ULjItgvihERT8YvOo9neEfErwJdY3jDR02rkqPcm44CSwZL408O6JZxR7cdyak2ttKthKkyYoQ7lvMwcwWc9sWE5Gpu1VI269e2OV/Z/stdkpj156wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749709547; c=relaxed/simple;
	bh=M9CxTHdXT5WrEkUahJ2svzM+9WFZHYH6PnfsJfmp96g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Djh84M6tZ0v+3ps2c5Krk/3p82KW9ugH6QqAXm3tV6Ijt/r9O+8EUyMXBYY6T7z79YFdO8piN+5p6UCp2vfQahE/n421kkSpjhB9RAHHnKeTsfym0uGMr21EvqyP4gEmnmja9MX/8JGudaWULcDsOij6e29uODz861xIlI3r0sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKL18zga; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C556AC4CEEA;
	Thu, 12 Jun 2025 06:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749709547;
	bh=M9CxTHdXT5WrEkUahJ2svzM+9WFZHYH6PnfsJfmp96g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JKL18zgaAsvyau0vg8RznAF41pnRn29ke6AvxA2D7Mw7V5apl+KttEkVoHd6d/tnL
	 Tuo1iauSla5SB1LKgm+CI852NO9cSM9ti1JUQsc/o7dMziPmdWh9ZdbdQ2+TqECf72
	 tKe6h029giSgUjLMox+O2hYJKhtS6lMpSEfXLsJfJnNduiMUk/nc06zKPQ6Xuo/CLw
	 gDfzldMCEdbHvb9VdubI943kkJgzbIHMo9wMyw6AZYo1x8aI4EOPR+sgVoGrwCPBtm
	 IjKOYTe5ai8875DlouqZWShNo2Danpn8JLN4tG1KOtY8p69UDDT8P0t64FjMsOusx5
	 x4gCYIr9ucEUA==
Date: Wed, 11 Jun 2025 23:25:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250612062521.GA1838@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612005914.GA546455@google.com>

On Thu, Jun 12, 2025 at 12:59:14AM +0000, Eric Biggers wrote:
> On Thu, Jun 12, 2025 at 09:21:26AM +0900, Simon Richter wrote:
> > Hi,
> > 
> > On 6/12/25 05:58, Eric Biggers wrote:
> > 
> > > But
> > > otherwise this style of hardware offload is basically obsolete and has
> > > been superseded by hardware-accelerated crypto instructions directly on
> > > the CPU as well as inline storage encryption (UFS/eMMC).
> > 
> > For desktop, yes, but embedded still has quite a few of these, for example
> > the STM32 crypto offload engine

By the way, I noticed you specifically mentioned STM32.  I'm not sure if you
looked at the links I had in my commit message, but one of them
(https://github.com/google/fscryptctl/issues/32) was actually for the STM32
driver being broken and returning the wrong results, which broke filename
encryption.  The user fixed the issue by disabling the STM32 driver, and they
seemed okay with that.

That doesn't sound like something useful, IMO.  It sounds more like something
actively harmful to users.

Here's another one I forgot to mention:
https://github.com/google/fscryptctl/issues/9

I get blamed for these issues, because it's fscrypt that breaks.

FWIW, here's what happens if you try to use the Intel QAT driver with dm-crypt:
https://lore.kernel.org/r/CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com/
https://lore.kernel.org/r/0171515-7267-624-5a22-238af829698f@redhat.com/

- Eric

