Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A667B681EDD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Jan 2023 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjA3W7H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Jan 2023 17:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjA3W6q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Jan 2023 17:58:46 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3D8E1631C;
        Mon, 30 Jan 2023 14:58:43 -0800 (PST)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 31BDC20EA1ED; Mon, 30 Jan 2023 14:58:42 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 31BDC20EA1ED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1675119522;
        bh=Ql9EiLPH5Em37wPM4yPhYAWcGtEHZ+bjn+2LFzyC8mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDrcJyk6Q+9ab4Iwz/QhsVJ5prtxxHJm3uOwDiTxJiWCZafTBnxE80AwyfXhaIIBf
         y7xSeTD1RLWweBL0PbyoJwuJSZku7CRX/TuzSgo4zq6sJxEYwq6MsWQ2V7XJnbuHYK
         uwE6D1JnZKCjejyfznzV+jUcc0+xfSUjuKDhPFtE=
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
Subject: [RFC PATCH v9 05/16] ipe: add userspace interface
Date:   Mon, 30 Jan 2023 14:57:20 -0800
Message-Id: <1675119451-23180-6-git-send-email-wufan@linux.microsoft.com>
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
    operaiton.
  + Minor function renames

v6:
  + No changes

v7:
  + Propogating changes to support the new ipe_context structure in the
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
---
 security/ipe/Makefile    |   2 +
 security/ipe/fs.c        | 101 +++++++++
 security/ipe/fs.h        |  17 ++
 security/ipe/ipe.c       |   3 +
 security/ipe/ipe.h       |   2 +
 security/ipe/policy.c    | 135 ++++++++++++
 security/ipe/policy.h    |   7 +
 security/ipe/policy_fs.c | 459 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 726 insertions(+)
 create mode 100644 security/ipe/fs.c
 create mode 100644 security/ipe/fs.h
 create mode 100644 security/ipe/policy_fs.c

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index d7f2870d7c09..8602d71250b4 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -7,7 +7,9 @@
 
 obj-$(CONFIG_SECURITY_IPE) += \
 	eval.o \
+	fs.o \
 	hooks.o \
 	ipe.o \
 	policy.o \
+	policy_fs.o \
 	policy_parser.o \
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
new file mode 100644
index 000000000000..9f6a4867bec2
--- /dev/null
+++ b/security/ipe/fs.c
@@ -0,0 +1,101 @@
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
+	rc = ipe_new_policyfs_node(p);
+	if (rc)
+		goto err;
+
+err:
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
+	np = securityfs_create_file("new_policy", 0200, root, NULL, &np_fops);
+	if (IS_ERR(np)) {
+		rc = PTR_ERR(np);
+		goto err;
+	}
+
+	policy_root = securityfs_create_dir("policies", root);
+	if (IS_ERR(policy_root)) {
+		rc = PTR_ERR(policy_root);
+		goto err;
+	}
+
+	return 0;
+err:
+	securityfs_remove(np);
+	securityfs_remove(root);
+	securityfs_remove(policy_root);
+	return rc;
+}
+
+fs_initcall(ipe_init_securityfs);
diff --git a/security/ipe/fs.h b/security/ipe/fs.h
new file mode 100644
index 000000000000..fa105d9d6fc5
--- /dev/null
+++ b/security/ipe/fs.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_FS_H
+#define IPE_FS_H
+
+#include "policy.h"
+
+extern struct dentry *policy_root __ro_after_init;
+
+void ipe_soft_del_policyfs(struct ipe_policy *p);
+int ipe_new_policyfs_node(struct ipe_policy *p);
+void ipe_del_policyfs_node(struct ipe_policy *p);
+
+#endif /* IPE_FS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 551c6d90ac11..bef923026b50 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -5,6 +5,8 @@
 
 #include "ipe.h"
 
+bool ipe_enabled;
+
 static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 };
 
@@ -30,6 +32,7 @@ static int __init ipe_init(void)
 	int rc = 0;
 
 	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
+	ipe_enabled = true;
 
 	return rc;
 }
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index ee7ec3f3b55d..43cc132ed048 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -10,4 +10,6 @@
 
 #include <linux/lsm_hooks.h>
 
+extern bool ipe_enabled;
+
 #endif /* IPE_H */
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index 772d876b1087..a5e9c6e5691b 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -4,12 +4,39 @@
  */
 
 #include "ipe.h"
+#include "eval.h"
+#include "fs.h"
 #include "policy.h"
 #include "policy_parser.h"
 #include "digest.h"
 
 #include <linux/verification.h>
 
+/* lock for synchronizing writers across ipe policy */
+DEFINE_SPINLOCK(ipe_policy_lock);
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
  * ipe_free_policy - Deallocate a given IPE policy.
  * @p: Supplies the policy to free.
@@ -21,6 +48,7 @@ void ipe_free_policy(struct ipe_policy *p)
 	if (IS_ERR_OR_NULL(p))
 		return;
 
+	ipe_del_policyfs_node(p);
 	free_parsed_policy(p->parsed);
 	if (!p->pkcs7)
 		kfree(p->text);
@@ -39,6 +67,70 @@ static int set_pkcs7_data(void *ctx, const void *data, size_t len,
 	return 0;
 }
 
+/**
+ * ipe_update_policy - parse a new policy and replace @old with it.
+ * @addr: Supplies a pointer to the i_private for saving policy.
+ * @text: Supplies a pointer to the plain text policy.
+ * @textlen: Supplies the length of @text.
+ * @pkcs7: Supplies a pointer to a buffer containing a pkcs7 message.
+ * @pkcs7len: Supplies the length of @pkcs7len.
+ *
+ * @text/@textlen is mutually exclusive with @pkcs7/@pkcs7len - see
+ * ipe_new_policy.
+ *
+ * Return:
+ * * !IS_ERR	- OK
+ * * -ENOENT	- Policy doesn't exist
+ * * -EINVAL	- New policy is invalid
+ */
+struct ipe_policy *ipe_update_policy(struct ipe_policy __rcu **addr,
+				     const char *text, size_t textlen,
+				     const char *pkcs7, size_t pkcs7len)
+{
+	int rc = 0;
+	struct ipe_policy *old, *new;
+
+	old = ipe_get_policy_rcu(*addr);
+	if (!old) {
+		rc = -ENOENT;
+		goto err;
+	}
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
+	if (ver_to_u64(old) > ver_to_u64(new)) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	if (ipe_is_policy_active(old)) {
+		spin_lock(&ipe_policy_lock);
+		rcu_assign_pointer(ipe_active_policy, new);
+		spin_unlock(&ipe_policy_lock);
+		synchronize_rcu();
+	}
+
+	rcu_assign_pointer(*addr, new);
+
+	swap(new->policyfs, old->policyfs);
+	ipe_free_policy(old);
+
+	goto out;
+err:
+	ipe_free_policy(new);
+out:
+	return (rc < 0) ? ERR_PTR(rc) : new;
+}
+
 /**
  * ipe_new_policy - Allocate and parse an ipe_policy structure.
  *
@@ -117,3 +209,46 @@ struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p)
 
 	return rv;
 }
+
+/**
+ * ipe_set_active_pol - Make @p the active policy.
+ * @p: Supplies a pointer to the policy to make active.
+ */
+int ipe_set_active_pol(const struct ipe_policy *p)
+{
+	int rc = 0;
+	struct ipe_policy *ap = NULL;
+
+	ap = ipe_get_policy_rcu(ipe_active_policy);
+	if (ap && ver_to_u64(ap) > ver_to_u64(p)) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	spin_lock(&ipe_policy_lock);
+	rcu_assign_pointer(ipe_active_policy, p);
+	spin_unlock(&ipe_policy_lock);
+	synchronize_rcu();
+
+out:
+	return rc;
+}
+
+/**
+ * ipe_is_policy_active - Determine wehther @p is the active policy.
+ * @p: Supplies a pointer to the policy to check.
+ *
+ * Return:
+ * * true	- @p is the active policy
+ * * false	- @p is not the active policy
+ */
+bool ipe_is_policy_active(const struct ipe_policy *p)
+{
+	bool rv;
+
+	rcu_read_lock();
+	rv = rcu_access_pointer(ipe_active_policy) == p;
+	rcu_read_unlock();
+
+	return rv;
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 967d816cd5cd..0cb42b6f246e 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -70,11 +70,18 @@ struct ipe_policy {
 	size_t		textlen;
 
 	struct ipe_parsed_policy *parsed;
+
+	struct dentry *policyfs;
 };
 
 struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
 				  const char *pkcs7, size_t pkcs7len);
 void ipe_free_policy(struct ipe_policy *pol);
 struct ipe_policy *ipe_get_policy_rcu(struct ipe_policy __rcu *p);
+struct ipe_policy *ipe_update_policy(struct ipe_policy **addr, const char *text,
+				     size_t textlen, const char *pkcs7,
+				     size_t pkcs7len);
+int ipe_set_active_pol(const struct ipe_policy *p);
+bool ipe_is_policy_active(const struct ipe_policy *p);
 
 #endif /* IPE_POLICY_H */
diff --git a/security/ipe/policy_fs.c b/security/ipe/policy_fs.c
new file mode 100644
index 000000000000..72759cc8938d
--- /dev/null
+++ b/security/ipe/policy_fs.c
@@ -0,0 +1,459 @@
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
+ * find_policy - return a policy pointer saved in i_private of a dentry.
+ * @f: Securityfs object that contains a link to the dentry containing the
+ *     policy structure.
+ *
+ * Return: Always-Valid Address Pointer
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
+ * ipefs_file - defines a file in securityfs.
+ */
+struct ipefs_file {
+	const char	*name;
+	umode_t		access;
+	const struct	file_operations *fops;
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
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	rc = simple_read_from_buffer(data, len, offset, p->text, p->textlen);
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
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p)
+		return -ENOENT;
+
+	rc = simple_read_from_buffer(data, len, offset, p->parsed->name,
+				     strlen(p->parsed->name));
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
+	struct ipe_policy *p = NULL;
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
+	rc = ipe_set_active_pol(p);
+
+out:
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
+	struct ipe_policy *p = NULL;
+
+	p = ipe_get_policy_rcu(*find_policy(f));
+	if (!p) {
+		rc = -ENOENT;
+		goto out;
+	}
+
+	str = ipe_is_policy_active(p) ? "1" : "0";
+	rc = simple_read_from_buffer(data, len, offset, str, 1);
+
+out:
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
+	int rc = 0;
+	char *copy = NULL;
+	struct inode *ino = NULL;
+	struct ipe_policy *new = NULL;
+	struct ipe_policy __rcu **addr = NULL;
+
+	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
+		return -EPERM;
+
+	copy = memdup_user(data, len);
+	if (IS_ERR(copy)) {
+		rc = PTR_ERR(copy);
+		goto err;
+	}
+
+	ino = d_inode(f->f_path.dentry->d_parent);
+	inode_lock(ino);
+	addr = find_policy(f);
+	new = ipe_update_policy(addr, NULL, 0, copy, len);
+	inode_unlock(ino);
+	synchronize_rcu();
+	if (IS_ERR(new)) {
+		rc = PTR_ERR(new);
+		goto err;
+	}
+
+	kfree(copy);
+	return len;
+err:
+	kfree(copy);
+	return rc;
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
+	struct ipe_policy *p = NULL;
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
+	ipe_free_policy(p);
+out:
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
+ * soft_del_policyfs - soft delete a policyfs node.
+ * @p: Supplies a ipe_policy associated with the node to delete.
+ *
+ * This deletes the i_private field of a policyfs node.
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
+ * ipe_del_policyfs_node - Delete a securityfs entry for @p.
+ * @p: Supplies a pointer to the policy to delete a securityfs entry for.
+ */
+void ipe_del_policyfs_node(struct ipe_policy *p)
+{
+	if (IS_ERR_OR_NULL(p->policyfs))
+		return;
+
+	soft_del_policyfs(p);
+	securityfs_recursive_remove(p->policyfs);
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
+	struct ipe_policy **addr = NULL;
+	const struct ipefs_file *f = NULL;
+
+	p->policyfs = securityfs_create_dir(p->parsed->name, policy_root);
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
2.39.0

