Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62B1753077
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 06:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbjGNESN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 00:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjGNESN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 00:18:13 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A98C106;
        Thu, 13 Jul 2023 21:18:11 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id CED5321C4671; Thu, 13 Jul 2023 21:18:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CED5321C4671
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689308290;
        bh=1gEl/GRj6c25B7r9dHqS3pawBqKkEdHWIHvR4HQj6sU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oal6HR6h4sgrZUtnk3MlRaBzwN7QdW1Gc4+tOBT7PmbOeNpZCqr3pN14m8kZ8i39X
         ipr2fevWdb2kJ2e48Pqt4ojbmsCIpM0R++7n6rIcCeCsY3Gxkkdj3F/7+JDK2c91eL
         /l+HeHh9TpGqUna+1UTD9QWbL963n6ytqKUYhKxQ=
Date:   Thu, 13 Jul 2023 21:18:10 -0700
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
Subject: Re: [PATCH RFC v10 2/17] ipe: add policy parser
Message-ID: <20230714041810.GA15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-3-git-send-email-wufan@linux.microsoft.com>
 <b2abfd3883dce682ee911413fea2ec66.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2abfd3883dce682ee911413fea2ec66.paul@paul-moore.com>
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

On Sat, Jul 08, 2023 at 12:23:00AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE's interpretation of the what the user trusts is accomplished through
> > its policy. IPE's design is to not provide support for a single trust
> > provider, but to support multiple providers to enable the end-user to
> > choose the best one to seek their needs.
> > 
> > This requires the policy to be rather flexible and modular so that
> > integrity providers, like fs-verity, dm-verity, dm-integrity, or
> > some other system, can plug into the policy with minimal code changes.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/Makefile        |   2 +
> >  security/ipe/policy.c        |  97 +++++++
> >  security/ipe/policy.h        |  83 ++++++
> >  security/ipe/policy_parser.c | 488 +++++++++++++++++++++++++++++++++++
> >  security/ipe/policy_parser.h |  11 +
> >  5 files changed, 681 insertions(+)
> >  create mode 100644 security/ipe/policy.c
> >  create mode 100644 security/ipe/policy.h
> >  create mode 100644 security/ipe/policy_parser.c
> >  create mode 100644 security/ipe/policy_parser.h
> 
> ...
> 
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > new file mode 100644
> > index 000000000000..4069ff075093
> > --- /dev/null
> > +++ b/security/ipe/policy.c
> > @@ -0,0 +1,97 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/verification.h>
> > +
> > +#include "ipe.h"
> > +#include "policy.h"
> > +#include "policy_parser.h"
> > +
> > +/**
> > + * ipe_free_policy - Deallocate a given IPE policy.
> > + * @p: Supplies the policy to free.
> > + *
> > + * Safe to call on IS_ERR/NULL.
> > + */
> > +void ipe_free_policy(struct ipe_policy *p)
> > +{
> > +	if (IS_ERR_OR_NULL(p))
> > +		return;
> > +
> > +	free_parsed_policy(p->parsed);
> > +	if (!p->pkcs7)
> > +		kfree(p->text);
> 
> Since it's safe to kfree(NULL), you could kfree(p->text) without
> having to check if p->pkcs7 was non-NULL, correct?
> 
when p->pkcs7 is not NULL, p->text points to the plain text policy area inside
the data of p->pkcs7, for such cases p->text is not really an allocated memory chunk
so it cannot be passed to kfree.

I might better add a comment here to avoid confusion in the future.

> > +	kfree(p->pkcs7);
> > +	kfree(p);
> > +}
> 
> ...
> 
> > diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> > new file mode 100644
> > index 000000000000..113a037f0d71
> > --- /dev/null
> > +++ b/security/ipe/policy.h
> > @@ -0,0 +1,83 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef _IPE_POLICY_H
> > +#define _IPE_POLICY_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/types.h>
> > +
> > +enum ipe_op_type {
> > +	__IPE_OP_EXEC = 0,
> > +	__IPE_OP_FIRMWARE,
> > +	__IPE_OP_KERNEL_MODULE,
> > +	__IPE_OP_KEXEC_IMAGE,
> > +	__IPE_OP_KEXEC_INITRAMFS,
> > +	__IPE_OP_IMA_POLICY,
> > +	__IPE_OP_IMA_X509,
> > +	__IPE_OP_MAX
> > +};
> 
> Thanks for capitalizing the enums, that helps make IPE consistent with
> the majority of the kernel.  However, when I talked about using
> underscores for "__IPE_OP_MAX", I was talking about *only*
> "__IPE_OP_MAX" to help indicate it is a sentinel value and not an enum
> value that would normally be used by itself.
> 
> Here is what I was intending:
> 
> enum ipe_op_type {
>   IPE_OP_EXEC = 0,
>   IPE_OP_FIRMWARE,
>   ...
>   IPE_OP_IMA_X509,
>   __IPE_OP_MAX
> };
> 
> > +#define __IPE_OP_INVALID __IPE_OP_MAX
> 
> Similarly, I would remove the underscores from "__IPE_OP_INVALID":
> 
> #define IPE_OP_INVALID __IPE_OP_MAX
> 
> Both of these comments would apply to the other IPE enums as well.
> 
Sorry for the mistake, I will update them.

> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > new file mode 100644
> > index 000000000000..27e5767480b0
> > --- /dev/null
> > +++ b/security/ipe/policy_parser.c
> > @@ -0,0 +1,488 @@
> 
> ...
> 
> > +/**
> > + * parse_header - Parse policy header information.
> > + * @line: Supplies header line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Standard errno
> > + */
> > +static int parse_header(char *line, struct ipe_parsed_policy *p)
> > +{
> > +	int rc = 0;
> > +	char *t, *ver = NULL;
> > +	substring_t args[MAX_OPT_ARGS];
> > +	size_t idx = 0;
> > +
> > +	while ((t = strsep(&line, " \t")) != NULL) {
> 
> It might be nice to define a macro to help reinforce that " \t" are
> the IPE policy delimiters, how about IPE_POLICY_DELIM?
> 
> #define IPE_POLICY_DELIM " \t"
> 
Sure, this is better, I will take this idea.

> > +		int token;
> > +
> > +		if (*t == '\0')
> > +			continue;
> 
> Why would you want to continue if you run into a NUL byte?  You would
> only run into a NUL byte if the line was trimmed due to comments or
> whitespace, correct?  If that is the case, wouldn't you want to
> break out of this loop when hitting a NUL byte?
> 
This happens when two spaces are passed, for example "DEFAULT<space><space>action=DENY"
has two spaces inside, the strsep will create a NUL string when it sees the first space,
so for such cases I think we should just skip to the next token.

> > +		if (idx >= __IPE_HEADER_MAX) {
> > +			rc = -EBADMSG;
> > +			goto err;
> > +		}
> > +
> > +		token = match_token(t, header_tokens, args);
> > +		if (token != idx) {
> > +			rc = -EBADMSG;
> > +			goto err;
> > +		}
> > +
> > +		switch (token) {
> > +		case __IPE_HEADER_POLICY_NAME:
> > +			p->name = match_strdup(&args[0]);
> > +			if (!p->name)
> > +				rc = -ENOMEM;
> > +			break;
> > +		case __IPE_HEADER_POLICY_VERSION:
> > +			ver = match_strdup(&args[0]);
> > +			if (!ver) {
> > +				rc = -ENOMEM;
> > +				break;
> > +			}
> > +			rc = parse_version(ver, p);
> > +			break;
> > +		default:
> > +			rc = -EBADMSG;
> > +		}
> > +		if (rc)
> > +			goto err;
> > +		++idx;
> > +	}
> > +
> > +	if (idx != __IPE_HEADER_MAX) {
> > +		rc = -EBADMSG;
> > +		goto err;
> > +	}
> > +
> > +out:
> > +	kfree(ver);
> > +	return rc;
> > +err:
> > +	kfree(p->name);
> > +	p->name = NULL;
> > +	goto out;
> 
> Do we need to worry about ipe_parsed_policy::name here?  If we are
> returning an error the caller will call free_parsed_policy() for us,
> right?  This would allow us to get rid of the 'err' jump label and
> simply use 'out' for both success and failure.
> 
Yes this is not necessary, I will remove this part.

> > +}
> 
> ...
> 
> > +/**
> > + * parse_rule - parse a policy rule line.
> > + * @line: Supplies rule line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * !IS_ERR	- OK
> > + * * -ENOMEM	- Out of memory
> > + * * -EBADMSG	- Policy syntax error
> > + */
> > +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> > +{
> > +	int rc = 0;
> > +	bool first_token = true, is_default_rule = false;
> > +	bool op_parsed = false;
> > +	enum ipe_op_type op = __IPE_OP_INVALID;
> > +	enum ipe_action_type action = __IPE_ACTION_INVALID;
> > +	struct ipe_rule *r = NULL;
> > +	char *t;
> > +
> > +	r = kzalloc(sizeof(*r), GFP_KERNEL);
> > +	if (!r)
> > +		return -ENOMEM;
> > +
> > +	INIT_LIST_HEAD(&r->next);
> > +	INIT_LIST_HEAD(&r->props);
> > +
> > +	while (t = strsep(&line, " \t"), line) {
> 
> See my previous comment about IPE_POLICY_DELIM.
> 
> > +		if (*t == '\0')
> > +			continue;
> 
> I still wonder why continuing here is the desired behavior, can you
> help me understand?
This one is the same to the parse header function, when two consecutive
delimitators is passed to strsep it will generate a '\0'.

> 
> > +		if (first_token && token_default(t)) {
> > +			is_default_rule = true;
> > +		} else {
> > +			if (!op_parsed) {
> > +				op = parse_operation(t);
> > +				if (op == __IPE_OP_INVALID)
> > +					rc = -EBADMSG;
> > +				else
> > +					op_parsed = true;
> > +			} else {
> > +				rc = parse_property(t, r);
> > +			}
> > +		}
> > +
> > +		if (rc)
> > +			goto err;
> > +		first_token = false;
> > +	}
> > +
> > +	action = parse_action(t);
> > +	if (action == __IPE_ACTION_INVALID) {
> > +		rc = -EBADMSG;
> > +		goto err;
> > +	}
> > +
> > +	if (is_default_rule) {
> > +		if (!list_empty(&r->props)) {
> > +			rc = -EBADMSG;
> > +		} else if (op == __IPE_OP_INVALID) {
> > +			if (p->global_default_action != __IPE_ACTION_INVALID)
> > +				rc = -EBADMSG;
> > +			else
> > +				p->global_default_action = action;
> > +		} else {
> > +			if (p->rules[op].default_action != __IPE_ACTION_INVALID)
> > +				rc = -EBADMSG;
> > +			else
> > +				p->rules[op].default_action = action;
> > +		}
> > +	} else if (op != __IPE_OP_INVALID && action != __IPE_ACTION_INVALID) {
> > +		r->op = op;
> > +		r->action = action;
> > +	} else {
> > +		rc = -EBADMSG;
> > +	}
> > +
> > +	if (rc)
> > +		goto err;
> > +	if (!is_default_rule)
> > +		list_add_tail(&r->next, &p->rules[op].rules);
> > +	else
> > +		free_rule(r);
> > +
> > +out:
> > +	return rc;
> > +err:
> > +	free_rule(r);
> > +	goto out;
> 
> In keeping with the rule of not jumping to a label only to
> immediately return, and considering that the only place where we jump
> to 'out' is in the 'err' code, let's get rid of the 'out' label and
> have 'err' "return rc" instead of "goto out".
> 
Sure I can change this part, yeah I agree this looks weird. 

-Fan
> > +}
> 
> --
> paul-moore.com
