Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E88743E99A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Oct 2021 22:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJ1UjV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Oct 2021 16:39:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:33832 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbhJ1UjV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Oct 2021 16:39:21 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 467AF209F33D;
        Thu, 28 Oct 2021 13:36:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 467AF209F33D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635453413;
        bh=Sg4m6cIIMp0EQlTCVJOG/HF3l5yRADl+P97rGruin0k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hW0/0qsrhCnqI78v+oDwAvZFvLjiPG51C68cXBUMU6MR1eR5jWJHsJKWGKrWXSNMF
         CWkcJ68JGNUCYLNRVSk/12qevtpsVu+81b44Qc4SGVhoGZ+rmXKae97muGaHGNG0Sm
         +QcQWIujZYLgO9SsV4tXIpONaX5eBJ+0InFJHinw=
Message-ID: <c13eebea-0ccf-6b16-f12b-50e89ae4bb6d@linux.microsoft.com>
Date:   Thu, 28 Oct 2021 13:36:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v7 00/16] Integrity Policy Enforcement (IPE)
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>
Cc:     "jannh@google.com" <jannh@google.com>,
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
 <0a61327839b841a1a9d915a09d1d8b8c@huawei.com>
 <d1d1e9d2-5472-5a1d-1fba-7066888ff77e@linux.microsoft.com>
 <d5db8cd28de74fb8a3295b1b1c7f0522@huawei.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <d5db8cd28de74fb8a3295b1b1c7f0522@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/27/2021 1:26 AM, Roberto Sassu wrote:
>> From: Deven Bowers [mailto:deven.desai@linux.microsoft.com]
>> Sent: Tuesday, October 26, 2021 9:04 PM
>> On 10/25/2021 4:30 AM, Roberto Sassu wrote:
>>>> From:deven.desai@linux.microsoft.com
>>>> [mailto:deven.desai@linux.microsoft.com]
>>>> From: Deven Bowers<deven.desai@linux.microsoft.com>
>>>>
>>>> Overview:
>>>> ---------
>>>>
>>>> IPE is a Linux Security Module which takes a complimentary approach to
>>>> access control. Whereas existing systems approach use labels or paths
>>>> which control access to a resource, IPE controls access to a resource
>>>> based on the system's trust of said resource.
>>> To me, it does not give a particularly precise idea of what IPE is about.
>>>
>>> It would have been more clear, assuming that I understood it correctly,
>>> if you have said:
>>>
>>> Whereas existing mandatory access control mechanisms base their
>>> decisions on labels and paths, IPE instead determines whether or not
>>> an operation should be allowed based on immutable security properties
>>> of the system component the operation is being performed on.
>>>
>>> IPE itself does not mandate how the security property should be
>>> evaluated, but relies on an extensible set of external property providers
>>> to evaluate the component. IPE makes its decision based on reference
>>> values for the selected properties, specified in the IPE policy.
>>>
>>> The reference values represent the value that the policy writer and the
>>> local system administrator (based on the policy signature) trust for the
>>> system to accomplish the desired tasks.
>>>
>>> One such provider is for example dm-verity, which is able to represent
>>> the integrity property of a partition (its immutable state) with a digest.
>> You understood it perfectly, and managed to word in a much more clear
>> way than I did. I'll apply these changes in the next posting! Thanks.
> Welcome.
>
>>>> Trust requirements are established via IPE's policy, sourcing multiple
>>>> different implementations within the kernel to build a cohesive trust
>>>> model, based on how the system was built.
>>>>
>>>> Trust, with respect to computing, is a concept that designates a set
>>>> of entities who will endorse a set of resources as non-malicious.
>>>> Traditionally, this is done via signatures, which is the act of endorsing
>>>> a resource.
>>>>
>>>> Integrity, on the other hand, is the concept of ensuring that a resource
>>>> has not been modified since a point of time. This is typically done through
>>>> cryptographic hashes or signatures.
>>>>
>>>> Trust and integrity are very closely tied together concepts, as integrity
>>>> is the way you can prove trust for a resource; otherwise it could have
>>>> been modified by an entity who is untrusted.
>>>>
>>>> IPE provides a way for a user to express trust requirements of resources,
>>>> by using pre-existing systems which provide the integrity half of the
>>>> equation.
>>>>
>>>> IPE is compiled under CONFIG_SECURITY_IPE.
>>>>
>>>> Use Cases
>>>> ---------
>>>>
>>>> IPE works best in fixed-function devices: Devices in which their purpose
>>>> is clearly defined and not supposed to be changed (e.g. network firewall
>>>> device in a data center, an IoT device, etcetera), where all software and
>>>> configuration is built and provisioned by the system owner.
>>>>
>>>> IPE is a long-way off for use in general-purpose computing:
>>>> the Linux community as a whole tends to follow a decentralized trust
>>>> model, known as the Web of Trust, which IPE has no support for as of yet.
>>>> Instead, IPE supports the PKI Trust Model, which generally designates a
>>>> set of entities that provide a measure absolute trust.
>>> It is true that packages are signed with PGP, which is decentralized,
>>> but there is a special case where Linux distribution vendors trust
>>> their own keys. This, at least, would allow to trust the software built
>>> by a particular vendor (I ported David Howells's work on PGP keys and
>>> signature to the current kernel).
>> Yes, that is true. I figured that this scenario was somewhat obvious,
>> as it is, at a high level, similar to PKI but I can certainly add it
>> explicitly.
> Perfect.
>
>>>> Additionally, while most packages are signed today, the files inside
>>>> the packages (for instance, the executables), tend to be unsigned. This
>>>> makes it difficult to utilize IPE in systems where a package manager is
>>>> expected to be functional, without major changes to the package manager
>>>> and ecosystem behind it.
>>> Yes, RPMs don't have per file signatures but have a signature of the
>>> list of file digests, which is equivalent. They could have also the fsverity
>>> digests (instead of the fsverity signatures) to reduce size overhead.
>>>
>>> Given that the authenticity of RPMs headers can be verified, if the
>>> PGP key of the vendor is included in the primary keyring of the kernel,
>>> being able to protect file or fsverity digests against tampering by
>>> user space and being able to query them (e.g. with DIGLIM) extends
>>> the applicability of IPE to general purpose OSes.
>> Agreed. With these two functionalities, it does appear that IPE + DIGLIM
>> can be used for general purpose RPM-based OSes. I'll add a reference to
>> your recent posting (v3?) as a way to extend the functionality to general
>> purposes OSes in the next revision.
> Ok. Yes, v3 is the latest.
>
>>>> Policy:
>>>> -------
>>>>
>>>> IPE policy is a plain-text [#]_ policy composed of multiple statements
>>>> over several lines. There is one required line, at the top of the
>>>> policy, indicating the policy name, and the policy version, for
>>>> instance:
>>>>
>>>>     policy_name="Ex Policy" policy_version=0.0.0
>>>>
>>>> The policy version indicates the current version of the policy (NOT the
>>>> policy syntax version). This is used to prevent roll-back of policy to
>>>> potentially insecure previous versions of the policy.
>>>>
>>>> The next portion of IPE policy, are rules. Rules are formed by key=value
>>>> pairs, known as properties. IPE rules require two properties: "action",
>>> Better:
>>>
>>> IPE rules require two keys:
>> Ack.
>>>> which determines what IPE does when it encounters a match against the
>>>> policy, and "op", which determines when that rule should be evaluated.
>>>> Thus, a minimal rule is:
>>>>
>>>>     op=EXECUTE action=ALLOW
>>>>
>>>> This example will allow any execution. Additional properties are used to
>>>> restrict attributes about the files being evaluated. These properties are
>>>> intended to be deterministic attributes that are resident in the kernel.
>>>> Available properties for IPE described in the documentation patch of this
>>>> series.
>>>>
>>>> A rule is required to have the "op" property as the first token of a rule,
>>>> and the "action" as the last token of the rule. Rules are evaluated
>>>> top-to-bottom. As a result, any revocation rules, or denies should be
>>>> placed early in the file to ensure that these rules are evaluated before
>>>> a rule with "action=ALLOW" is hit.
>>>>
>>>> Any unknown syntax in IPE policy will result in a fatal error to parse
>>>> the policy. User mode can interrogate the kernel to understand what
>>>> properties and the associated versions through the securityfs node,
>>>> $securityfs/ipe/config, which will return a string of form:
>>>>
>>>>     key1=version1
>>>>     key2=version2
>>>>     .
>>>>     .
>>>>     .
>>>>     keyN=versionN
>>>>
>>>> User-mode should correlate these versions with the supported values
>>>> identified in the documentation to determine whether a policy should
>>>> be accepted by the system without actually trying to deploy the policy.
>>>>
>>>> Additionally, a DEFAULT operation must be set for all understood
>>>> operations within IPE. For policies to remain completely forwards
>>>> compatible, it is recommended that users add a "DEFAULT action=ALLOW"
>>>> and override the defaults on a per-operation basis.
>>>>
>>>> For more information about the policy syntax, the kernel documentation
>>>> page.
>>>>
>>>> Early Usermode Protection:
>>>> --------------------------
>>>>
>>>> IPE can be provided with a policy at startup to load and enforce.
>>>> This is intended to be a minimal policy to get the system to a state
>>>> where userland is setup and ready to receive commands, at which
>>>> point a policy can be deployed via securityfs. This "boot policy" can be
>>>> specified via the config, SECURITY_IPE_BOOT_POLICY, which accepts a path
>>>> to a plain-text version of the IPE policy to apply. This policy will be
>>>> compiled into the kernel. If not specified, IPE will be disabled until a
>>>> policy is deployed and activated through the method above.
>>>>
>>>> Policy Examples:
>>>> ----------------
>>>>
>>>> Allow all:
>>>>
>>>>     policy_name="Allow All" policy_version=0.0.0
>>>>     DEFAULT action=ALLOW
>>>>
>>>> Allow only initial superblock:
>>>>
>>>>     policy_name="Allow All Initial SB" policy_version=0.0.0
>>>>     DEFAULT action=DENY
>>>>
>>>>     op=EXECUTE boot_verified=TRUE action=ALLOW
>>>>
>>>> Allow any signed dm-verity volume and the initial superblock:
>>>>
>>>>     policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>>>     DEFAULT action=DENY
>>>>
>>>>     op=EXECUTE boot_verified=TRUE action=ALLOW
>>>>     op=EXECUTE dmverity_signature=TRUE action=ALLOW
>>>>
>>>> Prohibit execution from a specific dm-verity volume:
>>>>
>>>>     policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>>>     DEFAULT action=DENY
>>>>
>>>>     op=EXECUTE
>>>>
>> dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec
>>>> 146938 action=DENY
>>>>     op=EXECUTE boot_verified=TRUE action=ALLOW
>>>>     op=EXECUTE dmverity_signature=TRUE action=ALLOW
>>>>
>>>> Allow only a specific dm-verity volume:
>>>>
>>>>     policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>>>     DEFAULT action=DENY
>>>>
>>>>     op=EXECUTE
>>>>
>> dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec
>>>> 146938 action=ALLOW
>>>>
>>>> Deploying Policies:
>>>> -------------------
>>>>
>>>> First sign a plain text policy, with a certificate that is present in
>>>> the SYSTEM_TRUSTED_KEYRING of your test machine. Through openssl, the
>>>> signing can be done via:
>>>>
>>>>     openssl smime -sign -in "$MY_POLICY" -signer "$MY_CERTIFICATE" \
>>>>       -inkey "$MY_PRIVATE_KEY" -binary -outform der -noattr -nodetach \
>>>>       -out "$MY_POLICY.p7s"
>>>>
>>>> Then, simply cat the file into the IPE's "new_policy" securityfs node:
>>>>
>>>>     cat "$MY_POLICY.p7s" > /sys/kernel/security/ipe/new_policy
>>>>
>>>> The policy should now be present under the policies/ subdirectory, under
>>>> its "policy_name" attribute.
>>>>
>>>> The policy is now present in the kernel and can be marked as active,
>>>> via the securityfs node:
>>>>
>>>>     echo "1" > "/sys/kernel/security/ipe/$MY_POLICY_NAME/active"
>>>>
>>>> This will now mark the policy as active and the system will be enforcing
>>>> $MY_POLICY_NAME.
>>>>
>>>> There is one requirement when marking a policy as active, the policy_version
>>>> attribute must either increase, or remain the same as the currently running
>>>> policy.
>>>>
>>>> Policies can be updated via:
>>>>
>>>>     cat "$MY_UPDATED_POLICY.p7s" > \
>>>>       "/sys/kernel/security/ipe/policies/$MY_POLICY_NAME/update"
>>>>
>>>> Additionally, policies can be deleted via the "delete" securityfs
>>>> node. Simply write "1" to the corresponding node in the policy folder:
>>>>
>>>>     echo "1" > "/sys/kernel/security/ipe/policies/$MY_POLICY_NAME/delete"
>>>>
>>>> There is only one requirement to delete policies, the policy being
>>>> deleted must not be the active policy.
>>>>
>>>> NOTE: The securityfs commands will require CAP_MAC_ADMIN.
>>>>
>>>> Integrations:
>>>> -------------
>>>>
>>>> This patch series adds support for fsverity via digest and signature
>>>> (fsverity_signature and fsverity_digest), dm-verity by digest and
>>>> signature (dmverity_signature and dmverity_roothash), and trust for
>>>> the initramfs (boot_verified).
>>> Verifying the initial ram disk looks like a big problem. On general
>>> purpose OSes, having a reference value for it would be very hard.
>>>
>>> Instead, we would still be able to use per file reference values.
>>> Executable and shared libraries in the initial ram disk are copied
>>> from the main OS. Without fsverity support in tmpfs, I wonder
>>> if it would be still possible to mark the file as immutable and do
>>> an on the fly calculation of the root digest.
>> Yes, verifying the initial ramdisk is very difficult. "boot_verified",
>> is largely an assumption of trust as all the warning shows in the
>> documentation; it assumes the boot stack verified the initramfs somehow
>> (i.e. u-boot verified boot with it in the fitImage), and 'pins' (similar
>> to loadpin) the superblock to allow execution from that superblock.
>>> As an alternative, the IMA approach of calculating the file digest
>>> could be used (or IPE could get the file digest as a property from
>>> the integrity subsystem).
>> In general, I would like to keep as much of the implementation of the
>> integrity mechanisms out of IPE as much as possible - there are likely
>> much better layers to implement new ways of providing integrity /
>> authenticity claims than at the lsm layer within IPE.
> That would be still the case. The integrity subsystem will be still
> responsible to calculate the file digest and maintain it in a per
> inode metadata. Then, IPE could evaluate the file digest as the
> same as for the fsverity digest:
>
> op=EXECUTE integrity_digest=<hex> action=ALLOW
>
> integrity_digest will be handled by a separate IPE module which
> communicates with the integrity subsystem.

Sure, I'm happy with this. My comment was originally to the first half
of your response ("the IMA approach of calculating the file digest
could be used"); I don't see that as part of IPE's purpose.

I wanted to draw as rough boundary between what I find acceptable
as an IPE extension and what isn't.


