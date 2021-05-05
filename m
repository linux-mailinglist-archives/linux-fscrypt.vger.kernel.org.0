Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990973749D4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 23:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhEEVFr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 17:05:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44215 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232878AbhEEVFr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 17:05:47 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C0875C0156;
        Wed,  5 May 2021 17:04:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 05 May 2021 17:04:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=IgAeioOxlTyqRdXUnVATQBL5fk
        +20RoZlf5xSSHhEfo=; b=MeFh9KxjmNt+azfi9WLMnJ6Y5AM0LZCs8qmYV4sggO
        EUMN5IIo6zQg2uGWfecTgwPP1NIo8voRAbRu+bzCPQvaeanBcjmtY9rMrnJJ2tlz
        H/kbgSr8QwIwvP+CTOpsv6U/BEq8Ps28ClUl0rEfHev8lWHPYo4rd/oHDxqzd9kl
        XmThRULoygZqoeEmRC1zbPqjT5EG9AoKk4u7TXKztI5iD0R1X8tBbPjG4JSFAktM
        GMtwtBh3GE6zjQDJ/ornnweHSABr5dM1WuZhoa+a1y6Cv4L+rndQMXgPQT508rW/
        hDzWf1eaKRUt05zJxJi+KbHj8V4rPHyii0b1BD8t+eNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=IgAeioOxlTyqRdXUnVATQBL5fk+20RoZlf5xSSHhEfo=; b=wulrc81S
        +Z1Zy6zUiFr9HkUAkFd1iHxR5Nrq69jsTPZVEc/ybtOq962rhCqeH134rn0P8nFP
        zr6QFeqxuWgZ8Nz21kUwoLmyjHp2g0rE1D8XX5BzdQMo5zJnMCjFhuTgHBB1yV1m
        QDrLhJk/gRC6jzpBsFMKMYVHlF5i9/k2AGJhqf1HYo7Kr7vak1OisgXqcOi75gkd
        ZxdSDvdkc612DlkNe0XM9Wgaf3hqpkxSvt6/bB6z1c0++419MWCtiec88uCS226s
        JNd1RfdN6Km3uxHxWFlHKvzz8px6fk08ioqVqZi7wub9bLwRy23ected1KFP5Fdc
        AP/QbQ3WKBIWqw==
X-ME-Sender: <xms:cQiTYPJATzrbr8j6KNXI8Dg_hvFmNG1DH3VdZhBjLcIjONSfJjWuJg>
    <xme:cQiTYDIvJguxelfmhnelqj-efKcxB5YXEjoK_xxo6_wCDzEqRUcH6wZkv9wGGAXNc
    bqVHrkzz6vFqKE9Nrc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:cQiTYHtcIeNHq3pBCN9ERtFHMzB48yLg-wcpqKRI-dPabH_8akuxOw>
    <xmx:cQiTYIZOkt7EYySCVvzmnisYDZ5L9DL3Fca0pw87TSZEsxJdBM2IaA>
    <xmx:cQiTYGaXowqdZMBMoVzluTXBfJmcgh1_VG6cMP7Gk5LRNYDIeCcQMg>
    <xmx:cQiTYJxkVj7O8aCLvrgtol-jGRv_KCB9HDYOmIXv-5ssG_hdQBghPw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 17:04:49 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 1/4] btrfs: test btrfs specific fsverity corruption
Date:   Wed,  5 May 2021 14:04:43 -0700
Message-Id: <39a5e3f106db214a2d6416c7fda242c445cc6e53.1620248200.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620248200.git.boris@bur.io>
References: <cover.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

There are some btrfs specific fsverity scenarios that don't map
neatly onto the tests in generic/574 like holes, inline extents,
and preallocated extents. Cover those in a btrfs specific test.

This test relies on the btrfs implementation of fsverity in the patches
titled:
btrfs: initial fsverity support
btrfs: check verity for reads of inline extents and holes

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/btrfs        |   5 ++
 common/config       |   1 +
 common/verity       |   7 ++
 tests/btrfs/290     | 180 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  25 ++++++
 tests/btrfs/group   |   1 +
 6 files changed, 219 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

diff --git a/common/btrfs b/common/btrfs
index ebe6ce26..bd6e87ce 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -419,3 +419,8 @@ _btrfs_rescan_devices()
 {
 	$BTRFS_UTIL_PROG device scan &> /dev/null
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block
+}
diff --git a/common/config b/common/config
index a47e462c..003b2a88 100644
--- a/common/config
+++ b/common/config
@@ -256,6 +256,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index 38eea157..d2c1ea24 100644
--- a/common/verity
+++ b/common/verity
@@ -8,6 +8,10 @@ _require_scratch_verity()
 	_require_scratch
 	_require_command "$FSVERITY_PROG" fsverity
 
+	if [ $FSTYP == "btrfs" ]; then
+		_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block
+	fi
+
 	if ! _scratch_mkfs_verity &>>$seqres.full; then
 		# ext4: need e2fsprogs v1.44.5 or later (but actually v1.45.2+
 		#       is needed for some tests to pass, due to an e2fsck bug)
@@ -147,6 +151,9 @@ _scratch_mkfs_verity()
 	ext4|f2fs)
 		_scratch_mkfs -O verity
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
diff --git a/tests/btrfs/290 b/tests/btrfs/290
new file mode 100755
index 00000000..26939833
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,180 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
+#
+# FS QA Test 290
+#
+# Test btrfs support for fsverity.
+# This test extends the generic fsverity testing by corrupting inline extents,
+# preallocated extents, holes, and the Merkle descriptor in a btrfs-aware way.
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+_supported_fs btrfs
+_require_scratch_verity
+_require_scratch_nocheck
+_require_odirect
+_require_btrfs_corrupt_block
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+get_ino() {
+	local file=$1
+	stat -c "%i" $file
+}
+
+validate() {
+	local f=$1
+	local sz=$(_get_filesize $f)
+	# buffered io
+	echo $(basename $f)
+	$XFS_IO_PROG -rc "pread -q 0 $sz" $f 2>&1 | _filter_scratch
+	# direct io
+	$XFS_IO_PROG -rdc "pread -q 0 $sz" $f 2>&1 | _filter_scratch
+}
+
+# corrupt the data portion of an inline extent
+corrupt_inline() {
+	local f=$SCRATCH_MNT/inl
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 42" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	# inline data starts at disk_bytenr
+	# overwrite the first u64 with random bogus junk
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f disk_bytenr $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# preallocate a file, then corrupt it by changing it to a regular file
+corrupt_prealloc_to_reg() {
+	local f=$SCRATCH_MNT/prealloc
+	$XFS_IO_PROG -fc "falloc 0 12k" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	# set extent type from prealloc (2) to reg (1)
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 1 $SCRATCH_DEV >/dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# corrupt a regular file by changing the type to preallocated
+corrupt_reg_to_prealloc() {
+	local f=$SCRATCH_MNT/reg
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	# set type from reg (1) to prealloc (2)
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 2 $SCRATCH_DEV >/dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# corrupt a file by punching a hole
+corrupt_punch_hole() {
+	local f=$SCRATCH_MNT/punch
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	# make a new extent in the middle, sync so the writes don't coalesce
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	$XFS_IO_PROG -fc "pwrite -q -S 0x59 4096 4096" $f
+	_fsv_enable $f
+	_scratch_unmount
+	# change disk_bytenr to 0, representing a hole
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 0 $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# plug hole
+corrupt_plug_hole() {
+	local f=$SCRATCH_MNT/plug
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	$XFS_IO_PROG -fc "falloc 4k 4k" $f
+	_fsv_enable $f
+	_scratch_unmount
+	# change disk_bytenr to some value, plugging the hole
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 13639680 $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# corrupt the fsverity descriptor item indiscriminately (causes EINVAL)
+corrupt_verity_descriptor() {
+	local f=$SCRATCH_MNT/desc
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	# key for the descriptor item is <inode, BTRFS_VERITY_DESC_ITEM_KEY, 1>,
+	# 88 is X. So we write 5 Xs to the start of the descriptor
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 0 -b 5 $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# specifically target the root hash in the descriptor (causes EIO)
+corrupt_root_hash() {
+	local f=$SCRATCH_MNT/roothash
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 16 -b 1 $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# corrupt the Merkle tree data itself
+corrupt_merkle_tree() {
+	local f=$SCRATCH_MNT/merkle
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
+	local ino=$(get_ino $f)
+	_fsv_enable $f
+	_scratch_unmount
+	# key for the descriptor item is <inode, BTRFS_VERITY_MERKLE_ITEM_KEY, 0>,
+	# 88 is X. So we write 5 Xs to somewhere in the middle of the first
+	# merkle item
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v 88 -o 100 -b 5 $SCRATCH_DEV > /dev/null 2>&1
+	_scratch_mount
+	validate $f
+}
+
+# real QA test starts here
+_scratch_mkfs >/dev/null
+_scratch_mount
+
+corrupt_inline
+corrupt_prealloc_to_reg
+corrupt_reg_to_prealloc
+corrupt_punch_hole
+corrupt_plug_hole
+corrupt_verity_descriptor
+corrupt_root_hash
+corrupt_merkle_tree
+
+status=0
+exit
diff --git a/tests/btrfs/290.out b/tests/btrfs/290.out
new file mode 100644
index 00000000..056b114b
--- /dev/null
+++ b/tests/btrfs/290.out
@@ -0,0 +1,25 @@
+QA output created by 290
+inl
+pread: Input/output error
+pread: Input/output error
+prealloc
+pread: Input/output error
+pread: Input/output error
+reg
+pread: Input/output error
+pread: Input/output error
+punch
+pread: Input/output error
+pread: Input/output error
+plug
+pread: Input/output error
+pread: Input/output error
+desc
+SCRATCH_MNT/desc: Invalid argument
+SCRATCH_MNT/desc: Invalid argument
+roothash
+pread: Input/output error
+pread: Input/output error
+merkle
+pread: Input/output error
+pread: Input/output error
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 331dd432..13051562 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -238,3 +238,4 @@
 233 auto quick subvolume
 234 auto quick compress rw
 235 auto quick send
+290 auto quick verity
-- 
2.30.2

