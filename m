Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034767C418E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbjJJUll (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343870AbjJJUlb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:31 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CDBB7
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:29 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5a7cc03dee5so10200247b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970488; x=1697575288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EC2BrZuJgY6Pyv2LPz1FwiqkAGFlRQStgxYqSpmtjY=;
        b=KciDVe0BmNdpsSYiITSIC1t46vSHpqOLYnXmQKolLUv8q5hLck0kvE3Ts3v/5NuiRj
         VAAdjB/5byZifwSVkIzO7saBtqtFYi61/1YqNKzI7gci+RpjOQMFarIoE3XVYwr33lJ3
         UeBpIbQFkX9zbKp/MpvZpLX/ko+hnh+vsIef/ImUHArGAblHFeCG6sP5DtAOsEY5/s63
         c8ZPa2i9Q/DjuW3qJNeUHYlQYEtvewG9JKAP+GXxU3JX6Ttjde2Hsu7sv5JJXuBRAsTc
         0uPokunc6sQTQdlDQw305D1dZ2iU+2I6e55l7qX57bFLLFh/J+bwKbl+Gm0FtdSYgx0k
         YgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970488; x=1697575288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1EC2BrZuJgY6Pyv2LPz1FwiqkAGFlRQStgxYqSpmtjY=;
        b=KBuv6KCEOWiTF1p8Zatw458eDNGMKnJBDMr9ihYwjTl6zBeUt80t1hK/gK8XqPVDPl
         g8PCVAntFvEQ3HAnLU8JpQjx87alQqDgpWFykFTCnvcdhfP0Z3WCd0VqpYlNK9OFusfe
         i8SVJFULfCjo9kqzaDKuII6yx3luA3rWufGmTYrXjMh6c6I4e5+z9H8vUUscT+hbn04i
         qZ3K2IYMdishfzBW1Tj5Z85FBxtp89i7eThlv0nNj9+/b0xuQihmjsIvGNlic25pOQ3c
         8x2r5JT+MPDZIU8FFwOsczsoMX7kf/TVOhVFBg4KvmYUwUKBxNtC4kkz+LCBItCjbs6/
         rJtA==
X-Gm-Message-State: AOJu0YwLxHvqjt+yN/Zz7ht1cQe/KI712QLKPTeBWKSQ40MzuFqq4Wg6
        61XSZNu+Hm6Jyprril0/3sgKjq3Gx8VimAvAugy4gA==
X-Google-Smtp-Source: AGHT+IFZBWYMLQeNss3gw/Ul9R7Tza2pWdWzmtSWr0lxioEjdRkFxCn3chbdc9TMwYm6u6KbmN8wTg==
X-Received: by 2002:a0d:d40d:0:b0:5a7:c1f1:24b with SMTP id w13-20020a0dd40d000000b005a7c1f1024bmr3132014ywd.22.1696970488166;
        Tue, 10 Oct 2023 13:41:28 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id fd13-20020a05690c318d00b0058c8b1ddcc1sm1025429ywb.15.2023.10.10.13.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 21/36] btrfs: add fscrypt_info and encryption_type to extent_map
Date:   Tue, 10 Oct 2023 16:40:36 -0400
Message-ID: <4cd0e0a3fee883dde7a1127dc0c602b610687216.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Each extent_map will end up with a pointer to its associated
fscrypt_info if any, which should have the same lifetime as the
extent_map. We are also going to need to track the encryption_type for
the file extent items.  Add the fscrypt_info to the extent_map, and the
subsequent code for transferring it in the split and merge cases, as
well as the code necessary to free them.  A future patch will add the
code to load them as appropriate.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_map.c | 32 +++++++++++++++++++++++++++++---
 fs/btrfs/extent_map.h |  2 ++
 fs/btrfs/file-item.c  |  1 +
 fs/btrfs/inode.c      |  1 +
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index af5ff6b10865..8c8023388758 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -61,6 +61,7 @@ struct extent_map *alloc_extent_map(void)
 
 static void __free_extent_map(struct extent_map *em)
 {
+	fscrypt_put_extent_info(em->fscrypt_info);
 	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
 		kfree(em->map_lookup);
 	kmem_cache_free(extent_map_cache, em);
@@ -103,12 +104,24 @@ void free_extent_map_safe(struct extent_map_tree *tree,
 	if (!em)
 		return;
 
-	if (refcount_dec_and_test(&em->refs)) {
-		WARN_ON(extent_map_in_tree(em));
-		WARN_ON(!list_empty(&em->list));
+	if (!refcount_dec_and_test(&em->refs))
+		return;
+
+	WARN_ON(extent_map_in_tree(em));
+	WARN_ON(!list_empty(&em->list));
+
+	/*
+	 * We could take a lock freeing the fscrypt_info, so add this to the
+	 * list of freed_extents to be freed later.
+	 */
+	if (em->fscrypt_info) {
 		list_add_tail(&em->free_list, &tree->freed_extents);
 		set_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags);
+		return;
 	}
+
+	/* Nothing scary here, just free the object. */
+	__free_extent_map(em);
 }
 
 /*
@@ -274,6 +287,12 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
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
 
@@ -884,6 +903,8 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 			split->generation = gen;
 			split->flags = flags;
 			split->compress_type = em->compress_type;
+			split->fscrypt_info =
+				fscrypt_get_extent_info(em->fscrypt_info);
 			replace_extent_mapping(em_tree, em, split, modified);
 			free_extent_map(split);
 			split = split2;
@@ -925,6 +946,8 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 				split->orig_block_len = 0;
 			}
 
+			split->fscrypt_info =
+				fscrypt_get_extent_info(em->fscrypt_info);
 			if (extent_map_in_tree(em)) {
 				replace_extent_mapping(em_tree, em, split,
 						       modified);
@@ -1087,6 +1110,7 @@ int split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pre,
 	split_pre->flags = flags;
 	split_pre->compress_type = em->compress_type;
 	split_pre->generation = em->generation;
+	split_pre->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
 
 	replace_extent_mapping(em_tree, em, split_pre, 1);
 
@@ -1106,6 +1130,8 @@ int split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pre,
 	split_mid->flags = flags;
 	split_mid->compress_type = em->compress_type;
 	split_mid->generation = em->generation;
+	split_mid->fscrypt_info = fscrypt_get_extent_info(em->fscrypt_info);
+
 	add_extent_mapping(em_tree, split_mid, 1);
 
 	/* Once for us */
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 2093720271ea..2d618e61ceb5 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -50,10 +50,12 @@ struct extent_map {
 	 */
 	u64 generation;
 	unsigned long flags;
+	struct fscrypt_extent_info *fscrypt_info;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
 	struct map_lookup *map_lookup;
 	refcount_t refs;
 	unsigned int compress_type;
+	unsigned int encryption_type;
 	struct list_head list;
 	struct list_head free_list;
 };
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 45cae356e89b..26f35c1baedc 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -1305,6 +1305,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			if (type == BTRFS_FILE_EXTENT_PREALLOC)
 				set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		}
+		em->encryption_type = btrfs_file_extent_encryption(leaf, fi);
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		em->block_start = EXTENT_MAP_INLINE;
 		em->start = extent_start;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9cb8b82ff8be..19087fd68cfe 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7348,6 +7348,7 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		em->compress_type = compress_type;
 	}
+	em->encryption_type = BTRFS_ENCRYPTION_NONE;
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
-- 
2.41.0

