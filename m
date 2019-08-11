Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFD08947F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Aug 2019 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfHKVhO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfHKVhN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8EEE2085B;
        Sun, 11 Aug 2019 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559432;
        bh=jLSRndS90GZ1sS5nNH8viZnBJzvjYmn5wdaigS/eBOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXNM5iORw1W3gqfwS4dRHQM5oTQW4JpvBOt9qx/RkXXhm/+qlhiuvoOMgKnPClO/F
         iu1M7eO0iSxh2ichFx9CUOQMUB7gmhmbSzVBOpx3WSxi7luktLQgJJIjpjP3ks/YuF
         plLF6RnO9ZoGWqRyhEbFBqZYpQCJz97ubZTca+RA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/6] ext4: skip truncate when verity in progress in ->write_begin()
Date:   Sun, 11 Aug 2019 14:35:53 -0700
Message-Id: <20190811213557.1970-3-ebiggers@kernel.org>
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

When an error (e.g. ENOSPC) occurs during ext4_write_begin() when called
from ext4_write_merkle_tree_block(), skip truncating the file.  i_size
is not meaningful in this case, and the truncation is handled by
ext4_end_enable_verity() instead.  Also, this was triggering the
WARN_ON(!inode_is_locked(inode)) in ext4_truncate().

Fixes: ea54d7e4c0f8 ("ext4: add basic fs-verity support")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b2c8d09acf652..cf0fce1173a4c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1340,6 +1340,9 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	}
 
 	if (ret) {
+		bool extended = (pos + len > inode->i_size) &&
+				!ext4_verity_in_progress(inode);
+
 		unlock_page(page);
 		/*
 		 * __block_write_begin may have instantiated a few blocks
@@ -1349,11 +1352,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 		 * Add inode to orphan list in case we crash before
 		 * truncate finishes
 		 */
-		if (pos + len > inode->i_size && ext4_can_truncate(inode))
+		if (extended && ext4_can_truncate(inode))
 			ext4_orphan_add(handle, inode);
 
 		ext4_journal_stop(handle);
-		if (pos + len > inode->i_size) {
+		if (extended) {
 			ext4_truncate_failed_write(inode);
 			/*
 			 * If truncate failed early the inode might
-- 
2.22.0

