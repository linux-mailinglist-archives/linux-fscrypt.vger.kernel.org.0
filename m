Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05CA2DD3C1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgLQPGH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728652AbgLQPGG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:06:06 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DF5C061248
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:52 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id u8so16996563qvm.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=gUHtlY29KgYt4sJ00WK6RieWdOsnGeYeOfjOKvllIlw=;
        b=hXnpH4iybBNdXkdra8xGAeRwak4mM5FsawfYx5o+i4XIL6/L+yIeNbxDaYs90z8g22
         excIt5dg2/HLr6cd3Lkm5YLaShtVzP8uvz5cb+54qwVzUHqFoguDecYQVWkeXAM3XYqz
         P8nQNJtuCctra0nAmlQ8umC2QMe4BKnpEgsQYKAM1fs+NMByfDmv60kd5yuwXJjTPvu0
         I+mpiun5a98CObtZMoDjuO+HHLOhiGJUcQQ0tri4E4mjRm5IoXIr72s28SFCJqgUNeGN
         b925rRpfbYE8YOsKsauH6l0c8V9kSX16sN8Hi1C733lL2AqXIHjJiHRc9zG+CnJDtKRH
         jdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gUHtlY29KgYt4sJ00WK6RieWdOsnGeYeOfjOKvllIlw=;
        b=Ja8QIfQyhNc4Wg4epO0R6NGVWOnVQFo4MX328QFd+QYQQvVL1Rfz53you7suqRKTv2
         Efw/cjXd3Y/uF5Oebatn3D7AM8MQtxg1mC0lTmmuQ0gLIH42o8VByWDhwwBO3KTu52jH
         lJbT/Eqin8Q3KH1d6k09dK4omxiuNyFp0+PAaxOBfwFiYkBE7laUOArxs6bb+mGaDyz8
         bClmHzSTGOVjGaV+Mr4gq9s3CObth3Y48Z4CNbXSCB0jZSoF88iF591W3N/6atchQlr/
         sds370ywKYkf5pDMNSDqddyiF+EfkRTb2j+gPM0sAaMMOozLDzTNGFpGXt/fyg7QDfro
         kEjA==
X-Gm-Message-State: AOAM5322/VobIMC83jUSPpHE6urxQ2/cRhzEc5oGYVo/zeUDBnyMzynn
        wjUKiXnz56lRInT6VIuEZIFFiDM1ULc=
X-Google-Smtp-Source: ABdhPJxfVLg4dVq1oQLbKGyjfcacFaij6ffBEa7ezVhjup4u5DaiBk1bP+eQsCkMuUm56B9OLd27A3wZ5NQ=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a0c:f00e:: with SMTP id z14mr28530594qvk.25.1608217491181;
 Thu, 17 Dec 2020 07:04:51 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:04:35 +0000
In-Reply-To: <20201217150435.1505269-1-satyat@google.com>
Message-Id: <20201217150435.1505269-4-satyat@google.com>
Mime-Version: 1.0
References: <20201217150435.1505269-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH v2 3/3] f2fs: Add metadata encryption support
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Wire up metadata encryption support with the fscrypt metadata crypt
additions. Note that this feature relies on the blk-crypto framework
for encryption, and thus requires either hardware inline encryption
support or the blk-crypto-fallback.

Filesystems can be configured with metadata encryption support using the
f2fs userspace tools (mkfs.f2fs). Once formatted, F2FS filesystems with
metadata encryption can be mounted as long as the required key is present.
fscrypt looks for a logon key with the key descriptor=
fscrypt:<metadata_key_identifier>. The metadata_key_identifier is stored in
the filesystem superblock (and the userspace tools print the required
key descriptor).

Right now, the superblock of the filesystem is itself not encrypted. F2FS
reads the superblock using sb_bread, which uses the bd_inode of the block
device as the address space for any data it reads from the block device -
the data read under the bd_inode address space must be what is physically
present on disk (i.e. if the superblock is encrypted, then the ciphertext
of the superblock must be present in the page cache in the bd_inode's
address space), but f2fs requires that the superblock is decrypted by
blk-crypto, which would put the decrypted page contents into the page cache
instead. We could make f2fs read the superblock by submitting bios directly
with a separate address space, but we choose to just not encrypt the
superblock for now.

Not encrypting the superblock allows us to store the encryption algorithm
used for metadata encryption within the superblock itself, which simplifies
a few things. The userspace tools will store the encryption algorithm in
the superblock when formatting the FS.

Direct I/O with metadata encryption is also not supported for now.
Attempts to do direct I/O on a metadata encrypted F2FS filesystem will fall
back to using buffered I/O (just as attempts to do direct I/O on fscrypt
encrypted files also fall back to buffered I/O).

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/f2fs/data.c          | 17 ++++++++--------
 fs/f2fs/f2fs.h          |  2 ++
 fs/f2fs/super.c         | 44 +++++++++++++++++++++++++++++++++++++----
 include/linux/f2fs_fs.h |  7 ++++++-
 4 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 627164706029..4bb7d1dd2a18 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -460,8 +460,8 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
 	return bio;
 }
 
-static void f2fs_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
-				  pgoff_t first_idx,
+static void f2fs_set_bio_crypt_ctx(struct bio *bio, block_t blk_addr,
+				  const struct inode *inode, pgoff_t first_idx,
 				  const struct f2fs_io_info *fio,
 				  gfp_t gfp_mask)
 {
@@ -470,7 +470,7 @@ static void f2fs_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	 * read/write raw data without encryption.
 	 */
 	if (!fio || !fio->encrypted_page)
-		fscrypt_set_bio_crypt_ctx(bio, 0, inode, first_idx, gfp_mask);
+		fscrypt_set_bio_crypt_ctx(bio, blk_addr, inode, first_idx, gfp_mask);
 }
 
 static bool f2fs_crypt_mergeable_bio(struct bio *bio, const struct inode *inode,
@@ -712,7 +712,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	/* Allocate a new bio */
 	bio = __bio_alloc(fio, 1);
 
-	f2fs_set_bio_crypt_ctx(bio, fio->page->mapping->host,
+	f2fs_set_bio_crypt_ctx(bio, fio->new_blkaddr, fio->page->mapping->host,
 			       fio->page->index, fio, GFP_NOIO);
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
@@ -918,7 +918,8 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	if (!bio) {
 		bio = __bio_alloc(fio, BIO_MAX_PAGES);
 		__attach_io_flag(fio);
-		f2fs_set_bio_crypt_ctx(bio, fio->page->mapping->host,
+		f2fs_set_bio_crypt_ctx(bio, fio->new_blkaddr,
+				       fio->page->mapping->host,
 				       fio->page->index, fio, GFP_NOIO);
 		bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
@@ -992,7 +993,8 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 			goto skip;
 		}
 		io->bio = __bio_alloc(fio, BIO_MAX_PAGES);
-		f2fs_set_bio_crypt_ctx(io->bio, fio->page->mapping->host,
+		f2fs_set_bio_crypt_ctx(io->bio, fio->new_blkaddr,
+				       fio->page->mapping->host,
 				       bio_page->index, fio, GFP_NOIO);
 		io->fio = *fio;
 	}
@@ -1039,9 +1041,8 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-	f2fs_set_bio_crypt_ctx(bio, inode, first_idx, NULL, GFP_NOFS);
-
 	f2fs_target_device(sbi, blkaddr, bio);
+	f2fs_set_bio_crypt_ctx(bio, blkaddr, inode, first_idx, NULL, GFP_NOFS);
 	bio->bi_end_io = f2fs_read_end_io;
 	bio_set_op_attrs(bio, REQ_OP_READ, op_flag);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cb700d797296..af2c1f5136d9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4122,6 +4122,8 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 
 	if (f2fs_post_read_required(inode))
 		return true;
+	if (fscrypt_metadata_crypted(sbi->sb))
+		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
 	/*
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4872973d7a22..d817aa1cfc18 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -981,7 +981,6 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 		return -EINVAL;
 	}
 #endif
-
 	if (F2FS_IO_SIZE_BITS(sbi) && !f2fs_lfs_mode(sbi)) {
 		f2fs_err(sbi, "Should set mode=lfs with %uKB-sized IO",
 			 F2FS_IO_SIZE_KB(sbi));
@@ -1268,6 +1267,8 @@ static void f2fs_put_super(struct super_block *sb)
 	iput(sbi->meta_inode);
 	sbi->meta_inode = NULL;
 
+	fscrypt_free_metadata_encryption(sb);
+
 	/*
 	 * iput() can update stat information, if f2fs_write_checkpoint()
 	 * above failed with error.
@@ -2533,6 +2534,9 @@ static int f2fs_get_num_devices(struct super_block *sb)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	if (!sbi)
+		return 0;
+
 	if (f2fs_is_multi_device(sbi))
 		return sbi->s_ndevs;
 	return 1;
@@ -2910,6 +2914,13 @@ static int sanity_check_raw_super(struct f2fs_sb_info *sbi,
 		return -EFSCORRUPTED;
 	}
 
+	/* Check if FS has metadata encryption if kernel doesn't support it */
+#ifndef CONFIG_FS_ENCRYPTION_METADATA
+	if (raw_super->metadata_crypt_alg) {
+		f2fs_err(sbi, "Filesystem has metadata encryption but kernel support for it wasn't enabled");
+		return -EINVAL;
+	}
+#endif
 	/* check CP/SIT/NAT/SSA/MAIN_AREA area boundary */
 	if (sanity_check_area_boundary(sbi, bh))
 		return -EFSCORRUPTED;
@@ -3510,6 +3521,21 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 						sizeof(raw_super->uuid));
 
 	default_options(sbi);
+
+#ifdef CONFIG_FS_ENCRYPTION
+	sb->s_cop = &f2fs_cryptops;
+#endif
+	if (sbi->raw_super->metadata_crypt_alg) {
+		err = fscrypt_setup_metadata_encryption(sb,
+				sbi->raw_super->metadata_crypt_key_ident,
+				le32_to_cpu(sbi->raw_super->metadata_crypt_alg),
+				sizeof(block_t));
+		if (err) {
+			f2fs_err(sbi, "Could not setup metadata encryption");
+			goto free_sb_buf;
+		}
+	}
+
 	/* parse mount options */
 	options = kstrdup((const char *)data, GFP_KERNEL);
 	if (data && !options) {
@@ -3544,9 +3570,6 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 #endif
 
 	sb->s_op = &f2fs_sops;
-#ifdef CONFIG_FS_ENCRYPTION
-	sb->s_cop = &f2fs_cryptops;
-#endif
 #ifdef CONFIG_FS_VERITY
 	sb->s_vop = &f2fs_verityops;
 #endif
@@ -3658,6 +3681,12 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_devices;
 	}
 
+	err = fscrypt_metadata_crypt_prepare_all_devices(sb);
+	if (err) {
+		f2fs_err(sbi, "Failed to initialize metadata crypt on all devices");
+		goto free_devices;
+	}
+
 	err = f2fs_init_post_read_wq(sbi);
 	if (err) {
 		f2fs_err(sbi, "Failed to initialize post read workqueue");
@@ -3860,6 +3889,12 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 
 	f2fs_notice(sbi, "Mounted with checkpoint version = %llx",
 		    cur_cp_version(F2FS_CKPT(sbi)));
+	if (fscrypt_metadata_crypted(sb)) {
+		f2fs_notice(sbi, "Mounted with metadata key identifier = %s%*phN",
+			    FSCRYPT_KEY_DESC_PREFIX,
+			    FSCRYPT_KEY_IDENTIFIER_SIZE,
+			    sbi->raw_super->metadata_crypt_key_ident);
+	}
 	f2fs_update_time(sbi, CP_TIME);
 	f2fs_update_time(sbi, REQ_TIME);
 	clear_sbi_flag(sbi, SBI_CP_DISABLED_QUICK);
@@ -3931,6 +3966,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	fscrypt_free_dummy_policy(&F2FS_OPTION(sbi).dummy_enc_policy);
 	kvfree(options);
 free_sb_buf:
+	fscrypt_free_metadata_encryption(sb);
 	kfree(raw_super);
 free_sbi:
 	if (sbi->s_chksum_driver)
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index a5dbb57a687f..34b2f6156694 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -10,6 +10,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/types.h>
+#include <linux/fscrypt.h>
 
 #define F2FS_SUPER_OFFSET		1024	/* byte-size offset */
 #define F2FS_MIN_LOG_SECTOR_SIZE	9	/* 9 bits for 512 bytes */
@@ -115,7 +116,11 @@ struct f2fs_super_block {
 	__u8 hot_ext_count;		/* # of hot file extension */
 	__le16  s_encoding;		/* Filename charset encoding */
 	__le16  s_encoding_flags;	/* Filename charset encoding flags */
-	__u8 reserved[306];		/* valid reserved region */
+	/* The metadata encryption algorithm (FSCRYPT_MODE_*) */
+	__le32 metadata_crypt_alg;
+	/* The metadata encryption key identifier */
+	__u8 metadata_crypt_key_ident[FSCRYPT_KEY_IDENTIFIER_SIZE];
+	__u8 reserved[286];		/* valid reserved region */
 	__le32 crc;			/* checksum of superblock */
 } __packed;
 
-- 
2.29.2.729.g45daf8777d-goog

