Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373817543BB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbjGNU2s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 16:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235472AbjGNU2r (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 16:28:47 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D57831995;
        Fri, 14 Jul 2023 13:28:45 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 353B820ABD64; Fri, 14 Jul 2023 13:28:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 353B820ABD64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689366525;
        bh=P3inuFi0gMXqoY/7xlKkhztUrimCDUfNFGSqCXwgTfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9xCGTHAMzWx55C7H1MErPQE+n5ghx5PbMvaBnwI0vs8CCBaJ5VU9tOOqs/Jg36+p
         wycIU9OWZ8tR0M5Yitid06KA4Yk3IPi5PSM32luz0EIsXBdKDL1X3jGYf4zsWPrIvt
         JpNuiSLgROZLx0DdvUXKjEhBMKE7PX/6muWF71q4=
Date:   Fri, 14 Jul 2023 13:28:45 -0700
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
Subject: Re: [PATCH RFC v10 3/17] ipe: add evaluation loop
Message-ID: <20230714202845.GB15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
 <309cfd62a474a7e93be6a0886a3d5aa8.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <309cfd62a474a7e93be6a0886a3d5aa8.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 08, 2023 at 12:23:01AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE must have a centralized function to evaluate incoming callers
> > against IPE's policy. This iteration of the policy for against the rules
> > for that specific caller is known as the evaluation loop.
> 
> Can you rewrite that second sentence, it reads a bit awkward and I'm
> unclear as to the meaning.
> 
Sure, it is indeed not clear, I might rewrite the whole message in the next version.

> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile |  1 +
> >  security/ipe/eval.c   | 94 +++++++++++++++++++++++++++++++++++++++++++
> >  security/ipe/eval.h   | 25 ++++++++++++
> >  3 files changed, 120 insertions(+)
> >  create mode 100644 security/ipe/eval.c
> >  create mode 100644 security/ipe/eval.h
> 
> ...
> 
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > new file mode 100644
> > index 000000000000..59144b2ecdda
> > --- /dev/null
> > +++ b/security/ipe/eval.c
> > @@ -0,0 +1,94 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <linux/sched.h>
> > +#include <linux/rcupdate.h>
> > +
> > +#include "ipe.h"
> > +#include "eval.h"
> > +#include "hooks.h"
> 
> There is no "hooks.h" at this point in the patchset.
> 
> In order for 'git bisect' to remain useful (and it can be a very handy
> tool), we need to ensure that each point in the patchset compiles
> cleanly.
> 
Sorry for the mistake here, I will avoid this kind of problems in the future.

> > +#include "policy.h"
> > +
> > +struct ipe_policy __rcu *ipe_active_policy;
> > +
> > +/**
> > + * evaluate_property - Analyze @ctx against a property.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + * @p: Supplies a pointer to the property to be evaluated.
> > + *
> > + * Return:
> > + * * true	- The current @ctx match the @p
> > + * * false	- The current @ctx doesn't match the @p
> > + */
> > +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> > +			      struct ipe_prop *p)
> > +{
> > +	return false;
> > +}
> > +
> > +/**
> > + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> > + * @ctx: Supplies a pointer to the context to be evaluated.
> > + *
> > + * This is the loop where all policy evaluation happens against IPE policy.
> > + *
> > + * Return:
> > + * * 0		- OK
> > + * * -EACCES	- @ctx did not pass evaluation.
> > + * * !0		- Error
> > + */
> > +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> > +{
> > +	int rc = 0;
> > +	bool match = false;
> > +	enum ipe_action_type action;
> > +	struct ipe_policy *pol = NULL;
> > +	const struct ipe_rule *rule = NULL;
> > +	const struct ipe_op_table *rules = NULL;
> > +	struct ipe_prop *prop = NULL;
> > +
> > +	rcu_read_lock();
> > +
> > +	pol = rcu_dereference(ipe_active_policy);
> > +	if (!pol) {
> > +		rcu_read_unlock();
> > +		return 0;
> > +	}
> > +
> > +	if (ctx->op == __IPE_OP_INVALID) {
> > +		action = pol->parsed->global_default_action;
> > +		goto eval;
> 
> It looks like you are missing a rcu_read_unlock() in this case.
> 
Thanks for pointing that out. I will add the unlock. 
> Also, given how simplistic the evaluation is in this case, why not
> just do it here, saving the assignment, jump, etc.?
> 
>   if (ctx->op == INVALID) {
>     rcu_read_unlock()
>     if (global_action == DENY)
>       return -EACCES;
>     return 0;
>   }
> 
The jump is actually for auditing the decision in the next patch, while
it does make more sense to not jump when the auditing is not introduced. 
I will make the return here then switch to jump in the auditing patch.

> > +	}
> > +
> > +	rules = &pol->parsed->rules[ctx->op];
> > +
> > +	list_for_each_entry(rule, &rules->rules, next) {
> > +		match = true;
> > +
> > +		list_for_each_entry(prop, &rule->props, next)
> > +			match = match && evaluate_property(ctx, prop);
> 
> Why not break from this loop once evaluate_property() returns false?
> 
Yes we can break when one property evals to false, thanks for the advice.

> > +
> > +		if (match)
> > +			break;
> > +	}
> > +
> > +	if (match)
> > +		action = rule->action;
> > +	else if (rules->default_action != __IPE_ACTION_INVALID)
> > +		action = rules->default_action;
> > +	else
> > +		action = pol->parsed->global_default_action;
> > +
> > +	rcu_read_unlock();
> > +eval:
> > +	if (action == __IPE_ACTION_DENY)
> > +		rc = -EACCES;
> > +
> > +	return rc;
> 
> This can just be 'return 0;' right?
> 
For this patch, if we just return on error, then yes the end of the function
could just return 0. But when auditing(audit rc) and permissive switch(overwrite rc)
are introduced then return on error might not be the clean way. So I kept
the rc variable in this patch. I can change the style in this patch then
switch to use rc when auditing and permissive switch are introduced.

-Fan

> > +}
> 
> --
> paul-moore.com
