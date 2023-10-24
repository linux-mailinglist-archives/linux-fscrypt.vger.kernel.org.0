Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07ABB7D4624
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Oct 2023 05:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjJXDw3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Oct 2023 23:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjJXDw2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Oct 2023 23:52:28 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5765F9
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:23 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-778a20df8c3so281469385a.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698119543; x=1698724343; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PYQStjjr2Q8HKTHbB20ou4WiXIqkha1Xi9gNGY1VyVs=;
        b=WAHBHXtjHEsNLoriS8vOtzrxgPI6/NMjDrdW5rIviWtRjDjfsUKxfuTOekd8pKSCyk
         D1j8V4OyAzgJh5iLtBrkUgqGbWOPoj3VTOZC9JcpciWz4cfj+rKZxhmRF+aEX4hl+T//
         nYVBex5k/D3yPgZa64W8kV4L66lKiEm323MlPTmkYLspb6+hojACf8PyxQeG/Yi1/2Fd
         +OW/2kBtN4yHRtVJALJYvZoAKP6yTODb8TTIJABeqk/QHJmguWtEAWhvnIO3uRtSFoP6
         Z31sTINDDOu0o0B9lHst/GL//IKm5o/Qqk6Ny3uJV1kKyC3Zjd7UiZcqkB+qzb9Ja7sv
         JeXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698119543; x=1698724343;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYQStjjr2Q8HKTHbB20ou4WiXIqkha1Xi9gNGY1VyVs=;
        b=YS3CxZVvw0PlmWMxUTVcg4OOTHQgU7u2ntYDgbejg3Uc1r5OnVbKnBAi+FrDHF6Y/W
         aaqmAGY3v9jJCFqhOKHZgkJDWomunuI+iSRWiTXuxNT3WGhh32fsWCQZR/fLue2bv0c2
         AxYmxYVSUebK9+dr18qxeb0y7CULef+pDEpzI2nYfQ1DSn4+R6/P53Fbx9b0BiDhGSpx
         fDkgCAaEpLj00tvv+V6YWJc3i+V42MupEYWAcTgnDeTwF6YgCwlVR5LViksNNGISrMUA
         gZLtMVJu8VMgC6b2rB5sZOKzS8pZsRA0ZztQHOwsyX8lUyyC59LtodU6mxTNeX7PRB0r
         7ztw==
X-Gm-Message-State: AOJu0YxW5iKfjHVjogpuMogNK18iQYOCBD++e0MwS5a8rcfvCjclfQmy
        8AoLhvN1rBWm7uYKciAbztgq
X-Google-Smtp-Source: AGHT+IHfXLDpTQH23RQCgDD0EvaJ8t5ssD/FP1FN3NpOgQNJgnc6N7o0sQ0agZuP/Pbj2axyoTKe+g==
X-Received: by 2002:a05:620a:1a25:b0:772:6419:89ab with SMTP id bk37-20020a05620a1a2500b00772641989abmr13610179qkb.55.1698119542757;
        Mon, 23 Oct 2023 20:52:22 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id bi12-20020a05620a318c00b00772662b7804sm3164703qkb.100.2023.10.23.20.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 20:52:22 -0700 (PDT)
Date:   Mon, 23 Oct 2023 23:52:21 -0400
Message-ID: <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
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
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
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
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move policy load and activation audit event to 03/12
>   + Fix a potential panic when a policy failed to load.
>   + use pr_warn for a failure to parse instead of an
>     audit record
>   + Remove comments from headers
>   + Add lockdep assertions to ipe_update_active_policy and
>     ipe_activate_policy
>   + Fix up warnings with checkpatch --strict
>   + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
>     nodes.
>   + Use memdup_user instead of kzalloc+simple_write_to_buffer.
>   + Remove strict_parse command line parameter, as it is added
>     by the sysctl command line.
>   + Prefix extern variables with ipe_
> 
> v4:
>   + Remove securityfs to reverse-dependency
>   + Add SHA1 reverse dependency.
>   + Add versioning scheme for IPE properties, and associated
>     interface to query the versioning scheme.
>   + Cause a parser to always return an error on unknown syntax.
>   + Remove strict_parse option
>   + Change active_policy interface from sysctl, to securityfs,
>     and change scheme.
> 
> v5:
>   + Cause an error if a default action is not defined for each
>     operation.
>   + Minor function renames
> 
> v6:
>   + No changes
> 
> v7:
>   + Further split parser and userspace interface into two
>     separate commits, for easier review.
>   + Refactor policy parser to make code cleaner via introducing a
>     more modular design, for easier extension of policy, and
>     easier review.
> 
> v8:
>   + remove unnecessary pr_info emission on parser loading
>   + add explicit newline to the pr_err emitted when a parser
>     fails to load.
> 
> v9:
>   + switch to match table to parse policy
>   + remove quote syntax and KERNEL_READ operation
> 
> v10:
>   + Fix memory leaks in parser
>   + Fix typos and change code styles
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/Makefile        |   2 +
>  security/ipe/policy.c        | 101 ++++++++
>  security/ipe/policy.h        |  83 ++++++
>  security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++++
>  security/ipe/policy_parser.h |  11 +
>  5 files changed, 684 insertions(+)
>  create mode 100644 security/ipe/policy.c
>  create mode 100644 security/ipe/policy.h
>  create mode 100644 security/ipe/policy_parser.c
>  create mode 100644 security/ipe/policy_parser.h

...

> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
> new file mode 100644
> index 000000000000..3a529c7950a1
> --- /dev/null
> +++ b/security/ipe/policy.c
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
> +			  size_t asn1hdrlen)
> +{
> +	struct ipe_policy *p = ctx;
> +
> +	p->text = (const char *)data;
> +	p->textlen = len;
> +
> +	return 0;
> +}

The @asn1hdrlen parameter isn't used in this function, at least at this
point in the patchset, so you really should remove it.  If it is needed
later in the patchset you can always update the function.

> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> new file mode 100644
> index 000000000000..c09458bd348d
> --- /dev/null
> +++ b/security/ipe/policy_parser.c
> @@ -0,0 +1,487 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +/**
> + * remove_trailing_spaces - Truncate all trailing spaces in a string.
> + *
> + * @line: Supplies a poilcy line string for preprocessing.
> + *
> + * Return: The length of truncated string.
> + */
> +static size_t remove_trailing_spaces(char *line)
> +{
> +	size_t i = 0;
> +
> +	for (i = strlen(line); i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
> +		;

Maybe I've asked this before, I can't remember: could you use the
isspace() macro here instead of explicitly checking for ' ' and '\t'?

  i = strlen(line);
  while (i > 0 && isspace(line[i - 1]))
    i--;
  line[i] = '\0';

> +	line[i] = '\0';
> +
> +	return i;
> +}
> +
> +/**
> + * parse_version - Parse policy version.
> + * @ver: Supplies a version string to be parsed.
> + * @p: Supplies the partial parsed policy.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Standard errno
> + */
> +static int parse_version(char *ver, struct ipe_parsed_policy *p)
> +{
> +	int rc = 0;
> +	size_t sep_count = 0;
> +	char *token;
> +	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
> +
> +	while ((token = strsep(&ver, ".")) != NULL) {
> +		/* prevent overflow */
> +		if (sep_count >= ARRAY_SIZE(cv))
> +			return -EBADMSG;
> +
> +		rc = kstrtou16(token, 10, cv[sep_count]);
> +		if (rc)
> +			return rc;
> +
> +		++sep_count;
> +	}
> +
> +	/* prevent underflow */
> +	if (sep_count != ARRAY_SIZE(cv))
> +		rc = -EBADMSG;

You could always just 'return -EBADMSG' here and 'return 0' below to
simplify things a little.

> +	return rc;
> +}
> +
> +enum header_opt {
> +	IPE_HEADER_POLICY_NAME = 0,
> +	IPE_HEADER_POLICY_VERSION,
> +	__IPE_HEADER_MAX
> +};
> +
> +static const match_table_t header_tokens = {
> +	{IPE_HEADER_POLICY_NAME,	"policy_name=%s"},
> +	{IPE_HEADER_POLICY_VERSION,	"policy_version=%s"},
> +	{__IPE_HEADER_MAX,		NULL}
> +};
> +
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
> +	while ((t = strsep(&line, IPE_POLICY_DELIM)) != NULL) {
> +		int token;
> +
> +		if (*t == '\0')
> +			continue;
> +		if (idx >= __IPE_HEADER_MAX) {
> +			rc = -EBADMSG;
> +			goto out;
> +		}
> +
> +		token = match_token(t, header_tokens, args);
> +		if (token != idx) {
> +			rc = -EBADMSG;
> +			goto out;
> +		}
> +
> +		switch (token) {
> +		case IPE_HEADER_POLICY_NAME:
> +			p->name = match_strdup(&args[0]);
> +			if (!p->name)
> +				rc = -ENOMEM;
> +			break;
> +		case IPE_HEADER_POLICY_VERSION:
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
> +			goto out;
> +		++idx;
> +	}
> +
> +	if (idx != __IPE_HEADER_MAX) {
> +		rc = -EBADMSG;
> +		goto out;

You probably don't need to 'goto out' here.

> +	}
> +
> +out:
> +	kfree(ver);
> +	return rc;
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
> +	enum ipe_op_type op = IPE_OP_INVALID;
> +	enum ipe_action_type action = IPE_ACTION_INVALID;
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
> +	while (t = strsep(&line, IPE_POLICY_DELIM), line) {
> +		if (*t == '\0')
> +			continue;
> +		if (first_token && token_default(t)) {
> +			is_default_rule = true;
> +		} else {
> +			if (!op_parsed) {
> +				op = parse_operation(t);
> +				if (op == IPE_OP_INVALID)
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
> +	if (action == IPE_ACTION_INVALID) {
> +		rc = -EBADMSG;
> +		goto err;
> +	}
> +
> +	if (is_default_rule) {
> +		if (!list_empty(&r->props)) {
> +			rc = -EBADMSG;
> +		} else if (op == IPE_OP_INVALID) {
> +			if (p->global_default_action != IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->global_default_action = action;
> +		} else {
> +			if (p->rules[op].default_action != IPE_ACTION_INVALID)
> +				rc = -EBADMSG;
> +			else
> +				p->rules[op].default_action = action;
> +		}
> +	} else if (op != IPE_OP_INVALID && action != IPE_ACTION_INVALID) {
> +		r->op = op;
> +		r->action = action;
> +	} else {
> +		rc = -EBADMSG;
> +	}

I might be missing something important in the policy syntac, but could
this function, and perhaps the ipe_parsed_policy struct, be simplified
if the default action was an explicit rule?

 "op=DEFAULT action=ALLOW"

> +	if (rc)
> +		goto err;
> +	if (!is_default_rule)
> +		list_add_tail(&r->next, &p->rules[op].rules);
> +	else
> +		free_rule(r);
> +
> +	return rc;
> +err:
> +	free_rule(r);
> +	return rc;
> +}
> +
> +/**
> + * free_parsed_policy - free a parsed policy structure.
> + * @p: Supplies the parsed policy.
> + */
> +void free_parsed_policy(struct ipe_parsed_policy *p)
> +{
> +	size_t i = 0;
> +	struct ipe_rule *pp, *t;
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return;
> +
> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
> +		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next) {
> +			list_del(&pp->next);
> +			free_rule(pp);
> +		}
> +
> +	kfree(p->name);
> +	kfree(p);
> +}
> +
> +/**
> + * validate_policy - validate a parsed policy.
> + * @p: Supplies the fully parsed policy.
> + *
> + * Given a policy structure that was just parsed, validate that all
> + * necessary fields are present, initialized correctly.
> + *
> + * A parsed policy can be in an invalid state for use (a default was
> + * undefined) by just parsing the policy.
> + *
> + * Return:
> + * * 0		- OK
> + * * -EBADMSG	- Policy is invalid
> + */
> +static int validate_policy(const struct ipe_parsed_policy *p)
> +{
> +	size_t i = 0;
> +
> +	if (p->global_default_action != IPE_ACTION_INVALID)
> +		return 0;

Should the if conditional above be "==" and not "!="?

> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
> +		if (p->rules[i].default_action == IPE_ACTION_INVALID)
> +			return -EBADMSG;
> +	}
> +
> +	return 0;
> +}

--
paul-moore.com
