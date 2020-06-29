Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E8F20E215
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jun 2020 00:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbgF2VCU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Jun 2020 17:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731161AbgF2TMt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Jun 2020 15:12:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCD9C00E3CD
        for <linux-fscrypt@vger.kernel.org>; Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id j6so11657313qvl.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 29 Jun 2020 05:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rQCFvxhbLx/r3eMcEvmgZzOJDH58PjJImIwAors0/6o=;
        b=NAdgfUPo9Qgq2/LEw9+yVPLnHdf7y7jX8Pc9Kk4zwCcaKJDy014Acetv+D/mZNPyAU
         pLjClzaFaf5iENTtvfk2uIKCwfkEbSMUG3ULZ+GXEdyWzalMGijfXhvgLmWu0KOA47iM
         dKkCmi+DeJn9oY03Zobb1baIvUKRE6UkiXoTomcrHD7nEQIt5cMl8fHgmD3ygr0192kU
         toQSg73se/AUETCpi7N133WS3ua/rJnlHNGE+gkCfC+fyaXZm1pCwrbP2DcfHUbmddVf
         rYARV6RPHClIqHLIPFsTDuG6Z3Wm5tzGGX+K+ziFlglILfsDbw9EL1us9VCHbjVinldq
         ou2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rQCFvxhbLx/r3eMcEvmgZzOJDH58PjJImIwAors0/6o=;
        b=IQSCnHEkb79NyDcwiXUiC9jxF90CemJ6b8Pl675WVrXnDZGu0di3MQTjl/BgutTXLG
         D/aXVyIaxmsdL4dx0nOY8C5i6NXIbjRCft/DF2zWk9nJ8QOb2w86oHECL6jZHHhpLKX6
         m92YbB5gcaJ2PVTzEIk6qL5daLJXmJIxDlROp1HPHIB7prqTJC2RQ9bE8D305KriQrDr
         rAM3X0sefaL/W77TupHtABI+HWzTFw1K1txX/JNcovp8SCbjvBBQC/X325LrU5cUR0CT
         Ll4Tr/JU2ISnEBioRElG5u8iVKRdNpvGf8LNWufeGnK2bS2KcQLYb6WiQPstidun14Uc
         yCGg==
X-Gm-Message-State: AOAM5324VH1uxrcZV3nzO4C4mI//Nfz6WERfj0RiqAi9iAmYGfiDD+Si
        GL5V7Kg6hvv3rdCCQvl0dp2G11Wi9gv2rihgTBBqAtDF2GNC9C5MXvlO+4IlcG/sUXBWdU4CMqZ
        XZvT/kHkVE6JP4rlclG1u/ZlR5XbPQSMy0EAaovHvJyol5djQ8kZn9t1jONm5kUUs4eS5Lvs=
X-Google-Smtp-Source: ABdhPJzJ+GlPoESKWeWK0lA+tshOOxjFsa9PIKq+VJQURZP/zSeh6AVLT/JDtP2Dgqq7rmDvPtGrlCN5N9M=
X-Received: by 2002:a0c:f281:: with SMTP id k1mr8939133qvl.219.1593432257532;
 Mon, 29 Jun 2020 05:04:17 -0700 (PDT)
Date:   Mon, 29 Jun 2020 12:04:04 +0000
In-Reply-To: <20200629120405.701023-1-satyat@google.com>
Message-Id: <20200629120405.701023-4-satyat@google.com>
Mime-Version: 1.0
References: <20200629120405.701023-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v2 3/4] f2fs: add inline encryption support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Wire up f2fs to support inline encryption via the helper functions which
fs/crypto/ now provides.  This includes:

- Adding a mount option 'inlinecrypt' which enables inline encryption
  on encrypted files where it can be used.

- Setting the bio_crypt_ctx on bios that will be submitted to an
  inline-encrypted file.

- Not adding logically discontiguous data to bios that will be submitted
  to an inline-encrypted file.

- Not doing filesystem-layer crypto on inline-encrypted files.

This patch includes a fix for a race during IPU by
Sahitya Tummala <stummala@codeaurora.org>

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/f2fs.rst |  7 +++
 fs/f2fs/compress.c                 |  2 +-
 fs/f2fs/data.c                     | 78 +++++++++++++++++++++++++-----
 fs/f2fs/super.c                    | 35 ++++++++++++++
 4 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 099d45ac8d8f..8b4fac44f4e1 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -258,6 +258,13 @@ compress_extension=%s  Support adding specified extension, so that f2fs can enab
                        on compression extension list and enable compression on
                        these file by default rather than to enable it via ioctl.
                        For other files, we can still enable compression via ioctl.
+inlinecrypt
+                       When possible, encrypt/decrypt the contents of encrypted
+                       files using the blk-crypto framework rather than
+                       filesystem-layer encryption. This allows the use of
+                       inline encryption hardware. The on-disk format is
+                       unaffected. For more details, see
+                       Documentation/block/inline-encryption.rst.
 ====================== ============================================================
 
 Debugfs Entries
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 1e02a8c106b0..29e50fbe7eca 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1086,7 +1086,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		.submitted = false,
 		.io_type = io_type,
 		.io_wbc = wbc,
-		.encrypted = f2fs_encrypted_file(cc->inode),
+		.encrypted = fscrypt_inode_uses_fs_layer_crypto(cc->inode),
 	};
 	struct dnode_of_data dn;
 	struct node_info ni;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 326c63879ddc..acadfd8ea853 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -14,6 +14,7 @@
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
+#include <linux/blk-crypto.h>
 #include <linux/swap.h>
 #include <linux/prefetch.h>
 #include <linux/uio.h>
@@ -459,6 +460,33 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 	return bio;
 }
 
+static void f2fs_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
+				  pgoff_t first_idx,
+				  const struct f2fs_io_info *fio,
+				  gfp_t gfp_mask)
+{
+	/*
+	 * The f2fs garbage collector sets ->encrypted_page when it wants to
+	 * read/write raw data without encryption.
+	 */
+	if (!fio || !fio->encrypted_page)
+		fscrypt_set_bio_crypt_ctx(bio, inode, first_idx, gfp_mask);
+}
+
+static bool f2fs_crypt_mergeable_bio(struct bio *bio, const struct inode *inode,
+				     pgoff_t next_idx,
+				     const struct f2fs_io_info *fio)
+{
+	/*
+	 * The f2fs garbage collector sets ->encrypted_page when it wants to
+	 * read/write raw data without encryption.
+	 */
+	if (fio && fio->encrypted_page)
+		return !bio_has_crypt_ctx(bio);
+
+	return fscrypt_mergeable_bio(bio, inode, next_idx);
+}
+
 static inline void __submit_bio(struct f2fs_sb_info *sbi,
 				struct bio *bio, enum page_type type)
 {
@@ -684,6 +712,9 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	/* Allocate a new bio */
 	bio = __bio_alloc(fio, 1);
 
+	f2fs_set_bio_crypt_ctx(bio, fio->page->mapping->host,
+			       fio->page->index, fio, GFP_NOIO);
+
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		bio_put(bio);
 		return -EFAULT;
@@ -763,9 +794,10 @@ static void del_bio_entry(struct bio_entry *be)
 	kmem_cache_free(bio_entry_slab, be);
 }
 
-static int add_ipu_page(struct f2fs_sb_info *sbi, struct bio **bio,
+static int add_ipu_page(struct f2fs_io_info *fio, struct bio **bio,
 							struct page *page)
 {
+	struct f2fs_sb_info *sbi = fio->sbi;
 	enum temp_type temp;
 	bool found = false;
 	int ret = -EAGAIN;
@@ -782,13 +814,18 @@ static int add_ipu_page(struct f2fs_sb_info *sbi, struct bio **bio,
 
 			found = true;
 
-			if (bio_add_page(*bio, page, PAGE_SIZE, 0) ==
-							PAGE_SIZE) {
+			if (page_is_mergeable(sbi, *bio, *fio->last_block,
+					fio->new_blkaddr) &&
+			    f2fs_crypt_mergeable_bio(*bio,
+					fio->page->mapping->host,
+					fio->page->index, fio) &&
+			    bio_add_page(*bio, page, PAGE_SIZE, 0) ==
+					PAGE_SIZE) {
 				ret = 0;
 				break;
 			}
 
-			/* bio is full */
+			/* page can't be merged into bio; submit the bio */
 			del_bio_entry(be);
 			__submit_bio(sbi, *bio, DATA);
 			break;
@@ -880,11 +917,13 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	if (!bio) {
 		bio = __bio_alloc(fio, BIO_MAX_PAGES);
 		__attach_io_flag(fio);
+		f2fs_set_bio_crypt_ctx(bio, fio->page->mapping->host,
+				       fio->page->index, fio, GFP_NOIO);
 		bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
 		add_bio_entry(fio->sbi, bio, page, fio->temp);
 	} else {
-		if (add_ipu_page(fio->sbi, &bio, page))
+		if (add_ipu_page(fio, &bio, page))
 			goto alloc_new;
 	}
 
@@ -936,8 +975,11 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 
 	inc_page_count(sbi, WB_DATA_TYPE(bio_page));
 
-	if (io->bio && !io_is_mergeable(sbi, io->bio, io, fio,
-			io->last_block_in_bio, fio->new_blkaddr))
+	if (io->bio &&
+	    (!io_is_mergeable(sbi, io->bio, io, fio, io->last_block_in_bio,
+			      fio->new_blkaddr) ||
+	     !f2fs_crypt_mergeable_bio(io->bio, fio->page->mapping->host,
+				       bio_page->index, fio)))
 		__submit_merged_bio(io);
 alloc_new:
 	if (io->bio == NULL) {
@@ -949,6 +991,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 			goto skip;
 		}
 		io->bio = __bio_alloc(fio, BIO_MAX_PAGES);
+		f2fs_set_bio_crypt_ctx(io->bio, fio->page->mapping->host,
+				       bio_page->index, fio, GFP_NOIO);
 		io->fio = *fio;
 	}
 
@@ -993,11 +1037,14 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 								for_write);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
+
+	f2fs_set_bio_crypt_ctx(bio, inode, first_idx, NULL, GFP_NOFS);
+
 	f2fs_target_device(sbi, blkaddr, bio);
 	bio->bi_end_io = f2fs_read_end_io;
 	bio_set_op_attrs(bio, REQ_OP_READ, op_flag);
 
-	if (f2fs_encrypted_file(inode))
+	if (fscrypt_inode_uses_fs_layer_crypto(inode))
 		post_read_steps |= 1 << STEP_DECRYPT;
 	if (f2fs_compressed_file(inode))
 		post_read_steps |= 1 << STEP_DECOMPRESS_NOWQ;
@@ -2073,8 +2120,9 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 	 * This page will go to BIO.  Do we need to send this
 	 * BIO off first?
 	 */
-	if (bio && !page_is_mergeable(F2FS_I_SB(inode), bio,
-				*last_block_in_bio, block_nr)) {
+	if (bio && (!page_is_mergeable(F2FS_I_SB(inode), bio,
+				       *last_block_in_bio, block_nr) ||
+		    !f2fs_crypt_mergeable_bio(bio, inode, page->index, NULL))) {
 submit_and_realloc:
 		__submit_bio(F2FS_I_SB(inode), bio, DATA);
 		bio = NULL;
@@ -2204,8 +2252,9 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 		blkaddr = data_blkaddr(dn.inode, dn.node_page,
 						dn.ofs_in_node + i + 1);
 
-		if (bio && !page_is_mergeable(sbi, bio,
-					*last_block_in_bio, blkaddr)) {
+		if (bio && (!page_is_mergeable(sbi, bio,
+					*last_block_in_bio, blkaddr) ||
+		    !f2fs_crypt_mergeable_bio(bio, inode, page->index, NULL))) {
 submit_and_realloc:
 			__submit_bio(sbi, bio, DATA);
 			bio = NULL;
@@ -2421,6 +2470,9 @@ int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
 	/* wait for GCed page writeback via META_MAPPING */
 	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
 
+	if (fscrypt_inode_uses_inline_crypto(inode))
+		return 0;
+
 retry_encrypt:
 	fio->encrypted_page = fscrypt_encrypt_pagecache_blocks(page,
 					PAGE_SIZE, 0, gfp_flags);
@@ -2594,7 +2646,7 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 			f2fs_unlock_op(fio->sbi);
 		err = f2fs_inplace_write_data(fio);
 		if (err) {
-			if (f2fs_encrypted_file(inode))
+			if (fscrypt_inode_uses_fs_layer_crypto(inode))
 				fscrypt_finalize_bounce_page(&fio->encrypted_page);
 			if (PageWriteback(page))
 				end_page_writeback(page);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 20e56b0fa46a..23c49c313fb6 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -138,6 +138,7 @@ enum {
 	Opt_alloc,
 	Opt_fsync,
 	Opt_test_dummy_encryption,
+	Opt_inlinecrypt,
 	Opt_checkpoint_disable,
 	Opt_checkpoint_disable_cap,
 	Opt_checkpoint_disable_cap_perc,
@@ -204,6 +205,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_fsync, "fsync_mode=%s"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption=%s"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
+	{Opt_inlinecrypt, "inlinecrypt"},
 	{Opt_checkpoint_disable, "checkpoint=disable"},
 	{Opt_checkpoint_disable_cap, "checkpoint=disable:%u"},
 	{Opt_checkpoint_disable_cap_perc, "checkpoint=disable:%u%%"},
@@ -833,6 +835,13 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			if (ret)
 				return ret;
 			break;
+		case Opt_inlinecrypt:
+#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
+			sb->s_flags |= SB_INLINECRYPT;
+#else
+			f2fs_info(sbi, "inline encryption not supported");
+#endif
+			break;
 		case Opt_checkpoint_disable_cap_perc:
 			if (args->from && match_int(args, &arg))
 				return -EINVAL;
@@ -1590,6 +1599,9 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
 
 	fscrypt_show_test_dummy_encryption(seq, ',', sbi->sb);
 
+	if (sbi->sb->s_flags & SB_INLINECRYPT)
+		seq_puts(seq, ",inlinecrypt");
+
 	if (F2FS_OPTION(sbi).alloc_mode == ALLOC_MODE_DEFAULT)
 		seq_printf(seq, ",alloc_mode=%s", "default");
 	else if (F2FS_OPTION(sbi).alloc_mode == ALLOC_MODE_REUSE)
@@ -1624,6 +1636,8 @@ static void default_options(struct f2fs_sb_info *sbi)
 	F2FS_OPTION(sbi).compress_ext_cnt = 0;
 	F2FS_OPTION(sbi).bggc_mode = BGGC_MODE_ON;
 
+	sbi->sb->s_flags &= ~SB_INLINECRYPT;
+
 	set_opt(sbi, INLINE_XATTR);
 	set_opt(sbi, INLINE_DATA);
 	set_opt(sbi, INLINE_DENTRY);
@@ -2470,6 +2484,25 @@ static void f2fs_get_ino_and_lblk_bits(struct super_block *sb,
 	*lblk_bits_ret = 8 * sizeof(block_t);
 }
 
+static int f2fs_get_num_devices(struct super_block *sb)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+
+	if (f2fs_is_multi_device(sbi))
+		return sbi->s_ndevs;
+	return 1;
+}
+
+static void f2fs_get_devices(struct super_block *sb,
+			     struct request_queue **devs)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	int i;
+
+	for (i = 0; i < sbi->s_ndevs; i++)
+		devs[i] = bdev_get_queue(FDEV(i).bdev);
+}
+
 static const struct fscrypt_operations f2fs_cryptops = {
 	.key_prefix		= "f2fs:",
 	.get_context		= f2fs_get_context,
@@ -2479,6 +2512,8 @@ static const struct fscrypt_operations f2fs_cryptops = {
 	.max_namelen		= F2FS_NAME_LEN,
 	.has_stable_inodes	= f2fs_has_stable_inodes,
 	.get_ino_and_lblk_bits	= f2fs_get_ino_and_lblk_bits,
+	.get_num_devices	= f2fs_get_num_devices,
+	.get_devices		= f2fs_get_devices,
 };
 #endif
 
-- 
2.27.0.212.ge8ba1cc988-goog

