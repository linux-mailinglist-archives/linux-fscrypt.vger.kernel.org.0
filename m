Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B9F43BA2B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 21:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238516AbhJZTGQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 15:06:16 -0400
Received: from linux.microsoft.com ([13.77.154.182]:56212 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbhJZTF5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 15:05:57 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6B9B220A5C29;
        Tue, 26 Oct 2021 12:03:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6B9B220A5C29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1635275013;
        bh=LbYvFHeuIT/HcZT5kQmlJKLN5nx8xe1Jlq6EGuz5Be4=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=qNDj9ArGWZBUhiutFUDtmp93alVv9iwpvOHNG54hbFwHrjKz0UArdixn6JLSO3fxW
         wshVdl4xSPzRQZRzJKcd/B8J9oYdB5FKo98eooeKxP3+o7olG8EGj0AgTdx5+S+o/4
         3Hz0SwtXHSHk6KUeYgMZ0NnBEtVHSI/hYk1hqqhU=
Message-ID: <d1d1e9d2-5472-5a1d-1fba-7066888ff77e@linux.microsoft.com>
Date:   Tue, 26 Oct 2021 12:03:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
From:   Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v7 00/16] Integrity Policy Enforcement (IPE)
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
Content-Language: en-US
In-Reply-To: <0a61327839b841a1a9d915a09d1d8b8c@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 10/25/2021 4:30 AM, Roberto Sassu wrote:
>> From:deven.desai@linux.microsoft.com
>> [mailto:deven.desai@linux.microsoft.com]
>> From: Deven Bowers<deven.desai@linux.microsoft.com>
>>
>> Overview:
>> ---------
>>
>> IPE is a Linux Security Module which takes a complimentary approach to
>> access control. Whereas existing systems approach use labels or paths
>> which control access to a resource, IPE controls access to a resource
>> based on the system's trust of said resource.
> To me, it does not give a particularly precise idea of what IPE is about.
>
> It would have been more clear, assuming that I understood it correctly,
> if you have said:
>
> Whereas existing mandatory access control mechanisms base their
> decisions on labels and paths, IPE instead determines whether or not
> an operation should be allowed based on immutable security properties
> of the system component the operation is being performed on.
>
> IPE itself does not mandate how the security property should be
> evaluated, but relies on an extensible set of external property providers
> to evaluate the component. IPE makes its decision based on reference
> values for the selected properties, specified in the IPE policy.
>
> The reference values represent the value that the policy writer and the
> local system administrator (based on the policy signature) trust for the
> system to accomplish the desired tasks.
>
> One such provider is for example dm-verity, which is able to represent
> the integrity property of a partition (its immutable state) with a digest.
You understood it perfectly, and managed to word in a much more clear
way than I did. I'll apply these changes in the next posting! Thanks.
>> Trust requirements are established via IPE's policy, sourcing multiple
>> different implementations within the kernel to build a cohesive trust
>> model, based on how the system was built.
>>
>> Trust, with respect to computing, is a concept that designates a set
>> of entities who will endorse a set of resources as non-malicious.
>> Traditionally, this is done via signatures, which is the act of endorsing
>> a resource.
>>
>> Integrity, on the other hand, is the concept of ensuring that a resource
>> has not been modified since a point of time. This is typically done through
>> cryptographic hashes or signatures.
>>
>> Trust and integrity are very closely tied together concepts, as integrity
>> is the way you can prove trust for a resource; otherwise it could have
>> been modified by an entity who is untrusted.
>>
>> IPE provides a way for a user to express trust requirements of resources,
>> by using pre-existing systems which provide the integrity half of the
>> equation.
>>
>> IPE is compiled under CONFIG_SECURITY_IPE.
>>
>> Use Cases
>> ---------
>>
>> IPE works best in fixed-function devices: Devices in which their purpose
>> is clearly defined and not supposed to be changed (e.g. network firewall
>> device in a data center, an IoT device, etcetera), where all software and
>> configuration is built and provisioned by the system owner.
>>
>> IPE is a long-way off for use in general-purpose computing:
>> the Linux community as a whole tends to follow a decentralized trust
>> model, known as the Web of Trust, which IPE has no support for as of yet.
>> Instead, IPE supports the PKI Trust Model, which generally designates a
>> set of entities that provide a measure absolute trust.
> It is true that packages are signed with PGP, which is decentralized,
> but there is a special case where Linux distribution vendors trust
> their own keys. This, at least, would allow to trust the software built
> by a particular vendor (I ported David Howells's work on PGP keys and
> signature to the current kernel).
Yes, that is true. I figured that this scenario was somewhat obvious,
as it is, at a high level, similar to PKI but I can certainly add it
explicitly.
>> Additionally, while most packages are signed today, the files inside
>> the packages (for instance, the executables), tend to be unsigned. This
>> makes it difficult to utilize IPE in systems where a package manager is
>> expected to be functional, without major changes to the package manager
>> and ecosystem behind it.
> Yes, RPMs don't have per file signatures but have a signature of the
> list of file digests, which is equivalent. They could have also the fsverity
> digests (instead of the fsverity signatures) to reduce size overhead.
>
> Given that the authenticity of RPMs headers can be verified, if the
> PGP key of the vendor is included in the primary keyring of the kernel,
> being able to protect file or fsverity digests against tampering by
> user space and being able to query them (e.g. with DIGLIM) extends
> the applicability of IPE to general purpose OSes.
Agreed. With these two functionalities, it does appear that IPE + DIGLIM
can be used for general purpose RPM-based OSes. I'll add a reference to
your recent posting (v3?) as a way to extend the functionality to general
purposes OSes in the next revision.
>> Policy:
>> -------
>>
>> IPE policy is a plain-text [#]_ policy composed of multiple statements
>> over several lines. There is one required line, at the top of the
>> policy, indicating the policy name, and the policy version, for
>> instance:
>>
>>    policy_name="Ex Policy" policy_version=0.0.0
>>
>> The policy version indicates the current version of the policy (NOT the
>> policy syntax version). This is used to prevent roll-back of policy to
>> potentially insecure previous versions of the policy.
>>
>> The next portion of IPE policy, are rules. Rules are formed by key=value
>> pairs, known as properties. IPE rules require two properties: "action",
> Better:
>
> IPE rules require two keys:
Ack.
>> which determines what IPE does when it encounters a match against the
>> policy, and "op", which determines when that rule should be evaluated.
>> Thus, a minimal rule is:
>>
>>    op=EXECUTE action=ALLOW
>>
>> This example will allow any execution. Additional properties are used to
>> restrict attributes about the files being evaluated. These properties are
>> intended to be deterministic attributes that are resident in the kernel.
>> Available properties for IPE described in the documentation patch of this
>> series.
>>
>> A rule is required to have the "op" property as the first token of a rule,
>> and the "action" as the last token of the rule. Rules are evaluated
>> top-to-bottom. As a result, any revocation rules, or denies should be
>> placed early in the file to ensure that these rules are evaluated before
>> a rule with "action=ALLOW" is hit.
>>
>> Any unknown syntax in IPE policy will result in a fatal error to parse
>> the policy. User mode can interrogate the kernel to understand what
>> properties and the associated versions through the securityfs node,
>> $securityfs/ipe/config, which will return a string of form:
>>
>>    key1=version1
>>    key2=version2
>>    .
>>    .
>>    .
>>    keyN=versionN
>>
>> User-mode should correlate these versions with the supported values
>> identified in the documentation to determine whether a policy should
>> be accepted by the system without actually trying to deploy the policy.
>>
>> Additionally, a DEFAULT operation must be set for all understood
>> operations within IPE. For policies to remain completely forwards
>> compatible, it is recommended that users add a "DEFAULT action=ALLOW"
>> and override the defaults on a per-operation basis.
>>
>> For more information about the policy syntax, the kernel documentation
>> page.
>>
>> Early Usermode Protection:
>> --------------------------
>>
>> IPE can be provided with a policy at startup to load and enforce.
>> This is intended to be a minimal policy to get the system to a state
>> where userland is setup and ready to receive commands, at which
>> point a policy can be deployed via securityfs. This "boot policy" can be
>> specified via the config, SECURITY_IPE_BOOT_POLICY, which accepts a path
>> to a plain-text version of the IPE policy to apply. This policy will be
>> compiled into the kernel. If not specified, IPE will be disabled until a
>> policy is deployed and activated through the method above.
>>
>> Policy Examples:
>> ----------------
>>
>> Allow all:
>>
>>    policy_name="Allow All" policy_version=0.0.0
>>    DEFAULT action=ALLOW
>>
>> Allow only initial superblock:
>>
>>    policy_name="Allow All Initial SB" policy_version=0.0.0
>>    DEFAULT action=DENY
>>
>>    op=EXECUTE boot_verified=TRUE action=ALLOW
>>
>> Allow any signed dm-verity volume and the initial superblock:
>>
>>    policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>    DEFAULT action=DENY
>>
>>    op=EXECUTE boot_verified=TRUE action=ALLOW
>>    op=EXECUTE dmverity_signature=TRUE action=ALLOW
>>
>> Prohibit execution from a specific dm-verity volume:
>>
>>    policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>    DEFAULT action=DENY
>>
>>    op=EXECUTE
>> dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec
>> 146938 action=DENY
>>    op=EXECUTE boot_verified=TRUE action=ALLOW
>>    op=EXECUTE dmverity_signature=TRUE action=ALLOW
>>
>> Allow only a specific dm-verity volume:
>>
>>    policy_name="AllowSignedAndInitial" policy_version=0.0.0
>>    DEFAULT action=DENY
>>
>>    op=EXECUTE
>> dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec
>> 146938 action=ALLOW
>>
>> Deploying Policies:
>> -------------------
>>
>> First sign a plain text policy, with a certificate that is present in
>> the SYSTEM_TRUSTED_KEYRING of your test machine. Through openssl, the
>> signing can be done via:
>>
>>    openssl smime -sign -in "$MY_POLICY" -signer "$MY_CERTIFICATE" \
>>      -inkey "$MY_PRIVATE_KEY" -binary -outform der -noattr -nodetach \
>>      -out "$MY_POLICY.p7s"
>>
>> Then, simply cat the file into the IPE's "new_policy" securityfs node:
>>
>>    cat "$MY_POLICY.p7s" > /sys/kernel/security/ipe/new_policy
>>
>> The policy should now be present under the policies/ subdirectory, under
>> its "policy_name" attribute.
>>
>> The policy is now present in the kernel and can be marked as active,
>> via the securityfs node:
>>
>>    echo "1" > "/sys/kernel/security/ipe/$MY_POLICY_NAME/active"
>>
>> This will now mark the policy as active and the system will be enforcing
>> $MY_POLICY_NAME.
>>
>> There is one requirement when marking a policy as active, the policy_version
>> attribute must either increase, or remain the same as the currently running
>> policy.
>>
>> Policies can be updated via:
>>
>>    cat "$MY_UPDATED_POLICY.p7s" > \
>>      "/sys/kernel/security/ipe/policies/$MY_POLICY_NAME/update"
>>
>> Additionally, policies can be deleted via the "delete" securityfs
>> node. Simply write "1" to the corresponding node in the policy folder:
>>
>>    echo "1" > "/sys/kernel/security/ipe/policies/$MY_POLICY_NAME/delete"
>>
>> There is only one requirement to delete policies, the policy being
>> deleted must not be the active policy.
>>
>> NOTE: The securityfs commands will require CAP_MAC_ADMIN.
>>
>> Integrations:
>> -------------
>>
>> This patch series adds support for fsverity via digest and signature
>> (fsverity_signature and fsverity_digest), dm-verity by digest and
>> signature (dmverity_signature and dmverity_roothash), and trust for
>> the initramfs (boot_verified).
> Verifying the initial ram disk looks like a big problem. On general
> purpose OSes, having a reference value for it would be very hard.
>
> Instead, we would still be able to use per file reference values.
> Executable and shared libraries in the initial ram disk are copied
> from the main OS. Without fsverity support in tmpfs, I wonder
> if it would be still possible to mark the file as immutable and do
> an on the fly calculation of the root digest.
Yes, verifying the initial ramdisk is very difficult. "boot_verified",
is largely an assumption of trust as all the warning shows in the
documentation; it assumes the boot stack verified the initramfs somehow
(i.e. u-boot verified boot with it in the fitImage), and 'pins' (similar
to loadpin) the superblock to allow execution from that superblock.
> As an alternative, the IMA approach of calculating the file digest
> could be used (or IPE could get the file digest as a property from
> the integrity subsystem).
In general, I would like to keep as much of the implementation of the
integrity mechanisms out of IPE as much as possible - there are likely
much better layers to implement new ways of providing integrity /
authenticity claims than at the lsm layer within IPE.
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
>> Please see the documentation patch for more information about the
>> integrations available.
>>
>> Testing:
>> --------
>>
>> KUnit Tests are available. Recommended kunitconfig:
>>
>>      CONFIG_KUNIT=y
>>      CONFIG_SECURITY=y
>>      CONFIG_SECURITYFS=y
>>      CONFIG_PKCS7_MESSAGE_PARSER=y
>>      CONFIG_SYSTEM_DATA_VERIFICATION=y
>>      CONFIG_FS_VERITY=y
>>      CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
>>      CONFIG_BLOCK=y
>>      CONFIG_MD=y
>>      CONFIG_BLK_DEV_DM=y
>>      CONFIG_DM_VERITY=y
>>      CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
>>
>>      CONFIG_SECURITY_IPE=y
>>      CONFIG_SECURITY_IPE_KUNIT_TEST=y
>>      CONFIG_IPE_PROP_BOOT_VERIFIED=y
>>      CONFIG_IPE_PROP_DM_VERITY_SIGNATURE=y
>>      CONFIG_IPE_PROP_DM_VERITY_ROOTHASH=y
>>      CONFIG_IPE_PROP_FS_VERITY_SIGNATURE=y
>>      CONFIG_IPE_PROP_FS_VERITY_DIGEST=y
>>
>> Simply run:
>>
>>      make ARCH=um mrproper
>>      ./tools/testing/kunit/kunit.py run --kunitconfig <path/to/config>
>>
>> And the tests will execute and report the result. For more indepth testing,
>> it will require you to create and mount a dm-verity volume or fs-verity
>> enabled file.
>>
>> Documentation:
>> --------------
>>
>> There is both documentation available on github at
>> https://microsoft.github.io/ipe, and Documentation in this patch series,
>> to be added in-tree. This includes architectural block diagrams.
>>
>> Known Gaps:
>> -----------
>>
>> IPE has two known gaps:
>>
>> 1. IPE cannot verify the integrity of anonymous executable memory, such as
>>    the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
>>    Unfortunately, as this is dynamically generated code, there is no way
>>    for IPE to ensure the integrity of this code to form a trust basis. In all
>>    cases, the return result for these operations will be whatever the admin
>>    configures the DEFAULT action for "EXECUTE".
>>
>> 2. IPE cannot verify the integrity of interpreted languages' programs when
>>    these scripts invoked via ``<interpreter> <file>``. This is because the
>>    way interpreters execute these files, the scripts themselves are not
>>    evaluated as executable code through one of IPE's hooks. Interpreters
>>    can be enlightened to the usage of IPE by trying to mmap a file into
>>    executable memory (+X), after opening the file and responding to the
>>    error code appropriately. This also applies to included files, or high
>>    value files, such as configuration files of critical system components.
>>    However, there is a patchset that is looking to address this gap [1].
>>
>> Appendix:
>> ---------
>>
>> A. IPE Github Repository:https://github.com/microsoft/ipe
>> B. IPE Users' Guide: Documentation/admin-guide/LSM/ipe.rst
>>
>> References:
>> -----------
>>
>> [1]https://lore.kernel.org/all/20211012192410.2356090-1-mic@digikod.net/
>>
>> FAQ:
>> ----
>>
>> Q: What's the difference between other LSMs which provide trust-based
>>    access control, for instance, IMA?
>>
>> A: IMA is a fantastic option when needing measurement in addition to the
>>    trust-based access model. All of IMA is centered around their measurement
>>    hashes, so you save time when doing both actions. IPE, on the other hand,
>>    is a highly performant system that does not rely (and explicitly prohibits),
>>    generating its own integrity mechanisms - separating measurement and access
>>    control. Simply put, IPE provides only the enforcement of trust, while other
>>    subsystems provide the integrity guarantee that IPE needs to determine the
>>    trust of a resource. IMA provides both the integrity guarantee, the
>>    enforcement of trust, and a whole host of other features that may not be
>>    needed.
>>
>> Changelog:
>> ----------
>>
>> Changes since v1:
>>    Split the second patch of the previous series into two.
>>    Minor corrections in the cover-letter and documentation
>>    comments regarding CAP_MAC_ADMIN checks in IPE.
>>
>> Changes since v2:
>>    Address various comments by Jann Horn. Highlights:
>>      Switch various audit allocators to GFP_KERNEL.
>>      Utilize rcu_access_pointer() in various locations.
>>      Strip out the caching system for properties
>>      Strip comments from headers
>>      Move functions around in patches
>>      Remove kernel command line parameters
>>      Reconcile the race condition on the delete node for policy by
>>        expanding the policy critical section.
>>
>>    Address a few comments by Jonathan Corbet around the documentation
>>      pages for IPE.
>>
>>    Fix an issue with the initialization of IPE policy with a "-0"
>>      version, caused by not initializing the hlist entries before
>>      freeing.
>>
>> Changes since v3:
>>    Address a concern around IPE's behavior with unknown syntax.
>>      Specifically, make any unknown syntax a fatal error instead of a
>>      warning, as suggested by Mickaël Salaün.
>>    Introduce a new securityfs node, $securityfs/ipe/property_config,
>>      which provides a listing of what properties are enabled by the
>>      kernel and their versions. This allows usermode to predict what
>>      policies should be allowed.
>>    Strip some comments from c files that I missed.
>>    Clarify some documentation comments around 'boot_verified'.
>>      While this currently does not functionally change the property
>>      itself, the distinction is important when IPE can enforce verified
>>      reads. Additionally, 'KERNEL_READ' was omitted from the documentation.
>>      This has been corrected.
>>    Change SecurityFS and SHA1 to a reverse dependency.
>>    Update the cover-letter with the updated behavior of unknown syntax.
>>    Remove all sysctls, making an equivalent function in securityfs.
>>    Rework the active/delete mechanism to be a node under the policy in
>>      $securityfs/ipe/policies.
>>    The kernel command line parameters ipe.enforce and ipe.success_audit
>>      have returned as this functionality is no longer exposed through
>>      sysfs.
>>
>> Changes since v4:
>>    Correct some grammatical errors reported by Randy Dunlap.
>>    Fix some warnings reported by kernel test bot.
>>    Change convention around security_bdev_setsecurity. -ENOSYS
>>      is now expected if an LSM does not implement a particular @name,
>>      as suggested by Casey Schaufler.
>>    Minor string corrections related to the move from sysfs to securityfs
>>    Correct a spelling of an #ifdef for the permissive argument.
>>    Add the kernel parameters re-added to the documentation.
>>    Fix a minor bug where the mode being audited on permissive switch
>>      was the original mode, not the mode being swapped to.
>>    Cleanup doc comments, fix some whitespace alignment issues.
>>
>> Changes since v5:
>>    Change if statement condition in security_bdev_setsecurity to be
>>      more concise, as suggested by Casey Schaufler and Al Viro
>>    Drop the 6th patch in the series, "dm-verity move signature check..."
>>      due to numerous issues, and it ultimately providing no real value.
>>    Fix the patch tree - the previous iteration appears to have been in a
>>      torn state (patches 8+9 were merged). This has since been corrected.
>>
>> Changes since v6:
>>    * Reword cover letter to more accurate convey IPE's purpose
>>      and latest updates.
>>    * Refactor series to:
>>        1. Support a context structure, enabling:
>>            1. Easier Testing via KUNIT
>>            2. A better architecture for future designs
>>        2. Make parser code cleaner
>>    * Move patch 01/12 to [14/16] of the series
>>    * Split up patch 02/12 into four parts:
>>        1. context creation [01/16]
>>        2. audit [07/16]
>>        3. evaluation loop [03/16]
>>        4. access control hooks [05/16]
>>        5. permissive mode [08/16]
>>    * Split up patch 03/12 into two parts:
>>        1. parser [02/16]
>>        2. userspace interface [04/16]
>>    * Reword and refactor patch 04/12 to [09/16]
>>    * Squash patch 05/12, 07/12, 09/12 to [10/16]
>>    * Squash patch 08/12, 10/12 to [11/16]
>>    * Change audit records to MAC region (14XX) from Integrity region (18XX)
>>    * Add FSVerity Support
>>    * Interface changes:
>>        1. "raw" was renamed to "pkcs7" and made read only
>>        2. "raw"'s write functionality (update a policy) moved to "update"
>>        3. introduced "version", "policy_name" nodes.
>>        4. "content" renamed to "policy"
>>        5. The boot policy can now be updated like any other policy.
>>    * Add additional developer-level documentation
>>    * Update admin-guide docs to reflect changes.
>>    * Kunit tests
>>    * Dropped CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH - functionality can
>>      easily come later with a small patch.
>>    * Use partition0 for block_device for dm-verity patch
>>
>> Deven Bowers (14):
>>    security: add ipe lsm & initial context creation
>>    ipe: add policy parser
>>    ipe: add evaluation loop
>>    ipe: add userspace interface
>>    ipe: add LSM hooks on execution and kernel read
>>    uapi|audit: add trust audit message definitions
>>    ipe: add auditing support
>>    ipe: add permissive toggle
>>    ipe: introduce 'boot_verified' as a trust provider
>>    fs|dm-verity: add block_dev LSM blob and submit dm-verity data
>>    ipe: add support for dm-verity as a trust provider
>>    scripts: add boot policy generation program
>>    ipe: kunit tests
>>    documentation: add ipe documentation
>>
>> Fan Wu (2):
>>    fsverity|security: add security hooks to fsverity digest and signature
>>    ipe: enable support for fs-verity as a trust provider
>>
>>   Documentation/admin-guide/LSM/index.rst       |    1 +
>>   Documentation/admin-guide/LSM/ipe.rst         |  587 ++++++++++
>>   .../admin-guide/kernel-parameters.txt         |   12 +
>>   Documentation/security/index.rst              |    1 +
>>   Documentation/security/ipe.rst                |  339 ++++++
>>   MAINTAINERS                                   |    9 +
>>   block/bdev.c                                  |    7 +
>>   drivers/md/dm-verity-target.c                 |   20 +-
>>   drivers/md/dm-verity-verify-sig.c             |   16 +-
>>   drivers/md/dm-verity-verify-sig.h             |   10 +-
>>   fs/verity/open.c                              |   12 +
>>   fs/verity/signature.c                         |    5 +-
>>   include/asm-generic/vmlinux.lds.h             |   16 +
>>   include/linux/blk_types.h                     |    1 +
>>   include/linux/device-mapper.h                 |    3 +
>>   include/linux/fsverity.h                      |    3 +
>>   include/linux/lsm_hook_defs.h                 |    5 +
>>   include/linux/lsm_hooks.h                     |   12 +
>>   include/linux/security.h                      |   22 +
>>   include/uapi/linux/audit.h                    |    4 +
>>   scripts/Makefile                              |    1 +
>>   scripts/ipe/Makefile                          |    2 +
>>   scripts/ipe/polgen/.gitignore                 |    1 +
>>   scripts/ipe/polgen/Makefile                   |    6 +
>>   scripts/ipe/polgen/polgen.c                   |  145 +++
>>   security/Kconfig                              |   11 +-
>>   security/Makefile                             |    1 +
>>   security/ipe/.gitignore                       |    1 +
>>   security/ipe/Kconfig                          |  100 ++
>>   security/ipe/Makefile                         |   39 +
>>   security/ipe/audit.c                          |  304 +++++
>>   security/ipe/audit.h                          |   41 +
>>   security/ipe/ctx.c                            |  381 ++++++
>>   security/ipe/ctx.h                            |   43 +
>>   security/ipe/ctx_test.c                       |  732 ++++++++++++
>>   security/ipe/eval.c                           |  237 ++++
>>   security/ipe/eval.h                           |   57 +
>>   security/ipe/fs.c                             |  327 ++++++
>>   security/ipe/fs.h                             |   13 +
>>   security/ipe/hooks.c                          |  328 ++++++
>>   security/ipe/hooks.h                          |   56 +
>>   security/ipe/ipe.c                            |  143 +++
>>   security/ipe/ipe.h                            |   27 +
>>   security/ipe/ipe_parser.h                     |   59 +
>>   security/ipe/modules.c                        |  134 +++
>>   security/ipe/modules.h                        |   17 +
>>   security/ipe/modules/Kconfig                  |   66 ++
>>   security/ipe/modules/Makefile                 |   12 +
>>   security/ipe/modules/boot_verified.c          |   24 +
>>   security/ipe/modules/dmverity_roothash.c      |   80 ++
>>   security/ipe/modules/dmverity_signature.c     |   25 +
>>   security/ipe/modules/fsverity_digest.c        |   80 ++
>>   security/ipe/modules/fsverity_signature.c     |   33 +
>>   security/ipe/modules/ipe_module.h             |   40 +
>>   security/ipe/parsers.c                        |  139 +++
>>   security/ipe/parsers/Makefile                 |   12 +
>>   security/ipe/parsers/default.c                |  106 ++
>>   security/ipe/parsers/policy_header.c          |  126 ++
>>   security/ipe/policy.c                         | 1037 +++++++++++++++++
>>   security/ipe/policy.h                         |  113 ++
>>   security/ipe/policy_parser_tests.c            |  299 +++++
>>   security/ipe/policyfs.c                       |  528 +++++++++
>>   security/security.c                           |   76 +-
>>   63 files changed, 7069 insertions(+), 18 deletions(-)
>>   create mode 100644 Documentation/admin-guide/LSM/ipe.rst
>>   create mode 100644 Documentation/security/ipe.rst
>>   create mode 100644 scripts/ipe/Makefile
>>   create mode 100644 scripts/ipe/polgen/.gitignore
>>   create mode 100644 scripts/ipe/polgen/Makefile
>>   create mode 100644 scripts/ipe/polgen/polgen.c
>>   create mode 100644 security/ipe/.gitignore
>>   create mode 100644 security/ipe/Kconfig
>>   create mode 100644 security/ipe/Makefile
>>   create mode 100644 security/ipe/audit.c
>>   create mode 100644 security/ipe/audit.h
>>   create mode 100644 security/ipe/ctx.c
>>   create mode 100644 security/ipe/ctx.h
>>   create mode 100644 security/ipe/ctx_test.c
>>   create mode 100644 security/ipe/eval.c
>>   create mode 100644 security/ipe/eval.h
>>   create mode 100644 security/ipe/fs.c
>>   create mode 100644 security/ipe/fs.h
>>   create mode 100644 security/ipe/hooks.c
>>   create mode 100644 security/ipe/hooks.h
>>   create mode 100644 security/ipe/ipe.c
>>   create mode 100644 security/ipe/ipe.h
>>   create mode 100644 security/ipe/ipe_parser.h
>>   create mode 100644 security/ipe/modules.c
>>   create mode 100644 security/ipe/modules.h
>>   create mode 100644 security/ipe/modules/Kconfig
>>   create mode 100644 security/ipe/modules/Makefile
>>   create mode 100644 security/ipe/modules/boot_verified.c
>>   create mode 100644 security/ipe/modules/dmverity_roothash.c
>>   create mode 100644 security/ipe/modules/dmverity_signature.c
>>   create mode 100644 security/ipe/modules/fsverity_digest.c
>>   create mode 100644 security/ipe/modules/fsverity_signature.c
>>   create mode 100644 security/ipe/modules/ipe_module.h
>>   create mode 100644 security/ipe/parsers.c
>>   create mode 100644 security/ipe/parsers/Makefile
>>   create mode 100644 security/ipe/parsers/default.c
>>   create mode 100644 security/ipe/parsers/policy_header.c
>>   create mode 100644 security/ipe/policy.c
>>   create mode 100644 security/ipe/policy.h
>>   create mode 100644 security/ipe/policy_parser_tests.c
>>   create mode 100644 security/ipe/policyfs.c
>>
>> --
>> 2.33.0
