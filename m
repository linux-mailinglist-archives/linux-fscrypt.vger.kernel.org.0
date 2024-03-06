Return-Path: <linux-fscrypt+bounces-217-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ADD874405
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C066B2160E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Mar 2024 23:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001461CFAD;
	Wed,  6 Mar 2024 23:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="XEUz8GMf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54191CA89;
	Wed,  6 Mar 2024 23:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709768094; cv=none; b=aaI6C5csO7GYBwNkfVjkX4YorvhKWx25f/jl2sLmm4/cPXwhX6JQlKNkT+iqDA7DUHpdI70bHeDJ5BQuhJ116SwBKvfgqvlMAy4LvYLI82MgfO0DyAVam2fI8cV0B/QFGRuhUY1aBXQT5m5yqvBFB85M+ewbLrsl8nYVwqkZjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709768094; c=relaxed/simple;
	bh=4scSE670252E8slNKNx17nqUTAN0WHYncBvv5HhNM8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=o4X4xXsGW7dDi7lpMWLZ1idPJjV6E7KqPQ8S5UDzkTHzPDMHX6TuxelZmNdRFUKSLQIGX4vl6CBJ8e/S5f4ukFbzC4jvm44lyQjmLJSwP9bXazFn5yZs+FhmRjxHuPuAE4QV0iA0/jXyCUqJh5+OfDWGnmUerNdumcHDJ69bTKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=XEUz8GMf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 2865920B74C7; Wed,  6 Mar 2024 15:34:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2865920B74C7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709768092;
	bh=oU2gJaZ/tDQpMjRyUo3UsUFt3eRpWD/7YstqSsv343I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEUz8GMfkqsUXKtseK18A58yoyVpMsFPxB1NVMcV2kATbwwLruGxG/QjVvzmbgOlr
	 2eYPwn2otHT2mRoBp5BeJf1t92nInT/QbNDUa8hgsVXbDBoYYyaPWNsFDZVL7CfPaj
	 Za8pVoWp8MbqFhcFIpVptnxZqbFXP0sTQDOxast8=
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
Subject: [RFC PATCH v14 04/19] ipe: add LSM hooks on execution and kernel read
Date: Wed,  6 Mar 2024 15:34:29 -0800
Message-Id: <1709768084-22539-5-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

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

v12:
  + Correct WARN usages

v13:
  + No changes

v14:
  + No changes
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
index af56815ed0fa..4f425afffcad 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -16,6 +16,20 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 
+/**
+ * build_eval_ctx - Build an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populated.
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
index 000000000000..3aec88c074e1
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
+		op = IPE_OP_POLICY;
+		break;
+	case READING_X509_CERTIFICATE:
+		op = IPE_OP_X509;
+		break;
+	default:
+		op = IPE_OP_INVALID;
+		WARN(1, "no rule setup for kernel_read_file enum %d", id);
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
+		op = IPE_OP_POLICY;
+		break;
+	case LOADING_X509_CERTIFICATE:
+		op = IPE_OP_X509;
+		break;
+	default:
+		op = IPE_OP_INVALID;
+		WARN(1, "no rule setup for kernel_load_data enum %d", id);
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
index b013aed15e73..22bd95116087 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -5,6 +5,7 @@
 #include <uapi/linux/lsm.h>
 
 #include "ipe.h"
+#include "hooks.h"
 
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 };
@@ -15,6 +16,11 @@ static const struct lsm_id ipe_lsmid = {
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
2.43.1


