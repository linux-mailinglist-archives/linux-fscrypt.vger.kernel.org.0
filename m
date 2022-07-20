Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC1F57AB2D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiGTAuI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 20:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiGTAuH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 20:50:07 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033D5E79;
        Tue, 19 Jul 2022 17:50:05 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 181B23200901;
        Tue, 19 Jul 2022 20:50:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 19 Jul 2022 20:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658278204; x=1658364604; bh=OD
        ZmgbrhVrxYeIj7xGH9Be+izw+faEUFSqtv/9vlspA=; b=bA9W3KRhfCOlziPi79
        3BZr6gTYzx5p4abCe+jpLcuzOqKuWILfHl5WMEgQ9NTUFIZEr4RjgwYLbg+G9M3A
        dX6IBzng4/2l9b4eaqXBILTseMz97hjT/l+XrAJM0NcOgZ5pU/kiUUXLf+3P9fwm
        m6OzuE7zYMpoTpy7zcZJ1lGdN6USem++cAW7b9zVEsRpej+PrjM9NWPcS5k+5VVm
        I7FCjU4jlQYisiJb6toFVgo5+TMvXxZW+7E1JC+pEBNBh/scJsRHZHRiXzdd68zD
        OAA4sWvsjmdbPkXUrKa3xcADKrgcuCf4O5K0IbcyIZYWNI4pjSzfO+mu/QKx1sM5
        5PMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658278204; x=1658364604; bh=ODZmgbrhVrxYe
        Ij7xGH9Be+izw+faEUFSqtv/9vlspA=; b=e66f/NhIcxgPLH4k6O6rDby7or7S/
        JQ1h9/vR1J+0GN0WrxE8WLx/cKUquMUdz1rzsERy9hPNrXUzeIACRf+Ak909AKkK
        Cj9uy4/cAtAyYhkw2fMVOIdD/zCi8VXnX60fSdLVPEg4MBUGj/jY7GRjloGxdbmA
        iJuU8H7xTi3zmHJ7zJmykCvsR1uVneUkjNpf61oR3ey2nBW/Po+4J/mwjN1qAPx1
        ZU8fuVRorWWz4YXP91CI1qweOMvCcLerSNi4cOpCis0KyoJ3/1AAGgv8SuJ8iaiE
        B5Fa62Nnav7B1PkvuyVvy4KanIhC6yC6+k3toCbmtKHrcPJuJUN0+WY2Q==
X-ME-Sender: <xms:PFHXYksOJKCYgVsI6_51B2h7Z9m95xMuj2tO7eWwlchpi_3FyPhbLA>
    <xme:PFHXYheUSxMWxeqA1jTRQi7Jz__SC8lVKK0C7dz6YCNqNmBtNP0SjyRXRaz4JqcKI
    w_FOTVl9oP_W1giPwU>
X-ME-Received: <xmr:PFHXYvwPz4w-AQ1DeZ7LDe2fgFln8n4S0WxedGZQQPTzuO-ZI0bXScuU6NVFlvfAd-Cz_5hLWHwX6Rb4RqVFCaBKEM0Elw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeluddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:PFHXYnOiuYU0eEIkKdUABSlqMhmlxM_s4IQ5Uin7mV34i1vVa2F9YA>
    <xmx:PFHXYk9BRXBpd7-rfz3yLaCBcnV9TQ7WsCQO479T5eB1sguYM6xETQ>
    <xmx:PFHXYvVk5D1Jtf9V9NMWEZoMLTVNqHirxVLWuRzvSF2jhEM_pr_h1w>
    <xmx:PFHXYmKJs7qctrLaRjHVWm8jrtwjE9wdqzN5IQI5UzkuY1pl4q2GOQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Jul 2022 20:50:04 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v13 4/5] btrfs: test verity orphans with dmlogwrites
Date:   Tue, 19 Jul 2022 17:49:49 -0700
Message-Id: <57123fe31da2886cfae01e27ffc43095ef7db7d1.1658277755.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658277755.git.boris@bur.io>
References: <cover.1658277755.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The behavior of orphans is most interesting across mounts, interrupted
at arbitrary points during fsverity enable. To cover as many such cases
as possible, use dmlogwrites and dmsnapshot as in
log-writes/replay-individual.sh. As we replay the log events, we run a
state machine with different invariants enforced at each state.

There are three possible states for a given point in the log:
0. Verity has not yet started
1. Verity has started but not finished
2. Verity has finished.

The possible transitions with causes are:
0->1: We see an orphan item for the file.
1->2: Running 'fsverity measure' succeeds on the file.

Each state has its own invariant for testing:
0: No verity items exist.
1: Mount should handle the orphan and blow away verity data: expect 0
   Merkle items after mounting.
2: The orphan should be gone and mount should not blow away merkle
   items. Expect the same number of merkle items before and after
   mounting.

As a result, we can be confident that if the file system loses power at
any point during enabling verity on a file, the work is either completed,
or gets rolled-back by mount.

Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 tests/btrfs/291     | 168 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out |   2 +
 2 files changed, 170 insertions(+)
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out

diff --git a/tests/btrfs/291 b/tests/btrfs/291
new file mode 100755
index 00000000..bbdd183d
--- /dev/null
+++ b/tests/btrfs/291
@@ -0,0 +1,168 @@
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
+_begin_fstest auto verity recoveryloop
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
+_require_loop
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
+	dump_tree $dev | grep -c "$item"
+}
+
+count_merkle_items() {
+	local dev=$1
+	count_item $dev 'VERITY_\(DESC\|MERKLE\)_ITEM'
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
+prev=$(_log_writes_mark_to_entry_number mkfs)
+[ -z "$prev" ] && _fail "failed to locate entry mark 'mkfs'"
+cur=$(_log_writes_find_next_fua $prev)
+
+# state = 0: verity hasn't started
+# state = 1: verity underway
+# state = 2: verity done
+state=0
+while [ ! -z "$cur" ];
+do
+	_log_writes_replay_log_range $cur $replay_dev >> $seqres.full
+
+	$LVM_PROG lvcreate -s -L 4M -n $snapname $vgname/$lvname >>$seqres.full 2>&1 || \
+		_fail "Failed to create snapshot"
+	$UDEV_SETTLE_PROG >>$seqres.full 2>&1
+
+	orphan=$(count_item $snap_dev ORPHAN)
+	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
+
+	pre_mount=$(count_merkle_items $snap_dev)
+	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $cur"
+	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
+	measured=$?
+	umount $SCRATCH_MNT
+	[ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
+	[ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but measurement failed at entry $cur")
+	post_mount=$(count_merkle_items $snap_dev)
+
+	echo "entry: $cur, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
+
+	if [ $state -eq 1 ]; then
+		[ $post_mount -eq 0 ] || \
+			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $cur";
+	fi
+	if [ $state -eq 2 ]; then
+		[ $pre_mount -gt 0 ] || \
+			_fail "expected to have verity items before mount at entry $cur"
+		[ $pre_mount -eq $post_mount ] || \
+			_fail "mount cleared merkle items after verity was enabled $pre_mount vs $post_mount at entry $cur";
+	fi
+
+	$LVM_PROG lvremove $vgname/$snapname -y >>$seqres.full
+
+	prev=$cur
+	cur=$(_log_writes_find_next_fua $(($cur + 1)))
+done
+
+[ $state -eq 2 ] || _fail "expected to reach verity done state"
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
2.37.1

