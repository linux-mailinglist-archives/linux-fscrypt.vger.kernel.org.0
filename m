Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6947C4188
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbjJJUlf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbjJJUl3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:29 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA28AF
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:27 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5a7c7262d5eso11150727b3.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970486; x=1697575286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q5MCWk661EZR0yQflHwRp7j11F40Rg/sD7ho8oSo4N0=;
        b=Qgr/udq7+iOfiXo2yHTPfN1kYbHpo62fIE6U7xmjpg573B7ddb6J+QA3nBdvQ2EYJb
         SepmsDJ3XH1RIjJmJLeQwnIRFvsIOLfye8fiCHURJxvOdiiDY9oEibTYBY7i0t4C9TcC
         YZ2MF4hF58Olg1gBOZkjK0kB+MvF5PKJMNfTnvotxFTyKVOezPWsF3QxjKgUKXAo5fV+
         X7I/sWbcFKBUr4aZ7KW9TF4IKceueGnRjJQalokZyX2bj7Z5RUJkwcYxE4EBHxJNEWSr
         M6IdZjAV43Bd0ZslzTmL+1rDgTAoFxXLIFvi8g0k6wiD9Q5S8NsodMi6VGI3d3mF2bY7
         3+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970486; x=1697575286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q5MCWk661EZR0yQflHwRp7j11F40Rg/sD7ho8oSo4N0=;
        b=HWQo1LllgW6K1qnSxqW9/MKAjoO1ee6W0ws8C7wn/kE+Sg5j/jk5yVb1KkCEsldwR1
         dayWfGQMJRsCfhfdWAOTR//u7jiHIJ/GErACia5t35/vHGkY0FkzxTbxu6MN49wbh0yT
         IMX5yGtuLfCOC/SgpULJznosImO0ODrpHt0PvRlo3s7Hce6TVGmxW3rSJu3vgi5FmPcj
         KIUa6aKr7maPbjJx4snSTU7E4XuyJmYzGhQg0YXc9Z5DUiQzOaigCX3DgL7X8FAP2jR2
         UBpy0yYh+Oz3RqL2p7jCIVG8qE9jG/cE06c1SHu+delpz6eRRAvBSzPcMc0IaLSH8x5C
         ftJQ==
X-Gm-Message-State: AOJu0Ywu/IJNrGvageDqe9/FcxDpmU6Gx9H0OrI1gTrGyFD4UWbnAfOO
        qJeivcIUgbCqodoKOnv3utIYoo6LEaXhXms1kNlgyA==
X-Google-Smtp-Source: AGHT+IHGeF/oL94akgLlXxtzH+SovNmE9PJgEqpnpaHqTPMtKnGFsY+2TBxuAcy8OlF653cQwb3M/w==
X-Received: by 2002:a81:5254:0:b0:5a7:c92b:f49 with SMTP id g81-20020a815254000000b005a7c92b0f49mr2149709ywb.21.1696970486493;
        Tue, 10 Oct 2023 13:41:26 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u7-20020a814707000000b005a23fc389d8sm4591665ywa.103.2023.10.10.13.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:26 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 20/36] btrfs: set file extent encryption excplicitly
Date:   Tue, 10 Oct 2023 16:40:35 -0400
Message-ID: <51d5438ae7f0dc2bae5e3126c7e061680aa69ad0.1696970227.git.josef@toxicpanda.com>
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

This puts the long-preserved 1-byte encryption field to work, storing
whether the extent is encrypted.  Update the tree-checker to allow for
the encryption bit to be set to our valid types.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/accessors.h            | 2 ++
 fs/btrfs/inode.c                | 8 ++++++--
 fs/btrfs/tree-checker.c         | 8 +++++---
 fs/btrfs/tree-log.c             | 2 ++
 include/uapi/linux/btrfs_tree.h | 8 +++++++-
 5 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index aa0844535644..5aaf204fa55f 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -949,6 +949,8 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
 			 struct btrfs_file_extent_item, disk_num_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
 			 struct btrfs_file_extent_item, compression, 8);
+BTRFS_SETGET_STACK_FUNCS(stack_file_extent_encryption,
+			 struct btrfs_file_extent_item, encryption, 8);
 
 
 BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e5b52edcb042..9cb8b82ff8be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2992,7 +2992,9 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, ram_bytes);
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
-	/* Encryption and other encoding is reserved and all 0 */
+	btrfs_set_stack_file_extent_encryption(&stack_fi,
+					       BTRFS_ENCRYPTION_NONE);
+	/* Other encoding is reserved and always 0 */
 
 	/*
 	 * For delalloc, when completing an ordered extent we update the inode's
@@ -9640,7 +9642,9 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
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
index a416cbea75d1..825b235927c6 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -210,6 +210,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	u32 sectorsize = fs_info->sectorsize;
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
+	u8 policy;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -261,10 +262,11 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 			BTRFS_NR_COMPRESS_TYPES - 1);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_encryption(leaf, fi))) {
+	policy = btrfs_file_extent_encryption(leaf, fi);
+	if (unlikely(policy >= BTRFS_NR_ENCRYPTION_TYPES)) {
 		file_extent_err(leaf, slot,
-			"invalid encryption for file extent, have %u expect 0",
-			btrfs_file_extent_encryption(leaf, fi));
+			"invalid encryption for file extent, have %u expect range [0, %u]",
+			policy, BTRFS_NR_ENCRYPTION_TYPES - 1);
 		return -EUCLEAN;
 	}
 	if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c1fd4ef2dd8b..404577383513 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4628,6 +4628,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 extent_offset = em->start - em->orig_start;
 	u64 block_len;
 	int ret;
+	u8 encryption = BTRFS_ENCRYPTION_NONE;
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
@@ -4649,6 +4650,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&fi, em->len);
 	btrfs_set_stack_file_extent_ram_bytes(&fi, em->ram_bytes);
 	btrfs_set_stack_file_extent_compression(&fi, em->compress_type);
+	btrfs_set_stack_file_extent_encryption(&fi, encryption);
 
 	ret = log_extent_csums(trans, inode, log, em, ctx);
 	if (ret)
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index ef796a3cf387..e5a4ba9573a0 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1093,8 +1093,14 @@ struct btrfs_file_extent_item {
 	 * but not for stat.
 	 */
 	__u8 compression;
+
+	/*
+	 * Type of encryption in use. Unencrypted value is 0.
+	 */
 	__u8 encryption;
-	__le16 other_encoding; /* spare for later use */
+
+	/* spare for later use */
+	__le16 other_encoding;
 
 	/* are we inline data or a real extent? */
 	__u8 type;
-- 
2.41.0

