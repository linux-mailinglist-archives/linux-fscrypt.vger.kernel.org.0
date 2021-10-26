Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519A743BA39
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 21:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhJZTGX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 15:06:23 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56334 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238368AbhJZTGS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 15:06:18 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 2A6E420A5C29;
        Tue, 26 Oct 2021 12:03:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2A6E420A5C29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635275034;
        bh=CpfYk836igqDoUQTiFnJrqG9YNeYd0h2icXWecLV0bk=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=ZViKJkN4UY9Yc0gS5sxY88yn6huX32kbojQl+7KSvjEx85E0KwloitsdVd9eoEpXS
         zWvHYtdmjIG6hB3GObByUI5befjkF37YYQv8BValpdzLl1JIHoHL5qhTLJDtmJPgvn
         5l2bhcRZr5SlvyzbetzAH5MD+qniA6iggwrPhtr4=
Message-ID: <f027e3fa-2f70-0cdb-ac7b-255cee68edbb@linux.microsoft.com>
Date:   Tue, 26 Oct 2021 12:03:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
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
Content-Language: en-US
In-Reply-To: <YWngaVdvMyWBlITZ@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 10/15/2021 1:11 PM, Eric Biggers wrote:

> On Fri, Oct 15, 2021 at 12:25:53PM -0700, Deven Bowers wrote:
>> On 10/13/2021 12:24 PM, Eric Biggers wrote:
>>> On Wed, Oct 13, 2021 at 12:06:31PM -0700,deven.desai@linux.microsoft.com  wrote:
>>>> From: Fan Wu<wufan@linux.microsoft.com>
>>>>
>>>> Add security_inode_setsecurity to fsverity signature verification.
>>>> This can let LSMs save the signature data and digest hashes provided
>>>> by fsverity.
>>> Can you elaborate on why LSMs need this information?
>> The proposed LSM (IPE) of this series will be the only one to need
>> this information at the  moment. IPE’s goal is to have provide
>> trust-based access control. Trust and Integrity are tied together,
>> as you cannot prove trust without proving integrity.
> I think you mean authenticity, not integrity?
I’ve heard a lot of people use these terms in overloaded ways.

If we’re working with the definition of authenticity being
“the property that a resource was _actually_ sent/created by a
party”, and integrity being “the property that a resource was not
modified from a point of time”, then yes. Though the statement isn’t
false, though, because you’d need to prove integrity in the process of
proving authenticity.

If not, could you clarify what you mean by authenticity and integrity,
so that we can use consistent definitions?
> Also how does this differ from IMA?  I know that IMA doesn't support fs-verity
> file hashes, but that could be changed.  Why not extend IMA to cover your use
> case(s)?
We looked at extending IMA to cover our requirements extensively the 
past year
based on feedback the last time I posted these patches. We implemented a
prototype that had half of our requirements, but found it resulted in a
large change list that would result in a large amount of pain in respect
to maintenance, in addition to other more architectural concerns about the
implementation. We weren’t convinced it was the correct direction, for our
needs.

There was a presentation done at LSS 2021 around this prototype done by my
colleague, Fan, who authored this patch and implemented the aforementioned
prototype.

In general, IMA provides a whole suite of amazing functionality when it
comes to everything integrity, as the fs-verity documentation states
itself:

    IMA specifies a system-wide policy that specifies which
    files are hashed and what to do with those hashes, such
    as log them, authenticate them, or add them to a
    measurement list.

Instead, IPE provides a fine-tuned way to _only_ enforce an access control
policy to these files based on the defined trust requirements in the policy,
under various contexts, (you might have different requirements for what
executes in a general purpose, versus loadable kernel modules, for example).
It will never provide bother to log, measure, or revalidate these hashes 
because
that’s not its purpose. This is why it belongs at the LSM layer instead 
of the
integrity subsystem layer, as it is providing access control based on a 
policy,
versus providing deep integrations with the actual integrity claim.

IPE is trying to be agnostic to how precisely “trust” is provided, as
opposed to be deeply integrated into the mechanism that provides
“trust”.
>> IPE needs the digest information to be able to compare a digest
>> provided by the policy author, against the digest calculated by
>> fsverity to make a decision on whether that specific file, represented
>> by the digest is authorized for the actions specified in the policy.
>>
>> A more concrete example, if an IPE policy author writes:
>>
>>      op=EXECUTE fsverity_digest=<HexDigest > action=DENY
>>
>> IPE takes the digest provided by this security hook, stores it
>> in IPE's security blob on the inode. If this file is later
>> executed, IPE compares the digest stored in the LSM blob,
>> provided by this hook, against <HexDigest> in the policy, if
>> it matches, it denies the access, performing a revocation
>> of that file.
> Do you have a better example?  This one is pretty useless since one can get
> around it just by executing a file that doesn't have fs-verity enabled.
Here’s a more complete example:

    policy_name=”fs-exec-only” policy_version=0.0.1
    DEFAULT action=ALLOW

    DEFAULT op=EXECUTE action=DENY
    op=EXECUTE fsverity_digest=<Digest> action=DENY
    op=EXECUTE fsverity_signature=TRUE action=ALLOW

Execution is prohibited unless it is a signed fs-verity file;
However, after one of those executables was signed and published,
an exploitable vulnerability in said executable was found, a new
version was published without that vulnerability. We need to
revoke trust for that executable since it could be used to exploit
the system, so the first rule prevents it from matching the second.
>> This brings me to your next comment:
>>
>>> The digest isn't meaningful without knowing the hash algorithm it uses.
>> It's available here, but you aren't passing it to this function.
>>
>> The digest is meaningful without the algorithm in this case.
> No, it's not.
>
> Digests are meaningless without knowing what algorithm they were created with.
>
> If your security policy is something like "Trust the file with digest $foo" and
> multiple hash algorithms are possible, then the alorithm intended to be used
> needs to be explicitly specified.  Otherwise any algorithm with the same length
> digest will be accepted.  That's a fatal flaw if any of these algorithms is
> cryptographically broken or was never intended to be a cryptographic algorithm
> in the first place (e.g., a non-cryptographic checksum).
>
> Cryptosystems always need to specify the crypto algorithm(s) used; the adversary
> must not be allowed to choose the algorithms.
Oof. You’re completely right. The part I was missing is that as time 
goes on,
the secure status of these cryptographic algorithms will change, and 
then we’ll
need a way to migrate between algorithms. Additionally, tooling and the 
like will
likely need a way to identify this from the policy text without 
consulting anything
else. This is a major oversight for general use, the system that this 
was originally
designed for only had support for a subset of the sha2-family (all 
separate lengths)
so I hadn’t even considered it.

It's trivial to correct in a minimal amount of code, making the policy 
express the
digest like so:

    fsverity_digest=<algo>:<digest>

and change the argument passed to the LSM hook to accept a structure 
containing these
two fields.

> I'm not sure how these patches can be taken seriously when they're getting this
> sort of thing wrong.
That said, I, personally, hope that an honest mistake, in a series 
submitted as
an RFC submitted in good faith, is not a reason to discount an entire patch
series.

I hope you continue to provide feedback, as it is invaluable to making this
system better, and making me, personally, a better developer.
>>>> +					FS_VERITY_SIGNATURE_SEC_NAME,
>>>> +					signature, sig_size, 0);
>>> This is only for fs-verity built-in signatures which aren't the only way to do
>>> signatures with fs-verity.  Are you sure this is what you're looking for?
>> Could you elaborate on the other signature types that can be used
>> with fs-verity? I’m 99% sure this is what I’m looking for as this
>> is a signature validated in the kernel against the fs-verity keyring
>> as part of the “fsverity enable” utility.
>>
>> It's important that the signature is validated in the kernel, as
>> userspace is considered untrusted until the signature is validated
>> for this case.
>>
>>> Can you elaborate on your use case for fs-verity built-in signatures,
>> Sure, signatures, like digests, also provide a way to prove integrity,
>> and the trust component comes from the validation against the keyring,
>> as opposed to a fixed value in IPE’s policy. The use case for fs-verity
>> built-in signatures is that we have a rw ext4 filesystem that has some
>> executable files, and we want to have a execution policy (through IPE)
>> that only _trusted_ executables can run. Perf is important here, hence
>> fs-verity.
> Most users of fs-verity built-in signatures have actually been enforcing their
> security policy in userspace, by checking whether specific files have the
> fs-verity bit set or not.  Such users could just store and verify signatures in
> userspace instead, without any kernel involvement.  So that's what I've been
> recommending (with limited success, unfortunately).
I believe the difference in security models comes from this line
(emphasis, mine):

 > by checking whether _specific files_ have the fs-verity bit set or not.

IPE policy is written by a system author who owns the system, but may
not have 100% control over all of the application code running on the
system.  In the case of applications which are not aware of IPE, the policy
can still enforce that all of the code running on the system is trusted.

An example attack of what we're trying to mitigate:  A hostile actor
could downloads a binary off the internet with all required
dependencies into tmpfs and runs their malicious executable.

With us validating this information in the kernel, even if the attacker
downloaded their malicious executable to /tmp and executed it, it would
still fail to pass policy and be denied, as the kernel is the common
entrypoint across all executables.

Operationally, this _could_ be done by digest, but the policies would
quickly become gigantic on a cartoonish proportion, as you'll have to
authorize every single executable and dependency by digest - and
there would be a complicated update story as the policy would have to
be updated to onboard new digests.

By using signatures, we can prevent the policy update, and keep the
policy size small.

> If you really do need in-kernel signature verification, then that may be a
> legitimate use case for the fs-verity built-in signatures, although I do wonder
> why you aren't using IMA and its signature mechanism instead.
>
> - Eric
