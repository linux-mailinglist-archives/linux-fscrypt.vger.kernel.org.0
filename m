Return-Path: <linux-fscrypt+bounces-164-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55212848001
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 04:57:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB8A4289C66
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 03:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B61EF9FD;
	Sat,  3 Feb 2024 03:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="m/clajfx"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85594F9D7;
	Sat,  3 Feb 2024 03:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706932616; cv=none; b=GTRhB69qjA7JAhShsrlvg157pXbr4NwEKNkj8MgLXIdXMEyqx907g8kZm+pr36LcPRlbkAncIBzLMtvhNntdFRjxXqffiz7VUCbBMOWcHJSDSluwV34GVHpd68f34wcyE62oGanO/ujG6ldhGjNHll6lfRdK92Gf2LJXRZs/elo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706932616; c=relaxed/simple;
	bh=ZxPkhkdkh/qzOmQ6tzCINtYqo1Amarn570/0hPuCEws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZcddcnhpE5NA4Y65si7OfagtKnE3N3L6G4Yry+aC88qjaiY4u+P+vI1W2+UpNPpPxPo0OoSEGj2entHjZ+wsfXeJBQhBPxmhVum0BjvrQSi/bXTRL7Ff2gV6VQTmt3yfwMhNhNQESEVhCBgTWRlwvwLc+JyDZno4Tkv0Z9jRyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=m/clajfx; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id E44F1206FD0D;
	Fri,  2 Feb 2024 19:56:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E44F1206FD0D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706932614;
	bh=0jiNLQIjYZrK1snHh4U7Lo4wv1LyM7JCqFc7TqpIT2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m/clajfxDfxFvAcTDd46NYouM6uhFugKVWR8uHm4sE6EFTynnuvqsAFU7GTarPWIH
	 y7EQZ7z1rcxftAwNX6cuTOp1ixL13ykPZ5kzqZcWa3CA9w9UEpQl0TTQWWnYBc/fAu
	 sCvZECuOFeoyIVWglZe2vjeuBACkQz0fknf7owY4=
Message-ID: <dd6f4726-692b-4537-8bb4-a0466f24d713@linux.microsoft.com>
Date: Fri, 2 Feb 2024 19:56:53 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v12 12/20] dm verity: set DM_TARGET_SINGLETON feature
 flag
To: Mike Snitzer <snitzer@kernel.org>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
 <1706654228-17180-13-git-send-email-wufan@linux.microsoft.com>
 <Zb05y2cl3T9rxRJZ@redhat.com>
Content-Language: en-US
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <Zb05y2cl3T9rxRJZ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/2/2024 10:51 AM, Mike Snitzer wrote:
> On Tue, Jan 30 2024 at  5:37P -0500,
> Fan Wu <wufan@linux.microsoft.com> wrote:
> 
>> The device-mapper has a flag to mark targets as singleton, which is a
>> required flag for immutable targets. Without this flag, multiple
>> dm-verity targets can be added to a mapped device, which has no
>> practical use cases and will let dm_table_get_immutable_target return
>> NULL. This patch adds the missing flag, restricting only one
>> dm-verity target per mapped device.
>>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>>
>> ---
>> v1-v10:
>>    + Not present
>>
>> v11:
>>    + Introduced
>>
>> v12:
>>    + No changes
>> ---
>>   drivers/md/dm-verity-target.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
>> index 14e58ae70521..66a850c02be4 100644
>> --- a/drivers/md/dm-verity-target.c
>> +++ b/drivers/md/dm-verity-target.c
>> @@ -1507,7 +1507,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
>>   
>>   static struct target_type verity_target = {
>>   	.name		= "verity",
>> -	.features	= DM_TARGET_IMMUTABLE,
>> +	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
>>   	.version	= {1, 9, 0},
>>   	.module		= THIS_MODULE,
>>   	.ctr		= verity_ctr,
>> -- 
>> 2.43.0
>>
>>
> 
> It is true this change will cause dm_table_get_immutable_target() to
> not return NULL, but: I'm curious how that is meaningful in the
> context of dm-verity? (given the only caller of
> dm_table_get_immutable_target() is request-based DM code in DM core.)
> 
> Thanks,
> Mike

Sorry for the confusion. The reference of 
dm_table_get_immutable_target() is only to justify an immutable target 
should also be a 
singleton(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/md/dm-table.c#n982). 
It is not directly related to dm-verity.

In the context of dm-verity. I found although veritysetup does ensure 
the dm-verity target as a singleton, users can still use dmsetup to 
configure multiple dm-verity targets within a single map table. This 
leads to a situation where only the first target can be accessed. 
Therefore to prevent this and similar misuse, I propose introducing 
DM_TARGET_SINGLETON to allow the kernel to enforce dm-verity targets as 
singletons.

Thanks,
Fan

