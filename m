Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DF1358D15
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhDHS6G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:58:06 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58711 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232950AbhDHS6G (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:58:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 5435610DD;
        Thu,  8 Apr 2021 14:57:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=voRJ6ryxRIGj8Kjs4Jzl3xnWaq
        gIsk7zuvLZpA5e/+o=; b=Zb5949C0y+u30Bt1tn6WpmvbDJeudNHEBv8en4bNWW
        HtUwYSM6MmQEnAYwPrBLdyTQp6aXafA8wq9m+xqojUN/9eKdHUweBaBLKC6x65T0
        QxVI8/dZ7FiF9BmwtFFszDkqay+C/aCIiovxnIf5pSOfE12xwxNPlc+aP1ZZhxzD
        xNZZoTc7eoZAT7UaBt75mw+UBWly/U9tPpFntGc5eyU/iEkLGkr+K9EO4A+yrEP3
        gotIOWzPBib7PIOh27Ak+QWXa0lwGmki0rL4Y7D2YBf1ZvgcAAH7XbG8ipxV1PTh
        o+yClb3AzeGFDTFuBtnAzIwL7NY3nmZz+EqJe/ZOcLMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=voRJ6ryxRIGj8Kjs4Jzl3xnWaqgIsk7zuvLZpA5e/+o=; b=pa8n5uJz
        Kz9EJNKpA92WbIwT6txYq7MXvb8MbT2pTzkX04ZkdW5GhMFrBymQi9RcnQEbyDlI
        z7A0a1JYJ4LYgYdL5BxAYCzLwgGhQRbRn0IptNmbcFZRyMv5EbD+Nwr6CRCPqZTM
        uqggyleYTFz5OQTmulQazOk9Bqb7oOJsiUb7z51GHce2gfQEcfrEaB5PPiveMF4d
        17xpOrF0+f5lYHcjaQtSXEZv9boL2Xxt/wJ3HLwdhrMb9zUGQbxzJPf7vnMqjx6Q
        AOZ09Y1uF7NuMiDfqF1wVDha0kBbnzPFzKTWHVhQqX11slUsXOw+spRP9JErqAtD
        3cjKu9OsYAmQfw==
X-ME-Sender: <xms:MVJvYNiI0if7fuVGH7v1zj5YGFc2DPVt2fKg0COZHzdG4jECjWMPTw>
    <xme:MVJvYCBwrNp0MlnZP7lDrJV_mYnEVxuwYh6ht4oG3DUMlnvDiyr1e1HUP1sdUFmOw
    I91x99tLIJwsLsshwE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:MVJvYNHVCB0vmaVTDAQXUF5OmP5JOu4Vcb8Ajqp2GZ2ps7Kwn7BPpQ>
    <xmx:MVJvYCQ8bOxLzjBQjZAAOizwqFqFI_nFnhP_34PFRCKLQnBvC4-J-Q>
    <xmx:MVJvYKy3kc3BBZ2GADlhHjGOxKuY2fEIbQk5j8RyzvPYemw33nUggg>
    <xmx:MVJvYPon2dtkf_B7WZj5JO0TqkJbDTI33meL-6GIdsy21_UaPfuDdw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id A6C55240057;
        Thu,  8 Apr 2021 14:57:53 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 1/3] btrfs: test btrfs specific fsverity corruption
Date:   Thu,  8 Apr 2021 11:57:49 -0700
Message-Id: <6e3759825cd0134186b0d6eb8825a4ba3ed62b70.1617908086.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617908086.git.boris@bur.io>
References: <cover.1617908086.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

There are some btrfs specific fsverity scenarios that don't map
neatly onto the tests in generic/574 like holes, inline extents,
and preallocated extents. Cover those in a btrfs specific test.

This test relies on the btrfs implementation of fsverity in:
<kernel patches>
and it relies on btrfs-corrupt-block for corruption, with the patches:
<corrupt block patches>

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/config       |   1 +
 common/verity       |   7 ++
 tests/btrfs/290     | 190 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  17 ++++
 tests/btrfs/group   |   1 +
 5 files changed, 216 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

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
index 00000000..5aff7648
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,190 @@
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
+trap "cleanup; exit \$status" 0 1 2 3 15
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
+_require_scratch
+_require_scratch_verity
+
+cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+get_ino() {
+	file=$1
+	ls -i $file | awk '{print $1}'
+}
+
+validate() {
+	f=$1
+	sz=$2
+	# buffered io
+	cat $f > /dev/null
+	# direct io
+	dd if=$f iflag=direct of=/dev/null status=none
+}
+
+# corrupt the data portion of an inline extent
+corrupt_inline() {
+	f=$SCRATCH_MNT/inl
+	head -c 42 /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# inline data starts at disk_bytenr
+	# overwrite the first u64 with random bogus junk
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f disk_bytenr $SCRATCH_DEV > /dev/null
+	_scratch_mount
+	validate $f
+}
+
+# preallocate a file, then corrupt it by changing it to a regular file
+corrupt_prealloc_to_reg() {
+	f=$SCRATCH_MNT/prealloc
+	fallocate -l 4k $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# set extent type from prealloc (2) to reg (1)
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 1 $SCRATCH_DEV 2>/dev/null >/dev/null
+	_scratch_mount
+	validate $f
+}
+
+# corrupt a regular file by changing the type to preallocated
+corrupt_reg_to_prealloc() {
+	f=$SCRATCH_MNT/reg
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# set type from reg (1) to prealloc (2)
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 2 $SCRATCH_DEV 2>/dev/null >/dev/null
+	_scratch_mount
+	validate $f
+}
+
+# corrupt a file by punching a hole
+corrupt_punch_hole() {
+	f=$SCRATCH_MNT/punch
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	# make a new extent in the middle
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	head -c 4k /dev/zero | tr '\0' Y | dd of=$f bs=4k count=1 seek=1 conv=notrunc 2>/dev/null
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# change disk_bytenr to 0, representing a hole
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 0 $SCRATCH_DEV > /dev/null
+	_scratch_mount
+	validate $f
+}
+
+# plug hole
+corrupt_plug_hole() {
+	f=$SCRATCH_MNT/plug
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	fallocate -p -o 4k -l 4k $f
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# change disk_bytenr to some value, plugging the hole
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 13639680 $SCRATCH_DEV > /dev/null
+	_scratch_mount
+	validate $f
+}
+
+# corrupt the fsverity descriptor item indiscriminately (causes EINVAL)
+corrupt_verity_descriptor() {
+	f=$SCRATCH_MNT/desc
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# key for the descriptor item is <inode, BTRFS_VERITY_DESC_ITEM_KEY, 1>,
+	# 88 is X. So we write 5 Xs to the start of the descriptor
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 0 -b 5 $SCRATCH_DEV > /dev/null
+	_scratch_mount
+	validate $f
+}
+
+# specifically target the root hash in the descriptor (causes EIO)
+corrupt_root_hash() {
+	f=$SCRATCH_MNT/roothash
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 16 -b 1 $SCRATCH_DEV >> $seqres.full
+	#$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,0 -v 88 -o 120 -b 5 $SCRATCH_DEV > /dev/null
+	_scratch_mount
+	validate $f
+}
+
+# corrupt the Merkle tree data itself
+corrupt_merkle_tree() {
+	f=$SCRATCH_MNT/merkle
+	head -c 12k /dev/zero | tr '\0' X > $f
+	ino=$(get_ino $f)
+	_fsv_enable $f
+	$XFS_IO_PROG -c sync $SCRATCH_MNT
+	_scratch_unmount
+	# key for the descriptor item is <inode, BTRFS_VERITY_MERKLE_ITEM_KEY, 0>,
+	# 88 is X. So we write 5 Xs to somewhere in the middle of the first
+	# merkle item
+	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v 88 -o 100 -b 5 $SCRATCH_DEV > /dev/null
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
+# we intentionally corrupted, re-mkfs to avoid tripping the corrupted fs error
+_scratch_unmount
+_scratch_mkfs >/dev/null
+
+status=0
+exit
diff --git a/tests/btrfs/290.out b/tests/btrfs/290.out
new file mode 100644
index 00000000..4da61246
--- /dev/null
+++ b/tests/btrfs/290.out
@@ -0,0 +1,17 @@
+QA output created by 290
+cat: /mnt/scratch/inl: Input/output error
+dd: error reading '/mnt/scratch/inl': Input/output error
+cat: /mnt/scratch/prealloc: Input/output error
+dd: error reading '/mnt/scratch/prealloc': Input/output error
+cat: /mnt/scratch/reg: Input/output error
+dd: error reading '/mnt/scratch/reg': Input/output error
+cat: /mnt/scratch/punch: Input/output error
+dd: error reading '/mnt/scratch/punch': Input/output error
+cat: /mnt/scratch/plug: Input/output error
+dd: error reading '/mnt/scratch/plug': Input/output error
+cat: /mnt/scratch/desc: Invalid argument
+dd: failed to open '/mnt/scratch/desc': Invalid argument
+cat: /mnt/scratch/roothash: Input/output error
+dd: error reading '/mnt/scratch/roothash': Input/output error
+cat: /mnt/scratch/merkle: Input/output error
+dd: error reading '/mnt/scratch/merkle': Input/output error
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

