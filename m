Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EA16A88E7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCBTEX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjCBTEQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:04:16 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAD7F96C
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:03:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so9026pjp.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677783803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FssevT39iJZR1q32L9Ldyz9vD4a6RNVi8ykMS5L1yW0=;
        b=MZq6OPOVyRu1sSz4WecTPIjyC2a7Pf/CbfdJd+Jl6gExGNfwpTa818dup+aGHyLMiR
         UUe1eW16dk6t7yL654sU7zEwyma092q9031/s11yhSm0Md1SEsRS96Rx4XPTF8B9npTm
         RkxXLlJdqmy4EHHD6vSgmhiK4gDGJipI28K3LP03wayEYpaNJPRX8f93TpnKfVAr64Ud
         P/SbiMUHiMN2Y10C6mv7j9xghChgGhgZgHXUHYtTA+VlnC+6fiSAeZLC02+MFHfH/IcN
         QZyHrCg+Ja8jrKIunVYNGQaqItFYq4pIKSQG6I3sX2Yl1lbWhhcU51ONnoWVYF3fvbcj
         rtNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677783803;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FssevT39iJZR1q32L9Ldyz9vD4a6RNVi8ykMS5L1yW0=;
        b=t8UpO/I3zXMFR2twZhJUInA/9e+cxmwUU7VccZxScFpUWvUVYPqRXKxZf075UVS2bD
         xeCscqieDWS7rOB6bwMyhULUyCSUOzFIfqL2GlNXEYXdM5inrGRdbYuYVoHPj35AVtjJ
         W/7bmq4zh4cj1/tSf5+JRvsmk3OklqyEK5oRr19M1lYYFE/vgi9HFYgYaSPD4V4td+Ms
         vBuW5VxAGzePS8TTAT3EOeY36zYm3Ab+dQzQRTwSThKVj1FmwARu1HMBdM9Ebi1Cwesy
         XMvaZEN9krEY5zTN5APQSQwCKxz1eHwLBGDhYclGh1ttmurul27iI3q3HK8di0jEmAIA
         R3dQ==
X-Gm-Message-State: AO0yUKXUiHxhHRclIVwqF7zhq8yoSYp9gfPgytE5XytsH4vS1hNtF1yC
        noY2xhq6W/SATVelbdYyee1pd5QymiNtevlxIsdz
X-Google-Smtp-Source: AK7set+3/GrjQmGEOIf5XN+oR/tJPrT7DH51D3Ab0edP4F+WhT/BThkJbqjsZYFOdsjV/WC6bwO0qzp+XudiOKcSgMg=
X-Received: by 2002:a17:90b:3798:b0:237:7edd:2e08 with SMTP id
 mz24-20020a17090b379800b002377edd2e08mr4456582pjb.0.1677783802723; Thu, 02
 Mar 2023 11:03:22 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:03:11 -0500
Message-ID: <CAHC9VhS_EbT7ze4oSHwHfus91VWQfdgGagf=5O7_h+XJ2o79PA@mail.gmail.com>
Subject: Re: [RFC PATCH v9 03/16] ipe: add evaluation loop and introduce
 'boot_verified' as a trust provider
To:     Fan Wu <wufan@linux.microsoft.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 30, 2023 at 5:58=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
>
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> IPE must have a centralized function to evaluate incoming callers
> against IPE's policy. This iteration of the policy against the rules
> for that specific caller is known as the evaluation loop.
>
> In addition, IPE is designed to provide system level trust guarantees,
> this usually implies that trust starts from bootup with a hardware root
> of trust, which validates the bootloader. After this, the bootloader
> verifies the kernel and the initramfs.
>
> As there's no currently supported integrity method for initramfs, and
> it's typically already verified by the bootloader, introduce a property
> that causes the first superblock to have an execution to be "pinned",
> which is typically initramfs.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

...

> ---
>  security/ipe/Makefile        |   1 +
>  security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h          |  28 ++++++
>  security/ipe/hooks.c         |  25 +++++
>  security/ipe/hooks.h         |  14 +++
>  security/ipe/ipe.c           |   1 +
>  security/ipe/policy.c        |  20 ++++
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |   8 +-
>  9 files changed, 279 insertions(+), 1 deletion(-)
>  create mode 100644 security/ipe/eval.c
>  create mode 100644 security/ipe/eval.h
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h
>
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> index 16bbe80991f1..d7f2870d7c09 100644
> --- a/security/ipe/Makefile
> +++ b/security/ipe/Makefile
> @@ -6,6 +6,7 @@
>  #
>
>  obj-$(CONFIG_SECURITY_IPE) +=3D \
> +       eval.o \
>         hooks.o \
>         ipe.o \
>         policy.o \
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> new file mode 100644
> index 000000000000..48b5104a3463
> --- /dev/null
> +++ b/security/ipe/eval.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/sched.h>
> +#include <linux/rcupdate.h>
> +#include <linux/spinlock.h>
> +
> +struct ipe_policy __rcu *ipe_active_policy;
> +
> +static struct super_block *pinned_sb;
> +static DEFINE_SPINLOCK(pin_lock);
> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> +
> +/**
> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> + * @f: Supplies a file structure to source the super_block from.
> + */
> +static void pin_sb(const struct file *f)
> +{
> +       if (!f)
> +               return;
> +       spin_lock(&pin_lock);
> +       if (pinned_sb)
> +               goto out;
> +       pinned_sb =3D FILE_SUPERBLOCK(f);
> +out:
> +       spin_unlock(&pin_lock);
> +}

Since you don't actually use @f, just the super_block, you might
consider passing the super_block as the parameter and not the
associated file.

I'd probably also flip the if-then to avoid the 'goto', for example:

  static void pin_sb(const struct super_block *sb)
  {
    if (!sb)
      return;
    spin_lock(&pin_lock);
    if (!pinned_sb)
      pinned_sb =3D sb;
    spin_unlock(&pin_lock);
  }

Also, do we need to worry about the initramfs' being unmounted and the
super_block going away?

> +/**
> + * from_pinned - Determine whether @f is source from the pinned super_bl=
ock.
> + * @f: Supplies a file structure to check against the pinned super_block=
.
> + *
> + * Return:
> + * * true      - @f is sourced from the pinned super_block
> + * * false     - @f is not sourced from the pinned super_block
> + */
> +static bool from_pinned(const struct file *f)
> +{
> +       bool rv;
> +
> +       if (!f)
> +               return false;
> +       spin_lock(&pin_lock);
> +       rv =3D !IS_ERR_OR_NULL(pinned_sb) && pinned_sb =3D=3D FILE_SUPERB=
LOCK(f);
> +       spin_unlock(&pin_lock);
> +       return rv;
> +}
> +
> +/**
> + * build_eval_ctx - Build an evaluation context.
> + * @ctx: Supplies a pointer to the context to be populdated.
> + * @file: Supplies a pointer to the file to associated with the evaluati=
on.
> + * @op: Supplies the IPE policy operation associated with the evaluation=
.
> + */
> +void build_eval_ctx(struct ipe_eval_ctx *ctx,
> +                   const struct file *file,
> +                   enum ipe_op_type op)
> +{
> +       ctx->file =3D file;
> +       ctx->op =3D op;
> +       ctx->from_init_sb =3D from_pinned(file);
> +}

I was a little concerned about the spinlock around the pinned
superblock being a potential issue so I was checking the callers of
`build_eval_ctx()` and realized there are no callers in this patch ...
?  Maybe it makes sense for `build_eval_ctx()` to be in this patch but
it seems a little odd.

> +/**
> + * evaluate_property - Analyze @ctx against a property.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + * @p: Supplies a pointer to the property to be evaluated.
> + *
> + * Return:
> + * * true      - The current @ctx match the @p
> + * * false     - The current @ctx doesn't match the @p
> + */
> +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> +                             struct ipe_prop *p)
> +{
> +       bool eval =3D false;
> +
> +       switch (p->type) {
> +       case ipe_prop_boot_verified_false:
> +               eval =3D !ctx->from_init_sb;
> +               break;
> +       case ipe_prop_boot_verified_true:
> +               eval =3D ctx->from_init_sb;
> +               break;
> +       default:
> +               eval =3D false;

You don't need to set @eval to false both when it is declared or in
the 'default' case.

Honestly, you don't need @eval at all, you can simply replace all of
the @eval assignment statements with return statements.

> +       }
> +
> +       return eval;
> +}
> +
> +/**
> + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + *
> + * This is the loop where all policy evaluation happens against IPE poli=
cy.
> + *
> + * Return:
> + * * 0         - OK
> + * * -EACCES   - @ctx did not pass evaluation.
> + * * !0                - Error
> + */
> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> +{
> +       int rc =3D 0;
> +       bool match =3D false;
> +       enum ipe_action_type action;
> +       struct ipe_policy *pol =3D NULL;
> +       const struct ipe_rule *rule =3D NULL;
> +       const struct ipe_op_table *rules =3D NULL;
> +       struct ipe_prop *prop =3D NULL;
> +
> +       if (ctx->op =3D=3D ipe_op_exec)
> +               pin_sb(ctx->file);

If I understand things correctly, the initramfs is determined by the
first process to be executed?  I think that's reasonable, but I'm
beginning to wonder if that pinned super_block spinlock is going to be
a problem, especially for something that is written once (twice if you
consider the ERR_PTR(-EIO) on umount), yet read for each IPE policy
evaluation.

I'm okay if you want to keep this as a spinlock for now, but this
seems like a good candidate for RCU, and the change would be trivial
since it is a single pointer.

> +       pol =3D ipe_get_policy_rcu(ipe_active_policy);

I don't think you can safely drop the RCU lock and leave the RCU
critical section while you are still using @ipe_active_policy.  I
think the right thing to do is to get rid of `ipe_get_policy_rcu()`
and simply place from here on down in `ipe_evaluate_event()` in a RCU
critical section.  Doing so would ensure that @ipe_active_policy could
not be free'd/replaced from underneath you while evaluating an event.

> +       if (!pol)
> +               goto out;
> +
> +       if (ctx->op =3D=3D ipe_op_max) {
> +               action =3D pol->parsed->global_default_action;
> +               goto eval;
> +       }
> +
> +       rules =3D &pol->parsed->rules[ctx->op];
> +
> +       list_for_each_entry(rule, &rules->rules, next) {
> +               match =3D true;
> +
> +               list_for_each_entry(prop, &rule->props, next)
> +                       match =3D match && evaluate_property(ctx, prop);
> +
> +               if (match)
> +                       break;
> +       }
> +
> +       if (match)
> +               action =3D rule->action;
> +       else if (rules->default_action !=3D ipe_action_max)
> +               action =3D rules->default_action;
> +       else
> +               action =3D pol->parsed->global_default_action;
> +
> +eval:
> +       if (action =3D=3D ipe_action_deny)
> +               rc =3D -EACCES;
> +
> +out:
> +       return rc;
> +}
> +
> +/**
> + * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.
> + * @mnt_sb: super_block to check against the pinned super_block.
> + *
> + * This function is called a super_block like the initramfs's is freed,
> + * if the super_block is currently pinned by ipe it will be invalided,
> + * so ipe won't consider the block device is boot verified afterward.
> + */
> +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
> +{
> +       spin_lock(&pin_lock);
> +
> +       if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb =3D=3D pinned_sb)
> +               pinned_sb =3D ERR_PTR(-EIO);

I think you only need to check if @pinned_sb is equal to @mnt_sb,
that's all that really matters here.

> +       spin_unlock(&pin_lock);
> +}
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> new file mode 100644
> index 000000000000..887797438b9b
> --- /dev/null
> +++ b/security/ipe/eval.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#ifndef IPE_EVAL_H
> +#define IPE_EVAL_H
> +
> +#include <linux/file.h>
> +#include <linux/types.h>
> +
> +#include "hooks.h"
> +#include "policy.h"
> +
> +extern struct ipe_policy __rcu *ipe_active_policy;
> +
> +struct ipe_eval_ctx {
> +       enum ipe_op_type op;
> +
> +       const struct file *file;
> +       bool from_init_sb;
> +};
> +
> +void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, e=
num ipe_op_type op);
> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
> +void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
> +
> +#endif /* IPE_EVAL_H */
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..335b773c7ae1
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,25 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "hooks.h"
> +#include "eval.h"
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/binfmts.h>
> +#include <linux/mman.h>
> +
> +/**
> + * ipe_sb_free_security - ipe security hook function for super_block.
> + * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
> + *
> + * IPE does not have any structures with mnt_sb, but uses this hook to
> + * invalidate a pinned super_block.
> + */
> +void ipe_sb_free_security(struct super_block *mnt_sb)
> +{
> +       ipe_invalidate_pinned_sb(mnt_sb);
> +}
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> new file mode 100644
> index 000000000000..30fe455389bf
> --- /dev/null
> +++ b/security/ipe/hooks.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef IPE_HOOKS_H
> +#define IPE_HOOKS_H
> +
> +#include <linux/fs.h>
> +#include <linux/binfmts.h>
> +#include <linux/security.h>
> +
> +void ipe_sb_free_security(struct super_block *mnt_sb);
> +
> +#endif /* IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index 9ed3bf4dcc04..551c6d90ac11 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_ini=
t =3D {
>  };
>
>  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init =3D {
> +       LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
>  };
>
>  /**
> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> index e446f4b84152..772d876b1087 100644
> --- a/security/ipe/policy.c
> +++ b/security/ipe/policy.c
> @@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, si=
ze_t textlen,
>  err:
>         return ERR_PTR(rc);
>  }
> +
> +/**
> + * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
> + *
> + * @p: rcu-protected pointer to a policy.
> + *
> + * Not safe to call on IS_ERR.
> + *
> + * Return: the value of @p
> + */
> +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
> +{
> +       struct ipe_policy *rv =3D NULL;
> +
> +       rcu_read_lock();
> +       rv =3D rcu_dereference(p);
> +       rcu_read_unlock();
> +
> +       return rv;
> +}
> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> index 6af2d9a811ec..967d816cd5cd 100644
> --- a/security/ipe/policy.h
> +++ b/security/ipe/policy.h
> @@ -26,6 +26,8 @@ enum ipe_action_type {
>  };
>
>  enum ipe_prop_type {
> +       ipe_prop_boot_verified_false,
> +       ipe_prop_boot_verified_true,
>         ipe_prop_max
>  };
>
> @@ -73,5 +75,6 @@ struct ipe_policy {
>  struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
>                                   const char *pkcs7, size_t pkcs7len);
>  void ipe_free_policy(struct ipe_policy *pol);
> +struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
>
>  #endif /* IPE_POLICY_H */
> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> index c7ba0e865366..7efafc482e46 100644
> --- a/security/ipe/policy_parser.c
> +++ b/security/ipe/policy_parser.c
> @@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
>  }
>
>  static const match_table_t property_tokens =3D {
> -       {ipe_prop_max,                                  NULL}
> +       {ipe_prop_boot_verified_false,  "boot_verified=3DFALSE"},
> +       {ipe_prop_boot_verified_true,   "boot_verified=3DTRUE"},
> +       {ipe_prop_max,                  NULL}
>  };
>
>  /**
> @@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
>         token =3D match_token(t, property_tokens, args);
>
>         switch (token) {
> +       case ipe_prop_boot_verified_false:
> +       case ipe_prop_boot_verified_true:
> +               p->type =3D token;
> +               break;
>         case ipe_prop_max:
>         default:
>                 rc =3D -EBADMSG;
> --
> 2.39.0

--
paul-moore.com
