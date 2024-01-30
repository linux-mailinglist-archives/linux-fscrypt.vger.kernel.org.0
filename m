Return-Path: <linux-fscrypt+bounces-156-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C7F843037
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:40:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3FA42887F5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B4883CAB;
	Tue, 30 Jan 2024 22:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="E+/7IrVK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F9813F007;
	Tue, 30 Jan 2024 22:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654253; cv=none; b=bcHq/y12JShmrpFC+yglNkm4IQG3quZz0E6YVK/yDN2+qy4WnibxzCq3pax7QLXk04Td0rLSBOB3zDoKfWRlQuz53vfbkgaociW04/dqrf/OBdO+Bv/S+/gUiLMdoqYD9yXYqARhQzU3lhujRYvqqFt8Cide00I/ogyDP+bv87s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654253; c=relaxed/simple;
	bh=47d0KOwUo8zvzqM68yv/pcsfRHIoam5Yl/1T2vYHCXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Nn9Y3MqRaRVQlEGnJA+J6lwG7O/CQfeojJTYCgwuokUtGXhNhFUhO+ubgoWb2WsZSiyjMKikqk+KFrRvy4VlizK0qzM8dsWgMtoSIoqnA2+T4Vl1b9nael4wVV1DvOqes4Uz0KjxxufMrSEMlvbvc0leMgb5CGh+HULE9DiBgmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=E+/7IrVK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id E231820B201E; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E231820B201E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=90YQ8e6N1UBebdYnb2d4lQ/x9uyYXZ0yeECAtCrXLzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+/7IrVKUFsqF2Kut8Y0t1WCscAseVjaXnLRo5RKBrHIrDjIDk39JMyWI/jS7sXXv
	 6yVFdqMoRm49y9y2vTwrGBbgBaawFbaUlyEZ3mQ3Vb75469hPd0ZeGddonlmPfWReR
	 7lmaX5OWXoOYLKVTQHIy/9kkR7klf9IbXjL5PQRg=
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
Subject: [RFC PATCH v12 17/20] ipe: enable support for fs-verity as a trust provider
Date: Tue, 30 Jan 2024 14:37:05 -0800
Message-Id: <1706654228-17180-18-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

Enable IPE policy authors to indicate trust for a singular fsverity
file, identified by the digest information, through "fsverity_digest"
and all files using fsverity's builtin signatures via
"fsverity_signature".

This enables file-level integrity claims to be expressed in IPE,
allowing individual files to be authorized, giving some flexibility
for policy authors. Such file-level claims are important to be expressed
for enforcing the integrity of packages, as well as address some of the
scalability issues in a sole dm-verity based solution (# of loop back
devices, etc).

This solution cannot be done in userspace as the minimum threat that
IPE should mitigate is an attacker downloads malicious payload with
all required dependencies. These dependencies can lack the userspace
check, bypassing the protection entirely. A similar attack succeeds if
the userspace component is replaced with a version that does not
perform the check. As a result, this can only be done in the common
entry point - the kernel.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v6:
  + Not present

v7:
  Introduced

v8:
  * Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
  * Use common-audit function for fsverity_signature.
  + Change fsverity implementation to use fsverity_get_digest
  + prevent unnecessary copy of fs-verity signature data, instead
    just check for presence of signature data.
  + Remove free_inode_security hook, as the digest is now acquired
    at runtime instead of via LSM blob.

v9:
  + Adapt to the new parser

v10:
  + Update the fsverity get digest call

v11:
  + No changes

v12:
  + Fix audit format
  + Simplify property evaluation
---
 security/ipe/Kconfig         |  13 +++++
 security/ipe/audit.c         |  25 ++++++++
 security/ipe/eval.c          | 108 ++++++++++++++++++++++++++++++++++-
 security/ipe/eval.h          |  10 ++++
 security/ipe/hooks.c         |  30 ++++++++++
 security/ipe/hooks.h         |   7 +++
 security/ipe/ipe.c           |  13 +++++
 security/ipe/ipe.h           |   3 +
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |   8 +++
 10 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 7afb1ce0cb99..9dd5c4769d79 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
 	  that was mounted with a signed root-hash or the volume's
 	  root hash matches the supplied value in the policy.
 
+	  If unsure, answer Y.
+
+config IPE_PROP_FS_VERITY
+	bool "Enable property for fs-verity files"
+	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
+	help
+	  This option enables the usage of properties "fsverity_signature"
+	  and "fsverity_digest". These properties evaluates to TRUE when
+	  a file is fsverity enabled and with a signed digest or its
+	  diegst matches the supplied value in the policy.
+
+	  if unsure, answer Y.
+
 endmenu
 
 endif
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index a4ad8e888df0..7e3372be3214 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -60,6 +60,11 @@ static const char *const audit_prop_names[__IPE_PROP_MAX] = {
 	"dmverity_signature=FALSE",
 	"dmverity_signature=TRUE",
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	"fsverity_digest=",
+	"fsverity_signature=FALSE",
+	"fsverity_signature=TRUE",
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY
@@ -79,6 +84,23 @@ static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * audit_fsv_digest - audit a digest of a fsverity file.
+ * @ab: Supplies a pointer to the audit_buffer to append to.
+ * @d: Supplies a pointer to the digest structure.
+ */
+static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
+{
+	audit_log_format(ab, "%s", audit_prop_names[IPE_PROP_FSV_DIGEST]);
+	ipe_digest_audit(ab, d);
+}
+#else
+static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
+{
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * audit_rule - audit an IPE policy rule approximation.
  * @ab: Supplies a pointer to the audit_buffer to append to.
@@ -95,6 +117,9 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 		case IPE_PROP_DMV_ROOTHASH:
 			audit_dmv_roothash(ab, ptr->value);
 			break;
+		case IPE_PROP_FSV_DIGEST:
+			audit_fsv_digest(ab, ptr->value);
+			break;
 		default:
 			audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
 			break;
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4e0fd1dc5808..b31f39e44b09 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
+#include <linux/fsverity.h>
 
 #include "ipe.h"
 #include "eval.h"
@@ -56,6 +57,23 @@ static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *con
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * build_ipe_inode_ctx - Build inode fields of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populated.
+ * @ino: Supplies the inode struct of the file triggered IPE event.
+ */
+static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+	ctx->ino = ino;
+	ctx->ipe_inode = ipe_inode(ctx->ino);
+}
+#else
+static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
+{
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populated.
@@ -68,13 +86,17 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    enum ipe_op_type op,
 		    enum ipe_hook_type hook)
 {
+	struct inode *ino;
+
 	ctx->file = file;
 	ctx->op = op;
 	ctx->hook = hook;
 
 	if (file) {
 		build_ipe_sb_ctx(ctx, file);
-		build_ipe_bdev_ctx(ctx, d_real_inode(file->f_path.dentry));
+		ino = d_real_inode(file->f_path.dentry);
+		build_ipe_bdev_ctx(ctx, ino);
+		build_ipe_inode_ctx(ctx, ino);
 	}
 }
 
@@ -178,6 +200,84 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx)
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * evaluate_fsv_digest - Analyze @ctx against a fsv digest property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
+				struct ipe_prop *p)
+{
+	enum hash_algo alg;
+	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];
+	struct digest_info info;
+
+	if (!ctx->ino)
+		return false;
+	if (!fsverity_get_digest((struct inode *)ctx->ino,
+				 digest,
+				 NULL,
+				 &alg))
+		return false;
+
+	info.alg = hash_algo_name[alg];
+	info.digest = digest;
+	info.digest_len = hash_digest_size[alg];
+
+	return ipe_digest_eval(p->value, &info);
+}
+
+/**
+ * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the property
+ * * false	- The current @ctx doesn't match the property
+ */
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx)
+{
+	return !ctx->ino ||
+	       !IS_VERITY(ctx->ino) ||
+	       !ctx->ipe_inode ||
+	       !ctx->ipe_inode->fs_verity_signed;
+}
+
+/**
+ * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ *
+ * Return:
+ * * true - The current @ctx match the property
+ * * false - The current @ctx doesn't match the property
+ */
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx)
+{
+	return !evaluate_fsv_sig_false(ctx);
+}
+#else
+static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
+				struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx)
+{
+	return false;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -201,6 +301,12 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 		return evaluate_dmv_sig_false(ctx);
 	case IPE_PROP_DMV_SIG_TRUE:
 		return evaluate_dmv_sig_true(ctx);
+	case IPE_PROP_FSV_DIGEST:
+		return evaluate_fsv_digest(ctx, p);
+	case IPE_PROP_FSV_SIG_FALSE:
+		return evaluate_fsv_sig_false(ctx);
+	case IPE_PROP_FSV_SIG_TRUE:
+		return evaluate_fsv_sig_true(ctx);
 	default:
 		return false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 2c997d188508..d1b3015f4443 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -31,6 +31,12 @@ struct ipe_bdev {
 };
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode {
+	bool fs_verity_signed;
+};
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 	enum ipe_hook_type hook;
@@ -42,6 +48,10 @@ struct ipe_eval_ctx {
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	const struct ipe_bdev *ipe_bdev;
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	const struct inode *ino;
+	const struct ipe_inode *ipe_inode;
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 enum ipe_match {
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 50c5324dcd92..64c1fa7de9aa 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -256,3 +256,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 	return -EOPNOTSUPP;
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * ipe_inode_setsecurity - Sets fields of a inode security blob from @key.
+ * @inode: The inode to source the security blob from.
+ * @name: The name representing the information to be stored.
+ * @value: The value to be stored.
+ * @size: The size of @value.
+ * @flags: unused
+ *
+ * Saves fsverity signature & digest into inode security blob
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags)
+{
+	struct ipe_inode *inode_sec = ipe_inode(inode);
+
+	if (!strcmp(name, FS_VERITY_INODE_SEC_NAME)) {
+		inode_sec->fs_verity_signed = size > 0 && value;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_CONFIG_IPE_PROP_FS_VERITY */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index e114d633dcb4..ba3b961cda05 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -9,6 +9,7 @@
 #include <linux/binfmts.h>
 #include <linux/security.h>
 #include <linux/blk_types.h>
+#include <linux/fsverity.h>
 
 enum ipe_hook_type {
 	IPE_HOOK_BPRM_CHECK = 0,
@@ -45,4 +46,10 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 			 const void *value, size_t len);
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags);
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 27a76aeabf1d..e1eeb0646bf1 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -18,6 +18,9 @@ static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	.lbs_bdev = sizeof(struct ipe_bdev),
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	.lbs_inode = sizeof(struct ipe_inode),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 static const struct lsm_id ipe_lsmid = {
@@ -39,6 +42,13 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode *ipe_inode(const struct inode *inode)
+{
+	return inode->i_security + ipe_blobs.lbs_inode;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
 	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
@@ -52,6 +62,9 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
 	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 03dab0dec54a..e504e5ae275a 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -21,5 +21,8 @@ extern bool ipe_enabled;
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 struct ipe_bdev *ipe_bdev(struct block_device *b);
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode *ipe_inode(const struct inode *inode);
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index fa59037c3fa4..9fecfc8e42bd 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -36,6 +36,9 @@ enum ipe_prop_type {
 	IPE_PROP_DMV_ROOTHASH,
 	IPE_PROP_DMV_SIG_FALSE,
 	IPE_PROP_DMV_SIG_TRUE,
+	IPE_PROP_FSV_DIGEST,
+	IPE_PROP_FSV_SIG_FALSE,
+	IPE_PROP_FSV_SIG_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 6cab7eef6052..5c721e801cd7 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -277,6 +277,11 @@ static const match_table_t property_tokens = {
 	{IPE_PROP_DMV_SIG_FALSE,	"dmverity_signature=FALSE"},
 	{IPE_PROP_DMV_SIG_TRUE,		"dmverity_signature=TRUE"},
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	{IPE_PROP_FSV_DIGEST,		"fsverity_digest=%s"},
+	{IPE_PROP_FSV_SIG_FALSE,	"fsverity_signature=FALSE"},
+	{IPE_PROP_FSV_SIG_TRUE,		"fsverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 	{IPE_PROP_INVALID,		NULL}
 };
 
@@ -306,6 +311,7 @@ static int parse_property(char *t, struct ipe_rule *r)
 
 	switch (token) {
 	case IPE_PROP_DMV_ROOTHASH:
+	case IPE_PROP_FSV_DIGEST:
 		dup = match_strdup(&args[0]);
 		if (!dup) {
 			rc = -ENOMEM;
@@ -321,6 +327,8 @@ static int parse_property(char *t, struct ipe_rule *r)
 	case IPE_PROP_BOOT_VERIFIED_TRUE:
 	case IPE_PROP_DMV_SIG_FALSE:
 	case IPE_PROP_DMV_SIG_TRUE:
+	case IPE_PROP_FSV_SIG_FALSE:
+	case IPE_PROP_FSV_SIG_TRUE:
 		p->type = token;
 		break;
 	default:
-- 
2.43.0


