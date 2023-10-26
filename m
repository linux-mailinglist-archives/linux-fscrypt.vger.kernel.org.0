Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E07D8A74
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Oct 2023 23:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjJZVhP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Oct 2023 17:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjJZVhN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Oct 2023 17:37:13 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C41718A
        for <linux-fscrypt@vger.kernel.org>; Thu, 26 Oct 2023 14:37:11 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-5a7c08b7744so10803227b3.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 26 Oct 2023 14:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698356230; x=1698961030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXajQCd4F/1lAfqXs9yFErTqS9iveL7bqi06E72Hzxw=;
        b=O55ntrRkoSk4p1rxbJKdJBiHXyyTLjqfDZlFDCFTDaAftVT9vSSpsZ5Nn/lBMXAMyA
         ngDsmGBQp16yWWUcSgjhE62qWfR/TPOOju5Wg6mZIWwtVZ0K8IBssUBxJ0uZ5Uqnrg52
         TKGh5rInzQ0tNfMj7BSwHDqlljEjhadQoqWTGhbl7JaXlDBCzYGjy2L3kHy9P30XCuLX
         S9MBoeODeT+oeMN2t/4TkRRXms1vrjYWN82xnLFav2POjw6xrL9KOI9y5VnAXIapfMsq
         RtHKYkm/eYoYhmJW3S40jagam0J1jq/aK7JEDwETISARtuHZHYJxPSwVFCiuI1KA5Le+
         x4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698356230; x=1698961030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MXajQCd4F/1lAfqXs9yFErTqS9iveL7bqi06E72Hzxw=;
        b=K6QgQAq5swG+44HkN2fzbPQPAKw2O7gwJ0dR0tqYbPG41GHh3SnLBqK5n9NZkhjR7P
         nXs2EvVyZlWQSjAPTt1GKkcTl6zF0sj4qj9QyHAValz+EtHhoNwWvNXX1sLNwD/2ikEM
         xn/OQNtPwfVkdcuAJf7KPOBwiH1oxapLw9A711VErfBCmiNIdkZKXp2EpujrSwOuRFZB
         AyzB9RVSAM5FW/ijrApSMQ94bzhBdzLV5O+lw4SzKmmAs8nqrHten2dTYtl3l43HZAuO
         j9cwhL0ro64PSXzHpZ3CpkYgx1rV0ObAoI3g6N3tWYdATe93qBaMfj+4r8p/2SOrM2Oi
         8MzQ==
X-Gm-Message-State: AOJu0Yz0g7YJ0bEARv0Vo/iVLwseiX8fEKVkO3bqADiNRfy9nIMJHupO
        Q7l8y+bj2DU5CX4HL74gTdDW1QmSjyo5lukNNive
X-Google-Smtp-Source: AGHT+IGs3yVweOLen1m7MhCJB6RbgNFPe23s8osYedKaob9va7EUB7gQ3SlX41xgxocwXKE4pusvmi6cSAkHebq1bDk=
X-Received: by 2002:a25:238e:0:b0:da1:2a2b:4c5b with SMTP id
 j136-20020a25238e000000b00da12a2b4c5bmr342821ybj.41.1698356230039; Thu, 26
 Oct 2023 14:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
 <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com> <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
In-Reply-To: <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 26 Oct 2023 17:36:59 -0400
Message-ID: <CAHC9VhQv5xBtG9zVk_rpNmQ=GLm9sitxeyqbwkw=LmHAN0Su3g@mail.gmail.com>
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
To:     Fan Wu <wufan@linux.microsoft.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 25, 2023 at 6:46=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
> On 10/23/2023 8:52 PM, Paul Moore wrote:
> > On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> >>
> >> IPE's interpretation of the what the user trusts is accomplished throu=
gh
> >> its policy. IPE's design is to not provide support for a single trust
> >> provider, but to support multiple providers to enable the end-user to
> >> choose the best one to seek their needs.
> >>
> >> This requires the policy to be rather flexible and modular so that
> >> integrity providers, like fs-verity, dm-verity, dm-integrity, or
> >> some other system, can plug into the policy with minimal code changes.
> >>
> >> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> >> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ...
> >> ---
> >>   security/ipe/Makefile        |   2 +
> >>   security/ipe/policy.c        | 101 ++++++++
> >>   security/ipe/policy.h        |  83 ++++++
> >>   security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++=
++
> >>   security/ipe/policy_parser.h |  11 +
> >>   5 files changed, 684 insertions(+)
> >>   create mode 100644 security/ipe/policy.c
> >>   create mode 100644 security/ipe/policy.h
> >>   create mode 100644 security/ipe/policy_parser.c
> >>   create mode 100644 security/ipe/policy_parser.h
> >
> > ...
> >
> >> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> >> new file mode 100644
> >> index 000000000000..3a529c7950a1
> >> --- /dev/null
> >> +++ b/security/ipe/policy.c
> >> @@ -0,0 +1,101 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (C) Microsoft Corporation. All rights reserved.
> >> + */
> >
> > ...
> >
> >> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> >> +                      size_t asn1hdrlen)
> >> +{
> >> +    struct ipe_policy *p =3D ctx;
> >> +
> >> +    p->text =3D (const char *)data;
> >> +    p->textlen =3D len;
> >> +
> >> +    return 0;
> >> +}
> >
> > The @asn1hdrlen parameter isn't used in this function, at least at this
> > point in the patchset, so you really should remove it.  If it is needed
> > later in the patchset you can always update the function.
>
> Although the @asn1hdrlen is not used, it's a required parameter for the
> pkcs7 callback. I guess adding a __always_unused might be the right
> solution?

Ah gotcha, I'm sorry for the noise, I obviously didn't catch that.  As
for the __always_unused marking, yes, that's probably a good idea.

> >> +/**
> >> + * parse_rule - parse a policy rule line.
> >> + * @line: Supplies rule line to be parsed.
> >> + * @p: Supplies the partial parsed policy.
> >> + *
> >> + * Return:
> >> + * * !IS_ERR        - OK
> >> + * * -ENOMEM        - Out of memory
> >> + * * -EBADMSG       - Policy syntax error
> >> + */
> >> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
> >> +{
> >> +    int rc =3D 0;
> >> +    bool first_token =3D true, is_default_rule =3D false;
> >> +    bool op_parsed =3D false;
> >> +    enum ipe_op_type op =3D IPE_OP_INVALID;
> >> +    enum ipe_action_type action =3D IPE_ACTION_INVALID;
> >> +    struct ipe_rule *r =3D NULL;
> >> +    char *t;
> >> +
> >> +    r =3D kzalloc(sizeof(*r), GFP_KERNEL);
> >> +    if (!r)
> >> +            return -ENOMEM;
> >> +
> >> +    INIT_LIST_HEAD(&r->next);
> >> +    INIT_LIST_HEAD(&r->props);
> >> +
> >> +    while (t =3D strsep(&line, IPE_POLICY_DELIM), line) {
> >> +            if (*t =3D=3D '\0')
> >> +                    continue;
> >> +            if (first_token && token_default(t)) {
> >> +                    is_default_rule =3D true;
> >> +            } else {
> >> +                    if (!op_parsed) {
> >> +                            op =3D parse_operation(t);
> >> +                            if (op =3D=3D IPE_OP_INVALID)
> >> +                                    rc =3D -EBADMSG;
> >> +                            else
> >> +                                    op_parsed =3D true;
> >> +                    } else {
> >> +                            rc =3D parse_property(t, r);
> >> +                    }
> >> +            }
> >> +
> >> +            if (rc)
> >> +                    goto err;
> >> +            first_token =3D false;
> >> +    }
> >> +
> >> +    action =3D parse_action(t);
> >> +    if (action =3D=3D IPE_ACTION_INVALID) {
> >> +            rc =3D -EBADMSG;
> >> +            goto err;
> >> +    }
> >> +
> >> +    if (is_default_rule) {
> >> +            if (!list_empty(&r->props)) {
> >> +                    rc =3D -EBADMSG;
> >> +            } else if (op =3D=3D IPE_OP_INVALID) {
> >> +                    if (p->global_default_action !=3D IPE_ACTION_INVA=
LID)
> >> +                            rc =3D -EBADMSG;
> >> +                    else
> >> +                            p->global_default_action =3D action;
> >> +            } else {
> >> +                    if (p->rules[op].default_action !=3D IPE_ACTION_I=
NVALID)
> >> +                            rc =3D -EBADMSG;
> >> +                    else
> >> +                            p->rules[op].default_action =3D action;
> >> +            }
> >> +    } else if (op !=3D IPE_OP_INVALID && action !=3D IPE_ACTION_INVAL=
ID) {
> >> +            r->op =3D op;
> >> +            r->action =3D action;
> >> +    } else {
> >> +            rc =3D -EBADMSG;
> >> +    }
> >
> > I might be missing something important in the policy syntac, but could
> > this function, and perhaps the ipe_parsed_policy struct, be simplified
> > if the default action was an explicit rule?
> >
> >   "op=3DDEFAULT action=3DALLOW"
>
> The complexity here arises from our need for two types of default rules:
> one for global settings and another for operation-specific settings.
>
> To illustrate the flexibility of operation-specific default rules, users
> can set their policy to have a default rule of 'DENY' for execution,
> meaning all execution actions are prohibited by default. This let users
> to create an allow-list for execution. At the same time, the default
> rule for read can be set to 'ALLOW'.  This let users to create an
> deny-list for read.
>
> Adding explicit default rules can simplify ipe_parsed_policy struct, but
> that impose a burden on users that requires users always add the default
> rules the end of the policy. In contrast, our current design allows
> users to place the default rule anywhere in the policy. In practice, we
> often position the default rule at the beginning of the policy, which
> makes it more convenient for users to add new rules.

Okay, thanks for the explanation.

> >> +/**
> >> + * free_parsed_policy - free a parsed policy structure.
> >> + * @p: Supplies the parsed policy.
> >> + */
> >> +void free_parsed_policy(struct ipe_parsed_policy *p)
> >> +{
> >> +    size_t i =3D 0;
> >> +    struct ipe_rule *pp, *t;
> >> +
> >> +    if (IS_ERR_OR_NULL(p))
> >> +            return;
> >> +
> >> +    for (i =3D 0; i < ARRAY_SIZE(p->rules); ++i)
> >> +            list_for_each_entry_safe(pp, t, &p->rules[i].rules, next)=
 {
> >> +                    list_del(&pp->next);
> >> +                    free_rule(pp);
> >> +            }
> >> +
> >> +    kfree(p->name);
> >> +    kfree(p);
> >> +}
> >> +
> >> +/**
> >> + * validate_policy - validate a parsed policy.
> >> + * @p: Supplies the fully parsed policy.
> >> + *
> >> + * Given a policy structure that was just parsed, validate that all
> >> + * necessary fields are present, initialized correctly.
> >> + *
> >> + * A parsed policy can be in an invalid state for use (a default was
> >> + * undefined) by just parsing the policy.
> >> + *
> >> + * Return:
> >> + * * 0              - OK
> >> + * * -EBADMSG       - Policy is invalid
> >> + */
> >> +static int validate_policy(const struct ipe_parsed_policy *p)
> >> +{
> >> +    size_t i =3D 0;
> >> +
> >> +    if (p->global_default_action !=3D IPE_ACTION_INVALID)
> >> +            return 0;
> >
> > Should the if conditional above be "=3D=3D" and not "!=3D"?
>
> >No, "!=3D" is the correct one.
>
> The purpose of validation is to ensure that we have enough default rules
> to cover all cases. If the global default action not invalid, it means
> we have a global default rule in the policy to cover all cases, thus we
> simply return 0.
>
> However, if there is no global default rule, then we need to ensure that
> for each operation, there is a operation specific default rule, this is
> validated in the for loop below.

Makes sense, thanks.

--=20
paul-moore.com
