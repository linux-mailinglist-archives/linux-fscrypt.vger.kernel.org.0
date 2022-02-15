Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11224B5ED8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Feb 2022 01:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiBOAKP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 19:10:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiBOAKO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 19:10:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BDFA66DF;
        Mon, 14 Feb 2022 16:10:04 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D798B5C02DF;
        Mon, 14 Feb 2022 19:10:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 14 Feb 2022 19:10:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; bh=mtzBVuwkZ5pbeJVVBQ3oB1V/yIywmA
        4xvSw0LlnEDZ4=; b=e/S5SCnT25jWhPBSlD4jfm9KcqQxxPODdp5ZCVb+kpD3Yk
        RsXsQ+N6WlOPCahorny04VI/aRGwT1mKd2SynnZz6ZrdqqynMJHW2+gX7iQpDtch
        H+U+OoVJduXnkOaWxOsMpjyDTca4YOjYXvnrEaMX20DCqfCJQOFFmoeD0WjN2FQx
        RfkshWojwM4Vxi7DB6JRRxlUyxGSaJoAte3Gj8LSz9eLRzyHjQ7P1+CBVHOhAMQb
        Al1fRklzYqWMEeZFqcAQ0akrdoex1ogsAxim93gamy9Pn7fp5YWVdFKyBSZZC3Yb
        K7Djw938CbWBDUQFtSk4hiln03GT8tfxtAvi38Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mtzBVu
        wkZ5pbeJVVBQ3oB1V/yIywmA4xvSw0LlnEDZ4=; b=bVYXklS1RQcXL/aCpW/7GI
        vJyW6Qlou7+LEnk0AdasGD1JwLpogBz3A86fSvSffG/nOMs3r3pLu/JozNFcve2o
        fzFKURYD+LFmQMNGwi1q1aHLp48PRplXcIaYt+Btq02lPv7vth8oWXlDCdaoxfqP
        Txs9zL4Itl3RlReqhnYD2ssY2kslkMhS9tMsnLgpc1IzrZB3FoP0QdExjSukUaw+
        coNYuz9VnQFYDBHUMmfzofWJx686RPCyz2+g9JqB23Hx1jSYKU3AJay8p+JSuCLn
        cJ2FDuCQODS//lK/linGJNw4SwKl0SWcCkXtXl+ZKJAtqA2Vc5EVhcwaJ25h2dUw
        ==
X-ME-Sender: <xms:Wu8KYlp3HfahAfTS-W_Fla2Rd-yka_oCdHHWnSzo67sdzqA-5gyBNA>
    <xme:Wu8KYnrJtJ6mYZOj_2IHwrBK67jG8nXM8R4dH7iSnxWqOSNhXkM_vT-xCcPaqBPUl
    _YPCgTPjR0_G6nUABM>
X-ME-Received: <xmr:Wu8KYiO91X--XWCiskw6DP2sN3dGADnOvMNVxlOdXXqIzP3aLIdWcHlmwzLkeugkgVnh5LUtNFt8nJ7Qkef1Eo3RaqeYRQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:Wu8KYg5mFnGZQYXLHcXCXb9Co97S_D-GQv6FZCHCdJSYW2oK_r03RQ>
    <xmx:Wu8KYk7MZbvxFnt04tWM9SKM_vQY4qzTRPL-wC6nQRoh5ZMxaNZLkA>
    <xmx:Wu8KYoittLzSZvTP7DogIVmrAX_UlunfMrZde4JPpHfS4OtlsLL4BQ>
    <xmx:Wu8KYkHVFBhtdOQ1Ur3cBoShaxzrBS-mtU7CVjVK3EanWG6Vjdd3YQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 19:10:02 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 1/4] btrfs: test btrfs specific fsverity corruption
Date:   Mon, 14 Feb 2022 16:09:55 -0800
Message-Id: <de58122e6cb1712fa5304f0759b40b36351dfc36.1644883592.git.boris@bur.io>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1644883592.git.boris@bur.io>
References: <cover.1644883592.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 common/btrfs        |   5 ++
 common/config       |   1 +
 common/verity       |  14 ++++
 tests/btrfs/290     | 166 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  25 +++++++
 5 files changed, 211 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out

diff --git a/common/btrfs b/common/btrfs
index 5de926dd..6eb574be 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -496,3 +496,8 @@ _require_btrfs_support_sectorsize()
 	grep -wq $sectorsize /sys/fs/btrfs/features/supported_sectorsizes || \
 		_notrun "sectorsize $sectorsize is not supported"
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
+}
diff --git a/common/config b/common/config
index 0566ab4a..8cda36be 100644
--- a/common/config
+++ b/common/config
@@ -295,6 +295,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index 38eea157..eec8ae72 100644
--- a/common/verity
+++ b/common/verity
@@ -3,6 +3,8 @@
 #
 # Functions for setting up and testing fs-verity
 
+. common/btrfs
+
 _require_scratch_verity()
 {
 	_require_scratch
@@ -48,6 +50,15 @@ _require_scratch_verity()
 	FSV_BLOCK_SIZE=$(get_page_size)
 }
 
+# Check for userspace tools needed to corrupt verity data or metadata.
+_require_fsverity_corruption()
+{
+	_require_xfs_io_command "fiemap"
+	if [ $FSTYP == "btrfs" ]; then
+		_require_btrfs_corrupt_block
+	fi
+}
+
 # Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, as well as the userspace
 # commands needed to generate certificates and add them to the kernel.
 _require_fsverity_builtin_signatures()
@@ -147,6 +158,9 @@ _scratch_mkfs_verity()
 	ext4|f2fs)
 		_scratch_mkfs -O verity
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
diff --git a/tests/btrfs/290 b/tests/btrfs/290
new file mode 100755
index 00000000..0276527d
--- /dev/null
+++ b/tests/btrfs/290
@@ -0,0 +1,166 @@
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
+_require_fsverity_corruption
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
2.34.0

