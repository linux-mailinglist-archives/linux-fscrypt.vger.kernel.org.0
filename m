Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8D7741D38
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjF2AgT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjF2AgM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:12 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68B22728;
        Wed, 28 Jun 2023 17:36:10 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 493508030E;
        Wed, 28 Jun 2023 20:36:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998970; bh=LjgdUVTk/4TKiQb+LcDMUjcZ2Mh194QHEhld30f2HwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No85yExNB0NsQcpl+RXoZk6nbfdmP2sWVrxSlP8DU0Gp6W6mW1LdI0Ob/0+jiP3Ty
         LMIl6newWOPyNo1Qwmkr6dsA4y8+J2NCq1Hb8cNvY2vrVHL3z/bK+rAQqMb40tInGk
         G89RcFBJRA6Ohz9vGDwwsfRGhID1cp1aOxu2eYem2N8KXMsEvKva3TtvDVWddX3dqY
         pvW8/2ZNxnrUEI/vi5j/ftQHtrBF1orBK+tjOiskOay2c1x2B8NsYywWgdo1K6MJqp
         ndOGjI0rXbZQ2g1U9dEA6sF+IyOeRuXEVKffuK+G+qnhnqaxpjPQ02kV9s6D/fi1RB
         KHu9eC94qeqXA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 15/17] btrfs: start tracking extent encryption context info
Date:   Wed, 28 Jun 2023 20:35:38 -0400
Message-Id: <e2de16a346dfa9ccf5964fb4cf740a81c21e8a77.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This puts the long-preserved 1-byte encryption field to work, storing
whether the extent is encrypted and the length of its fscrypt_context.
Since there is no way for a btrfs inode to be encrypted right now, we
set context length to be 0 in all locations. We then update all the
locations which check the size of an extent item to expect the size to
agree with the context length.

The 1-byte field packs the encryption type and context length together,
to avoid a format change. Right now we don't anticipate very many
encryption policies, so 2 bits should be ample; similarly right now we
can't imagine a context larger than fscrypt's current contexts, which
are 40 bytes, so 6 bits is ample to store the context's size; and
therefore we can pack these together into the one-byte encryption field
without touching other space reserved for future use.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/accessors.h    | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/file-item.c    |  8 ++++++++
 fs/btrfs/fscrypt.h      | 24 ++++++++++++++++++++++++
 fs/btrfs/inode.c        | 26 ++++++++++++++++++++++----
 fs/btrfs/tree-checker.c | 37 +++++++++++++++++++++++++++++--------
 fs/btrfs/tree-log.c     |  3 +++
 6 files changed, 117 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index ceadfc5d6c66..fbee45b9d9c2 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -3,6 +3,8 @@
 #ifndef BTRFS_ACCESSORS_H
 #define BTRFS_ACCESSORS_H
 
+#include "fscrypt.h"
+
 struct btrfs_map_token {
 	struct extent_buffer *eb;
 	char *kaddr;
@@ -936,6 +938,16 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
 			 struct btrfs_file_extent_item, disk_num_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
 			 struct btrfs_file_extent_item, compression, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_encryption,
+			 struct btrfs_file_extent_item, encryption, 8);
+static inline u8 btrfs_stack_file_extent_encryption_ctxsize(
+	struct btrfs_file_extent_item *e)
+{
+	u8 ctxsize;
+
+	btrfs_unpack_encryption(e->encryption, NULL, &ctxsize);
+	return ctxsize;
+}
 
 
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
@@ -958,6 +970,25 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+static inline u8
+btrfs_file_extent_encryption_ctxsize(const struct extent_buffer *eb,
+				     struct btrfs_file_extent_item *e)
+{
+	u8 ctxsize;
+
+	btrfs_unpack_encryption(btrfs_file_extent_encryption(eb, e),
+				NULL, &ctxsize);
+	return ctxsize;
+}
+
+static inline u8
+btrfs_file_extent_ctxsize_from_item(const struct extent_buffer *leaf,
+				    const struct btrfs_path *path)
+{
+	return (btrfs_item_size(leaf, path->slots[0]) -
+		sizeof(struct btrfs_file_extent_item));
+}
+
 /* btrfs_qgroup_status_item */
 BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
 		   generation, 64);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 696bf695d8eb..8095fc2e7ca1 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1272,6 +1272,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 	em->generation = btrfs_file_extent_generation(leaf, fi);
 	if (type == BTRFS_FILE_EXTENT_REG ||
 	    type == BTRFS_FILE_EXTENT_PREALLOC) {
+		u8 ctxsize;
 		em->start = extent_start;
 		em->len = extent_end - extent_start;
 		em->orig_start = extent_start -
@@ -1287,6 +1288,10 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			em->compress_type = compress_type;
 			em->block_start = bytenr;
 			em->block_len = em->orig_block_len;
+		} else if (btrfs_file_extent_encryption(leaf, fi)) {
+			set_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);
+			em->block_start = bytenr;
+			em->block_len = em->orig_block_len;
 		} else {
 			bytenr += btrfs_file_extent_offset(leaf, fi);
 			em->block_start = bytenr;
@@ -1294,6 +1299,9 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			if (type == BTRFS_FILE_EXTENT_PREALLOC)
 				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		}
+
+		ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
+		ASSERT(ctxsize == btrfs_file_extent_encryption_ctxsize(leaf, fi));
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 1647bbbcd609..2d405d54cbc7 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -8,6 +8,30 @@
 
 #include "fs.h"
 
+#define BTRFS_ENCRYPTION_POLICY_BITS 2
+#define BTRFS_ENCRYPTION_CTXSIZE_BITS 6
+
+#define BTRFS_ENCRYPTION_POLICY_MASK ((1 << BTRFS_ENCRYPTION_POLICY_BITS) - 1)
+#define BTRFS_ENCRYPTION_CTXSIZE_MASK \
+	(((1 << BTRFS_ENCRYPTION_CTXSIZE_BITS) - 1) << \
+		BTRFS_ENCRYPTION_POLICY_BITS)
+
+static inline void btrfs_unpack_encryption(u8 encryption,
+					   u8 *policy,
+					   u8 *ctxsize)
+{
+	if (policy)
+		*policy = encryption & BTRFS_ENCRYPTION_POLICY_MASK;
+	if (ctxsize)
+		*ctxsize = ((encryption & BTRFS_ENCRYPTION_CTXSIZE_MASK) >>
+			    BTRFS_ENCRYPTION_POLICY_BITS);
+}
+
+static inline u8 btrfs_pack_encryption(u8 policy, u8 ctxsize)
+{
+	return policy | (ctxsize << BTRFS_ENCRYPTION_POLICY_BITS);
+}
+
 #ifdef CONFIG_FS_ENCRYPTION
 bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 72da8f5e32af..931f948b42f7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3151,7 +3151,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, ram_bytes);
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
-	/* Encryption and other encoding is reserved and all 0 */
+	/* Other encoding is reserved and always 0 */
 
 	/*
 	 * For delalloc, when completing an ordered extent we update the inode's
@@ -7046,8 +7046,24 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 
 	btrfs_extent_item_to_extent_map(inode, path, item, em);
 
-	if (extent_type == BTRFS_FILE_EXTENT_REG ||
-	    extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
+	if (extent_type == BTRFS_FILE_EXTENT_REG) {
+		u8 item_ctxsize = btrfs_file_extent_ctxsize_from_item(leaf, path);
+		u8 encryption = btrfs_file_extent_encryption(leaf, item);
+		u8 policy, ctxsize;
+
+		btrfs_unpack_encryption(encryption, &policy, &ctxsize);
+
+		if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+			if (ctxsize != item_ctxsize) {
+				btrfs_crit(fs_info,
+					"invalid encryption context size for inode %llu: itemsize %d item %d",
+					btrfs_ino(inode), ctxsize, item_ctxsize);
+				ret = -EUCLEAN;
+				goto out;
+			}
+		}
+		goto insert;
+	} else if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		goto insert;
 	} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 		/*
@@ -9739,7 +9755,9 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_compression(&stack_fi, BTRFS_COMPRESS_NONE);
-	/* Encryption and other encoding is reserved and all 0 */
+	btrfs_set_stack_file_extent_encryption(&stack_fi,
+					       BTRFS_ENCRYPTION_NONE);
+	/* Other encoding is reserved and always 0 */
 
 	qgroup_released = btrfs_qgroup_release_data(inode, file_offset, len);
 	if (qgroup_released < 0)
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 351ba9e90675..c1244fd60d3f 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -208,6 +208,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
+	u8 policy;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -259,10 +260,12 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 			BTRFS_NR_COMPRESS_TYPES - 1);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_encryption(leaf, fi))) {
+	btrfs_unpack_encryption(btrfs_file_extent_encryption(leaf, fi),
+				&policy, NULL);
+	if (unlikely(policy >= BTRFS_NR_ENCRYPTION_TYPES)) {
 		file_extent_err(leaf, slot,
-			"invalid encryption for file extent, have %u expect 0",
-			btrfs_file_extent_encryption(leaf, fi));
+			"invalid encryption for file extent, have %u expect range [0, %u]",
+			policy, BTRFS_NR_ENCRYPTION_TYPES - 1);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
@@ -291,12 +294,30 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
-	/* Regular or preallocated extent has fixed item size */
-	if (unlikely(item_size != sizeof(*fi))) {
-		file_extent_err(leaf, slot,
+	if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+		u8 ctxsize = btrfs_file_extent_encryption_ctxsize(leaf, fi);
+
+		if (unlikely(item_size != sizeof(*fi) + ctxsize)) {
+			file_extent_err(leaf, slot,
+	"invalid item size for encrypted file extent, have %u expect = %zu + context of size %u",
+					item_size, sizeof(*fi), ctxsize);
+			return -EUCLEAN;
+		}
+		/* Only regular extents should be encrypted. */
+		if (btrfs_file_extent_type(leaf, fi) != BTRFS_FILE_EXTENT_REG) {
+			file_extent_err(leaf, slot,
+		"invalid type for encrypted file extent, have %u expect %u",
+					btrfs_file_extent_type(leaf, fi),
+					BTRFS_FILE_EXTENT_REG);
+			return -EUCLEAN;
+		}
+	} else {
+		if (unlikely(item_size != sizeof(*fi))) {
+			file_extent_err(leaf, slot,
 	"invalid item size for reg/prealloc file extent, have %u expect %zu",
-			item_size, sizeof(*fi));
-		return -EUCLEAN;
+					item_size, sizeof(*fi));
+			return -EUCLEAN;
+		}
 	}
 	if (unlikely(CHECK_FE_ALIGNED(leaf, slot, fi, ram_bytes, sectorsize) ||
 		     CHECK_FE_ALIGNED(leaf, slot, fi, disk_bytenr, sectorsize) ||
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f32f961adc7b..5a636a6b0d82 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4634,6 +4634,8 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
+	u8 encryption = btrfs_pack_encryption(IS_ENCRYPTED(&inode->vfs_inode) ?
+					      BTRFS_ENCRYPTION_FSCRYPT : 0, 0);
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
@@ -4655,6 +4657,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&fi, em->len);
 	btrfs_set_stack_file_extent_ram_bytes(&fi, em->ram_bytes);
 	btrfs_set_stack_file_extent_compression(&fi, em->compress_type);
+	btrfs_set_stack_file_extent_encryption(&fi, encryption);
 
 	ret = log_extent_csums(trans, inode, log, em, ctx);
 	if (ret)
-- 
2.40.1

