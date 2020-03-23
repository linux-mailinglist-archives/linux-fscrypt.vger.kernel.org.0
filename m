Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 928A018FA18
	for <lists+linux-fscrypt@lfdr.de>; Mon, 23 Mar 2020 17:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCWQlm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Mar 2020 12:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgCWQlm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Mar 2020 12:41:42 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B982520722;
        Mon, 23 Mar 2020 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584981701;
        bh=fZ6Ca65pVsgLkGVDZcmEe0ZSxR5Sa5VHy4Sjlcpm9g0=;
        h=From:To:Cc:Subject:Date:From;
        b=dRthrSVy7+m3MDexkgWQuT3Vs3I9ClbdWQaMvnvKfQW1RJygLNWH9bwRJDt7NKJqd
         Ir18b+twpQnOosQ0XBySzncADTWO4VgY7S97llhKN+COmJsLF73bN29INeQHKvVJQw
         eR5G7LFNauopk9xf1zXfkUIvnSvvC5LpqZ+Gl5gU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH RESEND v2] generic: test fscrypt key eviction racing with inode dirtying
Date:   Mon, 23 Mar 2020 09:40:34 -0700
Message-Id: <20200323164034.69031-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a regression test for a bug in the FS_IOC_REMOVE_ENCRYPTION_KEY
ioctl fixed by commit 2b4eae95c736 ("fscrypt: don't evict dirty inodes
after removing key").

This ioctl is also tested by generic/580 and generic/581, but they
didn't cover the case where this bug occurs.

This test detects the bug on ext4, f2fs, and ubifs.  The multi-threaded
part of the test actually still fails on ubifs even with the fix, due to
another kernel bug which I'm working on fixing.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed v1 => v2:
  - Added upstream commit ID.
  - Removed RFC tag.
  - Removed some unnecessary output suppressions.

 tests/generic/900     | 115 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  10 ++++
 tests/generic/group   |   1 +
 3 files changed, 126 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..8c8671ea
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2020 Google LLC
+#
+# FS QA Test No. 900
+#
+# Regression test for a bug in the FS_IOC_REMOVE_ENCRYPTION_KEY ioctl fixed by
+# commit 2b4eae95c736 ("fscrypt: don't evict dirty inodes after removing key").
+# This bug could cause writes to encrypted files to be lost if they raced with
+# the corresponding fscrypt master key being removed.  With f2fs, this bug could
+# also crash the kernel.
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
+	# Stop all subprocesses.
+	touch $tmp.done
+	wait
+
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_encryption -v 2
+_require_command "$KEYCTL_PROG" keyctl
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+dir=$SCRATCH_MNT/dir
+runtime=$((4 * TIME_FACTOR))
+
+# Create an encrypted directory.
+mkdir $dir
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+
+# Start with a single-threaded reproducer:
+echo -e "\n# Single-threaded reproducer"
+# Keep a fd open to a file past its fscrypt master key being removed.
+exec 3>$dir/file
+_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
+# Write to and close the open fd.
+echo contents >&3
+exec 3>&-
+# Drop any dentries which might be pinning the inode for "file".
+echo 2 > /proc/sys/vm/drop_caches
+# In buggy kernels, the inode for "file" was evicted despite the dirty data,
+# causing the dirty data to be lost.  Check whether the write made it through.
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+cat $dir/file
+rm -f $dir/file
+
+# Also run a multi-threaded reproducer.  This is included for good measure, as
+# this type of thing tends to be good for finding other bugs too.
+echo -e "\n# Multi-threaded reproducer"
+touch $dir/file
+
+# One process add/removes the encryption key repeatedly.
+(
+	while [ ! -e $tmp.done ]; do
+		_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" > /dev/null
+		_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER &> /dev/null
+	done
+) &
+
+# Another process repeatedly tries to append to the encrypted file.  The file is
+# re-opened each time, so that there are chances for the inode to be evicted.
+# Failures to open the file due to the key being removed are ignored.
+(
+	touch $tmp.expected
+	while [ ! -e $tmp.done ]; do
+		if sh -c "echo -n X >> $dir/file" 2>/dev/null; then
+			# Keep track of the expected file contents.
+			echo -n X >> $tmp.expected
+		fi
+	done
+) &
+
+# Run for a while.
+sleep $runtime
+
+# Stop all subprocesses.
+touch $tmp.done
+wait
+
+# Make sure no writes were lost.
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" > /dev/null
+stat $tmp.expected >> $seqres.full
+stat $dir/file >> $seqres.full
+cmp $tmp.expected $dir/file
+
+echo "Multi-threaded reproducer done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..14fde4c8
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,10 @@
+QA output created by 900
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Single-threaded reproducer
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, but files still busy
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+contents
+
+# Multi-threaded reproducer
+Multi-threaded reproducer done
diff --git a/tests/generic/group b/tests/generic/group
index dc95b77b..0852fc31 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 591 auto quick rw pipe splice
 592 auto quick encrypt
 593 auto quick encrypt
+900 auto quick encrypt
-- 
2.25.1.696.g5e7596f4ac-goog

