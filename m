Return-Path: <linux-fscrypt+bounces-209-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D35C86D3D6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 20:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 539BD1C21382
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 19:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B6813F44D;
	Thu, 29 Feb 2024 19:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FAEOTZDG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4255813C9DF;
	Thu, 29 Feb 2024 19:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709236781; cv=none; b=qT9SCO+xHEYYHFYpA4vFqo8Sm/STK3cWt+LPHzRMH/90EQb04UEgNMhZ26A/R2rBSUvGissWSG2MfMW9JxDEOT3CPTSZuh7ENr3U3EJW5We8R6lvxp31nzPPJjlJSp1oDUkmK9EQ6fjUZHlppDQ77WSM64uMKtcUtNb3M09IQv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709236781; c=relaxed/simple;
	bh=1iFRua+KRGwO6LXerMjQRyUEaPugQrsxR57ztwBXH+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MI/qSM61IOCROZ+jbsNSxoaf/s0DmiJbbs31ywe8DhB8kwUffALPy4G6Em/CrlWJewJcRqWu6uwC7C9yYr1jD7/J3EqLXSCMlh1brT+NAFzw8oDXqDzWqeWpFs8RwbH3aUt5klD16rqU2JitQln8DNUXZsHZixFRFxcwu1yFFZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FAEOTZDG; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9622C20B74C0;
	Thu, 29 Feb 2024 11:59:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9622C20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709236779;
	bh=G8RefpRZLqdFOepXMPPmDviGVAqIh+9z7ml3Ytz4pAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FAEOTZDGgg7u1+aNsJy4wgD3dI4ZJ/MMnTMSY55caDEIorrF7oioQY7Fi2LzMWFSN
	 RaR7XBcH8RrRiU+7ymQEq/w0Gw8ej/+0quxYw1hGfzOqRzW5lj9MAlatW88mfHeiHj
	 mBTrAGBJg01GEvclsyNBG73rkqgfOzbUVfDuKv4o=
Message-ID: <a6061c25-1f7d-4954-b5d3-5d21c6d6df82@linux.microsoft.com>
Date: Thu, 29 Feb 2024 11:59:39 -0800
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
 <b73e3387-558f-4f40-8741-c6ed7965b25f@linux.microsoft.com>
 <20240229194237.GA1454@sol.localdomain>
Content-Language: en-CA
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20240229194237.GA1454@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/29/2024 11:42 AM, Eric Biggers wrote:
> On Thu, Feb 29, 2024 at 10:59:21AM -0800, Fan Wu wrote:
>>>
>>> So IPE is interested in whether a file has an fsverity builtin signature, but it
>>> doesn't care what the signature is or whether it has been checked.  What is the
>>> point?
>>>
>>> - Eric
>>
>> It does make sure the signature is checked. This hook call can only be
>> triggered after fsverity_verify_signature() succeed. Therefore, for files
>> that are marked with the security blob inode_sec->fs_verity_sign as true,
>> they must successfully pass the fsverity_verify_signature() check.
>>
>> Regarding the other question, the current version does not support defining
>> policies to trust files based on the inner content of their signatures
>> because the current patch set is already too large.
>>
>> We plan to introduce new policy grammars to enable the policy to define
>> which certificate of the signature can be trusted after this version is
>> accepted.
> 
> Ah, I see, you're relying on the fact that fsverity_verify_signature() verifies
> the signature (if present) even if fs.verity.require_signatures hasn't been set.
> That does happen to be its behavior, but this isn't clearly documented since
> there previously wasn't really a use case for the builtin signatures without
> setting fs.verity.require_signatures.  Can you please make sure this behavior is
> documented properly in Documentation/filesystems/fsverity.rst and in function
> comments?  Otherwise I worry that it could get changed and break your code.
> 
> - Eric

Thanks for the suggestion. I will add this info in the next version.
-Fan

