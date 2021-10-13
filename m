Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26ED42C985
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239200AbhJMTJL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:11 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49082 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 53A0520B9D07;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 53A0520B9D07
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=xG/zPHHutL8T5eRrGb1/Q/GV2nZZLBHINhuwqkApUsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NG1/fJodDX3frNqh45lSR0U+Sja/o98n348hhFBUDCNgfE7l2ldnR31WITY3dQ2YT
         RnFzfr/PZTkOuJt0rNvSKDTZc9cTu5E8LzeIe+Q3Xl26g6th/566pJx8OPzVus+Aiq
         PTYXuWypkkfNBzqNNHW/RpssYdC6V++XcF/5jt9M=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 11/16] ipe: add support for dm-verity as a trust provider
Date:   Wed, 13 Oct 2021 12:06:30 -0700
Message-Id: <1634151995-16266-12-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Allows author of IPE policy to indicate trust for a singular dm-verity
volume, identified by roothash, through "dmverity_roothash" and all
signed dm-verity volumes, through "dmverity_signature".

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Squash patch 08/12, 10/12 to [11/16]

---
 security/ipe/eval.c                       |  5 ++
 security/ipe/eval.h                       | 10 +++
 security/ipe/hooks.c                      | 48 ++++++++++++++
 security/ipe/hooks.h                      |  6 ++
 security/ipe/ipe.c                        |  9 +++
 security/ipe/ipe.h                        |  3 +
 security/ipe/modules/Kconfig              | 23 +++++++
 security/ipe/modules/Makefile             |  2 +
 security/ipe/modules/dmverity_roothash.c  | 80 +++++++++++++++++++++++
 security/ipe/modules/dmverity_signature.c | 25 +++++++
 10 files changed, 211 insertions(+)
 create mode 100644 security/ipe/modules/dmverity_roothash.c
 create mode 100644 security/ipe/modules/dmverity_signature.c

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 361efccebad4..facc05c753f4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -23,6 +23,7 @@ static struct super_block *pinned_sb;
 static DEFINE_SPINLOCK(pin_lock);
 
 #define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+#define FILE_BLOCK_DEV(f) (FILE_SUPERBLOCK(f)->s_bdev)
 
 /**
  * pin_sb: pin the underlying superblock of @f, marking it as trusted
@@ -95,6 +96,10 @@ static struct ipe_eval_ctx *build_ctx(const struct file *file,
 	ctx->hook = hook;
 	ctx->ci_ctx = ipe_current_ctx();
 	ctx->from_init_sb = from_pinned(file);
+	if (file) {
+		if (FILE_BLOCK_DEV(file))
+			ctx->ipe_bdev = ipe_bdev(FILE_BLOCK_DEV(file));
+	}
 
 	return ctx;
 }
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 42fb7fdf2599..25d2d8d55702 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -13,6 +13,14 @@
 #include "hooks.h"
 #include "policy.h"
 
+struct ipe_bdev {
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
@@ -20,6 +28,8 @@ struct ipe_eval_ctx {
 	const struct file *file;
 	struct ipe_context *ci_ctx;
 
+	const struct ipe_bdev *ipe_bdev;
+
 	bool from_init_sb;
 };
 
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 2d4a4f0eead0..470fb48e490c 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -13,6 +13,7 @@
 #include <linux/types.h>
 #include <linux/refcount.h>
 #include <linux/rcupdate.h>
+#include <linux/blk_types.h>
 #include <linux/binfmts.h>
 #include <linux/mman.h>
 
@@ -219,3 +220,50 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
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
+	kfree(blob->sigdata);
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
+	if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
+		blob->siglen = len;
+		blob->sigdata = kmemdup(value, len, GFP_KERNEL);
+		if (!blob->sigdata)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
+		blob->hashlen = len;
+		blob->hash = kmemdup(value, len, GFP_KERNEL);
+		if (!blob->hash)
+			return -ENOMEM;
+
+		return 0;
+	}
+
+	return -ENOSYS;
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index e7f107ab5620..285f35187188 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/binfmts.h>
 #include <linux/security.h>
+#include <linux/device-mapper.h>
 
 enum ipe_hook {
 	ipe_hook_exec = 0,
@@ -40,4 +41,9 @@ int ipe_on_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
 void ipe_sb_free_security(struct super_block *mnt_sb);
 
+void ipe_bdev_free_security(struct block_device *bdev);
+
+int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
+			 const void *value, size_t len);
+
 #endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 1382d50078ec..215936cb4574 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -9,6 +9,7 @@
 #include "ipe_parser.h"
 #include "modules/ipe_module.h"
 #include "modules.h"
+#include "eval.h"
 
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -20,8 +21,14 @@
 
 struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
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
@@ -31,6 +38,8 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
 	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
 	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
+	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
+	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
 };
 
 /**
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index ad16d2bebfec..6b4c7e07f204 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -14,10 +14,13 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
+#include <linux/blk_types.h>
 #include <linux/lsm_hooks.h>
 
 extern struct lsm_blob_sizes ipe_blobs;
 extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
 extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
+struct ipe_bdev *ipe_bdev(struct block_device *b);
+
 #endif /* IPE_H */
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
index 000000000000..0f82bec3b842
--- /dev/null
+++ b/security/ipe/modules/dmverity_roothash.c
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
+static int dvrh_parse(const char *valstr, void **value)
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
+static bool dvrh_eval(const struct ipe_eval_ctx *ctx, const void *val)
+{
+	const u8 *src;
+	struct counted_array *expect = (struct counted_array *)val;
+
+	if (!ctx->ipe_bdev)
+		return false;
+
+	if (ctx->ipe_bdev->hashlen != expect->len)
+		return false;
+
+	src = ctx->ipe_bdev->hash;
+
+	return !memcmp(expect->data, src, expect->len);
+}
+
+static int dvrh_free(void **val)
+{
+	struct counted_array *expect = (struct counted_array *)val;
+
+	kfree(expect->data);
+	kfree(expect);
+
+	return 0;
+}
+
+IPE_MODULE(dvrh) = {
+	.name = "dmverity_roothash",
+	.version = 1,
+	.parse = dvrh_parse,
+	.free = dvrh_free,
+	.eval = dvrh_eval,
+};
diff --git a/security/ipe/modules/dmverity_signature.c b/security/ipe/modules/dmverity_signature.c
new file mode 100644
index 000000000000..08746fcbcb3e
--- /dev/null
+++ b/security/ipe/modules/dmverity_signature.c
@@ -0,0 +1,25 @@
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
+	bool eval = ctx->ipe_bdev && (!!ctx->ipe_bdev->sigdata);
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
+};
-- 
2.33.0

