Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B716358D1C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhDHS6J (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:58:09 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:36683 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232950AbhDHS6J (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:58:09 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 083131190;
        Thu,  8 Apr 2021 14:57:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=nGgnP7AIGs/HWGEeOtaY+P48k4
        4xac4zxkzR1kwl1QY=; b=ngVoKF55qXW3PwcyRdm+QXPqBLg5viTVF/G2/+AIOn
        BF1joFLYcymJ0fU3mQaYM5OfiSD8hIMd2mvIqATJX2VaDCx0uNlZvir7youbV3WJ
        wo8mYt8B/3J4ostUc6a0723sBYE8W6zdcI7Yxym2ux9NFSzS5KAvXrqSQ1+EcN9k
        K9goZIdwFXZXQ/DVRFSebtoMJZ1k0nCVdmWC5oHTodH1Pmtl9VELCjTEn0A7K1HD
        gMysjgu9Y+Ffe+f5kt6jsPbRq+g3RgDtDSu2ewKZDQvNJgZ8y3bvbrvfmcNUQ79w
        X5SZo2YCwkAnIo9jwIV37XGF8zaKSWrF7mIth/h40QCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=nGgnP7AIGs/HWGEeOtaY+P48k44xac4zxkzR1kwl1QY=; b=V+WjBDHD
        cBcZdwyCOMzm5KdM3UWC5XBJv1wj/vV+qO1VpOYOm1EUbZoyq1STluRt91mODyaK
        l77j4AKR4dZWKp+cfLEdrzpmHicGDK4wGxodUpdKA2+cpY17gNSnBlmTEhHFsesv
        M0yvyD7VW4FBZJCP+DnDew1jnMJeGs3+Z/s93qB1PDo5BuEqNJViOHiXORZzB6P2
        wcYHsEL64jcg3sOlgStgiCu13omjNni4XSKa/W3l7NfBwCIt0V8WBEDiqqgINKhe
        tKuRNZmxvdbWjahpveuEXLYI2jZOoSlanfuzFsR5WCrb6oedXsafy2zNaQKkplZP
        +eKtSW4wU+Vk+g==
X-ME-Sender: <xms:NFJvYGR-tAF338xlPTD4sMrYpQn-JnV8XW1dlEdrmdmAPm7hdrsfpw>
    <xme:NFJvYLzEjWfFdNZ9B_evtQ5xyT7pTbxPNkZDItvLMEoyEl-60swhQZCqEU_JCyHnD
    YobacYbzAN2hB_13TY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:NFJvYD0EztIqVoUbgLkOOU0-88zS-MGiVJKxFrqklPTvn006mPCEyQ>
    <xmx:NFJvYCAIpuzgJSJV-Mg2F5HYIxPZIHtRq5IsVw1mIQech1vLyM3C9Q>
    <xmx:NFJvYPj5wWeg4yZVNIxSDYqV9AGZUOKO-QEk0R-LJZGaTAYYt5M9vw>
    <xmx:NFJvYHb3aciAAyowP6UnBD7vliHhs0dLy053fnBHiPzMaWNJ2EuvZw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DCBA108005F;
        Thu,  8 Apr 2021 14:57:56 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 3/3] btrfs: test verity orphans with dmlogwrites
Date:   Thu,  8 Apr 2021 11:57:51 -0700
Message-Id: <64129051878e58aa8d8ccc30479f6f767541e31e.1617908086.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617908086.git.boris@bur.io>
References: <cover.1617908086.git.boris@bur.io>
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
 tests/btrfs/291     | 156 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out |   2 +
 tests/btrfs/group   |   1 +
 3 files changed, 159 insertions(+)
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out

diff --git a/tests/btrfs/291 b/tests/btrfs/291
new file mode 100755
index 00000000..61f36426
--- /dev/null
+++ b/tests/btrfs/291
@@ -0,0 +1,156 @@
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
+	_log_writes_cleanup &> /dev/null
+	rm -f $tmp.*
+	$LVM_PROG vgremove -f -y $vgname >>$seqres.full 2>&1
+	losetup -d $loop_dev >>$seqres.full 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/dmlogwrites
+. ./common/verity
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs btrfs
+
+_require_scratch
+_require_log_writes
+_require_dm_target snapshot
+_require_command $LVM_PROG lvm
+_require_scratch_verity
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
+	dev=$1
+	$BTRFS_UTIL_PROG inspect-internal dump-tree $dev
+}
+
+count_item() {
+	dev=$1
+	item=$2
+	dump_tree $dev | grep -c $item
+}
+
+_log_writes_init $SCRATCH_DEV
+_log_writes_mkfs
+_log_writes_mount
+
+f=$SCRATCH_MNT/fsv
+dd if=/dev/zero of=$f bs=1M count=10 >>$seqres.full 2>&1
+$XFS_IO_PROG -c sync $SCRATCH_MNT
+sync_loop 10 &
+_fsv_enable $f
+$XFS_IO_PROG -c sync $SCRATCH_MNT
+
+_log_writes_unmount
+_log_writes_remove
+
+dd if=/dev/zero of=$tmp.loop-file bs=1M count=1 seek=8192 >>$seqres.full 2>&1
+loop_dev=$(losetup -f --show $tmp.loop-file)
+vgname=vg_replay
+lvname=lv_replay
+replay_dev=/dev/mapper/vg_replay-lv_replay
+snapname=lv_snap
+snap_dev=/dev/mapper/vg_replay-$snapname
+
+$LVM_PROG vgcreate -f $vgname $loop_dev >>$seqres.full 2>&1 || _fail "failed to vgcreate $vgname"
+$LVM_PROG lvcreate -L 4G -n $lvname $vgname -y >>$seqres.full 2>&1 || \
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
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 13051562..cc5a811e 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -239,3 +239,4 @@
 234 auto quick compress rw
 235 auto quick send
 290 auto quick verity
+291 auto verity
-- 
2.30.2

