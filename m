Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B73B42C978
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238794AbhJMTJF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:05 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49068 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhJMTIq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:46 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id C6F4820B9D0C;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C6F4820B9D0C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=dQ+u9TNfPDEJUjM64WZr/miBrXoUBKgng6ViWxPtixc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b29+pJ6FM1zVt4i4+Ggxjywi0M8X7qZH7waixVR0fsPRpL/piBDpiyAuyNzNbz4jC
         QDLyBe2h+hTdXATF3rhAnULcTDekL/bgYma24lzTqdbcoPJahAprHP5oS3HUEGlfDv
         2VEsE4KlefPAKod+1IFdVvrg5PDcI2i/MqQTFPTI=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 16/16] documentation: add ipe documentation
Date:   Wed, 13 Oct 2021 12:06:35 -0700
Message-Id: <1634151995-16266-17-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add IPE's admin and developer documentation to the kernel tree.

Co-developed-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Add additional developer-level documentation
  * Update admin-guide docs to reflect changes.
  * Drop Acked-by due to significant changes

---
 Documentation/admin-guide/LSM/index.rst       |   1 +
 Documentation/admin-guide/LSM/ipe.rst         | 587 ++++++++++++++++++
 .../admin-guide/kernel-parameters.txt         |  12 +
 Documentation/security/index.rst              |   1 +
 Documentation/security/ipe.rst                | 339 ++++++++++
 MAINTAINERS                                   |   2 +
 6 files changed, 942 insertions(+)
 create mode 100644 Documentation/admin-guide/LSM/ipe.rst
 create mode 100644 Documentation/security/ipe.rst

diff --git a/Documentation/admin-guide/LSM/index.rst b/Documentation/admin-guide/LSM/index.rst
index a6ba95fbaa9f..ce63be6d64ad 100644
--- a/Documentation/admin-guide/LSM/index.rst
+++ b/Documentation/admin-guide/LSM/index.rst
@@ -47,3 +47,4 @@ subdirectories.
    tomoyo
    Yama
    SafeSetID
+   ipe
diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-guide/LSM/ipe.rst
new file mode 100644
index 000000000000..56a9fa2fe59b
--- /dev/null
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -0,0 +1,587 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Integrity Policy Enforcement (IPE)
+==================================
+
+.. NOTE::
+
+   This is the documentation for admins, system builders, or individuals
+   attempting to use IPE, without understanding all of its internal systems.
+   If you're looking for documentation to extend IPE, understand the design
+   decisions behind IPE, or are just curious about the internals, please
+   see :ref:`Documentation/security/ipe.rst`
+
+Overview
+--------
+
+IPE is a Linux Security Module which imposes a complimentary model
+of mandatory access control to other LSMs. Whereas the existing LSMs
+impose access control based on labels or paths, IPE imposes access
+control based on the trust of the resource. Simply put, IPE
+or restricts access to a resource based on the trust of said resource.
+
+Trust requirements are established via IPE's policy, sourcing multiple
+different implementations within the kernel to build a cohesive trust
+model, based on how the system was built.
+
+Trust vs Integrity
+------------------
+
+Trust, with respect to computing, is a concept that designates a set
+of entities who will endorse a set of resources as non-malicious.
+Traditionally, this is done via signatures, which is the act of endorsing
+a resource. Integrity, on the other hand, is the concept of ensuring that a
+resource has not been modified since a point of time. This is typically done
+through cryptography or signatures.
+
+Trust and integrity are very closely tied together concepts, as integrity
+is the way you can prove trust for a resource; otherwise it could have
+been modified by an entity who is untrusted.
+
+IPE provides a way for a user to express trust of resources, by using
+pre-existing systems which provide the integrity half of the equation.
+
+Use Cases
+---------
+
+IPE works best in fixed-function devices: Devices in which their purpose
+is clearly defined and not supposed to be changed (e.g. network firewall
+device in a data center, an IoT device, etcetera), where all software and
+configuration is built and provisioned by the system owner.
+
+IPE is a long-way off for use in general-purpose computing:
+the Linux community as a whole tends to follow a decentralized trust
+model, known as the Web of Trust, which IPE has no support for as of yet.
+Instead, IPE supports the PKI Trust Model, which generally designates a
+set of entities that provide a measure absolute trust.
+
+Additionally, while most packages are signed today, the files inside
+the packages (for instance, the executables), tend to be unsigned. This
+makes it difficult to utilize IPE in systems where a package manager is
+expected to be functional, without major changes to the package manager
+and ecosystem behind it.
+
+For the highest level of security, platform firmware should verify the
+the kernel and optionally the root filesystem (for example, via U-Boot
+verified boot). This forms a chain of trust from the hardware, ensuring
+that every stage of the system is trusted.
+
+Known Gaps
+----------
+
+IPE cannot verify the integrity of anonymous executable memory, such as
+the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
+Unfortunately, as this is dynamically generated code, there is no way
+for IPE to ensure the integrity of this code to form a trust basis. In all
+cases, the return result for these operations will be whatever the admin
+configures the DEFAULT action for "EXECUTE".
+
+IPE cannot verify the integrity of interpreted languages' programs when
+these scripts invoked via ``<interpreter> <file>``. This is because the
+way interpreters execute these files, the scripts themselves are not
+evaluated as executable code through one of IPE's hooks. Interpreters
+can be enlightened to the usage of IPE by trying to mmap a file into
+executable memory (+X), after opening the file and responding to the
+error code appropriately. This also applies to included files, or high
+value files, such as configuration files of critical system components [#]_.
+
+.. [#] Mickaël Salaün's `trusted_for patchset <https://lore.kernel.org/all/20211008104840.1733385-1-mic@digikod.net/>`_
+   can be used to leverage this.
+
+Threat Model
+------------
+
+The threat type addressed by IPE is tampering of executable user-land
+code beyond the initially booted kernel, and the initial verification of
+kernel modules that are loaded in userland through ``modprobe`` or
+``insmod``.
+
+Tampering violates integrity, and being unable to verify the integrity,
+results in a lack of trust. IPE's role in mitigating this threat is to
+verify the integrity (and authenticity) of all executable code and to
+deny their use if they cannot be trusted (as integrity verification fails).
+IPE generates audit logs which may be utilized to detect failures resulting
+from failure to pass policy.
+
+Tampering threat scenarios include modification or replacement of
+executable code by a range of actors including:
+
+-  Actors with physical access to the hardware
+-  Actors with local network access to the system
+-  Actors with access to the deployment system
+-  Compromised internal systems under external control
+-  Malicious end users of the system
+-  Compromised end users of the system
+-  Remote (external) compromise of the system
+
+IPE does not mitigate threats arising from malicious authorized
+developers, or compromised developer tools used by authorized
+developers. Additionally, IPE draws hard security boundary between user
+mode and kernel mode. As a result, IPE does not provide any protections
+against a kernel level exploit, and a kernel-level exploit can disable
+or tamper with IPE's protections.
+
+Policy
+------
+
+IPE policy is a plain-text [#]_ policy composed of multiple statements
+over several lines. There is one required line, at the top of the
+policy, indicating the policy name, and the policy version, for
+instance::
+
+   policy_name="Ex Policy" policy_version=0.0.0
+
+The policy name is a unique key identifying this policy in a human
+readable name. This is used to create nodes under securityfs as well as
+uniquely identify policies to deploy new policies vs update existing
+policies.
+
+The policy version indicates the current version of the policy (NOT the
+policy syntax version). This is used to prevent rollback of policy to
+potentially insecure previous versions of the policy.
+
+The next portion of IPE policy, are rules. Rules are formed by key=value
+pairs, known as properties. IPE rules require two properties: "action",
+which determines what IPE does when it encounters a match against the
+rule, and "op", which determines when that rule should be evaluated.
+The ordering is significant, a rule must start with "op", and end with
+"action". Thus, a minimal rule is::
+
+   op=EXECUTE action=ALLOW
+
+This example will allow any execution. Additional properties are used to
+restrict attributes about the files being evaluated. These properties
+are intended to be descriptions of systems within the kernel, that can
+provide a measure of integrity verification, such that IPE can determine
+the trust of the resource based on the "value" half of the property.
+
+Rules are evaluated top-to-bottom. As a result, any revocation rules,
+or denies should be placed early in the file to ensure that these rules
+are evaluated before as rule with "action=ALLOW" is hit.
+
+IPE policy is designed to be only forward compatible. Userspace can read
+what the parser's current configuration (supported statements, properties,
+etcetera) via reading the securityfs entry, 'ipe/config'
+
+IPE policy supports comments. The character '#' will function as a
+comment, ignoring all characters to the right of '#' until the newline.
+
+The default behavior of IPE evaluations can also be expressed in policy,
+through the ``DEFAULT`` statement. This can be done at a global level,
+or a per-operation level::
+
+   # Global
+   DEFAULT action=ALLOW
+
+   # Operation Specific
+   DEFAULT op=EXECUTE action=ALLOW
+
+A default must be set for all known operations in IPE. If you want to
+preserve older policies being compatible with newer kernels that can introduce
+new operations, please set a global default of 'ALLOW', and override the
+defaults on a per-operation basis.
+
+With configurable policy-based LSMs, there's several issues with
+enforcing the configurable policies at startup, around reading and
+parsing the policy:
+
+1. The kernel *should* not read files from userland, so directly reading
+   the policy file is prohibited.
+2. The kernel command line has a character limit, and one kernel module
+   should not reserve the entire character limit for its own
+   configuration.
+3. There are various boot loaders in the kernel ecosystem, so handing
+   off a memory block would be costly to maintain.
+
+As a result, IPE has addressed this problem through a concept of a "boot
+policy". A boot policy is a minimal policy, compiled into the kernel.
+This policy is intended to get the system to a state where userland is
+setup and ready to receive commands, at which point a more complex
+policy ("user policies") can be deployed via securityfs. The boot policy
+can be specified via the Kconfig, ``SECURITY_IPE_BOOT_POLICY``, which
+accepts a path to a plain-text version of the IPE policy to apply. This
+policy will be compiled into the kernel. If not specified, IPE will be
+disabled until a policy is deployed and activated through securityfs.
+
+.. [#] Please see the :ref:`Documentation/security/ipe.rst` for more on this
+   topic.
+
+Deploying Policies
+~~~~~~~~~~~~~~~~~~
+
+User policies as explained above, are policies that are deployed from
+userland, through securityfs. These policies are signed to enforce some
+level of authorization of the policies (prohibiting an attacker from
+gaining root, and deploying an "allow all" policy), through the PKCS#7
+enveloped data format. These policies must be signed by a certificate
+that chains to the ``SYSTEM_TRUSTED_KEYRING``. Through openssl, the
+signing can be done via::
+
+   openssl smime -sign -in "$MY_POLICY" -signer "$MY_CERTIFICATE" \
+     -inkey "$MY_PRIVATE_KEY" -binary -outform der -noattr -nodetach \
+     -out "$MY_POLICY.p7s"
+
+Deploying the policies is done through securityfs, through the
+``new_policy`` node. To deploy a policy, simply cat the file into the
+securityfs node::
+
+   cat "$MY_POLICY.p7s" > /sys/kernel/security/ipe/new_policy
+
+Upon success, this will create one subdirectory under
+``/sys/kernel/security/ipe/policies/``. The subdirectory will be the
+``policy_name`` field of the policy deployed, so for the example above,
+the directory will be ``/sys/kernel/security/ipe/policies/Ex\ Policy``.
+Within this directory, there will be five files: ``pkcs7``, ``policy``,
+``active``, ``update``, and ``delete``.
+
+The ``pkcs7`` file is rw, reading will provide the raw PKCS#7 data that
+was provided to the kernel, representing the policy. Writing, will
+deploy an in-place policy update - if this policy is the currently
+running policy, the new updated policy will replace it immediately upon
+success. If the policy being read is the boot policy, when read, this
+will return ENOENT.
+
+The ``policy`` file is read only. Reading will provide the PKCS#7 inner
+content of the policy, which will be the plain text policy.
+
+The ``active`` file is used to set a policy as the currently active policy.
+This file is rw, and accepts a value of ``"1"`` to set the policy as active.
+Since only a single policy can be active at one time, all other policies
+will be marked inactive. The policy being marked active must have a policy
+version greater or equal to the currently-running version.
+
+The ``update`` file is used to update a policy that is already present in
+the kernel. This file is write-only and accepts a PKCS#7 signed policy.
+One check will be performed on this policy: the policy_names must match
+with the updated version and the existing version. If the policy being
+updated is the active policy, the updated policy must have a policy version
+greater or equal to the currently-running version.
+
+The ``delete`` file is used to remove a policy that is no longer needed.
+This file is write-only and accepts a value of ``"1"`` to delete the policy.
+On deletion, the securityfs node representing the policy will be removed.
+The policy that is currently active, cannot be deleted.
+
+Similarly, the writes to both ``update`` and ``new_policy`` above will
+result in an error upon syntactically invalid or untrusted policies.
+It will also error if a policy already exists with the same ``policy_name``,
+in the case of ``new_policy``.
+
+Deploying these policies will *not* cause IPE to start enforcing this
+policy. Once deployment is successful, a policy can be marked as active,
+via ``/sys/kernel/security/ipe/$policy_name/active``. IPE will enforce
+whatever policy is marked as active. For our example, we can activate
+the ``Ex Policy`` via::
+
+   echo "1" > "/sys/kernel/security/ipe/Ex Policy/active"
+
+At which point, ``Ex Policy`` will now be the enforced policy on the
+system.
+
+IPE also provides a way to delete policies. This can be done via the
+``delete`` securityfs node, ``/sys/kernel/security/ipe/$policy_name/delete``.
+Writing ``1`` to that file will delete that node::
+
+   echo "1" > "/sys/kernel/security/ipe/$policy_name/delete"
+
+There is only one requirement to delete a policy:
+
+1. The policy being deleted must not be the active policy.
+
+.. NOTE::
+
+   If a traditional MAC system is enabled (SELinux, apparmor, smack), all
+   writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
+
+Modes
+~~~~~
+
+IPE supports two modes of operation: permissive (similar to SELinux's
+permissive mode) and enforce. Permissive mode performs the same checks
+as enforce mode, and logs policy violations, but will not enforce the
+policy. This allows users to test policies before enforcing them.
+
+The default mode is enforce, and can be changed via the kernel command
+line parameter ``ipe.enforce=(0|1)``, or the securityfs node
+``/sys/kernel/security/ipe/enforce``.
+
+.. NOTE::
+
+   If a traditional MAC system is enabled (SELinux, apparmor, smack, etcetera),
+   all writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
+
+Audit Events
+~~~~~~~~~~~~
+
+Success Auditing
+^^^^^^^^^^^^^^^^
+
+IPE supports success auditing. When enabled, all events that pass IPE
+policy and are not blocked will emit an audit event. This is disabled by
+default, and can be enabled via the kernel command line
+``ipe.success_audit=(0|1)`` or the securityfs node,
+``/sys/kernel/security/ipe/success_audit``.
+
+This is very noisy, as IPE will check every user-mode binary on the
+system, but is useful for debugging policies.
+
+.. NOTE::
+
+   If a traditional MAC system is enabled (SELinux, apparmor, smack, etcetera),
+   all writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
+
+Properties
+--------------
+
+As explained above, IPE properties are ``key=value`` pairs expressed in
+IPE policy. Two properties are built-into the policy parser: 'op' and
+'action'. The other properties are determinstic attributes to express
+across files. Currently those properties are: 'boot_verified',
+'dmverity_signature', 'dmverity_roothash', 'fsverity_signature',
+'fsverity_digest'. A description of all properties supported by IPE
+are listed below:
+
+op
+~~
+
+Indicates the operation for a rule to apply to. Must be in every rule,
+as the first token. IPE supports the following operations:
+
+Version 1
+^^^^^^^^^
+
+``EXECUTE``
+
+   Pertains to any file attempting to be executed, or loaded as an
+   executable.
+
+``FIRMWARE``:
+
+   Pertains to firmware being loaded via the firmware_class interface.
+   This covers both the preallocated buffer and the firmware file
+   itself.
+
+``KMODULE``:
+
+   Pertains to loading kernel modules via ``modprobe`` or ``insmod``.
+
+``KEXEC_IMAGE``:
+
+   Pertains to kernel images loading via ``kexec``.
+
+``KEXEC_INITRAMFS``
+
+   Pertains to initrd images loading via ``kexec --initrd``.
+
+``POLICY``:
+
+   Controls loading IMA policies through the
+   ``/sys/kernel/security/ima/policy`` securityfs entry.
+
+``X509_CERT``:
+
+   Controls loading IMA certificates through the Kconfigs,
+   ``CONFIG_IMA_X509_PATH`` and ``CONFIG_EVM_X509_PATH``.
+
+``KERNEL_READ``:
+
+   Short hand for all of the following: ``FIRMWARE``, ``KMODULE``,
+   ``KEXEC_IMAGE``, ``KEXEC_INITRAMFS``, ``POLICY``, and ``X509_CERT``.
+
+action
+~~~~~~
+
+Version 1
+^^^^^^^^^
+
+Determines what IPE should do when a rule matches. Must be in every
+rule, as the final clause. Can be one of:
+
+``ALLOW``:
+
+   If the rule matches, explicitly allow access to the resource to proceed
+   without executing any more rules.
+
+``DENY``:
+
+   If the rule matches, explicitly prohibit access to the resource to
+   proceed without executing any more rules.
+
+boot_verified
+~~~~~~~~~~~~~
+
+Version 1
+^^^^^^^^^
+
+This property can be utilized for authorization of the first super-block
+that executes a file. This is almost always init. Typically this is used
+for systems with an initramfs or other initial disk, where this is unmounted
+before the system becomes available, and is not covered by any other property.
+This property is controlled by the Kconfig, ``CONFIG_IPE_PROP_BOOT_VERIFIED``.
+The format of this property is::
+
+       boot_verified=(TRUE|FALSE)
+
+
+.. WARNING::
+
+  This property will trust any disk where the first execution evaluation
+  occurs. If you do *NOT* have a startup disk that is unpacked and unmounted
+  (like initramfs), then it will automatically trust the root filesystem and
+  potentially overauthorize the entire disk.
+
+dmverity_roothash
+~~~~~~~~~~~~~~~~~
+
+Version 1
+^^^^^^^^^
+
+This property can be utilized for authorization or revocation of
+specific dm-verity volumes, identified via root hash. It has a
+dependency on the DM_VERITY module. This property is controlled by the
+Kconfig ``CONFIG_IPE_PROP_DM_VERITY_ROOTHASH``. The format of this property
+is::
+
+   dmverity_roothash=HashHexDigest
+
+dmverity_signature
+~~~~~~~~~~~~~~~~~~
+
+Version 1
+^^^^^^^^^
+
+This property can be utilized for authorization of all dm-verity volumes
+that have a signed roothash that chains to a keyring specified by dm-verity's
+configuration, either the system trusted keyring, or the secondary keyring.
+It has an additional dependency on the ``DM_VERITY_VERIFY_ROOTHASH_SIG``
+Kconfig. This property is controlled by the Kconfig
+``CONFIG_IPE_PROP_DM_VERITY_SIGNATURE``. The format of this property is::
+
+   dmverity_signature=(TRUE|FALSE)
+
+fsverity_digest
+~~~~~~~~~~~~~~~
+
+Version 1
+^^^^^^^^^
+This property can be utilized for authorization or revocation of
+specific fsverity enabled file, identified via its fsverity digest,
+which is the hash of a struct contains the file's roothash and hashing
+parameters. It has a dependency on the FS_VERITY module.
+This property is controlled by the Kconfig
+``CONFIG_IPE_PROP_FS_VERITY_DIGEST``. The format of this property is::
+
+   fsverity_digest=HashHexDigest
+
+fsverity_signature
+~~~~~~~~~~~~~~~~~~
+
+Version 1
+^^^^^^^^^
+
+This property can be utilized for authorization of all fsverity enabled
+files that is verified by fsverity. The keyring that is verifies against
+is subject to fsverity's configuration, which is typically the fsverity
+keyring. It has a dependency on the ``CONFIG_FS_VERITY_BUILTIN_SIGNATURES``
+Kconfig. This property is controlled by the Kconfig
+``CONFIG_IPE_PROP_FS_VERITY_SIGNATURE``. The format of this property is::
+
+   fsverity_signature=(TRUE|FALSE)
+
+Policy Examples
+---------------
+
+Allow all
+~~~~~~~~~
+
+::
+
+   policy_name="Allow All" policy_version=0.0.0
+   DEFAULT action=ALLOW
+
+Allow only initial superblock
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="Allow All Initial SB" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+
+Allow any signed dm-verity volume and the initial superblock
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="AllowSignedAndInitial" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+   op=EXECUTE dmverity_signature=TRUE action=ALLOW
+
+Prohibit execution from a specific dm-verity volume
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="AllowSignedAndInitial" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec146938 action=DENY
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+   op=EXECUTE dmverity_signature=TRUE action=ALLOW
+
+Allow only a specific dm-verity volume
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="AllowSignedAndInitial" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE dmverity_roothash=401fcec5944823ae12f62726e8184407a5fa9599783f030dec146938 action=ALLOW
+
+Allow any signed fs-verity file
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="AllowSignedFSVerity" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE fsverity_signature=TRUE action=ALLOW
+
+Prohibit execution of a specific fs-verity file
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name="ProhibitSpecificFSVF" policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE fsverity_digest=fd88f2b8824e197f850bf4c5109bea5cf0ee38104f710843bb72da796ba5af9e action=DENY
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+   op=EXECUTE dmverity_signature=TRUE action=ALLOW
+
+Additional Information
+----------------------
+
+- `Github Repository <https://github.com/microsoft/ipe>`_
+- `Design Documentation </security/ipe>`_
+
+FAQ
+---
+
+:Q: What's the difference between other LSMs which provide trust-based
+   access control, for instance, IMA?
+
+:A: IMA is a fantastic option when needing measurement in addition to the
+   trust-based access model. All of IMA is centered around their measurement
+   hashes, so you save time when doing both actions. IPE, on the other hand,
+   is a highly performant system that does not rely (and explicitly prohibits),
+   generating its own integrity mechanisms - separating measurement and access
+   control. Simply put, IPE provides only the enforcement of trust, while other
+   subsystems provide the integrity guarantee that IPE needs to determine the
+   trust of a resource. IMA provides both the integrity guarantee, and the
+   enforcement of trust.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 43dc35fe5bc0..85dd654e642f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2096,6 +2096,18 @@
 	ipcmni_extend	[KNL] Extend the maximum number of unique System V
 			IPC identifiers from 32,768 to 16,777,216.
 
+	ipe.enforce=	[IPE]
+			Format: <bool>
+			Determine whether IPE starts in permissive (0) or
+			enforce (1) mode. The default is enforce.
+
+	ipe.success_audit=
+			[IPE]
+			Format: <bool>
+			Start IPE with success auditing enabled, emitting
+			an audit event when a binary is allowed. The default
+			is 0.
+
 	irqaffinity=	[SMP] Set the default irq affinity mask
 			The argument is a cpu list, as described above.
 
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
index 16335de04e8c..c06530b50514 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -17,3 +17,4 @@ Security Documentation
    tpm/index
    digsig
    landlock
+   ipe
diff --git a/Documentation/security/ipe.rst b/Documentation/security/ipe.rst
new file mode 100644
index 000000000000..e691e08e0303
--- /dev/null
+++ b/Documentation/security/ipe.rst
@@ -0,0 +1,339 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Integrity Policy Enforcement (IPE) - Design Documents
+=====================================================
+
+.. NOTE::
+
+   This is the documentation for kernel developers and other individuals
+   who want to understand the reason behind why IPE is designed the way it
+   is, as well as a tour of the implementation. If you're looking for
+   documentation on the usage of IPE, please see
+   :ref:`Documentation/admin-guide/LSM/ipe.rst`
+
+Role and Scope
+--------------
+
+IPE originally started with a simple goal: create a system that can
+ensure that only trusted usermode binaries are allowed to be executed.
+
+During the design phase it was apparent that there are multiple systems
+within the Linux kernel that can provide some level of integrity
+verification, and by association, trust for its content:
+
+  1. DM-Verity
+  2. FS-Verity
+  3. IMA + EVM
+
+However, of those systems only the third option has the ability to enforce
+trust requirements on the whole system. Its architecture, however is centered
+around its own form of verifications, and a multitude of actions surrounding
+those verifications with various purposes, the most prominent being measurement
+and verification (appraisal). This makes it unsuitable from a layering and
+architectural purpose, as IPE's goal is limited to ensure just trusted usermode
+binaries are executed, with the intentional goal of supporting multiple methods
+from a higher subsystem layer (i.e. fs, block, or super_block).
+
+The two other options, dm-verity and fs-verity are missing a crucial component
+to accomplish the goal of IPE: a policy to indicate the requirements of
+answering the question "What is Trusted?" and a system-wide level of enforcing
+those requirements.
+
+Therefore, IPE was designed around:
+
+  1. Easy configuration of trust mechanisms
+  2. Ease of integration with other layers
+  3. Ease of use for platform administrators.
+
+Design Decisions
+----------------
+
+Policy
+~~~~~~
+
+Plain Text
+^^^^^^^^^^
+
+Unlike other LSMs, IPE's policy is plain-text. This introduces slightly larger
+policy files than other LSMs, but solves two major problems that occurs with
+other trust-based access control systems.
+
+The first issue is one of code maintenance and duplication. To author policies,
+the policy has to be some form of string representation (be it structured,
+through XMl, JSON, YAML, etcetera), to allow the policy author to understand
+what is being written. In a hypothetical binary policy design, that a serializer
+must be written to write said binary form, for a *majority* of humans to be
+able to utilize it properly.
+
+Additionally, a deserializer will eventually be needed to transform the binary
+back into text with as much information preserved. Without a deserializer, a
+user of this access control system will have to keep a lookup table of either
+a checksum, or the file itself to try to understand what policies have been
+deployed on this system and what policies have not. For a single user, this
+may be alright, as old policies can be discarded almost immediately after
+the update takes hold.
+
+For users that manage fleets in the thousands, if not hundreds of thousands,
+this quickly becomes an issue, as stale policies from years ago may be present,
+quickly resulting in the need to recover the policy or fund extensive
+infrastructure to track what each policy contains.
+
+Secondly, a serializer is still needed with a plain-text policy (as the plain
+text policy still has to be serialized to a data structure in the kernel), so
+not much is saved.
+
+The second issue is one of transparency. As IPE controls access based on trust,
+it's policy must also be trusted to be changed. This is done through signatures,
+chaining to the SYSTEM_TRUSTED_KEYRING. The confidence of signing a plain-text
+policy in which you can see every aspect of what is being signed is a step higher
+than signing an opaque binary blob.
+
+Boot Policy
+~~~~~~~~~~~
+
+Additionally, IPE shouldn't have any obvious gaps in its enforcement story.
+That means, a policy that configures trust requirements, if specified, must
+be enforced as soon as the kernel starts up. That can be accomplished one
+of three ways:
+
+  1. The policy file(s) live on disk and the kernel loads the policy prior
+     to an code path that would result in an enforcement decision.
+  2. The policy file(s) are passed by the bootloader to the kernel, who
+     parses the policy.
+  3. There is a policy file that is compiled into the kernel that is
+     parsed and enforced on initialization.
+
+The first option has problems: the kernel reading files from userspace
+is typically discouraged and very uncommon in the kernel.
+
+The second option also has problems: Linux supports a variety of bootloaders
+across its entire ecosystem - every bootloader would have to support this
+new methodology or there must be an independent source. Additionally, it
+would likely result in more drastic changes to the kernel startup than
+necessary.
+
+The third option is the best but it's important to be aware that the policy
+will take disk space against the kernel it's compiled in. It's important to
+keep this policy generalized enough that userspace can load a new, more
+complicated policy, but restrictive enough that it will not overauthorize
+and cause security issues.
+
+The initramfs, provides a way that this bootup path can be established. The
+kernel starts with a minimal policy, that just trusts the initramfs. Inside
+the initramfs, when the real rootfs is mounted, but not yet transferred to,
+it deploys and activates a policy that trusts the new root filesystem(s).
+This prevents overauthorization at any step, and keeps the kernel policy
+to a minimal size.
+
+Startup
+^^^^^^^
+
+Not every system, however starts with an initramfs, so the startup policy
+compiled into the kernel will need some flexibility to express how trust
+is established for the next phase of the bootup. To this end, if we just
+make the compiled-in policy a full IPE policy, it allows system builders
+to express the first stage bootup requirements appropriately.
+
+Updatable, Rebootless Policy
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+As time goes on, trust requirements are changed (vulnerabilities are found in
+previously trusted applcations, keys roll, etcetera). Updating a kernel to
+change the trust requirements is not always a suitable option, as updates
+are not always risk-free and without consequence. This means IPE requires
+a policy that can be completely updated from a source external to the kernel.
+
+Additionally, since the kernel is relatively stateless between invocations,
+and we've established that reading policy files off the disk from kernel
+space is a *bad idea*, then the policy updates have to be done rebootlessly.
+
+To allow an update from an external source, it could be potentially malicious,
+so this policy needs to have a way to be identified as trusted. This will be
+done via a signature, chained to a trust source in the kernel. Arbitrarily,
+this will be the ``SYSTEM_TRUSTED_KEYRING``, a keyring that is initially
+populated at kernel compile-time, as this matches the expectation that the
+author of the compiled-in policy described above is the same entity that can
+deploy policy updates.
+
+Anti-Rollback / Anti-Replay
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Over time, vulnerabilities are found and trusted resources may not be
+trusted anymore. IPE's policy has no exception to this. There can be
+instances where a mistaken policy author deploys an insecure policy,
+before correcting it with a secure policy.
+
+Assuming that as soon as the insecure policy was signed, an attacker
+can acquire the insecure policy, IPE needs a way to prevent rollback
+from the secure policy update, to the insecure policy update.
+
+Initially, IPE's policy can have a policy_version that states the
+minimum required version across all policies that can be active on
+the system. This will prevent rollback while the system is live.
+
+.. WARNING::
+
+  However, since the kernel is stateless across boots, this policy
+  version will be reset to 0.0.0 on the next boot. System builders
+  need to be aware of this, and ensure the new secure policies are
+  deployed ASAP after a boot to ensure that the window of
+  opportunity is minimal for an attacker to deploy the insecure policy[#]_.
+
+Implementation
+--------------
+
+Context
+~~~~~~~
+
+An ``ipe_context`` structure represent a context in which IPE can be enforced.
+It contains all the typical values that one would expect are global:
+
+  1. Enforce/Permissive State
+  2. Active Policy
+  3. List of Policies
+  4. Success Auditing State
+
+A context is created at boot time and attached to the ``task_struct`` as a
+security blob. All new ``task_struct`` will inherit the original ``ipe_context``
+that the system boots with. This structure is reference counted.
+
+Initially, a system will only ever have one context; for ``init``, and since
+all userspace processes are descendents of ``init``, all of usermode will have
+this execution context.
+
+This architecture has some advantages - namely, it allows for a natural
+extension for IPE to create new contexts - such as applying a different
+policy for trust for a privledged container from that of its host.
+
+Anonymous Memory
+~~~~~~~~~~~~~~~~
+
+Anonymous memory isn't treated any differently than any other access in IPE.
+When anonymous memory is mapped with ``+X``, it still comes into the ``file_mmap``
+hook, but with a ``NULL`` file object. This is submitted to the evaluation, like
+any other file, however, all trust mechanisms will return false as there is
+nothing to evaluate. This means anonymous memory execution is subject to
+whatever the ``DEFAULT`` is for ``EXECUTE``.
+
+.. WARNING::
+
+  This also occurs with the ``kernel_load_data`` hook, which is used by signed
+  and compressed kernel modules. Using this with IPE will result in the
+  ``DEFAULT`` for ``KMODULE`` being taken.
+
+Policy Parser
+~~~~~~~~~~~~~
+
+The policy parser is the staple of IPE's functionality, providing a
+modular way to introduce new integrations. As such, it's functionality
+is divided into 4 passes. This gives the benefit of clearly defined pre
+and post-condition states after each pass, giving debugging benefits
+when something goes wrong.
+
+In pass1, the policy is transformed into a 2D, jagged, array of tokens,
+where a token is defined as a "key=value" pair, or a singular token,
+for example, "DEFAULT". Quoted values are parsed as a single value-pair,
+which is why ``<linux/parser.h>`` parser is insufficient - it does not
+understand quoted values.
+
+In pass2, the jagged array produced in pass1 is partially ingested,
+creating a partially populated policy, where no rules have been parsed
+yet, but metadata and references are created that can be now used in
+pass3.
+
+Examples of parsing that would be done in pass2::
+
+  policy_name="my-policy" policy_version=0.0.0
+  DEFAULT action=DENY
+
+As these lines are not rules in of themselves, but effect the policy
+itself.
+
+In pass3, the remaining lines in the jagged array produced in pass1 and
+partially-consumed in pass2 is consumed completely, parsing all the
+rules in IPE policy. This can leverage the data used in pass2.
+Example lines parsed in pass3::
+
+  op=EXECUTE dmverity_signature=TRUE action=DENY
+
+A rule is strictly defined as starts with the op token and ends with
+the action token.
+
+After this pass, a policy is deemed fully constructed but not yet valid,
+as there could be missing elements (such as a required DEFAULT for all
+actions, missing a policy_name), etc.
+
+Additionally, as IPE policy supports operation aliases (an operation
+that maps to two or more other operations), support is added here.
+
+The purpose in the division of pass2 and pass3 is to allow for
+declarations in IPE's syntax. For example, in the future, if we were
+to introduce this syntax::
+
+  CERTIFICATE=FakeCert thumbprint=DEADBEEF CN="Contoso"
+
+And use it like so::
+
+  op=EXECUTE dmverity_signature=FakeCert action=ALLOW
+
+The ``CERTIFICATE`` lines can be grouped together at any place in the policy.
+
+After pass3, an IPE policy can still be technically invalid for use, as
+a policy can be lacking required elements to eliminated the possibility
+of undefined or unknown behavior.
+
+A concrete example is when a policy does not define a default action for
+all possibilities::
+
+  DEFAULT op=EXECUTE action=ALLOW
+
+At this point, while a technically syntactically and semantically valid
+policy, it does not contain enough information to determine what should
+be done for an operation other than "EXECUTE". As IPE's design
+explicitly prohibits the implicit setting of a DEFAULT, it is important
+for cases like these are prevented from occurring.
+
+To resolve all these cases, a final check on the policy is done to ensure
+it valid for use.
+
+In all cases, the parser is the number one bottleneck when it comes to
+IPE's performance, but has the benefit of happening rarely, and as a
+direct consequence of user-input.
+
+Module vs Parser
+~~~~~~~~~~~~~~~~
+
+A "module", "trust provider", or "property" as defined in IPE's code and
+commits is an integration with an external subsystem that provides a way
+to identify a resource as trusted. It's the code that powers the key=value
+pairs in between the ``op`` token and the ``action`` token. These are called
+in pass3 when parsing a policy (via the ``parse`` method), and during
+evaluation when evaluating a access attempt (via the ``eval`` method). These
+discrete modules are single files in ``security/ipe/modules`` and are
+versioned independently. The documentation in the admin guide and be used
+to cross reference what version supports what syntax.
+
+A "parser", on the other hand is a discrete unit of code that is *only*
+used when parsing a policy in pass2. The intention is to make it easy
+to introduce statements, like the ``DEFAULT`` statement::
+
+  DEFAULT op=EXECUTE action=ALLOW
+  DEFAULT action=ALLOW
+
+or, the policy header::
+
+  policy_name="MyPolicy" policy_version=0.0.0
+
+These individual fragments of code, as such, gain access to manipulating
+IPE's policy structure directly, as opposed to the opaque ``void *`` that
+modules get.
+
+.. [#] This is something we're interested in solving, using some
+       persistent storage
+
+Tests
+~~~~~
+
+IPE initially has KUnit Tests, testing primarily the parser and the context
+structures. A majority of these are table-based testing, please contribute
+to them, especially when adding new properties.
diff --git a/MAINTAINERS b/MAINTAINERS
index a84ca781199b..909db5ba6f87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9283,6 +9283,8 @@ INTEGRITY POLICY ENFORCEMENT (IPE)
 M:	Deven Bowers <deven.desai@linux.microsoft.com>
 M:	Fan Wu <wufan@linux.microsoft.com>
 S:	Supported
+F:	Documentation/admin-guide/LSM/ipe.rst
+F:	Documentation/security/ipe.rst
 F:	scripts/ipe/
 F:	security/ipe/
 
-- 
2.33.0

