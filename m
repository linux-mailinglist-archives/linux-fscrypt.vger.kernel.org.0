Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4342C991
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbhJMTJO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:14 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49068 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id EA73820B9D02;
        Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EA73820B9D02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=BM3rJKCXfcZEtw4PeOjJxoZpUH7vJt73PAtSiLZhUuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv+mPR5aOVAYjSI44vi9DBuLOdhl2uhmmaK9owh03SA0/8v9X2dk3cot23rCj33os
         Zj960padefav7toxPPy6dvDqvnS/PKnA2WzXKfBiyOX01uz9UfiDgLrB2akiNvd1FV
         mTmrPW7PUr5hMxWUe5BkEgWPNd4XUlsxoIZkIyQI=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 07/16] ipe: add auditing support
Date:   Wed, 13 Oct 2021 12:06:26 -0700
Message-Id: <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Users of IPE require a way to identify when and why an operation fails,
allowing them to both respond to violations of policy and be notified
of potentially malicious actions on their systens with respect to IPE
itself.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Split up patch 02/12 into four parts:
      1. context creation [01/16]
      2. audit [07/16] (this patch)
      3. evaluation loop [03/16]
      4. access control hooks [05/16]

---
 security/ipe/Kconfig              |  52 ++++++
 security/ipe/Makefile             |   2 +
 security/ipe/audit.c              | 264 ++++++++++++++++++++++++++++++
 security/ipe/audit.h              |  36 ++++
 security/ipe/ctx.c                |  18 ++
 security/ipe/ctx.h                |   2 +
 security/ipe/eval.c               |   8 +
 security/ipe/eval.h               |   7 +
 security/ipe/fs.c                 |  79 +++++++++
 security/ipe/modules/ipe_module.h |   2 +
 10 files changed, 470 insertions(+)
 create mode 100644 security/ipe/audit.c
 create mode 100644 security/ipe/audit.h

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index c4503083e92d..ef556b66e674 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -17,3 +17,55 @@ menuconfig SECURITY_IPE
 	  requirements on the fly.
 
 	  If unsure, answer N.
+
+if SECURITY_IPE
+
+choice
+	prompt "Hash algorithm used in auditing policies"
+	default IPE_AUDIT_HASH_SHA1
+	depends on AUDIT
+	help
+		Specify the hash algorithm used when auditing policies.
+		The hash is used to uniquely identify a policy from other
+		policies on the system.
+
+		If unsure, leave default.
+
+	config IPE_AUDIT_HASH_SHA1
+		bool "sha1"
+		depends on CRYPTO_SHA1
+		help
+			Use the SHA128 algorithm to hash policies
+			in the audit records.
+
+	config IPE_AUDIT_HASH_SHA256
+		bool "sha256"
+		depends on CRYPTO_SHA256
+		help
+			Use the SHA256 algorithm to hash policies
+			in the audit records.
+
+	config IPE_AUDIT_HASH_SHA384
+		bool "sha384"
+		depends on CRYPTO_SHA512
+		help
+			Use the SHA384 algorithm to hash policies
+			in the audit records
+
+	config IPE_AUDIT_HASH_SHA512
+		bool "sha512"
+		depends on CRYPTO_SHA512
+		help
+			Use the SHA512 algorithm to hash policies
+			in the audit records
+endchoice
+
+config IPE_AUDIT_HASH_ALG
+	string
+	depends on AUDIT
+	default "sha1" if IPE_AUDIT_HASH_SHA1
+	default "sha256" if IPE_AUDIT_HASH_SHA256
+	default "sha384" if IPE_AUDIT_HASH_SHA384
+	default "sha512" if IPE_AUDIT_HASH_SHA512
+
+endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index d5660a17364c..6d9ac818e8c6 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -18,3 +18,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	parsers.o \
 	policy.o \
 	policyfs.o \
+
+obj-$(CONFIG_AUDIT) += audit.o
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
new file mode 100644
index 000000000000..5f6c0a52b0cb
--- /dev/null
+++ b/security/ipe/audit.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "eval.h"
+#include "hooks.h"
+#include "policy.h"
+#include "audit.h"
+#include "modules/ipe_module.h"
+
+#include <linux/slab.h>
+#include <linux/audit.h>
+#include <linux/types.h>
+#include <crypto/hash.h>
+
+#define NULLSTR(x) ((x) == NULL ? "NULL" : "!NULL")
+#define ACTSTR(x) ((x) == ipe_action_allow ? "ALLOW" : "DENY")
+
+#define POLICY_LOAD_FMT "IPE policy_name=%s policy_version=%hu.%hu.%hu "\
+			CONFIG_IPE_AUDIT_HASH_ALG "="
+
+static const char *const audit_hook_names[ipe_hook_max] = {
+	"EXECVE",
+	"MMAP",
+	"MPROTECT",
+	"KERNEL_READ",
+	"KERNEL_LOAD",
+};
+
+static const char *const audit_op_names[ipe_operation_max] = {
+	"EXECUTE",
+	"FIRMWARE",
+	"KMODULE",
+	"KEXEC_IMAGE",
+	"KEXEC_INITRAMFS",
+	"IMA_X509_CERT",
+	"IMA_POLICY",
+};
+
+/**
+ * audit_pathname: retrieve the absoute path to a file being evaluated.
+ * @f: File to retrieve the absolute path for.
+ *
+ * This function walks past symlinks and mounts.
+ *
+ * Return:
+ * !IS_ERR - OK
+ */
+static char *audit_pathname(const struct file *f)
+{
+	int rc = 0;
+	char *pos = NULL;
+	char *pathbuf = NULL;
+	char *temp_path = NULL;
+
+	if (IS_ERR_OR_NULL(f))
+		return ERR_PTR(-ENOENT);
+
+	pathbuf = __getname();
+	if (!pathbuf)
+		return ERR_PTR(-ENOMEM);
+
+	pos = d_absolute_path(&f->f_path, pathbuf, PATH_MAX);
+	if (IS_ERR(pos)) {
+		rc = PTR_ERR(pos);
+		goto err;
+	}
+
+	temp_path = __getname();
+	if (!temp_path) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	strscpy(temp_path, pos, PATH_MAX);
+	__putname(pathbuf);
+
+	return temp_path;
+err:
+	__putname(pathbuf);
+	return ERR_PTR(rc);
+}
+
+/**
+ * audit_eval_ctx: audit an evaluation context structure.
+ * @ab: Supplies a poniter to the audit_buffer to append to.
+ * @ctx: Supplies a pointer to the evaluation context to audit
+ * @enforce: Supplies a boolean representing the enforcement state
+ */
+static void audit_eval_ctx(struct audit_buffer *ab,
+			   const struct ipe_eval_ctx *const ctx, bool enforce)
+{
+	char *abspath = NULL;
+
+	audit_log_format(ab, "ctx_pid=%d ", task_tgid_nr(current));
+	audit_log_format(ab, "ctx_op=%s ", audit_op_names[ctx->op]);
+	audit_log_format(ab, "ctx_hook=%s ", audit_hook_names[ctx->hook]);
+	audit_log_format(ab, "ctx_ns_enforce=%d ", enforce);
+	audit_log_format(ab, "ctx_comm=");
+	audit_log_n_untrustedstring(ab, current->comm, ARRAY_SIZE(current->comm));
+	audit_log_format(ab, " ");
+
+	/* best effort */
+	if (ctx->file) {
+		abspath = audit_pathname(ctx->file);
+		if (!IS_ERR(abspath)) {
+			audit_log_format(ab, "ctx_pathname=");
+			audit_log_n_untrustedstring(ab, abspath, PATH_MAX);
+			__putname(abspath);
+		}
+
+		audit_log_format(ab, " ctx_ino=%ld ctx_dev=%s",
+				 ctx->file->f_inode->i_ino,
+				 ctx->file->f_inode->i_sb->s_id);
+	}
+}
+
+/**
+ * audit_rule: audit an IPE policy rule approximation.
+ * @ab: Supplies a poniter to the audit_buffer to append to.
+ * @r: Supplies a pointer to the ipe_rule to approximate a string form for.
+ *
+ * This is an approximation because aliases like "KERNEL_READ" will be
+ * emitted in their expanded form.
+ */
+static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
+{
+	const struct ipe_policy_mod *ptr;
+
+	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
+
+	list_for_each_entry(ptr, &r->modules, next) {
+		audit_log_format(ab, "%s=", ptr->mod->name);
+
+		ptr->mod->audit(ab, ptr->mod_value);
+
+		audit_log_format(ab, " ");
+	}
+
+	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
+}
+
+/**
+ * ipe_audit_match: audit a match for IPE policy.
+ * @ctx: Supplies a poniter to the evaluation context that was used in the
+ *	 evaluation.
+ * @match_type: Supplies the scope of the match: rule, operation default,
+ *		global default.
+ * @act: Supplies the IPE's evaluation decision, deny or allow.
+ * @r: Supplies a pointer to the rule that was matched, if possible.
+ * @enforce: Supplies the enforcement/permissive state at the point
+ *	     the enforcement decision was made.
+ */
+void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+		     enum ipe_match match_type,
+		     enum ipe_action act, const struct ipe_rule *const r,
+		     bool enforce)
+{
+	struct audit_buffer *ab;
+	bool success_audit;
+
+	rcu_read_lock();
+	success_audit = READ_ONCE(ctx->ci_ctx->success_audit);
+	rcu_read_unlock();
+
+	if (act != ipe_action_deny && !success_audit)
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_TRUST_RESULT);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "IPE ");
+	audit_eval_ctx(ab, ctx, enforce);
+	audit_log_format(ab, " ");
+
+	if (match_type == ipe_match_rule)
+		audit_rule(ab, r);
+	else if (match_type == ipe_match_table)
+		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"",
+				 audit_op_names[ctx->op], ACTSTR(act));
+	else
+		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
+				 ACTSTR(act));
+
+	audit_log_end(ab);
+}
+
+/**
+ * audit_policy: Audit a policy's name, version and thumprint to @ab
+ * @ab: Supplies a pointer to the audit buffer to append to.
+ * @p: Supplies a pointer to the policy to audit
+ */
+static void audit_policy(struct audit_buffer *ab,
+			 const struct ipe_policy *const p)
+{
+	u8 *digest = NULL;
+	struct crypto_shash *tfm;
+	SHASH_DESC_ON_STACK(desc, tfm);
+
+	tfm = crypto_alloc_shash(CONFIG_IPE_AUDIT_HASH_ALG, 0, 0);
+	if (IS_ERR(tfm))
+		return;
+
+	desc->tfm = tfm;
+
+	digest = kzalloc(crypto_shash_digestsize(tfm), GFP_KERNEL);
+	if (!digest)
+		goto out;
+
+	if (crypto_shash_init(desc))
+		goto out;
+
+	if (crypto_shash_update(desc, p->pkcs7, p->pkcs7len))
+		goto out;
+
+	if (crypto_shash_final(desc, digest))
+		goto out;
+
+	audit_log_format(ab, POLICY_LOAD_FMT, p->parsed->name,
+			 p->parsed->version.major, p->parsed->version.minor,
+			 p->parsed->version.rev);
+	audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
+
+out:
+	kfree(digest);
+	crypto_free_shash(tfm);
+}
+
+/**
+ * ipe_audit_policy_activation: Audit a policy being made the active policy.
+ * @p: Supplies a pointer to the policy to audit
+ */
+void ipe_audit_policy_activation(const struct ipe_policy *const p)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_TRUST_POLICY_ACTIVATE);
+	if (!ab)
+		return;
+
+	audit_policy(ab, p);
+
+	audit_log_end(ab);
+}
+
+/**
+ * ipe_audit_policy_load: Audit a policy being loaded into the kernel.
+ * @p: Supplies a pointer to the policy to audit
+ */
+void ipe_audit_policy_load(const struct ipe_policy *const p)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_TRUST_POLICY_LOAD);
+	if (!ab)
+		return;
+
+	audit_policy(ab, p);
+
+	audit_log_end(ab);
+}
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
new file mode 100644
index 000000000000..6b6880f6e8e7
--- /dev/null
+++ b/security/ipe/audit.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_AUDIT_H
+#define IPE_AUDIT_H
+
+#include "ipe.h"
+#include "eval.h"
+
+#ifdef CONFIG_AUDIT
+void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+		     enum ipe_match match_type,
+		     enum ipe_action act, const struct ipe_rule *const r,
+		     bool enforce);
+void ipe_audit_policy_load(const struct ipe_policy *const p);
+void ipe_audit_policy_activation(const struct ipe_policy *const p);
+#else
+static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+				   enum ipe_match match_type,
+				   enum ipe_action act, const struct ipe_rule *const r,
+				   bool enforce)
+{
+}
+
+static inline void ipe_audit_policy_load(const struct ipe_policy *const p)
+{
+}
+
+static inline void ipe_audit_policy_activation(const struct ipe_policy *const p)
+{
+}
+#endif /* CONFIG_AUDIT */
+
+#endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 664c671a4f9c..77475aedbfe9 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -6,12 +6,16 @@
 #include "ipe.h"
 #include "ctx.h"
 #include "policy.h"
+#include "audit.h"
 
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/parser.h>
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
+#include <linux/moduleparam.h>
+
+static bool success_audit;
 
 /**
  * ver_to_u64: convert an internal ipe_policy_version to a u64
@@ -265,6 +269,7 @@ int ipe_set_active_pol(const struct ipe_policy *p)
 	spin_unlock(&ctx->lock);
 	synchronize_rcu();
 
+	ipe_audit_policy_activation(p);
 out:
 	ipe_put_policy(ap);
 	ipe_put_ctx(ctx);
@@ -330,6 +335,10 @@ int __init ipe_init_ctx(void)
 		goto err;
 	}
 
+	spin_lock(&lns->lock);
+	WRITE_ONCE(lns->success_audit, success_audit);
+	spin_unlock(&lns->lock);
+
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
 
 	return 0;
@@ -337,3 +346,12 @@ int __init ipe_init_ctx(void)
 	ipe_put_ctx(lns);
 	return rc;
 }
+
+/* Set the right module name */
+#ifdef KBUILD_MODNAME
+#undef KBUILD_MODNAME
+#define KBUILD_MODNAME "ipe"
+#endif
+
+module_param(success_audit, bool, 0400);
+MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
index fe11fb767788..31aea2fb9e49 100644
--- a/security/ipe/ctx.h
+++ b/security/ipe/ctx.h
@@ -15,6 +15,8 @@
 struct ipe_context {
 	struct ipe_policy __rcu *active_policy;
 
+	bool __rcu success_audit;
+
 	refcount_t refcount;
 	/* Protects concurrent writers */
 	spinlock_t lock;
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index b732f76cfd05..dcb62179e4bf 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -9,6 +9,7 @@
 #include "hooks.h"
 #include "policy.h"
 #include "modules/ipe_module.h"
+#include "audit.h"
 
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -73,7 +74,9 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 {
 	int rc = 0;
 	bool match = false;
+	bool enforcing = true;
 	enum ipe_action action;
+	enum ipe_match match_type;
 	struct ipe_policy *pol = NULL;
 	const struct ipe_rule *rule = NULL;
 	const struct ipe_policy_mod *module = NULL;
@@ -97,12 +100,17 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 
 	if (match) {
 		action = rule->action;
+		match_type = ipe_match_rule;
 	} else if (rules->default_action != ipe_action_max) {
 		action = rules->default_action;
+		match_type = ipe_match_table;
 	} else {
 		action = pol->parsed->global_default;
+		match_type = ipe_match_global;
 	}
 
+	ipe_audit_match(ctx, match_type, action, rule, enforcing);
+
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index db6da2998a20..8c08eed5af2b 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -20,6 +20,13 @@ struct ipe_eval_ctx {
 	struct ipe_context *ci_ctx;
 };
 
+enum ipe_match {
+	ipe_match_rule = 0,
+	ipe_match_table,
+	ipe_match_global,
+	ipe_match_max
+};
+
 int ipe_process_event(const struct file *file, enum ipe_operation op,
 		      enum ipe_hook hook);
 
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 10ad23f8bf92..c202c0753755 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -5,6 +5,7 @@
 #include "ipe.h"
 #include "fs.h"
 #include "policy.h"
+#include "audit.h"
 
 #include <linux/dcache.h>
 #include <linux/security.h>
@@ -12,6 +13,70 @@
 static struct dentry *np __ro_after_init;
 static struct dentry *root __ro_after_init;
 static struct dentry *config __ro_after_init;
+static struct dentry *success_audit __ro_after_init;
+
+/**
+ * setaudit: Write handler for the securityfs node, "ipe/success_audit"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t setaudit(struct file *f, const char __user *data,
+			size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value;
+	struct ipe_context *ctx;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	ctx = ipe_current_ctx();
+
+	spin_lock(&ctx->lock);
+	WRITE_ONCE(ctx->success_audit, value);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	ipe_put_ctx(ctx);
+	return len;
+}
+
+/**
+ * getaudit: Read handler for the securityfs node, "ipe/success_audit"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t getaudit(struct file *f, char __user *data,
+			size_t len, loff_t *offset)
+{
+	const char *result;
+	struct ipe_context *ctx;
+
+	ctx = ipe_current_ctx();
+
+	rcu_read_lock();
+	result = ((READ_ONCE(ctx->success_audit)) ? "1" : "0");
+	rcu_read_unlock();
+
+	ipe_put_ctx(ctx);
+	return simple_read_from_buffer(data, len, offset, result, 2);
+}
 
 /**
  * new_policy: Write handler for the securityfs node, "ipe/new_policy"
@@ -54,6 +119,7 @@ static ssize_t new_policy(struct file *f, const char __user *data,
 		goto err;
 
 	ipe_add_policy(ctx, p);
+	ipe_audit_policy_load(p);
 err:
 	ipe_put_policy(p);
 	ipe_put_ctx(ctx);
@@ -119,6 +185,11 @@ static const struct file_operations np_fops = {
 	.write = new_policy,
 };
 
+static const struct file_operations audit_fops = {
+	.write = setaudit,
+	.read = getaudit,
+};
+
 /**
  * ipe_init_securityfs: Initialize IPE's securityfs tree at fsinit
  *
@@ -152,6 +223,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	success_audit = securityfs_create_file("success_audit", 0600, root,
+					       NULL, &audit_fops);
+	if (IS_ERR(success_audit)) {
+		rc = PTR_ERR(success_audit);
+		goto err;
+	}
+
 	ctx->policy_root = securityfs_create_dir("policies", root);
 	if (IS_ERR(ctx->policy_root)) {
 		rc = PTR_ERR(ctx->policy_root);
@@ -163,6 +241,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
 }
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index b4f975e9218a..6855815d72da 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -6,6 +6,7 @@
 #define IPE_MODULE_H
 
 #include <linux/types.h>
+#include <linux/audit.h>
 #include "../eval.h"
 
 /**
@@ -26,6 +27,7 @@ struct ipe_module {
 	int (*free)(void **value);			/* optional */
 	bool (*eval)(const struct ipe_eval_ctx *ctx,	/* required */
 		     const void *val);
+	void (*audit)(struct audit_buffer *ab, const void *val); /* required */
 };
 
 #define IPE_MODULE(parser)				\
-- 
2.33.0

