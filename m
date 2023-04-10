Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC8A6DCB34
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 20:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDJSxk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 14:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDJSxj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 14:53:39 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39980E4;
        Mon, 10 Apr 2023 11:53:35 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 99EB92174E2A; Mon, 10 Apr 2023 11:53:34 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99EB92174E2A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1681152814;
        bh=6k4RqFSClh1JCnvAAxRswlmchYa0DJUjXyAdfc2QE8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KHDLnhB8SnkcU0ENyT4L8IqUsgr7Nl9Dy7xsbX5ee2cKmrHXRLo1D3b+au7r6WT9d
         FnSyoMEwf4y2vM/6gHR1e/R20YqVwo4bbJefzizzKS1bgHLMaBMzT0f3GWYTEqKfmx
         GaTfDWdahgG3vccJbhUB48ivfSr/HzjtOVn9Nmso=
Date:   Mon, 10 Apr 2023 11:53:34 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v9 03/16] ipe: add evaluation loop and introduce
 'boot_verified' as a trust provider
Message-ID: <20230410185334.GA18827@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 02, 2023 at 02:03:11PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
> >
> > IPE must have a centralized function to evaluate incoming callers
> > against IPE's policy. This iteration of the policy against the rules
> > for that specific caller is known as the evaluation loop.
> >
> > In addition, IPE is designed to provide system level trust guarantees,
> > this usually implies that trust starts from bootup with a hardware root
> > of trust, which validates the bootloader. After this, the bootloader
> > verifies the kernel and the initramfs.
> >
> > As there's no currently supported integrity method for initramfs, and
> > it's typically already verified by the bootloader, introduce a property
> > that causes the first superblock to have an execution to be "pinned",
> > which is typically initramfs.
> >
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ...
> 
> > ---
> >  security/ipe/Makefile        |   1 +
> >  security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
> >  security/ipe/eval.h          |  28 ++++++
> >  security/ipe/hooks.c         |  25 +++++
> >  security/ipe/hooks.h         |  14 +++
> >  security/ipe/ipe.c           |   1 +
> >  security/ipe/policy.c        |  20 ++++
> >  security/ipe/policy.h        |   3 +
> >  security/ipe/policy_parser.c |   8 +-
> >  9 files changed, 279 insertions(+), 1 deletion(-)
> >  create mode 100644 security/ipe/eval.c
> >  create mode 100644 security/ipe/eval.h
> >  create mode 100644 security/ipe/hooks.c
> >  create mode 100644 security/ipe/hooks.h
> >
> > diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> > index 16bbe80991f1..d7f2870d7c09 100644
> > --- a/security/ipe/Makefile
> > +++ b/security/ipe/Makefile
> > @@ -6,6 +6,7 @@
> >  #
> >
> >  obj-$(CONFIG_SECURITY_IPE) += \
> > +       eval.o \
> >         hooks.o \
> >         ipe.o \
> >         policy.o \
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > new file mode 100644
> > index 000000000000..48b5104a3463
> > --- /dev/null
> > +++ b/security/ipe/eval.c
> > @@ -0,0 +1,180 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "ipe.h"
> > +#include "eval.h"
> > +#include "hooks.h"
> > +#include "policy.h"
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <linux/sched.h>
> > +#include <linux/rcupdate.h>
> > +#include <linux/spinlock.h>
> > +
> > +struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +static struct super_block *pinned_sb;
> > +static DEFINE_SPINLOCK(pin_lock);
> > +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> > +
> > +/**
> > + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> > + * @f: Supplies a file structure to source the super_block from.
> > + */
> > +static void pin_sb(const struct file *f)
> > +{
> > +       if (!f)
> > +               return;
> > +       spin_lock(&pin_lock);
> > +       if (pinned_sb)
> > +               goto out;
> > +       pinned_sb = FILE_SUPERBLOCK(f);
> > +out:
> > +       spin_unlock(&pin_lock);
> > +}
> 
> Since you don't actually use @f, just the super_block, you might
> consider passing the super_block as the parameter and not the
> associated file.
> 
> I'd probably also flip the if-then to avoid the 'goto', for example:
> 
>   static void pin_sb(const struct super_block *sb)
>   {
>     if (!sb)
>       return;
>     spin_lock(&pin_lock);
>     if (!pinned_sb)
>       pinned_sb = sb;
>     spin_unlock(&pin_lock);
>   }
> 

Sure, I can change the code accordingly. 

> Also, do we need to worry about the initramfs' being unmounted and the
> super_block going away?
> 

If initramfs is being unmounted, the boot_verified property will never be TRUE,
which is an expected behavior. In an actual use case, we can leverage this
property to only enable files in initramfs during the booting stage, and later switch
to another policy without the boot_verified property after unmounting the initramfs.
This approach helps keep the allowed set of files minimum at each stage.

> > +/**
> > + * from_pinned - Determine whether @f is source from the pinned super_block.
> > + * @f: Supplies a file structure to check against the pinned super_block.
> > + *
> > + * Return:
> > + * * true      - @f is sourced from the pinned super_block
> > + * * false     - @f is not sourced from the pinned super_block
> > + */
> > +static bool from_pinned(const struct file *f)
> > +{
> > +       bool rv;
> > +
> > +       if (!f)
> > +               return false;
> > +       spin_lock(&pin_lock);
> > +       rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
> > +       spin_unlock(&pin_lock);
> > +       return rv;
> > +}
> > +
> > +/**
> > + * build_eval_ctx - Build an evaluation context.
> > + * @ctx: Supplies a pointer to the context to be populdated.
> > + * @file: Supplies a pointer to the file to associated with the evaluation.
> > + * @op: Supplies the IPE policy operation associated with the evaluation.
> > + */
> > +void build_eval_ctx(struct ipe_eval_ctx *ctx,
> > +                   const struct file *file,
> > +                   enum ipe_op_type op)
> > +{
> > +       ctx->file = file;
> > +       ctx->op = op;
> > +       ctx->from_init_sb = from_pinned(file);
> > +}
> 
> I was a little concerned about the spinlock around the pinned
> superblock being a potential issue so I was checking the callers of
> `build_eval_ctx()` and realized there are no callers in this patch ...
> ?  Maybe it makes sense for `build_eval_ctx()` to be in this patch but
> it seems a little odd.
> 

I can try to move this function to a later patch.

> > +/**
> > + * evaluate_property - Analyze @ctx against a property.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + * @p: Supplies a pointer to the property to be evaluated.
> > + *
> > + * Return:
> > + * * true      - The current @ctx match the @p
> > + * * false     - The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> > +                             struct ipe_prop *p)
> > +{
> > +       bool eval = false;
> > +
> > +       switch (p->type) {
> > +       case ipe_prop_boot_verified_false:
> > +               eval = !ctx->from_init_sb;
> > +               break;
> > +       case ipe_prop_boot_verified_true:
> > +               eval = ctx->from_init_sb;
> > +               break;
> > +       default:
> > +               eval = false;
> 
> You don't need to set @eval to false both when it is declared or in
> the 'default' case.
> 
> Honestly, you don't need @eval at all, you can simply replace all of
> the @eval assignment statements with return statements.
> 

Yep, this makes sense to me, I will replace them with returns.

> > +       }
> > +
> > +       return eval;
> > +}
> > +
> > +/**
> > + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + *
> > + * This is the loop where all policy evaluation happens against IPE policy.
> > + *
> > + * Return:
> > + * * 0         - OK
> > + * * -EACCES   - @ctx did not pass evaluation.
> > + * * !0                - Error
> > + */
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> > +{
> > +       int rc = 0;
> > +       bool match = false;
> > +       enum ipe_action_type action;
> > +       struct ipe_policy *pol = NULL;
> > +       const struct ipe_rule *rule = NULL;
> > +       const struct ipe_op_table *rules = NULL;
> > +       struct ipe_prop *prop = NULL;
> > +
> > +       if (ctx->op == ipe_op_exec)
> > +               pin_sb(ctx->file);
> 
> If I understand things correctly, the initramfs is determined by the
> first process to be executed?  I think that's reasonable, but I'm
> beginning to wonder if that pinned super_block spinlock is going to be
> a problem, especially for something that is written once (twice if you
> consider the ERR_PTR(-EIO) on umount), yet read for each IPE policy
> evaluation.
> 
> I'm okay if you want to keep this as a spinlock for now, but this
> seems like a good candidate for RCU, and the change would be trivial
> since it is a single pointer.
> 

I agree switching to RCU will be better, I will change this part.

> > +       pol = ipe_get_policy_rcu(ipe_active_policy);
> 
> I don't think you can safely drop the RCU lock and leave the RCU
> critical section while you are still using @ipe_active_policy.  I
> think the right thing to do is to get rid of `ipe_get_policy_rcu()`
> and simply place from here on down in `ipe_evaluate_event()` in a RCU
> critical section.  Doing so would ensure that @ipe_active_policy could
> not be free'd/replaced from underneath you while evaluating an event.
> 

Yes After reading the RCU documentation, I realized that we were mistaken.
I will place the entire eval function into the critical section instead.

> > +       if (!pol)
> > +               goto out;
> > +
> > +       if (ctx->op == ipe_op_max) {
> > +               action = pol->parsed->global_default_action;
> > +               goto eval;
> > +       }
> > +
> > +       rules = &pol->parsed->rules[ctx->op];
> > +
> > +       list_for_each_entry(rule, &rules->rules, next) {
> > +               match = true;
> > +
> > +               list_for_each_entry(prop, &rule->props, next)
> > +                       match = match && evaluate_property(ctx, prop);
> > +
> > +               if (match)
> > +                       break;
> > +       }
> > +
> > +       if (match)
> > +               action = rule->action;
> > +       else if (rules->default_action != ipe_action_max)
> > +               action = rules->default_action;
> > +       else
> > +               action = pol->parsed->global_default_action;
> > +
> > +eval:
> > +       if (action == ipe_action_deny)
> > +               rc = -EACCES;
> > +
> > +out:
> > +       return rc;
> > +}
> > +
> > +/**
> > + * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.
> > + * @mnt_sb: super_block to check against the pinned super_block.
> > + *
> > + * This function is called a super_block like the initramfs's is freed,
> > + * if the super_block is currently pinned by ipe it will be invalided,
> > + * so ipe won't consider the block device is boot verified afterward.
> > + */
> > +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
> > +{
> > +       spin_lock(&pin_lock);
> > +
> > +       if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb == pinned_sb)
> > +               pinned_sb = ERR_PTR(-EIO);
> 
> I think you only need to check if @pinned_sb is equal to @mnt_sb,
> that's all that really matters here.
> 

Agree, will remove the unnecessary part.

> > +       spin_unlock(&pin_lock);
> > +}
> > diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> > new file mode 100644
> > index 000000000000..887797438b9b
> > --- /dev/null
> > +++ b/security/ipe/eval.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#ifndef IPE_EVAL_H
> > +#define IPE_EVAL_H
> > +
> > +#include <linux/file.h>
> > +#include <linux/types.h>
> > +
> > +#include "hooks.h"
> > +#include "policy.h"
> > +
> > +extern struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +struct ipe_eval_ctx {
> > +       enum ipe_op_type op;
> > +
> > +       const struct file *file;
> > +       bool from_init_sb;
> > +};
> > +
> > +void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
> > +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> > +
> > +#endif /* IPE_EVAL_H */
> > diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> > new file mode 100644
> > index 000000000000..335b773c7ae1
> > --- /dev/null
> > +++ b/security/ipe/hooks.c
> > @@ -0,0 +1,25 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "ipe.h"
> > +#include "hooks.h"
> > +#include "eval.h"
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/mman.h>
> > +
> > +/**
> > + * ipe_sb_free_security - ipe security hook function for super_block.
> > + * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
> > + *
> > + * IPE does not have any structures with mnt_sb, but uses this hook to
> > + * invalidate a pinned super_block.
> > + */
> > +void ipe_sb_free_security(struct super_block *mnt_sb)
> > +{
> > +       ipe_invalidate_pinned_sb(mnt_sb);
> > +}
> > diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> > new file mode 100644
> > index 000000000000..30fe455389bf
> > --- /dev/null
> > +++ b/security/ipe/hooks.h
> > @@ -0,0 +1,14 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef IPE_HOOKS_H
> > +#define IPE_HOOKS_H
> > +
> > +#include <linux/fs.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/security.h>
> > +
> > +void ipe_sb_free_security(struct super_block *mnt_sb);
> > +
> > +#endif /* IPE_HOOKS_H */
> > diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> > index 9ed3bf4dcc04..551c6d90ac11 100644
> > --- a/security/ipe/ipe.c
> > +++ b/security/ipe/ipe.c
> > @@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
> >  };
> >
> >  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
> > +       LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
> >  };
> >
> >  /**
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > index e446f4b84152..772d876b1087 100644
> > --- a/security/ipe/policy.c
> > +++ b/security/ipe/policy.c
> > @@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> >  err:
> >         return ERR_PTR(rc);
> >  }
> > +
> > +/**
> > + * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
> > + *
> > + * @p: rcu-protected pointer to a policy.
> > + *
> > + * Not safe to call on IS_ERR.
> > + *
> > + * Return: the value of @p
> > + */
> > +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
> > +{
> > +       struct ipe_policy *rv = NULL;
> > +
> > +       rcu_read_lock();
> > +       rv = rcu_dereference(p);
> > +       rcu_read_unlock();
> > +
> > +       return rv;
> > +}
> > diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> > index 6af2d9a811ec..967d816cd5cd 100644
> > --- a/security/ipe/policy.h
> > +++ b/security/ipe/policy.h
> > @@ -26,6 +26,8 @@ enum ipe_action_type {
> >  };
> >
> >  enum ipe_prop_type {
> > +       ipe_prop_boot_verified_false,
> > +       ipe_prop_boot_verified_true,
> >         ipe_prop_max
> >  };
> >
> > @@ -73,5 +75,6 @@ struct ipe_policy {
> >  struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> >                                   const char *pkcs7, size_t pkcs7len);
> >  void ipe_free_policy(struct ipe_policy *pol);
> > +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
> >
> >  #endif /* IPE_POLICY_H */
> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > index c7ba0e865366..7efafc482e46 100644
> > --- a/security/ipe/policy_parser.c
> > +++ b/security/ipe/policy_parser.c
> > @@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
> >  }
> >
> >  static const match_table_t property_tokens = {
> > -       {ipe_prop_max,                                  NULL}
> > +       {ipe_prop_boot_verified_false,  "boot_verified=FALSE"},
> > +       {ipe_prop_boot_verified_true,   "boot_verified=TRUE"},
> > +       {ipe_prop_max,                  NULL}
> >  };
> >
> >  /**
> > @@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
> >         token = match_token(t, property_tokens, args);
> >
> >         switch (token) {
> > +       case ipe_prop_boot_verified_false:
> > +       case ipe_prop_boot_verified_true:
> > +               p->type = token;
> > +               break;
> >         case ipe_prop_max:
> >         default:
> >                 rc = -EBADMSG;
> > --
> > 2.39.0
> 
> --
> paul-moore.com
