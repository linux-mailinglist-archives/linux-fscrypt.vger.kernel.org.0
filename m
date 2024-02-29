Return-Path: <linux-fscrypt+bounces-208-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7882A86D374
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 20:42:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18EDE1F227F7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 19:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105D213442D;
	Thu, 29 Feb 2024 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbp5jW+R"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B053BA5F;
	Thu, 29 Feb 2024 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709235761; cv=none; b=DKEYePfN2YpmXqwyoR6Ax/H4pWtm7wGUZrPgEj4253ApBwRoVKto62nn963VPRtApLPel1B9nxWJXg/wWkUobYrYlOMbIEmiO5ns17eNSUQXvgkYZ2fUc5wjej9qbsSpyK1TjEDOM7hKxv7d4LArZqx++lMqnnOqN3HDduNq5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709235761; c=relaxed/simple;
	bh=Vi1OV6mPnbivI3QcfryhhIDSyDsUvv3NuubcSwFHfrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPRSMVmsNVorhVdFUunqQ6itnMnwyU+z8vp4gt6dhIHEq0+isCXO6DPZzJDfLHr9JGtiNyqzDGKf2xC6gQBe9V+LPaAIj1P9fsK/BEg8Ma9vmqU9rlHWSWdr+8Z5lDf8JspBu51mb7Uznt1dAZxC6TTEaY7+VkvORYuWB7ZmcJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbp5jW+R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892BBC433C7;
	Thu, 29 Feb 2024 19:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709235760;
	bh=Vi1OV6mPnbivI3QcfryhhIDSyDsUvv3NuubcSwFHfrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbp5jW+RbWM6tOj49M04q1npx8OYdVRYu90kwphtII1yEQ8sD23lUYszEQOhJ3XS6
	 kco9VUDO+T7GP7PMq9LqMid3f1dsyrAqf7QtBRZ25hfm9yyfhhccISC5d9APB1NZn3
	 qOgJH6OmC/7qWfpeCOd4Ui2XTnf5LFu6YVjUXUtwPDztMOVpnXV8NKsrABhDTi/Wfj
	 7OBjYEJUSp8yQJ1C6jZZqd5fdaz2R8kGCqVSDWS1B7HsAZHAdVGWzGvaV2zuVlD0rJ
	 HwTPoMm3wIiPh+M2EyA93AOYY0mPCqdK3t4cwyr4Gyv4VWY7iP3xmkZaH1P0QHz4h+
	 40oN5y8eCz5QA==
Date: Thu, 29 Feb 2024 11:42:37 -0800
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
Subject: Re: [RFC PATCH v13 17/20] ipe: enable support for fs-verity as a
 trust provider
Message-ID: <20240229194237.GA1454@sol.localdomain>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>
 <20240229044625.GA1946@sol.localdomain>
 <b73e3387-558f-4f40-8741-c6ed7965b25f@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b73e3387-558f-4f40-8741-c6ed7965b25f@linux.microsoft.com>

On Thu, Feb 29, 2024 at 10:59:21AM -0800, Fan Wu wrote:
> > 
> > So IPE is interested in whether a file has an fsverity builtin signature, but it
> > doesn't care what the signature is or whether it has been checked.  What is the
> > point?
> > 
> > - Eric
> 
> It does make sure the signature is checked. This hook call can only be
> triggered after fsverity_verify_signature() succeed. Therefore, for files
> that are marked with the security blob inode_sec->fs_verity_sign as true,
> they must successfully pass the fsverity_verify_signature() check.
> 
> Regarding the other question, the current version does not support defining
> policies to trust files based on the inner content of their signatures
> because the current patch set is already too large.
> 
> We plan to introduce new policy grammars to enable the policy to define
> which certificate of the signature can be trusted after this version is
> accepted.

Ah, I see, you're relying on the fact that fsverity_verify_signature() verifies
the signature (if present) even if fs.verity.require_signatures hasn't been set.
That does happen to be its behavior, but this isn't clearly documented since
there previously wasn't really a use case for the builtin signatures without
setting fs.verity.require_signatures.  Can you please make sure this behavior is
documented properly in Documentation/filesystems/fsverity.rst and in function
comments?  Otherwise I worry that it could get changed and break your code.

- Eric

