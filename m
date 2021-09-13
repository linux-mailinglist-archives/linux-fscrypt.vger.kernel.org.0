Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE64E409C75
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 20:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhIMSp7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:45:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34503 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237448AbhIMSp6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:45:58 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C03865C01D8;
        Mon, 13 Sep 2021 14:44:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 13 Sep 2021 14:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=0OIOzk6s5MrQF1Iv4mbmIk0G4M
        J+cYgAn2S09CEPYHw=; b=tqGwTzul28UORo0QS3NJP6E2cixG/GmKA0FD/T/BdD
        fuTpIlQ6J4K8mq48JuKbu/JmjEt1i5M2vEQoJ1Yh2xnSQQJXl0hZeVb6oQx7DYCN
        NdNJgmR/ya6mLGiZy4wz2TkM0PrVrHjQ0IxkNdbpmb/AihzthEGGFXZX7QVe2iw9
        Qgi+nB/wma8Zk6icVW6haEYNjeCg25xymc0NDWQ1ijs9+TQI0crErhqN9deN4fA6
        1kA+sd9d4o2H/mZRlhPBSZ861rRoK/tKny+oq49VS5igAjelHCAU2QGXfjWr+G//
        MjIuB725BM/X6wSNLhndS1T1oCKmnlfGM4NR9qUEdULA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0OIOzk6s5MrQF1Iv4mbmIk0G4MJ+cYgAn2S09CEPYHw=; b=FmO2D1C/
        6TxxCUMmfEruEfnPzBJWsrSd8JP7nPBkuID/EToknFxOTU12rB5/gQrJB1B85ULu
        YUXxxW63aQekjVP3oML5A7d37MuebzPrmdqMaVtSASyw4vA95baIJ4xig4eTcSQv
        sg4pBxjS7YSV+Pk7qIjziSAYYixQ5RXyaVejWzV4x0oCkBN2m7k8ivQVwDJTdADk
        dVh16li954ljJ5A5vcFoCXKevzgGaTc/6JwsNi+HKoxkk6K7Gj63ISlGlxZr7JNR
        pvum5YY8NAe+DePqajLZZDj8ZuxyNVtn1MCoaSiFVU+VMD1MrmHp+tX5Ih64Kw7a
        HWcSPD0QvO0/vQ==
X-ME-Sender: <xms:GZw_YewxJxSSJYY74iMp25hzOA_dgfVyfu3LwxWhUtUTlJ18tdc2qQ>
    <xme:GZw_YaRlEMEztxxptxqVS_oNGksT9z5_eQEYhRseNVkVCN9AK0jGOK3j9v7jhxfFn
    MyCQhyfCXH04G3P4tU>
X-ME-Received: <xmr:GZw_YQX33NFGPAmic1bfXJnPZIKXzGW3OAhvNHxNRjQE1wIahP8DpKIfZdd9C1Aj5YZyiTKWH1-pIB9_nR_joyU9HwIy-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:GZw_YUgXgzTD2XnrFbZWxXX8iUz0MsqWRloiPaTqVagWaZvhppKzlg>
    <xmx:GZw_YQBeX0Wsrp-6CqN7LgFx8PoqfPxBhz5lLu0KkjivTVwDrjiDGQ>
    <xmx:GZw_YVKi9WBUDBOaemAIu7rTnPza8H0fBevBZZhhT2FnNckaV9YBaQ>
    <xmx:GZw_YTMreH8yzzZoMQ77GIrVolSSbiJM0tGduDjUbquEtS6jOJMijw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 14:44:41 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 1/4] btrfs: test btrfs specific fsverity corruption
Date:   Mon, 13 Sep 2021 11:44:34 -0700
Message-Id: <b8b1aa031b1e2bbf97085ddaa77c1e3f120bdc28.1631558495.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631558495.git.boris@bur.io>
References: <cover.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

There are some btrfs specific fsverity scenarios that don't map
neatly onto the tests in generic/574 like holes, inline extents,
and preallocated extents. Cover those in a btrfs specific test.

This test relies on the btrfs implementation of fsverity in the patch:
btrfs: initial fsverity support

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/btrfs        |   5 ++
 common/config       |   1 +
 common/verity       |   9 +++
 tests/btrfs/290     | 165 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  25 +++++++
 5 files changed, 205 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

diff --git a/common/btrfs b/common/btrfs
index ac880bdd..45f07b1d 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -445,3 +445,8 @@ _scratch_btrfs_is_zoned()
 	[ `_zone_type ${SCRATCH_DEV}` != "none" ] && return 0
 	return 1
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
+}
diff --git a/common/config b/common/config
index 164381b7..fa061958 100644
--- a/common/config
+++ b/common/config
@@ -294,6 +294,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index 38eea157..7eb8d9b9 100644
--- a/common/verity
+++ b/common/verity
@@ -3,11 +3,17 @@
 #
 # Functions for setting up and testing fs-verity
 
+. common/btrfs
+
 _require_scratch_verity()
 {
 	_require_scratch
 	_require_command "$FSVERITY_PROG" fsverity
 
+	if [ $FSTYP == "btrfs" ]; then
+		_require_btrfs_corrupt_block
+	fi
+
 	if ! _scratch_mkfs_verity &>>$seqres.full; then
 		# ext4: need e2fsprogs v1.44.5 or later (but actually v1.45.2+
 		#       is needed for some tests to pass, due to an e2fsck bug)
@@ -147,6 +153,9 @@ _scratch_mkfs_verity()
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
index 00000000..52dc1784
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,165 @@
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
+. ./common/preamble
+_begin_fstest auto quick verity
+
+# Import common functions.
+. ./common/filter
+. ./common/verity
+
+# real QA test starts here
+_supported_fs btrfs
+_require_scratch_verity
+_require_scratch_nocheck
+_require_odirect
+_require_xfs_io_command "falloc"
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
-- 
2.33.0

