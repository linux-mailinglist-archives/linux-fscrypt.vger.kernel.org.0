Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A18F62A63
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2019 22:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405032AbfGHUdZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 8 Jul 2019 16:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729370AbfGHUdZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 8 Jul 2019 16:33:25 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F38205ED;
        Mon,  8 Jul 2019 20:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562618003;
        bh=AyI1LJSWEGua8v/8eClfc39Rc/AarGIsKe0oKSNf5oc=;
        h=From:To:Cc:Subject:Date:From;
        b=ppnWqNQ+11Wl3sI1hitl2GTuQUV5wzhfQMFBM+0JNxjRqtBT8o1yk7leizHEzQ0he
         y211wp65SoBgTlLN42fEUyvxK0PyGdVZ8beA4QvDEg9lC3sSlZ5zQ44GjHa79ew6IK
         DUvo7FnjoG/T4l30zqis5HH5/ViK3lt83KeAMNxc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic/399: don't rely on xfs_io exit status
Date:   Mon,  8 Jul 2019 13:32:39 -0700
Message-Id: <20190708203239.219792-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Unexpectedly, 'xfs_io -f $file -c "pwrite 0 1M"' exits with failure
status if the file can't be created, but exits with success status if an
error occurs actually writing data.  As discussed previously, xfs_io's
exit status has always been broken, and it will be difficult to fix:
https://marc.info/?l=linux-xfs&m=151269053129101&w=2

Because of this, generic/399 fails on ext4 if "-I 256" (256-byte inodes)
is specified in the mkfs options, e.g. with 'kvm-xfstests -c ext4/adv
generic/399'.  This is because the test tries to fill a filesystem
entirely with 1 MiB encrypted files, and it expects the xfs_io commands
to start failing when no more files should be able to fit.  But when the
filesystem supports in-inode xattrs, no blocks need to be allocated for
the encryption xattrs, so empty encrypted files can continue to be
created even after all the filesystem's blocks are in-use.

For better or worse, the convention for xfstests is to ignore the exit
status of xfs_io and instead rely on the printed error messages.  Thus,
other tests don't run into this problem.  So for now, let's fix the test
failure by making generic/399 do the same.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/399 | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/tests/generic/399 b/tests/generic/399
index 5625503b..dfd8d3c2 100755
--- a/tests/generic/399
+++ b/tests/generic/399
@@ -82,28 +82,38 @@ total_file_size=0
 i=1
 while true; do
 	file=$SCRATCH_MNT/encrypted_dir/file$i
-	if ! $XFS_IO_PROG -f $file -c 'pwrite 0 1M' &> $tmp.out; then
-		if ! grep -q 'No space left on device' $tmp.out; then
-			echo "FAIL: unexpected pwrite failure"
-			cat $tmp.out
-		elif [ -e $file ]; then
-			total_file_size=$((total_file_size + $(stat -c %s $file)))
-		fi
-		break
+
+	$XFS_IO_PROG -f $file -c 'pwrite 0 1M' &> $tmp.out
+	echo "Writing $file..." >> $seqres.full
+	cat $tmp.out >> $seqres.full
+
+	file_size=0
+	if [ -e $file ]; then
+		file_size=$(stat -c %s $file)
 	fi
-	total_file_size=$((total_file_size + $(stat -c %s $file)))
-	i=$((i + 1))
-	if [ $i -gt $fs_size_in_mb ]; then
-		echo "FAIL: filesystem never filled up!"
+
+	# We shouldn't have been able to write more data than we had space for.
+	(( total_file_size += file_size ))
+	if (( total_file_size > fs_size )); then
+		_fail "Wrote $total_file_size bytes but should have only" \
+		      "had space for $fs_size bytes at most!"
+	fi
+
+	# Stop if we hit ENOSPC.
+	if grep -q 'No space left on device' $tmp.out; then
 		break
 	fi
-done
 
-# We shouldn't have been able to write more data than we had space for.
-if (( $total_file_size > $fs_size )); then
-	echo "FAIL: wrote $total_file_size bytes but should have only" \
-		"had space for $fs_size bytes at most"
-fi
+	# Otherwise the file should have been successfully created.
+	if [ ! -e $file ]; then
+		_fail "$file failed to be created, but the fs isn't out of space yet!"
+	fi
+	if (( file_size != 1024 * 1024 )); then
+		_fail "Size of $file is wrong (possible write error?)." \
+		      "Got $file_size, expected 1 MiB"
+	fi
+	(( i++ ))
+done
 
 #
 # Unmount the filesystem and compute its compressed size.  It must be no smaller
-- 
2.22.0.410.gd8fdbe21b5-goog

