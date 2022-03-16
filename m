Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D0E4DB952
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 21:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357859AbiCPU0l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 16:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357852AbiCPU0k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 16:26:40 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1126649F03;
        Wed, 16 Mar 2022 13:25:24 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 004F83200F72;
        Wed, 16 Mar 2022 16:25:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 16 Mar 2022 16:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=UrTD+OwwNy5sqifVd5EB6Kp+h0vfMo
        6NvpfhP+v5+lw=; b=LWkft4z8FMms1KPgxdGq6mRGCMfBHM36lsOqLykTNWqBSu
        M9kVLMKytFUbbajsSXbv8XzlrqJR1iP7M29GZ9aTdaXk5d2qI2nnMUBXu4mHfQLp
        4fUK9/KzfpVR2YdoDpG2jZwv+nHff95P3p2nrtYl1jtufKDgl7B+lCNs00K8N2u9
        9qjd9W+UlyX+oeAjc7nDI6fEQ+p4Wf11JocKD5oy136ruFzvxPLsrkbEHrffWQQH
        IrY61hks7YSKvKMvKGBdeowAemG0ADMZnoBB0HVdlC918bJy8f2h2trFl3+FdoCL
        gZibIk4eSEnT99P6qKYQ+iyclmVXoIh1RM2ijNkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UrTD+O
        wwNy5sqifVd5EB6Kp+h0vfMo6NvpfhP+v5+lw=; b=FX7sKtFAVl8Wel390J7RXc
        5jmdq2qVzdJ1gdvDvzC5WW7gK6NAeycNyaf+xBY6/da22PB64+KE1LIYfDEbgN44
        3z3IM5l9ruMIBCwC4gHYNyLTJ1cTmDjExeumrbFuj8FQdq+2gKIfypQjINAT9kUC
        nsZmxpvEPd5TTN5BhE2jwyt/V8ObqCaUtBwyIEhHQNZI3Tdc9VvTKZts/fRo4/3I
        lWQ8WPuf/pJ8HQN3kHxIRzG0SnU/drvfUDbXelodmBrT1usk/tHOK+0YUlDP7h5T
        kVE1x9HXJGOrgfBdL091BCllVGSjnfcq3Y6isUnbAE/eEU1BUiKDgveWvQ9Kivbg
        ==
X-ME-Sender: <xms:skcyYpBOvmGDcdKleqdt1s2k4fVV2gWSWtMbDunnaaNAQEUIymkAOA>
    <xme:skcyYnjvUi20B-pRejoDhOfg7vLGDe11NR50FTa5rd93mjgN-Oew2AGcUVQLgOVGX
    QWHG133WLKGxsVNYSE>
X-ME-Received: <xmr:skcyYkkedplc-RjW0UYnGeWycv39M4hpG9sy5vzzKhwIdlbwllbf2q82moOLr0REPPMZz74ZSJeeWyzQRE1J1JnFaN6_BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:skcyYjznr_S_bfPMDRcpgIxs6uNcNo0Hl71gk7wBCHXb8NunJUqgrQ>
    <xmx:skcyYuQgOah-hCz0RZXu7fMnzCBLau_O3OhGvIjb1bZttQD0oM1bRw>
    <xmx:skcyYmZ19n5Q_g3GxjYyuKUsF9iQm37IUhiA7DXVShVTs8rbkQNP3Q>
    <xmx:skcyYpfmiUSkIpQKkxplQ30fUN_N0NAinsfEeXQT7zP-PAP28YAc3g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Mar 2022 16:25:22 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v8 2/5] common/verity: support btrfs in generic fsverity tests
Date:   Wed, 16 Mar 2022 13:25:12 -0700
Message-Id: <9c64fbf9ad37dc84a31caf91762edd64b33d59db.1647461985.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647461985.git.boris@bur.io>
References: <cover.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/572-579 have tests for fsverity. Now that btrfs supports
fsverity, make these tests function as well. For a majority of the tests
that pass, simply adding the case to mkfs a btrfs filesystem with no
extra options is sufficient.

However, generic/574 has tests for corrupting the merkle tree itself.
Since btrfs uses a different scheme from ext4 and f2fs for storing this
data, the existing logic for corrupting it doesn't work out of the box.
Adapt it to properly corrupt btrfs merkle items.

576 does not run because btrfs does not support transparent encryption.

This test relies on the btrfs implementation of fsverity in the patch:
btrfs: initial fsverity support

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/btrfs  |  5 +++++
 common/config |  1 +
 common/verity | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/common/btrfs b/common/btrfs
index 670d9d1f..c3a7dc6e 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -511,3 +511,8 @@ _btrfs_metadump()
 	$BTRFS_IMAGE_PROG "$device" "$dumpfile"
 	[ -n "$DUMP_COMPRESSOR" ] && $DUMP_COMPRESSOR -f "$dumpfile" &> /dev/null
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
+}
diff --git a/common/config b/common/config
index 479e50d1..67bdf912 100644
--- a/common/config
+++ b/common/config
@@ -296,6 +296,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index d58cad90..c6a47013 100644
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
@@ -145,6 +147,9 @@ _require_fsverity_dump_metadata()
 _require_fsverity_corruption()
 {
 	_require_xfs_io_command "fiemap"
+	if [ $FSTYP == "btrfs" ]; then
+		_require_btrfs_corrupt_block
+	fi
 }
 
 _scratch_mkfs_verity()
@@ -153,6 +158,9 @@ _scratch_mkfs_verity()
 	ext4|f2fs)
 		_scratch_mkfs -O verity
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
@@ -314,6 +322,21 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		local ino=$(stat -c '%i' $file)
+		_scratch_unmount
+		local byte=""
+		while read -n 1 byte; do
+			local ascii=$(printf "%d" "'$byte'")
+			# This command will find a Merkle tree item for the inode (-I $ino,37,0)
+			# in the default filesystem tree (-r 5) and corrupt one byte (-b 1) at
+			# $offset (-o $offset) with the ascii representation of the byte we read
+			# (-v $ascii)
+			$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b 1 $SCRATCH_DEV
+			(( offset += 1 ))
+		done
+		_scratch_mount
+		;;
 	*)
 		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
 		;;
-- 
2.31.0

