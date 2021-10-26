Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41B743BA36
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238521AbhJZTGW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 15:06:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56304 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238384AbhJZTGP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 15:06:15 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 403732034CB5;
        Tue, 26 Oct 2021 12:03:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 403732034CB5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635275031;
        bh=5uVMdrVNwQlawt1ibaKRqS7Nvl/fogOPepcpQlWjyuU=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=JQEBdaXtWvgoj1bYEEdu/OP37eRpJvc/BTJmbsE6C4U4De5XuUvriHCATeI91HD16
         dGqKI4JATg+UNiQ2v4CwnOXDyj+Ep/KWPD5qIRJffJp4fYXN2Vr/rt+5yzjvAaeOQa
         LJ1K7KRo+AncXeQgSRAr1g3ptTcedfPMuvjzCD+A=
Message-ID: <40f70c77-80eb-2716-be77-9cbcf4770b8a@linux.microsoft.com>
Date:   Tue, 26 Oct 2021 12:03:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v7 12/16] fsverity|security: add security hooks to
 fsverity digest and signature
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
 <YWcyYBuNppjrVOe2@gmail.com>
 <9089bdb0-b28a-9fa0-c510-00fa275af621@linux.microsoft.com>
 <YWngaVdvMyWBlITZ@gmail.com> <5c1f800ba554485cb3659da689d2079a@huawei.com>
 <a16a628b9e21433198c490500a987121@huawei.com>
Content-Language: en-US
In-Reply-To: <a16a628b9e21433198c490500a987121@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/22/2021 9:31 AM, Roberto Sassu wrote:
>> From: Roberto Sassu [mailto:roberto.sassu@huawei.com]
>> Sent: Wednesday, October 20, 2021 5:09 PM
>>> From: Eric Biggers [mailto:ebiggers@kernel.org]
>>> Sent: Friday, October 15, 2021 10:11 PM
>>> On Fri, Oct 15, 2021 at 12:25:53PM -0700, Deven Bowers wrote:
>>>> On 10/13/2021 12:24 PM, Eric Biggers wrote:
>>>>> On Wed, Oct 13, 2021 at 12:06:31PM -0700,
>>> deven.desai@linux.microsoft.com  wrote:
>>>>>> From: Fan Wu<wufan@linux.microsoft.com>
>>>>>>
>>>>>> Add security_inode_setsecurity to fsverity signature verification.
>>>>>> This can let LSMs save the signature data and digest hashes provided
>>>>>> by fsverity.
>>>>> Can you elaborate on why LSMs need this information?
>>>> The proposed LSM (IPE) of this series will be the only one to need
>>>> this information at the  moment. IPE’s goal is to have provide
>>>> trust-based access control. Trust and Integrity are tied together,
>>>> as you cannot prove trust without proving integrity.
>>> I think you mean authenticity, not integrity?
>>>
>>> Also how does this differ from IMA?  I know that IMA doesn't support fs-verity
>>> file hashes, but that could be changed.  Why not extend IMA to cover your use
>>> case(s)?
>>>
>>>> IPE needs the digest information to be able to compare a digest
>>>> provided by the policy author, against the digest calculated by
>>>> fsverity to make a decision on whether that specific file, represented
>>>> by the digest is authorized for the actions specified in the policy.
>>>>
>>>> A more concrete example, if an IPE policy author writes:
>>>>
>>>>      op=EXECUTE fsverity_digest=<HexDigest > action=DENY
>>>>
>>>> IPE takes the digest provided by this security hook, stores it
>>>> in IPE's security blob on the inode. If this file is later
>>>> executed, IPE compares the digest stored in the LSM blob,
>>>> provided by this hook, against <HexDigest> in the policy, if
>>>> it matches, it denies the access, performing a revocation
>>>> of that file.
>>> Do you have a better example?  This one is pretty useless since one can get
>>> around it just by executing a file that doesn't have fs-verity enabled.
>> I was wondering if the following use case can be supported:
>> allow the execution of files protected with fsverity if the root
>> digest is found among reference values (instead of providing
>> them one by one in the policy).
>>
>> Something like:
>>
>> op=EXECUTE fsverity_digest=diglim action=ALLOW
> Looks like it works. I modified IPE to query the root digest
> of an fsverity-protected file in DIGLIM.
>
> # cat ipe-policy
> policy_name="AllowFSVerityKmodules" policy_version=0.0.1
> DEFAULT action=ALLOW
> DEFAULT op=KMODULE action=DENY
> op=KMODULE fsverity_digest=diglim action=ALLOW
>
> IPE setup:
> # cat ipe-policy.p7s > /sys/kernel/security/ipe/new_policy
> # echo -n 1 >  /sys/kernel/security/ipe/policies/AllowFSVerityKmodules/active
> # echo 1 > /sys/kernel/security/ipe/enforce
>
> IPE denies loading of kernel modules not protected by fsverity:
> # insmod  /lib/modules/5.15.0-rc1+/kernel/fs/fat/fat.ko
> insmod: ERROR: could not insert module /lib/modules/5.15.0-rc1+/kernel/fs/fat/fat.ko: Permission denied
>
> Protect fat.ko with fsverity:
> # cp /lib/modules/5.15.0-rc1+/kernel/fs/fat/fat.ko /fsverity
> # fsverity enable /fsverity/fat.ko
> # fsverity measure /fsverity/fat.ko
> sha256:079be6d88638e58141ee24bba89813917c44faa55ada4bf5d80335efe1547803 /fsverity/fat.ko
>
> IPE still denies the loading of fat.ko (root digest not uploaded to the kernel):
> # insmod /fsverity/fat.ko
> insmod: ERROR: could not insert module /fsverity/fat.ko: Permission denied
>
> Generate a digest list with the root digest above and upload it to the kernel:
> # ./compact_gen -i 079be6d88638e58141ee24bba89813917c44faa55ada4bf5d80335efe1547803 -a sha256 -d test -s -t file -f
> # echo $PWD/test/0-file_list-compact-079be6d88638e58141ee24bba89813917c44faa55ada4bf5d80335efe1547803 > /sys/kernel/security/integrity/diglim/digest_list_add
>
> IPE allows the loading of fat.ko:
> # insmod /fsverity/fat.ko
> #
>
> Regarding authenticity, not shown in this demo, IPE will also
> ensure that the root digest is signed (diglim_digest_get_info()
> reports this information).

I apologize for the delay in responses, but it looks like
you've figured it out.

This kind of thing is exactly what IPE's design is supposed to
solve, you have some other system which provides the
integrity mechanism and (optionally) determine if it is trusted or
not, and IPE can provide the policy aspect very easily to
make a set of system-wide requirements around your mechanism.

I'm very supportive of adding the functionality, but I wonder
if it makes more sense to have digilm's extension be a separate
key instead of tied to the fsverity_digest key - something like

    op=EXECUTE diglim_fsverity=TRUE action=DENY

that way the condition that enables this property can depend
on digilm in the build, and it separates the two systems'
integrations in a slightly more clean way.

As an aside, did you find it difficult to extend?

> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
>> DIGLIM is a component I'm working on that generically
>> stores digests. The current use case is to store file digests
>> from RPMTAG_FILEDIGESTS and use them with IMA, but
>> the fsverity use case could be easily supported (if the root
>> digest is stored in the RPM header).
>>
>> DIGLIM also tells whether or not the signature of the source
>> containing file digests (or fsverity digests) is valid (the signature
>> of the RPM header is taken from RPMTAG_RSAHEADER).
>>
>> The memory occupation is relatively small for executables
>> and shared libraries. I published a demo for Fedora and
>> openSUSE some time ago:
>>
>> https://lore.kernel.org/linux-
>> integrity/48cd737c504d45208377daa27d625531@huawei.com/
>>
>> Thanks
>>
>> Roberto
>>
>> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
>> Managing Director: Li Peng, Zhong Ronghua
