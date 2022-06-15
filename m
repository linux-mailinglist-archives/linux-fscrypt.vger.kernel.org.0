Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED89954D44F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Jun 2022 00:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349985AbiFOWMu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Jun 2022 18:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348025AbiFOWMs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Jun 2022 18:12:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC34261D
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Jun 2022 15:12:45 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c130-20020a1c3588000000b0039c6fd897b4so1871867wma.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Jun 2022 15:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSOtOkDkOk9qsY6xSh9C/I7r4Ll5CO5SNVnf8+8fJm0=;
        b=UGz4voZkiYy2T1jZPCUpGwAq8DWUs1C10ptp/RCma4DWeZy77DPwl5Fi5TlHWsTS3s
         ZVZVWouQcfJ/+MrVbre3b1AYiaNA21W3eI9Xj6/UMq8pMkj7UwYOmGWsU5ZxDtuyqK69
         xDxNV/+v4NclAPEaAHP/4WVyH36VRpCp0/XvHkehcXID6/N7MSP08odeL5vupooC4s3k
         xciPfwe4xpQtVOnKyjPBEaZh4gvBybKAP+QK4+v1hK8sp9ifCkNS0gH9ZdW8EGKar+7a
         /KgQB2dr3NEzAdaghURBtI0tGCPtUwNvJXo2vyTh3FJXMLo/gVLVKZZ82CpV9k8iMGs/
         lydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSOtOkDkOk9qsY6xSh9C/I7r4Ll5CO5SNVnf8+8fJm0=;
        b=yD0YqJCthQSc64gIWvokYIzRgYrPLTF7fTnm7J83olmOxMebBuMvUD8F9//oDIZRHm
         5xH/ybwdVdZ41DBBz9JT9mAyEH1Pxg5pOd0TWGKC1JVzPrXR7705Zm71wDHEahTVzuBd
         6Y/kSjX2up1Y21D08dy9S37Dr++PHziM+WM4MIXYlNgonuvD0KE3w7bU3G84bGy/NCEe
         8KXWX30/pxk1l7kx8sUpmpiKDIWgkQmsKZF7+77AAdHXQ28KZfPAtyHF7GNtJJzvt37X
         VexzWCMxseHGWSUQzXM0o1eJnSqdA9b8u1uOZKmU1UMHCeAd+58uuDJqmGQjqkuqdTO3
         aBmA==
X-Gm-Message-State: AJIora9/Yz2kWyg2BrmKPCpnJvmLy9QxmBKcSlzonh8SgxSZ6U05FsQJ
        zmjohIrmSJOSasnic20N5B7CDGWxAgraNnnHIym7
X-Google-Smtp-Source: AGRyM1u8WHYJxyChRm93HhK2qOXy/iIT8DfeKlH463+I0qcRUIk50BumzQ3i3t1k/DfR1laWs4EYR2MJ1g0kM5yv8Zw=
X-Received: by 2002:a7b:c38b:0:b0:39c:6964:34a2 with SMTP id
 s11-20020a7bc38b000000b0039c696434a2mr1587311wmj.165.1655331164083; Wed, 15
 Jun 2022 15:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-8-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1654714889-26728-8-git-send-email-deven.desai@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 15 Jun 2022 18:12:33 -0400
Message-ID: <CAHC9VhRYE_YFpD5BwwFaNmvSbLDnvvQKO6zNUqAkxLu1aSwuGw@mail.gmail.com>
Subject: Re: [RFC PATCH v8 07/17] ipe: add auditing support
To:     Deven Bowers <deven.desai@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 8, 2022 at 3:01 PM Deven Bowers
<deven.desai@linux.microsoft.com> wrote:
>
> Users of IPE require a way to identify when and why an operation fails,
> allowing them to both respond to violations of policy and be notified
> of potentially malicious actions on their systens with respect to IPE
> itself.
>
> The new 1420 audit, AUDIT_IPE_ACCESS indicates the result of a policy
> evaulation of a resource. The other two events, AUDIT_MAC_POLICY_LOAD,
> and AUDIT_MAC_CONFIG_CHANGE represent a new policy was loaded into the
> kernel and the currently active policy changed, respectively.
>
> This patch also adds support for success auditing, allowing users to
> identify how a resource passed policy. It is recommended to use this
> option with caution, as it is quite noisy.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> ---

One quick comment: I would suggest squashing patch 6/17 together with
this one (7/17), as there is no real need for the AUDIT_IPE_ACCESS
definition to be in its own patch.

... and now the hard questions: why are the audit record examples not
included in the commit description? :)

> This patch adds the following audit records:
>
>   type=1420 audit(1653364735.161:64):
>     rule="DEFAULT op=EXECUTE action=DENY"

I suspect I'll have more comments on this when I get to the relevant
chunk in this patch, but if the "rule" string is coming directly from
userspace we should make sure it is recorded as an untrusted string.
Given the extensible nature of IPE, it might be a good idea to make it
untrusted regardless just so we don't run into problems in the future.

What does this record actually indicate?  With it being type 1420, I'm
assuming it is the result of an IPE access control decision, but for
what?

>   type=1420 audit(1653364370.067:61): path="/root/fs/rw/plain/execve"
>     dev="vdc1" ino=16 rule="DEFAULT op=EXECUTE action=DENY"

Why are we repeating the rule in the record which reports on the
access control verdict?  There is always a concern around the size of
heavily configured audit streams, this is not going to help.

>   type=1405 audit(1653425583.136:54): policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686

What changed?  How is this record useful?

>   type=1403 audit(1653425529.927:53): policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686

The policy loads should probably attempt to mimic some of the existing
LSMs, for example:

  type=MAC_POLICY_LOAD msg=audit(06/15/2022 17:31:54.281:878) : \
    auid=root ses=4 lsm=selinux res=yes

> This results in the following events (the audit records are always
> prior to a SYSCALL record):
>
>   type=1420 audit(1653364735.161:64):
>     rule="DEFAULT op=EXECUTE action=DENY"
>   type=1300 audit(1653364735.161:64): arch=c000003e syscall=9
>     success=no exit=-13 a0=0 a1=1000 a2=4 a3=20 items=0 ppid=455 pid=774
>     auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
>     tty=ttyS0 ses=3 comm="mmap" exe="/root/host/mmap" subj=kernel
>     key=(null)
>   audit: type=1327 audit(1653364735.161:64):
>     proctitle=686F73742F6D6D617000410058
>
>   type=1420 audit(1653364370.067:61): path="/root/fs/rw/plain/execve"
>     dev="vdc1" ino=16 rule="DEFAULT op=EXECUTE action=DENY"
>   type=1300 audit(1653364370.067:61): arch=c000003e syscall=10
>     success=no exit=-13 a0=7f0bf0644000 a1=4f80 a2=5 a3=7f0bf043d300
>     items=0 ppid=455 pid=737 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0
>     egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=3 comm="mprotect"
>     exe="/root/host/mprotect" subj=kernel key=(null)
>   type=1327 audit(1653364370.067:61):
>     proctitle=686F73742F6D70726F7465637400534800527C5700527C5800706C61696E2F657865637665
>
>   type=1403 audit(1653425529.927:53): policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686
>   type=1300 audit(1653425529.927:53): arch=c000003e syscall=1
>     success=yes exit=6215 a0=1 a1=7f07adfe4000 a2=1847 a3=22 items=0
>     ppid=441 pid=445 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=)
>   type=1327 audit(1653425529.927:53):
>     proctitle=63617400706F6C69636965732F646D7665726974795F726F6F74686173682E706F6C2E703762
>
>   type=1405 audit(1653425583.136:54): policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686
>   type=1300 audit(1653425583.136:54): arch=c000003e syscall=1 success=yes
>     exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=7fe683990020 items=0 ppid=405
>     pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 e)
>   type=1327 audit(1653425583.136:54): proctitle="-bash"
>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
>
> v3:
>   + Move ipe_load_properties to patch 04.
>   + Remove useless 0-initializations
>   + Prefix extern variables with ipe_
>   + Remove kernel module parameters, as these are
>     exposed through sysctls.
>   + Add more prose to the IPE base config option
>     help text.
>   + Use GFP_KERNEL for audit_log_start.
>   + Remove unnecessary caching system.
>   + Remove comments from headers
>   + Use rcu_access_pointer for rcu-pointer null check
>   + Remove usage of reqprot; use prot only.
>   + Move policy load and activation audit event to 03/12
>
> v4:
>   + Remove sysctls in favor of securityfs nodes
>   + Re-add kernel module parameters, as these are now
>     exposed through securityfs.
>   + Refactor property audit loop to a separate function.
>
> v5:
>   + fix minor grammatical errors
>   + do not group rule by curly-brace in audit record,
>     reconstruct the exact rule.
>
> v6:
>   + No changes
>
> v7:
>   + Further split lsm creation, the audit system, the evaluation loop,
>     and access control hooks into separate patches.
>   + Further split audit system patch into two separate patches; one
>     for include/uapi, and the usage of the new defines.
>   + Split out the permissive functionality into another separate patch,
>     for easier review.
>   + Correct misuse of audit_log_n_untrusted string to audit_log_format
>   + Use get_task_comm instead of comm directly.
>   + Quote certain audit values
>   + Remove unnecessary help text on choice options - these were previously
>     idented at the wrong level
>   + Correct a stale string constant (ctx_ns_enforce to ctx_enforce)
>
> v8:
>
>   + Change dependency for CONFIG_AUDIT to CONFIG_AUDITSYSCALL
>   + Drop ctx_* prefix
>   + Reuse, where appropriate, the audit fields from the field
>     dictionary. This transforms:
>       ctx_pathname  -> path
>       ctx_ino       -> ino
>       ctx_dev       -> dev
>
>   + Add audit records and event examples to commit description.
>   + Remove new_audit_ctx, replace with audit_log_start. All data that
>     would provided by new_audit_ctx is already present in the syscall
>     audit record, that is always emitted on these actions. The audit
>     records should be correlated as such.
>   + Change audit types:
>     + AUDIT_TRUST_RESULT                -> AUDIT_IPE_ACCESS
>       +  This prevents overloading of the AVC type.
>     + AUDIT_TRUST_POLICY_ACTIVATE       -> AUDIT_MAC_CONFIG_CHANGE
>     + AUDIT_TRUST_POLICY_LOAD           -> AUDIT_MAC_POLICY_LOAD
>       + There were no significant difference in meaning between
>         these types.
>
>   + Remove enforcing parameter passed from the context structure
>     for AUDIT_IPE_ACCESS.
>     +  This field can be inferred from the SYSCALL audit event,
>        based on the success field.
>
>   + Remove all fields already captured in the syscall record. "hook",
>     an IPE specific field, can be determined via the syscall field in
>     the syscall record itself, so it has been removed.
>       + ino, path, and dev in IPE's record refer to the subject of the
>         syscall, while the syscall record refers to the calling process.
>
>   + remove IPE prefix from policy load/policy activation events
>   + fix a bug wherein a policy change audit record was not fired when
>     updating a policy
> ---
>  security/ipe/Kconfig              |  55 +++++++++
>  security/ipe/Makefile             |   2 +
>  security/ipe/audit.c              | 184 ++++++++++++++++++++++++++++++
>  security/ipe/audit.h              |  34 ++++++
>  security/ipe/ctx.c                |  21 ++++
>  security/ipe/ctx.h                |   2 +
>  security/ipe/eval.c               |   9 ++
>  security/ipe/eval.h               |   7 ++
>  security/ipe/fs.c                 |  79 +++++++++++++
>  security/ipe/modules/ipe_module.h |   2 +
>  10 files changed, 395 insertions(+)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h
>
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index e4875fb04883..1ad2f34b98ec 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -15,3 +15,58 @@ menuconfig SECURITY_IPE
>           admins to reconfigure trust requirements on the fly.
>
>           If unsure, answer N.
> +
> +if SECURITY_IPE
> +
> +config IPE_AUDIT
> +       bool "Enable IPE's audit events"
> +       depends on AUDIT && AUDITSYSCALL
> +       help
> +         This option causes IPE to emit audit records on certain key
> +         events during IPE's normal operation. Examples include:
> +         when an action is denied by IPE policy, when a new policy is
> +         loaded, and when a new policy is active. This allows system
> +         admins to analyze what is happening on their systems, and
> +         validate through audit records that IPE is responsible for
> +         certain behaviors.
> +
> +         if unsure, answer Y.

Do you ever envision someone using IPE without auditing built into the kernel?

> +choice
> +       prompt "Hash algorithm used in auditing policies"
> +       default IPE_AUDIT_HASH_SHA1
> +       depends on IPE_AUDIT
> +       help
> +         Specify the hash algorithm used when auditing policies.
> +         The hash is used to uniquely identify a policy from other
> +         policies on the system.
> +
> +         If unsure, leave default.
> +
> +       config IPE_AUDIT_HASH_SHA1
> +               bool "sha1"
> +               select CRYPTO_SHA1
> +
> +       config IPE_AUDIT_HASH_SHA256
> +               bool "sha256"
> +               select CRYPTO_SHA256
> +
> +       config IPE_AUDIT_HASH_SHA384
> +               bool "sha384"
> +               select CRYPTO_SHA512
> +
> +       config IPE_AUDIT_HASH_SHA512
> +               bool "sha512"
> +               select CRYPTO_SHA512
> +
> +endchoice
> +
> +config IPE_AUDIT_HASH_ALG
> +       string
> +       depends on IPE_AUDIT
> +       default "sha1" if IPE_AUDIT_HASH_SHA1
> +       default "sha256" if IPE_AUDIT_HASH_SHA256
> +       default "sha384" if IPE_AUDIT_HASH_SHA384
> +       default "sha512" if IPE_AUDIT_HASH_SHA512
> +
> +endif

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..0442cc51a4bd
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,184 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +#include "audit.h"
> +#include "modules/ipe_module.h"
> +
> +#include <linux/slab.h>
> +#include <linux/audit.h>
> +#include <linux/types.h>
> +#include <crypto/hash.h>
> +
> +#define ACTSTR(x) ((x) == ipe_action_allow ? "ALLOW" : "DENY")
> +
> +#define POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
> +                       CONFIG_IPE_AUDIT_HASH_ALG "="
> +
> +static const char *const audit_op_names[ipe_operation_max] = {
> +       "EXECUTE",
> +       "FIRMWARE",
> +       "KMODULE",
> +       "KEXEC_IMAGE",
> +       "KEXEC_INITRAMFS",
> +       "IMA_POLICY",
> +       "IMA_X509_CERT",
> +};
> +
> +/**
> + * audit_rule: audit an IPE policy rule approximation.
> + * @ab: Supplies a poniter to the audit_buffer to append to.
> + * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
> + *
> + * This is an approximation because aliases like "KERNEL_READ" will be
> + * emitted in their expanded form.
> + */
> +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
> +{
> +       const struct ipe_policy_mod *ptr;
> +
> +       audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
> +
> +       list_for_each_entry(ptr, &r->modules, next) {
> +               audit_log_format(ab, "%s=", ptr->mod->name);

The module names must always be alphanumeric, yes?

> +               ptr->mod->audit(ab, ptr->mod_value);

Regardless of the module names, I suspect the module specific audit
value is going to push this to being an untrusted string ... which is
a bit interesting as I think the only way to do that would be to build
up the rule string first and do something like this:

  audit_log_format(ab, "rule=");
  audit_log_untrustedstring(ab, rule_string);

> +               audit_log_format(ab, " ");
> +       }
> +
> +       audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
> +}
> +
> +/**
> + * ipe_audit_match: audit a match for IPE policy.
> + * @ctx: Supplies a poniter to the evaluation context that was used in the
> + *      evaluation.
> + * @match_type: Supplies the scope of the match: rule, operation default,
> + *             global default.
> + * @act: Supplies the IPE's evaluation decision, deny or allow.
> + * @r: Supplies a pointer to the rule that was matched, if possible.
> + * @enforce: Supplies the enforcement/permissive state at the point
> + *          the enforcement decision was made.
> + */
> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +                    enum ipe_match match_type,
> +                    enum ipe_action act, const struct ipe_rule *const r)
> +{
> +       bool success_audit;
> +       struct inode *inode;
> +       struct audit_buffer *ab;
> +       const char *op = audit_op_names[ctx->op];
> +
> +       rcu_read_lock();
> +       success_audit = READ_ONCE(ctx->ci_ctx->success_audit);
> +       rcu_read_unlock();
> +
> +       if (act != ipe_action_deny && !success_audit)
> +               return;
> +
> +       ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
> +       if (!ab)
> +               return;
> +
> +       if (ctx->file) {
> +               audit_log_d_path(ab, "path=", &ctx->file->f_path);
> +               inode = file_inode(ctx->file);
> +               if (inode) {
> +                       audit_log_format(ab, " dev=");
> +                       audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +                       audit_log_format(ab, " ino=%lu ", inode->i_ino);
> +               }

I noticed in the execve/mprotect example above that your "path" (and
presumably the "dev"/"inode" too) field doesn't match the "comm" field
in the syscall record.  Granted, the "comm" field can be manipulated,
but I'm guessing that isn't the case here and instead you just wrote a
script that calls a "/root/host/mprotect" helper, is that correct?

If yes, the IPE "path" field seems a little misleading, is that
intentional?  What happens in the case of a proper application binary?
 Perhaps we need to use a different field name than "path"?

> +       }
> +
> +       if (match_type == ipe_match_rule)
> +               audit_rule(ab, r);
> +       else if (match_type == ipe_match_table)
> +               audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> +                                ACTSTR(act));
> +       else
> +               audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> +                                ACTSTR(act));
> +
> +       audit_log_end(ab);
> +}
> +
> +/**
> + * audit_policy: Audit a policy's name, version and thumprint to @ab

Thum*b*print :)


> + * @ab: Supplies a pointer to the audit buffer to append to.
> + * @p: Supplies a pointer to the policy to audit
> + */
> +static void audit_policy(struct audit_buffer *ab,
> +                        const struct ipe_policy *const p)
> +{
> +       u8 *digest = NULL;
> +       struct crypto_shash *tfm;
> +       SHASH_DESC_ON_STACK(desc, tfm);
> +
> +       tfm = crypto_alloc_shash(CONFIG_IPE_AUDIT_HASH_ALG, 0, 0);
> +       if (IS_ERR(tfm))
> +               return;
> +
> +       desc->tfm = tfm;
> +
> +       digest = kzalloc(crypto_shash_digestsize(tfm), GFP_KERNEL);
> +       if (!digest)
> +               goto out;
> +
> +       if (crypto_shash_init(desc))
> +               goto out;
> +
> +       if (crypto_shash_update(desc, p->pkcs7, p->pkcs7len))
> +               goto out;
> +
> +       if (crypto_shash_final(desc, digest))
> +               goto out;
> +
> +       audit_log_format(ab, POLICY_LOAD_FMT, p->parsed->name,
> +                        p->parsed->version.major, p->parsed->version.minor,
> +                        p->parsed->version.rev);
> +       audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
> +
> +out:
> +       kfree(digest);
> +       crypto_free_shash(tfm);
> +}

--
paul-moore.com
