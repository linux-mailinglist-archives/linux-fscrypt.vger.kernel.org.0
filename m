Return-Path: <linux-fscrypt+bounces-229-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 437DC874454
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:37:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE933281F4A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Mar 2024 23:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 242D85A7AB;
	Wed,  6 Mar 2024 23:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="tA1BCOWi"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFAF746521;
	Wed,  6 Mar 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709768101; cv=none; b=om2OEQprBLSJ1aVeXop2BTmYsUZ0cadF8WuoFxLBqhrL2HJHqPzXQ01wo/FvyTjJCzjsMTKBZ8Sss0LM69GFDgai7+CYsHjXLqnqd1+MppvKCJfccZUZwRvoMzaOBM26E/bEW9n5agqMLqOcndhzcRuqK94Xq95U8VsrRRHsY3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709768101; c=relaxed/simple;
	bh=JMGFzxzJSuX8HTzW3/y9gmlqQwTGf542nsFK190Y+i4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=o6LiRsPme5+XAFV6wbqJLWBkM+hvUrbOmJfW3lEZBqmHH6FdEpDCsZqgWdiDvQYHTGYgbl1KhJMw90QbkF0dGGf6rbOxm98zZFzliqUayxV1FI9ADZRDfC30qzVO0LwHpey/WjURpcxWdtXX7KUw4kU9Vhw80hv7t/2cvEsZfSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=tA1BCOWi; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 05AD320B74E2; Wed,  6 Mar 2024 15:34:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 05AD320B74E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709768093;
	bh=KN8yiKPI7h4k5IV/Ds1qGJWY0tuHJk5+XQgL6E7JT+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tA1BCOWijbSd6/cD3MuPcSClMx98QWJiDucrtQ/wkO9jwpO2E/9MSxNph2xTg1TVz
	 terqU6cPyouL7GF/116iNQein0whOv3P2BgOXFjaP/in9nzVZGW9JSShTVQaIgu/cS
	 EEJ7mmL4BQlr4xHoEqDidiYjHkcw8D8k+v5BNsSU=
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
Subject: [RFC PATCH v14 18/19] ipe: kunit test for parser
Date: Wed,  6 Mar 2024 15:34:43 -0800
Message-Id: <1709768084-22539-19-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add various happy/unhappy unit tests for both IPE's policy parser.

Besides, a test suite for IPE functionality is available at
https://github.com/microsoft/ipe/tree/test-suite

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v6:
  + Not present

v7:
  Introduced

v8:
  + Remove the kunit tests with respect to the fsverity digest, as these
    require significant changes to work with the new method of acquiring
    the digest at runtime.

v9:
  + Remove the kunit tests related to ipe_context

v10:
  + No changes

v11:
  + No changes

v12:
  + No changes

v13:
  + No changes

v14:
  + No changes
---
 security/ipe/Kconfig        |  17 +++
 security/ipe/Makefile       |   3 +
 security/ipe/policy_tests.c | 294 ++++++++++++++++++++++++++++++++++++
 3 files changed, 314 insertions(+)
 create mode 100644 security/ipe/policy_tests.c

diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index bf3b9ff0c913..216a9b340caa 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -55,4 +55,21 @@ config IPE_PROP_FS_VERITY
 
 endmenu
 
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
index ce23101b66ba..def674e09e84 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -26,3 +26,6 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	audit.o \
 
 clean-files := boot-policy.c \
+
+obj-$(CONFIG_SECURITY_IPE_KUNIT_TEST) += \
+	policy_tests.o \
diff --git a/security/ipe/policy_tests.c b/security/ipe/policy_tests.c
new file mode 100644
index 000000000000..d67c42c9ca59
--- /dev/null
+++ b/security/ipe/policy_tests.c
@@ -0,0 +1,294 @@
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
+struct policy_case {
+	const char *const policy;
+	int errno;
+	const char *const desc;
+};
+
+static const struct policy_case policy_cases[] = {
+	{
+		"policy_name=allowall policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		0,
+		"basic",
+	},
+	{
+		"policy_name=trailing_comment policy_version=152.0.0 #This is comment\n"
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
+		"policy_name=carriagereturnlinefeed policy_version=0.0.1\n"
+		"DEFAULT action=ALLOW\n"
+		"\r\n",
+		0,
+		"clrf newline",
+	},
+	{
+		"policy_name=whitespace policy_version=0.0.0\n"
+		"DEFAULT\taction=ALLOW\n"
+		"     \t     DEFAULT \t    op=EXECUTE      action=DENY\n"
+		"op=EXECUTE boot_verified=TRUE action=ALLOW\n"
+		"# this is a\tcomment\t\t\t\t\n"
+		"DEFAULT \t op=KMODULE\t\t\t  action=DENY\r\n"
+		"op=KMODULE boot_verified=TRUE action=ALLOW\n",
+		0,
+		"various whitespaces and nested default",
+	},
+	{
+		"policy_name=boot_verified policy_version=-1236.0.0\n"
+		"DEFAULT\taction=ALLOW\n",
+		-EINVAL,
+		"negative version",
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
+		"policy_name=test\0policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"random null in header",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"\0DEFAULT action=ALLOW",
+		-EBADMSG,
+		"incomplete policy from NULL",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=DENY\n\0"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW\n",
+		0,
+		"NULL truncates policy",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
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
+		"policy_name=test policy_version=0.0.0\n",
+		-EBADMSG,
+		"missing default definition",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"dmverity_signature=TRUE op=EXECUTE action=ALLOW",
+		-EBADMSG,
+		"invalid rule ordering"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"action=ALLOW op=EXECUTE dmverity_signature=TRUE",
+		-EBADMSG,
+		"invalid rule ordering (2)",
+	},
+	{
+		"policy_name=test policy_version=0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW",
+		-EBADMSG,
+		"invalid version",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=UNKNOWN dmverity_signature=TRUE action=ALLOW",
+		-EBADMSG,
+		"unknown operation",
+	},
+	{
+		"policy_name=asdvpolicy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n",
+		-EBADMSG,
+		"missing space after policy name",
+	},
+	{
+		"policy_name=test\xFF\xEF policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_signature=TRUE action=ALLOW",
+		0,
+		"expanded ascii",
+	},
+	{
+		"policy_name=test\xFF\xEF policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_roothash=GOOD_DOG action=ALLOW",
+		-EBADMSG,
+		"invalid property value (2)",
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"policy_name=test policy_version=0.1.0\n"
+		"DEFAULT action=ALLOW",
+		-EBADMSG,
+		"double header"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT action=ALLOW\n",
+		-EBADMSG,
+		"double default"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action=DENY\n"
+		"DEFAULT op=EXECUTE action=ALLOW\n",
+		-EBADMSG,
+		"double operation default"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action=DEN\n",
+		-EBADMSG,
+		"invalid action value"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"DEFAULT op=EXECUTE action\n",
+		-EBADMSG,
+		"invalid action value (2)"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"UNKNOWN value=true\n",
+		-EBADMSG,
+		"unrecognized statement"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE dmverity_roothash=1c0d7ee1f8343b7fbe418378e8eb22c061d7dec7 action=DENY\n",
+		-EBADMSG,
+		"old-style digest"
+	},
+	{
+		"policy_name=test policy_version=0.0.0\n"
+		"DEFAULT action=ALLOW\n"
+		"op=EXECUTE fsverity_digest=1c0d7ee1f8343b7fbe418378e8eb22c061d7dec7 action=DENY\n",
+		-EBADMSG,
+		"old-style digest"
+	}
+};
+
+static void pol_to_desc(const struct policy_case *c, char *desc)
+{
+	strscpy(desc, c->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+KUNIT_ARRAY_PARAM(ipe_policies, policy_cases, pol_to_desc);
+
+/**
+ * ipe_parser_unsigned_test - Test the parser by passing unsigned policies.
+ * @test: Supplies a pointer to a kunit structure.
+ *
+ * This is called by the kunit harness. This test does not check the correctness
+ * of the policy, but ensures that errors are handled correctly.
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
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, pol->parsed);
+	KUNIT_EXPECT_STREQ(test, pol->text, p->policy);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, pol->pkcs7);
+	KUNIT_EXPECT_EQ(test, 0, pol->pkcs7len);
+
+	ipe_free_policy(pol);
+}
+
+/**
+ * ipe_parser_widestring_test - Ensure parser fail on a wide string policy.
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
+	ipe_free_policy(pol);
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
2.43.1


