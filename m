Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C755543C11
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbiFHTBx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbiFHTBt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:49 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4B48240AE;
        Wed,  8 Jun 2022 12:01:47 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 69EF620BE67F;
        Wed,  8 Jun 2022 12:01:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 69EF620BE67F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714905;
        bh=uJl99er7g1z1c12B6jDcGNKvJHQVDd0gHzCmetM8LIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft0Aaqoz8TMdmEvtj694amzsqacEffCg8BmfyI9uW+Tt3OAp3gkm27XsIYBKxgpRd
         JTosSBifxtOx/AhwarbCcBRyFpql5zsp1Dlg2eXAsG0xcvmXIshX8br9U2MUApB7G5
         4kZdNIK+7nSgUZJtLnERU8uLilBN1kAqH2/uZsss=
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
Subject: [RFC PATCH v8 15/17] scripts: add boot policy generation program
Date:   Wed,  8 Jun 2022 12:01:27 -0700
Message-Id: <1654714889-26728-16-git-send-email-deven.desai@linux.microsoft.com>
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

Enables an IPE policy to be enforced from kernel start, enabling access
control based on trust from kernel startup. This is accomplished by
transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
c-string literal that is parsed at kernel startup as an unsigned policy.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + No Changes

v4:
  + No Changes

v5:
  + No Changes

v6:
  + No Changes

v7:
  + Move from 01/11 to 14/16
  + Don't return errno directly.
  + Make output of script more user-friendly
  + Add escaping for tab and '?'
  + Mark argv pointer const
  + Invert return code check in the boot policy parsing code path.

v8:
  + No signfiicant chances.
---
 MAINTAINERS                   |   1 +
 scripts/Makefile              |   1 +
 scripts/ipe/Makefile          |   2 +
 scripts/ipe/polgen/.gitignore |   1 +
 scripts/ipe/polgen/Makefile   |   6 ++
 scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
 security/ipe/.gitignore       |   1 +
 security/ipe/Kconfig          |  10 +++
 security/ipe/Makefile         |  11 +++
 security/ipe/ctx.c            |  18 +++++
 security/ipe/fs.c             |  10 +++
 11 files changed, 206 insertions(+)
 create mode 100644 scripts/ipe/Makefile
 create mode 100644 scripts/ipe/polgen/.gitignore
 create mode 100644 scripts/ipe/polgen/Makefile
 create mode 100644 scripts/ipe/polgen/polgen.c
 create mode 100644 security/ipe/.gitignore

diff --git a/MAINTAINERS b/MAINTAINERS
index 965fdac6d609..f7333d07a9df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9797,6 +9797,7 @@ INTEGRITY POLICY ENFORCEMENT (IPE)
 M:	Deven Bowers <deven.desai@linux.microsoft.com>
 M:	Fan Wu <wufan@linux.microsoft.com>
 S:	Supported
+F:	scripts/ipe/
 F:	security/ipe/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
diff --git a/scripts/Makefile b/scripts/Makefile
index f084f08ed176..4f1a8f37a83f 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -38,6 +38,7 @@ targets += module.lds
 subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
+subdir-$(CONFIG_SECURITY_IPE) += ipe
 
 # Let clean descend into subdirs
 subdir-	+= basic dtc gdb kconfig mod
diff --git a/scripts/ipe/Makefile b/scripts/ipe/Makefile
new file mode 100644
index 000000000000..e87553fbb8d6
--- /dev/null
+++ b/scripts/ipe/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+subdir-y := polgen
diff --git a/scripts/ipe/polgen/.gitignore b/scripts/ipe/polgen/.gitignore
new file mode 100644
index 000000000000..80f32f25d200
--- /dev/null
+++ b/scripts/ipe/polgen/.gitignore
@@ -0,0 +1 @@
+polgen
diff --git a/scripts/ipe/polgen/Makefile b/scripts/ipe/polgen/Makefile
new file mode 100644
index 000000000000..066060c22b4a
--- /dev/null
+++ b/scripts/ipe/polgen/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+hostprogs-always-y	:= polgen
+HOST_EXTRACFLAGS += \
+	-I$(srctree)/include \
+	-I$(srctree)/include/uapi \
+
diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
new file mode 100644
index 000000000000..40b6fe07f47b
--- /dev/null
+++ b/scripts/ipe/polgen/polgen.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+
+static void usage(const char *const name)
+{
+	printf("Usage: %s OutputFile (PolicyFile)\n", name);
+	exit(EINVAL);
+}
+
+static int policy_to_buffer(const char *pathname, char **buffer, size_t *size)
+{
+	int rc = 0;
+	FILE *fd;
+	char *lbuf;
+	size_t fsize;
+	size_t read;
+
+	fd = fopen(pathname, "r");
+	if (!fd) {
+		rc = errno;
+		goto out;
+	}
+
+	fseek(fd, 0, SEEK_END);
+	fsize = ftell(fd);
+	rewind(fd);
+
+	lbuf = malloc(fsize);
+	if (!lbuf) {
+		rc = ENOMEM;
+		goto out_close;
+	}
+
+	read = fread((void *)lbuf, sizeof(*lbuf), fsize, fd);
+	if (read != fsize) {
+		rc = -1;
+		goto out_free;
+	}
+
+	*buffer = lbuf;
+	*size = fsize;
+	fclose(fd);
+
+	return rc;
+
+out_free:
+	free(lbuf);
+out_close:
+	fclose(fd);
+out:
+	return rc;
+}
+
+static int write_boot_policy(const char *pathname, const char *buf, size_t size)
+{
+	int rc = 0;
+	FILE *fd;
+	size_t i;
+
+	fd = fopen(pathname, "w");
+	if (!fd) {
+		rc = errno;
+		goto err;
+	}
+
+	fprintf(fd, "/* This file is automatically generated.");
+	fprintf(fd, " Do not edit. */\n");
+	fprintf(fd, "#include <linux/stddef.h>\n");
+	fprintf(fd, "\nextern const char *const ipe_boot_policy;\n\n");
+	fprintf(fd, "const char *const ipe_boot_policy =\n");
+
+	if (!buf || size == 0) {
+		fprintf(fd, "\tNULL;\n");
+		fclose(fd);
+		return 0;
+	}
+
+	fprintf(fd, "\t\"");
+
+	for (i = 0; i < size; ++i) {
+		switch (buf[i]) {
+		case '"':
+			fprintf(fd, "\\\"");
+			break;
+		case '\'':
+			fprintf(fd, "'");
+			break;
+		case '\n':
+			fprintf(fd, "\\n\"\n\t\"");
+			break;
+		case '\\':
+			fprintf(fd, "\\\\");
+			break;
+		case '\t':
+			fprintf(fd, "\\t");
+			break;
+		case '\?':
+			fprintf(fd, "\\?");
+			break;
+		default:
+			fprintf(fd, "%c", buf[i]);
+		}
+	}
+	fprintf(fd, "\";\n");
+	fclose(fd);
+
+	return 0;
+
+err:
+	if (fd)
+		fclose(fd);
+	return rc;
+}
+
+int main(int argc, const char *const argv[])
+{
+	int rc = 0;
+	size_t len = 0;
+	char *policy = NULL;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	if (argc > 2) {
+		rc = policy_to_buffer(argv[2], &policy, &len);
+		if (rc != 0)
+			goto cleanup;
+	}
+
+	rc = write_boot_policy(argv[1], policy, len);
+cleanup:
+	if (policy)
+		free(policy);
+	if (rc != 0)
+		perror("An error occurred during policy conversion: ");
+	return rc;
+}
diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
new file mode 100644
index 000000000000..eca22ad5ed22
--- /dev/null
+++ b/security/ipe/.gitignore
@@ -0,0 +1 @@
+boot-policy.c
\ No newline at end of file
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 69345fa49be5..619bf179af43 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -18,6 +18,16 @@ menuconfig SECURITY_IPE
 
 if SECURITY_IPE
 
+config IPE_BOOT_POLICY
+	string "Integrity policy to apply on system startup"
+	help
+	  This option specifies a filepath to a IPE policy that is compiled
+	  into the kernel. This policy will be enforced until a policy update
+	  is deployed via the $securityfs/ipe/policies/$policy_name/active
+	  interface.
+
+	  If unsure, leave blank.
+
 config IPE_AUDIT
 	bool "Enable IPE's audit events"
 	depends on AUDIT && AUDITSYSCALL
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 0d970236efc4..1a1f7484caee 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -7,7 +7,16 @@
 
 ccflags-y := -I$(srctree)/security/ipe/modules
 
+quiet_cmd_polgen = IPE_POL $(2)
+      cmd_polgen = scripts/ipe/polgen/polgen security/ipe/boot-policy.c $(2)
+
+targets += boot-policy.c
+
+$(obj)/boot-policy.c: scripts/ipe/polgen/polgen $(CONFIG_IPE_BOOT_POLICY) FORCE
+	$(call if_changed,polgen,$(CONFIG_IPE_BOOT_POLICY))
+
 obj-$(CONFIG_SECURITY_IPE) += \
+	boot-policy.o \
 	ctx.o \
 	eval.o \
 	fs.o \
@@ -21,3 +30,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	policyfs.o \
 
 obj-$(CONFIG_IPE_AUDIT) += audit.o
+
+clean-files := boot-policy.c \
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
index ee3cb2bd6028..979027570c2c 100644
--- a/security/ipe/ctx.c
+++ b/security/ipe/ctx.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
 
+extern const char *const ipe_boot_policy;
 static bool success_audit;
 static bool enforce = true;
 
@@ -316,6 +317,7 @@ void ipe_put_ctx(struct ipe_context *ctx)
 int __init ipe_init_ctx(void)
 {
 	int rc = 0;
+	struct ipe_policy *p = NULL;
 	struct ipe_context *lns = NULL;
 
 	lns = create_ctx();
@@ -329,10 +331,26 @@ int __init ipe_init_ctx(void)
 	WRITE_ONCE(lns->enforce, enforce);
 	spin_unlock(&lns->lock);
 
+	if (ipe_boot_policy) {
+		p = ipe_new_policy(ipe_boot_policy, strlen(ipe_boot_policy),
+				   NULL, 0);
+		if (IS_ERR(p)) {
+			rc = PTR_ERR(p);
+			goto err;
+		}
+
+		ipe_add_policy(lns, p);
+		rc = ipe_set_active_pol(p);
+		if (rc)
+			goto err;
+	}
+
 	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
+	ipe_put_policy(p);
 
 	return 0;
 err:
+	ipe_put_policy(p);
 	ipe_put_ctx(lns);
 	return rc;
 }
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index f4d32f84c945..eb8738373a64 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -270,6 +270,7 @@ static const struct file_operations audit_fops = {
 static int __init ipe_init_securityfs(void)
 {
 	int rc = 0;
+	struct ipe_policy *p = NULL;
 	struct ipe_context *ctx = NULL;
 
 	if (!ipe_enabled)
@@ -316,8 +317,17 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	p = ipe_get_policy_rcu(ctx->active_policy);
+	if (p) {
+		rc = ipe_new_policyfs_node(ctx, p);
+		if (rc)
+			goto err;
+	}
+
+	ipe_put_policy(p);
 	return 0;
 err:
+	ipe_put_policy(p);
 	securityfs_remove(np);
 	securityfs_remove(root);
 	securityfs_remove(config);
-- 
2.25.1

