Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04187C4183
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbjJJUl1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343768AbjJJUlV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:21 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC34AF
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:18 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-d84d883c1b6so246268276.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970477; x=1697575277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUVuCMhgLp9ZG1FCOJMjkYEGr1CrEBEZ7HiAZ8GmnT4=;
        b=KOSpINjMt8VtZYzpKiKfwt2ZYFAxOpe2jWSPot3ynzn3VKCHNOdTNveu7IfuAMnqC1
         fKkwYouMMiD8boMBgn5we3LJrx22z79ZigVW1GTS5s8+eczO6CnM04kNupE+FfekyVvL
         LNd8AVpdYSx6ssBpi4quBX8VU9uoNrCa/MFyo+ak+eRjGlGaMgu+VdSWR5iLmfT8F2LH
         AxOBIsejY1lCRWYWrXmiTb6q+j0LNDEgyf+R0lRgdV/yoTRwEMQj6SaR0+XSoXbDLvFE
         5ulDWOWRg97uAPtXPbRpNqqORF5UqbrF+Cr6BoKDAeBdtjJTTsGk5HECLKde40Zgmr0x
         cdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970477; x=1697575277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUVuCMhgLp9ZG1FCOJMjkYEGr1CrEBEZ7HiAZ8GmnT4=;
        b=MjJI2VshSx2msiNNr4b9gOUdyIUtqjg0nmuHGLvcjKVGwysGJBiPZv2GPE8BET7JNU
         hK8CrIBd8qxEAH3O5pnhPxvtLNPjaNSbC1VB5INFNeccE5NZ0hzLW1Eu5ShleS9ykhRG
         wUGb+UMGOyYuGQ7i+hPERyPrFI3gY+iu5rHQYNpp1gdyzOg+ta0TEHAwGY+FvWcqEO2Z
         fD+rclBH6xOLCiDKtRQ4UAVnUPAa1rbC0v2I6D2VGrjRvEl19J4V0U7zMeF6rRtyisYh
         MlbwIInuTrp8RFGm8ApBosalPo8wzJv9EAft5VjbaUtcaF/T8QpvnMr47NMqCvuPMO/k
         uvKQ==
X-Gm-Message-State: AOJu0YwSEgoK9OlvTYm4vYRKYQ6OZPyEPFVw3oNKe/P+FFFvLSMSdJih
        yF/+ynjEooycqb+7C9Ui4l4P+LtmzMiLnOngWa83dQ==
X-Google-Smtp-Source: AGHT+IE89btaHf6z2ZMQE2ILWZRDm5s3O/k1UVn5Kq4F0TibN8tlNSZJsKyYxZR2oLNbBY9fO+GTjw==
X-Received: by 2002:a25:8503:0:b0:d9a:4cc0:a90c with SMTP id w3-20020a258503000000b00d9a4cc0a90cmr2718555ybk.15.1696970477649;
        Tue, 10 Oct 2023 13:41:17 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c201-20020a25c0d2000000b00d9a4aad7f40sm881827ybf.24.2023.10.10.13.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:17 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 12/36] btrfs: add inode encryption contexts
Date:   Tue, 10 Oct 2023 16:40:27 -0400
Message-ID: <2aa2bc594a95829503338d7345c41bae2030bfd3.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

In order to store encryption information for directories, symlinks,
etc., fscrypt stores a context item with each encrypted non-regular
inode. fscrypt provides an arbitrary blob for the filesystem to store,
and it does not clearly fit into an existing structure, so this goes in
a new item type.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/fscrypt.c              | 117 ++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h              |   2 +
 fs/btrfs/inode.c                |  19 ++++++
 fs/btrfs/ioctl.c                |   8 ++-
 include/uapi/linux/btrfs_tree.h |  10 +++
 5 files changed, 154 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 48ab99dfe48d..0e4011d6b1cd 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -1,7 +1,124 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <linux/iversion.h>
 #include "ctree.h"
+#include "accessors.h"
+#include "btrfs_inode.h"
+#include "disk-io.h"
+#include "fs.h"
 #include "fscrypt.h"
+#include "ioctl.h"
+#include "messages.h"
+#include "transaction.h"
+#include "xattr.h"
+
+static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
+{
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
+		.offset = 0,
+	};
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int ret;
+
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
+	if (ret) {
+		len = -ENOENT;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+	/* fscrypt provides max context length, but it could be less */
+	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+	read_extent_buffer(leaf, ctx, ptr, len);
+
+out:
+	btrfs_free_path(path);
+	return len;
+}
+
+static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
+				     size_t len, void *fs_data)
+{
+	struct btrfs_trans_handle *trans = fs_data;
+	struct btrfs_key key = {
+		.objectid = btrfs_ino(BTRFS_I(inode)),
+		.type = BTRFS_FSCRYPT_CTX_ITEM_KEY,
+		.offset = 0,
+	};
+	struct btrfs_path *path = NULL;
+	struct extent_buffer *leaf;
+	unsigned long ptr;
+	int ret;
+
+	if (!trans)
+		trans = btrfs_start_transaction(BTRFS_I(inode)->root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
+	if (ret < 0)
+		goto out_err;
+
+	if (ret > 0) {
+		btrfs_release_path(path);
+		ret = btrfs_insert_empty_item(trans, BTRFS_I(inode)->root, path, &key, len);
+		if (ret)
+			goto out_err;
+	}
+
+	leaf = path->nodes[0];
+	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
+
+	len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
+	write_extent_buffer(leaf, ctx, ptr, len);
+	btrfs_mark_buffer_dirty(trans, leaf);
+	btrfs_release_path(path);
+
+	if (fs_data)
+		return ret;
+
+	BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+	btrfs_sync_inode_flags_to_i_flags(inode);
+	inode_inc_iversion(inode);
+	inode_set_ctime_current(inode);
+	ret = btrfs_update_inode(trans, BTRFS_I(inode));
+	if (ret)
+		goto out_abort;
+	btrfs_free_path(path);
+	btrfs_end_transaction(trans);
+	return 0;
+out_abort:
+	btrfs_abort_transaction(trans, ret);
+out_err:
+	if (!fs_data)
+		btrfs_end_transaction(trans);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static bool btrfs_fscrypt_empty_dir(struct inode *inode)
+{
+	return inode->i_size == BTRFS_EMPTY_DIR_SIZE;
+}
 
 const struct fscrypt_operations btrfs_fscrypt_ops = {
+	.get_context = btrfs_fscrypt_get_context,
+	.set_context = btrfs_fscrypt_set_context,
+	.empty_dir = btrfs_fscrypt_empty_dir,
 };
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 7f4e6888bd43..80adb7e56826 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -5,6 +5,8 @@
 
 #include <linux/fscrypt.h>
 
+#include "fs.h"
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b92da4a4ed21..a316128b3069 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -62,6 +62,7 @@
 #include "defrag.h"
 #include "dir-item.h"
 #include "file-item.h"
+#include "fscrypt.h"
 #include "uuid-tree.h"
 #include "ioctl.h"
 #include "file.h"
@@ -6087,6 +6088,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	struct inode *inode = args->inode;
 	int ret;
 
+	if (fscrypt_is_nokey_name(args->dentry))
+		return -ENOKEY;
+
 	if (!args->orphan) {
 		ret = fscrypt_setup_filename(dir, &args->dentry->d_name, 0,
 					     &args->fname);
@@ -6122,6 +6126,9 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
 	if (dir->i_security)
 		(*trans_num_items)++;
 #endif
+	/* 1 to add fscrypt item */
+	if (args->encrypt)
+		(*trans_num_items)++;
 	if (args->orphan) {
 		/* 1 to add orphan item */
 		(*trans_num_items)++;
@@ -6299,6 +6306,11 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 	inode->i_atime = inode->i_mtime;
 	BTRFS_I(inode)->i_otime = inode->i_mtime;
 
+	if (args->encrypt) {
+		BTRFS_I(inode)->flags |= BTRFS_INODE_ENCRYPT;
+		btrfs_sync_inode_flags_to_i_flags(inode);
+	}
+
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
 	 * must be fully initialized.
@@ -6373,6 +6385,13 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 			goto discard;
 		}
 	}
+	if (args->encrypt) {
+		ret = fscrypt_set_context(inode, trans);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto discard;
+		}
+	}
 
 	inode_tree_add(BTRFS_I(inode));
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 89cd212735ea..1f1506280619 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -156,6 +156,8 @@ static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (flags & BTRFS_INODE_ENCRYPT)
+		iflags |= FS_ENCRYPT_FL;
 	if (ro_flags & BTRFS_INODE_RO_VERITY)
 		iflags |= FS_VERITY_FL;
 
@@ -185,12 +187,14 @@ void btrfs_sync_inode_flags_to_i_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (binode->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	if (binode->flags & BTRFS_INODE_ENCRYPT)
+		new_fl |= S_ENCRYPTED;
 	if (binode->ro_flags & BTRFS_INODE_RO_VERITY)
 		new_fl |= S_VERITY;
 
 	set_mask_bits(&inode->i_flags,
 		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
-		      S_VERITY, new_fl);
+		      S_VERITY | S_ENCRYPTED, new_fl);
 }
 
 /*
@@ -203,7 +207,7 @@ static int check_fsflags(unsigned int old_flags, unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_ENCRYPT_FL))
 		return -EOPNOTSUPP;
 
 	/* COMPR and NOCOMP on new/old are valid */
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index c25fc9614594..ef796a3cf387 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -164,6 +164,8 @@
 #define BTRFS_VERITY_DESC_ITEM_KEY	36
 #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
 
+#define BTRFS_FSCRYPT_CTX_ITEM_KEY	41
+
 #define BTRFS_ORPHAN_ITEM_KEY		48
 /* reserve 2-15 close to the inode for later flexibility */
 
@@ -416,6 +418,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 #define BTRFS_INODE_NOATIME		(1U << 9)
 #define BTRFS_INODE_DIRSYNC		(1U << 10)
 #define BTRFS_INODE_COMPRESS		(1U << 11)
+#define BTRFS_INODE_ENCRYPT	(1U << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1U << 31)
 
@@ -432,6 +435,7 @@ static inline __u8 btrfs_dir_flags_to_ftype(__u8 flags)
 	 BTRFS_INODE_NOATIME |						\
 	 BTRFS_INODE_DIRSYNC |						\
 	 BTRFS_INODE_COMPRESS |						\
+	 BTRFS_INODE_ENCRYPT |						\
 	 BTRFS_INODE_ROOT_ITEM_INIT)
 
 #define BTRFS_INODE_RO_VERITY		(1U << 0)
@@ -1061,6 +1065,12 @@ enum {
 	BTRFS_NR_FILE_EXTENT_TYPES = 3,
 };
 
+enum {
+	BTRFS_ENCRYPTION_NONE,
+	BTRFS_ENCRYPTION_FSCRYPT,
+	BTRFS_NR_ENCRYPTION_TYPES,
+};
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
-- 
2.41.0

