Return-Path: <linux-fscrypt+bounces-249-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E1A879B76
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 19:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C1E8B214CC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 18:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C686213E7DD;
	Tue, 12 Mar 2024 18:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="huSxnsmb"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E9431DDC9;
	Tue, 12 Mar 2024 18:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710268438; cv=none; b=TCIKm/h8ErsjsiIbbzAMldQzK1NvDiEW4kIBA3JAMz3YpI96glxNUILl7ycH1uXesNCDHkHFuNa3AFQ2acpqgMX8v4NUHJKAOy2Ay0n1jSrzw95SXCkchmTU8fF1EgOTWpuhqxIV03Ll71NdgEFYAtAjQ2KYh+anGT16lri51a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710268438; c=relaxed/simple;
	bh=ijhnuffNcILFouxKfyqglG/acU+UDWarC+AJ6fu6/Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrAR51wPKsC7qLwT46JV3rAZYJQ1FAbxy5K93m2nhfts5rdKYTHDHmMCfYW2n5m6HAA7H34bw3VQ0o2VMdqTIrGL31tOqoGhaISPHiLBgap2i1YT/9TgQsTOpeyb0/xF+zq7O9xUAiO8OSdhCeOzWzwxWXIsn1AJfvTeXuHJldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=huSxnsmb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [167.220.2.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 82E0520B74C0;
	Tue, 12 Mar 2024 11:33:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 82E0520B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710268436;
	bh=VdDw0jy/dWElqQTjBY8o3DI+PCxpiEFvUC2SxNbC8p0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=huSxnsmbkMPs8Og/JWl83P4lKRuDq/6lAjJoQI9l5mRc3e2tETI7D/7/rBXYu2mug
	 shxYBFq4NtqGAJsYHSsKvOp6xcI4fi0+8xChbmdjGOBkAafpY+HAb+vnLx5qw5mpgK
	 KTF1UjzAWZ9vGSnS4ymBoKrtqqxG47IioaH03N/M=
Message-ID: <be0289fe-3bb6-4a53-8125-62b640e5e31b@linux.microsoft.com>
Date: Tue, 12 Mar 2024 11:33:56 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM
 hook
Content-Language: en-CA
To: Eric Biggers <ebiggers@kernel.org>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org,
 linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20240312025712.GE1182@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2024 7:57 PM, Eric Biggers wrote:
> On Wed, Mar 06, 2024 at 03:34:40PM -0800, Fan Wu wrote:
>> fsverity represents a mechanism to support both integrity and
>> authenticity protection of a file, supporting both signed and unsigned
>> digests.
>>
>> An LSM which controls access to a resource based on authenticity and
>> integrity of said resource, can then use this data to make an informed
>> decision on the authorization (provided by the LSM's policy) of said
>> claim.
>>
>> This effectively allows the extension of a policy enforcement layer in
>> LSM for fsverity, allowing for more granular control of how a
>> particular authenticity claim can be used. For example, "all (built-in)
>> signed fsverity files should be allowed to execute, but only these
>> hashes are allowed to be loaded as kernel modules".
>>
>> This enforcement must be done in kernel space, as a userspace only
>> solution would fail a simple litmus test: Download a self-contained
>> malicious binary that never touches the userspace stack. This
>> binary would still be able to execute.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> As I've said before, this commit message needs some work.  It currently doesn't
> say anything about what the patch actually does.
Apologies, I must have missed your previous comment. I appreciate your 
feedback and will ensure that the commit message clearly describes what 
the patch does in the next version. Thank you for pointing this out.

> 
> BTW, please make sure you're Cc'ing the fsverity mailing list
> (fsverity@lists.linux.dev), not fscrypt (linux-fscrypt@vger.kernel.org).
Thanks for the info.

> 
>> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
>> index 13e4b18e5dbb..64618a6141ab 100644
>> --- a/Documentation/filesystems/fsverity.rst
>> +++ b/Documentation/filesystems/fsverity.rst
>> @@ -461,7 +461,9 @@ Enabling this option adds the following:
>>   
>>   3. A new sysctl "fs.verity.require_signatures" is made available.
>>      When set to 1, the kernel requires that all verity files have a
>> -   correctly signed digest as described in (2).
>> +   correctly signed digest as described in (2). Note that verification
>> +   happens as long as the file's signature exists regardless the state of
>> +   "fs.verity.require_signatures".
>>   
>>   The data that the signature as described in (2) must be a signature of
>>   is the fs-verity file digest in the following format::
> 
> Doesn't anything else in this file need to be updated to document the IPE
> support?
> 
Yes, I can add more details of IPE support in the built-in signature 
section.

>> diff --git a/fs/verity/open.c b/fs/verity/open.c
>> index 6c31a871b84b..f917023255c8 100644
>> --- a/fs/verity/open.c
>> +++ b/fs/verity/open.c
>> @@ -8,6 +8,7 @@
>>   #include "fsverity_private.h"
>>   
>>   #include <linux/mm.h>
>> +#include <linux/security.h>
>>   #include <linux/slab.h>
>>   
>>   static struct kmem_cache *fsverity_info_cachep;
>> @@ -172,12 +173,28 @@ static int compute_file_digest(const struct fsverity_hash_alg *hash_alg,
>>   	return err;
>>   }
>>   
>> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
>> +static int fsverity_inode_setsecurity(struct inode *inode,
>> +				      const struct fsverity_descriptor *desc)
>> +{
>> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
>> +					  desc->signature,
>> +					  le32_to_cpu(desc->sig_size), 0);
> 
> Please call it something like FS_VERITY_INODE_BUILTIN_SIG to make it clear that
> it's the builtin signature.
>
Thanks for the suggestion, I will take the name.

>> +}
>> +#else
>> +static inline int fsverity_inode_setsecurity(struct inode *inode,
>> +					     const struct fsverity_descriptor *desc)
>> +{
>> +	return 0;
>> +}
>> +#endif /* CONFIG_IPE_PROP_FS_VERITY*/
> 
> The above comment mentions CONFIG_IPE_PROP_FS_VERITY, but it doesn't appear
> anywhere else in the patch.
>
The CONFIG_IPE_PROP_FS_VERITY KCONFIG switch is introduced in a 
subsequent patch. Merging these two patches might not be the best 
approach. I can switch to using CONFIG_FS_VERITY_BUILTIN_SIGNATURES 
instead, which may be more appropriate for the current context.

>> +struct fsverity_info *fsverity_create_info(struct inode *inode,
>>   					   struct fsverity_descriptor *desc)
>>   {
>>   	struct fsverity_info *vi;
>> @@ -242,6 +259,13 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
>>   		spin_lock_init(&vi->hash_page_init_lock);
>>   	}
>>   
>> +	err = fsverity_inode_setsecurity(inode, desc);
>> +	if (err == -EOPNOTSUPP)
>> +		err = 0;
> 
> What is the "err == -EOPNOTSUPP" case intended to handle?
>
The -EOPNOTSUPP is designed to signal situations where the called LSM 
hook does not support associating the passed name with a value, but the 
hook call itself does not encounter any errors. Also, -EOPNOTSUPP is the 
default return value of security_inode_setsecurity when no LSM has 
registered the hook. In summary, it indicates that no hook call 
succeeded, but no critical error occurred.

>> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
>> index 90c07573dd77..42f58f4e45d0 100644
>> --- a/fs/verity/signature.c
>> +++ b/fs/verity/signature.c
>> @@ -41,7 +41,9 @@ static struct key *fsverity_keyring;
>>    * @sig_size: size of signature in bytes, or 0 if no signature
>>    *
>>    * If the file includes a signature of its fs-verity file digest, verify it
>> - * against the certificates in the fs-verity keyring.
>> + * against the certificates in the fs-verity keyring. Note that verification
>> + * happens as long as the file's signature exists regardless the state of
>> + * fsverity_require_signatures.
> 
> Can you please make this mention explicitly that the LSM hook is relying on that
> behavior?
Sure, I can add this info.
-Fan
> 
> - Eric

