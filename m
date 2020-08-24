Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560E524F25A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 08:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgHXGSa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 02:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgHXGST (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 02:18:19 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90CA6207D3;
        Mon, 24 Aug 2020 06:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598249898;
        bh=QdONhA25GuQQJmapNTQIWWWGH7achN6FFOfpot5lMGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2050mad+4BMjzCtGT254bX32Y57ZVPtbWQMoQ32OT3m9nxLEs1AyyyqNgsRbiXRZ
         QT/l38bY56Ows6Dz77k+6jZZieKpGieGImYQ2x0upL1GsY64XNmbcCCuQTqD6nxcy5
         EOd44g73ySC7xMwhc5Xioy2YrWtVXRk3pKMU+uk4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH 2/8] ext4: factor out ext4_xattr_credits_for_new_inode()
Date:   Sun, 23 Aug 2020 23:17:06 -0700
Message-Id: <20200824061712.195654-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824061712.195654-1-ebiggers@kernel.org>
References: <20200824061712.195654-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To compute a new inode's xattr credits, we need to know whether the
inode will be encrypted or not.  When we switch to use the new helper
function fscrypt_prepare_new_inode(), we won't find out whether the
inode will be encrypted until slightly later than is currently the case,
which requires moving the code block that computes the xattr credits.

To make this easier and reduce the length of __ext4_new_inode(), move
this code block into a new function ext4_xattr_credits_for_new_inode().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ialloc.c | 90 +++++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index df25d38d65393..0cc576005a923 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -742,6 +742,53 @@ static int find_inode_bit(struct super_block *sb, ext4_group_t group,
 	return 1;
 }
 
+static int ext4_xattr_credits_for_new_inode(struct inode *dir, mode_t mode,
+					    bool encrypt)
+{
+	struct super_block *sb = dir->i_sb;
+	int nblocks = 0;
+#ifdef CONFIG_EXT4_FS_POSIX_ACL
+	struct posix_acl *p = get_acl(dir, ACL_TYPE_DEFAULT);
+
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+	if (p) {
+		int acl_size = p->a_count * sizeof(ext4_acl_entry);
+
+		nblocks += (S_ISDIR(mode) ? 2 : 1) *
+			__ext4_xattr_set_credits(sb, NULL /* inode */,
+						 NULL /* block_bh */, acl_size,
+						 true /* is_create */);
+		posix_acl_release(p);
+	}
+#endif
+
+#ifdef CONFIG_SECURITY
+	{
+		int num_security_xattrs = 1;
+
+#ifdef CONFIG_INTEGRITY
+		num_security_xattrs++;
+#endif
+		/*
+		 * We assume that security xattrs are never more than 1k.
+		 * In practice they are under 128 bytes.
+		 */
+		nblocks += num_security_xattrs *
+			__ext4_xattr_set_credits(sb, NULL /* inode */,
+						 NULL /* block_bh */, 1024,
+						 true /* is_create */);
+	}
+#endif
+	if (encrypt)
+		nblocks += __ext4_xattr_set_credits(sb,
+						    NULL /* inode */,
+						    NULL /* block_bh */,
+						    FSCRYPT_SET_CONTEXT_MAX_SIZE,
+						    true /* is_create */);
+	return nblocks;
+}
+
 /*
  * There are two policies for allocating an inode.  If the new inode is
  * a directory, then a forward search is made for a block group with both
@@ -796,45 +843,10 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	}
 
 	if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
-		struct posix_acl *p = get_acl(dir, ACL_TYPE_DEFAULT);
-
-		if (IS_ERR(p))
-			return ERR_CAST(p);
-		if (p) {
-			int acl_size = p->a_count * sizeof(ext4_acl_entry);
-
-			nblocks += (S_ISDIR(mode) ? 2 : 1) *
-				__ext4_xattr_set_credits(sb, NULL /* inode */,
-					NULL /* block_bh */, acl_size,
-					true /* is_create */);
-			posix_acl_release(p);
-		}
-#endif
-
-#ifdef CONFIG_SECURITY
-		{
-			int num_security_xattrs = 1;
-
-#ifdef CONFIG_INTEGRITY
-			num_security_xattrs++;
-#endif
-			/*
-			 * We assume that security xattrs are never
-			 * more than 1k.  In practice they are under
-			 * 128 bytes.
-			 */
-			nblocks += num_security_xattrs *
-				__ext4_xattr_set_credits(sb, NULL /* inode */,
-					NULL /* block_bh */, 1024,
-					true /* is_create */);
-		}
-#endif
-		if (encrypt)
-			nblocks += __ext4_xattr_set_credits(sb,
-					NULL /* inode */, NULL /* block_bh */,
-					FSCRYPT_SET_CONTEXT_MAX_SIZE,
-					true /* is_create */);
+		ret2 = ext4_xattr_credits_for_new_inode(dir, mode, encrypt);
+		if (ret2 < 0)
+			return ERR_PTR(ret2);
+		nblocks += ret2;
 	}
 
 	ngroups = ext4_get_groups_count(sb);
-- 
2.28.0

