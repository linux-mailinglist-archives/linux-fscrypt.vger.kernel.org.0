Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E551B7AF221
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbjIZSDp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbjIZSDo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:44 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E095124
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:37 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5a1f00b75aaso5282997b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751416; x=1696356216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrbBTlq6SUEE2oe2Hsm17SMa27dUAmVsqmKO5cSW0nI=;
        b=cVcekEtcu3osW0EkmlVnfIsJerVPkJv+q2CryBeQ7Yz332XpViXCIzV2jVq2pRWqUR
         Db5rPhLWmg5Lg3+ncYZW0zThEbsBbvcsGLVYLtLwQnkmFecjTLKXO2Laj8Oa8o5WU9FR
         UNXrXltINjcPpWhSl3UNP9KhmJvy24fWAAKJ8fKApzV1blrAd4gvrsErDvj4DNcoHWml
         wQjfxwPRzdE+v7wIQwOQ9yPdEMJ0cSHyoh7U+N5mGVbPx0mLH48hBnspJaYt4wXaVd5O
         VZtHogCDwYbq3LRmJ8ZYQkYxPapWcy40KgxWAVDjSypv84LHRDXTpG6CmWyRVpAAr5pK
         3MhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751416; x=1696356216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XrbBTlq6SUEE2oe2Hsm17SMa27dUAmVsqmKO5cSW0nI=;
        b=aaCAIVuiw/iI8hep70H4mAnN3yInCkvd9IqB2wEze0wovRAy89qkiSCqXDjmLprPuq
         R512pdIiXOevVVDPMNJwr2LY0RPcv1rR2LLZhsdAC40netYBKS03aBKnDuAmPAxeW5JF
         Yp7GZ04leUbJ4CSjGAQ3xyCRWMfXoBxBOVyxgNXvaFXg61VFbjyEa4J+UXIKPhfvcphm
         oYz7ny8eXEljvO/i5cz6/+w0Mah78pFCU9co4zEwa/OzTG8hMWiyPnovAdob3hqbFr1A
         GxRoo5JoXWjBY4PuWHhZEC8riICRoe3AbBRPme8getRYHUVck33d2Ri5Nm0up18zkWbE
         fjJA==
X-Gm-Message-State: AOJu0Yy/NDxPvExldxPn7ApTTzl/gRrv9AjQegrdXcW/ufqtDB1vvsF4
        ufCS8YdOMQ4aSX7gvShTZTcYOA==
X-Google-Smtp-Source: AGHT+IGq4cwIQizmr1i34EBsuDl/BhdizoBqq/+aVOodsyyyccHlPmrF0VYCfaBwxCEGXTo03/8w5A==
X-Received: by 2002:a0d:ff06:0:b0:599:da80:e1e6 with SMTP id p6-20020a0dff06000000b00599da80e1e6mr11433800ywf.34.1695751416085;
        Tue, 26 Sep 2023 11:03:36 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id r16-20020a0ccc10000000b0065b151d5d12sm1732425qvk.126.2023.09.26.11.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:35 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 20/35] btrfs: add fscrypt_info and encryption_type to extent_map
Date:   Tue, 26 Sep 2023 14:01:46 -0400
Message-ID: <b4ba109f1477cc03487e3ef693a0641e5b6e8260.1695750478.git.josef@toxicpanda.com>
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
index db053b392d26..d26062b67211 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7350,6 +7350,7 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		em->compress_type = compress_type;
 	}
+	em->encryption_type = BTRFS_ENCRYPTION_NONE;
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
-- 
2.41.0

