Return-Path: <linux-fscrypt+bounces-74-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBED80B686
	for <lists+linux-fscrypt@lfdr.de>; Sat,  9 Dec 2023 22:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 511DB1F21049
	for <lists+linux-fscrypt@lfdr.de>; Sat,  9 Dec 2023 21:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC1681CAA2;
	Sat,  9 Dec 2023 21:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R82/Bplq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08D21804D;
	Sat,  9 Dec 2023 21:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0554EC433C8;
	Sat,  9 Dec 2023 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702157380;
	bh=enCUt3M3djVROs6vqIrAQpW2GmD+0gM0t0LR46XBsh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R82/Bplq6CAp1nCStIcs1hX0A4dsqGZeaJI2AYCPwVoPa0uFrYBJrBVtH/ZNHje8k
	 VBFbJfQ1/sAK0TMxGRIW/jRp5sOy0f4+fJzPW335RPlHVY8hEDwykI4YV+zmTlo1Pc
	 GMWBiTIFmi+R2N/yPpf1EbRdtOUnmPUzbpQka7TnViUGtZG5sHxfUl3kGB/Hn6/Ttf
	 Vs/K4OLGZyVN3stchVFUSz1F2bTOY18onCC8gS6bk9bTHXuxlFe68qOhs7sQngYyKU
	 sev/K5c+uIPJAxUQA5mnGs/VNGDMdWEAWvMs7AhgCUJn9dIdOBZeP+gSWCoPsxsF7u
	 JPal5vMFoi7Vg==
Date: Sat, 9 Dec 2023 13:29:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] fscrypt: move the call to fscrypt_destroy_keyring() into
 ->put_super()
Message-ID: <20231209212938.GA2270@sol.localdomain>
References: <20231206001325.13676-1-ebiggers@kernel.org>
 <ZXAW1BREPtCSUz4W@infradead.org>
 <20231206064430.GA41771@sol.localdomain>
 <ZXAf0WUbCccBn5QM@infradead.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXAf0WUbCccBn5QM@infradead.org>

On Tue, Dec 05, 2023 at 11:16:33PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 05, 2023 at 10:44:30PM -0800, Eric Biggers wrote:
> > There are lots of filesystems that free their ->s_fs_info in ->put_super().  Are
> > they all wrong?
> 
> Wrong is the wrong word :)
> 
> For simple file systems that either don't use block devices, or just
> the main one set up by the super.c code using ->put_super is perfectly
> fine.  Once a file system does something complicated like setting up
> their own block devices, or trying to reuse super blocks using custom
> rules it basically has to free ->s_fs_info  in it's own ->kill_sb
> handler.  This whole area is a bit messy unfortunately.
> 

btrfs releases its block devices in ->put_super(), so with your proposal that
would need to be moved to ->kill_sb() as well, right?

I guess I'm a bit concerned about introducing a requirement "->put_super() must
not release the block devices" which seemingly didn't exist before.

- Eric

