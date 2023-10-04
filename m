Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72827B97BF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjJDWKJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjJDWJz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:55 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30F6FE4;
        Wed,  4 Oct 2023 15:09:51 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 5E46A20B74C8; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E46A20B74C8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=wQldn5ra9xhJ9R5r5n7wWEOCqUSx21WzsLRfV1k+lcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXMEJN+OMrf+ea+9L+BZEla2fuc/MhAal7WyZXZwmuRzsMvyVJZlsp9zLyoxOBSQ0
         hxUB2OmmUcicM/u09+st4CIgIhuTzyxaqtFyrnnFoAx90gAYImbDSa5KalBx/covQM
         w8J4Odb/6BRu7jURmvQ6jLrj6IsOJPuilh1NWGk8=
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
Subject: [RFC PATCH v11 04/19] ipe: add LSM hooks on execution and kernel read
Date:   Wed,  4 Oct 2023 15:09:31 -0700
Message-Id: <1696457386-3010-5-git-send-email-wufan@linux.microsoft.com>
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

IPE's initial goal is to control both execution and the loading of
kernel modules based on the system's definition of trust. It
accomplishes this by plugging into the security hooks for
bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
and kernel_read_data.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
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

v9:
  + Minor changes for adapting to the new parser

v10:
  + Remove @reqprot part

v11:
  + Fix code style issues
---
 security/ipe/Makefile |   1 +
 security/ipe/eval.c   |  14 ++++
 security/ipe/eval.h   |   3 +
 security/ipe/hooks.c  | 183 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/hooks.h  |  25 ++++++
 security/ipe/ipe.c    |   6 ++
 6 files changed, 232 insertions(+)
 create mode 100644 security/ipe/hooks.c
 create mode 100644 security/ipe/hooks.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 57fe922cf1fc..d7f2870d7c09 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -7,6 +7,7 @@
 
 obj-$(CONFIG_SECURITY_IPE) += \
 	eval.o \
+	hooks.o \
 	ipe.o \
 	policy.o \
 	policy_parser.o \
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 5533c359bbeb..8a8bcc5c7d7f 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -16,6 +16,20 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 
+/**
+ * build_eval_ctx - Build an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
+ * @file: Supplies a pointer to the file to associated with the evaluation.
+ * @op: Supplies the IPE policy operation associated with the evaluation.
+ */
+void build_eval_ctx(struct ipe_eval_ctx *ctx,
+		    const struct file *file,
+		    enum ipe_op_type op)
+{
+	ctx->file = file;
+	ctx->op = op;
+}
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 6b434515968f..cfdf3c8dfe8a 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -11,6 +11,8 @@
 
 #include "policy.h"
 
+#define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })
+
 extern struct ipe_policy __rcu *ipe_active_policy;
 
 struct ipe_eval_ctx {
@@ -19,6 +21,7 @@ struct ipe_eval_ctx {
 	const struct file *file;
 };
 
+void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
 int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
 
 #endif /* _IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
new file mode 100644
index 000000000000..6164a9b53361
--- /dev/null
+++ b/security/ipe/hooks.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/binfmts.h>
+#include <linux/mman.h>
+
+#include "ipe.h"
+#include "hooks.h"
+#include "eval.h"
+
+/**
+ * ipe_bprm_check_security - ipe security hook function for bprm check.
+ * @bprm: Supplies a pointer to a linux_binprm structure to source the file
+ *	  being evaluated.
+ *
+ * This LSM hook is called when a binary is loaded through the exec
+ * family of system calls.
+ * Return:
+ * *0	- OK
+ * *!0	- Error
+ */
+int ipe_bprm_check_security(struct linux_binprm *bprm)
+{
+	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
+
+	build_eval_ctx(&ctx, bprm->file, IPE_OP_EXEC);
+	return ipe_evaluate_event(&ctx);
+}
+
+/**
+ * ipe_mmap_file - ipe security hook function for mmap check.
+ * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
+ * @reqprot: The requested protection on the mmap, passed from usermode.
+ * @prot: The effective protection on the mmap, resolved from reqprot and
+ *	  system configuration.
+ * @flags: Unused.
+ *
+ * This hook is called when a file is loaded through the mmap
+ * family of system calls.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_mmap_file(struct file *f, unsigned long reqprot __always_unused,
+		  unsigned long prot, unsigned long flags)
+{
+	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
+
+	if (prot & PROT_EXEC) {
+		build_eval_ctx(&ctx, f, IPE_OP_EXEC);
+		return ipe_evaluate_event(&ctx);
+	}
+
+	return 0;
+}
+
+/**
+ * ipe_file_mprotect - ipe security hook function for mprotect check.
+ * @vma: Existing virtual memory area created by mmap or similar.
+ * @reqprot: The requested protection on the mmap, passed from usermode.
+ * @prot: The effective protection on the mmap, resolved from reqprot and
+ *	  system configuration.
+ *
+ * This LSM hook is called when a mmap'd region of memory is changing
+ * its protections via mprotect.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_file_mprotect(struct vm_area_struct *vma,
+		      unsigned long reqprot __always_unused,
+		      unsigned long prot)
+{
+	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
+
+	/* Already Executable */
+	if (vma->vm_flags & VM_EXEC)
+		return 0;
+
+	if (prot & PROT_EXEC) {
+		build_eval_ctx(&ctx, vma->vm_file, IPE_OP_EXEC);
+		return ipe_evaluate_event(&ctx);
+	}
+
+	return 0;
+}
+
+/**
+ * ipe_kernel_read_file - ipe security hook function for kernel read.
+ * @file: Supplies a pointer to the file structure being read in from disk.
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * This LSM hook is called when a file is being read in from disk from
+ * the kernel.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
+			 bool contents)
+{
+	enum ipe_op_type op;
+	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
+
+	switch (id) {
+	case READING_FIRMWARE:
+		op = IPE_OP_FIRMWARE;
+		break;
+	case READING_MODULE:
+		op = IPE_OP_KERNEL_MODULE;
+		break;
+	case READING_KEXEC_INITRAMFS:
+		op = IPE_OP_KEXEC_INITRAMFS;
+		break;
+	case READING_KEXEC_IMAGE:
+		op = IPE_OP_KEXEC_IMAGE;
+		break;
+	case READING_POLICY:
+		op = IPE_OP_IMA_POLICY;
+		break;
+	case READING_X509_CERTIFICATE:
+		op = IPE_OP_IMA_X509;
+		break;
+	default:
+		op = IPE_OP_INVALID;
+		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);
+	}
+
+	build_eval_ctx(&ctx, file, op);
+	return ipe_evaluate_event(&ctx);
+}
+
+/**
+ * ipe_kernel_load_data - ipe security hook function for kernel load data.
+ * @id: Supplies the enumeration identifying the purpose of the read.
+ * @contents: Unused.
+ *
+ * This LSM hook is called when a buffer is being read in from disk.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
+{
+	enum ipe_op_type op;
+	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
+
+	switch (id) {
+	case LOADING_FIRMWARE:
+		op = IPE_OP_FIRMWARE;
+		break;
+	case LOADING_MODULE:
+		op = IPE_OP_KERNEL_MODULE;
+		break;
+	case LOADING_KEXEC_INITRAMFS:
+		op = IPE_OP_KEXEC_INITRAMFS;
+		break;
+	case LOADING_KEXEC_IMAGE:
+		op = IPE_OP_KEXEC_IMAGE;
+		break;
+	case LOADING_POLICY:
+		op = IPE_OP_IMA_POLICY;
+		break;
+	case LOADING_X509_CERTIFICATE:
+		op = IPE_OP_IMA_X509;
+		break;
+	default:
+		op = IPE_OP_INVALID;
+		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);
+	}
+
+	build_eval_ctx(&ctx, NULL, op);
+	return ipe_evaluate_event(&ctx);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
new file mode 100644
index 000000000000..23205452f758
--- /dev/null
+++ b/security/ipe/hooks.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef _IPE_HOOKS_H
+#define _IPE_HOOKS_H
+
+#include <linux/fs.h>
+#include <linux/binfmts.h>
+#include <linux/security.h>
+
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
+#endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index ba5526f9d527..77c950459810 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -4,11 +4,17 @@
  */
 
 #include "ipe.h"
+#include "hooks.h"
 
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 };
 
 static struct security_hook_list ipe_hooks[] __ro_after_init = {
+	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
+	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
+	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
+	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
+	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
 };
 
 /**
-- 
2.25.1

