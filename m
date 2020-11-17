Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A102B6723
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 15:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgKQOJI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 09:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387904AbgKQOHS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 09:07:18 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1267BC061A48
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:19 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 144so14718148pfv.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ngULhpz11Q/j6tHSZGdoq1k2Y18NapqEmNmWx6pnpds=;
        b=snl8AQN+4q0zaDnmgZiKDfY4BcQFwcUPqfaEamyZnARbcBpvvm2tCsbFDhC7PO/kaF
         XpmHVQypDCrEpETyH0O/+IPdPEe8+0F6bjFFPe+HqFOwM5mnRLXJm3qrf3oH5yz93weu
         k8yUvB7kymKr5j1mfzIC1JBZb7b75X9XgzHD6wbTTAx6zcG4bW3As4kxLmJYLAWWbKs+
         v8sgx1pD/T4xCBLazxrhjZOqc1AF/wKhYoGuhM09dAeMU4xK7yhaYyoick9RdHyNjnN/
         r1QEPRlPwRN+pJTqhVxfd2tUWcyfAYU8/yOjD7m64fmvTuG3SCgn0P6TiSsH7bTZFxLv
         zkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ngULhpz11Q/j6tHSZGdoq1k2Y18NapqEmNmWx6pnpds=;
        b=If/zbEpv2nCyQZ8avzZHor7u6tqUSZL8aGqBEiAO8MxwSQoUtAeRPIJqjmBbSvftH9
         kmsTGgSvi3z4KxqG4Q7rJ4d3J9zM/T+8m8UDuOIToQ5372JQC/837d7X5n6hmfY/ETJh
         cg/Tzg0qxJlPmKOQ9r7XI53NVW9zmtF+0M0cw7+pSQ6Soc51pNHwLEOAe3xHC/Wy3Cup
         LIHz7j2brOMYR/7inCeGjxNLO34d0ZSWxGByFgfzekFlXy0QQGWTJSckkicsaHFu4/rP
         u40bgZZQrG2bfQwoPQnWR4TjU/DSS5vprktIdFsUqCXkLWV22Y2Xfe7BBfpAOHMAJDVW
         9X6Q==
X-Gm-Message-State: AOAM533agPjLhzLwc+S6sQkWbfPHztbzdm0U4ZmmsQoEcM8hwQZRGsj+
        g+r0ZyaWKgeG9r0snxvrTayx388B3VY=
X-Google-Smtp-Source: ABdhPJw5NQvqUboH8Ybmr6y+GycjFJcCstoOU2VcZiDffIhrL0ssJ30b/OSNm1zUDKVRLZuAPZdifhA2Hvk=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:902:7fc9:b029:d6:c372:a04b with SMTP id
 t9-20020a1709027fc9b02900d6c372a04bmr17896536plb.4.1605622038458; Tue, 17 Nov
 2020 06:07:18 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:03 +0000
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Message-Id: <20201117140708.1068688-4-satyat@google.com>
Mime-Version: 1.0
References: <20201117140708.1068688-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 3/8] fscrypt: add functions for direct I/O support
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

Introduce fscrypt_dio_supported() to check whether a direct I/O request
is unsupported due to encryption constraints.

Also introduce fscrypt_limit_io_blocks() to limit how many blocks can be
added to a bio being prepared for direct I/O. This is needed for
filesystems that use the iomap direct I/O implementation to avoid DUN
wraparound in the middle of a bio (which is possible with the
IV_INO_LBLK_32 IV generation method). Elsewhere fscrypt_mergeable_bio()
is used for this, but iomap operates on logical ranges directly, so
filesystems using iomap won't have a chance to call fscrypt_mergeable_bio()
on every block added to a bio. So we need this function which limits a
logical range in one go.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/crypto/crypto.c       |  8 +++++
 fs/crypto/inline_crypt.c | 74 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h  | 18 ++++++++++
 3 files changed, 100 insertions(+)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4ef3f714046a..4fcca79f39ae 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -69,6 +69,14 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
+/*
+ * Generate the IV for the given logical block number within the given file.
+ * For filenames encryption, lblk_num == 0.
+ *
+ * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
+ * needs to know about any IV generation methods where the low bits of IV don't
+ * simply contain the lblk_num (e.g., IV_INO_LBLK_32).
+ */
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci)
 {
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index c57bebfa48fe..956f5bfab7a0 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -17,6 +17,7 @@
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
+#include <linux/uio.h>
 
 #include "fscrypt_private.h"
 
@@ -363,3 +364,76 @@ bool fscrypt_mergeable_bio_bh(struct bio *bio,
 	return fscrypt_mergeable_bio(bio, inode, next_lblk);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio_bh);
+
+/**
+ * fscrypt_dio_supported() - check whether a direct I/O request is unsupported
+ *			     due to encryption constraints
+ * @iocb: the file and position the I/O is targeting
+ * @iter: the I/O data segment(s)
+ *
+ * Return: true if direct I/O is supported
+ */
+bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
+{
+	const struct inode *inode = file_inode(iocb->ki_filp);
+	const unsigned int blocksize = i_blocksize(inode);
+
+	/* If the file is unencrypted, no veto from us. */
+	if (!fscrypt_needs_contents_encryption(inode))
+		return true;
+
+	/* We only support direct I/O with inline crypto, not fs-layer crypto */
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return false;
+
+	/*
+	 * Since the granularity of encryption is filesystem blocks, the I/O
+	 * must be block aligned -- not just disk sector aligned.
+	 */
+	if (!IS_ALIGNED(iocb->ki_pos | iov_iter_count(iter), blocksize))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
+
+/**
+ * fscrypt_limit_io_blocks() - limit I/O blocks to avoid discontiguous DUNs
+ * @inode: the file on which I/O is being done
+ * @lblk: the block at which the I/O is being started from
+ * @nr_blocks: the number of blocks we want to submit starting at @lblk
+ *
+ * Determine the limit to the number of blocks that can be submitted in the bio
+ * targeting @lblk without causing a data unit number (DUN) discontinuity.
+ *
+ * This is normally just @nr_blocks, as normally the DUNs just increment along
+ * with the logical blocks.  (Or the file is not encrypted.)
+ *
+ * In rare cases, fscrypt can be using an IV generation method that allows the
+ * DUN to wrap around within logically continuous blocks, and that wraparound
+ * will occur.  If this happens, a value less than @nr_blocks will be returned
+ * so that the wraparound doesn't occur in the middle of the bio.
+ *
+ * Return: the actual number of blocks that can be submitted
+ */
+u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
+{
+	const struct fscrypt_info *ci = inode->i_crypt_info;
+	u32 dun;
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return nr_blocks;
+
+	if (nr_blocks <= 1)
+		return nr_blocks;
+
+	if (!(fscrypt_policy_flags(&ci->ci_policy) &
+	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
+		return nr_blocks;
+
+	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
+
+	dun = ci->ci_hashed_ino + lblk;
+
+	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
+}
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index a8f7a43f031b..39cce302660b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -567,6 +567,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter);
+
+u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
+
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
@@ -595,6 +599,20 @@ static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
 {
 	return true;
 }
+
+static inline bool fscrypt_dio_supported(struct kiocb *iocb,
+					 struct iov_iter *iter)
+{
+	const struct inode *inode = file_inode(iocb->ki_filp);
+
+	return !fscrypt_needs_contents_encryption(inode);
+}
+
+static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
+					  u64 nr_blocks)
+{
+	return nr_blocks;
+}
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /**
-- 
2.29.2.299.gdc1121823c-goog

