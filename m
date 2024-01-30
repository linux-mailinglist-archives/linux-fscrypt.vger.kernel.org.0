Return-Path: <linux-fscrypt+bounces-144-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF4F842FE9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AE63B24452
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B44141984;
	Tue, 30 Jan 2024 22:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aad2sg6m"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8DF7AE64;
	Tue, 30 Jan 2024 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654247; cv=none; b=Y+kN0W49NOARe4+3qVu0t03h0GEv6+6bFvdCib9hYSlXWl6IP+ew5HAkyTYhjyqwVDhnvuGRG5lOuODUScCVNv6OQb2/ZbnaEWGJ69QkBH6faj1MRnLfYhVasreztcqWTJx4nd/gkKevuXk2qRGUNfEBLbR1Mux/TzEtzGlnzS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654247; c=relaxed/simple;
	bh=gVHsfI1hdXwrv55SKZ9DjXOQ0gJJG8eF5axil3JDPBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pCkhd7h2Zi3YomvJYi7QY7a6ITm8UJuhv5ZxUGkSpI2+E6oZxk54lWfz3+J/9vWao10r7J4RCoXkpS8RI5fH9q3pGV9MmzvFJ/ycEdSolxei+9giQY/0RfblKmTnvIYMWAcJi3kFFczZf/fsFFYnm1yVw66WUl2+YPse6+2bsjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=aad2sg6m; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 41B9820B2009; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 41B9820B2009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=Dj7s7TKXi7tggAz1EoYiw6d0qfj1qjT6bJT1M8cM8Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aad2sg6mVx63/2SuqPTZ+/kwX8UoafaWW8I8HcARCS0tENmj0EsigABKRd5dGUIp7
	 3E0Ug4XwKU4lLcSzRgL7BRZ42vF/SG20nESiS8jdfsunJ2pmT83ociEPYNngZx8GQv
	 0c1rzH9qY/ityAnsWul/qG2lsnq6iL3JHrG6RqG0=
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
	Fan Wu <wufan@linux.microsoft.com>,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: [RFC PATCH v12 06/20] ipe: introduce 'boot_verified' as a trust provider
Date: Tue, 30 Jan 2024 14:36:54 -0800
Message-Id: <1706654228-17180-7-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

IPE is designed to provide system level trust guarantees, this usually
implies that trust starts from bootup with a hardware root of trust,
which validates the bootloader. After this, the bootloader verifies
the kernel and the initramfs.

As there's no currently supported integrity method for initramfs, and
it's typically already verified by the bootloader. This patch introduces
a new IPE property `boot_verified` which allows author of IPE policy to
indicate trust for files from initramfs.

The implementation of this feature utilizes the newly added
`unpack_initramfs` hook. This hook marks the superblock of the rootfs
after the initramfs has been unpacked into it.

Since the rootfs is never unmounted during system operation, it is
advised to switch to a different policy that doesn't rely on the
`boot_verified` property after the real rootfs is in charge.
This ensures that the trust policies remain relevant and effective
throughout the system's operation.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  +No Changes

v3:
  + Remove useless caching system
  + Move ipe_load_properties to this match
  + Minor changes from checkpatch --strict warnings

v4:
  + Remove comments from headers that was missed previously.
  + Grammatical corrections.

v5:
  + No significant changes

v6:
  + No changes

v7:
  + Reword and refactor patch 04/12 to [09/16], based on changes in
the underlying system.
  + Add common audit function for boolean values
  + Use common audit function as implementation.

v8:
  + No changes

v9:
  + No changes

v10:
  + Replace struct file with struct super_block

v11:
  + Fix code style issues

v12:
  + Switch to use unpack_initramfs hook and security blob
---
 security/ipe/eval.c          | 68 +++++++++++++++++++++++++++++++++++-
 security/ipe/eval.h          |  9 +++++
 security/ipe/hooks.c         |  8 +++++
 security/ipe/hooks.h         |  4 +++
 security/ipe/ipe.c           | 14 ++++++++
 security/ipe/ipe.h           |  3 ++
 security/ipe/policy.h        |  2 ++
 security/ipe/policy_parser.c | 37 +++++++++++++++++++-
 8 files changed, 143 insertions(+), 2 deletions(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4f425afffcad..546bbc52a071 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -16,6 +16,24 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+#ifdef CONFIG_BLK_DEV_INITRD
+/**
+ * build_ipe_sb_ctx - Build from_initramfs field of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populated.
+ * @file: Supplies the file struct of the file triggered IPE event.
+ */
+static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const file)
+{
+	ctx->from_initramfs = ipe_sb(FILE_SUPERBLOCK(file))->is_initramfs;
+}
+#else
+static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const file)
+{
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populated.
@@ -28,8 +46,49 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 {
 	ctx->file = file;
 	ctx->op = op;
+
+	if (file)
+		build_ipe_sb_ctx(ctx, file);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+/**
+ * evaluate_boot_verified_true - Evaluate @ctx for the boot verified property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_boot_verified_true(const struct ipe_eval_ctx *const ctx)
+{
+	return ctx->from_initramfs;
 }
 
+/**
+ * evaluate_boot_verified_false - Evaluate @ctx for the boot verified property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_boot_verified_false(const struct ipe_eval_ctx *const ctx)
+{
+	return !evaluate_boot_verified_true(ctx);
+}
+#else
+static bool evaluate_boot_verified_true(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+
+static bool evaluate_boot_verified_false(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -42,7 +101,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 			      struct ipe_prop *p)
 {
-	return false;
+	switch (p->type) {
+	case IPE_PROP_BOOT_VERIFIED_FALSE:
+		return evaluate_boot_verified_false(ctx);
+	case IPE_PROP_BOOT_VERIFIED_TRUE:
+		return evaluate_boot_verified_true(ctx);
+	default:
+		return false;
+	}
 }
 
 /**
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index cfdf3c8dfe8a..7d79fdb63bbf 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -15,10 +15,19 @@
 
 extern struct ipe_policy __rcu *ipe_active_policy;
 
+#ifdef CONFIG_BLK_DEV_INITRD
+struct ipe_sb {
+	bool is_initramfs;
+};
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
 	const struct file *file;
+#ifdef CONFIG_BLK_DEV_INITRD
+	bool from_initramfs;
+#endif /* CONFIG_BLK_DEV_INITRD */
 };
 
 void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 3aec88c074e1..8ee105bf7bad 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
@@ -181,3 +182,10 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 	build_eval_ctx(&ctx, NULL, op);
 	return ipe_evaluate_event(&ctx);
 }
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void ipe_unpack_initramfs(void)
+{
+	ipe_sb(current->fs->root.mnt->mnt_sb)->is_initramfs = true;
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 23205452f758..3b1bb0a6e89c 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -22,4 +22,8 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 
 int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+#ifdef CONFIG_BLK_DEV_INITRD
+void ipe_unpack_initramfs(void);
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 22bd95116087..ed3acf6174d8 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -5,9 +5,13 @@
 #include <uapi/linux/lsm.h>
 
 #include "ipe.h"
+#include "eval.h"
 #include "hooks.h"
 
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
+#ifdef CONFIG_BLK_DEV_INITRD
+	.lbs_superblock = sizeof(struct ipe_sb),
+#endif /* CONFIG_BLK_DEV_INITRD */
 };
 
 static const struct lsm_id ipe_lsmid = {
@@ -15,12 +19,22 @@ static const struct lsm_id ipe_lsmid = {
 	.id = LSM_ID_IPE,
 };
 
+#ifdef CONFIG_BLK_DEV_INITRD
+struct ipe_sb *ipe_sb(const struct super_block *sb)
+{
+	return sb->s_security + ipe_blobs.lbs_superblock;
+}
+#endif /* CONFIG_BLK_DEV_INITRD */
+
 static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
 	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
 	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
+#ifdef CONFIG_BLK_DEV_INITRD
+	LSM_HOOK_INIT(unpack_initramfs_security, ipe_unpack_initramfs),
+#endif /* CONFIG_BLK_DEV_INITRD */
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index a1c68d0fc2e0..f1e7c3222b6d 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -12,5 +12,8 @@
 #define pr_fmt(fmt) "IPE: " fmt
 
 #include <linux/lsm_hooks.h>
+#ifdef CONFIG_BLK_DEV_INITRD
+struct ipe_sb *ipe_sb(const struct super_block *sb);
+#endif /* CONFIG_BLK_DEV_INITRD */
 
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index fb906f41522b..fb48024bb63e 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -30,6 +30,8 @@ enum ipe_action_type {
 #define IPE_ACTION_INVALID __IPE_ACTION_MAX
 
 enum ipe_prop_type {
+	IPE_PROP_BOOT_VERIFIED_FALSE,
+	IPE_PROP_BOOT_VERIFIED_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 612839b405f4..cce15f0eb645 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -265,6 +265,14 @@ static enum ipe_action_type parse_action(char *t)
 	return match_token(t, action_tokens, args);
 }
 
+static const match_table_t property_tokens = {
+#ifdef CONFIG_BLK_DEV_INITRD
+	{IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
+	{IPE_PROP_BOOT_VERIFIED_TRUE,	"boot_verified=TRUE"},
+#endif /* CONFIG_BLK_DEV_INITRD */
+	{IPE_PROP_INVALID,		NULL}
+};
+
 /**
  * parse_property - Parse the property type given a token string.
  * @t: Supplies the token string to be parsed.
@@ -277,7 +285,34 @@ static enum ipe_action_type parse_action(char *t)
  */
 static int parse_property(char *t, struct ipe_rule *r)
 {
-	return -EBADMSG;
+	substring_t args[MAX_OPT_ARGS];
+	struct ipe_prop *p = NULL;
+	int rc = 0;
+	int token;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	token = match_token(t, property_tokens, args);
+
+	switch (token) {
+	case IPE_PROP_BOOT_VERIFIED_FALSE:
+	case IPE_PROP_BOOT_VERIFIED_TRUE:
+		p->type = token;
+		break;
+	default:
+		rc = -EBADMSG;
+		break;
+	}
+	if (rc)
+		goto err;
+	list_add_tail(&p->next, &r->props);
+
+	return rc;
+err:
+	kfree(p);
+	return rc;
 }
 
 /**
-- 
2.43.0


