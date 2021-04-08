Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41FC2358C93
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhDHSa7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:30:59 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:42561 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232666AbhDHSaa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:30:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 3FC0211F4;
        Thu,  8 Apr 2021 14:30:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=Mgk/B0dlPhpxiSE4tISOsRzgWo
        gtoCcTTbyWOOFMNF4=; b=jEL90Gs5+DkRZX6ErnX93ngGfStzhqR2AwMWDK6ywC
        raGw2Qv+4+zjcIaFGyBZutoWJdMWS6ho4R4PtLJrqqbe3nngna3E2Sp5xc8R6sDf
        /lVWHjyy+6Ajlg5hI7MV9qD/sTXgsx17OIXiS6Y25kEwVX1df2QDj4n+nxfKiUqh
        uBzYXKP4AAn1JfWzxhops0FeOF+LnrkyeThOkqVjJz6p2NLtQ6LoGgkhLt/bLy9U
        UsulnUkI3Np3bLmLoA12Y/u6J2Jk5fnQAMIv0rbeIqOQZzQ9m197IUsAwbomBEPH
        PQzwSz0NXFo+8VZiYPHp19ghxYTdOjfwctr7kO40eyMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Mgk/B0dlPhpxiSE4tISOsRzgWogtoCcTTbyWOOFMNF4=; b=ecYMWJmx
        BbiOcinXe+HprRSemVoH98yROgFd9flyn0xWJ60t7XBQCmaFSPJ8bfLlnZAginEy
        bEI9Zw2qdCLqFFwOLRGUrzaEAX6rah+YuqEvAIKmTRv2LZeP66G04S5L0ZBHR6pP
        KAH5DI18MN9rIpR+5/Y/5fXKjtyjL6VWunij9pT3VDqJ65C3QHn0+dnCBp7wT9bZ
        neNWCOWZNBt6pplUBTE8Mu8/Ykvxn5ZyAYWyT5XvtGEY3jzlsDT8Iv6XZ6zsk1WE
        xKA3ZVoux1RbczS69n/7QA7EedcPsbS6FIy/mEw8Cq9Nm9FEbAqqTnbrms7aJSfU
        hdIDGnz/xryoyg==
X-ME-Sender: <xms:uUtvYGELHf1hSISfBZSKTr6-7sahYCxqGNyOLfAguNUpLaTe4SdDjg>
    <xme:uUtvYHUa-cBcRMr5Ec61HwMWjQxrgvL1Td2ID6xexTVJ6PpVhuPgFsZmztv2GZhug
    mUvIgt1mbrAn9xrqoo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:uUtvYAK6EckS-Ha5ZtNApOCX_k-WbJblcgTC_IbQFadzSiZul-6MWQ>
    <xmx:uUtvYAFrZQQ3ZwBMpXb8PZQOTKspQoxsFffx3SMmkuJZt6eh0dWvYA>
    <xmx:uUtvYMU5gbyOrLB347Dbzm4b1FSZuhxBKJBcxk-x38sfT2KEeg4DWQ>
    <xmx:uUtvYHd1BMCIE6MP43MHNLqH98Wvu7TnLoWOQgC-dNUKwzuDfE90wQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F0511080054;
        Thu,  8 Apr 2021 14:30:17 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 2/3] generic/574: corrupt btrfs merkle tree data
Date:   Thu,  8 Apr 2021 11:30:12 -0700
Message-Id: <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617906318.git.boris@bur.io>
References: <cover.1617906318.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/574 has tests for corrupting the merkle tree data stored by the
filesystem. Since btrfs uses a different scheme for storing this data,
the existing logic for corrupting it doesn't work out of the box. Adapt
it to properly corrupt btrfs merkle items.

Note that there is a bit of a kludge here: since btrfs_corrupt_block
doesn't handle streaming corruption bytes from stdin (I could change
that, but it feels like overkill for this purpose), I just read the
first corruption byte and duplicate it for the desired length. That is
how the test is using the interface in practice, anyway.

This test relies on the btrfs implementation of fsverity in:
btrfs: add compat_flags to btrfs_inode_item
btrfs: initial fsverity support
btrfs: check verity for reads of inline extents and holes
btrfs: fallback to buffered io for verity files

It also relies on the btrfs fiemap fix in:
btrfs: return whole extents in fiemap

and it relies on btrfs-corrupt-block for corruption, with the
following btrfs-progs patches:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/common/verity b/common/verity
index c0b0c55d..333526ac 100644
--- a/common/verity
+++ b/common/verity
@@ -3,8 +3,7 @@
 #
 # Functions for setting up and testing fs-verity
 
-_require_scratch_verity()
-{
+_require_scratch_verity() {
 	_require_scratch
 	_require_command "$FSVERITY_PROG" fsverity
 
@@ -244,6 +243,18 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		ino=$(ls -i $file | awk '{print $1}')
+		sync
+		cat > $tmp.bytes
+		sz=$(_get_filesize $tmp.bytes)
+		read -n 1 byte < $tmp.bytes
+		ascii=$(printf "%d" "'$byte'")
+		_scratch_unmount
+		$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b $sz $SCRATCH_DEV
+		sync
+		_scratch_mount
+		;;
 	*)
 		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
 		;;
-- 
2.30.2

