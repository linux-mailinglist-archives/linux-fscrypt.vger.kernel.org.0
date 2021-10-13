Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02142C9F2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhJMT0W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:26:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhJMT0W (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:26:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1509C61165;
        Wed, 13 Oct 2021 19:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634153058;
        bh=JUok33pGH4UgBASbmLqOAHK5yJuIuNZQKpPd6Vna/dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XccaERcARzIvJnuXANFKQNKReeOrIWdIqKl5rzPUZFJN7xcAcduSZ3Z+Dbps8mTbn
         LphHMJMf3fA0TW0mDXX4+z95W8vl6NkC2kg32q25r06CGg7r07iNpiCPWE5yDiPBTD
         SZ9NEP045hQdcd1MJZ0CkRlAzguW7PpFXN0x+lHoP3oKGFrufud9qO7izn3HM/40Lx
         UY+2B4+/Ppn2Q8swW3uZV36cVFdD9uuwjHUBb+TwibbdIyvbjZM45dKT61kqeaI0BK
         ZOnzQiT4sbUcAiqpqcptty4eqf6afmjRb9TN+drtT7u+Fywbi8Gw5Qwb1nT1xaCvQf
         vmNlV3Kcsglvg==
Date:   Wed, 13 Oct 2021 12:24:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     deven.desai@linux.microsoft.com
Cc:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
        jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Message-ID: <YWcyYBuNppjrVOe2@gmail.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 13, 2021 at 12:06:31PM -0700, deven.desai@linux.microsoft.com wrote:
> From: Fan Wu <wufan@linux.microsoft.com>
> 
> Add security_inode_setsecurity to fsverity signature verification.
> This can let LSMs save the signature data and digest hashes provided
> by fsverity.

Can you elaborate on why LSMs need this information?

> 
> Also changes the implementaion inside the hook function to let
> multiple LSMs can add hooks.

Please split fs/verity/ changes and security/ changes into separate patches, if
possible.

> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

> @@ -177,6 +178,17 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>  		fsverity_err(inode, "Error %d computing file digest", err);
>  		goto out;
>  	}
> +
> +	err = security_inode_setsecurity((struct inode *)inode,

If a non-const inode is needed, please propagate that into the callers rather
than randomly casting away the const.

> +					 FS_VERITY_DIGEST_SEC_NAME,
> +					 vi->file_digest,
> +					 vi->tree_params.hash_alg->digest_size,
> +					 0);

The digest isn't meaningful without knowing the hash algorithm it uses.
It's available here, but you aren't passing it to this function.

> @@ -84,7 +85,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
>  
>  	pr_debug("Valid signature for file digest %s:%*phN\n",
>  		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
> -	return 0;
> +	return security_inode_setsecurity((struct inode *)inode,

Likewise, please don't cast away const.

> +					FS_VERITY_SIGNATURE_SEC_NAME,
> +					signature, sig_size, 0);

This is only for fs-verity built-in signatures which aren't the only way to do
signatures with fs-verity.  Are you sure this is what you're looking for?  Can
you elaborate on your use case for fs-verity built-in signatures, and what the
LSM hook will do with them?

- Eric
