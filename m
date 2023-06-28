Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B57E741A5A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jun 2023 23:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbjF1VKT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 17:10:19 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39534 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjF1VJw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 17:09:52 -0400
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id AE09E20ABD85; Wed, 28 Jun 2023 14:09:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AE09E20ABD85
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1687986588;
        bh=P9//z4a7/H/+tSfGzQBtSqcLlmARCsGSAntXQyaXUmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LZnOYArBT5ZDScOl99IQGl66P+ymYI28Ffg3QYpb1tX+6Hf3PRvQ/q/4AVOxqqIoy
         mc8fHwYy8aMV20XluoSXoOQCmZ+gEIbcKaUHn230UFpj/9g8oco4I6KaS8aquvxbPe
         t86GskoWUzJ2Ho67057HgOUVzeNsZmiYLLVKBrFQ=
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
Subject: [RFC PATCH v10 12/17] ipe: add support for dm-verity as a trust provider
Date:   Wed, 28 Jun 2023 14:09:26 -0700
Message-Id: <1687986571-16823-13-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
---
 security/ipe/Kconfig         |  18 +++++
 security/ipe/Makefile        |   1 +
 security/ipe/audit.c         |  25 ++++++
 security/ipe/digest.c        | 142 +++++++++++++++++++++++++++++++++++
 security/ipe/digest.h        |  26 +++++++
 security/ipe/eval.c          | 101 ++++++++++++++++++++++++-
 security/ipe/eval.h          |  13 ++++
 security/ipe/hooks.c         |  51 +++++++++++++
 security/ipe/hooks.h         |   8 ++
 security/ipe/ipe.c           |  15 ++++
 security/ipe/ipe.h           |   4 +
 security/ipe/policy.h        |   3 +
 security/ipe/policy_parser.c |  21 ++++++
 13 files changed, 427 insertions(+), 1 deletion(-)
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
index 89a76ad72301..ec7f69c34735 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	digest.o \
 	eval.o \
 	fs.o \
 	hooks.o \
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 08f855f70f76..781f98536b35 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -13,6 +13,7 @@
 #include "hooks.h"
 #include "policy.h"
 #include "audit.h"
+#include "digest.h"
 
 #define ACTSTR(x) ((x) == __IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
 
@@ -40,8 +41,29 @@ static const char *const audit_op_names[__IPE_OP_MAX] = {
 static const char *const audit_prop_names[__IPE_PROP_MAX] = {
 	"boot_verified=FALSE",
 	"boot_verified=TRUE",
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
+ * @r: Supplies a pointer to the digest structure.
+ */
+static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
+{
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
@@ -55,6 +77,9 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
 
 	list_for_each_entry(ptr, &r->props, next) {
 		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
+		if (ptr->type == __IPE_PROP_DMV_ROOTHASH)
+			audit_dmv_roothash(ab, ptr->value);
+
 		audit_log_format(ab, " ");
 	}
 
diff --git a/security/ipe/digest.c b/security/ipe/digest.c
new file mode 100644
index 000000000000..7a42ca71880c
--- /dev/null
+++ b/security/ipe/digest.c
@@ -0,0 +1,142 @@
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
+ * @value: Supplies a pointer to be populated with the result.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to parse the digest
+ * consistently. The parsed digest will be saved in @value in IPE's
+ * policy.
+ *
+ * Return:
+ * * 0	- OK
+ * * !0	- Error
+ */
+int ipe_digest_parse(const char *valstr, void **value)
+{
+	char *sep, *raw_digest;
+	size_t raw_digest_len;
+	int rc = 0;
+	u8 *digest = NULL;
+	struct digest_info *info = NULL;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	sep = strchr(valstr, ':');
+	if (!sep) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	info->alg = kstrndup(valstr, sep - valstr, GFP_KERNEL);
+	if (!info->alg) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	raw_digest = sep + 1;
+	raw_digest_len = strlen(raw_digest);
+	info->raw_digest = kstrndup(raw_digest, raw_digest_len, GFP_KERNEL);
+	if (!info->raw_digest) {
+		rc = -ENOMEM;
+		goto err_free_alg;
+	}
+
+	info->digest_len = (raw_digest_len + 1) / 2;
+	digest = kzalloc(info->digest_len, GFP_KERNEL);
+	if (!digest) {
+		rc = -ENOMEM;
+		goto err_free_raw;
+	}
+
+	rc = hex2bin(digest, raw_digest, info->digest_len);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_free_raw;
+	}
+
+	info->digest = digest;
+	*value = info;
+	return 0;
+
+err_free_raw:
+	kfree(info->raw_digest);
+err_free_alg:
+	kfree(info->alg);
+err:
+	kfree(digest);
+	kfree(info);
+	return rc;
+}
+
+/**
+ * ipe_digest_eval - evaluate an IPE digest against another digest.
+ * @expect: Supplies the policy-provided digest value.
+ * @digest: Supplies the digest to compare against the policy digest value.
+ * @digest_len: The length of @digest.
+ * @alg: Supplies the name of the algorithm used to calculated @digest.
+ *
+ * Return:
+ * * true	- digests match
+ * * false	- digests do not match
+ */
+bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
+		     const char *alg)
+{
+	const struct digest_info *info = (struct digest_info *)expect;
+
+	return (digest_len == info->digest_len) && !strcmp(alg, info->alg) &&
+	       (!memcmp(info->digest, digest, info->digest_len));
+}
+
+/**
+ * ipe_digest_free - free an IPE digest.
+ * @value: Supplies a pointer the policy-provided digest value to free.
+ */
+void ipe_digest_free(void **value)
+{
+	struct digest_info *info = (struct digest_info *)(*value);
+
+	if (IS_ERR_OR_NULL(info))
+		return;
+
+	kfree(info->alg);
+	kfree(info->raw_digest);
+	kfree(info->digest);
+	kfree(info);
+}
+
+/**
+ * ipe_digest_audit - audit a digest that was sourced from IPE's policy.
+ * @ab: Supplies the audit_buffer to append the formatted result.
+ * @val: Supplies a pointer to source the audit record from.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to audit the digest
+ * consistently.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+void ipe_digest_audit(struct audit_buffer *ab, const void *val)
+{
+	const struct digest_info *info = (struct digest_info *)val;
+
+	audit_log_untrustedstring(ab, info->alg);
+	audit_log_format(ab, ":");
+	audit_log_untrustedstring(ab, info->raw_digest);
+}
diff --git a/security/ipe/digest.h b/security/ipe/digest.h
new file mode 100644
index 000000000000..e40ba4b2799e
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
+#include "policy.h"
+#include <linux/types.h>
+#include <linux/audit.h>
+
+struct digest_info {
+	const char *alg;
+	const char *raw_digest;
+	const u8 *digest;
+	size_t digest_len;
+};
+
+int ipe_digest_parse(const char *valstr, void **value);
+void ipe_digest_free(void **value);
+void ipe_digest_audit(struct audit_buffer *ab, const void *val);
+bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
+		     const char *alg);
+
+#endif /* _IPE_DIGEST_H */
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 2d4b3a6d7b7a..8ba7d6bd2950 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -17,10 +17,12 @@
 #include "hooks.h"
 #include "policy.h"
 #include "audit.h"
+#include "digest.h"
 
 struct ipe_policy __rcu *ipe_active_policy;
 bool success_audit;
 bool enforce = true;
+#define INO_BLOCK_DEV(ino) ((ino)->i_sb->s_bdev)
 
 static const struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
@@ -60,6 +62,23 @@ static bool from_pinned(const struct super_block *sb)
 	return rv;
 }
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+/**
+ * build_ipe_bdev_ctx - Build ipe_bdev field of an evaluation context.
+ * @ctx: Supplies a pointer to the context to be populdated.
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
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -70,15 +89,89 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    const struct file *file,
 		    enum ipe_op_type op)
 {
+	struct inode *ino = NULL;
+
 	if (op == __IPE_OP_EXEC && file)
 		pin_sb(FILE_SUPERBLOCK(file));
 
 	ctx->file = file;
 	ctx->op = op;
 
-	if (file)
+	if (file) {
 		ctx->from_init_sb = from_pinned(FILE_SUPERBLOCK(file));
+		ino = d_real_inode(file->f_path.dentry);
+		build_ipe_bdev_ctx(ctx, ino);
+	}
+}
+
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
+	       ipe_digest_eval(p->value,
+			       ctx->ipe_bdev->digest,
+			       ctx->ipe_bdev->digest_len,
+			       ctx->ipe_bdev->digest_algo);
+}
+
+/**
+ * evaluate_dmv_sig_false: Analyze @ctx against a dmv sig false property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return !ctx->ipe_bdev || (!ctx->ipe_bdev->dm_verity_signed);
+}
+
+/**
+ * evaluate_dmv_sig_true: Analyze @ctx against a dmv sig true property.
+ * @ctx: Supplies a pointer to the context being evaluated.
+ * @p: Supplies a pointer to the property being evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return ctx->ipe_bdev && (!!ctx->ipe_bdev->dm_verity_signed);
+}
+#else
+static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx,
+				   struct ipe_prop *p)
+{
+	return false;
+}
+
+static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
+				  struct ipe_prop *p)
+{
+	return false;
 }
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 
 /**
  * evaluate_property - Analyze @ctx against a property.
@@ -97,6 +190,12 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 		return !ctx->from_init_sb;
 	case __IPE_PROP_BOOT_VERIFIED_TRUE:
 		return ctx->from_init_sb;
+	case __IPE_PROP_DMV_ROOTHASH:
+		return evaluate_dmv_roothash(ctx, p);
+	case __IPE_PROP_DMV_SIG_FALSE:
+		return evaluate_dmv_sig_false(ctx, p);
+	case __IPE_PROP_DMV_SIG_TRUE:
+		return evaluate_dmv_sig_true(ctx, p);
 	default:
 		return false;
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 15c35921fd4d..746e58b79f2a 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -16,11 +16,24 @@ extern struct ipe_policy __rcu *ipe_active_policy;
 extern bool success_audit;
 extern bool enforce;
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev {
+	bool dm_verity_signed;
+
+	const u8 *digest;
+	size_t digest_len;
+	const char *digest_algo;
+};
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
 	const struct file *file;
 	bool from_init_sb;
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	const struct ipe_bdev *ipe_bdev;
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
 enum ipe_match {
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 6f94f5c8a0c3..9651e582791e 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -7,6 +7,9 @@
 #include <linux/types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
+#include <linux/blk_types.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 #include "ipe.h"
 #include "hooks.h"
@@ -192,3 +195,51 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
 {
 	ipe_invalidate_pinned_sb(mnt_sb);
 }
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
+	kfree(blob->digest);
+	kfree(blob->digest_algo);
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
+
+		blob->digest = kmemdup(digest->digest, digest->digest_len, GFP_KERNEL);
+		if (!blob->digest)
+			return -ENOMEM;
+
+		blob->digest_algo = kstrdup_const(digest->algo, GFP_KERNEL);
+		if (!blob->digest_algo)
+			return -ENOMEM;
+
+		blob->digest_len = digest->digest_len;
+		return 0;
+	} else if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
+		blob->dm_verity_signed = true;
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index ac0cdfd9877f..1d1d30b61f3e 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/device-mapper.h>
 
 int ipe_bprm_check_security(struct linux_binprm *bprm);
 
@@ -24,4 +25,11 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 6f063d51b2af..fa2dcb9fde62 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -5,12 +5,23 @@
 
 #include "ipe.h"
 #include "hooks.h"
+#include "eval.h"
 
 bool ipe_enabled;
 
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	.lbs_bdev = sizeof(struct ipe_bdev),
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 
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
@@ -18,6 +29,10 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
+#endif
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 6dec06403eee..4e8d1a440c4b 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -15,4 +15,8 @@
 
 extern bool ipe_enabled;
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 #endif /* _IPE_H */
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 94bcbbf79b05..42059039bb3d 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -33,6 +33,9 @@ enum ipe_action_type {
 enum ipe_prop_type {
 	__IPE_PROP_BOOT_VERIFIED_FALSE,
 	__IPE_PROP_BOOT_VERIFIED_TRUE,
+	__IPE_PROP_DMV_ROOTHASH,
+	__IPE_PROP_DMV_SIG_FALSE,
+	__IPE_PROP_DMV_SIG_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 28c14adfe6d2..cb87bc3d67fc 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -8,6 +8,7 @@
 
 #include "policy.h"
 #include "policy_parser.h"
+#include "digest.h"
 
 #define START_COMMENT	'#'
 
@@ -216,6 +217,7 @@ static void free_rule(struct ipe_rule *r)
 
 	list_for_each_entry_safe(p, t, &r->props, next) {
 		list_del(&p->next);
+		ipe_digest_free(&p->value);
 		kfree(p);
 	}
 
@@ -268,6 +270,11 @@ static enum ipe_action_type parse_action(char *t)
 static const match_table_t property_tokens = {
 	{__IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
 	{__IPE_PROP_BOOT_VERIFIED_TRUE,		"boot_verified=TRUE"},
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	{__IPE_PROP_DMV_ROOTHASH,		"dmverity_roothash=%s"},
+	{__IPE_PROP_DMV_SIG_FALSE,		"dmverity_signature=FALSE"},
+	{__IPE_PROP_DMV_SIG_TRUE,		"dmverity_signature=TRUE"},
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 	{__IPE_PROP_INVALID,			NULL}
 };
 
@@ -287,6 +294,7 @@ static int parse_property(char *t, struct ipe_rule *r)
 	struct ipe_prop *p = NULL;
 	int rc = 0;
 	int token;
+	char *dup = NULL;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -295,8 +303,20 @@ static int parse_property(char *t, struct ipe_rule *r)
 	token = match_token(t, property_tokens, args);
 
 	switch (token) {
+	case __IPE_PROP_DMV_ROOTHASH:
+		dup = match_strdup(&args[0]);
+		if (!dup) {
+			rc = -ENOMEM;
+			goto err;
+		}
+		rc = ipe_digest_parse(dup, &p->value);
+		if (rc)
+			goto err;
+		fallthrough;
 	case __IPE_PROP_BOOT_VERIFIED_FALSE:
 	case __IPE_PROP_BOOT_VERIFIED_TRUE:
+	case __IPE_PROP_DMV_SIG_FALSE:
+	case __IPE_PROP_DMV_SIG_TRUE:
 		p->type = token;
 		break;
 	case __IPE_PROP_INVALID:
@@ -309,6 +329,7 @@ static int parse_property(char *t, struct ipe_rule *r)
 	list_add_tail(&p->next, &r->props);
 
 out:
+	kfree(dup);
 	return rc;
 err:
 	kfree(p);
-- 
2.25.1

