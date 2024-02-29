Return-Path: <linux-fscrypt+bounces-204-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9EE86BD8A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 01:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55FD7B255CF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 00:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497743DBB7;
	Thu, 29 Feb 2024 00:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ak914OGs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E365F38382;
	Thu, 29 Feb 2024 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168132; cv=none; b=Mc+0hK0yqKK+WiTRUVsdH2zj9NTgyjmLI3Ncaqrw+nvhxFUXF7C197JZwRd5NtYH27ExYUjZUtvT6oY+PeEHRRycnTgs0EHAKP0RduwgQREa8qSDWOpGLrJkz/fiGnKDI8bse0AYMt00pdRttIllznbwbLYcm+GUo7P97KZ8Fcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168132; c=relaxed/simple;
	bh=Fdn8TuisCUMQhpe9Axj2LkgxBbRsPxa7LGeHTt87okI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Hf9StNuxsvoYZqxTRyGc/BjqhIYydtsCPZwLeQOXREVledG/3Tmawrh5lVFeNnPjVfo630dpA2+HmAI73o73h9nsXzEswP7aMABLjY43vsZhFoA6/Cey1J9iZLuypoao4SVKtUmHmyBLnl2XEOJ1q/9bIGx8K0SXjGoWjb5msZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ak914OGs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 8646A20B57B4; Wed, 28 Feb 2024 16:55:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8646A20B57B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709168119;
	bh=pm9pX2HXykDk2FI9eug2xnP3WfWUJaBZItI3ndComf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ak914OGs2kYBBT4gyRL+S919Is/hSdneqJStNu+Mxxo1gsYop8uqawgDj3U/epvcW
	 krmMMIBis/zzwJCY5Fx5OEfkABS61q0u4AMC97BTKXHpMnegUHQ2/1gBpc6XJk5CSZ
	 ejGCl/E76dOjroIgkWnVZaH1KZifXz8hFlKD0VAM=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v13 20/20] documentation: add ipe documentation
Date: Wed, 28 Feb 2024 16:55:02 -0800
Message-Id: <1709168102-7677-21-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add IPE's admin and developer documentation to the kernel tree.

Co-developed-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + Add Acked-by
  + Fixup code block syntax
  + Fix a minor grammatical issue.

v4:
  + Update documentation with the results of other
    code changes.

v5:
  + No changes

v6:
  + No changes

v7:
  + Add additional developer-level documentation
  + Update admin-guide docs to reflect changes.
  + Drop Acked-by due to significant changes
  + Added section about audit events in admin-guide

v8:
  + Correct terminology from "audit event" to "audit record"
  + Add associated documentation with the correct "audit event"
    terminology.
  + Add some context to the historical motivation for IPE and design
    philosophy.
  + Add some content about the securityfs layout in the policies
    directory.
  + Various spelling and grammatical corrections.

v9:
  + Correct spelling of "pitfalls"
  + Update the docs w.r.t the new parser and new audit formats

v10:
  + Refine user docs per upstream suggestions
  + Update audit events part

v11:
  + No changes

v12:
  + Update audit formats
  + Update initramfs related docs
  + Add test suite link

v13:
  + No changes
---
 Documentation/admin-guide/LSM/index.rst       |   1 +
 Documentation/admin-guide/LSM/ipe.rst         | 761 ++++++++++++++++++
 .../admin-guide/kernel-parameters.txt         |  12 +
 Documentation/security/index.rst              |   1 +
 Documentation/security/ipe.rst                | 444 ++++++++++
 MAINTAINERS                                   |   2 +
 6 files changed, 1221 insertions(+)
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
index 000000000000..54c90f1fc654
--- /dev/null
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -0,0 +1,761 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Integrity Policy Enforcement (IPE)
+==================================
+
+.. NOTE::
+
+   This is the documentation for admins, system builders, or individuals
+   attempting to use IPE. If you're looking for more developer-focused
+   documentation about IPE please see `Documentation/security/ipe.rst`
+
+Overview
+--------
+
+IPE is a Linux Security Module which takes a complimentary approach to
+access control. Whereas existing mandatory access control mechanisms
+base their decisions on labels and paths, IPE instead determines
+whether or not an operation should be allowed based on immutable
+security properties of the system component the operation is being
+performed on.
+
+IPE itself does not mandate how the security property should be
+evaluated, but relies on an extensible set of external property providers
+to evaluate the component. IPE makes its decision based on reference
+values for the selected properties, specified in the IPE policy.
+
+The reference values represent the value that the policy writer and the
+local system administrator (based on the policy signature) trust for the
+system to accomplish the desired tasks.
+
+One such provider is for example dm-verity, which is able to represent
+the integrity property of a partition (its immutable state) with a digest.
+
+To enable IPE, ensure that ``CONFIG_SECURITY_IPE`` (under
+:menuselection:`Security -> Integrity Policy Enforcement (IPE)`) config
+option is enabled.
+
+Use Cases
+---------
+
+IPE works best in fixed-function devices: devices in which their purpose
+is clearly defined and not supposed to be changed (e.g. network firewall
+device in a data center, an IoT device, etcetera), where all software and
+configuration is built and provisioned by the system owner.
+
+IPE is a long-way off for use in general-purpose computing: the Linux
+community as a whole tends to follow a decentralized trust model (known as
+the web of trust), which IPE has no support for it yet. Instead, IPE
+supports PKI (public key infrastructure), which generally designates a
+set of trusted entities that provide a measure of absolute trust.
+
+Additionally, while most packages are signed today, the files inside
+the packages (for instance, the executables), tend to be unsigned. This
+makes it difficult to utilize IPE in systems where a package manager is
+expected to be functional, without major changes to the package manager
+and ecosystem behind it.
+
+DIGLIM [#diglim]_ is a system that when combined with IPE, could be used to
+enable and support general-purpose computing use cases.
+
+Known Limitations
+-----------------
+
+IPE cannot verify the integrity of anonymous executable memory, such as
+the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
+Unfortunately, as this is dynamically generated code, there is no way
+for IPE to ensure the integrity of this code to form a trust basis. In all
+cases, the return result for these operations will be whatever the admin
+configures as the ``DEFAULT`` action for ``EXECUTE``.
+
+IPE cannot verify the integrity of programs written in interpreted
+languages when these scripts are invoked by passing these program files
+to the interpreter. This is because the way interpreters execute these
+files; the scripts themselves are not evaluated as executable code
+through one of IPE's hooks, but they are merely text files that are read
+(as opposed to compiled executables) [#interpreters]_.
+
+Threat Model
+------------
+
+The threat type addressed by IPE is tampering of executable userspace
+code beyond the initially booted kernel, and the initial verification of
+kernel modules that are loaded in userspace through ``modprobe`` or
+``insmod``.
+
+A bare-minimum example of a threat that should be mitigated by IPE, is
+an untrusted (potentially malicious) binary that is downloaded and
+bundled with all required dependencies (including a loader, libc, etc).
+With IPE, this binary should not be allowed to be executed, not even any
+of its dependencies.
+
+Tampering violates integrity, yet lack of trust is caused by being
+unable to detect tampering (and by extent verifying the integrity).
+IPE's role in mitigating this threat is to verify the integrity (and
+authenticity) of all executable code and to deny their use if they
+cannot be trusted (as integrity verification fails, or the authorization
+check fails against the reference value in the policy). IPE generates
+audit logs which may be utilized to detect and analyze failures
+resulting from policy violation.
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
+IPE does not mitigate threats arising from malicious but authorized
+developers (with access to a signing certificate), or compromised
+developer tools used by them (i.e. return-oriented programming attacks).
+Additionally, IPE draws hard security boundary between userspace and
+kernelspace. As a result, IPE does not provide any protections against a
+kernel level exploit, and a kernel-level exploit can disable or tamper
+with IPE's protections.
+
+Policy
+------
+
+IPE policy is a plain-text [#devdoc]_ policy composed of multiple statements
+over several lines. There is one required line, at the top of the
+policy, indicating the policy name, and the policy version, for
+instance::
+
+   policy_name=Ex_Policy policy_version=0.0.0
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
+The next portion of IPE policy are rules. Rules are formed by key=value
+pairs, known as properties. IPE rules require two properties: ``action``,
+which determines what IPE does when it encounters a match against the
+rule, and ``op``, which determines when the rule should be evaluated.
+The ordering is significant, a rule must start with ``op``, and end with
+``action``. Thus, a minimal rule is::
+
+   op=EXECUTE action=ALLOW
+
+This example will allow any execution. Additional properties are used to
+restrict attributes about the files being evaluated. These properties
+are intended to be descriptions of systems within the kernel that can
+provide a measure of integrity verification, such that IPE can determine
+the trust of the resource based on the value of the property.
+
+Rules are evaluated top-to-bottom. As a result, any revocation rules,
+or denies should be placed early in the file to ensure that these rules
+are evaluated before a rule with ``action=ALLOW``.
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
+new operations, set a global default of ``ALLOW``, then override the
+defaults on a per-operation basis (as above).
+
+With configurable policy-based LSMs, there's several issues with
+enforcing the configurable policies at startup, around reading and
+parsing the policy:
+
+1. The kernel *should* not read files from userspace, so directly reading
+   the policy file is prohibited.
+2. The kernel command line has a character limit, and one kernel module
+   should not reserve the entire character limit for its own
+   configuration.
+3. There are various boot loaders in the kernel ecosystem, so handing
+   off a memory block would be costly to maintain.
+
+As a result, IPE has addressed this problem through a concept of a "boot
+policy". A boot policy is a minimal policy which is compiled into the
+kernel. This policy is intended to get the system to a state where
+userspace is set up and ready to receive commands, at which point a more
+complex policy can be deployed via securityfs. The boot policy can be
+specified via ``SECURITY_IPE_BOOT_POLICY`` config option, which accepts
+a path to a plain-text version of the IPE policy to apply. This policy
+will be compiled into the kernel. If not specified, IPE will be disabled
+until a policy is deployed and activated through securityfs.
+
+Deploying Policies
+~~~~~~~~~~~~~~~~~~
+
+Policies can be deployed from userspace through securityfs. These policies
+are signed through the PKCS#7 message format to enforce some level of
+authorization of the policies (prohibiting an attacker from gaining
+unconstrained root, and deploying an "allow all" policy). These
+policies must be signed by a certificate that chains to the
+``SYSTEM_TRUSTED_KEYRING``. With openssl, the policy can be signed by::
+
+   openssl smime -sign \
+      -in "$MY_POLICY" \
+      -signer "$MY_CERTIFICATE" \
+      -inkey "$MY_PRIVATE_KEY" \
+      -noattr \
+      -nodetach \
+      -nosmimecap \
+      -outform der \
+      -out "$MY_POLICY.p7b"
+
+Deploying the policies is done through securityfs, through the
+``new_policy`` node. To deploy a policy, simply cat the file into the
+securityfs node::
+
+   cat "$MY_POLICY.p7b" > /sys/kernel/security/ipe/new_policy
+
+Upon success, this will create one subdirectory under
+``/sys/kernel/security/ipe/policies/``. The subdirectory will be the
+``policy_name`` field of the policy deployed, so for the example above,
+the directory will be ``/sys/kernel/security/ipe/policies/Ex_Policy``.
+Within this directory, there will be seven files: ``pkcs7``, ``policy``,
+``name``, ``version``, ``active``, ``update``, and ``delete``.
+
+The ``pkcs7`` file is read-only. Reading it returns the raw PKCS#7 data
+that was provided to the kernel, representing the policy. If the policy being
+read is the boot policy, this will return ``ENOENT``, as it is not signed.
+
+The ``policy`` file is read only. Reading it returns the PKCS#7 inner
+content of the policy, which will be the plain text policy.
+
+The ``active`` file is used to set a policy as the currently active policy.
+This file is rw, and accepts a value of ``"1"`` to set the policy as active.
+Since only a single policy can be active at one time, all other policies
+will be marked inactive. The policy being marked active must have a policy
+version greater or equal to the currently-running version.
+
+The ``update`` file is used to update a policy that is already present
+in the kernel. This file is write-only and accepts a PKCS#7 signed
+policy. Two checks will always be performed on this policy: First, the
+``policy_names`` must match with the updated version and the existing
+version. Second the updated policy must have a policy version greater than
+or equal to the currently-running version. This is to prevent rollback attacks.
+
+The ``delete`` file is used to remove a policy that is no longer needed.
+This file is write-only and accepts a value of ``1`` to delete the policy.
+On deletion, the securityfs node representing the policy will be removed.
+However, delete the current active policy is not allowed and will return
+an operation not permitted error.
+
+Similarly, writing to both ``update`` and ``new_policy`` could result in
+bad message(policy syntax error) or file exists error. The latter error happens
+when trying to deploy a policy with a ``policy_name`` while the kernel already
+has a deployed policy with the same ``policy_name``.
+
+Deploying a policy will *not* cause IPE to start enforcing the policy. IPE will
+only enforce the policy marked active. Note that only one policy can be active
+at a time.
+
+Once deployment is successful, the policy can be activated, by writing file
+``/sys/kernel/security/ipe/$policy_name/active``.
+For example, the ``Ex_Policy`` can be activated by::
+
+   echo 1 > "/sys/kernel/security/ipe/Ex_Policy/active"
+
+From above point on, ``Ex_Policy`` is now the enforced policy on the
+system.
+
+IPE also provides a way to delete policies. This can be done via the
+``delete`` securityfs node, ``/sys/kernel/security/ipe/$policy_name/delete``.
+Writing ``1`` to that file deletes the policy::
+
+   echo 1 > "/sys/kernel/security/ipe/$policy_name/delete"
+
+There is only one requirement to delete a policy: the policy being deleted
+must be inactive.
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
+permissive mode) and enforced. In permissive mode, all events are
+checked and policy violations are logged, but the policy is not really
+enforced. This allows users to test policies before enforcing them.
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
+1420 AUDIT_IPE_ACCESS
+^^^^^^^^^^^^^^^^^^^^^
+Event Examples::
+
+   type=1420 audit(1653364370.067:61): ipe_op=EXECUTE ipe_hook=MMAP enforcing=1 pid=2241 comm="ld-linux.so" path="/deny/lib/libc.so.6" dev="sda2" ino=14549020 rule="DEFAULT action=DENY"
+   type=1300 audit(1653364370.067:61): SYSCALL arch=c000003e syscall=9 success=no exit=-13 a0=7f1105a28000 a1=195000 a2=5 a3=812 items=0 ppid=2219 pid=2241 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="ld-linux.so" exe="/tmp/ipe-test/lib/ld-linux.so" subj=unconfined key=(null)
+   type=1327 audit(1653364370.067:61): 707974686F6E3300746573742F6D61696E2E7079002D6E00
+
+   type=1420 audit(1653364735.161:64): ipe_op=EXECUTE ipe_hook=MMAP enforcing=1 pid=2472 comm="mmap_test" path=? dev=? ino=? rule="DEFAULT action=DENY"
+   type=1300 audit(1653364735.161:64): SYSCALL arch=c000003e syscall=9 success=no exit=-13 a0=0 a1=1000 a2=4 a3=21 items=0 ppid=2219 pid=2472 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="mmap_test" exe="/root/overlake_test/upstream_test/vol_fsverity/bin/mmap_test" subj=unconfined key=(null)
+   type=1327 audit(1653364735.161:64): 707974686F6E3300746573742F6D61696E2E7079002D6E00
+
+This event indicates that IPE made an access control decision; the IPE
+specific record (1420) is always emitted in conjunction with a
+``AUDITSYSCALL`` record.
+
+Determining whether IPE is in permissive or enforced mode can be derived
+from ``success`` property and exit code of the ``AUDITSYSCALL`` record.
+
+
+Field descriptions:
+
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| Field     | Value Type | Optional? | Description of Value                                                            |
++===========+============+===========+=================================================================================+
+| ipe_op    | string     | No        | The IPE operation name associated with the log                                  |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| ipe_hook  | string     | No        | The name of the LSM hook that triggered the IPE event                           |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| enforcing | integer    | No        | The current IPE enforcing state 1 is in enforcing mode, 0 is in permissive mode |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| pid       | integer    | No        | The pid of the process that triggered the IPE event.                            |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| comm      | string     | No        | The command line program name of the process that triggered the IPE event       |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| path      | string     | Yes       | The absolute path to the evaluated file                                         |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| ino       | integer    | Yes       | The inode number of the evaluated file                                          |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| dev       | string     | Yes       | The device name of the evaluated file, e.g. vda                                 |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+| rule      | string     | No        | The matched policy rule                                                         |
++-----------+------------+-----------+---------------------------------------------------------------------------------+
+
+1421 AUDIT_IPE_CONFIG_CHANGE
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Event Example::
+
+   type=1421 audit(1653425583.136:54): old_active_pol_name="Allow_All" old_active_pol_version=0.0.0 old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855 new_active_pol_name="boot_verified" new_active_pol_version=0.0.0 new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB auid=4294967295 ses=4294967295 lsm=ipe res=1
+   type=1300 audit(1653425583.136:54): SYSCALL arch=c000003e syscall=1 success=yes exit=2 a0=3 a1=5596fcae1fb0 a2=2 a3=2 items=0 ppid=184 pid=229 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=4294967295 comm="python3" exe="/usr/bin/python3.10" key=(null)
+   type=1327 audit(1653425583.136:54): PROCTITLE proctitle=707974686F6E3300746573742F6D61696E2E7079002D66002E2
+
+This event indicates that IPE switched the active poliy from one to another
+along with the version and the hash digest of the two policies.
+Note IPE can only have one policy active at a time, all access decision
+evaluation is based on the current active policy.
+The normal procedure to deploy a new policy is loading the policy to deploy
+into the kernel first, then switch the active policy to it.
+
+This record will always be emitted in conjunction with a ``AUDITSYSCALL`` record for the ``write`` syscall.
+
++------------------------+------------+-----------+---------------------------------------------------+
+| Field                  | Value Type | Optional? | Description of Value                              |
++========================+============+===========+===================================================+
+| old_active_pol_name    | string     | No        | The name of previous active policy                |
++------------------------+------------+-----------+---------------------------------------------------+
+| old_active_pol_version | string     | No        | The version of previous active policy             |
++------------------------+------------+-----------+---------------------------------------------------+
+| old_policy_digest      | string     | No        | The hash of previous active policy                |
++------------------------+------------+-----------+---------------------------------------------------+
+| new_active_pol_name    | string     | No        | The name of current active policy                 |
++------------------------+------------+-----------+---------------------------------------------------+
+| new_active_pol_version | string     | No        | The version of current active policy              |
++------------------------+------------+-----------+---------------------------------------------------+
+| new_policy_digest      | string     | No        | The hash of current active policy                 |
++------------------------+------------+-----------+---------------------------------------------------+
+| auid                   | integer    | No        | The login user ID                                 |
++------------------------+------------+-----------+---------------------------------------------------+
+| ses                    | integer    | No        | The login session ID                              |
++------------------------+------------+-----------+---------------------------------------------------+
+| lsm                    | string     | No        | The lsm name associated with the event            |
++------------------------+------------+-----------+---------------------------------------------------+
+| res                    | integer    | No        | The result of the audited operation(success/fail) |
++------------------------+------------+-----------+---------------------------------------------------+
+
+1422 AUDIT_IPE_POLICY_LOAD
+^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Event Example::
+
+   type=1422 audit(1653425529.927:53): policy_name="boot_verified" policy_version=0.0.0 policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB auid=4294967295 ses=4294967295 lsm=ipe res=1
+   type=1300 audit(1653425529.927:53): arch=c000003e syscall=1 success=yes exit=2567 a0=3 a1=5596fcae1fb0 a2=a07 a3=2 items=0 ppid=184 pid=229 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=4294967295 comm="python3" exe="/usr/bin/python3.10" key=(null)
+   type=1327 audit(1653425529.927:53): PROCTITLE proctitle=707974686F6E3300746573742F6D61696E2E7079002D66002E2E
+
+This record indicates a new policy has been loaded into the kernel with the policy name, policy version and policy hash.
+
+This record will always be emitted in conjunction with a ``AUDITSYSCALL`` record for the ``write`` syscall.
+
++----------------+------------+-----------+---------------------------------------------------+
+| Field          | Value Type | Optional? | Description of Value                              |
++================+============+===========+===================================================+
+| policy_name    | string     | No        | The policy_name                                   |
++----------------+------------+-----------+---------------------------------------------------+
+| policy_version | string     | No        | The policy_version                                |
++----------------+------------+-----------+---------------------------------------------------+
+| policy_digest  | string     | No        | The policy hash                                   |
++----------------+------------+-----------+---------------------------------------------------+
+| auid           | integer    | No        | The login user ID                                 |
++----------------+------------+-----------+---------------------------------------------------+
+| ses            | integer    | No        | The login session ID                              |
++----------------+------------+-----------+---------------------------------------------------+
+| lsm            | string     | No        | The lsm name associated with the event            |
++----------------+------------+-----------+---------------------------------------------------+
+| res            | integer    | No        | The result of the audited operation(success/fail) |
++----------------+------------+-----------+---------------------------------------------------+
+
+
+1404 AUDIT_MAC_STATUS
+^^^^^^^^^^^^^^^^^^^^^
+
+Event Examples::
+
+   type=1404 audit(1653425689.008:55): enforcing=0 old_enforcing=1 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1327 audit(1653425689.008:55): proctitle="-bash"
+
+   type=1404 audit(1653425689.008:55): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
+   type=1300 audit(1653425689.008:55): arch=c000003e syscall=1 success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405 pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
+   type=1327 audit(1653425689.008:55): proctitle="-bash"
+
+This record will always be emitted in conjunction with a ``AUDITSYSCALL`` record for the ``write`` syscall.
+
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| Field         | Value Type | Optional? | Description of Value                                                                            |
++===============+============+===========+=================================================================================================+
+| enforcing     | integer    | No        | The enforcing state IPE is being switched to, 1 is in enforcing mode, 0 is in permissive mode   |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| old_enforcing | integer    | No        | The enforcing state IPE is being switched from, 1 is in enforcing mode, 0 is in permissive mode |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| auid          | integer    | No        | The login user ID                                                                               |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| ses           | integer    | No        | The login session ID                                                                            |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| enabled       | integer    | No        | The new TTY audit enabled setting                                                               |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| old-enabled   | integer    | No        | The old TTY audit enabled setting                                                               |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| lsm           | string     | No        | The lsm name associated with the event                                                          |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+| res           | integer    | No        | The result of the audited operation(success/fail)                                               |
++---------------+------------+-----------+-------------------------------------------------------------------------------------------------+
+
+
+Success Auditing
+^^^^^^^^^^^^^^^^
+
+IPE supports success auditing. When enabled, all events that pass IPE
+policy and are not blocked will emit an audit event. This is disabled by
+default, and can be enabled via the kernel command line
+``ipe.success_audit=(0|1)`` or
+``/sys/kernel/security/ipe/success_audit`` securityfs file.
+
+This is *very* noisy, as IPE will check every userspace binary on the
+system, but is useful for debugging policies.
+
+.. NOTE::
+
+   If a traditional MAC system is enabled (SELinux, apparmor, smack, etcetera),
+   all writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
+
+Properties
+----------
+
+As explained above, IPE properties are ``key=value`` pairs expressed in
+IPE policy. Two properties are built-into the policy parser: 'op' and
+'action'. The other properties are deterministic attributes to express
+across files. Currently those properties are: '``boot_verified``',
+'``dmverity_signature``', '``dmverity_roothash``', '``fsverity_signature``',
+'``fsverity_digest``'. A description of all properties supported by IPE
+are listed below:
+
+op
+~~
+
+Indicates the operation for a rule to apply to. Must be in every rule,
+as the first token. IPE supports the following operations:
+
+   ``EXECUTE``
+
+      Pertains to any file attempting to be executed, or loaded as an
+      executable.
+
+   ``FIRMWARE``:
+
+      Pertains to firmware being loaded via the firmware_class interface.
+      This covers both the preallocated buffer and the firmware file
+      itself.
+
+   ``KMODULE``:
+
+      Pertains to loading kernel modules via ``modprobe`` or ``insmod``.
+
+   ``KEXEC_IMAGE``:
+
+      Pertains to kernel images loading via ``kexec``.
+
+   ``KEXEC_INITRAMFS``
+
+      Pertains to initrd images loading via ``kexec --initrd``.
+
+   ``POLICY``:
+
+      Controls loading policies via reading a kernel-space initiated read.
+
+      An example of such is loading IMA policies by writing the path
+      to the policy file to ``$securityfs/ima/policy``
+
+   ``X509_CERT``:
+
+      Controls loading IMA certificates through the Kconfigs,
+      ``CONFIG_IMA_X509_PATH`` and ``CONFIG_EVM_X509_PATH``.
+
+action
+~~~~~~
+
+   Determines what IPE should do when a rule matches. Must be in every
+   rule, as the final clause. Can be one of:
+
+   ``ALLOW``:
+
+      If the rule matches, explicitly allow access to the resource to proceed
+      without executing any more rules.
+
+   ``DENY``:
+
+      If the rule matches, explicitly prohibit access to the resource to
+      proceed without executing any more rules.
+
+boot_verified
+~~~~~~~~~~~~~
+
+   This property can be utilized for authorization of files from initramfs.
+   It will only be available if ``CONFIG_BLK_DEV_INITRD`` is enabled.
+   The format of this property is::
+
+         boot_verified=(TRUE|FALSE)
+
+
+   .. WARNING::
+
+      This property will trust files from initramfs(rootfs). It should
+      only be used during early booting stage. As the rootfs is never
+      unmounted, It is recommended to switch to another policy without
+      this property after the real rootfs takes over.
+
+dmverity_roothash
+~~~~~~~~~~~~~~~~~
+
+   This property can be utilized for authorization or revocation of
+   specific dm-verity volumes, identified via sroot hash. It has a
+   dependency on the DM_VERITY module. This property is controlled by
+   the ``IPE_PROP_DM_VERITY`` config option, it will be automatically
+   selected when ``IPE_SECURITY``, ``DM_VERITY `` and
+   ``DM_VERITY_VERIFY_ROOTHASH_SIG`` are all enabled.
+   The format of this property is::
+
+      dmverity_roothash=DigestName:HexadecimalString
+
+   The supported DigestNames for dmverity_roothash are [#dmveritydigests]_ [#securedigest]_ :
+
+      + blake2b-512
+      + blake2s-256
+      + sha1
+      + sha256
+      + sha384
+      + sha512
+      + sha3-224
+      + sha3-256
+      + sha3-384
+      + sha3-512
+      + md4
+      + md5
+      + sm3
+      + rmd160
+
+dmverity_signature
+~~~~~~~~~~~~~~~~~~
+
+   This property can be utilized for authorization of all dm-verity
+   volumes that have a signed roothash that chains to a keyring
+   specified by dm-verity's configuration, either the system trusted
+   keyring, or the secondary keyring. It depends on
+   ``DM_VERITY_VERIFY_ROOTHASH_SIG`` config option and is controlled by
+   the ``IPE_PROP_DM_VERITY`` config option, it will be automatically
+   selected when ``IPE_SECURITY``, ``DM_VERITY `` and
+   ``DM_VERITY_VERIFY_ROOTHASH_SIG`` are all enabled.
+   The format of this property is::
+
+      dmverity_signature=(TRUE|FALSE)
+
+fsverity_digest
+~~~~~~~~~~~~~~~
+
+   This property can be utilized for authorization or revocation of
+   specific fsverity enabled file, identified via its fsverity digest.
+   It depends on ``FS_VERITY`` config option and is controlled by
+   ``CONFIG_IPE_PROP_FS_VERITY``. The format of this property is::
+
+      fsverity_digest=DigestName:HexadecimalString
+
+   The supported DigestNames for dmverity_roothash are [#fsveritydigest] [#securedigest]_ :
+
+      + sha256
+      + sha512
+
+fsverity_signature
+~~~~~~~~~~~~~~~~~~
+
+   This property can be utilized for authorization of all fsverity
+   enabled files that is verified by fsverity. The keyring that the
+   signature is verified against is subject to fsverity's configuration,
+   typically the fsverity keyring. It depends on
+   ``CONFIG_FS_VERITY_BUILTIN_SIGNATURES`` and  it is controlled by
+   the Kconfig ``CONFIG_IPE_PROP_FS_VERITY``. The format of this
+   property is::
+
+      fsverity_signature=(TRUE|FALSE)
+
+Policy Examples
+---------------
+
+Allow all
+~~~~~~~~~
+
+::
+
+   policy_name=Allow_All policy_version=0.0.0
+   DEFAULT action=ALLOW
+
+Allow only initramfs
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name=Allow_All_Initramfs policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+
+Allow any signed dm-verity volume and the initramfs
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name=AllowSignedAndInitramfs policy_version=0.0.0
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
+   policy_name=AllowSignedAndInitramfs policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE dmverity_roothash=sha256:cd2c5bae7c6c579edaae4353049d58eb5f2e8be0244bf05345bc8e5ed257baff action=DENY
+
+   op=EXECUTE boot_verified=TRUE action=ALLOW
+   op=EXECUTE dmverity_signature=TRUE action=ALLOW
+
+Allow only a specific dm-verity volume
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name=AllowSignedAndInitramfs policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE dmverity_roothash=sha256:401fcec5944823ae12f62726e8184407a5fa9599783f030dec146938 action=ALLOW
+
+Allow any signed fs-verity file
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name=AllowSignedFSVerity policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE fsverity_signature=TRUE action=ALLOW
+
+Prohibit execution of a specific fs-verity file
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+   policy_name=ProhibitSpecificFSVF policy_version=0.0.0
+   DEFAULT action=DENY
+
+   op=EXECUTE fsverity_digest=sha256:fd88f2b8824e197f850bf4c5109bea5cf0ee38104f710843bb72da796ba5af9e action=DENY
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
+Q:
+   What's the difference between other LSMs which provide a measure of
+   trust-based access control?
+
+A:
+
+   In general, there's two other LSMs that can provide similar functionality:
+   IMA, and Loadpin.
+
+   IMA and IPE are functionally very similar. The significant difference between
+   the two is the policy. [#devdoc]_
+
+   Loadpin and IPE differ fairly dramatically, as Loadpin controls only the IPE
+   equivalent of ``KERNEL_READ``, whereas IPE is capable of controlling execution,
+   on top of ``KERNEL_READ``. The trust model is also different; Loadpin roots its
+   trust in the initial super-block, whereas trust in IPE is stemmed from kernel
+   itself (via ``SYSTEM_TRUSTED_KEYS``).
+
+-----------
+
+.. [#diglim] 1: https://lore.kernel.org/bpf/4d6932e96d774227b42721d9f645ba51@huawei.com/T/
+
+.. [#interpreters] There is `some interest in solving this issue <https://lore.kernel.org/lkml/20220321161557.495388-1-mic@digikod.net/>`_.
+
+.. [#devdoc] Please see `Documentation/security/ipe.rst` for more on this topic.
+
+.. [#fsveritydigest] These hash algorithms are based on values accepted by fsverity-utils;
+                     IPE does not impose any restrictions on the digest algorithm itself;
+                     thus, this list may be out of date.
+
+.. [#dmveritydigests] These hash algorithms are based on values accepted by dm-verity,
+                      specifically ``crypto_alloc_ahash`` in ``verity_ctr``; ``veritysetup``
+                      does support more algorithms than the list above. IPE does not impose
+                      any restrictions on the digest algorithm itself; thus, this list
+                      may be out of date.
+
+.. [#securedigest] Please ensure you are using cryptographically secure hash functions;
+                   just because something is *supported* does not mean it is *secure*.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 31b3a25680d0..3a3e0978e95d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2282,6 +2282,18 @@
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
index 59f8fc106cb0..3e0a7114a862 100644
--- a/Documentation/security/index.rst
+++ b/Documentation/security/index.rst
@@ -19,3 +19,4 @@ Security Documentation
    digsig
    landlock
    secrets/index
+   ipe
diff --git a/Documentation/security/ipe.rst b/Documentation/security/ipe.rst
new file mode 100644
index 000000000000..9ac3d680fbdc
--- /dev/null
+++ b/Documentation/security/ipe.rst
@@ -0,0 +1,444 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+Integrity Policy Enforcement (IPE) - Kernel Documentation
+=========================================================
+
+.. NOTE::
+
+   This is documentation targeted at developers, instead of administrators.
+   If you're looking for documentation on the usage of IPE, please see
+   `Documentation/admin-guide/LSM/ipe.rst`
+
+Historical Motivation
+---------------------
+
+The original issue that prompted IPE's implementation was the creation
+of a locked-down system. This system would be born-secure, and have
+strong integrity guarantees over both the executable code, and specific
+*data files* on the system, that were critical to its function. These
+specific data files would not be readable unless they passed integrity
+policy. A mandatory access control system would be present, and
+as a result, xattrs would have to be protected. This lead to a selection
+of what would provide the integrity claims. At the time, there were two
+main mechanisms considered that could guarantee integrity for the system
+with these requirements:
+
+  1. IMA + EVM Signatures
+  2. DM-Verity
+
+Both options were carefully considered, however the choice to use DM-Verity
+over IMA+EVM as the *integrity mechanism* in the original use case of IPE
+was due to three main reasons:
+
+  1. Protection of additional attack vectors:
+
+    * With IMA+EVM, without an encryption solution, the system is vulnerable
+      to offline attack against the aforementioned specific data files.
+
+      Unlike executables, read operations (like those on the protected data
+      files), cannot be enforced to be globally integrity verified. This means
+      there must be some form of selector to determine whether a read should
+      enforce the integrity policy, or it should not.
+
+      At the time, this was done with mandatory access control labels. An IMA
+      policy would indicate what labels required integrity verification, which
+      presented an issue: EVM would protect the label, but if an attacker could
+      modify filesystem offline, the attacker could wipe all the xattrs -
+      including the SELinux labels that would be used to determine whether the
+      file should be subject to integrity policy.
+
+      With DM-Verity, as the xattrs are saved as part of the merkel tree, if
+      offline mount occurs against the filesystem protected by dm-verity, the
+      checksum no longer matches and the file fails to be read.
+
+    * As userspace binaries are paged in Linux, dm-verity also offers the
+      additional protection against a hostile block device. In such an attack,
+      the block device reports the appropriate content for the IMA hash
+      initially, passing the required integrity check. Then, on the page fault
+      that accesses the real data, will report the attacker's payload. Since
+      dm-verity will check the data when the page fault occurs (and the disk
+      access), this attack is mitigated.
+
+  2. Performance:
+
+    * dm-verity provides integrity verification on demand as blocks are
+      read versus requiring the entire file being read into memory for
+      validation.
+
+  3. Simplicity of signing:
+
+    * No need for two signatures (IMA, then EVM): one signature covers
+      an entire block device.
+    * Signatures can be stored externally to the filesystem metadata.
+    * The signature supports an x.509-based signing infrastructure.
+
+The next step was to choose a *policy* to enforce the integrity mechanism.
+The minimum requirements for the policy were:
+
+  1. The policy itself must be integrity verified (preventing trivial
+     attack against it).
+  2. The policy itself must be resistant to rollback attacks.
+  3. The policy enforcement must have a permissive-like mode.
+  4. The policy must be able to be updated, in its entirety, without
+     a reboot.
+  5. Policy updates must be atomic.
+  6. The policy must support *revocations* of previously authored
+     components.
+  7. The policy must be auditable, at any point-of-time.
+
+IMA, as the only integrity policy mechanism at the time, was
+considered against these list of requirements, and did not fulfill
+all of the minimum requirements. Extending IMA to cover these
+requirements was considered, but ultimately discarded for a
+two reasons:
+
+  1. Regression risk; many of these changes would result in
+     dramatic code changes to IMA, which is already present in the
+     kernel, and therefore might impact users.
+
+  2. IMA was used in the system for measurement and attestation;
+     separation of measurement policy from local integrity policy
+     enforcement was considered favorable.
+
+Due to these reasons, it was decided that a new LSM should be created,
+whose responsibility would be only the local integrity policy enforcement.
+
+Role and Scope
+--------------
+
+IPE, as its name implies, is fundamentally an integrity policy enforcement
+solution; IPE does not mandate how integrity is provided, but instead
+leaves that decision to the system administrator to set the security bar,
+via the mechanisms that they select that suit their individual needs.
+There are several different integrity solutions that provide a different
+level of security guarantees; and IPE allows sysadmins to express policy for
+theoretically all of them.
+
+IPE does not have an inherent mechanism to ensure integrity on its own.
+Instead, there are more effective layers available for building systems that
+can guarantee integrity. It's important to note that the mechanism for proving
+integrity is independent of the policy for enforcing that integrity claim.
+
+Therefore, IPE was designed around:
+
+  1. Easy integrations with integrity providers.
+  2. Ease of use for platform administrators/sysadmins.
+
+Design Rationale:
+-----------------
+
+IPE was designed after evaluating existing integrity policy solutions
+in other operating systems and environments. In this survey of other
+implementations, there were a few pitfalls identified:
+
+  1. Policies were not readable by humans, usually requiring a binary
+     intermediary format.
+  2. A single, non-customizable action was implicitly taken as a default.
+  3. Debugging the policy required manual steps to determine what rule was violated.
+  4. Authoring a policy required an in-depth knowledge of the larger system,
+     or operating system.
+
+IPE attempts to avoid all of these pitfalls.
+
+Policy
+~~~~~~
+
+Plain Text
+^^^^^^^^^^
+
+IPE's policy is plain-text. This introduces slightly larger policy files than
+other LSMs, but solves two major problems that occurs with some integrity policy
+solutions on other platforms.
+
+The first issue is one of code maintenance and duplication. To author policies,
+the policy has to be some form of string representation (be it structured,
+through XML, JSON, YAML, etcetera), to allow the policy author to understand
+what is being written. In a hypothetical binary policy design, a serializer
+is necessary to write the policy from the human readable form, to the binary
+form, and a deserializer is needed to interpret the binary form into a data
+structure in the kernel.
+
+Eventually, another deserializer will be needed to transform the binary from
+back into the human-readable form with as much information preserved. This is because a
+user of this access control system will have to keep a lookup table of a checksum
+and the original file itself to try to understand what policies have been deployed
+on this system and what policies have not. For a single user, this may be alright,
+as old policies can be discarded almost immediately after the update takes hold.
+For users that manage computer fleets in the thousands, if not hundreds of thousands,
+with multiple different operating systems, and multiple different operational needs,
+this quickly becomes an issue, as stale policies from years ago may be present,
+quickly resulting in the need to recover the policy or fund extensive infrastructure
+to track what each policy contains.
+
+With now three separate serializer/deserializers, maintenance becomes costly. If the
+policy avoids the binary format, there is only one required serializer: from the
+human-readable form to the data structure in kernel, saving on code maintenance,
+and retaining operability.
+
+The second issue with a binary format is one of transparency. As IPE controls
+access based on the trust of the system's resources, it's policy must also be
+trusted to be changed. This is done through signatures, resulting in needing
+signing as a process. Signing, as a process, is typically done with a
+high security bar, as anything signed can be used to attack integrity
+enforcement systems. It is also important that, when signing something, that
+the signer is aware of what they are signing. A binary policy can cause
+obfuscation of that fact; what signers see is an opaque binary blob. A
+plain-text policy, on the other hand, the signers see the actual policy
+submitted for signing.
+
+Boot Policy
+~~~~~~~~~~~
+
+IPE, if configured appropriately, is able to enforce a policy as soon as a
+kernel is booted and usermode starts. That implies some level of storage
+of the policy to apply the minute usermode starts. Generally, that storage
+can be handled in one of three ways:
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
+new methodology or there must be an independent source. It would likely
+result in more drastic changes to the kernel startup than necessary.
+
+The third option is the best but it's important to be aware that the policy
+will take disk space against the kernel it's compiled in. It's important to
+keep this policy generalized enough that userspace can load a new, more
+complicated policy, but restrictive enough that it will not overauthorize
+and cause security issues.
+
+The initramfs provides a way that this bootup path can be established. The
+kernel starts with a minimal policy, that trusts the initramfs only. Inside
+the initramfs, when the real rootfs is mounted, but not yet transferred to,
+it deploys and activates a policy that trusts the new root filesystem.
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
+As requirements change over time (vulnerabilities are found in previously
+trusted applications, keys roll, etcetera). Updating a kernel to change the
+meet those security goals is not always a suitable option, as updates are not
+always risk-free, and blocking a security update leaves systems vulnerable.
+This means IPE requires a policy that can be completely updated (allowing
+revocations of existing policy) from a source external to the kernel (allowing
+policies to be updated without updating the kernel).
+
+Additionally, since the kernel is stateless between invocations, and reading
+policy files off the disk from kernel space is a bad idea(tm), then the
+policy updates have to be done rebootlessly.
+
+To allow an update from an external source, it could be potentially malicious,
+so this policy needs to have a way to be identified as trusted. This is
+done via a signature chained to a trust source in the kernel. Arbitrarily,
+this is  the ``SYSTEM_TRUSTED_KEYRING``, a keyring that is initially
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
+Assuming that as soon as the insecure policy is signed, and an attacker
+acquires the insecure policy, IPE needs a way to prevent rollback
+from the secure policy update to the insecure policy update.
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
+  opportunity is minimal for an attacker to deploy the insecure policy.
+
+Implicit Actions:
+~~~~~~~~~~~~~~~~~
+
+The issue of implicit actions only becomes visible when you consider
+a mixed level of security bars across multiple operations in a system.
+For example, consider a system that has strong integrity guarantees
+over both the executable code, and specific *data files* on the system,
+that were critical to its function. In this system, three types of policies
+are possible:
+
+  1. A policy in which failure to match any rules in the policy results
+     in the action being denied.
+  2. A policy in which failure to match any rules in the policy results
+     in the action being allowed.
+  3. A policy in which the action taken when no rules are matched is
+     specified by the policy author.
+
+The first option could make a policy like this::
+
+  op=EXECUTE integrity_verified=YES action=ALLOW
+
+In the example system, this works well for the executables, as all
+executables should have integrity guarantees, without exception. The
+issue becomes with the second requirement about specific data files.
+This would result in a policy like this (assuming each line is
+evaluated in order)::
+
+  op=EXECUTE integrity_verified=YES action=ALLOW
+
+  op=READ integrity_verified=NO label=critical_t action=DENY
+  op=READ action=ALLOW
+
+This is somewhat clear if you read the docs, understand the policy
+is executed in order and that the default is a denial; however, the
+last line effectively changes that default to an ALLOW. This is
+required, because in a realistic system, there are some unverified
+reads (imagine appending to a log file).
+
+The second option, matching no rules results in an allow, is clearer
+for the specific data files::
+
+  op=READ integrity_verified=NO label=critical_t action=DENY
+
+And, like the first option, falls short with the opposite scenario,
+effectively needing to override the default::
+
+  op=EXECUTE integrity_verified=YES action=ALLOW
+  op=EXECUTE action=DENY
+
+  op=READ integrity_verified=NO label=critical_t action=DENY
+
+This leaves the third option. Instead of making users be clever
+and override the default with an empty rule, force the end-user
+to consider what the appropriate default should be for their
+scenario and explicitly state it::
+
+  DEFAULT op=EXECUTE action=DENY
+  op=EXECUTE integrity_verified=YES action=ALLOW
+
+  DEFAULT op=READ action=ALLOW
+  op=READ integrity_verified=NO label=critical_t action=DENY
+
+Policy Debugging:
+~~~~~~~~~~~~~~~~~
+
+When developing a policy, it is useful to know what line of the policy
+is being violated to reduce debugging costs; narrowing the scope of the
+investigation to the exact line that resulted in the action. Some integrity
+policy systems do not provide this information, instead providing the
+information that was used in the evaluation. This then requires a correlation
+with the policy to evaluate what went wrong.
+
+Instead, IPE just emits the rule that was matched. This limits the scope
+of the investigation to the exact policy line (in the case of a specific
+rule), or the section (in the case of a DEFAULT). This decreases iteration
+and investigation times when policy failures are observed while evaluating
+policies.
+
+IPE's policy engine is also designed in a way that it makes it obvious to
+a human of how to investigate a policy failure. Each line is evaluated in
+the sequence that is written, so the algorithm is very simple to follow
+for humans to recreate the steps and could have caused the failure. In other
+surveyed systems, optimizations occur (sorting rules, for instance) when loading
+the policy. In those systems, it requires multiple steps to debug, and the
+algorithm may not always be clear to the end-user without reading the code first.
+
+Simplified Policy:
+~~~~~~~~~~~~~~~~~~
+
+Finally, IPE's policy is designed for sysadmins, not kernel developers. Instead
+of covering individual LSM hooks (or syscalls), IPE covers operations. This means
+instead of sysadmins needing to know that the syscalls ``mmap``, ``mprotect``,
+``execve``, and ``uselib`` must have rules protecting them, they must simple know
+that they want to restrict code execution. This limits the amount of bypasses that
+could occur due to a lack of knowledge of the underlying system; whereas the
+maintainers of IPE, being kernel developers can make the correct choice to determine
+whether something maps to these operations, and under what conditions.
+
+Implementation Notes
+--------------------
+
+Anonymous Memory
+~~~~~~~~~~~~~~~~
+
+Anonymous memory isn't treated any differently from any other access in IPE.
+When anonymous memory is mapped with ``+X``, it still comes into the ``file_mmap``
+or ``file_mprotect`` hook, but with a ``NULL`` file object. This is submitted to
+the evaluation, like any other file, however, all current trust mechanisms will
+return false as there is nothing to evaluate. This means anonymous memory
+execution is subject to whatever the ``DEFAULT`` is for ``EXECUTE``.
+
+.. WARNING::
+
+  This also occurs with the ``kernel_load_data`` hook, which is used by signed
+  and compressed kernel modules. Using signed and compressed kernel modules with
+  IPE will always result in the ``DEFAULT`` action for ``KMODULE``.
+
+Securityfs Interface
+~~~~~~~~~~~~~~~~~~~~
+
+The per-policy securityfs tree is somewhat unique. For example, for
+a standard securityfs policy tree::
+
+  MyPolicy
+    |- active
+    |- delete
+    |- name
+    |- pkcs7
+    |- policy
+    |- update
+    |- version
+
+The policy is stored in the ``->i_private`` data of the MyPolicy inode.
+
+Tests
+-----
+
+IPE has KUnit Tests for the policy parser. Recommended kunitconfig::
+
+  CONFIG_KUNIT=y
+  CONFIG_SECURITY=y
+  CONFIG_SECURITYFS=y
+  CONFIG_PKCS7_MESSAGE_PARSER=y
+  CONFIG_SYSTEM_DATA_VERIFICATION=y
+  CONFIG_FS_VERITY=y
+  CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y
+  CONFIG_BLOCK=y
+  CONFIG_MD=y
+  CONFIG_BLK_DEV_DM=y
+  CONFIG_DM_VERITY=y
+  CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG=y
+  CONFIG_NET=y
+  CONFIG_AUDIT=y
+  CONFIG_AUDITSYSCALL=y
+  CONFIG_BLK_DEV_INITRD=y
+
+  CONFIG_SECURITY_IPE=y
+  CONFIG_IPE_PROP_DM_VERITY=y
+  CONFIG_IPE_PROP_FS_VERITY=y
+  CONFIG_SECURITY_IPE_KUNIT_TEST=y
+
+In addition, IPE has a python based integration
+`test suite <https://github.com/microsoft/ipe/tree/test-suite>`_ that
+can test both user interfaces and enforcement functionalities.
diff --git a/MAINTAINERS b/MAINTAINERS
index b2db91a215c6..110ca5a3d836 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10654,6 +10654,8 @@ M:	Fan Wu <wufan@linux.microsoft.com>
 L:	linux-security-module@vger.kernel.org
 S:	Supported
 T:	git https://github.com/microsoft/ipe.git
+F:	Documentation/admin-guide/LSM/ipe.rst
+F:	Documentation/security/ipe.rst
 F:	scripts/ipe/
 F:	security/ipe/
 
-- 
2.43.1


