Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5073246F4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Feb 2021 23:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhBXWhg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 17:37:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235410AbhBXWhe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 17:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A98164F0C;
        Wed, 24 Feb 2021 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614206212;
        bh=9ROxyYh/MaXaAATrXRoOGh96fFZi/DSrU+oJAe7xnWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bwsSO123i5Z1ZAZViq6fRPmtCTxnc0Xbiv2Au3Tx+fUdSzIY2oZdmACyug3yMP+bm
         +UlNt9E5SwjOnbT/nfWW50CP2i1r5bt2xylIrw0pcijnp+nwJCu7Yc+DCsch1euz04
         GwbUI3m9KSzqgaKSh3GypCuWT7LLIfDSfZCwyGmxW+/Q9jWhTE7YxQhvfatACCuTw0
         cZg+0RoYko71rX/z1UDHPoZUPBLpAHc/qAiYzwXxBMIfHBqgviJxXDzvw9/+0K9QB4
         wewg8LJpkS5/TAi0ttZ8RDzBO754ygpeT95rWINH65KdrCBZyX4csQrGTeIrxAFOK/
         Lwg6eZiAAsZsg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v2 3/4] generic: test retrieving verity Merkle tree and descriptor
Date:   Wed, 24 Feb 2021 14:35:36 -0800
Message-Id: <20210224223537.110491-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224223537.110491-1-ebiggers@kernel.org>
References: <20210224223537.110491-1-ebiggers@kernel.org>
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
index b10fdea4..3cc40795 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -625,3 +625,4 @@
 620 auto mount quick
 621 auto quick encrypt
 622 auto shutdown metadata atime
+901 auto quick verity
-- 
2.30.1

