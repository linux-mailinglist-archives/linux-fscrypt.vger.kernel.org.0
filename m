Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1759E7DFCB1
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 23:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbjKBW46 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 18:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjKBW45 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 18:56:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BAE15133;
        Thu,  2 Nov 2023 15:56:51 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2780620B74C0;
        Thu,  2 Nov 2023 15:56:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2780620B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698965811;
        bh=MeD71Q6biPj3nx4lgT1GcHQD3ltSRaQZ4DGHwulTS4Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YVJmYHq00nJnWXOaOSPSTB9CLF31HF844WK9jukAHjJwBurLVyw9YxueHfQGQbuAS
         xFhAUSlG0ZSdEvoJUpcBQGNDOEVTYD6tjqdCBHiacARnQT29rnL0TFNS+awxAjiTA2
         sipFNWa9gayF5SdjotF0sP2f2g/4o4eKi61Us97s=
Message-ID: <b315474c-77f7-49c1-8983-c8d1de80cc86@linux.microsoft.com>
Date:   Thu, 2 Nov 2023 15:56:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 9/19] ipe: add permissive toggle
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
References: <1696457386-3010-10-git-send-email-wufan@linux.microsoft.com>
 <1ef52e983dd5b9a7759dc76bfe156804.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <1ef52e983dd5b9a7759dc76bfe156804.paul@paul-moore.com>
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
>> IPE, like SELinux, supports a permissive mode. This mode allows policy
>> authors to test and evaluate IPE policy without it effecting their
>> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
>> be reported.
>>
>> This patch adds the following audit records:
>>
>>      audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
>>        ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>>      audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
>>        ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>>
>> The audit record only emit when the value from the user input is
>> different from the current enforce value.
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
>>    + Propagating changes to support the new ipe_context structure in the
>>      evaluation loop.
>>    + Split out permissive functionality into a separate patch for easier
>>      review.
>>    + Remove permissive switch compile-time configuration option - this
>>      is trivial to add later.
>>
>> v8:
>>    + Remove "IPE" prefix from permissive audit record
>>    + align fields to the linux-audit field dictionary. This causes the
>>      following fields to change:
>>        enforce -> permissive
>>
>>    + Remove duplicated information correlated with syscall record, that
>>      will always be present in the audit event.
>>    + Change audit types:
>>      + AUDIT_TRUST_STATUS -> AUDIT_MAC_STATUS
>>        + There is no significant difference in meaning between
>>          these types.
>>
>> v9:
>>    + Clean up ipe_context related code
>>
>> v10:
>>    + Change audit format to comform with the existing format selinux is
>>      using
>>    + Remove the audit record emission during init to align with selinux,
>>      which does not perform this action.
>>
>> v11:
>>    + Remove redundant code
>> ---
>>   security/ipe/audit.c | 22 ++++++++++++++
>>   security/ipe/audit.h |  1 +
>>   security/ipe/eval.c  | 14 +++++++--
>>   security/ipe/eval.h  |  1 +
>>   security/ipe/fs.c    | 68 ++++++++++++++++++++++++++++++++++++++++++++
>>   5 files changed, 104 insertions(+), 2 deletions(-)
> 
> ...
> 
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> index 499b6b3338f2..78c54ff1fdd3 100644
>> --- a/security/ipe/eval.c
>> +++ b/security/ipe/eval.c
>> @@ -167,9 +172,12 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>>   	ipe_audit_match(ctx, match_type, action, rule);
>>   
>>   	if (action == IPE_ACTION_DENY)
>> -		return -EACCES;
>> +		rc = -EACCES;
>> +
>> +	if (!enforcing)
>> +		rc = 0;
> 
> Why the local @enforcing variable?  Why not:
> 
>    if (!READ_ONCE(enforce))
>      rc = 0;
> 

Yes the variable is unnecessary, I will remove it.
-Fan
>> -	return 0;
>> +	return rc;
>>   }
>>   
>>   /**
>> @@ -198,3 +206,5 @@ void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
>>   
>>   module_param(success_audit, bool, 0400);
>>   MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
>> +module_param(enforce, bool, 0400);
>> +MODULE_PARM_DESC(enforce, "Start IPE in enforce or permissive mode");
> 
> "enforcing"
> 
> --
> paul-moore.com
