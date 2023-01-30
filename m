Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B2F681EC1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Jan 2023 23:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjA3W7N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Jan 2023 17:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjA3W6p (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Jan 2023 17:58:45 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74C3A1E9F7;
        Mon, 30 Jan 2023 14:58:42 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 1685920EA1E6; Mon, 30 Jan 2023 14:58:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1685920EA1E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675119522;
        bh=oBH6B/7tvfVHuvCYy6kWpso1VakQP0OiUtr5HYsOjkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ist+8lG+cgW2nhL8x+uKJHzbKXnINu/qPx7Ne6sG38uD/2uRp7JzUdM8ZihJyXlyO
         mYHEeG9YCS8OyLcQ7XFw6fgbAiA1SaKG4acnGXyAzm4pdZ4hbxEOkMMuI7q4gwj1dI
         GjYdiTbQYdWGKz4HujYpLUSbc5pfM0I6UvrZth5w=
From:   Fan Wu <wufan@linux.microsoft.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v9 03/16] ipe: add evaluation loop and introduce 'boot_verified' as a trust provider
Date:   Mon, 30 Jan 2023 14:57:18 -0800
Message-Id: <1675119451-23180-4-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE must have a centralized function to evaluate incoming callers
against IPE's policy. This iteration of the policy against the rules
for that specific caller is known as the evaluation loop.

In addition, IPE is designed to provide system level trust guarantees,
this usually implies that trust starts from bootup with a hardware root
of trust, which validates the bootloader. After this, the bootloader
verifies the kernel and the initramfs.

As there's no currently supported integrity method for initramfs, and
it's typically already verified by the bootloader, introduce a property
that causes the first superblock to have an execution to be "pinned",
which is typically initramfs.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  + Split evaluation loop, access control hooks,
    and evaluation loop from policy parser and userspace
    interface to pass mailing list character limit

v3:
  + Move ipe_load_properties to patch 04.
  + Remove useless 0-initializations
  + Prefix extern variables with ipe_
  + Remove kernel module parameters, as these are
    exposed through sysctls.
  + Add more prose to the IPE base config option
    help text.
  + Use GFP_KERNEL for audit_log_start.
  + Remove unnecessary caching system.
  + Remove comments from headers
  + Use rcu_access_pointer for rcu-pointer null check
  + Remove usage of reqprot; use prot only.
  + Move policy load and activation audit event to 03/12

v4:
  + Remove sysctls in favor of securityfs nodes
  + Re-add kernel module parameters, as these are now
    exposed through securityfs.
  + Refactor property audit loop to a separate function.

v5:
  + fix minor grammatical errors
  + do not group rule by curly-brace in audit record,
    reconstruct the exact rule.

v6:
  + No changes

v7:
  + Further split lsm creation into a separate commit from the
    evaluation loop and audit system, for easier review.

  + Propogating changes to support the new ipe_context structure in the
    evaluation loop.

v8:
  + Remove ipe_hook enumeration; hooks can be correlated via syscall
    record.

v9:
  + Remove ipe_context related code and simplify the evaluation loop.
  + Merge the evaluation loop commit with the boot_verified commit.
---
 security/ipe/Makefile        |   1 +
 security/ipe/eval.c          | 180 +++++++++++++++++++++++++++++++++++
 security/ipe/eval.h          |  28 ++++++
 security/ipe/hooks.c         |  25 +++++
 security/ipe/hooks.h         |  14 +++
 security/ipe/ipe.c           |   1 +
 security/ipe/policy.c        |  20 ++++
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |   8 +-
 9 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 security/ipe/eval.c
 create mode 100644 security/ipe/eval.h
 create mode 100644 security/ipe/hooks.c
 create mode 100644 security/ipe/hooks.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 16bbe80991f1..d7f2870d7c09 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	eval.o \
 	hooks.o \
 	ipe.o \
 	policy.o \
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
new file mode 100644
index 000000000000..48b5104a3463
--- /dev/null
+++ b/security/ipe/eval.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "eval.h"
+#include "hooks.h"
+#include "policy.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+#include <linux/spinlock.h>
+
+struct ipe_policy __rcu *ipe_active_policy;
+
+static struct super_block *pinned_sb;
+static DEFINE_SPINLOCK(pin_lock);
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+/**
+ * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
+ * @f: Supplies a file structure to source the super_block from.
+ */
+static void pin_sb(const struct file *f)
+{
+	if (!f)
+		return;
+	spin_lock(&pin_lock);
+	if (pinned_sb)
+		goto out;
+	pinned_sb = FILE_SUPERBLOCK(f);
+out:
+	spin_unlock(&pin_lock);
+}
+
+/**
+ * from_pinned - Determine whether @f is source from the pinned super_block.
+ * @f: Supplies a file structure to check against the pinned super_block.
+ *
+ * Return:
+ * * true	- @f is sourced from the pinned super_block
+ * * false	- @f is not sourced from the pinned super_block
+ */
+static bool from_pinned(const struct file *f)
+{
+	bool rv;
+
+	if (!f)
+		return false;
+	spin_lock(&pin_lock);
+	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == FILE_SUPERBLOCK(f);
+	spin_unlock(&pin_lock);
+	return rv;
+}
+
+/**
+ * build_eval_ctx - Build an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
+ * @file: Supplies a pointer to the file to associated with the evaluation.
+ * @op: Supplies the IPE policy operation associated with the evaluation.
+ */
+void build_eval_ctx(struct ipe_eval_ctx *ctx,
+		    const struct file *file,
+		    enum ipe_op_type op)
+{
+	ctx->file = file;
+	ctx->op = op;
+	ctx->from_init_sb = from_pinned(file);
+}
+
+/**
+ * evaluate_property - Analyze @ctx against a property.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ * @p: Supplies a pointer to the property to be evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
+			      struct ipe_prop *p)
+{
+	bool eval = false;
+
+	switch (p->type) {
+	case ipe_prop_boot_verified_false:
+		eval = !ctx->from_init_sb;
+		break;
+	case ipe_prop_boot_verified_true:
+		eval = ctx->from_init_sb;
+		break;
+	default:
+		eval = false;
+	}
+
+	return eval;
+}
+
+/**
+ * ipe_evaluate_event - Analyze @ctx against the current active policy.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ *
+ * This is the loop where all policy evaluation happens against IPE policy.
+ *
+ * Return:
+ * * 0		- OK
+ * * -EACCES	- @ctx did not pass evaluation.
+ * * !0		- Error
+ */
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
+{
+	int rc = 0;
+	bool match = false;
+	enum ipe_action_type action;
+	struct ipe_policy *pol = NULL;
+	const struct ipe_rule *rule = NULL;
+	const struct ipe_op_table *rules = NULL;
+	struct ipe_prop *prop = NULL;
+
+	if (ctx->op == ipe_op_exec)
+		pin_sb(ctx->file);
+
+	pol = ipe_get_policy_rcu(ipe_active_policy);
+	if (!pol)
+		goto out;
+
+	if (ctx->op == ipe_op_max) {
+		action = pol->parsed->global_default_action;
+		goto eval;
+	}
+
+	rules = &pol->parsed->rules[ctx->op];
+
+	list_for_each_entry(rule, &rules->rules, next) {
+		match = true;
+
+		list_for_each_entry(prop, &rule->props, next)
+			match = match && evaluate_property(ctx, prop);
+
+		if (match)
+			break;
+	}
+
+	if (match)
+		action = rule->action;
+	else if (rules->default_action != ipe_action_max)
+		action = rules->default_action;
+	else
+		action = pol->parsed->global_default_action;
+
+eval:
+	if (action == ipe_action_deny)
+		rc = -EACCES;
+
+out:
+	return rc;
+}
+
+/**
+ * ipe_invalidate_pinned_sb - invalidte the ipe pinned super_block.
+ * @mnt_sb: super_block to check against the pinned super_block.
+ *
+ * This function is called a super_block like the initramfs's is freed,
+ * if the super_block is currently pinned by ipe it will be invalided,
+ * so ipe won't consider the block device is boot verified afterward.
+ */
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
+{
+	spin_lock(&pin_lock);
+
+	if (!IS_ERR_OR_NULL(pinned_sb) && mnt_sb == pinned_sb)
+		pinned_sb = ERR_PTR(-EIO);
+
+	spin_unlock(&pin_lock);
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
new file mode 100644
index 000000000000..887797438b9b
--- /dev/null
+++ b/security/ipe/eval.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_EVAL_H
+#define IPE_EVAL_H
+
+#include <linux/file.h>
+#include <linux/types.h>
+
+#include "hooks.h"
+#include "policy.h"
+
+extern struct ipe_policy __rcu *ipe_active_policy;
+
+struct ipe_eval_ctx {
+	enum ipe_op_type op;
+
+	const struct file *file;
+	bool from_init_sb;
+};
+
+void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
+
+#endif /* IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
new file mode 100644
index 000000000000..335b773c7ae1
--- /dev/null
+++ b/security/ipe/hooks.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "hooks.h"
+#include "eval.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/binfmts.h>
+#include <linux/mman.h>
+
+/**
+ * ipe_sb_free_security - ipe security hook function for super_block.
+ * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
+ *
+ * IPE does not have any structures with mnt_sb, but uses this hook to
+ * invalidate a pinned super_block.
+ */
+void ipe_sb_free_security(struct super_block *mnt_sb)
+{
+	ipe_invalidate_pinned_sb(mnt_sb);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
new file mode 100644
index 000000000000..30fe455389bf
--- /dev/null
+++ b/security/ipe/hooks.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_HOOKS_H
+#define IPE_HOOKS_H
+
+#include <linux/fs.h>
+#include <linux/binfmts.h>
+#include <linux/security.h>
+
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
+#endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 9ed3bf4dcc04..551c6d90ac11 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -9,6 +9,7 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 };
 
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index e446f4b84152..772d876b1087 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -97,3 +97,23 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 err:
 	return ERR_PTR(rc);
 }
+
+/**
+ * ipe_get_policy_rcu - Dereference a rcu-protected policy pointer.
+ *
+ * @p: rcu-protected pointer to a policy.
+ *
+ * Not safe to call on IS_ERR.
+ *
+ * Return: the value of @p
+ */
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
+{
+	struct ipe_policy *rv = NULL;
+
+	rcu_read_lock();
+	rv = rcu_dereference(p);
+	rcu_read_unlock();
+
+	return rv;
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 6af2d9a811ec..967d816cd5cd 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -26,6 +26,8 @@ enum ipe_action_type {
 };
 
 enum ipe_prop_type {
+	ipe_prop_boot_verified_false,
+	ipe_prop_boot_verified_true,
 	ipe_prop_max
 };
 
@@ -73,5 +75,6 @@ struct ipe_policy {
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
 void ipe_free_policy(struct ipe_policy *pol);
+struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
 
 #endif /* IPE_POLICY_H */
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index c7ba0e865366..7efafc482e46 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -265,7 +265,9 @@ static enum ipe_action_type parse_action(char *t)
 }
 
 static const match_table_t property_tokens = {
-	{ipe_prop_max,					NULL}
+	{ipe_prop_boot_verified_false,	"boot_verified=FALSE"},
+	{ipe_prop_boot_verified_true,	"boot_verified=TRUE"},
+	{ipe_prop_max,			NULL}
 };
 
 /**
@@ -295,6 +297,10 @@ int parse_property(char *t, struct ipe_rule *r)
 	token = match_token(t, property_tokens, args);
 
 	switch (token) {
+	case ipe_prop_boot_verified_false:
+	case ipe_prop_boot_verified_true:
+		p->type = token;
+		break;
 	case ipe_prop_max:
 	default:
 		rc = -EBADMSG;
-- 
2.39.0

