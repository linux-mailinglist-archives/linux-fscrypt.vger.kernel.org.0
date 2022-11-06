Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DB861E70D
	for <lists+linux-fscrypt@lfdr.de>; Sun,  6 Nov 2022 23:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiKFWwi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 6 Nov 2022 17:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKFWwh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 6 Nov 2022 17:52:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77EB10066;
        Sun,  6 Nov 2022 14:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49BF660CA3;
        Sun,  6 Nov 2022 22:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F08DC433C1;
        Sun,  6 Nov 2022 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775155;
        bh=FTMJf9tJaJ+vA5K6ogaxVdllbIlkNpkMhDKCwzVAMTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6DpbLjh0MDYXje2DnvKkE0b0IgFXNnQKbokuy7FqMwaUefDJlYBxiHBqkJwuFMKz
         82a6Sdl+Jb91jpW8T1SrjXZnQl0X1FkY1A2w2XL/MNZ0+snArcf90WlHgx1GunSnGw
         z5bhCV3MYHusUGe6RSGpbRbRaiQHGc1gHe+Y4ugl5HbH77ovqYuEdINTnKdlZ4Dyf4
         djxCH9rJ0Ip7i5sxqgiNaw61PEXmop3APhFxcdDpw9N4XTHZYGFNId/gX2oyEH8ANL
         na8NieMMxJRBREdlNG3hOODNF7DlCx8MMJXEVmeW7O3xf46BFblVvdQaSB65qdyJxU
         Yzxf6por18WfQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH 7/7] ext4: simplify fast-commit CRC calculation
Date:   Sun,  6 Nov 2022 14:48:41 -0800
Message-Id: <20221106224841.279231-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106224841.279231-1-ebiggers@kernel.org>
References: <20221106224841.279231-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of checksumming each field as it is added to the block, just
checksum each block before it is written.  This is simpler, and also
much more efficient.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 54 +++++++++++++------------------------------
 1 file changed, 16 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 7ed71c652f67f..1da85f6261166 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -675,27 +675,6 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 
 /* Ext4 commit path routines */
 
-/* memcpy to fc reserved space and update CRC */
-static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
-				int len, u32 *crc)
-{
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
-	return memcpy(dst, src, len);
-}
-
-/* memzero and update CRC */
-static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
-				u32 *crc)
-{
-	void *ret;
-
-	ret = memset(dst, 0, len);
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, dst, len);
-	return ret;
-}
-
 /*
  * Allocate len bytes on a fast commit buffer.
  *
@@ -749,8 +728,9 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
 	tl.fc_len = cpu_to_le16(remaining);
-	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
-	ext4_fc_memzero(sb, dst + EXT4_FC_TAG_BASE_LEN, remaining, crc);
+	memcpy(dst, &tl, EXT4_FC_TAG_BASE_LEN);
+	memset(dst + EXT4_FC_TAG_BASE_LEN, 0, remaining);
+	*crc = ext4_chksum(sbi, *crc, sbi->s_fc_bh->b_data, bsize);
 
 	ext4_fc_submit_bh(sb, false);
 
@@ -792,13 +772,15 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	tl.fc_len = cpu_to_le16(bsize - off + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
-	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
+	memcpy(dst, &tl, EXT4_FC_TAG_BASE_LEN);
 	dst += EXT4_FC_TAG_BASE_LEN;
 	tail.fc_tid = cpu_to_le32(sbi->s_journal->j_running_transaction->t_tid);
-	ext4_fc_memcpy(sb, dst, &tail.fc_tid, sizeof(tail.fc_tid), &crc);
+	memcpy(dst, &tail.fc_tid, sizeof(tail.fc_tid));
 	dst += sizeof(tail.fc_tid);
+	crc = ext4_chksum(sbi, crc, sbi->s_fc_bh->b_data,
+			  dst - (u8 *)sbi->s_fc_bh->b_data);
 	tail.fc_crc = cpu_to_le32(crc);
-	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	memcpy(dst, &tail.fc_crc, sizeof(tail.fc_crc));
 	dst += sizeof(tail.fc_crc);
 	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
@@ -824,8 +806,8 @@ static bool ext4_fc_add_tlv(struct super_block *sb, u16 tag, u16 len, u8 *val,
 	tl.fc_tag = cpu_to_le16(tag);
 	tl.fc_len = cpu_to_le16(len);
 
-	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
-	ext4_fc_memcpy(sb, dst + EXT4_FC_TAG_BASE_LEN, val, len, crc);
+	memcpy(dst, &tl, EXT4_FC_TAG_BASE_LEN);
+	memcpy(dst + EXT4_FC_TAG_BASE_LEN, val, len);
 
 	return true;
 }
@@ -847,11 +829,11 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	fcd.fc_ino = cpu_to_le32(fc_dentry->fcd_ino);
 	tl.fc_tag = cpu_to_le16(fc_dentry->fcd_op);
 	tl.fc_len = cpu_to_le16(sizeof(fcd) + dlen);
-	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	memcpy(dst, &tl, EXT4_FC_TAG_BASE_LEN);
 	dst += EXT4_FC_TAG_BASE_LEN;
-	ext4_fc_memcpy(sb, dst, &fcd, sizeof(fcd), crc);
+	memcpy(dst, &fcd, sizeof(fcd));
 	dst += sizeof(fcd);
-	ext4_fc_memcpy(sb, dst, fc_dentry->fcd_name.name, dlen, crc);
+	memcpy(dst, fc_dentry->fcd_name.name, dlen);
 
 	return true;
 }
@@ -889,15 +871,11 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 	if (!dst)
 		goto err;
 
-	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc))
-		goto err;
+	memcpy(dst, &tl, EXT4_FC_TAG_BASE_LEN);
 	dst += EXT4_FC_TAG_BASE_LEN;
-	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
-		goto err;
+	memcpy(dst, &fc_inode, sizeof(fc_inode));
 	dst += sizeof(fc_inode);
-	if (!ext4_fc_memcpy(inode->i_sb, dst, (u8 *)ext4_raw_inode(&iloc),
-					inode_len, crc))
-		goto err;
+	memcpy(dst, (u8 *)ext4_raw_inode(&iloc), inode_len);
 	ret = 0;
 err:
 	brelse(iloc.bh);
-- 
2.38.1

