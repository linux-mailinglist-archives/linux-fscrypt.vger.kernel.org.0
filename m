Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4AA74BC07
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjGHFhO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbjGHFhB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:01 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D692123
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:36:57 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4039f0d140eso8057451cf.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794616; x=1691386616;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8vhWvQ+HIeKxtbu9t/iKboGRzIGP6y7RZUqn4rd0xJo=;
        b=fdRL7xX+eSfHc9l349SZZQzcmwjli1bYhlOjKsKWmvlq6lCra4lPeOhOvssB6sQ0x+
         AL6uyiAm4D/HAEqFEasgQh6ULnj8GEsDj2m1oQxpdEwzdnn1ZOsS9OVzjvt0oaAF/oL2
         eo82i53p2IE5vvpa3+sQiwJ2n6PZi3H9fgrMTgJEPk8euRbBlRozfAi4VRl45d8znPnz
         wlNwS+nAhF2XiRaxUBjGygGy9EBSaZd9xr0Hvw0pIQHINJ0KoBNCqZlNDnkaMIhk3Kfq
         ZhHn+Vu5HOtsX6dMfoT+430qhJBZWGde7p/owY+TNNY7jR0dcsGfOww3VPOasRHaLQkv
         1v+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794616; x=1691386616;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8vhWvQ+HIeKxtbu9t/iKboGRzIGP6y7RZUqn4rd0xJo=;
        b=Yi+F3hIPPu2Fr0SJ3BaG7qubtix4mSLCc0bpdCKQv8wBq3Ufce81dtvACMqSy6+TyI
         Rb2qfGTKOtOssK1d90PutWdZCHqTFUA9uxn76meb8k1+2WRVFQdhUATX4CSYGuLtfxp0
         fMZb3DZK7j12NgNAZ6Rl25rPw0JkumsmONczP0NdIRoMt9nMb4Yf5sF25rn7zr603czy
         AGYQybzRe/H2sLqjSudqaLJCL6yHehc9ELaphqCEkLN+jtMuPrEeKK57Z5mcD8B5SpFH
         wribmQluaIpNezj5TGQSordhVYWy+zZKfcR4UMp6HgzjsYzARF90lGEMSmWS6l6CcsD4
         8TfQ==
X-Gm-Message-State: ABy/qLZ/cyCo70OE1jryXS8ZioeNi8OCA9rYOPSNKO5hd7Wr/RgYqqxR
        ZS/9lDn9MR5TPsc3ZS7Ha8Ph
X-Google-Smtp-Source: APBJJlGS6QkcaojJ51y27g6fEhYWrJspUv8fSJt2GrIbyIfM4i/xFNiSjdaR6x7s/mOzbvvPGql2MA==
X-Received: by 2002:ac8:5793:0:b0:402:2e84:f06e with SMTP id v19-20020ac85793000000b004022e84f06emr9536600qta.27.1688794616056;
        Fri, 07 Jul 2023 22:36:56 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id p1-20020a0c9a01000000b0062def68f75csm2971727qvd.124.2023.07.07.22.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:36:55 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:36:55 -0400
Message-ID: <d4b1522c467839c02d38ff9da99ebbd3.paul@paul-moore.com>
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
Subject: Re: [PATCH RFC v10 2/17] ipe: add policy parser
References: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
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
> IPE's interpretation of the what the user trusts is accomplished through
> its policy. IPE's design is to not provide support for a single trust
> provider, but to support multiple providers to enable the end-user to
> choose the best one to seek their needs.
> 
> This requires the policy to be rather flexible and modular so that
> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> some other system, can plug into the policy with minimal code changes.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Makefile        |   2 +
>  security/ipe/policy.c        |  97 +++++++
>  security/ipe/policy.h        |  83 ++++++
>  security/ipe/policy_parser.c | 488 +++++++++++++++++++++++++++++++++++
>  security/ipe/policy_parser.h |  11 +
>  5 files changed, 681 insertions(+)
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h
>  create mode 100644 security/ipe/policy_parser.c
>  create mode 100644 security/ipe/policy_parser.h

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> new file mode 100644
> index 000000000000..4069ff075093
> --- /dev/null
> +++ b/security/ipe/policy.c
> @@ -0,0 +1,97 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/verification.h>
> +
> +#include "ipe.h"
> +#include "policy.h"
> +#include "policy_parser.h"
> +
> +/**
> + * ipe_free_policy - Deallocate a given IPE policy.
> + * @p: Supplies the policy to free.
> + *
> + * Safe to call on IS_ERR/NULL.
> + */
> +void ipe_free_policy(struct ipe_policy *p)
> +{
> +	if (IS_ERR_OR_NULL(p))
> +		return;
> +
> +	free_parsed_policy(p->parsed);
> +	if (!p->pkcs7)
> +		kfree(p->text);

Since it's safe to kfree(NULL), you could kfree(p->text) without
having to check if p->pkcs7 was non-NULL, correct?

> +	kfree(p->pkcs7);
> +	kfree(p);
> +}

...

> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> new file mode 100644
> index 000000000000..113a037f0d71
> --- /dev/null
> +++ b/security/ipe/policy.h
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef _IPE_POLICY_H
> +#define _IPE_POLICY_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +
> +enum ipe_op_type {
> +	__IPE_OP_EXEC = 0,
> +	__IPE_OP_FIRMWARE,
> +	__IPE_OP_KERNEL_MODULE,
> +	__IPE_OP_KEXEC_IMAGE,
> +	__IPE_OP_KEXEC_INITRAMFS,
> +	__IPE_OP_IMA_POLICY,
> +	__IPE_OP_IMA_X509,
> +	__IPE_OP_MAX
> +};

Thanks for capitalizing the enums, that helps make IPE consistent with
the majority of the kernel.  However, when I talked about using
underscores for "__IPE_OP_MAX", I was talking about *only*
"__IPE_OP_MAX" to help indicate it is a sentinel value and not an enum
value that would normally be used by itself.

Here is what I was intending:

enum ipe_op_type {
  IPE_OP_EXEC = 0,
  IPE_OP_FIRMWARE,
  ...
  IPE_OP_IMA_X509,
  __IPE_OP_MAX
};

> +#define __IPE_OP_INVALID __IPE_OP_MAX

Similarly, I would remove the underscores from "__IPE_OP_INVALID":

#define IPE_OP_INVALID __IPE_OP_MAX

Both of these comments would apply to the other IPE enums as well.

> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> new file mode 100644
> index 000000000000..27e5767480b0
> --- /dev/null
> +++ b/security/ipe/policy_parser.c
> @@ -0,0 +1,488 @@

...

> +/**
> + * parse_header - Parse policy header information.
> + * @line: Supplies header line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Standard errno
> + */
> +static int parse_header(char *line, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	char *t, *ver = NULL;
> +	substring_t args[MAX_OPT_ARGS];
> +	size_t idx = 0;
> +
> +	while ((t = strsep(&line, " \t")) != NULL) {

It might be nice to define a macro to help reinforce that " \t" are
the IPE policy delimiters, how about IPE_POLICY_DELIM?

#define IPE_POLICY_DELIM " \t"

> +		int token;
> +
> +		if (*t == '\0')
> +			continue;

Why would you want to continue if you run into a NUL byte?  You would
only run into a NUL byte if the line was trimmed due to comments or
whitespace, correct?  If that is the case, wouldn't you want to
break out of this loop when hitting a NUL byte?

> +		if (idx >= __IPE_HEADER_MAX) {
> +			rc = -EBADMSG;
> +			goto err;
> +		}
> +
> +		token = match_token(t, header_tokens, args);
> +		if (token != idx) {
> +			rc = -EBADMSG;
> +			goto err;
> +		}
> +
> +		switch (token) {
> +		case __IPE_HEADER_POLICY_NAME:
> +			p->name = match_strdup(&args[0]);
> +			if (!p->name)
> +				rc = -ENOMEM;
> +			break;
> +		case __IPE_HEADER_POLICY_VERSION:
> +			ver = match_strdup(&args[0]);
> +			if (!ver) {
> +				rc = -ENOMEM;
> +				break;
> +			}
> +			rc = parse_version(ver, p);
> +			break;
> +		default:
> +			rc = -EBADMSG;
> +		}
> +		if (rc)
> +			goto err;
> +		++idx;
> +	}
> +
> +	if (idx != __IPE_HEADER_MAX) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +out:
> +	kfree(ver);
> +	return rc;
> +err:
> +	kfree(p->name);
> +	p->name = NULL;
> +	goto out;

Do we need to worry about ipe_parsed_policy::name here?  If we are
returning an error the caller will call free_parsed_policy() for us,
right?  This would allow us to get rid of the 'err' jump label and
simply use 'out' for both success and failure.

> +}

...

> +/**
> + * parse_rule - parse a policy rule line.
> + * @line: Supplies rule line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * !IS_ERR	- OK
> + * * -ENOMEM	- Out of memory
> + * * -EBADMSG	- Policy syntax error
> + */
> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	bool first_token = true, is_default_rule = false;
> +	bool op_parsed = false;
> +	enum ipe_op_type op = __IPE_OP_INVALID;
> +	enum ipe_action_type action = __IPE_ACTION_INVALID;
> +	struct ipe_rule *r = NULL;
> +	char *t;
> +
> +	r = kzalloc(sizeof(*r), GFP_KERNEL);
> +	if (!r)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&r->next);
> +	INIT_LIST_HEAD(&r->props);
> +
> +	while (t = strsep(&line, " \t"), line) {

See my previous comment about IPE_POLICY_DELIM.

> +		if (*t == '\0')
> +			continue;

I still wonder why continuing here is the desired behavior, can you
help me understand?

> +		if (first_token && token_default(t)) {
> +			is_default_rule = true;
> +		} else {
> +			if (!op_parsed) {
> +				op = parse_operation(t);
> +				if (op == __IPE_OP_INVALID)
> +					rc = -EBADMSG;
> +				else
> +					op_parsed = true;
> +			} else {
> +				rc = parse_property(t, r);
> +			}
> +		}
> +
> +		if (rc)
> +			goto err;
> +		first_token = false;
> +	}
> +
> +	action = parse_action(t);
> +	if (action == __IPE_ACTION_INVALID) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +	if (is_default_rule) {
> +		if (!list_empty(&r->props)) {
> +			rc = -EBADMSG;
> +		} else if (op == __IPE_OP_INVALID) {
> +			if (p->global_default_action != __IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->global_default_action = action;
> +		} else {
> +			if (p->rules[op].default_action != __IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->rules[op].default_action = action;
> +		}
> +	} else if (op != __IPE_OP_INVALID && action != __IPE_ACTION_INVALID) {
> +		r->op = op;
> +		r->action = action;
> +	} else {
> +		rc = -EBADMSG;
> +	}
> +
> +	if (rc)
> +		goto err;
> +	if (!is_default_rule)
> +		list_add_tail(&r->next, &p->rules[op].rules);
> +	else
> +		free_rule(r);
> +
> +out:
> +	return rc;
> +err:
> +	free_rule(r);
> +	goto out;

In keeping with the rule of not jumping to a label only to
immediately return, and considering that the only place where we jump
to 'out' is in the 'err' code, let's get rid of the 'out' label and
have 'err' "return rc" instead of "goto out".

> +}

--
paul-moore.com
