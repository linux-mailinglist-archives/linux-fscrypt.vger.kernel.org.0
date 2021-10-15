Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B3F42FBFD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Oct 2021 21:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbhJOT1z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Oct 2021 15:27:55 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51948 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbhJOT1w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Oct 2021 15:27:52 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id A840E20B9D2B;
        Fri, 15 Oct 2021 12:25:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A840E20B9D2B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634325945;
        bh=RPZtRxj2Ft0zzKXvpgW0rZMYpHi1gS55iyEpO7uuSJY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ccCuDchH9sh5yYOrHA40uvyfplTe3oCiqj9ESax6es5pjOU7zhzl+xuNw4A3ht2NP
         XtjqZPD/uSqSTIQL/xduVGrKXRtNn6mqMqyZMDFih/9UOG/9j1x34dBapCpe2KYHQ0
         rS6B9PRwppJDpJLTf2vrEFV5OzOFjKHa64SZ/siE=
Message-ID: <7bd474ae-3dbe-4351-fa10-ee68e5c7267c@linux.microsoft.com>
Date:   Fri, 15 Oct 2021 12:25:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
Content-Language: en-US
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
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 10/13/2021 3:54 PM, Randy Dunlap wrote:
> Hi,
>
> On 10/13/21 12:06 PM, deven.desai@linux.microsoft.com wrote:
>> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
>> index c4503083e92d..ef556b66e674 100644
>> --- a/security/ipe/Kconfig
>> +++ b/security/ipe/Kconfig
>> @@ -17,3 +17,55 @@ menuconfig SECURITY_IPE
>>         requirements on the fly.
>>           If unsure, answer N.
>> +
>> +if SECURITY_IPE
>> +
>> +choice
>> +    prompt "Hash algorithm used in auditing policies"
>> +    default IPE_AUDIT_HASH_SHA1
>> +    depends on AUDIT
>> +    help
>> +        Specify the hash algorithm used when auditing policies.
>> +        The hash is used to uniquely identify a policy from other
>> +        policies on the system.
>> +
>> +        If unsure, leave default.
>> +
>> +    config IPE_AUDIT_HASH_SHA1
>> +        bool "sha1"
>> +        depends on CRYPTO_SHA1
>> +        help
>> +            Use the SHA128 algorithm to hash policies
>> +            in the audit records.
>> +
>> +    config IPE_AUDIT_HASH_SHA256
>> +        bool "sha256"
>> +        depends on CRYPTO_SHA256
>> +        help
>> +            Use the SHA256 algorithm to hash policies
>> +            in the audit records.
>> +
>> +    config IPE_AUDIT_HASH_SHA384
>> +        bool "sha384"
>> +        depends on CRYPTO_SHA512
>> +        help
>> +            Use the SHA384 algorithm to hash policies
>> +            in the audit records
>> +
>> +    config IPE_AUDIT_HASH_SHA512
>> +        bool "sha512"
>> +        depends on CRYPTO_SHA512
>> +        help
>> +            Use the SHA512 algorithm to hash policies
>> +            in the audit records
>> +endchoice
>> +
>> +config IPE_AUDIT_HASH_ALG
>> +    string
>> +    depends on AUDIT
>> +    default "sha1" if IPE_AUDIT_HASH_SHA1
>> +    default "sha256" if IPE_AUDIT_HASH_SHA256
>> +    default "sha384" if IPE_AUDIT_HASH_SHA384
>> +    default "sha512" if IPE_AUDIT_HASH_SHA512
>> +
>> +endif
>
> Please follow coding-style for Kconfig files:
>
> (from Documentation/process/coding-style.rst, section 10):
>
> For all of the Kconfig* configuration files throughout the source tree,
> the indentation is somewhat different.  Lines under a ``config`` 
> definition
> are indented with one tab, while help text is indented an additional two
> spaces.
>
Oof. That's embarrassing. Sorry, I'll fix this for v8.

While I'm at it, is the help text required for choice configs?
checkpatch --strict complains with a warning without them, but
I see other places in the tree where help text is omitted for
these configs attached to a choice.

Documentation/process/* doesn't seem to have any guidance, nor
Documentation/kbuild/* on whether it is safe to ignore that
checkpatch warning.




