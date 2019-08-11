Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18E658947C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Aug 2019 23:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHKVhO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfHKVhN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7DE4208C2;
        Sun, 11 Aug 2019 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559433;
        bh=hfKkuGUJ1kiygfXldZQujeyj/c9gD3q/1k7tA5kqnRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wlTph1uBlx9zoYfzKeX5qpWlntqWfJ1qt93hZQkqaXlU1RSgvNwwOiWoLvesgSRg
         JRW37GlYSQRTVezCPpP7o3yCpnxL1AE/qDE/D72IdEVwTS9KxbQ614EKWGLMhNffJq
         GOHlkkzHZWPwjEFriIHid8Y66YQ1Te1cFzkU/dhk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/6] f2fs: skip truncate when verity in progress in ->write_begin()
Date:   Sun, 11 Aug 2019 14:35:54 -0700
Message-Id: <20190811213557.1970-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190811213557.1970-1-ebiggers@kernel.org>
References: <20190811213557.1970-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When an error (e.g. ENOSPC) occurs during f2fs_write_begin() when called
from f2fs_write_merkle_tree_block(), skip truncating the file.  i_size
is not meaningful in this case, and the truncation is handled by
f2fs_end_enable_verity() instead.

Fixes: 60d7bf0f790f ("f2fs: add fs-verity support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3f525f8a3a5fa..00b03fb87bd9b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2476,7 +2476,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
 	struct inode *inode = mapping->host;
 	loff_t i_size = i_size_read(inode);
 
-	if (to > i_size) {
+	if (to > i_size && !f2fs_verity_in_progress(inode)) {
 		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 		down_write(&F2FS_I(inode)->i_mmap_sem);
 
-- 
2.22.0

