Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD42682319
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Jan 2023 05:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjAaEAQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Jan 2023 23:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjAaEAO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Jan 2023 23:00:14 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5069166FF;
        Mon, 30 Jan 2023 20:00:04 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id m2so8805773plg.4;
        Mon, 30 Jan 2023 20:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nA0EIUAHwgO7ndVe4M7D/QYKBfvfNFS6L/m+DuzCtAQ=;
        b=kxWIHUJBuuB7136aV31CI/qnMQJBRr4mq6gGWJYJ1jh78mm69gWnSFmCg5PLGC73KV
         OsM2oS7kQAIBxev5O9qCHg0hoPrbzMeIEPn6QwaWhE9jECrs9n5UI7Glfl56BUV9pX/N
         RD0NLJfNvG4lGvfG0XzSKyE8IimShLDRPHuQT+zhNuoehveluDw6r88gS5N0xcnh5t1M
         AAljrVI5WX/s7wDLEM71WUldCZhU2u4JoPkGpCCCtnZ4zoHH4ulF0Gds6tkzuf12O2qT
         Li8ev9+MFW2b9m/hbkZ10UXairjgoCKXh9lN96gGxKW5SuUnmHDc8o/pmUk5GJOUbWgY
         pYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nA0EIUAHwgO7ndVe4M7D/QYKBfvfNFS6L/m+DuzCtAQ=;
        b=ffc5Wfw7k/Hg3lGdKI2QQFMua25hvcJzmmPCFEaOI2fiVrLuws3UXlBRXYGyGC9AwH
         mJaKoZTs8LcFQXsz9Wkb3RWtuKA76ONFw/03SOJuxo+En4xArOX+uSl1Gt1LTIVnusr2
         0PgbTuwJVtop/zCq6EjavMLLm6RsUwBu7OEKxJ0P10/6W5taQZDfgteZDBp+alU3NdpG
         /TJVAF9/bFAvrc2OP+FwoGteNA0ezNhko+g4Wa3T4nSdSwlu9M2yn7TzQOD227Eab8KV
         zKzlk/LbzT02MA92QH7xeC9vcrnhPLl8FggqAtBdqgis2TFD/2M5J7q+8rZ/LFAfxoBe
         gnbg==
X-Gm-Message-State: AFqh2kqzjDajB+uqGIkYfOYeUPvF3NRh2FWnZ56hwuFaOS3AcwLAaddD
        Fc/u3yZ3lDYnT7STV+k5ccE=
X-Google-Smtp-Source: AMrXdXvtLWrDd0ovPr2457iXzYxSwcw1Xicbx1ZLaPAvYn8zj1KXF7C7tG3InP8s7tfkTpB2QDLuFw==
X-Received: by 2002:a17:902:f78e:b0:194:85db:e20c with SMTP id q14-20020a170902f78e00b0019485dbe20cmr51042089pln.8.1675137603132;
        Mon, 30 Jan 2023 20:00:03 -0800 (PST)
Received: from debian.me (subs03-180-214-233-83.three.co.id. [180.214.233.83])
        by smtp.gmail.com with ESMTPSA id l10-20020a170902eb0a00b00196503444b0sm7382053plb.43.2023.01.30.20.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 20:00:02 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 97E15105433; Tue, 31 Jan 2023 10:59:59 +0700 (WIB)
Date:   Tue, 31 Jan 2023 10:59:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 16/16] documentation: add ipe documentation
Message-ID: <Y9iSP+RxY+1/o7PQ@debian.me>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-17-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5lN23sTtfzW6y4pB"
Content-Disposition: inline
In-Reply-To: <1675119451-23180-17-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


--5lN23sTtfzW6y4pB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 02:57:31PM -0800, Fan Wu wrote:
> diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-=
guide/LSM/ipe.rst
> new file mode 100644
> index 000000000000..b676cea62b2e
> --- /dev/null
> +++ b/Documentation/admin-guide/LSM/ipe.rst
> @@ -0,0 +1,729 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +Integrity Policy Enforcement (IPE)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +.. NOTE::
> +
> +   This is the documentation for admins, system builders, or individuals
> +   attempting to use IPE. If you're looking for more developer-focused
> +   documentation about IPE please see `Documentation/security/ipe.rst`
> +
> +Overview
> +--------
> +
> +IPE is a Linux Security Module which takes a complimentary approach to
> +access control. Whereas existing mandatory access control mechanisms
> +base their decisions on labels and paths, IPE instead determines
> +whether or not an operation should be allowed based on immutable
> +security properties of the system component the operation is being
> +performed on.
> +
> +IPE itself does not mandate how the security property should be
> +evaluated, but relies on an extensible set of external property providers
> +to evaluate the component. IPE makes its decision based on reference
> +values for the selected properties, specified in the IPE policy.
> +
> +The reference values represent the value that the policy writer and the
> +local system administrator (based on the policy signature) trust for the
> +system to accomplish the desired tasks.
> +
> +One such provider is for example dm-verity, which is able to represent
> +the integrity property of a partition (its immutable state) with a diges=
t.
> +
> +IPE is compiled under ``CONFIG_SECURITY_IPE`` (Security -> Integrity Pol=
icy Enforcement (IPE)).
> +
> +Use Cases
> +---------
> +
> +IPE works best in fixed-function devices: devices in which their purpose
> +is clearly defined and not supposed to be changed (e.g. network firewall
> +device in a data center, an IoT device, etcetera), where all software and
> +configuration is built and provisioned by the system owner.
> +
> +IPE is a long-way off for use in general-purpose computing: the Linux
> +community as a whole tends to follow a decentralized trust model,
> +known as the web of trust, which IPE has no support for as of yet.
> +
> +IPE, instead of supporting web of trust, supports PKI, which generally
> +designates a set of entities that provide a measure of absolute trust.
> +
> +Additionally, while most packages are signed today, the files inside
> +the packages (for instance, the executables), tend to be unsigned. This
> +makes it difficult to utilize IPE in systems where a package manager is
> +expected to be functional, without major changes to the package manager
> +and ecosystem behind it.
> +
> +DIGLIM [#diglim]_ is a system that when combined with IPE, could be used=
 to
> +enable general purpose computing scenarios.
> +
> +Known Gaps
> +----------
> +
> +IPE cannot verify the integrity of anonymous executable memory, such as
> +the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd co=
de.
> +Unfortunately, as this is dynamically generated code, there is no way
> +for IPE to ensure the integrity of this code to form a trust basis. In a=
ll
> +cases, the return result for these operations will be whatever the admin
> +configures as the ``DEFAULT`` action for ``EXECUTE``.
> +
> +IPE cannot verify the integrity of interpreted languages' programs when
> +these scripts are invoked via ``<interpreter> <file>``. This is because
> +the way interpreters execute these files, the scripts themselves are not
> +evaluated as executable code through one of IPE's hooks, as they are mer=
ely
> +files that are read (as opposed to executable code) [#interpreters]_.
> +
> +Threat Model
> +------------
> +
> +The threat type addressed by IPE is tampering of executable userspace
> +code beyond the initially booted kernel, and the initial verification of
> +kernel modules that are loaded in userspace through ``modprobe`` or
> +``insmod``.
> +
> +A bare-minimum example of a threat that should be mitigated by IPE, is
> +a hostile binary is downloaded with all required binaries (including
> +a loader, libc, etc). With IPE, this hostile binary should not able to
> +be executed, nor any of the downloaded binaries.
> +
> +Tampering violates integrity, and being unable to verify the integrity,
> +results in a lack of trust. IPE's role in mitigating this threat is to
> +verify the integrity (and authenticity) of all executable code and to
> +deny their use if they cannot be trusted (as integrity verification fail=
s,
> +or the authorization check fails against the reference value in the poli=
cy).
> +IPE generates audit logs which may be utilized to detect failures result=
ing
> +from failure to pass policy.
> +
> +Tampering threat scenarios include modification or replacement of
> +executable code by a range of actors including:
> +
> +-  Actors with physical access to the hardware
> +-  Actors with local network access to the system
> +-  Actors with access to the deployment system
> +-  Compromised internal systems under external control
> +-  Malicious end users of the system
> +-  Compromised end users of the system
> +-  Remote (external) compromise of the system
> +
> +IPE does not mitigate threats arising from malicious authorized
> +developers (with access to a signing certificate), or compromised
> +developer tools used by authorized developers (i.e. Return Oriented
> +Programming attacks). Additionally, IPE draws hard security boundary
> +between userspace and kernelspace. As a result, IPE does not provide
> +any protections against a kernel level exploit, and a kernel-level
> +exploit can disable or tamper with IPE's protections.
> +
> +Policy
> +------
> +
> +IPE policy is a plain-text [#devdoc]_ policy composed of multiple statem=
ents
> +over several lines. There is one required line, at the top of the
> +policy, indicating the policy name, and the policy version, for
> +instance::
> +
> +   policy_name=3DEx_Policy policy_version=3D0.0.0
> +
> +The policy name is a unique key identifying this policy in a human
> +readable name. This is used to create nodes under securityfs as well as
> +uniquely identify policies to deploy new policies vs update existing
> +policies.
> +
> +The policy version indicates the current version of the policy (NOT the
> +policy syntax version). This is used to prevent rollback of policy to
> +potentially insecure previous versions of the policy.
> +
> +The next portion of IPE policy are rules. Rules are formed by key=3Dvalue
> +pairs, known as properties. IPE rules require two properties: "action",
> +which determines what IPE does when it encounters a match against the
> +rule, and "op", which determines when that rule should be evaluated.
> +The ordering is significant, a rule must start with "op", and end with
> +"action". Thus, a minimal rule is::
> +
> +   op=3DEXECUTE action=3DALLOW
> +
> +This example will allow any execution. Additional properties are used to
> +restrict attributes about the files being evaluated. These properties
> +are intended to be descriptions of systems within the kernel that can
> +provide a measure of integrity verification, such that IPE can determine
> +the trust of the resource based on the "value" half of the property.
> +
> +Rules are evaluated top-to-bottom. As a result, any revocation rules,
> +or denies should be placed early in the file to ensure that these rules
> +are evaluated before a rule with "action=3DALLOW" is hit.
> +
> +IPE policy supports comments. The character '#' will function as a
> +comment, ignoring all characters to the right of '#' until the newline.
> +
> +The default behavior of IPE evaluations can also be expressed in policy,
> +through the ``DEFAULT`` statement. This can be done at a global level,
> +or a per-operation level::
> +
> +   # Global
> +   DEFAULT action=3DALLOW
> +
> +   # Operation Specific
> +   DEFAULT op=3DEXECUTE action=3DALLOW
> +
> +A default must be set for all known operations in IPE. If you want to
> +preserve older policies being compatible with newer kernels that can int=
roduce
> +new operations, please set a global default of 'ALLOW', and override the
> +defaults on a per-operation basis.
> +
> +With configurable policy-based LSMs, there's several issues with
> +enforcing the configurable policies at startup, around reading and
> +parsing the policy:
> +
> +1. The kernel *should* not read files from userspace, so directly reading
> +   the policy file is prohibited.
> +2. The kernel command line has a character limit, and one kernel module
> +   should not reserve the entire character limit for its own
> +   configuration.
> +3. There are various boot loaders in the kernel ecosystem, so handing
> +   off a memory block would be costly to maintain.
> +
> +As a result, IPE has addressed this problem through a concept of a "boot
> +policy". A boot policy is a minimal policy, compiled into the kernel.
> +This policy is intended to get the system to a state where userspace is
> +set up and ready to receive commands, at which point a more complex
> +policy can be deployed via securityfs. The boot policy can be specified
> +via the Kconfig, ``SECURITY_IPE_BOOT_POLICY``, which accepts a path to
> +a plain-text version of the IPE policy to apply. This policy will be
> +compiled into the kernel. If not specified, IPE will be disabled until
> +a policy is deployed and activated through securityfs.
> +
> +Deploying Policies
> +~~~~~~~~~~~~~~~~~~
> +
> +Policies can be deployed from userspace through securityfs. These polici=
es
> +are signed through the PKCS#7 message format to enforce some level of
> +authorization of the policies (prohibiting an attacker from gaining
> +unconstrained root, and deploying an "allow all" policy). These
> +policies must be signed by a certificate that chains to the
> +``SYSTEM_TRUSTED_KEYRING``. Through openssl, the signing can be done via=
::
> +
> +   openssl smime -sign \
> +      -in "$MY_POLICY" \
> +      -signer "$MY_CERTIFICATE" \
> +      -inkey "$MY_PRIVATE_KEY" \
> +      -noattr \
> +      -nodetach \
> +      -nosmimecap \
> +      -outform der \
> +      -out "$MY_POLICY.p7b"
> +
> +Deploying the policies is done through securityfs, through the
> +``new_policy`` node. To deploy a policy, simply cat the file into the
> +securityfs node::
> +
> +   cat "$MY_POLICY.p7b" > /sys/kernel/security/ipe/new_policy
> +
> +Upon success, this will create one subdirectory under
> +``/sys/kernel/security/ipe/policies/``. The subdirectory will be the
> +``policy_name`` field of the policy deployed, so for the example above,
> +the directory will be ``/sys/kernel/security/ipe/policies/Ex_Policy``.
> +Within this directory, there will be five files: ``pkcs7``, ``policy``,
> +``active``, ``update``, and ``delete``.
> +
> +The ``pkcs7`` file is read only. Reading will provide the raw PKCS#7 data
> +that was provided to the kernel, representing the policy. Writing, will
> +deploy an in-place policy update.If the policy being read is the boot
> +policy, when read, this will return ENOENT, as this policy is not signed.
> +
> +The ``policy`` file is read only. Reading will provide the PKCS#7 inner
> +content of the policy, which will be the plain text policy.
> +
> +The ``active`` file is used to set a policy as the currently active poli=
cy.
> +This file is rw, and accepts a value of ``"1"`` to set the policy as act=
ive.
> +Since only a single policy can be active at one time, all other policies
> +will be marked inactive. The policy being marked active must have a poli=
cy
> +version greater or equal to the currently-running version.
> +
> +The ``update`` file is used to update a policy that is already present in
> +the kernel. This file is write-only and accepts a PKCS#7 signed policy.
> +One check will always be performed on this policy: the policy_names must
> +match with the updated version and the existing version. One additional =
check
> +may be made: If the policy being updated is the active policy, the updat=
ed
> +policy must have a policy version greater than or equal to the currently=
-running
> +version; This is to prevent rollback attacks.
> +
> +The ``delete`` file is used to remove a policy that is no longer needed.
> +This file is write-only and accepts a value of ``1`` to delete the polic=
y.
> +On deletion, the securityfs node representing the policy will be removed.
> +The policy that is currently active cannot be deleted.
> +
> +Similarly, the writes to both ``update`` and ``new_policy`` above will
> +result in an error upon syntactically invalid or untrusted policies.
> +In the case of ``new_policy``, it will also error if a policy already
> +exists with the same ``policy_name``.
> +
> +Deploying these policies will *not* cause IPE to start enforcing this
> +policy. Once deployment is successful, a policy can be marked as active,
> +via ``/sys/kernel/security/ipe/$policy_name/active``. IPE will enforce
> +whatever policy is marked as active. For our example, we can activate
> +the ``Ex_Policy`` via::
> +
> +   echo 1 > "/sys/kernel/security/ipe/Ex_Policy/active"
> +
> +At which point, ``Ex_Policy`` will now be the enforced policy on the
> +system.
> +
> +IPE also provides a way to delete policies. This can be done via the
> +``delete`` securityfs node, ``/sys/kernel/security/ipe/$policy_name/dele=
te``.
> +Writing ``1`` to that file will delete that node::
> +
> +   echo 1 > "/sys/kernel/security/ipe/$policy_name/delete"
> +
> +There is only one requirement to delete a policy:
> +
> +1. The policy being deleted must not be the active policy.
> +
> +.. NOTE::
> +
> +   If a traditional MAC system is enabled (SELinux, apparmor, smack), all
> +   writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
> +
> +Modes
> +~~~~~
> +
> +IPE supports two modes of operation: permissive (similar to SELinux's
> +permissive mode) and enforce. Permissive mode performs the same checks
> +as enforce mode, and logs policy violations, but will not enforce the
> +policy. This allows users to test policies before enforcing them.
> +
> +The default mode is enforce, and can be changed via the kernel command
> +line parameter ``ipe.enforce=3D(0|1)``, or the securityfs node
> +``/sys/kernel/security/ipe/enforce``.
> +
> +.. NOTE::
> +
> +   If a traditional MAC system is enabled (SELinux, apparmor, smack, etc=
etera),
> +   all writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
> +
> +Audit Events
> +~~~~~~~~~~~~
> +
> +1420 AUDIT_IPE_ACCESS
> +^^^^^^^^^^^^^^^^^^^^^
> +Event Examples::
> +
> +   type=3D1420 audit(1653364370.067:61): path=3D"/root/fs/rw/plain/execv=
e" dev=3D"vdc1" ino=3D16 rule=3D"DEFAULT op=3DEXECUTE action=3DDENY"
> +   type=3D1300 audit(1653364370.067:61): arch=3Dc000003e syscall=3D10 su=
ccess=3Dno exit=3D-13 a0=3D7f0bf0644000 a1=3D4f80 a2=3D5 a3=3D7f0bf043d300 =
items=3D0 ppid=3D455 pid=3D737 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 f=
suid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3DttyS0 ses=3D3 comm=3D"mprotect" =
exe=3D"/root/host/mprotect" subj=3Dkernel key=3D(null)
> +   type=3D1327 audit(1653364370.067:61): proctitle=3D686F73742F6D70726F7=
465637400534800527C5700527C5800706C61696E2F657865637665
> +
> +   type=3D1420 audit(1653364735.161:64): rule=3D"DEFAULT op=3DEXECUTE ac=
tion=3DDENY"
> +   type=3D1300 audit(1653364735.161:64): arch=3Dc000003e syscall=3D9 suc=
cess=3Dno exit=3D-13 a0=3D0 a1=3D1000 a2=3D4 a3=3D20 items=3D0 ppid=3D455 p=
id=3D774 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3DttyS0 ses=3D3 comm=3D"mmap" exe=3D"/root/host/mmap" su=
bj=3Dkernel key=3D(null)
> +   type=3D1327 audit(1653364735.161:64): proctitle=3D686F73742F6D6D61700=
0410058=E2=8F=8E
> +
> +This event indicates that IPE made an access control decision; the IPE s=
pecific
> +record (1420) will always be emitted in conjunction with a ``AUDITSYSCAL=
L`` record.
> +
> +Determining whether IPE is in permissive can be derived from the success=
 and exit
> +field of the AUDITSYSCALL record
> +
> +
> +
> +Field descriptions:
> +
> ++---------------+------------+-----------+------------------------------=
-------------------------------------------+
> +| Field         | Value Type | Optional? | Description of Value         =
                                           |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> +| path          | string     | Yes       | The absolute path to the file=
 that was the subject of the evaluation    |
> ++---------------+------------+-----------+------------------------------=
-------------------------------------------+
> +| ino           | integer    | Yes       | The inode number of the file =
that was the subject of the evaluation     |
> ++---------------+------------+-----------+------------------------------=
-------------------------------------------+
> +| dev           | string     | Yes       | The device name that the file=
 under evaluation belongs to, e.g. vda     |
> ++---------------+------------+-----------+------------------------------=
-------------------------------------------+
> +| rule          | string     | No        | The exact rule in IPE's polic=
y that the evaluation matched              |
> ++---------------+------------+-----------+------------------------------=
-------------------------------------------+
> +
> +1403 AUDIT_MAC_POLICY_LOAD
> +^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Event Example::
> +
> +   type=3D1403 audit(1653425529.927:53): policy_name=3D"dmverity_roothas=
h" policy_version=3D0.0.0 sha256=3DDC67AC19E05894EFB3170A8E55DE529794E248C2=
 auid=3D4294967295 ses=3D4294967295 lsm=3Dipe res=3D1
> +   type=3D1300 audit(1653425529.927:53): arch=3Dc000003e syscall=3D1 suc=
cess=3Dyes exit=3D2567 a0=3D3 a1=3D5596fcae1fb0 a2=3Da07 a3=3D2 items=3D0 p=
pid=3D184 pid=3D229 auid=3D4294967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsu=
id=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D4294967295 comm=3D"pyth=
on3" exe=3D"/usr/bin/python3.10" key=3D(null)
> +   type=3D1327 audit(1653425529.927:53): PROCTITLE proctitle=3D707974686=
F6E3300746573742F6D61696E2E7079002D66002E2E
> +
> +This record will always be emitted in conjunction with a ``AUDITSYSCALL`=
` record for the ``write`` syscall.
> +
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| Field          | Value Type | Optional? | Description of Value        =
                                 |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D+
> +| policy_name    | string     | No        | The policy_name field of the=
 policy.                         |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| policy_version | string     | No        | The policy_version field of =
the policy                       |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| sha256         | string     | Yes*      | A flat hash of the policy. C=
an be used to identify a policy. |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| auid           | integer    | No        | The audit user ID.          =
                                 |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| ses            | integer    | No        | The session ID.             =
                                 |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| lsm            | string     | No        | The lsm name associated with=
 the event.                      |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +| res            | integer    | No        | The operation result.       =
                                 |
> ++----------------+------------+-----------+-----------------------------=
---------------------------------+
> +
> +1405 AUDIT_MAC_CONFIG_CHANGE
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Event Example::
> +
> +   type=3D1405 audit(1653425583.136:54): old_active_pol_name=3D"Allow_Al=
l" old_active_pol_version=3D0.0.0 old_sha256=3DDA39A3EE5E6B4B0D3255BFEF9560=
1890AFD80709 new_active_pol_name=3D"dmverity_roothash" new_active_pol_versi=
on=3D0.0.0 new_sha256=3DDC67AC19E05894EFB3170A8E55DE529794E248C2 auid=3D429=
4967295 ses=3D4294967295 lsm=3Dipe res=3D1
> +   type=3D1300 audit(1653425583.136:54): SYSCALL arch=3Dc000003e syscall=
=3D1 success=3Dyes exit=3D2 a0=3D3 a1=3D5596fcae1fb0 a2=3D2 a3=3D2 items=3D=
0 ppid=3D184 pid=3D229 auid=3D4294967295 uid=3D0 gid=3D0 euid=3D0 suid=3D0 =
fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D4294967295 comm=3D"p=
ython3" exe=3D"/usr/bin/python3.10" key=3D(null)
> +   type=3D1327 audit(1653425583.136:54): PROCTITLE proctitle=3D707974686=
F6E3300746573742F6D61696E2E7079002D66002E2
> +
> +This record will always be emitted in conjunction with a ``AUDITSYSCALL`=
` record for the ``write`` syscall.
> +
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| Field                  | Value Type | Optional? | Description of Value=
                               |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D+
> +| old_active_pol_name    | string     | No        | The policy_name fiel=
d of the old active policy.    |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| old_active_pol_version | string     | No        | The policy_version f=
ield of the old active policy. |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| old_sha256             | string     | Yes*      | A flat hash of the o=
ld active policy.              |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| new_active_pol_name    | string     | No        | The policy_name fiel=
d of the new active policy.    |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| new_active_pol_version | string     | No        | The policy_version f=
ield of the new active policy. |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| new_sha256             | string     | Yes*      | A flat hash of the n=
ew active policy.              |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| auid                   | integer    | No        | The audit user ID.  =
                               |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| ses                    | integer    | No        | The session ID.     =
                               |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| lsm                    | string     | No        | The lsm name associa=
ted with the event.            |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +| res                    | integer    | No        | The operation result=
=2E                              |
> ++------------------------+------------+-----------+---------------------=
-------------------------------+
> +
> +1404 AUDIT_MAC_STATUS
> +^^^^^^^^^^^^^^^^^^^^^
> +
> +Event Examples::
> +
> +   type=3D1404 audit(1653425689.008:55): permissive=3D1 auid=3D0 ses=3D4=
294967295 lsm=3Dipe res=3D1
> +   type=3D1300 audit(1653425689.008:55): arch=3Dc000003e syscall=3D1 suc=
cess=3Dyes exit=3D2 a0=3D1 a1=3D55c1065e5c60 a2=3D2 a3=3D0 items=3D0 ppid=
=3D405 pid=3D441 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=
=3D0 sgid=3D)
> +   type=3D1327 audit(1653425689.008:55): proctitle=3D"-bash"
> +
> +   type=3D1404 audit(1653425689.008:55): permissive=3D0 auid=3D0 ses=3D4=
294967295 lsm=3Dipe res=3D1
> +   type=3D1300 audit(1653425689.008:55): arch=3Dc000003e syscall=3D1 suc=
cess=3Dyes exit=3D2 a0=3D1 a1=3D55c1065e5c60 a2=3D2 a3=3D0 items=3D0 ppid=
=3D405 pid=3D441 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=
=3D0 sgid=3D)
> +   type=3D1327 audit(1653425689.008:55): proctitle=3D"-bash"
> +
> +This record will always be emitted in conjunction with a ``AUDITSYSCALL`=
` record for the ``write`` syscall.
> +
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +| Field      | Value Type | Optional? | Description of Value            =
                                  |
> ++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D+
> +| permissive | integer    | No        | The state IPE is being switched =
to. 1 is permissive, 0 is enforce |
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +| auid       | integer    | No        | The audit user ID.              =
                                  |
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +| ses        | integer    | No        | The session ID.                 =
                                  |
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +| lsm        | string     | No        | The lsm name associated with the=
 event.                           |
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +| res        | integer    | No        | The operation result.           =
                                  |
> ++------------+------------+-----------+---------------------------------=
----------------------------------+
> +
> +Success Auditing
> +^^^^^^^^^^^^^^^^
> +
> +IPE supports success auditing. When enabled, all events that pass IPE
> +policy and are not blocked will emit an audit event. This is disabled by
> +default, and can be enabled via the kernel command line
> +``ipe.success_audit=3D(0|1)`` or the securityfs node,
> +``/sys/kernel/security/ipe/success_audit``.
> +
> +This is *very* noisy, as IPE will check every userspace binary on the
> +system, but is useful for debugging policies.
> +
> +.. NOTE::
> +
> +   If a traditional MAC system is enabled (SELinux, apparmor, smack, etc=
etera),
> +   all writes to ipe's securityfs nodes require ``CAP_MAC_ADMIN``.
> +
> +Properties
> +----------
> +
> +As explained above, IPE properties are ``key=3Dvalue`` pairs expressed in
> +IPE policy. Two properties are built-into the policy parser: 'op' and
> +'action'. The other properties are determinstic attributes to express
> +across files. Currently those properties are: '``boot_verified``',
> +'``dmverity_signature``', '``dmverity_roothash``', '``fsverity_signature=
``',
> +'``fsverity_digest``'. A description of all properties supported by IPE
> +are listed below:
> +
> +op
> +~~
> +
> +Indicates the operation for a rule to apply to. Must be in every rule,
> +as the first token. IPE supports the following operations:
> +
> +   ``EXECUTE``
> +
> +      Pertains to any file attempting to be executed, or loaded as an
> +      executable.
> +
> +   ``FIRMWARE``:
> +
> +      Pertains to firmware being loaded via the firmware_class interface.
> +      This covers both the preallocated buffer and the firmware file
> +      itself.
> +
> +   ``KMODULE``:
> +
> +      Pertains to loading kernel modules via ``modprobe`` or ``insmod``.
> +
> +   ``KEXEC_IMAGE``:
> +
> +      Pertains to kernel images loading via ``kexec``.
> +
> +   ``KEXEC_INITRAMFS``
> +
> +      Pertains to initrd images loading via ``kexec --initrd``.
> +
> +   ``POLICY``:
> +
> +      Controls loading polcies via reading a kernel-space initiated read.
> +
> +      An example of such is loading IMA policies by writing the path
> +      to the policy file to ``$securityfs/ima/policy``
> +
> +   ``X509_CERT``:
> +
> +      Controls loading IMA certificates through the Kconfigs,
> +      ``CONFIG_IMA_X509_PATH`` and ``CONFIG_EVM_X509_PATH``.
> +
> +action
> +~~~~~~
> +
> +   Determines what IPE should do when a rule matches. Must be in every
> +   rule, as the final clause. Can be one of:
> +
> +   ``ALLOW``:
> +
> +      If the rule matches, explicitly allow access to the resource to pr=
oceed
> +      without executing any more rules.
> +
> +   ``DENY``:
> +
> +      If the rule matches, explicitly prohibit access to the resource to
> +      proceed without executing any more rules.
> +
> +boot_verified
> +~~~~~~~~~~~~~
> +
> +   This property can be utilized for authorization of the first super-bl=
ock
> +   that executes a file. This is almost always init. Typically this is u=
sed
> +   for systems with an initramfs or other initial disk, where this is un=
mounted
> +   before the system becomes available, and is not covered by any other =
property.
> +   The format of this property is::
> +
> +         boot_verified=3D(TRUE|FALSE)
> +
> +
> +   .. WARNING::
> +
> +      This property will trust any disk where the first execution evalua=
tion
> +      occurs. If you do *NOT* have a startup disk that is unpacked and u=
nmounted
> +      (like initramfs), then it will automatically trust the root filesy=
stem and
> +      potentially overauthorize the entire disk.
> +
> +dmverity_roothash
> +~~~~~~~~~~~~~~~~~
> +
> +   This property can be utilized for authorization or revocation of
> +   specific dm-verity volumes, identified via root hash. It has a
> +   dependency on the DM_VERITY module. This property is controlled by the
> +   Kconfig ``CONFIG_IPE_PROP_DM_VERITY``. The format of this property
> +   is::
> +
> +      dmverity_roothash=3DDigestName:HexadecimalString
> +
> +   The supported DigestNames for dmverity_roothash are [#dmveritydigests=
]_ [#securedigest]_ :
> +
> +      + blake2b-512
> +      + blake2s-256
> +      + sha1
> +      + sha256
> +      + sha384
> +      + sha512
> +      + sha3-224
> +      + sha3-256
> +      + sha3-384
> +      + sha3-512
> +      + md4
> +      + md5
> +      + sm3
> +      + rmd160
> +
> +dmverity_signature
> +~~~~~~~~~~~~~~~~~~
> +
> +   This property can be utilized for authorization of all dm-verity volu=
mes
> +   that have a signed roothash that chains to a keyring specified by dm-=
verity's
> +   configuration, either the system trusted keyring, or the secondary ke=
yring.
> +   It has an additional dependency on the ``DM_VERITY_VERIFY_ROOTHASH_SI=
G``
> +   Kconfig. This property is controlled by the Kconfig
> +   ``CONFIG_IPE_PROP_DM_VERITY``. The format of this property is::
> +
> +      dmverity_signature=3D(TRUE|FALSE)
> +
> +fsverity_digest
> +~~~~~~~~~~~~~~~
> +
> +   This property can be utilized for authorization or revocation of
> +   specific fsverity enabled file, identified via its fsverity digest.
> +   It has a dependency on the FS_VERITY module. This property is
> +   controlled by the Kconfig ``CONFIG_IPE_PROP_FS_VERITY``.
> +   The format of this property is::
> +
> +      fsverity_digest=3DDigestName:HexadecimalString
> +
> +   The supported DigestNames for dmverity_roothash are [#fsveritydigest]=
 [#securedigest]_ :
> +
> +      + sha256
> +      + sha512
> +
> +fsverity_signature
> +~~~~~~~~~~~~~~~~~~
> +
> +Version 1
> +
> +   This property can be utilized for authorization of all fsverity enabl=
ed
> +   files that is verified by fsverity. The keyring that the signature is
> +   verified against is subject to fsverity's configuration, typically th=
e fsverity
> +   keyring. It has a dependency on the ``CONFIG_FS_VERITY_BUILTIN_SIGNAT=
URES``
> +   Kconfig. This property is controlled by the Kconfig
> +   ``CONFIG_IPE_PROP_FS_VERITY``. The format of this property is::
> +
> +      fsverity_signature=3D(TRUE|FALSE)
> +
> +Policy Examples
> +---------------
> +
> +Allow all
> +~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllow_All policy_version=3D0.0.0
> +   DEFAULT action=3DALLOW
> +
> +Allow only initial superblock
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllow_All_Initial_SB policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
> +
> +Allow any signed dm-verity volume and the initial superblock
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllowSignedAndInitial policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
> +   op=3DEXECUTE dmverity_signature=3DTRUE action=3DALLOW
> +
> +Prohibit execution from a specific dm-verity volume
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllowSignedAndInitial policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE dmverity_roothash=3Dsha256:cd2c5bae7c6c579edaae4353049d5=
8eb5f2e8be0244bf05345bc8e5ed257baff action=3DDENY
> +
> +   op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
> +   op=3DEXECUTE dmverity_signature=3DTRUE action=3DALLOW
> +
> +Allow only a specific dm-verity volume
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllowSignedAndInitial policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE dmverity_roothash=3Dsha256:401fcec5944823ae12f62726e8184=
407a5fa9599783f030dec146938 action=3DALLOW
> +
> +Allow any signed fs-verity file
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DAllowSignedFSVerity policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE fsverity_signature=3DTRUE action=3DALLOW
> +
> +Prohibit execution of a specific fs-verity file
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +::
> +
> +   policy_name=3DProhibitSpecificFSVF policy_version=3D0.0.0
> +   DEFAULT action=3DDENY
> +
> +   op=3DEXECUTE fsverity_digest=3Dsha256:fd88f2b8824e197f850bf4c5109bea5=
cf0ee38104f710843bb72da796ba5af9e action=3DDENY
> +   op=3DEXECUTE boot_verified=3DTRUE action=3DALLOW
> +   op=3DEXECUTE dmverity_signature=3DTRUE action=3DALLOW
> +
> +Additional Information
> +----------------------
> +
> +- `Github Repository <https://github.com/microsoft/ipe>`_
> +- `Design Documentation </security/ipe>`_
> +
> +FAQ
> +---
> +
> +Q:
> +   What's the difference between other LSMs which provide a measure of
> +   trust-based access control?
> +
> +A:
> +
> +   In general, there's two other LSMs that can provide similar functiona=
lity:
> +   IMA, and Loadpin.
> +
> +   IMA and IPE are functionally very similar. The significant difference=
 between
> +   the two is the policy. [#devdoc]_
> +
> +   Loadpin and IPE differ fairly dramatically, as Loadpin controls only =
the IPE
> +   equivalent of ``KERNEL_READ``, whereas IPE is capable of controlling =
execution,
> +   on top of ``KERNEL_READ``. The trust model is also different; Loadpin=
 roots its
> +   trust in the initial super-block, instead, IPE roots its trust in the=
 kernel
> +   itself (via ``SYSTEM_TRUSTED_KEYS``).
> +
> +-----------
> +
> +.. [#diglim] 1: https://lore.kernel.org/bpf/4d6932e96d774227b42721d9f645=
ba51@huawei.com/T/
> +
> +.. [#interpreters] There is `some interest in solving this issue <https:=
//lore.kernel.org/lkml/20220321161557.495388-1-mic@digikod.net/>`_.
> +
> +.. [#devdoc] Please see `Documentation/security/ipe.rst` for more on thi=
s topic.
> +
> +.. [#fsveritydigest] These hash algorithms are based on values accepted =
by fsverity-utils;
> +                     IPE does not impose any restrictions on the digest =
algorithm itself;
> +                     thus, this list may be out of date.
> +
> +.. [#dmveritydigests] These hash algorithms are based on values accepted=
 by dm-verity,
> +                      specifically ``crypto_alloc_ahash`` in ``verity_ct=
r``; ``veritysetup``
> +                      does support more algorithms than the list above. =
IPE does not impose
> +                      any restrictions on the digest algorithm itself; t=
hus, this list
> +                      may be out of date.
> +
> +.. [#securedigest] Please ensure you are using cryptographically secure =
hash functions;
> +                   just because something is *supported* does not mean i=
t is *secure*.

What about wordings below instead?

---- >8 ----
diff --git a/Documentation/admin-guide/LSM/ipe.rst b/Documentation/admin-gu=
ide/LSM/ipe.rst
index b676cea62b2e74..8b1d4eb0ebf19f 100644
--- a/Documentation/admin-guide/LSM/ipe.rst
+++ b/Documentation/admin-guide/LSM/ipe.rst
@@ -31,7 +31,9 @@ system to accomplish the desired tasks.
 One such provider is for example dm-verity, which is able to represent
 the integrity property of a partition (its immutable state) with a digest.
=20
-IPE is compiled under ``CONFIG_SECURITY_IPE`` (Security -> Integrity Polic=
y Enforcement (IPE)).
+To enable IPE, ensure that ``CONFIG_SECURITY_IPE`` (under
+:menuselection:`Security -> Integrity Policy Enforcement (IPE)`) config
+option is enabled.
=20
 Use Cases
 ---------
@@ -42,11 +44,10 @@ device in a data center, an IoT device, etcetera), wher=
e all software and
 configuration is built and provisioned by the system owner.
=20
 IPE is a long-way off for use in general-purpose computing: the Linux
-community as a whole tends to follow a decentralized trust model,
-known as the web of trust, which IPE has no support for as of yet.
-
-IPE, instead of supporting web of trust, supports PKI, which generally
-designates a set of entities that provide a measure of absolute trust.
+community as a whole tends to follow a decentralized trust model (known as
+the web of trust), which IPE has no support for it yet. Instead, IPE
+supports PKI (public key infrastructure), which generally designates a
+set of trusted entities that provide a measure of absolute trust.
=20
 Additionally, while most packages are signed today, the files inside
 the packages (for instance, the executables), tend to be unsigned. This
@@ -55,10 +56,10 @@ expected to be functional, without major changes to the=
 package manager
 and ecosystem behind it.
=20
 DIGLIM [#diglim]_ is a system that when combined with IPE, could be used to
-enable general purpose computing scenarios.
+enable and support general-purpose computing use cases.
=20
-Known Gaps
-----------
+Known Limitations
+-----------------
=20
 IPE cannot verify the integrity of anonymous executable memory, such as
 the trampolines created by gcc closures and libffi (<3.4.2), or JIT'd code.
@@ -67,11 +68,12 @@ for IPE to ensure the integrity of this code to form a =
trust basis. In all
 cases, the return result for these operations will be whatever the admin
 configures as the ``DEFAULT`` action for ``EXECUTE``.
=20
-IPE cannot verify the integrity of interpreted languages' programs when
-these scripts are invoked via ``<interpreter> <file>``. This is because
-the way interpreters execute these files, the scripts themselves are not
-evaluated as executable code through one of IPE's hooks, as they are merely
-files that are read (as opposed to executable code) [#interpreters]_.
+IPE cannot verify the integrity of programs written in interpreted
+languages when these scripts are invoked by passing these program files
+to the interpreter. This is because the way interpreters execute these
+files; the scripts themselves are not evaluated as executable code
+through one of IPE's hooks, but they are merely text files that are read
+(as opposed to compiled executables) [#interpreters]_.
=20
 Threat Model
 ------------
@@ -82,17 +84,19 @@ kernel modules that are loaded in userspace through ``m=
odprobe`` or
 ``insmod``.
=20
 A bare-minimum example of a threat that should be mitigated by IPE, is
-a hostile binary is downloaded with all required binaries (including
-a loader, libc, etc). With IPE, this hostile binary should not able to
-be executed, nor any of the downloaded binaries.
+an untrusted (potentially malicious) binary that is downloaded and
+bundled with all required dependencies (including a loader, libc, etc).
+With IPE, this binary should not be allowed to be executed, not even any
+of its dependencies.
=20
-Tampering violates integrity, and being unable to verify the integrity,
-results in a lack of trust. IPE's role in mitigating this threat is to
-verify the integrity (and authenticity) of all executable code and to
-deny their use if they cannot be trusted (as integrity verification fails,
-or the authorization check fails against the reference value in the policy=
).
-IPE generates audit logs which may be utilized to detect failures resulting
-from failure to pass policy.
+Tampering violates integrity, yet lack of trust is caused by being
+unable to detect tampering (and by extent verifying the integrity).
+IPE's role in mitigating this threat is to verify the integrity (and
+authenticity) of all executable code and to deny their use if they
+cannot be trusted (as integrity verification fails, or the authorization
+check fails against the reference value in the policy). IPE generates
+audit logs which may be utilized to detect and analyze failures
+resulting from policy violation.
=20
 Tampering threat scenarios include modification or replacement of
 executable code by a range of actors including:
@@ -105,13 +109,13 @@ executable code by a range of actors including:
 -  Compromised end users of the system
 -  Remote (external) compromise of the system
=20
-IPE does not mitigate threats arising from malicious authorized
+IPE does not mitigate threats arising from malicious but authorized
 developers (with access to a signing certificate), or compromised
-developer tools used by authorized developers (i.e. Return Oriented
-Programming attacks). Additionally, IPE draws hard security boundary
-between userspace and kernelspace. As a result, IPE does not provide
-any protections against a kernel level exploit, and a kernel-level
-exploit can disable or tamper with IPE's protections.
+developer tools used by them (i.e. return-oriented programming attacks).
+Additionally, IPE draws hard security boundary between userspace and
+kernelspace. As a result, IPE does not provide any protections against a
+kernel level exploit, and a kernel-level exploit can disable or tamper
+with IPE's protections.
=20
 Policy
 ------
@@ -133,11 +137,11 @@ policy syntax version). This is used to prevent rollb=
ack of policy to
 potentially insecure previous versions of the policy.
=20
 The next portion of IPE policy are rules. Rules are formed by key=3Dvalue
-pairs, known as properties. IPE rules require two properties: "action",
+pairs, known as properties. IPE rules require two properties: ``action``,
 which determines what IPE does when it encounters a match against the
-rule, and "op", which determines when that rule should be evaluated.
-The ordering is significant, a rule must start with "op", and end with
-"action". Thus, a minimal rule is::
+rule, and ``op``, which determines when the rule should be evaluated.
+The ordering is significant, a rule must start with ``op``, and end with
+``action``. Thus, a minimal rule is::
=20
    op=3DEXECUTE action=3DALLOW
=20
@@ -145,14 +149,14 @@ This example will allow any execution. Additional pro=
perties are used to
 restrict attributes about the files being evaluated. These properties
 are intended to be descriptions of systems within the kernel that can
 provide a measure of integrity verification, such that IPE can determine
-the trust of the resource based on the "value" half of the property.
+the trust of the resource based on the value of the property.
=20
 Rules are evaluated top-to-bottom. As a result, any revocation rules,
 or denies should be placed early in the file to ensure that these rules
-are evaluated before a rule with "action=3DALLOW" is hit.
+are evaluated before a rule with ``action=3DALLOW``.
=20
-IPE policy supports comments. The character '#' will function as a
-comment, ignoring all characters to the right of '#' until the newline.
+IPE policy supports comments. Any line which is prefixed with ``#`` will
+be ignored.
=20
 The default behavior of IPE evaluations can also be expressed in policy,
 through the ``DEFAULT`` statement. This can be done at a global level,
@@ -166,8 +170,8 @@ or a per-operation level::
=20
 A default must be set for all known operations in IPE. If you want to
 preserve older policies being compatible with newer kernels that can intro=
duce
-new operations, please set a global default of 'ALLOW', and override the
-defaults on a per-operation basis.
+new operations, set a global default of ``ALLOW``, then override the
+defaults on a per-operation basis (as above).
=20
 With configurable policy-based LSMs, there's several issues with
 enforcing the configurable policies at startup, around reading and
@@ -182,14 +186,14 @@ parsing the policy:
    off a memory block would be costly to maintain.
=20
 As a result, IPE has addressed this problem through a concept of a "boot
-policy". A boot policy is a minimal policy, compiled into the kernel.
-This policy is intended to get the system to a state where userspace is
-set up and ready to receive commands, at which point a more complex
-policy can be deployed via securityfs. The boot policy can be specified
-via the Kconfig, ``SECURITY_IPE_BOOT_POLICY``, which accepts a path to
-a plain-text version of the IPE policy to apply. This policy will be
-compiled into the kernel. If not specified, IPE will be disabled until
-a policy is deployed and activated through securityfs.
+policy". A boot policy is a minimal policy which is compiled into the
+kernel. This policy is intended to get the system to a state where
+userspace is set up and ready to receive commands, at which point a more
+complex policy can be deployed via securityfs. The boot policy can be
+specified via ``SECURITY_IPE_BOOT_POLICY`` config option, which accepts
+a path to a plain-text version of the IPE policy to apply. This policy
+will be compiled into the kernel. If not specified, IPE will be disabled
+until a policy is deployed and activated through securityfs.
=20
 Deploying Policies
 ~~~~~~~~~~~~~~~~~~
@@ -199,7 +203,7 @@ are signed through the PKCS#7 message format to enforce=
 some level of
 authorization of the policies (prohibiting an attacker from gaining
 unconstrained root, and deploying an "allow all" policy). These
 policies must be signed by a certificate that chains to the
-``SYSTEM_TRUSTED_KEYRING``. Through openssl, the signing can be done via::
+``SYSTEM_TRUSTED_KEYRING``. With openssl, the policy can be signed by::
=20
    openssl smime -sign \
       -in "$MY_POLICY" \
@@ -224,12 +228,12 @@ the directory will be ``/sys/kernel/security/ipe/poli=
cies/Ex_Policy``.
 Within this directory, there will be five files: ``pkcs7``, ``policy``,
 ``active``, ``update``, and ``delete``.
=20
-The ``pkcs7`` file is read only. Reading will provide the raw PKCS#7 data
+The ``pkcs7`` file is read-only. Reading it returns the raw PKCS#7 data
 that was provided to the kernel, representing the policy. Writing, will
-deploy an in-place policy update.If the policy being read is the boot
-policy, when read, this will return ENOENT, as this policy is not signed.
+deploy an in-place policy update. If the policy being read is the boot
+policy, this will return ``ENOENT``, as it is is not signed.
=20
-The ``policy`` file is read only. Reading will provide the PKCS#7 inner
+The ``policy`` file is read-only. Reading it returns the PKCS#7 inner
 content of the policy, which will be the plain text policy.
=20
 The ``active`` file is used to set a policy as the currently active policy.
@@ -238,44 +242,42 @@ Since only a single policy can be active at one time,=
 all other policies
 will be marked inactive. The policy being marked active must have a policy
 version greater or equal to the currently-running version.
=20
-The ``update`` file is used to update a policy that is already present in
-the kernel. This file is write-only and accepts a PKCS#7 signed policy.
-One check will always be performed on this policy: the policy_names must
-match with the updated version and the existing version. One additional ch=
eck
-may be made: If the policy being updated is the active policy, the updated
-policy must have a policy version greater than or equal to the currently-r=
unning
-version; This is to prevent rollback attacks.
+The ``update`` file is used to update a policy that is already present
+in the kernel. This file is write-only and accepts a PKCS#7 signed
+policy. One check will always be performed on this policy: the
+``policy_names`` must match with the updated version and the existing
+version. There is also an additional check: if the policy being updated
+is the active policy, the updated policy must have a policy version
+greater than or equal to the currently-running version. This is to
+prevent rollback attacks.
=20
 The ``delete`` file is used to remove a policy that is no longer needed.
 This file is write-only and accepts a value of ``1`` to delete the policy.
 On deletion, the securityfs node representing the policy will be removed.
 The policy that is currently active cannot be deleted.
=20
-Similarly, the writes to both ``update`` and ``new_policy`` above will
-result in an error upon syntactically invalid or untrusted policies.
-In the case of ``new_policy``, it will also error if a policy already
-exists with the same ``policy_name``.
+Similarly, writing to both ``update`` and ``new_policy`` results in
+syntax or untrusted policy error. In the case of the latter, it will
+also error out if a policy already exists with the same ``policy_name``.
=20
 Deploying these policies will *not* cause IPE to start enforcing this
-policy. Once deployment is successful, a policy can be marked as active,
-via ``/sys/kernel/security/ipe/$policy_name/active``. IPE will enforce
-whatever policy is marked as active. For our example, we can activate
-the ``Ex_Policy`` via::
+policy. Once deployment is successful, a policy can be activated, by
+``/sys/kernel/security/ipe/$policy_name/active``. IPE will enforce
+active policies. For example, the ``Ex_Policy`` can be activated by::
=20
    echo 1 > "/sys/kernel/security/ipe/Ex_Policy/active"
=20
-At which point, ``Ex_Policy`` will now be the enforced policy on the
+From above point on, ``Ex_Policy`` is now the enforced policy on the
 system.
=20
 IPE also provides a way to delete policies. This can be done via the
 ``delete`` securityfs node, ``/sys/kernel/security/ipe/$policy_name/delete=
``.
-Writing ``1`` to that file will delete that node::
+Writing ``1`` to that file deletes the policy::
=20
    echo 1 > "/sys/kernel/security/ipe/$policy_name/delete"
=20
-There is only one requirement to delete a policy:
-
-1. The policy being deleted must not be the active policy.
+There is only one requirement to delete a policy: the policy being deleted
+must be inactive.
=20
 .. NOTE::
=20
@@ -286,9 +288,9 @@ Modes
 ~~~~~
=20
 IPE supports two modes of operation: permissive (similar to SELinux's
-permissive mode) and enforce. Permissive mode performs the same checks
-as enforce mode, and logs policy violations, but will not enforce the
-policy. This allows users to test policies before enforcing them.
+permissive mode) and enforced. In permissive mode, all events are
+checked and policy violations are logged, but the policy is not really
+enforced. This allows users to test policies before enforcing them.
=20
 The default mode is enforce, and can be changed via the kernel command
 line parameter ``ipe.enforce=3D(0|1)``, or the securityfs node
@@ -314,11 +316,12 @@ Event Examples::
    type=3D1300 audit(1653364735.161:64): arch=3Dc000003e syscall=3D9 succe=
ss=3Dno exit=3D-13 a0=3D0 a1=3D1000 a2=3D4 a3=3D20 items=3D0 ppid=3D455 pid=
=3D774 auid=3D0 uid=3D0 gid=3D0 euid=3D0 suid=3D0 fsuid=3D0 egid=3D0 sgid=
=3D0 fsgid=3D0 tty=3DttyS0 ses=3D3 comm=3D"mmap" exe=3D"/root/host/mmap" su=
bj=3Dkernel key=3D(null)
    type=3D1327 audit(1653364735.161:64): proctitle=3D686F73742F6D6D6170004=
10058=E2=8F=8E
=20
-This event indicates that IPE made an access control decision; the IPE spe=
cific
-record (1420) will always be emitted in conjunction with a ``AUDITSYSCALL`=
` record.
+This event indicates that IPE made an access control decision; the IPE
+specific record (1420) is always emitted in conjunction with a
+``AUDITSYSCALL`` record.
=20
-Determining whether IPE is in permissive can be derived from the success a=
nd exit
-field of the AUDITSYSCALL record
+Determining whether IPE is in permissive or enforced mode can be derived
+from ``success`` property and exit code of the ``AUDITSYSCALL`` record.
=20
=20
=20
@@ -327,13 +330,13 @@ Field descriptions:
 +---------------+------------+-----------+--------------------------------=
-----------------------------------------+
 | Field         | Value Type | Optional? | Description of Value           =
                                         |
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
-| path          | string     | Yes       | The absolute path to the file t=
hat was the subject of the evaluation    |
+| path          | string     | Yes       | The absolute path to the evalua=
ted file                                 |
 +---------------+------------+-----------+--------------------------------=
-----------------------------------------+
-| ino           | integer    | Yes       | The inode number of the file th=
at was the subject of the evaluation     |
+| ino           | integer    | Yes       | The inode number of the evaluat=
ed file                                  |
 +---------------+------------+-----------+--------------------------------=
-----------------------------------------+
-| dev           | string     | Yes       | The device name that the file u=
nder evaluation belongs to, e.g. vda     |
+| dev           | string     | Yes       | The device name of the evaluate=
d file, e.g. vda                         |
 +---------------+------------+-----------+--------------------------------=
-----------------------------------------+
-| rule          | string     | No        | The exact rule in IPE's policy =
that the evaluation matched              |
+| rule          | string     | No        | The matched policy rule        =
                                         |
 +---------------+------------+-----------+--------------------------------=
-----------------------------------------+
=20
 1403 AUDIT_MAC_POLICY_LOAD
@@ -350,11 +353,11 @@ This record will always be emitted in conjunction wit=
h a ``AUDITSYSCALL`` record
 +----------------+------------+-----------+-------------------------------=
-------------------------------+
 | Field          | Value Type | Optional? | Description of Value          =
                               |
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D+
-| policy_name    | string     | No        | The policy_name field of the p=
olicy.                         |
+| policy_name    | string     | No        | The policy name               =
                               |
 +----------------+------------+-----------+-------------------------------=
-------------------------------+
-| policy_version | string     | No        | The policy_version field of th=
e policy                       |
+| policy_version | string     | No        | The policy version            =
                               |
 +----------------+------------+-----------+-------------------------------=
-------------------------------+
-| sha256         | string     | Yes*      | A flat hash of the policy. Can=
 be used to identify a policy. |
+| sha256         | string     | Yes*      | The policy hash               =
                               |
 +----------------+------------+-----------+-------------------------------=
-------------------------------+
 | auid           | integer    | No        | The audit user ID.            =
                               |
 +----------------+------------+-----------+-------------------------------=
-------------------------------+
@@ -379,17 +382,17 @@ This record will always be emitted in conjunction wit=
h a ``AUDITSYSCALL`` record
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
 | Field                  | Value Type | Optional? | Description of Value  =
                             |
 +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+
-| old_active_pol_name    | string     | No        | The policy_name field =
of the old active policy.    |
+| old_active_pol_name    | string     | No        | The name of previous a=
ctive policy                 |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
-| old_active_pol_version | string     | No        | The policy_version fie=
ld of the old active policy. |
+| old_active_pol_version | string     | No        | The version of previou=
s active policy              |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
-| old_sha256             | string     | Yes*      | A flat hash of the old=
 active policy.              |
+| old_sha256             | string     | Yes*      | The hash of previous a=
ctive policy                 |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
-| new_active_pol_name    | string     | No        | The policy_name field =
of the new active policy.    |
+| new_active_pol_name    | string     | No        | The name of current ac=
tive policy                  |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
-| new_active_pol_version | string     | No        | The policy_version fie=
ld of the new active policy. |
+| new_active_pol_version | string     | No        | The version of current=
 active policy               |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
-| new_sha256             | string     | Yes*      | A flat hash of the new=
 active policy.              |
+| new_sha256             | string     | Yes*      | The hash of current ac=
tive policy                  |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
 | auid                   | integer    | No        | The audit user ID.    =
                             |
 +------------------------+------------+-----------+-----------------------=
-----------------------------+
@@ -415,19 +418,19 @@ Event Examples::
=20
 This record will always be emitted in conjunction with a ``AUDITSYSCALL`` =
record for the ``write`` syscall.
=20
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
-| Field      | Value Type | Optional? | Description of Value              =
                                |
-+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D+
-| permissive | integer    | No        | The state IPE is being switched to=
=2E 1 is permissive, 0 is enforce |
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
-| auid       | integer    | No        | The audit user ID.                =
                                |
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
-| ses        | integer    | No        | The session ID.                   =
                                |
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
-| lsm        | string     | No        | The lsm name associated with the e=
vent.                           |
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
-| res        | integer    | No        | The operation result.             =
                                |
-+------------+------------+-----------+-----------------------------------=
--------------------------------+
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
+| Field      | Value Type | Optional? | Description of Value              =
                                                  |
++=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
+| permissive | integer    | No        | The state IPE is being switched to=
=2E 1 is in permissive mode; 0 is in enforced mode. |
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
+| auid       | integer    | No        | The audit user ID.                =
                                                  |
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
+| ses        | integer    | No        | The session ID.                   =
                                                  |
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
+| lsm        | string     | No        | The lsm name associated with the e=
vent.                                             |
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
+| res        | integer    | No        | The operation result.             =
                                                  |
++------------+------------+-----------+-----------------------------------=
--------------------------------------------------+
=20
 Success Auditing
 ^^^^^^^^^^^^^^^^
@@ -435,8 +438,8 @@ Success Auditing
 IPE supports success auditing. When enabled, all events that pass IPE
 policy and are not blocked will emit an audit event. This is disabled by
 default, and can be enabled via the kernel command line
-``ipe.success_audit=3D(0|1)`` or the securityfs node,
-``/sys/kernel/security/ipe/success_audit``.
+``ipe.success_audit=3D(0|1)`` or
+``/sys/kernel/security/ipe/success_audit`` securityfs file.
=20
 This is *very* noisy, as IPE will check every userspace binary on the
 system, but is useful for debugging policies.
@@ -538,9 +541,9 @@ dmverity_roothash
=20
    This property can be utilized for authorization or revocation of
    specific dm-verity volumes, identified via root hash. It has a
-   dependency on the DM_VERITY module. This property is controlled by the
-   Kconfig ``CONFIG_IPE_PROP_DM_VERITY``. The format of this property
-   is::
+   dependency on the DM_VERITY module. This property is controlled by
+   the ``CONFIG_IPE_PROP_DM_VERITY`` config option. The format of this
+   property is::
=20
       dmverity_roothash=3DDigestName:HexadecimalString
=20
@@ -564,11 +567,11 @@ dmverity_roothash
 dmverity_signature
 ~~~~~~~~~~~~~~~~~~
=20
-   This property can be utilized for authorization of all dm-verity volumes
-   that have a signed roothash that chains to a keyring specified by dm-ve=
rity's
-   configuration, either the system trusted keyring, or the secondary keyr=
ing.
-   It has an additional dependency on the ``DM_VERITY_VERIFY_ROOTHASH_SIG``
-   Kconfig. This property is controlled by the Kconfig
+   This property can be utilized for authorization of all dm-verity
+   volumes that have a signed roothash that chains to a keyring
+   specified by dm-verity's configuration, either the system trusted
+   keyring, or the secondary keyring. It depends on
+   ``DM_VERITY_VERIFY_ROOTHASH_SIG`` config option and is controlled by
    ``CONFIG_IPE_PROP_DM_VERITY``. The format of this property is::
=20
       dmverity_signature=3D(TRUE|FALSE)
@@ -578,9 +581,8 @@ fsverity_digest
=20
    This property can be utilized for authorization or revocation of
    specific fsverity enabled file, identified via its fsverity digest.
-   It has a dependency on the FS_VERITY module. This property is
-   controlled by the Kconfig ``CONFIG_IPE_PROP_FS_VERITY``.
-   The format of this property is::
+   It depends on ``FS_VERITY`` config option and is controlled by
+   ``CONFIG_IPE_PROP_FS_VERITY``. The format of this property is::
=20
       fsverity_digest=3DDigestName:HexadecimalString
=20
@@ -594,12 +596,13 @@ fsverity_signature
=20
 Version 1
=20
-   This property can be utilized for authorization of all fsverity enabled
-   files that is verified by fsverity. The keyring that the signature is
-   verified against is subject to fsverity's configuration, typically the =
fsverity
-   keyring. It has a dependency on the ``CONFIG_FS_VERITY_BUILTIN_SIGNATUR=
ES``
-   Kconfig. This property is controlled by the Kconfig
-   ``CONFIG_IPE_PROP_FS_VERITY``. The format of this property is::
+   This property can be utilized for authorization of all fsverity
+   enabled files that is verified by fsverity. The keyring that the
+   signature is verified against is subject to fsverity's configuration,
+   typically the fsverity keyring. It depends on
+   ``CONFIG_FS_VERITY_BUILTIN_SIGNATURES`` is controlled controlled by
+   the Kconfig ``CONFIG_IPE_PROP_FS_VERITY``. The format of this
+   property is::
=20
       fsverity_signature=3D(TRUE|FALSE)
=20
@@ -704,7 +707,7 @@ A:
    Loadpin and IPE differ fairly dramatically, as Loadpin controls only th=
e IPE
    equivalent of ``KERNEL_READ``, whereas IPE is capable of controlling ex=
ecution,
    on top of ``KERNEL_READ``. The trust model is also different; Loadpin r=
oots its
-   trust in the initial super-block, instead, IPE roots its trust in the k=
ernel
+   trust in the initial super-block, whereas trust in IPE is stemmed from =
kernel
    itself (via ``SYSTEM_TRUSTED_KEYS``).
=20
 -----------

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--5lN23sTtfzW6y4pB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9iSOwAKCRD2uYlJVVFO
o/10AP90cKboFSr4kgFDFSX2M/f/7J1/taridjPO7m9iHnLpxQD/eyYvB3ksQP36
j/V0Z/HQ8n8dpiLk+ULcRnqOrwwCowk=
=0cU9
-----END PGP SIGNATURE-----

--5lN23sTtfzW6y4pB--
