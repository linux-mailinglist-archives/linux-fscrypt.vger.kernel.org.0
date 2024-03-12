Return-Path: <linux-fscrypt+bounces-244-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A92A8878D42
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 03:57:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F907B2235E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 02:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E448BFA;
	Tue, 12 Mar 2024 02:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuJToceU"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865888BE7;
	Tue, 12 Mar 2024 02:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710212235; cv=none; b=AO+O3VmLnXtO5gNkobO7OrmJQ9SWpJe7ioIKZmoMArl8Z1fhyfg42Ij+fTheo/N6qZF3WZpEkBXiscdMVvRSeWbNA2sqrod/gyRLW1T8stAn39mc2+1z31b7kvqWQg3AEWWEWMjt+5xH970+8hGczac2vMXLq3mKv89SPKYUcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710212235; c=relaxed/simple;
	bh=JuGozl3Rp1HWn76gH4B/w7ED+gwkYd5CwT5FVvVs2ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jK6UG5kDibzvw4RiRbzYdLI/E+6OBUGFyV08ergbiy6g1zID+ud7+t3eOpGuOal9iESyY3rJPoF9kIImexzACj2N5j4Vtbr8TuiaR0PE4hNZzf6nSCx1kptbVhFp/cusxEs+RGt9JQbWBNq5SFgW5DtfB2jwfnX5bMmxJfBngeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuJToceU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFB3C433C7;
	Tue, 12 Mar 2024 02:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710212235;
	bh=JuGozl3Rp1HWn76gH4B/w7ED+gwkYd5CwT5FVvVs2ko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuJToceUyzjtMyTX+M6+0aviaN1EBPAsesFnTfszl5Y3gq63stmXW8MRYC3j0guwf
	 D3NJEIzZSofB7vxeWf++eb8a8gjLqr0OsgNAWfLaAOGrjYQbcH2VrTOZU29yLltSod
	 fMW4ENbfD1AfMe/8SUmhrkhlOHnwgCDg70rZCw5099VYqTOO1hIWOksFp99Zlc1BjV
	 yTP3qlxdEQ9R4FBqRYcYGF+DnjByGbViSQlJ7cjQKZmZfAKgQodww1Pv2M1o0bN1ih
	 +HbqTsQMzqrpqIAYmBzhtMv0kHpoDpMwH/Eup5acjlncKW/Z/DdFPYecTV38V/NLv3
	 Fr2vZvzn2C0pQ==
Date: Mon, 11 Mar 2024 19:57:12 -0700
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
Message-ID: <20240312025712.GE1182@sol.localdomain>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>

On Wed, Mar 06, 2024 at 03:34:40PM -0800, Fan Wu wrote:
> fsverity represents a mechanism to support both integrity and
> authenticity protection of a file, supporting both signed and unsigned
> digests.
> 
> An LSM which controls access to a resource based on authenticity and
> integrity of said resource, can then use this data to make an informed
> decision on the authorization (provided by the LSM's policy) of said
> claim.
> 
> This effectively allows the extension of a policy enforcement layer in
> LSM for fsverity, allowing for more granular control of how a
> particular authenticity claim can be used. For example, "all (built-in)
> signed fsverity files should be allowed to execute, but only these
> hashes are allowed to be loaded as kernel modules".
> 
> This enforcement must be done in kernel space, as a userspace only
> solution would fail a simple litmus test: Download a self-contained
> malicious binary that never touches the userspace stack. This
> binary would still be able to execute.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

As I've said before, this commit message needs some work.  It currently doesn't
say anything about what the patch actually does.

BTW, please make sure you're Cc'ing the fsverity mailing list
(fsverity@lists.linux.dev), not fscrypt (linux-fscrypt@vger.kernel.org).

> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 13e4b18e5dbb..64618a6141ab 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -461,7 +461,9 @@ Enabling this option adds the following:
>  
>  3. A new sysctl "fs.verity.require_signatures" is made available.
>     When set to 1, the kernel requires that all verity files have a
> -   correctly signed digest as described in (2).
> +   correctly signed digest as described in (2). Note that verification
> +   happens as long as the file's signature exists regardless the state of
> +   "fs.verity.require_signatures".
>  
>  The data that the signature as described in (2) must be a signature of
>  is the fs-verity file digest in the following format::

Doesn't anything else in this file need to be updated to document the IPE
support?

> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 6c31a871b84b..f917023255c8 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -8,6 +8,7 @@
>  #include "fsverity_private.h"
>  
>  #include <linux/mm.h>
> +#include <linux/security.h>
>  #include <linux/slab.h>
>  
>  static struct kmem_cache *fsverity_info_cachep;
> @@ -172,12 +173,28 @@ static int compute_file_digest(const struct fsverity_hash_alg *hash_alg,
>  	return err;
>  }
>  
> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
> +static int fsverity_inode_setsecurity(struct inode *inode,
> +				      const struct fsverity_descriptor *desc)
> +{
> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
> +					  desc->signature,
> +					  le32_to_cpu(desc->sig_size), 0);

Please call it something like FS_VERITY_INODE_BUILTIN_SIG to make it clear that
it's the builtin signature.

> +}
> +#else
> +static inline int fsverity_inode_setsecurity(struct inode *inode,
> +					     const struct fsverity_descriptor *desc)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_IPE_PROP_FS_VERITY*/

The above comment mentions CONFIG_IPE_PROP_FS_VERITY, but it doesn't appear
anywhere else in the patch.

> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>  					   struct fsverity_descriptor *desc)
>  {
>  	struct fsverity_info *vi;
> @@ -242,6 +259,13 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  		spin_lock_init(&vi->hash_page_init_lock);
>  	}
>  
> +	err = fsverity_inode_setsecurity(inode, desc);
> +	if (err == -EOPNOTSUPP)
> +		err = 0;

What is the "err == -EOPNOTSUPP" case intended to handle?

> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index 90c07573dd77..42f58f4e45d0 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -41,7 +41,9 @@ static struct key *fsverity_keyring;
>   * @sig_size: size of signature in bytes, or 0 if no signature
>   *
>   * If the file includes a signature of its fs-verity file digest, verify it
> - * against the certificates in the fs-verity keyring.
> + * against the certificates in the fs-verity keyring. Note that verification
> + * happens as long as the file's signature exists regardless the state of
> + * fsverity_require_signatures.

Can you please make this mention explicitly that the LSM hook is relying on that
behavior?

- Eric

