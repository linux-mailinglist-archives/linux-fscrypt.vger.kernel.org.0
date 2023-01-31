Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD173683362
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Jan 2023 18:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjAaRLp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 12:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjAaRLo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 12:11:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079F18A49
        for <linux-fscrypt@vger.kernel.org>; Tue, 31 Jan 2023 09:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675185063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yntr+OXayVRbKBTd8ymJCMOByp9K7d7gLFaDiL9OB9Y=;
        b=eIj09iejmd3YEMd+dTxIizu197A5avnaOgneXYE8XiBU1dLrJ0ZRotjktCyJ1s57VGk0Ph
        J+bWvG4hEw0vkBdYrLWfPu5S8HU4EOshpfw4JOU8C09Y4h7ytKyclc9UFY6HOK5r3yywTK
        g10WlY1C8Gsi1+zYKBmF4dLdAhKOSYQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-iGras36oNeehrFb4acio0Q-1; Tue, 31 Jan 2023 12:11:01 -0500
X-MC-Unique: iGras36oNeehrFb4acio0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0667D887405;
        Tue, 31 Jan 2023 17:10:59 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.17.134])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 27CAD112132C;
        Tue, 31 Jan 2023 17:10:57 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com, linux-audit@redhat.com
Cc:     Fan Wu <wufan@linux.microsoft.com>, dm-devel@redhat.com,
        linux-doc@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        roberto.sassu@huawei.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-integrity@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 07/16] uapi|audit|ipe: add ipe auditing support
Date:   Tue, 31 Jan 2023 12:10:56 -0500
Message-ID: <3723852.kQq0lBPeGt@x2>
Organization: Red Hat
In-Reply-To: <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-8-git-send-email-wufan@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

On Monday, January 30, 2023 5:57:22 PM EST Fan Wu wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
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

Typically when you reuse an existing record type, it is expected to maintain 
the same fields in the same order. Also, it is expect that fields that are 
common across diferent records have the same meaning. To aid in this, we have 
a field dictionary here:

https://github.com/linux-audit/audit-documentation/blob/main/specs/fields/
field-dictionary.csv

For example, dev is expected to be 2 hex numbers separated by a colon which 
are the device major and minor numbers. But down a couple lines from here, we 
find dev="tmpfs". But isn't that a filesystem type?

> This patch also adds support for success auditing, allowing users to
> identify how a resource passed policy. It is recommended to use this
> option with caution, as it is quite noisy.
> 
> This patch adds the following audit records:
> 
>   audit: AUDIT1420 path="/tmp/tmpwxmam366/deny/bin/hello" dev="tmpfs"
>     ino=72 rule="DEFAULT op=EXECUTE action=DENY"

Do we really need to log the whole rule?

>   The above audit record shows IPE blocked a file
>     /tmp/tmpwxmam366/deny/bin/hello in the temp file system.
> 
>   audit: AUDIT1420 path="/tmp/tmpxkvb3d9x/deny/bin/hello" dev="tmpfs"
>     ino=157 rule="DEFAULT action=DENY"
> 
>   The above audit record shows IPE blocked a file
>     /tmp/tmpxkvb3d9x/deny/bin/hello in the temp file system via another
>     rule.
> 
>   audit: MAC_POLICY_LOAD policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=DC67AC19E05894EFB3170A8E55DE529794E248C2
>     auid=4294967295 ses=4294967295 lsm=ipe res=1

The MAC_POLICY_LOAD record type simply states the lsm that had it's policy 
loaded. There isn't name, version, and hash information. I'd prefer to see 
all users of this record type decide if it should be extended because they 
also have that information available to record.

>   The above audit record shows IPE loaded a new policy named
>     "dmverity_roothash" with the sha256 hash of the policy.
> 
>   audit: MAC_CONFIG_CHANGE old_active_pol_name="Allow_All"
>     old_active_pol_version=0.0.0
>     old_sha256=DA39A3EE5E6B4B0D3255BFEF95601890AFD80709
>     new_active_pol_name="dmverity_roothash" new_active_pol_version=0.0.0
>     new_sha256=DC67AC19E05894EFB3170A8E55DE529794E248C2
>     auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
>   The above audit record shows IPE's active policy switched from
>     "Allow_All" to "dmverity_roothash".

Shouldn't this just be another MAC_POLICY_LOAD? That would match other LSM's. 
The MAC_CONFIG_CHANGE is to denote that a changeable option was modified from 
one value to another. But it is still operating under the same policy.

-Steve

> These result in the following events (the audit records are always
> prior to a SYSCALL record):
> 
>   audit: AUDIT1420 path="/tmp/tmpwxmam366/deny/bin/hello" dev="tmpfs"
>     ino=72 rule="DEFAULT op=EXECUTE action=DENY"
>   audit[476]: SYSCALL arch=c000003e syscall=59 success=no exit=-13
>     a0=7f7d01b5e890 a1=7f7d01f80e80 a2=7ffde535f230 a3=0 items=0 ppid=229
>     pid=476 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
> fsgid=0 tty=pts0 ses=4294967295 comm="python3" exe="/usr/bin/python3.10"
> key=(null)
>   audit: PROCTITLE
>     proctitle=707974686F6E3300746573742F6D61696E2E7079002D66002E2E
> 
>   The above events shows IPE blocked the hello file which python was
>     trying to execute.
> 
>   audit: AUDIT1420 path="/tmp/tmpxkvb3d9x/deny/bin/hello" dev="tmpfs"
>     ino=157 rule="DEFAULT action=DENY"
>   audit[1195]: SYSCALL arch=c000003e syscall=9 success=no
>     exit=-13 a0=0 a1=18020 a2=6 a3=2 items=0 ppid=997 pid=1195
>     auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
> tty=pts0 ses=4294967295 comm="mmap_test"
>     exe="/tmp/ipe-test/bin/mmap_test" key=(null)
>   audit: PROCTITLE
>     proctitle=2F746D702F6970652D746573742F62696E2F6D6D61705F746573
> 
>   The above events shows IPE blocked the hello file which
>     /tmp/ipe-test/bin/mmap_test was trying to mmap.
> 
>   audit: MAC_POLICY_LOAD policy_name="dmverity_roothash"
>     policy_version=0.0.0 sha256=DC67AC19E05894EFB3170A8E55DE529794E248C2
>     auid=4294967295 ses=4294967295 lsm=ipe res=1
>   audit[229]: SYSCALL arch=c000003e syscall=1 success=yes exit=2567 a0=3
>     a1=5596fcae1fb0 a2=a07 a3=2 items=0 ppid=184 pid=229 auid=4294967295
>     uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sg
>     id=0 fsgid=0 tty=pts0 ses=4294967295 comm="python3"
>     exe="/usr/bin/python3.10" key=(null)
>   audit: PROCTITLE
>     proctitle=707974686F6E3300746573742F6D61696E2E7079002D66002E2E
> 
>   The above events shows IPE loaded a new policy "dmverity_roothash"
>     because python used write system call.
> 
>   audit: MAC_CONFIG_CHANGE old_active_pol_name="Allow_All"
>     old_active_pol_version=0.0.0
>     old_sha256=DA39A3EE5E6B4B0D3255BFEF95601890AFD80709
>     new_active_pol_name="dmverity_roothash" new_active_pol_version=0.0.0
>     new_sha256=DC67AC19E05894EFB3170A8E55DE529794E248C2
>     auid=4294967295 ses=4294967295 lsm=ipe res=1
>   audit[229]: SYSCALL arch=c000003e syscall=1 success=yes exit=2 a0=3
>     a1=5596fcae1fb0 a2=2 a3=2 items=0 ppid=184 pid=229 auid=4294967295
> uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
>     fsgid=0 tty=pts0 ses=4294967295 comm="python3"
> exe="/usr/bin/python3.10" key=(null)
>   audit: PROCTITLE
>     proctitle=707974686F6E3300746573742F6D61696E2E7079002D66002E2
>   The above events shows IPE switched to a new active policy
>     "dmverity_roothash" because python used write system call.
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
>   + Change the audit format of policy load and siwtch
>   + Remove the ipe audit kernel switch
> ---
>  include/uapi/linux/audit.h |   1 +
>  security/ipe/Kconfig       |   2 +-
>  security/ipe/Makefile      |   1 +
>  security/ipe/audit.c       | 196 +++++++++++++++++++++++++++++++++++++
>  security/ipe/audit.h       |  18 ++++
>  security/ipe/eval.c        |  26 ++++-
>  security/ipe/eval.h        |   8 ++
>  security/ipe/fs.c          |  68 +++++++++++++
>  security/ipe/policy.c      |   5 +
>  9 files changed, 321 insertions(+), 4 deletions(-)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h
> 
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index d676ed2b246e..ee3b3db95076 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -143,6 +143,7 @@
>  #define AUDIT_MAC_UNLBL_STCDEL	1417	/* NetLabel: del a static label 
*/
>  #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry 
*/
>  #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI 
entry */
> +#define AUDIT_IPE_ACCESS	1420	/* IPE Denial or Grant */
> 
>  #define AUDIT_FIRST_KERN_ANOM_MSG   1700
>  #define AUDIT_LAST_KERN_ANOM_MSG    1799
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index e4875fb04883..ac4d558e69d5 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -5,7 +5,7 @@
> 
>  menuconfig SECURITY_IPE
>  	bool "Integrity Policy Enforcement (IPE)"
> -	depends on SECURITY && SECURITYFS
> +	depends on SECURITY && SECURITYFS && AUDIT && AUDITSYSCALL
>  	select PKCS7_MESSAGE_PARSER
>  	select SYSTEM_DATA_VERIFICATION
>  	help
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> index 8602d71250b4..89a76ad72301 100644
> --- a/security/ipe/Makefile
> +++ b/security/ipe/Makefile
> @@ -13,3 +13,4 @@ obj-$(CONFIG_SECURITY_IPE) += \
>  	policy.o \
>  	policy_fs.o \
>  	policy_parser.o \
> +	audit.o \
> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..295e9f9f5146
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,196 @@
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
> +#include "digest.h"
> +
> +#include <linux/slab.h>
> +#include <linux/audit.h>
> +#include <linux/types.h>
> +#include <crypto/hash.h>
> +
> +#define ACTSTR(x) ((x) == ipe_action_allow ? "ALLOW" : "DENY")
> +
> +#define IPE_AUDIT_HASH_ALG "sha256"
> +
> +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\"
> policy_version=%hu.%hu.%hu "\ +			      IPE_AUDIT_HASH_ALG 
"="
> +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
> +				    "old_active_pol_version=%hu.%hu.%hu "\
> +				    "old_" IPE_AUDIT_HASH_ALG "="
> +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
> +				    "new_active_pol_version=%hu.%hu.%hu "\
> +				    "new_" IPE_AUDIT_HASH_ALG "="
> +
> +static const char *const audit_op_names[ipe_op_max] = {
> +	"EXECUTE",
> +	"FIRMWARE",
> +	"KMODULE",
> +	"KEXEC_IMAGE",
> +	"KEXEC_INITRAMFS",
> +	"IMA_POLICY",
> +	"IMA_X509_CERT",
> +};
> +
> +static const char *const audit_prop_names[ipe_prop_max] = {
> +	"boot_verified=FALSE",
> +	"boot_verified=TRUE",
> +};
> +
> +/**
> + * audit_rule - audit an IPE policy rule approximation.
> + * @ab: Supplies a poniter to the audit_buffer to append to.
> + * @r: Supplies a pointer to the ipe_rule to approximate a string form
> for. + */
> +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
> +{
> +	const struct ipe_prop *ptr;
> +
> +	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
> +
> +	list_for_each_entry(ptr, &r->props, next) {
> +		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
> +		audit_log_format(ab, " ");
> +	}
> +
> +	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
> +}
> +
> +/**
> + * ipe_audit_match - audit a match for IPE policy.
> + * @ctx: Supplies a poniter to the evaluation context that was used in the
> + *	 evaluation.
> + * @match_type: Supplies the scope of the match: rule, operation default,
> + *		global default.
> + * @act: Supplies the IPE's evaluation decision, deny or allow.
> + * @r: Supplies a pointer to the rule that was matched, if possible.
> + * @enforce: Supplies the enforcement/permissive state at the point
> + *	     the enforcement decision was made.
> + */
> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +		     enum ipe_match match_type,
> +		     enum ipe_action_type act, const struct ipe_rule *const r)
> +{
> +	struct inode *inode;
> +	struct audit_buffer *ab;
> +	const char *op = audit_op_names[ctx->op];
> +
> +	if (act != ipe_action_deny && !READ_ONCE(success_audit))
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
> +	if (match_type == ipe_match_rule)
> +		audit_rule(ab, r);
> +	else if (match_type == ipe_match_table)
> +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> +				 ACTSTR(act));
> +	else
> +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> +				 ACTSTR(act));
> +
> +	audit_log_end(ab);
> +}
> +
> +/**
> + * audit_policy - Audit a policy's name, version and thumbprint to @ab.
> + * @ab: Supplies a pointer to the audit buffer to append to.
> + * @p: Supplies a pointer to the policy to audit.
> + */
> +static void audit_policy(struct audit_buffer *ab,
> +			 const char *audit_format,
> +			 const struct ipe_policy *const p)
> +{
> +	u8 *digest = NULL;
> +	struct crypto_shash *tfm;
> +	SHASH_DESC_ON_STACK(desc, tfm);
> +
> +	tfm = crypto_alloc_shash(IPE_AUDIT_HASH_ALG, 0, 0);
> +	if (IS_ERR(tfm))
> +		return;
> +
> +	desc->tfm = tfm;
> +
> +	digest = kzalloc(crypto_shash_digestsize(tfm), GFP_KERNEL);
> +	if (!digest)
> +		goto out;
> +
> +	if (crypto_shash_init(desc))
> +		goto out;
> +
> +	if (crypto_shash_update(desc, p->pkcs7, p->pkcs7len))
> +		goto out;
> +
> +	if (crypto_shash_final(desc, digest))
> +		goto out;
> +
> +	audit_log_format(ab, audit_format, p->parsed->name,
> +			 p->parsed->version.major, p->parsed->version.minor,
> +			 p->parsed->version.rev);
> +	audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
> +
> +out:
> +	kfree(digest);
> +	crypto_free_shash(tfm);
> +}
> +
> +/**
> + * ipe_audit_policy_activation - Audit a policy being made the active
> policy. + * @p: Supplies a pointer to the policy to audit.
> + */
> +void ipe_audit_policy_activation(const struct ipe_policy *const op,
> +				 const struct ipe_policy *const np)
> +{
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL,
> AUDIT_MAC_CONFIG_CHANGE); +	if (!ab)
> +		return;
> +
> +	audit_policy(ab, AUDIT_OLD_ACTIVE_POLICY_FMT, op);
> +	audit_log_format(ab, " ");
> +	audit_policy(ab, AUDIT_NEW_ACTIVE_POLICY_FMT, np);
> +	audit_log_format(ab, " auid=%u ses=%u lsm=ipe res=1",
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 audit_get_sessionid(current));
> +
> +	audit_log_end(ab);
> +}
> +
> +/**
> + * ipe_audit_policy_load - Audit a policy being loaded into the kernel.
> + * @p: Supplies a pointer to the policy to audit.
> + */
> +void ipe_audit_policy_load(const struct ipe_policy *const p)
> +{
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, 
AUDIT_MAC_POLICY_LOAD);
> +	if (!ab)
> +		return;
> +
> +	audit_policy(ab, AUDIT_POLICY_LOAD_FMT, p);
> +	audit_log_format(ab, " auid=%u ses=%u lsm=ipe res=1",
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 audit_get_sessionid(current));
> +
> +	audit_log_end(ab);
> +}
> diff --git a/security/ipe/audit.h b/security/ipe/audit.h
> new file mode 100644
> index 000000000000..2e9b99737f97
> --- /dev/null
> +++ b/security/ipe/audit.h
> @@ -0,0 +1,18 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#ifndef IPE_AUDIT_H
> +#define IPE_AUDIT_H
> +
> +#include "policy.h"
> +
> +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> +		     enum ipe_match match_type,
> +		     enum ipe_action_type act, const struct ipe_rule *const 
r);
> +void ipe_audit_policy_load(const struct ipe_policy *const p);
> +void ipe_audit_policy_activation(const struct ipe_policy *const op,
> +				 const struct ipe_policy *const np);
> +
> +#endif /* IPE_AUDIT_H */
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 48b5104a3463..d713808cad9c 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -7,6 +7,7 @@
>  #include "eval.h"
>  #include "hooks.h"
>  #include "policy.h"
> +#include "audit.h"
> 
>  #include <linux/fs.h>
>  #include <linux/types.h>
> @@ -15,8 +16,10 @@
>  #include <linux/sched.h>
>  #include <linux/rcupdate.h>
>  #include <linux/spinlock.h>
> +#include <linux/moduleparam.h>
> 
>  struct ipe_policy __rcu *ipe_active_policy;
> +bool success_audit;
> 
>  static struct super_block *pinned_sb;
>  static DEFINE_SPINLOCK(pin_lock);
> @@ -117,6 +120,7 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const
> ctx) int rc = 0;
>  	bool match = false;
>  	enum ipe_action_type action;
> +	enum ipe_match match_type;
>  	struct ipe_policy *pol = NULL;
>  	const struct ipe_rule *rule = NULL;
>  	const struct ipe_op_table *rules = NULL;
> @@ -131,6 +135,7 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const
> ctx)
> 
>  	if (ctx->op == ipe_op_max) {
>  		action = pol->parsed->global_default_action;
> +		match_type = ipe_match_global;
>  		goto eval;
>  	}
> 
> @@ -146,14 +151,20 @@ int ipe_evaluate_event(const struct ipe_eval_ctx
> *const ctx) break;
>  	}
> 
> -	if (match)
> +	if (match) {
>  		action = rule->action;
> -	else if (rules->default_action != ipe_action_max)
> +		match_type = ipe_match_rule;
> +	} else if (rules->default_action != ipe_action_max) {
>  		action = rules->default_action;
> -	else
> +		match_type = ipe_match_table;
> +	} else {
>  		action = pol->parsed->global_default_action;
> +		match_type = ipe_match_global;
> +	}
> 
>  eval:
> +	ipe_audit_match(ctx, match_type, action, rule);
> +
>  	if (action == ipe_action_deny)
>  		rc = -EACCES;
> 
> @@ -178,3 +189,12 @@ void ipe_invalidate_pinned_sb(const struct super_block
> *mnt_sb)
> 
>  	spin_unlock(&pin_lock);
>  }
> +
> +/* Set the right module name */
> +#ifdef KBUILD_MODNAME
> +#undef KBUILD_MODNAME
> +#define KBUILD_MODNAME "ipe"
> +#endif
> +
> +module_param(success_audit, bool, 0400);
> +MODULE_PARM_DESC(success_audit, "Start IPE with success auditing
> enabled"); diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index 887797438b9b..b83730d0b5ae 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -13,6 +13,7 @@
>  #include "policy.h"
> 
>  extern struct ipe_policy __rcu *ipe_active_policy;
> +extern bool success_audit;
> 
>  struct ipe_eval_ctx {
>  	enum ipe_op_type op;
> @@ -21,6 +22,13 @@ struct ipe_eval_ctx {
>  	bool from_init_sb;
>  };
> 
> +enum ipe_match {
> +	ipe_match_rule = 0,
> +	ipe_match_table,
> +	ipe_match_global,
> +	ipe_match_max
> +};
> +
>  void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file,
> enum ipe_op_type op); int ipe_evaluate_event(const struct ipe_eval_ctx
> *const ctx);
>  void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> index 9f6a4867bec2..c99616f36f32 100644
> --- a/security/ipe/fs.c
> +++ b/security/ipe/fs.c
> @@ -4,7 +4,9 @@
>   */
>  #include "ipe.h"
>  #include "fs.h"
> +#include "eval.h"
>  #include "policy.h"
> +#include "audit.h"
> 
>  #include <linux/dcache.h>
>  #include <linux/security.h>
> @@ -12,6 +14,57 @@
>  static struct dentry *np __ro_after_init;
>  static struct dentry *root __ro_after_init;
>  struct dentry *policy_root __ro_after_init;
> +static struct dentry *audit_node __ro_after_init;
> +
> +/**
> + * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t setaudit(struct file *f, const char __user *data,
> +			size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	bool value;
> +
> +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	rc = kstrtobool_from_user(data, len, &value);
> +	if (rc)
> +		return rc;
> +
> +	WRITE_ONCE(success_audit, value);
> +
> +	return len;
> +}
> +
> +/**
> + * getaudit - Read handler for the securityfs node, "ipe/success_audit"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the read syscall
> + * @len: Supplies the length of @data
> + * @offset: unused.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t getaudit(struct file *f, char __user *data,
> +			size_t len, loff_t *offset)
> +{
> +	const char *result;
> +
> +	result = ((READ_ONCE(success_audit)) ? "1" : "0");
> +
> +	return simple_read_from_buffer(data, len, offset, result, 1);
> +}
> 
>  /**
>   * new_policy - Write handler for the securityfs node, "ipe/new_policy".
> @@ -50,6 +103,8 @@ static ssize_t new_policy(struct file *f, const char
> __user *data, if (rc)
>  		goto err;
> 
> +	ipe_audit_policy_load(p);
> +
>  err:
>  	return (rc < 0) ? rc : len;
>  }
> @@ -58,6 +113,11 @@ static const struct file_operations np_fops = {
>  	.write = new_policy,
>  };
> 
> +static const struct file_operations audit_fops = {
> +	.write = setaudit,
> +	.read = getaudit,
> +};
> +
>  /**
>   * ipe_init_securityfs - Initialize IPE's securityfs tree at fsinit.
>   *
> @@ -84,6 +144,13 @@ static int __init ipe_init_securityfs(void)
>  		goto err;
>  	}
> 
> +	audit_node = securityfs_create_file("success_audit", 0600, root,
> +					    NULL, &audit_fops);
> +	if (IS_ERR(audit_node)) {
> +		rc = PTR_ERR(audit_node);
> +		goto err;
> +	}
> +
>  	policy_root = securityfs_create_dir("policies", root);
>  	if (IS_ERR(policy_root)) {
>  		rc = PTR_ERR(policy_root);
> @@ -94,6 +161,7 @@ static int __init ipe_init_securityfs(void)
>  err:
>  	securityfs_remove(np);
>  	securityfs_remove(root);
> +	securityfs_remove(audit_node);
>  	securityfs_remove(policy_root);
>  	return rc;
>  }
> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index a5e9c6e5691b..703b3fd9cf4c 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -9,6 +9,7 @@
>  #include "policy.h"
>  #include "policy_parser.h"
>  #include "digest.h"
> +#include "audit.h"
> 
>  #include <linux/verification.h>
> 
> @@ -124,6 +125,9 @@ struct ipe_policy *ipe_update_policy(struct ipe_policy
> __rcu **addr, swap(new->policyfs, old->policyfs);
>  	ipe_free_policy(old);
> 
> +	if (!rc)
> +		ipe_audit_policy_load(new);
> +
>  	goto out;
>  err:
>  	ipe_free_policy(new);
> @@ -230,6 +234,7 @@ int ipe_set_active_pol(const struct ipe_policy *p)
>  	spin_unlock(&ipe_policy_lock);
>  	synchronize_rcu();
> 
> +	ipe_audit_policy_activation(ap, p);
>  out:
>  	return rc;
>  }




