Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D425674BC14
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjGHFha (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjGHFhL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:11 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361582139
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:36:58 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-635eedf073eso17176076d6.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794617; x=1691386617;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pr9IRZWW9eKpjkAEIe/1R+NHyAjULaMI0VUp/S3+Lu8=;
        b=cnEGslyQpdnBNLSSp1rxXhTSSkhDwfqUSx/Ul9J71t2DK99oYfA/K6u/Ej+Hv3Wq/r
         jUDFg555SvEL3MsR4lk83PktHqF36QcKnjNP/seQerubrhFtJsn4xCiIgC5HO2UMbiT0
         vZAKIKsOjeVtV2JxdN6AALNiDj5ylJgsA2FNCNYuWdqfgnQZBiCTwnHSC2xytauHOuCD
         ow1E4PvHNMKk6S17+7mrFKmMbQJDzpiaQVbqJcv1af80ac280QUIPZTXrfcRx2Y56eWU
         f7so5MIVQigRRgcM7IapiXZH+ltrnfRoS3ghDhatYUcW2hsq+J0Q8I3Pyx0wwDeKH5m4
         Cvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794617; x=1691386617;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pr9IRZWW9eKpjkAEIe/1R+NHyAjULaMI0VUp/S3+Lu8=;
        b=Oqpql0j4NS6nZP5/kQtV1ffmY8OkOys9e9wt4HyvL9svxrzJI8n04YaVod0YvQ2vpi
         5j34Rv6q6JCtywy1HmBi37x8lvOiHIsoi/U1vWuafDW5ztQEooZwxx0ognkL4NRcdyqx
         JCeRWjrG/Oyo2RTZog9bQL6OBAljWc5nkyp0C2DtjgPXLIuMooLoq1sSGJirBuE9vFBe
         z6Jn6iwmlOGevLTSSTi6v5fVQ3ss3bfxrPvFsJru2yWHu5u3Rphg3C0DEcI0BfG0Bjaj
         zSoHqYkLatn3XSHYdzQaRYEmodtV+m2ydp6/VMMsWlXbioY2dCiJVHr53uor14k1cYpo
         M6Qw==
X-Gm-Message-State: ABy/qLalbsnARBEgH+pcmSgkklTVInI1dYiCs8jAIOb+jdtjnR22PHK8
        4J4KnCAZ/MlaermhLEG9z69b
X-Google-Smtp-Source: APBJJlHVEnPnUDGr6mQjbAqrTDHyLKUL8eVo8SubbpUGbeUzE5umQXjhguJpoCwsEuQ9Nx80Dqycqg==
X-Received: by 2002:a0c:dc01:0:b0:636:836e:8064 with SMTP id s1-20020a0cdc01000000b00636836e8064mr6540486qvk.63.1688794616895;
        Fri, 07 Jul 2023 22:36:56 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id t25-20020a0cb399000000b006238f82cde4sm2951181qve.108.2023.07.07.22.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:36:56 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:36:56 -0400
Message-ID: <a7ca7bc6780787ab1e2f0d4b93016700.paul@paul-moore.com>
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
Subject: Re: [PATCH RFC v10 3/17] ipe: add evaluation loop
References: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-4-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE must have a centralized function to evaluate incoming callers
> against IPE's policy. This iteration of the policy for against the rules
> for that specific caller is known as the evaluation loop.

Can you rewrite that second sentence, it reads a bit awkward and I'm
unclear as to the meaning.

> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile |  1 +
>  security/ipe/eval.c   | 94 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h   | 25 ++++++++++++
>  3 files changed, 120 insertions(+)
>  create mode 100644 security/ipe/eval.c
>  create mode 100644 security/ipe/eval.h

...

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> new file mode 100644
> index 000000000000..59144b2ecdda
> --- /dev/null
> +++ b/security/ipe/eval.c
> @@ -0,0 +1,94 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/file.h>
> +#include <linux/sched.h>
> +#include <linux/rcupdate.h>
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"

There is no "hooks.h" at this point in the patchset.

In order for 'git bisect' to remain useful (and it can be a very handy
tool), we need to ensure that each point in the patchset compiles
cleanly.

> +#include "policy.h"
> +
> +struct ipe_policy __rcu *ipe_active_policy;
> +
> +/**
> + * evaluate_property - Analyze @ctx against a property.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + * @p: Supplies a pointer to the property to be evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
> +			      struct ipe_prop *p)
> +{
> +	return false;
> +}
> +
> +/**
> + * ipe_evaluate_event - Analyze @ctx against the current active policy.
> + * @ctx: Supplies a pointer to the context to be evaluated.
> + *
> + * This is the loop where all policy evaluation happens against IPE policy.
> + *
> + * Return:
> + * * 0		- OK
> + * * -EACCES	- @ctx did not pass evaluation.
> + * * !0		- Error
> + */
> +int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
> +{
> +	int rc = 0;
> +	bool match = false;
> +	enum ipe_action_type action;
> +	struct ipe_policy *pol = NULL;
> +	const struct ipe_rule *rule = NULL;
> +	const struct ipe_op_table *rules = NULL;
> +	struct ipe_prop *prop = NULL;
> +
> +	rcu_read_lock();
> +
> +	pol = rcu_dereference(ipe_active_policy);
> +	if (!pol) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
> +
> +	if (ctx->op == __IPE_OP_INVALID) {
> +		action = pol->parsed->global_default_action;
> +		goto eval;

It looks like you are missing a rcu_read_unlock() in this case.

Also, given how simplistic the evaluation is in this case, why not
just do it here, saving the assignment, jump, etc.?

  if (ctx->op == INVALID) {
    rcu_read_unlock()
    if (global_action == DENY)
      return -EACCES;
    return 0;
  }

> +	}
> +
> +	rules = &pol->parsed->rules[ctx->op];
> +
> +	list_for_each_entry(rule, &rules->rules, next) {
> +		match = true;
> +
> +		list_for_each_entry(prop, &rule->props, next)
> +			match = match && evaluate_property(ctx, prop);

Why not break from this loop once evaluate_property() returns false?

> +
> +		if (match)
> +			break;
> +	}
> +
> +	if (match)
> +		action = rule->action;
> +	else if (rules->default_action != __IPE_ACTION_INVALID)
> +		action = rules->default_action;
> +	else
> +		action = pol->parsed->global_default_action;
> +
> +	rcu_read_unlock();
> +eval:
> +	if (action == __IPE_ACTION_DENY)
> +		rc = -EACCES;
> +
> +	return rc;

This can just be 'return 0;' right?

> +}

--
paul-moore.com
