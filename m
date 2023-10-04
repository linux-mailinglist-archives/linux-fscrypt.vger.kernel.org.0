Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911227B97A2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbjJDWKY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbjJDWJ7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:59 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F879EB;
        Wed,  4 Oct 2023 15:09:53 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 8B91B20B74CE; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8B91B20B74CE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=T1w7PrldlbC7Y8tVhLFdg7dzzhk8RluXOVQGKL0bsKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnnKpYFlFQU4UNquBFMPIlLfAmqN827BxzfvciwZsIFkzUlV8spmx9pyViVNFmWBc
         uQM02wuQabymQZnxa5ABz32ApbldNQG1iMSs/GBI/flc+4F6ChmazxluOyMBjsIhvz
         shlrgZLO/jPiOkCYSeviyoid3TwT8jfS+8tRLIFI=
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
Subject: [RFC PATCH v11 07/19] ipe: add userspace interface
Date:   Wed,  4 Oct 2023 15:09:34 -0700
Message-Id: <1696457386-3010-8-git-send-email-wufan@linux.microsoft.com>
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
---
 security/ipe/Makefile    |   2 +
 security/ipe/fs.c        | 101 ++++++++
 security/ipe/fs.h        |  16 ++
 security/ipe/ipe.c       |   3 +
 security/ipe/ipe.h       |   2 +
 security/ipe/policy.c    | 112 +++++++++
 security/ipe/policy.h    |   9 +
 security/ipe/policy_fs.c | 481 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 726 insertions(+)
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
index 000000000000..522162af741a
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
+ * @data: Suppleis a buffer passed to the write syscall.
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
+	if (rc < 0 && !IS_ERR(p))
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
index 06da94a58aba..783058c06cd6 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -6,6 +6,8 @@
 #include "ipe.h"
 #include "hooks.h"
 
+bool ipe_enabled;
+
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 };
 
@@ -31,6 +33,7 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 static int __init ipe_init(void)
 {
 	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
+	ipe_enabled = true;
 
 	return 0;
 }
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index a1c68d0fc2e0..6dec06403eee 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -13,4 +13,6 @@
 
 #include <linux/lsm_hooks.h>
 
+extern bool ipe_enabled;
+
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index 3a529c7950a1..33bbc43f0d6f 100644
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
@@ -43,6 +71,65 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
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
+ * Context: Requires root->i_rwsem and ipe_policy_lock to be held.
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
+	lockdep_assert_held(&ipe_policy_lock);
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
+
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (old == ap)
+		rcu_assign_pointer(ipe_active_policy, new);
+
+	swap(new->policyfs, old->policyfs);
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
@@ -99,3 +186,28 @@ struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 	ipe_free_policy(new);
 	return ERR_PTR(rc);
 }
+
+/**
+ * ipe_set_active_pol - Make @p the active policy.
+ * @p: Supplies a pointer to the policy to make active.
+ *
+ * Context: Requires root->i_rwsem and ipe_policy_lock to be held.
+ * Return:
+ * * !IS_ERR	- Success
+ * * -EINVAL	- New active policy version is invalid
+ */
+int ipe_set_active_pol(const struct ipe_policy *p)
+{
+	struct ipe_policy *ap = NULL;
+
+	lockdep_assert_held(&ipe_policy_lock);
+
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (ap && ver_to_u64(ap) > ver_to_u64(p))
+		return -EINVAL;
+
+	rcu_assign_pointer(ipe_active_policy, p);
+
+	return 0;
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 45704465dc01..32e5e0b941eb 100644
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
index 000000000000..52a120118cda
--- /dev/null
+++ b/security/ipe/policy_fs.c
@@ -0,0 +1,481 @@
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
+ * @data: Suppleis a buffer passed to the write syscall.
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
+ * @data: Suppleis a buffer passed to the write syscall.
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
+ * @data: Suppleis a buffer passed to the write syscall.
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
+ * @data: Suppleis a buffer passed to the write syscall.
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
+	size_t bufsize = 0;
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
+	bufsize = scnprintf(buffer, ARRAY_SIZE(buffer), "%hu.%hu.%hu",
+			    p->parsed->version.major, p->parsed->version.minor,
+			    p->parsed->version.rev);
+
+	rc = simple_read_from_buffer(data, len, offset, buffer, bufsize);
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
+	mutex_lock(&ipe_policy_lock);
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
+	mutex_unlock(&ipe_policy_lock);
+	inode_unlock(root);
+	synchronize_rcu();
+	return (rc < 0) ? rc : len;
+}
+
+/**
+ * getactive - Read handler for "ipe/policies/$name/active".
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Suppleis a buffer passed to the write syscall.
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
+	mutex_lock(&ipe_policy_lock);
+	old = ipe_update_policy(root, NULL, 0, copy, len);
+	mutex_unlock(&ipe_policy_lock);
+	inode_unlock(root);
+	synchronize_rcu();
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
+	mutex_lock(&ipe_policy_lock);
+	p = (struct ipe_policy *)root->i_private;
+	if (!p) {
+		mutex_unlock(&ipe_policy_lock);
+		inode_unlock(root);
+		return -ENOENT;
+	}
+
+	ap = rcu_dereference_protected(ipe_active_policy,
+				       lockdep_is_held(&ipe_policy_lock));
+	if (p == ap) {
+		mutex_unlock(&ipe_policy_lock);
+		inode_unlock(root);
+		return -EPERM;
+	}
+	root->i_private = NULL;
+
+	mutex_unlock(&ipe_policy_lock);
+	inode_unlock(root);
+	synchronize_rcu();
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
+	if (IS_ERR(policyfs)) {
+		rc = PTR_ERR(policyfs);
+		goto err;
+	}
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
+	mutex_lock(&ipe_policy_lock);
+	p->policyfs = policyfs;
+	root->i_private = p;
+	mutex_unlock(&ipe_policy_lock);
+	inode_unlock(root);
+
+	return 0;
+err:
+	securityfs_recursive_remove(policyfs);
+	return rc;
+}
-- 
2.25.1

