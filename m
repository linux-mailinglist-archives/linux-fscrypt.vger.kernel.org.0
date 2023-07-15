Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87B7546A9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jul 2023 05:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjGOD5m (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 23:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjGOD5l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 23:57:41 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5604F358C;
        Fri, 14 Jul 2023 20:57:39 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id BFE1321C4681; Fri, 14 Jul 2023 20:57:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BFE1321C4681
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689393458;
        bh=5ETqQBo4jhT0sgXcEKTQTHb9DKJHdPEG+UQJY6rKJXc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FlXnoMgxkK7/ztVgrNQudm3izi2MTX4KVc+gJtjxvIeSMSNs3tgxkoBXM2QUth/Jj
         CpbCGSnPDCFP3niU82NQyquFiwZ3LzcmcFlvnrNA6B4hRHt3s4aiaqzUDNFWGYgRnI
         iPQgjuZjgkpKeTULi8vaAKhpJypH91uthpy6XeFY=
Date:   Fri, 14 Jul 2023 20:57:38 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 8/17] uapi|audit|ipe: add ipe auditing support
Message-ID: <20230715035738.GG15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-9-git-send-email-wufan@linux.microsoft.com>
 <ec09144af7c7109d8b457ceccd50ba7a.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec09144af7c7109d8b457ceccd50ba7a.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:05AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > Users of IPE require a way to identify when and why an operation fails,
> > allowing them to both respond to violations of policy and be notified
> > of potentially malicious actions on their systems with respect to IPE
> > itself.
> > 
> > This patch introduces 3 new audit events.
> > 
> > AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
> > of a resource.
> > AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
> > has been changed to another loaded policy.
> > AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
> > into the kernel.
> > 
> > This patch also adds support for success auditing, allowing users to
> > identify why an allow decision was made for a resource. However, it is
> > recommended to use this option with caution, as it is quite noisy.
> > 
> > Here are some examples of the new audit record types:
> > 
> > AUDIT_IPE_ACCESS(1420):
> > 
> >     audit: AUDIT1420 path="/root/vol/bin/hello" dev="sda"
> >       ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"
> 
> The 'dev' field is already in use by audit, and is used to log the
> device major and minor numbers, see audit_log_name() for an example.
> 
> I would suggest adopting the existing 'dev' field format, but if you
> really want to log the device name as a string you will need to find
> another audit field name.
> 
Actually it was copied from https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/security/lsm_audit.c#n228
Personally I think using device name is better, I will try to add a new field.

> >     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
> >       ino=2 rule="DEFAULT action=DENY"
> > 
> >     audit: AUDIT1420 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
> >       ino=131 rule="DEFAULT action=DENY"
> > 
> > The above three records were generated when the active IPE policy only
> > allows binaries from the initial booted drive(sda) to run. The three
> > identical `hello` binary were placed at different locations, only the
> > first hello from sda was allowed.
> > 
> > Field path followed by the file's path name.
> > 
> > Field dev followed by the device name as found in /dev where the file is
> > from.
> > Note that for device mappers it will use the name `dm-X` instead of
> > the name in /dev/mapper.
> > For a file in a temp file system, which is not from a device, it will use
> > `tmpfs` for the field.
> > The implementation of this part is following another existing use case
> > LSM_AUDIT_DATA_INODE in security/lsm_audit.c
> > 
> > Field ino followed by the file's inode number.
> > 
> > Field rule followed by the IPE rule made the access decision. The whole
> > rule must be audited because the decision is based on the combination of
> > all property conditions in the rule.
> > 
> > Along with the syscall audit event, user can know why a blocked
> > happened. For example:
> > 
> >     audit: AUDIT1420 path="/mnt/ipe/bin/hello" dev="dm-0"
> >       ino=2 rule="DEFAULT action=DENY"
> >     audit[1956]: SYSCALL arch=c000003e syscall=59
> >       success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
> >       a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
> >       gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
> >       ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
> > 
> > The above two records showed bash used execve to run "hello" and got
> > blocked by IPE. Note that the IPE records are always prior to a SYSCALL
> > record.
> > 
> > AUDIT_IPE_CONFIG_CHANGE(1421):
> > 
> >     audit: AUDIT1421
> >       old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
> >       old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855
> >       new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
> >       new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB
> >       auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> You can trim hash digest strings so they better fit in terminals, for
> example:
> 
>   old_policy_digest=sha256:E3B0C44....
> 
Do you mean I could trim it in the documentation and for the real audit
record I still record the whole hash?

> > The above record showed the current IPE active policy switch from
> > `Allow_All` to `boot_verified` along with the version and the hash
> > digest of the two policies. Note IPE can only have one policy active
> > at a time, all access decision evaluation is based on the current active
> > policy.
> > The normal procedure to deploy a policy is loading the policy to deploy
> > into the kernel first, then switch the active policy to it.
> > 
> > AUDIT_IPE_POLICY_LOAD(1422):
> > 
> > audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
> > policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F26765076DD8EED7B8F4DB
> > auid=4294967295 ses=4294967295 lsm=ipe res=1
> > 
> > The above record showed a new policy has been loaded into the kernel
> > with the policy name, policy version and policy hash.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  include/uapi/linux/audit.h |   3 +
> >  security/ipe/Kconfig       |   2 +-
> >  security/ipe/Makefile      |   1 +
> >  security/ipe/audit.c       | 197 +++++++++++++++++++++++++++++++++++++
> >  security/ipe/audit.h       |  18 ++++
> >  security/ipe/eval.c        |  26 ++++-
> >  security/ipe/eval.h        |   8 ++
> >  security/ipe/fs.c          |  71 +++++++++++++
> >  security/ipe/policy.c      |   5 +
> >  9 files changed, 327 insertions(+), 4 deletions(-)
> >  create mode 100644 security/ipe/audit.c
> >  create mode 100644 security/ipe/audit.h
> 
> ...
> 
> > diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> > new file mode 100644
> > index 000000000000..d3f78a7fc93f
> > --- /dev/null
> > +++ b/security/ipe/audit.c
> > @@ -0,0 +1,197 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include <linux/audit.h>
> > +#include <linux/types.h>
> > +#include <crypto/hash.h>
> > +
> > +#include "ipe.h"
> > +#include "eval.h"
> > +#include "hooks.h"
> > +#include "policy.h"
> > +#include "audit.h"
> > +
> > +#define ACTSTR(x) ((x) == __IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
> > +
> > +#define IPE_AUDIT_HASH_ALG "sha256"
> > +
> > +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
> > +			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
> > +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
> > +				    "old_active_pol_version=%hu.%hu.%hu "\
> > +				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> > +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
> > +				    "new_active_pol_version=%hu.%hu.%hu "\
> > +				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> > +
> > +static const char *const audit_op_names[__IPE_OP_MAX] = {
> > +	"EXECUTE",
> > +	"FIRMWARE",
> > +	"KMODULE",
> > +	"KEXEC_IMAGE",
> > +	"KEXEC_INITRAMFS",
> > +	"IMA_POLICY",
> > +	"IMA_X509_CERT",
> > +};
> > +
> > +static const char *const audit_prop_names[__IPE_PROP_MAX] = {
> > +	"boot_verified=FALSE",
> > +	"boot_verified=TRUE",
> > +};
> > +
> > +/**
> > + * audit_rule - audit an IPE policy rule approximation.
> > + * @ab: Supplies a pointer to the audit_buffer to append to.
> > + * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
> > + */
> > +static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
> > +{
> > +	const struct ipe_prop *ptr;
> > +
> > +	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
> > +
> > +	list_for_each_entry(ptr, &r->props, next) {
> > +		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
> > +		audit_log_format(ab, " ");
> 
> Why make two calls to audit_log_format()?  You can just use "%s " as
> the format string.
> 
Yep, this code is kind of silly, I will change the format. Thanks for the advice.

> > +	}
> > +
> > +	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
> > +}
> > +
> > +/**
> > + * ipe_audit_match - audit a match for IPE policy.
> > + * @ctx: Supplies a pointer to the evaluation context that was used in the
> > + *	 evaluation.
> > + * @match_type: Supplies the scope of the match: rule, operation default,
> > + *		global default.
> > + * @act: Supplies the IPE's evaluation decision, deny or allow.
> > + * @r: Supplies a pointer to the rule that was matched, if possible.
> > + * @enforce: Supplies the enforcement/permissive state at the point
> > + *	     the enforcement decision was made.
> > + */
> > +void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
> > +		     enum ipe_match match_type,
> > +		     enum ipe_action_type act, const struct ipe_rule *const r)
> > +{
> > +	struct inode *inode;
> > +	struct audit_buffer *ab;
> > +	const char *op = audit_op_names[ctx->op];
> > +
> > +	if (act != __IPE_ACTION_DENY && !READ_ONCE(success_audit))
> > +		return;
> > +
> > +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
> > +	if (!ab)
> > +		return;
> > +
> > +	if (ctx->file) {
> > +		audit_log_d_path(ab, "path=", &ctx->file->f_path);
> > +		inode = file_inode(ctx->file);
> > +		if (inode) {
> > +			audit_log_format(ab, " dev=");
> > +			audit_log_untrustedstring(ab, inode->i_sb->s_id);
> 
> See my comments above about using the 'dev' field name, however, you
> shouldn't need to log the device name as an untrusted string as the
> string is coming from a trusted source within the kernel (the driver).
> 
I was trying to follow the existing code at https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/security/lsm_audit.c#n229
But I do agree as it is already in the kernel, it should be trusted. 

> > +			audit_log_format(ab, " ino=%lu ", inode->i_ino);
> > +		}
> > +	}
> > +
> > +	if (match_type == __IPE_MATCH_RULE)
> > +		audit_rule(ab, r);
> > +	else if (match_type == __IPE_MATCH_TABLE)
> > +		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
> > +				 ACTSTR(act));
> > +	else
> > +		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
> > +				 ACTSTR(act));
> > +
> > +	audit_log_end(ab);
> > +}
> 
> ...
> 
> > diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> > index 88c625d6af97..8fcdb2ea19f4 100644
> > --- a/security/ipe/eval.h
> > +++ b/security/ipe/eval.h
> > @@ -13,6 +13,7 @@
> >  #include "policy.h"
> >  
> >  extern struct ipe_policy __rcu *ipe_active_policy;
> > +extern bool success_audit;
> >  
> >  struct ipe_eval_ctx {
> >  	enum ipe_op_type op;
> > @@ -21,6 +22,13 @@ struct ipe_eval_ctx {
> >  	bool from_init_sb;
> >  };
> >  
> > +enum ipe_match {
> > +	__IPE_MATCH_RULE = 0,
> > +	__IPE_MATCH_TABLE,
> > +	__IPE_MATCH_GLOBAL,
> > +	__IPE_MATCH_MAX
> > +};
> > +
> >  void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
> >  int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
> >  void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> > diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> > index 522162af741a..6bd2aa84831b 100644
> > --- a/security/ipe/fs.c
> > +++ b/security/ipe/fs.c
> > @@ -8,11 +8,65 @@
> >  
> >  #include "ipe.h"
> >  #include "fs.h"
> > +#include "eval.h"
> >  #include "policy.h"
> > +#include "audit.h"
> >  
> >  static struct dentry *np __ro_after_init;
> >  static struct dentry *root __ro_after_init;
> >  struct dentry *policy_root __ro_after_init;
> > +static struct dentry *audit_node __ro_after_init;
> > +
> > +/**
> > + * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> > + * @f: Supplies a file structure representing the securityfs node.
> > + * @data: Supplies a buffer passed to the write syscall.
> > + * @len: Supplies the length of @data.
> > + * @offset: unused.
> > + *
> > + * Return:
> > + * * >0	- Success, Length of buffer written
> > + * * <0	- Error
> > + */
> > +static ssize_t setaudit(struct file *f, const char __user *data,
> > +			size_t len, loff_t *offset)
> > +{
> > +	int rc = 0;
> > +	bool value;
> > +
> > +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> > +		return -EPERM;
> > +
> > +	value = READ_ONCE(success_audit);
> 
> I don't understand why you are setting @value here only to change its
> value in the line below ... ?
> 
Sorry my mistake, I thought the value can be not set in the function call but after
reading the source code I found it will return error in that case. I will remove
the above line.

-Fan

> > +	rc = kstrtobool_from_user(data, len, &value);
> > +	if (rc)
> > +		return rc;
> > +
> > +	WRITE_ONCE(success_audit, value);
> > +
> > +	return len;
> > +}
> 
> --
> paul-moore.com
