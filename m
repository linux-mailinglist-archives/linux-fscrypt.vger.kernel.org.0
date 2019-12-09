Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CBD117862
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfLIVYW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:24:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfLIVYW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:24:22 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C3EC206E0;
        Mon,  9 Dec 2019 21:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926661;
        bh=AuIH2TuNaKEm6dBcgepjEUobcygYmoPNcrv739g/VaE=;
        h=From:To:Cc:Subject:Date:From;
        b=J7m6m+s8RzaSoJKCdliMpJXYf99LrPNVjrWWU2WJDaJ5oXTnD7gq/qxP7Nnkl7bvY
         9PNeNoBVhuNoLzJNODdkdHgY3KTved7XvffkkEBncbYyJ+pfRxQYH9P6RSnEtkLUng
         YE4h6d65aZU+lFiYDvliDOzoPEfYiBHfVmDGLMdk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: [PATCH] fscrypt: don't check for ENOKEY from fscrypt_get_encryption_info()
Date:   Mon,  9 Dec 2019 13:23:48 -0800
Message-Id: <20191209212348.243331-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_get_encryption_info() returns 0 if the encryption key is
unavailable; it never returns ENOKEY.  So remove checks for ENOKEY.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/dir.c  | 2 +-
 fs/f2fs/dir.c  | 2 +-
 fs/ubifs/dir.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 9fdd2b269d617..4c9d3ff394a5d 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -116,7 +116,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 
 	if (IS_ENCRYPTED(inode)) {
 		err = fscrypt_get_encryption_info(inode);
-		if (err && err != -ENOKEY)
+		if (err)
 			return err;
 	}
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c967cacf979ef..d9ad842945df5 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -987,7 +987,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 
 	if (IS_ENCRYPTED(inode)) {
 		err = fscrypt_get_encryption_info(inode);
-		if (err && err != -ENOKEY)
+		if (err)
 			goto out;
 
 		err = fscrypt_fname_alloc_buffer(inode, F2FS_NAME_LEN, &fstr);
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 0b98e3c8b461d..acc4f942d25b6 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -512,7 +512,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
 
 	if (encrypted) {
 		err = fscrypt_get_encryption_info(dir);
-		if (err && err != -ENOKEY)
+		if (err)
 			return err;
 
 		err = fscrypt_fname_alloc_buffer(dir, UBIFS_MAX_NLEN, &fstr);
-- 
2.24.0.393.g34dc348eaf-goog

