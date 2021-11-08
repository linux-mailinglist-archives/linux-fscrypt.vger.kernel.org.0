Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B24644796D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Nov 2021 05:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234158AbhKHEkT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 7 Nov 2021 23:40:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231463AbhKHEkS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 7 Nov 2021 23:40:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D1261076;
        Mon,  8 Nov 2021 04:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636346255;
        bh=Pdd82xrVzMnfiWi2u+fTvK6TMnsM7+MLbMGx3FZWteg=;
        h=From:To:Cc:Subject:Date:From;
        b=meMzeIxb90AZ12Nr9C9Di6wPtrxB4uLZAQs3rQ5VXuSJMlF4gpUS4mZW0CGuZdgeA
         lJjvodhnrAKwBIxYm3miQrO0RAjQ7bzEmfjlAq3H1uKOMTPhyVDdm7H0QyiddMWypj
         5mNdbcpCV1HLZDQ3FzwWTxaJE36f+qNctPS9qWvUP14VQ2J7hxr59ncOASYhSj84Rf
         MyzXIYMtq637NIAhjG+BJaQjh6I3NAsAAS6ntrqRP1VcfQT3rmFmgszqJpUW6pAKlB
         LMiWCN8425XyTVEzVXe0OQYQ50L+RwFIZzbYkj1uQ7oCEcHxDi/ggghpE3HJYv5iha
         e7hgzVfNg2Dfw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH] generic/574: remove invalid test of read completely past EOF
Date:   Sun,  7 Nov 2021 20:36:20 -0800
Message-Id: <20211108043620.155257-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

One of the test cases in generic/574 tests that if a file of length
130999 has fs-verity enabled, and if bytes 131000..131071 (i.e. some
bytes past EOF and in the same block as EOF) are corrupted with nonzero
values, then reads of the corrupted part should fail with EIO.

This isn't a valid test case, because reads that start at or past EOF
are allowed to simply return 0 without doing any I/O.

Therefore, don't run this test case.

This fixes a test failure caused by the kernel commit 8c8387ee3f55
("mm: stop filemap_read() from grabbing a superfluous page").

Note that the other test cases for this same corrupted file remain
valid, including testing that an error is reported during full file
reads and during mmap "reads".  This is because the fs-verity Merkle
tree is defined over full blocks, so the file's last block won't be
readable if it contains corrupted (nonzero) bytes past EOF.  This may
seem odd, but it's working as intended, especially considering that
bytes past EOF in a file's last block are exposed to userspace in mmaps.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/574     | 2 +-
 tests/generic/574.out | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tests/generic/574 b/tests/generic/574
index df0ef95f..882baa21 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -106,7 +106,7 @@ corruption_test()
 	dd if=$fsv_file bs=$FSV_BLOCK_SIZE iflag=direct status=none \
 		of=/dev/null |& _filter_scratch
 
-	if ! $is_merkle_tree; then
+	if (( zap_offset < file_len )) && ! $is_merkle_tree; then
 		echo "Validating corruption (reading just corrupted part)..."
 		dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
 			of=/dev/null status=none |& _filter_scratch
diff --git a/tests/generic/574.out b/tests/generic/574.out
index d43474c5..3c08d3e8 100644
--- a/tests/generic/574.out
+++ b/tests/generic/574.out
@@ -63,8 +63,6 @@ Validating corruption (reading full file)...
 md5sum: SCRATCH_MNT/file.fsv: Input/output error
 Validating corruption (direct I/O)...
 dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading just corrupted part)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
 Validating corruption (reading full file via mmap)...
 Bus error
 Validating corruption (reading just corrupted part via mmap)...
-- 
2.33.1

