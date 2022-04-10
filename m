Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AF64FAE4F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 10 Apr 2022 16:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbiDJOzY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 10 Apr 2022 10:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiDJOzX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 10 Apr 2022 10:55:23 -0400
Received: from out20-2.mail.aliyun.com (out20-2.mail.aliyun.com [115.124.20.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEDA53E12;
        Sun, 10 Apr 2022 07:53:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436395|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.00855563-0.000526557-0.990918;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047188;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.NNpdYAe_1649602384;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.NNpdYAe_1649602384)
          by smtp.aliyun-inc.com(33.37.75.176);
          Sun, 10 Apr 2022 22:53:05 +0800
Date:   Sun, 10 Apr 2022 22:53:04 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 3/5] btrfs: test btrfs specific fsverity corruption
Message-ID: <YlLvUCWvx3fK2ocg@desktop>
References: <cover.1647461985.git.boris@bur.io>
 <fd69c62b9971d446f53ba3d168625fb3a3468882.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd69c62b9971d446f53ba3d168625fb3a3468882.1647461985.git.boris@bur.io>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 01:25:13PM -0700, Boris Burkov wrote:
> There are some btrfs specific fsverity scenarios that don't map
> neatly onto the tests in generic/574 like holes, inline extents,
> and preallocated extents. Cover those in a btrfs specific test.
> 
> This test relies on the btrfs implementation of fsverity in the patch:
> btrfs: initial fsverity support
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  tests/btrfs/290     | 168 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/290.out |  25 +++++++
>  2 files changed, 193 insertions(+)
>  create mode 100755 tests/btrfs/290
>  create mode 100644 tests/btrfs/290.out
> 
> diff --git a/tests/btrfs/290 b/tests/btrfs/290
> new file mode 100755
> index 00000000..f9acd55a
> --- /dev/null
> +++ b/tests/btrfs/290
> @@ -0,0 +1,168 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.

I noticed that all patches have 2021 in copyright statement, should be
updated to 2022?

And I'd like btrfs folks to help review these 2 btrfs specific tests.

Thanks,
Eryu

> +#
> +# FS QA Test 290
> +#
> +# Test btrfs support for fsverity.
> +# This test extends the generic fsverity testing by corrupting inline extents,
> +# preallocated extents, holes, and the Merkle descriptor in a btrfs-aware way.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/verity
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_require_scratch_verity
> +_require_scratch_nocheck
> +_require_odirect
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "pread"
> +_require_xfs_io_command "pwrite"
> +_require_btrfs_corrupt_block
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
> -- 
> 2.31.0
