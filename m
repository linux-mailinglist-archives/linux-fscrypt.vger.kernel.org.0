Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046FF6A88DD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCBTCx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCBTCv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:02:51 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CF15329D
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:02:44 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id u20so81268pfm.7
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677783764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eNgkNkO7kUzRzMyg6Huq3bqtBmJhOsXt5NyJWkplV0=;
        b=IRkcm4bF5M7GmgsGyPytmQAZNfZw/tFWZ9EyQ6ddQeFvOYW3TkR5wbW8OSzjBWxJFL
         lhPtOOG/I3+5etwsvaiSAmZ6PpwMk1MEBeCaDifbVqRNd3DK4XO2DsVE7F5Ca6r1Tf+s
         5voFyhaqDsVU8CYJw1Udhg2W8tHArgyt5rKcsEULy+tHL5hhWLp3kKaKMHRSR+PB5Ghg
         yrShemyN3edbmyiHWYe9MPGD8V0oHTYqeyErshGguAn2n9tpyqy4CxOqnQLrAFU0iLzi
         GyWyjKOi+QivXtLuClOMPxR4m4t/kzkbzbWgX8FQHVQcicrHqj70I92wiqJRZis/87wH
         MqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677783764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7eNgkNkO7kUzRzMyg6Huq3bqtBmJhOsXt5NyJWkplV0=;
        b=DQLb5HcAvIPEzzCTyaCp/4d03QeMC+OQa4mo3XOMN9Li60NZsqladMl72AdpR60Zfv
         1PcOvxVGpibIx6X3dYBH3253vigHuV+5oMyTjCjryzxAKA7KLc+rGG/+6BRmjoqsSKk4
         8O4VeRcMl/1qtfX6IjlK5ki9gwXlvGLjiZrIXWkETdG1Gg+tWWd49ClSOzgKW25UgcBn
         FgYkSCjvRRjn5bFbYr5JgC57tbdF5aNY1Ci0bKLOF4XjZ+SNOiZvogSeZb4pzqJgBMbV
         7KQZuzUpt4/7XAO1MFoyCgVHdvkEPj9CBOm8sM6EPPKVUSEQ1FsHD8L+PdcOcSCi5q4h
         Ufig==
X-Gm-Message-State: AO0yUKU1R4YyUvG7P3V0hoVtC19Q5bZq8lCGXJvDDdS7qtWdwGJdMspp
        fZl7+lQpzDKE/wgHo6khrpMbrPcuPKkHOxYzwgKy
X-Google-Smtp-Source: AK7set/ZgQ1PLxjzqfjnZhDwNZUZSnS+oEiRfFID9zN0H+NiVUb8QA+kx+QEtd5OoGJV/vgGc+ziesiZ5qkQNGGFv8w=
X-Received: by 2002:a63:e113:0:b0:4f0:2691:a0ee with SMTP id
 z19-20020a63e113000000b004f02691a0eemr1157233pgh.0.1677783763707; Thu, 02 Mar
 2023 11:02:43 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-3-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:02:32 -0500
Message-ID: <CAHC9VhRguGeb8=oNVFebshL_2LLZ4hf0qO97YBVm8OObLsLNTw@mail.gmail.com>
Subject: Re: [RFC PATCH v9 02/16] ipe: add policy parser
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

...

> ---
>  security/ipe/Makefile        |   2 +
>  security/ipe/policy.c        |  99 +++++++
>  security/ipe/policy.h        |  77 ++++++
>  security/ipe/policy_parser.c | 515 +++++++++++++++++++++++++++++++++++
>  security/ipe/policy_parser.h |  11 +
>  5 files changed, 704 insertions(+)
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h
>  create mode 100644 security/ipe/policy_parser.c
>  create mode 100644 security/ipe/policy_parser.h
>
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> index 571648579991..16bbe80991f1 100644
> --- a/security/ipe/Makefile
> +++ b/security/ipe/Makefile
> @@ -8,3 +8,5 @@
>  obj-$(CONFIG_SECURITY_IPE) +=3D \
>         hooks.o \
>         ipe.o \
> +       policy.o \
> +       policy_parser.o \
> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> new file mode 100644
> index 000000000000..e446f4b84152
> --- /dev/null
> +++ b/security/ipe/policy.c
> @@ -0,0 +1,99 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "ipe.h"
> +#include "policy.h"
> +#include "policy_parser.h"
> +#include "digest.h"
> +
> +#include <linux/verification.h>

Generally speaking the system/kernel-wide header files, e.g. headers
using '<...>', tend to come before the local header files, e.g.
headers using '"..."'.  I wouldn't consider this a hard rule, but
unless you have a reason to put the local header files first I would
stick with convention here.

> +/**
> + * ipe_free_policy - Deallocate a given IPE policy.
> + * @p: Supplies the policy to free.
> + *
> + * Safe to call on IS_ERR/NULL.
> + */
> +void ipe_free_policy(struct ipe_policy *p)
> +{
> +       if (IS_ERR_OR_NULL(p))
> +               return;
> +
> +       free_parsed_policy(p->parsed);
> +       if (!p->pkcs7)
> +               kfree(p->text);
> +       kfree(p->pkcs7);
> +       kfree(p);
> +}
> +
> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> +                         size_t asn1hdrlen)
> +{
> +       struct ipe_policy *p =3D ctx;
> +
> +       p->text =3D (const char *)data;
> +       p->textlen =3D len;
> +
> +       return 0;
> +}
> +
> +/**
> + * ipe_new_policy - Allocate and parse an ipe_policy structure.
> + *
> + * @text: Supplies a pointer to the plain-text policy to parse.
> + * @textlen: Supplies the length of @text.
> + * @pkcs7: Supplies a pointer to a pkcs7-signed IPE policy.
> + * @pkcs7len: Supplies the length of @pkcs7.
> + *
> + * @text/@textlen Should be NULL/0 if @pkcs7/@pkcs7len is set.
> + *
> + * The result will still need to be associated with a context via
> + * ipe_add_policy.
> + *
> + * Return:
> + * * !IS_ERR   - Success
> + * * -EBADMSG  - Policy is invalid
> + * * -ENOMEM   - Out of memory
> + */
> +struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> +                                 const char *pkcs7, size_t pkcs7len)
> +{
> +       int rc =3D 0;
> +       struct ipe_policy *new =3D NULL;
> +
> +       new =3D kzalloc(sizeof(*new), GFP_KERNEL);
> +       if (!new)
> +               return ERR_PTR(-ENOMEM);
> +
> +       if (!text) {
> +               new->pkcs7len =3D pkcs7len;
> +               new->pkcs7 =3D kmemdup(pkcs7, pkcs7len, GFP_KERNEL);
> +               if (!new->pkcs7) {
> +                       rc =3D -ENOMEM;
> +                       goto err;

As Roberto already pointed out, and you acknowledged, this leaks @new.
However, as a FYI for future work, if you have a label with only one
return instruction after the jump, e.g. the 'err' label here, you
should replace the 'goto' with the single return instruction.  Jumping
just to immediately return is a bit silly, but if you also need to
cleanup, e.g. free some memory, that's okay to use the goto/jump.

> +               }
> +
> +               rc =3D verify_pkcs7_signature(NULL, 0, new->pkcs7, pkcs7l=
en, NULL,
> +                                           VERIFYING_UNSPECIFIED_SIGNATU=
RE,
> +                                           set_pkcs7_data, new);
> +               if (rc)
> +                       goto err;
> +       } else {
> +               new->textlen =3D textlen;
> +               new->text =3D kstrdup(text, GFP_KERNEL);
> +               if (!new->text) {
> +                       rc =3D -ENOMEM;
> +                       goto err;
> +               }
> +       }
> +
> +       rc =3D parse_policy(new);
> +       if (rc)
> +               goto err;
> +
> +       return new;
> +err:
> +       return ERR_PTR(rc);
> +}

...

> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> new file mode 100644
> index 000000000000..6af2d9a811ec
> --- /dev/null
> +++ b/security/ipe/policy.h
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef IPE_POLICY_H
> +#define IPE_POLICY_H
> +
> +#include <linux/list.h>
> +#include <linux/types.h>
> +
> +enum ipe_op_type {
> +       ipe_op_exec =3D 0,
> +       ipe_op_firmware,
> +       ipe_op_kernel_module,
> +       ipe_op_kexec_image,
> +       ipe_op_kexec_initramfs,
> +       ipe_op_ima_policy,
> +       ipe_op_ima_x509,
> +       ipe_op_max
> +};

I'm used to seeing enum values defined in ALL_CAPS to help visually
distinguish them from variables and other assorted symbols, for
example:

  enum ipe_op_type {
    IPE_OP_EXEC =3D 0,
    ...
    IPE_OP_MAX,
  };

You might also want to consider prefixing IPE_OP_MAX with a couple
underscores, e.g. __IPE_OP_MAX, to help distinguish it as a sentinel
value and provide some protection in case you think you might ever
want an op named "max".  However, this really is a judgement call that
is up to you.

(Similar comments apply to the other IPE enums)

> +enum ipe_action_type {
> +       ipe_action_allow =3D 0,
> +       ipe_action_deny,
> +       ipe_action_max
> +};
> +
> +enum ipe_prop_type {
> +       ipe_prop_max
> +};
> +
> +struct ipe_prop {
> +       struct list_head next;
> +       enum ipe_prop_type type;
> +       void *value;
> +};
> +
> +struct ipe_rule {
> +       enum ipe_op_type op;
> +       enum ipe_action_type action;
> +       struct list_head props;
> +       struct list_head next;
> +};
> +
> +struct ipe_op_table {
> +       struct list_head rules;
> +       enum ipe_action_type default_action;
> +};
> +
> +struct ipe_parsed_policy {
> +       const char *name;
> +       struct {
> +               u16 major;
> +               u16 minor;
> +               u16 rev;
> +       } version;
> +
> +       enum ipe_action_type global_default_action;
> +
> +       struct ipe_op_table rules[ipe_op_max];
> +};
> +
> +struct ipe_policy {
> +       const char     *pkcs7;
> +       size_t          pkcs7len;
> +
> +       const char     *text;
> +       size_t          textlen;
> +
> +       struct ipe_parsed_policy *parsed;
> +};

None of the other structs in this header file have horizontally
aligned variable names, you should pick one style and stick with it
... and that style should be the un-aligned style, e.g. what was used
in 'struct ipe_rule'

> +struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
> +                                 const char *pkcs7, size_t pkcs7len);
> +void ipe_free_policy(struct ipe_policy *pol);
> +
> +#endif /* IPE_POLICY_H */
> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> new file mode 100644
> index 000000000000..c7ba0e865366
> --- /dev/null
> +++ b/security/ipe/policy_parser.c
> @@ -0,0 +1,515 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include "policy.h"
> +#include "policy_parser.h"
> +#include "digest.h"
> +
> +#include <linux/parser.h>
> +
> +#define START_COMMENT  '#'
> +
> +/**
> + * new_parsed_policy - Allocate and initialize a parsed policy.
> + *
> + * Return:
> + * * !IS_ERR   - OK
> + * * -ENOMEM   - Out of memory
> + */
> +static struct ipe_parsed_policy *new_parsed_policy(void)
> +{
> +       size_t i =3D 0;
> +       struct ipe_parsed_policy *p =3D NULL;
> +       struct ipe_op_table *t =3D NULL;
> +
> +       p =3D kzalloc(sizeof(*p), GFP_KERNEL);
> +       if (!p)
> +               return ERR_PTR(-ENOMEM);
> +
> +       p->global_default_action =3D ipe_action_max;

I'm assuming you're using the "ipe_action_max" as an intentional bogus
placeholder value here, yes?  If that is the case, have you considered
creating an "invalid" enum with an explicit zero value to save you
this additional assignment (you are already using kzalloc())?  For
example:

  enum ipe_op_type {
    IPE_OP_INVALID =3D 0,
    IPE_OP_EXEC,
    ...
    IPE_OP_MAX,
  };

  enum ipe_action_type {
    IPE_ACTION_INVALID =3D 0,
    IPE_ACTION_ALLOW,
    ...
    IPE_ACTION_MAX,
  };

> +       for (i =3D 0; i < ARRAY_SIZE(p->rules); ++i) {
> +               t =3D &p->rules[i];
> +
> +               t->default_action =3D ipe_action_max;
> +               INIT_LIST_HEAD(&t->rules);
> +       }
> +
> +       return p;
> +}
> +
> +/**
> + * remove_comment - Truncate all chars following START_COMMENT in a stri=
ng.
> + *
> + * @line: Supplies a poilcy line string for preprocessing.

"policy" :)

I'm definitely guilty of adding a lot of silly spelling errors to
codebases over the years, so no worries here, but in case you haven't
seen the codespell tool already, it might be something worth taking a
look at sometime.

* https://github.com/codespell-project/codespell

> + */
> +static void remove_comment(char *line)
> +{
> +       size_t i, len =3D 0;
> +
> +       len =3D strlen(line);
> +       for (i =3D 0; i < len && line[i] !=3D START_COMMENT; ++i)
> +               ;

The kernel has a strchr() implementation which could simplify this,
and possibly speed things up if there is an arch specific optimized
implementation.

> +       line[i] =3D '\0';
> +}
> +
> +/**
> + * remove_trailing_spaces - Truncate all trailing spaces in a string.
> + *
> + * @line: Supplies a poilcy line string for preprocessing.
> + */
> +static void remove_trailing_spaces(char *line)
> +{
> +       size_t i, len =3D 0;
> +
> +       len =3D strlen(line);
> +       for (i =3D len; i > 0 && (line[i - 1] =3D=3D ' ' || line[i - 1] =
=3D=3D '\t'); --i)
> +               ;

You can probably drop the @len variable and just assign 'i =3D
strlen(line)' in the for-loop initializer.

> +       line[i] =3D '\0';
> +}
> +
> +/**
> + * parse_version - Parse policy version.
> + * @ver: Supplies a version string to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0 - OK
> + * * !0        - Standard errno
> + */
> +static int parse_version(char *ver, struct ipe_parsed_policy *p)
> +{
> +       int rc =3D 0;
> +       size_t sep_count =3D 0;
> +       char *token;
> +       u16 *const cv[] =3D { &p->version.major, &p->version.minor, &p->v=
ersion.rev };
> +
> +       while ((token =3D strsep(&ver, ".")) !=3D NULL) {
> +               /* prevent overflow */
> +               if (sep_count >=3D ARRAY_SIZE(cv)) {
> +                       rc =3D -EBADMSG;
> +                       goto err;

Remember what I said above about not needing a 'goto' here? ;)

> +               }
> +
> +               rc =3D kstrtou16(token, 10, cv[sep_count]);
> +               if (rc)
> +                       goto err;
> +
> +               ++sep_count;
> +       }
> +
> +       /* prevent underflow */
> +       if (sep_count !=3D ARRAY_SIZE(cv))
> +               rc =3D -EBADMSG;
> +
> +err:
> +       return rc;
> +}
> +
> +enum header_opt {
> +       ipe_header_policy_name =3D 0,
> +       ipe_header_policy_version,
> +       ipe_header_max
> +};
> +
> +static const match_table_t header_tokens =3D {
> +       {ipe_header_policy_name,        "policy_name=3D%s"},
> +       {ipe_header_policy_version,     "policy_version=3D%s"},
> +       {ipe_header_max,                NULL}
> +};
> +
> +/**
> + * parse_header - Parse policy header information.
> + * @line: Supplies header line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0 - OK
> + * * !0        - Standard errno
> + */
> +static int parse_header(char *line, struct ipe_parsed_policy *p)
> +{
> +       int rc =3D 0;
> +       char *t, *ver =3D NULL;
> +       substring_t args[MAX_OPT_ARGS];
> +       size_t idx =3D 0;
> +
> +       while ((t =3D strsep(&line, " \t")) !=3D NULL) {
> +               int token;
> +
> +               if (*t =3D=3D '\0')
> +                       continue;
> +               if (idx >=3D ipe_header_max) {
> +                       rc =3D -EBADMSG;
> +                       goto err;
> +               }
> +
> +               token =3D match_token(t, header_tokens, args);
> +               if (token !=3D idx) {
> +                       rc =3D -EBADMSG;
> +                       goto err;
> +               }
> +
> +               switch (token) {
> +               case ipe_header_policy_name:
> +                       p->name =3D match_strdup(&args[0]);
> +                       if (!p->name)
> +                               rc =3D -ENOMEM;
> +                       break;
> +               case ipe_header_policy_version:
> +                       ver =3D match_strdup(&args[0]);
> +                       if (!ver) {
> +                               rc =3D -ENOMEM;
> +                               break;
> +                       }
> +                       rc =3D parse_version(ver, p);
> +                       break;
> +               default:
> +                       rc =3D -EBADMSG;
> +               }
> +               if (rc)
> +                       goto err;
> +               ++idx;
> +       }
> +
> +       if (idx !=3D ipe_header_max) {
> +               rc =3D -EBADMSG;
> +               goto err;
> +       }
> +       goto out;

Generally the normal, non-error case is structured so that the
function can continue to fall through to the correct code without
needed a 'goto'.  I would suggest moving the 'err' label/code *after*
the 'out' label/code so the normal case can just fall through without
the goto; you will have to add a 'goto out' at the end of 'err', but
that's the error case so we aren't going to worry too much about that.

Put another (shorter) way, structure your code to optimize for the
common, non-error case.

Needless to say, this applies to other functions in this patch(set).

> +err:
> +       kfree(p->name);
> +       p->name =3D NULL;
> +out:
> +       kfree(ver);
> +       return rc;
> +}
> +
> +/**
> + * is_default - Determine if the given token is "DEFAULT".
> + * @token: Supplies the token string to be compared.
> + *
> + * Return:
> + * * 0 - The token is not "DEFAULT"
> + * * !0        - The token is "DEFAULT"
> + */
> +static bool is_default(char *token)
> +{
> +       return !strcmp(token, "DEFAULT");
> +}

Let's be honest, "is_default()" isn't a great name, and it's a pretty
trivial function too; I'm wondering if hiding the simple strcmp()
behind an oddly named function is really all that helpful.  I'm okay
if you want to keep the function, but can we name it something else?
Maybe "token_default(...)" or something similar?

> +/**
> + * free_rule - Free the supplied ipe_rule struct.
> + * @r: Supplies the ipe_rule struct to be freed.
> + */

It might be worth mentioning that @r should be removed from any lists,
e.g. list_empty() is true.

> +static void free_rule(struct ipe_rule *r)
> +{
> +       struct ipe_prop *p, *t;
> +
> +       if (IS_ERR_OR_NULL(r))
> +               return;
> +
> +       list_for_each_entry_safe(p, t, &r->props, next) {
> +               kfree(p);
> +       }

That's interesting, I'm used to seeing a 'list_del()' call (or
similar) before the list entry is freed.  Although looking at
list_for_each_entry_safe() I guess it is safe with the current
implementation ... did you see this pattern elsewhere in the kernel?
If so, where?

Unless this is performance critical (I don't think it is?), it might
be safer to do an explicit `list_del()` before free'ing the entries
... unless this is now a common pattern in the kernel and I just
missed the memo.

> +       kfree(r);
> +}
> +
> +static const match_table_t operation_tokens =3D {
> +       {ipe_op_exec,                   "op=3DEXECUTE"},
> +       {ipe_op_firmware,               "op=3DFIRMWARE"},
> +       {ipe_op_kernel_module,          "op=3DKMODULE"},
> +       {ipe_op_kexec_image,            "op=3DKEXEC_IMAGE"},
> +       {ipe_op_kexec_initramfs,        "op=3DKEXEC_INITRAMFS"},
> +       {ipe_op_ima_policy,             "op=3DIMA_POLICY"},
> +       {ipe_op_ima_x509,               "op=3DIMA_X509_CERT"},
> +       {ipe_op_max,                    NULL}
> +};
> +
> +/**
> + * parse_operation - Parse the opeartion type given a token string.
> + * @t: Supplies the token string to be parsed.
> + *
> + * Return: The parsed opeartion type.
> + */
> +static enum ipe_op_type parse_operation(char *t)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +
> +       return match_token(t, operation_tokens, args);
> +}
> +
> +static const match_table_t action_tokens =3D {
> +       {ipe_action_allow,      "action=3DALLOW"},
> +       {ipe_action_deny,       "action=3DDENY"},
> +       {ipe_action_max,        NULL}
> +};
> +
> +/**
> + * parse_action - Parse the action type given a token string.
> + * @t: Supplies the token string to be parsed.
> + *
> + * Return: The parsed action type.
> + */
> +static enum ipe_action_type parse_action(char *t)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +
> +       return match_token(t, action_tokens, args);
> +}
> +
> +static const match_table_t property_tokens =3D {
> +       {ipe_prop_max,                                  NULL}
> +};
> +
> +/**
> + * parse_property - Parse the property type given a token string.
> + * @t: Supplies the token string to be parsed.
> + * @r: Supplies the ipe_rule the parsed property will be associated with=
.
> + *
> + * Return:
> + * * !IS_ERR   - OK
> + * * -ENOMEM   - Out of memory
> + * * -EBADMSG  - The supplied token cannot be parsed
> + */
> +int parse_property(char *t, struct ipe_rule *r)
> +{
> +       substring_t args[MAX_OPT_ARGS];
> +       struct ipe_prop *p =3D NULL;
> +       int rc =3D 0;
> +       int token;
> +       char *dup =3D NULL;
> +
> +       p =3D kzalloc(sizeof(*p), GFP_KERNEL);
> +       if (!p) {
> +               rc =3D -ENOMEM;
> +               goto err;
> +       }
> +
> +       token =3D match_token(t, property_tokens, args);
> +
> +       switch (token) {
> +       case ipe_prop_max:
> +       default:
> +               rc =3D -EBADMSG;
> +               break;
> +       }
> +       list_add_tail(&p->next, &r->props);
> +
> +err:
> +       kfree(dup);
> +       return rc;
> +}

There is a lot of stuff in 'parse_property()' that doesn't make sense
at this point in the patchset, including lots of unused variables.
Considering that no valid properties are defined yet, why not just
make this function return -EBADMSG in this patch?  You can always
populate it later when it becomes useful.

int parse_property(...)
{
  return -EBADMSG;
}

> +/**
> + * parse_rule - parse a policy rule line.
> + * @line: Supplies rule line to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * !IS_ERR   - OK
> + * * -ENOMEM   - Out of memory
> + * * -EBADMSG  - Policy syntax error
> + */
> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> +{
> +       int rc =3D 0;
> +       bool first_token =3D true, is_default_rule =3D false;
> +       bool op_parsed =3D false;
> +       enum ipe_op_type op =3D ipe_op_max;
> +       enum ipe_action_type action =3D ipe_action_max;
> +       struct ipe_rule *r =3D NULL;
> +       char *t;
> +
> +       r =3D kzalloc(sizeof(*r), GFP_KERNEL);
> +       if (!r) {
> +               rc =3D -ENOMEM;
> +               goto err;
> +       }
> +
> +       INIT_LIST_HEAD(&r->next);
> +       INIT_LIST_HEAD(&r->props);
> +
> +       while (t =3D strsep(&line, " \t"), line) {
> +               if (*t =3D=3D '\0')
> +                       continue;
> +               if (first_token && is_default(t)) {
> +                       is_default_rule =3D true;
> +               } else {
> +                       if (!op_parsed) {
> +                               op =3D parse_operation(t);
> +                               if (op =3D=3D ipe_op_max)
> +                                       rc =3D -EBADMSG;
> +                               else
> +                                       op_parsed =3D true;
> +                       } else {
> +                               rc =3D parse_property(t, r);
> +                       }
> +               }
> +
> +               if (rc)
> +                       goto err;
> +               first_token =3D false;
> +       }
> +
> +       action =3D parse_action(t);
> +       if (action =3D=3D ipe_action_max) {
> +               rc =3D -EBADMSG;
> +               goto err;
> +       }
> +
> +       if (is_default_rule) {
> +               if (op =3D=3D ipe_op_max) {
> +                       if (p->global_default_action !=3D ipe_action_max)
> +                               rc =3D -EBADMSG;
> +                       else
> +                               p->global_default_action =3D action;
> +               } else {
> +                       if (p->rules[op].default_action !=3D ipe_action_m=
ax)
> +                               rc =3D -EBADMSG;
> +                       else
> +                               p->rules[op].default_action =3D action;
> +               }
> +               free_rule(r);
> +       } else if (op !=3D ipe_op_max && action !=3D ipe_action_max) {
> +               r->op =3D op;
> +               r->action =3D action;
> +               list_add_tail(&r->next, &p->rules[op].rules);

There is no way @rc could be non-zero here, right?  If there is some
chance of it being non-zero we could have a problem with the @rc check
below jumping us to the 'err' label and free'ing a rule that has been
added to the list.

It might be better to move the list addition after the last error check.

> +       } else {
> +               rc =3D -EBADMSG;
> +       }
> +
> +       if (rc)
> +               goto err;
> +
> +       goto out;
> +
> +err:
> +       free_rule(r);
> +out:
> +       return rc;
> +}
> +
> +/**
> + * free_parsed_policy - free a parsed policy structure.
> + * @p: Supplies the parsed policy.
> + */
> +void free_parsed_policy(struct ipe_parsed_policy *p)
> +{
> +       size_t i =3D 0;
> +       struct ipe_rule *pp, *t;
> +
> +       if (IS_ERR_OR_NULL(p))
> +               return;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(p->rules); ++i)
> +               list_for_each_entry_safe(pp, t, &p->rules[i].rules, next)
> +                       free_rule(pp);
> +
> +       kfree(p);
> +}
> +
> +/**
> + * validate_policy - validate a parsed policy.
> + * @p: Supplies the fully parsed policy.
> + *
> + * Given a policy structure that was just parsed, validate that all
> + * necessary fields are present, initialized correctly, and all lines
> + * parsed are have been consumed.
> + *
> + * A parsed policy can be an invalid state for use (a default was
> + * undefined, a header was undefined) by just parsing the policy.
> + *
> + * Return:
> + * * 0         - OK
> + * * -EBADMSG  - Policy is invalid
> + */
> +static int validate_policy(const struct ipe_parsed_policy *p)
> +{
> +       int i =3D 0;
> +
> +       if (p->global_default_action !=3D ipe_action_max)
> +               return 0;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(p->rules); ++i) {
> +               if (p->rules[i].default_action =3D=3D ipe_action_max)
> +                       return -EBADMSG;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * parse_policy - Given a string, parse the string into an IPE policy.
> + * @p: partially filled ipe_policy structure to populate with the result=
.
> + *     it must have text and textlen set.
> + *
> + * Return:
> + * * 0         - OK
> + * * -EBADMSG  - Policy is invalid
> + * * -ENOMEM   - Out of Memory
> + */
> +int parse_policy(struct ipe_policy *p)
> +{
> +       int rc =3D 0;
> +       size_t len;
> +       char *policy =3D NULL, *dup =3D NULL;
> +       char *line =3D NULL;
> +       bool header_parsed =3D false;
> +       struct ipe_parsed_policy *pp =3D NULL;
> +
> +       if (!p->textlen)
> +               return -EBADMSG;
> +
> +       policy =3D kmemdup_nul(p->text, p->textlen, GFP_KERNEL);
> +       if (!policy)
> +               return -ENOMEM;
> +       dup =3D policy;
> +
> +       pp =3D new_parsed_policy();
> +       if (IS_ERR(pp)) {
> +               rc =3D PTR_ERR(pp);
> +               goto out;
> +       }
> +
> +       while ((line =3D strsep(&policy, "\n\r")) !=3D NULL) {
> +               remove_comment(line);
> +               remove_trailing_spaces(line);

I think it might be very easy for 'remove_trailing_spaces()' to return
the length of the string as it already knows where the string ends;
perhaps the function could return the string length and we could get
rid of the 'strlen()' call below?

> +               len =3D strlen(line);
> +               if (!len)
> +                       continue;
> +
> +               if (!header_parsed) {
> +                       rc =3D parse_header(line, pp);
> +                       if (rc)
> +                               goto err;
> +                       header_parsed =3D true;
> +                       continue;

Instead of the 'continue' above, why not just put the 'parse_rule()'
call into the 'else' block of this if-then-else?

> +               }
> +
> +               rc =3D parse_rule(line, pp);
> +               if (rc)
> +                       goto err;
> +       }
> +
> +       if (!header_parsed || validate_policy(pp)) {
> +               rc =3D -EBADMSG;
> +               goto err;
> +       }
> +
> +       p->parsed =3D pp;
> +
> +       goto out;
> +err:
> +       free_parsed_policy(pp);
> +out:
> +       kfree(dup);
> +
> +       return rc;
> +}
> diff --git a/security/ipe/policy_parser.h b/security/ipe/policy_parser.h
> new file mode 100644
> index 000000000000..699ca58a5a32
> --- /dev/null
> +++ b/security/ipe/policy_parser.h
> @@ -0,0 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#ifndef IPE_POLICY_PARSER_H
> +#define IPE_POLICY_PARSER_H
> +
> +int parse_policy(struct ipe_policy *p);
> +void free_parsed_policy(struct ipe_parsed_policy *p);
> +
> +#endif /* IPE_POLICY_PARSER */
> --
> 2.39.0

--
paul-moore.com
