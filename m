Return-Path: <linux-fscrypt+bounces-242-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3056987870A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 19:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 545A21C20E9A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 18:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006D4537EE;
	Mon, 11 Mar 2024 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VHtK0knn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 255B01EB5C;
	Mon, 11 Mar 2024 18:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710180658; cv=none; b=AXJkU2UvnLl0q8dsi67WghPEVQ/sbyq7WNFLdo1IXDsaPffHi8igThayP2ZfKS15oKfPyaJDpsJTvze81RbwWoesP3yr4/hfy3QnztBe7s4tQ3/5UyziKh9ZYPAiTTfWJcDhRl3ouJ5OzohqjNz/lrU6jL4nkHB/Buts0JbmkI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710180658; c=relaxed/simple;
	bh=IlpA1JdDk979yXLkGRM+oxDPT5bK6ueS7QlDrgRmw7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O/hEhQkH90K0KcfcNS+AEAKvBY6E+b+upqKDd5tMtnngwcLkFVJfkuKHWVhnVKtGs2/w4vxrcvohrhPMKUgbL+onOoCULSnW3dvl5hBbyS7mi5rgpac910Bu2iqmK+BMH1eCxMZEoS6w3CcJBq3e+a8nDoPbwbH9gAQqT3mKmkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VHtK0knn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7F32B20B74C0;
	Mon, 11 Mar 2024 11:10:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7F32B20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710180654;
	bh=xbhwVp3nppXLf2bz4+VzXn2ef5pW4ZLtcKrUCC0s6oc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VHtK0knneBY7bnXaWkXbbfxbekWNaF5L4lbPiC/aa3AtSGgdPCPYKfdfXtJW/PBBn
	 GtDWVCu1XMqQXuRkVdSWyHkLl/IFY5005VvSho8vmiA6qMUChbzHUaNbJx58XqMqsO
	 gapRoOZxJB3uq1+eg7Lhx54WmiZstmlselC1Y+54=
Message-ID: <9b02176a-3842-460c-a78f-f4d4debfde5b@linux.microsoft.com>
Date: Mon, 11 Mar 2024 11:10:54 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 01/19] security: add ipe lsm
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, corbet@lwn.net,
 zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu,
 ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-2-git-send-email-wufan@linux.microsoft.com>
 <21597a6e143e4110d0103ef1421ac87fa98b7f32.camel@huaweicloud.com>
Content-Language: en-CA
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <21597a6e143e4110d0103ef1421ac87fa98b7f32.camel@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2024 7:25 AM, Roberto Sassu wrote:
> On Wed, 2024-03-06 at 15:34 -0800, Fan Wu wrote:
>> From: Deven Bowers <deven.desai@linux.microsoft.com>
>>
>> Integrity Policy Enforcement (IPE) is an LSM that provides an
>> complimentary approach to Mandatory Access Control than existing LSMs
>> today.
>>
>> Existing LSMs have centered around the concept of access to a resource
>> should be controlled by the current user's credentials. IPE's approach,
>> is that access to a resource should be controlled by the system's trust
>> of a current resource.
>>
>> The basis of this approach is defining a global policy to specify which
>> resource can be trusted.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v2:
>>    + Split evaluation loop, access control hooks,
>>      and evaluation loop from policy parser and userspace
>>      interface to pass mailing list character limit
>>
>> v3:
>>    + Move ipe_load_properties to patch 04.
>>    + Remove useless 0-initializations
>>    + Prefix extern variables with ipe_
>>    + Remove kernel module parameters, as these are
>>      exposed through sysctls.
>>    + Add more prose to the IPE base config option
>>      help text.
>>    + Use GFP_KERNEL for audit_log_start.
>>    + Remove unnecessary caching system.
>>    + Remove comments from headers
>>    + Use rcu_access_pointer for rcu-pointer null check
>>    + Remove usage of reqprot; use prot only.
>>    + Move policy load and activation audit event to 03/12
>>
>> v4:
>>    + Remove sysctls in favor of securityfs nodes
>>    + Re-add kernel module parameters, as these are now
>>      exposed through securityfs.
>>    + Refactor property audit loop to a separate function.
>>
>> v5:
>>    + fix minor grammatical errors
>>    + do not group rule by curly-brace in audit record,
>>      reconstruct the exact rule.
>>
>> v6:
>>    + No changes
>>
>> v7:
>>    + Further split lsm creation into a separate commit from the
>>      evaluation loop and audit system, for easier review.
>>
>>    + Introduce the concept of an ipe_context, a scoped way to
>>      introduce execution policies, used initially for allowing for
>>      kunit tests in isolation.
>>
>> v8:
>>    + Follow lsmname_hook_name convention for lsm hooks.
>>    + Move LSM blob accessors to ipe.c and mark LSM blobs as static.
>>
>> v9:
>>    + Remove ipe_context for simplification
>>
>> v10:
>>    + Add github url
>>
>> v11:
>>    + Correct github url
>>    + Move ipe before bpf
>>
>> v12:
>>    + Switch to use lsm_id instead of string for lsm name
>>
>> v13:
>>    + No changes
>>
>> v14:
>>    + No changes
>> ---
>>   MAINTAINERS              |  7 +++++++
>>   include/uapi/linux/lsm.h |  1 +
>>   security/Kconfig         | 11 ++++++-----
>>   security/Makefile        |  1 +
>>   security/ipe/Kconfig     | 17 +++++++++++++++++
>>   security/ipe/Makefile    |  9 +++++++++
>>   security/ipe/ipe.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>>   security/ipe/ipe.h       | 16 ++++++++++++++++
>>   security/security.c      |  3 ++-
>>   9 files changed, 100 insertions(+), 6 deletions(-)
>>   create mode 100644 security/ipe/Kconfig
>>   create mode 100644 security/ipe/Makefile
>>   create mode 100644 security/ipe/ipe.c
>>   create mode 100644 security/ipe/ipe.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 13158047f2af..8517011f88ff 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -10650,6 +10650,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
>>   F:	security/integrity/
>>   F:	security/integrity/ima/
>>   
>> +INTEGRITY POLICY ENFORCEMENT (IPE)
>> +M:	Fan Wu <wufan@linux.microsoft.com>
>> +L:	linux-security-module@vger.kernel.org
>> +S:	Supported
>> +T:	git https://github.com/microsoft/ipe.git
>> +F:	security/ipe/
>> +
>>   INTEL 810/815 FRAMEBUFFER DRIVER
>>   M:	Antonino Daplas <adaplas@gmail.com>
>>   L:	linux-fbdev@vger.kernel.org
>> diff --git a/include/uapi/linux/lsm.h b/include/uapi/linux/lsm.h
>> index f8aef9ade549..43e2fb32745a 100644
>> --- a/include/uapi/linux/lsm.h
>> +++ b/include/uapi/linux/lsm.h
>> @@ -62,6 +62,7 @@ struct lsm_ctx {
>>   #define LSM_ID_LOCKDOWN		108
>>   #define LSM_ID_BPF		109
>>   #define LSM_ID_LANDLOCK		110
>> +#define LSM_ID_IPE		111
>>   
>>   /*
>>    * LSM_ATTR_XXX definitions identify different LSM attributes
>> diff --git a/security/Kconfig b/security/Kconfig
>> index 52c9af08ad35..cc7adfbb6b96 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -194,6 +194,7 @@ source "security/yama/Kconfig"
>>   source "security/safesetid/Kconfig"
>>   source "security/lockdown/Kconfig"
>>   source "security/landlock/Kconfig"
>> +source "security/ipe/Kconfig"
>>   
>>   source "security/integrity/Kconfig"
>>   
>> @@ -233,11 +234,11 @@ endchoice
>>   
>>   config LSM
>>   	string "Ordered list of enabled LSMs"
>> -	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
>> -	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
>> -	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
>> -	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECURITY_DAC
>> -	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"
>> +	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,ipe,bpf" if DEFAULT_SECURITY_SMACK
>> +	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,ipe,bpf" if DEFAULT_SECURITY_APPARMOR
>> +	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,ipe,bpf" if DEFAULT_SECURITY_TOMOYO
>> +	default "landlock,lockdown,yama,loadpin,safesetid,ipe,bpf" if DEFAULT_SECURITY_DAC
>> +	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,ipe,bpf"
>>   	help
>>   	  A comma-separated list of LSMs, in initialization order.
>>   	  Any LSMs left off this list, except for those with order
>> diff --git a/security/Makefile b/security/Makefile
>> index 59f238490665..cc0982214b84 100644
>> --- a/security/Makefile
>> +++ b/security/Makefile
>> @@ -25,6 +25,7 @@ obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
>>   obj-$(CONFIG_CGROUPS)			+= device_cgroup.o
>>   obj-$(CONFIG_BPF_LSM)			+= bpf/
>>   obj-$(CONFIG_SECURITY_LANDLOCK)		+= landlock/
>> +obj-$(CONFIG_SECURITY_IPE)		+= ipe/
>>   
>>   # Object integrity file lists
>>   obj-$(CONFIG_INTEGRITY)			+= integrity/
>> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
>> new file mode 100644
>> index 000000000000..e4875fb04883
>> --- /dev/null
>> +++ b/security/ipe/Kconfig
>> @@ -0,0 +1,17 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +#
>> +# Integrity Policy Enforcement (IPE) configuration
>> +#
>> +
>> +menuconfig SECURITY_IPE
>> +	bool "Integrity Policy Enforcement (IPE)"
>> +	depends on SECURITY && SECURITYFS
>> +	select PKCS7_MESSAGE_PARSER
>> +	select SYSTEM_DATA_VERIFICATION
>> +	help
>> +	  This option enables the Integrity Policy Enforcement LSM
>> +	  allowing users to define a policy to enforce a trust-based access
>> +	  control. A key feature of IPE is a customizable policy to allow
>> +	  admins to reconfigure trust requirements on the fly.
>> +
>> +	  If unsure, answer N.
>> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
>> new file mode 100644
>> index 000000000000..f7a80d0f18f8
>> --- /dev/null
>> +++ b/security/ipe/Makefile
>> @@ -0,0 +1,9 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Copyright (C) Microsoft Corporation. All rights reserved.
>> +#
>> +# Makefile for building the IPE module as part of the kernel tree.
>> +#
>> +
>> +obj-$(CONFIG_SECURITY_IPE) += \
>> +	ipe.o \
>> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
>> new file mode 100644
>> index 000000000000..b013aed15e73
>> --- /dev/null
>> +++ b/security/ipe/ipe.c
>> @@ -0,0 +1,41 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +#include <uapi/linux/lsm.h>
>> +
>> +#include "ipe.h"
>> +
>> +static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
>> +};
>> +
>> +static const struct lsm_id ipe_lsmid = {
>> +	.name = "ipe",
>> +	.id = LSM_ID_IPE,
>> +};
>> +
>> +static struct security_hook_list ipe_hooks[] __ro_after_init = {
>> +};
>> +
>> +/**
>> + * ipe_init - Entry point of IPE.
>> + *
>> + * This is called at LSM init, which happens occurs early during kernel
>> + * start up. During this phase, IPE registers its hooks and loads the
>> + * builtin boot policy.
>> + * Return:
>> + * * 0		- OK
>> + * * -ENOMEM	- Out of memory
>> + */
>> +static int __init ipe_init(void)
>> +{
>> +	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), &ipe_lsmid);
>> +
>> +	return 0;
>> +}
>> +
>> +DEFINE_LSM(ipe) = {
>> +	.name = "ipe",
>> +	.init = ipe_init,
>> +	.blobs = &ipe_blobs,
>> +};
>> diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
>> new file mode 100644
>> index 000000000000..a1c68d0fc2e0
>> --- /dev/null
>> +++ b/security/ipe/ipe.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#ifndef _IPE_H
>> +#define _IPE_H
>> +
>> +#ifdef pr_fmt
>> +#undef pr_fmt
>> +#endif
>> +#define pr_fmt(fmt) "IPE: " fmt
>> +
>> +#include <linux/lsm_hooks.h>
>> +
>> +#endif /* _IPE_H */
>> diff --git a/security/security.c b/security/security.c
>> index 7035ee35a393..f168bc30a60d 100644
>> --- a/security/security.c
>> +++ b/security/security.c
>> @@ -51,7 +51,8 @@
>>   	(IS_ENABLED(CONFIG_SECURITY_SAFESETID) ? 1 : 0) + \
>>   	(IS_ENABLED(CONFIG_SECURITY_LOCKDOWN_LSM) ? 1 : 0) + \
>>   	(IS_ENABLED(CONFIG_BPF_LSM) ? 1 : 0) + \
>> -	(IS_ENABLED(CONFIG_SECURITY_LANDLOCK) ? 1 : 0))
>> +	(IS_ENABLED(CONFIG_SECURITY_LANDLOCK) ? 1 : 0) + \
>> +	(IS_ENABLED(CONFIG_SECURITY_IPE) ? 1 : 0))
> 
> Hi Fan
> 
> you would also need to update
> tools/testing/selftests/lsm/lsm_list_modules_test.c.
> 
> Roberto
>   
>>   /*
>>    * These are descriptions of the reasons that can be passed to the

Hi Roberto,

Thanks for the info. I will also update that file.

-Fan

