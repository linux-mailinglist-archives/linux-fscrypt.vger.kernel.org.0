Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C7C7AF24C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbjIZSDb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbjIZSDa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:30 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0D6BF
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:22 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id ada2fe7eead31-4527ba546d2so3497715137.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751401; x=1696356201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j7RxghLOy6rRzt/rT5VjJx2/IyUKbya008SIuzU+uYo=;
        b=CuYshcPBSXpK5R1JB+o/iIZ4/jRwFxtl40XVuYcPZb4qrZL9KAEH+lnVLNtWRO7Nni
         jNh/Szt4xKNOQWk/iVhhNVIxb2sFAVF54R0tCe4di77unYFPzkuxRgnkgBfnUlj/RJYd
         duFUSHIbYsQbnJeqhrneOWnPoCfuE6IYb+1Y7sg0ogpvve3DbxzflxOUpfLrbBTjTnak
         Yb7rfDt2f9cPkyZLc8q0rXnWndqex4q8sLrF6KhqY4a9HAChgeD0PFrPr4y4FciyH8xK
         C2O9wWr41vS/SK9nZEvszGIH1UnhxXZLBYqyQVG8ZWmqeFac/0mlUupT1bSNirEMCONL
         y0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751401; x=1696356201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7RxghLOy6rRzt/rT5VjJx2/IyUKbya008SIuzU+uYo=;
        b=kkBdhUKH/Hj0ZKg4jF0bBbTJWyGIwWyr8WuZa58pRSkfT+XJ0m09i5WGusWQt0GMpl
         RQUhfpg0e7fkyoALDJ76NubMcyqaM4YDbhOdlEakG74lv07GCtMpN3IBMg6GOTlAgwh5
         PnL4PwoKFgZL/fqgI/uTHZdYmHF5zYwRRaznEaf+ZIxIih5QNbPzpVmP5C9tbjqIaeSl
         6LcQHaJ+wTQqYYC9zTzw0UPUrvnHZvZlMKzkX7UCUALHu2sA4FH4/isp+oX3Xe4EEveO
         wXOi6doexzjumdai7RNpEuDDD71eYS23t9G9XftMtFxBnnd0ZezoDv+S23qTeH2eEtxS
         RI6g==
X-Gm-Message-State: AOJu0YztwpcikMNDqJaPEfPSQDcYWmk1jg4/WM6UG3mKDurQ9/ruqdYk
        i0n1woFUFMBgFQHQVT+mCry58A==
X-Google-Smtp-Source: AGHT+IEBUCwZa7YczuFBjeuEPic4b/05oZxUfyX0O2eDASOgnNpTTjxcVN8P864sB1nKF9d3IokTOg==
X-Received: by 2002:a67:fa10:0:b0:44d:5435:a3e with SMTP id i16-20020a67fa10000000b0044d54350a3emr6242999vsq.9.1695751401502;
        Tue, 26 Sep 2023 11:03:21 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id t6-20020a0cde06000000b0065b2167fd63sm1111707qvk.65.2023.09.26.11.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:21 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 07/35] btrfs: add infrastructure for safe em freeing
Date:   Tue, 26 Sep 2023 14:01:33 -0400
Message-ID: <e6b3d2767e1ca79224d00e275e9d34ebc6ffcb8f.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
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

When we add fscrypt support we're going to have fscrypt objects hanging
off of extent_maps.  This includes a block key, which if we're the last
one freeing the key we may have to unregister it from the block layer.
This requires taking a semaphore in the block layer, which means we
can't free em's under the extent map tree lock.

Thankfully we only do this in two places, one where we're dropping a
range of extent maps, and when we're freeing logged extents.  Add a
free_extent_map_safe() which will add the em to a list in the em_tree if
we free'd the object.  Currently this is unconditional but will be
changed to conditional on the fscrypt object we will add in a later
patch.

To process these delayed objects add a free_pending_extent_maps() that
is called after the lock has been dropped on the em_tree.  This will
process the extent maps on the freed list and do the appropriate freeing
work in a safe manner.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_map.c | 80 ++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/extent_map.h | 10 ++++++
 fs/btrfs/tree-log.c   |  6 ++--
 3 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index a6d8368ed0ed..af5ff6b10865 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -35,7 +35,9 @@ void __cold extent_map_exit(void)
 void extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->map = RB_ROOT_CACHED;
+	tree->flags = 0;
 	INIT_LIST_HEAD(&tree->modified_extents);
+	INIT_LIST_HEAD(&tree->freed_extents);
 	rwlock_init(&tree->lock);
 }
 
@@ -53,9 +55,17 @@ struct extent_map *alloc_extent_map(void)
 	em->compress_type = BTRFS_COMPRESS_NONE;
 	refcount_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
+	INIT_LIST_HEAD(&em->free_list);
 	return em;
 }
 
+static void __free_extent_map(struct extent_map *em)
+{
+	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
+		kfree(em->map_lookup);
+	kmem_cache_free(extent_map_cache, em);
+}
+
 /*
  * Drop the reference out on @em by one and free the structure if the reference
  * count hits zero.
@@ -67,12 +77,69 @@ void free_extent_map(struct extent_map *em)
 	if (refcount_dec_and_test(&em->refs)) {
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
-		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
-			kfree(em->map_lookup);
-		kmem_cache_free(extent_map_cache, em);
+		__free_extent_map(em);
 	}
 }
 
+/*
+ * Drop a ref for the extent map in the given tree.
+ *
+ * @tree:	tree that the em is a part of.
+ * @em:		the em to drop the reference to.
+ *
+ * Drop the reference count on @em by one, if the reference count hits 0 and
+ * there is an object on the em that can't be safely freed in the current
+ * context (if we are holding the extent_map_tree->lock for example), then add
+ * it to the freed_extents list on the extent_map_tree for later processing.
+ *
+ * This must be followed by a free_pending_extent_maps() to clear the pending
+ * frees.
+ */
+void free_extent_map_safe(struct extent_map_tree *tree,
+			  struct extent_map *em)
+{
+	lockdep_assert_held_write(&tree->lock);
+
+	if (!em)
+		return;
+
+	if (refcount_dec_and_test(&em->refs)) {
+		WARN_ON(extent_map_in_tree(em));
+		WARN_ON(!list_empty(&em->list));
+		list_add_tail(&em->free_list, &tree->freed_extents);
+		set_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags);
+	}
+}
+
+/*
+ * Free the em objects that exist on the em tree
+ *
+ * @tree:	the tree to free the objects from.
+ *
+ * If there are any objects on the em->freed_extents list go ahead and free them
+ * here in a safe way.  This is to be coupled with any uses of
+ * free_extent_map_safe().
+ */
+void free_pending_extent_maps(struct extent_map_tree *tree)
+{
+	struct extent_map *em;
+
+	/* Avoid taking the write lock if we don't have any pending frees. */
+	if (!test_and_clear_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags))
+		return;
+
+	write_lock(&tree->lock);
+	while ((em = list_first_entry_or_null(&tree->freed_extents,
+					      struct extent_map, free_list))) {
+		list_del_init(&em->free_list);
+		write_unlock(&tree->lock);
+		__free_extent_map(em);
+		cond_resched();
+		write_lock(&tree->lock);
+	}
+	write_unlock(&tree->lock);
+}
+
 /* Do the math around the end of an extent, handling wrapping. */
 static u64 range_end(u64 start, u64 len)
 {
@@ -684,10 +751,12 @@ static void drop_all_extent_maps_fast(struct extent_map_tree *tree)
 		clear_bit(EXTENT_FLAG_PINNED, &em->flags);
 		clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
 		remove_extent_mapping(tree, em);
-		free_extent_map(em);
+		free_extent_map_safe(tree, em);
 		cond_resched_rwlock_write(&tree->lock);
 	}
 	write_unlock(&tree->lock);
+
+	free_pending_extent_maps(tree);
 }
 
 /*
@@ -908,13 +977,14 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 		free_extent_map(em);
 next:
 		/* Once for us (for our lookup reference). */
-		free_extent_map(em);
+		free_extent_map_safe(em_tree, em);
 
 		em = next_em;
 	}
 
 	write_unlock(&em_tree->lock);
 
+	free_pending_extent_maps(em_tree);
 	free_extent_map(split);
 	free_extent_map(split2);
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 35d27c756e08..2093720271ea 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -55,11 +55,18 @@ struct extent_map {
 	refcount_t refs;
 	unsigned int compress_type;
 	struct list_head list;
+	struct list_head free_list;
+};
+
+enum extent_map_flags {
+	EXTENT_MAP_TREE_PENDING_FREES,
 };
 
 struct extent_map_tree {
 	struct rb_root_cached map;
+	unsigned long flags;
 	struct list_head modified_extents;
+	struct list_head freed_extents;
 	rwlock_t lock;
 };
 
@@ -95,6 +102,9 @@ int split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pre,
 
 struct extent_map *alloc_extent_map(void);
 void free_extent_map(struct extent_map *em);
+void free_extent_map_safe(struct extent_map_tree *tree,
+			  struct extent_map *em);
+void free_pending_extent_maps(struct extent_map_tree *tree);
 int __init extent_map_init(void);
 void __cold extent_map_exit(void);
 int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len, u64 gen);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6b98e0dbc0a4..c4d8900f91bb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4886,7 +4886,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		 */
 		if (ret) {
 			clear_em_logging(tree, em);
-			free_extent_map(em);
+			free_extent_map_safe(tree, em);
 			continue;
 		}
 
@@ -4895,11 +4895,13 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		ret = log_one_extent(trans, inode, em, path, ctx);
 		write_lock(&tree->lock);
 		clear_em_logging(tree, em);
-		free_extent_map(em);
+		free_extent_map_safe(tree, em);
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
 
+	free_pending_extent_maps(tree);
+
 	if (!ret)
 		ret = btrfs_log_prealloc_extents(trans, inode, path);
 	if (ret)
-- 
2.41.0

