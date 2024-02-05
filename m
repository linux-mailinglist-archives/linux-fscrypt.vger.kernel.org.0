Return-Path: <linux-fscrypt+bounces-172-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4111F84A887
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Feb 2024 23:05:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D31551F2CC82
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Feb 2024 22:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FB94D5B0;
	Mon,  5 Feb 2024 21:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="W8TAC/No"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDC01AB807;
	Mon,  5 Feb 2024 21:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707167885; cv=none; b=NXr3hwdCHpzIW+fj6a1pQ1myxallHAiuK7AYuVvi0Gk2kXxaQPCdC7QzLCTDiFKhMDHUn91kctFgJCpTL2BH4Hi3U6yOz7uU/EFk7976CtlYEol28YuNCmHiGbjdTDXquPCVS/uUIN7qwaxmM++GMl3PIy/+eym2oj0x1P+Dzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707167885; c=relaxed/simple;
	bh=/Enu6bwQmdx49axHA/1lmJJgKYU6G8zyTZPbq9OH+ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CH7Uxpf3Cez8k7ZdIDuPUiiMg1kLZg5cecEHRLfRZ7OEIDG4p/8d5BYOvoOxnO9ebiuiBCez4yzN0H7+C9rP2x9koyqw/0Iz5sRxCbwgnXPwMryetGmJ1XlScJNKjJx/WDTPlDZTPff+sbwZ7Xn7w5VdP6NWOFKbwJOqid+IFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=W8TAC/No; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id B65FB20B2000;
	Mon,  5 Feb 2024 13:18:03 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B65FB20B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707167883;
	bh=H595nLqKN1iU7O92UiJT9PEuwtk7Rd1yCbWBC1ZA8Dk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W8TAC/No1VdGRZqMNpbRyarbJ0N1ksbo6q9VDwms6JAikfNWLiPh8pBpJItN4CS23
	 IfusA0S7VmJXlzwz6fInL7nOKKj4xPLnLwKrHbC0DxeKFY9uDlKLJYrmJTNL3IsRxQ
	 NhwWoikC1Q5N62rvYtOFqHGPmfxebEyKNmpVRN1s=
Message-ID: <13daca32-ee3f-46f5-a6ca-66bb02726e5c@linux.microsoft.com>
Date: Mon, 5 Feb 2024 13:18:03 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v12 5/20] initramfs|security: Add security hook to
 initramfs unpack
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1706654228-17180-6-git-send-email-wufan@linux.microsoft.com>
 <b9ca171301d5abeb78922dd79d65136a@paul-moore.com>
Content-Language: en-US
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <b9ca171301d5abeb78922dd79d65136a@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/3/2024 2:25 PM, Paul Moore wrote:
> On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> This patch introduces a new hook to notify security system that the
>> content of initramfs has been unpacked into the rootfs.
>>
>> Upon receiving this notification, the security system can activate
>> a policy to allow only files that originated from the initramfs to
>> execute or load into kernel during the early stages of booting.
>>
>> This approach is crucial for minimizing the attack surface by
>> ensuring that only trusted files from the initramfs are operational
>> in the critical boot phase.
>>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v1-v11:
>>    + Not present
>>
>> v12:
>>    + Introduced
>> ---
>>   include/linux/lsm_hook_defs.h |  4 ++++
>>   include/linux/security.h      | 10 ++++++++++
>>   init/initramfs.c              |  3 +++
>>   security/security.c           | 12 ++++++++++++
>>   4 files changed, 29 insertions(+)
>>
>> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
>> index 185924c56378..b247388786a9 100644
>> --- a/include/linux/lsm_hook_defs.h
>> +++ b/include/linux/lsm_hook_defs.h
>> @@ -425,3 +425,7 @@ LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>>   LSM_HOOK(int, 0, uring_sqpoll, void)
>>   LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>>   #endif /* CONFIG_IO_URING */
>> +
>> +#ifdef CONFIG_BLK_DEV_INITRD
>> +LSM_HOOK(void, LSM_RET_VOID, unpack_initramfs_security, void)
>> +#endif /* CONFIG_BLK_DEV_INITRD */
> 
> Let's just call it "unpack_initramfs", the "_security" part is somewhat
> implied since we are talking about a LSM hook ;)
> 
>> diff --git a/init/initramfs.c b/init/initramfs.c
>> index 76deb48c38cb..075a5794cde5 100644
>> --- a/init/initramfs.c
>> +++ b/init/initramfs.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/init_syscalls.h>
>>   #include <linux/task_work.h>
>>   #include <linux/umh.h>
>> +#include <linux/security.h>
>>   
>>   static __initdata bool csum_present;
>>   static __initdata u32 io_csum;
>> @@ -720,6 +721,8 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
>>   #endif
>>   	}
>>   
>> +	security_unpack_initramfs();
> 
> Given the caller, what do you think of changing the hook name to
> "security_initramfs_populated()"?  I think this not only matches up
> better with the caller, "do_populate_rootfs()", but since in using the
> past tense we help indicate that this hook happens *after* the rootfs
> is populated with the initramfs data.
> 

Yeah, I agree this sounds better. I will update this part.

-Fan
>>   done:
>>   	/*
>>   	 * If the initrd region is overlapped with crashkernel reserved region,
>> diff --git a/security/security.c b/security/security.c
>> index ddf2e69cf8f2..2a527d4c69bc 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -5581,3 +5581,15 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
>>   	return call_int_hook(uring_cmd, 0, ioucmd);
>>   }
>>   #endif /* CONFIG_IO_URING */
>> +
>> +#ifdef CONFIG_BLK_DEV_INITRD
>> +/**
>> + * security_unpack_initramfs() - Notify LSM that initramfs has been loaded
>> + *
>> + * Tells the LSM the initramfs has been unpacked into the rootfs.
>> + */
>> +void security_unpack_initramfs(void)
>> +{
>> +	call_void_hook(unpack_initramfs_security);
>> +}
>> +#endif /* CONFIG_BLK_DEV_INITRD */
>> -- 
>> 2.43.0
> 
> --
> paul-moore.com

