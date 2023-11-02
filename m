Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E667DFCAA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 23:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbjKBWzT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 18:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjKBWzS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 18:55:18 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8749133;
        Thu,  2 Nov 2023 15:55:12 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0DD9A20B74C0;
        Thu,  2 Nov 2023 15:55:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DD9A20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698965712;
        bh=wxUvcwrX53Zjb5IfQjMd76sktwF0Bx1xsTYH7qW6t7I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZWlloepImZ9GRatND4xjl+xB9RQLb+0EGP2ccqYh7w3J+meHB2n0Lt3mKKgoZIB0T
         mo/DceKwkSOtPHBLuAhyn1hVqu3Ke1ESaWr3oz5dvGU+lWgVDed9LRrzpz/tjmsyKL
         JblNh4/JWBfRQo9Tk6xrxeG/vIhYJDkHFLjI36Vg=
Message-ID: <d2a51f1e-14eb-4757-a1b8-1dcfb4635002@linux.microsoft.com>
Date:   Thu, 2 Nov 2023 15:55:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 8/19] uapi|audit|ipe: add ipe auditing support
Content-Language: en-US
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
References: <1696457386-3010-9-git-send-email-wufan@linux.microsoft.com>
 <9217384a1f58c5d3431b90f100c7de85.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <9217384a1f58c5d3431b90f100c7de85.paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> Users of IPE require a way to identify when and why an operation fails,
>> allowing them to both respond to violations of policy and be notified
>> of potentially malicious actions on their systems with respect to IPE
>> itself.
>>
>> This patch introduces 3 new audit events.
>>
>> AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
>> of a resource.
>> AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
>> has been changed to another loaded policy.
>> AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
>> into the kernel.
>>
>> This patch also adds support for success auditing, allowing users to
>> identify why an allow decision was made for a resource. However, it is
>> recommended to use this option with caution, as it is quite noisy.
>>
>> Here are some examples of the new audit record types:
>>
>> AUDIT_IPE_ACCESS(1420):
>>
>>      audit: AUDIT1420 path="/root/vol/bin/hello" dev="sda"
>>        ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"
>>
>>      audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>>        ino=2 rule="DEFAULT action=DENY"
>>
>>      audit: AUDIT1420 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
>>        ino=131 rule="DEFAULT action=DENY"
>>
>> The above three records were generated when the active IPE policy only
>> allows binaries from the initial booted drive(sda) to run. The three
>> identical `hello` binary were placed at different locations, only the
>> first hello from sda was allowed.
>>
>> Field path followed by the file's path name.
>>
>> Field dev followed by the device name as found in /dev where the file is
>> from.
>> Note that for device mappers it will use the name `dm-X` instead of
>> the name in /dev/mapper.
>> For a file in a temp file system, which is not from a device, it will use
>> `tmpfs` for the field.
>> The implementation of this part is following another existing use case
>> LSM_AUDIT_DATA_INODE in security/lsm_audit.c
>>
>> Field ino followed by the file's inode number.
>>
>> Field rule followed by the IPE rule made the access decision. The whole
>> rule must be audited because the decision is based on the combination of
>> all property conditions in the rule.
>>
>> Along with the syscall audit event, user can know why a blocked
>> happened. For example:
>>
>>      audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>>        ino=2 rule="DEFAULT action=DENY"
>>      audit[1956]: SYSCALL arch=c000003e syscall=59
>>        success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
>>        a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
>>        gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
>>        ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
>>
>> The above two records showed bash used execve to run "hello" and got
>> blocked by IPE. Note that the IPE records are always prior to a SYSCALL
>> record.
>>
>> AUDIT_IPE_CONFIG_CHANGE(1421):
>>
>>      audit: AUDIT1421
>>        old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
>>        old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649
>>        new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
>>        new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F
>>        auid=4294967295 ses=4294967295 lsm=ipe res=1
>>
>> The above record showed the current IPE active policy switch from
>> `Allow_All` to `boot_verified` along with the version and the hash
>> digest of the two policies. Note IPE can only have one policy active
>> at a time, all access decision evaluation is based on the current active
>> policy.
>> The normal procedure to deploy a policy is loading the policy to deploy
>> into the kernel first, then switch the active policy to it.
>>
>> AUDIT_IPE_POLICY_LOAD(1422):
>>
>> audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
>> policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD
>> auid=4294967295 ses=4294967295 lsm=ipe res=1
>>
>> The above record showed a new policy has been loaded into the kernel
>> with the policy name, policy version and policy hash.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   include/uapi/linux/audit.h |   3 +
>>   security/ipe/Kconfig       |   2 +-
>>   security/ipe/Makefile      |   1 +
>>   security/ipe/audit.c       | 195 +++++++++++++++++++++++++++++++++++++
>>   security/ipe/audit.h       |  18 ++++
>>   security/ipe/eval.c        |  32 ++++--
>>   security/ipe/eval.h        |   8 ++
>>   security/ipe/fs.c          |  70 +++++++++++++
>>   security/ipe/policy.c      |   5 +
>>   9 files changed, 327 insertions(+), 7 deletions(-)
>>   create mode 100644 security/ipe/audit.c
>>   create mode 100644 security/ipe/audit.h
> 
> ...
> 
>> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
>> new file mode 100644
>> index 000000000000..e123701d5e3b
>> --- /dev/null
>> +++ b/security/ipe/audit.c
>> @@ -0,0 +1,195 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include <linux/slab.h>
>> +#include <linux/audit.h>
>> +#include <linux/types.h>
>> +#include <crypto/hash.h>
>> +
>> +#include "ipe.h"
>> +#include "eval.h"
>> +#include "hooks.h"
>> +#include "policy.h"
>> +#include "audit.h"
>> +
>> +#define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
>> +
>> +#define IPE_AUDIT_HASH_ALG "sha256"
>> +
>> +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
>> +			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
>> +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
>> +				    "old_active_pol_version=%hu.%hu.%hu "\
>> +				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
>> +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
>> +				    "new_active_pol_version=%hu.%hu.%hu "\
>> +				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
>> +
>> +static const char *const audit_op_names[__IPE_OP_MAX] = {
>> +	"EXECUTE",
>> +	"FIRMWARE",
>> +	"KMODULE",
>> +	"KEXEC_IMAGE",
>> +	"KEXEC_INITRAMFS",
>> +	"IMA_POLICY",
>> +	"IMA_X509_CERT",
>> +};
>> +
>> +static const char *const audit_prop_names[__IPE_PROP_MAX] = {
>> +	"boot_verified=FALSE",
>> +	"boot_verified=TRUE",
>> +};
> 
> I would suggest taking the same approach for both @audit_op_names and
> @audit_prop_names; either include the field name in the string array
> for both or leave it out of both.
>
Yes sure, I will move the "op=" into audit_op_names.

>> +/**
>> + * audit_rule - audit an IPE policy rule approximation.
>> + * @ab: Supplies a pointer to the audit_buffer to append to.
>> + * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
>> + */
>> +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
>> +{
>> +	const struct ipe_prop *ptr;
>> +
>> +	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
>> +
>> +	list_for_each_entry(ptr, &r->props, next)
>> +		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
>> +
>> +	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
>> +}
>> +
>> +/**
>> + * ipe_audit_match - audit a match for IPE policy.
>> + * @ctx: Supplies a pointer to the evaluation context that was used in the
>> + *	 evaluation.
>> + * @match_type: Supplies the scope of the match: rule, operation default,
>> + *		global default.
>> + * @act: Supplies the IPE's evaluation decision, deny or allow.
>> + * @r: Supplies a pointer to the rule that was matched, if possible.
>> + * @enforce: Supplies the enforcement/permissive state at the point
>> + *	     the enforcement decision was made.
>> + */
> 
> Does it make sense to move @match_type into the ipe_eval_ctx struct?
> 
I feel the @match_type is part of the evaluation result information, 
which is the result of the context against the active policy. So I 
prefer keeping it as a local variable in the evaluation loop.

-Fan
>> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
>> +		     enum ipe_match match_type,
>> +		     enum ipe_action_type act, const struct ipe_rule *const r)
>> +{
>> +	struct inode *inode;
>> +	struct audit_buffer *ab;
>> +	const char *op = audit_op_names[ctx->op];
>> +
>> +	if (act != IPE_ACTION_DENY && !READ_ONCE(success_audit))
>> +		return;
>> +
>> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
>> +	if (!ab)
>> +		return;
>> +
>> +	if (ctx->file) {
>> +		audit_log_d_path(ab, "path=", &ctx->file->f_path);
>> +		inode = file_inode(ctx->file);
>> +		if (inode) {
>> +			audit_log_format(ab, " dev=");
>> +			audit_log_untrustedstring(ab, inode->i_sb->s_id);
>> +			audit_log_format(ab, " ino=%lu ", inode->i_ino);
>> +		}
>> +	}
>> +
>> +	if (match_type == IPE_MATCH_RULE)
>> +		audit_rule(ab, r);
>> +	else if (match_type == IPE_MATCH_TABLE)
>> +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
>> +				 ACTSTR(act));
>> +	else
>> +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
>> +				 ACTSTR(act));
>> +
>> +	audit_log_end(ab);
>> +}
> 
> --
> paul-moore.com
