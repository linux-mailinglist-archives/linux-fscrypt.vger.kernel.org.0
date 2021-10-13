Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EA842C95F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbhJMTIs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:08:48 -0400
Received: from linux.microsoft.com ([13.77.154.182]:48848 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236537AbhJMTIn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:43 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 76EC320B9CE1;
        Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 76EC320B9CE1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634151999;
        bh=MY4BLlBH7yfJXATWb05+GEk0Q/Ik2x0bfG/P66TvFok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlUZ/M18mNxQmE0odicjxxwp2jz+SiiKyak62t0sAhWwZ7WHAceWeo54l6uRjwzhv
         aUrS+LOiQv3AhQfI6lInp7TMhOsG92JzAQ1BJwbXIfloV3CZHultNOsDNl5QEmm9nh
         3FJVaOd+HlvV07YMweWidyIrF/KUuuE8wyJQLUYk=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 02/16] ipe: add policy parser
Date:   Wed, 13 Oct 2021 12:06:21 -0700
Message-Id: <1634151995-16266-3-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

IPE's interpretation of the what the user trusts is accomplished through
its policy. IPE's design is to not provide support for a single trust
provider, but to support multiple providers to enable the end-user to
choose the best one to seek their needs.

This requires the policy to be rather flexible and modular so that
trust/integrity providers, like fs-verity or dm-verity, can plug
into the policy with minimal code changes.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Refactor policy parser to make code cleaner via introducing
    clearly defined passes, with specific goal states.
  * Split up patch 03/12 into two parts:
      1. parser [02/16] (this patch)
      2. userspace interface [04/16]

---
 include/asm-generic/vmlinux.lds.h    |  16 +
 security/ipe/Makefile                |   6 +
 security/ipe/ipe.c                   |  63 ++
 security/ipe/ipe.h                   |   4 +
 security/ipe/ipe_parser.h            |  59 ++
 security/ipe/modules.c               | 109 +++
 security/ipe/modules.h               |  17 +
 security/ipe/modules/ipe_module.h    |  33 +
 security/ipe/parsers.c               | 139 ++++
 security/ipe/parsers/Makefile        |  12 +
 security/ipe/parsers/default.c       | 106 +++
 security/ipe/parsers/policy_header.c | 126 ++++
 security/ipe/policy.c                | 946 +++++++++++++++++++++++++++
 security/ipe/policy.h                |  97 +++
 14 files changed, 1733 insertions(+)
 create mode 100644 security/ipe/ipe_parser.h
 create mode 100644 security/ipe/modules.c
 create mode 100644 security/ipe/modules.h
 create mode 100644 security/ipe/modules/ipe_module.h
 create mode 100644 security/ipe/parsers.c
 create mode 100644 security/ipe/parsers/Makefile
 create mode 100644 security/ipe/parsers/default.c
 create mode 100644 security/ipe/parsers/policy_header.c
 create mode 100644 security/ipe/policy.c
 create mode 100644 security/ipe/policy.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f2984af2b85b..91abbacbaf8d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -278,6 +278,20 @@
 #define EARLY_LSM_TABLE()
 #endif
 
+#ifdef CONFIG_SECURITY_IPE
+#define IPE_PARSER_TABLE()	. = ALIGN(8);				\
+				__start_ipe_parsers = .;		\
+				KEEP(*(.ipe_parsers))		\
+				__end_ipe_parsers = .;
+#define IPE_MODULE_TABLE()	. = ALIGN(8);				\
+				__start_ipe_modules = .;		\
+				KEEP(*(.ipe_modules))			\
+				__end_ipe_modules = .;
+#else
+#define IPE_PARSER_TABLE()
+#define IPE_MODULE_TABLE()
+#endif
+
 #define ___OF_TABLE(cfg, name)	_OF_TABLE_##cfg(name)
 #define __OF_TABLE(cfg, name)	___OF_TABLE(cfg, name)
 #define OF_TABLE(cfg, name)	__OF_TABLE(IS_ENABLED(cfg), name)
@@ -436,6 +450,8 @@
 		KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
 		__stop___tracepoints_ptrs = .;				\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
+		IPE_PARSER_TABLE()					\
+		IPE_MODULE_TABLE()					\
 	}								\
 									\
 	.rodata1          : AT(ADDR(.rodata1) - LOAD_OFFSET) {		\
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index ba3df729e252..9a97efd8a190 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -5,7 +5,13 @@
 # Makefile for building the IPE module as part of the kernel tree.
 #
 
+ccflags-y := -I$(srctree)/security/ipe/modules
+
 obj-$(CONFIG_SECURITY_IPE) += \
 	ctx.o \
 	hooks.o \
 	ipe.o \
+	modules.o \
+	parsers/ \
+	parsers.o \
+	policy.o \
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index d600346702e5..b58b372327a1 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -6,6 +6,9 @@
 #include "ipe.h"
 #include "ctx.h"
 #include "hooks.h"
+#include "ipe_parser.h"
+#include "modules/ipe_module.h"
+#include "modules.h"
 
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -24,6 +27,58 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_free, ipe_task_free),
 };
 
+/**
+ * load_parsers: Load all the parsers compiled into IPE. This needs
+ *		 to be called prior to the boot policy being loaded.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+static int load_parsers(void)
+{
+	int rc = 0;
+	struct ipe_parser *parser;
+
+	for (parser = __start_ipe_parsers; parser < __end_ipe_parsers; ++parser) {
+		rc = ipe_register_parser(parser);
+		if (rc) {
+			pr_err("failed to initialize '%s'", parser->first_token);
+			return rc;
+		}
+
+		pr_info("initialized parser module '%s'", parser->first_token);
+	}
+
+	return 0;
+}
+
+/**
+ * load_modules: Load all the modules compiled into IPE. This needs
+ *		 to be called prior to the boot policy being loaded.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+static int load_modules(void)
+{
+	int rc = 0;
+	struct ipe_module *m;
+
+	for (m = __start_ipe_modules; m < __end_ipe_modules; ++m) {
+		rc = ipe_register_module(m);
+		if (rc) {
+			pr_err("failed to initialize '%s'", m->name);
+			return rc;
+		}
+
+		pr_info("initialized module '%s'", m->name);
+	}
+
+	return 0;
+}
+
 /**
  * ipe_init: Entry point of IPE.
  *
@@ -41,6 +96,14 @@ static int __init ipe_init(void)
 {
 	int rc = 0;
 
+	rc = load_parsers();
+	if (rc)
+		return rc;
+
+	rc = load_modules();
+	if (rc)
+		return rc;
+
 	rc = ipe_init_ctx();
 	if (rc)
 		return rc;
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
index 09c492b8fd03..ad16d2bebfec 100644
--- a/security/ipe/ipe.h
+++ b/security/ipe/ipe.h
@@ -9,11 +9,15 @@
 #define pr_fmt(fmt) "IPE " fmt "\n"
 
 #include "ctx.h"
+#include "ipe_parser.h"
+#include "modules/ipe_module.h"
 
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/lsm_hooks.h>
 
 extern struct lsm_blob_sizes ipe_blobs;
+extern struct ipe_parser __start_ipe_parsers[], __end_ipe_parsers[];
+extern struct ipe_module __start_ipe_modules[], __end_ipe_modules[];
 
 #endif /* IPE_H */
diff --git a/security/ipe/ipe_parser.h b/security/ipe/ipe_parser.h
new file mode 100644
index 000000000000..f7c5c11bde44
--- /dev/null
+++ b/security/ipe/ipe_parser.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_PARSER_H
+#define IPE_PARSER_H
+
+#include "policy.h"
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+/*
+ * Struct used to define internal parsers that effect the policy,
+ * but do not belong as policy modules, as they are not used to make
+ * decisions in the event loop, and only effect the internal workings
+ * of IPE.
+ *
+ * These structures are used in pass2, and policy deallocation.
+ */
+struct ipe_parser {
+	u8 version;
+	const char *first_token;
+
+	int (*parse)(const struct ipe_policy_line *line,
+		     struct ipe_parsed_policy *pol);
+	int (*free)(struct ipe_parsed_policy *pol);
+	int (*validate)(const struct ipe_parsed_policy *pol);
+};
+
+int ipe_parse_op(const struct ipe_policy_token *tok,
+		 enum ipe_operation *op);
+
+int ipe_parse_action(const struct ipe_policy_token *tok,
+		     enum ipe_action *action);
+
+/*
+ * Optional struct to make structured parsers easier.
+ */
+struct ipe_token_parser {
+	const char *key;
+	int (*parse_token)(const struct ipe_policy_token *t,
+			   struct ipe_parsed_policy *p);
+};
+
+const struct ipe_parser *ipe_lookup_parser(const char *first_token);
+
+int ipe_for_each_parser(int (*view)(const struct ipe_parser *parser,
+				    void *ctx),
+			void *ctx);
+
+int ipe_register_parser(struct ipe_parser *p);
+
+#define IPE_PARSER(parser)				\
+	static struct ipe_parser __ipe_parser_##parser	\
+		__used __section(".ipe_parsers")	\
+		__aligned(sizeof(unsigned long))
+
+#endif /* IPE_PARSER_MODULE_H */
diff --git a/security/ipe/modules.c b/security/ipe/modules.c
new file mode 100644
index 000000000000..fb100c14cce5
--- /dev/null
+++ b/security/ipe/modules.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "modules.h"
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+static struct rb_root module_root = RB_ROOT;
+
+struct module_container {
+	struct rb_node node;
+	const struct ipe_module *mod;
+};
+
+/**
+ * cmp_node: Comparator for a node in the module lookup tree.
+ * @n: First node to compare
+ * @nn: Second node to compare
+ *
+ * Return:
+ * <0 - @n's key is lexigraphically before @nn.
+ * 0 - n's key is identical to @nn
+ * >0 - n's key is legxigraphically after @nn
+ */
+static int cmp_node(struct rb_node *n, const struct rb_node *nn)
+{
+	const struct module_container *c1;
+	const struct module_container *c2;
+
+	c1 = container_of(n, struct module_container, node);
+	c2 = container_of(nn, struct module_container, node);
+
+	return strcmp(c1->mod->name, c2->mod->name);
+}
+
+/**
+ * cmp_key: Comparator to find a module in the tree by key.
+ * @key: Supplies a pointer to a null-terminated string key
+ * @n: Node to compare @key against
+ *
+ * Return:
+ * <0 - Desired node is to the left of @n
+ * 0  - @n is the desired node
+ * >0 - Desired node is to the right of @n
+ */
+static int cmp_key(const void *key, const struct rb_node *n)
+{
+	struct module_container *mod;
+
+	mod = container_of(n, struct module_container, node);
+
+	return strcmp((const char *)key, mod->mod->name);
+}
+
+/**
+ * ipe_lookup_module: Attempt to find a ipe_pmodule structure by @key.
+ * @key: The key to look for in the tree.
+ *
+ * Return:
+ * !NULL - OK
+ * NULL - No property exists under @key
+ */
+const struct ipe_module *ipe_lookup_module(const char *key)
+{
+	struct rb_node *n;
+
+	n = rb_find(key, &module_root, cmp_key);
+	if (!n)
+		return NULL;
+
+	return container_of(n, struct module_container, node)->mod;
+}
+
+/**
+ * ipe_register_module: Register a policy module to be used in IPE's policy.
+ * @m: Module to register.
+ *
+ * This function allows parsers (policy constructs that represent integrations
+ * with other subsystems, to be leveraged in rules) to be leveraged in IPE policy.
+ * This must be called prior to any policies being loaded.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_register_module(struct ipe_module *m)
+{
+	struct rb_node *n = NULL;
+	struct module_container *c = NULL;
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->mod = m;
+
+	n = rb_find_add(&c->node, &module_root, cmp_node);
+	if (n) {
+		kfree(c);
+		return -EEXIST;
+	}
+
+	return 0;
+}
diff --git a/security/ipe/modules.h b/security/ipe/modules.h
new file mode 100644
index 000000000000..7b897bdd870b
--- /dev/null
+++ b/security/ipe/modules.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_MODULES_H
+#define IPE_MODULES_H
+
+#include "ipe.h"
+#include "ipe_module.h"
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+const struct ipe_module *ipe_lookup_module(const char *key);
+int ipe_register_module(struct ipe_module *m);
+
+#endif /* IPE_MODULES_H */
diff --git a/security/ipe/modules/ipe_module.h b/security/ipe/modules/ipe_module.h
new file mode 100644
index 000000000000..397a54cbc4db
--- /dev/null
+++ b/security/ipe/modules/ipe_module.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_MODULE_H
+#define IPE_MODULE_H
+
+#include <linux/types.h>
+
+/**
+ * ipe_module: definition of an extensible module for IPE properties.
+ *	       These structures are used to implement 'key=value' pairs
+ *	       in IPE policy, which will be evaluated on every IPE policy
+ *	       evaluation.
+ *
+ *	       Integrity mechanisms should be define as a module, and modules
+ *	       should manage their own dependencies via KConfig. @name is both
+ *	       the key half of the key=value pair in the policy, and the unique
+ *	       identifier for the module.
+ */
+struct ipe_module {
+	const char			*const name;	/* required */
+	u16				version;	/* required */
+	int (*parse)(const char *valstr, void **value);	/* required */
+	int (*free)(void **value);			/* optional */
+};
+
+#define IPE_MODULE(parser)				\
+	static struct ipe_module __ipe_module_##parser	\
+		__used __section(".ipe_modules")	\
+		__aligned(sizeof(unsigned long))
+
+#endif /* IPE_MODULE_H */
diff --git a/security/ipe/parsers.c b/security/ipe/parsers.c
new file mode 100644
index 000000000000..80dc4704ae40
--- /dev/null
+++ b/security/ipe/parsers.c
@@ -0,0 +1,139 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "policy.h"
+#include "ipe_parser.h"
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/rbtree.h>
+
+static struct rb_root ipe_parser_root = RB_ROOT;
+
+struct parser_container {
+	struct rb_node node;
+	const struct ipe_parser *parser;
+};
+
+/**
+ * cmp_key: Comparator for the nodes within the parser tree by key
+ * @key: Supplies a the key to evaluate nodes against
+ * @n: Supplies a pointer to the node to compare.
+ *
+ * Return:
+ * <0 - @key is to the left of @n
+ * 0 - @key identifies @n
+ * >0 - @key is to the right of @n
+ */
+static int cmp_key(const void *key, const struct rb_node *n)
+{
+	const struct parser_container *node;
+
+	node = container_of(n, struct parser_container, node);
+
+	return strcmp((const char *)key, node->parser->first_token);
+}
+
+/**
+ * cmp_node: Comparator for the nodes within the parser tree
+ * @n: Supplies a pointer to the node to compare
+ * @nn: Supplies a pointer to the another node to compare.
+ *
+ * Return:
+ * <0 - @n is lexigraphically before @nn
+ * 0 - @n is identical @nn
+ * >0 - @n is lexigraphically after @nn
+ */
+static int cmp_node(struct rb_node *n, const struct rb_node *nn)
+{
+	const struct parser_container *c1;
+	const struct parser_container *c2;
+
+	c1 = container_of(n, struct parser_container, node);
+	c2 = container_of(nn, struct parser_container, node);
+
+	return strcmp(c1->parser->first_token, c2->parser->first_token);
+}
+
+/**
+ * ipe_lookup_parser: Attempt to find a ipe_property structure by @first_token.
+ * @first_token: The key to look for in the tree.
+ *
+ * Return:
+ * !NULL - OK
+ * NULL - No property exists under @key
+ */
+const struct ipe_parser *ipe_lookup_parser(const char *first_token)
+{
+	struct rb_node *n;
+
+	n = rb_find(first_token, &ipe_parser_root, cmp_key);
+	if (!n)
+		return NULL;
+
+	return container_of(n, struct parser_container, node)->parser;
+}
+
+/**
+ * ipe_for_each_parser: Iterate over all currently-registered parsers
+ *			calling @fn on the values, and providing @view @ctx.
+ * @view: The function to call for each property. This is given the property
+ *	  structure as the first argument, and @ctx as the second.
+ * @ctx: caller-specified context that is passed to the function. Can be NULL.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Proper errno as returned by @view.
+ */
+int ipe_for_each_parser(int (*view)(const struct ipe_parser *parser,
+				    void *ctx),
+			void *ctx)
+{
+	int rc = 0;
+	struct rb_node *node;
+	struct parser_container *val;
+
+	for (node = rb_first(&ipe_parser_root); node; node = rb_next(node)) {
+		val = container_of(node, struct parser_container, node);
+
+		rc = view(val->parser, ctx);
+		if (rc)
+			return rc;
+	}
+
+	return rc;
+}
+
+/**
+ * ipe_register_parser: Register a parser to be used in IPE's policy.
+ * @p: Parser to register.
+ *
+ * This function allows parsers (policy constructs that effect IPE's
+ * internal functionality) to be leveraged in IPE policy. This must
+ * be called prior to any policies being loaded.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int ipe_register_parser(struct ipe_parser *p)
+{
+	struct rb_node *n = NULL;
+	struct parser_container *c = NULL;
+
+	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return -ENOMEM;
+
+	c->parser = p;
+
+	n = rb_find_add(&c->node, &ipe_parser_root, cmp_node);
+	if (n) {
+		kfree(c);
+		return -EEXIST;
+	}
+
+	return 0;
+}
diff --git a/security/ipe/parsers/Makefile b/security/ipe/parsers/Makefile
new file mode 100644
index 000000000000..1a19a094724f
--- /dev/null
+++ b/security/ipe/parsers/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+ccflags-y := -I$(srctree)/security/ipe
+
+obj-$(CONFIG_SECURITY_IPE) += \
+	default.o \
+	policy_header.o \
diff --git a/security/ipe/parsers/default.c b/security/ipe/parsers/default.c
new file mode 100644
index 000000000000..30181d2cc4ed
--- /dev/null
+++ b/security/ipe/parsers/default.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+
+#include "ipe_parser.h"
+
+static int set_op_default(enum ipe_operation op, enum ipe_action act,
+			  struct ipe_parsed_policy *pol)
+{
+	size_t i, remap_len;
+	const enum ipe_operation *remap;
+
+	if (!ipe_is_op_alias(op, &remap, &remap_len)) {
+		if (pol->rules[op].default_action != ipe_action_max)
+			return -EBADMSG;
+
+		pol->rules[op].default_action = act;
+		return 0;
+	}
+
+	for (i = 0; i < remap_len; ++i) {
+		if (pol->rules[remap[i]].default_action != ipe_action_max)
+			return -EBADMSG;
+
+		pol->rules[remap[i]].default_action = act;
+	}
+
+	return 0;
+}
+
+static int parse_default(const struct ipe_policy_line *line,
+			 struct ipe_parsed_policy *pol)
+{
+	int rc = 0;
+	size_t idx = 0;
+	struct ipe_policy_token *tok = NULL;
+	enum ipe_operation op = ipe_operation_max;
+	enum ipe_action act = ipe_action_max;
+
+	list_for_each_entry(tok, &line->tokens, next) {
+		switch (idx) {
+		case 0:
+			if (strcmp("DEFAULT", tok->key) || tok->value)
+				return -EBADMSG;
+			break;
+		case 1:
+			/* schema 1 - operation, followed by action */
+			rc = ipe_parse_op(tok, &op);
+			if (!rc) {
+				++idx;
+				continue;
+			}
+
+			if (pol->global_default != ipe_action_max)
+				return -EBADMSG;
+
+			/* schema 2 - action */
+			rc = ipe_parse_action(tok, &pol->global_default);
+			if (!rc)
+				return rc;
+
+			return -EBADMSG;
+		case 2:
+			rc = ipe_parse_action(tok, &act);
+			if (rc)
+				return rc;
+
+			return set_op_default(op, act, pol);
+		default:
+			return -EBADMSG;
+		}
+		++idx;
+	}
+
+	/* met no schema */
+	return -EBADMSG;
+}
+
+static int validate_defaults(const struct ipe_parsed_policy *p)
+{
+	size_t i = 0;
+
+	if (p->global_default != ipe_action_max)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
+		if (p->rules[i].default_action == ipe_action_max)
+			return -EBADMSG;
+	}
+
+	return 0;
+}
+
+IPE_PARSER(default_decl) = {
+	.first_token = "DEFAULT",
+	.version = 1,
+	.parse = parse_default,
+	.free = NULL,
+	.validate = validate_defaults,
+};
diff --git a/security/ipe/parsers/policy_header.c b/security/ipe/parsers/policy_header.c
new file mode 100644
index 000000000000..4d3c1a42c915
--- /dev/null
+++ b/security/ipe/parsers/policy_header.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe_parser.h"
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+
+#include "ipe_parser.h"
+
+static int parse_name(const struct ipe_policy_token *t,
+		      struct ipe_parsed_policy *p)
+{
+	if (p->name)
+		return -EBADMSG;
+
+	p->name = kstrdup_const(t->value, GFP_KERNEL);
+	if (!p->name)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int parse_ver(const struct ipe_policy_token *t,
+		     struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	char *dup = NULL;
+	char *dup2 = NULL;
+	char *token = NULL;
+	size_t sep_count = 0;
+	u16 *const cv[] = { &p->version.major, &p->version.minor, &p->version.rev };
+
+	dup = kstrdup(t->value, GFP_KERNEL);
+	if (!dup) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	dup2 = dup;
+
+	while ((token = strsep(&dup, ".\n")) != NULL) {
+		/* prevent overflow */
+		if (sep_count >= ARRAY_SIZE(cv)) {
+			rc = -EBADMSG;
+			goto err;
+		}
+
+		rc = kstrtou16(token, 10, cv[sep_count]);
+		if (rc)
+			goto err;
+
+		++sep_count;
+	}
+
+	/* prevent underflow */
+	if (sep_count != ARRAY_SIZE(cv))
+		rc = -EBADMSG;
+
+err:
+	kfree(dup2);
+	return rc;
+}
+
+static const struct ipe_token_parser parsers[] = {
+	{ .key = "policy_name", .parse_token = parse_name },
+	{ .key = "policy_version", .parse_token = parse_ver },
+};
+
+static int parse_policy_hdr(const struct ipe_policy_line *line,
+			    struct ipe_parsed_policy *pol)
+{
+	int rc = 0;
+	size_t idx = 0;
+	struct ipe_policy_token *tok = NULL;
+	const struct ipe_token_parser *p = NULL;
+
+	list_for_each_entry(tok, &line->tokens, next) {
+		if (!tok->value || idx >= sizeof(parsers)) {
+			rc = -EBADMSG;
+			goto err;
+		}
+
+		p = &parsers[idx];
+
+		if (strcmp(p->key, tok->key)) {
+			rc = -EBADMSG;
+			goto err;
+		}
+
+		rc = p->parse_token(tok, pol);
+		if (rc)
+			goto err;
+
+		++idx;
+	}
+
+	return 0;
+
+err:
+	return rc;
+}
+
+static int free_policy_hdr(struct ipe_parsed_policy *pol)
+{
+	kfree(pol->name);
+	return 0;
+}
+
+static int validate_policy_hdr(const struct ipe_parsed_policy *p)
+{
+	return !p->name ? -EBADMSG : 0;
+}
+
+IPE_PARSER(policy_header) = {
+	.first_token = "policy_name",
+	.version = 1,
+	.parse = parse_policy_hdr,
+	.free = free_policy_hdr,
+	.validate = validate_policy_hdr,
+};
diff --git a/security/ipe/policy.c b/security/ipe/policy.c
new file mode 100644
index 000000000000..9dd60dd34477
--- /dev/null
+++ b/security/ipe/policy.c
@@ -0,0 +1,946 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "policy.h"
+#include "ipe_parser.h"
+#include "modules.h"
+
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/ctype.h>
+#include <linux/types.h>
+#include <linux/parser.h>
+#include <linux/verification.h>
+
+#define START_COMMENT	'#'
+#define KEYVAL_DELIMIT	'='
+
+static inline bool is_quote(char ch)
+{
+	return ch == '\'' || ch == '\"';
+}
+
+/**
+ * is_key_char: Determine whether @ch is an acceptable character for a
+ *		key type
+ * @ch: Supplies the character to evaluate.
+ *
+ * Return:
+ * true - Character is acceptable.
+ * false - Character is not acceptable.
+ */
+static inline bool is_key_char(char ch)
+{
+	return isalnum(ch) || ch == '_';
+}
+
+/**
+ * is_val_char: Determine whether @ch is an acceptable character for a
+ *		value type
+ * @ch: Supplies the character to evaluate.
+ *
+ * Return:
+ * true - Character is acceptable.
+ * false - Character is not acceptable.
+ */
+static inline bool is_val_char(char ch)
+{
+	return isgraph(ch) || ch == ' ' || ch == '\t';
+}
+
+/**
+ * free_parser: Callback to invoke, freeing data allocated by parsers.
+ * @parser: parser to free data.
+ * @ctx: ctx object passed to ipe_for_each_parser.
+ *
+ * This function is intended to be used with ipe_for_each_parser only.
+ *
+ * Return:
+ * 0 - Always
+ */
+static int free_parser(const struct ipe_parser *parser, void *ctx)
+{
+	struct ipe_parsed_policy *pol = ctx;
+
+	if (parser->free)
+		parser->free(pol);
+
+	return 0;
+}
+
+/**
+ * free_rule: free an ipe_rule.
+ * @r: Supplies the rule to free.
+ *
+ * This function is safe to call if @r is NULL or ERR_PTR.
+ */
+static void free_rule(struct ipe_rule *r)
+{
+	struct ipe_policy_mod *p, *t;
+
+	if (IS_ERR_OR_NULL(r))
+		return;
+
+	list_for_each_entry_safe(p, t, &r->modules, next) {
+		if (p->mod->free)
+			p->mod->free(p->mod_value);
+
+		kfree(p);
+	}
+
+	kfree(r);
+}
+
+static void free_parsed_policy(struct ipe_parsed_policy *p)
+{
+	size_t i = 0;
+	struct ipe_rule *pp, *t;
+
+	if (IS_ERR_OR_NULL(p))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i)
+		list_for_each_entry_safe(pp, t, &p->rules[i].rules, next)
+			free_rule(pp);
+
+	(void)ipe_for_each_parser(free_parser, p);
+	kfree(p);
+}
+
+/**
+ * free_parsed_line: free a single parsed line of tokens.
+ * @line: Supplies the line to free.
+ *
+ * This function is safe to call if @line is NULL or ERR_PTR.
+ */
+static void free_parsed_line(struct ipe_policy_line *line)
+{
+	struct ipe_policy_token *p, *t;
+
+	if (IS_ERR_OR_NULL(line))
+		return;
+
+	list_for_each_entry_safe(p, t, &line->tokens, next)
+		kfree(p);
+}
+
+/**
+ * free_parsed_text: free a 2D list representing a tokenized policy.
+ * @parsed: Supplies the policy to free.
+ *
+ * This function is safe to call if @parsed is NULL or ERR_PTR.
+ */
+static void free_parsed_text(struct list_head *parsed)
+{
+	struct ipe_policy_line *p, *t;
+
+	if (IS_ERR_OR_NULL(parsed))
+		return;
+
+	list_for_each_entry_safe(p, t, parsed, next)
+		free_parsed_line(p);
+}
+
+/**
+ * trim_quotes: Edit @str to remove a single instance of a trailing and
+ *		leading quotes.
+ * @str: Supplies the string to edit.
+ *
+ * If the string is not quoted, @str will be returned. This function is
+ * safe to call if @str is NULL.
+ *
+ * Return:
+ * !0 - OK
+ * ERR_PTR(-EBADMSG) - Quote mismatch.
+ */
+static char *trim_quotes(char *str)
+{
+	char s;
+	size_t len;
+
+	if (!str)
+		return str;
+
+	s = *str;
+
+	if (is_quote(s)) {
+		len = strlen(str) - 1;
+
+		if (str[len] != s)
+			return ERR_PTR(-EBADMSG);
+
+		str[len] = '\0';
+		++str;
+	}
+
+	return str;
+}
+
+/**
+ * parse_token: Parse a string into a proper token representation.
+ * @token: Supplies the token string to parse.
+ *
+ * @token will be edited destructively. Pass a copy if you wish to retain
+ * the state of the original.
+ *
+ * This function will emit an error to pr_err when a parsing error occurs.
+ *
+ * Return:
+ * !0 - OK
+ * ERR_PTR(-EBADMSG) - An invalid character was encountered while parsing.
+ * ERR_PTR(-ENOMEM) - No Memory
+ */
+static struct ipe_policy_token *parse_token(char *token)
+{
+	size_t i, len = 0;
+	char *key = token;
+	char *value = NULL;
+	struct ipe_policy_token *local = NULL;
+
+	len = strlen(token);
+
+	for (i = 0; (i < len) && token[i] != KEYVAL_DELIMIT; ++i)
+		if (!is_key_char(token[i]))
+			return ERR_PTR(-EBADMSG);
+
+	token[i] = '\0';
+	++i;
+
+	/* there is a value */
+	if (i < len) {
+		value = trim_quotes(&token[i]);
+		if (IS_ERR(value))
+			return ERR_PTR(-EBADMSG);
+
+		len = strlen(value);
+
+		for (i = 0; i < len; ++i)
+			if (!is_val_char(value[i]))
+				return ERR_PTR(-EBADMSG);
+	}
+
+	local = kzalloc(sizeof(*local), GFP_KERNEL);
+	if (!local)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&local->next);
+	local->key = key;
+	local->value = value;
+
+	return local;
+}
+
+/**
+ * append_token: Parse and append a token into an ipe_policy_line structure.
+ * @p: Supplies the ipe_policy_line structure to append to.
+ * @token: Supplies the token to parse and append to.
+ *
+ * @token will be edited during the parsing destructively. Pass a copy if you
+ * wish to retain the original.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Parsing error of @token
+ */
+static int append_token(struct ipe_policy_line *p, char *token)
+{
+	struct ipe_policy_token *t = NULL;
+
+	t = parse_token(token);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+
+	list_add_tail(&t->next, &p->tokens);
+
+	return 0;
+}
+
+/**
+ * alloc_line: Allocate an ipe_policy_line structure.
+ *
+ * Return:
+ * !0 - OK
+ * -EBADMSG - Parsing error of @token
+ */
+static struct ipe_policy_line *alloc_line(void)
+{
+	struct ipe_policy_line *l = NULL;
+
+	l = kzalloc(sizeof(*l), GFP_KERNEL);
+	if (!l)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&l->next);
+	INIT_LIST_HEAD(&l->tokens);
+
+	return l;
+}
+
+/**
+ * insert_token: Append a token to @line.
+ * @token: Supplies the token to append to @line.
+ * @line: Supplies a pointer to the ipe_policy_line structure to append to.
+ *
+ * If @line is NULL, it will be allocated on behalf of the caller.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - No Memory
+ * -EBADMSG - Parsing error of @token
+ */
+static int insert_token(char *token, struct ipe_policy_line **line)
+{
+	int rc = 0;
+	struct ipe_policy_line *local = *line;
+
+	if (!local) {
+		local = alloc_line();
+		if (IS_ERR(local))
+			return PTR_ERR(local);
+
+		*line = local;
+	}
+
+	rc = append_token(local, token);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+/**
+ * ipe_tokenize_line: Parse a line of text into a list of token structures.
+ * @line: Supplies the line to parse.
+ *
+ * The final result can be NULL, which represents no tokens were parsed.
+ *
+ * Return:
+ * !0 - OK
+ * NULL - OK, no tokens were parsed.
+ * ERR_PTR(-EBADMSG) - Invalid policy syntax
+ * ERR_PTR(-ENOMEM) - No Memory
+ */
+static struct ipe_policy_line *tokenize_line(char *line)
+{
+	int rc = 0;
+	size_t i = 0;
+	size_t len = 0;
+	char *tok = NULL;
+	char quote = '\0';
+	struct ipe_policy_line *p = NULL;
+
+	/* nullterm guaranteed by strsep */
+	len = strlen(line);
+
+	for (i = 0; i < len; ++i) {
+		if (quote == '\0' && is_quote(line[i])) {
+			quote = line[i];
+			continue;
+		}
+
+		if (quote != '\0' && line[i] == quote) {
+			quote = '\0';
+			continue;
+		}
+
+		if (quote == '\0' && line[i] == START_COMMENT) {
+			tok = NULL;
+			break;
+		}
+
+		if (isgraph(line[i]) && !tok)
+			tok = &line[i];
+
+		if (quote == '\0' && isspace(line[i])) {
+			line[i] = '\0';
+
+			if (!tok)
+				continue;
+
+			rc = insert_token(tok, &p);
+			if (rc)
+				goto err;
+
+			tok = NULL;
+		}
+	}
+
+	if (quote != '\0') {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	if (tok) {
+		rc = insert_token(tok, &p);
+		if (rc)
+			goto err;
+	}
+
+	return p;
+
+err:
+	free_parsed_line(p);
+	return ERR_PTR(rc);
+}
+
+/**
+ * parse_pass1: parse @policy into a 2D list, representing tokens on each line.
+ * @policy: Supplies the policy to parse. Must be nullterminated, and is
+ *	    edited.
+ *
+ * In pass1 of the parser, the policy is tokenized. Minor structure checks
+ * are done (mismatching quotes, invalid characters).
+ *
+ * Caller must maintain the lifetime of @policy while the return value is
+ * alive.
+ *
+ * Return:
+ * !0 - OK
+ * ERR_PTR(-ENOMEM) - Out of Memory
+ * ERR_PTR(-EBADMSG) - Parsing Error
+ */
+static int parse_pass1(char *policy, struct list_head *tokens)
+{
+	int rc = 0;
+	char *p = NULL;
+
+	while ((p = strsep(&policy, "\n\0")) != NULL) {
+		struct ipe_policy_line *t = NULL;
+
+		t = tokenize_line(p);
+		if (IS_ERR(t)) {
+			rc = PTR_ERR(t);
+			goto err_free_parsed;
+		}
+
+		if (!t)
+			continue;
+
+		list_add_tail(&t->next, tokens);
+	}
+
+	return 0;
+
+err_free_parsed:
+	free_parsed_text(tokens);
+	return rc;
+}
+
+/**
+ * parse_pass2: Take the 2D list of tokens generated from pass1, and transform
+ *		it into a partial ipe_policy.
+ * @parsed: Supplies the list of tokens generated from pass1.
+ * @p: Policy to manipulate with parsed tokens.
+ *
+ * This function is where various declarations and references are parsed into
+ * policy. All declarations and references required to parse rules should be
+ * done here as a parser, and then in pass3 these can be utilized.
+ *
+ * Return:
+ * !0 - OK
+ * -EBADMSG - Syntax Parsing Errors
+ * -ENOENT - No handler for a token.
+ * -ENOMEM - Out of memory
+ */
+static int parse_pass2(struct list_head *parsed, struct ipe_parsed_policy *pol)
+{
+	int rc = 0;
+	const struct ipe_parser *p = NULL;
+	struct ipe_policy_line *line = NULL;
+	const struct ipe_policy_token *token = NULL;
+
+	list_for_each_entry(line, parsed, next) {
+		token = list_first_entry(&line->tokens, struct ipe_policy_token, next);
+		p = ipe_lookup_parser(token->key);
+		if (!p)
+			continue;
+
+		rc = p->parse(line, pol);
+		if (rc)
+			return rc;
+
+		line->consumed = true;
+	}
+
+	return rc;
+}
+
+/**
+ * ipe_parse_op: parse a token to an operation value.
+ * @tok: Token to parse
+ * @op: Operation Parsed.
+ *
+ * Return:
+ * 0 - OK
+ * -EINVAL - Invalid key or value.
+ */
+int ipe_parse_op(const struct ipe_policy_token *tok,
+		 enum ipe_operation *op)
+{
+	substring_t match[MAX_OPT_ARGS] = { 0 };
+	const match_table_t ops = {
+		{ ipe_op_alias_max, NULL },
+	};
+
+	if (strcmp(tok->key, "op") || !tok->value)
+		return -EINVAL;
+
+	*op = match_token((char *)tok->value, ops, match);
+	if ((*op) == (int)ipe_op_alias_max)
+		return -ENOENT;
+
+	return 0;
+}
+
+/**
+ * ipe_parse_action: parse a token to an operation value.
+ * @tok: Token to parse
+ * @action: action parsed.
+ *
+ * Return:
+ * 0 - OK
+ * -EINVAL - Invalid key or value.
+ */
+int ipe_parse_action(const struct ipe_policy_token *tok,
+		     enum ipe_action *action)
+{
+	substring_t match[MAX_OPT_ARGS] = { 0 };
+	const match_table_t actions = {
+		{ ipe_action_allow, "ALLOW" },
+		{ ipe_action_deny, "DENY" },
+		{ ipe_action_max, NULL },
+	};
+
+	if (strcmp(tok->key, "action") || !tok->value)
+		return -EINVAL;
+
+	*action = match_token((char *)tok->value, actions, match);
+
+	if (*action == ipe_action_max)
+		return -EINVAL;
+
+	return 0;
+}
+
+/**
+ * parse_mod_to_rule: Parse a module token and append the values to the
+ *		      provided rule.
+ * @t: Supplies the token to parse.
+ * @r: Supplies the rule to modify with the result.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOENT - No such module to handle @t.
+ * -ENOMEM - No memory.
+ * Others - Module defined errors.
+ */
+static int parse_mod_to_rule(const struct ipe_policy_token *t, struct ipe_rule *r)
+{
+	int rc = 0;
+	struct ipe_policy_mod *p = NULL;
+	const struct ipe_module *m = NULL;
+
+	m = ipe_lookup_module(t->key);
+	if (IS_ERR_OR_NULL(m)) {
+		rc = (m) ? PTR_ERR(m) : -ENOENT;
+		goto err;
+	}
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		rc = -ENOMEM;
+		goto err;
+	}
+	INIT_LIST_HEAD(&p->next);
+	p->mod = m;
+
+	rc = m->parse(t->value, &p->mod_value);
+	if (rc)
+		goto err2;
+
+	list_add_tail(&p->next, &r->modules);
+	return 0;
+err2:
+	kfree(p);
+err:
+	return rc;
+}
+
+/**
+ * parse_rule: Parse a policy line into an ipe_rule structure.
+ * @line: Supplies the line to parse.
+ *
+ * Return:
+ * Valid ipe_rule - OK
+ * ERR_PTR(-ENOMEM) - Out of Memory
+ * ERR_PTR(-ENOENT) - No such module to handle a token
+ * ERR_PTR(-EINVAL) - An unacceptable value has been encountered.
+ * ERR_PTR(...) - Module defined errors.
+ */
+static struct ipe_rule *parse_rule(const struct ipe_policy_line *line)
+{
+	int rc = 0;
+	struct ipe_rule *r = NULL;
+	const struct list_head *node = NULL;
+
+	r = kzalloc(sizeof(*r), GFP_KERNEL);
+	if (!r) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&r->next);
+	INIT_LIST_HEAD(&r->modules);
+	r->op = (int)ipe_op_alias_max;
+	r->action = ipe_action_max;
+
+	list_for_each(node, &line->tokens) {
+		const struct ipe_policy_token *token = NULL;
+
+		token = container_of(node, struct ipe_policy_token, next);
+
+		if (list_is_first(node, &line->tokens)) {
+			enum ipe_operation op;
+
+			rc = ipe_parse_op(token, &op);
+			if (rc)
+				goto err;
+
+			r->op = op;
+			continue;
+		}
+
+		if (list_is_last(node, &line->tokens)) {
+			enum ipe_action action;
+
+			rc = ipe_parse_action(token, &action);
+			if (rc)
+				goto err;
+
+			r->action = action;
+			continue;
+		}
+
+		rc = parse_mod_to_rule(token, r);
+		if (rc)
+			goto err;
+	}
+
+	if (r->action == ipe_action_max || r->op == (int)ipe_op_alias_max) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	return r;
+err:
+	free_rule(r);
+	return ERR_PTR(rc);
+}
+
+/**
+ * parse_pass3: Take the partially parsed list of tokens from pass 1 and the
+ *		parial policy from pass 2, and finalize the policy.
+ * @parsed: Supplies the tokens parsed from pass 1.
+ * @p: Supplies the partial policy from pass 2.
+ *
+ * This function finalizes the IPE policy by parsing all rules in the
+ * policy. This must occur in pass3, as in pass2, references are resolved
+ * that can be used in pass3.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Standard errno
+ */
+static int parse_pass3(struct list_head *parsed,
+		       struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	size_t i = 0;
+	size_t remap_len = 0;
+	struct ipe_rule *rule = NULL;
+	struct ipe_policy_line *line = NULL;
+	const enum ipe_operation *remap;
+
+	list_for_each_entry(line, parsed, next) {
+		if (line->consumed)
+			continue;
+
+		rule = parse_rule(line);
+		if (IS_ERR(rule)) {
+			rc = PTR_ERR(rule);
+			goto err;
+		}
+
+		if (ipe_is_op_alias(rule->op, &remap, &remap_len)) {
+			for (i = 0; i < remap_len; ++i) {
+				rule->op = remap[i];
+				list_add_tail(&rule->next, &p->rules[rule->op].rules);
+				rule = parse_rule(line);
+			}
+
+			free_rule(rule);
+		} else {
+			list_add_tail(&rule->next, &p->rules[rule->op].rules);
+		}
+
+		line->consumed = true;
+	}
+
+	return 0;
+err:
+	free_rule(rule);
+	return rc;
+}
+
+/**
+ * parser_validate: Callback to invoke, validating parsers as necessary
+ * @parser: parser to call to validate data.
+ * @ctx: ctx object passed to ipe_for_each_parser.
+ *
+ * This function is intended to be used with ipe_for_each_parser only.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Validation failed.
+ */
+static int parser_validate(const struct ipe_parser *parser, void *ctx)
+{
+	int rc = 0;
+	const struct ipe_parsed_policy *pol = ctx;
+
+	if (parser->validate)
+		rc = parser->validate(pol);
+
+	return rc;
+}
+
+/**
+ * validate_policy: Given a policy structure that was just parsed, validate
+ *		    that all necessary fields are present, initialized
+ *		    correctly, and all lines parsed are have been consumed.
+ * @parsed: Supplies the policy lines that were parsed in pass1.
+ * @policy: Supplies the fully parsed policy.
+ *
+ * A parsed policy can be an invalid state for use (a default was undefined,
+ * a header was undefined) by just parsing the policy.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Policy is invalid.
+ */
+static int validate_policy(const struct list_head *parsed,
+			   const struct ipe_parsed_policy *p)
+{
+	int rc = 0;
+	const struct ipe_policy_line *line = NULL;
+
+	list_for_each_entry(line, parsed, next) {
+		if (!line->consumed)
+			return -EBADMSG;
+	}
+
+	rc = ipe_for_each_parser(parser_validate,
+				 (struct ipe_parsed_policy *)p);
+
+	return rc;
+}
+
+/**
+ * new_parsed_policy: Allocate and initialize a parsed policy to its default
+ *		      values.
+ *
+ * Return:
+ * !IS_ERR - OK
+ */
+static struct ipe_parsed_policy *new_parsed_policy(void)
+{
+	size_t i = 0;
+	struct ipe_parsed_policy *p = NULL;
+	struct ipe_operation_table *t = NULL;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	p->global_default = ipe_action_max;
+
+	for (i = 0; i < ARRAY_SIZE(p->rules); ++i) {
+		t = &p->rules[i];
+
+		t->default_action = ipe_action_max;
+		INIT_LIST_HEAD(&t->rules);
+	}
+
+	return p;
+}
+
+/**
+ * parse_policy: Given a string, parse the string into an IPE policy
+ *		     structure.
+ * @p: partially filled ipe_policy structure to populate with the result.
+ *
+ * @p must have text and textlen set.
+ *
+ * Return:
+ * Valid ipe_policy structure - OK
+ * ERR_PTR(-EBADMSG) - Invalid Policy Syntax (Unrecoverable)
+ * ERR_PTR(-ENOMEM) - Out of Memory
+ */
+static int parse_policy(struct ipe_policy *p)
+{
+	int rc = 0;
+	char *dup = NULL;
+	LIST_HEAD(parsed);
+	struct ipe_parsed_policy *pp = NULL;
+
+	if (!p->textlen)
+		return -EBADMSG;
+
+	dup = kmemdup_nul(p->text, p->textlen, GFP_KERNEL);
+	if (!dup)
+		return -ENOMEM;
+
+	pp = new_parsed_policy();
+	if (IS_ERR(pp)) {
+		rc = PTR_ERR(pp);
+		goto out;
+	}
+
+	rc = parse_pass1(dup, &parsed);
+	if (rc)
+		goto err;
+
+	rc = parse_pass2(&parsed, pp);
+	if (rc)
+		goto err;
+
+	rc = parse_pass3(&parsed, pp);
+	if (rc)
+		goto err;
+
+	rc = validate_policy(&parsed, pp);
+	if (rc)
+		goto err;
+
+	p->parsed = pp;
+
+	goto out;
+err:
+	free_parsed_policy(pp);
+out:
+	free_parsed_text(&parsed);
+	kfree(dup);
+
+	return rc;
+}
+
+/**
+ * ipe_is_op_alias: Determine if @op is an alias for one or more operations
+ * @op: Supplies the operation to check. Should be either ipe_operation or
+ *	ipe_op_alias.
+ * @map: Supplies a pointer to populate with the mapping if @op is an alias
+ * @size: Supplies the size of @map if @op is an alias.
+ *
+ * Return:
+ * true - @op is an alias
+ * false - @op is not an alias
+ */
+bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size)
+{
+	switch (op) {
+	default:
+		return false;
+	}
+}
+
+/**
+ * ipe_free_policy: Deallocate a given IPE policy.
+ * @p: Supplies the policy to free.
+ *
+ * Safe to call on IS_ERR/NULL.
+ */
+void ipe_put_policy(struct ipe_policy *p)
+{
+	if (IS_ERR_OR_NULL(p) || !refcount_dec_and_test(&p->refcount))
+		return;
+
+	free_parsed_policy(p->parsed);
+	if (!p->pkcs7)
+		kfree(p->text);
+	kfree(p->pkcs7);
+	kfree(p);
+}
+
+static int set_pkcs7_data(void *ctx, const void *data, size_t len,
+			  size_t asn1hdrlen)
+{
+	struct ipe_policy *p = ctx;
+
+	p->text = (const char *)data;
+	p->textlen = len;
+
+	return 0;
+}
+
+/**
+ * ipe_new_policy: allocate and parse an ipe_policy structure.
+ *
+ * @text: Supplies a pointer to the plain-text policy to parse.
+ * @textlen: Supplies the length of @text.
+ * @pkcs7: Supplies a pointer to a pkcs7-signed IPE policy.
+ * @pkcs7len: Supplies the length of @pkcs7.
+ *
+ * @text/@textlen Should be NULL/0 if @pkcs7/@pkcs7len is set.
+ *
+ * The result will still need to be associated with a context via
+ * ipe_add_policy.
+ *
+ * Return:
+ * !IS_ERR - Success
+ */
+struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
+				  const char *pkcs7, size_t pkcs7len)
+{
+	int rc = 0;
+	struct ipe_policy *new = NULL;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	refcount_set(&new->refcount, 1);
+
+	if (!text) {
+		new->pkcs7len = pkcs7len;
+		new->pkcs7 = kmemdup(pkcs7, pkcs7len, GFP_KERNEL);
+		if (!new->pkcs7) {
+			rc = -ENOMEM;
+			goto err;
+		}
+
+		rc = verify_pkcs7_signature(NULL, 0, new->pkcs7, pkcs7len, NULL,
+					    VERIFYING_UNSPECIFIED_SIGNATURE,
+					    set_pkcs7_data, new);
+		if (rc)
+			goto err;
+	} else {
+		new->textlen = textlen;
+		new->text = kstrndup(text, textlen, GFP_KERNEL);
+		if (!new->text) {
+			rc = -ENOMEM;
+			goto err;
+		}
+	}
+
+	rc = parse_policy(new);
+	if (rc)
+		goto err;
+
+	return new;
+err:
+	ipe_put_policy(new);
+	return ERR_PTR(rc);
+}
diff --git a/security/ipe/policy.h b/security/ipe/policy.h
new file mode 100644
index 000000000000..d78788db238c
--- /dev/null
+++ b/security/ipe/policy.h
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_POLICY_H
+#define IPE_POLICY_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+
+struct ipe_policy_token {
+	struct list_head next;		/* type: policy_token */
+
+	const char *key;
+	const char *value;
+};
+
+struct ipe_policy_line {
+	struct list_head next;		/* type: policy_line */
+	struct list_head tokens;	/* type: policy_token */
+
+	bool consumed;
+};
+
+struct ipe_module;
+
+enum ipe_operation {
+	ipe_operation_max = 0,
+};
+
+/*
+ * Extension to ipe_operation, representing operations
+ * that are just one or more operations under the hood
+ */
+enum ipe_op_alias {
+	ipe_op_alias_max = ipe_operation_max,
+};
+
+enum ipe_action {
+	ipe_action_allow = 0,
+	ipe_action_deny,
+	ipe_action_max,
+};
+
+struct ipe_policy_mod {
+	const struct ipe_module *mod;
+	void			*mod_value;
+
+	struct list_head next;
+};
+
+struct ipe_rule {
+	enum ipe_operation op;
+	enum ipe_action action;
+
+	struct list_head modules;
+
+	struct list_head next;
+};
+
+struct ipe_operation_table {
+	struct list_head rules;
+	enum ipe_action default_action;
+};
+
+struct ipe_parsed_policy {
+	const char *name;
+	struct {
+		u16 major;
+		u16 minor;
+		u16 rev;
+	} version;
+
+	enum ipe_action global_default;
+
+	struct ipe_operation_table rules[ipe_operation_max];
+};
+
+struct ipe_policy {
+	const char     *pkcs7;
+	size_t		pkcs7len;
+
+	const char     *text;
+	size_t		textlen;
+
+	struct ipe_parsed_policy *parsed;
+
+	refcount_t	refcount;
+};
+
+struct ipe_policy *ipe_new_policy(const char *text, size_t textlen,
+				  const char *pkcs7, size_t pkcs7len);
+void ipe_put_policy(struct ipe_policy *pol);
+bool ipe_is_op_alias(int op, const enum ipe_operation **map, size_t *size);
+
+#endif /* IPE_POLICY_H */
-- 
2.33.0

