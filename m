Return-Path: <linux-fscrypt+bounces-767-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A74D1B1155B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Jul 2025 02:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD7F6169F32
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Jul 2025 00:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A311465A5;
	Fri, 25 Jul 2025 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efp+kDyP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10EA2BAF4;
	Fri, 25 Jul 2025 00:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753404259; cv=none; b=YSDMVpLES8q6YKQH6FuezhraM0X7VNg0Vz8tZoTKs/4hzeAmbz6JMY8Y2AI1ZLeo44J58wJr4fiLozoQSahTi5SAL4ZPkRZ7jYDOwUoTu3cIJvLGsh27I6VCKaZIQGjTFtYiC4kY4LzpbL/HJwmrvyUcOGcX4IpehuaAft1o12c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753404259; c=relaxed/simple;
	bh=mBk99YiLp1Br0ZDSfftrqLBouFW4UBlTRwDDrmIRG/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qVx/IrZAKPMiPdnZBRzHt0DyaiwjTwqftIWg/NrGKO/HEEd2ihduEmQQ03c1qxZFuLctnNyu/teFkYBNL9uj+PmM23PbW6jeCguEwDh0vv2zJn27z/QhvoX+Xs8bDuzkeBakty/+09FmR9nR7lMxRPOYB9TdhMPvUuoiBtpGS24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efp+kDyP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17677C4CEED;
	Fri, 25 Jul 2025 00:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753404259;
	bh=mBk99YiLp1Br0ZDSfftrqLBouFW4UBlTRwDDrmIRG/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efp+kDyPCDTrbzqlBCApDdjaKGLT5QuopBCIsa9ouwpiTFNSxol5Eq3LDTagjJeY6
	 t2EHZ9PMdV5NxqPae16INwxApKAHh6ql4nRb3j3VcZVYzXnQgE8nfAqmVTOtVYS5an
	 d9KS448K3+TF7OhmciWraSJPa04egmwteBy6rLgz9y29fmAp6aSKgpamFxRJ2o53yx
	 geXOiahVTJAfZeADJCdaJA/ymWQpnjnMGEjJHRuwcDi0g7zC1IgHkR7qbjC55nY6KS
	 iqyx37CRhb3+uwWj0qKjf2a10nWHh5dVMUw593+eBK4H7Cd6RQ46QZbMbk3mAMuwxu
	 XALabhJetboHA==
Date: Thu, 24 Jul 2025 17:43:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH v4 14/15] fs: drop i_verity_info from struct inode
Message-ID: <20250725004329.GF25163@sol>
References: <20250723-work-inode-fscrypt-v4-0-c8e11488a0e6@kernel.org>
 <20250723-work-inode-fscrypt-v4-14-c8e11488a0e6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723-work-inode-fscrypt-v4-14-c8e11488a0e6@kernel.org>

On Wed, Jul 23, 2025 at 12:57:52PM +0200, Christian Brauner wrote:
>  static inline struct fsverity_info *fsverity_get_info(const struct inode *inode)
>  {
> -	if (!inode->i_sb->s_vop)
> +	/*
> +	 * We're called from fsverity_active() which might be called on
> +	 * inodes from filesystems that don't support fsverity at all.
> +	 */
> +	if (likely(!inode->i_sb->s_vop))
>  		return NULL;

!IS_VERITY().

Also the proposed comment is misleading, since fsverity_get_digest() and
bpf_get_fsverity_digest() similarly can call this on arbitrary inodes.

- Eric

