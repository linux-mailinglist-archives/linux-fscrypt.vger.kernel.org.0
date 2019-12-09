Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B230E117889
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfLIVdI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfLIVdH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:33:07 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383E72071E;
        Mon,  9 Dec 2019 21:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575927187;
        bh=sazSRY1r8F1TEbx3JI+yAVvJF6WPJx2Um+B19LoeA8U=;
        h=From:To:Cc:Subject:Date:From;
        b=vcVaWl8f8m2EK6Cgx6TiwQXaQRhxW+3n9hd/RGrkcVfKZJYCeqRmzhnfaCFsd88i5
         O8LAY0icOUsEiNzTmeEBB5m057COzfsRdyQffIg7+VXKkVK1zr+uVpVf/V9WE3LxDI
         8J59PQQcZ22uLpMYocJXFITnd6Czk/sXDBcQWFIU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] ext4: remove unnecessary ifdefs in htree_dirblock_to_tree()
Date:   Mon,  9 Dec 2019 13:32:25 -0800
Message-Id: <20191209213225.18477-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The ifdefs for CONFIG_FS_ENCRYPTION in htree_dirblock_to_tree() are
unnecessary, as the called functions are already stubbed out when
!CONFIG_FS_ENCRYPTION.  Remove them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/namei.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a856997d87b54..d4c2cc73fe71d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1002,7 +1002,6 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
 					   EXT4_DIR_REC_LEN(0));
-#ifdef CONFIG_FS_ENCRYPTION
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
 		err = fscrypt_get_encryption_info(dir);
@@ -1017,7 +1016,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			return err;
 		}
 	}
-#endif
+
 	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 				bh->b_data, bh->b_size,
@@ -1065,9 +1064,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	}
 errout:
 	brelse(bh);
-#ifdef CONFIG_FS_ENCRYPTION
 	fscrypt_fname_free_buffer(&fname_crypto_str);
-#endif
 	return count;
 }
 
-- 
2.24.0.393.g34dc348eaf-goog

