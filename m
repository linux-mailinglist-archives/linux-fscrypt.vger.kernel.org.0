Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60A742C979
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhJMTJG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:06 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49092 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237779AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 81C9520B9D09;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 81C9520B9D09
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=mlyLB653erZlNw5CD5zMHBUnb6jgdKf8+Lje6CHRKd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmS3KOkenIvgXCpDDU5QK5h8SotNnCj+IagKbqMTdYPJcXNSvFgJFQDAKaoocbT0S
         tV1XzFB9FYjH3XRmxN45vfMmhsCHLjajSJ1aIDNfpZzac/zd41U7v3SnZ6inlPYFSu
         h6rANyNFC41rgNeBCMgoco/OYnJRI9qGA5IX5yQg=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 13/16] ipe: enable support for fs-verity as a trust provider
Date:   Wed, 13 Oct 2021 12:06:32 -0700
Message-Id: <1634151995-16266-14-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Fan Wu <wufan@linux.microsoft.com>

Enable IPE policy authors to indicate trust for a singular fsverity
file, identified by the digest information, through "fsverity_digest"
and all fsverity signed by a key via "fsverity_signature".

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Add FSVerity Support (Introduced)

---
 security/ipe/eval.c                       |  1 +
 security/ipe/eval.h                       |  9 +++
 security/ipe/hooks.c                      | 58 ++++++++++++++++
 security/ipe/hooks.h                      |  7 ++
 security/ipe/ipe.c                        |  8 +++
 security/ipe/ipe.h                        |  1 +
 security/ipe/modules/Kconfig              | 23 +++++++
 security/ipe/modules/Makefile             |  2 +
 security/ipe/modules/fsverity_digest.c    | 80 +++++++++++++++++++++++
 security/ipe/modules/fsverity_signature.c | 33 ++++++++++
 10 files changed, 222 insertions(+)
 create mode 100644 security/ipe/modules/fsverity_digest.c
 create mode 100644 security/ipe/modules/fsverity_signature.c

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index facc05c753f4..8f8b91c714c2 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -97,6 +97,7 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->ci_ctx = ipe_current_ctx();
 	ctx->from_init_sb = from_pinned(file);
 	if (file) {
+		ctx->ipe_inode = ipe_inode(file->f_inode);
 		if (FILE_BLOCK_DEV(file))
 			ctx->ipe_bdev = ipe_bdev(FILE_BLOCK_DEV(file));
 	}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 25d2d8d55702..d51280f0519f 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -21,6 +21,14 @@ struct ipe_bdev {
 	size_t		hashlen;
 };
 
+struct ipe_inode {
+	const u8       *sigdata;
+	size_t		siglen;
+
+	const u8       *hash;
+	size_t		hashlen;
+};
+
 struct ipe_eval_ctx {
 	enum ipe_hook hook;
 	enum ipe_operation op;
@@ -29,6 +37,7 @@ struct ipe_eval_ctx {
 	struct ipe_context *ci_ctx;
 
 	const struct ipe_bdev *ipe_bdev;
+	const struct ipe_inode *ipe_inode;
 
 	bool from_init_sb;
 };
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index d76e60a3f511..78bb3451220a 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -268,3 +268,61 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 
 	return -ENOSYS;
 }
+
+/**
+ * ipe_inode_setsecurity: Sets the a certain field of a inode security
+ *			 blob, based on @key.
+ * @inode: The inode to source the security blob from.
+ * @name: The name representing the information to be stored.
+ * @value: The value to be stored.
+ * @size: The size of @value.
+ * @flags: unused
+ *
+ * Saves fsverity signature & digest into inode security blob
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags)
+{
+	struct ipe_inode *inode_sec = ipe_inode(inode);
+
+	if (!strcmp(name, FS_VERITY_SIGNATURE_SEC_NAME)) {
+		inode_sec->siglen = size;
+		inode_sec->sigdata = kmemdup(value, size, GFP_KERNEL);
+		if (!inode_sec->sigdata)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	if (!strcmp(name, FS_VERITY_DIGEST_SEC_NAME)) {
+		inode_sec->hashlen = size;
+		inode_sec->hash = kmemdup(value, size, GFP_KERNEL);
+		if (!inode_sec->hash)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+/**
+ * ipe_node_free_security: Frees all fields of IPE's inode security blob.
+ * @inode: The inode structure to source the security blob from.
+ *
+ * The deallocation of the blob itself is performed later by the LSM
+ * infrastructure, (on behalf of all LSMs) in lsm_free_file.
+ *
+ */
+void ipe_inode_free_security(struct inode *inode)
+{
+	struct ipe_inode *inode_sec = ipe_inode(inode);
+
+	kfree(inode_sec->sigdata);
+	kfree(inode_sec->hash);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 285f35187188..d6f8c05a8011 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/fsverity.h>
 #include <linux/device-mapper.h>
 
 enum ipe_hook {
@@ -46,4 +47,10 @@ void ipe_bdev_free_security(struct block_device *bdev);
 int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
 			 const void *value, size_t len);
 
+void ipe_inode_free_security(struct inode *inode);
+
+int ipe_inode_setsecurity(struct inode *inode, const char *name,
+			  const void *value, size_t size,
+			  int flags);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 215936cb4574..c7ecd542c317 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -22,6 +22,7 @@
 struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
 	.lbs_task = sizeof(struct ipe_context __rcu *),
 	.lbs_bdev = sizeof(struct ipe_bdev),
+	.lbs_inode = sizeof(struct ipe_inode),
 };
 
 struct ipe_bdev *ipe_bdev(struct block_device *b)
@@ -29,6 +30,11 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
 	return b->security + ipe_blobs.lbs_bdev;
 }
 
+struct ipe_inode *ipe_inode(const struct inode *inode)
+{
+	return inode->i_security + ipe_blobs.lbs_inode;
+}
+
 static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
 	LSM_HOOK_INIT(task_free, ipe_task_free),
@@ -40,6 +46,8 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
 	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
+	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
+	LSM_HOOK_INIT(inode_free_security, ipe_inode_free_security),
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 6b4c7e07f204..16d843614fac 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -22,5 +22,6 @@ extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
 extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
 struct ipe_bdev *ipe_bdev(struct block_device *b);
+struct ipe_inode *ipe_inode(const struct inode *inode);
 
 #endif /* IPE_H */
diff --git a/security/ipe/modules/Kconfig b/security/ipe/modules/Kconfig
index a6ea06cf0737..8f823a1edf96 100644
--- a/security/ipe/modules/Kconfig
+++ b/security/ipe/modules/Kconfig
@@ -40,4 +40,27 @@ config IPE_PROP_DM_VERITY_ROOTHASH
 
 	  If unsure, answer Y.
 
+config IPE_PROP_FS_VERITY_SIGNATURE
+	bool "Enable property for signed fs-verity files"
+	depends on FS_VERITY_BUILTIN_SIGNATURES
+	help
+	  This option enables IPE's integration with FSVerity's
+	  signed hashes. This enables the usage of the property,
+	  "fsverity_signature" in IPE's policy.
+
+	  if unsure, answer Y.
+
+config IPE_PROP_FS_VERITY_DIGEST
+	bool "Enable property for authorizing fs-verity files via digest"
+	depends on FS_VERITY
+	help
+	  This option enables IPE's integration with FSVerity.
+	  This enables the usage of the property "fsverity_digest" in IPE's
+	  policy. This property allows authorization or revocation via a
+	  a hex-string representing the digest of a fsverity file.
+
+	  if unsure, answer Y.
+
+
+
 endmenu
diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
index 84fadce85193..890440b9050f 100644
--- a/security/ipe/modules/Makefile
+++ b/security/ipe/modules/Makefile
@@ -8,3 +8,5 @@
 obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
 obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
 obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
+obj-$(CONFIG_IPE_PROP_FS_VERITY_SIGNATURE) += fsverity_signature.o
+obj-$(CONFIG_IPE_PROP_FS_VERITY_DIGEST) += fsverity_digest.o
diff --git a/security/ipe/modules/fsverity_digest.c b/security/ipe/modules/fsverity_digest.c
new file mode 100644
index 000000000000..67944ebbb8d5
--- /dev/null
+++ b/security/ipe/modules/fsverity_digest.c
@@ -0,0 +1,80 @@
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
+struct counted_array {
+	size_t	len;
+	u8     *data;
+};
+
+static int parse(const char *valstr, void **value)
+{
+	int rv = 0;
+	struct counted_array *arr;
+
+	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
+	if (!arr) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	arr->len = (strlen(valstr) / 2);
+
+	arr->data = kzalloc(arr->len, GFP_KERNEL);
+	if (!arr->data) {
+		rv = -ENOMEM;
+		goto err;
+	}
+
+	rv = hex2bin(arr->data, valstr, arr->len);
+	if (rv != 0)
+		goto err2;
+
+	*value = arr;
+	return rv;
+err2:
+	kfree(arr->data);
+err:
+	kfree(arr);
+	return rv;
+}
+
+static bool evaluate(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	const u8 *src;
+	struct counted_array *expect = (struct counted_array *)val;
+
+	if (!ctx->ipe_inode)
+		return false;
+
+	if (ctx->ipe_inode->hashlen != expect->len)
+		return false;
+
+	src = ctx->ipe_inode->hash;
+
+	return !memcmp(expect->data, src, expect->len);
+}
+
+static int free_value(void **val)
+{
+	struct counted_array *expect = (struct counted_array *)val;
+
+	kfree(expect->data);
+	kfree(expect);
+
+	return 0;
+}
+
+IPE_MODULE(fsv_digest) = {
+	.name = "fsverity_digest",
+	.version = 1,
+	.parse = parse,
+	.free = free_value,
+	.eval = evaluate,
+};
diff --git a/security/ipe/modules/fsverity_signature.c b/security/ipe/modules/fsverity_signature.c
new file mode 100644
index 000000000000..8930a8961f61
--- /dev/null
+++ b/security/ipe/modules/fsverity_signature.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe_module.h"
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/audit.h>
+#include <linux/mount.h>
+
+static bool evaluate(const struct ipe_eval_ctx *ctx, const void *value)
+{
+	bool expect = (bool)value;
+
+	if (!ctx->file)
+		return false;
+
+	if (!IS_VERITY(ctx->file->f_inode) || !ctx->ipe_inode)
+		return false;
+
+	return (!!ctx->ipe_inode->sigdata) == expect;
+}
+
+IPE_MODULE(fsvs) = {
+	.name = "fsverity_signature",
+	.version = 1,
+	.parse = ipe_bool_parse,
+	.free = NULL,
+	.eval = evaluate,
+};
-- 
2.33.0

