Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B291D21A837
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 21:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgGITyJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgGITr7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 15:47:59 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F093DC08E806
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 12:47:57 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p127so2023898pfb.18
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 12:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+/XxnKhf8VQXnWlmxkLfLTPJmNMo/X9aFiP13+Lo8YI=;
        b=h/H0yRKbuSfyI8puj/GfGNpcjE4q8yWyZ39S7u7IcbvSYgI4b91Twrik62nZGiY8/z
         vzOjVOI15upZpzR/91wpbk98WfhemXBOL8DnysODYMcDgtbDIUG7EO6XLwAxLx0SkTlF
         QuQjmm6XT0lnZviNNA1jOOUC2jD+UG5qvworuWF3RuQKUTvEWAjaiWPwi84RKPEfbi3m
         hFPycqByVMLVQymThzvU3TnnurvzfN7ul52dp57GX99wkXEEyn1d/4kXqFJDCSww1rkP
         NSAplp6KppOYzHSsEqJTRpsyYGTar0iKcIpip6VZw4atI9KNa17YKeOYmpjk2VYFGA+a
         1cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+/XxnKhf8VQXnWlmxkLfLTPJmNMo/X9aFiP13+Lo8YI=;
        b=fMotXDz8JQxGrCuqIwfPaPH9tIjOJyw6NDTHTQWCmh2qwGQpnB2nMQuKFtq30cXMLo
         dMoZftT2U4fAj/v4Dwg6dsDJNu8ewFzBU015aFo24jCN6wBf5nHCTGIT2ZXLD6cplOgS
         fT9NtBUk2E+gsUR+vnzyXf3i5dh845MI7WijiY9H/fEY/vh/z7LNOPtHDzTOZ71+/ehK
         j9PxryyefUdLnoQLrUdnZAM/NQ62STSLGi5mHYFjop45iYN2AGuAnpiBMEWfo1GPFxjq
         7X9h9hfws3nguQNJqG1Mn1Yd4HK+XuT9EAk9xpgW/6xi519X16f6MIYFz/dDd2h8P177
         4+gw==
X-Gm-Message-State: AOAM5323KNHLm0JNqGbjNl/jWWiACuxlpnoQI3wR2EAtcxZ2U6mutUhF
        PdR0TgSQ8t+2jh+jumJhYmcFpxi44Wrt32/tzl56CU4bWgZomFas2CIbqQseDnI0dG+KVXRBXp6
        y4SsEDb1B4fNRW+ksYku5LqUceAD3HAWByDCro0mAKegRqFx+g8mSXJcfMI1J41pg5fIudmw=
X-Google-Smtp-Source: ABdhPJxYeiQ2L/94mDwyv3mswoERkGf+Tmeckiw7ylTjL8M61t3axBfoCoxoXL00bXkKN7P/cwqndSOs1sQ=
X-Received: by 2002:aa7:9e4e:: with SMTP id z14mr31139029pfq.256.1594324077224;
 Thu, 09 Jul 2020 12:47:57 -0700 (PDT)
Date:   Thu,  9 Jul 2020 19:47:47 +0000
In-Reply-To: <20200709194751.2579207-1-satyat@google.com>
Message-Id: <20200709194751.2579207-2-satyat@google.com>
Mime-Version: 1.0
References: <20200709194751.2579207-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 1/5] fscrypt: Add functions for direct I/O support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Introduce fscrypt_dio_supported() to check whether a direct I/O request
is unsupported due to encryption constraints, and
fscrypt_limit_dio_pages() to check how many pages may be added to a bio
being prepared for direct I/O.

The IV_INO_LBLK_32 fscrypt policy introduces the possibility that DUNs
in logically continuous file blocks might wrap from 0xffffffff to 0.
Bios in which the DUN wraps around like this cannot be submitted. This
is especially difficult to handle when block_size != PAGE_SIZE, since in
that case the DUN can wrap in the middle of a page.

For now, we add direct I/O support while using IV_INO_LBLK_32 policies
only for the case when block_size == PAGE_SIZE. When IV_INO_LBLK_32
policy is used, fscrypt_dio_supported() rejects the bio when
block_size != PAGE_SIZE. fscrypt_limit_dio_pages() returns the number of
pages that may be added to the bio without causing the DUN to wrap
around within the bio.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/crypto/crypto.c       |  8 +++++
 fs/crypto/inline_crypt.c | 72 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h  | 19 +++++++++++
 3 files changed, 99 insertions(+)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index a52cf32733ab..b88d97618efb 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -69,6 +69,14 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
+/*
+ * Generate the IV for the given logical block number within the given file.
+ * For filenames encryption, lblk_num == 0.
+ *
+ * Keep this in sync with fscrypt_limit_dio_pages().  fscrypt_limit_dio_pages()
+ * needs to know about any IV generation methods where the low bits of IV don't
+ * simply contain the lblk_num (e.g., IV_INO_LBLK_32).
+ */
 void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 			 const struct fscrypt_info *ci)
 {
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index d7aecadf33c1..86788ee2b206 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -16,6 +16,7 @@
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
+#include <linux/uio.h>
 
 #include "fscrypt_private.h"
 
@@ -362,3 +363,74 @@ bool fscrypt_mergeable_bio_bh(struct bio *bio,
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
+	if (!IS_ALIGNED(iocb->ki_pos | iov_iter_alignment(iter), blocksize))
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
+
+/**
+ * fscrypt_limit_dio_pages() - limit I/O pages to avoid discontiguous DUNs
+ * @inode: the file on which I/O is being done
+ * @pos: the file position (in bytes) at which the I/O is being done
+ * @nr_pages: the number of pages we want to submit starting at @pos
+ *
+ * For direct I/O: limit the number of pages that will be submitted in the bio
+ * targeting @pos, in order to avoid crossing a data unit number (DUN)
+ * discontinuity.  This is only needed for certain IV generation methods.
+ *
+ * This assumes block_size == PAGE_SIZE; see fscrypt_dio_supported().
+ *
+ * Return: the actual number of pages that can be submitted
+ */
+int fscrypt_limit_dio_pages(const struct inode *inode, loff_t pos, int nr_pages)
+{
+	const struct fscrypt_info *ci = inode->i_crypt_info;
+	u32 dun;
+
+	if (!fscrypt_inode_uses_inline_crypto(inode))
+		return nr_pages;
+
+	if (nr_pages <= 1)
+		return nr_pages;
+
+	if (!(fscrypt_policy_flags(&ci->ci_policy) &
+	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
+		return nr_pages;
+
+	if (WARN_ON_ONCE(i_blocksize(inode) != PAGE_SIZE))
+		return 1;
+
+	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
+
+	dun = ci->ci_hashed_ino + (pos >> inode->i_blkbits);
+
+	return min_t(u64, nr_pages, (u64)U32_MAX + 1 - dun);
+}
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index bb257411365f..9c65d949c611 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -559,6 +559,11 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio_bh(struct bio *bio,
 			      const struct buffer_head *next_bh);
 
+bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter);
+
+int fscrypt_limit_dio_pages(const struct inode *inode, loff_t pos,
+			    int nr_pages);
+
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline bool __fscrypt_inode_uses_inline_crypto(const struct inode *inode)
@@ -587,6 +592,20 @@ static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
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
+static inline int fscrypt_limit_dio_pages(const struct inode *inode, loff_t pos,
+					  int nr_pages)
+{
+	return nr_pages;
+}
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 /**
-- 
2.27.0.383.g050319c2ae-goog

