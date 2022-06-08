Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17B9543BF9
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbiFHTBv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiFHTBs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15C2530565;
        Wed,  8 Jun 2022 12:01:46 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9FA0820BE672;
        Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FA0820BE672
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714904;
        bh=tZ0tEV78U4XYhZBbLbR3cTHG9gHVuXD3NQAKNEzNx7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YeMPHkDt4bj55xtTxzPIYAM5Kuo2SoOVbyr87vnk3y6zKZkbmmHYE1XH4MHiA36k9
         f7cxoLWX5oachgv44CfUQVjxIPKwHPvL+Jba6cZKhs0pIDleR6rsfA/pfr1DY5Vn6A
         ogyap4DaiG1yFJVYlbtTj0nTnlnLLDYub3ROrc5g=
From:   Deven Bowers <deven.desai@linux.microsoft.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v8 08/17] ipe: add permissive toggle
Date:   Wed,  8 Jun 2022 12:01:20 -0700
Message-Id: <1654714889-26728-9-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

IPE, like SELinux, supports a permissive mode. This mode allows policy
authors to test and evaluate IPE policy without it effecting their
programs. When the mode is changed, a 1423 AUDIT_TRUST_STATUS will
be reported.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

---

This patch adds the following audit records:

  type=1404 audit(1653425689.008:55): permissive=1
  type=1404 audit(1653425689.008:55): permissive=0

These records are emitted within the following events:

  type=1404 audit(1653425689.008:55): permissive=1
  type=1300 audit(1653425689.008:55): arch=c000003e syscall=1
    success=yes exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=0 items=0 ppid=405
    pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=)
  type=1327 audit(1653425689.008:55): proctitle="-bash"

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
  + Split out permissive functionality into a separate patch for easier
    review.
  + Remove permissive switch compile-time configuration option - this
    is trivial to add later.

v8:
  + Remove "IPE" prefix from permissive audit record
  + align fields to the linux-audit field dictionary. This causes the
    following fields to change:
      enforce -> permissive

  + Remove duplicated information correlated with syscall record, that
    will always be present in the audit event.
  + Change audit types:
    + AUDIT_TRUST_STATUS -> AUDIT_MAC_STATUS
      + There is no significant difference in meaning between
        these types.
---
 security/ipe/audit.c | 43 ++++++++++++++++++++++++
 security/ipe/audit.h |  5 +++
 security/ipe/ctx.c   |  6 ++++
 security/ipe/ctx.h   |  1 +
 security/ipe/eval.c  |  6 ++++
 security/ipe/fs.c    | 78 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 139 insertions(+)

diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 0442cc51a4bd..cf0ccea32c90 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -182,3 +182,46 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
 
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
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
+	if (!ab)
+		return;
+
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->enforce);
+	rcu_read_unlock();
+
+	audit_log_format(ab, "permissive=%d", !enforcing);
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
+	if (!ipe_enabled)
+		return -EOPNOTSUPP;
+
+	ctx = ipe_current_ctx();
+	ipe_audit_enforce(ctx);
+	ipe_put_ctx(ctx);
+	return 0;
+}
+
+late_initcall(emit_enforcement);
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
index bec03208042d..daff9c801a8e 100644
--- a/security/ipe/audit.h
+++ b/security/ipe/audit.h
@@ -15,6 +15,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 		     enum ipe_action act, const struct ipe_rule *const r);
 void ipe_audit_policy_load(const struct ipe_policy *const p);
 void ipe_audit_policy_activation(const struct ipe_policy *const p);
+void ipe_audit_enforce(const struct ipe_context *const ctx);
 #else
 static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 				   enum ipe_match match_type,
@@ -29,6 +30,10 @@ static inline void ipe_audit_policy_load(const struct ipe_policy *const p)
 static inline void ipe_audit_policy_activation(const struct ipe_policy *const p)
 {
 }
+
+static inline void ipe_audit_enforce(const struct ipe_context *const ctx)
+{
+}
 #endif /* CONFIG_IPE_AUDIT */
 
 #endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 391c7102e08d..ee3cb2bd6028 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -16,6 +16,7 @@
 #include <linux/moduleparam.h>
 
 static bool success_audit;
+static bool enforce = true;
 
 /**
  * ver_to_u64: convert an internal ipe_policy_version to a u64
@@ -135,6 +136,7 @@ static struct ipe_context *create_ctx(void)
 	INIT_LIST_HEAD(&ctx->policies);
 	refcount_set(&ctx->refcount, 1);
 	spin_lock_init(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, true);
 
 	return ctx;
 
@@ -324,6 +326,7 @@ int __init ipe_init_ctx(void)
 
 	spin_lock(&lns->lock);
 	WRITE_ONCE(lns->success_audit, success_audit);
+	WRITE_ONCE(lns->enforce, enforce);
 	spin_unlock(&lns->lock);
 
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
@@ -342,3 +345,6 @@ int __init ipe_init_ctx(void)
 
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
index fcfa3a37b0ed..eafa670558e3 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -84,6 +84,10 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (!pol)
 		goto out;
 
+	rcu_read_lock();
+	enforcing = READ_ONCE(ctx->ci_ctx->enforce);
+	rcu_read_unlock();
+
 	if (ctx->op == ipe_operation_max) {
 		action = pol->parsed->global_default;
 		match_type = ipe_match_global;
@@ -119,6 +123,8 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
+	if (!enforcing)
+		rc = 0;
 out:
 	ipe_put_policy(pol);
 	return rc;
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 6e28807780c0..f4d32f84c945 100644
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
@@ -233,6 +303,13 @@ static int __init ipe_init_securityfs(void)
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
@@ -244,6 +321,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(enforce);
 	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
-- 
2.25.1

