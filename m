Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F5742C969
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhJMTIt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:08:49 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49064 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238374AbhJMTIq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:46 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id AF6F620B9D0B;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AF6F620B9D0B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=ousWeedsgO2t3dP0RTto2gM0Bh3q3C1Isu/HZSqQ0R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAC49FghiB4x3KtAlKjmbzn87sE6+UFRPzrLZRZ6/W23nQok4DQSw40g3taLZYTCP
         q+bzu+e4Wmfc/TqfFjSHEWrjrWhP0d0gUVBfCGfEpWZdL9XLUsFd8ycagWrJjNb4HX
         jR+Zv1QvgmncD7zqQ8NQJV7Em98PzQ1sGrIybpMk=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 15/16] ipe: kunit tests
Date:   Wed, 13 Oct 2021 12:06:34 -0700
Message-Id: <1634151995-16266-16-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add various happy/unhappy unit tests for both IPE's parser
and evaluation loop, testing the core of IPE. The missing
test gap remains the interface with userspace.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Add Kunit tests (Introduced)

---
 security/ipe/Kconfig               |  17 +
 security/ipe/Makefile              |   3 +
 security/ipe/ctx_test.c            | 732 +++++++++++++++++++++++++++++
 security/ipe/eval.c                |   4 +
 security/ipe/policy_parser_tests.c | 299 ++++++++++++
 5 files changed, 1055 insertions(+)
 create mode 100644 security/ipe/ctx_test.c
 create mode 100644 security/ipe/policy_parser_tests.c

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 39df680b67a2..e1ec8740392c 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -80,4 +80,21 @@ config IPE_AUDIT_HASH_ALG
 
 source "security/ipe/modules/Kconfig"
 
+config SECURITY_IPE_KUNIT_TEST
+	bool "Build KUnit tests for IPE" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the IPE KUnit tests.
+
+	  KUnit tests run during boot and output the results to the debug log
+	  in TAP format (https://testanything.org/). Only useful for kernel devs
+	  running KUnit test harness and are not for inclusion into a
+	  production build.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 89fec670f954..f11a9ac24f2e 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -33,4 +33,7 @@ obj-$(CONFIG_SECURITY_IPE) += \
 
 obj-$(CONFIG_AUDIT) += audit.o
 
+obj-$(CONFIG_SECURITY_IPE_KUNIT_TEST) += \
+	policy_parser_tests.o \
+
 clean-files := boot-policy.c \
diff --git a/security/ipe/ctx_test.c b/security/ipe/ctx_test.c
new file mode 100644
index 000000000000..163cc8aa8861
--- /dev/null
+++ b/security/ipe/ctx_test.c
@@ -0,0 +1,732 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include <kunit/test.h>
+#include <linux/workqueue.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include "ctx.h"
+#include "policy.h"
+#include "hooks.h"
+
+struct eval_case {
+	const char *const desc;
+	const char *const policy;
+	int		  errno;
+
+	const struct file *fake_file;
+	const struct ipe_bdev *bdev_sec;
+	const struct ipe_inode *inode_sec;
+	bool initsb;
+};
+
+static const u8 fake_digest[] = { 0xDE, 0xAD, 0xBE, 0xEF };
+
+static const struct ipe_bdev fake_bdev_no_data = {};
+static const struct ipe_bdev fake_bdev_no_sig = {
+	.hash = fake_digest,
+	.hashlen = ARRAY_SIZE(fake_digest),
+};
+
+static const struct ipe_bdev fake_bdev_signed = {
+	.sigdata = fake_digest,
+	.siglen = ARRAY_SIZE(fake_digest),
+	.hash = fake_digest,
+	.hashlen = ARRAY_SIZE(fake_digest),
+};
+
+static const struct ipe_inode fake_ino_no_data = {};
+
+static const struct ipe_inode fake_ino_no_sig = {
+	.hash = fake_digest,
+	.hashlen = ARRAY_SIZE(fake_digest),
+};
+
+static const struct ipe_inode fake_ino_signed = {
+	.sigdata = fake_digest,
+	.siglen = ARRAY_SIZE(fake_digest),
+	.hash = fake_digest,
+	.hashlen = ARRAY_SIZE(fake_digest),
+};
+
+static struct inode fake_inode = {
+	.i_flags = S_VERITY
+};
+
+static const struct file fake_verity = {
+	.f_inode = &fake_inode,
+};
+
+static const struct eval_case cases[] = {
+	{
+		"boot_verified_trust_no_source",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE boot_verified=TRUE action=ALLOW\n"
+		"op=KERNEL_READ boot_verified=TRUE action=ALLOW\n",
+		-EACCES, NULL, NULL, NULL, false
+	},
+	{
+		"boot_verified_distrust",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE boot_verified=FALSE action=ALLOW\n"
+		"op=KERNEL_READ boot_verified=FALSE action=ALLOW\n",
+		0, NULL, NULL, NULL, false
+	},
+	{
+		"boot_verified_trust",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE boot_verified=TRUE action=ALLOW\n"
+		"op=KERNEL_READ boot_verified=TRUE action=ALLOW\n",
+		0, NULL, NULL, NULL, true
+	},
+	{
+		"boot_verified_trust",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE boot_verified=FALSE action=ALLOW\n"
+		"op=KERNEL_READ boot_verified=FALSE action=ALLOW\n",
+		-EACCES, NULL, NULL, NULL, true
+	},
+	{
+		"dmverity_signature_trust_no_bdev",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_signature=FALSE action=ALLOW\n"
+		"op=KERNEL_READ dmverity_signature=FALSE action=ALLOW\n",
+		0, NULL, NULL, NULL, true
+	},
+	{
+		"dmverity_signature_distrust_no_bdev",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ dmverity_signature=TRUE action=ALLOW\n",
+		-EACCES, NULL, NULL, NULL, false
+	},
+	{
+		"dmverity_signature_distrust_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_signature=FALSE action=ALLOW\n"
+		"op=KERNEL_READ dmverity_signature=FALSE action=ALLOW\n",
+		-EACCES, NULL, &fake_bdev_signed, &fake_ino_no_data, false
+	},
+	{
+		"dmverity_signature_trust_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ dmverity_signature=TRUE action=ALLOW\n",
+		0, NULL, &fake_bdev_signed, &fake_ino_no_data, true
+	},
+	{
+		"dmverity_roothash_trust_no_bdev",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_roothash=DEADBEEF action=ALLOW\n"
+		"op=KERNEL_READ dmverity_roothash=DEADBEEF action=ALLOW\n",
+		-EACCES, NULL, NULL, NULL, true
+	},
+	{
+		"dmverity_roothash_distrust_no_bdev",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_roothash=deadbeef action=DENY\n"
+		"op=KERNEL_READ dmverity_roothash=deadbeef action=DENY\n",
+		0, NULL, NULL, NULL, false
+	},
+	{
+		"dmverity_roothash_trust_hash",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_roothash=DEADBEEF action=ALLOW\n"
+		"op=KERNEL_READ dmverity_roothash=DEADBEEF action=ALLOW\n",
+		0, NULL, &fake_bdev_no_sig, &fake_ino_no_data, false
+	},
+	{
+		"dmverity_roothash_distrust_hash",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_roothash=DEADBEEF action=DENY\n"
+		"op=KERNEL_READ dmverity_roothash=DEADBEEF action=DENY\n",
+		-EACCES, NULL, &fake_bdev_no_sig, &fake_ino_no_data, false
+	},
+	{
+		"dmverity_signature_revoke_hash",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE dmverity_roothash=DEADBEEF action=DENY\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ dmverity_roothash=DEADBEEF action=DENY\n"
+		"op=KERNEL_READ dmverity_signature=TRUE action=ALLOW\n",
+		-EACCES, NULL, &fake_bdev_signed, &fake_ino_no_data, false
+	},
+	{
+		"fsverity_signature_trust_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE fsverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ fsverity_signature=TRUE action=ALLOW\n",
+		0, &fake_verity, &fake_bdev_no_data, &fake_ino_signed, false
+	},
+	{
+		"fsverity_signature_distrust_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE fsverity_signature=TRUE action=DENY\n"
+		"op=KERNEL_READ fsverity_signature=TRUE action=DENY\n",
+		-EACCES, &fake_verity, &fake_bdev_no_data, &fake_ino_signed, false
+	},
+	{
+		"fsverity_signature_trust_no_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE fsverity_signature=FALSE action=ALLOW\n"
+		"op=KERNEL_READ fsverity_signature=FALSE action=ALLOW\n",
+		0, &fake_verity, &fake_bdev_signed, &fake_ino_no_sig, true
+	},
+	{
+		"fsverity_signature_distrust_no_sigdata",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE fsverity_signature=FALSE action=DENY\n"
+		"op=KERNEL_READ fsverity_signature=FALSE action=DENY\n",
+		-EACCES, &fake_verity, &fake_bdev_signed, &fake_ino_no_sig, true
+	},
+	{
+		"fsverity_digest_trust_hash",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE fsverity_digest=DEADBEEF action=ALLOW\n"
+		"op=KERNEL_READ fsverity_digest=DEADBEEF action=ALLOW\n",
+		0, &fake_verity, &fake_bdev_signed, &fake_ino_no_sig, true
+	},
+	{
+		"fsverity_digest_revoke_hash",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE fsverity_digest=DEADBEEF action=DENY\n"
+		"op=EXECUTE fsverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ fsverity_digest=DEADBEEF action=DENY\n"
+		"op=KERNEL_READ fsverity_signature=TRUE action=ALLOW\n",
+		-EACCES, &fake_verity, &fake_bdev_signed, &fake_ino_signed, true
+	},
+	{
+		"dmverity_signature_revoke_fsverity_digest",
+		"policy_name='Test' policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"op=EXECUTE fsverity_digest=DEADBEEF action=DENY\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n"
+		"op=KERNEL_READ fsverity_digest=DEADBEEF action=DENY\n"
+		"op=KERNEL_READ dmverity_signature=TRUE action=ALLOW\n",
+		-EACCES, &fake_verity, &fake_bdev_signed, &fake_ino_signed, false
+	},
+};
+
+static void case_to_desc(const struct eval_case *c, char *desc)
+{
+	strncpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(ipe_eval, cases, case_to_desc);
+
+/**
+ * fake_free_ctx: Fake function to deallocate a context structure.
+ */
+static void fake_free_ctx(struct ipe_context *ctx)
+{
+	struct ipe_policy *p = NULL;
+
+	list_for_each_entry(p, &ctx->policies, next)
+		ipe_put_policy(p);
+
+	kfree(ctx);
+}
+
+/**
+ * create_fake_ctx: Build a fake ipe_context for use
+ *		    in a test.
+ * Return:
+ * !IS_ERR - OK
+ */
+static struct ipe_context *create_fake_ctx(void)
+{
+	struct ipe_context *ctx = NULL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&ctx->policies);
+	refcount_set(&ctx->refcount, 1);
+	spin_lock_init(&ctx->lock);
+	WRITE_ONCE(ctx->enforce, true);
+
+	return ctx;
+}
+
+/**
+ * ipe_ctx_eval_test: Parse a policy, and run a mock through the
+ *		      evaluation loop to check the functional result.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_eval_test(struct kunit *test)
+{
+	int rc = 0;
+	enum ipe_operation i = ipe_operation_exec;
+	struct ipe_policy *pol = NULL;
+	struct ipe_context *ctx = NULL;
+	struct ipe_eval_ctx eval = { 0 };
+	const struct eval_case *t = test->param_value;
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	pol = ipe_new_policy(t->policy, strlen(t->policy), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pol);
+
+	ipe_add_policy(ctx, pol);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(pol));
+	KUNIT_EXPECT_EQ(test, refcount_read(&pol->refcount), 2);
+	KUNIT_EXPECT_PTR_EQ(test, pol->policyfs, NULL);
+	KUNIT_EXPECT_PTR_EQ(test, pol->pkcs7, NULL);
+
+	eval.hook = ipe_hook_max;
+	eval.ipe_bdev = t->bdev_sec;
+	eval.ipe_inode = t->inode_sec;
+	eval.from_init_sb = t->initsb;
+	eval.ci_ctx = ctx;
+	eval.file = t->fake_file;
+
+	for (i = ipe_operation_exec; i < ipe_operation_max; ++i) {
+		eval.op = i;
+		rc = evaluate(&eval);
+		KUNIT_EXPECT_EQ(test, rc, t->errno);
+	}
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(pol);
+}
+
+/**
+ * ipe_ctx_eval_permissive_test: Parse a policy, and run a mock through the
+ *				 evaluation loop to with permissive on,
+ *				 checking the functional result.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_eval_permissive_test(struct kunit *test)
+{
+	int rc = 0;
+	enum ipe_operation i = ipe_operation_exec;
+	struct ipe_policy *pol = NULL;
+	struct ipe_context *ctx = NULL;
+	struct ipe_eval_ctx eval = { 0 };
+	const struct eval_case *t = test->param_value;
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+	WRITE_ONCE(ctx->enforce, false);
+
+	pol = ipe_new_policy(t->policy, strlen(t->policy), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pol);
+
+	ipe_add_policy(ctx, pol);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(pol));
+	KUNIT_EXPECT_EQ(test, refcount_read(&pol->refcount), 2);
+	KUNIT_EXPECT_PTR_EQ(test, pol->policyfs, NULL);
+	KUNIT_EXPECT_PTR_EQ(test, pol->pkcs7, NULL);
+
+	eval.hook = ipe_hook_max;
+	eval.ipe_bdev = t->bdev_sec;
+	eval.ipe_inode = t->inode_sec;
+	eval.from_init_sb = t->initsb;
+	eval.ci_ctx = ctx;
+	eval.file = t->fake_file;
+
+	for (i = ipe_operation_exec; i < ipe_operation_max; ++i) {
+		eval.op = i;
+		rc = evaluate(&eval);
+		KUNIT_EXPECT_EQ(test, rc, 0);
+	}
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(pol);
+}
+
+/**
+ * ipe_ctx_default_eval_test: Ensure an operation-level default
+ *			      is taken over a global-level default.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_default_eval_test(struct kunit *test)
+{
+	int rc = 0;
+	struct ipe_policy *pol = NULL;
+	struct ipe_context *ctx = NULL;
+	struct ipe_eval_ctx eval = { 0 };
+	const char *const policy =
+		"policy_name=Test policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n"
+		"DEFAULT op=EXECUTE action=ALLOW";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	pol = ipe_new_policy(policy, strlen(policy), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pol);
+	KUNIT_EXPECT_EQ(test, pol->parsed->global_default, ipe_action_deny);
+	KUNIT_EXPECT_EQ(test, pol->parsed->rules[ipe_operation_exec].default_action,
+			ipe_action_allow);
+
+	ipe_add_policy(ctx, pol);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(pol));
+	KUNIT_EXPECT_EQ(test, refcount_read(&pol->refcount), 2);
+	KUNIT_EXPECT_PTR_EQ(test, pol->policyfs, NULL);
+	KUNIT_EXPECT_PTR_EQ(test, pol->pkcs7, NULL);
+
+	eval.hook = ipe_hook_max;
+	eval.ipe_bdev = NULL;
+	eval.ipe_inode = NULL;
+	eval.from_init_sb = NULL;
+	eval.ci_ctx = ctx;
+	eval.file = NULL;
+	eval.op = ipe_operation_exec;
+
+	rc = evaluate(&eval);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+
+	eval.op = ipe_operation_kexec_image;
+	rc = evaluate(&eval);
+	KUNIT_EXPECT_EQ(test, rc, -EACCES);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(pol);
+}
+
+/**
+ * ipe_ctx_replace_policy - Associate a policy with a context, then replace it.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_replace_policy(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_policy *pp = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+	p2 = ipe_new_policy(policy2, strlen(policy2), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p2);
+
+	ipe_add_policy(ctx, p1);
+	KUNIT_EXPECT_TRUE(test, list_is_singular(&ctx->policies));
+
+	pp = list_first_entry(&ctx->policies, struct ipe_policy, next);
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+
+	ipe_replace_policy(p1, p2);
+	KUNIT_EXPECT_TRUE(test, list_is_singular(&ctx->policies));
+	pp = list_first_entry(&ctx->policies, struct ipe_policy, next);
+	KUNIT_EXPECT_PTR_EQ(test, pp, p2);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_replace_policy - Associate a policy with a context, mark the policy active,
+ *			    then replace it.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_replace_active_policy(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_policy *pp = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+	p2 = ipe_new_policy(policy2, strlen(policy2), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p2);
+
+	ipe_add_policy(ctx, p1);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(p1));
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	ipe_replace_policy(p1, p2);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p2);
+	ipe_put_policy(pp);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_update_policy - Associate a policy with a context, then update it.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness. This function differs from replace above,
+ * as it performs additional error checking.
+ */
+static void ipe_ctx_update_policy(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_policy *pp = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+
+	ipe_add_policy(ctx, p1);
+	ipe_set_active_pol(p1);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	p2 = ipe_update_policy(p1, policy2, strlen(policy2), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p2);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p2);
+	ipe_put_policy(pp);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_update_wrong_policy - Associate a policy with a context, then
+ *				 attempt update it with the wrong policy.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_update_wrong_policy(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_policy *pp = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t2 policy_version=0.0.0\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+
+	ipe_add_policy(ctx, p1);
+	ipe_set_active_pol(p1);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	p2 = ipe_update_policy(p1, policy2, strlen(policy2), NULL, 0);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(p2), -EINVAL);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_update_wrong_policy - Associate a policy with a context, mark it active,
+ *				 then attempt update it with a stale policy.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_update_rollback_policy(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_policy *pp = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+
+	ipe_add_policy(ctx, p1);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(p1));
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	p2 = ipe_update_policy(p1, policy2, strlen(policy2), NULL, 0);
+	KUNIT_EXPECT_EQ(test, PTR_ERR(p2), -EINVAL);
+
+	rcu_read_lock();
+	pp = ipe_get_policy_rcu(ctx->active_policy);
+	rcu_read_unlock();
+	KUNIT_EXPECT_PTR_EQ(test, pp, p1);
+	ipe_put_policy(pp);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_rollback - Associate two policies with a context, then
+ *		      attempt rollback the active policy.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_rollback(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t2 policy_version=0.0.0\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+	ipe_add_policy(ctx, p1);
+	KUNIT_ASSERT_EQ(test, 0, ipe_set_active_pol(p1));
+
+	p2 = ipe_new_policy(policy2, strlen(policy2), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p2);
+	ipe_add_policy(ctx, p2);
+	KUNIT_ASSERT_EQ(test, -EINVAL, ipe_set_active_pol(p2));
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+/**
+ * ipe_ctx_update_rollback_inactive - Associate a policy with a context, then
+ *				      attempt update it with a stale policy.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_ctx_update_rollback_inactive(struct kunit *test)
+{
+	struct ipe_policy *p1 = NULL;
+	struct ipe_policy *p2 = NULL;
+	struct ipe_context *ctx = NULL;
+	const char *const policy1 = "policy_name=t policy_version=0.0.1\n"
+				    "DEFAULT action=ALLOW";
+	const char *const policy2 = "policy_name=t policy_version=0.0.0\n"
+				    "DEFAULT action=DENY\n";
+
+	ctx = create_fake_ctx();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+
+	p1 = ipe_new_policy(policy1, strlen(policy1), NULL, 0);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, p1);
+
+	ipe_add_policy(ctx, p1);
+
+	p2 = ipe_update_policy(p1, policy2, strlen(policy2), NULL, 0);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, p2);
+
+	fake_free_ctx(ctx);
+	ipe_put_policy(p1);
+	ipe_put_policy(p2);
+}
+
+static struct kunit_case ipe_ctx_test_cases[] = {
+	KUNIT_CASE_PARAM(ipe_ctx_eval_test, ipe_eval_gen_params),
+	KUNIT_CASE_PARAM(ipe_ctx_eval_permissive_test, ipe_eval_gen_params),
+	KUNIT_CASE(ipe_ctx_default_eval_test),
+	KUNIT_CASE(ipe_ctx_replace_active_policy),
+	KUNIT_CASE(ipe_ctx_replace_policy),
+	KUNIT_CASE(ipe_ctx_update_policy),
+	KUNIT_CASE(ipe_ctx_update_wrong_policy),
+	KUNIT_CASE(ipe_ctx_update_rollback_policy),
+	KUNIT_CASE(ipe_ctx_update_rollback_inactive),
+	KUNIT_CASE(ipe_ctx_rollback),
+};
+
+static struct kunit_suite ipe_ctx_test_suite = {
+	.name = "ipe-context",
+	.test_cases = ipe_ctx_test_cases,
+};
+
+kunit_test_suite(ipe_ctx_test_suite);
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 8f8b91c714c2..9a45548118c8 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -231,3 +231,7 @@ void ipe_invalidate_pinned_sb(const struct super_block *mnt_sb)
 
 	spin_unlock(&pin_lock);
 }
+
+#ifdef CONFIG_SECURITY_IPE_KUNIT_TEST
+#include "ctx_test.c"
+#endif /* CONFIG_SECURITY_IPE_KUNIT_TEST */
diff --git a/security/ipe/policy_parser_tests.c b/security/ipe/policy_parser_tests.c
new file mode 100644
index 000000000000..9bc97f0e0a1c
--- /dev/null
+++ b/security/ipe/policy_parser_tests.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <kunit/test.h>
+#include "policy.h"
+
+struct policy_case {
+	const char *const policy;
+	int	   errno;
+	const char *const desc;
+};
+
+static const struct policy_case policy_cases[] = {
+	{
+		"policy_name=\"allowall\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		0,
+		"basic",
+	},
+	{
+		"policy_name='trailing comment' policy_version=152.0.0 #This is comment\n"
+		"DEFAULT action=ALLOW",
+		0,
+		"trailing comment",
+	},
+	{
+		"policy_name=allowallnewline policy_version=0.2.0\n"
+		"DEFAULT action=ALLOW\n"
+		"\n",
+		0,
+		"trailing newline",
+	},
+	{
+		"policy_name=\"carriage return\tline feed\" policy_version=0.0.1\n"
+		"DEFAULT action=ALLOW\n"
+		"\r\n",
+		0,
+		"clrf newline",
+	},
+	{
+		"policy_name='whitespace' policy_version=0.0.0\n"
+		"DEFAULT\taction=ALLOW\n"
+		"     \t     DEFAULT \t    op=EXECUTE      action=DENY\n"
+		"op=EXECUTE boot_verified=TRUE action=ALLOW\n"
+		"# this is a\tcomment\t\t\t\t\n"
+		"DEFAULT \t op=KERNEL_READ\t\t\t  action=DENY\r\n"
+		"op=KERNEL_READ boot_verified=TRUE action=ALLOW\n",
+		0,
+		"various whitespaces and nested default",
+	},
+	{
+		"policy_name='boot verified' policy_version=-1236.0.0\n"
+		"DEFAULT\taction=ALLOW\n",
+		-EINVAL,
+		"negative version",
+	},
+	{
+		"policy_name=\"# this is not a comment\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		0,
+		"quoted '#'",
+	},
+	{
+		"policy_name=$@!*&^%%\\:;{}() policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		0,
+		"special characters",
+	},
+	{
+		"policy_name=test policy_version=999999.0.0\n"
+		"DEFAULT action=ALLOW",
+		-ERANGE,
+		"overflow version",
+	},
+	{
+		"policy_name=test policy_version=255.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"incomplete version",
+	},
+	{
+		"policy_name=test policy_version=111.0.0.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"extra version",
+	},
+	{
+		"",
+		-EBADMSG,
+		"0-length policy",
+	},
+	{
+		"policy_name=\"test\"\0policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"random null in header",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"\0DEFAULT action=ALLOW",
+		-EBADMSG,
+		"incomplete policy from NULL",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n\0"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n",
+		0,
+		"NULL truncates policy",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_signature=abc action=ALLOW",
+		-EBADMSG,
+		"invalid property type",
+	},
+	{
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"missing policy header",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n",
+		-EBADMSG,
+		"missing default definition",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=KERNEL_READ dmverity_signature=TRUE action=ALLOW",
+		0,
+		"aliased operation",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"dmverity_signature=TRUE op=EXECUTE action=ALLOW",
+		-EINVAL,
+		"invalid rule ordering"
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"action=ALLOW op=EXECUTE dmverity_signature=TRUE",
+		-EINVAL,
+		"invalid rule ordering (2)",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW",
+		-EBADMSG,
+		"invalid version",
+	},
+	{
+		"policy_name=\"test\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=UNKNOWN dmverity_signature=TRUE action=ALLOW",
+		-ENOENT,
+		"unknown operation",
+	},
+	{
+		"policy_name=\"asdv\"policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n",
+		-EBADMSG,
+		"missing space after quote",
+	},
+	{
+		"policy_name=\"test\xFF\xEF\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW",
+		0,
+		"expanded ascii",
+	},
+	{
+		"policy_name=\"test\xFF\xEF\" policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_roothash=\"GOOD DOG\" action=ALLOW",
+		-EINVAL,
+		"invalid property value (2)",
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"policy_name='test' policy_version=0.1.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"double header"
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT action=ALLOW\n",
+		-EBADMSG,
+		"double default"
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action=DENY\n"
+		"DEFAULT op=EXECUTE action=ALLOW\n",
+		-EBADMSG,
+		"double operation default"
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action=DEN\n",
+		-EINVAL,
+		"invalid allow value"
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action\n",
+		-EINVAL,
+		"invalid allow value (2)"
+	},
+	{
+		"policy_name='test' policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"UNKNOWN value=true\n",
+		-EINVAL,
+		"unrecognized statement"
+	}
+};
+
+static void pol_to_desc(const struct policy_case *c, char *desc)
+{
+	strncpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(ipe_policies, policy_cases, pol_to_desc);
+
+/**
+ * ipe_parser_unsigned_test: Throw policies at the parser and check the result.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness. This test does not check the correctness
+ * of the policy, but ensures that errors are handled correctly. Functional
+ * validation of correctly-parsed policies are done in the evaluation unit tests.
+ */
+static void ipe_parser_unsigned_test(struct kunit *test)
+{
+	const struct policy_case *p = test->param_value;
+	struct ipe_policy *pol = ipe_new_policy(p->policy, strlen(p->policy), NULL, 0);
+
+	if (p->errno) {
+		KUNIT_EXPECT_EQ(test, PTR_ERR(pol), p->errno);
+		return;
+	}
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pol);
+	KUNIT_EXPECT_EQ(test, 1, refcount_read(&pol->refcount));
+	KUNIT_EXPECT_PTR_EQ(test, NULL, pol->ctx);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, pol->parsed);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, pol->policyfs);
+	KUNIT_EXPECT_STREQ(test, pol->text, p->policy);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, pol->pkcs7);
+	KUNIT_EXPECT_EQ(test, 0, pol->pkcs7len);
+	KUNIT_EXPECT_TRUE(test, list_empty(&pol->next));
+
+	ipe_put_policy(pol);
+}
+
+/**
+ * ipe_parser_widestring_test: Ensure a wide string policy causes a failure.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness.
+ */
+static void ipe_parser_widestring_test(struct kunit *test)
+{
+	struct ipe_policy *pol = NULL;
+	const unsigned short policy[] = L"policy_name=Test policy_version=0.0.0\n"
+					L"DEFAULT action=ALLOW";
+
+	pol = ipe_new_policy((const char *)policy, (ARRAY_SIZE(policy) - 1) * 2, NULL, 0);
+	KUNIT_EXPECT_TRUE(test, IS_ERR_OR_NULL(pol));
+
+	ipe_put_policy(pol);
+}
+
+static struct kunit_case ipe_parser_test_cases[] = {
+	KUNIT_CASE_PARAM(ipe_parser_unsigned_test, ipe_policies_gen_params),
+	KUNIT_CASE(ipe_parser_widestring_test),
+};
+
+static struct kunit_suite ipe_parser_test_suite = {
+	.name = "ipe-parser",
+	.test_cases = ipe_parser_test_cases,
+};
+
+kunit_test_suite(ipe_parser_test_suite);
-- 
2.33.0

