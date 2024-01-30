Return-Path: <linux-fscrypt+bounces-154-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3726184302F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:40:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B5D51C251CB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6201382878;
	Tue, 30 Jan 2024 22:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WvrXp2Um"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAFF71B49;
	Tue, 30 Jan 2024 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654253; cv=none; b=N1al/wsQN72TuKkPs9H77XNIHfXKF962khawlMx+S6GzRqL8cwNT6TpLLnV4w5+Q+Wm8DERuo1UlwnkwcLRKXSKoaLFBXVVuve5ANvBgrz5lOlWHCO5CY0VVZOTxX91eAzpik9mdzdpTbKldNiXe9Ww7eD0kVoSWA0PTYmQY1JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654253; c=relaxed/simple;
	bh=8ys87+FWcjOtlpDcS14USCvG8Clo2Z/MJzz/ZhuBlEs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=UlfrEDL2dSh9ej99O9XFIu6SMlai5Sy6xOA6RHPaEc0ZSHcq3eoPFGc1Gy/YzN8kibhgPMhvMoVpyjMadRh38ZcOccHys3bt22E2OeaXb5xArD6BktLHtWbIjRQpvAd0MA/wPm/8L6+YtwioxTs3SoMQHt4dsgzeYXVeyinUozQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WvrXp2Um; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id C547D20B201A; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C547D20B201A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=69/j553M2gH3SSN/ELYRwq9FhV89dp0Tjofq4ImyvtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvrXp2UmfPLc6bGa0+Sm+pcvf3EMvzzrkh2/9GPl969wD59Y2aS5wrnTAcoiBWRS2
	 xJa+TCkUI2pLRpG47tAo11j/88Ot5R5nxX7ZI1CZXCr+jPo2JkiagkPkVw2SvpsvEX
	 6/CSXPGQZvuiyJU/+za+QNVyc6OiFhbyvBIXbJxY=
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
Subject: [RFC PATCH v12 15/20] ipe: add support for dm-verity as a trust provider
Date: Tue, 30 Jan 2024 14:37:03 -0800
Message-Id: <1706654228-17180-16-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

Allows author of IPE policy to indicate trust for a singular dm-verity
volume, identified by roothash, through "dmverity_roothash" and all
signed dm-verity volumes, through "dmverity_signature".

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
  + No Changes

v3:
  + No changes

v4:
  + No changes

v5:
  + No changes

v6:
  + Fix an improper cleanup that can result in
    a leak

v7:
  + Squash patch 08/12, 10/12 to [11/16]

v8:
  + Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
    & block/
  + Use common-audit function for dmverity_signature.
  + Change implementation for storing the dm-verity digest to use the
    newly introduced dm_verity_digest structure introduced in patch
    14/20.

v9:
  + Adapt to the new parser

v10:
  + Select the Kconfig when all dependencies are enabled

v11:
  + No changes

v12:
  + Refactor to use struct digest_info* instead of void*
  + Correct audit format
---
 security/ipe/Kconfig         |  18 ++++++
 security/ipe/Makefile        |   1 +
 security/ipe/audit.c         |  37 ++++++++++-
 security/ipe/digest.c        | 120 +++++++++++++++++++++++++++++++++++
 security/ipe/digest.h        |  26 ++++++++
 security/ipe/eval.c          |  90 +++++++++++++++++++++++++-
 security/ipe/eval.h          |  10 +++
 security/ipe/hooks.c         |  67 +++++++++++++++++++
 security/ipe/hooks.h         |   8 +++
 security/ipe/ipe.c           |  15 +++++
 security/ipe/ipe.h           |   4 ++
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |  26 +++++++-
 13 files changed, 421 insertions(+), 4 deletions(-)
 create mode 100644 security/ipe/digest.c
 create mode 100644 security/ipe/digest.h

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index ac4d558e69d5..7afb1ce0cb99 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -8,6 +8,7 @@ menuconfig SECURITY_IPE
 	depends on SECURITY && SECURITYFS && AUDIT && AUDITSYSCALL
 	select PKCS7_MESSAGE_PARSER
 	select SYSTEM_DATA_VERIFICATION
+	select IPE_PROP_DM_VERITY if DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
 	help
 	  This option enables the Integrity Policy Enforcement LSM
 	  allowing users to define a policy to enforce a trust-based access
@@ -15,3 +16,20 @@ menuconfig SECURITY_IPE
 	  admins to reconfigure trust requirements on the fly.
 
 	  If unsure, answer N.
+
+if SECURITY_IPE
+menu "IPE Trust Providers"
+
+config IPE_PROP_DM_VERITY
+	bool "Enable support for dm-verity volumes"
+	depends on DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
+	help
+	  This option enables the properties 'dmverity_signature' and
+	  'dmverity_roothash' in IPE policy. These properties evaluates
+	  to TRUE when a file is evaluated against a dm-verity volume
+	  that was mounted with a signed root-hash or the volume's
+	  root hash matches the supplied value in the policy.
+
+endmenu
+
+endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 2279eaa3cea3..66de53687d11 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	digest.o \
 	eval.o \
 	hooks.o \
 	fs.o \
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index ed390d32c641..a4ad8e888df0 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -13,6 +13,7 @@
 #include "hooks.h"
 #include "policy.h"
 #include "audit.h"
+#include "digest.h"
 
 #define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
 
@@ -54,8 +55,30 @@ static const char *const audit_prop_names[__IPE_PROP_MAX] = {
 	"boot_verified=FALSE",
 	"boot_verified=TRUE",
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	"dmverity_roothash=",
+	"dmverity_signature=FALSE",
+	"dmverity_signature=TRUE",
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * audit_dmv_roothash - audit a roothash of a dmverity volume.
+ * @ab: Supplies a pointer to the audit_buffer to append to.
+ * @rh: Supplies a pointer to the digest structure.
+ */
+static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
+{
+	audit_log_format(ab, "%s", audit_prop_names[IPE_PROP_DMV_ROOTHASH]);
+	ipe_digest_audit(ab, rh);
+}
+#else
+static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * audit_rule - audit an IPE policy rule approximation.
  * @ab: Supplies a pointer to the audit_buffer to append to.
@@ -67,8 +90,18 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 
 	audit_log_format(ab, " rule=\"%s ", audit_op_names[r->op]);
 
-	list_for_each_entry(ptr, &r->props, next)
-		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
+	list_for_each_entry(ptr, &r->props, next) {
+		switch (ptr->type) {
+		case IPE_PROP_DMV_ROOTHASH:
+			audit_dmv_roothash(ab, ptr->value);
+			break;
+		default:
+			audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
+			break;
+		}
+
+		audit_log_format(ab, " ");
+	}
 
 	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
 }
diff --git a/security/ipe/digest.c b/security/ipe/digest.c
new file mode 100644
index 000000000000..f6fde0b1fe74
--- /dev/null
+++ b/security/ipe/digest.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "digest.h"
+
+/**
+ * ipe_digest_parse - parse a digest in IPE's policy.
+ * @valstr: Supplies the string parsed from the policy.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to parse the digest
+ * consistently. The parsed digest will be saved in @value in IPE's
+ * policy.
+ *
+ * Return: The parsed digest_info structure.
+ */
+struct digest_info *ipe_digest_parse(const char *valstr)
+{
+	char *sep, *raw_digest;
+	size_t raw_digest_len;
+	int rc = 0;
+	char *alg = NULL;
+	u8 *digest = NULL;
+	struct digest_info *info = NULL;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	sep = strchr(valstr, ':');
+	if (!sep) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	alg = kstrndup(valstr, sep - valstr, GFP_KERNEL);
+	if (!alg) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	raw_digest = sep + 1;
+	raw_digest_len = strlen(raw_digest);
+
+	info->digest_len = (raw_digest_len + 1) / 2;
+	digest = kzalloc(info->digest_len, GFP_KERNEL);
+	if (!digest) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = hex2bin(digest, raw_digest, info->digest_len);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	info->alg = alg;
+	info->digest = digest;
+	return info;
+
+err:
+	kfree(alg);
+	kfree(digest);
+	kfree(info);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_digest_eval - evaluate an IPE digest against another digest.
+ * @expected: Supplies the policy-provided digest value.
+ * @digest: Supplies the digest to compare against the policy digest value.
+ *
+ * Return:
+ * * true	- digests match
+ * * false	- digests do not match
+ */
+bool ipe_digest_eval(const struct digest_info *expected,
+		     const struct digest_info *digest)
+{
+	return (expected->digest_len == digest->digest_len) &&
+	       (!strcmp(expected->alg, digest->alg)) &&
+	       (!memcmp(expected->digest, digest->digest, expected->digest_len));
+}
+
+/**
+ * ipe_digest_free - free an IPE digest.
+ * @info: Supplies a pointer the policy-provided digest to free.
+ */
+void ipe_digest_free(struct digest_info *info)
+{
+	if (IS_ERR_OR_NULL(info))
+		return;
+
+	kfree(info->alg);
+	kfree(info->digest);
+	kfree(info);
+}
+
+/**
+ * ipe_digest_audit - audit a digest that was sourced from IPE's policy.
+ * @ab: Supplies the audit_buffer to append the formatted result.
+ * @info: Supplies a pointer to source the audit record from.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to audit the digest
+ * consistently.
+ */
+void ipe_digest_audit(struct audit_buffer *ab, const struct digest_info *info)
+{
+	audit_log_untrustedstring(ab, info->alg);
+	audit_log_format(ab, ":");
+	audit_log_n_hex(ab, info->digest, info->digest_len);
+}
diff --git a/security/ipe/digest.h b/security/ipe/digest.h
new file mode 100644
index 000000000000..13fa67071805
--- /dev/null
+++ b/security/ipe/digest.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _IPE_DIGEST_H
+#define _IPE_DIGEST_H
+
+#include <linux/types.h>
+#include <linux/audit.h>
+
+#include "policy.h"
+
+struct digest_info {
+	const char *alg;
+	const u8 *digest;
+	size_t digest_len;
+};
+
+struct digest_info *ipe_digest_parse(const char *valstr);
+void ipe_digest_free(struct digest_info *digest_info);
+void ipe_digest_audit(struct audit_buffer *ab, const struct digest_info *val);
+bool ipe_digest_eval(const struct digest_info *expected,
+		     const struct digest_info *digest);
+
+#endif /* _IPE_DIGEST_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 49338b35f126..4e0fd1dc5808 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -15,10 +15,12 @@
 #include "eval.h"
 #include "policy.h"
 #include "audit.h"
+#include "digest.h"
 
 struct ipe_policy __rcu *ipe_active_policy;
 bool success_audit;
 bool enforce = true;
+#define INO_BLOCK_DEV(ino) ((ino)->i_sb->s_bdev)
 
 #define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
 
@@ -37,6 +39,22 @@ static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const
 {
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * build_ipe_bdev_ctx - Build ipe_bdev field of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populated.
+ * @ino: Supplies the inode struct of the file triggered IPE event.
+ */
+static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+	if (INO_BLOCK_DEV(ino))
+		ctx->ipe_bdev = ipe_bdev(INO_BLOCK_DEV(ino));
+}
+#else
+static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 
 /**
  * build_eval_ctx - Build an evaluation context.
@@ -54,8 +72,10 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 	ctx->op = op;
 	ctx->hook = hook;
 
-	if (file)
+	if (file) {
 		build_ipe_sb_ctx(ctx, file);
+		build_ipe_bdev_ctx(ctx, d_real_inode(file->f_path.dentry));
+	}
 }
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -96,6 +116,68 @@ static bool evaluate_boot_verified_false(const struct ipe_eval_ctx *const ctx)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * evaluate_dmv_roothash - Evaluate @ctx against a dmv roothash property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return !!ctx->ipe_bdev &&
+	       !!ctx->ipe_bdev->root_hash &&
+	       ipe_digest_eval(p->value,
+			       ctx->ipe_bdev->root_hash);
+}
+
+/**
+ * evaluate_dmv_sig_false: Analyze @ctx against a dmv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the property
+ * * false	- The current @ctx doesn't match the property
+ */
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx)
+{
+	return !ctx->ipe_bdev || (!ctx->ipe_bdev->dm_verity_signed);
+}
+
+/**
+ * evaluate_dmv_sig_true: Analyze @ctx against a dmv sig true property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the property
+ * * false	- The current @ctx doesn't match the property
+ */
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx)
+{
+	return !evaluate_dmv_sig_false(ctx);
+}
+#else
+static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -113,6 +195,12 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 		return evaluate_boot_verified_false(ctx);
 	case IPE_PROP_BOOT_VERIFIED_TRUE:
 		return evaluate_boot_verified_true(ctx);
+	case IPE_PROP_DMV_ROOTHASH:
+		return evaluate_dmv_roothash(ctx, p);
+	case IPE_PROP_DMV_SIG_FALSE:
+		return evaluate_dmv_sig_false(ctx);
+	case IPE_PROP_DMV_SIG_TRUE:
+		return evaluate_dmv_sig_true(ctx);
 	default:
 		return false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 84adf1a0e514..2c997d188508 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -24,6 +24,13 @@ struct ipe_sb {
 };
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev {
+	bool dm_verity_signed;
+	struct digest_info *root_hash;
+};
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 	enum ipe_hook_type hook;
@@ -32,6 +39,9 @@ struct ipe_eval_ctx {
 #ifdef CONFIG_BLK_DEV_INITRD
 	bool from_initramfs;
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	const struct ipe_bdev *ipe_bdev;
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
 enum ipe_match {
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index ab762865a671..50c5324dcd92 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -8,10 +8,14 @@
 #include <linux/types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
+#include <linux/blk_types.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 #include "ipe.h"
 #include "hooks.h"
 #include "eval.h"
+#include "digest.h"
 
 /**
  * ipe_bprm_check_security - ipe security hook function for bprm check.
@@ -189,3 +193,66 @@ void ipe_unpack_initramfs(void)
 	ipe_sb(current->fs->root.mnt->mnt_sb)->is_initramfs = true;
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
+
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * ipe_bdev_free_security - free IPE's LSM blob of block_devices.
+ * @bdev: Supplies a pointer to a block_device that contains the structure
+ *	  to free.
+ */
+void ipe_bdev_free_security(struct block_device *bdev)
+{
+	struct ipe_bdev *blob = ipe_bdev(bdev);
+
+	ipe_digest_free(blob->root_hash);
+}
+
+/**
+ * ipe_bdev_setsecurity - save data from a bdev to IPE's LSM blob.
+ * @bdev: Supplies a pointer to a block_device that contains the LSM blob.
+ * @key: Supplies the string key that uniquely identifies the value.
+ * @value: Supplies the value to store.
+ * @len: The length of @value.
+ */
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len)
+{
+	struct ipe_bdev *blob = ipe_bdev(bdev);
+
+	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
+		const struct dm_verity_digest *digest = value;
+		struct digest_info *info = NULL;
+		u8 *raw_digest = NULL;
+		char *alg = NULL;
+
+		info = kzalloc(sizeof(*info), GFP_KERNEL);
+		if (!info)
+			return -ENOMEM;
+
+		raw_digest = kmemdup(digest->digest, digest->digest_len,
+				     GFP_KERNEL);
+		if (!raw_digest)
+			goto err;
+
+		alg = kstrdup(digest->alg, GFP_KERNEL);
+		if (!alg)
+			goto err;
+
+		info->alg = alg;
+		info->digest = raw_digest;
+		info->digest_len = digest->digest_len;
+		blob->root_hash = info;
+		return 0;
+err:
+		kfree(info);
+		kfree(raw_digest);
+		kfree(alg);
+		return -ENOMEM;
+	} else if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
+		blob->dm_verity_signed = true;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 55fc0e35c13d..e114d633dcb4 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/blk_types.h>
 
 enum ipe_hook_type {
 	IPE_HOOK_BPRM_CHECK = 0,
@@ -37,4 +38,11 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 void ipe_unpack_initramfs(void);
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 034ee8cd6802..27a76aeabf1d 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -7,6 +7,7 @@
 #include "ipe.h"
 #include "eval.h"
 #include "hooks.h"
+#include "eval.h"
 
 bool ipe_enabled;
 
@@ -14,6 +15,9 @@ static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 #ifdef CONFIG_BLK_DEV_INITRD
 	.lbs_superblock = sizeof(struct ipe_sb),
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	.lbs_bdev = sizeof(struct ipe_bdev),
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
 static const struct lsm_id ipe_lsmid = {
@@ -28,6 +32,13 @@ struct ipe_sb *ipe_sb(const struct super_block *sb)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev *ipe_bdev(struct block_device *b)
+{
+	return b->security + ipe_blobs.lbs_bdev;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
 	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
@@ -37,6 +48,10 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 #ifdef CONFIG_BLK_DEV_INITRD
 	LSM_HOOK_INIT(unpack_initramfs_security, ipe_unpack_initramfs),
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 1862c710dab8..03dab0dec54a 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -18,4 +18,8 @@ struct ipe_sb *ipe_sb(const struct super_block *sb);
 
 extern bool ipe_enabled;
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 060ffdbc62d6..fa59037c3fa4 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -33,6 +33,9 @@ enum ipe_action_type {
 enum ipe_prop_type {
 	IPE_PROP_BOOT_VERIFIED_FALSE,
 	IPE_PROP_BOOT_VERIFIED_TRUE,
+	IPE_PROP_DMV_ROOTHASH,
+	IPE_PROP_DMV_SIG_FALSE,
+	IPE_PROP_DMV_SIG_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index cce15f0eb645..6cab7eef6052 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -11,6 +11,7 @@
 
 #include "policy.h"
 #include "policy_parser.h"
+#include "digest.h"
 
 #define START_COMMENT	'#'
 #define IPE_POLICY_DELIM " \t"
@@ -216,6 +217,7 @@ static void free_rule(struct ipe_rule *r)
 
 	list_for_each_entry_safe(p, t, &r->props, next) {
 		list_del(&p->next);
+		ipe_digest_free(p->value);
 		kfree(p);
 	}
 
@@ -270,6 +272,11 @@ static const match_table_t property_tokens = {
 	{IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
 	{IPE_PROP_BOOT_VERIFIED_TRUE,	"boot_verified=TRUE"},
 #endif /* CONFIG_BLK_DEV_INITRD */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	{IPE_PROP_DMV_ROOTHASH,		"dmverity_roothash=%s"},
+	{IPE_PROP_DMV_SIG_FALSE,	"dmverity_signature=FALSE"},
+	{IPE_PROP_DMV_SIG_TRUE,		"dmverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 	{IPE_PROP_INVALID,		NULL}
 };
 
@@ -289,6 +296,7 @@ static int parse_property(char *t, struct ipe_rule *r)
 	struct ipe_prop *p = NULL;
 	int rc = 0;
 	int token;
+	char *dup = NULL;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -297,8 +305,22 @@ static int parse_property(char *t, struct ipe_rule *r)
 	token = match_token(t, property_tokens, args);
 
 	switch (token) {
+	case IPE_PROP_DMV_ROOTHASH:
+		dup = match_strdup(&args[0]);
+		if (!dup) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		p->value = ipe_digest_parse(dup);
+		if (IS_ERR(p->value)) {
+			rc = PTR_ERR(p->value);
+			goto err;
+		}
+		fallthrough;
 	case IPE_PROP_BOOT_VERIFIED_FALSE:
 	case IPE_PROP_BOOT_VERIFIED_TRUE:
+	case IPE_PROP_DMV_SIG_FALSE:
+	case IPE_PROP_DMV_SIG_TRUE:
 		p->type = token;
 		break;
 	default:
@@ -309,10 +331,12 @@ static int parse_property(char *t, struct ipe_rule *r)
 		goto err;
 	list_add_tail(&p->next, &r->props);
 
+out:
+	kfree(dup);
 	return rc;
 err:
 	kfree(p);
-	return rc;
+	goto out;
 }
 
 /**
-- 
2.43.0


