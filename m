Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994B442C994
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbhJMTJR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:17 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49064 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 0DF7520B9D03;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0DF7520B9D03
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=U+g085wgU+Is+WzDTIguYGX9/BIK0TB3mTgcW+hbXss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNWiwCq4PZL2yfdogwdKCdQzIhozD2pXyjeq1alhyFFQS2IdxtBRY0w40JMuUiKo4
         dzNG/ohizceyGgAxhO2vN3w4omLWd2a1BfaGK430qFK/MXvCzAMGLpvtCkgVOAaxpD
         hzTrXyM7OaVRQFh7FfukHeApI5y6JLRYTZ+dD4DQ=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 08/16] ipe: add permissive toggle
Date:   Wed, 13 Oct 2021 12:06:27 -0700
Message-Id: <1634151995-16266-9-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE, like SELinux, supports a permissive mode. This mode allows policy
authors to test and evaluate IPE policy without it effecting their
programs.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Refactor series to:
      1. Support a context structure, enabling easier testing
      2. Make parser code cleaner
  * Split up patch 02/12 into four parts:
      1. context creation [01/16]
      2. audit [07/16]
      3. evaluation loop [03/16]
      4. access control hooks [05/16]
      5. permissive mode [08/16]

---
 security/ipe/audit.c | 40 +++++++++++++++++++++++
 security/ipe/audit.h |  5 +++
 security/ipe/ctx.c   |  6 ++++
 security/ipe/ctx.h   |  1 +
 security/ipe/eval.c  |  6 ++++
 security/ipe/fs.c    | 78 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 136 insertions(+)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 5f6c0a52b0cb..82bf94b83fe1 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -262,3 +262,43 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
 
 	audit_log_end(ab);
 }
+
+/**
+ * ipe_audit_enforce: Audit a change in IPE's enforcement state
+ * @ctx: Supplies a pointer to the contexts whose state changed.
+ */
+void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+	struct audit_buffer *ab;
+	bool enforcing = false;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_TRUST_STATUS);
+	if (!ab)
+		return;
+
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->enforce);
+	rcu_read_unlock();
+
+	audit_log_format(ab, "IPE enforce=%d", enforcing);
+
+	audit_log_end(ab);
+}
+
+/**
+ * emit_enforcement: Emit the enforcement state of IPE started with.
+ *
+ * Return:
+ * 0 - Always
+ */
+static int emit_enforcement(void)
+{
+	struct ipe_context *ctx = NULL;
+
+	ctx = ipe_current_ctx();
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return 0;
+}
+
+late_initcall(emit_enforcement);
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
index 6b6880f6e8e7..a9d16323a3c8 100644
--- a/security/ipe/audit.h
+++ b/security/ipe/audit.h
@@ -16,6 +16,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		     bool enforce);
 void ipe_audit_policy_load(const struct ipe_policy *const p);
 void ipe_audit_policy_activation(const struct ipe_policy *const p);
+void ipe_audit_enforce(const struct ipe_context *const ctx);
 #else
 static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 				   enum ipe_match match_type,
@@ -31,6 +32,10 @@ static inline void ipe_audit_policy_load(const struct ipe_policy *const p)
 static inline void ipe_audit_policy_activation(const struct ipe_policy *const p)
 {
 }
+
+static inline void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+}
 #endif /* CONFIG_AUDIT */
 
 #endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 77475aedbfe9..fc9b8e467bc9 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -16,6 +16,7 @@
 #include <linux/moduleparam.h>
 
 static bool success_audit;
+static bool enforce = true;
 
 /**
  * ver_to_u64: convert an internal ipe_policy_version to a u64
@@ -151,6 +152,7 @@ static struct ipe_context *create_ctx(void)
 	INIT_LIST_HEAD(&ctx->policies);
 	refcount_set(&ctx->refcount, 1);
 	spin_lock_init(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, true);
 
 	return ctx;
 
@@ -337,6 +339,7 @@ int __init ipe_init_ctx(void)
 
 	spin_lock(&lns->lock);
 	WRITE_ONCE(lns->success_audit, success_audit);
+	WRITE_ONCE(lns->enforce, enforce);
 	spin_unlock(&lns->lock);
 
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
@@ -355,3 +358,6 @@ int __init ipe_init_ctx(void)
 
 module_param(success_audit, bool, 0400);
 MODULE_PARM_DESC(success_audit, "Start IPE with success auditing enabled");
+
+module_param(enforce, bool, 0400);
+MODULE_PARM_DESC(enforce, "Start IPE in enforce or permissive mode");
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
index 31aea2fb9e49..d7bf9fc6426a 100644
--- a/security/ipe/ctx.h
+++ b/security/ipe/ctx.h
@@ -14,6 +14,7 @@
 
 struct ipe_context {
 	struct ipe_policy __rcu *active_policy;
+	bool __rcu enforce;
 
 	bool __rcu success_audit;
 
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index dcb62179e4bf..e520ce521c05 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -86,6 +86,10 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (!pol)
 		goto out;
 
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->ci_ctx->enforce);
+	rcu_read_unlock();
+
 	rules = &pol->parsed->rules[ctx->op];
 
 	list_for_each_entry(rule, &rules->rules, next) {
@@ -114,6 +118,8 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
+	if (!enforcing)
+		rc = 0;
 out:
 	ipe_put_policy(pol);
 	return rc;
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index c202c0753755..e6b36291e62f 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -13,8 +13,73 @@
 static struct dentry *np __ro_after_init;
 static struct dentry *root __ro_after_init;
 static struct dentry *config __ro_after_init;
+static struct dentry *enforce __ro_after_init;
 static struct dentry *success_audit __ro_after_init;
 
+/**
+ * setenforce: Write handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the write syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t setenforce(struct file *f, const char __user *data,
+			  size_t len, loff_t *offset)
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
+	WRITE_ONCE(ctx->enforce, value);
+	spin_unlock(&ctx->lock);
+	synchronize_rcu();
+
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return len;
+}
+
+/**
+ * getenforce: Read handler for the securityfs node, "ipe/enforce"
+ * @f: Supplies a file structure representing the securityfs node.
+ * @data: Supplies a buffer passed to the read syscall
+ * @len: Supplies the length of @data
+ * @offset: unused.
+ *
+ * Return:
+ * >0 - Success, Length of buffer written
+ * <0 - Error
+ */
+static ssize_t getenforce(struct file *f, char __user *data,
+			  size_t len, loff_t *offset)
+{
+	const char *result;
+	struct ipe_context *ctx;
+
+	ctx = ipe_current_ctx();
+
+	rcu_read_lock();
+	result = ((READ_ONCE(ctx->enforce)) ? "1" : "0");
+	rcu_read_unlock();
+
+	ipe_put_ctx(ctx);
+	return simple_read_from_buffer(data, len, offset, result, 2);
+}
+
 /**
  * setaudit: Write handler for the securityfs node, "ipe/success_audit"
  * @f: Supplies a file structure representing the securityfs node.
@@ -185,6 +250,11 @@ static const struct file_operations np_fops = {
 	.write = new_policy,
 };
 
+static const struct file_operations enforce_fops = {
+	.write = setenforce,
+	.read = getenforce,
+};
+
 static const struct file_operations audit_fops = {
 	.write = setaudit,
 	.read = getaudit,
@@ -230,6 +300,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	enforce = securityfs_create_file("enforce", 0600, root, NULL,
+					 &enforce_fops);
+	if (IS_ERR(enforce)) {
+		rc = PTR_ERR(enforce);
+		goto err;
+	}
+
 	ctx->policy_root = securityfs_create_dir("policies", root);
 	if (IS_ERR(ctx->policy_root)) {
 		rc = PTR_ERR(ctx->policy_root);
@@ -241,6 +318,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(enforce);
 	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
-- 
2.33.0

