Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7ECB741A3C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jun 2023 23:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjF1VKb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 17:10:31 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39532 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjF1VJw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 17:09:52 -0400
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id CAA3320ABD91; Wed, 28 Jun 2023 14:09:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CAA3320ABD91
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1687986588;
        bh=kAdzDCOt9XpQRLmAY2ykPG2+n8vU/uwmXic4zxyTdQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QlFlHjT96fwlcrp1LA3zORQDSpjn8b2VC0BwZXYi3pQw3WuA6lyuvrLHiknrxpEWU
         jr4pCy9oHFwsliM2XtUMrXRr01tZzLoTaBzcQkzdj8+fmLAnPQ8eILNxgvyNBk+GPb
         I/wxpqDz6oMqM1H6jPwoz4kJRFnNgfBwAwJcrzO0=
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
        Fan Wu <wufan@linux.microsoft.com>,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: [RFC PATCH v10 14/17] ipe: enable support for fs-verity as a trust provider
Date:   Wed, 28 Jun 2023 14:09:28 -0700
Message-Id: <1687986571-16823-15-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
---
 security/ipe/Kconfig         |  13 +++++
 security/ipe/audit.c         |  23 ++++++++
 security/ipe/eval.c          | 110 +++++++++++++++++++++++++++++++++++
 security/ipe/eval.h          |  10 ++++
 security/ipe/hooks.c         |  30 ++++++++++
 security/ipe/hooks.h         |   7 +++
 security/ipe/ipe.c           |  13 +++++
 security/ipe/ipe.h           |   3 +
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |   8 +++
 10 files changed, 220 insertions(+)

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
index 781f98536b35..25c7cbce3683 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -46,6 +46,11 @@ static const char *const audit_prop_names[__IPE_PROP_MAX] = {
 	"dmverity_signature=FALSE",
 	"dmverity_signature=TRUE",
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	"fsverity_digest=",
+	"fsverity_signature=FALSE",
+	"fsverity_signature=TRUE"
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY
@@ -64,6 +69,22 @@ static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
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
+	ipe_digest_audit(ab, d);
+}
+#else
+static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /**
  * audit_rule - audit an IPE policy rule approximation.
  * @ab: Supplies a pointer to the audit_buffer to append to.
@@ -79,6 +100,8 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
 		if (ptr->type == __IPE_PROP_DMV_ROOTHASH)
 			audit_dmv_roothash(ab, ptr->value);
+		if (ptr->type == __IPE_PROP_FSV_DIGEST)
+			audit_fsv_digest(ab, ptr->value);
 
 		audit_log_format(ab, " ");
 	}
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 8ba7d6bd2950..dd369b38810b 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -79,6 +79,23 @@ static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *con
 }
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
 
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+/**
+ * build_ipe_inode_ctx - Build inode fields of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
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
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -101,6 +118,7 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		ctx->from_init_sb = from_pinned(FILE_SUPERBLOCK(file));
 		ino = d_real_inode(file->f_path.dentry);
 		build_ipe_bdev_ctx(ctx, ino);
+		build_ipe_inode_ctx(ctx, ino);
 	}
 }
 
@@ -173,6 +191,92 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
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
+
+	if (!ctx->ino)
+		return false;
+	if (!fsverity_get_digest((struct inode *)ctx->ino,
+				 digest,
+				 NULL,
+				 &alg)) {
+		return false;
+	}
+
+	return ipe_digest_eval(p->value,
+			       digest,
+			       hash_digest_size[alg],
+			       hash_algo_name[alg]);
+}
+
+/**
+ * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
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
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true - The current @ctx match the @p
+ * * false - The current @ctx doesn't match the @p
+ */
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return ctx->ino &&
+	       IS_VERITY(ctx->ino) &&
+	       ctx->ipe_inode &&
+	       ctx->ipe_inode->fs_verity_signed;
+}
+#else
+static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
+				struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
+
 /**
  * evaluate_property - Analyze @ctx against a property.
  * @ctx: Supplies a pointer to the context to be evaluated.
@@ -196,6 +300,12 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 		return evaluate_dmv_sig_false(ctx, p);
 	case __IPE_PROP_DMV_SIG_TRUE:
 		return evaluate_dmv_sig_true(ctx, p);
+	case __IPE_PROP_FSV_DIGEST:
+		return evaluate_fsv_digest(ctx, p);
+	case __IPE_PROP_FSV_SIG_FALSE:
+		return evaluate_fsv_sig_false(ctx, p);
+	case __IPE_PROP_FSV_SIG_TRUE:
+		return evaluate_fsv_sig_true(ctx, p);
 	default:
 		return false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 746e58b79f2a..89883d8a65aa 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -26,6 +26,12 @@ struct ipe_bdev {
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
 
@@ -34,6 +40,10 @@ struct ipe_eval_ctx {
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
index 9651e582791e..06f279a34083 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -243,3 +243,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
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
index 1d1d30b61f3e..5ac531ddc9da 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/fsverity.h>
 #include <linux/device-mapper.h>
 
 int ipe_bprm_check_security(struct linux_binprm *bprm);
@@ -32,4 +33,10 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
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
index fa2dcb9fde62..1d3d66e1623b 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -13,6 +13,9 @@ static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	.lbs_bdev = sizeof(struct ipe_bdev),
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	.lbs_inode = sizeof(struct ipe_inode),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 #ifdef CONFIG_IPE_PROP_DM_VERITY
@@ -22,6 +25,13 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
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
@@ -33,6 +43,9 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
 	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 #endif
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 4e8d1a440c4b..d32f99350503 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -18,5 +18,8 @@ extern bool ipe_enabled;
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 struct ipe_bdev *ipe_bdev(struct block_device *b);
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+struct ipe_inode *ipe_inode(const struct inode *inode);
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 42059039bb3d..7811d28d5aac 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -36,6 +36,9 @@ enum ipe_prop_type {
 	__IPE_PROP_DMV_ROOTHASH,
 	__IPE_PROP_DMV_SIG_FALSE,
 	__IPE_PROP_DMV_SIG_TRUE,
+	__IPE_PROP_FSV_DIGEST,
+	__IPE_PROP_FSV_SIG_FALSE,
+	__IPE_PROP_FSV_SIG_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index cb87bc3d67fc..93c1b98987a7 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -275,6 +275,11 @@ static const match_table_t property_tokens = {
 	{__IPE_PROP_DMV_SIG_FALSE,		"dmverity_signature=FALSE"},
 	{__IPE_PROP_DMV_SIG_TRUE,		"dmverity_signature=TRUE"},
 #endif /* CONFIG_IPE_PROP_DM_VERITY */
+#ifdef CONFIG_IPE_PROP_FS_VERITY
+	{__IPE_PROP_FSV_DIGEST,			"fsverity_digest=%s"},
+	{__IPE_PROP_FSV_SIG_FALSE,		"fsverity_signature=FALSE"},
+	{__IPE_PROP_FSV_SIG_TRUE,		"fsverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_FS_VERITY */
 	{__IPE_PROP_INVALID,			NULL}
 };
 
@@ -304,6 +309,7 @@ static int parse_property(char *t, struct ipe_rule *r)
 
 	switch (token) {
 	case __IPE_PROP_DMV_ROOTHASH:
+	case __IPE_PROP_FSV_DIGEST:
 		dup = match_strdup(&args[0]);
 		if (!dup) {
 			rc = -ENOMEM;
@@ -317,6 +323,8 @@ static int parse_property(char *t, struct ipe_rule *r)
 	case __IPE_PROP_BOOT_VERIFIED_TRUE:
 	case __IPE_PROP_DMV_SIG_FALSE:
 	case __IPE_PROP_DMV_SIG_TRUE:
+	case __IPE_PROP_FSV_SIG_FALSE:
+	case __IPE_PROP_FSV_SIG_TRUE:
 		p->type = token;
 		break;
 	case __IPE_PROP_INVALID:
-- 
2.25.1

