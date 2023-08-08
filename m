Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2964D7743CC
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbjHHSKg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjHHSKB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:10:01 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFC71B07C;
        Tue,  8 Aug 2023 10:12:46 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9AE1683446;
        Tue,  8 Aug 2023 13:12:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514765; bh=NBpxKgk+H4/khOgT6Ol7/oaU5ORwleA192wOniXULdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdhP+lmb3YZt2exXt69KR5DsJO3jSjNxzcr7WZmMT4UEncVS4goV1dWrepzc2JlTR
         Y/6xv09RdaCvB4EnkY8FqmtadjuGZoq4MQfQ1Ann+1Drqx6J6wSKh/SM/quXVv7YNo
         O4D6IXllYtdxVGqJ1dbOEJ1PvN2NXV86eNi0UATf1v0MoR1PCpZ1xBR72ZLXN7+G1W
         Iwll27ZyRkA1u1+Wg9Rq3X5Dws9aJQNDwCKYBAvzgiYbovduws9D7n5rZVDLSCcq80
         cv2OgBVDUd72sVlHaYWYWgeO6nZpLsO0LT93yusS/WBwVbg8fcfm1JNlFKhS0GVhbn
         4YJhV/WHaiDPg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 14/17] btrfs: create and free extent fscrypt_infos
Date:   Tue,  8 Aug 2023 13:12:16 -0400
Message-ID: <13fd27bd85084a74b09c46b82d42210d5b9f84ff.1691510179.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691510179.git.sweettea-kernel@dorminy.me>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Each extent_map will end up with a pointer to its associated
fscrypt_info if any, which should have the same lifetime as the
extent_map. Add creation of fscrypt_infos for new extent_maps, and
freeing as appropriate.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/extent_map.c | 18 ++++++++++++++++++
 fs/btrfs/extent_map.h |  1 +
 fs/btrfs/fscrypt.c    | 13 +++++++++++++
 fs/btrfs/fscrypt.h    |  4 ++++
 fs/btrfs/inode.c      |  6 ++++++
 5 files changed, 42 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 0cdb3e86f29b..cb4b7517b253 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -9,6 +9,7 @@
 #include "extent_map.h"
 #include "compression.h"
 #include "btrfs_inode.h"
+#include "fscrypt.h"
 
 
 static struct kmem_cache *extent_map_cache;
@@ -65,6 +66,8 @@ void free_extent_map(struct extent_map *em)
 	if (!em)
 		return;
 	if (refcount_dec_and_test(&em->refs)) {
+		if (em->fscrypt_info)
+			fscrypt_free_extent_info(&em->fscrypt_info);
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
@@ -207,6 +210,12 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
 	if (!list_empty(&prev->list) || !list_empty(&next->list))
 		return 0;
 
+	/*
+	 * Don't merge adjacent encrypted maps.
+	 */
+	if (prev->fscrypt_info || next->fscrypt_info)
+		return 0;
+
 	ASSERT(next->block_start != EXTENT_MAP_DELALLOC &&
 	       prev->block_start != EXTENT_MAP_DELALLOC);
 
@@ -817,6 +826,8 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			split->generation = gen;
 			split->flags = flags;
 			split->compress_type = em->compress_type;
+			btrfs_fscrypt_copy_fscrypt_info(inode, em->fscrypt_info,
+							&split->fscrypt_info);
 			replace_extent_mapping(em_tree, em, split, modified);
 			free_extent_map(split);
 			split = split2;
@@ -858,6 +869,8 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 				split->orig_block_len = 0;
 			}
 
+			btrfs_fscrypt_copy_fscrypt_info(inode, em->fscrypt_info,
+							&split->fscrypt_info);
 			if (extent_map_in_tree(em)) {
 				replace_extent_mapping(em_tree, em, split,
 						       modified);
@@ -1019,6 +1032,8 @@ int split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pre,
 	split_pre->flags = flags;
 	split_pre->compress_type = em->compress_type;
 	split_pre->generation = em->generation;
+	btrfs_fscrypt_copy_fscrypt_info(inode, em->fscrypt_info,
+					&split_pre->fscrypt_info);
 
 	replace_extent_mapping(em_tree, em, split_pre, 1);
 
@@ -1038,6 +1053,9 @@ int split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pre,
 	split_mid->flags = flags;
 	split_mid->compress_type = em->compress_type;
 	split_mid->generation = em->generation;
+	btrfs_fscrypt_copy_fscrypt_info(inode, em->fscrypt_info,
+					&split_mid->fscrypt_info);
+
 	add_extent_mapping(em_tree, split_mid, 1);
 
 	/* Once for us */
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 35d27c756e08..3ffb74412d31 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -50,6 +50,7 @@ struct extent_map {
 	 */
 	u64 generation;
 	unsigned long flags;
+	struct fscrypt_info *fscrypt_info;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
 	struct map_lookup *map_lookup;
 	refcount_t refs;
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 499073376110..5508cbc6bccb 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -215,6 +215,19 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
 	return devs;
 }
 
+void btrfs_fscrypt_copy_fscrypt_info(struct btrfs_inode *inode,
+				     struct fscrypt_info *from,
+				     struct fscrypt_info **to_ptr)
+{
+	if (from == NULL) {
+		*to_ptr = NULL;
+		return;
+	}
+
+	fscrypt_get_extent_info_ref(from);
+	*to_ptr = from;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index c08fd52c99b4..a489bb54b3b1 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -37,6 +37,10 @@ static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 }
 #endif /* CONFIG_FS_ENCRYPTION */
 
+void btrfs_fscrypt_copy_fscrypt_info(struct btrfs_inode *inode,
+				     struct fscrypt_info *from,
+				     struct fscrypt_info **to_ptr);
+
 extern const struct fscrypt_operations btrfs_fscrypt_ops;
 
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 053c7170ce6e..7726957284c1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7319,6 +7319,12 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		em->compress_type = compress_type;
 	}
 
+	ret = fscrypt_prepare_new_extent(&inode->vfs_inode, &em->fscrypt_info);
+	if (ret < 0) {
+		free_extent_map(em);
+		return ERR_PTR(ret);
+	}
+
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
 		free_extent_map(em);
-- 
2.41.0

