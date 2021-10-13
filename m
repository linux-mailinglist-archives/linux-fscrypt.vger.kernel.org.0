Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0024C42C95A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhJMTIq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:08:46 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48888 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236703AbhJMTIn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:43 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id A513820B9CFF;
        Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A513820B9CFF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634151999;
        bh=umwm8Kpg6kU2t3Jjy02gwlm/Zk0Xi63fhE6PV4jIuZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jICy86BrsvrLryholTlSWkcpak5dbYjg1b0NeCzBoaF0aoCLMpsXV6x62m1Shds04
         4877sw4BXCU+CdxrAzLmrw5wf+nUMEb4o+kKfnhvq/YkWDqSPsWXpnJUF0hyWLDLjv
         qSHidPugs10KuVolsIXOV8KxQIoQCNQ6tRDz3iyw=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 04/16] ipe: add userspace interface
Date:   Wed, 13 Oct 2021 12:06:23 -0700
Message-Id: <1634151995-16266-5-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

As is typical with LSMs, IPE uses securityfs as its interface with
userspace. for a complete list of the interfaces and the respective
inputs/outputs, please see the documentation under
admin-guide/LSM/ipe.rst

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Refactor series to:
      1. Support a context structure, enabling easier testing
  * Split up patch 03/12 into two parts:
      1. parser [02/16]
      2. userspace interface [04/16] (this patch)
  * Interface changes:
      1. "raw" was renamed to "pkcs7" and made read only
      2. "raw"'s write functionality (update a policy) moved to "update"
      3. introduced "version", "policy_name" nodes.
      4. "content" renamed to "policy"
      5. The boot policy can now be updated like any other policy.

---
 security/ipe/Makefile   |   2 +
 security/ipe/ctx.c      | 121 +++++++++
 security/ipe/ctx.h      |   6 +
 security/ipe/fs.c       | 170 +++++++++++++
 security/ipe/fs.h       |  13 +
 security/ipe/policy.c   |  41 ++++
 security/ipe/policy.h   |   4 +
 security/ipe/policyfs.c | 528 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 885 insertions(+)
 create mode 100644 security/ipe/fs.c
 create mode 100644 security/ipe/fs.h
 create mode 100644 security/ipe/policyfs.c

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 0db69f13e82a..d5660a17364c 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -10,9 +10,11 @@ ccflags-y := -I$(srctree)/security/ipe/modules
 obj-$(CONFIG_SECURITY_IPE) += \
 	ctx.o \
 	eval.o \
+	fs.o \
 	hooks.o \
 	ipe.o \
 	modules.o \
 	parsers/ \
 	parsers.o \
 	policy.o \
+	policyfs.o \
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 9274e51eff52..664c671a4f9c 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -13,6 +13,29 @@
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 
+/**
+ * ver_to_u64: convert an internal ipe_policy_version to a u64
+ * @p: Policy to extract the version from
+ *
+ * Bits (LSB is index 0):
+ *	[48,32] -> Major
+ *	[32,16] -> Minor
+ *	[16, 0] -> Revision
+ *
+ * Return:
+ * u64 version of the embedded version structure.
+ */
+static inline u64 ver_to_u64(const struct ipe_policy *const p)
+{
+	u64 r = 0;
+
+	r = (((u64)p->parsed->version.major) << 32)
+	  | (((u64)p->parsed->version.minor) << 16)
+	  | ((u64)(p->parsed->version.rev));
+
+	return r;
+}
+
 /**
  * ipe_current_ctx: Helper to retrieve the ipe_context for the current task.
  *
@@ -96,6 +119,7 @@ static void free_ctx_work(struct work_struct *const work)
 	list_for_each_entry(p, &ctx->policies, next)
 		ipe_put_policy(p);
 
+	securityfs_remove(ctx->policy_root);
 	kfree(ctx);
 }
 
@@ -160,6 +184,9 @@ void ipe_remove_policy(struct ipe_policy *p)
  * ipe_add_policy: Associate @p with @ctx
  * @ctx: Supplies a pointer to the ipe_context structure to associate @p with.
  * @p: Supplies a pointer to the ipe_policy structure to associate.
+ *
+ * This will increase @p's reference count by one.
+ *
  */
 void ipe_add_policy(struct ipe_context *ctx, struct ipe_policy *p)
 {
@@ -168,7 +195,101 @@ void ipe_add_policy(struct ipe_context *ctx, struct ipe_policy *p)
 	list_add_tail(&p->next, &ctx->policies);
 	refcount_inc(&p->refcount);
 	spin_unlock(&ctx->lock);
+}
+
+/**
+ * ipe_replace_policy: Replace @old with @new in the list of policies in @ctx
+ * @ctx: Supplies the context object to manipulate.
+ * @old: Supplies a pointer to the ipe_policy to replace with @new
+ * @new: Supplies a pointer to the ipe_policy structure to replace @old with
+ */
+int ipe_replace_policy(struct ipe_policy *old, struct ipe_policy *new)
+{
+	int rc = -EINVAL;
+	struct ipe_context *ctx;
+	struct ipe_policy *cursor;
+	struct ipe_policy *p = NULL;
+
+	ctx = ipe_get_ctx_rcu(old->ctx);
+	if (!ctx)
+		return -ENOENT;
+
+	spin_lock(&ctx->lock);
+	list_for_each_entry(cursor, &ctx->policies, next) {
+		if (!strcmp(old->parsed->name, cursor->parsed->name)) {
+			if (ipe_is_policy_active(old)) {
+				if (ver_to_u64(old) > ver_to_u64(new))
+					break;
+				rcu_assign_pointer(ctx->active_policy, new);
+			}
+			list_replace_init(&cursor->next, &new->next);
+			refcount_inc(&new->refcount);
+			rcu_assign_pointer(new->ctx, old->ctx);
+			p = cursor;
+			rc = 0;
+			break;
+		}
+	}
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	ipe_put_policy(p);
+	ipe_put_ctx(ctx);
+	return rc;
+}
+
+/**
+ * ipe_set_active_pol: Make @p the active policy.
+ * @p: Supplies a pointer to the policy to make active.
+ */
+int ipe_set_active_pol(const struct ipe_policy *p)
+{
+	int rc = 0;
+	struct ipe_policy *ap = NULL;
+	struct ipe_context *ctx = NULL;
+
+	ctx = ipe_get_ctx_rcu(p->ctx);
+	if (!ctx) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	ap = ipe_get_policy_rcu(ctx->active_policy);
+	if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	spin_lock(&ctx->lock);
+	rcu_assign_pointer(ctx->active_policy, p);
+	spin_unlock(&ctx->lock);
 	synchronize_rcu();
+
+out:
+	ipe_put_policy(ap);
+	ipe_put_ctx(ctx);
+	return rc;
+}
+
+/**
+ * ipe_is_policy_active: Determine wehther @p is the active policy
+ * @p: Supplies a pointer to the policy to check.
+ *
+ * Return:
+ * true - @p is the active policy of @ctx
+ * false - @p is not the active policy of @ctx
+ */
+bool ipe_is_policy_active(const struct ipe_policy *p)
+{
+	bool rv;
+	struct ipe_context *ctx;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(p->ctx);
+	rv = !IS_ERR_OR_NULL(ctx) && rcu_access_pointer(ctx->active_policy) == p;
+	rcu_read_unlock();
+
+	return rv;
 }
 
 /**
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
index a0da92da818c..fe11fb767788 100644
--- a/security/ipe/ctx.h
+++ b/security/ipe/ctx.h
@@ -7,6 +7,7 @@
 
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/dcache.h>
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
@@ -20,6 +21,8 @@ struct ipe_context {
 
 	struct list_head policies; /* type: ipe_policy */
 
+	struct dentry *policy_root;
+
 	struct work_struct free_work;
 };
 
@@ -30,5 +33,8 @@ struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx);
 void ipe_put_ctx(struct ipe_context *ctx);
 void ipe_add_policy(struct ipe_context *ctx, struct ipe_policy *p);
 void ipe_remove_policy(struct ipe_policy *p);
+int ipe_replace_policy(struct ipe_policy *old, struct ipe_policy *new);
+int ipe_set_active_pol(const struct ipe_policy *p);
+bool ipe_is_policy_active(const struct ipe_policy *p);
 
 #endif /* IPE_CONTEXT_H */
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
new file mode 100644
index 000000000000..10ad23f8bf92
--- /dev/null
+++ b/security/ipe/fs.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include "ipe.h"
+#include "fs.h"
+#include "policy.h"
+
+#include <linux/dcache.h>
+#include <linux/security.h>
+
+static struct dentry *np __ro_after_init;
+static struct dentry *root __ro_after_init;
+static struct dentry *config __ro_after_init;
+
+/**
+ * new_policy: Write handler for the securityfs node, "ipe/new_policy"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t new_policy(struct file *f, const char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	char *copy = NULL;
+	struct ipe_policy *p = NULL;
+	struct ipe_context *ctx = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	ctx = ipe_current_ctx();
+
+	copy = memdup_user_nul(data, len);
+	if (IS_ERR(copy)) {
+		rc = PTR_ERR(copy);
+		goto err;
+	}
+
+	p = ipe_new_policy(NULL, 0, copy, len);
+	if (IS_ERR(p)) {
+		rc = PTR_ERR(p);
+		goto err;
+	}
+
+	rc = ipe_new_policyfs_node(ctx, p);
+	if (rc)
+		goto err;
+
+	ipe_add_policy(ctx, p);
+err:
+	ipe_put_policy(p);
+	ipe_put_ctx(ctx);
+	return (rc < 0) ? rc : len;
+}
+
+/**
+ * get_config: Read handler for the securityfs node, "ipe/config"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t get_config(struct file *f, char __user *data, size_t len,
+			  loff_t *offset)
+{
+	int rc = 0;
+	char *buf = NULL;
+	size_t buflen = 0;
+	char tmp[30] = { 0 };
+	struct ipe_parser *p = NULL;
+	struct ipe_module *m = NULL;
+
+	for (p = __start_ipe_parsers; p < __end_ipe_parsers; ++p)
+		buflen += snprintf(NULL, 0, "%s=%d\n", p->first_token, p->version);
+	for (m = __start_ipe_modules; m < __end_ipe_modules; ++m)
+		buflen += snprintf(NULL, 0, "%s=%d\n", m->name, m->version);
+
+	++buflen;
+	buf = kzalloc(buflen, GFP_KERNEL);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	for (p = __start_ipe_parsers; p < __end_ipe_parsers; ++p) {
+		memset(tmp, 0x0, ARRAY_SIZE(tmp));
+		scnprintf(tmp, ARRAY_SIZE(tmp), "%s=%d\n", p->first_token, p->version);
+		strcat(buf, tmp);
+	}
+
+	for (m = __start_ipe_modules; m < __end_ipe_modules; ++m) {
+		memset(tmp, 0x0, ARRAY_SIZE(tmp));
+		scnprintf(tmp, ARRAY_SIZE(tmp), "%s=%d\n", m->name, m->version);
+		strcat(buf, tmp);
+	}
+
+	rc = simple_read_from_buffer(data, len, offset, buf, buflen);
+out:
+	kfree(buf);
+	return rc;
+}
+
+static const struct file_operations cfg_fops = {
+	.read = get_config,
+};
+
+static const struct file_operations np_fops = {
+	.write = new_policy,
+};
+
+/**
+ * ipe_init_securityfs: Initialize IPE's securityfs tree at fsinit
+ *
+ * Return:
+ * !0 - Error
+ * 0 - OK
+ */
+static int __init ipe_init_securityfs(void)
+{
+	int rc = 0;
+	struct ipe_context *ctx = NULL;
+
+	ctx = ipe_current_ctx();
+
+	root = securityfs_create_dir("ipe", NULL);
+	if (IS_ERR(root)) {
+		rc = PTR_ERR(root);
+		goto err;
+	}
+
+	np = securityfs_create_file("new_policy", 0200, root, NULL, &np_fops);
+	if (IS_ERR(np)) {
+		rc = PTR_ERR(np);
+		goto err;
+	}
+
+	config = securityfs_create_file("config", 0400, root, NULL,
+					&cfg_fops);
+	if (IS_ERR(config)) {
+		rc = PTR_ERR(config);
+		goto err;
+	}
+
+	ctx->policy_root = securityfs_create_dir("policies", root);
+	if (IS_ERR(ctx->policy_root)) {
+		rc = PTR_ERR(ctx->policy_root);
+		goto err;
+	}
+
+	return 0;
+err:
+	securityfs_remove(np);
+	securityfs_remove(root);
+	securityfs_remove(config);
+	securityfs_remove(ctx->policy_root);
+	return rc;
+}
+
+fs_initcall(ipe_init_securityfs);
diff --git a/security/ipe/fs.h b/security/ipe/fs.h
new file mode 100644
index 000000000000..4ab2f4e8c454
--- /dev/null
+++ b/security/ipe/fs.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_FS_H
+#define IPE_FS_H
+
+void ipe_soft_del_policyfs(struct ipe_policy *p);
+int ipe_new_policyfs_node(struct ipe_context *ctx, struct ipe_policy *p);
+void ipe_del_policyfs_node(struct ipe_policy *p);
+
+#endif /* IPE_FS_H */
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index 8970f96453d6..b766824cc08f 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -4,6 +4,7 @@
  */
 
 #include "ipe.h"
+#include "fs.h"
 #include "policy.h"
 #include "ipe_parser.h"
 #include "modules.h"
@@ -867,6 +868,8 @@ void ipe_put_policy(struct ipe_policy *p)
 	if (IS_ERR_OR_NULL(p) || !refcount_dec_and_test(&p->refcount))
 		return;
 
+	ipe_del_policyfs_node(p);
+	securityfs_remove(p->policyfs);
 	free_parsed_policy(p->parsed);
 	if (!p->pkcs7)
 		kfree(p->text);
@@ -911,6 +914,44 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
 	return 0;
 }
 
+/**
+ * ipe_update_policy: parse a new policy and replace @old with it.
+ * @old: Supplies a pointer to the policy to replace
+ * @text: Supplies a pointer to the plain text policy
+ * @textlen: Supplies the length of @text
+ * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
+ * @pkcs7len: Supplies the length of @pkcs7len
+ *
+ * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
+ * ipe_new_policy.
+ *
+ * Return:
+ * !IS_ERR - OK
+ */
+struct ipe_policy *ipe_update_policy(struct ipe_policy *old,
+				     const char *text, size_t textlen,
+				     const char *pkcs7, size_t pkcs7len)
+{
+	int rc = 0;
+	struct ipe_policy *new;
+
+	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
+	if (IS_ERR(new)) {
+		rc = PTR_ERR(new);
+		goto err;
+	}
+
+	if (strcmp(new->parsed->name, old->parsed->name)) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	rc = ipe_replace_policy(old, new);
+err:
+	ipe_put_policy(new);
+	return (rc < 0) ? ERR_PTR(rc) : new;
+}
+
 /**
  * ipe_new_policy: allocate and parse an ipe_policy structure.
  *
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 2b5041c5a75a..6818f6405dd0 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -88,12 +88,16 @@ struct ipe_policy {
 
 	refcount_t	refcount;
 
+	struct dentry *policyfs;
 	struct list_head next;		/* type: ipe_policy */
 	struct ipe_context __rcu *ctx;
 };
 
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
+struct ipe_policy *ipe_update_policy(struct ipe_policy *old, const char *text,
+				     size_t textlen, const char *pkcs7,
+				     size_t pkcs7len);
 void ipe_put_policy(struct ipe_policy *pol);
 bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size);
 struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
diff --git a/security/ipe/policyfs.c b/security/ipe/policyfs.c
new file mode 100644
index 000000000000..d34c22e99225
--- /dev/null
+++ b/security/ipe/policyfs.c
@@ -0,0 +1,528 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include "ipe.h"
+#include "policy.h"
+#include "fs.h"
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/types.h>
+#include <linux/dcache.h>
+#include <linux/security.h>
+
+#define MAX_VERSION_SIZE ARRAY_SIZE("65535.65535.65535")
+
+/**
+ * find_policy: Follow the i_private field of a dentry, returning the address
+ *		of the resulting policy structure.
+ * @f: Securityfs object that contains a link to the dentry containing the
+ *     policy structure.
+ *
+ * Return:
+ * Always-Valid Address Pointer
+ */
+static inline struct ipe_policy __rcu **find_policy(struct file *f)
+{
+	struct dentry *link;
+
+	link = d_inode(f->f_path.dentry)->i_private;
+
+	return (struct ipe_policy __rcu **)&(d_inode(link)->i_private);
+}
+
+/**
+ * ipefs_file: defines a file in securityfs
+ */
+struct ipefs_file {
+	const char	*name;
+	umode_t		access;
+	const struct	file_operations *fops;
+};
+
+/**
+ * read_pkcs7: Read handler for the securityfs node,
+ *	       "ipe/policies/$name/pkcs7"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * @data will be populated with the pkcs7 blob representing the policy
+ * on success. If the policy is unsigned (like the boot policy), this
+ * will return -ENOENT.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t read_pkcs7(struct file *f, char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	if (!p->pkcs7) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = simple_read_from_buffer(data, len, offset, p->pkcs7, p->pkcs7len);
+
+out:
+	ipe_put_policy(p);
+	return rc;
+}
+
+/**
+ * read_policy: Read handler for the securityfs node,
+ *		"ipe/policies/$name/policy"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * @data will be populated with the plain-text version of the policy
+ * on success.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t read_policy(struct file *f, char __user *data,
+			   size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	rc = simple_read_from_buffer(data, len, offset, p->text, p->textlen);
+
+	ipe_put_policy(p);
+	return rc;
+}
+
+/**
+ * read_name: Read handler for the securityfs node,
+ *	      "ipe/policies/$name/name"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * @data will be populated with the policy_name attribute on success
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t read_name(struct file *f, char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	rc = simple_read_from_buffer(data, len, offset, p->parsed->name,
+				     strlen(p->parsed->name));
+
+	ipe_put_policy(p);
+	return rc;
+}
+
+/**
+ * read_version: Read handler for the securityfs node,
+ *		 "ipe/policies/$name/version"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * @data will be populated with the version string on success.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t read_version(struct file *f, char __user *data,
+			    size_t len, loff_t *offset)
+{
+	ssize_t rc = 0;
+	size_t bufsize = 0;
+	struct ipe_policy *p = NULL;
+	char buffer[MAX_VERSION_SIZE] = { 0 };
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	bufsize = scnprintf(buffer, ARRAY_SIZE(buffer), "%hu.%hu.%hu",
+			    p->parsed->version.major, p->parsed->version.minor,
+			    p->parsed->version.rev);
+
+	rc = simple_read_from_buffer(data, len, offset, buffer, bufsize);
+
+	ipe_put_policy(p);
+	return rc;
+}
+
+/**
+ * setactive: Write handler for the securityfs node,
+ *	      "ipe/policies/$name/active"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t setactive(struct file *f, const char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value = false;
+	struct ipe_policy *p = NULL;
+	struct ipe_context *ctx = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		goto out;
+
+	if (!value) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	ctx = ipe_get_ctx_rcu(p->ctx);
+	if (!ctx) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = ipe_set_active_pol(p);
+
+out:
+	ipe_put_ctx(ctx);
+	ipe_put_policy(p);
+	return (rc < 0) ? rc : len;
+}
+
+/**
+ * getactive: Read handler for the securityfs node,
+ *	      "ipe/policies/$name/active"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * @data will be populated with the 1 or 0 depending on if the
+ * corresponding policy is active.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t getactive(struct file *f, char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	const char *str;
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	str = ipe_is_policy_active(p) ? "1" : "0";
+	rc = simple_read_from_buffer(data, len, offset, str, 2);
+
+out:
+	ipe_put_policy(p);
+	return rc;
+}
+
+/**
+ * update_policy: Write handler for the securityfs node,
+ *		  "ipe/policies/$name/active"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * On success this updates the policy represented by $name,
+ * in-place.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t update_policy(struct file *f, const char __user *data,
+			     size_t len, loff_t *offset)
+{
+	int rc = 0;
+	char *copy = NULL;
+	struct ipe_policy *new = NULL;
+	struct ipe_policy *old = NULL;
+	struct ipe_context *ctx = NULL;
+	struct ipe_policy __rcu **addr = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	ctx = ipe_current_ctx();
+	if (!ctx)
+		return -ENOENT;
+
+	addr = find_policy(f);
+	old = ipe_get_policy_rcu(*addr);
+	if (!old) {
+		rc = -ENOENT;
+		goto err;
+	}
+
+	copy = memdup_user(data, len);
+	if (IS_ERR(copy)) {
+		rc = PTR_ERR(copy);
+		goto err;
+	}
+
+	new = ipe_update_policy(old, NULL, 0, copy, len);
+	if (IS_ERR(new)) {
+		rc = PTR_ERR(new);
+		goto err;
+	}
+
+	spin_lock(&ctx->lock);
+	rcu_assign_pointer(*addr, new);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	swap(new->policyfs, old->policyfs);
+
+	kfree(copy);
+	ipe_put_ctx(ctx);
+	ipe_put_policy(old);
+	return len;
+err:
+	kfree(copy);
+	ipe_put_ctx(ctx);
+	ipe_put_policy(new);
+	ipe_put_policy(old);
+	return rc;
+}
+
+/**
+ * delete_policy: write handler for securityfs dir, "ipe/policies/$name/delete"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * On success this deletes the policy represented by $name.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t delete_policy(struct file *f, const char __user *data,
+			     size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value = false;
+	struct ipe_policy *p = NULL;
+	struct ipe_context *ctx = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		goto out;
+
+	if (!value) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	if (ipe_is_policy_active(p)) {
+		rc = -EPERM;
+		goto out;
+	}
+
+	ctx = ipe_get_ctx_rcu(p->ctx);
+	if (!ctx) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	ipe_remove_policy(p);
+out:
+	ipe_put_ctx(ctx);
+	ipe_put_policy(p);
+	return (rc < 0) ? rc : len;
+}
+
+static const struct file_operations content_fops = {
+	.read = read_policy,
+};
+
+static const struct file_operations pkcs7_fops = {
+	.read = read_pkcs7,
+};
+
+static const struct file_operations name_fops = {
+	.read = read_name,
+};
+
+static const struct file_operations ver_fops = {
+	.read = read_version,
+};
+
+static const struct file_operations active_fops = {
+	.write = setactive,
+	.read = getactive,
+};
+
+static const struct file_operations update_fops = {
+	.write = update_policy,
+};
+
+static const struct file_operations delete_fops = {
+	.write = delete_policy,
+};
+
+/**
+ * policy_subdir: files under a policy subdirectory
+ */
+static const struct ipefs_file policy_subdir[] = {
+	{ "pkcs7", 0444, &pkcs7_fops },
+	{ "policy", 0444, &content_fops },
+	{ "name", 0444, &name_fops },
+	{ "version", 0444, &ver_fops },
+	{ "active", 0600, &active_fops },
+	{ "update", 0200, &update_fops },
+	{ "delete", 0200, &delete_fops },
+};
+
+/**
+ * soft_del_policyfs - soft delete the policyfs tree, preventing new
+ *		       accesses to the interfaces for this policy.
+ * @p - Policy to soft delete the tree for.
+ */
+static void soft_del_policyfs(struct ipe_policy *p)
+{
+	struct inode *ino = NULL;
+	struct ipe_policy __rcu **addr = NULL;
+
+	ino = d_inode(p->policyfs);
+	addr = (struct ipe_policy __rcu **)&ino->i_private;
+
+	inode_lock(ino);
+	rcu_assign_pointer(*addr, NULL);
+	inode_unlock(ino);
+	synchronize_rcu();
+}
+
+/**
+ * ipe_del_policyfs_node: Delete a securityfs entry for @p
+ * @p: Supplies a pointer to the policy to delete a securityfs entry for.
+ */
+void ipe_del_policyfs_node(struct ipe_policy *p)
+{
+	size_t i = 0;
+	struct dentry *d = NULL;
+	const struct ipefs_file *f = NULL;
+
+	if (IS_ERR_OR_NULL(p->policyfs))
+		return;
+
+	soft_del_policyfs(p);
+
+	for (i = 0; i < ARRAY_SIZE(policy_subdir); ++i) {
+		f = &policy_subdir[i];
+
+		d = lookup_positive_unlocked(f->name, p->policyfs,
+					     strlen(f->name));
+		if (IS_ERR(d))
+			continue;
+
+		securityfs_remove(d);
+		dput(d);
+	}
+
+	securityfs_remove(p->policyfs);
+}
+
+/**
+ * ipe_new_policyfs_node: Create a securityfs entry for @p
+ * @ctx: Supplies a pointer to a context structure that contains the root of
+ *	 the policy tree.
+ * @p: Supplies a pointer to the policy to create a securityfs entry for.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_new_policyfs_node(struct ipe_context *ctx, struct ipe_policy *p)
+{
+	int rc = 0;
+	size_t i = 0;
+	struct dentry *d = NULL;
+	struct ipe_policy **addr = NULL;
+	const struct ipefs_file *f = NULL;
+
+	p->policyfs = securityfs_create_dir(p->parsed->name, ctx->policy_root);
+	if (IS_ERR(p->policyfs)) {
+		rc = PTR_ERR(p->policyfs);
+		goto err;
+	}
+
+	addr = (struct ipe_policy **)&(d_inode(p->policyfs)->i_private);
+	*addr = p;
+
+	for (i = 0; i < ARRAY_SIZE(policy_subdir); ++i) {
+		f = &policy_subdir[i];
+
+		d = securityfs_create_file(f->name, f->access, p->policyfs, p->policyfs,
+					   f->fops);
+		if (IS_ERR(d)) {
+			rc = PTR_ERR(d);
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	ipe_del_policyfs_node(p);
+	return rc;
+}
-- 
2.33.0

