Return-Path: <linux-fscrypt+bounces-141-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D064B842FD6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F41481C24402
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62F412837A;
	Tue, 30 Jan 2024 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="e4BMtpEv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CAD78B6D;
	Tue, 30 Jan 2024 22:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654245; cv=none; b=XjFD8S31On0xYI5VYCqgRXcpAParySWOGFTPtL6vCu0z58meNSqKIzgVROSAlPByxtGwMc+leymfUuXV7jfBFw+rw3IXDgQro2TtQcb4SK/6NPdhV4rYjU3i84bD5rKRfWXyc6t2E4q6lsYCpiQ+YU0BKjHU1PUaF7jzYoWa2yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654245; c=relaxed/simple;
	bh=tFaUeER30hosoJ+OPdSsgr1pXSqyKZEV/QNpQ5VRXqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Db6gM26LpuuOi5njZn4yEO/DXfuSrxh6hRbk3ff3bFxqkO32uNxBueYBE9yX5XI9gLfxJjEnigE/egKzocN0S7CPO6kX415cSiH0vFiScJn9XwPbgkjD6EwZDerh3ZFIQKo1dcF192cMnpO6AFm21OKcoqk5UmGQtdeDsxr3r3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=e4BMtpEv; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 1713F20B2003; Tue, 30 Jan 2024 14:37:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1713F20B2003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=RI94jOT/R/a54qYYhDK+OanuSVzhv0ZoCkBytf6U4PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4BMtpEv0x+VEYI/SgN/yn03yyjnw6/RrRl9pcTgCG88Av9CPgpq1jn4UOma1aWxd
	 fm1HEwyXtTEZY0K/YT05k3D/98mpVrPl737keon90rYs2PGhFAOqDBUhVqkFeV1VXz
	 6cxJIbibPvjWhUUH5igN5jAd6ya8EPh4g6wWGxuI=
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
Subject: [RFC PATCH v12 03/20] ipe: add evaluation loop
Date: Tue, 30 Jan 2024 14:36:51 -0800
Message-Id: <1706654228-17180-4-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE must have a centralized function to evaluate incoming callers
against IPE's policy. This iteration of the policy for against the rules
for that specific caller is known as the evaluation loop.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v2:
+ Split evaluation loop, access control hooks, and evaluation loop from policy parser and userspace interface to pass mailing list character limit

v3:
+ Move ipe_load_properties to patch 04.
+ Remove useless 0-initializations Prefix extern variables with ipe_
+ Remove kernel module parameters, as these are exposed through sysctls.
+ Add more prose to the IPE base config option help text.
+ Use GFP_KERNEL for audit_log_start.
+ Remove unnecessary caching system.
+ Remove comments from headers
+ Use rcu_access_pointer for rcu-pointer null check
+ Remove usage of reqprot; use prot only.
+Move policy load and activation audit event to 03/12

v4:
+ Remove sysctls in favor of securityfs nodes
+ Re-add kernel module parameters, as these are now exposed through securityfs.
+ Refactor property audit loop to a separate function.

v5:
+ fix minor grammatical errors
+ do not group rule by curly-brace in audit record,
+ reconstruct the exact rule.

v6:
+ No changes

v7:
+ Further split lsm creation into a separate commit from the evaluation loop and audit system, for easier review.
+ Propagating changes to support the new ipe_context structure in the evaluation loop.

v8:
+ Remove ipe_hook enumeration; hooks can be correlated via syscall record.

v9:
+ Remove ipe_context related code and simplify the evaluation loop.

v10:
+ Split eval part and boot_verified part

v11:
+ Fix code style issues

v12:
+ Correct an rcu_read_unlock usage
+ Add a WARN to unknown op during evaluation
---
 security/ipe/Makefile |   1 +
 security/ipe/eval.c   | 100 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/eval.h   |  24 ++++++++++
 3 files changed, 125 insertions(+)
 create mode 100644 security/ipe/eval.c
 create mode 100644 security/ipe/eval.h

diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index c09aec4904f2..57fe922cf1fc 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -6,6 +6,7 @@
 #
 
 obj-$(CONFIG_SECURITY_IPE) += \
+	eval.o \
 	ipe.o \
 	policy.o \
 	policy_parser.o \
diff --git a/security/ipe/eval.c b/security/ipe/eval.c
new file mode 100644
index 000000000000..af56815ed0fa
--- /dev/null
+++ b/security/ipe/eval.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/fs.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/sched.h>
+#include <linux/rcupdate.h>
+
+#include "ipe.h"
+#include "eval.h"
+#include "policy.h"
+
+struct ipe_policy __rcu *ipe_active_policy;
+
+/**
+ * evaluate_property - Analyze @ctx against a property.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ * @p: Supplies a pointer to the property to be evaluated.
+ *
+ * Return:
+ * * true	- The current @ctx match the @p
+ * * false	- The current @ctx doesn't match the @p
+ */
+static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
+			      struct ipe_prop *p)
+{
+	return false;
+}
+
+/**
+ * ipe_evaluate_event - Analyze @ctx against the current active policy.
+ * @ctx: Supplies a pointer to the context to be evaluated.
+ *
+ * This is the loop where all policy evaluation happens against IPE policy.
+ *
+ * Return:
+ * * 0		- OK
+ * * -EACCES	- @ctx did not pass evaluation.
+ * * !0		- Error
+ */
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
+{
+	bool match = false;
+	enum ipe_action_type action;
+	struct ipe_policy *pol = NULL;
+	const struct ipe_rule *rule = NULL;
+	const struct ipe_op_table *rules = NULL;
+	struct ipe_prop *prop = NULL;
+
+	rcu_read_lock();
+
+	pol = rcu_dereference(ipe_active_policy);
+	if (!pol) {
+		rcu_read_unlock();
+		return 0;
+	}
+
+	if (ctx->op == IPE_OP_INVALID) {
+		if (pol->parsed->global_default_action == IPE_ACTION_DENY) {
+			rcu_read_unlock();
+			return -EACCES;
+		}
+		if (pol->parsed->global_default_action == IPE_ACTION_INVALID)
+			WARN(1, "no default rule set for unknown op, ALLOW it");
+		rcu_read_unlock();
+		return 0;
+	}
+
+	rules = &pol->parsed->rules[ctx->op];
+
+	list_for_each_entry(rule, &rules->rules, next) {
+		match = true;
+
+		list_for_each_entry(prop, &rule->props, next) {
+			match = evaluate_property(ctx, prop);
+			if (!match)
+				break;
+		}
+
+		if (match)
+			break;
+	}
+
+	if (match)
+		action = rule->action;
+	else if (rules->default_action != IPE_ACTION_INVALID)
+		action = rules->default_action;
+	else
+		action = pol->parsed->global_default_action;
+
+	rcu_read_unlock();
+	if (action == IPE_ACTION_DENY)
+		return -EACCES;
+
+	return 0;
+}
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
new file mode 100644
index 000000000000..6b434515968f
--- /dev/null
+++ b/security/ipe/eval.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _IPE_EVAL_H
+#define _IPE_EVAL_H
+
+#include <linux/file.h>
+#include <linux/types.h>
+
+#include "policy.h"
+
+extern struct ipe_policy __rcu *ipe_active_policy;
+
+struct ipe_eval_ctx {
+	enum ipe_op_type op;
+
+	const struct file *file;
+};
+
+int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx);
+
+#endif /* _IPE_EVAL_H */
-- 
2.43.0


