Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A7E43BA25
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 21:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhJZTF5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 15:05:57 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56184 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbhJZTFt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 15:05:49 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2B51A20A5C1D;
        Tue, 26 Oct 2021 12:03:25 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2B51A20A5C1D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635275005;
        bh=vG1c20XgZv9AARF8oqgFeOhnp5BzXzRRwPGohfxdvHg=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=SjcEDGw//Ymcik+VMtF1+ERZ+dw8FH9bVt5l8mvrE1j8JvgxJdq/SZ+srf/Pf/8d0
         sQMrclFPXiGR/HUVPWGv1TMfC8TSpx/ay8/t6fEQu1s8Q1/nc43IRpFo5qcZLYlBZe
         EMhCBMauerhUpPRGOV1nnpgVN0QOJQ5uOgO6DU6M=
Message-ID: <6865843a-0b64-2149-7652-aff7369532b9@linux.microsoft.com>
Date:   Tue, 26 Oct 2021 12:03:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
To:     Randy Dunlap <rdunlap@infradead.org>, corbet@lwn.net,
        axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
        ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
 <9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
 <7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
 <e4bc834b-5483-604d-7fa1-e5eafdd5ebf5@infradead.org>
Content-Language: en-US
In-Reply-To: <e4bc834b-5483-604d-7fa1-e5eafdd5ebf5@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/15/2021 12:50 PM, Randy Dunlap wrote:
> On 10/15/21 12:25 PM, Deven Bowers wrote:
>> On 10/13/2021 3:54 PM, Randy Dunlap wrote:
>>> Hi,
>>>
>>> On 10/13/21 12:06 PM, deven.desai@linux.microsoft.com wrote:
>>>> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
>>>> index c4503083e92d..ef556b66e674 100644
>>>> --- a/security/ipe/Kconfig
>>>> +++ b/security/ipe/Kconfig
>>>> @@ -17,3 +17,55 @@ menuconfig SECURITY_IPE
>>>>         requirements on the fly.
>>>>           If unsure, answer N.
>>>> +
>>>> +if SECURITY_IPE
>>>> +
>>>> +choice
>>>> +    prompt "Hash algorithm used in auditing policies"
>>>> +    default IPE_AUDIT_HASH_SHA1
>>>> +    depends on AUDIT
>>>> +    help
>>>> +        Specify the hash algorithm used when auditing policies.
>>>> +        The hash is used to uniquely identify a policy from other
>>>> +        policies on the system.
>>>> +
>>>> +        If unsure, leave default.
>>>> +
>>>> +    config IPE_AUDIT_HASH_SHA1
>>>> +        bool "sha1"
>>>> +        depends on CRYPTO_SHA1
>>>> +        help
>>>> +            Use the SHA128 algorithm to hash policies
>>>> +            in the audit records.
>>>> +
>>>> +    config IPE_AUDIT_HASH_SHA256
>>>> +        bool "sha256"
>>>> +        depends on CRYPTO_SHA256
>>>> +        help
>>>> +            Use the SHA256 algorithm to hash policies
>>>> +            in the audit records.
>>>> +
>>>> +    config IPE_AUDIT_HASH_SHA384
>>>> +        bool "sha384"
>>>> +        depends on CRYPTO_SHA512
>>>> +        help
>>>> +            Use the SHA384 algorithm to hash policies
>>>> +            in the audit records
>>>> +
>>>> +    config IPE_AUDIT_HASH_SHA512
>>>> +        bool "sha512"
>>>> +        depends on CRYPTO_SHA512
>>>> +        help
>>>> +            Use the SHA512 algorithm to hash policies
>>>> +            in the audit records
>>>> +endchoice
>>>> +
>>>> +config IPE_AUDIT_HASH_ALG
>>>> +    string
>>>> +    depends on AUDIT
>>>> +    default "sha1" if IPE_AUDIT_HASH_SHA1
>>>> +    default "sha256" if IPE_AUDIT_HASH_SHA256
>>>> +    default "sha384" if IPE_AUDIT_HASH_SHA384
>>>> +    default "sha512" if IPE_AUDIT_HASH_SHA512
>>>> +
>>>> +endif
>>>
>>> Please follow coding-style for Kconfig files:
>>>
>>> (from Documentation/process/coding-style.rst, section 10):
>>>
>>> For all of the Kconfig* configuration files throughout the source tree,
>>> the indentation is somewhat different.  Lines under a ``config`` 
>>> definition
>>> are indented with one tab, while help text is indented an additional 
>>> two
>>> spaces.
>>>
>> Oof. That's embarrassing. Sorry, I'll fix this for v8.
>>
>> While I'm at it, is the help text required for choice configs?
>> checkpatch --strict complains with a warning without them, but
>> I see other places in the tree where help text is omitted for
>> these configs attached to a choice.
>
> Does checkpatch complain about what you have above
> or did you add that help text to keep it from complaining?

I added the help text to keep it from complaining (and added it incorrectly,
clearly).

>
>
>> Documentation/process/* doesn't seem to have any guidance, nor
>> Documentation/kbuild/* on whether it is safe to ignore that
>> checkpatch warning.
>
> Yeah, I don't think that we have any good guidance on that.
>
> I would say that if the choice prompt provides good/adequate
> help info, then each 'config' inside the choice block does not
> need help text. OTOH, if the choice prompt has little/no help
> info, then each 'config' under it should have some useful info.
>
> I only looked in arch/x86/Kconfig, init/Kconfig, and lib/Kconfig.debug,
> but you can see either help text method being used in those.
>
> And then if the help text is adequate in either one of those
> methods, I would just ignore the checkpatch complaints.
> It's just a guidance tool.

Alright. I think the choice guidance is pretty clear:

    Specify the hash algorithm used when auditing policies.
    The hash is used to uniquely identify a policy from other
    policies on the system.

So I'll remove the help text for these choices.

At worst, I can make the choice text more clear.
>
> HTH.
>
