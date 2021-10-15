Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63ED142FC0A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Oct 2021 21:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242751AbhJOT2K (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Oct 2021 15:28:10 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52042 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242676AbhJOT2D (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Oct 2021 15:28:03 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id F35ED20B9D2C;
        Fri, 15 Oct 2021 12:25:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F35ED20B9D2C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634325956;
        bh=WiFPeoYYf7JgIE6cLQcFBOiHdI1T+QFJIC56m0pwNME=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ha4ZoNtXPkA3Jy44+DtQuIH/9nRXhlj71wdDl3ZD4qRkWf0uWLjhmAuxtUYWHcir0
         +Kz7vE9jspYUaEhiVhvtVbp6BvXVU7M/QXphO+ld7/jPO9jeobx0ln+Z7rdztYXgqg
         AXpQlPV5pSEZVFh6T8t2cv3wVm9ZPL7SsWmuwPIc=
Message-ID: <3b127720-d486-18da-4f1d-afe402fb39c4@linux.microsoft.com>
Date:   Fri, 15 Oct 2021 12:25:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v7 05/16] ipe: add LSM hooks on execution and kernel
 read
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>, corbet@lwn.net,
        axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
        ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Cc:     linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        jannh@google.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-6-git-send-email-deven.desai@linux.microsoft.com>
 <a358e0b0-2fc0-8b03-4bee-141675fdc73e@schaufler-ca.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <a358e0b0-2fc0-8b03-4bee-141675fdc73e@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/13/2021 1:04 PM, Casey Schaufler wrote:
> On 10/13/2021 12:06 PM, deven.desai@linux.microsoft.com wrote:
>> From: Deven Bowers <deven.desai@linux.microsoft.com>
>>
>> IPE's initial goal is to control both execution and the loading of
>> kernel modules based on the system's definition of trust. It
>> accomplishes this by plugging into the security hooks for execve,
>> mprotect, mmap, kernel_load_data and kernel_read_data.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> ---
>>
>> Relevant changes since v6:
>>    * Split up patch 02/12 into four parts:
>>        1. context creation [01/16]
>>        2. audit [07/16]
>>        3. evaluation loop [03/16]
>>        4. access control hooks [05/16] (this patch)
>>
>> ---
>>   security/ipe/hooks.c  | 149 ++++++++++++++++++++++++++++++++++++++++++
>>   security/ipe/hooks.h  |  23 ++++++-
>>   security/ipe/ipe.c    |   5 ++
>>   security/ipe/policy.c |  23 +++++++
>>   security/ipe/policy.h |  12 +++-
>>   5 files changed, 209 insertions(+), 3 deletions(-)
>>
>> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
>> index ed0c886eaa5a..216242408a80 100644
>> --- a/security/ipe/hooks.c
>> +++ b/security/ipe/hooks.c
>> @@ -6,11 +6,15 @@
>>   #include "ipe.h"
>>   #include "ctx.h"
>>   #include "hooks.h"
>> +#include "eval.h"
>>   
>> +#include <linux/fs.h>
>>   #include <linux/sched.h>
>>   #include <linux/types.h>
>>   #include <linux/refcount.h>
>>   #include <linux/rcupdate.h>
>> +#include <linux/binfmts.h>
>> +#include <linux/mman.h>
>>   
>>   /**
>>    * ipe_task_alloc: Assign a new context for an associated task structure.
>> @@ -56,3 +60,148 @@ void ipe_task_free(struct task_struct *task)
>>   	ipe_put_ctx(ctx);
>>   	rcu_read_unlock();
>>   }
>> +
>> +/**
>> + * ipe_on_exec: LSM hook called when a process is loaded through the exec
>> + *		family of system calls.
>> + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
>> + *	  being evaluated.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +int ipe_on_exec(struct linux_binprm *bprm)
>> +{
>> +	return ipe_process_event(bprm->file, ipe_operation_exec, ipe_hook_exec);
>> +}
>> +
>> +/**
>> + * ipe_on_mmap: LSM hook called when a file is loaded through the mmap
>> + *		family of system calls.
>> + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
>> + * @reqprot: The requested protection on the mmap, passed from usermode.
>> + * @prot: The effective protection on the mmap, resolved from reqprot and
>> + *	  system configuration.
>> + * @flags: Unused.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
>> +		unsigned long flags)
>> +{
>> +	if (prot & PROT_EXEC || reqprot & PROT_EXEC)
>> +		return ipe_process_event(f, ipe_operation_exec, ipe_hook_mmap);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ipe_on_mprotect: LSM hook called when a mmap'd region of memory is changing
>> + *		    its protections via mprotect.
>> + * @vma: Existing virtual memory area created by mmap or similar
>> + * @reqprot: The requested protection on the mmap, passed from usermode.
>> + * @prot: The effective protection on the mmap, resolved from reqprot and
>> + *	  system configuration.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
>> +		    unsigned long prot)
>> +{
>> +	/* Already Executable */
>> +	if (vma->vm_flags & VM_EXEC)
>> +		return 0;
>> +
>> +	if (((prot & PROT_EXEC) || reqprot & PROT_EXEC))
>> +		return ipe_process_event(vma->vm_file, ipe_operation_exec,
>> +					 ipe_hook_mprotect);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * ipe_on_kernel_read: LSM hook called when a file is being read in from
>> + *		       disk.
>> + * @file: Supplies a pointer to the file structure being read in from disk
>> + * @id: Supplies the enumeration identifying the purpose of the read.
>> + * @contents: Unused.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
>> +		       bool contents)
>> +{
>> +	enum ipe_operation op;
>> +
>> +	switch (id) {
>> +	case READING_FIRMWARE:
>> +		op = ipe_operation_firmware;
>> +		break;
>> +	case READING_MODULE:
>> +		op = ipe_operation_kernel_module;
>> +		break;
>> +	case READING_KEXEC_INITRAMFS:
>> +		op = ipe_operation_kexec_initramfs;
>> +		break;
>> +	case READING_KEXEC_IMAGE:
>> +		op = ipe_operation_kexec_image;
>> +		break;
>> +	case READING_POLICY:
>> +		op = ipe_operation_ima_policy;
>> +		break;
>> +	case READING_X509_CERTIFICATE:
>> +		op = ipe_operation_ima_x509;
>> +		break;
>> +	default:
>> +		op = ipe_operation_max;
>> +	}
>> +
>> +	return ipe_process_event(file, op, ipe_hook_kernel_read);
>> +}
>> +
>> +/**
>> + * ipe_on_kernel_load_data: LSM hook called when a buffer is being read in from
>> + *			    disk.
>> + * @id: Supplies the enumeration identifying the purpose of the read.
>> + * @contents: Unused.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents)
>> +{
>> +	enum ipe_operation op;
>> +
>> +	switch (id) {
>> +	case LOADING_FIRMWARE:
>> +		op = ipe_operation_firmware;
>> +		break;
>> +	case LOADING_MODULE:
>> +		op = ipe_operation_kernel_module;
>> +		break;
>> +	case LOADING_KEXEC_INITRAMFS:
>> +		op = ipe_operation_kexec_initramfs;
>> +		break;
>> +	case LOADING_KEXEC_IMAGE:
>> +		op = ipe_operation_kexec_image;
>> +		break;
>> +	case LOADING_POLICY:
>> +		op = ipe_operation_ima_policy;
>> +		break;
>> +	case LOADING_X509_CERTIFICATE:
>> +		op = ipe_operation_ima_x509;
>> +		break;
>> +	default:
>> +		op = ipe_operation_max;
>> +	}
>> +
>> +	return ipe_process_event(NULL, op, ipe_hook_kernel_load);
>> +}
>> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
>> index 58ed4a612e26..c99a0b7f45f7 100644
>> --- a/security/ipe/hooks.h
>> +++ b/security/ipe/hooks.h
>> @@ -5,11 +5,19 @@
>>   #ifndef IPE_HOOKS_H
>>   #define IPE_HOOKS_H
>>   
>> +#include <linux/fs.h>
>>   #include <linux/types.h>
>>   #include <linux/sched.h>
>> +#include <linux/binfmts.h>
>> +#include <linux/security.h>
>>   
>>   enum ipe_hook {
>> -	ipe_hook_max = 0
>> +	ipe_hook_exec = 0,
>> +	ipe_hook_mmap,
>> +	ipe_hook_mprotect,
>> +	ipe_hook_kernel_read,
>> +	ipe_hook_kernel_load,
>> +	ipe_hook_max
>>   };
>>   
>>   int ipe_task_alloc(struct task_struct *task,
>> @@ -17,4 +25,17 @@ int ipe_task_alloc(struct task_struct *task,
>>   
>>   void ipe_task_free(struct task_struct *task);
>>   
>> +int ipe_on_exec(struct linux_binprm *bprm);
>> +
>> +int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
>> +		unsigned long flags);
>> +
>> +int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
>> +		    unsigned long prot);
>> +
>> +int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
>> +		       bool contents);
>> +
>> +int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
>> +
>>   #endif /* IPE_HOOKS_H */
>> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
>> index b58b372327a1..3f9d43783293 100644
>> --- a/security/ipe/ipe.c
>> +++ b/security/ipe/ipe.c
>> @@ -25,6 +25,11 @@ struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
>>   static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
>>   	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
>>   	LSM_HOOK_INIT(task_free, ipe_task_free),
>> +	LSM_HOOK_INIT(bprm_check_security, ipe_on_exec),
>> +	LSM_HOOK_INIT(mmap_file, ipe_on_mmap),
>> +	LSM_HOOK_INIT(file_mprotect, ipe_on_mprotect),
>> +	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
>> +	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
> Please stick with the lsmname_hook_name convention, as you did
> with ipe_task_alloc and ipe_task_free. Anyone who is looking at
> more than one LSM is going to have a much harder time working
> with your code the way you have it. Think
>
> 	% find security | xargs grep '_bprm_check_security('

Sure. I'll make this change with the v8 series.


