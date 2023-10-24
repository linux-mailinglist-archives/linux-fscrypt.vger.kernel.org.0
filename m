Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4636D7D4651
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Oct 2023 05:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbjJXDw5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Oct 2023 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjJXDwq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Oct 2023 23:52:46 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4101711A
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:29 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7789cc5c8ccso330253485a.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698119548; x=1698724348; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gkQv4NPpuq+SSSCpl9UyQF6YqX/MV1oQ90uakIxS1+8=;
        b=EszOCmz+XhI58q2jgJ0foA5LyquXNRos7hryJRhcLTxxoVVm2LYYxZWtEdZ2L8wFrV
         Ucq8QOPfAAwJdQS3+Io54xU61g0zSWk4vr6MrsI0W+LMTBV23alOi0HkpBBGsLyAuMxw
         M2wehRbJG/xPPYoJReaPoUFbH/j3adou1ra2UDX5h8wnj6tAoIutIIGf0yH1RpPJxYtm
         LpcFf8d/QQcNbu07CcrujMdtgdBeBKjGoPSmW/S9Fu6OI7bB2dk70llts38xvDN+/Xoh
         DwPvpjJLK7lpBz5WlPBo5f2vvIrXJdTPYHiyBwFMpNpWDfEWzKhVKJGnz48lTnBXi0kL
         vdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698119548; x=1698724348;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gkQv4NPpuq+SSSCpl9UyQF6YqX/MV1oQ90uakIxS1+8=;
        b=vjIZqKG8NVFXR7Rx0fqiB6mc1l46DLX/NLtAlPGuf/PdqWRnAqhBYLWKMxkqMPdxXH
         TN4qCPkmSpT+1hvHy3lADxYs3ubB37+FVpKkg658SUJ24wBC2iLJSIv20oY5BzzN/Tzb
         Y4JHYCcsw6h5AL6EAk3zykpvpDNO72mCS3uHfm2q3nMqVeCBsA2SJwA7YRGNE9x6ny1W
         fTGEXA/f9vb15NT6Lg3AUQnv0bawqKceW+efbMVgkpA4BPHVaXGhFhTdgRRPBAK5SS3r
         gzMz3SePHrEupYungdthuEScSkGcj1UtQdbBrJhMZJsAf9iGH/9r2Bov4slypoCkWfQc
         4DgA==
X-Gm-Message-State: AOJu0YynfznodWJO0HZFfsTNIJqLadOP3zAWpwILC2VrcNck+Cr5JojI
        elVUI3hof6ivz2gX5vMZs2wi
X-Google-Smtp-Source: AGHT+IGpiqDf/TKC1eRppc/Gn4MIT1ywdMmENtPJG/iCE8tbE4s8HLyLA6+qJAYdCissawMFbRrNGA==
X-Received: by 2002:a05:620a:1a8d:b0:774:21d8:b0bb with SMTP id bl13-20020a05620a1a8d00b0077421d8b0bbmr14769901qkb.24.1698119548174;
        Mon, 23 Oct 2023 20:52:28 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id x1-20020a05620a098100b0076f21383b6csm3157623qkx.112.2023.10.23.20.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 20:52:27 -0700 (PDT)
Date:   Mon, 23 Oct 2023 23:52:27 -0400
Message-ID: <9217384a1f58c5d3431b90f100c7de85.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v11 8/19] uapi|audit|ipe: add ipe auditing support
References: <1696457386-3010-9-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-9-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Users of IPE require a way to identify when and why an operation fails,
> allowing them to both respond to violations of policy and be notified
> of potentially malicious actions on their systems with respect to IPE
> itself.
> 
> This patch introduces 3 new audit events.
> 
> AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
> of a resource.
> AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
> has been changed to another loaded policy.
> AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
> into the kernel.
> 
> This patch also adds support for success auditing, allowing users to
> identify why an allow decision was made for a resource. However, it is
> recommended to use this option with caution, as it is quite noisy.
> 
> Here are some examples of the new audit record types:
> 
> AUDIT_IPE_ACCESS(1420):
> 
>     audit: AUDIT1420 path="/root/vol/bin/hello" dev="sda"
>       ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"
> 
>     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
> 
>     audit: AUDIT1420 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
>       ino=131 rule="DEFAULT action=DENY"
> 
> The above three records were generated when the active IPE policy only
> allows binaries from the initial booted drive(sda) to run. The three
> identical `hello` binary were placed at different locations, only the
> first hello from sda was allowed.
> 
> Field path followed by the file's path name.
> 
> Field dev followed by the device name as found in /dev where the file is
> from.
> Note that for device mappers it will use the name `dm-X` instead of
> the name in /dev/mapper.
> For a file in a temp file system, which is not from a device, it will use
> `tmpfs` for the field.
> The implementation of this part is following another existing use case
> LSM_AUDIT_DATA_INODE in security/lsm_audit.c
> 
> Field ino followed by the file's inode number.
> 
> Field rule followed by the IPE rule made the access decision. The whole
> rule must be audited because the decision is based on the combination of
> all property conditions in the rule.
> 
> Along with the syscall audit event, user can know why a blocked
> happened. For example:
> 
>     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
>     audit[1956]: SYSCALL arch=c000003e syscall=59
>       success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
>       a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
>       gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
>       ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
> 
> The above two records showed bash used execve to run "hello" and got
> blocked by IPE. Note that the IPE records are always prior to a SYSCALL
> record.
> 
> AUDIT_IPE_CONFIG_CHANGE(1421):
> 
>     audit: AUDIT1421
>       old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
>       old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649
>       new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
>       new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F
>       auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed the current IPE active policy switch from
> `Allow_All` to `boot_verified` along with the version and the hash
> digest of the two policies. Note IPE can only have one policy active
> at a time, all access decision evaluation is based on the current active
> policy.
> The normal procedure to deploy a policy is loading the policy to deploy
> into the kernel first, then switch the active policy to it.
> 
> AUDIT_IPE_POLICY_LOAD(1422):
> 
> audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
> policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD
> auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed a new policy has been loaded into the kernel
> with the policy name, policy version and policy hash.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> 
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
>   + Remove unnecessary help text on choice options - these were
>     previously
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
> 
> v9:
>   + Merge the AUDIT_IPE_ACCESS definition with the audit support commit
>   + Change the audit format of policy load and switch
>   + Remove the ipe audit kernel switch
> 
> v10:
>   + Create AUDIT_IPE_CONFIG_CHANGE and AUDIT_IPE_POLICY_LOAD
>   + Change field names per upstream feedback
> 
> v11:
>   + Fix style issues
> ---
>  include/uapi/linux/audit.h |   3 +
>  security/ipe/Kconfig       |   2 +-
>  security/ipe/Makefile      |   1 +
>  security/ipe/audit.c       | 195 +++++++++++++++++++++++++++++++++++++
>  security/ipe/audit.h       |  18 ++++
>  security/ipe/eval.c        |  32 ++++--
>  security/ipe/eval.h        |   8 ++
>  security/ipe/fs.c          |  70 +++++++++++++
>  security/ipe/policy.c      |   5 +
>  9 files changed, 327 insertions(+), 7 deletions(-)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..e123701d5e3b
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,195 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/audit.h>
> +#include <linux/types.h>
> +#include <crypto/hash.h>
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +#include "audit.h"
> +
> +#define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
> +
> +#define IPE_AUDIT_HASH_ALG "sha256"
> +
> +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
> +			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
> +				    "old_active_pol_version=%hu.%hu.%hu "\
> +				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
> +				    "new_active_pol_version=%hu.%hu.%hu "\
> +				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +
> +static const char *const audit_op_names[__IPE_OP_MAX] = {
> +	"EXECUTE",
> +	"FIRMWARE",
> +	"KMODULE",
> +	"KEXEC_IMAGE",
> +	"KEXEC_INITRAMFS",
> +	"IMA_POLICY",
> +	"IMA_X509_CERT",
> +};
> +
> +static const char *const audit_prop_names[__IPE_PROP_MAX] = {
> +	"boot_verified=FALSE",
> +	"boot_verified=TRUE",
> +};

I would suggest taking the same approach for both @audit_op_names and
@audit_prop_names; either include the field name in the string array
for both or leave it out of both.

> +/**
> + * audit_rule - audit an IPE policy rule approximation.
> + * @ab: Supplies a pointer to the audit_buffer to append to.
> + * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
> + */
> +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
> +{
> +	const struct ipe_prop *ptr;
> +
> +	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
> +
> +	list_for_each_entry(ptr, &r->props, next)
> +		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
> +
> +	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
> +}
> +
> +/**
> + * ipe_audit_match - audit a match for IPE policy.
> + * @ctx: Supplies a pointer to the evaluation context that was used in the
> + *	 evaluation.
> + * @match_type: Supplies the scope of the match: rule, operation default,
> + *		global default.
> + * @act: Supplies the IPE's evaluation decision, deny or allow.
> + * @r: Supplies a pointer to the rule that was matched, if possible.
> + * @enforce: Supplies the enforcement/permissive state at the point
> + *	     the enforcement decision was made.
> + */

Does it make sense to move @match_type into the ipe_eval_ctx struct?

> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +		     enum ipe_match match_type,
> +		     enum ipe_action_type act, const struct ipe_rule *const r)
> +{
> +	struct inode *inode;
> +	struct audit_buffer *ab;
> +	const char *op = audit_op_names[ctx->op];
> +
> +	if (act != IPE_ACTION_DENY && !READ_ONCE(success_audit))
> +		return;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
> +	if (!ab)
> +		return;
> +
> +	if (ctx->file) {
> +		audit_log_d_path(ab, "path=", &ctx->file->f_path);
> +		inode = file_inode(ctx->file);
> +		if (inode) {
> +			audit_log_format(ab, " dev=");
> +			audit_log_untrustedstring(ab, inode->i_sb->s_id);
> +			audit_log_format(ab, " ino=%lu ", inode->i_ino);
> +		}
> +	}
> +
> +	if (match_type == IPE_MATCH_RULE)
> +		audit_rule(ab, r);
> +	else if (match_type == IPE_MATCH_TABLE)
> +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> +				 ACTSTR(act));
> +	else
> +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> +				 ACTSTR(act));
> +
> +	audit_log_end(ab);
> +}

--
paul-moore.com
