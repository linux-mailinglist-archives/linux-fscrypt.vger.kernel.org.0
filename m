Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA50510C26
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 00:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355900AbiDZWne (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Apr 2022 18:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355905AbiDZWnd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Apr 2022 18:43:33 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C4914096;
        Tue, 26 Apr 2022 15:40:24 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 16AA35C0178;
        Tue, 26 Apr 2022 18:40:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 26 Apr 2022 18:40:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651012824; x=1651099224; bh=kd
        CQVT5iGxrkT4Rh51mMDn0TbprGq2A1KbBC1nlNg58=; b=Ow8s9+ksnR5NnpOANb
        gx5zMFwOnDPbkoyuzvtbT/5Mou+by/PPEtRfgKA91r//jsXlMjROsLIkJQrH4DdV
        2mVTKYyU2Q6XskeX7C1DaePsztC6tKrToTBmuDgcKIFc+b/3MvpTx5EE/5BWtpcK
        g8U6sNGdg72d9Cq6yFKpRAtREoTLB7XIdqmjJGNpaI874YyjaPy1ElU24CbOu2Fh
        uCzJel2tU7K1P5E5uOE9A4agSBU1Z4ai4jSRCaqJKfgO6q8z5jWYbdMhKL98w6HK
        pxQeS6TcsHnbIvP+iuyLqXaBNsDL6Nc5hVC9JKreKEdJGWATVq7e9J/JdN2tDSQR
        0mvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651012824; x=1651099224; bh=kdCQVT5iGxrkT4Rh51mMDn0TbprGq2A1KbB
        C1nlNg58=; b=LVDZhVf3DaEwFWkNPWX2MBLFnJYcWGoKpHfIDKBD6jJB9oApyF/
        3OyudEiM6T9bkXBSHXnHAoSX1MG+3r3A44ixY2Y3K56SrnOCKQyQNSP+By81FQuS
        LCsdahWCNe+xrXjOxoq1iuMzg7nCbrBsk02QmRZt8dZoIq7OsWaBqFoPWl9xePJ4
        gfqJmI27f99cMu8/mN23Enpbp604SqUZrTzDoDHeYcNJ0SghlPOhPn8O0SIVHr2+
        MzAKcXY8w9Dvm4Gsk0FO8zSE/dSzCjF/TzPnFAZF7KyrBQAWnG7Thz6mtYRUxd5S
        I+ZQ+7ekabUViGbDcOFkCM8zF1jC9eQ+mjg==
X-ME-Sender: <xms:13RoYnMamvqkfcA2oaBNm0a88HhqwVkaHZFQPLaNIDLXaw0mNGAhbA>
    <xme:13RoYh-xWovtH-DVJzn_V8LuiruzOKh_Sc-kb296Esh_7Q7e4B1gUvznVFrv-bkO3
    x-lK11oGz5r6GxRrFs>
X-ME-Received: <xmr:13RoYmScs_IcrakONaCGaiqbVndbg4fqLId39XAvHOT1UjkPQqpEva1piT73VxiqbnvOERhchNK1Boq2xRNSppVH0iDSvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:13RoYrvaDt6WU0dFtm6QtHlH5X7oOkmUY3n341lAGAElasTOmfHEiw>
    <xmx:13RoYvfnfu-rd6wFKrxqD-yzbJWfXtpf_FX3yNzi7rkqHJ46EXsEqA>
    <xmx:13RoYn1KC4hBOnsAAc9NECxZkr7KDozHkQoKKXmSfxjrOjKHORgL7w>
    <xmx:2HRoYgpd7F29aVwSTR099VdH4N5SI3i4dmnl26hF8BA9dW6u02FXuA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 18:40:23 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v9 3/5] btrfs: test btrfs specific fsverity corruption
Date:   Tue, 26 Apr 2022 15:40:14 -0700
Message-Id: <5fb8fbcf72ad2e7cca0badae1f48c695b3dd8e67.1651012461.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651012461.git.boris@bur.io>
References: <cover.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 tests/btrfs/290     | 168 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  25 +++++++
 2 files changed, 193 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

diff --git a/tests/btrfs/290 b/tests/btrfs/290
new file mode 100755
index 00000000..f9acd55a
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,168 @@
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
+_require_xfs_io_command "pread"
+_require_xfs_io_command "pwrite"
+_require_btrfs_corrupt_block
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
2.35.1

