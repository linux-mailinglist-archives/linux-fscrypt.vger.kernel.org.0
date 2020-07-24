Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB79822C4DA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jul 2020 14:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgGXMMW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jul 2020 08:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgGXML7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jul 2020 08:11:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33002C08C5DC
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:11:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22so10199007ybg.21
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=r8Pg6JmNaFN8fVBskJ954zlZvlkSSoV1f+xmIU4eJ8Y=;
        b=CIOYCqTme+TnWuKD+xZRysHr8oJo78rie88iaMhNzTS0t45MoVE4RsI/vEVkYotMFZ
         JtjeVNk6dL7xq1AR4PQA6w+exLdpvxRctrNJ2l6hVGYJMGeMH8HU4Izlxs39K4/L9Csg
         iaeQxhWNQr4udHFUBEXYDh0it42hv4TuuYRMH3NvOqxfOT5YQZZhuwdUvMZocLeHtm1+
         wWhBEQsXnDrUzdith9nAVMQtoO0aXYKyWzoqdOJxpf17R/DHVuV6ojo2ym2rZkevTwWN
         dbBmJIWEZR4a7YLOBF2DNCau1fKoD6S7dcgLT2jQsSAOFbzYgqxPmojFzvDL5GEfdwZp
         Xzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=r8Pg6JmNaFN8fVBskJ954zlZvlkSSoV1f+xmIU4eJ8Y=;
        b=SpPfyqs9fwUC3PwLWeAZ1+zH3lo2OKYGBg39SeTGkrUE/IJggCrZELE1tlmDeeF+ZD
         gkrp8cKK5lJMOMs2NOmR1wGGIJgdQfwZqwYePgEUFpfzkN2aRNSVr96CbV2XqTqmqIDF
         Z/7SpAad6xTKl/W1rXLqZ9lsr2ycyEz+veMhI6BPAvQ76NHVe1ApwT3vKfIm+N95iIDE
         9P7gKE1J7dIuZ3zDGBhZcJ9kcrjT102yREB+CQhj7TUZ4sqg5z3552vEssVMv9E5Fnxl
         zrJDVBBemE/EYcPVLdOxa/Czhcp0tHyY4oDhRumzuBNcRrjDMq4kvmsKJE4opWbdBLBA
         fCTQ==
X-Gm-Message-State: AOAM530Z7U24EYF1EVXMn6LqO11l6nEY7tNZCBhCDAVHM2apY3r47T2s
        HK9KLvjizP+Z/ep1MYBPf4HVVSENUPxiBcol3uQzfifzhlvY7dTE6rAcCsuCXYPh+stqb4cOsM8
        utnOthHFVBJEF3hJFmjVbZ8dWUr319JL07YSnwVKrDozLJFWC3Y/G5XmkvWw1ofvioy/mJSI=
X-Google-Smtp-Source: ABdhPJx/KO6QnXMM0Pc1pM0nRqEcHHdAJJmtmE+sSNw66/LnMCl7LqpQ2/7JJlu071k/LdTupwpYQ4l/YFY=
X-Received: by 2002:a5b:74a:: with SMTP id s10mr15292910ybq.101.1595592716305;
 Fri, 24 Jul 2020 05:11:56 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:40 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-5-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 4/7] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support. Direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

fscrypt_limit_io_blocks() is called before setting up the iomap to ensure
that the blocks of each bio that iomap will submit will have contiguous
DUNs. Note that fscrypt_limit_io_blocks() is normally a no-op, as normally
the DUNs simply increment along with the logical blocks. But it's needed
to handle an edge case in one of the fscrypt IV generation methods.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/file.c  | 10 ++++++----
 fs/ext4/inode.c |  7 +++++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a01e31a032c..d534f72675d9 100644
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
@@ -490,7 +492,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 44bad4bb8831..6725116ea348 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3445,6 +3445,13 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	if (ret < 0)
 		return ret;
 
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
2.28.0.rc0.142.g3c755180ce-goog

