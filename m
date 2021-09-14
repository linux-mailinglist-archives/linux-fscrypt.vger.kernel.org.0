Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290B240A215
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 02:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbhINAie (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 20:38:34 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39313 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235668AbhINAid (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 20:38:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 0D1D55C00D2;
        Mon, 13 Sep 2021 20:37:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 13 Sep 2021 20:37:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=zN3chAHMtfdEZEbzcfOf5bHHCu
        TFI6EyUaFJvsZ1CZA=; b=KTcZGOjkqmShf1nk4yNldTGrCURhBZSKmWjn5eXn6g
        /CL5Wh0RI27b5WKQYKdZJTYLal1p0Fb2NQftTWfu8cjmTqyL/NbZgipakRfo2R60
        iFzCBgyM+4mh7f0J2pD9+15kaPczZIcnTQQ+JImFZ3f3aI6hNKIc/LM0h4ClKRPe
        lLZBrjbMM1YagPT8bJW+uXoN0NB6zuRa9HDUn9dRE6WQiJ+jbrF0yoW7iuiwK1Bf
        WRr9VHo9gx/PGZbjfSOMmiu6P9l30nBAC+eiHCqWOlq8pTEx0p3zIR2F2SAiH5dc
        QH1BkUtJhITKw870DzWGgSM/ICu9b1FM8vkEhoRyhrmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zN3chAHMtfdEZEbzc
        fOf5bHHCuTFI6EyUaFJvsZ1CZA=; b=aRel+WJS0YzzeQkbczznaQ7pfg8F3e8wK
        9wlrQugvQq7W+78K7ZAZvVRCAnaqZwlbR5c5fnalZJdqPjPOaaB2Ju0M/QbOxAOT
        sWT5trTqxnZuBEZ0p7SoHmtXiKXDQW1nZrQaz9Ig7OBZtWbIYm5pCNOyQje05w2S
        v831vKLSnX4KjJi9qC4MiO9Er5vBG5ON7E7QM+uFflwtUcgDN+8zGkULIz2tFp6X
        EjO3Bolp991igx9zaYC+1vjW9D2rLp88th3gc1HLmX5grhARzXL9iWoWXzQkDQZ8
        4oz24zjJ9MxtcHSzbjk+B1UGctB6l5pDL1b2977ppIXSx89JEKf9w==
X-ME-Sender: <xms:vO4_YTAHbE7-GnXOm6--EauDNbRTrTZ_hCvSzuamyc7mKrZKNd_Jyg>
    <xme:vO4_YZhLqvoupsgnlqoUWsErF-Y0MmYiVb0KRLTqoA9-1fZRTDq1lfrE_reoVbN7b
    AiJBSgu26ujOJJqqWI>
X-ME-Received: <xmr:vO4_YekX7TEjKw4AZUb_dq-Br4MyquBZ4Xj0nHsqVqUYbJXgNPZwvG6jAC_PJpX5kjHPzP1Dy8Nb30LlmgdUR7t-m44qsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegkedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:vO4_YVzwHaOUXwx3_Z7RcRwITicBKX6LnIMnBEguFK79Q1KZhaKTUw>
    <xmx:vO4_YYTDxfKkDaRmJTE251iQL0ymNdQLpTqwScDFCUinhQEtM6yKXw>
    <xmx:vO4_YYZzc0J2AFBTCY5kcEJIBFcMEL_j8Szgmx2TpRymBk4KCDLiAA>
    <xmx:ve4_YR7pYwV76n86adDD2Q5SKHW5sYXEiYekjvYnIY3Y3ws4KS_NZQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 20:37:16 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: [RFC PATCH] fsverity: add enable sysctl
Date:   Mon, 13 Sep 2021 17:37:15 -0700
Message-Id: <ebc9c81c31119e0ce8f810c5729b42eef4c5c3af.1631560857.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

At Facebook, we would find a global killswitch sysctl reassuring while
rolling fs-verity out widely. i.e., we could run it in a logging mode
for a while, measure how it's doing, then fully enable it later.

However, I feel that "let root turn off verity" seems pretty sketchy, so
I was hoping to ask for some feedback on it.

I had another idea of making it per-file sort of like MODE_LOGGING in
dm-verity. I could add a mode to the ioctl args, and perhaps a new ioctl
for getting/setting the mode?

The rest is the commit message from the patch I originally wrote:


Add a sysctl killswitch for verity:
0: verity has no effect, even if configured or used
1: verity is in "audit" mode, only log on failures
2: verity fully enabled; the behavior before this patch

This also precipitated re-organizing sysctls for verity as previously
the only sysctl was for signatures and setting up the sysctl was coupled
with the signature logic.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/verity/Makefile           |  2 ++
 fs/verity/enable.c           |  5 +++
 fs/verity/fsverity_private.h | 15 ++++++++
 fs/verity/init.c             |  7 +++-
 fs/verity/measure.c          |  5 +++
 fs/verity/open.c             |  3 +-
 fs/verity/read_metadata.c    |  5 +++
 fs/verity/signature.c        | 53 +--------------------------
 fs/verity/sysctl.c           | 69 ++++++++++++++++++++++++++++++++++++
 fs/verity/verify.c           | 11 ++++--
 10 files changed, 119 insertions(+), 56 deletions(-)
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
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 77e159a0346b..f7d2e1ed4b69 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -14,6 +14,8 @@
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 
+extern int fsverity_enable;
+
 /*
  * Read a file data page for Merkle tree construction.  Do aggressive readahead,
  * since we're sequentially reading the entire file.
@@ -343,6 +345,9 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 	struct fsverity_enable_arg arg;
 	int err;
 
+	if (!fsverity_enable)
+		return -EOPNOTSUPP;
+
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a7920434bae5..43604b80a562 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -136,6 +136,21 @@ int fsverity_get_descriptor(struct inode *inode,
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
+	return;
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
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index f0d7b30c62db..789d0a8672f9 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -9,6 +9,8 @@
 
 #include <linux/uaccess.h>
 
+extern int fsverity_enable;
+
 /**
  * fsverity_ioctl_measure() - get a verity file's digest
  * @filp: file to get digest of
@@ -28,6 +30,9 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	const struct fsverity_hash_alg *hash_alg;
 	struct fsverity_digest arg;
 
+	if (!fsverity_enable)
+		return -EOPNOTSUPP;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 60ff8af7219f..8230def90017 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 
 static struct kmem_cache *fsverity_info_cachep;
+extern int fsverity_enable;
 
 /**
  * fsverity_init_merkle_tree_params() - initialize Merkle tree parameters
@@ -344,7 +345,7 @@ static int ensure_verity_info(struct inode *inode)
  */
 int fsverity_file_open(struct inode *inode, struct file *filp)
 {
-	if (!IS_VERITY(inode))
+	if (!IS_VERITY(inode) || !fsverity_enable)
 		return 0;
 
 	if (filp->f_mode & FMODE_WRITE) {
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index 7e2d0c7bdf0d..d262e26086f5 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -12,6 +12,8 @@
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
 
+extern int fsverity_enable;
+
 static int fsverity_read_merkle_tree(struct inode *inode,
 				     const struct fsverity_info *vi,
 				     void __user *buf, u64 offset, int length)
@@ -157,6 +159,9 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
 	int length;
 	void __user *buf;
 
+	if (!fsverity_enable)
+		return -EOPNOTSUPP;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..2b1280c66d21 100644
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
@@ -87,45 +83,6 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
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
@@ -139,14 +96,6 @@ int __init fsverity_init_signature(void)
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
index 000000000000..6ff1ae34931e
--- /dev/null
+++ b/fs/verity/sysctl.c
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include "fsverity_private.h"
+
+#include <linux/sysctl.h>
+
+static int two = 2;
+/*
+ * /proc/sys/fs/verity/require_signatures
+ * If 1, all verity files must have a valid builtin signature.
+ */
+int fsverity_require_signatures;
+/*
+ * /proc/sys/fs/verity/enable
+ * If 0, disable verity, don't verify, ignore enable ioctl.
+ * If 1, allow enabling verity, but only log on verification failure.
+ * If 2, fully enable.
+ * default: 2
+ */
+int fsverity_enable = 2;
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
+	{
+		.procname       = "enable",
+		.data           = &fsverity_enable,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = &two,
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
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 0adb970f4e73..0a52e4c16038 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -12,6 +12,7 @@
 #include <linux/ratelimit.h>
 
 static struct workqueue_struct *fsverity_read_workqueue;
+extern int fsverity_enable;
 
 /**
  * hash_at_level() - compute the location of the block's hash at the given level
@@ -98,8 +99,10 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 	unsigned int hoffsets[FS_VERITY_MAX_LEVELS];
 	int err;
 
-	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page)))
-		return false;
+	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	pr_debug_ratelimited("Verifying data page %lu...\n", index);
 
@@ -174,6 +177,8 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 	for (; level > 0; level--)
 		put_page(hpages[level - 1]);
 
+	if (fsverity_enable == 1)
+		err = 0;
 	return err == 0;
 }
 
@@ -193,6 +198,8 @@ bool fsverity_verify_page(struct page *page)
 	struct ahash_request *req;
 	bool valid;
 
+	if (!fsverity_enable)
+		return true;
 	/* This allocation never fails, since it's mempool-backed. */
 	req = fsverity_alloc_hash_request(vi->tree_params.hash_alg, GFP_NOFS);
 
-- 
2.33.0

