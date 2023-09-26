Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334CF7AF24A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbjIZSD6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbjIZSDz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:55 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E48A13A
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:48 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id 71dfb90a1353d-495bcd861ccso3451993e0c.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751427; x=1696356227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ooLPADEkYYZeyiiszR+3TpFJaY39zdcW3+I7UXRUGU0=;
        b=OtKDdWVY+4xIQ8qZBxEVJjQnCmOBJ/9zay1WPUWnMsbgbg3/BkEcZwf4yFXkk7u5r6
         gGeaznGmwudFlC1S7Rl7EInhri17D4KBHTOMJbD4+gBbwmYdgIjFdkfs7r7P69V7s66K
         vc1untpWVTSrRVrc9Eba6ig3krzaqPYeDPUiqvFcOUtljjA4oMBsIgONNGuU2ax+I2Mx
         hcpmd42wTqw59fMH/viNnMH5fymywYMteVU4TbYpuj6LU5tBa0epudGv2WZVVCnjcB8P
         Twp502RyL2PnY0tBBm0w6yp56dysmzBTK2L+ShaiYzBIr4Mv2Oc8pVjSUW56F6PBfu7P
         oYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751427; x=1696356227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ooLPADEkYYZeyiiszR+3TpFJaY39zdcW3+I7UXRUGU0=;
        b=WTr7M0DoBbr2UIgHfrJrpEQCefTFXuK5uCIm9s5SMz+8IKX50LLWX/CkNRpc1Ep0i9
         7fygTo50eEOFgNu9L/QKjhzCcNlDTffW1HnQvtjN7yna19jkMr3gQyGYYE/y783SEUd5
         rPpcSNc+iKDQLcdDWAjxUYBy+uqlFu/lUc8F17510a6dE4aOcN1VOJogY5jj+5vTU+GL
         8WsT6SaE3ui/uImG6cKn2oQVMo2SEAAJPsriOc2iNFCtUaCSRH9vxCYkj8B6xgRsgxyS
         MJNeaZA5Uv5dfcnrkGdyiVB17HFq61EVokb3M8fGKZFKjykb9840dczdFh4IOUyyI64E
         4qDw==
X-Gm-Message-State: AOJu0Yzss3lcJmPsDTpybVAJYAe7AxiBXISetGkCJIRDuU7dDRU1Emvk
        92o8JV1av3+r2f2lxZ8mSSIuwA==
X-Google-Smtp-Source: AGHT+IH+BXG3yeuqTTz9jzHfssXZbvrO/BzPzJh3nbUSTyvQu6lv9ZdLNv4vW+bnZGyWpZk9SNaC/Q==
X-Received: by 2002:a1f:2354:0:b0:49a:4de8:af2b with SMTP id j81-20020a1f2354000000b0049a4de8af2bmr4776083vkj.9.1695751427477;
        Tue, 26 Sep 2023 11:03:47 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id w8-20020ac843c8000000b00418122186ccsm2367002qtn.12.2023.09.26.11.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:47 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 30/35] btrfs: setup fscrypt_extent_info for new extents
Date:   Tue, 26 Sep 2023 14:01:56 -0400
Message-ID: <aa7c1943d19f1d8d82499c90cfc4475c4bd2a0a5.1695750478.git.josef@toxicpanda.com>
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

New extents for encrypted inodes must have a fscrypt_extent_info, which
has the necessary keys and does all the registration at the block layer
for them.  This is passed through all of the infrastructure we've
previously added to make sure the context gets saved properly with the
file extents.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9414991d6b6b..aa536b838ce3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7398,7 +7398,20 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		em->compress_type = compress_type;
 	}
-	em->encryption_type = BTRFS_ENCRYPTION_NONE;
+
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		struct fscrypt_extent_info *fscrypt_info;
+
+		em->encryption_type = BTRFS_ENCRYPTION_FSCRYPT;
+		fscrypt_info = fscrypt_prepare_new_extent(&inode->vfs_inode);
+		if (IS_ERR(fscrypt_info)) {
+			free_extent_map(em);
+			return ERR_CAST(fscrypt_info);
+		}
+		em->fscrypt_info = fscrypt_info;
+	} else {
+		em->encryption_type = BTRFS_ENCRYPTION_NONE;
+	}
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
@@ -9785,6 +9798,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	if (trans)
 		own_trans = false;
 	while (num_bytes > 0) {
+		struct fscrypt_extent_info *fscrypt_info = NULL;
+		int encryption_type = BTRFS_ENCRYPTION_NONE;
+
 		cur_bytes = min_t(u64, num_bytes, SZ_256M);
 		cur_bytes = max(cur_bytes, min_size);
 		/*
@@ -9799,6 +9815,20 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		if (ret)
 			break;
 
+		if (IS_ENCRYPTED(inode)) {
+			fscrypt_info = fscrypt_prepare_new_extent(inode);
+			if (IS_ERR(fscrypt_info)) {
+				btrfs_dec_block_group_reservations(fs_info,
+								   ins.objectid);
+				btrfs_free_reserved_extent(fs_info,
+							   ins.objectid,
+							   ins.offset, 0);
+				ret = PTR_ERR(fscrypt_info);
+				break;
+			}
+			encryption_type = BTRFS_ENCRYPTION_FSCRYPT;
+		}
+
 		/*
 		 * We've reserved this space, and thus converted it from
 		 * ->bytes_may_use to ->bytes_reserved.  Any error that happens
@@ -9810,7 +9840,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		last_alloc = ins.offset;
 		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, NULL, cur_offset);
+						    &ins, fscrypt_info,
+						    cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9820,6 +9851,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
+			fscrypt_put_extent_info(fscrypt_info);
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
 						   ins.offset, 0);
 			break;
@@ -9827,6 +9859,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		em = alloc_extent_map();
 		if (!em) {
+			fscrypt_put_extent_info(fscrypt_info);
 			btrfs_drop_extent_map_range(BTRFS_I(inode), cur_offset,
 					    cur_offset + ins.offset - 1, false);
 			btrfs_set_inode_full_sync(BTRFS_I(inode));
@@ -9842,6 +9875,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		em->ram_bytes = ins.offset;
 		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		em->generation = trans->transid;
+		em->fscrypt_info = fscrypt_info;
+		em->encryption_type = encryption_type;
 
 		ret = btrfs_replace_extent_map_range(BTRFS_I(inode), em, true);
 		free_extent_map(em);
-- 
2.41.0

