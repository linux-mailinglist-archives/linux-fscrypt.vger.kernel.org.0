Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60930616240
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiKBLyG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiKBLxo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:44 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E247BD1;
        Wed,  2 Nov 2022 04:53:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 43AAB81462;
        Wed,  2 Nov 2022 07:53:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390023; bh=Y7i/Jzp5z12W/F5OGHJJyvkneUKSA1fRLs5m/r5eQvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urXc+jE9JYnppE2uCMrid+NGu6M1/xiPqSs0dqnlXCfAxjkuGjoVj5bIevLo9cOxC
         ZJmBq4QkcKn+Npjrxbzn1E1Um2fPFwy8GIlXZXtYhWHqwbHSKT10z6RvMzq8ank+AJ
         FW0hJKC+MhZaMW0DYP7uAUBEcsmwImoUurhXQ3cBuL+IEdip4GcWUHU0iNmq8FV1NR
         NTAsV4Y/B8wtAK6ujpSUXumPpSe5534oOC11+BqN8BGMYYtfOe8jJbwQpeDmw1BVmi
         9ZGfj/+FItHxy0GlQrAW3xhq8KCAk8jBp4FJBGDoP9/DFKCpnvDOjFlG+5r2W5gm4z
         A2+YXObNnYAtg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 18/18] btrfs: allow encrypting compressed extents
Date:   Wed,  2 Nov 2022 07:53:07 -0400
Message-Id: <b7d40ecc00427518aab87ed4a3ac6d48b951872a.1667389116.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Conveniently, compressed extents are already padded to sector size, so
they can be encrypted in-place (which requires 16-byte alignment).

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/btrfs_inode.h |  3 ---
 fs/btrfs/compression.c | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index f0935a95ec70..d7f2b9a3d42b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -385,9 +385,6 @@ static inline bool btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
  */
 static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 {
-	if (IS_ENCRYPTED(&inode->vfs_inode))
-		return false;
-
 	if (inode->flags & BTRFS_INODE_NODATACOW ||
 	    inode->flags & BTRFS_INODE_NODATASUM)
 		return false;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 52df6c06cc91..038721a66414 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -202,6 +202,16 @@ static void end_compressed_bio_read(struct btrfs_bio *bbio)
 				status = errno_to_blk_status(ret);
 			}
 		}
+		if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
+			int err;
+			u64 lblk_num = start >> fs_info->sectorsize_bits;
+			err = fscrypt_decrypt_block_inplace(inode, bv.bv_page,
+							    fs_info->sectorsize,
+							    bv.bv_offset,
+							    lblk_num);
+			if (err)
+				status = errno_to_blk_status(err);
+		}
 	}
 
 	if (status)
@@ -451,6 +461,19 @@ blk_status_t btrfs_submit_compressed_write(struct btrfs_inode *inode, u64 start,
 		real_size = min_t(u64, real_size, compressed_len - offset);
 		ASSERT(IS_ALIGNED(real_size, fs_info->sectorsize));
 
+		if (fscrypt_inode_uses_fs_layer_crypto(&inode->vfs_inode)) {
+			int err;
+			u64 lblk_num = start >> fs_info->sectorsize_bits;
+
+			err = fscrypt_encrypt_block_inplace(&inode->vfs_inode,
+							    page, real_size, 0,
+							    lblk_num, GFP_NOFS);
+			if (err) {
+				ret = errno_to_blk_status(err);
+				break;
+			}
+		}
+
 		if (use_append)
 			added = bio_add_zone_append_page(bio, page, real_size,
 					offset_in_page(offset));
-- 
2.37.3

