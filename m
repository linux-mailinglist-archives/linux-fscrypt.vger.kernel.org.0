Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B109A358C97
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhDHSbB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:31:01 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:58339 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233026AbhDHSab (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:30:31 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 89BD9A55;
        Thu,  8 Apr 2021 14:30:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=uJy16+IV3nOoRUFl290+OORwnC
        SSQ4W35UUQqeIY/p0=; b=hyt+SL0l7aLPC0L8DSmmj5vpqIyHS4Sfq5wfgKp4E4
        a+TDX3fZkKLqnOXmUUG/zIeJ3EY7wJozC7E9TUN4oKTEWvnM8VBXCRGqxQ6+s38S
        bAVQYWK+rVhkUNBZpluLGBgx+nwlU8nAvHjwqepIEOocM+SeUTWYLDY8M3NiPWdF
        0O/8hBdPZljp26hIsv4sRwsP+5Ne8+K8PJbFVOCEJsd7ZsDVmknEhKedAwN12z4w
        T0iXKYqPotoKaA+feMuKMvTTebmCXQMBXj/xquqA4PL6bC9TH7SLJrBjMKcIAtmM
        6pj6sQ6TvPmIiIQV6YPRSt5VoY/SIPJn5cEq2enPDNDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=uJy16+IV3nOoRUFl290+OORwnCSSQ4W35UUQqeIY/p0=; b=TpR9zRBb
        dfNhkjboZC7fSeI2dgVfCH5QkaZwWaRKHHLrNb78Ff8tZrCuWOK2ArErF4eTymWd
        V5PhQL19gnKNRIY1mlOc72uxr4nUgBpLnKxxgbUWoBJuP1/TxQjj7ZOm2Gwy3dkw
        2OaawUrvU5hG7qtR1slWi8t2HK4KgSWOiqFyPVtU0Im21uc1JRVHXTiyuRQg8Cl9
        w4nQNhQAylV7eab9agWVz4IUv8H722AVlZKRhRinYjOL/riXXecrRzRljtMRd5zz
        poEPAw7Iap/YefDKvQrReY4kLY0+wgw8CuV0YAYB+OQBXoE4MQ1p8aeTaja/Gx2k
        4sgrtWIxpxAiVA==
X-ME-Sender: <xms:u0tvYNPlyfNkf_RCCuq1bqze1AEFmyobc2ghmP2I4zKuRR7Zn76ubg>
    <xme:u0tvYP-I7FGR0XZpgv-Ua7hBo_9ImSxKBA_pmnVpdr9MfCToXXBRUtH1YfVmN2EKR
    2gLpiZTXOr7XxuOMro>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:u0tvYMTGP8neZu0QoXVySSijfpjc2jhcrkwLFQvffCTvp9_sCa3Vdw>
    <xmx:u0tvYJslT3bPOAVIURVbxn6RAMRm98ZPiIwJb1gVOb5q31XSmwY4_Q>
    <xmx:u0tvYFcJpMwGJPLVgwOB8FlrzP0_09yvK25cMuxyHIKQXsl9hOfwsw>
    <xmx:u0tvYFEpTTh0yw_QK3qLSdr6ZAb0i2Ys0_Q886h9syKWAOv7whM5Zg>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id D03FC1080054;
        Thu,  8 Apr 2021 14:30:18 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 3/3] btrfs: test verity orphans with dmlogwrites
Date:   Thu,  8 Apr 2021 11:30:13 -0700
Message-Id: <a7d13a3ee3ba2c3af97466462b40b20aeee89efa.1617906318.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617906318.git.boris@bur.io>
References: <cover.1617906318.git.boris@bur.io>
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

This test relies on the btrfs implementation of fsverity in:
btrfs: add compat_flags to btrfs_inode_item
btrfs: initial fsverity support
btrfs: check verity for reads of inline extents and holes
btrfs: fallback to buffered io for verity files
btrfs: verity metadata orphan items

and it relies on btrfs-corrupt-block for corruption, with the
following btrfs-progs patches:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

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
index 58943c85..72e3ec38 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -234,3 +234,4 @@
 229 auto quick send clone
 230 auto quick qgroup limit
 290 auto quick verity
+291 auto verity
-- 
2.30.2

