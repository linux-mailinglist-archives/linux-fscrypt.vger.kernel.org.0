Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532AB267ECC
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgIMIjV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbgIMIiA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:00 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 863D6217BA;
        Sun, 13 Sep 2020 08:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986278;
        bh=b+br3C3cbfnBLBIC6l48f9MznNCXZDVFxP9oBuV6fkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGul2KB3CInYTSSC4L2PRp6JTaRYcFNP0nidlDNYYfkMYlIOTEaZob7V4VtNrIGWm
         AL/Oi/ir5g2CXybFFSNqBguAQ9/tmP5RJyHzacP8pFF/S1Y/Chg87Lm7X6Oje3vh0B
         +OcZ8AHS3KZSm/Zul/lrrcPWKAWpE1oq0ZaXR1zw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 03/11] ext4: use fscrypt_prepare_new_inode() and fscrypt_set_context()
Date:   Sun, 13 Sep 2020 01:36:12 -0700
Message-Id: <20200913083620.170627-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200913083620.170627-1-ebiggers@kernel.org>
References: <20200913083620.170627-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert ext4 to use the new functions fscrypt_prepare_new_inode() and
fscrypt_set_context().  This avoids calling
fscrypt_get_encryption_info() from within a transaction, which can
deadlock because fscrypt_get_encryption_info() isn't GFP_NOFS-safe.

For more details about this problem, see the earlier patch
"fscrypt: add fscrypt_prepare_new_inode() and fscrypt_set_context()".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ialloc.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 0cc576005a923..698ca4a4db5f7 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -819,7 +819,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	ext4_group_t i;
 	ext4_group_t flex_group;
 	struct ext4_group_info *grp;
-	int encrypt = 0;
+	bool encrypt = false;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -831,24 +831,6 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if (unlikely(ext4_forced_shutdown(sbi)))
 		return ERR_PTR(-EIO);
 
-	if ((IS_ENCRYPTED(dir) || DUMMY_ENCRYPTION_ENABLED(sbi)) &&
-	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)) &&
-	    !(i_flags & EXT4_EA_INODE_FL)) {
-		err = fscrypt_get_encryption_info(dir);
-		if (err)
-			return ERR_PTR(err);
-		if (!fscrypt_has_encryption_key(dir))
-			return ERR_PTR(-ENOKEY);
-		encrypt = 1;
-	}
-
-	if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
-		ret2 = ext4_xattr_credits_for_new_inode(dir, mode, encrypt);
-		if (ret2 < 0)
-			return ERR_PTR(ret2);
-		nblocks += ret2;
-	}
-
 	ngroups = ext4_get_groups_count(sb);
 	trace_ext4_request_inode(dir, mode);
 	inode = new_inode(sb);
@@ -878,10 +860,25 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	else
 		ei->i_projid = make_kprojid(&init_user_ns, EXT4_DEF_PROJID);
 
+	if (!(i_flags & EXT4_EA_INODE_FL)) {
+		err = fscrypt_prepare_new_inode(dir, inode, &encrypt);
+		if (err)
+			goto out;
+	}
+
 	err = dquot_initialize(inode);
 	if (err)
 		goto out;
 
+	if (!handle && sbi->s_journal && !(i_flags & EXT4_EA_INODE_FL)) {
+		ret2 = ext4_xattr_credits_for_new_inode(dir, mode, encrypt);
+		if (ret2 < 0) {
+			err = ret2;
+			goto out;
+		}
+		nblocks += ret2;
+	}
+
 	if (!goal)
 		goal = sbi->s_inode_goal;
 
@@ -1174,7 +1171,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	 * prevent its deduplication.
 	 */
 	if (encrypt) {
-		err = fscrypt_inherit_context(dir, inode, handle, true);
+		err = fscrypt_set_context(inode, handle);
 		if (err)
 			goto fail_free_drop;
 	}
-- 
2.28.0

