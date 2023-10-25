Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84AF7D7835
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Oct 2023 00:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjJYWq3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Oct 2023 18:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjJYWq2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Oct 2023 18:46:28 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDE5E116;
        Wed, 25 Oct 2023 15:46:24 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 02F9D20B74C0;
        Wed, 25 Oct 2023 15:46:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02F9D20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698273984;
        bh=dm0CpobQbsS7czPRbypssTTQ8Y+D288bv9BFBEkdSMg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VmAw5akzIQiz/kj0sGLX3UeCAxwTCCby0Z4dr5chbT8LOZuTjrV6zzf6eX6rdeTB2
         HgzjasdJ8l9JQAN+hrSjlG6Pw2BbPf+Nau7CHPLo9dsnkAMZbhogCk09Psu6AyXNRZ
         T0Rg2cw/n2Sjeqk/kQGKNahzQPmB22jPvN4zyRHc=
Message-ID: <594923f6-6942-4b4b-8ca1-b9dcf74c9c1c@linux.microsoft.com>
Date:   Wed, 25 Oct 2023 15:45:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 2/19] ipe: add policy parser
To:     Paul Moore <paul@paul-moore.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
 <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
Content-Language: en-US
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <7c8c2a158c628a642078f746e5c42f2f.paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> IPE's interpretation of the what the user trusts is accomplished through
>> its policy. IPE's design is to not provide support for a single trust
>> provider, but to support multiple providers to enable the end-user to
>> choose the best one to seek their needs.
>>
>> This requires the policy to be rather flexible and modular so that
>> integrity providers, like fs-verity, dm-verity, dm-integrity, or
>> some other system, can plug into the policy with minimal code changes.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
...
>> ---
>>   security/ipe/Makefile        |   2 +
>>   security/ipe/policy.c        | 101 ++++++++
>>   security/ipe/policy.h        |  83 ++++++
>>   security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++++
>>   security/ipe/policy_parser.h |  11 +
>>   5 files changed, 684 insertions(+)
>>   create mode 100644 security/ipe/policy.c
>>   create mode 100644 security/ipe/policy.h
>>   create mode 100644 security/ipe/policy_parser.c
>>   create mode 100644 security/ipe/policy_parser.h
> 
> ...
> 
>> diff --git a/security/ipe/policy.c b/security/ipe/policy.c
>> new file mode 100644
>> index 000000000000..3a529c7950a1
>> --- /dev/null
>> +++ b/security/ipe/policy.c
>> @@ -0,0 +1,101 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
> 
> ...
> 
>> +static int set_pkcs7_data(void *ctx, const void *data, size_t len,
>> +			  size_t asn1hdrlen)
>> +{
>> +	struct ipe_policy *p = ctx;
>> +
>> +	p->text = (const char *)data;
>> +	p->textlen = len;
>> +
>> +	return 0;
>> +}
> 
> The @asn1hdrlen parameter isn't used in this function, at least at this
> point in the patchset, so you really should remove it.  If it is needed
> later in the patchset you can always update the function.
>
Although the @asn1hdrlen is not used, it's a required parameter for the 
pkcs7 callback. I guess adding a __always_unused might be the right 
solution?

>> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
>> new file mode 100644
>> index 000000000000..c09458bd348d
>> --- /dev/null
>> +++ b/security/ipe/policy_parser.c
>> @@ -0,0 +1,487 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
> 
> ...
> 
>> +/**
>> + * remove_trailing_spaces - Truncate all trailing spaces in a string.
>> + *
>> + * @line: Supplies a poilcy line string for preprocessing.
>> + *
>> + * Return: The length of truncated string.
>> + */
>> +static size_t remove_trailing_spaces(char *line)
>> +{
>> +	size_t i = 0;
>> +
>> +	for (i = strlen(line); i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
>> +		;
> 
> Maybe I've asked this before, I can't remember: could you use the
> isspace() macro here instead of explicitly checking for ' ' and '\t'?
> Yes, isspace() works here. I will update this part.

>    i = strlen(line);
>    while (i > 0 && isspace(line[i - 1]))
>      i--;
>    line[i] = '\0';
> 
>> +	line[i] = '\0';
>> +
>> +	return i;
>> +}
>> +
>> +/**
>> + * parse_version - Parse policy version.
>> + * @ver: Supplies a version string to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Standard errno
>> + */
>> +static int parse_version(char *ver, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	size_t sep_count = 0;
>> +	char *token;
>> +	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
>> +
>> +	while ((token = strsep(&ver, ".")) != NULL) {
>> +		/* prevent overflow */
>> +		if (sep_count >= ARRAY_SIZE(cv))
>> +			return -EBADMSG;
>> +
>> +		rc = kstrtou16(token, 10, cv[sep_count]);
>> +		if (rc)
>> +			return rc;
>> +
>> +		++sep_count;
>> +	}
>> +
>> +	/* prevent underflow */
>> +	if (sep_count != ARRAY_SIZE(cv))
>> +		rc = -EBADMSG;
> 
> You could always just 'return -EBADMSG' here and 'return 0' below to
> simplify things a little.
> 
I agree, this part is kind of unnecessary. I will update accordingly.

>> +	return rc;
>> +}
>> +
>> +enum header_opt {
>> +	IPE_HEADER_POLICY_NAME = 0,
>> +	IPE_HEADER_POLICY_VERSION,
>> +	__IPE_HEADER_MAX
>> +};
>> +
>> +static const match_table_t header_tokens = {
>> +	{IPE_HEADER_POLICY_NAME,	"policy_name=%s"},
>> +	{IPE_HEADER_POLICY_VERSION,	"policy_version=%s"},
>> +	{__IPE_HEADER_MAX,		NULL}
>> +};
>> +
>> +/**
>> + * parse_header - Parse policy header information.
>> + * @line: Supplies header line to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Standard errno
>> + */
>> +static int parse_header(char *line, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	char *t, *ver = NULL;
>> +	substring_t args[MAX_OPT_ARGS];
>> +	size_t idx = 0;
>> +
>> +	while ((t = strsep(&line, IPE_POLICY_DELIM)) != NULL) {
>> +		int token;
>> +
>> +		if (*t == '\0')
>> +			continue;
>> +		if (idx >= __IPE_HEADER_MAX) {
>> +			rc = -EBADMSG;
>> +			goto out;
>> +		}
>> +
>> +		token = match_token(t, header_tokens, args);
>> +		if (token != idx) {
>> +			rc = -EBADMSG;
>> +			goto out;
>> +		}
>> +
>> +		switch (token) {
>> +		case IPE_HEADER_POLICY_NAME:
>> +			p->name = match_strdup(&args[0]);
>> +			if (!p->name)
>> +				rc = -ENOMEM;
>> +			break;
>> +		case IPE_HEADER_POLICY_VERSION:
>> +			ver = match_strdup(&args[0]);
>> +			if (!ver) {
>> +				rc = -ENOMEM;
>> +				break;
>> +			}
>> +			rc = parse_version(ver, p);
>> +			break;
>> +		default:
>> +			rc = -EBADMSG;
>> +		}
>> +		if (rc)
>> +			goto out;
>> +		++idx;
>> +	}
>> +
>> +	if (idx != __IPE_HEADER_MAX) {
>> +		rc = -EBADMSG;
>> +		goto out;
> 
> You probably don't need to 'goto out' here.
>
Yes it's unnecessary, thanks for pointing that out.

>> +	}
>> +
>> +out:
>> +	kfree(ver);
>> +	return rc;
>> +}
> 
> ...
> 
>> +/**
>> + * parse_rule - parse a policy rule line.
>> + * @line: Supplies rule line to be parsed.
>> + * @p: Supplies the partial parsed policy.
>> + *
>> + * Return:
>> + * * !IS_ERR	- OK
>> + * * -ENOMEM	- Out of memory
>> + * * -EBADMSG	- Policy syntax error
>> + */
>> +static int parse_rule(char *line, struct ipe_parsed_policy *p)
>> +{
>> +	int rc = 0;
>> +	bool first_token = true, is_default_rule = false;
>> +	bool op_parsed = false;
>> +	enum ipe_op_type op = IPE_OP_INVALID;
>> +	enum ipe_action_type action = IPE_ACTION_INVALID;
>> +	struct ipe_rule *r = NULL;
>> +	char *t;
>> +
>> +	r = kzalloc(sizeof(*r), GFP_KERNEL);
>> +	if (!r)
>> +		return -ENOMEM;
>> +
>> +	INIT_LIST_HEAD(&r->next);
>> +	INIT_LIST_HEAD(&r->props);
>> +
>> +	while (t = strsep(&line, IPE_POLICY_DELIM), line) {
>> +		if (*t == '\0')
>> +			continue;
>> +		if (first_token && token_default(t)) {
>> +			is_default_rule = true;
>> +		} else {
>> +			if (!op_parsed) {
>> +				op = parse_operation(t);
>> +				if (op == IPE_OP_INVALID)
>> +					rc = -EBADMSG;
>> +				else
>> +					op_parsed = true;
>> +			} else {
>> +				rc = parse_property(t, r);
>> +			}
>> +		}
>> +
>> +		if (rc)
>> +			goto err;
>> +		first_token = false;
>> +	}
>> +
>> +	action = parse_action(t);
>> +	if (action == IPE_ACTION_INVALID) {
>> +		rc = -EBADMSG;
>> +		goto err;
>> +	}
>> +
>> +	if (is_default_rule) {
>> +		if (!list_empty(&r->props)) {
>> +			rc = -EBADMSG;
>> +		} else if (op == IPE_OP_INVALID) {
>> +			if (p->global_default_action != IPE_ACTION_INVALID)
>> +				rc = -EBADMSG;
>> +			else
>> +				p->global_default_action = action;
>> +		} else {
>> +			if (p->rules[op].default_action != IPE_ACTION_INVALID)
>> +				rc = -EBADMSG;
>> +			else
>> +				p->rules[op].default_action = action;
>> +		}
>> +	} else if (op != IPE_OP_INVALID && action != IPE_ACTION_INVALID) {
>> +		r->op = op;
>> +		r->action = action;
>> +	} else {
>> +		rc = -EBADMSG;
>> +	}
> 
> I might be missing something important in the policy syntac, but could
> this function, and perhaps the ipe_parsed_policy struct, be simplified
> if the default action was an explicit rule?
> 
>   "op=DEFAULT action=ALLOW"
>
The complexity here arises from our need for two types of default rules: 
one for global settings and another for operation-specific settings.

To illustrate the flexibility of operation-specific default rules, users 
can set their policy to have a default rule of 'DENY' for execution, 
meaning all execution actions are prohibited by default. This let users 
to create an allow-list for execution. At the same time, the default 
rule for read can be set to 'ALLOW'.  This let users to create an 
deny-list for read.

Adding explicit default rules can simplify ipe_parsed_policy struct, but 
that impose a burden on users that requires users always add the default 
rules the end of the policy. In contrast, our current design allows 
users to place the default rule anywhere in the policy. In practice, we 
often position the default rule at the beginning of the policy, which 
makes it more convenient for users to add new rules.

>> +	if (rc)
>> +		goto err;
>> +	if (!is_default_rule)
>> +		list_add_tail(&r->next, &p->rules[op].rules);
>> +	else
>> +		free_rule(r);
>> +
>> +	return rc;
>> +err:
>> +	free_rule(r);
>> +	return rc;
>> +}
>> +
>> +/**
>> + * free_parsed_policy - free a parsed policy structure.
>> + * @p: Supplies the parsed policy.
>> + */
>> +void free_parsed_policy(struct ipe_parsed_policy *p)
>> +{
>> +	size_t i = 0;
>> +	struct ipe_rule *pp, *t;
>> +
>> +	if (IS_ERR_OR_NULL(p))
>> +		return;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
>> +		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next) {
>> +			list_del(&pp->next);
>> +			free_rule(pp);
>> +		}
>> +
>> +	kfree(p->name);
>> +	kfree(p);
>> +}
>> +
>> +/**
>> + * validate_policy - validate a parsed policy.
>> + * @p: Supplies the fully parsed policy.
>> + *
>> + * Given a policy structure that was just parsed, validate that all
>> + * necessary fields are present, initialized correctly.
>> + *
>> + * A parsed policy can be in an invalid state for use (a default was
>> + * undefined) by just parsing the policy.
>> + *
>> + * Return:
>> + * * 0		- OK
>> + * * -EBADMSG	- Policy is invalid
>> + */
>> +static int validate_policy(const struct ipe_parsed_policy *p)
>> +{
>> +	size_t i = 0;
>> +
>> +	if (p->global_default_action != IPE_ACTION_INVALID)
>> +		return 0;
> 
> Should the if conditional above be "==" and not "!="?
>No, "!=" is the correct one.

The purpose of validation is to ensure that we have enough default rules 
to cover all cases. If the global default action not invalid, it means 
we have a global default rule in the policy to cover all cases, thus we 
simply return 0.

However, if there is no global default rule, then we need to ensure that 
for each operation, there is a operation specific default rule, this is 
validated in the for loop below.

-Fan

>> +	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
>> +		if (p->rules[i].default_action == IPE_ACTION_INVALID)
>> +			return -EBADMSG;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> --
> paul-moore.com
