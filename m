Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4112FF8CA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jan 2021 00:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbhAUXZp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 18:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbhAUXG0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 18:06:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0320C061226
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 15:03:51 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id c21so2682926pjr.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 15:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=9aiKVbqQYlPIThgTQ82dzvRvheXuBHM9UbbX1NZZwXQ=;
        b=PDwCDzUeRrtiDbzP8R+ZzFNkDbG94q487W93Pzf3+343mIFOYQTDkuNfSKH3Njmgwk
         Y1YPBbC6QmPRr4Alpg0Kx5Fm+v1IdyCTm0Yg+e6vqeauAts8m3c9NJ8uXTDII+85pRDd
         2zUYu2cZLlMKY7g0UyvFFR98CJuJd0CliHcYVfg1y0sE3TBQVxqi4Mn51kTipxxQG9lG
         SAQqsDMxW+8p4X4CfWdq2yc9jdOF0n7jVQ9JmayBBNV1rw54mgpTduxHdebVkhVQO2xM
         HGr4GC96GJ5HXmQ+RoPWclxW98DPjcCU93GdDJbQ7hQnKT4gdwYR/sa5P6nZIJsn4WW3
         1bXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9aiKVbqQYlPIThgTQ82dzvRvheXuBHM9UbbX1NZZwXQ=;
        b=nliroUXxlEQ40YuepkiK5vxD25dsONKpMu4/1t0k+NyMHWf8U7bAfVFzIQbG2ezdzs
         oXeedxz1bxPJSF8qcG8/RTkm4PpHEV+9pskN6WPXMxlVhakcuESXViP5hsrmut3T7JpS
         aL/xPdxIDwUUEBitMlrjBGHpsxzCJ/RWpqc+M9Nh9Mt00Lj5IslqTxPOljDAyF3GK7+U
         FhhTVw9zTxeNLo24bgef5lfjukvnL9cHh8JSsVjMtcjCNREF7RNQ71nroUczgGZmDfS1
         otKNJtCOZZY1ioEkwvB3kNbzwmIAtwkAOQkWj+rZWVbiATAk4+zVNdrMndOT06x5g5VM
         J5Vg==
X-Gm-Message-State: AOAM531CkJ+bUQWOs+7bUF1OeHjBRAwrub9IO9KbF0EeyQ5JI+/hLFQb
        JN7FhKO8ylSrPk/RqSNAvhaIyEcxtuM=
X-Google-Smtp-Source: ABdhPJwXyycuFLMhL7lKL1NWCjYBJKBgLzmFW+8+TaABQDqzzJuvNirg4GTlA554HwKIFpRGe7RJFJ2TUyQ=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a62:37c7:0:b029:1aa:22ea:537d with SMTP id
 e190-20020a6237c70000b02901aa22ea537dmr1803778pfa.56.1611270230981; Thu, 21
 Jan 2021 15:03:50 -0800 (PST)
Date:   Thu, 21 Jan 2021 23:03:34 +0000
In-Reply-To: <20210121230336.1373726-1-satyat@google.com>
Message-Id: <20210121230336.1373726-7-satyat@google.com>
Mime-Version: 1.0
References: <20210121230336.1373726-1-satyat@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v8 6/8] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support. Direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when the *length* of the
I/O is aligned to the filesystem block size (which is *not* necessarily the
same as the block device's block size).

fscrypt_limit_io_blocks() is called before setting up the iomap to ensure
that the blocks of each bio that iomap will submit will have contiguous
DUNs. Note that fscrypt_limit_io_blocks() is normally a no-op, as normally
the DUNs simply increment along with the logical blocks. But it's needed
to handle an edge case in one of the fscrypt IV generation methods.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
Acked-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/file.c  | 10 ++++++----
 fs/ext4/inode.c |  7 +++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 349b27f0dda0..77681ba5e6cc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -36,9 +36,11 @@
 #include "acl.h"
 #include "truncate.h"
 
-static bool ext4_dio_supported(struct inode *inode)
+static bool ext4_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
 {
-	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENCRYPTED(inode))
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (!fscrypt_dio_supported(iocb, iter))
 		return false;
 	if (fsverity_active(inode))
 		return false;
@@ -61,7 +63,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, to)) {
 		inode_unlock_shared(inode);
 		/*
 		 * Fallback to buffered I/O if the operation being performed on
@@ -495,7 +497,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c173c8405856..e5407699ce92 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3482,6 +3482,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 out:
+	/*
+	 * When inline encryption is enabled, sometimes I/O to an encrypted file
+	 * has to be broken up to guarantee DUN contiguity. Handle this by
+	 * limiting the length of the mapping returned.
+	 */
+	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
+
 	ext4_set_iomap(inode, iomap, &map, offset, length);
 
 	return 0;
-- 
2.30.0.280.ga3ce27912f-goog

