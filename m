Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC81E89476
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Aug 2019 23:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfHKVhN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfHKVhN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B08F2085A;
        Sun, 11 Aug 2019 21:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559432;
        bh=swoMgo/n2caW8yJE4pfd10ANnvVz7VhP4yS8JJAp8jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjl93+AdEy/Khgm0sMNr6vNO8vy8+xtaJ1FK03uu8Hf21CqlupuirV1lgPjpC3eNP
         j+mTgk8XFhCfbLOy7kGcp4S1eFQLrYp4GRpbcPes0lSBHhMTW696YwxCNtGfdaz31s
         NC8T+kUaShHNtQ9bCRN/9r60OPepWkiFcKwiowmo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/6] fs-verity: fix crash on read error in build_merkle_tree_level()
Date:   Sun, 11 Aug 2019 14:35:52 -0700
Message-Id: <20190811213557.1970-2-ebiggers@kernel.org>
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

In build_merkle_tree_level(), use a separate fsverity_err() statement
when failing to read a data page, rather than incorrectly reusing the
one for failure to read a Merkle tree page and accessing level_start[]
out of bounds due to 'params->level_start[level - 1]' when level == 0.

Fixes: 248676649d53 ("fs-verity: implement FS_IOC_ENABLE_VERITY ioctl")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 3371d51563962..eabc6ac199064 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -43,19 +43,27 @@ static int build_merkle_tree_level(struct inode *inode, unsigned int level,
 			pr_debug("Hashing block %llu of %llu for level %u\n",
 				 i + 1, num_blocks_to_hash, level);
 
-		if (level == 0)
+		if (level == 0) {
 			/* Leaf: hashing a data block */
 			src_page = read_mapping_page(inode->i_mapping, i, NULL);
-		else
+			if (IS_ERR(src_page)) {
+				err = PTR_ERR(src_page);
+				fsverity_err(inode,
+					     "Error %d reading data page %llu",
+					     err, i);
+				return err;
+			}
+		} else {
 			/* Non-leaf: hashing hash block from level below */
 			src_page = vops->read_merkle_tree_page(inode,
 					params->level_start[level - 1] + i);
-		if (IS_ERR(src_page)) {
-			err = PTR_ERR(src_page);
-			fsverity_err(inode,
-				     "Error %d reading Merkle tree page %llu",
-				     err, params->level_start[level - 1] + i);
-			return err;
+			if (IS_ERR(src_page)) {
+				err = PTR_ERR(src_page);
+				fsverity_err(inode,
+					     "Error %d reading Merkle tree page %llu",
+					     err, params->level_start[level - 1] + i);
+				return err;
+			}
 		}
 
 		err = fsverity_hash_page(params, inode, req, src_page,
-- 
2.22.0

