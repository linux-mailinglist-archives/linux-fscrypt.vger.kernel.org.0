Return-Path: <linux-fscrypt+bounces-681-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DA3FAE8E57
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 21:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FCBD4A311B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Jun 2025 19:17:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B0062DAFA9;
	Wed, 25 Jun 2025 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zj7hSevz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585051DE3A4;
	Wed, 25 Jun 2025 19:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750879057; cv=none; b=nuJhWSPZ5YCRahXU3w80fgdB6DcjuU2IdX1DHNzysarFy3q5uX7r6c0KrjKsT0gqqCOOObmacqRp13rZJuPRpeEtWoUQuxzVp/zSWmq1FzOv9275xYmasX/7q71dn8SKsv6dev9QHGMO/xsaskvy7K6AnPwHvps7PDiHqaGmy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750879057; c=relaxed/simple;
	bh=e6mdajjaaY5koL3e5Crmq60SgZT4vYU/Wk5mcE5cq1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nw3traYNo8u9iCpnyLSfJnBOrLt7+rUvEDPryV/Lr/UN10RUdTrQ7qzMHJaBM8MweJz7F63ckncpt4XPLEHmJoEQ63G6Y2NxkdTdYZExLqTyMcWSepwc09AZ6fygm6Dff+QU78voq02fqhDpad7EtEoZjBf/q6+8iMdJVWlMhGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zj7hSevz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9715BC4CEEA;
	Wed, 25 Jun 2025 19:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750879056;
	bh=e6mdajjaaY5koL3e5Crmq60SgZT4vYU/Wk5mcE5cq1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zj7hSevzFjb9nv0J7kpQsGJy2uqoqv/HX/Syg50/I+VKdIlWz5Ct06R68BfydP4ak
	 OWofz6fZdZ8o7zke1xi9L5JvMnkTnsC3vwwqSBEfYLWUou+uyuewdc5mMWeu6svGz3
	 aPPPpk9Vk1YTFlDIfry6lPaJoEa2oA7lMLFXRvq3CNoK1o6DEC/PoVOeU2/8Ucha9F
	 ZTIrHr0nU/srtYm5KMh+ysaprYtF48Rf6HpnyQ3kYKeGGFldsA1l3p2OuUU1qcYalT
	 +8pfDNBZGj2cUuvB7BLrG1tPmX5idHxcgBGuqvy2SVh9zltJRM+3Y0M8tGAgF0uasH
	 4GSjy+3D9tS6g==
Date: Wed, 25 Jun 2025 12:17:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Maxime MERE <maxime.mere@foss.st.com>
Cc: Simon Richter <Simon.Richter@hogyros.de>, linux-fscrypt@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250625191701.GC1703@sol>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <20250625063252.GD8962@sol>
 <f174540e-4b9a-4dc1-9ab8-f4f36fe1f837@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f174540e-4b9a-4dc1-9ab8-f4f36fe1f837@foss.st.com>

On Wed, Jun 25, 2025 at 06:29:26PM +0200, Maxime MERE wrote:
> Hi,
> 
> On 6/25/25 08:32, Eric Biggers wrote:
> > That was the synchronous throughput.  However, submitting multiple requests
> > asynchronously (which again, fscrypt doesn't actually do) barely helps.
> > Apparently the STM32 crypto engine has only one hardware queue.
> > 
> > I already strongly suspected that these non-inline crypto engines aren't worth
> > using.  But I didn't realize they are quite this bad.  Even with AES on a
> > Cortex-A7 CPU that lacks AES instructions, the CPU is much faster!
> 
> From a performance perspective, using hardware crypto offloads the CPU,
> which is important in real-world applications where the CPU must handle
> multiple tasks. Our processors are often single-core and not the highest
> performing, so hardware acceleration is valuable.
> 
> I can show you performance test realized with openSSL (3.2.4) who shows,
> less CPU usage and better performance for large block of data when our
> driver is used (via afalg):
> 
> command used: ```openssl speed -evp aes-256-cbc -engine afalg -elapsed```
> 
> +--------------------+--------------+-----------------+
> | Block Size (bytes) | AFALG (MB/s) | SW BASED (MB/s) |
> +--------------------+--------------+-----------------+
> | 16                 | 0.09         | 9.44            |
> | 64                 | 0.34         | 11.43           |
> | 256                | 1.31         | 12.08           |
> | 1024               | 4.96         | 12.27           |
> | 8192               | 18.18        | 12.33           |
> | 16384              | 22.48        | 12.33           |
> +--------------------+--------------+-----------------+
> 
> to test CPU usage I've used a monocore stm32mp157f.
> here with afalg, we have an average CPU usage of ~75%, with the sw based
> approach CPU is used at ~100%
> 
> Maxime

fscrypt is almost always used with 4096-byte blocks, which in my benchmark took
about 1300 μs each with AES-128-CBC-ESSIV w/ STM32 engine, 264 μs each with
AES-128-CBC-ESSIV w/ CPU, or 77 μs each with Adiantum w/ CPU.  The CPU-based
times seem short enough that there isn't much time for another task to be
usefully scheduled while waiting for each block.  It's important to consider (a)
driver overhead, (b) scheduling overhead, and (c) the low instructions per
second of this processor in the first place.

By the way, the board I have (STM32MP157F-DK2) is actually multi-core.  It seems
this is common among ST's offerings that are intended to run Linux?  (Of course,
the microcontrollers that don't run Linux are another story.)

- Eric

