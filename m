Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5BFEA4D03
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Sep 2019 03:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfIBBHY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Sep 2019 21:07:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729147AbfIBBHX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Sep 2019 21:07:23 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DFEAACCBADF9A72EFC1A;
        Mon,  2 Sep 2019 09:07:21 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.204) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 2 Sep 2019
 09:07:17 +0800
Subject: Re: [PATCH] ext4 crypto: fix to check feature status before get
 policy
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>
References: <20190804095643.7393-1-chao@kernel.org>
 <f5186fae-ac58-a5f5-f9dc-b749ade7285d@huawei.com>
 <20190831150251.GA528@zzz.localdomain>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <a6a452d6-aee3-76e1-4a6c-e31247a5a72e@huawei.com>
Date:   Mon, 2 Sep 2019 09:07:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190831150251.GA528@zzz.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2019/8/31 23:02, Eric Biggers wrote:
> On Sat, Aug 31, 2019 at 06:32:28PM +0800, Chao Yu wrote:
>> Hi,
>>
>> Is this change not necessary? A month has passed...
>>
>> Thanks,
>>
>> On 2019/8/4 17:56, Chao Yu wrote:
>>> From: Chao Yu <yuchao0@huawei.com>
>>>
>>> When getting fscrypto policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
>>> encryption feature is off, it's better to return EOPNOTSUPP instead
>>> of ENODATA, so let's add ext4_has_feature_encrypt() to do the check
>>> for that.
>>>
>>> Signed-off-by: Chao Yu <yuchao0@huawei.com>
>>> ---
>>>  fs/ext4/ioctl.c | 6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>>> index 442f7ef873fc..bf87835c1237 100644
>>> --- a/fs/ext4/ioctl.c
>>> +++ b/fs/ext4/ioctl.c
>>> @@ -1112,9 +1112,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>>>  		return -EOPNOTSUPP;
>>>  #endif
>>>  	}
>>> -	case EXT4_IOC_GET_ENCRYPTION_POLICY:
>>> +	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
>>> +		if (!ext4_has_feature_encrypt(sb))
>>> +			return -EOPNOTSUPP;
>>>  		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
>>> -
>>> +	}
>>>  	case EXT4_IOC_FSGETXATTR:
>>>  	{
>>>  		struct fsxattr fa;
>>>
> 
> Sorry, I was preoccupied with all the other fscrypt changes, and was thinking of
> waiting until 5.5 for this to avoid a potential extra merge conflict or a
> potentially breaking change.  Looking at this again though, the new ioctl
> FS_IOC_GET_ENCRYPTION_POLICY_EX *does* do the feature check, which doesn't match
> the documentation, which implies the check isn't done.  Also, f2fs does the
> check in FS_IOC_GET_ENCRYPTION_POLICY, so the filesystems are inconsistent.
> 
> So, it makes some sense to apply this now.  So I've gone ahead and applied the
> following to fscrypt.git#master, edited a bit from your original patch:
> 
>>From 0642ea2409f3bfa105570e12854b8e2628db6835 Mon Sep 17 00:00:00 2001
> From: Chao Yu <yuchao0@huawei.com>
> Date: Sun, 4 Aug 2019 17:56:43 +0800
> Subject: [PATCH] ext4 crypto: fix to check feature status before get policy
> 
> When getting fscrypt policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
> encryption feature is off, it's better to return EOPNOTSUPP instead of
> ENODATA, so let's add ext4_has_feature_encrypt() to do the check for
> that.
> 
> This makes it so that all fscrypt ioctls consistently check for the
> encryption feature, and makes ext4 consistent with f2fs in this regard.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> [EB - removed unneeded braces, updated the documentation, and
>       added more explanation to commit message]

The patch looks better now, thanks for the help.

Thanks,

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 3 ++-
>  fs/ext4/ioctl.c                       | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 4289c29d7c5a..8a0700af9596 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -562,7 +562,8 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX can fail with the following errors:
>    or this kernel is too old to support FS_IOC_GET_ENCRYPTION_POLICY_EX
>    (try FS_IOC_GET_ENCRYPTION_POLICY instead)
>  - ``EOPNOTSUPP``: the kernel was not configured with encryption
> -  support for this filesystem
> +  support for this filesystem, or the filesystem superblock has not
> +  had encryption enabled on it
>  - ``EOVERFLOW``: the file is encrypted and uses a recognized
>    encryption policy version, but the policy struct does not fit into
>    the provided buffer
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index fe5a4b13f939..5703d607f5af 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1113,6 +1113,8 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  #endif
>  	}
>  	case EXT4_IOC_GET_ENCRYPTION_POLICY:
> +		if (!ext4_has_feature_encrypt(sb))
> +			return -EOPNOTSUPP;
>  		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
>  
>  	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> 
