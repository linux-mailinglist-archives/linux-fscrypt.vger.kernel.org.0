Return-Path: <linux-fscrypt+bounces-167-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E0D8884892C
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 23:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1138D1C221CB
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 22:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B06F175BB;
	Sat,  3 Feb 2024 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="FEg1YU/K"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C342E168DE
	for <linux-fscrypt@vger.kernel.org>; Sat,  3 Feb 2024 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999115; cv=none; b=m4MLr0X0NvccKBJcD9bOTDbKYI8ORnbJibHL/zErnd2kdKd8irvuOvrhrAEHMF/6Ke+PYIbebz8a6ZNTrpYAW0nc4WaGWm5LomC/kDzmxZFVkFodexiGBK03M0TxEzLnk/4umO0M8RiD7TPhvFFQo40PwRkxtJVTENxXWiR2MxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999115; c=relaxed/simple;
	bh=TG3+0EGUR9bt602rI+2HsmhmcTLyo9r4S+xTet7lKAc=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=c52tEUuyX6W/71fLqqoAJLak71SZVjApOPY0qOypuIJWCRpcjMoNaeQvTQMT5P4QVhSeDZjvY4ULMA5eFTlRrQjB6Wxz+g2sKlPXrbCdUvyzSukUR4i7ZAzNfDVhdT85NBo1WDBYGKCbhVI1mptJsMfmvzB00G36aqU8TxLazK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=FEg1YU/K; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-42a4516ec5dso25080851cf.3
        for <linux-fscrypt@vger.kernel.org>; Sat, 03 Feb 2024 14:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999111; x=1707603911; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sSRaH1fgvDWzg8gAGfI9lRaHi1xVIBmOW3KgqeIEJWQ=;
        b=FEg1YU/KHoKkwFw6L9WNlMEUNpemgVoQwBpPNqtCQ1GOQwGRUVd83XiruWL+RvVojD
         a4dAH3wEAhlvWjFa31PxPWDsZYwsfCg/putLqmcq6oFdV3INKK9gvadiv82Kx3KY31iH
         R6+XmKfJKbD4HTfBqYAm2V9rPWbCyI4H84FWhL9ptihIq9KmAZJvzp3RuXHvOqwo/djd
         XBFIVhfrXY1gtSmo0lvdXAuPN0CPDqETp5eZR4q0IQ5YTIrhYmEnIbxs8JfO+IiRM286
         1GoAw5SWO8PnfQEXqeeRuaSTkl+xIt2u2lMG/SZNdBUYCWE7dU8xqffXX+F1wududjW4
         0m+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999111; x=1707603911;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sSRaH1fgvDWzg8gAGfI9lRaHi1xVIBmOW3KgqeIEJWQ=;
        b=YFwJ2xIdYm/HFYFokhUEola5K0qJ7wX+668IseGKsBZbrg7q7n/kt9Kfw3577ShiPn
         lPxq7MZ7C24/nYrufEXC3S85E5hn2LXNPsayWoxLf9qZLlCBVsRva18YirJ8Tvr4m8EP
         4kF+aovrw4dhb+yVc7MgWFDOcX/706Vo2APrsvQd+IFThczvyh7k2yQSub3Y9uWv6/vV
         O3GfEyKi6pA0ld9Qp3Xc1b6DwUtl65O5yT+XUAd+4FsGVNzalM6v9A4uu4GE8Y9889kb
         5muvAuViFLU5aWf+uYQRDN/JGuv59oViyBb+uED5VGMIRVcEGuf7A+BL9co2gMBfUKTh
         0qpw==
X-Gm-Message-State: AOJu0Ywtp+5G53ZkcA94o4lWxm4r3589Owsi319GyUqbitJCeIH34D7A
	h8qA5enj66UsH2BtmKcFD4D1z2EpJ91BqrhPJycH0w03SkNj70YKZSZ9KgJq5w==
X-Google-Smtp-Source: AGHT+IG3EYhsNVPBU6KUcsUBSOQZNgKpw+Vbn9C8kTOZ2rew1NJBeQEAn2o9I3Z39lXFU9xFt+w5vw==
X-Received: by 2002:a05:6214:246b:b0:68c:7faa:b256 with SMTP id im11-20020a056214246b00b0068c7faab256mr2977855qvb.54.1706999111497;
        Sat, 03 Feb 2024 14:25:11 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWJSkgONFuvS33JOo7SgHBJCl+YTDRQpn2fDGiqnCeMDJb05PrWc0j1lbEa88WjF0wk/V3HTr/tA/zLb+NU9Cu//2wkmDRvpvTn0QJLWq8aiOqRyJ2K6BinavcCOK9suVGRki6Ikkq09RW/Sq87IRue3GOQ3e+Q4bsLzWAObDVzhXdNMxzQ9cHt2Y1sKPYHIZRFOWGBU2FmwE38lkXuDp4zCB0K9EiRRCxMcVUkJWRvTTlzwQaJ9U0UnaINRI34+9Ul7fXRwrqEko1h4YAJnl6W0Zhd1RBiapwr53PyKauqBAhrM0AI5PCdstCXGcQGoLKr7ZhCM16Nd8aytLhNgunOBxL1zYMyE9ZuFgvIlSl+6PI7SfWMYgfZkinZeBCUeB8VV31vMjKU0mvQO04fmSC/d900C0wIv5H9kQpC312TyYPlA6+9c++DRYvqTQQo0a5EVe+iDIksVhrACG7X6szUn+6c0KfEQAEWylHaMTAyLHHavIFDd1Jcl+2eVkSfM00gB6l45Z9ixVBD+SyPEMlCj2AjLiVWzMfEWNCCcw1JQqybylZKYc4Q5q4aZxt7ktVMSkGFhxNmRZt5TKeUPN0xnUYBxBbz4UUyFxCtjNdlG+Q8262ydgPT
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id nf8-20020a0562143b8800b0068c3b1bcf6bsm2177452qvb.95.2024.02.03.14.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:10 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:10 -0500
Message-ID: <737a8ea0323b3db38044813041215bac@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=utf-8 
Content-Disposition: inline 
Content-Transfer-Encoding: 8bit
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v12 8/20] ipe: add userspace interface
References: <1706654228-17180-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-9-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> As is typical with LSMs, IPE uses securityfs as its interface with
> userspace. for a complete list of the interfaces and the respective
> inputs/outputs, please see the documentation under
> admin-guide/LSM/ipe.rst
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move policy load and activation audit event to 03/12
>   + Fix a potential panic when a policy failed to load.
>   + use pr_warn for a failure to parse instead of an
>     audit record
>   + Remove comments from headers
>   + Add lockdep assertions to ipe_update_active_policy and
>     ipe_activate_policy
>   + Fix up warnings with checkpatch --strict
>   + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>     nodes.
>   + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>   + Remove strict_parse command line parameter, as it is added
>     by the sysctl command line.
>   + Prefix extern variables with ipe_
> 
> v4:
>   + Remove securityfs to reverse-dependency
>   + Add SHA1 reverse dependency.
>   + Add versioning scheme for IPE properties, and associated
>     interface to query the versioning scheme.
>   + Cause a parser to always return an error on unknown syntax.
>   + Remove strict_parse option
>   + Change active_policy interface from sysctl, to securityfs,
>     and change scheme.
> 
> v5:
>   + Cause an error if a default action is not defined for each
>     operation.
>   + Minor function renames
> 
> v6:
>   + No changes
> 
> v7:
>   + Propagating changes to support the new ipe_context structure in the
>     evaluation loop.
> 
>   + Further split the parser and userspace interface changes into
>     separate commits.
> 
>   + "raw" was renamed to "pkcs7" and made read only
>   + "raw"'s write functionality (update a policy) moved to "update"
>   + introduced "version", "policy_name" nodes.
>   + "content" renamed to "policy"
>   + changes to allow the compiled-in policy to be treated
>     identical to deployed-after-the-fact policies.
> 
> v8:
>   + Prevent securityfs initialization if the LSM is disabled
> 
> v9:
>   + Switch to securityfs_recursive_remove for policy folder deletion
> 
> v10:
>   + Simplify and correct concurrency
>   + Fix typos
> 
> v11:
>   + Correct code comments
> 
> v12:
>   + Correct locking and remove redundant code
> ---
>  security/ipe/Makefile    |   2 +
>  security/ipe/fs.c        | 101 +++++++++
>  security/ipe/fs.h        |  16 ++
>  security/ipe/ipe.c       |   3 +
>  security/ipe/ipe.h       |   2 +
>  security/ipe/policy.c    | 123 ++++++++++
>  security/ipe/policy.h    |   9 +
>  security/ipe/policy_fs.c | 469 +++++++++++++++++++++++++++++++++++++++
>  8 files changed, 725 insertions(+)
>  create mode 100644 security/ipe/fs.c
>  create mode 100644 security/ipe/fs.h
>  create mode 100644 security/ipe/policy_fs.c

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index f22a576a6d68..61fea3e38e11 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -43,6 +71,68 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>  	return 0;
>  }
>  
> +/**
> + * ipe_update_policy - parse a new policy and replace old with it.
> + * @root: Supplies a pointer to the securityfs inode saved the policy.
> + * @text: Supplies a pointer to the plain text policy.
> + * @textlen: Supplies the length of @text.
> + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
> + * @pkcs7len: Supplies the length of @pkcs7len.
> + *
> + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
> + * ipe_new_policy.
> + *
> + * Context: Requires root->i_rwsem to be held.
> + * Return:
> + * * !IS_ERR	- The existing policy saved in the inode before update
> + * * -ENOENT	- Policy doesn't exist
> + * * -EINVAL	- New policy is invalid
> + */
> +struct ipe_policy *ipe_update_policy(struct inode *root,
> +				     const char *text, size_t textlen,
> +				     const char *pkcs7, size_t pkcs7len)
> +{
> +	int rc = 0;
> +	struct ipe_policy *old, *ap, *new = NULL;
> +
> +	old = (struct ipe_policy *)root->i_private;
> +	if (!old)
> +		return ERR_PTR(-ENOENT);
> +
> +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
> +	if (IS_ERR(new))
> +		return new;
> +
> +	if (strcmp(new->parsed->name, old->parsed->name)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	if (ver_to_u64(old) > ver_to_u64(new)) {
> +		rc = -EINVAL;
> +		goto err;
> +	}
> +
> +	root->i_private = new;
> +	swap(new->policyfs, old->policyfs);

Should the swap() take place with @ipe_policy_lock held?

> +	mutex_lock(&ipe_policy_lock);
> +	ap = rcu_dereference_protected(ipe_active_policy,
> +				       lockdep_is_held(&ipe_policy_lock));
> +	if (old == ap) {
> +		rcu_assign_pointer(ipe_active_policy, new);
> +		mutex_unlock(&ipe_policy_lock);
> +		synchronize_rcu();

I'm guessing you are forcing a synchronize_rcu() here because you are
free()'ing @old in the caller, yes?  Looking at the code, I only see
one caller, update_policy().  With only one caller, why not free @old
directly in ipe_update_policy()?  Do you see others callers that would
do something different?

> +	} else {
> +		mutex_unlock(&ipe_policy_lock);
> +	}
> +
> +	return old;
> +err:
> +	ipe_free_policy(new);
> +	return ERR_PTR(rc);
> +}
> +
>  /**
>   * ipe_new_policy - Allocate and parse an ipe_policy structure.
>   *
> @@ -99,3 +189,36 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
>  	ipe_free_policy(new);
>  	return ERR_PTR(rc);
>  }
> +
> +/**
> + * ipe_set_active_pol - Make @p the active policy.
> + * @p: Supplies a pointer to the policy to make active.
> + *
> + * Context: Requires root->i_rwsem, which i_private has the policy, to be held.
> + * Return:
> + * * !IS_ERR	- Success
> + * * -EINVAL	- New active policy version is invalid
> + */
> +int ipe_set_active_pol(const struct ipe_policy *p)
> +{
> +	struct ipe_policy *ap = NULL;
> +
> +	mutex_lock(&ipe_policy_lock);
> +
> +	ap = rcu_dereference_protected(ipe_active_policy,
> +				       lockdep_is_held(&ipe_policy_lock));
> +	if (ap == p) {
> +		mutex_unlock(&ipe_policy_lock);
> +		return 0;
> +	}
> +	if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
> +		mutex_unlock(&ipe_policy_lock);
> +		return -EINVAL;
> +	}
> +
> +	rcu_assign_pointer(ipe_active_policy, p);
> +	mutex_unlock(&ipe_policy_lock);
> +	synchronize_rcu();

Why do you need the synchronize_rcu() call here?

> +	return 0;
> +}


--
paul-moore.com

