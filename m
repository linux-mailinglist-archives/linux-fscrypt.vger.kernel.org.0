Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9FC4457C3
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 17:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhKDRBo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 13:01:44 -0400
Received: from linux.microsoft.com ([13.77.154.182]:53428 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhKDRBn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 13:01:43 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id D817320ABA92;
        Thu,  4 Nov 2021 09:59:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D817320ABA92
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636045145;
        bh=6Fhu1fVrlEM+zAeqzfl+2y2B+pfRDcedOWmMzTvJw68=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=qbxZqAsxfR+uZTMqf4wXUs1iyN/O0A9xneB0ugX07sKH4oYoJGlekFy5vbq79mK1h
         MMnPCiWKoOKbLKYoMjOY7jqTP6yv1bSanJLOzZSGaLn8s1dJOojCUNY6+wZZJ0vs69
         Mu73irmZ7f10kfbIy2N+gkfEspEQ5jrQWbygMak4=
Message-ID: <bd189273-7640-e135-9ca3-e6f3b909b3a1@linux.microsoft.com>
Date:   Thu, 4 Nov 2021 09:59:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
To:     Steve Grubb <sgrubb@redhat.com>, corbet@lwn.net, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org,
        tytso@mit.edu, paul@paul-moore.com, eparis@redhat.com,
        jmorris@namei.org, serge@hallyn.com, linux-audit@redhat.com
Cc:     linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
        jannh@google.com, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <2159283.iZASKD2KPV@x2>
 <8802b1ff-3028-642a-22c5-bc4896450a60@linux.microsoft.com>
 <1898302.usQuhbGJ8B@x2>
Content-Language: en-US
In-Reply-To: <1898302.usQuhbGJ8B@x2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 11/2/2021 12:44 PM, Steve Grubb wrote:
> Hello,
>
> On Friday, October 15, 2021 3:25:47 PM EDT Deven Bowers wrote:
>> On 10/13/2021 1:02 PM, Steve Grubb wrote:
>>> On Wednesday, October 13, 2021 3:06:26 PM EDT
>>> deven.desai@linux.microsoft.com> 
>>> wrote:
>>>> Users of IPE require a way to identify when and why an operation fails,
>>>> allowing them to both respond to violations of policy and be notified
>>>> of potentially malicious actions on their systens with respect to IPE
>>>> itself.
>>> Would you mind sending examples of audit events so that we can see what
>>> the end result is? Some people add them to the commit text. But we still
>>> need to see what they look like.
>> Sure, sorry. I’ll add them to the commit description (and the documentation
>> patch at the end) for v8 – In the interest of asynchronous feedback, I’ve
>> copied the relevant examples:
> Thanks for sending these. This helps.
>
>   
>> AUDIT1420 IPE ctx_pid=229 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=0
>> ctx_comm="grep" ctx_pathname="/usr/lib/libc-2.23.so"
>> ctx_ino=532 ctx_dev=vda rule="DEFAULT op=EXECUTE action=DENY"
> Question...why do all of these have a ctx_  prefix?

Ah, the ctx_ was because these fields are all grouped in ipe in a 
context (ctx)
structure. An private version (pre-v1) had these grouped like:

    ctx={ pid=229 comm="grep" op=EXECUTE ... }

But during an internal review, it was brought up that the grouping is likely
non-standard and to cause more issues than its worth instead of just 
prefixing
the field with ctx_. Now that I think about it a bit more, the context is
implicit, so the prefix and grouping doesn't make sense.

> Is it possible to trigger an audit context so that the audit machinery
> collects all of this stuff in  it's own way? Which means you could drop
> everything execept op, hook, enforce, rule, and action.

I could do something internal in IPE that will create the context in the 
right
way. As far as inside the audit stack it looks like the closest analogue 
would
be common_lsm_audit - which fixes the type to be AVC. I don't think 
adding another
form of AVC is appropriate?

I could also either extend common_lsm_audit to accept a type parameter, or
make a more generalized function as part of the audit framework. Do you have
a preference? Paul, do you have a preference?

> We also have a field dictionary here:
> https://github.com/linux-audit/audit-documentation/blob/main/specs/fields/
> field-dictionary.csv
>
> which names the known fields and how they should be formatted. If there is a
> collision where they are something else and cannot be in the same format,
> then we make a new name and hopefully update the dictionary. For example, if
> you are collecting a process id, use pid and not ctx_pid so that it matches a
> known definition.

Wow. I didn't know about this - it should be pretty easy to change the 
fields
to follow this mapping. Almost everything has a correlation already. It 
looks
like there would be only one collision with hook being currently defined
with netfilter. Everything else would be new (e.g. rule), or could map
an existingfield.
> Also, I don't thnk these events can stand on their own. Who did this action?
> You have the pid, but no uid, auid, or session_id.

It makes sense to add these fields; and it'd be taken care of with your 
suggestion
above to make the audit context just gathers this information in its 
own, consistent
way.

> Hope this helps...
>
> -Steve
>
>   
>> AUDIT1420 IPE ctx_pid=229 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=0
>> ctx_comm="grep" ctx_pathname="/usr/lib/libc-2.23.so"
>> ctx_ino=532 ctx_dev=vda rule="DEFAULT action=DENY"
>>
>> AUDIT1420 IPE ctx_pid=253 ctx_op=EXECUTE ctx_hook=MMAP ctx_enforce=1
>> ctx_comm="anon" rule="DEFAULT op=EXECUTE action=DENY"
>>
>> These three audit records represent various types of results after
>> evaluating
>> the trust of a resource. The first two differ in the rule that was
>> matched in
>> IPE's policy, the first being an operation-specific default, the second
>> being
>> a global default. The third is an example of what is audited when anonymous
>> memory is blocked (as there is no way to verify the trust of an anonymous
>> page).
>>
>> The remaining three events, AUDIT_TRUST_POLICY_LOAD (1421),
>> AUDIT_TRUST_POLICY_ACTIVATE (1422), and AUDIT_TRUST_STATUS (1423) have this
>> form:
>>
>> AUDIT1421 IPE policy_name="my-policy" policy_version=0.0.0
>> <hash_alg_name>=<hash>
>> AUDIT1422 IPE policy_name="my-policy" policy_version=0.0.0
>> <hash_alg_name>=<hash>
>> AUDIT1423 IPE enforce=1
>>
>> The 1421 (AUDIT_TRUST_POLICY_LOAD) event represents a new policy was loaded
>> into the kernel, but not is not marked as the policy to enforce. The
>>
>> The 1422 (AUDIT_TRUST_POLICY_ACTIVATE) event represents a policy that was
>> already loaded was made the enforcing policy.
>>
>> The 1423 (AUDIT_TRUST_STATUS) event represents a switch between
>> permissive and
>> enforce, it is added in 08/16 (the following patch)
