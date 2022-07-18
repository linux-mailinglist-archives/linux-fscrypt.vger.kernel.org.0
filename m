Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B1578E23
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiGRXNr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiGRXNp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:13:45 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A5B3336F;
        Mon, 18 Jul 2022 16:13:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 27D035C00F4;
        Mon, 18 Jul 2022 19:13:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 19:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658186024; x=1658272424; bh=lz
        41RhC44hJZSB8wBNhpeduk4A1cB9xHfyPqzM1f0m8=; b=nZ49tRJskvY94YrZIJ
        Lxnbu+FBXwjfmtYeiLUsR2G543FLKV7isZJ+PFgztDwnZiEMg43BN/OTu7sPgOUT
        lEEjMunoaAxdajd/p+y6dvTCvPvyw+egmGyMNVOOPxSh3Saq/LDsZlbFtLAymkiK
        bVdK8F7lHmzjFyARkBebMLWVKzAw/Y2VDO2D1B4jGMvnl+t04Uwd3z1wxw/HKp69
        QUNdh0CYnKRSzrU94kIVQCwDIVm8XECoQm7vUoF6PvX4Wzh/zsEk1AWfIf/1UIoG
        FYVhGaJjImG3HqPITxUZ2NLuqTzxpIhSvaHUXp6cMBcI7a0pWdcnrY3ytATm32of
        i5Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658186024; x=1658272424; bh=lz41RhC44hJZS
        B8wBNhpeduk4A1cB9xHfyPqzM1f0m8=; b=dz0KNw6UWhAEnfL/YT3+Jd02D98z5
        r6z3dyqzteOh2rz0pgklCGuiUGL+7JoqT7ERilmr9Pj6z8KQLyn6WDGZC2zWR5vA
        DQ3N0OX1jWmSFYn76x2X1FJFt6LX+m98VBNf6paaOaZLzT0P8uKiHV/S67oU6tRU
        vC7jK5EdPjE7XwtvgEfSwl3r4nHPXv7qk9O6uTI0GOEgFnOAyX6dKG/BSZXsn0eN
        ln2z8/WVVG45nr6jq62MzXDS9p61rL5cGaX2lSdqyPUS1d1uD9DFPqIogXAYzNde
        fzBkR8dn2zt3vmnz58kNZqj6/+Hes1JNQk5LCHiNsXkF+X1zuQ6t8gzrA==
X-ME-Sender: <xms:J-nVYnGmLixk3LEAI0Gy_GlGxcV6eF_n6VDE1jbEnzkRkkBHaXLySA>
    <xme:J-nVYkWAiG9trLqP_ThEHZ9qZ6VLddoj6It1modRf247Bm56BtveuWYH4j46NebKH
    u-oglDQ9EMq7SaogJc>
X-ME-Received: <xmr:J-nVYpLzWC2yZlIfFCLLVubCHCroy9v7SCZIMSFhjyk9b0wAo6-Ov9g_G86rSQUyFTpcQEWGtw9Is4yUA5m43U7a9GD6jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:KOnVYlFNMKW7a-vmfp6P-ogW3ySecJc8pwcdNKph7vA_445BGJyLPg>
    <xmx:KOnVYtV193t5cbemQ2xOKd30k-UJAUGZQbrNa_hBfyFkikivraDK7g>
    <xmx:KOnVYgMmffPGfm_ntZEK3WFbgJIN8OrYjQRc10UriPxPvYL5ELgktg>
    <xmx:KOnVYqiIqbyh75enqgHga0fpxOSj6T2Cb1mnmQ-TUQ1eX9sjlz6_Mw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:13:43 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v11 3/5] btrfs: test btrfs specific fsverity corruption
Date:   Mon, 18 Jul 2022 16:13:35 -0700
Message-Id: <dab79d5d2a15a145c322b60ce319d009a33be189.1658185784.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658185784.git.boris@bur.io>
References: <cover.1658185784.git.boris@bur.io>
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
 tests/btrfs/290     | 172 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  25 +++++++
 2 files changed, 197 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

diff --git a/tests/btrfs/290 b/tests/btrfs/290
new file mode 100755
index 00000000..b7254c5e
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,172 @@
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
+	# ensure non-zero at the pre-allocated region on disk
+	# set extent type from prealloc (2) to reg (1)
+	$BTRFS_CORRUPT_BLOCK_PROG -i $ino -x 0 -f type -v 1 $SCRATCH_DEV >/dev/null 2>&1
+	_scratch_mount
+	# now that it's a regular file, reading actually looks at the previously
+	# preallocated region, so ensure that has non-zero contents.
+	head -c 5 /dev/zero | tr '\0' X | _fsv_scratch_corrupt_bytes $f 0
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
2.37.1

