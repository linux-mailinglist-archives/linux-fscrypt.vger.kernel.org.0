Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C85405D2B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 21:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhIITJu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Sep 2021 15:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhIITJu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Sep 2021 15:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFB261167
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Sep 2021 19:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631214520;
        bh=63tgs8Y3y3gfHHFrioeHQHe12NcoN2nSerjoG8o7A08=;
        h=From:To:Subject:Date:From;
        b=pRzqgHz4Uad8alJcs14A2gvLpQmx9+iZOSx342zC8SxCeSylfD4VzztWhV4sxU+TD
         FVq8E3hXI+VZpMYEKIG/EFQMckEjziwO3NSCEyExDleqNvZQMQJzjc2tQBamlJkwQ/
         M9j06vD7rayy7Roap2X/Hl9UUbAWXvC+knTIM3thJZhGaHkB+aWqDLM/eY3Q45maxo
         sJutZfTQlBb3dAxMbCfkR1zhPOiZEz6YGLIzB44i0LlNQ/ac5/jR315mFloJWDfn1K
         5eiPY72ce4XnoWHndfYi63kCWZ5PtwMwbbDfQf9QXqcmGlfMk6KkD9Sga8vv2yvU6o
         egBNyVGIffCeA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: clean up comments in bio.c
Date:   Thu,  9 Sep 2021 12:07:37 -0700
Message-Id: <20210909190737.140841-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The file comment in bio.c is almost completely irrelevant to the actual
contents of the file; it was originally copied from crypto.c.  Fix it
up, and also add a kerneldoc comment for fscrypt_decrypt_bio().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/bio.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 68a2de6b5a9b1..bfc2a5b74ed39 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -1,23 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * This contains encryption functions for per-file encryption.
+ * Utility functions for file contents encryption/decryption on
+ * block device-based filesystems.
  *
  * Copyright (C) 2015, Google, Inc.
  * Copyright (C) 2015, Motorola Mobility
- *
- * Written by Michael Halcrow, 2014.
- *
- * Filename encryption additions
- *	Uday Savagaonkar, 2014
- * Encryption policy handling additions
- *	Ildar Muslukhov, 2014
- * Add fscrypt_pullback_bio_page()
- *	Jaegeuk Kim, 2015.
- *
- * This has not yet undergone a rigorous security audit.
- *
- * The usage of AES-XTS should conform to recommendations in NIST
- * Special Publication 800-38E and IEEE P1619/D16.
  */
 
 #include <linux/pagemap.h>
@@ -26,6 +13,21 @@
 #include <linux/namei.h>
 #include "fscrypt_private.h"
 
+/**
+ * fscrypt_decrypt_bio() - decrypt the contents of a bio
+ * @bio: the bio to decrypt
+ *
+ * Decrypt the contents of a "read" bio following successful completion of the
+ * underlying disk read.  The bio must be reading a whole number of blocks of an
+ * encrypted file directly into the page cache.  If the bio is reading the
+ * ciphertext into bounce pages instead of the page cache (for example, because
+ * the file is also compressed, so decompression is required after decryption),
+ * then this function isn't applicable.  This function may sleep, so it must be
+ * called from a workqueue rather than from the bio's bi_end_io callback.
+ *
+ * This function sets PG_error on any pages that contain any blocks that failed
+ * to be decrypted.  The filesystem must not mark such pages uptodate.
+ */
 void fscrypt_decrypt_bio(struct bio *bio)
 {
 	struct bio_vec *bv;
-- 
2.33.0

