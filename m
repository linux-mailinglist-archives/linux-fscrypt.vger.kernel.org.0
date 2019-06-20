Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92644DCBD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 23:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFTVik (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 17:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfFTVij (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 17:38:39 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD29820B1F;
        Thu, 20 Jun 2019 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066719;
        bh=d27p70Gr0QEAejavj4m8KjtHSwoT83LH9uhHi+Iuvmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhj3bYfZOl448KVcMoiYVX4H+lxzjWdO1NvnxLgW1UhgvdhtKr4YYli2lj0vt7vF+
         vhrGZWOTzYW+H+4O0/2w+J/ftirIAiZzZYsqMDNoZhKQJQmMDdqn97NsnKjkECKh9l
         IFPEwTK+6Iug/tSEFZPNWqMB3lPD5QWoOeZRaXR4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v2 5/8] generic: test corrupting verity files
Date:   Thu, 20 Jun 2019 14:36:11 -0700
Message-Id: <20190620213614.113685-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620213614.113685-1-ebiggers@kernel.org>
References: <20190620213614.113685-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This test corrupts various parts of the contents of a verity file, or
parts of its Merkle tree, by writing directly to the block device.  It
verifies that this causes I/O errors when the relevant part of the
contents is later read by any means.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/902     | 154 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/902.out |  91 +++++++++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 246 insertions(+)
 create mode 100755 tests/generic/902
 create mode 100644 tests/generic/902.out

diff --git a/tests/generic/902 b/tests/generic/902
new file mode 100755
index 00000000..5ef2cca1
--- /dev/null
+++ b/tests/generic/902
@@ -0,0 +1,154 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2018 Google LLC
+#
+# FS QA Test generic/902
+#
+# Test corrupting verity files.  This test corrupts various parts of the
+# contents of a verity file, or parts of its Merkle tree, by writing directly to
+# the block device.  It verifies that this causes I/O errors when the relevant
+# part of the contents is later read by any means.
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
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_verity
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+fsv_orig_file=$SCRATCH_MNT/file
+fsv_file=$SCRATCH_MNT/file.fsv
+
+setup_zeroed_file()
+{
+	local len=$1
+	local sparse=$2
+
+	if $sparse; then
+		dd if=/dev/zero of=$fsv_orig_file bs=1 count=0 seek=$len \
+			status=none
+	else
+		head -c $len /dev/zero > $fsv_orig_file
+	fi
+	cp $fsv_orig_file $fsv_file
+	_fsv_enable $fsv_file
+	md5sum $fsv_file |& _filter_scratch
+}
+
+filter_sigbus()
+{
+	sed -e 's/.*Bus error.*/Bus error/'
+}
+
+round_up_to_page_boundary()
+{
+	local n=$1
+	local page_size=$(get_page_size)
+
+	echo $(( (n + page_size - 1) & ~(page_size - 1) ))
+}
+
+corruption_test()
+{
+	local file_len=$1
+	local zap_offset=$2
+	local zap_len=$3
+	local is_merkle_tree=${4:-false} # if true, zap tree instead of data
+	local use_sparse_file=${5:-false}
+	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
+	local measurement
+
+	if $is_merkle_tree; then
+		local corrupt_func=_fsv_scratch_corrupt_merkle_tree
+	else
+		local corrupt_func=_fsv_scratch_corrupt_bytes
+	fi
+
+	local msg="Corruption test:"
+	msg+=" file_len=$file_len"
+	if $use_sparse_file; then
+		msg+=" (sparse)"
+	fi
+	msg+=" zap_offset=$zap_offset"
+	if $is_merkle_tree; then
+		msg+=" (in Merkle tree)"
+	fi
+	msg+=" zap_len=$zap_len"
+
+	_fsv_scratch_begin_subtest "$msg"
+	setup_zeroed_file $file_len $use_sparse_file
+	cmp $fsv_file $fsv_orig_file
+	echo "Corrupting bytes..."
+	head -c $zap_len /dev/zero | tr '\0' X \
+		| $corrupt_func $fsv_file $zap_offset
+
+	echo "Validating corruption (reading full file)..."
+	_scratch_cycle_mount
+	md5sum $fsv_file |& _filter_scratch
+
+	echo "Validating corruption (direct I/O)..."
+	_scratch_cycle_mount
+	dd if=$fsv_file bs=$FSV_BLOCK_SIZE iflag=direct status=none \
+		of=/dev/null |& _filter_scratch
+
+	if ! $is_merkle_tree; then
+		echo "Validating corruption (reading just corrupted part)..."
+		dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
+			of=/dev/null status=none |& _filter_scratch
+	fi
+
+	echo "Validating corruption (reading full file via mmap)..."
+	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
+		-c 'mmap -r 0 $page_aligned_eof' \
+		-c 'mread 0 $file_len'" |& filter_sigbus
+
+	if ! $is_merkle_tree; then
+		echo "Validating corruption (reading just corrupted part via mmap)..."
+		bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
+			-c 'mmap -r 0 $page_aligned_eof' \
+			-c 'mread $zap_offset $zap_len'" |& filter_sigbus
+	fi
+}
+
+corruption_test 131072 0 1
+corruption_test 131072 4095 1
+corruption_test 131072 65536 65536
+corruption_test 131072 131071 1
+
+# Non-zeroed bytes in the final partial block beyond EOF should cause reads to
+# fail too.  Such bytes would be visible via mmap().
+corruption_test 130999 131000 72
+
+# Merkle tree corruption.
+corruption_test 200000 100 10 true
+
+# Sparse file.  Corrupting the Merkle tree should still cause reads to fail,
+# i.e. the filesystem must verify holes.
+corruption_test 200000 100 10 true true
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/902.out b/tests/generic/902.out
new file mode 100644
index 00000000..15fe691e
--- /dev/null
+++ b/tests/generic/902.out
@@ -0,0 +1,91 @@
+QA output created by 902
+
+# Corruption test: file_len=131072 zap_offset=0 zap_len=1
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading just corrupted part)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+Validating corruption (reading just corrupted part via mmap)...
+Bus error
+
+# Corruption test: file_len=131072 zap_offset=4095 zap_len=1
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading just corrupted part)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+Validating corruption (reading just corrupted part via mmap)...
+Bus error
+
+# Corruption test: file_len=131072 zap_offset=65536 zap_len=65536
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading just corrupted part)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+Validating corruption (reading just corrupted part via mmap)...
+Bus error
+
+# Corruption test: file_len=131072 zap_offset=131071 zap_len=1
+0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading just corrupted part)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+Validating corruption (reading just corrupted part via mmap)...
+Bus error
+
+# Corruption test: file_len=130999 zap_offset=131000 zap_len=72
+f5cca0d7fbb8b02bc6118a9954d5d306  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading just corrupted part)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+Validating corruption (reading just corrupted part via mmap)...
+Bus error
+
+# Corruption test: file_len=200000 zap_offset=100 (in Merkle tree) zap_len=10
+4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
+
+# Corruption test: file_len=200000 (sparse) zap_offset=100 (in Merkle tree) zap_len=10
+4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
+Corrupting bytes...
+Validating corruption (reading full file)...
+md5sum: SCRATCH_MNT/file.fsv: Input/output error
+Validating corruption (direct I/O)...
+dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
+Validating corruption (reading full file via mmap)...
+Bus error
diff --git a/tests/generic/group b/tests/generic/group
index 003fbff4..ffdc7640 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -561,3 +561,4 @@
 556 auto quick casefold
 900 auto quick verity
 901 auto quick verity
+902 auto quick verity
-- 
2.22.0.410.gd8fdbe21b5-goog

