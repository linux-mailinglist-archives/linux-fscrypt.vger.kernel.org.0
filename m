Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514DA543C35
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiFHTCL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiFHTBr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:47 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4B2F27CC8;
        Wed,  8 Jun 2022 12:01:45 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 529E620BE66D;
        Wed,  8 Jun 2022 12:01:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 529E620BE66D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714904;
        bh=ZUxZBYZW8RxJhh/xTeek6eUhn4hppVGKZXv/5L5vDbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaLdnhKU6eF3snvyXOSVrtylEb30HqI7ylgMQ9DyIROC5NmuhnhfOvtz/91IPRVjn
         LWaaS+PtMUJMKRMiJPDo5jJUj6WpA5QN7SWK4gTnlchDPoyVV9zeO1cSn/E6HON/a6
         c5BUVMVVNFSZsXLkA84l4fzTwZTuihCVnN3AyCps=
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
Subject: [RFC PATCH v8 05/17] ipe: add LSM hooks on execution and kernel read
Date:   Wed,  8 Jun 2022 12:01:17 -0700
Message-Id: <1654714889-26728-6-git-send-email-deven.desai@linux.microsoft.com>
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

IPE's initial goal is to control both execution and the loading of
kernel modules based on the system's definition of trust. It
accomplishes this by plugging into the security hooks for
bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
and kernel_read_data.

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
  + Further split lsm creation, the audit system, the evaluation loop
    and access control hooks into separate commits.

v8:
  + Rename hook functions to follow the lsmname_hook_name convention
  + Remove ipe_hook enumeration, can be derived from correlation with
    syscall audit record.
---
 security/ipe/hooks.c  | 150 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/hooks.h  |  16 +++++
 security/ipe/ipe.c    |   5 ++
 security/ipe/policy.c |  23 +++++++
 security/ipe/policy.h |  12 +++-
 5 files changed, 204 insertions(+), 2 deletions(-)

diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index dd9606962fa5..d20de25bbd40 100644
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
@@ -52,3 +56,149 @@ void ipe_task_free(struct task_struct *task)
 	ipe_put_ctx(ctx);
 	rcu_read_unlock();
 }
+
+/**
+ * ipe_bprm_check_security: LSM hook called when a process is loaded through the exec
+ *		family of system calls.
+ * @bprm: Supplies a pointer to a linux_binprm structure to source the file
+ *	  being evaluated.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_bprm_check_security(struct linux_binprm *bprm)
+{
+	return ipe_process_event(bprm->file, ipe_operation_exec);
+}
+
+/**
+ * ipe_mmap_file: LSM hook called when a file is loaded through the mmap
+ *		  family of system calls.
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
+int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
+		  unsigned long flags)
+{
+	if (prot & PROT_EXEC || reqprot & PROT_EXEC)
+		return ipe_process_event(f, ipe_operation_exec);
+
+	return 0;
+}
+
+/**
+ * ipe_file_mprotect: LSM hook called when a mmap'd region of memory is changing
+ *		      its protections via mprotect.
+ * @vma: Existing virtual memory area created by mmap or similar
+ * @reqprot: The requested protection on the mmap, passed from usermode.
+ * @prot: The effective protection on the mmap, resolved from reqprot and
+ *	  system configuration.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		      unsigned long prot)
+{
+	/* Already Executable */
+	if (vma->vm_flags & VM_EXEC)
+		return 0;
+
+	if (prot & PROT_EXEC)
+		return ipe_process_event(vma->vm_file, ipe_operation_exec);
+
+	return 0;
+}
+
+/**
+ * ipe_kernel_read_file: LSM hook called when a file is being read in from
+ *			 disk.
+ * @file: Supplies a pointer to the file structure being read in from disk
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
+			 bool contents)
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
+	WARN(op == ipe_operation_max, "no rule setup for enum %d", id);
+	return ipe_process_event(file, op);
+}
+
+/**
+ * ipe_kernel_load_data: LSM hook called when a buffer is being read in from
+ *			 disk.
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
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
+	WARN(op == ipe_operation_max, "no rule setup for enum %d", id);
+	return ipe_process_event(NULL, op);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index e0ae3c7dfb5b..fa9e0657bd64 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -5,12 +5,28 @@
 #ifndef IPE_HOOKS_H
 #define IPE_HOOKS_H
 
+#include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/binfmts.h>
+#include <linux/security.h>
 
 int ipe_task_alloc(struct task_struct *task,
 		   unsigned long clone_flags);
 
 void ipe_task_free(struct task_struct *task);
 
+int ipe_bprm_check_security(struct linux_binprm *bprm);
+
+int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
+		  unsigned long flags);
+
+int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		      unsigned long prot);
+
+int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
+			 bool contents);
+
+int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index edeb354765dd..fca7019ca53c 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -27,6 +27,11 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
+	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
+	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
+	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
+	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
+	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
 };
 
 /**
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
index d4bd06e4a19b..8309f9270000 100644
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
2.25.1

