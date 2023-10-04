Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19737B9788
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjJDWJ4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjJDWJy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:54 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC9CCC9;
        Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id 30FF620B74C2; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 30FF620B74C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=oBYPhxhjQL5BN0Kiy8n4HfaBWKlzqDu9gGFuvxbs4W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlE6XpLZ+4/+yT20r/6R09Nc/lR/L+ItVzP+479faG/k3TjLT266PmJZQFNO6GW46
         B2vIZ+VHlGUOqxvp+AWQl0MmJnSFwEf6asTMMPdsFPJ4eKACvglV+iC2rsWBJ/LuPy
         XUUSlLY2kj5bhK/WqYQcQL5WVH3qOCeHK0+P2+LY=
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
Subject: [RFC PATCH v11 01/19] security: add ipe lsm
Date:   Wed,  4 Oct 2023 15:09:28 -0700
Message-Id: <1696457386-3010-2-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Deven Bowers <deven.desai@linux.microsoft.com>

Integrity Policy Enforcement (IPE) is an LSM that provides an
complimentary approach to Mandatory Access Control than existing LSMs
today.

Existing LSMs have centered around the concept of access to a resource
should be controlled by the current user's credentials. IPE's approach,
is that access to a resource should be controlled by the system's trust
of a current resource.

The basis of this approach is defining a global policy to specify which
resource can be trusted.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
---
v2:
  + Split evaluation loop, access control hooks,
    and evaluation loop from policy parser and userspace
    interface to pass mailing list character limit

v3:
  + Move ipe_load_properties to patch 04.
  + Remove useless 0-initializations
  + Prefix extern variables with ipe_
  + Remove kernel module parameters, as these are
    exposed through sysctls.
  + Add more prose to the IPE base config option
    help text.
  + Use GFP_KERNEL for audit_log_start.
  + Remove unnecessary caching system.
  + Remove comments from headers
  + Use rcu_access_pointer for rcu-pointer null check
  + Remove usage of reqprot; use prot only.
  + Move policy load and activation audit event to 03/12

v4:
  + Remove sysctls in favor of securityfs nodes
  + Re-add kernel module parameters, as these are now
    exposed through securityfs.
  + Refactor property audit loop to a separate function.

v5:
  + fix minor grammatical errors
  + do not group rule by curly-brace in audit record,
    reconstruct the exact rule.

v6:
  + No changes

v7:
  + Further split lsm creation into a separate commit from the
    evaluation loop and audit system, for easier review.

  + Introduce the concept of an ipe_context, a scoped way to
    introduce execution policies, used initially for allowing for
    kunit tests in isolation.

v8:
  + Follow lsmname_hook_name convention for lsm hooks.
  + Move LSM blob accessors to ipe.c and mark LSM blobs as static.

v9:
  + Remove ipe_context for simplification

v10:
  + Add github url

v11:
  + Correct github url
  + Move ipe before bpf
---
 MAINTAINERS           |  7 +++++++
 security/Kconfig      | 11 ++++++-----
 security/Makefile     |  1 +
 security/ipe/Kconfig  | 17 +++++++++++++++++
 security/ipe/Makefile |  9 +++++++++
 security/ipe/ipe.c    | 35 +++++++++++++++++++++++++++++++++++
 security/ipe/ipe.h    | 16 ++++++++++++++++
 7 files changed, 91 insertions(+), 5 deletions(-)
 create mode 100644 security/ipe/Kconfig
 create mode 100644 security/ipe/Makefile
 create mode 100644 security/ipe/ipe.c
 create mode 100644 security/ipe/ipe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 35977b269d5e..b898f2f8f9c4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10389,6 +10389,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 F:	security/integrity/
 F:	security/integrity/ima/
 
+INTEGRITY POLICY ENFORCEMENT (IPE)
+M:	Fan Wu <wufan@linux.microsoft.com>
+L:	linux-security-module@vger.kernel.org
+S:	Supported
+T:	git https://github.com/microsoft/ipe.git
+F:	security/ipe/
+
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/security/Kconfig b/security/Kconfig
index 52c9af08ad35..cc7adfbb6b96 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -194,6 +194,7 @@ source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
 source "security/landlock/Kconfig"
+source "security/ipe/Kconfig"
 
 source "security/integrity/Kconfig"
 
@@ -233,11 +234,11 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
-	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
-	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
-	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
-	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECURITY_DAC
-	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,bpf"
+	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,ipe,bpf" if DEFAULT_SECURITY_SMACK
+	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,ipe,bpf" if DEFAULT_SECURITY_APPARMOR
+	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,ipe,bpf" if DEFAULT_SECURITY_TOMOYO
+	default "landlock,lockdown,yama,loadpin,safesetid,ipe,bpf" if DEFAULT_SECURITY_DAC
+	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,apparmor,ipe,bpf"
 	help
 	  A comma-separated list of LSMs, in initialization order.
 	  Any LSMs left off this list, except for those with order
diff --git a/security/Makefile b/security/Makefile
index 18121f8f85cd..527b1864d96c 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
 obj-$(CONFIG_CGROUPS)			+= device_cgroup.o
 obj-$(CONFIG_BPF_LSM)			+= bpf/
 obj-$(CONFIG_SECURITY_LANDLOCK)		+= landlock/
+obj-$(CONFIG_SECURITY_IPE)		+= ipe/
 
 # Object integrity file lists
 obj-$(CONFIG_INTEGRITY)			+= integrity/
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
new file mode 100644
index 000000000000..e4875fb04883
--- /dev/null
+++ b/security/ipe/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Integrity Policy Enforcement (IPE) configuration
+#
+
+menuconfig SECURITY_IPE
+	bool "Integrity Policy Enforcement (IPE)"
+	depends on SECURITY && SECURITYFS
+	select PKCS7_MESSAGE_PARSER
+	select SYSTEM_DATA_VERIFICATION
+	help
+	  This option enables the Integrity Policy Enforcement LSM
+	  allowing users to define a policy to enforce a trust-based access
+	  control. A key feature of IPE is a customizable policy to allow
+	  admins to reconfigure trust requirements on the fly.
+
+	  If unsure, answer N.
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
new file mode 100644
index 000000000000..f7a80d0f18f8
--- /dev/null
+++ b/security/ipe/Makefile
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+obj-$(CONFIG_SECURITY_IPE) += \
+	ipe.o \
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
new file mode 100644
index 000000000000..ba5526f9d527
--- /dev/null
+++ b/security/ipe/ipe.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+
+static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
+};
+
+static struct security_hook_list ipe_hooks[] __ro_after_init = {
+};
+
+/**
+ * ipe_init - Entry point of IPE.
+ *
+ * This is called at LSM init, which happens occurs early during kernel
+ * start up. During this phase, IPE registers its hooks and loads the
+ * builtin boot policy.
+ * Return:
+ * * 0		- OK
+ * * -ENOMEM	- Out of memory
+ */
+static int __init ipe_init(void)
+{
+	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
+
+	return 0;
+}
+
+DEFINE_LSM(ipe) = {
+	.name = "ipe",
+	.init = ipe_init,
+	.blobs = &ipe_blobs,
+};
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
new file mode 100644
index 000000000000..a1c68d0fc2e0
--- /dev/null
+++ b/security/ipe/ipe.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef _IPE_H
+#define _IPE_H
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+#define pr_fmt(fmt) "IPE: " fmt
+
+#include <linux/lsm_hooks.h>
+
+#endif /* _IPE_H */
-- 
2.25.1

