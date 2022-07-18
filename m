Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97783578E26
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiGRXNs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiGRXNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:13:48 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6570FAF;
        Mon, 18 Jul 2022 16:13:46 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C81AB5C00D8;
        Mon, 18 Jul 2022 19:13:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 19:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658186025; x=1658272425; bh=Od
        qIRigvyCfEXL6smrO/YK1fvAEjJRN9u77IRl5jhE4=; b=krz4ZJ9vqiOG9kscwa
        rUgfuH2dNkMHZ1YP98hB8KyAH1Gy1JbbAAcd/8bxbOIfofAMxo1X+bgRu5+ALhFI
        B6JZ7K6QMCQCBd5HdIxIzSRqpgEpBYnsI9L6li8fyxqC5qejKgpApBZdVjNMLQPg
        oLIV+ha7TyICvhB9kyyYILBCndsY+c5wiLZPezUdbAufeWV+YXBztZ3WOvtrzEMb
        U2qi8CEVPGfq1amX3DhlPQAj9lu1G/oGGOnjgQHe0PfnCEQc9NIxK0yMyAqxX/14
        vTz3OA82sRSdvZZui7/+bD8LJZ8l6ctqr9RTnkDtz3w+c12BdguOSzpskIuoZwia
        xHuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658186025; x=1658272425; bh=OdqIRigvyCfEX
        L6smrO/YK1fvAEjJRN9u77IRl5jhE4=; b=1HMEkZoebPPCVWFtWDddfwTjr0RsW
        cY/R2igt1qexLcQKIqvwrQehth+ZUnJIDA9zjlrt95dV+N59cMHneUvIojtl94Rm
        V5LgIyA3iYhv9/qQeJzX5ZrdZ6XWLp44x8kxPNAZOHScz7JQHyyHtlUWDNUg3soc
        QwsNxiA2afb1Zv+4RYuSxGkHIosnQPPw+rAX/D1QMFy655MqcYT5yiFCUcM0p0+9
        ASO2MouESbCSSq4nycXlPQfW5OkWWCzDrMJBt243muhybYlcVGrgAL4uhKyAy4WB
        4iWtdVTIqSs3fJ2qrN7QePj6AuIurb6nF9kTtTmc0MRcaoAMilRuaL3Aw==
X-ME-Sender: <xms:KenVYvcUKg_9FjViswArmjSzcILmcDW8PluwBeb49jVzXywc8mFNiQ>
    <xme:KenVYlPzahHkRxtnnAHVtPHkoG-CtzJjtwCkHTqaChKcn22aSqBTdz9iEu0WxEfR6
    MUH-IDkZellQYmJJI8>
X-ME-Received: <xmr:KenVYoiECsMxteHQldjuDyQ-VDfaw6ZE-29g-a1HFUEjcDj5KYqLzEA45qZ_wcGy4FLpmXxZ1D1jwtUKmJ-2UsGzOY7MEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:KenVYg8K0OC0KKXvwRKn8ZW4wKTrUFWiolSnzsygHb3udicHay5JJg>
    <xmx:KenVYruGtSVGnZzOXZNMCloO50oqZd4n-vVaxlKgOWrL_BQIZg-etw>
    <xmx:KenVYvH7oARzTiyoJDPXyAuKrQTq34fO3bGOdoIXxQY1nE5kiB5Vfw>
    <xmx:KenVYk6Q5vXRV4qBdHMMTUm_fhw72FhV0b767xro50f8uv7iLp4jDQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:13:45 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v11 4/5] btrfs: test verity orphans with dmlogwrites
Date:   Mon, 18 Jul 2022 16:13:36 -0700
Message-Id: <f6b3cc7859672177a68d5509a91c8104c8cb9a8f.1658185784.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658185784.git.boris@bur.io>
References: <cover.1658185784.git.boris@bur.io>
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
 tests/btrfs/291     | 167 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out |   2 +
 2 files changed, 169 insertions(+)
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out

diff --git a/tests/btrfs/291 b/tests/btrfs/291
new file mode 100755
index 00000000..97cb78c7
--- /dev/null
+++ b/tests/btrfs/291
@@ -0,0 +1,167 @@
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
+	local count_old=$(count_item $dev 'UNKNOWN.3[67]')
+	local count_new=$(count_item $dev 'VERITY_\(DESC\|MERKLE\)_ITEM')
+	echo $((count_old + count_new))
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
+	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
+
+	pre_mount=$(count_merkle_items $snap_dev)
+	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $entry"
+	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
+	measured=$?
+	umount $SCRATCH_MNT
+	[ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
+	[ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but measurement failed at entry $entry")
+	post_mount=$(count_merkle_items $snap_dev)
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
2.37.1

