Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7374D513E76
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 00:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352839AbiD1WXA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 Apr 2022 18:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237230AbiD1WW7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 Apr 2022 18:22:59 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D44BF32C
        for <linux-fscrypt@vger.kernel.org>; Thu, 28 Apr 2022 15:19:43 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B38A73200973;
        Thu, 28 Apr 2022 18:19:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 28 Apr 2022 18:19:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651184382; x=1651270782; bh=Lk
        u8dSa0YNRw/UmYyQIh0l7pvpo2E3YOc+OtY9zcVgw=; b=0jcEf1FeJZYiXkV6d6
        SLWK0udPIIvzQXXJY/LMhI9pz7BoBJYr7bP197pFIjpfYvD02nBG8wW4eB98Glmh
        gu0B/QdRnD9WneZu2fxE2s2wZviY7cEcC2+tGX1vkXX3gdV7EzxYnwLFo7dyRmwP
        kDtrn3S+XRrhr/BnJMl4k7KtmyTkEL4qztmfQNyXZhbYyk9AVvne5kTng9tQWaF3
        fD0CW+BaF/hO+HkDyCCfCCEcHY6bMaHfdUC+Jdvr6NtGo9D5eSqA9v3QJRNAoBvk
        wbbJ0CB22TNkTLJ1bZ89xH7LKn9oMvZKJ8AK8SNhBguW+DQKjvuiiJ0KxwPLHlhn
        rAAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651184382; x=1651270782; bh=Lku8dSa0YNRw/UmYyQIh0l7pvpo2E3YOc+O
        tY9zcVgw=; b=Xlarn8kKCjBjcJDEzjiR/TvV1u1lHX2i3g/Ohaas4kJqFH8rq5w
        1TzEMp1Z8nEfCQGfaglFKVM/eWo0UgxcgaFC6gspr2No1zvhADf7GZG0xE6H6vzD
        Pg62RrdMB3ucaZ4nGp3d1VQHXhuuV2NjNfmK6A+RleS6k8eXebPVc80XJE84k3zy
        S5mOo3VXUOnXxZEB7Y569NqKYoxi8Nn7W/w0DZvZjpB18QnsrEbHG/qMeHASuSEy
        KZUnxu0v056E8ZIzwrO+SMBcsF0xGuzpg64vNgpnobuEI+oIBW2gq5i8/eS8x67p
        2fichBj55xeUmqD0TpCU4rAAaO2wvrkfk9w==
X-ME-Sender: <xms:_RJrYiy7ebIdS18zYxOR7xELPIZcIlb-8eRCwI-jLEmzEfyXQJIuCg>
    <xme:_RJrYuRVhFjWK8QoMC6za4l3EfM5uWE2i3wgCyJNcaejhqgpO2NMBmrJSpBNXyhYL
    -pFYkStVXPeWw_4QJI>
X-ME-Received: <xmr:_RJrYkXCE3NNUGuluflTjcZzAXLrenSmD9H_3c6v0jEr5xRD6zPbQX-AAyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekgddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:_hJrYoghc_KbC6FlMthKau5Pp_z5cuBCefcFRKy3kWddVLzJsjIkvA>
    <xmx:_hJrYkA7ycAIDjQXYbyg4z7BeVgr0xeEAugeQxUcsKxEa-KS5P2O_g>
    <xmx:_hJrYpJW0ID76O6aHDTUvXnDuWjYVGzhWNk1DOCke_dByBPg9_eeMg>
    <xmx:_hJrYvoCezIJg18EbYYBIfVSkHirSsenK9-ZT1QQaSUa-A-1X9X4WQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 28 Apr 2022 18:19:41 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/2] fsverity: add mode sysctl
Date:   Thu, 28 Apr 2022 15:19:20 -0700
Message-Id: <70ca249017356383ed420b8213713309b8d15d0f.1651184207.git.boris@bur.io>
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

Add a "mode" sysctl to act as a killswitch for fs-verity. The motivation
is that in case there is an unforeseen performance regression or bug in
verity as one attempts to use it in production, being able to disable it
live gives a lot of peace of mind. One could also run in audit mode for
a while before switching to the enforcing mode.

The modes are:
disable: verity has no effect, even if configured or used
audit: run the verity logic, permit ioctls, but only log on failures
enforce: fully enabled; the default and the behavior before this patch

This also precipitated re-organizing sysctls for verity as previously
the only sysctl was for signatures so sysctls and signatures were
coupled.

One slightly subtle issue is what errors should "audit" swallow.
Certainly verification or signature errors, but there is a slippery
slope leading to inconsistent states with half set up verity if you try
to ignore errors in enabling verity on a file. The intent of audit mode
is to still fail normally in verity specific ioctls, but to leave the
file be from the perspective of normal filesystem APIs. However, we must
still disallow writes in audit mode, or else it would immediately lead
to invalid verity state.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/verity/enable.c           |  3 ++
 fs/verity/fsverity_private.h | 10 ++++++
 fs/verity/measure.c          |  3 ++
 fs/verity/open.c             | 14 +++++++--
 fs/verity/read_metadata.c    |  3 ++
 fs/verity/signature.c        | 14 +++++++--
 fs/verity/sysctl.c           | 59 ++++++++++++++++++++++++++++++++++++
 fs/verity/verify.c           | 34 +++++++++++++++++++--
 include/linux/fsverity.h     |  4 +--
 9 files changed, 136 insertions(+), 8 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 60a4372aa4d7..dae21c09e518 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -343,6 +343,9 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 	struct fsverity_enable_arg arg;
 	int err;
 
+	if (fsverity_disabled())
+		return -EPERM;
+
 	if (copy_from_user(&arg, uarg, sizeof(arg)))
 		return -EFAULT;
 
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index c416c1cd9371..05faaa827a9d 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -140,6 +140,8 @@ void __init fsverity_exit_info_cache(void);
 #ifdef CONFIG_SYSCTL
 int __init fsverity_sysctl_init(void);
 void __init fsverity_exit_sysctl(void);
+bool fsverity_disabled(void);
+bool fsverity_enforced(void);
 #else /* !CONFIG_SYSCTL */
 static inline int __init fsverity_sysctl_init(void)
 {
@@ -148,6 +150,14 @@ static inline int __init fsverity_sysctl_init(void)
 static inline void __init fsverity_exit_sysctl(void)
 {
 }
+static inline bool fsverity_disabled(void)
+{
+	return true;
+}
+static inline bool fsverity_enforced(void)
+{
+	return false;
+}
 #endif /* !CONFIG_SYSCTL */
 
 /* signature.c */
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index f0d7b30c62db..f17efaa919e3 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -28,6 +28,9 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	const struct fsverity_hash_alg *hash_alg;
 	struct fsverity_digest arg;
 
+	if (fsverity_disabled())
+		return -EPERM;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 92df87f5fa38..840ad62bf6ac 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -177,7 +177,7 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 		fsverity_err(inode, "Error %d computing file digest", err);
 		goto out;
 	}
-	pr_debug("Computed file digest: %s:%*phN\n",
+	pr_info("Computed file digest: %s:%*phN\n",
 		 vi->tree_params.hash_alg->name,
 		 vi->tree_params.digest_size, vi->file_digest);
 
@@ -344,6 +344,11 @@ static int ensure_verity_info(struct inode *inode)
  */
 int fsverity_file_open(struct inode *inode, struct file *filp)
 {
+	int ret;
+
+	if (fsverity_disabled())
+		return 0;
+
 	if (!IS_VERITY(inode))
 		return 0;
 
@@ -353,7 +358,12 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
 		return -EPERM;
 	}
 
-	return ensure_verity_info(inode);
+	ret = ensure_verity_info(inode);
+	if (!fsverity_enforced()) {
+		fsverity_warn(inode, "AUDIT ONLY: ignore missing verity info");
+		return 0;
+	}
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fsverity_file_open);
 
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index 7e2d0c7bdf0d..5773fbaabf1e 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -157,6 +157,9 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg)
 	int length;
 	void __user *buf;
 
+	if (fsverity_disabled())
+		return -EPERM;
+
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 67a471e4b570..b10515817d8a 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -42,12 +42,18 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 	int err;
 
 	if (sig_size == 0) {
+		err = 0;
 		if (fsverity_require_signatures) {
 			fsverity_err(inode,
 				     "require_signatures=1, rejecting unsigned file!");
-			return -EPERM;
+			if (fsverity_enforced()) {
+				err = -EPERM;
+			} else {
+				fsverity_warn(vi->inode, "AUDIT ONLY. ignore unsigned");
+				err = 0;
+			}
 		}
-		return 0;
+		return err;
 	}
 
 	d = kzalloc(sizeof(*d) + hash_alg->digest_size, GFP_KERNEL);
@@ -75,6 +81,10 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		else
 			fsverity_err(inode, "Error %d verifying file signature",
 				     err);
+		if (!fsverity_enforced()) {
+			fsverity_warn(vi->inode, "AUDIT ONLY. ignore signature error");
+			err = 0;
+		}
 		return err;
 	}
 
diff --git a/fs/verity/sysctl.c b/fs/verity/sysctl.c
index 3ba7b02282db..94ffb78f745c 100644
--- a/fs/verity/sysctl.c
+++ b/fs/verity/sysctl.c
@@ -9,6 +9,21 @@
  * If 1, all verity files must have a valid builtin signature.
  */
 int fsverity_require_signatures;
+/*
+ * /proc/sys/fs/verity/mode
+ * If "disable": disable verity, don't verify, fail all ioctls.
+ * If "audit": allow ioctls, and run verification logic, but only log on verification failure.
+ * If "enforce": fully enforce, verification failure returns errors.
+ * default: "enforce"
+ */
+#define FSVERITY_MODE_LEN 10
+static const char * const fsverity_modes[] = {
+	"disable",
+	"audit",
+	"enforce",
+	NULL
+};
+static char fsverity_mode[FSVERITY_MODE_LEN] = "enforce";
 
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *fsverity_sysctl_header;
@@ -19,6 +34,34 @@ static const struct ctl_path fsverity_sysctl_path[] = {
 	{ }
 };
 
+static int proc_do_fsverity_mode(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	char tmp_mode[FSVERITY_MODE_LEN];
+	const char *const *mode = fsverity_modes;
+	struct ctl_table tmp = {
+		.data = tmp_mode,
+		.maxlen = FSVERITY_MODE_LEN,
+		.mode = table->mode,
+	};
+	int ret;
+
+	strncpy(tmp_mode, fsverity_mode, FSVERITY_MODE_LEN);
+	ret = proc_dostring(&tmp, write, buffer, lenp, ppos);
+	if (write) {
+		while (*mode) {
+			if (!strcmp(*mode, tmp_mode))
+				break;
+			++mode;
+		}
+		if (!*mode)
+			ret = -EINVAL;
+		else
+			strncpy(fsverity_mode, *mode, FSVERITY_MODE_LEN);
+	}
+	return ret;
+}
+
 static struct ctl_table fsverity_sysctl_table[] = {
 	{
 		.procname       = "require_signatures",
@@ -29,6 +72,13 @@ static struct ctl_table fsverity_sysctl_table[] = {
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
+	{
+		.procname       = "mode",
+		.data           = fsverity_mode,
+		.maxlen         = FSVERITY_MODE_LEN,
+		.mode           = 0644,
+		.proc_handler   = proc_do_fsverity_mode,
+	},
 	{ }
 };
 
@@ -48,4 +98,13 @@ void __init fsverity_exit_sysctl(void)
 	unregister_sysctl_table(fsverity_sysctl_header);
 	fsverity_sysctl_header = NULL;
 }
+
+bool fsverity_disabled(void)
+{
+	return !strcmp(fsverity_mode, "disable");
+}
+bool fsverity_enforced(void)
+{
+	return !strcmp(fsverity_mode, "enforce");
+}
 #endif /* !CONFIG_SYSCTL */
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 14e2fb49cff5..aedd8f8d864f 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -7,6 +7,7 @@
 
 #include "fsverity_private.h"
 
+#include "linux/export.h"
 #include <crypto/hash.h>
 #include <linux/bio.h>
 #include <linux/ratelimit.h>
@@ -63,6 +64,10 @@ static inline int cmp_hashes(const struct fsverity_info *vi,
 		     index, level,
 		     vi->tree_params.hash_alg->name, hsize, want_hash,
 		     vi->tree_params.hash_alg->name, hsize, real_hash);
+	if (!fsverity_enforced()) {
+		fsverity_warn(vi->inode, "AUDIT ONLY. ignore corruption");
+		return 0;
+	}
 	return -EBADMSG;
 }
 
@@ -98,8 +103,10 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 	unsigned int hoffsets[FS_VERITY_MAX_LEVELS];
 	int err;
 
-	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page)))
-		return false;
+	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	pr_debug_ratelimited("Verifying data page %lu...\n", index);
 
@@ -193,6 +200,8 @@ bool fsverity_verify_page(struct page *page)
 	struct ahash_request *req;
 	bool valid;
 
+	if (fsverity_disabled())
+		return true;
 	/* This allocation never fails, since it's mempool-backed. */
 	req = fsverity_alloc_hash_request(vi->tree_params.hash_alg, GFP_NOFS);
 
@@ -276,6 +285,27 @@ void fsverity_enqueue_verify_work(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(fsverity_enqueue_verify_work);
 
+/**
+ * fsverity_active() - do reads from the inode need to go through fs-verity?
+ * @inode: inode to check
+ *
+ * This checks whether ->i_verity_info has been set.
+ *
+ * Filesystems call this from ->readahead() to check whether the pages need to
+ * be verified or not.  Don't use IS_VERITY() for this purpose; it's subject to
+ * a race condition where the file is being read concurrently with
+ * FS_IOC_ENABLE_VERITY completing.  (S_VERITY is set before ->i_verity_info.)
+ *
+ * Return: true if reads need to go through fs-verity, otherwise false
+ */
+bool fsverity_active(const struct inode *inode)
+{
+	if (fsverity_disabled())
+		return false;
+	return fsverity_get_info(inode) != NULL;
+}
+EXPORT_SYMBOL_GPL(fsverity_active);
+
 int __init fsverity_init_workqueue(void)
 {
 	/*
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index a7afc800bd8d..51ba4adf7b73 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -147,6 +147,7 @@ int fsverity_ioctl_read_metadata(struct file *filp, const void __user *uarg);
 bool fsverity_verify_page(struct page *page);
 void fsverity_verify_bio(struct bio *bio);
 void fsverity_enqueue_verify_work(struct work_struct *work);
+bool fsverity_active(const struct inode *inode);
 
 #else /* !CONFIG_FS_VERITY */
 
@@ -213,8 +214,6 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 	WARN_ON(1);
 }
 
-#endif	/* !CONFIG_FS_VERITY */
-
 /**
  * fsverity_active() - do reads from the inode need to go through fs-verity?
  * @inode: inode to check
@@ -232,5 +231,6 @@ static inline bool fsverity_active(const struct inode *inode)
 {
 	return fsverity_get_info(inode) != NULL;
 }
+#endif	/* !CONFIG_FS_VERITY */
 
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.30.2

