Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B37012AD46
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Dec 2019 16:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLZPnI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Dec 2019 10:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfLZPnI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Dec 2019 10:43:08 -0500
Received: from zzz.tds (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5EB206A4;
        Thu, 26 Dec 2019 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577374986;
        bh=PP6jkSc/QXOCmLJGVaYVYKwJ1LRIg+2zs1+Hj8jbbfc=;
        h=From:To:Cc:Subject:Date:From;
        b=CUI5TUxdI8fWbuOIQyVDVo6vnNZMmHAVb6s+47CAqkyzDuUdBcv6MxOYeLRE46yZk
         AXWcYcHYukoN4aLQGfFvv79z9zsHXuGDMvQ2bSG4SHopF9YOaC1Z1VNZy4EeuGFKop
         6OPindYgqINW9nmhqE2m1uW7UqFqxY643+qvKxJY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: allow ZERO_RANGE on encrypted files
Date:   Thu, 26 Dec 2019 09:42:16 -0600
Message-Id: <20191226154216.4808-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When ext4 encryption support was first added, ZERO_RANGE was disallowed,
supposedly because test failures (e.g. ext4/001) were seen when enabling
it, and at the time there wasn't enough time/interest to debug it.

However, there's actually no reason why ZERO_RANGE can't work on
encrypted files.  And it fact it *does* work now.  Whole blocks in the
zeroed range are converted to unwritten extents, as usual; encryption
makes no difference for that part.  Partial blocks are zeroed in the
pagecache and then ->writepages() encrypts those blocks as usual.
ext4_block_zero_page_range() handles reading and decrypting the block if
needed before actually doing the pagecache write.

Also, f2fs has always supported ZERO_RANGE on encrypted files.

As far as I can tell, the reason that ext4/001 was failing in v4.1 was
actually because of one of the bugs fixed by commit 36086d43f657 ("ext4
crypto: fix bugs in ext4_encrypted_zeroout()").  The bug made
ext4_encrypted_zeroout() always return a positive value, which caused
unwritten extents in encrypted files to sometimes not be marked as
initialized after being written to.  This bug was not actually in
ZERO_RANGE; it just happened to trigger during the extents manipulation
done in ext4/001 (and probably other tests too).

So, let's enable ZERO_RANGE on encrypted files on ext4.

Tested with:
	gce-xfstests -c ext4/encrypt -g auto
	gce-xfstests -c ext4/encrypt_1k -g auto

Got the same set of test failures both with and without this patch.
But with this patch 6 fewer tests are skipped: ext4/001, generic/008,
generic/009, generic/033, generic/096, and generic/511.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 6 +++---
 fs/ext4/extents.c                     | 7 +------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 68c2bc8275cf..07f1f15276bf 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -975,9 +975,9 @@ astute users may notice some differences in behavior:
 - Direct I/O is not supported on encrypted files.  Attempts to use
   direct I/O on such files will fall back to buffered I/O.
 
-- The fallocate operations FALLOC_FL_COLLAPSE_RANGE,
-  FALLOC_FL_INSERT_RANGE, and FALLOC_FL_ZERO_RANGE are not supported
-  on encrypted files and will fail with EOPNOTSUPP.
+- The fallocate operations FALLOC_FL_COLLAPSE_RANGE and
+  FALLOC_FL_INSERT_RANGE are not supported on encrypted files and will
+  fail with EOPNOTSUPP.
 
 - Online defragmentation of encrypted files is not supported.  The
   EXT4_IOC_MOVE_EXT and F2FS_IOC_MOVE_RANGE ioctls will fail with
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0e8708b77da6..dae66e8f0c3a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4890,14 +4890,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * range since we would need to re-encrypt blocks with a
 	 * different IV or XTS tweak (which are based on the logical
 	 * block number).
-	 *
-	 * XXX It's not clear why zero range isn't working, but we'll
-	 * leave it disabled for encrypted inodes for now.  This is a
-	 * bug we should fix....
 	 */
 	if (IS_ENCRYPTED(inode) &&
-	    (mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
-		     FALLOC_FL_ZERO_RANGE)))
+	    (mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE)))
 		return -EOPNOTSUPP;
 
 	/* Return error if mode is not supported */
-- 
2.24.1

