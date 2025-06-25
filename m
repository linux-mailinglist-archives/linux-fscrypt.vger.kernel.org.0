Return-Path: <linux-fscrypt+bounces-679-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 211F3AE8CBD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 20:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59E7C4A734D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 18:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0492DAFC1;
	Wed, 25 Jun 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3gbLHlg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7129B2DAFBC;
	Wed, 25 Jun 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750876747; cv=none; b=WObQjS41eZj/mcgFUoajdZDsVKvKM/ZZhk2kxkmQDlJveM8e8dwhGeVqT5VvR/9KjCZl3BFGC5ha09petX0eJ2P9zu37icRaPZDHqAFbeLrhG96Xp38m3NF4PqP/KCHIoPHQDBBZG/1LFX/Z3NDTsna7MpwO8Z/HJzGzdHf/h+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750876747; c=relaxed/simple;
	bh=WRHYPzI57hddDK7CE8Wr1nJ8heCzKe+3hF0K0wP3ejc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F4vGnjV6QPXIxIpwTWjbZqcgnwDQAY6AY+6Ao/hPvv7l2tBubueTlvZ3QE+uBb7AxPRTnwvE+MIBA0ixAsK0RdirgrZUMGEF3mQ1v9diTl1+UDM9TJxsLEWyrGquPvY6yoiw9AhHUfwEhVegQl6WVK/GGBf2QqbAaqweVZ5/TZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3gbLHlg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3C0C4CEEA;
	Wed, 25 Jun 2025 18:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750876747;
	bh=WRHYPzI57hddDK7CE8Wr1nJ8heCzKe+3hF0K0wP3ejc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q3gbLHlg+Xr2KnUs3hglU2onJJoUGSlohkLlIO0HiHKEfzcHm7gbBX7ehcf6RPYV/
	 +lZdqAI4YsE3A8mHgnUfSM9Qr3Uqr4VhCyGtockNTKWG0+lc/YO91ybT2218qYd9B8
	 jOIucmU2Yi99l/8qd4aJIkS2fkjuIddv1w1bJOwL0xgoqCDcWZy9KQ2abe8KvHwn3Y
	 BpA+FSQrIB4THuqB3RMyQi/a0HkIxNqAHE5vcpF0mV4D0ZBT/g9VXKCrxMjPY5B9lC
	 SRv0AlpeaFxq62qgpTMg5AGtCYq6KdpB/doP2ovkMnfKnZJimNdBjGwPNThRlOjZ0r
	 N27ijJqi/rVSg==
Date: Wed, 25 Jun 2025 11:38:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Simon Richter <Simon.Richter@hogyros.de>, linux-fscrypt@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250625183831.GA1703@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <20250625063252.GD8962@sol>
 <20250625124445.GC28249@mit.edu>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625124445.GC28249@mit.edu>

On Wed, Jun 25, 2025 at 08:44:45AM -0400, Theodore Ts'o wrote:
> On Tue, Jun 24, 2025 at 11:32:52PM -0700, Eric Biggers wrote:
> > 
> > That was the synchronous throughput.  However, submitting multiple requests
> > asynchronously (which again, fscrypt doesn't actually do) barely helps.
> > Apparently the STM32 crypto engine has only one hardware queue.
> > 
> > I already strongly suspected that these non-inline crypto engines
> > aren't worth using.  But I didn't realize they are quite this bad.
> > Even with AES on a Cortex-A7 CPU that lacks AES instructions, the
> > CPU is much faster!
> 
> I wonder if the primary design goal of the STM32 crypto engine is that
> it might reduce power consumption --- after all, one of the primary
> benchmarketing metrics that vendors care about is "hours of You Tube
> watch time" --- and decryptoing a video stream doesn't require high
> performance.
> 
> Given that the typical benchmarketing number which handset vendors
> tend to care about is SQLite transactions per second, maybe they
> wouldn't be all that eager to use the crypto engine.  :-)
> 

My STM32MP157F-DK2 board (with screen removed) is pulling 1.5W regardless of
whether it's running the benchmark with the STM32 crypto engine or with the NEON
bit-sliced code.  However, the NEON bit-sliced code finishes 5 times faster.

- Eric

