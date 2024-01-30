Return-Path: <linux-fscrypt+bounces-153-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0A0784302C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:39:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E50F81C25104
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F254580C16;
	Tue, 30 Jan 2024 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="qUa0pet3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBAF1272C7;
	Tue, 30 Jan 2024 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654251; cv=none; b=nVF7avbTvtJRkK/o7iM1i7Jz4gDYEeYXeCsPLPco2S0b4UubKrJAH+NIQyxTHxdjF9+Ney1wWkn7lSu7YAHZv+oWcfCQgb7I2WPMTNzCUwrPbDbR84E0CMJXbuQ5qgsvmOi4zZhGXnizWHMqmUejliIWAXsbIKkwokZSor9wu3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654251; c=relaxed/simple;
	bh=nvTQAYe6ClKLywYsFl60TChrGrXR4TmMYD5qbQ5OSto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=e78eIBgEEisia2INo76L58A14gNTWh29b98OTRMz3eaHgUm5l/Mx+5zgk1a5AC0RnbtgHtsnbkF8hZcB40j3TStDwg8AGzVcqzz4VIFo9e2zQl1z3+1XP+Zigj3tv/xvi1HxmCGRRKRGUDDNk4R4hdc9RSo4cQmwTllmNq27nxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=qUa0pet3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 5D7D920B200D; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5D7D920B200D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=n1T7fFPVsrxosq+Gy/4MwsLRi5hZV/83J4GqC56xZlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUa0pet3z8lirYCbYybqJSCvQXrdvYOPWEMP/nSvzWZHa5q9zypzx5kfMrFvO4fOw
	 qBxlhXnLCeuXiFDg331cO71b7nn18sHsBJz9Apu3dOairzUXB7peX3GCYOHKYmByUM
	 ad6f7MQaCTGwqXMFN4mZ+jm7m/L8zNPtOBYblCk0=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v12 08/20] ipe: add userspace interface
Date: Tue, 30 Jan 2024 14:36:56 -0800
Message-Id: <1706654228-17180-9-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

As is typical with LSMs, IPE uses securityfs as its interface with
userspace. for a complete list of the interfaces and the respective
inputs/outputs, please see the documentation under
admin-guide/LSM/ipe.rst

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
  + Propagating changes to support the new ipe_context structure in the
    evaluation loop.

  + Further split the parser and userspace interface changes into
    separate commits.

  + "raw" was renamed to "pkcs7" and made read only
  + "raw"'s write functionality (update a policy) moved to "update"
  + introduced "version", "policy_name" nodes.
  + "content" renamed to "policy"
  + changes to allow the compiled-in policy to be treated
    identical to deployed-after-the-fact policies.

v8:
  + Prevent securityfs initialization if the LSM is disabled

v9:
  + Switch to securityfs_recursive_remove for policy folder deletion

v10:
  + Simplify and correct concurrency
  + Fix typos

v11:
  + Correct code comments

v12:
  + Correct locking and remove redundant code
---
 security/ipe/Makefile    |   2 +
 security/ipe/fs.c        | 101 +++++++++
 security/ipe/fs.h        |  16 ++
 security/ipe/ipe.c       |   3 +
 security/ipe/ipe.h       |   2 +
 security/ipe/policy.c    | 123 ++++++++++
 security/ipe/policy.h    |   9 +
 security/ipe/policy_fs.c | 469 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 725 insertions(+)
 create mode 100644 security/ipe/fs.c
 create mode 100644 security/ipe/fs.h
 create mode 100644 security/ipe/policy_fs.c

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index d7f2870d7c09..cfbed03a8885 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -8,6 +8,8 @@
 obj-$(CONFIG_SECURITY_IPE) += \
 	eval.o \
 	hooks.o \
+	fs.o \
 	ipe.o \
 	policy.o \
+	policy_fs.o \
 	policy_parser.o \
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
new file mode 100644
index 000000000000..4949296caeb5
--- /dev/null
+++ b/security/ipe/fs.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/dcache.h>
+#include <linux/security.h>
+
+#include "ipe.h"
+#include "fs.h"
+#include "policy.h"
+
+static struct dentry *np __ro_after_init;
+static struct dentry *root __ro_after_init;
+struct dentry *policy_root __ro_after_init;
+
+/**
+ * new_policy - Write handler for the securityfs node, "ipe/new_policy".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t new_policy(struct file *f, const char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	char *copy = NULL;
+	struct ipe_policy *p = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	copy = memdup_user_nul(data, len);
+	if (IS_ERR(copy))
+		return PTR_ERR(copy);
+
+	p = ipe_new_policy(NULL, 0, copy, len);
+	if (IS_ERR(p)) {
+		rc = PTR_ERR(p);
+		goto out;
+	}
+
+	rc = ipe_new_policyfs_node(p);
+
+out:
+	if (rc < 0)
+		ipe_free_policy(p);
+	kfree(copy);
+	return (rc < 0) ? rc : len;
+}
+
+static const struct file_operations np_fops = {
+	.write = new_policy,
+};
+
+/**
+ * ipe_init_securityfs - Initialize IPE's securityfs tree at fsinit.
+ *
+ * Return:
+ * * !0	- Error
+ * * 0	- OK
+ */
+static int __init ipe_init_securityfs(void)
+{
+	int rc = 0;
+
+	if (!ipe_enabled)
+		return -EOPNOTSUPP;
+
+	root = securityfs_create_dir("ipe", NULL);
+	if (IS_ERR(root)) {
+		rc = PTR_ERR(root);
+		goto err;
+	}
+
+	policy_root = securityfs_create_dir("policies", root);
+	if (IS_ERR(policy_root)) {
+		rc = PTR_ERR(policy_root);
+		goto err;
+	}
+
+	np = securityfs_create_file("new_policy", 0200, root, NULL, &np_fops);
+	if (IS_ERR(np)) {
+		rc = PTR_ERR(np);
+		goto err;
+	}
+
+	return 0;
+err:
+	securityfs_remove(np);
+	securityfs_remove(policy_root);
+	securityfs_remove(root);
+	return rc;
+}
+
+fs_initcall(ipe_init_securityfs);
diff --git a/security/ipe/fs.h b/security/ipe/fs.h
new file mode 100644
index 000000000000..c1fc0ca4ae93
--- /dev/null
+++ b/security/ipe/fs.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _IPE_FS_H
+#define _IPE_FS_H
+
+#include "policy.h"
+
+extern struct dentry *policy_root __ro_after_init;
+
+int ipe_new_policyfs_node(struct ipe_policy *p);
+void ipe_del_policyfs_node(struct ipe_policy *p);
+
+#endif /* _IPE_FS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index ed3acf6174d8..034ee8cd6802 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -8,6 +8,8 @@
 #include "eval.h"
 #include "hooks.h"
 
+bool ipe_enabled;
+
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 #ifdef CONFIG_BLK_DEV_INITRD
 	.lbs_superblock = sizeof(struct ipe_sb),
@@ -50,6 +52,7 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 static int __init ipe_init(void)
 {
 	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), &ipe_lsmid);
+	ipe_enabled = true;
 
 	return 0;
 }
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index f1e7c3222b6d..1862c710dab8 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -16,4 +16,6 @@
 struct ipe_sb *ipe_sb(const struct super_block *sb);
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+extern bool ipe_enabled;
+
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index f22a576a6d68..61fea3e38e11 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -7,9 +7,36 @@
 #include <linux/verification.h>
 
 #include "ipe.h"
+#include "eval.h"
+#include "fs.h"
 #include "policy.h"
 #include "policy_parser.h"
 
+/* lock for synchronizing writers across ipe policy */
+DEFINE_MUTEX(ipe_policy_lock);
+
+/**
+ * ver_to_u64 - Convert an internal ipe_policy_version to a u64.
+ * @p: Policy to extract the version from.
+ *
+ * Bits (LSB is index 0):
+ *	[48,32] -> Major
+ *	[32,16] -> Minor
+ *	[16, 0] -> Revision
+ *
+ * Return: u64 version of the embedded version structure.
+ */
+static inline u64 ver_to_u64(const struct ipe_policy *const p)
+{
+	u64 r;
+
+	r = (((u64)p->parsed->version.major) << 32)
+	  | (((u64)p->parsed->version.minor) << 16)
+	  | ((u64)(p->parsed->version.rev));
+
+	return r;
+}
+
 /**
  * ipe_free_policy - Deallocate a given IPE policy.
  * @p: Supplies the policy to free.
@@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
 	if (IS_ERR_OR_NULL(p))
 		return;
 
+	ipe_del_policyfs_node(p);
 	free_parsed_policy(p->parsed);
 	/*
 	 * p->text is allocated only when p->pkcs7 is not NULL
@@ -43,6 +71,68 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
 	return 0;
 }
 
+/**
+ * ipe_update_policy - parse a new policy and replace old with it.
+ * @root: Supplies a pointer to the securityfs inode saved the policy.
+ * @text: Supplies a pointer to the plain text policy.
+ * @textlen: Supplies the length of @text.
+ * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
+ * @pkcs7len: Supplies the length of @pkcs7len.
+ *
+ * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
+ * ipe_new_policy.
+ *
+ * Context: Requires root->i_rwsem to be held.
+ * Return:
+ * * !IS_ERR	- The existing policy saved in the inode before update
+ * * -ENOENT	- Policy doesn't exist
+ * * -EINVAL	- New policy is invalid
+ */
+struct ipe_policy *ipe_update_policy(struct inode *root,
+				     const char *text, size_t textlen,
+				     const char *pkcs7, size_t pkcs7len)
+{
+	int rc = 0;
+	struct ipe_policy *old, *ap, *new = NULL;
+
+	old = (struct ipe_policy *)root->i_private;
+	if (!old)
+		return ERR_PTR(-ENOENT);
+
+	new = ipe_new_policy(text, textlen, pkcs7, pkcs7len);
+	if (IS_ERR(new))
+		return new;
+
+	if (strcmp(new->parsed->name, old->parsed->name)) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	if (ver_to_u64(old) > ver_to_u64(new)) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	root->i_private = new;
+	swap(new->policyfs, old->policyfs);
+
+	mutex_lock(&ipe_policy_lock);
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (old == ap) {
+		rcu_assign_pointer(ipe_active_policy, new);
+		mutex_unlock(&ipe_policy_lock);
+		synchronize_rcu();
+	} else {
+		mutex_unlock(&ipe_policy_lock);
+	}
+
+	return old;
+err:
+	ipe_free_policy(new);
+	return ERR_PTR(rc);
+}
+
 /**
  * ipe_new_policy - Allocate and parse an ipe_policy structure.
  *
@@ -99,3 +189,36 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 	ipe_free_policy(new);
 	return ERR_PTR(rc);
 }
+
+/**
+ * ipe_set_active_pol - Make @p the active policy.
+ * @p: Supplies a pointer to the policy to make active.
+ *
+ * Context: Requires root->i_rwsem, which i_private has the policy, to be held.
+ * Return:
+ * * !IS_ERR	- Success
+ * * -EINVAL	- New active policy version is invalid
+ */
+int ipe_set_active_pol(const struct ipe_policy *p)
+{
+	struct ipe_policy *ap = NULL;
+
+	mutex_lock(&ipe_policy_lock);
+
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (ap == p) {
+		mutex_unlock(&ipe_policy_lock);
+		return 0;
+	}
+	if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
+		mutex_unlock(&ipe_policy_lock);
+		return -EINVAL;
+	}
+
+	rcu_assign_pointer(ipe_active_policy, p);
+	mutex_unlock(&ipe_policy_lock);
+	synchronize_rcu();
+
+	return 0;
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index fb48024bb63e..060ffdbc62d6 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -7,6 +7,7 @@
 
 #include <linux/list.h>
 #include <linux/types.h>
+#include <linux/fs.h>
 
 enum ipe_op_type {
 	IPE_OP_EXEC = 0,
@@ -76,10 +77,18 @@ struct ipe_policy {
 	size_t textlen;
 
 	struct ipe_parsed_policy *parsed;
+
+	struct dentry *policyfs;
 };
 
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
 void ipe_free_policy(struct ipe_policy *pol);
+struct ipe_policy *ipe_update_policy(struct inode *root,
+				     const char *text,
+				     size_t textlen, const char *pkcs7,
+				     size_t pkcs7len);
+int ipe_set_active_pol(const struct ipe_policy *p);
+extern struct mutex ipe_policy_lock;
 
 #endif /* _IPE_POLICY_H */
diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
new file mode 100644
index 000000000000..abdf1ad843e0
--- /dev/null
+++ b/security/ipe/policy_fs.c
@@ -0,0 +1,469 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/types.h>
+#include <linux/dcache.h>
+#include <linux/security.h>
+
+#include "ipe.h"
+#include "policy.h"
+#include "eval.h"
+#include "fs.h"
+
+#define MAX_VERSION_SIZE ARRAY_SIZE("65535.65535.65535")
+
+/**
+ * ipefs_file - defines a file in securityfs.
+ */
+struct ipefs_file {
+	const char *name;
+	umode_t access;
+	const struct file_operations *fops;
+};
+
+/**
+ * read_pkcs7 - Read handler for "ipe/policies/$name/pkcs7".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * @data will be populated with the pkcs7 blob representing the policy
+ * on success. If the policy is unsigned (like the boot policy), this
+ * will return -ENOENT.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t read_pkcs7(struct file *f, char __user *data,
+			  size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	if (!p->pkcs7) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = simple_read_from_buffer(data, len, offset, p->pkcs7, p->pkcs7len);
+
+out:
+	inode_unlock_shared(root);
+
+	return rc;
+}
+
+/**
+ * read_policy - Read handler for "ipe/policies/$name/policy".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * @data will be populated with the plain-text version of the policy
+ * on success.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t read_policy(struct file *f, char __user *data,
+			   size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = simple_read_from_buffer(data, len, offset, p->text, p->textlen);
+
+out:
+	inode_unlock_shared(root);
+
+	return rc;
+}
+
+/**
+ * read_name: Read handler for "ipe/policies/$name/name".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * @data will be populated with the policy_name attribute on success.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t read_name(struct file *f, char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = simple_read_from_buffer(data, len, offset, p->parsed->name,
+				     strlen(p->parsed->name));
+
+out:
+	inode_unlock_shared(root);
+
+	return rc;
+}
+
+/**
+ * read_version - Read handler for "ipe/policies/$name/version".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * @data will be populated with the version string on success.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t read_version(struct file *f, char __user *data,
+			    size_t len, loff_t *offset)
+{
+	ssize_t rc = 0;
+	size_t strsize = 0;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+	char buffer[MAX_VERSION_SIZE] = { 0 };
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	strsize = scnprintf(buffer, ARRAY_SIZE(buffer), "%hu.%hu.%hu",
+			    p->parsed->version.major, p->parsed->version.minor,
+			    p->parsed->version.rev);
+
+	rc = simple_read_from_buffer(data, len, offset, buffer, strsize);
+
+out:
+	inode_unlock_shared(root);
+
+	return rc;
+}
+
+/**
+ * setactive - Write handler for "ipe/policies/$name/active".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t setactive(struct file *f, const char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value = false;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	if (!value)
+		return -EINVAL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+	inode_lock(root);
+
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	rc = ipe_set_active_pol(p);
+
+out:
+	inode_unlock(root);
+	return (rc < 0) ? rc : len;
+}
+
+/**
+ * getactive - Read handler for "ipe/policies/$name/active".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * @data will be populated with the 1 or 0 depending on if the
+ * corresponding policy is active.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t getactive(struct file *f, char __user *data,
+			 size_t len, loff_t *offset)
+{
+	int rc = 0;
+	const char *str;
+	struct inode *root = NULL;
+	const struct ipe_policy *p = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		inode_unlock_shared(root);
+		return -ENOENT;
+	}
+	inode_unlock_shared(root);
+
+	str = (p == rcu_access_pointer(ipe_active_policy)) ? "1" : "0";
+	rc = simple_read_from_buffer(data, len, offset, str, 1);
+
+	return rc;
+}
+
+/**
+ * update_policy - Write handler for "ipe/policies/$name/update".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * On success this updates the policy represented by $name,
+ * in-place.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t update_policy(struct file *f, const char __user *data,
+			     size_t len, loff_t *offset)
+{
+	char *copy = NULL;
+	struct inode *root = NULL;
+	struct ipe_policy *old = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	copy = memdup_user(data, len);
+	if (IS_ERR(copy))
+		return PTR_ERR(copy);
+
+	root = d_inode(f->f_path.dentry->d_parent);
+	inode_lock(root);
+	old = ipe_update_policy(root, NULL, 0, copy, len);
+	inode_unlock(root);
+
+	kfree(copy);
+	if (IS_ERR(old))
+		return PTR_ERR(old);
+	ipe_free_policy(old);
+
+	return len;
+}
+
+/**
+ * delete_policy - write handler for  "ipe/policies/$name/delete".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall.
+ * @len: Supplies the length of @data.
+ * @offset: unused.
+ *
+ * On success this deletes the policy represented by $name.
+ *
+ * Return:
+ * * >0	- Success, Length of buffer written
+ * * <0	- Error
+ */
+static ssize_t delete_policy(struct file *f, const char __user *data,
+			     size_t len, loff_t *offset)
+{
+	int rc = 0;
+	bool value = false;
+	struct inode *root = NULL;
+	struct ipe_policy *p = NULL;
+	struct ipe_policy *ap = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	rc = kstrtobool_from_user(data, len, &value);
+	if (rc)
+		return rc;
+
+	if (!value)
+		return -EINVAL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+	inode_lock(root);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		inode_unlock(root);
+		return -ENOENT;
+	}
+
+	mutex_lock(&ipe_policy_lock);
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (p == ap) {
+		mutex_unlock(&ipe_policy_lock);
+		inode_unlock(root);
+		return -EPERM;
+	}
+	mutex_unlock(&ipe_policy_lock);
+
+	root->i_private = NULL;
+	inode_unlock(root);
+
+	ipe_free_policy(p);
+	return len;
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
+ * policy_subdir - files under a policy subdirectory
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
+ * ipe_del_policyfs_node - Delete a securityfs entry for @p.
+ * @p: Supplies a pointer to the policy to delete a securityfs entry for.
+ */
+void ipe_del_policyfs_node(struct ipe_policy *p)
+{
+	securityfs_recursive_remove(p->policyfs);
+	p->policyfs = NULL;
+}
+
+/**
+ * ipe_new_policyfs_node - Create a securityfs entry for @p.
+ * @p: Supplies a pointer to the policy to create a securityfs entry for.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_new_policyfs_node(struct ipe_policy *p)
+{
+	int rc = 0;
+	size_t i = 0;
+	struct dentry *d = NULL;
+	struct dentry *policyfs = NULL;
+	struct inode *root = NULL;
+	const struct ipefs_file *f = NULL;
+
+	if (p->policyfs)
+		return 0;
+
+	policyfs = securityfs_create_dir(p->parsed->name, policy_root);
+	if (IS_ERR(policyfs))
+		return PTR_ERR(policyfs);
+
+	root = d_inode(policyfs);
+
+	for (i = 0; i < ARRAY_SIZE(policy_subdir); ++i) {
+		f = &policy_subdir[i];
+
+		d = securityfs_create_file(f->name, f->access, policyfs,
+					   NULL, f->fops);
+		if (IS_ERR(d)) {
+			rc = PTR_ERR(d);
+			goto err;
+		}
+	}
+
+	inode_lock(root);
+	p->policyfs = policyfs;
+	root->i_private = p;
+	inode_unlock(root);
+
+	return 0;
+err:
+	securityfs_recursive_remove(policyfs);
+	return rc;
+}
-- 
2.43.0


