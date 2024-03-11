Return-Path: <linux-fscrypt+bounces-243-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8341187876C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 19:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 038001F22307
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 18:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262E34DA10;
	Mon, 11 Mar 2024 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="mFz9z8ar"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A965439AFF;
	Mon, 11 Mar 2024 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710182066; cv=none; b=lMg9vg6/+kwtMK2lx+l/Pjc2vEn9rYx1JaZU1fPuc15sCGqp+b1G1//7UQhSMVAY9au1dajpDtnpfWHgy/+8zxMHuPUvTbtmqZ12R04SWMP2yiu1DXGbVsRZjz+j5Wj3+Tf0e1So8VLmgD0kj/owR8HT08b4NnfNc7pvitHtP34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710182066; c=relaxed/simple;
	bh=yuuZpbBSCUVSrGY6ZKhBWY/+6yGrO/sdr6mf+50hinw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5MT0nE4e8Y9r/AbWOY7fdYfZEJDU1dtgGjLZDgr9XCwjvZ8RNkxssTMozF0NbQTL5BtbUTTa5bc/5863v3BDB1XBi+s5pQH9bN4w/ngefv/doDu6oIckLogx4rRGD0x2dS7nt8FksA3k6S0edWC01jbYYeKgRbqDZYMA5znT1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=mFz9z8ar; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id 1198520B74C0;
	Mon, 11 Mar 2024 11:34:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1198520B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710182063;
	bh=RZfhJKtA70RVNfOir8lzr0ciKj5PtunMNDoxTSux7fE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mFz9z8arBOPU8v6pO+Y+J35vQvitl8VqPkIYNZGGSUMjWOwFkbgdsn/fsaTtgIIqj
	 lm65//Wy3qUMogCm1d3VAgU6qHyzhgARwjBJkoNDAWrpqSE11KxCysxx2ZEwdIUI3b
	 24ndee37du0KS1BRqLoK1y7EAEhmBpQEWFXCie8w=
Message-ID: <553f0f09-45b4-4f4b-9b91-b3c2fe5d6030@linux.microsoft.com>
Date: Mon, 11 Mar 2024 11:34:22 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 05/19] initramfs|security: Add a security hook to
 do_populate_rootfs()
Content-Language: en-CA
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, corbet@lwn.net,
 zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu,
 ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-6-git-send-email-wufan@linux.microsoft.com>
 <cff886eef84ced5b4dfac1be7572dc8d06b63792.camel@huaweicloud.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <cff886eef84ced5b4dfac1be7572dc8d06b63792.camel@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2024 7:53 AM, Roberto Sassu wrote:
> On Wed, 2024-03-06 at 15:34 -0800, Fan Wu wrote:
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
>>
>> ---
>> v1-v11:
>>    + Not present
>>
>> v12:
>>    + Introduced
>>
>> v13:
>>    + Rename the hook name to initramfs_populated()
>>
>> v14:
>>    + No changes
>> ---
>>   include/linux/lsm_hook_defs.h |  2 ++
>>   include/linux/security.h      |  8 ++++++++
>>   init/initramfs.c              |  3 +++
>>   security/security.c           | 10 ++++++++++
>>   4 files changed, 23 insertions(+)
>>
>> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
>> index 76458b6d53da..e0f50789a18f 100644
>> --- a/include/linux/lsm_hook_defs.h
>> +++ b/include/linux/lsm_hook_defs.h
>> @@ -425,3 +425,5 @@ LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>>   LSM_HOOK(int, 0, uring_sqpoll, void)
>>   LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>>   #endif /* CONFIG_IO_URING */
>> +
>> +LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)
> 
> I don't know, but why there is no super_block as parameter?
> 
> And, wouldn't be better to rely on existing hooks to identify inodes in
> the initial ram disk?
> 
> (gdb) p *file->f_path.dentry->d_inode->i_sb->s_type
> $3 = {name = 0xffffffff826058a9 "rootfs"
> 
> That could also help if you want to enforce action based on the
> filesystem name (and why not on the UUID too).
> 
> Roberto
>
We are not passing any parameter here because when populating the 
initramfs, the rootfs can be accessed via current->fs->root. In the next 
patch, we use ipe_sb(current->fs->root.mnt->mnt_sb)->initramfs = true; 
to mark the initramfs via a security blob.

The hook here is used only to signal that files are unpacked into the 
rootfs. The hook won't be triggered if initramfs is not enabled.

Regarding the approach of using the filesystem's name attribute to 
identify files in initramfs, it will treat all files from a filesystem 
named "rootfs" as initramfs files, which could potentially be exploited 
by malicious users. For example, an attacker could override the name of 
an existing filesystem and then load malicious kernel modules from it. 
The LSM would think the kernel modules are from initramfs and allow 
them, which is not what we want.

Also, the rootfs is a ramfs, which doesn't have a UUID, so we couldn't 
use UUID to identify it.

-Fan

>> diff --git a/include/linux/security.h b/include/linux/security.h
>> index d0eb20f90b26..619e17e59532 100644
>> --- a/include/linux/security.h
>> +++ b/include/linux/security.h
>> @@ -2167,4 +2167,12 @@ static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
>>   #endif /* CONFIG_SECURITY */
>>   #endif /* CONFIG_IO_URING */
>>   
>> +#ifdef CONFIG_SECURITY
>> +extern void security_initramfs_populated(void);
>> +#else
>> +static inline void security_initramfs_populated(void)
>> +{
>> +}
>> +#endif /* CONFIG_SECURITY */
>> +
>>   #endif /* ! __LINUX_SECURITY_H */
>> diff --git a/init/initramfs.c b/init/initramfs.c
>> index 76deb48c38cb..140619a583ff 100644
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
>> +	security_initramfs_populated();
>> +
>>   done:
>>   	/*
>>   	 * If the initrd region is overlapped with crashkernel reserved region,
>> diff --git a/security/security.c b/security/security.c
>> index f168bc30a60d..26c28db211fd 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -5619,3 +5619,13 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
>>   	return call_int_hook(uring_cmd, 0, ioucmd);
>>   }
>>   #endif /* CONFIG_IO_URING */
>> +
>> +/**
>> + * security_initramfs_populated() - Notify LSMs that initramfs has been loaded
>> + *
>> + * Tells the LSMs the initramfs has been unpacked into the rootfs.
>> + */
>> +void security_initramfs_populated(void)
>> +{
>> +	call_void_hook(initramfs_populated);
>> +}

