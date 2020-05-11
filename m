Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FE81CE3EA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 May 2020 21:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731464AbgEKTWY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 May 2020 15:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731453AbgEKTWW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 May 2020 15:22:22 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2A52075E;
        Mon, 11 May 2020 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589224942;
        bh=d0mhTf9ltsz6952kdu0zLSAPYKO76veQBl8NydPGJB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dLxJoMny0QN72lRYXNcFmWIIOcbgMyDAbiGZHE09IFd/erBpDY4JaB/ORztvXyk2K
         pbZY1lTGqEJCotE/vj/aKuIxsEPv6rYdN0aDD5Wl+VVPDDmMS3kpP+Y2lHoz4uL2fA
         Dx/Owh3QovbPRpljw8aLLS9I84ngHD0TwojQBnJs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] fs-verity: fix all kerneldoc warnings
Date:   Mon, 11 May 2020 12:21:17 -0700
Message-Id: <20200511192118.71427-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511192118.71427-1-ebiggers@kernel.org>
References: <20200511192118.71427-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Fix all kerneldoc warnings in fs/verity/ and include/linux/fsverity.h.
Most of these were due to missing documentation for function parameters.

Detected with:

    scripts/kernel-doc -v -none fs/verity/*.{c,h} include/linux/fsverity.h

This cleanup makes it possible to check new patches for kerneldoc
warnings without having to filter out all the existing ones.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c           | 2 ++
 fs/verity/fsverity_private.h | 2 +-
 fs/verity/measure.c          | 2 ++
 fs/verity/open.c             | 1 +
 fs/verity/signature.c        | 3 +++
 fs/verity/verify.c           | 3 +++
 include/linux/fsverity.h     | 3 +++
 7 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index d98bea308fd7f1..5ab3bbec810873 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -329,6 +329,8 @@ static int enable_verity(struct file *filp,
 
 /**
  * fsverity_ioctl_enable() - enable verity on a file
+ * @filp: file to enable verity on
+ * @uarg: user pointer to fsverity_enable_arg
  *
  * Enable fs-verity on a file.  See the "FS_IOC_ENABLE_VERITY" section of
  * Documentation/filesystems/fsverity.rst for the documentation.
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 74768cf539daf5..8788f3a5035c2a 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -61,7 +61,7 @@ struct merkle_tree_params {
 	u64 level_start[FS_VERITY_MAX_LEVELS];
 };
 
-/**
+/*
  * fsverity_info - cached verity metadata for an inode
  *
  * When a verity file is first opened, an instance of this struct is allocated
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 05049b68c74553..df409a5682edf9 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -11,6 +11,8 @@
 
 /**
  * fsverity_ioctl_measure() - get a verity file's measurement
+ * @filp: file to get measurement of
+ * @_uarg: user pointer to fsverity_digest
  *
  * Retrieve the file measurement that the kernel is enforcing for reads from a
  * verity file.  See the "FS_IOC_MEASURE_VERITY" section of
diff --git a/fs/verity/open.c b/fs/verity/open.c
index c5fe6948e26290..d007db0c9304d1 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -330,6 +330,7 @@ EXPORT_SYMBOL_GPL(fsverity_prepare_setattr);
 
 /**
  * fsverity_cleanup_inode() - free the inode's verity info, if present
+ * @inode: an inode being evicted
  *
  * Filesystems must call this on inode eviction to free ->i_verity_info.
  */
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index c8b255232de543..b14ed96387ece0 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -28,6 +28,9 @@ static struct key *fsverity_keyring;
 
 /**
  * fsverity_verify_signature() - check a verity file's signature
+ * @vi: the file's fsverity_info
+ * @desc: the file's fsverity_descriptor
+ * @desc_size: size of @desc
  *
  * If the file's fs-verity descriptor includes a signature of the file
  * measurement, verify it against the certificates in the fs-verity keyring.
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index e0cb62da38644b..a8b68c6f663d12 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -179,6 +179,7 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 
 /**
  * fsverity_verify_page() - verify a data page
+ * @page: the page to verity
  *
  * Verify a page that has just been read from a verity file.  The page must be a
  * pagecache page that is still locked and not yet uptodate.
@@ -206,6 +207,7 @@ EXPORT_SYMBOL_GPL(fsverity_verify_page);
 #ifdef CONFIG_BLOCK
 /**
  * fsverity_verify_bio() - verify a 'read' bio that has just completed
+ * @bio: the bio to verify
  *
  * Verify a set of pages that have just been read from a verity file.  The pages
  * must be pagecache pages that are still locked and not yet uptodate.  Pages
@@ -264,6 +266,7 @@ EXPORT_SYMBOL_GPL(fsverity_verify_bio);
 
 /**
  * fsverity_enqueue_verify_work() - enqueue work on the fs-verity workqueue
+ * @work: the work to enqueue
  *
  * Enqueue verification work for asynchronous processing.
  */
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index ecc604e61d61b9..5ac30198e03201 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -200,6 +200,7 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
 
 /**
  * fsverity_active() - do reads from the inode need to go through fs-verity?
+ * @inode: inode to check
  *
  * This checks whether ->i_verity_info has been set.
  *
@@ -207,6 +208,8 @@ static inline void fsverity_enqueue_verify_work(struct work_struct *work)
  * be verified or not.  Don't use IS_VERITY() for this purpose; it's subject to
  * a race condition where the file is being read concurrently with
  * FS_IOC_ENABLE_VERITY completing.  (S_VERITY is set before ->i_verity_info.)
+ *
+ * Return: true if reads need to go through fs-verity, otherwise false
  */
 static inline bool fsverity_active(const struct inode *inode)
 {
-- 
2.26.2

