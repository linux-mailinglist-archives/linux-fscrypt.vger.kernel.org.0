Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29173409C7B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 20:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbhIMSqC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:46:02 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44149 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237448AbhIMSqB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:46:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 45E495C01D9;
        Mon, 13 Sep 2021 14:44:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 13 Sep 2021 14:44:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=SkAMvbQhMyrbVqmTjHcW7LgdLo
        GKXEn1a1dVDndxhKA=; b=YT6ueGu6eopj9w++8lvam886FJPW3d76qxgPv5HASC
        4aiB8cUhvj4/3bAD7xVnxJUUfxkCBxiL1ggR9eUEelI50RSCs7swdBIlyrKJhYN2
        OZSOQ6Wzg/QTbddedRAaKoX+Gosj1498/ezL8hgLXmMc+LxbGsH+oeMdCnEwAqEN
        43xTlWpAgcgArEPVzPIwc3VcwXuVf9/3QWqNkjPgSpb1y6GQtp68G8Shi/VnHuhb
        +xuFrBbYiO9GEolaQWY+AIk0YNyo8LMmPhDUCi3DreOHLnntjwqDZRuHDUxoXzCX
        BOgzHfvy3UAcPLg2T28wkcmJ5zdw16Kzo5JU4vOWInTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=SkAMvbQhMyrbVqmTjHcW7LgdLoGKXEn1a1dVDndxhKA=; b=tUwTb1iq
        i37FYnUQboEkbecnVLobjhCmSayE85TfkiB++1uQX8wvvKq4awjJaDyHTm/ITTTN
        uq8ZpnIXBZZiO+6/so9wh4nXTPuaUbfQwt0o435ueVg14jBYXN6DTUkh6nwFUE7F
        NTvb2dMpI/PuutZzH7xsrZ6G/szgE+g8HCUVz5FMmeA0qp6OxrCe7boiwq+TVQ/a
        rW/Y8FXUoZNwefkh+KWyLVlcvrQx6NvxlEv2kZA6Z5akcEebQ0/fsT98aFXwR1M5
        dT+DXlaUkbOUvL4vEYscq0MWek4ZkvmHw1xUgskZes3TlMKsv7ieL8qMKX0PnPmn
        jzN+A7PTVZpgwg==
X-ME-Sender: <xms:HZw_YV9fkK0_rQNHSIFo-9WNVl2pQ6EwoHpOvMiNDDNZFiaSD-yosQ>
    <xme:HZw_YZsRsjF4cjAEUqMupAKwNScWC7rSTqMPb6-wggSXQ3_TornIMacGUmaoL4IZZ
    WPJYHhhij7DkzlxuQE>
X-ME-Received: <xmr:HZw_YTAZ58BiNtZFGJb1jHogHZidJxcDXVyuhRx3kg0W33-PiqecgBjBqkwetR2vjEGv976GYjUaTbdeLGfKhvXn4PzjCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:HZw_YZdFKuCyX-JiJZK2tsRxN9dDPlYWPDRsUm8WmOE2HCxFN3Nv0A>
    <xmx:HZw_YaMP_cGK2eW2KdLl6cJTxd5n6NH8Oq7vd0JHTTV8Jr3gAfNWkA>
    <xmx:HZw_Ybm29jnMPk1czH8elj3GjK_T5o_0BZkDxGEkKnlHfzDucitl0Q>
    <xmx:HZw_YTZOr2qj0YptoRRrLYEQ5KU9kLDIcgtPk3Q-1GQwAfkNyUFGiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 14:44:44 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 3/4] btrfs: test verity orphans with dmlogwrites
Date:   Mon, 13 Sep 2021 11:44:36 -0700
Message-Id: <90ba270bcb48f43f6d13805fd57e89f7213812d2.1631558495.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631558495.git.boris@bur.io>
References: <cover.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The behavior of orphans is most interesting across mounts, interrupted
at arbitrary points during fsverity enable. To cover as many such cases
as possible, use dmlogwrites and dmsnapshot as in
log-writes/replay-individual.sh. At each log entry, we want to assert a
somewhat complicated invariant:

If verity has not yet started: an orphan indicates that verity has
started.
If verity has started: mount should handle the orphan and blow away
verity data: expect 0 merkle items after mounting the snapshot dev. If
we can measure the file, verity has finished.
If verity has finished: the orphan should be gone, so mount should not
blow away merkle items. Expect the same number of merkle items before
and after mounting the snapshot dev.

Note that this relies on grepping btrfs inspect-internal dump-tree.
Until btrfs-progs has the ability to print the new Merkle items, they
will show up as UNKNOWN.36/37.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/btrfs/291     | 161 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out |   2 +
 2 files changed, 163 insertions(+)
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out

diff --git a/tests/btrfs/291 b/tests/btrfs/291
new file mode 100755
index 00000000..1bb3f1b3
--- /dev/null
+++ b/tests/btrfs/291
@@ -0,0 +1,161 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
+#
+# FS QA Test 291
+#
+# Test btrfs consistency after each FUA while enabling verity on a file
+# This test works by following the pattern in log-writes/replay-individual.sh:
+# 1. run a workload (verity + sync) while logging to the log device
+# 2. replay an entry to the replay device
+# 3. snapshot the replay device to the snapshot device
+# 4. run destructive tests on the snapshot device (e.g. mount with orphans)
+# 5. goto 2
+#
+. ./common/preamble
+_begin_fstest auto verity
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_log_writes_cleanup &> /dev/null
+	rm -f $img
+	$LVM_PROG vgremove -f -y $vgname >>$seqres.full 2>&1
+	losetup -d $loop_dev >>$seqres.full 2>&1
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/dmlogwrites
+. ./common/verity
+
+# real QA test starts here
+_supported_fs btrfs
+
+_require_scratch
+_require_test
+_require_log_writes
+_require_dm_target snapshot
+_require_command $LVM_PROG lvm
+_require_scratch_verity
+_require_btrfs_command inspect-internal dump-tree
+_require_test_program "log-writes/replay-log"
+
+sync_loop() {
+	i=$1
+	[ -z "$i" ] && _fail "sync loop needs a number of iterations"
+	while [ $i -gt 0 ]
+	do
+		$XFS_IO_PROG -c sync $SCRATCH_MNT
+		let i-=1
+	done
+}
+
+dump_tree() {
+	local dev=$1
+	$BTRFS_UTIL_PROG inspect-internal dump-tree $dev
+}
+
+count_item() {
+	local dev=$1
+	local item=$2
+	dump_tree $dev | grep -c $item
+}
+
+_log_writes_init $SCRATCH_DEV
+_log_writes_mkfs
+_log_writes_mount
+
+f=$SCRATCH_MNT/fsv
+MB=$((1024 * 1024))
+img=$TEST_DIR/$$.img
+$XFS_IO_PROG -fc "pwrite -q 0 $((10 * $MB))" $f
+$XFS_IO_PROG -c sync $SCRATCH_MNT
+sync_loop 10 &
+sync_proc=$!
+_fsv_enable $f
+$XFS_IO_PROG -c sync $SCRATCH_MNT
+wait $sync_proc
+
+_log_writes_unmount
+_log_writes_remove
+
+# the snapshot and the replay will each be the size of the log writes dev
+# so we create a loop device of size 2 * logwrites and then split it into
+# replay and snapshot with lvm.
+log_writes_blocks=$(blockdev --getsz $LOGWRITES_DEV)
+replay_bytes=$((512 * $log_writes_blocks))
+img_bytes=$((2 * $replay_bytes))
+
+$XFS_IO_PROG -fc "pwrite -q -S 0 $img_bytes $MB" $img >>$seqres.full 2>&1 || \
+	_fail "failed to create image for loop device"
+loop_dev=$(losetup -f --show $img)
+vgname=vg_replay
+lvname=lv_replay
+replay_dev=/dev/mapper/vg_replay-lv_replay
+snapname=lv_snap
+snap_dev=/dev/mapper/vg_replay-$snapname
+
+$LVM_PROG vgcreate -f $vgname $loop_dev >>$seqres.full 2>&1 || _fail "failed to vgcreate $vgname"
+$LVM_PROG lvcreate -L "$replay_bytes"B -n $lvname $vgname -y >>$seqres.full 2>&1 || \
+	_fail "failed to lvcreate $lvname"
+$UDEV_SETTLE_PROG >>$seqres.full 2>&1
+
+replay_log_prog=$here/src/log-writes/replay-log
+num_entries=$($replay_log_prog --log $LOGWRITES_DEV --num-entries)
+entry=$($replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev --find --end-mark mkfs | cut -d@ -f1)
+$replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev --limit $entry || \
+	_fail "failed to replay to start entry $entry"
+let entry+=1
+
+# state = 0: verity hasn't started
+# state = 1: verity underway
+# state = 2: verity done
+state=0
+while [ $entry -lt $num_entries ];
+do
+	$replay_log_prog --limit 1 --log $LOGWRITES_DEV --replay $replay_dev --start $entry || \
+		_fail "failed to take replay step at entry: $entry"
+
+	$LVM_PROG lvcreate -s -L 4M -n $snapname $vgname/$lvname >>$seqres.full 2>&1 || \
+		_fail "Failed to create snapshot"
+	$UDEV_SETTLE_PROG >>$seqres.full 2>&1
+
+	orphan=$(count_item $snap_dev ORPHAN)
+	if [ $state -eq 0 ]; then
+		[ $orphan -gt 0 ] && state=1
+	fi
+
+	pre_mount=$(count_item $snap_dev UNKNOWN.3[67])
+	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $entry"
+	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
+	measured=$?
+	umount $SCRATCH_MNT
+	[ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
+	[ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but measurement failed at entry $entry")
+	post_mount=$(count_item $snap_dev UNKNOWN.3[67])
+
+	echo "entry: $entry, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
+
+	if [ $state -eq 1 ]; then
+		[ $post_mount -eq 0 ] || \
+			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $entry";
+	fi
+	if [ $state -eq 2 ]; then
+		[ $pre_mount -gt 0 ] || \
+			_fail "expected to have verity items before mount at entry $entry"
+		[ $pre_mount -eq $post_mount ] || \
+			_fail "mount cleared merkle items after verity was enabled $pre_mount vs $post_mount at entry $entry";
+	fi
+
+	let entry+=1
+	$LVM_PROG lvremove $vgname/$snapname -y >>$seqres.full
+done
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/291.out b/tests/btrfs/291.out
new file mode 100644
index 00000000..04605c70
--- /dev/null
+++ b/tests/btrfs/291.out
@@ -0,0 +1,2 @@
+QA output created by 291
+Silence is golden
-- 
2.33.0

