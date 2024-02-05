Return-Path: <linux-fscrypt+bounces-177-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C7B84AA67
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Feb 2024 00:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC6562867E8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Feb 2024 23:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE50248786;
	Mon,  5 Feb 2024 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gI6cjtkm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA60482F6;
	Mon,  5 Feb 2024 23:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707175270; cv=none; b=op9hMrcIa7cG7IszkDPJTKR/Tkm6w2LSiAs0y58Z+6DBkbfuecX0nx3crLms3uy4/NlcW2jdKK6Fb3GYKU6hG7O+hmHAvCiAkA7+akUYu8HYLFRz4wgkEViPvQualnqMBI8HNd8+B4BPR2bDdF6FqOowQU4z5dAa3lh7/aa2eNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707175270; c=relaxed/simple;
	bh=zNL2ywjKJssZ5pRTlZYgka+6y+zGk61/qvBAu5YB1YU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ElX/mlT6EWN1wEbMptDhTEZu8L04x/Ic95MsnaupgPAtVi9i7cjJ565LIbX7m08r/KK7lyp18624XE1+6KfhIc0M3SkdU3PoV0ZIb09ljA14ePBwLLLkbHBcfUg/5mL4QdTYMDDXmcoKqaPtYidqKSP3qsDIt6U/+mUhD3NVf7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gI6cjtkm; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7AEC4207D846;
	Mon,  5 Feb 2024 15:21:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7AEC4207D846
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707175268;
	bh=Qg5yL0/Namb3YNGXwn7cLAEyy/A44S+ELEwtmFhQ+RU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gI6cjtkm4cibm2DUJ9mtikbVu9hHSNKlrL01rbV0Y8abl/91KTJ8r5LlGcVKm9npe
	 EPhMJHhHGPNgNk3rT65weiExV4D+LnWH+FHKY7HJV0KPaLDujK5Oaas9kgHlsRJkAo
	 o4qOBdinDv8keS6+bkjw5zNNXTTm+m7Xl1UsGhi0=
Message-ID: <695f5fc3-446d-4f18-88cf-a95b3287fe7f@linux.microsoft.com>
Date: Mon, 5 Feb 2024 15:21:08 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v12 8/20] ipe: add userspace interface
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org,
 linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
References: <1706654228-17180-9-git-send-email-wufan@linux.microsoft.com>
 <737a8ea0323b3db38044813041215bac@paul-moore.com>
 <6e7c707c-28cd-42ec-a617-6f8d2ce9da4f@linux.microsoft.com>
 <CAHC9VhSX4iNHEw89-mpF07cSqgGd1myQ6CUfiQnA9pgg3QS7Tw@mail.gmail.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <CAHC9VhSX4iNHEw89-mpF07cSqgGd1myQ6CUfiQnA9pgg3QS7Tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/5/2024 3:10 PM, Paul Moore wrote:
> On Mon, Feb 5, 2024 at 6:01 PM Fan Wu <wufan@linux.microsoft.com> wrote:
>> On 2/3/2024 2:25 PM, Paul Moore wrote:
>>> On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
>>>>
>>>> As is typical with LSMs, IPE uses securityfs as its interface with
>>>> userspace. for a complete list of the interfaces and the respective
>>>> inputs/outputs, please see the documentation under
>>>> admin-guide/LSM/ipe.rst
>>>>
>>>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>>>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>>>> ---
>>>> v2:
>>>>     + Split evaluation loop, access control hooks,
>>>>       and evaluation loop from policy parser and userspace
>>>>       interface to pass mailing list character limit
>>>>
>>>> v3:
>>>>     + Move policy load and activation audit event to 03/12
>>>>     + Fix a potential panic when a policy failed to load.
>>>>     + use pr_warn for a failure to parse instead of an
>>>>       audit record
>>>>     + Remove comments from headers
>>>>     + Add lockdep assertions to ipe_update_active_policy and
>>>>       ipe_activate_policy
>>>>     + Fix up warnings with checkpatch --strict
>>>>     + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>>>>       nodes.
>>>>     + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>>>>     + Remove strict_parse command line parameter, as it is added
>>>>       by the sysctl command line.
>>>>     + Prefix extern variables with ipe_
>>>>
>>>> v4:
>>>>     + Remove securityfs to reverse-dependency
>>>>     + Add SHA1 reverse dependency.
>>>>     + Add versioning scheme for IPE properties, and associated
>>>>       interface to query the versioning scheme.
>>>>     + Cause a parser to always return an error on unknown syntax.
>>>>     + Remove strict_parse option
>>>>     + Change active_policy interface from sysctl, to securityfs,
>>>>       and change scheme.
>>>>
>>>> v5:
>>>>     + Cause an error if a default action is not defined for each
>>>>       operation.
>>>>     + Minor function renames
>>>>
>>>> v6:
>>>>     + No changes
>>>>
>>>> v7:
>>>>     + Propagating changes to support the new ipe_context structure in the
>>>>       evaluation loop.
>>>>
>>>>     + Further split the parser and userspace interface changes into
>>>>       separate commits.
>>>>
>>>>     + "raw" was renamed to "pkcs7" and made read only
>>>>     + "raw"'s write functionality (update a policy) moved to "update"
>>>>     + introduced "version", "policy_name" nodes.
>>>>     + "content" renamed to "policy"
>>>>     + changes to allow the compiled-in policy to be treated
>>>>       identical to deployed-after-the-fact policies.
>>>>
>>>> v8:
>>>>     + Prevent securityfs initialization if the LSM is disabled
>>>>
>>>> v9:
>>>>     + Switch to securityfs_recursive_remove for policy folder deletion
>>>>
>>>> v10:
>>>>     + Simplify and correct concurrency
>>>>     + Fix typos
>>>>
>>>> v11:
>>>>     + Correct code comments
>>>>
>>>> v12:
>>>>     + Correct locking and remove redundant code
>>>> ---
>>>>    security/ipe/Makefile    |   2 +
>>>>    security/ipe/fs.c        | 101 +++++++++
>>>>    security/ipe/fs.h        |  16 ++
>>>>    security/ipe/ipe.c       |   3 +
>>>>    security/ipe/ipe.h       |   2 +
>>>>    security/ipe/policy.c    | 123 ++++++++++
>>>>    security/ipe/policy.h    |   9 +
>>>>    security/ipe/policy_fs.c | 469 +++++++++++++++++++++++++++++++++++++++
>>>>    8 files changed, 725 insertions(+)
>>>>    create mode 100644 security/ipe/fs.c
>>>>    create mode 100644 security/ipe/fs.h
>>>>    create mode 100644 security/ipe/policy_fs.c
>>>
>>> ...
>>>
>>>> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
>>>> index f22a576a6d68..61fea3e38e11 100644
>>>> --- a/security/ipe/policy.c
>>>> +++ b/security/ipe/policy.c
>>>> @@ -43,6 +71,68 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>>>>       return 0;
>>>>    }
>>>>
>>>> +/**
>>>> + * ipe_update_policy - parse a new policy and replace old with it.
>>>> + * @root: Supplies a pointer to the securityfs inode saved the policy.
>>>> + * @text: Supplies a pointer to the plain text policy.
>>>> + * @textlen: Supplies the length of @text.
>>>> + * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
>>>> + * @pkcs7len: Supplies the length of @pkcs7len.
>>>> + *
>>>> + * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
>>>> + * ipe_new_policy.
>>>> + *
>>>> + * Context: Requires root->i_rwsem to be held.
>>>> + * Return:
>>>> + * * !IS_ERR        - The existing policy saved in the inode before update
>>>> + * * -ENOENT        - Policy doesn't exist
>>>> + * * -EINVAL        - New policy is invalid
>>>> + */
>>>> +struct ipe_policy *ipe_update_policy(struct inode *root,
>>>> +                                 const char *text, size_t textlen,
>>>> +                                 const char *pkcs7, size_t pkcs7len)
>>>> +{
>>>> +    int rc = 0;
>>>> +    struct ipe_policy *old, *ap, *new = NULL;
>>>> +
>>>> +    old = (struct ipe_policy *)root->i_private;
>>>> +    if (!old)
>>>> +            return ERR_PTR(-ENOENT);
>>>> +
>>>> +    new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
>>>> +    if (IS_ERR(new))
>>>> +            return new;
>>>> +
>>>> +    if (strcmp(new->parsed->name, old->parsed->name)) {
>>>> +            rc = -EINVAL;
>>>> +            goto err;
>>>> +    }
>>>> +
>>>> +    if (ver_to_u64(old) > ver_to_u64(new)) {
>>>> +            rc = -EINVAL;
>>>> +            goto err;
>>>> +    }
>>>> +
>>>> +    root->i_private = new;
>>>> +    swap(new->policyfs, old->policyfs);
>>>
>>> Should the swap() take place with @ipe_policy_lock held?
>>>
>> I think we are safe here because root->i_rwsem is held. Other two
>> operations set_active and delete are also depending on the inode lock.
>>>> +    mutex_lock(&ipe_policy_lock);
>>>> +    ap = rcu_dereference_protected(ipe_active_policy,
>>>> +                                   lockdep_is_held(&ipe_policy_lock));
>>>> +    if (old == ap) {
>>>> +            rcu_assign_pointer(ipe_active_policy, new);
>>>> +            mutex_unlock(&ipe_policy_lock);
>>>> +            synchronize_rcu();
>>>
>>> I'm guessing you are forcing a synchronize_rcu() here because you are
>>> free()'ing @old in the caller, yes?  Looking at the code, I only see
>>> one caller, update_policy().  With only one caller, why not free @old
>>> directly in ipe_update_policy()?  Do you see others callers that would
>>> do something different?
>>>
>> The call of synchronize_rcu() is because we are updating the current
>> active policy so we need to set the new policy as active.
> 
> Unless I'm mistaken, a syncronize_rcu() call only ensures that the
> current task will see the updated value by waiting until all current
> RCU critical sections have finished.  Given the mutex involved here I
> don't believe this is necessary, but please correct me if I'm wrong.
> 
Sorry for the confusion. I think your previous comment was right, the 
call of synchronize_rcu() is to free the old one. And I should put the 
free of old just after the synchronize_rcu() call.

Thanks,
Fan

