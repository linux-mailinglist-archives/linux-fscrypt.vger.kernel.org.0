Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98135B405
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Apr 2021 14:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbhDKMNw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Apr 2021 08:13:52 -0400
Received: from out20-87.mail.aliyun.com ([115.124.20.87]:49415 "EHLO
        out20-87.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKMNu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Apr 2021 08:13:50 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.000844626-4.85803e-05-0.999107;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.JyIaTYn_1618143211;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JyIaTYn_1618143211)
          by smtp.aliyun-inc.com(10.147.42.16);
          Sun, 11 Apr 2021 20:13:32 +0800
Date:   Sun, 11 Apr 2021 20:13:31 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 1/3] btrfs: test btrfs specific fsverity corruption
Message-ID: <YHLn65QlJHCNK3kM@desktop>
References: <cover.1617908086.git.boris@bur.io>
 <6e3759825cd0134186b0d6eb8825a4ba3ed62b70.1617908086.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e3759825cd0134186b0d6eb8825a4ba3ed62b70.1617908086.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:57:49AM -0700, Boris Burkov wrote:
> There are some btrfs specific fsverity scenarios that don't map
> neatly onto the tests in generic/574 like holes, inline extents,
> and preallocated extents. Cover those in a btrfs specific test.
> 
> This test relies on the btrfs implementation of fsverity in:
> <kernel patches>
> and it relies on btrfs-corrupt-block for corruption, with the patches:
> <corrupt block patches>

I assume you'll fill in the patch lists when they're merged.

> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/config       |   1 +
>  common/verity       |   7 ++
>  tests/btrfs/290     | 190 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/290.out |  17 ++++
>  tests/btrfs/group   |   1 +
>  5 files changed, 216 insertions(+)
>  create mode 100755 tests/btrfs/290
>  create mode 100644 tests/btrfs/290.out
> 
> diff --git a/common/config b/common/config
> index a47e462c..003b2a88 100644
> --- a/common/config
> +++ b/common/config
> @@ -256,6 +256,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
>  export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
>  export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
>  export BTRFS_TUNE_PROG=$(type -P btrfstune)
> +export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
>  export XFS_FSR_PROG=$(type -P xfs_fsr)
>  export MKFS_NFS_PROG="false"
>  export MKFS_CIFS_PROG="false"
> diff --git a/common/verity b/common/verity
> index 38eea157..d2c1ea24 100644
> --- a/common/verity
> +++ b/common/verity
> @@ -8,6 +8,10 @@ _require_scratch_verity()
>  	_require_scratch
>  	_require_command "$FSVERITY_PROG" fsverity
>  
> +	if [ $FSTYP == "btrfs" ]; then
> +		_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block
> +	fi

Does the fsverity function depend on btrfs-corrupt-block command? I
think btrfs-corrupt-block is only needed in this specific test, other
btrfs fsverity tests may not depend on it. So add this require rule in
the test if that's the case.

> +
>  	if ! _scratch_mkfs_verity &>>$seqres.full; then
>  		# ext4: need e2fsprogs v1.44.5 or later (but actually v1.45.2+
>  		#       is needed for some tests to pass, due to an e2fsck bug)
> @@ -147,6 +151,9 @@ _scratch_mkfs_verity()
>  	ext4|f2fs)
>  		_scratch_mkfs -O verity
>  		;;
> +	btrfs)
> +		_scratch_mkfs
> +		;;
>  	*)
>  		_notrun "No verity support for $FSTYP"
>  		;;
> diff --git a/tests/btrfs/290 b/tests/btrfs/290
> new file mode 100755
> index 00000000..5aff7648
> --- /dev/null
> +++ b/tests/btrfs/290
> @@ -0,0 +1,190 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
> +#
> +# FS QA Test 290
> +#
> +# Test btrfs support for fsverity.
> +# This test extends the generic fsverity testing by corrupting inline extents,
> +# preallocated extents, holes, and the Merkle descriptor in a btrfs-aware way.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/verity
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +_supported_fs btrfs
> +_require_scratch
> +_require_scratch_verity
> +
> +cleanup()

Better to name it as _cleanup(), though usually we name local functions
without the leading underscore, but _cleanup function is a bit special,
almost all tests name it with "_" and it's in template in 'check'
script. And it's easier to do a global s/_cleanup/cleanup/ if it's
consistent with other tests.

> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +get_ino() {
> +	file=$1

Declare local variables with local keyword.

> +	ls -i $file | awk '{print $1}'

stat -c "%i"

> +}
> +
> +validate() {
> +	f=$1
> +	sz=$2

sz is not used, but xfs_io below would use $sz

> +	# buffered io
> +	cat $f > /dev/null
> +	# direct io
> +	dd if=$f iflag=direct of=/dev/null status=none

$XFS_IO_PROG -dc "pread -q 0 $sz" $f

Direct I/O is used, then we need

_require_odirect

> +}
> +
> +# corrupt the data portion of an inline extent
> +corrupt_inline() {
> +	f=$SCRATCH_MNT/inl
> +	head -c 42 /dev/zero | tr '\0' X > $f

$XFS_IO_PROG  -fc "pwrite -q -S 0x58 0 42" $f

And all usages in other functions.

> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# inline data starts at disk_bytenr
> +	# overwrite the first u64 with random bogus junk
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f disk_bytenr $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f

Then all validte calls should pass file size as second param.

> +}
> +
> +# preallocate a file, then corrupt it by changing it to a regular file
> +corrupt_prealloc_to_reg() {
> +	f=$SCRATCH_MNT/prealloc
> +	fallocate -l 4k $f

$XFS_IO_PROG -fc "falloc 0 4k" $f

> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT

Not sure why sync is needed in all the tests, we do umount in every test
which syncs filesystem as well.

> +	_scratch_unmount
> +	# set extent type from prealloc (2) to reg (1)
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 1 $SCRATCH_DEV 2>/dev/null >/dev/null

Usually do ">/dev/null 2>&1" to discard stdout & stderr

> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt a regular file by changing the type to preallocated
> +corrupt_reg_to_prealloc() {
> +	f=$SCRATCH_MNT/reg
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# set type from reg (1) to prealloc (2)
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 2 $SCRATCH_DEV 2>/dev/null >/dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt a file by punching a hole
> +corrupt_punch_hole() {
> +	f=$SCRATCH_MNT/punch
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	# make a new extent in the middle
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	head -c 4k /dev/zero | tr '\0' Y | dd of=$f bs=4k count=1 seek=1 conv=notrunc 2>/dev/null

$XFS_IO_PROG -c "pwrite -q -S 0x59 4k 4k" $f

> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# change disk_bytenr to 0, representing a hole
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 0 $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# plug hole
> +corrupt_plug_hole() {
> +	f=$SCRATCH_MNT/plug
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	fallocate -p -o 4k -l 4k $f
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# change disk_bytenr to some value, plugging the hole
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 13639680 $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt the fsverity descriptor item indiscriminately (causes EINVAL)
> +corrupt_verity_descriptor() {
> +	f=$SCRATCH_MNT/desc
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# key for the descriptor item is <inode, BTRFS_VERITY_DESC_ITEM_KEY, 1>,
> +	# 88 is X. So we write 5 Xs to the start of the descriptor
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 0 -b 5 $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# specifically target the root hash in the descriptor (causes EIO)
> +corrupt_root_hash() {
> +	f=$SCRATCH_MNT/roothash
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 16 -b 1 $SCRATCH_DEV >> $seqres.full
> +	#$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,0 -v 88 -o 120 -b 5 $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt the Merkle tree data itself
> +corrupt_merkle_tree() {
> +	f=$SCRATCH_MNT/merkle
> +	head -c 12k /dev/zero | tr '\0' X > $f
> +	ino=$(get_ino $f)
> +	_fsv_enable $f
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	_scratch_unmount
> +	# key for the descriptor item is <inode, BTRFS_VERITY_MERKLE_ITEM_KEY, 0>,
> +	# 88 is X. So we write 5 Xs to somewhere in the middle of the first
> +	# merkle item
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v 88 -o 100 -b 5 $SCRATCH_DEV > /dev/null
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# real QA test starts here
> +_scratch_mkfs >/dev/null
> +_scratch_mount
> +
> +corrupt_inline
> +corrupt_prealloc_to_reg
> +corrupt_reg_to_prealloc
> +corrupt_punch_hole
> +corrupt_plug_hole
> +corrupt_verity_descriptor
> +corrupt_root_hash
> +corrupt_merkle_tree
> +
> +# we intentionally corrupted, re-mkfs to avoid tripping the corrupted fs error
> +_scratch_unmount
> +_scratch_mkfs >/dev/null

Use _require_scratch_nocheck, then there's no post-test fsck.

> +
> +status=0
> +exit
> diff --git a/tests/btrfs/290.out b/tests/btrfs/290.out
> new file mode 100644
> index 00000000..4da61246
> --- /dev/null
> +++ b/tests/btrfs/290.out
> @@ -0,0 +1,17 @@
> +QA output created by 290
> +cat: /mnt/scratch/inl: Input/output error
> +dd: error reading '/mnt/scratch/inl': Input/output error

The $SCRATCH_MNT path in error message should be filtered, as people may
hanve different SCRATCH_MNT defined. Use _filter_scratch, i.e.

  cat $f 2>&1 >/dev/null | _filter_sratch

Thanks,
Eryu

> +cat: /mnt/scratch/prealloc: Input/output error
> +dd: error reading '/mnt/scratch/prealloc': Input/output error
> +cat: /mnt/scratch/reg: Input/output error
> +dd: error reading '/mnt/scratch/reg': Input/output error
> +cat: /mnt/scratch/punch: Input/output error
> +dd: error reading '/mnt/scratch/punch': Input/output error
> +cat: /mnt/scratch/plug: Input/output error
> +dd: error reading '/mnt/scratch/plug': Input/output error
> +cat: /mnt/scratch/desc: Invalid argument
> +dd: failed to open '/mnt/scratch/desc': Invalid argument
> +cat: /mnt/scratch/roothash: Input/output error
> +dd: error reading '/mnt/scratch/roothash': Input/output error
> +cat: /mnt/scratch/merkle: Input/output error
> +dd: error reading '/mnt/scratch/merkle': Input/output error
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 331dd432..13051562 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -238,3 +238,4 @@
>  233 auto quick subvolume
>  234 auto quick compress rw
>  235 auto quick send
> +290 auto quick verity
> -- 
> 2.30.2
