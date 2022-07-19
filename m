Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7557657A837
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 22:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237714AbiGSUbg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 16:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbiGSUbf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 16:31:35 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4684506B;
        Tue, 19 Jul 2022 13:31:33 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 807CA8041F;
        Tue, 19 Jul 2022 16:31:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658262693; bh=FDjI2vMjoZHF7q7/cVu4Sx0eikcuDcn0YEDlplVP8Vc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=L2FNDXbItDheFWX93EKTF9AEk88HvK53BnHTArhPr9f51JAs65jHvznKiZ8GUexz8
         8AM7hQnSr1+o609eOdUp2+Kx2yndZa0O7qbkr5/d1V353FTwpqoJ3tLgy3lbAV6bAt
         4EYQ4mx6eyhUPx94j6IglodamZSHw9Z1bueL1vOAGk2YoKSsFXVG7/23C9pKI1Ra4u
         GQ9N31nRD2o57eZdYGYxU2m8EBQyGsN2IngGl7KYJi8iwi89rCJdKNEcjBIcQ0xTyt
         JIgcLcYn4My0M18VXNrwR4Ju+BYRC3pbxncMyjLRucHohvgvq1QBs5yf5ppnTXTTeI
         /DAJ+4OeWNtiQ==
Message-ID: <d8284f65-8bad-1c95-ae1c-b903e356cd78@dorminy.me>
Date:   Tue, 19 Jul 2022 16:31:30 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v12 4/5] btrfs: test verity orphans with dmlogwrites
Content-Language: en-US
To:     Boris Burkov <boris@bur.io>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1658188603.git.boris@bur.io>
 <73cfa9631ed78ce99c20bcc09114ac28e9ff2148.1658188603.git.boris@bur.io>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <73cfa9631ed78ce99c20bcc09114ac28e9ff2148.1658188603.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 7/18/22 19:58, Boris Burkov wrote:
> The behavior of orphans is most interesting across mounts, interrupted
> at arbitrary points during fsverity enable. To cover as many such cases
> as possible, use dmlogwrites and dmsnapshot as in
> log-writes/replay-individual.sh.  As we replay the log events, we run a
> state machine with different invariants enforced at each state.
> 
> There are three possible states for a given point in the log:
> 0. Verity has not yet started
> 1. Verity has started but not finished
> 2. Verity has finished.
> 
> The possible transitions with causes are:
> 0->1: We see an orphan item for the file.
> 1->2: Running 'fsverity measure' succeeds on the file.
> 
> Each state has its own invariant for testing:
> 0: No verity items exist.
> 1: Mount should handle the orphan and blow away verity data: expect 0
>     Merkle items after mounting.
> 2: The orphan should be gone and mount should not blow away merkle
>     items. Expect the same number of merkle items before and after
>     mounting.
> 
> As a result, we can be confident that if the file system loses power at
> any point during enabling verity on a file, the work is either completed,
> or gets rolled-back by mount.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>   tests/btrfs/291     | 167 ++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/291.out |   2 +
>   2 files changed, 169 insertions(+)
>   create mode 100755 tests/btrfs/291
>   create mode 100644 tests/btrfs/291.out
> 
> diff --git a/tests/btrfs/291 b/tests/btrfs/291
> new file mode 100755
> index 00000000..97cb78c7
> --- /dev/null
> +++ b/tests/btrfs/291
> @@ -0,0 +1,167 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
> +#
> +# FS QA Test 291
> +#
> +# Test btrfs consistency after each FUA while enabling verity on a file
> +# This test works by following the pattern in log-writes/replay-individual.sh:
> +# 1. run a workload (verity + sync) while logging to the log device
> +# 2. replay an entry to the replay device
> +# 3. snapshot the replay device to the snapshot device
> +# 4. run destructive tests on the snapshot device (e.g. mount with orphans)
> +# 5. goto 2
> +#
> +. ./common/preamble
> +_begin_fstest auto verity
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	_log_writes_cleanup &> /dev/null
> +	rm -f $img
> +	$LVM_PROG vgremove -f -y $vgname >>$seqres.full 2>&1
> +	losetup -d $loop_dev >>$seqres.full 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/dmlogwrites
> +. ./common/verity
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +
> +_require_scratch
> +_require_test
> +_require_loop
> +_require_log_writes
> +_require_dm_target snapshot
> +_require_command $LVM_PROG lvm
> +_require_scratch_verity
> +_require_btrfs_command inspect-internal dump-tree
> +_require_test_program "log-writes/replay-log"
> +
> +sync_loop() {
> +	i=$1
> +	[ -z "$i" ] && _fail "sync loop needs a number of iterations"
> +	while [ $i -gt 0 ]
> +	do
> +		$XFS_IO_PROG -c sync $SCRATCH_MNT
> +		let i-=1
> +	done
> +}
> +
> +dump_tree() {
> +	local dev=$1
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree $dev
> +}
> +
> +count_item() {
> +	local dev=$1
> +	local item=$2
> +	dump_tree $dev | grep -c "$item"
> +}
> +
> +count_merkle_items() {
> +	local dev=$1
> +	local count_old=$(count_item $dev 'UNKNOWN.3[67]')
> +	local count_new=$(count_item $dev 'VERITY_\(DESC\|MERKLE\)_ITEM')
> +	echo $((count_old + count_new))
> +}
If you did another version of this changeset, I'd rather just require 
new btrfs-progs that supports the VERITY_DESC/MERKLE_ITEM name, but it's 
only a very tiny nit and I'm fine with it as is if nothing else comes up.
> +
> +_log_writes_init $SCRATCH_DEV
> +_log_writes_mkfs
> +_log_writes_mount
> +
> +f=$SCRATCH_MNT/fsv
> +MB=$((1024 * 1024))
> +img=$TEST_DIR/$$.img
> +$XFS_IO_PROG -fc "pwrite -q 0 $((10 * $MB))" $f
> +$XFS_IO_PROG -c sync $SCRATCH_MNT
> +sync_loop 10 &
> +sync_proc=$!
> +_fsv_enable $f
> +$XFS_IO_PROG -c sync $SCRATCH_MNT
> +wait $sync_proc
> +
> +_log_writes_unmount
> +_log_writes_remove
> +
> +# the snapshot and the replay will each be the size of the log writes dev
> +# so we create a loop device of size 2 * logwrites and then split it into
> +# replay and snapshot with lvm.
> +log_writes_blocks=$(blockdev --getsz $LOGWRITES_DEV)
> +replay_bytes=$((512 * $log_writes_blocks))
> +img_bytes=$((2 * $replay_bytes))
> +
> +$XFS_IO_PROG -fc "pwrite -q -S 0 $img_bytes $MB" $img >>$seqres.full 2>&1 || \
> +	_fail "failed to create image for loop device"
> +loop_dev=$(losetup -f --show $img)
> +vgname=vg_replay
> +lvname=lv_replay
> +replay_dev=/dev/mapper/vg_replay-lv_replay
> +snapname=lv_snap
> +snap_dev=/dev/mapper/vg_replay-$snapname
> +
> +$LVM_PROG vgcreate -f $vgname $loop_dev >>$seqres.full 2>&1 || _fail "failed to vgcreate $vgname"
> +$LVM_PROG lvcreate -L "$replay_bytes"B -n $lvname $vgname -y >>$seqres.full 2>&1 || \
> +	_fail "failed to lvcreate $lvname"
> +$UDEV_SETTLE_PROG >>$seqres.full 2>&1
> +
> +replay_log_prog=$here/src/log-writes/replay-log
> +num_entries=$($replay_log_prog --log $LOGWRITES_DEV --num-entries)
> +entry=$($replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev --find --end-mark mkfs | cut -d@ -f1)
> +$replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev --limit $entry || \
> +	_fail "failed to replay to start entry $entry"
> +let entry+=1
> +
> +# state = 0: verity hasn't started
> +# state = 1: verity underway
> +# state = 2: verity done
> +state=0
> +while [ $entry -lt $num_entries ];
> +do
> +	$replay_log_prog --limit 1 --log $LOGWRITES_DEV --replay $replay_dev --start $entry || \
> +		_fail "failed to take replay step at entry: $entry"
> +
> +	$LVM_PROG lvcreate -s -L 4M -n $snapname $vgname/$lvname >>$seqres.full 2>&1 || \
> +		_fail "Failed to create snapshot"
> +	$UDEV_SETTLE_PROG >>$seqres.full 2>&1
> +
> +	orphan=$(count_item $snap_dev ORPHAN)
> +	[ $state -eq 0 ] && [ $orphan -gt 0 ] && state=1
> +
> +	pre_mount=$(count_merkle_items $snap_dev)
> +	_mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $entry"
> +	fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
> +	measured=$?
> +	umount $SCRATCH_MNT
> +	[ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
> +	[ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but measurement failed at entry $entry")
> +	post_mount=$(count_merkle_items $snap_dev)
> +
> +	echo "entry: $entry, state: $state, orphan: $orphan, pre_mount: $pre_mount, post_mount: $post_mount" >> $seqres.full
> +
> +	if [ $state -eq 1 ]; then
> +		[ $post_mount -eq 0 ] || \
> +			_fail "mount failed to clear under-construction merkle items pre: $pre_mount, post: $post_mount at entry $entry";
> +	fi
> +	if [ $state -eq 2 ]; then
> +		[ $pre_mount -gt 0 ] || \
> +			_fail "expected to have verity items before mount at entry $entry"
> +		[ $pre_mount -eq $post_mount ] || \
> +			_fail "mount cleared merkle items after verity was enabled $pre_mount vs $post_mount at entry $entry";
> +	fi
> +
> +	let entry+=1
> +	$LVM_PROG lvremove $vgname/$snapname -y >>$seqres.full
> +done
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/btrfs/291.out b/tests/btrfs/291.out
> new file mode 100644
> index 00000000..04605c70
> --- /dev/null
> +++ b/tests/btrfs/291.out
> @@ -0,0 +1,2 @@
> +QA output created by 291
> +Silence is golden
