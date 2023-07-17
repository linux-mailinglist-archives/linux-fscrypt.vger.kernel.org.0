Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE92A755A52
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjGQDx2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjGQDxT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:19 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830EE48;
        Sun, 16 Jul 2023 20:53:18 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id A50D48341B;
        Sun, 16 Jul 2023 23:53:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565998; bh=qx6HHyvFnMQ36spD8HTeyGJvMMVybZw/KR0D2N5Xg4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyYCzqzRziFmh2Igbu4zXO9f37yj/274PqzBQsagYDicYH2p2mU1OFgqMZM88qCd6
         jb7hbi1ttkrUyj91+z7p2kUxURQp68CccEpq6ACHpSaJL/ewvKZg7xQMBXSxtZmhQY
         Swk6i+vsV+XJVMZ0E88i9DxA+ctzA3BkN7mm3hVUzwo6MRtB8Dt25IPwf1q8B9O7Rl
         l5U6QJX3VP7eTqo5zAeWedNH93/1AxqYdrtEjoIaHDP+8RaJR4o1pvBnSA4VSvM0ig
         /c2VQeo0C4SM3iFDiC2QmpmD/g6vXJdbve1Qj9HpAUXmLXhHwvYVZ4RPEHNtAeq0Yc
         3hFmSfw6LB1qg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 16/17] btrfs: explicitly track file extent length and encryption
Date:   Sun, 16 Jul 2023 23:52:47 -0400
Message-Id: <85b570f5b467dab2da4e125166283e3d3d1aada2.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

With the advent of storing fscrypt contexts with each encrypted extent,
extents will have a variable length depending on encryption status.
Add accessors for the encryption field, and update all the checks for
file extents.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h                | 2 ++
 fs/btrfs/file.c                 | 4 ++--
 fs/btrfs/inode.c                | 9 +++++++--
 fs/btrfs/reflink.c              | 1 +
 fs/btrfs/tree-log.c             | 2 +-
 include/uapi/linux/btrfs_tree.h | 5 +++++
 6 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f2d2b313bde5..b1afcfc62f75 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -364,6 +364,8 @@ struct btrfs_replace_extent_info {
 	u64 file_offset;
 	/* Pointer to a file extent item of type regular or prealloc. */
 	char *extent_buf;
+	/* The length of @extent_buf */
+	u32 extent_buf_size;
 	/*
 	 * Set to true when attempting to replace a file range with a new extent
 	 * described by this structure, set to false when attempting to clone an
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 73038908876a..4988c9317234 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2246,14 +2246,14 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = extent_info->file_offset;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
-				      sizeof(struct btrfs_file_extent_item));
+				      extent_info->extent_buf_size);
 	if (ret)
 		return ret;
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 	write_extent_buffer(leaf, extent_info->extent_buf,
 			    btrfs_item_ptr_offset(leaf, slot),
-			    sizeof(struct btrfs_file_extent_item));
+			    extent_info->extent_buf_size);
 	extent = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 	ASSERT(btrfs_file_extent_type(leaf, extent) != BTRFS_FILE_EXTENT_INLINE);
 	btrfs_set_file_extent_offset(leaf, extent, extent_info->data_offset);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f68d74dec5ed..83098779dad2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3036,6 +3036,9 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
+	size_t fscrypt_context_size =
+		btrfs_stack_file_extent_encryption(stack_fi) ?
+			FSCRYPT_SET_CONTEXT_MAX_SIZE : 0;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -3055,7 +3058,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	drop_args.start = file_pos;
 	drop_args.end = file_pos + num_bytes;
 	drop_args.replace_extent = true;
-	drop_args.extent_item_size = sizeof(*stack_fi);
+	drop_args.extent_item_size = sizeof(*stack_fi) + fscrypt_context_size;
 	ret = btrfs_drop_extents(trans, root, inode, &drop_args);
 	if (ret)
 		goto out;
@@ -3066,7 +3069,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_DATA_KEY;
 
 		ret = btrfs_insert_empty_item(trans, root, path, &ins,
-					      sizeof(*stack_fi));
+					      sizeof(*stack_fi) + fscrypt_context_size);
 		if (ret)
 			goto out;
 	}
@@ -9770,6 +9773,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	u64 len = ins->offset;
 	int qgroup_released;
 	int ret;
+	size_t fscrypt_context_size = 0;
 
 	memset(&stack_fi, 0, sizeof(stack_fi));
 
@@ -9802,6 +9806,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.data_len = len;
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
+	extent_info.extent_buf_size = sizeof(stack_fi) + fscrypt_context_size;
 	extent_info.is_new_extent = true;
 	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index ad722f495c9b..9f3b5748f39b 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -502,6 +502,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.data_len = datal;
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
+			clone_info.extent_buf_size = size;
 			clone_info.is_new_extent = false;
 			clone_info.update_times = !no_time_update;
 			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index a49a05cfbac4..82c91097672b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4689,7 +4689,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		key.offset = em->start;
 
 		ret = btrfs_insert_empty_item(trans, log, path, &key,
-					      sizeof(fi));
+					      sizeof(fi) + fscrypt_context_size);
 		if (ret)
 			return ret;
 	}
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 029af0aeb65d..ea4903cfd926 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1048,6 +1048,11 @@ struct btrfs_file_extent_item {
 	 * but not for stat.
 	 */
 	__u8 compression;
+
+	/*
+	 * 2 bits of encryption type in the lower bits, 6 bits of context size
+	 * in the upper bits. Unencrypted value is 0.
+	 */
 	__u8 encryption;
 	__le16 other_encoding; /* spare for later use */
 
-- 
2.40.1

