Return-Path: <linux-fscrypt+bounces-4-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 293BF7EDE26
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Nov 2023 11:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6183280F3C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Nov 2023 10:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4282D2942C;
	Thu, 16 Nov 2023 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJaExwT0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1644BEAD4;
	Thu, 16 Nov 2023 10:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2F9C433C7;
	Thu, 16 Nov 2023 10:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700129062;
	bh=uIPRvuOccneeBtO3/9hRvyi7Ye1E1xX4yxPtxFdSS1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VJaExwT0OjsGuDC4xKVoWQ4hoI0j76mrFOPXoZGSAugFDHJpNWJqwS7jgnQjNlUCv
	 JLKMQMoeEZngiMkm7GwxMsfBHV9PScoEcIqG/yMdmPmaSc35mWkErWIcpnK5IGVmbS
	 4Cs6oBRCxCByuCoaqfqKnYOSgozuPI7L9t6EV/Ut1FGac5vgg5b06PH5IoxVVYTK+H
	 XDPpWEZdDgYHhYSYGkLRdYcrWOhbJpEkW1oOZq7bnb1VkvmChIJR1GBxuUtR4Z/b4L
	 I9lw/uH5yR4v2opFaSf8sEXM76PVtj5Jvnys/dqSZctxwTgbkE1agV0tZOY4Zl0bTj
	 vqnNdeEUthPag==
Date: Thu, 16 Nov 2023 11:04:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data
 unit size
Message-ID: <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>
References: <20231013062639.141468-1-ebiggers@kernel.org>
 <KMvmogj9a91wwFViEyqlFQPlIuusUrW4mllNMHHZWBgZzBLAzrSJ2c93ZZyLh7bh4tkBI-JTjQZ6LJrGHubXcQ==@protonmail.internalid>
 <20231116035846.GA1583@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116035846.GA1583@sol.localdomain>

On Wed, Nov 15, 2023 at 07:58:46PM -0800, Eric Biggers wrote:
> On Thu, Oct 12, 2023 at 11:26:39PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
> > exercising the log2_data_unit_size field that is being added to struct
> > fscrypt_policy_v2 (kernel patch:
> > https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).
> >
> > The xfs_io support is needed for xfstests
> > (https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
> > which currently relies on xfs_io to access the encryption ioctls.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  configure.ac          |  1 +
> >  include/builddefs.in  |  4 +++
> >  io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
> >  m4/package_libcdev.m4 | 21 +++++++++++++
> >  man/man8/xfs_io.8     |  5 ++-
> >  5 files changed, 84 insertions(+), 19 deletions(-)
> 
> Hi!  Any feedback on this patch?

I've got a limited bandwidth these days, I'll try to review this sometime
around next week.

> 
> - Eric

