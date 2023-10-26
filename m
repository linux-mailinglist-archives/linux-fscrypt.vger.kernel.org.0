Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949CF7D7919
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Oct 2023 02:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjJZAP3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Oct 2023 20:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJZAP2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Oct 2023 20:15:28 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE5F410E;
        Wed, 25 Oct 2023 17:15:26 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id DC7A120B74C0;
        Wed, 25 Oct 2023 17:15:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC7A120B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698279326;
        bh=Ayg5mamt8HCVNY+t4GHPswTJfJb2ciVUg3Q8qdqL6WE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ovNPjhYAJE3PiwQsqnWOT8BVxfey4Ku6txfhhlOv+IbofSxRoW2I/UfuChbVmptfZ
         OoqUvAEgfqDQMX460M6f1L4bM/7ro6HymGSEFoD4BIoEM+SpVEJLLY/mlmG8bdt1Cy
         XGfyJLNcmoePkK24YClYdoBvr20aQVIi2uz0YWJo=
Message-ID: <84f25e00-3a3a-419f-baea-50d64a1d5575@linux.microsoft.com>
Date:   Wed, 25 Oct 2023 17:15:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 3/19] ipe: add evaluation loop
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
References: <1696457386-3010-4-git-send-email-wufan@linux.microsoft.com>
 <aa226bdcba26d74304f6c10c290db840.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <aa226bdcba26d74304f6c10c290db840.paul@paul-moore.com>
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
>> IPE must have a centralized function to evaluate incoming callers
>> against IPE's policy. This iteration of the policy for against the rules
>> for that specific caller is known as the evaluation loop.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/Makefile |  1 +
>>   security/ipe/eval.c   | 96 +++++++++++++++++++++++++++++++++++++++++++
>>   security/ipe/eval.h   | 24 +++++++++++
>>   3 files changed, 121 insertions(+)
>>   create mode 100644 security/ipe/eval.c
>>   create mode 100644 security/ipe/eval.h
> 
> ...
> 
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> new file mode 100644
>> index 000000000000..5533c359bbeb
>> --- /dev/null
>> +++ b/security/ipe/eval.c
>> @@ -0,0 +1,96 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +#include <linux/slab.h>
>> +#include <linux/file.h>
>> +#include <linux/sched.h>
>> +#include <linux/rcupdate.h>
>> +
>> +#include "ipe.h"
>> +#include "eval.h"
>> +#include "policy.h"
>> +
>> +struct ipe_policy __rcu *ipe_active_policy;
>> +
>> +/**
>> + * evaluate_property - Analyze @ctx against a property.
>> + * @ctx: Supplies a pointer to the context to be evaluated.
>> + * @p: Supplies a pointer to the property to be evaluated.
>> + *
>> + * Return:
>> + * * true	- The current @ctx match the @p
>> + * * false	- The current @ctx doesn't match the @p
>> + */
>> +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
>> +			      struct ipe_prop *p)
>> +{
>> +	return false;
>> +}
>> +
>> +/**
>> + * ipe_evaluate_event - Analyze @ctx against the current active policy.
>> + * @ctx: Supplies a pointer to the context to be evaluated.
>> + *
>> + * This is the loop where all policy evaluation happens against IPE policy.
>> + *
>> + * Return:
>> + * * 0		- OK
>> + * * -EACCES	- @ctx did not pass evaluation.
>> + * * !0		- Error
>> + */
>> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>> +{
>> +	bool match = false;
>> +	enum ipe_action_type action;
>> +	struct ipe_policy *pol = NULL;
>> +	const struct ipe_rule *rule = NULL;
>> +	const struct ipe_op_table *rules = NULL;
>> +	struct ipe_prop *prop = NULL;
>> +
>> +	rcu_read_lock();
>> +
>> +	pol = rcu_dereference(ipe_active_policy);
>> +	if (!pol) {
>> +		rcu_read_unlock();
>> +		return 0;
>> +	}
>> +
>> +	if (ctx->op == IPE_OP_INVALID) {
>> +		rcu_read_unlock();
>> +		if (pol->parsed->global_default_action == IPE_ACTION_DENY)
>> +			return -EACCES;
> 
> Assuming that the RCU lock protects @pol, shouldn't it be held until
> after the global_default_action comparison?
> 
Yes for this part the unlock should be moved after the comparison. 
Thanks for spotting this.

>> +		return 0;
>> +	}
>> +
>> +	rules = &pol->parsed->rules[ctx->op];
>> +
>> +	list_for_each_entry(rule, &rules->rules, next) {
>> +		match = true;
>> +
>> +		list_for_each_entry(prop, &rule->props, next) {
>> +			match = match && evaluate_property(ctx, prop);
> 
> The @match variable will always be true on the right side above, or am
> I missing something?
> 
Yes the "match &&" are completely unnecessary. I will remove them.

-Fan
>> +			if (!match)
>> +				break;
>> +		}
>> +
>> +		if (match)
>> +			break;
>> +	}
>> +
>> +	if (match)
>> +		action = rule->action;
>> +	else if (rules->default_action != IPE_ACTION_INVALID)
>> +		action = rules->default_action;
>> +	else
>> +		action = pol->parsed->global_default_action;
>> +
>> +	rcu_read_unlock();
>> +	if (action == IPE_ACTION_DENY)
>> +		return -EACCES;
>> +
>> +	return 0;
>> +}
> 
> --
> paul-moore.com
