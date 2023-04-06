Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A206DA219
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Apr 2023 22:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbjDFUBA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 6 Apr 2023 16:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjDFUA7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 6 Apr 2023 16:00:59 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5005C8A51;
        Thu,  6 Apr 2023 13:00:56 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id C625F210DF1A; Thu,  6 Apr 2023 13:00:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C625F210DF1A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1680811255;
        bh=kIhIeFG4MaGGqkVyCC+t2Fm8LD7aGeQ+QkpzOWB5vQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bFhAzdjz9LPROY9fHt3hBL7035bbtSLBOnE8AEMPMngm4YGTjejjTl2xvFncwogEn
         7IvCp6BiCyl8qRlfnkUbpxzi0vTcydGsLsp1o5gNWHex4dsyUP6SY6g0N+xDHhKXxi
         626bVNd2nWicKKYq7sPqdPVybHC+axOGKMUTeSpw=
Date:   Thu, 6 Apr 2023 13:00:55 -0700
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
Subject: Re: [RFC PATCH v9 02/16] ipe: add policy parser
Message-ID: <20230406200055.GB19196@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
 <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
 <CAHC9VhRguGeb8=oNVFebshL_2LLZ4hf0qO97YBVm8OObLsLNTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRguGeb8=oNVFebshL_2LLZ4hf0qO97YBVm8OObLsLNTw@mail.gmail.com>
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

On Thu, Mar 02, 2023 at 02:02:32PM -0500, Paul Moore wrote:
> On Mon, Jan 30, 2023 at 5:58???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> >
> > From: Deven Bowers <deven.desai@linux.microsoft.com>
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
> 
> ...
> 
> > ---
> >  security/ipe/Makefile        |   2 +
> >  security/ipe/policy.c        |  99 +++++++
> >  security/ipe/policy.h        |  77 ++++++
> >  security/ipe/policy_parser.c | 515 +++++++++++++++++++++++++++++++++++
> >  security/ipe/policy_parser.h |  11 +
> >  5 files changed, 704 insertions(+)
> >  create mode 100644 security/ipe/policy.c
> >  create mode 100644 security/ipe/policy.h
> >  create mode 100644 security/ipe/policy_parser.c
> >  create mode 100644 security/ipe/policy_parser.h
> >
> > diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> > index 571648579991..16bbe80991f1 100644
> > --- a/security/ipe/Makefile
> > +++ b/security/ipe/Makefile
> > @@ -8,3 +8,5 @@
> >  obj-$(CONFIG_SECURITY_IPE) += \
> >         hooks.o \
> >         ipe.o \
> > +       policy.o \
> > +       policy_parser.o \
> > diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> > new file mode 100644
> > index 000000000000..e446f4b84152
> > --- /dev/null
> > +++ b/security/ipe/policy.c
> > @@ -0,0 +1,99 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "ipe.h"
> > +#include "policy.h"
> > +#include "policy_parser.h"
> > +#include "digest.h"
> > +
> > +#include <linux/verification.h>
> 
> Generally speaking the system/kernel-wide header files, e.g. headers
> using '<...>', tend to come before the local header files, e.g.
> headers using '"..."'.  I wouldn't consider this a hard rule, but
> unless you have a reason to put the local header files first I would
> stick with convention here.
> 

I agree we didn't follow the correct common pattern here, I will update
all header lines in the next version.

> > +/**
> > + * ipe_free_policy - Deallocate a given IPE policy.
> > + * @p: Supplies the policy to free.
> > + *
> > + * Safe to call on IS_ERR/NULL.
> > + */
> > +void ipe_free_policy(struct ipe_policy *p)
> > +{
> > +       if (IS_ERR_OR_NULL(p))
> > +               return;
> > +
> > +       free_parsed_policy(p->parsed);
> > +       if (!p->pkcs7)
> > +               kfree(p->text);
> > +       kfree(p->pkcs7);
> > +       kfree(p);
> > +}
> > +
> > +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> > +                         size_t asn1hdrlen)
> > +{
> > +       struct ipe_policy *p = ctx;
> > +
> > +       p->text = (const char *)data;
> > +       p->textlen = len;
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * ipe_new_policy - Allocate and parse an ipe_policy structure.
> > + *
> > + * @text: Supplies a pointer to the plain-text policy to parse.
> > + * @textlen: Supplies the length of @text.
> > + * @pkcs7: Supplies a pointer to a pkcs7-signed IPE policy.
> > + * @pkcs7len: Supplies the length of @pkcs7.
> > + *
> > + * @text/@textlen Should be NULL/0 if @pkcs7/@pkcs7len is set.
> > + *
> > + * The result will still need to be associated with a context via
> > + * ipe_add_policy.
> > + *
> > + * Return:
> > + * * !IS_ERR   - Success
> > + * * -EBADMSG  - Policy is invalid
> > + * * -ENOMEM   - Out of memory
> > + */
> > +struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> > +                                 const char *pkcs7, size_t pkcs7len)
> > +{
> > +       int rc = 0;
> > +       struct ipe_policy *new = NULL;
> > +
> > +       new = kzalloc(sizeof(*new), GFP_KERNEL);
> > +       if (!new)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       if (!text) {
> > +               new->pkcs7len = pkcs7len;
> > +               new->pkcs7 = kmemdup(pkcs7, pkcs7len, GFP_KERNEL);
> > +               if (!new->pkcs7) {
> > +                       rc = -ENOMEM;
> > +                       goto err;
> 
> As Roberto already pointed out, and you acknowledged, this leaks @new.
> However, as a FYI for future work, if you have a label with only one
> return instruction after the jump, e.g. the 'err' label here, you
> should replace the 'goto' with the single return instruction.  Jumping
> just to immediately return is a bit silly, but if you also need to
> cleanup, e.g. free some memory, that's okay to use the goto/jump.
> 
> > +               }
> > +
> > +               rc = verify_pkcs7_signature(NULL, 0, new->pkcs7, pkcs7len, NULL,
> > +                                           VERIFYING_UNSPECIFIED_SIGNATURE,
> > +                                           set_pkcs7_data, new);
> > +               if (rc)
> > +                       goto err;
> > +       } else {
> > +               new->textlen = textlen;
> > +               new->text = kstrdup(text, GFP_KERNEL);
> > +               if (!new->text) {
> > +                       rc = -ENOMEM;
> > +                       goto err;
> > +               }
> > +       }
> > +
> > +       rc = parse_policy(new);
> > +       if (rc)
> > +               goto err;
> > +
> > +       return new;
> > +err:
> > +       return ERR_PTR(rc);
> > +}
> 
> ...
> 
> > diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> > new file mode 100644
> > index 000000000000..6af2d9a811ec
> > --- /dev/null
> > +++ b/security/ipe/policy.h
> > @@ -0,0 +1,77 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef IPE_POLICY_H
> > +#define IPE_POLICY_H
> > +
> > +#include <linux/list.h>
> > +#include <linux/types.h>
> > +
> > +enum ipe_op_type {
> > +       ipe_op_exec = 0,
> > +       ipe_op_firmware,
> > +       ipe_op_kernel_module,
> > +       ipe_op_kexec_image,
> > +       ipe_op_kexec_initramfs,
> > +       ipe_op_ima_policy,
> > +       ipe_op_ima_x509,
> > +       ipe_op_max
> > +};
> 
> I'm used to seeing enum values defined in ALL_CAPS to help visually
> distinguish them from variables and other assorted symbols, for
> example:
> 
>   enum ipe_op_type {
>     IPE_OP_EXEC = 0,
>     ...
>     IPE_OP_MAX,
>   };
> 
> You might also want to consider prefixing IPE_OP_MAX with a couple
> underscores, e.g. __IPE_OP_MAX, to help distinguish it as a sentinel
> value and provide some protection in case you think you might ever
> want an op named "max".  However, this really is a judgement call that
> is up to you.
> 
> (Similar comments apply to the other IPE enums)
> 

Yes this looks much better, I will also update all enums. Thanks for the advice.

> > +enum ipe_action_type {
> > +       ipe_action_allow = 0,
> > +       ipe_action_deny,
> > +       ipe_action_max
> > +};
> > +
> > +enum ipe_prop_type {
> > +       ipe_prop_max
> > +};
> > +
> > +struct ipe_prop {
> > +       struct list_head next;
> > +       enum ipe_prop_type type;
> > +       void *value;
> > +};
> > +
> > +struct ipe_rule {
> > +       enum ipe_op_type op;
> > +       enum ipe_action_type action;
> > +       struct list_head props;
> > +       struct list_head next;
> > +};
> > +
> > +struct ipe_op_table {
> > +       struct list_head rules;
> > +       enum ipe_action_type default_action;
> > +};
> > +
> > +struct ipe_parsed_policy {
> > +       const char *name;
> > +       struct {
> > +               u16 major;
> > +               u16 minor;
> > +               u16 rev;
> > +       } version;
> > +
> > +       enum ipe_action_type global_default_action;
> > +
> > +       struct ipe_op_table rules[ipe_op_max];
> > +};
> > +
> > +struct ipe_policy {
> > +       const char     *pkcs7;
> > +       size_t          pkcs7len;
> > +
> > +       const char     *text;
> > +       size_t          textlen;
> > +
> > +       struct ipe_parsed_policy *parsed;
> > +};
> 
> None of the other structs in this header file have horizontally
> aligned variable names, you should pick one style and stick with it
> ... and that style should be the un-aligned style, e.g. what was used
> in 'struct ipe_rule'
> 

Thanks for pointing that out, will also update this part.

> > +struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> > +                                 const char *pkcs7, size_t pkcs7len);
> > +void ipe_free_policy(struct ipe_policy *pol);
> > +
> > +#endif /* IPE_POLICY_H */
> > diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> > new file mode 100644
> > index 000000000000..c7ba0e865366
> > --- /dev/null
> > +++ b/security/ipe/policy_parser.c
> > @@ -0,0 +1,515 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include "policy.h"
> > +#include "policy_parser.h"
> > +#include "digest.h"
> > +
> > +#include <linux/parser.h>
> > +
> > +#define START_COMMENT  '#'
> > +
> > +/**
> > + * new_parsed_policy - Allocate and initialize a parsed policy.
> > + *
> > + * Return:
> > + * * !IS_ERR   - OK
> > + * * -ENOMEM   - Out of memory
> > + */
> > +static struct ipe_parsed_policy *new_parsed_policy(void)
> > +{
> > +       size_t i = 0;
> > +       struct ipe_parsed_policy *p = NULL;
> > +       struct ipe_op_table *t = NULL;
> > +
> > +       p = kzalloc(sizeof(*p), GFP_KERNEL);
> > +       if (!p)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       p->global_default_action = ipe_action_max;
> 
> I'm assuming you're using the "ipe_action_max" as an intentional bogus
> placeholder value here, yes?  If that is the case, have you considered
> creating an "invalid" enum with an explicit zero value to save you
> this additional assignment (you are already using kzalloc())?  For
> example:
> 
>   enum ipe_op_type {
>     IPE_OP_INVALID = 0,
>     IPE_OP_EXEC,
>     ...
>     IPE_OP_MAX,
>   };
> 
>   enum ipe_action_type {
>     IPE_ACTION_INVALID = 0,
>     IPE_ACTION_ALLOW,
>     ...
>     IPE_ACTION_MAX,
>   };
> 

Yes, IPE_ACTION_MAX is kind of the INVALID value we are using here.

But I think we might be adding unnecessary complexity by using the
IPE_OP_INVLIAD enum here. Currently, we are using IPE_OP_MAX to
represent the number of operations we have, and we have allocated
an IPE_OP_MAX-sized array to store linked lists that link all rules
for each operation. If we were to add IPE_OP_INVLIAD to the enum
definition, then IPE_OP_MAX-1 would become the number of operations,
and we would need to change the index used to access the linked list
array. For example, to get the linked-list head of rules for the
EXEC operation, we would have to use index IPE_OP_EXEC-1. Is this
acceptable?


> > +       for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
> > +               t = &p->rules[i];
> > +
> > +               t->default_action = ipe_action_max;
> > +               INIT_LIST_HEAD(&t->rules);
> > +       }
> > +
> > +       return p;
> > +}
> > +
> > +/**
> > + * remove_comment - Truncate all chars following START_COMMENT in a string.
> > + *
> > + * @line: Supplies a poilcy line string for preprocessing.
> 
> "policy" :)
> 
> I'm definitely guilty of adding a lot of silly spelling errors to
> codebases over the years, so no worries here, but in case you haven't
> seen the codespell tool already, it might be something worth taking a
> look at sometime.
> 
> * https://github.com/codespell-project/codespell
> 

Thanks for the suggestion. I have found several other typos by using this.

> > + */
> > +static void remove_comment(char *line)
> > +{
> > +       size_t i, len = 0;
> > +
> > +       len = strlen(line);
> > +       for (i = 0; i < len && line[i] != START_COMMENT; ++i)
> > +               ;
> 
> The kernel has a strchr() implementation which could simplify this,
> and possibly speed things up if there is an arch specific optimized
> implementation.
> 

Yep this one is better, will switch to use it.

> > +       line[i] = '\0';
> > +}
> > +
> > +/**
> > + * remove_trailing_spaces - Truncate all trailing spaces in a string.
> > + *
> > + * @line: Supplies a poilcy line string for preprocessing.
> > + */
> > +static void remove_trailing_spaces(char *line)
> > +{
> > +       size_t i, len = 0;
> > +
> > +       len = strlen(line);
> > +       for (i = len; i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
> > +               ;
> 
> You can probably drop the @len variable and just assign 'i =
> strlen(line)' in the for-loop initializer.
> 

Yep, len is redundant here, will remove it.

> > +       line[i] = '\0';
> > +}
> > +
> > +/**
> > + * parse_version - Parse policy version.
> > + * @ver: Supplies a version string to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * 0 - OK
> > + * * !0        - Standard errno
> > + */
> > +static int parse_version(char *ver, struct ipe_parsed_policy *p)
> > +{
> > +       int rc = 0;
> > +       size_t sep_count = 0;
> > +       char *token;
> > +       u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
> > +
> > +       while ((token = strsep(&ver, ".")) != NULL) {
> > +               /* prevent overflow */
> > +               if (sep_count >= ARRAY_SIZE(cv)) {
> > +                       rc = -EBADMSG;
> > +                       goto err;
> 
> Remember what I said above about not needing a 'goto' here? ;)
> 

Yes just return is enough, will update it.

> > +               }
> > +
> > +               rc = kstrtou16(token, 10, cv[sep_count]);
> > +               if (rc)
> > +                       goto err;
> > +
> > +               ++sep_count;
> > +       }
> > +
> > +       /* prevent underflow */
> > +       if (sep_count != ARRAY_SIZE(cv))
> > +               rc = -EBADMSG;
> > +
> > +err:
> > +       return rc;
> > +}
> > +
> > +enum header_opt {
> > +       ipe_header_policy_name = 0,
> > +       ipe_header_policy_version,
> > +       ipe_header_max
> > +};
> > +
> > +static const match_table_t header_tokens = {
> > +       {ipe_header_policy_name,        "policy_name=%s"},
> > +       {ipe_header_policy_version,     "policy_version=%s"},
> > +       {ipe_header_max,                NULL}
> > +};
> > +
> > +/**
> > + * parse_header - Parse policy header information.
> > + * @line: Supplies header line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * 0 - OK
> > + * * !0        - Standard errno
> > + */
> > +static int parse_header(char *line, struct ipe_parsed_policy *p)
> > +{
> > +       int rc = 0;
> > +       char *t, *ver = NULL;
> > +       substring_t args[MAX_OPT_ARGS];
> > +       size_t idx = 0;
> > +
> > +       while ((t = strsep(&line, " \t")) != NULL) {
> > +               int token;
> > +
> > +               if (*t == '\0')
> > +                       continue;
> > +               if (idx >= ipe_header_max) {
> > +                       rc = -EBADMSG;
> > +                       goto err;
> > +               }
> > +
> > +               token = match_token(t, header_tokens, args);
> > +               if (token != idx) {
> > +                       rc = -EBADMSG;
> > +                       goto err;
> > +               }
> > +
> > +               switch (token) {
> > +               case ipe_header_policy_name:
> > +                       p->name = match_strdup(&args[0]);
> > +                       if (!p->name)
> > +                               rc = -ENOMEM;
> > +                       break;
> > +               case ipe_header_policy_version:
> > +                       ver = match_strdup(&args[0]);
> > +                       if (!ver) {
> > +                               rc = -ENOMEM;
> > +                               break;
> > +                       }
> > +                       rc = parse_version(ver, p);
> > +                       break;
> > +               default:
> > +                       rc = -EBADMSG;
> > +               }
> > +               if (rc)
> > +                       goto err;
> > +               ++idx;
> > +       }
> > +
> > +       if (idx != ipe_header_max) {
> > +               rc = -EBADMSG;
> > +               goto err;
> > +       }
> > +       goto out;
> 
> Generally the normal, non-error case is structured so that the
> function can continue to fall through to the correct code without
> needed a 'goto'.  I would suggest moving the 'err' label/code *after*
> the 'out' label/code so the normal case can just fall through without
> the goto; you will have to add a 'goto out' at the end of 'err', but
> that's the error case so we aren't going to worry too much about that.
> 
> Put another (shorter) way, structure your code to optimize for the
> common, non-error case.
> 
> Needless to say, this applies to other functions in this patch(set).
> 

Thanks for pointing that out, I will update all the cases like this one.

> > +err:
> > +       kfree(p->name);
> > +       p->name = NULL;
> > +out:
> > +       kfree(ver);
> > +       return rc;
> > +}
> > +
> > +/**
> > + * is_default - Determine if the given token is "DEFAULT".
> > + * @token: Supplies the token string to be compared.
> > + *
> > + * Return:
> > + * * 0 - The token is not "DEFAULT"
> > + * * !0        - The token is "DEFAULT"
> > + */
> > +static bool is_default(char *token)
> > +{
> > +       return !strcmp(token, "DEFAULT");
> > +}
> 
> Let's be honest, "is_default()" isn't a great name, and it's a pretty
> trivial function too; I'm wondering if hiding the simple strcmp()
> behind an oddly named function is really all that helpful.  I'm okay
> if you want to keep the function, but can we name it something else?
> Maybe "token_default(...)" or something similar?
> 

I agree, I will take the name token_default.

> > +/**
> > + * free_rule - Free the supplied ipe_rule struct.
> > + * @r: Supplies the ipe_rule struct to be freed.
> > + */
> 
> It might be worth mentioning that @r should be removed from any lists,
> e.g. list_empty() is true.
> 
> > +static void free_rule(struct ipe_rule *r)
> > +{
> > +       struct ipe_prop *p, *t;
> > +
> > +       if (IS_ERR_OR_NULL(r))
> > +               return;
> > +
> > +       list_for_each_entry_safe(p, t, &r->props, next) {
> > +               kfree(p);
> > +       }
> 
> That's interesting, I'm used to seeing a 'list_del()' call (or
> similar) before the list entry is freed.  Although looking at
> list_for_each_entry_safe() I guess it is safe with the current
> implementation ... did you see this pattern elsewhere in the kernel?
> If so, where?
> 
> Unless this is performance critical (I don't think it is?), it might
> be safer to do an explicit `list_del()` before free'ing the entries
> ... unless this is now a common pattern in the kernel and I just
> missed the memo.
> 

I have double checked other use cases and found we were indeed wrong
here, I will add list_del calls in the next version.

> > +       kfree(r);
> > +}
> > +
> > +static const match_table_t operation_tokens = {
> > +       {ipe_op_exec,                   "op=EXECUTE"},
> > +       {ipe_op_firmware,               "op=FIRMWARE"},
> > +       {ipe_op_kernel_module,          "op=KMODULE"},
> > +       {ipe_op_kexec_image,            "op=KEXEC_IMAGE"},
> > +       {ipe_op_kexec_initramfs,        "op=KEXEC_INITRAMFS"},
> > +       {ipe_op_ima_policy,             "op=IMA_POLICY"},
> > +       {ipe_op_ima_x509,               "op=IMA_X509_CERT"},
> > +       {ipe_op_max,                    NULL}
> > +};
> > +
> > +/**
> > + * parse_operation - Parse the opeartion type given a token string.
> > + * @t: Supplies the token string to be parsed.
> > + *
> > + * Return: The parsed opeartion type.
> > + */
> > +static enum ipe_op_type parse_operation(char *t)
> > +{
> > +       substring_t args[MAX_OPT_ARGS];
> > +
> > +       return match_token(t, operation_tokens, args);
> > +}
> > +
> > +static const match_table_t action_tokens = {
> > +       {ipe_action_allow,      "action=ALLOW"},
> > +       {ipe_action_deny,       "action=DENY"},
> > +       {ipe_action_max,        NULL}
> > +};
> > +
> > +/**
> > + * parse_action - Parse the action type given a token string.
> > + * @t: Supplies the token string to be parsed.
> > + *
> > + * Return: The parsed action type.
> > + */
> > +static enum ipe_action_type parse_action(char *t)
> > +{
> > +       substring_t args[MAX_OPT_ARGS];
> > +
> > +       return match_token(t, action_tokens, args);
> > +}
> > +
> > +static const match_table_t property_tokens = {
> > +       {ipe_prop_max,                                  NULL}
> > +};
> > +
> > +/**
> > + * parse_property - Parse the property type given a token string.
> > + * @t: Supplies the token string to be parsed.
> > + * @r: Supplies the ipe_rule the parsed property will be associated with.
> > + *
> > + * Return:
> > + * * !IS_ERR   - OK
> > + * * -ENOMEM   - Out of memory
> > + * * -EBADMSG  - The supplied token cannot be parsed
> > + */
> > +int parse_property(char *t, struct ipe_rule *r)
> > +{
> > +       substring_t args[MAX_OPT_ARGS];
> > +       struct ipe_prop *p = NULL;
> > +       int rc = 0;
> > +       int token;
> > +       char *dup = NULL;
> > +
> > +       p = kzalloc(sizeof(*p), GFP_KERNEL);
> > +       if (!p) {
> > +               rc = -ENOMEM;
> > +               goto err;
> > +       }
> > +
> > +       token = match_token(t, property_tokens, args);
> > +
> > +       switch (token) {
> > +       case ipe_prop_max:
> > +       default:
> > +               rc = -EBADMSG;
> > +               break;
> > +       }
> > +       list_add_tail(&p->next, &r->props);
> > +
> > +err:
> > +       kfree(dup);
> > +       return rc;
> > +}
> 
> There is a lot of stuff in 'parse_property()' that doesn't make sense
> at this point in the patchset, including lots of unused variables.
> Considering that no valid properties are defined yet, why not just
> make this function return -EBADMSG in this patch?  You can always
> populate it later when it becomes useful.
> 
> int parse_property(...)
> {
>   return -EBADMSG;
> }
> 

Sure, I can restructure the patch to add them in the later patches.

> > +/**
> > + * parse_rule - parse a policy rule line.
> > + * @line: Supplies rule line to be parsed.
> > + * @p: Supplies the partial parsed policy.
> > + *
> > + * Return:
> > + * * !IS_ERR   - OK
> > + * * -ENOMEM   - Out of memory
> > + * * -EBADMSG  - Policy syntax error
> > + */
> > +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> > +{
> > +       int rc = 0;
> > +       bool first_token = true, is_default_rule = false;
> > +       bool op_parsed = false;
> > +       enum ipe_op_type op = ipe_op_max;
> > +       enum ipe_action_type action = ipe_action_max;
> > +       struct ipe_rule *r = NULL;
> > +       char *t;
> > +
> > +       r = kzalloc(sizeof(*r), GFP_KERNEL);
> > +       if (!r) {
> > +               rc = -ENOMEM;
> > +               goto err;
> > +       }
> > +
> > +       INIT_LIST_HEAD(&r->next);
> > +       INIT_LIST_HEAD(&r->props);
> > +
> > +       while (t = strsep(&line, " \t"), line) {
> > +               if (*t == '\0')
> > +                       continue;
> > +               if (first_token && is_default(t)) {
> > +                       is_default_rule = true;
> > +               } else {
> > +                       if (!op_parsed) {
> > +                               op = parse_operation(t);
> > +                               if (op == ipe_op_max)
> > +                                       rc = -EBADMSG;
> > +                               else
> > +                                       op_parsed = true;
> > +                       } else {
> > +                               rc = parse_property(t, r);
> > +                       }
> > +               }
> > +
> > +               if (rc)
> > +                       goto err;
> > +               first_token = false;
> > +       }
> > +
> > +       action = parse_action(t);
> > +       if (action == ipe_action_max) {
> > +               rc = -EBADMSG;
> > +               goto err;
> > +       }
> > +
> > +       if (is_default_rule) {
> > +               if (op == ipe_op_max) {
> > +                       if (p->global_default_action != ipe_action_max)
> > +                               rc = -EBADMSG;
> > +                       else
> > +                               p->global_default_action = action;
> > +               } else {
> > +                       if (p->rules[op].default_action != ipe_action_max)
> > +                               rc = -EBADMSG;
> > +                       else
> > +                               p->rules[op].default_action = action;
> > +               }
> > +               free_rule(r);
> > +       } else if (op != ipe_op_max && action != ipe_action_max) {
> > +               r->op = op;
> > +               r->action = action;
> > +               list_add_tail(&r->next, &p->rules[op].rules);
> 
> There is no way @rc could be non-zero here, right?  If there is some
> chance of it being non-zero we could have a problem with the @rc check
> below jumping us to the 'err' label and free'ing a rule that has been
> added to the list.
> 
> It might be better to move the list addition after the last error check.
> 

Yes, rc cannot be non-zero here because all the rc assignments will just
go to the 'err' label. But I also agree that moving the list addition after
the last error check can avoid potential bugs in the future. I will update this part.

> > +       } else {
> > +               rc = -EBADMSG;
> > +       }
> > +
> > +       if (rc)
> > +               goto err;
> > +
> > +       goto out;
> > +
> > +err:
> > +       free_rule(r);
> > +out:
> > +       return rc;
> > +}
> > +
> > +/**
> > + * free_parsed_policy - free a parsed policy structure.
> > + * @p: Supplies the parsed policy.
> > + */
> > +void free_parsed_policy(struct ipe_parsed_policy *p)
> > +{
> > +       size_t i = 0;
> > +       struct ipe_rule *pp, *t;
> > +
> > +       if (IS_ERR_OR_NULL(p))
> > +               return;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
> > +               list_for_each_entry_safe(pp, t, &p->rules[i].rules, next)
> > +                       free_rule(pp);
> > +
> > +       kfree(p);
> > +}
> > +
> > +/**
> > + * validate_policy - validate a parsed policy.
> > + * @p: Supplies the fully parsed policy.
> > + *
> > + * Given a policy structure that was just parsed, validate that all
> > + * necessary fields are present, initialized correctly, and all lines
> > + * parsed are have been consumed.
> > + *
> > + * A parsed policy can be an invalid state for use (a default was
> > + * undefined, a header was undefined) by just parsing the policy.
> > + *
> > + * Return:
> > + * * 0         - OK
> > + * * -EBADMSG  - Policy is invalid
> > + */
> > +static int validate_policy(const struct ipe_parsed_policy *p)
> > +{
> > +       int i = 0;
> > +
> > +       if (p->global_default_action != ipe_action_max)
> > +               return 0;
> > +
> > +       for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
> > +               if (p->rules[i].default_action == ipe_action_max)
> > +                       return -EBADMSG;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +/**
> > + * parse_policy - Given a string, parse the string into an IPE policy.
> > + * @p: partially filled ipe_policy structure to populate with the result.
> > + *     it must have text and textlen set.
> > + *
> > + * Return:
> > + * * 0         - OK
> > + * * -EBADMSG  - Policy is invalid
> > + * * -ENOMEM   - Out of Memory
> > + */
> > +int parse_policy(struct ipe_policy *p)
> > +{
> > +       int rc = 0;
> > +       size_t len;
> > +       char *policy = NULL, *dup = NULL;
> > +       char *line = NULL;
> > +       bool header_parsed = false;
> > +       struct ipe_parsed_policy *pp = NULL;
> > +
> > +       if (!p->textlen)
> > +               return -EBADMSG;
> > +
> > +       policy = kmemdup_nul(p->text, p->textlen, GFP_KERNEL);
> > +       if (!policy)
> > +               return -ENOMEM;
> > +       dup = policy;
> > +
> > +       pp = new_parsed_policy();
> > +       if (IS_ERR(pp)) {
> > +               rc = PTR_ERR(pp);
> > +               goto out;
> > +       }
> > +
> > +       while ((line = strsep(&policy, "\n\r")) != NULL) {
> > +               remove_comment(line);
> > +               remove_trailing_spaces(line);
> 
> I think it might be very easy for 'remove_trailing_spaces()' to return
> the length of the string as it already knows where the string ends;
> perhaps the function could return the string length and we could get
> rid of the 'strlen()' call below?
> 

Yes that's very easy, I will add a return value to remove_trailing_spaces().

> > +               len = strlen(line);
> > +               if (!len)
> > +                       continue;
> > +
> > +               if (!header_parsed) {
> > +                       rc = parse_header(line, pp);
> > +                       if (rc)
> > +                               goto err;
> > +                       header_parsed = true;
> > +                       continue;
> 
> Instead of the 'continue' above, why not just put the 'parse_rule()'
> call into the 'else' block of this if-then-else?
> 

I agree that's a better structure, I will switch to use 'else'.

-Fan

> > +               }
> > +
> > +               rc = parse_rule(line, pp);
> > +               if (rc)
> > +                       goto err;
> > +       }
> > +
> > +       if (!header_parsed || validate_policy(pp)) {
> > +               rc = -EBADMSG;
> > +               goto err;
> > +       }
> > +
> > +       p->parsed = pp;
> > +
> > +       goto out;
> > +err:
> > +       free_parsed_policy(pp);
> > +out:
> > +       kfree(dup);
> > +
> > +       return rc;
> > +}
> > diff --git a/security/ipe/policy_parser.h b/security/ipe/policy_parser.h
> > new file mode 100644
> > index 000000000000..699ca58a5a32
> > --- /dev/null
> > +++ b/security/ipe/policy_parser.h
> > @@ -0,0 +1,11 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +#ifndef IPE_POLICY_PARSER_H
> > +#define IPE_POLICY_PARSER_H
> > +
> > +int parse_policy(struct ipe_policy *p);
> > +void free_parsed_policy(struct ipe_parsed_policy *p);
> > +
> > +#endif /* IPE_POLICY_PARSER */
> > --
> > 2.39.0
> 
> --
> paul-moore.com
