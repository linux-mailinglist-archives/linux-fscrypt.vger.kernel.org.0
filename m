Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45BF7AF24F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbjIZSDw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235501AbjIZSDw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:52 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA332136
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:43 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-65b2463d663so11380586d6.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751423; x=1696356223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwrRby3JuIEpR+SgdzK5LtEWcKJElnROXAnAJyrScoA=;
        b=eqBXkP409BcBlLZz3fFrS4uMew8J9OZ4EkXa6WTTcC2H8sCxc3UAFfJjewUplddroj
         sU/p2lKgS/4EneUlu1qUx12NabQRHRaHldJa4p9aOQ9az2hEHYPa3i/nMmZ5+Qhizi6P
         PFhSmQsrd0/w0KNDQ047BbeMCM1HovsznG2mm4RlcuSmVf7je9+91qvW180BBQZqWxbr
         Pg+GUO3KE4ZSk6xBvg/5Ub3Tq7Ppu1o1ar5pVPfbRfVzg3TLPI+ZnHANncJvue0HB/uw
         cJm8iXIbJIYxcc6RXh1w5Pww5e0Ma7UBLpZsjNj+ksX8CMLGXu7rQE5dmBB93zHMCXPa
         rIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751423; x=1696356223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwrRby3JuIEpR+SgdzK5LtEWcKJElnROXAnAJyrScoA=;
        b=aVvih8Xoob3K48yQJCwZbDtGGh2EW/ll5erU9yv4ctOvQOXSP6Sfb+asdfMr5FeIMU
         u+l/EDD1YcpgL/K3GGh8uicJdG65H8fn61bJteJUv9iPuCxXalarsqH9PSiLpHCWersy
         vo7yEUGFdDKwCLub0ll4Jq8KGANRnmvfTNe4r2vMbhuWr7OcIe/gegjUMIckkbv3Rkyr
         CJjz+139n/1NyhuAKlyh4U/2OTXlz+PuLDYbB8vLuE08IJmWvhHop9IGbFN8Dl7viPTu
         Ly4pHJdst7fDxaQf1+fAUFX9rQhs8zUqGLwEFhl9IRIQ1GYAr7tg36/ck5zaLUIH2XKI
         nDkg==
X-Gm-Message-State: AOJu0Ywav5FlAX3DJs0qvyOJrVR1Qv+sGH0CtmoKjI+Wd8WU6UjVUdBm
        J+KvFGiMgYg4c2h8gObc1Vy9tw==
X-Google-Smtp-Source: AGHT+IFj6ikmk5dC+Oqkr7M9gXs4XiIq6UIM/mXgwpr2f/nYv65aT34BqgU13jj4cpkx2rg3+Jfqzw==
X-Received: by 2002:a0c:f1cd:0:b0:647:406b:4b06 with SMTP id u13-20020a0cf1cd000000b00647406b4b06mr9147405qvl.57.1695751422707;
        Tue, 26 Sep 2023 11:03:42 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id b19-20020a0ccd13000000b00646e0411e8csm2210298qvm.30.2023.09.26.11.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:42 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 26/35] btrfs: explicitly track file extent length for replace and drop
Date:   Tue, 26 Sep 2023 14:01:52 -0400
Message-ID: <37a0e86c3fd7e96ccee4d72e30f2a9dbaff653c4.1695750478.git.josef@toxicpanda.com>
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

With the advent of storing fscrypt contexts with each encrypted extent,
extents will have a variable length depending on encryption status.
Make sure the replace and drop file extent item helpers encode this
information so that everything gets updated properly.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h    | 2 ++
 fs/btrfs/file.c     | 4 ++--
 fs/btrfs/inode.c    | 7 +++++--
 fs/btrfs/reflink.c  | 1 +
 fs/btrfs/tree-log.c | 5 +++--
 5 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2758fbae7e39..5b0cccdab92a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -339,6 +339,8 @@ struct btrfs_replace_extent_info {
 	u64 file_offset;
 	/* Pointer to a file extent item of type regular or prealloc. */
 	char *extent_buf;
+	/* The length of @extent_buf */
+	u32 extent_buf_size;
 	/*
 	 * Set to true when attempting to replace a file range with a new extent
 	 * described by this structure, set to false when attempting to clone an
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8dcc5ae9c9e1..70a801b90d13 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2262,14 +2262,14 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
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
index 89cb09a40f58..6a835967684d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2899,6 +2899,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_stack_file_extent_num_bytes(stack_fi);
 	u64 ram_bytes = btrfs_stack_file_extent_ram_bytes(stack_fi);
 	struct btrfs_drop_extents_args drop_args = { 0 };
+	size_t fscrypt_context_size = 0;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -2918,7 +2919,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	drop_args.start = file_pos;
 	drop_args.end = file_pos + num_bytes;
 	drop_args.replace_extent = true;
-	drop_args.extent_item_size = sizeof(*stack_fi);
+	drop_args.extent_item_size = sizeof(*stack_fi) + fscrypt_context_size;
 	ret = btrfs_drop_extents(trans, root, inode, &drop_args);
 	if (ret)
 		goto out;
@@ -2929,7 +2930,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 		ins.type = BTRFS_EXTENT_DATA_KEY;
 
 		ret = btrfs_insert_empty_item(trans, root, path, &ins,
-					      sizeof(*stack_fi));
+					      sizeof(*stack_fi) + fscrypt_context_size);
 		if (ret)
 			goto out;
 	}
@@ -9671,6 +9672,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	u64 len = ins->offset;
 	int qgroup_released;
 	int ret;
+	size_t fscrypt_context_size = 0;
 
 	memset(&stack_fi, 0, sizeof(stack_fi));
 
@@ -9703,6 +9705,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	extent_info.data_len = len;
 	extent_info.file_offset = file_offset;
 	extent_info.extent_buf = (char *)&stack_fi;
+	extent_info.extent_buf_size = sizeof(stack_fi) + fscrypt_context_size;
 	extent_info.is_new_extent = true;
 	extent_info.update_times = true;
 	extent_info.qgroup_reserved = qgroup_released;
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 3c66630d87ee..f5440ae447a4 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -500,6 +500,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			clone_info.data_len = datal;
 			clone_info.file_offset = new_key.offset;
 			clone_info.extent_buf = buf;
+			clone_info.extent_buf_size = size;
 			clone_info.is_new_extent = false;
 			clone_info.update_times = !no_time_update;
 			ret = btrfs_replace_file_extents(BTRFS_I(inode), path,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f6f45a0f1b1e..d659547c9900 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4630,6 +4630,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
+	size_t fscrypt_context_size = 0;
 	u8 encryption = BTRFS_ENCRYPTION_NONE;
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
@@ -4672,7 +4673,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		drop_args.start = em->start;
 		drop_args.end = em->start + em->len;
 		drop_args.replace_extent = true;
-		drop_args.extent_item_size = sizeof(fi);
+		drop_args.extent_item_size = sizeof(fi) + fscrypt_context_size;
 		ret = btrfs_drop_extents(trans, log, inode, &drop_args);
 		if (ret)
 			return ret;
@@ -4684,7 +4685,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		key.offset = em->start;
 
 		ret = btrfs_insert_empty_item(trans, log, path, &key,
-					      sizeof(fi));
+					      sizeof(fi) + fscrypt_context_size);
 		if (ret)
 			return ret;
 	}
-- 
2.41.0

