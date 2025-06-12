Return-Path: <linux-fscrypt+bounces-663-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA48AD64D5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 02:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F3D216E044
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Jun 2025 00:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E346BFC0;
	Thu, 12 Jun 2025 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kn8RsBx4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D585C2F4317;
	Thu, 12 Jun 2025 00:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689957; cv=none; b=JSLesiVdJlQwnVtoeGrW4y0utTyRPHs4KRweGF6y4K1NrdT9j2B6dqglxwgsFX4Gp0wxZxHUtQR9DAGYYJV/dnhSgP639LK9Dl+D5orlVhe+exbJEu/FNp3/KyoThQOxVCb49hkhSTcK3TIaMeRnQCvr+t2pbVVSy8gB/coD+Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689957; c=relaxed/simple;
	bh=1pLf5bk/3PFIluwpReZ5mviAqg4CGwb1cCQQmcLw6f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIUcNo8EPpZbg+GEz8duEG5ZDuJpiw5PEcQYZMWJbv066LjKHthuNCFIMrIIJWxdu9o5VayG+uEHYJuWj7NgKmEYPiAnqFat5xNmjYX+vibSCl1NyoFmA6Kpiw2qKnvBrAL+xEhEJ/eUiY3XULCBW4LvACitNM01Ikk0qSM7/yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kn8RsBx4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03066C4CEE3;
	Thu, 12 Jun 2025 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749689956;
	bh=1pLf5bk/3PFIluwpReZ5mviAqg4CGwb1cCQQmcLw6f0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kn8RsBx4W5wwKgjX2bn2GPL7w7pbuxS4bXmDFzdgWA+KONs14NmKhmdJn+9//1d2a
	 U2/Kgaq61LJNRw8jMvkf4uuYNdcYZYbu5E+O60TZXvsvNQ7wT7YrPZUrelkhOW+wAN
	 Xy4kBVI1wepj/dFanHYyWK6/6/i0/d1i+/QhVo9b/rG0Xb9jNoDgkijJvYExFr7dwj
	 Y6UevZfed66WMmM3EFdMAmC1ngqx06O96BHAbNL6wlbVp6LW3w7GkeJKZz9M+LSMyL
	 WAnmQ488J49VwokEuqF6q/94k3A/56jKE7K5zazfC8qQE2LLdby/S/Sdex/T3xWbx8
	 ZwyP9Yt+uFe7A==
Date: Thu, 12 Jun 2025 00:59:14 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Simon Richter <Simon.Richter@hogyros.de>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250612005914.GA546455@google.com>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>

On Thu, Jun 12, 2025 at 09:21:26AM +0900, Simon Richter wrote:
> Hi,
> 
> On 6/12/25 05:58, Eric Biggers wrote:
> 
> > But
> > otherwise this style of hardware offload is basically obsolete and has
> > been superseded by hardware-accelerated crypto instructions directly on
> > the CPU as well as inline storage encryption (UFS/eMMC).
> 
> For desktop, yes, but embedded still has quite a few of these, for example
> the STM32 crypto offload engine, and I expect quite a few FPGA based
> implementations exist, so this would require vendors to maintain a fork to
> keep their out-of-tree drivers functional when updating the kernel.
> 
> POWER also has an asynchronous offload engine with AES, SHA and gzip
> support, these are significantly faster than the CPU.

Do you know if anyone is actually still using a legacy-style accelerator with
fscrypt, and if so what specific performance improvements are they getting?

Arguing that legacy-style crypto acceleration could theoretically be useful in
general isn't really relevant here.  What's relevant here is whether it's
actually useful and worthwhile with this specific kernel subsystem.

As I mentioned, fscrypt has never been optimized for legacy-style accelerators
anyway, and no one has ever tried to do so.  It just hasn't been relevant.

Meanwhile, the real feedback I *do* get from users is that these drivers are
causing problems for users, since the Crypto API (unwisely) enables them by
default and thus fscrypt uses them by default.

There are people who do care about some of these drivers, but they tend to be
the manufacturer of the hardware, not the users.  To me it seems like more of a
check-box exercise than something that is actually worth using in practice.

> If a buggy engine passes self-test, can this simply be fixed by adding more
> tests? :>

The crypto self-tests are disabled by default, just like any other kernel
subsystem.  They are supposed to be run before a kernel is released, but for
most of the drivers they aren't, since people don't have the hardware.  Thus, a
lot of drivers in-tree don't even pass the tests we do have.

Some distros do enable the crypto self-tests in production kernels, but only the
fast tests; the full set of tests is too slow to enable in production.  But even
the full tests don't properly test the hardware offload drivers, which have
unique challenges that do not exist in software code.

- Eric

