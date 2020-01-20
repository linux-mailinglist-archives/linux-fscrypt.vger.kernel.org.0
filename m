Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A9D142301
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 07:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgATGIU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jan 2020 01:08:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgATGIT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jan 2020 01:08:19 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23AF72073A;
        Mon, 20 Jan 2020 06:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579500499;
        bh=vXDa7ReBep0t1iBlcWB2T87bMhiP9s/H3lDJdDPQErA=;
        h=From:To:Cc:Subject:Date:From;
        b=EJxMqhiexC9D9GSnjVpbpE4UHvRvOuMwYSeWTItv76T9/XLZAhlRkdKtuajoYsnOL
         W+aW/xjnINdGJt+apMkE1TNd44JCaKBAopXzdosKByIwtlst8dLFX9KLF9i7sxZAFE
         JZoFJFK8ttdCd8/ZDgBx6pkKhG6qVsDNoEeTH/ak=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] fscrypt: don't print name of busy file when removing key
Date:   Sun, 19 Jan 2020 22:07:32 -0800
Message-Id: <20200120060732.390362-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When an encryption key can't be fully removed due to file(s) protected
by it still being in-use, we shouldn't really print the path to one of
these files to the kernel log, since parts of this path are likely to be
encrypted on-disk, and (depending on how the system is set up) the
confidentiality of this path might be lost by printing it to the log.

This is a trade-off: a single file path often doesn't matter at all,
especially if it's a directory; the kernel log might still be protected
in some way; and I had originally hoped that any "inode(s) still busy"
bugs (which are security weaknesses in their own right) would be quickly
fixed and that to do so it would be super helpful to always know the
file path and not have to run 'find dir -inum $inum' after the fact.

But in practice, these bugs can be hard to fix (e.g. due to asynchronous
process killing that is difficult to eliminate, for performance
reasons), and also not tied to specific files, so knowing a file path
doesn't necessarily help.

So to be safe, for now let's just show the inode number, not the path.
If someone really wants to know a path they can use 'find -inum'.

Fixes: b1c0ec3599f4 ("fscrypt: add FS_IOC_REMOVE_ENCRYPTION_KEY ioctl")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyring.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 098ff2e0f0bb4..ab41b25d4fa1b 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -776,9 +776,6 @@ static int check_for_busy_inodes(struct super_block *sb,
 	struct list_head *pos;
 	size_t busy_count = 0;
 	unsigned long ino;
-	struct dentry *dentry;
-	char _path[256];
-	char *path = NULL;
 
 	spin_lock(&mk->mk_decrypted_inodes_lock);
 
@@ -797,22 +794,14 @@ static int check_for_busy_inodes(struct super_block *sb,
 					 struct fscrypt_info,
 					 ci_master_key_link)->ci_inode;
 		ino = inode->i_ino;
-		dentry = d_find_alias(inode);
 	}
 	spin_unlock(&mk->mk_decrypted_inodes_lock);
 
-	if (dentry) {
-		path = dentry_path(dentry, _path, sizeof(_path));
-		dput(dentry);
-	}
-	if (IS_ERR_OR_NULL(path))
-		path = "(unknown)";
-
 	fscrypt_warn(NULL,
-		     "%s: %zu inode(s) still busy after removing key with %s %*phN, including ino %lu (%s)",
+		     "%s: %zu inode(s) still busy after removing key with %s %*phN, including ino %lu",
 		     sb->s_id, busy_count, master_key_spec_type(&mk->mk_spec),
 		     master_key_spec_len(&mk->mk_spec), (u8 *)&mk->mk_spec.u,
-		     ino, path);
+		     ino);
 	return -EBUSY;
 }
 
-- 
2.25.0

