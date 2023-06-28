Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C807741A0C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jun 2023 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjF1VKV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 17:10:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:39496 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbjF1VJv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 17:09:51 -0400
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 46F1520C091F; Wed, 28 Jun 2023 14:09:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 46F1520C091F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1687986588;
        bh=tYKTZZ4ACs74d1+CwxCZmCa7aIYoM5+NPKaACYNqbuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcUCo1A4B5OwC608I7Vv5HEf3wQ1QWLuTa53J2gNeHsetxXGroM9pZJm6zxGX1CTo
         beJ1jmYmdi+yIiY0r+pkr9XxrdC5fRBnIAxHlWWJ78nErV+P+WL5XTpH8NFdx7zuGt
         bbIt6PgEJCAhRT60FIbSb30EaJHig0A7hhWQ6OgM=
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
Subject: [RFC PATCH v10 05/17] ipe: introduce 'boot_verified' as a trust provider
Date:   Wed, 28 Jun 2023 14:09:19 -0700
Message-Id: <1687986571-16823-6-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE is designed to provide system level trust guarantees, this usually
implies that trust starts from bootup with a hardware root of trust,
which validates the bootloader. After this, the bootloader verifies the
kernel and the initramfs.

As there's no currently supported integrity method for initramfs, and
it's typically already verified by the bootloader, introduce a property
that causes the first superblock to have an execution to be "pinned",
which is typically initramfs.

When the "pinned" device is unmounted, it will be "unpinned" and
`boot_verified` property will always evaluate to false afterward.

We use a pointer with a spin_lock to "pin" the device instead of rcu
because rcu synchronization may sleep, which is not allowed when
unmounting a device.

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
+ Reword and refactor patch 04/12 to [09/16], based on changes in the underlying system.
+ Add common audit function for boolean values
+ Use common audit function as implementation.

v8:
+ No changes

v9:
+ No changes

v10:
+ Replace struct file with struct super_block
---
 security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
 security/ipe/eval.h          |  2 +
 security/ipe/hooks.c         | 12 ++++++
 security/ipe/hooks.h         |  2 +
 security/ipe/ipe.c           |  1 +
 security/ipe/policy.h        |  2 +
 security/ipe/policy_parser.c | 37 +++++++++++++++++-
 7 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 8d0ec7c80f8f..f19a641535c4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -9,6 +9,7 @@
 #include <linux/file.h>
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
+#include <linux/spinlock.h>
 
 #include "ipe.h"
 #include "eval.h"
@@ -17,6 +18,44 @@
 
 struct ipe_policy __rcu *ipe_active_policy;
 
+static const struct super_block *pinned_sb;
+static DEFINE_SPINLOCK(pin_lock);
+#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
+
+/**
+ * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
+ * @sb: Supplies a super_block structure to be pinned.
+ */
+static void pin_sb(const struct super_block *sb)
+{
+	if (!sb)
+		return;
+	spin_lock(&pin_lock);
+	if (!pinned_sb)
+		pinned_sb = sb;
+	spin_unlock(&pin_lock);
+}
+
+/**
+ * from_pinned - Determine whether @sb is the pinned super_block.
+ * @sb: Supplies a super_block to check against the pinned super_block.
+ *
+ * Return:
+ * * true	- @sb is the pinned super_block
+ * * false	- @sb is not the pinned super_block
+ */
+static bool from_pinned(const struct super_block *sb)
+{
+	bool rv;
+
+	if (!sb)
+		return false;
+	spin_lock(&pin_lock);
+	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
+	spin_unlock(&pin_lock);
+	return rv;
+}
+
 /**
  * build_eval_ctx - Build an evaluation context.
  * @ctx: Supplies a pointer to the context to be populdated.
@@ -27,8 +66,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 		    const struct file *file,
 		    enum ipe_op_type op)
 {
+	if (op == __IPE_OP_EXEC && file)
+		pin_sb(FILE_SUPERBLOCK(file));
+
 	ctx->file = file;
 	ctx->op = op;
+
+	if (file)
+		ctx->from_init_sb = from_pinned(FILE_SUPERBLOCK(file));
 }
 
 /**
@@ -43,7 +88,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
 static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
 			      struct ipe_prop *p)
 {
-	return false;
+	switch (p->type) {
+	case __IPE_PROP_BOOT_VERIFIED_FALSE:
+		return !ctx->from_init_sb;
+	case __IPE_PROP_BOOT_VERIFIED_TRUE:
+		return ctx->from_init_sb;
+	default:
+		return false;
+	}
 }
 
 /**
@@ -106,3 +158,21 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 
 	return rc;
 }
+
+/**
+ * ipe_invalidate_pinned_sb - invalidate the ipe pinned super_block.
+ * @mnt_sb: super_block to check against the pinned super_block.
+ *
+ * This function is called a super_block like the initramfs's is freed,
+ * if the super_block is currently pinned by ipe it will be invalided,
+ * so ipe won't consider the block device is boot verified afterward.
+ */
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
+{
+	spin_lock(&pin_lock);
+
+	if (mnt_sb == pinned_sb)
+		pinned_sb = ERR_PTR(-EIO);
+
+	spin_unlock(&pin_lock);
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index 5abb845d5c4e..88c625d6af97 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -18,9 +18,11 @@ struct ipe_eval_ctx {
 	enum ipe_op_type op;
 
 	const struct file *file;
+	bool from_init_sb;
 };
 
 void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
 int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
+void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb);
 
 #endif /* _IPE_EVAL_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index d896a5a474bc..6f94f5c8a0c3 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -180,3 +180,15 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
 	build_eval_ctx(&ctx, NULL, op);
 	return ipe_evaluate_event(&ctx);
 }
+
+/**
+ * ipe_sb_free_security - ipe security hook function for super_block.
+ * @mnt_sb: Supplies a pointer to a super_block is about to be freed.
+ *
+ * IPE does not have any structures with mnt_sb, but uses this hook to
+ * invalidate a pinned super_block.
+ */
+void ipe_sb_free_security(struct super_block *mnt_sb)
+{
+	ipe_invalidate_pinned_sb(mnt_sb);
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
index 23205452f758..ac0cdfd9877f 100644
--- a/security/ipe/hooks.h
+++ b/security/ipe/hooks.h
@@ -22,4 +22,6 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
 
 int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
 
+void ipe_sb_free_security(struct super_block *mnt_sb);
+
 #endif /* _IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index 29bedc0b2ad6..8f98ee7b8025 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -15,6 +15,7 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
 	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
 	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
+	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
 };
 
 /**
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
index 113a037f0d71..a74856b9966c 100644
--- a/security/ipe/policy.h
+++ b/security/ipe/policy.h
@@ -30,6 +30,8 @@ enum ipe_action_type {
 #define __IPE_ACTION_INVALID __IPE_ACTION_MAX
 
 enum ipe_prop_type {
+	__IPE_PROP_BOOT_VERIFIED_FALSE,
+	__IPE_PROP_BOOT_VERIFIED_TRUE,
 	__IPE_PROP_MAX
 };
 
diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
index 27e5767480b0..28c14adfe6d2 100644
--- a/security/ipe/policy_parser.c
+++ b/security/ipe/policy_parser.c
@@ -265,6 +265,12 @@ static enum ipe_action_type parse_action(char *t)
 	return match_token(t, action_tokens, args);
 }
 
+static const match_table_t property_tokens = {
+	{__IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
+	{__IPE_PROP_BOOT_VERIFIED_TRUE,		"boot_verified=TRUE"},
+	{__IPE_PROP_INVALID,			NULL}
+};
+
 /**
  * parse_property - Parse the property type given a token string.
  * @t: Supplies the token string to be parsed.
@@ -277,7 +283,36 @@ static enum ipe_action_type parse_action(char *t)
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
+	case __IPE_PROP_BOOT_VERIFIED_FALSE:
+	case __IPE_PROP_BOOT_VERIFIED_TRUE:
+		p->type = token;
+		break;
+	case __IPE_PROP_INVALID:
+	default:
+		rc = -EBADMSG;
+		break;
+	}
+	if (rc)
+		goto err;
+	list_add_tail(&p->next, &r->props);
+
+out:
+	return rc;
+err:
+	kfree(p);
+	goto out;
 }
 
 /**
-- 
2.25.1

