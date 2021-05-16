Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E47381FFC
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 May 2021 18:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhEPQf1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 May 2021 12:35:27 -0400
Received: from out20-14.mail.aliyun.com ([115.124.20.14]:57329 "EHLO
        out20-14.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhEPQfY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 May 2021 12:35:24 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436284|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00377139-7.02544e-05-0.996158;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047213;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KEFgLjv_1621182847;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEFgLjv_1621182847)
          by smtp.aliyun-inc.com(10.147.42.16);
          Mon, 17 May 2021 00:34:07 +0800
Date:   Mon, 17 May 2021 00:34:07 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 1/4] btrfs: test btrfs specific fsverity corruption
Message-ID: <YKFJf9UH7IYx7r76@desktop>
References: <cover.1620248200.git.boris@bur.io>
 <39a5e3f106db214a2d6416c7fda242c445cc6e53.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39a5e3f106db214a2d6416c7fda242c445cc6e53.1620248200.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 02:04:43PM -0700, Boris Burkov wrote:
> There are some btrfs specific fsverity scenarios that don't map
> neatly onto the tests in generic/574 like holes, inline extents,
> and preallocated extents. Cover those in a btrfs specific test.
> 
> This test relies on the btrfs implementation of fsverity in the patches
> titled:
> btrfs: initial fsverity support
> btrfs: check verity for reads of inline extents and holes
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/btrfs        |   5 ++
>  common/config       |   1 +
>  common/verity       |   7 ++
>  tests/btrfs/290     | 180 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/290.out |  25 ++++++
>  tests/btrfs/group   |   1 +
>  6 files changed, 219 insertions(+)
>  create mode 100755 tests/btrfs/290
>  create mode 100644 tests/btrfs/290.out
> 
> diff --git a/common/btrfs b/common/btrfs
> index ebe6ce26..bd6e87ce 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -419,3 +419,8 @@ _btrfs_rescan_devices()
>  {
>  	$BTRFS_UTIL_PROG device scan &> /dev/null
>  }
> +
> +_require_btrfs_corrupt_block()
> +{
> +	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block

The command should be btrfs-corrupt-block, instead of
btrfs_corrupt_block?

> +}
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

Use the _require_btrfs_corrupt_block helper?

> +	fi
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
> index 00000000..26939833
> --- /dev/null
> +++ b/tests/btrfs/290
> @@ -0,0 +1,180 @@
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
> +trap "_cleanup; exit \$status" 0 1 2 3 15
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
> +_require_scratch_verity
> +_require_scratch_nocheck
> +_require_odirect
> +_require_btrfs_corrupt_block

This is already checked in _require_scratch_verity.

And we also need '_require_xfs_io_command "falloc"'

Otherwise looks good to me from fstests' point of view.

Thanks,
Eryu

> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +get_ino() {
> +	local file=$1
> +	stat -c "%i" $file
> +}
> +
> +validate() {
> +	local f=$1
> +	local sz=$(_get_filesize $f)
> +	# buffered io
> +	echo $(basename $f)
> +	$XFS_IO_PROG -rc "pread -q 0 $sz" $f 2>&1 | _filter_scratch
> +	# direct io
> +	$XFS_IO_PROG -rdc "pread -q 0 $sz" $f 2>&1 | _filter_scratch
> +}
> +
> +# corrupt the data portion of an inline extent
> +corrupt_inline() {
> +	local f=$SCRATCH_MNT/inl
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 42" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# inline data starts at disk_bytenr
> +	# overwrite the first u64 with random bogus junk
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f disk_bytenr $SCRATCH_DEV > /dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# preallocate a file, then corrupt it by changing it to a regular file
> +corrupt_prealloc_to_reg() {
> +	local f=$SCRATCH_MNT/prealloc
> +	$XFS_IO_PROG -fc "falloc 0 12k" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# set extent type from prealloc (2) to reg (1)
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 1 $SCRATCH_DEV >/dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt a regular file by changing the type to preallocated
> +corrupt_reg_to_prealloc() {
> +	local f=$SCRATCH_MNT/reg
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# set type from reg (1) to prealloc (2)
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 2 $SCRATCH_DEV >/dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt a file by punching a hole
> +corrupt_punch_hole() {
> +	local f=$SCRATCH_MNT/punch
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	# make a new extent in the middle, sync so the writes don't coalesce
> +	$XFS_IO_PROG -c sync $SCRATCH_MNT
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x59 4096 4096" $f
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# change disk_bytenr to 0, representing a hole
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 0 $SCRATCH_DEV > /dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# plug hole
> +corrupt_plug_hole() {
> +	local f=$SCRATCH_MNT/plug
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	$XFS_IO_PROG -fc "falloc 4k 4k" $f
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# change disk_bytenr to some value, plugging the hole
> +	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 4096 -f disk_bytenr -v 13639680 $SCRATCH_DEV > /dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt the fsverity descriptor item indiscriminately (causes EINVAL)
> +corrupt_verity_descriptor() {
> +	local f=$SCRATCH_MNT/desc
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# key for the descriptor item is <inode, BTRFS_VERITY_DESC_ITEM_KEY, 1>,
> +	# 88 is X. So we write 5 Xs to the start of the descriptor
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 0 -b 5 $SCRATCH_DEV > /dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# specifically target the root hash in the descriptor (causes EIO)
> +corrupt_root_hash() {
> +	local f=$SCRATCH_MNT/roothash
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,36,1 -v 88 -o 16 -b 1 $SCRATCH_DEV > /dev/null 2>&1
> +	_scratch_mount
> +	validate $f
> +}
> +
> +# corrupt the Merkle tree data itself
> +corrupt_merkle_tree() {
> +	local f=$SCRATCH_MNT/merkle
> +	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $f
> +	local ino=$(get_ino $f)
> +	_fsv_enable $f
> +	_scratch_unmount
> +	# key for the descriptor item is <inode, BTRFS_VERITY_MERKLE_ITEM_KEY, 0>,
> +	# 88 is X. So we write 5 Xs to somewhere in the middle of the first
> +	# merkle item
> +	$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v 88 -o 100 -b 5 $SCRATCH_DEV > /dev/null 2>&1
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
> +status=0
> +exit
> diff --git a/tests/btrfs/290.out b/tests/btrfs/290.out
> new file mode 100644
> index 00000000..056b114b
> --- /dev/null
> +++ b/tests/btrfs/290.out
> @@ -0,0 +1,25 @@
> +QA output created by 290
> +inl
> +pread: Input/output error
> +pread: Input/output error
> +prealloc
> +pread: Input/output error
> +pread: Input/output error
> +reg
> +pread: Input/output error
> +pread: Input/output error
> +punch
> +pread: Input/output error
> +pread: Input/output error
> +plug
> +pread: Input/output error
> +pread: Input/output error
> +desc
> +SCRATCH_MNT/desc: Invalid argument
> +SCRATCH_MNT/desc: Invalid argument
> +roothash
> +pread: Input/output error
> +pread: Input/output error
> +merkle
> +pread: Input/output error
> +pread: Input/output error
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
