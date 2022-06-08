Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E88B543C32
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiFHTCL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiFHTBt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C186C3BBCD;
        Wed,  8 Jun 2022 12:01:46 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 15F0E20BE67A;
        Wed,  8 Jun 2022 12:01:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 15F0E20BE67A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714905;
        bh=oeE34hsi22VsTSnTBMX6qjlgjST1eR6y3tPGNEqqWQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNsXqHwbMwOALbJFvt/MLvJHIWrtaMJyB0gqqAZbQM8HiYhan3RMmL/iaUTzdW2Cv
         FVL9P6f/64BBCLyNW/gJpb1ipngMkIjmJWxBrMPQei3/NbiLNnVQgAWv42nD+TiDdx
         25L5e4lKRVltBXOuOMb4povlXNLuyl0QxSvZW4Lg=
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
Subject: [RFC PATCH v8 12/17] ipe: add support for dm-verity as a trust provider
Date:   Wed,  8 Jun 2022 12:01:24 -0700
Message-Id: <1654714889-26728-13-git-send-email-deven.desai@linux.microsoft.com>
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

Allows author of IPE policy to indicate trust for a singular dm-verity
volume, identified by roothash, through "dmverity_roothash" and all
signed dm-verity volumes, through "dmverity_signature".

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
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
  + Undo squash of 08/12, 10/12 - separating drivers/md/ from security/ & block/
  + Use common-audit function for dmverity_signature.
  + Change implementation for storing the dm-verity digest to use the
    newly introduced dm_verity_digest structure introduced in patch
    14/20.
---
 security/ipe/eval.c                       |   5 +
 security/ipe/eval.h                       |  11 ++
 security/ipe/hooks.c                      |  51 +++++++++
 security/ipe/hooks.h                      |   6 +
 security/ipe/ipe.c                        |   9 ++
 security/ipe/ipe.h                        |   3 +
 security/ipe/modules.c                    | 133 ++++++++++++++++++++++
 security/ipe/modules/Kconfig              |  23 ++++
 security/ipe/modules/Makefile             |   2 +
 security/ipe/modules/dmverity_roothash.c  |  31 +++++
 security/ipe/modules/dmverity_signature.c |  26 +++++
 security/ipe/modules/ipe_module.h         |   5 +
 12 files changed, 305 insertions(+)
 create mode 100644 security/ipe/modules/dmverity_roothash.c
 create mode 100644 security/ipe/modules/dmverity_signature.c

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index ccf9b843040b..9b29d83cd466 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -23,6 +23,7 @@ static struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
 
 #define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+#define FILE_BLOCK_DEV(f) (FILE_SUPERBLOCK(f)->s_bdev)
 
 /**
  * pin_sb: pin the underlying superblock of @f, marking it as trusted
@@ -93,6 +94,10 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->op = op;
 	ctx->ci_ctx = ipe_current_ctx();
 	ctx->from_init_sb = from_pinned(file);
+	if (file) {
+		if (FILE_BLOCK_DEV(file))
+			ctx->ipe_bdev = ipe_bdev(FILE_BLOCK_DEV(file));
+	}
 
 	return ctx;
 }
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index f195671eaa8f..57b7b2b424f8 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -8,17 +8,28 @@
 
 #include <linux/file.h>
 #include <linux/types.h>
+#include <crypto/hash_info.h>
 
 #include "ctx.h"
 #include "hooks.h"
 #include "policy.h"
 
+struct ipe_bdev {
+	bool dm_verity_signed;
+
+	const u8       *digest;
+	size_t		digest_len;
+	const char     *digest_algo;
+};
+
 struct ipe_eval_ctx {
 	enum ipe_operation op;
 
 	const struct file *file;
 	struct ipe_context *ci_ctx;
 
+	const struct ipe_bdev *ipe_bdev;
+
 	bool from_init_sb;
 };
 
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 4dc7b0c0fd31..1072ee5bb8f6 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -13,8 +13,11 @@
 #include <linux/types.h>
 #include <linux/refcount.h>
 #include <linux/rcupdate.h>
+#include <linux/blk_types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 /**
  * ipe_task_alloc: Assign a new context for an associated task structure.
@@ -216,3 +219,51 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
 {
 	ipe_invalidate_pinned_sb(mnt_sb);
 }
+
+/**
+ * ipe_bdev_free_security: free nested structures within IPE's LSM blob
+ *			   in block_devices
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
+ * ipe_bdev_setsecurity: associate some data from the block device layer
+ *			 with IPE's LSM blob.
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
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 43d5b2fe67fd..0d1589e47f8f 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/device-mapper.h>
 
 int ipe_task_alloc(struct task_struct *task,
 		   unsigned long clone_flags);
@@ -31,4 +32,9 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
 
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index d52ad248dfd3..398014ac6004 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -9,6 +9,7 @@
 #include "ipe_parser.h"
 #include "modules/ipe_module.h"
 #include "modules.h"
+#include "eval.h"
 
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -22,8 +23,14 @@ bool ipe_enabled;
 
 static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 	.lbs_task = sizeof(struct ipe_context __rcu *),
+	.lbs_bdev = sizeof(struct ipe_bdev),
 };
 
+struct ipe_bdev *ipe_bdev(struct block_device *b)
+{
+	return b->security + ipe_blobs.lbs_bdev;
+}
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
@@ -33,6 +40,8 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index de0629bd7061..df2b56d8b5e9 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/blk_types.h>
 #include <linux/lsm_hooks.h>
 
 extern bool ipe_enabled;
@@ -21,4 +22,6 @@ extern bool ipe_enabled;
 extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
 extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+
 #endif /* IPE_H */
diff --git a/security/ipe/modules.c b/security/ipe/modules.c
index 30346f7ad35c..673752a58505 100644
--- a/security/ipe/modules.c
+++ b/security/ipe/modules.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/rbtree.h>
+#include <crypto/hash_info.h>
 
 static struct rb_root module_root = RB_ROOT;
 
@@ -108,6 +109,12 @@ int ipe_register_module(struct ipe_module *m)
 	return 0;
 }
 
+struct digest_info {
+	const char     *alg;
+	const u8       *digest;
+	size_t		digest_len;
+};
+
 /**
  * ipe_bool_parse: parse a boolean in IPE's policy and associate
  *		   it as @value in IPE's policy.
@@ -137,3 +144,129 @@ void ipe_bool_audit(struct audit_buffer *ab, const void *val)
 {
 	audit_log_format(ab, "%s", ((bool)val) ? "TRUE" : "FALSE");
 }
+
+/**
+ * ipe_digest_parse: parse a digest in IPE's policy and associate
+ *		     it as @value in IPE's policy.
+ * @valstr: Supplies the string parsed from the policy
+ * @value: Supplies a pointer to be populated with the result.
+ *
+ * Digests in IPE are defined in a standard way:
+ *	<alg_name>:<hex>
+ *
+ * Use this function to create a property to parse the digest
+ * consistently.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_digest_parse(const char *valstr, void **value)
+{
+	char *sep;
+	int rc = 0;
+	u8 *digest = NULL;
+	struct digest_info *info;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		rc = -ENOMEM;
+		goto err;
+	}
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
+	info->digest_len = strlen(sep) / 2;
+	digest = kzalloc(info->digest_len, GFP_KERNEL);
+	if (!digest) {
+		rc = -ENOMEM;
+		goto err_free_info;
+	}
+
+	rc = hex2bin(digest, ++sep, info->digest_len);
+	if (rc < 0) {
+		rc = -EINVAL;
+		goto err_free_info;
+	}
+
+	info->digest = digest;
+	*value = info;
+	return 0;
+
+err_free_info:
+	kfree(info->alg);
+err:
+	kfree(digest);
+	kfree(info);
+	return rc;
+}
+
+/**
+ * ipe_digest_audit: audit a digest that was sourced from IPE's
+ *		     policy.
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
+	audit_log_format(ab, "%s:", info->alg);
+	audit_log_n_hex(ab, info->digest, info->digest_len);
+}
+
+/**
+ * ipe_digest_eval: evaluate an IPE digest against another digest.
+ * @expect: Supplies the policy-provided digest value.
+ * @digest: Supplies the digest to compare against the policy digest value.
+ * @digest_len: The length of @digest
+ * @alg: Supplies the name of the algorithm used to calculated @digest.
+ *
+ * Return:
+ * true - digests match
+ * false - digests do not match
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
+ * ipe_digest_free: evaluate an IPE digest against another digest.
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
+	kfree(info->digest);
+	kfree(info);
+}
diff --git a/security/ipe/modules/Kconfig b/security/ipe/modules/Kconfig
index fad96ba534e2..a6ea06cf0737 100644
--- a/security/ipe/modules/Kconfig
+++ b/security/ipe/modules/Kconfig
@@ -16,5 +16,28 @@ config IPE_PROP_BOOT_VERIFIED
 
 	  If unsure, answer N.
 
+config IPE_PROP_DM_VERITY_SIGNATURE
+	bool "Enable support for signed dm-verity volumes"
+	depends on DM_VERITY_VERIFY_ROOTHASH_SIG
+	default Y
+	help
+	  This option enables the property 'dmverity_signature' in
+	  IPE policy. This property evaluates to TRUE when a file
+	  is evaluated against a dm-verity volume that was mounted
+	  with a signed root-hash.
+
+	  If unsure, answer Y.
+
+config IPE_PROP_DM_VERITY_ROOTHASH
+	bool "Enable support for dm-verity volumes"
+	depends on DM_VERITY
+	default Y
+	help
+	  This option enables the property 'dmverity_roothash' in
+	  IPE policy. This property evaluates to TRUE when a file
+	  is evaluated against a dm-verity volume whose root hash
+	  matches the supplied value.
+
+	  If unsure, answer Y.
 
 endmenu
diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
index e0045ec65434..84fadce85193 100644
--- a/security/ipe/modules/Makefile
+++ b/security/ipe/modules/Makefile
@@ -6,3 +6,5 @@
 #
 
 obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
+obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
+obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
diff --git a/security/ipe/modules/dmverity_roothash.c b/security/ipe/modules/dmverity_roothash.c
new file mode 100644
index 000000000000..abf3ec0a1448
--- /dev/null
+++ b/security/ipe/modules/dmverity_roothash.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <crypto/hash_info.h>
+
+static bool dvrh_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	const struct ipe_bdev *bdev;
+
+	if (!ctx->ipe_bdev)
+		return false;
+
+	bdev = ctx->ipe_bdev;
+	return ipe_digest_eval(val, bdev->digest, bdev->digest_len, bdev->digest_algo);
+}
+
+IPE_MODULE(dvrh) = {
+	.name = "dmverity_roothash",
+	.version = 1,
+	.parse = ipe_digest_parse,
+	.free = ipe_digest_free,
+	.eval = dvrh_eval,
+	.audit = ipe_digest_audit,
+};
diff --git a/security/ipe/modules/dmverity_signature.c b/security/ipe/modules/dmverity_signature.c
new file mode 100644
index 000000000000..4f74cd82254b
--- /dev/null
+++ b/security/ipe/modules/dmverity_signature.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+
+static bool dvv_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	bool expect = (bool)val;
+	bool eval = ctx->ipe_bdev && (!!ctx->ipe_bdev->dm_verity_signed);
+
+	return expect == eval;
+}
+
+IPE_MODULE(dvv) = {
+	.name = "dmverity_signature",
+	.version = 1,
+	.parse = ipe_bool_parse,
+	.free = NULL,
+	.eval = dvv_eval,
+	.audit = ipe_bool_audit,
+};
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
index 5255a57c4784..58e5cdd94448 100644
--- a/security/ipe/modules/ipe_module.h
+++ b/security/ipe/modules/ipe_module.h
@@ -11,6 +11,11 @@
 
 int ipe_bool_parse(const char *valstr, void **value);
 void ipe_bool_audit(struct audit_buffer *ab, const void *val);
+int ipe_digest_parse(const char *valstr, void **value);
+void ipe_digest_audit(struct audit_buffer *ab, const void *val);
+bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
+		     const char *algo);
+void ipe_digest_free(void **value);
 
 /**
  * ipe_module: definition of an extensible module for IPE properties.
-- 
2.25.1

