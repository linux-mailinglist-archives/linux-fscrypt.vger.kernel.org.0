Return-Path: <linux-fscrypt+bounces-251-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DD99879C1A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 20:09:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CED09B25854
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 19:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8234F142636;
	Tue, 12 Mar 2024 19:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="b2Vdkjqu"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD77C139572;
	Tue, 12 Mar 2024 19:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710270531; cv=none; b=gVwQucksKi2ti9m4b1G/8jg99UIQUOiAGq+0Zz5cAZ4yNqV/dpQHrx2XtiQckSk/UUR3KxghhEYJWtRM44A0ASObDCMcWJVgri47qLnx+Kb3tY3uvI4QhY+vuTaKgUOmkaw6iHwwd4//YvEjhkQx9NPQyFoPytvn+5dAWn0+YtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710270531; c=relaxed/simple;
	bh=uJKJ5TT0DIQCG1G4MHwjHdZ45SeGQe6J4lJO/tq7XHI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T/MMM1kx+1+uqgp/l+IbI3GgmVicURuCQtVRCPtttC5EjbpqiqvKqC0/st/cfm1eC4GnnJHPQqTHiIcBZwHmoXU0CVOUyyun5tVgaXLaUnln3O1eS4gwW3CV0eRtSAGJw6cqwbMio/LsU3kLufmhq6zVpDS4pevbN548xlZ5fNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=b2Vdkjqu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [167.220.2.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5553320B74C0;
	Tue, 12 Mar 2024 12:08:49 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5553320B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710270529;
	bh=cWEVzi9QVVsJQgWK0gb+VOtCy9uOsL8ujlhBGevuOmc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b2VdkjquI/gfoxlQSlcUlTggdkJsZmhj+zejliyOfxmDA1IOrPGJIPBk7VcPkVMUB
	 Kyh93nFVzbfMhUQjOQDT3EaUahlKkrWKwFQp6K+Hi7CkcTBuyQ2kUmxR8pJHsthWBG
	 VLEd4uSybXl6Rc41g4x6fT6CHtJAsnZ/gKNEuqzs=
Message-ID: <746a5548-0e98-4953-9e71-16b881c63aa8@linux.microsoft.com>
Date: Tue, 12 Mar 2024 12:08:49 -0700
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
To: Casey Schaufler <casey@schaufler-ca.com>,
 Eric Biggers <ebiggers@kernel.org>
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
 <20240312030712.GF1182@sol.localdomain>
 <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
 <568fae5e-a6d4-4832-a1a1-ac3f4f93d650@schaufler-ca.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <568fae5e-a6d4-4832-a1a1-ac3f4f93d650@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 3/12/2024 11:51 AM, Casey Schaufler wrote:
> On 3/12/2024 11:14 AM, Fan Wu wrote:
>>
>>
>> On 3/11/2024 8:07 PM, Eric Biggers wrote:
>>> On Mon, Mar 11, 2024 at 07:57:12PM -0700, Eric Biggers wrote:
>>>>
>>>> As I've said before, this commit message needs some work.  It
>>>> currently doesn't
>>>> say anything about what the patch actually does.
>>>>
>>>> BTW, please make sure you're Cc'ing the fsverity mailing list
>>>> (fsverity@lists.linux.dev), not fscrypt
>>>> (linux-fscrypt@vger.kernel.org).
>>>
>>> Also, I thought this patch was using a new LSM hook, but I now see
>>> that you're
>>> actually abusing the existing security_inode_setsecurity() LSM hook.
>>> Currently
>>> that hook is called when an xattr is set.  I don't see any precedent for
>>> overloading it for other purposes.  This seems problematic, as it
>>> means that a
>>> request to set an xattr with the name you chose
>>> ("fsverity.builtin-sig") will be
>>> interpreted by LSMs as the fsverity builtin signature.  A dedicated
>>> LSM hook may
>>> be necessary to avoid issues with overloading the existing xattr hook
>>> like this.
>>>
>>> - Eric
>>
>> Thanks for the suggestion. I found that using
>> security_inode_setsecurity() causes issues with SMACK's
>> inode_setsecurity() hook. I will crate a dedicated new hook like
>> security_inode_setsig() in the next version.
> 
> What is the issue you encountered with the Smack hook?
> 

The current hook call for saving file signature will fail at 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/security/smack/smack_lsm.c#n2855 
.

The issue is file signature size is larger than SMK_LONGLABEL so if 
SMACK is enabled the SMACK's hook will return -EINVAL, which prevents us 
to use security_inode_setsecurity() to save file signature into security 
blob.

We could also make security_inode_setsecurity() more generic instead of 
for xattr only, any suggestions?

-Fan



