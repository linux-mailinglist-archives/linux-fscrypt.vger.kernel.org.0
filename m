Return-Path: <linux-fscrypt+bounces-174-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7921984AA25
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Feb 2024 00:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30A9E2924F0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Feb 2024 23:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2E226ACC;
	Mon,  5 Feb 2024 23:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="jSmmL4Kf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312A91DA58;
	Mon,  5 Feb 2024 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174081; cv=none; b=kshS5w+Md9FmAtvCuCCv+0wKvy0ZY9erL5DWHEzsUHrgm839J4QVYg0HVYzUQvNZwI6g6LpSL4brfWEKbG1bIPwN9SU7us/JjzP/GXK+WOyr43zAsh8EDh5GDP4jawgoaqdFWKiGg9fBncGlMLJkN9kb+ONoBhK3RkOf5KtJuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174081; c=relaxed/simple;
	bh=2ujfIZRQc1cb0HXJ/pt3KU/6I6sRy/gSMZ/md2bl5c0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ooux28EEu7vzv1y5hDc8wH8+Mye9IyagM5rKfEHKrrNZfXrtL/+Rjjkk43N+aLQlYHJcaKrAnOd+sjoHkoI5+N7rF1GXkO1AXYEl/WO8b4IE+yPkQQHavQygntWTAacrrOVGowmdOippkXUK/HaJU5UUVnJtLbY5kfc/cei02Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=jSmmL4Kf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id A4FC920B2000;
	Mon,  5 Feb 2024 15:01:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A4FC920B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707174078;
	bh=xWAC5tnA3tlH9LuH5yF6AglT0l9thEKDOUm3KpJsqzs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jSmmL4KfGUam+Zdzuwu7su4gNF2Nz/s39Ftb7keHkwZy31oo/Pu5RIZofnroBonm/
	 1O2rR2LF60iHe8PbbjAT3JBvmN+CrAPPgCQVlMFOJ6BxWbuYdGREh4Dq8FYqdFFuno
	 b8tgzKQ3Q1qv7LKZ3rO2re/4ju5cnnjtjleN4EoA=
Message-ID: <6e7c707c-28cd-42ec-a617-6f8d2ce9da4f@linux.microsoft.com>
Date: Mon, 5 Feb 2024 15:01:18 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v12 8/20] ipe: add userspace interface
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
References: <1706654228-17180-9-git-send-email-wufan@linux.microsoft.com>
 <737a8ea0323b3db38044813041215bac@paul-moore.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <737a8ea0323b3db38044813041215bac@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/3/2024 2:25 PM, Paul Moore wrote:
> On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> As is typical with LSMs, IPE uses securityfs as its interface with
>> userspace. for a complete list of the interfaces and the respective
>> inputs/outputs, please see the documentation under
>> admin-guide/LSM/ipe.rst
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v2:
>>    + Split evaluation loop, access control hooks,
>>      and evaluation loop from policy parser and userspace
>>      interface to pass mailing list character limit
>>
>> v3:
>>    + Move policy load and activation audit event to 03/12
>>    + Fix a potential panic when a policy failed to load.
>>    + use pr_warn for a failure to parse instead of an
>>      audit record
>>    + Remove comments from headers
>>    + Add lockdep assertions to ipe_update_active_policy and
>>      ipe_activate_policy
>>    + Fix up warnings with checkpatch --strict
>>    + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>>      nodes.
>>    + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>>    + Remove strict_parse command line parameter, as it is added
>>      by the sysctl command line.
>>    + Prefix extern variables with ipe_
>>
>> v4:
>>    + Remove securityfs to reverse-dependency
>>    + Add SHA1 reverse dependency.
>>    + Add versioning scheme for IPE properties, and associated
>>      interface to query the versioning scheme.
>>    + Cause a parser to always return an error on unknown syntax.
>>    + Remove strict_parse option
>>    + Change active_policy interface from sysctl, to securityfs,
>>      and change scheme.
>>
>> v5:
>>    + Cause an error if a default action is not defined for each
>>      operation.
>>    + Minor function renames
>>
>> v6:
>>    + No changes
>>
>> v7:
>>    + Propagating changes to support the new ipe_context structure in the
>>      evaluation loop.
>>
>>    + Further split the parser and userspace interface changes into
>>      separate commits.
>>
>>    + "raw" was renamed to "pkcs7" and made read only
>>    + "raw"'s write functionality (update a policy) moved to "update"
>>    + introduced "version", "policy_name" nodes.
>>    + "content" renamed to "policy"
>>    + changes to allow the compiled-in policy to be treated
>>      identical to deployed-after-the-fact policies.
>>
>> v8:
>>    + Prevent securityfs initialization if the LSM is disabled
>>
>> v9:
>>    + Switch to securityfs_recursive_remove for policy folder deletion
>>
>> v10:
>>    + Simplify and correct concurrency
>>    + Fix typos
>>
>> v11:
>>    + Correct code comments
>>
>> v12:
>>    + Correct locking and remove redundant code
>> ---
>>   security/ipe/Makefile    |   2 +
>>   security/ipe/fs.c        | 101 +++++++++
>>   security/ipe/fs.h        |  16 ++
>>   security/ipe/ipe.c       |   3 +
>>   security/ipe/ipe.h       |   2 +
>>   security/ipe/policy.c    | 123 ++++++++++
>>   security/ipe/policy.h    |   9 +
>>   security/ipe/policy_fs.c | 469 +++++++++++++++++++++++++++++++++++++++
>>   8 files changed, 725 insertions(+)
>>   create mode 100644 security/ipe/fs.c
>>   create mode 100644 security/ipe/fs.h
>>   create mode 100644 security/ipe/policy_fs.c
> 
> ...
> 
>> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
>> index f22a576a6d68..61fea3e38e11 100644
>> --- a/security/ipe/policy.c
>> +++ b/security/ipe/policy.c
>> @@ -43,6 +71,68 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>>   	return 0;
>>   }
>>   
>> +/**
>> + * ipe_update_policy - parse a new policy and replace old with it.
>> + * @root: Supplies a pointer to the securityfs inode saved the policy.
>> + * @text: Supplies a pointer to the plain text policy.
>> + * @textlen: Supplies the length of @text.
>> + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
>> + * @pkcs7len: Supplies the length of @pkcs7len.
>> + *
>> + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
>> + * ipe_new_policy.
>> + *
>> + * Context: Requires root->i_rwsem to be held.
>> + * Return:
>> + * * !IS_ERR	- The existing policy saved in the inode before update
>> + * * -ENOENT	- Policy doesn't exist
>> + * * -EINVAL	- New policy is invalid
>> + */
>> +struct ipe_policy *ipe_update_policy(struct inode *root,
>> +				     const char *text, size_t textlen,
>> +				     const char *pkcs7, size_t pkcs7len)
>> +{
>> +	int rc = 0;
>> +	struct ipe_policy *old, *ap, *new = NULL;
>> +
>> +	old = (struct ipe_policy *)root->i_private;
>> +	if (!old)
>> +		return ERR_PTR(-ENOENT);
>> +
>> +	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
>> +	if (IS_ERR(new))
>> +		return new;
>> +
>> +	if (strcmp(new->parsed->name, old->parsed->name)) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	if (ver_to_u64(old) > ver_to_u64(new)) {
>> +		rc = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	root->i_private = new;
>> +	swap(new->policyfs, old->policyfs);
> 
> Should the swap() take place with @ipe_policy_lock held?
> 
I think we are safe here because root->i_rwsem is held. Other two 
operations set_active and delete are also depending on the inode lock.
>> +	mutex_lock(&ipe_policy_lock);
>> +	ap = rcu_dereference_protected(ipe_active_policy,
>> +				       lockdep_is_held(&ipe_policy_lock));
>> +	if (old == ap) {
>> +		rcu_assign_pointer(ipe_active_policy, new);
>> +		mutex_unlock(&ipe_policy_lock);
>> +		synchronize_rcu();
> 
> I'm guessing you are forcing a synchronize_rcu() here because you are
> free()'ing @old in the caller, yes?  Looking at the code, I only see
> one caller, update_policy().  With only one caller, why not free @old
> directly in ipe_update_policy()?  Do you see others callers that would
> do something different?
> 
The call of synchronize_rcu() is because we are updating the current 
active policy so we need to set the new policy as active.

I do agree we can free the old inside this function.
>> +	} else {
>> +		mutex_unlock(&ipe_policy_lock);
>> +	}
>> +
>> +	return old;
>> +err:
>> +	ipe_free_policy(new);
>> +	return ERR_PTR(rc);
>> +}
>> +
>>   /**
>>    * ipe_new_policy - Allocate and parse an ipe_policy structure.
>>    *
>> @@ -99,3 +189,36 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
>>   	ipe_free_policy(new);
>>   	return ERR_PTR(rc);
>>   }
>> +
>> +/**
>> + * ipe_set_active_pol - Make @p the active policy.
>> + * @p: Supplies a pointer to the policy to make active.
>> + *
>> + * Context: Requires root->i_rwsem, which i_private has the policy, to be held.
>> + * Return:
>> + * * !IS_ERR	- Success
>> + * * -EINVAL	- New active policy version is invalid
>> + */
>> +int ipe_set_active_pol(const struct ipe_policy *p)
>> +{
>> +	struct ipe_policy *ap = NULL;
>> +
>> +	mutex_lock(&ipe_policy_lock);
>> +
>> +	ap = rcu_dereference_protected(ipe_active_policy,
>> +				       lockdep_is_held(&ipe_policy_lock));
>> +	if (ap == p) {
>> +		mutex_unlock(&ipe_policy_lock);
>> +		return 0;
>> +	}
>> +	if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
>> +		mutex_unlock(&ipe_policy_lock);
>> +		return -EINVAL;
>> +	}
>> +
>> +	rcu_assign_pointer(ipe_active_policy, p);
>> +	mutex_unlock(&ipe_policy_lock);
>> +	synchronize_rcu();
> 
> Why do you need the synchronize_rcu() call here?
> 
>> +	return 0;
>> +}
> 
> 
> --
> paul-moore.com

