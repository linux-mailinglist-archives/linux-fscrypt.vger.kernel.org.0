Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFE9755A4F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjGQDx1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjGQDxP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:15 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63083E46;
        Sun, 16 Jul 2023 20:53:14 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CC61583411;
        Sun, 16 Jul 2023 23:53:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565994; bh=q16hcLWVJw+1tsfWHxGPh6TESNmX9WqnBbV+YzCr7FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W64Nwt8o9c/+8s1jiaPiJXUkC3XsSZf78ZBLn3h8hGQT9i3BNNFOAzBQ7csR0NF80
         YygDKFLvYPBC/wXk6lZnqJVO5gJx16OLAvWioe6WekDQKTokaFcl030Ge2jSSCtnTf
         olgFjeiWzl22cPkii4CrrOENKV9FyLQM5AxGGR7ALFrXqiaMzZcwrNSy2O1E7pfoGn
         9FaZbB8KwDfXFSCiaiGwo54bRThrhgFmy40p7uv0LYxEKWguXxSdsxoJR0ieNsb+1Y
         QyqDSceayX44XGwFLGCuG4eQnDb0n8XA1HgJy7pmK8N4diYTFAXc0G++P65S0yFWiA
         rW60xdN5GLVyA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 14/17] btrfs: create and free extent fscrypt_infos
Date:   Sun, 16 Jul 2023 23:52:45 -0400
Message-Id: <fe6e2a2a1fb1c7e3942c83a496aed1694ccb5b44.1689564024.git.sweettea-kernel@dorminy.me>
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

Each extent_map will end up with a pointer to its associated
fscrypt_info if any, which should have the same lifetime as the
extent_map. Add creation of fscrypt_infos for new extent_maps, and
freeing as appropriate.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/extent_map.c | 8 ++++++++
 fs/btrfs/extent_map.h | 3 +++
 fs/btrfs/inode.c      | 8 ++++++++
 3 files changed, 19 insertions(+)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 0cdb3e86f29b..4fa5f97559da 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -65,6 +65,8 @@ void free_extent_map(struct extent_map *em)
 	if (!em)
 		return;
 	if (refcount_dec_and_test(&em->refs)) {
+		if (em->fscrypt_info)
+			fscrypt_free_extent_info(&em->fscrypt_info);
 		WARN_ON(extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
 		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
@@ -207,6 +209,12 @@ static int mergable_maps(struct extent_map *prev, struct extent_map *next)
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
 
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 35d27c756e08..3a1b66b1cedf 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -27,6 +27,8 @@ enum {
 	EXTENT_FLAG_FS_MAPPING,
 	/* This em is merged from two or more physically adjacent ems */
 	EXTENT_FLAG_MERGED,
+	/* This em has a fscrypt info */
+	EXTENT_FLAG_ENCRYPTED,
 };
 
 struct extent_map {
@@ -50,6 +52,7 @@ struct extent_map {
 	 */
 	u64 generation;
 	unsigned long flags;
+	struct fscrypt_info *fscrypt_info;
 	/* Used for chunk mappings, flag EXTENT_FLAG_FS_MAPPING must be set */
 	struct map_lookup *map_lookup;
 	refcount_t refs;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40c2ec328730..b43fc253ecd1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7460,6 +7460,14 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		em->compress_type = compress_type;
 	}
 
+	ret = fscrypt_prepare_new_extent(&inode->vfs_inode, &em->fscrypt_info);
+	if (ret < 0) {
+		free_extent_map(em);
+		return ERR_PTR(ret);
+	}
+	if (em->fscrypt_info)
+		set_bit(EXTENT_FLAG_ENCRYPTED, &em->flags);
+
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
 		free_extent_map(em);
-- 
2.40.1

