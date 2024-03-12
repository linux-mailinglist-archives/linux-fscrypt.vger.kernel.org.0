Return-Path: <linux-fscrypt+bounces-245-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56428878D60
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 04:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 057851F22246
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 03:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2E1945A;
	Tue, 12 Mar 2024 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTrInd9g"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893D3944D;
	Tue, 12 Mar 2024 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710212835; cv=none; b=SdZ5+B0rQfe6mZwK3krc7yxPhmp5kIJ4i8nCAShFeQXtYpXkR6DzW/pdSaJd7eyTXT83AQzf/xNYKko/mQNHc3IPtFEBb0uzgLflvAvYZZjEpalXOxVafwrALNBeN5qeLc8ORkmxse+CUFh8qWX0PUyDQuZRMBac4E1uQgexZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710212835; c=relaxed/simple;
	bh=ytfRXWxS21AEFMuYcnSijS3Mxzg7KMVx/T5YQr2suZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y31POpR8nFoVxLfq6JQPqzUI079JpQnQvBGx4jWxXLOG96eoeztEOCJZkn1s8YmaDCHT7lsmALOEeVBgOworrSS0jB9D2tNxXI1eCsknnmNDdnmCv0zCb4y4VnUOjrd4SqNbbHO6n6hstkbuy0kzTa7f820D3+TWnF0n8160oUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTrInd9g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916FBC433F1;
	Tue, 12 Mar 2024 03:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710212835;
	bh=ytfRXWxS21AEFMuYcnSijS3Mxzg7KMVx/T5YQr2suZI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sTrInd9g9mRdwLnEinw9+JlkJL8fino7b0pt2kuqwA31AMvCBt3SlSZCymztrnk/o
	 dCwJIKRTmzm3yse18G7gZ9YJsILW34zAVzxiGHCXjp86l5/p1RT8QJ73CCxVIswphn
	 B/CkZWPUmts3N5PmOFW1h0UQcfvz1Zqu8ZVzVetuW3eJPkV24zQxzsmuQyrTUFf/0v
	 PkEq4fcGX5ThURmPQ/pHP9BLHR/NR2e/0njk5IboPaUryGZKTDHOLF+Nf7VhobMaA4
	 WPtrIzG8qSBxf9AVzDIzcNws1aB173V2O7MXTiUxM2iPBp+enlp12o1kn4vkv1oJCK
	 6BeGxoIYJwUdQ==
Date: Mon, 11 Mar 2024 20:07:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
	serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
	linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via
 LSM hook
Message-ID: <20240312030712.GF1182@sol.localdomain>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312025712.GE1182@sol.localdomain>

On Mon, Mar 11, 2024 at 07:57:12PM -0700, Eric Biggers wrote:
> 
> As I've said before, this commit message needs some work.  It currently doesn't
> say anything about what the patch actually does.
> 
> BTW, please make sure you're Cc'ing the fsverity mailing list
> (fsverity@lists.linux.dev), not fscrypt (linux-fscrypt@vger.kernel.org).

Also, I thought this patch was using a new LSM hook, but I now see that you're
actually abusing the existing security_inode_setsecurity() LSM hook.  Currently
that hook is called when an xattr is set.  I don't see any precedent for
overloading it for other purposes.  This seems problematic, as it means that a
request to set an xattr with the name you chose ("fsverity.builtin-sig") will be
interpreted by LSMs as the fsverity builtin signature.  A dedicated LSM hook may
be necessary to avoid issues with overloading the existing xattr hook like this.

- Eric

