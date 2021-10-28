Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDD843E80E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Oct 2021 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhJ1SNo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Oct 2021 14:13:44 -0400
Received: from linux.microsoft.com ([13.77.154.182]:47562 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhJ1SNn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Oct 2021 14:13:43 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id A2C8B209F33F;
        Thu, 28 Oct 2021 11:11:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2C8B209F33F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635444675;
        bh=xaWJlPOkgwmSC4Z42bn0ksBEBLLvZTO2Sn6BQavTIXo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dDNeeyMjx4g/tOoo4kJSDD/tgC63NmK5mmzKrPpNd382Z9+2QjW8Wa6rQwM4sdcvw
         531P0qZXyZDSmmRmcXSG2JPJ3jsx+kPTha80B2J4xzECdL9HF/RUMZKv9GBd2gjNq0
         XoPOT+KetImd5KipF13ipc3zU3OfsWUMxl99upBA=
Message-ID: <9b2695ac-f6db-ac75-5451-4ea9667ce04f@linux.microsoft.com>
Date:   Thu, 28 Oct 2021 11:11:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, tytso@mit.edu, paul@paul-moore.com,
        eparis@redhat.com, jmorris@namei.org, serge@hallyn.com,
        jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
 <YWngaVdvMyWBlITZ@gmail.com>
 <f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
 <YXodhzYto5BRxqYO@sol.localdomain>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <YXodhzYto5BRxqYO@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/27/2021 8:48 PM, Eric Biggers wrote:
> On Tue, Oct 26, 2021 at 12:03:53PM -0700, Deven Bowers wrote:
>>>> The proposed LSM (IPE) of this series will be the only one to need
>>>> this information at the  moment. IPE’s goal is to have provide
>>>> trust-based access control. Trust and Integrity are tied together,
>>>> as you cannot prove trust without proving integrity.
>>> I think you mean authenticity, not integrity?
>> I’ve heard a lot of people use these terms in overloaded ways.
>>
>> If we’re working with the definition of authenticity being
>> “the property that a resource was _actually_ sent/created by a
>> party”, and integrity being “the property that a resource was not
>> modified from a point of time”, then yes. Though the statement isn’t
>> false, though, because you’d need to prove integrity in the process of
>> proving authenticity.
>>
>> If not, could you clarify what you mean by authenticity and integrity,
>> so that we can use consistent definitions?
> In cryptography, integrity normally means knowing whether data has been
> non-maliciously changed, while authenticity means knowing whether data is from a
> particular source, which implies knowing whether it has been changed at all
> (whether maliciously or not).  Consider that there are "Message Authentication
> Codes" (MACs) and "Authenticated Encryption", not "Message Integrity Codes" and
> "Intact Encryption".
>
> Unfortunately lots of people do overload "integrity" to mean authenticity, so
> you're not alone.  But it's confusing, so if you're going to do that then please
> make sure to clearly explain what you mean.
>
>>> Also how does this differ from IMA?  I know that IMA doesn't support fs-verity
>>> file hashes, but that could be changed.  Why not extend IMA to cover your use
>>> case(s)?
>> We looked at extending IMA to cover our requirements extensively the past
>> year
>> based on feedback the last time I posted these patches. We implemented a
>> prototype that had half of our requirements, but found it resulted in a
>> large change list that would result in a large amount of pain in respect
>> to maintenance, in addition to other more architectural concerns about the
>> implementation. We weren’t convinced it was the correct direction, for our
>> needs.
>>
>> There was a presentation done at LSS 2021 around this prototype done by my
>> colleague, Fan, who authored this patch and implemented the aforementioned
>> prototype.
>>
>> In general, IMA provides a whole suite of amazing functionality when it
>> comes to everything integrity, as the fs-verity documentation states
>> itself:
>>
>>     IMA specifies a system-wide policy that specifies which
>>     files are hashed and what to do with those hashes, such
>>     as log them, authenticate them, or add them to a
>>     measurement list.
>>
>> Instead, IPE provides a fine-tuned way to _only_ enforce an access control
>> policy to these files based on the defined trust requirements in the policy,
>> under various contexts, (you might have different requirements for what
>> executes in a general purpose, versus loadable kernel modules, for example).
>> It will never provide bother to log, measure, or revalidate these hashes
>> because
>> that’s not its purpose. This is why it belongs at the LSM layer instead of
>> the
>> integrity subsystem layer, as it is providing access control based on a
>> policy,
>> versus providing deep integrations with the actual integrity claim.
>>
>> IPE is trying to be agnostic to how precisely “trust” is provided, as
>> opposed to be deeply integrated into the mechanism that provides
>> “trust”.
> IMA doesn't require logging or "measuring" hashes, though.  Those are just some
> of its supported features.  And I thought the IMA developers were planning to
> add support for fs-verity hashes, and that it wouldn't require an entirely new
> architecture to do so.
>
> Anyway, while it does sound to me like you're duplicating IMA, I don't really
> have a horse in this race, and I defer to the IMA developers on this.  I trust
> that you've been engaging with them?  This patchset isn't even Cc'ed to
> linux-integrity, so it's unclear that's been happening.
That was entirely my mistake. Mimi and the linux-integrity list was CC'd 
on previous
versions (Roberto actually added the list to his responses) - when I was 
reconstructing
the To: line with get-maintainers.pl, the list didn't pop up and I did 
not remember to
add it manually. I've corrected my mailing script to re-add them again.
