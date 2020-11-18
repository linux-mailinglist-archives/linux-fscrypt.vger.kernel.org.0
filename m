Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E002B77C4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Nov 2020 09:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgKRIAY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 Nov 2020 03:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKRIAX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 Nov 2020 03:00:23 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE5D4223C7;
        Wed, 18 Nov 2020 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605686421;
        bh=TMQmJr2bMo4HNpZkNGctIWRJ10YvuhK/kFBcJlRDYN0=;
        h=From:To:Cc:Subject:Date:From;
        b=PYv0fxNSmDuTXiDa6iJPKFlieuXZzgMdq+BEEWlbmdqGIt6ygayTHEI7TYjDunNBf
         OeMZgoxzibZMFhQmIE8Ss8op5V8hTTbxOaJqtT3LvhelW0lO+41YMmr3Sq/GZgRikf
         7izY8jgn+sQO2wgExk3MwXVSKQmae+65zpguWjZU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH] generic: test for creating duplicate filenames in encrypted dir
Date:   Tue, 17 Nov 2020 23:59:53 -0800
Message-Id: <20201118075953.121175-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test for a race condition where a duplicate filename could be created in
an encrypted directory while the directory's encryption key was being
added concurrently.

generic/595 was already failing on ubifs due to this bug, but only by
accident.  This new test detects the bug on both ext4 and ubifs.  I
wasn't able to get it to detect the bug on f2fs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This RFC for now, until the kernel patches
https://lkml.kernel.org/linux-fscrypt/20201118075609.120337-1-ebiggers@kernel.org/T/#u
are merged.

 tests/generic/900     | 166 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  21 ++++++
 tests/generic/group   |   1 +
 3 files changed, 188 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..13e2e0af
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,166 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2020 Google LLC
+#
+# FS QA Test No. 900
+#
+# Test for a race condition where a duplicate filename could be created in an
+# encrypted directory while the directory's encryption key was being added
+# concurrently.  This is a regression test for the following kernel commits:
+#
+#       968dd6d0c6d6 ("fscrypt: fix race allowing rename() and link() of ciphertext dentries")
+#               TODO ("ext4: prevent creating duplicate encrypted filenames")
+#               TODO ("f2fs: prevent creating duplicate encrypted filenames")
+#               TODO ("ubifs: prevent creating duplicate encrypted filenames")
+#
+# The first commit fixed the bug for the rename() and link() syscalls.
+# The others fixed the bug for the other syscalls that create new filenames.
+#
+# Note, the bug wasn't actually reproducible on f2fs.
+#
+# The race condition worked as follows:
+#    1. Initial state: an encrypted directory "dir" contains a file "foo",
+#       but the directory's key hasn't been added yet so 'ls dir' shows an
+#       encoded no-key name rather than "foo".
+#    2. The key is added concurrently with mkdir("dir/foo") or another syscall
+#       that creates a new filename and should fail if it already exists.
+#        a. The syscall looks up "dir/foo", creating a negative no-key dentry
+#           for "foo" since the directory's key hasn't been added yet.
+#        b. The directory's key is added.
+#        c. The syscall does the actual fs-level operation to create the
+#           filename.  With the bug, the filesystem failed to detect that the
+#           dentry was created without the key, potentially causing the
+#           operation to unexpectedly succeed and add a duplicate filename.
+#
+# To test this, we try to reproduce the above race.  Afterwards we check for
+# duplicate filenames, plus a few other things.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	touch $tmp.done
+	wait
+	rm -f $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+. ./common/encrypt
+. ./common/renameat2
+
+rm -f $seqres.full
+
+_supported_fs generic
+_require_scratch_encryption -v 2
+_require_renameat2 noreplace
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+runtime=$((5 * TIME_FACTOR))
+dir=$SCRATCH_MNT/dir
+
+echo -e "\n# Creating encrypted directory containing files"
+mkdir $dir
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+for i in {1..100}; do
+	touch $dir/$i
+done
+
+# This is the filename which we'll try to duplicate.
+inode=$(stat -c %i $dir/100)
+
+# ext4 checks for duplicate dentries when inserting one, which can hide the bug
+# this test is testing for.  However, ext4 stops checking for duplicates once it
+# finds space for the new dentry.  Therefore, we can circumvent ext4's duplicate
+# checking by creating space at the beginning of the directory block.
+rm $dir/1
+
+echo -e "\n# Starting duplicate filename creator process"
+(
+	# Repeatedly try to create the filename $dir/100 (which already exists)
+	# using syscalls that should fail if the file already exists: mkdir(),
+	# mknod(), symlink(), link(), and renameat2(RENAME_NOREPLACE).  This
+	# hopefully detects any one of them having the bug.  TODO: we should
+	# also try open(O_EXCL|O_CREAT), but it needs a command-line tool.
+	while [ ! -e $tmp.done ]; do
+		if mkdir $dir/100 &> /dev/null; then
+			touch $tmp.mkdir_succeeded
+		fi
+		if mknod $dir/100 c 5 5 &> /dev/null; then
+			touch $tmp.mknod_succeeded
+		fi
+		if ln -s target $dir/100 &> /dev/null; then
+			touch $tmp.symlink_succeeded
+		fi
+		if ln $dir/50 $dir/100 &> /dev/null; then
+			touch $tmp.link_succeeded
+		fi
+		if $here/src/renameat2 -n $dir/50 $dir/100 &> /dev/null; then
+			touch $tmp.rename_noreplace_succeeded
+		fi
+	done
+) &
+
+echo -e "\n# Starting add/remove enckey process"
+(
+	# Repeatedly add and remove the encryption key for $dir.  The actual
+	# race this test is trying to reproduce occurs when adding the key.
+	while [ ! -e $tmp.done ]; do
+		_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" > /dev/null
+		_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER > /dev/null
+	done
+) &
+
+echo -e "\n# Running for a few seconds..."
+sleep $runtime
+echo -e "\n# Stopping subprocesses"
+touch $tmp.done
+wait
+
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" > /dev/null
+
+# Check for failure in several different ways, since different ways work on
+# different filesystems.  E.g. ext4 shows duplicate filenames but ubifs doesn't.
+
+echo -e "\n# Checking for duplicate filenames via readdir"
+ls $dir | grep 100
+
+echo -e "\n# Checking for unexpected change in inode number"
+new_inode=$(stat -c %i $dir/100)
+if [ $new_inode != $inode ]; then
+	echo "Dentry changed inode number $inode => $new_inode!"
+fi
+
+echo -e "\n# Checking for operations that unexpectedly succeeded on an existing filename"
+for op in "mkdir" "mknod" "symlink" "link" "rename_noreplace"; do
+	if [ -e $tmp.${op}_succeeded ]; then
+		echo "$op operation(s) on existing filename unexpectedly succeeded!"
+	fi
+done
+
+# Also check that the fsck program can't find any duplicate filenames.
+# For ext4, override _check_scratch_fs() so that we can specify -D (optimize
+# directories); otherwise e2fsck doesn't check for duplicate filenames.
+echo -e "\n# Checking for duplicate filenames via fsck"
+_scratch_unmount
+if [ "$FSTYP" = ext4 ]; then
+	if ! e2fsck -f -y -D $SCRATCH_DEV &>> $seqres.full; then
+		_log_err "filesystem on $SCRATCH_DEV is inconsistent"
+	fi
+else
+	_check_scratch_fs
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..62aa3744
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,21 @@
+QA output created by 900
+
+# Creating encrypted directory containing files
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Starting duplicate filename creator process
+
+# Starting add/remove enckey process
+
+# Running for a few seconds...
+
+# Stopping subprocesses
+
+# Checking for duplicate filenames via readdir
+100
+
+# Checking for unexpected change in inode number
+
+# Checking for operations that unexpectedly succeeded on an existing filename
+
+# Checking for duplicate filenames via fsck
diff --git a/tests/generic/group b/tests/generic/group
index 94e860b8..c3f0c9e8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -620,3 +620,4 @@
 615 auto rw
 616 auto rw io_uring stress
 617 auto rw io_uring stress
+900 auto quick encrypt
-- 
2.29.2

