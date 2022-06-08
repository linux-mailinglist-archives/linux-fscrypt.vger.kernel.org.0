Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43857543BE9
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiFHTBr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiFHTBp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:45 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30D8714009;
        Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id DAA5620BE667;
        Wed,  8 Jun 2022 12:01:43 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DAA5620BE667
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714903;
        bh=1SiiYimQcqYRBp1qt8JULwbnP1Gb1rebprFnuMnL+V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IH62JZdmU7Q943+JIx4WoNXPBzoXhpUvPyP0gd441zvbM5nXsBFXmc7Xa2qiN2c+7
         yPZHd7ArSjRwCRPxkhlq7JM7hwqpe0YweKbaQsQRlNdIFGrP70jOjZ3ubgIS0hqs3I
         Bet06BpeXlaXNWdyjLDGYsgTM4naiYc6O3ZPG8ZE=
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
Subject: [RFC PATCH v8 01/17] security: add ipe lsm & initial context creation
Date:   Wed,  8 Jun 2022 12:01:13 -0700
Message-Id: <1654714889-26728-2-git-send-email-deven.desai@linux.microsoft.com>
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

Integrity Policy Enforcement (IPE) is an LSM that provides an
complimentary approach to Mandatory Access Control than existing LSMs
today.

Existing LSMs have centered around the concept of access to a resource
should be controlled by the current user's credentials. IPE's approach,
is that access to a resource should be controlled by the system's trust
of a current resource.

The basis of this approach is that every process in the kernel is
associated with a context that determines the policy for what is
trusted by said process and its descendents, starting with 'init'.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
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

  + Introduce the concept of an ipe_context, a scoped way to
    introduce execution policies, used initially for allowing for
    kunit tests in isolation.

v8:
  + Follow lsmname_hook_name convention for lsm hooks.
  + Move LSM blob accessors to ipe.c and mark LSM blobs as static.
---
 MAINTAINERS           |   6 ++
 security/Kconfig      |  11 ++--
 security/Makefile     |   1 +
 security/ipe/Kconfig  |  17 +++++
 security/ipe/Makefile |  11 ++++
 security/ipe/ctx.c    | 145 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/ctx.h    |  28 ++++++++
 security/ipe/hooks.c  |  54 ++++++++++++++++
 security/ipe/hooks.h  |  16 +++++
 security/ipe/ipe.c    |  73 +++++++++++++++++++++
 security/ipe/ipe.h    |  17 +++++
 11 files changed, 374 insertions(+), 5 deletions(-)
 create mode 100644 security/ipe/Kconfig
 create mode 100644 security/ipe/Makefile
 create mode 100644 security/ipe/ctx.c
 create mode 100644 security/ipe/ctx.h
 create mode 100644 security/ipe/hooks.c
 create mode 100644 security/ipe/hooks.h
 create mode 100644 security/ipe/ipe.c
 create mode 100644 security/ipe/ipe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a6d3bd9d2a8d..965fdac6d609 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9793,6 +9793,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 F:	security/integrity/ima/
 F:	security/integrity/
 
+INTEGRITY POLICY ENFORCEMENT (IPE)
+M:	Deven Bowers <deven.desai@linux.microsoft.com>
+M:	Fan Wu <wufan@linux.microsoft.com>
+S:	Supported
+F:	security/ipe/
+
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/security/Kconfig b/security/Kconfig
index f29e4c656983..7d4c641313ca 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -218,6 +218,7 @@ source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
 source "security/landlock/Kconfig"
+source "security/ipe/Kconfig"
 
 source "security/integrity/Kconfig"
 
@@ -257,11 +258,11 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf,ipe" if DEFAULT_SECURITY_SMACK
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf,ipe" if DEFAULT_SECURITY_APPARMOR
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf,ipe" if DEFAULT_SECURITY_TOMOYO
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf,ipe" if DEFAULT_SECURITY_DAC
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf,ipe"
 	help
 	  A comma-separated list of LSMs, in initialization order.
 	  Any LSMs left off this list will be ignored. This can be
diff --git a/security/Makefile b/security/Makefile
index 18121f8f85cd..527b1864d96c 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
 obj-$(CONFIG_CGROUPS)			+= device_cgroup.o
 obj-$(CONFIG_BPF_LSM)			+= bpf/
 obj-$(CONFIG_SECURITY_LANDLOCK)		+= landlock/
+obj-$(CONFIG_SECURITY_IPE)		+= ipe/
 
 # Object integrity file lists
 obj-$(CONFIG_INTEGRITY)			+= integrity/
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
new file mode 100644
index 000000000000..e4875fb04883
--- /dev/null
+++ b/security/ipe/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Integrity Policy Enforcement (IPE) configuration
+#
+
+menuconfig SECURITY_IPE
+	bool "Integrity Policy Enforcement (IPE)"
+	depends on SECURITY && SECURITYFS
+	select PKCS7_MESSAGE_PARSER
+	select SYSTEM_DATA_VERIFICATION
+	help
+	  This option enables the Integrity Policy Enforcement LSM
+	  allowing users to define a policy to enforce a trust-based access
+	  control. A key feature of IPE is a customizable policy to allow
+	  admins to reconfigure trust requirements on the fly.
+
+	  If unsure, answer N.
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
new file mode 100644
index 000000000000..ba3df729e252
--- /dev/null
+++ b/security/ipe/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+obj-$(CONFIG_SECURITY_IPE) += \
+	ctx.o \
+	hooks.o \
+	ipe.o \
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
new file mode 100644
index 000000000000..d51fe2e13ad9
--- /dev/null
+++ b/security/ipe/ctx.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/parser.h>
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+
+/**
+ * ipe_current_ctx: Helper to retrieve the ipe_context for the current task.
+ *
+ * Return:
+ *	See ipe_get_ctx_rcu
+ */
+struct ipe_context *ipe_current_ctx(void)
+{
+	return ipe_get_ctx_rcu(*ipe_tsk_ctx(current));
+}
+
+/**
+ * ipe_get_ctx_rcu: Retrieve the underlying ipe_context in an rcu protected
+ *		    address space.
+ * @ctx: Context to dereference.
+ *
+ * This function will increment the reference count of the dereferenced
+ * ctx, ensuring that it is valid outside of the rcu_read_lock.
+ *
+ * However, if a context has a reference count of 0 (and thus being)
+ * freed, this API will return NULL.
+ *
+ * Return:
+ *	!NULL - Valid context
+ *	NULL - the dereferenced context will not exist outside after the
+ *	       next grace period.
+ */
+struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx)
+{
+	struct ipe_context *rv = NULL;
+
+	rcu_read_lock();
+
+	rv = rcu_dereference(ctx);
+	if (!rv || !refcount_inc_not_zero(&rv->refcount))
+		rv = NULL;
+
+	rcu_read_unlock();
+
+	return rv;
+}
+
+/**
+ * free_ctx_work: Worker function to deallocate a context structure.
+ * @work: work_struct passed to schedule_work
+ */
+static void free_ctx_work(struct work_struct *const work)
+{
+	struct ipe_context *ctx = NULL;
+
+	ctx = container_of(work, struct ipe_context, free_work);
+
+	kfree(ctx);
+}
+
+/**
+ * create_ctx: Allocate a context structure.
+ *
+ * The reference count at this point will be set to 1.
+ *
+ * Return:
+ * !IS_ERR - OK
+ * ERR_PTR(-ENOMEM) - Lack of memory.
+ */
+static struct ipe_context *create_ctx(void)
+{
+	int rc = 0;
+	struct ipe_context *ctx = NULL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	INIT_WORK(&ctx->free_work, free_ctx_work);
+	refcount_set(&ctx->refcount, 1);
+	spin_lock_init(&ctx->lock);
+
+	return ctx;
+
+err:
+	ipe_put_ctx(ctx);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_put_ctx: Decrement the reference of an ipe_context structure,
+ *	       scheduling a free as necessary.
+ * @ctx: Structure to free
+ *
+ * This function no-ops on error and null values for @ctx, and the
+ * deallocation will only occur if the refcount is 0.
+ */
+void ipe_put_ctx(struct ipe_context *ctx)
+{
+	if (IS_ERR_OR_NULL(ctx) || !refcount_dec_and_test(&ctx->refcount))
+		return;
+
+	schedule_work(&ctx->free_work);
+}
+
+/**
+ * ipe_init_ctx: Initialize the init context.
+ *
+ * This is called at LSM init, and marks the kernel init process
+ * with a context. All processes descendent from kernel
+ * init will inherit this context.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM: Not enough memory to allocate the init context.
+ */
+int __init ipe_init_ctx(void)
+{
+	int rc = 0;
+	struct ipe_context *lns = NULL;
+
+	lns = create_ctx();
+	if (IS_ERR(lns)) {
+		rc = PTR_ERR(lns);
+		goto err;
+	}
+
+	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
+
+	return 0;
+err:
+	ipe_put_ctx(lns);
+	return rc;
+}
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
new file mode 100644
index 000000000000..69a2c92c0a8c
--- /dev/null
+++ b/security/ipe/ctx.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_CONTEXT_H
+#define IPE_CONTEXT_H
+
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+struct ipe_context {
+	refcount_t refcount;
+	/* Protects concurrent writers */
+	spinlock_t lock;
+
+	struct work_struct free_work;
+};
+
+int __init ipe_init_ctx(void);
+struct ipe_context __rcu **ipe_tsk_ctx(struct task_struct *tsk);
+struct ipe_context *ipe_current_ctx(void);
+struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx);
+void ipe_put_ctx(struct ipe_context *ctx);
+
+#endif /* IPE_CONTEXT_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
new file mode 100644
index 000000000000..dd9606962fa5
--- /dev/null
+++ b/security/ipe/hooks.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+#include "hooks.h"
+
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/rcupdate.h>
+
+/**
+ * ipe_task_alloc: Assign a new context for an associated task structure.
+ * @task: Supplies the task structure to assign a context to.
+ * @clone_flags: unused.
+ *
+ * The context assigned is always the context of the current task.
+ * Reference counts are dropped by ipe_task_free
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Out of Memory
+ */
+int ipe_task_alloc(struct task_struct *task, unsigned long clone_flags)
+{
+	struct ipe_context __rcu **ctx = NULL;
+	struct ipe_context *current_ctx = NULL;
+
+	current_ctx = ipe_current_ctx();
+	ctx = ipe_tsk_ctx(task);
+	rcu_assign_pointer(*ctx, current_ctx);
+	refcount_inc(&current_ctx->refcount);
+
+	ipe_put_ctx(current_ctx);
+	return 0;
+}
+
+/**
+ * ipe_task_free: Drop a reference to an ipe_context associated with @task.
+ *		  If there are no tasks remaining, the context is freed.
+ * @task: Supplies the task to drop an ipe_context reference to.
+ */
+void ipe_task_free(struct task_struct *task)
+{
+	struct ipe_context *ctx;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(*ipe_tsk_ctx(task));
+	ipe_put_ctx(ctx);
+	rcu_read_unlock();
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
new file mode 100644
index 000000000000..e0ae3c7dfb5b
--- /dev/null
+++ b/security/ipe/hooks.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_HOOKS_H
+#define IPE_HOOKS_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+
+int ipe_task_alloc(struct task_struct *task,
+		   unsigned long clone_flags);
+
+void ipe_task_free(struct task_struct *task);
+
+#endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
new file mode 100644
index 000000000000..8a1e0b1c7240
--- /dev/null
+++ b/security/ipe/ipe.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+#include "hooks.h"
+
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/rcupdate.h>
+#include <linux/lsm_hooks.h>
+
+static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
+	.lbs_task = sizeof(struct ipe_context __rcu *),
+};
+
+static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
+	LSM_HOOK_INIT(task_free, ipe_task_free),
+};
+
+/**
+ * ipe_tsk_ctx: Retrieve the RCU-protected address of the task
+ *		that contains the ipe_context.
+ * @tsk: Task to retrieve the address from.
+ *
+ * Callers need to use the rcu* family functions to interact with
+ * the ipe_context, or ipe_get_ctx_rcu.
+ *
+ * Return:
+ *	Valid Address to a location containing an RCU-protected ipe_context.
+ */
+struct ipe_context __rcu **ipe_tsk_ctx(struct task_struct *tsk)
+{
+	return tsk->security + ipe_blobs.lbs_task;
+}
+
+/**
+ * ipe_init: Entry point of IPE.
+ *
+ * This is called at LSM init, which happens occurs early during kernel
+ * start up. During this phase, IPE loads the properties compiled into
+ * the kernel, and register's IPE's hooks. The boot policy is loaded
+ * later, during securityfs init, at which point IPE will start
+ * enforcing its policy.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Context creation failed.
+ */
+static int __init ipe_init(void)
+{
+	int rc = 0;
+
+	rc = ipe_init_ctx();
+	if (rc)
+		return rc;
+
+	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
+
+	return rc;
+}
+
+DEFINE_LSM(ipe) = {
+	.name = "ipe",
+	.init = ipe_init,
+	.blobs = &ipe_blobs,
+};
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
new file mode 100644
index 000000000000..152ae28f3cdd
--- /dev/null
+++ b/security/ipe/ipe.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_H
+#define IPE_H
+
+#define pr_fmt(fmt) "IPE " fmt "\n"
+
+#include "ctx.h"
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/lsm_hooks.h>
+
+#endif /* IPE_H */
-- 
2.25.1

