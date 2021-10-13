Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2342C98D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239243AbhJMTJN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49062 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236935AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id BD16120B9D00;
        Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BD16120B9D00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634151999;
        bh=IxYst3FiNb/kY3ikZe2nWCnkf57ca9R+8i/DDEvqFOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hl3m88SnYHDr7975V7Zl8YyNcB5uZfa1XLHlldlDU+1D3VDPrBpIrkkM61j5j1anq
         0XDaZ+B+jTwDXyRbMBO2Ps0brW3DskGy8QXJcO0PpzVQuJWpYxCj8fFgKqXTxAlFBe
         kDbFcFzu3AsljvRlmzXi8eNmcUDnziTjbaG4Ydtc=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 05/16] ipe: add LSM hooks on execution and kernel read
Date:   Wed, 13 Oct 2021 12:06:24 -0700
Message-Id: <1634151995-16266-6-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE's initial goal is to control both execution and the loading of
kernel modules based on the system's definition of trust. It
accomplishes this by plugging into the security hooks for execve,
mprotect, mmap, kernel_load_data and kernel_read_data.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Split up patch 02/12 into four parts:
      1. context creation [01/16]
      2. audit [07/16]
      3. evaluation loop [03/16]
      4. access control hooks [05/16] (this patch)

---
 security/ipe/hooks.c  | 149 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/hooks.h  |  23 ++++++-
 security/ipe/ipe.c    |   5 ++
 security/ipe/policy.c |  23 +++++++
 security/ipe/policy.h |  12 +++-
 5 files changed, 209 insertions(+), 3 deletions(-)

diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index ed0c886eaa5a..216242408a80 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -6,11 +6,15 @@
 #include "ipe.h"
 #include "ctx.h"
 #include "hooks.h"
+#include "eval.h"
 
+#include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/refcount.h>
 #include <linux/rcupdate.h>
+#include <linux/binfmts.h>
+#include <linux/mman.h>
 
 /**
  * ipe_task_alloc: Assign a new context for an associated task structure.
@@ -56,3 +60,148 @@ void ipe_task_free(struct task_struct *task)
 	ipe_put_ctx(ctx);
 	rcu_read_unlock();
 }
+
+/**
+ * ipe_on_exec: LSM hook called when a process is loaded through the exec
+ *		family of system calls.
+ * @bprm: Supplies a pointer to a linux_binprm structure to source the file
+ *	  being evaluated.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_on_exec(struct linux_binprm *bprm)
+{
+	return ipe_process_event(bprm->file, ipe_operation_exec, ipe_hook_exec);
+}
+
+/**
+ * ipe_on_mmap: LSM hook called when a file is loaded through the mmap
+ *		family of system calls.
+ * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
+ * @reqprot: The requested protection on the mmap, passed from usermode.
+ * @prot: The effective protection on the mmap, resolved from reqprot and
+ *	  system configuration.
+ * @flags: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
+		unsigned long flags)
+{
+	if (prot & PROT_EXEC || reqprot & PROT_EXEC)
+		return ipe_process_event(f, ipe_operation_exec, ipe_hook_mmap);
+
+	return 0;
+}
+
+/**
+ * ipe_on_mprotect: LSM hook called when a mmap'd region of memory is changing
+ *		    its protections via mprotect.
+ * @vma: Existing virtual memory area created by mmap or similar
+ * @reqprot: The requested protection on the mmap, passed from usermode.
+ * @prot: The effective protection on the mmap, resolved from reqprot and
+ *	  system configuration.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		    unsigned long prot)
+{
+	/* Already Executable */
+	if (vma->vm_flags & VM_EXEC)
+		return 0;
+
+	if (((prot & PROT_EXEC) || reqprot & PROT_EXEC))
+		return ipe_process_event(vma->vm_file, ipe_operation_exec,
+					 ipe_hook_mprotect);
+
+	return 0;
+}
+
+/**
+ * ipe_on_kernel_read: LSM hook called when a file is being read in from
+ *		       disk.
+ * @file: Supplies a pointer to the file structure being read in from disk
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
+		       bool contents)
+{
+	enum ipe_operation op;
+
+	switch (id) {
+	case READING_FIRMWARE:
+		op = ipe_operation_firmware;
+		break;
+	case READING_MODULE:
+		op = ipe_operation_kernel_module;
+		break;
+	case READING_KEXEC_INITRAMFS:
+		op = ipe_operation_kexec_initramfs;
+		break;
+	case READING_KEXEC_IMAGE:
+		op = ipe_operation_kexec_image;
+		break;
+	case READING_POLICY:
+		op = ipe_operation_ima_policy;
+		break;
+	case READING_X509_CERTIFICATE:
+		op = ipe_operation_ima_x509;
+		break;
+	default:
+		op = ipe_operation_max;
+	}
+
+	return ipe_process_event(file, op, ipe_hook_kernel_read);
+}
+
+/**
+ * ipe_on_kernel_load_data: LSM hook called when a buffer is being read in from
+ *			    disk.
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents)
+{
+	enum ipe_operation op;
+
+	switch (id) {
+	case LOADING_FIRMWARE:
+		op = ipe_operation_firmware;
+		break;
+	case LOADING_MODULE:
+		op = ipe_operation_kernel_module;
+		break;
+	case LOADING_KEXEC_INITRAMFS:
+		op = ipe_operation_kexec_initramfs;
+		break;
+	case LOADING_KEXEC_IMAGE:
+		op = ipe_operation_kexec_image;
+		break;
+	case LOADING_POLICY:
+		op = ipe_operation_ima_policy;
+		break;
+	case LOADING_X509_CERTIFICATE:
+		op = ipe_operation_ima_x509;
+		break;
+	default:
+		op = ipe_operation_max;
+	}
+
+	return ipe_process_event(NULL, op, ipe_hook_kernel_load);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 58ed4a612e26..c99a0b7f45f7 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -5,11 +5,19 @@
 #ifndef IPE_HOOKS_H
 #define IPE_HOOKS_H
 
+#include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/binfmts.h>
+#include <linux/security.h>
 
 enum ipe_hook {
-	ipe_hook_max = 0
+	ipe_hook_exec = 0,
+	ipe_hook_mmap,
+	ipe_hook_mprotect,
+	ipe_hook_kernel_read,
+	ipe_hook_kernel_load,
+	ipe_hook_max
 };
 
 int ipe_task_alloc(struct task_struct *task,
@@ -17,4 +25,17 @@ int ipe_task_alloc(struct task_struct *task,
 
 void ipe_task_free(struct task_struct *task);
 
+int ipe_on_exec(struct linux_binprm *bprm);
+
+int ipe_on_mmap(struct file *f, unsigned long reqprot, unsigned long prot,
+		unsigned long flags);
+
+int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		    unsigned long prot);
+
+int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id,
+		       bool contents);
+
+int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index b58b372327a1..3f9d43783293 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -25,6 +25,11 @@ struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
+	LSM_HOOK_INIT(bprm_check_security, ipe_on_exec),
+	LSM_HOOK_INIT(mmap_file, ipe_on_mmap),
+	LSM_HOOK_INIT(file_mprotect, ipe_on_mprotect),
+	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
+	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
 };
 
 /**
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index b766824cc08f..048500229365 100644
--- a/security/ipe/policy.c
+++ b/security/ipe/policy.c
@@ -483,6 +483,14 @@ int ipe_parse_op(const struct ipe_policy_token *tok,
 {
 	substring_t match[MAX_OPT_ARGS] = { 0 };
 	const match_table_t ops = {
+		{ ipe_operation_exec,		 "EXECUTE" },
+		{ ipe_operation_firmware,	 "FIRMWARE" },
+		{ ipe_operation_kernel_module,	 "KMODULE" },
+		{ ipe_operation_kexec_image,	 "KEXEC_IMAGE" },
+		{ ipe_operation_kexec_initramfs, "KEXEC_INITRAMFS"},
+		{ ipe_operation_ima_policy,	 "IMA_POLICY" },
+		{ ipe_operation_ima_x509,	 "IMA_X509_CERT" },
+		{ ipe_op_alias_kernel_read,	 "KERNEL_READ" },
 		{ ipe_op_alias_max, NULL },
 	};
 
@@ -838,6 +846,15 @@ static int parse_policy(struct ipe_policy *p)
 	return rc;
 }
 
+static const enum ipe_operation alias_kread[] = {
+	ipe_operation_firmware,
+	ipe_operation_kernel_module,
+	ipe_operation_ima_policy,
+	ipe_operation_ima_x509,
+	ipe_operation_kexec_image,
+	ipe_operation_kexec_initramfs,
+};
+
 /**
  * ipe_is_op_alias: Determine if @op is an alias for one or more operations
  * @op: Supplies the operation to check. Should be either ipe_operation or
@@ -852,9 +869,15 @@ static int parse_policy(struct ipe_policy *p)
 bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size)
 {
 	switch (op) {
+	case ipe_op_alias_kernel_read:
+		*map = alias_kread;
+		*size = ARRAY_SIZE(alias_kread);
+		break;
 	default:
 		return false;
 	}
+
+	return true;
 }
 
 /**
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 6818f6405dd0..ca37af46e5af 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -26,7 +26,14 @@ struct ipe_policy_line {
 struct ipe_module;
 
 enum ipe_operation {
-	ipe_operation_max = 0,
+	ipe_operation_exec = 0,
+	ipe_operation_firmware,
+	ipe_operation_kernel_module,
+	ipe_operation_kexec_image,
+	ipe_operation_kexec_initramfs,
+	ipe_operation_ima_policy,
+	ipe_operation_ima_x509,
+	ipe_operation_max
 };
 
 /*
@@ -34,7 +41,8 @@ enum ipe_operation {
  * that are just one or more operations under the hood
  */
 enum ipe_op_alias {
-	ipe_op_alias_max = ipe_operation_max,
+	ipe_op_alias_kernel_read = ipe_operation_max,
+	ipe_op_alias_max,
 };
 
 enum ipe_action {
-- 
2.33.0

