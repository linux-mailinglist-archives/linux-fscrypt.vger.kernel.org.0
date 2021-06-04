Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6218839C20A
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 23:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhFDVML (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 17:12:11 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:57101 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbhFDVMK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 17:12:10 -0400
Received: by mail-pg1-f201.google.com with SMTP id 28-20020a63135c0000b029021b78388f01so6666782pgt.23
        for <linux-fscrypt@vger.kernel.org>; Fri, 04 Jun 2021 14:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H6v2kY5YMxOOHLcLSDdX+aEzIdLNYM1I0EjO3txeols=;
        b=v1jZNkJYmY3AfKMvuvpfH3JJQcdV29JlvKaiWzw7Pj5dPY3hbHoKohjT3M1SqQ5FFz
         G/tUkYjzmPiXLBY61CpYrnU7ZI7tvTpp2CBXGHl/LyoFPLLKRvPxUy+N+cPRdapDxLeC
         Z8Eh4SoflqHue1COLbTamqv01t/mA8CE1LJwQOBgEgyAryAOTaY7MJlPrjluNTGeAint
         /gc5P2jZaZ3YZjQRytNEvbbEzCD+sJ/qkVZK7oysVmpkIMUsp5TFiGLVJL+HI3o0vFAa
         ewZH43cN3mTTq1bKsTBmIoWlxjxTnjXv2d97I3HYY+lA+lAakvigohnk7CHOmQBQGEy1
         o3Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H6v2kY5YMxOOHLcLSDdX+aEzIdLNYM1I0EjO3txeols=;
        b=lXpLnJueJInO0pBSpj7bUBHDLnXCUsiLqNlq0r5vn4YD3RJWQINBvwRg0v92dNnyJ5
         y7hDdOj99o51hZrjfiUv1UfY51WDR1JwI3z2J/wT8HT+ZP+W+ge5LXZ4HNEXTZ8IB0Dr
         66yvTH+tI58MoWGoXHskPr4GKbyu8/nwpYT2psGUEqzAm4ktJsSJHFDPHVSCIOyDw/17
         rXzF6oaDqfb47Z+F9ydoYk1BP2SMRROqMkrlvJKgaxikt1RIHALmSe5skZdt5HMmnYtO
         jDy/c0/jxW50KFU2jl45yTqtHdN6LeRV/05/bUmDAGL40hbSxBaj0k44uLpYV04OeJe/
         mV0w==
X-Gm-Message-State: AOAM531gg56kEet3g1STSHCu6GTi0FjAkuyVEn2epLSOo/rqDgdP64H7
        Sg3XgjTE2zPUFm066Ky2hHgi/h+75NE=
X-Google-Smtp-Source: ABdhPJw2OZI8kOjDJIkhSAHFElaeOr1IGaH93bDYTIxiQQ+b217XZW3IqkglpAxk3/foE4UT4038CtgtNRs=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:902:6acb:b029:fc:4d8c:cfba with SMTP id
 i11-20020a1709026acbb02900fc4d8ccfbamr6249435plt.29.1622840963331; Fri, 04
 Jun 2021 14:09:23 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:09:06 +0000
In-Reply-To: <20210604210908.2105870-1-satyat@google.com>
Message-Id: <20210604210908.2105870-8-satyat@google.com>
Mime-Version: 1.0
References: <20210604210908.2105870-1-satyat@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 7/9] ext4: support direct I/O with fscrypt using blk-crypto
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
index 816dedcbd541..a2898a496c4e 100644
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
@@ -511,7 +513,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fe6045a46599..fe8006efb5ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3481,6 +3481,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
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
2.32.0.rc1.229.g3e70b5a671-goog

