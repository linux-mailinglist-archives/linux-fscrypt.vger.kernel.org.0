Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3F27B9757
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbjJDWKp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjJDWJ4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:56 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA401D8;
        Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 3F86A20B74C4; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3F86A20B74C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=lhXR0ch0tKCjw7RJS4YUEV2H1gHFyEUZBLJkufmbD2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJkr+8ZZRXGS1wZpNyWP9uEBf5UJg2mOgcdRIy1NjYzl2sUfP+fX0YhqnKeS/NnzY
         688o/IDMpbLMdDDHDKYZmmTTDgggHZBKyTwpEd2q2rANd4Ueu2XcETAJCoDsLqtLPP
         yVLBxE3XwMDJSVOYWIMMO6DZSq4KSuyThK8Oeq3Q=
From:   Fan Wu <wufan@linux.microsoft.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v11 02/19] ipe: add policy parser
Date:   Wed,  4 Oct 2023 15:09:29 -0700
Message-Id: <1696457386-3010-3-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE's interpretation of the what the user trusts is accomplished through
its policy. IPE's design is to not provide support for a single trust
provider, but to support multiple providers to enable the end-user to
choose the best one to seek their needs.

This requires the policy to be rather flexible and modular so that
integrity providers, like fs-verity, dm-verity, dm-integrity, or
some other system, can plug into the policy with minimal code changes.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  + Split evaluation loop, access control hooks,
    and evaluation loop from policy parser and userspace
    interface to pass mailing list character limit

v3:
  + Move policy load and activation audit event to 03/12
  + Fix a potential panic when a policy failed to load.
  + use pr_warn for a failure to parse instead of an
    audit record
  + Remove comments from headers
  + Add lockdep assertions to ipe_update_active_policy and
    ipe_activate_policy
  + Fix up warnings with checkpatch --strict
  + Use file_ns_capable for CAP_MAC_ADMIN for securityfs
    nodes.
  + Use memdup_user instead of kzalloc+simple_write_to_buffer.
  + Remove strict_parse command line parameter, as it is added
    by the sysctl command line.
  + Prefix extern variables with ipe_

v4:
  + Remove securityfs to reverse-dependency
  + Add SHA1 reverse dependency.
  + Add versioning scheme for IPE properties, and associated
    interface to query the versioning scheme.
  + Cause a parser to always return an error on unknown syntax.
  + Remove strict_parse option
  + Change active_policy interface from sysctl, to securityfs,
    and change scheme.

v5:
  + Cause an error if a default action is not defined for each
    operation.
  + Minor function renames

v6:
  + No changes

v7:
  + Further split parser and userspace interface into two
    separate commits, for easier review.
  + Refactor policy parser to make code cleaner via introducing a
    more modular design, for easier extension of policy, and
    easier review.

v8:
  + remove unnecessary pr_info emission on parser loading
  + add explicit newline to the pr_err emitted when a parser
    fails to load.

v9:
  + switch to match table to parse policy
  + remove quote syntax and KERNEL_READ operation

v10:
  + Fix memory leaks in parser
  + Fix typos and change code styles

v11:
  + Fix code style issues
---
 security/ipe/Makefile        |   2 +
 security/ipe/policy.c        | 101 ++++++++
 security/ipe/policy.h        |  83 ++++++
 security/ipe/policy_parser.c | 487 +++++++++++++++++++++++++++++++++++
 security/ipe/policy_parser.h |  11 +
 5 files changed, 684 insertions(+)
 create mode 100644 security/ipe/policy.c
 create mode 100644 security/ipe/policy.h
 create mode 100644 security/ipe/policy_parser.c
 create mode 100644 security/ipe/policy_parser.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index f7a80d0f18f8..c09aec4904f2 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -7,3 +7,5 @@
 
 obj-$(CONFIG_SECURITY_IPE) += \
 	ipe.o \
+	policy.o \
+	policy_parser.o \
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
new file mode 100644
index 000000000000..3a529c7950a1
--- /dev/null
+++ b/security/ipe/policy.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/errno.h>
+#include <linux/verification.h>
+
+#include "ipe.h"
+#include "policy.h"
+#include "policy_parser.h"
+
+/**
+ * ipe_free_policy - Deallocate a given IPE policy.
+ * @p: Supplies the policy to free.
+ *
+ * Safe to call on IS_ERR/NULL.
+ */
+void ipe_free_policy(struct ipe_policy *p)
+{
+	if (IS_ERR_OR_NULL(p))
+		return;
+
+	free_parsed_policy(p->parsed);
+	/*
+	 * p->text is allocated only when p->pkcs7 is not NULL
+	 * otherwise it points to the plaintext data inside the pkcs7
+	 */
+	if (!p->pkcs7)
+		kfree(p->text);
+	kfree(p->pkcs7);
+	kfree(p);
+}
+
+static int set_pkcs7_data(void *ctx, const void *data, size_t len,
+			  size_t asn1hdrlen)
+{
+	struct ipe_policy *p = ctx;
+
+	p->text = (const char *)data;
+	p->textlen = len;
+
+	return 0;
+}
+
+/**
+ * ipe_new_policy - Allocate and parse an ipe_policy structure.
+ *
+ * @text: Supplies a pointer to the plain-text policy to parse.
+ * @textlen: Supplies the length of @text.
+ * @pkcs7: Supplies a pointer to a pkcs7-signed IPE policy.
+ * @pkcs7len: Supplies the length of @pkcs7.
+ *
+ * @text/@textlen Should be NULL/0 if @pkcs7/@pkcs7len is set.
+ *
+ * Return:
+ * * !IS_ERR	- Success
+ * * -EBADMSG	- Policy is invalid
+ * * -ENOMEM	- Out of memory
+ */
+struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
+				  const char *pkcs7, size_t pkcs7len)
+{
+	int rc = 0;
+	struct ipe_policy *new = NULL;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	if (!text) {
+		new->pkcs7len = pkcs7len;
+		new->pkcs7 = kmemdup(pkcs7, pkcs7len, GFP_KERNEL);
+		if (!new->pkcs7) {
+			rc = -ENOMEM;
+			goto err;
+		}
+
+		rc = verify_pkcs7_signature(NULL, 0, new->pkcs7, pkcs7len, NULL,
+					    VERIFYING_UNSPECIFIED_SIGNATURE,
+					    set_pkcs7_data, new);
+		if (rc)
+			goto err;
+	} else {
+		new->textlen = textlen;
+		new->text = kstrdup(text, GFP_KERNEL);
+		if (!new->text) {
+			rc = -ENOMEM;
+			goto err;
+		}
+	}
+
+	rc = parse_policy(new);
+	if (rc)
+		goto err;
+
+	return new;
+err:
+	ipe_free_policy(new);
+	return ERR_PTR(rc);
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
new file mode 100644
index 000000000000..77aa91f2b953
--- /dev/null
+++ b/security/ipe/policy.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef _IPE_POLICY_H
+#define _IPE_POLICY_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+enum ipe_op_type {
+	IPE_OP_EXEC = 0,
+	IPE_OP_FIRMWARE,
+	IPE_OP_KERNEL_MODULE,
+	IPE_OP_KEXEC_IMAGE,
+	IPE_OP_KEXEC_INITRAMFS,
+	IPE_OP_IMA_POLICY,
+	IPE_OP_IMA_X509,
+	__IPE_OP_MAX
+};
+
+#define IPE_OP_INVALID __IPE_OP_MAX
+
+enum ipe_action_type {
+	IPE_ACTION_ALLOW = 0,
+	IPE_ACTION_DENY,
+	__IPE_ACTION_MAX
+};
+
+#define IPE_ACTION_INVALID __IPE_ACTION_MAX
+
+enum ipe_prop_type {
+	__IPE_PROP_MAX
+};
+
+#define IPE_PROP_INVALID __IPE_PROP_MAX
+
+struct ipe_prop {
+	struct list_head next;
+	enum ipe_prop_type type;
+	void *value;
+};
+
+struct ipe_rule {
+	enum ipe_op_type op;
+	enum ipe_action_type action;
+	struct list_head props;
+	struct list_head next;
+};
+
+struct ipe_op_table {
+	struct list_head rules;
+	enum ipe_action_type default_action;
+};
+
+struct ipe_parsed_policy {
+	const char *name;
+	struct {
+		u16 major;
+		u16 minor;
+		u16 rev;
+	} version;
+
+	enum ipe_action_type global_default_action;
+
+	struct ipe_op_table rules[__IPE_OP_MAX];
+};
+
+struct ipe_policy {
+	const char *pkcs7;
+	size_t pkcs7len;
+
+	const char *text;
+	size_t textlen;
+
+	struct ipe_parsed_policy *parsed;
+};
+
+struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
+				  const char *pkcs7, size_t pkcs7len);
+void ipe_free_policy(struct ipe_policy *pol);
+
+#endif /* _IPE_POLICY_H */
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
new file mode 100644
index 000000000000..c09458bd348d
--- /dev/null
+++ b/security/ipe/policy_parser.c
@@ -0,0 +1,487 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/parser.h>
+#include <linux/types.h>
+
+#include "policy.h"
+#include "policy_parser.h"
+
+#define START_COMMENT	'#'
+#define IPE_POLICY_DELIM " \t"
+#define IPE_LINE_DELIM "\n\r"
+
+/**
+ * new_parsed_policy - Allocate and initialize a parsed policy.
+ *
+ * Return:
+ * * !IS_ERR	- OK
+ * * -ENOMEM	- Out of memory
+ */
+static struct ipe_parsed_policy *new_parsed_policy(void)
+{
+	size_t i = 0;
+	struct ipe_parsed_policy *p = NULL;
+	struct ipe_op_table *t = NULL;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	p->global_default_action = IPE_ACTION_INVALID;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
+		t = &p->rules[i];
+
+		t->default_action = IPE_ACTION_INVALID;
+		INIT_LIST_HEAD(&t->rules);
+	}
+
+	return p;
+}
+
+/**
+ * remove_comment - Truncate all chars following START_COMMENT in a string.
+ *
+ * @line: Supplies a poilcy line string for preprocessing.
+ */
+static void remove_comment(char *line)
+{
+	line = strchr(line, START_COMMENT);
+
+	if (line)
+		*line = '\0';
+}
+
+/**
+ * remove_trailing_spaces - Truncate all trailing spaces in a string.
+ *
+ * @line: Supplies a poilcy line string for preprocessing.
+ *
+ * Return: The length of truncated string.
+ */
+static size_t remove_trailing_spaces(char *line)
+{
+	size_t i = 0;
+
+	for (i = strlen(line); i > 0 && (line[i - 1] == ' ' || line[i - 1] == '\t'); --i)
+		;
+
+	line[i] = '\0';
+
+	return i;
+}
+
+/**
+ * parse_version - Parse policy version.
+ * @ver: Supplies a version string to be parsed.
+ * @p: Supplies the partial parsed policy.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Standard errno
+ */
+static int parse_version(char *ver, struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	size_t sep_count = 0;
+	char *token;
+	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
+
+	while ((token = strsep(&ver, ".")) != NULL) {
+		/* prevent overflow */
+		if (sep_count >= ARRAY_SIZE(cv))
+			return -EBADMSG;
+
+		rc = kstrtou16(token, 10, cv[sep_count]);
+		if (rc)
+			return rc;
+
+		++sep_count;
+	}
+
+	/* prevent underflow */
+	if (sep_count != ARRAY_SIZE(cv))
+		rc = -EBADMSG;
+
+	return rc;
+}
+
+enum header_opt {
+	IPE_HEADER_POLICY_NAME = 0,
+	IPE_HEADER_POLICY_VERSION,
+	__IPE_HEADER_MAX
+};
+
+static const match_table_t header_tokens = {
+	{IPE_HEADER_POLICY_NAME,	"policy_name=%s"},
+	{IPE_HEADER_POLICY_VERSION,	"policy_version=%s"},
+	{__IPE_HEADER_MAX,		NULL}
+};
+
+/**
+ * parse_header - Parse policy header information.
+ * @line: Supplies header line to be parsed.
+ * @p: Supplies the partial parsed policy.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Standard errno
+ */
+static int parse_header(char *line, struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	char *t, *ver = NULL;
+	substring_t args[MAX_OPT_ARGS];
+	size_t idx = 0;
+
+	while ((t = strsep(&line, IPE_POLICY_DELIM)) != NULL) {
+		int token;
+
+		if (*t == '\0')
+			continue;
+		if (idx >= __IPE_HEADER_MAX) {
+			rc = -EBADMSG;
+			goto out;
+		}
+
+		token = match_token(t, header_tokens, args);
+		if (token != idx) {
+			rc = -EBADMSG;
+			goto out;
+		}
+
+		switch (token) {
+		case IPE_HEADER_POLICY_NAME:
+			p->name = match_strdup(&args[0]);
+			if (!p->name)
+				rc = -ENOMEM;
+			break;
+		case IPE_HEADER_POLICY_VERSION:
+			ver = match_strdup(&args[0]);
+			if (!ver) {
+				rc = -ENOMEM;
+				break;
+			}
+			rc = parse_version(ver, p);
+			break;
+		default:
+			rc = -EBADMSG;
+		}
+		if (rc)
+			goto out;
+		++idx;
+	}
+
+	if (idx != __IPE_HEADER_MAX) {
+		rc = -EBADMSG;
+		goto out;
+	}
+
+out:
+	kfree(ver);
+	return rc;
+}
+
+/**
+ * token_default - Determine if the given token is "DEFAULT".
+ * @token: Supplies the token string to be compared.
+ *
+ * Return:
+ * * 0	- The token is not "DEFAULT"
+ * * !0	- The token is "DEFAULT"
+ */
+static bool token_default(char *token)
+{
+	return !strcmp(token, "DEFAULT");
+}
+
+/**
+ * free_rule - Free the supplied ipe_rule struct.
+ * @r: Supplies the ipe_rule struct to be freed.
+ *
+ * Free a ipe_rule struct @r. Note @r must be removed from any lists before
+ * calling this function.
+ */
+static void free_rule(struct ipe_rule *r)
+{
+	struct ipe_prop *p, *t;
+
+	if (IS_ERR_OR_NULL(r))
+		return;
+
+	list_for_each_entry_safe(p, t, &r->props, next) {
+		list_del(&p->next);
+		kfree(p);
+	}
+
+	kfree(r);
+}
+
+static const match_table_t operation_tokens = {
+	{IPE_OP_EXEC,			"op=EXECUTE"},
+	{IPE_OP_FIRMWARE,		"op=FIRMWARE"},
+	{IPE_OP_KERNEL_MODULE,	"op=KMODULE"},
+	{IPE_OP_KEXEC_IMAGE,		"op=KEXEC_IMAGE"},
+	{IPE_OP_KEXEC_INITRAMFS,	"op=KEXEC_INITRAMFS"},
+	{IPE_OP_IMA_POLICY,		"op=IMA_POLICY"},
+	{IPE_OP_IMA_X509,		"op=IMA_X509_CERT"},
+	{IPE_OP_INVALID,		NULL}
+};
+
+/**
+ * parse_operation - Parse the operation type given a token string.
+ * @t: Supplies the token string to be parsed.
+ *
+ * Return: The parsed operation type.
+ */
+static enum ipe_op_type parse_operation(char *t)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	return match_token(t, operation_tokens, args);
+}
+
+static const match_table_t action_tokens = {
+	{IPE_ACTION_ALLOW,	"action=ALLOW"},
+	{IPE_ACTION_DENY,	"action=DENY"},
+	{IPE_ACTION_INVALID,	NULL}
+};
+
+/**
+ * parse_action - Parse the action type given a token string.
+ * @t: Supplies the token string to be parsed.
+ *
+ * Return: The parsed action type.
+ */
+static enum ipe_action_type parse_action(char *t)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	return match_token(t, action_tokens, args);
+}
+
+/**
+ * parse_property - Parse the property type given a token string.
+ * @t: Supplies the token string to be parsed.
+ * @r: Supplies the ipe_rule the parsed property will be associated with.
+ *
+ * Return:
+ * * !IS_ERR	- OK
+ * * -ENOMEM	- Out of memory
+ * * -EBADMSG	- The supplied token cannot be parsed
+ */
+static int parse_property(char *t, struct ipe_rule *r)
+{
+	return -EBADMSG;
+}
+
+/**
+ * parse_rule - parse a policy rule line.
+ * @line: Supplies rule line to be parsed.
+ * @p: Supplies the partial parsed policy.
+ *
+ * Return:
+ * * !IS_ERR	- OK
+ * * -ENOMEM	- Out of memory
+ * * -EBADMSG	- Policy syntax error
+ */
+static int parse_rule(char *line, struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	bool first_token = true, is_default_rule = false;
+	bool op_parsed = false;
+	enum ipe_op_type op = IPE_OP_INVALID;
+	enum ipe_action_type action = IPE_ACTION_INVALID;
+	struct ipe_rule *r = NULL;
+	char *t;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&r->next);
+	INIT_LIST_HEAD(&r->props);
+
+	while (t = strsep(&line, IPE_POLICY_DELIM), line) {
+		if (*t == '\0')
+			continue;
+		if (first_token && token_default(t)) {
+			is_default_rule = true;
+		} else {
+			if (!op_parsed) {
+				op = parse_operation(t);
+				if (op == IPE_OP_INVALID)
+					rc = -EBADMSG;
+				else
+					op_parsed = true;
+			} else {
+				rc = parse_property(t, r);
+			}
+		}
+
+		if (rc)
+			goto err;
+		first_token = false;
+	}
+
+	action = parse_action(t);
+	if (action == IPE_ACTION_INVALID) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	if (is_default_rule) {
+		if (!list_empty(&r->props)) {
+			rc = -EBADMSG;
+		} else if (op == IPE_OP_INVALID) {
+			if (p->global_default_action != IPE_ACTION_INVALID)
+				rc = -EBADMSG;
+			else
+				p->global_default_action = action;
+		} else {
+			if (p->rules[op].default_action != IPE_ACTION_INVALID)
+				rc = -EBADMSG;
+			else
+				p->rules[op].default_action = action;
+		}
+	} else if (op != IPE_OP_INVALID && action != IPE_ACTION_INVALID) {
+		r->op = op;
+		r->action = action;
+	} else {
+		rc = -EBADMSG;
+	}
+
+	if (rc)
+		goto err;
+	if (!is_default_rule)
+		list_add_tail(&r->next, &p->rules[op].rules);
+	else
+		free_rule(r);
+
+	return rc;
+err:
+	free_rule(r);
+	return rc;
+}
+
+/**
+ * free_parsed_policy - free a parsed policy structure.
+ * @p: Supplies the parsed policy.
+ */
+void free_parsed_policy(struct ipe_parsed_policy *p)
+{
+	size_t i = 0;
+	struct ipe_rule *pp, *t;
+
+	if (IS_ERR_OR_NULL(p))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
+		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next) {
+			list_del(&pp->next);
+			free_rule(pp);
+		}
+
+	kfree(p->name);
+	kfree(p);
+}
+
+/**
+ * validate_policy - validate a parsed policy.
+ * @p: Supplies the fully parsed policy.
+ *
+ * Given a policy structure that was just parsed, validate that all
+ * necessary fields are present, initialized correctly.
+ *
+ * A parsed policy can be in an invalid state for use (a default was
+ * undefined) by just parsing the policy.
+ *
+ * Return:
+ * * 0		- OK
+ * * -EBADMSG	- Policy is invalid
+ */
+static int validate_policy(const struct ipe_parsed_policy *p)
+{
+	size_t i = 0;
+
+	if (p->global_default_action != IPE_ACTION_INVALID)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
+		if (p->rules[i].default_action == IPE_ACTION_INVALID)
+			return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/**
+ * parse_policy - Given a string, parse the string into an IPE policy.
+ * @p: partially filled ipe_policy structure to populate with the result.
+ *     it must have text and textlen set.
+ *
+ * Return:
+ * * 0		- OK
+ * * -EBADMSG	- Policy is invalid
+ * * -ENOMEM	- Out of Memory
+ */
+int parse_policy(struct ipe_policy *p)
+{
+	int rc = 0;
+	size_t len;
+	char *policy = NULL, *dup = NULL;
+	char *line = NULL;
+	bool header_parsed = false;
+	struct ipe_parsed_policy *pp = NULL;
+
+	if (!p->textlen)
+		return -EBADMSG;
+
+	policy = kmemdup_nul(p->text, p->textlen, GFP_KERNEL);
+	if (!policy)
+		return -ENOMEM;
+	dup = policy;
+
+	pp = new_parsed_policy();
+	if (IS_ERR(pp)) {
+		rc = PTR_ERR(pp);
+		goto out;
+	}
+
+	while ((line = strsep(&policy, IPE_LINE_DELIM)) != NULL) {
+		remove_comment(line);
+		len = remove_trailing_spaces(line);
+		if (!len)
+			continue;
+
+		if (!header_parsed) {
+			rc = parse_header(line, pp);
+			if (rc)
+				goto err;
+			header_parsed = true;
+		} else {
+			rc = parse_rule(line, pp);
+			if (rc)
+				goto err;
+		}
+	}
+
+	if (!header_parsed || validate_policy(pp)) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	p->parsed = pp;
+
+out:
+	kfree(dup);
+	return rc;
+err:
+	free_parsed_policy(pp);
+	goto out;
+}
diff --git a/security/ipe/policy_parser.h b/security/ipe/policy_parser.h
new file mode 100644
index 000000000000..2b744103d06a
--- /dev/null
+++ b/security/ipe/policy_parser.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef _IPE_POLICY_PARSER_H
+#define _IPE_POLICY_PARSER_H
+
+int parse_policy(struct ipe_policy *p);
+void free_parsed_policy(struct ipe_parsed_policy *p);
+
+#endif /* _IPE_POLICY_PARSER_H */
-- 
2.25.1

