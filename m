Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5197D8A66
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Oct 2023 23:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjJZVdu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Oct 2023 17:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbjJZVdt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Oct 2023 17:33:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BE03129;
        Thu, 26 Oct 2023 14:33:47 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 81AF920B74C0;
        Thu, 26 Oct 2023 14:33:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81AF920B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698356026;
        bh=4XTXNRGs6EFGxu4uzbSZ7r9fKh4mK0LSSScI1Qs6AQY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lkHsle7iI2VQ1AX+NaZr+9OMmFu99wmEtzfgnr6EJZqK4JVp9txEyJ3iZLIi3Yqiu
         atrmGJ/tt2zKVKq49LWpN05TsSkmG4Wfj5PgbwOkVV+gYOnVpzAz7Pyi+j5RPLfU0o
         BiQVRpCRe8GC+EKvTHzEo1DAKQ4XP+Zkut822rHM=
Message-ID: <616a6fd7-47b1-4b46-af23-46f9b1a3eedf@linux.microsoft.com>
Date:   Thu, 26 Oct 2023 14:33:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust
 provider
To:     Paul Moore <paul@paul-moore.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
 <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
Content-Language: en-US
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> IPE is designed to provide system level trust guarantees, this usually
>> implies that trust starts from bootup with a hardware root of trust,
>> which validates the bootloader. After this, the bootloader verifies the
>> kernel and the initramfs.
>>
>> As there's no currently supported integrity method for initramfs, and
>> it's typically already verified by the bootloader, introduce a property
>> that causes the first superblock to have an execution to be "pinned",
>> which is typically initramfs.
>>
>> When the "pinned" device is unmounted, it will be "unpinned" and
>> `boot_verified` property will always evaluate to false afterward.
>>
>> We use a pointer with a spin_lock to "pin" the device instead of rcu
>> because rcu synchronization may sleep, which is not allowed when
>> unmounting a device.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
>>   security/ipe/eval.h          |  2 +
>>   security/ipe/hooks.c         | 12 ++++++
>>   security/ipe/hooks.h         |  2 +
>>   security/ipe/ipe.c           |  1 +
>>   security/ipe/policy.h        |  2 +
>>   security/ipe/policy_parser.c | 35 +++++++++++++++++-
>>   7 files changed, 124 insertions(+), 2 deletions(-)
>>
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> index 8a8bcc5c7d7f..bdac4abc0ddb 100644
>> --- a/security/ipe/eval.c
>> +++ b/security/ipe/eval.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/file.h>
>>   #include <linux/sched.h>
>>   #include <linux/rcupdate.h>
>> +#include <linux/spinlock.h>
>>   
>>   #include "ipe.h"
>>   #include "eval.h"
>> @@ -16,6 +17,44 @@
>>   
>>   struct ipe_policy __rcu *ipe_active_policy;
>>   
>> +static const struct super_block *pinned_sb;
>> +static DEFINE_SPINLOCK(pin_lock);
>> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
>> +
>> +/**
>> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
>> + * @sb: Supplies a super_block structure to be pinned.
>> + */
>> +static void pin_sb(const struct super_block *sb)
>> +{
>> +	if (!sb)
>> +		return;
>> +	spin_lock(&pin_lock);
>> +	if (!pinned_sb)
>> +		pinned_sb = sb;
>> +	spin_unlock(&pin_lock);
>> +}
>> +
>> +/**
>> + * from_pinned - Determine whether @sb is the pinned super_block.
>> + * @sb: Supplies a super_block to check against the pinned super_block.
>> + *
>> + * Return:
>> + * * true	- @sb is the pinned super_block
>> + * * false	- @sb is not the pinned super_block
>> + */
>> +static bool from_pinned(const struct super_block *sb)
>> +{
>> +	bool rv;
>> +
>> +	if (!sb)
>> +		return false;
>> +	spin_lock(&pin_lock);
>> +	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
>> +	spin_unlock(&pin_lock);
> 
> It's okay for an initial version, but I still think you need to get
> away from this spinlock in from_pinned() as quickly as possible.
> Maybe I'm wrong, but this looks like a major source of lock contention.
> 
> I understand the issue around RCU and the potential for matching on
> a reused buffer/address, but if you modified IPE to have its own LSM
> security blob in super_block::security you could mark the superblock
> when it was mounted and do a lockless lookup here in from_pinned().
> 
Thank you for the suggestion. After some testing, I discovered that 
switching to RCU to pin the super block and using a security blob to 
mark a pinned super block works. This approach do avoid many spinlock 
operations. I'll incorporate these changes in the next version of the patch.

-Fan
>> +	return rv;
>> +}
> 
> --
> paul-moore.com
