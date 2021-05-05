Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9B53749D7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 23:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233287AbhEEVFu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 17:05:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50853 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233142AbhEEVFs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 17:05:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 14EB55C01A6;
        Wed,  5 May 2021 17:04:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 05 May 2021 17:04:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=tZZ8s1p3XaymaxBPJ8vTBzDBV7
        OqC1q3+aPNBJGE3QY=; b=p/4Jdz5CRoDfqOHFFwreQnFYksI+5rVN1CaSFHe1XL
        DxcwH5HpLHrMOf2al/71qe6RSD026+u01NzS4qhs1ZNtbWb/UKCNmvpP8grULJA7
        zahHIW/iJGZYWTIaCKAhHVGaod0mZogKwccxP7GtYNJYzKyrvlnv5v7/MAsou+8C
        nFpxCBWWdzS69ek7gBTXwnhVUE1SUlrXuYTOVK24ymyhpAW+PUxT9zIeYzJDmSaI
        75CVGps2lfBo9M3kb6nsdRaTCH29hwwkCWCAyxhc+nADdMNsT6Sc2hxhXHKfPITv
        ejW2/69kf2juLQbXaFqDI4HW1wGpZpc44G1+k/CdXX8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=tZZ8s1p3XaymaxBPJ8vTBzDBV7OqC1q3+aPNBJGE3QY=; b=LjwibFi5
        IQ/1wvv7+hbuVALeWa5q1zFcHL8/unpxb5+EjryP1rNLtXSipNpFGLbj0OYDVyIb
        adODgDoFiJYpk3Qvr9SROEpOQ8bnMduZ54/hF7yktUCzeyKnAIZ9+CB8JS397NZx
        EZBl/gaH82f0Fd8yzVRNL7/tyYqhsDzE70uIN0sWqpiL+xrvHDHS8j3fd+7utjXG
        4+Nnx3BmBxYNgHOX+gNhFmlhzEOnlYNo6JhPQXvgTiFzHZpGCZ0sE43iSjEoBzpD
        HLCL2k0PXLU4LlMIw5gz9zoT8Afw4VKH/BiFG4ITLyXyvEs5ZTN/36Bm3CHSfURz
        zLIQJTreuV+QSQ==
X-ME-Sender: <xms:cgiTYPZnjMbKpHcvub90VAnCs0beJzZNoRzS9267g3i9NMTDTfyP3Q>
    <xme:cgiTYOZj7SFwBZ42H4KVvG50zwCVhWjR8M5FYlJmnKg6QJ0CCajS7AEBVKnG9Jl8h
    icExQYNggHiI8w7XyI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:cgiTYB-FPD1Ww54_PFVIXNYY0P5SzbteSOazPo6yA2x-oVztuq4k2Q>
    <xmx:cgiTYFr01VGJ8Kmu0Pmrku2UuAAN9YPanm_CZS0b6ABLGgBWUUloug>
    <xmx:cgiTYKqq3ZyMn63NQZU6UpMbxWH61wGPex3bJhzng-6IEUNukNKdUA>
    <xmx:cwiTYPBwscGInA8mo85-IrtlJMZCh1xkSOFMtpPv9f31YVQBTX8v6A>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 17:04:50 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 2/4] generic/574: corrupt btrfs merkle tree data
Date:   Wed,  5 May 2021 14:04:44 -0700
Message-Id: <1fce7bfd74d15ddc4492a642d275eec284910950.1620248200.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620248200.git.boris@bur.io>
References: <cover.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/574 has tests for corrupting the merkle tree data stored by the
filesystem. Since btrfs uses a different scheme for storing this data,
the existing logic for corrupting it doesn't work out of the box. Adapt
it to properly corrupt btrfs merkle items.

This test relies on the btrfs implementation of fsverity in the patches
titled:
btrfs: initial fsverity support
btrfs: check verity for reads of inline extents and holes
btrfs: fallback to buffered io for verity files

A fix for fiemap in the patch titled:
btrfs: return whole extents in fiemap

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity     | 18 ++++++++++++++++++
 tests/generic/574 |  5 +++++
 2 files changed, 23 insertions(+)

diff --git a/common/verity b/common/verity
index d2c1ea24..1636e88b 100644
--- a/common/verity
+++ b/common/verity
@@ -315,6 +315,24 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		local ino=$(stat -c '%i' $file)
+		_scratch_unmount
+		local byte=""
+		while read -n 1 byte; do
+			if [ -z $byte ]; then
+				break
+			fi
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
diff --git a/tests/generic/574 b/tests/generic/574
index 1e296618..e4370dae 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -43,6 +43,11 @@ _scratch_mount
 fsv_orig_file=$SCRATCH_MNT/file
 fsv_file=$SCRATCH_MNT/file.fsv
 
+# utility needed for corrupting Merkle data itself in btrfs
+if [ $FSTYP == "btrfs" ]; then
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs_corrupt_block
+fi
+
 setup_zeroed_file()
 {
 	local len=$1
-- 
2.30.2

