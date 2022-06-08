Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF82543BFC
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiFHTBu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbiFHTBs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1610735242;
        Wed,  8 Jun 2022 12:01:46 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 860D220BE670;
        Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 860D220BE670
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714904;
        bh=097dEATcWhLqRc/23Y/0yKACK1hWd9dewZKfKYQTbIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6FdjkgOU1LC1lDib0oDwbnNYP8XgpDgI51UsngPDnC2EdZt8MMt8KjJPLxWptdkz
         9NX5lqmBhBa6KASF6O6O6P3/ejubKLjyGeBeA9IE0lZ6N+RWHDOV/0SAM/MeMwuUYd
         gUEWBmHZE6FHRqxX7qVKyGhan5vNjY/ewjTJQciE=
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
Subject: [RFC PATCH v8 07/17] ipe: add auditing support
Date:   Wed,  8 Jun 2022 12:01:19 -0700
Message-Id: <1654714889-26728-8-git-send-email-deven.desai@linux.microsoft.com>
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

Users of IPE require a way to identify when and why an operation fails,
allowing them to both respond to violations of policy and be notified
of potentially malicious actions on their systens with respect to IPE
itself.

The new 1420 audit, AUDIT_IPE_ACCESS indicates the result of a policy
evaulation of a resource. The other two events, AUDIT_MAC_POLICY_LOAD,
and AUDIT_MAC_CONFIG_CHANGE represent a new policy was loaded into the
kernel and the currently active policy changed, respectively.

This patch also adds support for success auditing, allowing users to
identify how a resource passed policy. It is recommended to use this
option with caution, as it is quite noisy.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

This patch adds the following audit records:

  type=1420 audit(1653364735.161:64):
    rule="DEFAULT op=EXECUTE action=DENY"

  type=1420 audit(1653364370.067:61): path="/root/fs/rw/plain/execve"
    dev="vdc1" ino=16 rule="DEFAULT op=EXECUTE action=DENY"

  type=1405 audit(1653425583.136:54): policy_name="dmverity_roothash"
    policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686

  type=1403 audit(1653425529.927:53): policy_name="dmverity_roothash"
    policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686

This results in the following events (the audit records are always
prior to a SYSCALL record):

  type=1420 audit(1653364735.161:64):
    rule="DEFAULT op=EXECUTE action=DENY"
  type=1300 audit(1653364735.161:64): arch=c000003e syscall=9
    success=no exit=-13 a0=0 a1=1000 a2=4 a3=20 items=0 ppid=455 pid=774
    auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
    tty=ttyS0 ses=3 comm="mmap" exe="/root/host/mmap" subj=kernel
    key=(null)
  audit: type=1327 audit(1653364735.161:64):
    proctitle=686F73742F6D6D617000410058

  type=1420 audit(1653364370.067:61): path="/root/fs/rw/plain/execve"
    dev="vdc1" ino=16 rule="DEFAULT op=EXECUTE action=DENY"
  type=1300 audit(1653364370.067:61): arch=c000003e syscall=10
    success=no exit=-13 a0=7f0bf0644000 a1=4f80 a2=5 a3=7f0bf043d300
    items=0 ppid=455 pid=737 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0
    egid=0 sgid=0 fsgid=0 tty=ttyS0 ses=3 comm="mprotect"
    exe="/root/host/mprotect" subj=kernel key=(null)
  type=1327 audit(1653364370.067:61):
    proctitle=686F73742F6D70726F7465637400534800527C5700527C5800706C61696E2F657865637665

  type=1403 audit(1653425529.927:53): policy_name="dmverity_roothash"
    policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686
  type=1300 audit(1653425529.927:53): arch=c000003e syscall=1
    success=yes exit=6215 a0=1 a1=7f07adfe4000 a2=1847 a3=22 items=0
    ppid=441 pid=445 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=)
  type=1327 audit(1653425529.927:53):
    proctitle=63617400706F6C69636965732F646D7665726974795F726F6F74686173682E706F6C2E703762

  type=1405 audit(1653425583.136:54): policy_name="dmverity_roothash"
    policy_version=0.0.0 sha256=A9C5803309F80D2B84D7C047534BE8B60EF121C8E1F351F2A8EFFA617B7F0686
  type=1300 audit(1653425583.136:54): arch=c000003e syscall=1 success=yes
    exit=2 a0=1 a1=55c1065e5c60 a2=2 a3=7fe683990020 items=0 ppid=405
    pid=441 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 e)
  type=1327 audit(1653425583.136:54): proctitle="-bash"

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
  + Further split lsm creation, the audit system, the evaluation loop,
    and access control hooks into separate patches.
  + Further split audit system patch into two separate patches; one
    for include/uapi, and the usage of the new defines.
  + Split out the permissive functionality into another separate patch,
    for easier review.
  + Correct misuse of audit_log_n_untrusted string to audit_log_format
  + Use get_task_comm instead of comm directly.
  + Quote certain audit values
  + Remove unnecessary help text on choice options - these were previously
    idented at the wrong level
  + Correct a stale string constant (ctx_ns_enforce to ctx_enforce)

v8:

  + Change dependency for CONFIG_AUDIT to CONFIG_AUDITSYSCALL
  + Drop ctx_* prefix
  + Reuse, where appropriate, the audit fields from the field
    dictionary. This transforms:
      ctx_pathname  -> path
      ctx_ino       -> ino
      ctx_dev       -> dev

  + Add audit records and event examples to commit description.
  + Remove new_audit_ctx, replace with audit_log_start. All data that
    would provided by new_audit_ctx is already present in the syscall
    audit record, that is always emitted on these actions. The audit
    records should be correlated as such.
  + Change audit types:
    + AUDIT_TRUST_RESULT                -> AUDIT_IPE_ACCESS
      +  This prevents overloading of the AVC type.
    + AUDIT_TRUST_POLICY_ACTIVATE       -> AUDIT_MAC_CONFIG_CHANGE
    + AUDIT_TRUST_POLICY_LOAD           -> AUDIT_MAC_POLICY_LOAD
      + There were no significant difference in meaning between
        these types.

  + Remove enforcing parameter passed from the context structure
    for AUDIT_IPE_ACCESS.
    +  This field can be inferred from the SYSCALL audit event,
       based on the success field.

  + Remove all fields already captured in the syscall record. "hook",
    an IPE specific field, can be determined via the syscall field in
    the syscall record itself, so it has been removed.
      + ino, path, and dev in IPE's record refer to the subject of the
        syscall, while the syscall record refers to the calling process.

  + remove IPE prefix from policy load/policy activation events
  + fix a bug wherein a policy change audit record was not fired when
    updating a policy
---
 security/ipe/Kconfig              |  55 +++++++++
 security/ipe/Makefile             |   2 +
 security/ipe/audit.c              | 184 ++++++++++++++++++++++++++++++
 security/ipe/audit.h              |  34 ++++++
 security/ipe/ctx.c                |  21 ++++
 security/ipe/ctx.h                |   2 +
 security/ipe/eval.c               |   9 ++
 security/ipe/eval.h               |   7 ++
 security/ipe/fs.c                 |  79 +++++++++++++
 security/ipe/modules/ipe_module.h |   2 +
 10 files changed, 395 insertions(+)
 create mode 100644 security/ipe/audit.c
 create mode 100644 security/ipe/audit.h

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index e4875fb04883..1ad2f34b98ec 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -15,3 +15,58 @@ menuconfig SECURITY_IPE
 	  admins to reconfigure trust requirements on the fly.
 
 	  If unsure, answer N.
+
+if SECURITY_IPE
+
+config IPE_AUDIT
+	bool "Enable IPE's audit events"
+	depends on AUDIT && AUDITSYSCALL
+	help
+	  This option causes IPE to emit audit records on certain key
+	  events during IPE's normal operation. Examples include:
+	  when an action is denied by IPE policy, when a new policy is
+	  loaded, and when a new policy is active. This allows system
+	  admins to analyze what is happening on their systems, and
+	  validate through audit records that IPE is responsible for
+	  certain behaviors.
+
+	  if unsure, answer Y.
+
+choice
+	prompt "Hash algorithm used in auditing policies"
+	default IPE_AUDIT_HASH_SHA1
+	depends on IPE_AUDIT
+	help
+	  Specify the hash algorithm used when auditing policies.
+	  The hash is used to uniquely identify a policy from other
+	  policies on the system.
+
+	  If unsure, leave default.
+
+	config IPE_AUDIT_HASH_SHA1
+		bool "sha1"
+		select CRYPTO_SHA1
+
+	config IPE_AUDIT_HASH_SHA256
+		bool "sha256"
+		select CRYPTO_SHA256
+
+	config IPE_AUDIT_HASH_SHA384
+		bool "sha384"
+		select CRYPTO_SHA512
+
+	config IPE_AUDIT_HASH_SHA512
+		bool "sha512"
+		select CRYPTO_SHA512
+
+endchoice
+
+config IPE_AUDIT_HASH_ALG
+	string
+	depends on IPE_AUDIT
+	default "sha1" if IPE_AUDIT_HASH_SHA1
+	default "sha256" if IPE_AUDIT_HASH_SHA256
+	default "sha384" if IPE_AUDIT_HASH_SHA384
+	default "sha512" if IPE_AUDIT_HASH_SHA512
+
+endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index d5660a17364c..25a7d7c8f07c 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -18,3 +18,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	parsers.o \
 	policy.o \
 	policyfs.o \
+
+obj-$(CONFIG_IPE_AUDIT) += audit.o
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
new file mode 100644
index 000000000000..0442cc51a4bd
--- /dev/null
+++ b/security/ipe/audit.c
@@ -0,0 +1,184 @@
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
+#define ACTSTR(x) ((x) == ipe_action_allow ? "ALLOW" : "DENY")
+
+#define POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
+			CONFIG_IPE_AUDIT_HASH_ALG "="
+
+static const char *const audit_op_names[ipe_operation_max] = {
+	"EXECUTE",
+	"FIRMWARE",
+	"KMODULE",
+	"KEXEC_IMAGE",
+	"KEXEC_INITRAMFS",
+	"IMA_POLICY",
+	"IMA_X509_CERT",
+};
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
+		     enum ipe_action act, const struct ipe_rule *const r)
+{
+	bool success_audit;
+	struct inode *inode;
+	struct audit_buffer *ab;
+	const char *op = audit_op_names[ctx->op];
+
+	rcu_read_lock();
+	success_audit = READ_ONCE(ctx->ci_ctx->success_audit);
+	rcu_read_unlock();
+
+	if (act != ipe_action_deny && !success_audit)
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_IPE_ACCESS);
+	if (!ab)
+		return;
+
+	if (ctx->file) {
+		audit_log_d_path(ab, "path=", &ctx->file->f_path);
+		inode = file_inode(ctx->file);
+		if (inode) {
+			audit_log_format(ab, " dev=");
+			audit_log_untrustedstring(ab, inode->i_sb->s_id);
+			audit_log_format(ab, " ino=%lu ", inode->i_ino);
+		}
+	}
+
+	if (match_type == ipe_match_rule)
+		audit_rule(ab, r);
+	else if (match_type == ipe_match_table)
+		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"", op,
+				 ACTSTR(act));
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
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_CONFIG_CHANGE);
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
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_POLICY_LOAD);
+	if (!ab)
+		return;
+
+	audit_policy(ab, p);
+
+	audit_log_end(ab);
+}
diff --git a/security/ipe/audit.h b/security/ipe/audit.h
new file mode 100644
index 000000000000..bec03208042d
--- /dev/null
+++ b/security/ipe/audit.h
@@ -0,0 +1,34 @@
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
+#ifdef CONFIG_IPE_AUDIT
+void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+		     enum ipe_match match_type,
+		     enum ipe_action act, const struct ipe_rule *const r);
+void ipe_audit_policy_load(const struct ipe_policy *const p);
+void ipe_audit_policy_activation(const struct ipe_policy *const p);
+#else
+static inline void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
+				   enum ipe_match match_type,
+				   enum ipe_action act, const struct ipe_rule *const r)
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
+#endif /* CONFIG_IPE_AUDIT */
+
+#endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index 177f60f02ed4..391c7102e08d 100644
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
@@ -217,6 +221,9 @@ int ipe_replace_policy(struct ipe_policy *old, struct ipe_policy *new)
 	spin_unlock(&ctx->lock);
 	synchronize_rcu();
 
+	if (!rc)
+		ipe_audit_policy_load(new);
+
 	ipe_put_policy(p);
 	ipe_put_ctx(ctx);
 	return rc;
@@ -249,6 +256,7 @@ int ipe_set_active_pol(const struct ipe_policy *p)
 	spin_unlock(&ctx->lock);
 	synchronize_rcu();
 
+	ipe_audit_policy_activation(p);
 out:
 	ipe_put_policy(ap);
 	ipe_put_ctx(ctx);
@@ -314,6 +322,10 @@ int __init ipe_init_ctx(void)
 		goto err;
 	}
 
+	spin_lock(&lns->lock);
+	WRITE_ONCE(lns->success_audit, success_audit);
+	spin_unlock(&lns->lock);
+
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
 
 	return 0;
@@ -321,3 +333,12 @@ int __init ipe_init_ctx(void)
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
index b3e4277fe6bd..fcfa3a37b0ed 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -9,6 +9,7 @@
 #include "hooks.h"
 #include "policy.h"
 #include "modules/ipe_module.h"
+#include "audit.h"
 
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -71,7 +72,9 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 {
 	int rc = 0;
 	bool match = false;
+	bool enforcing = true;
 	enum ipe_action action;
+	enum ipe_match match_type;
 	struct ipe_policy *pol = NULL;
 	const struct ipe_rule *rule = NULL;
 	const struct ipe_policy_mod *module = NULL;
@@ -83,6 +86,7 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 
 	if (ctx->op == ipe_operation_max) {
 		action = pol->parsed->global_default;
+		match_type = ipe_match_global;
 		goto eval;
 	}
 
@@ -100,13 +104,18 @@ static int evaluate(const struct ipe_eval_ctx *const ctx)
 
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
 
 eval:
+	ipe_audit_match(ctx, match_type, action, rule);
+
 	if (action == ipe_action_deny)
 		rc = -EACCES;
 
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index bc3a5da3badc..50bc16b0be25 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -19,6 +19,13 @@ struct ipe_eval_ctx {
 	struct ipe_context *ci_ctx;
 };
 
+enum ipe_match {
+	ipe_match_rule = 0,
+	ipe_match_table,
+	ipe_match_global,
+	ipe_match_max
+};
+
 int ipe_process_event(const struct file *file, enum ipe_operation op);
 
 #endif /* IPE_EVAL_H */
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 18100cfbd8d5..6e28807780c0 100644
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
@@ -155,6 +226,13 @@ static int __init ipe_init_securityfs(void)
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
@@ -166,6 +244,7 @@ static int __init ipe_init_securityfs(void)
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
+	securityfs_remove(success_audit);
 	securityfs_remove(ctx->policy_root);
 	return rc;
 }
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index 1157c5363048..1381ab977da5 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -6,6 +6,7 @@
 #define IPE_MODULE_H
 
 #include <linux/types.h>
+#include <linux/audit.h>
 #include "../eval.h"
 
 /**
@@ -26,6 +27,7 @@ struct ipe_module {
 	void (*free)(void **value);			/* optional */
 	bool (*eval)(const struct ipe_eval_ctx *ctx,	/* required */
 		     const void *val);
+	void (*audit)(struct audit_buffer *ab, const void *val); /* required */
 };
 
 #define IPE_MODULE(parser)				\
-- 
2.25.1

