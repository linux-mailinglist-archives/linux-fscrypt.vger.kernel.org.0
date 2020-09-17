Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C56F26D24E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Sep 2020 06:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIQEU6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Sep 2020 00:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIQEUv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Sep 2020 00:20:51 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BB021D1B;
        Thu, 17 Sep 2020 04:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600315989;
        bh=kONvZL9ec2SBbE4EAel9mci0YCQN1pZc7hmFt/F6qwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV/WrbzmMh/m1GcJfVh/IfrXQYzbYI++xzjHNF1UVeIGheoZk8x4jPK18g8sIGotG
         CbC5PHYju1c79ieBLnAf26mkx6hB5TXPaWBq2uxvQ+NKofgZXvuUg5y5OThKsE4CBu
         fosUQqDRp3/xsmxSqVSrTDuIO8vQ3CRlBZZ7H3ws=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v3 05/13] ubifs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
Date:   Wed, 16 Sep 2020 21:11:28 -0700
Message-Id: <20200917041136.178600-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917041136.178600-1-ebiggers@kernel.org>
References: <20200917041136.178600-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Convert ubifs to use the new functions fscrypt_prepare_new_inode() and
fscrypt_set_context().

Unlike ext4 and f2fs, this doesn't appear to fix any deadlock bug.  But
it does shorten the code slightly and get all filesystems using the same
helper functions, so that fscrypt_inherit_context() can be removed.

It also fixes an incorrect error code where ubifs returned EPERM instead
of the expected ENOKEY.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ubifs/dir.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a9c1f5a9c9bdd..155521e51ac57 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -81,19 +81,6 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 	struct ubifs_inode *ui;
 	bool encrypted = false;
 
-	if (IS_ENCRYPTED(dir)) {
-		err = fscrypt_get_encryption_info(dir);
-		if (err) {
-			ubifs_err(c, "fscrypt_get_encryption_info failed: %i", err);
-			return ERR_PTR(err);
-		}
-
-		if (!fscrypt_has_encryption_key(dir))
-			return ERR_PTR(-EPERM);
-
-		encrypted = true;
-	}
-
 	inode = new_inode(c->vfs_sb);
 	ui = ubifs_inode(inode);
 	if (!inode)
@@ -112,6 +99,12 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 			 current_time(inode);
 	inode->i_mapping->nrpages = 0;
 
+	err = fscrypt_prepare_new_inode(dir, inode, &encrypted);
+	if (err) {
+		ubifs_err(c, "fscrypt_prepare_new_inode failed: %i", err);
+		goto out_iput;
+	}
+
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_mapping->a_ops = &ubifs_file_address_operations;
@@ -131,7 +124,6 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 	case S_IFBLK:
 	case S_IFCHR:
 		inode->i_op  = &ubifs_file_inode_operations;
-		encrypted = false;
 		break;
 	default:
 		BUG();
@@ -151,9 +143,8 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 		if (c->highest_inum >= INUM_WATERMARK) {
 			spin_unlock(&c->cnt_lock);
 			ubifs_err(c, "out of inode numbers");
-			make_bad_inode(inode);
-			iput(inode);
-			return ERR_PTR(-EINVAL);
+			err = -EINVAL;
+			goto out_iput;
 		}
 		ubifs_warn(c, "running out of inode numbers (current %lu, max %u)",
 			   (unsigned long)c->highest_inum, INUM_WATERMARK);
@@ -171,16 +162,19 @@ struct inode *ubifs_new_inode(struct ubifs_info *c, struct inode *dir,
 	spin_unlock(&c->cnt_lock);
 
 	if (encrypted) {
-		err = fscrypt_inherit_context(dir, inode, &encrypted, true);
+		err = fscrypt_set_context(inode, NULL);
 		if (err) {
-			ubifs_err(c, "fscrypt_inherit_context failed: %i", err);
-			make_bad_inode(inode);
-			iput(inode);
-			return ERR_PTR(err);
+			ubifs_err(c, "fscrypt_set_context failed: %i", err);
+			goto out_iput;
 		}
 	}
 
 	return inode;
+
+out_iput:
+	make_bad_inode(inode);
+	iput(inode);
+	return ERR_PTR(err);
 }
 
 static int dbg_check_name(const struct ubifs_info *c,
-- 
2.28.0

