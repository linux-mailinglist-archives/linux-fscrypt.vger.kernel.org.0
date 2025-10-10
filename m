Return-Path: <linux-fscrypt+bounces-870-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B4ABCE808
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 22:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F81319A667F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 20:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91FC24BBF0;
	Fri, 10 Oct 2025 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grMAhxX1"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87ADC1DDC33;
	Fri, 10 Oct 2025 20:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760128779; cv=none; b=V+0cPbTMN9zDLzM/BhnDlmeCE1h/QyWRzWYKe1RwJwE+1G3ZqZAkZgBjgA3zRTIps/asqMMFwTNt5xKc1wZVfo86n6lV6ayCVqzGk9mklqkrcqPE6rav82RlHzQZN1AKx/um2TP6yTvvDOVPwyiOkvTt0JPv1+nVK6WIok0S1Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760128779; c=relaxed/simple;
	bh=23QQchZn74OhbikjpJXXcj/0fhyi1s4y231R27LUpzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFtP2nrFsY4YLiqAxyPIAOPfnHi3NyTkVR8H+TTQG2QtBrLdBqf5+AIiu0+aRi6Dze6afHPyHhv5j3NnKcShr0CcGhRuxal/acSsxmQVR2Oe+IsSFKgfMZiD7wyr1bsKS9QY91020wmIJDVh+7+nqTEWfNnTPazL/jnD9u0qhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grMAhxX1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6495C4CEF1;
	Fri, 10 Oct 2025 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760128779;
	bh=23QQchZn74OhbikjpJXXcj/0fhyi1s4y231R27LUpzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grMAhxX1/IMkXmvN/KTFayDf9a5qX4x+eOd6D13ZFiyX7LpV41whughu8vkEflqUc
	 NSQc+tzXKv3dIzQuOxiu660Paich0bb16Y9Lw46DxIXxVRL0z+WN/PbJOmEYr4zLmo
	 zHk1nzmRdjX6xwhp3PLx2yiUInoA8Uda94XFTfkeD+vVKUc347LgzmKF6HY09vBph5
	 Z3p+wv9XBhnR3Cmmp2AKAvc2lAQyRq9tAzhB4Zaf0sk6wrw98m79VtycxYOs4lLh1L
	 jeOMyxdR6DjBxPUalaVWN3ZO3MK/KJfadSPlP5rfmOgds0NinmqjJkdWE9yR89L+JO
	 f4vyA2SR4nwLQ==
Date: Fri, 10 Oct 2025 13:39:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Divya Bharathi <divya27392@gmail.com>
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
	corbet@lwn.net, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: fscrypt: document EFAULT return for
 FS_IOC_SET_ENCRYPTION_POLICY
Message-ID: <20251010203937.GC2922@quark>
References: <20251010154753.19216-1-divya27392@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010154753.19216-1-divya27392@gmail.com>

On Fri, Oct 10, 2025 at 09:17:53PM +0530, Divya Bharathi wrote:
> Signed-off-by: Divya Bharathi <divya27392@gmail.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 4a3e844b7..26cb409e3 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -729,6 +729,8 @@ FS_IOC_SET_ENCRYPTION_POLICY can fail with the following errors:
>    version, mode(s), or flags; or reserved bits were set); or a v1
>    encryption policy was specified but the directory has the casefold
>    flag enabled (casefolding is incompatible with v1 policies).
> +- ``EFAULT``: an invalid pointer was passed for the encryption policy
> +  structure
>  - ``ENOKEY``: a v2 encryption policy was specified, but the key with
>    the specified ``master_key_identifier`` has not been added, nor does
>    the process have the CAP_FOWNER capability in the initial user
> -- 
> 2.51.0
> 

Thanks for the patch!

I think I omitted EFAULT intentionally, since it's always a possibility
for almost any ioctl or syscall that takes a pointer parameter.

If we'd like to explicitly document it, it probably should be documented
for all the ioctls in fscrypt.rst, rather than just
FS_IOC_SET_ENCRYPTION_POLICY.

Also, the list of error codes is alphabetized.  EFAULT should go into
the correct position in the list.

- Eric

