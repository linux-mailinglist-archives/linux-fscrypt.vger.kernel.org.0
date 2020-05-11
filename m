Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7E1CE3F7
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 May 2020 21:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgEKTWb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 May 2020 15:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731429AbgEKTWW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 May 2020 15:22:22 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 216DB20882;
        Mon, 11 May 2020 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589224942;
        bh=WDO+wTU5z2N1q8uR2/RvSI6cZVBi4fXWIwtCAyalDqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICUV1do+0NBdYn0xx6KQ+B0rpXr4wRdt1K6Uco4pSoClI9wReBqPvE/onAWi2ctel
         +8H9Io5PQIuP71/uM2U3jz5rRCdViJ13RBDONq2zoLDQrqB3U2N9udr6m1bsT4r0xO
         1NQPEOjScHFSq7nuER/pHjhAipMYsfP/SLenozV8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] fs-verity: remove unnecessary extern keywords
Date:   Mon, 11 May 2020 12:21:18 -0700
Message-Id: <20200511192118.71427-3-ebiggers@kernel.org>
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

Remove the unnecessary 'extern' keywords from function declarations.
This makes it so that we don't have a mix of both styles, so it won't be
ambiguous what to use in new fs-verity patches.  This also makes the
code shorter and matches the 'checkpatch --strict' expectation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/fsverity_private.h |  2 +-
 include/linux/fsverity.h     | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 8788f3a5035c2a..e96d99d5145e1d 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -134,7 +134,7 @@ void __init fsverity_check_hash_algs(void);
 
 /* init.c */
 
-extern void __printf(3, 4) __cold
+void __printf(3, 4) __cold
 fsverity_msg(const struct inode *inode, const char *level,
 	     const char *fmt, ...);
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 5ac30198e03201..78201a6d35f66d 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -121,23 +121,23 @@ static inline struct fsverity_info *fsverity_get_info(const struct inode *inode)
 
 /* enable.c */
 
-extern int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
+int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
 
 /* measure.c */
 
-extern int fsverity_ioctl_measure(struct file *filp, void __user *arg);
+int fsverity_ioctl_measure(struct file *filp, void __user *arg);
 
 /* open.c */
 
-extern int fsverity_file_open(struct inode *inode, struct file *filp);
-extern int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
-extern void fsverity_cleanup_inode(struct inode *inode);
+int fsverity_file_open(struct inode *inode, struct file *filp);
+int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
+void fsverity_cleanup_inode(struct inode *inode);
 
 /* verify.c */
 
-extern bool fsverity_verify_page(struct page *page);
-extern void fsverity_verify_bio(struct bio *bio);
-extern void fsverity_enqueue_verify_work(struct work_struct *work);
+bool fsverity_verify_page(struct page *page);
+void fsverity_verify_bio(struct bio *bio);
+void fsverity_enqueue_verify_work(struct work_struct *work);
 
 #else /* !CONFIG_FS_VERITY */
 
-- 
2.26.2

