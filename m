Return-Path: <linux-fscrypt+bounces-207-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6126286D2BD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 19:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BEE628450A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 18:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18253134437;
	Thu, 29 Feb 2024 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Chwd/gWh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AE17828A;
	Thu, 29 Feb 2024 18:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709233169; cv=none; b=V9rAWC0Wivb9LbEyJMQrTyZUIsYXrtNQn5NENtoEViRgxOLyHjquLNc1gVbNf8Et6lOuDmhIFOVpHxqWxV5k4LWDN22o3ZSyQeRQVrRoFmHNXKqhw4/b9yCV/2ofbndmkfS49/8/l8Sa34LMSz0EkhPSOLdLoA9P57PZs9Bdvcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709233169; c=relaxed/simple;
	bh=03wrvTX4PmazfhRynJz8dIwWNCpXUtctCoHli5CWq3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BSiHEnK1bdl+ZO+qo/qnoUUG9LdFoS69mI789yi1f9M4hbQlP3TwSgZ4QgZw1CoRcTC1YdEaJ0nHdnKXs7DNBqKU9nmfQH3VkmTrcvK8pDbKiasf/pkmrHecWZoQDAUZ0B6jEZODhMuABiCXqLDyvfZGtqsbP5IevGcsG/q6MCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Chwd/gWh; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id 67BEC20B74C1;
	Thu, 29 Feb 2024 10:59:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 67BEC20B74C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709233161;
	bh=JV+3tSiFvjDV+NVnRDenCsHCjaCafQUqnYHRslOz/Is=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Chwd/gWhaBwu6cGDHeTQLShmFSuRlHjpipSjMmiY+uPVfP9m8FVNjLOHiAxx+ZPF/
	 mebhxmfmUfYNWYgKAjhshktx0kymWEOFVKFUkQGBgOaJ0lidTIXk/2OEIuZ/FtL46I
	 mzpviYdU/EUUFj7yvd/zQgv5h89QqsFhP/icO91I=
Message-ID: <b73e3387-558f-4f40-8741-c6ed7965b25f@linux.microsoft.com>
Date: Thu, 29 Feb 2024 10:59:21 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v13 17/20] ipe: enable support for fs-verity as a
 trust provider
To: Eric Biggers <ebiggers@kernel.org>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org,
 linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>
 <20240229044625.GA1946@sol.localdomain>
Content-Language: en-CA
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20240229044625.GA1946@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 8:46 PM, Eric Biggers wrote:
> On Wed, Feb 28, 2024 at 04:54:59PM -0800, Fan Wu wrote:
>> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
>> index f5190a1347a6..ca1573ff21b7 100644
>> --- a/security/ipe/hooks.c
>> +++ b/security/ipe/hooks.c
>> @@ -254,3 +254,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
>>   	return -EOPNOTSUPP;
>>   }
>>   #endif /* CONFIG_IPE_PROP_DM_VERITY */
>> +
>> +#ifdef CONFIG_IPE_PROP_FS_VERITY
>> +/**
>> + * ipe_inode_setsecurity - Sets fields of a inode security blob from @key.
>> + * @inode: The inode to source the security blob from.
>> + * @name: The name representing the information to be stored.
>> + * @value: The value to be stored.
>> + * @size: The size of @value.
>> + * @flags: unused
>> + *
>> + * Saves fsverity signature & digest into inode security blob
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Error
>> + */
>> +int ipe_inode_setsecurity(struct inode *inode, const char *name,
>> +			  const void *value, size_t size,
>> +			  int flags)
>> +{
>> +	struct ipe_inode *inode_sec = ipe_inode(inode);
>> +
>> +	if (!strcmp(name, FS_VERITY_INODE_SEC_NAME)) {
>> +		inode_sec->fs_verity_signed = size > 0 && value;
>> +		return 0;
>> +	}
>> +
>> +	return -EOPNOTSUPP;
>> +}
> 
> So IPE is interested in whether a file has an fsverity builtin signature, but it
> doesn't care what the signature is or whether it has been checked.  What is the
> point?
> 
> - Eric

It does make sure the signature is checked. This hook call can only be 
triggered after fsverity_verify_signature() succeed. Therefore, for 
files that are marked with the security blob inode_sec->fs_verity_sign 
as true, they must successfully pass the fsverity_verify_signature() check.

Regarding the other question, the current version does not support 
defining policies to trust files based on the inner content of their 
signatures because the current patch set is already too large.

We plan to introduce new policy grammars to enable the policy to define 
which certificate of the signature can be trusted after this version is 
accepted.

-Fan

