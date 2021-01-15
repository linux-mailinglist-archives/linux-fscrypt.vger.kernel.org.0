Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641F12F846E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 19:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbhAOSbC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 13:31:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387490AbhAOSbB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 13:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9833323A5A;
        Fri, 15 Jan 2021 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610735420;
        bh=Zq2xXRGPcF0MfdALNvMGtqIAAiivpPFH6hP0tdwW7I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vttam1w8/dE7Z0WFpoIDGXwY85jSAMLMfj/Ym60CHZwY2QyTJC5wP2arZl3oCfiqP
         TS7wk92uNSwc9j4O9+vVBP0TirvWOYQbR/cX3JqYora8gn16T+uThhgfLKZ8cLVVWR
         zBgw+z1+6dUcMtPn0qqYvBeBhT21uwqTbXUOr0b/V8dvkIQm62QMdpi9OOTxsfD96X
         N8F55CUKJrMUIV2Jv7oTxqyV+le0oxQdspVj4XRzcA/9S0lS7H1Zk7FacEEpzWB2VG
         Volu1d1UNRSRSiFz8N8p3VRC7sxbOLZl/M+OI+uQv2w3wzLM9/NlUPuvOdwbhizfMe
         JJBl+GveuOV9Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [xfstests RFC PATCH 3/4] generic: test retrieving verity Merkle tree and descriptor
Date:   Fri, 15 Jan 2021 10:28:36 -0800
Message-Id: <20210115182837.36333-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115182837.36333-1-ebiggers@kernel.org>
References: <20210115182837.36333-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a test which tests retrieving the Merkle tree and fs-verity
descriptor of a verity file using the new FS_IOC_READ_VERITY_METADATA
ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/901     | 79 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out | 16 +++++++++
 tests/generic/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100755
index 00000000..24889d63
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright 2021 Google LLC
+#
+# FS QA Test No. 901
+#
+# Test retrieving the Merkle tree and fs-verity descriptor of a verity file
+# using FS_IOC_READ_VERITY_METADATA.
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
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+rm -f $seqres.full
+
+_supported_fs generic
+_require_scratch_verity
+_disable_fsverity_signatures
+# For the output of this test to always be the same, it has to use a specific
+# Merkle tree block size.
+if [ $FSV_BLOCK_SIZE != 4096 ]; then
+	_notrun "4096-byte verity block size not supported on this platform"
+fi
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+echo -e "\n# Creating a verity file"
+fsv_file=$SCRATCH_MNT/file
+# Always use the same file contents, so that the output of the test is always
+# the same.  Also use a file that is large enough to have multiple Merkle tree
+# levels, so that the test verifies that the blocks are returned in the expected
+# order.  A 1 MB file with SHA-256 and a Merkle tree block size of 4096 will
+# have 3 Merkle tree blocks (3*4096 bytes): two at level 0 and one at level 1.
+head -c 1000000 /dev/zero > $fsv_file
+merkle_tree_size=$((3 * FSV_BLOCK_SIZE))
+fsverity_descriptor_size=256
+_fsv_enable $fsv_file --salt=abcd
+_require_fsverity_dump_metadata $fsv_file
+_fsv_measure $fsv_file
+
+echo -e "\n# Dumping Merkle tree"
+_fsv_dump_merkle_tree $fsv_file | sha256sum
+
+echo -e "\n# Dumping Merkle tree (in chunks)"
+# The above test may get the whole tree in one read, so also try reading it in
+# chunks.
+for (( i = 0; i < merkle_tree_size; i += 997 )); do
+	_fsv_dump_merkle_tree $fsv_file --offset=$i --length=997
+done | sha256sum
+
+echo -e "\n# Dumping descriptor"
+# Note that the hash that is printed here should be the same hash that was
+# printed by _fsv_measure above.
+_fsv_dump_descriptor $fsv_file | sha256sum
+
+echo -e "\n# Dumping descriptor (in chunks)"
+for (( i = 0; i < fsverity_descriptor_size; i += 13 )); do
+	_fsv_dump_descriptor $fsv_file --offset=$i --length=13
+done | sha256sum
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 00000000..ab018052
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,16 @@
+QA output created by 901
+
+# Creating a verity file
+sha256:11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73
+
+# Dumping Merkle tree
+db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
+
+# Dumping Merkle tree (in chunks)
+db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
+
+# Dumping descriptor
+11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
+
+# Dumping descriptor (in chunks)
+11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
diff --git a/tests/generic/group b/tests/generic/group
index 30a73605..3f2edfc0 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -624,3 +624,4 @@
 619 auto rw enospc
 620 auto mount quick
 621 auto quick encrypt
+901 auto quick verity
-- 
2.30.0

