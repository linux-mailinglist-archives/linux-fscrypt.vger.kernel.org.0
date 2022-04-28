Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63922513E75
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 00:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352838AbiD1WWu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Apr 2022 18:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiD1WWu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Apr 2022 18:22:50 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E86BF32C
        for <linux-fscrypt@vger.kernel.org>; Thu, 28 Apr 2022 15:19:34 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id BB5C63200958;
        Thu, 28 Apr 2022 18:19:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 28 Apr 2022 18:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651184373; x=1651270773; bh=o8
        eL68T90a9Fd/2AjVZWBLF/jOu9/Zdz4s/IhPynkog=; b=NruOn7pV7cy0AQbrqT
        7AojapXc35dKpoUfOy/Ne+X+qI3oE8JcF2JO60xwE2TJvbLGYjSzBYG7+JmlLFVx
        5iFfa/BbKYm45mOog4GiqOm0jvi4hZBzsQgsszqy5y/MImf4pPrbXS16AHIIdcFQ
        fOP6jKxB07vsOd30iNEDo8B78uqPstv1N2co2VMWrDPuYIMQEmutJoihPWTaD6y8
        PDilXiAPML7lfL/08wSbh0I9/KuR5IwiR+mUxgyQy3cOUNDXF9riWQOwOIUg9bOt
        c/5oZVJfDZPmt6A0KLvhTjPNynRskRdU8dmCKIDfDQudryptTzsns9fXqH3n4nNO
        U1fg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651184373; x=1651270773; bh=o8eL68T90a9Fd/2AjVZWBLF/jOu9/Zdz4s/
        IhPynkog=; b=mVQo5JH+VBS5eAhbaeL7iZ01Jip9hCK6LzWeFdHY7k6OOfgd0Me
        9kd8lUKEimDiX22yUGcAZ67A21ojFfl+LNNvp/4xH1tdfkZ9deUzP7lR2kzUq0O9
        5R+rw9CRmYBIfyBtfgepHU3v+Eptw56Y+zoL5embRnxr7W5znOAWwI2TlK2yh5XG
        Jj+ApWpOX0Cho+8/5bVWuepmk+F7iWGUZlN7L9yGWm9OQUb0VYAUEktWJwv4m0eV
        wDey3rQlyRspsu7IUBl4z+MxtZJsJpvlnyQE5KDDsADoyjLlxeCllFVzBLUSez1Z
        bZmLju1QRZuLZJeQY8z0JJShKpjnWOr52XQ==
X-ME-Sender: <xms:9RJrYiivvAp47ene9xcJ77gpCfJcUFPQG6Uw01-IO8VlJseEgva5GA>
    <xme:9RJrYjCgioiyX4zsQS5zz61TqbPJoqsazUzFqEOvNY49wXM7TXHVbSoQX7coB6y7d
    2ZEneKZ-kfbSX_3sro>
X-ME-Received: <xmr:9RJrYqGskfKhUnHZ34hGcvbAgUzrbMc2RAoYUyC91WjRqQ7RHKQE4xVXlDM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekgddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:9RJrYrSSbjDxDZbTLMPRfrKvwjnzObs5dc3p0xz3aQ9TyEKUwM2VUw>
    <xmx:9RJrYvzyFYlB78rMnnayjZT6rbw7NPlCLxrFk_JGngQdBMNpKVj1dA>
    <xmx:9RJrYp553R8s7jtRp1fGCWhI_acPeDGbDcgR1Nmz-ZQHZ1tg0oghGQ>
    <xmx:9RJrYtZckdlQDuPWt86gxYId0eXxpP_bwI7BEQknDkuBk794jWzgoQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Apr 2022 18:19:32 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 1/2] fsverity: factor out sysctl from signature.c
Date:   Thu, 28 Apr 2022 15:19:19 -0700
Message-Id: <42e975ed011e1e62d13bee0eb79012627b2abd60.1651184207.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1651184207.git.boris@bur.io>
References: <cover.1651184207.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a preparation patch for adding a second sysctl to fs-verity.
Move the sysctl logic into its own file, so we can add more sysctls
unrelated to signatures.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/verity/Makefile           |  2 ++
 fs/verity/fsverity_private.h | 14 ++++++++++
 fs/verity/init.c             |  7 ++++-
 fs/verity/signature.c        | 54 +-----------------------------------
 fs/verity/sysctl.c           | 51 ++++++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 54 deletions(-)
 create mode 100644 fs/verity/sysctl.c

diff --git a/fs/verity/Makefile b/fs/verity/Makefile
index 435559a4fa9e..81a468ca0131 100644
--- a/fs/verity/Makefile
+++ b/fs/verity/Makefile
@@ -9,3 +9,5 @@ obj-$(CONFIG_FS_VERITY) += enable.o \
 			   verify.o
 
 obj-$(CONFIG_FS_VERITY_BUILTIN_SIGNATURES) += signature.o
+
+obj-$(CONFIG_SYSCTL) += sysctl.o
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a7920434bae5..c416c1cd9371 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -136,6 +136,20 @@ int fsverity_get_descriptor(struct inode *inode,
 int __init fsverity_init_info_cache(void);
 void __init fsverity_exit_info_cache(void);
 
+/* sysctl.c */
+#ifdef CONFIG_SYSCTL
+int __init fsverity_sysctl_init(void);
+void __init fsverity_exit_sysctl(void);
+#else /* !CONFIG_SYSCTL */
+static inline int __init fsverity_sysctl_init(void)
+{
+	return 0;
+}
+static inline void __init fsverity_exit_sysctl(void)
+{
+}
+#endif /* !CONFIG_SYSCTL */
+
 /* signature.c */
 
 #ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
diff --git a/fs/verity/init.c b/fs/verity/init.c
index c98b7016f446..bd16495e8adf 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -45,13 +45,18 @@ static int __init fsverity_init(void)
 	if (err)
 		goto err_exit_info_cache;
 
-	err = fsverity_init_signature();
+	err = fsverity_sysctl_init();
 	if (err)
 		goto err_exit_workqueue;
+	err = fsverity_init_signature();
+	if (err)
+		goto err_exit_sysctl;
 
 	pr_debug("Initialized fs-verity\n");
 	return 0;
 
+err_exit_sysctl:
+	fsverity_exit_sysctl();
 err_exit_workqueue:
 	fsverity_exit_workqueue();
 err_exit_info_cache:
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..67a471e4b570 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -12,11 +12,7 @@
 #include <linux/slab.h>
 #include <linux/verification.h>
 
-/*
- * /proc/sys/fs/verity/require_signatures
- * If 1, all verity files must have a valid builtin signature.
- */
-static int fsverity_require_signatures;
+extern int fsverity_require_signatures;
 
 /*
  * Keyring that contains the trusted X.509 certificates.
@@ -87,49 +83,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 	return 0;
 }
 
-#ifdef CONFIG_SYSCTL
-static struct ctl_table_header *fsverity_sysctl_header;
-
-static const struct ctl_path fsverity_sysctl_path[] = {
-	{ .procname = "fs", },
-	{ .procname = "verity", },
-	{ }
-};
-
-static struct ctl_table fsverity_sysctl_table[] = {
-	{
-		.procname       = "require_signatures",
-		.data           = &fsverity_require_signatures,
-		.maxlen         = sizeof(int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
-		.extra1         = SYSCTL_ZERO,
-		.extra2         = SYSCTL_ONE,
-	},
-	{ }
-};
-
-static int __init fsverity_sysctl_init(void)
-{
-	fsverity_sysctl_header = register_sysctl_paths(fsverity_sysctl_path,
-						       fsverity_sysctl_table);
-	if (!fsverity_sysctl_header) {
-		pr_err("sysctl registration failed!\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-#else /* !CONFIG_SYSCTL */
-static inline int __init fsverity_sysctl_init(void)
-{
-	return 0;
-}
-#endif /* !CONFIG_SYSCTL */
-
 int __init fsverity_init_signature(void)
 {
 	struct key *ring;
-	int err;
 
 	ring = keyring_alloc(".fs-verity", KUIDT_INIT(0), KGIDT_INIT(0),
 			     current_cred(), KEY_POS_SEARCH |
@@ -139,14 +95,6 @@ int __init fsverity_init_signature(void)
 	if (IS_ERR(ring))
 		return PTR_ERR(ring);
 
-	err = fsverity_sysctl_init();
-	if (err)
-		goto err_put_ring;
-
 	fsverity_keyring = ring;
 	return 0;
-
-err_put_ring:
-	key_put(ring);
-	return err;
 }
diff --git a/fs/verity/sysctl.c b/fs/verity/sysctl.c
new file mode 100644
index 000000000000..3ba7b02282db
--- /dev/null
+++ b/fs/verity/sysctl.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "fsverity_private.h"
+
+#include <linux/sysctl.h>
+
+/*
+ * /proc/sys/fs/verity/require_signatures
+ * If 1, all verity files must have a valid builtin signature.
+ */
+int fsverity_require_signatures;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *fsverity_sysctl_header;
+
+static const struct ctl_path fsverity_sysctl_path[] = {
+	{ .procname = "fs", },
+	{ .procname = "verity", },
+	{ }
+};
+
+static struct ctl_table fsverity_sysctl_table[] = {
+	{
+		.procname       = "require_signatures",
+		.data           = &fsverity_require_signatures,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{ }
+};
+
+int __init fsverity_sysctl_init(void)
+{
+	fsverity_sysctl_header = register_sysctl_paths(fsverity_sysctl_path,
+						       fsverity_sysctl_table);
+	if (!fsverity_sysctl_header) {
+		pr_err("sysctl registration failed!\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void __init fsverity_exit_sysctl(void)
+{
+	unregister_sysctl_table(fsverity_sysctl_header);
+	fsverity_sysctl_header = NULL;
+}
+#endif /* !CONFIG_SYSCTL */
-- 
2.30.2

