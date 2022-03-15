Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83FA14DA522
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352131AbiCOWRZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352148AbiCOWRY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:17:24 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247CF5C379;
        Tue, 15 Mar 2022 15:16:12 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 7CD8E5C0200;
        Tue, 15 Mar 2022 18:16:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 15 Mar 2022 18:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=B7aWnl6o+/fwtAlM3Qm/DL+gMV/6dV
        zUA8OGnisteTc=; b=MwWR1209ql1+TZJio4Qb1HZOmmvUK0JhtWX6BTYueS07qI
        OFHYI2sA5PLBB4wB97KfB9AH05qTERzvFjlkWXb0HBgb5WZ8nAIvgHbI+WfBkxPC
        ClBM7R1SF63sGhE7on/vmOak8vkQ5FxJ0s1qaPK9f+V42+cOJLc1YJE5tuTwITs5
        Jnp9iHv+K30TKTofsJcpB4PNl8scHXsn//PuZwLx9p9wLrf1enz0JiMfV9E9uxxJ
        CUFcLJfKDshqOoQlgGkiA63GeQDag4TPMBjPjFg9fS0g6gd7V85RFkKHypfv3rq/
        HkfWfGynx0SlE1unkbq9+1Wd1ITFRPtx8toOhxbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=B7aWnl
        6o+/fwtAlM3Qm/DL+gMV/6dVzUA8OGnisteTc=; b=Vr50i+E08m8jNox/C80lPu
        svvv7wIk7q8RXiuBbUMMMnyFwDxLys+aj4c4wr26X11vrfzBCI1CDUuwGAN7Ll5f
        NIFBZtXN2eVi4wFBLfNU/fo2cdhGAt2x04C86FpJpIYyCPTNySjdt7LQM8I+NIOC
        yANbzN8wbumRxz271Gm1uEAJDt1a1SA0rMm6+tejRJLyLoujsQehSUZrCoCQIgkq
        QGXmB43fYwjjJMZQJhyrhxOOE6ab0CGeAUMvr/9kyhdTWj5tD4psIXDdcdUNQbmf
        jMn8vi21qqlg1/61t0PnesACHuOuHZg2mu3FIO2yU7vO8ZjrReisnk5DLCB4sKZA
        ==
X-ME-Sender: <xms:KxAxYlYKUozIrVs-XxsoXQVBpc0ED1tDEc8BxYFcMIEaYU4wnpdMtA>
    <xme:KxAxYsbGddekGc02ARwyvguLuUJzX_YN5epbOWEt27NezmEBw-UgL461Wsul4N1CF
    u_RCqtotzFAjlS3QPk>
X-ME-Received: <xmr:KxAxYn_eo3cQVPeWNOLyzlKBknJgojPqoFzISe4R-BT5h9SAbdCMv8Qu0CRvZkjo7cMf0R9qtKZ7x_BNEfLjnfV_MPn5ag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:KxAxYjpCo67WjTiFD2XmAXiyh8jShT_hoGGAF5GLrgUhCeDpxHKOww>
    <xmx:KxAxYgoTv54lb7gGOUbuKKKJjT7PLACPi5iBbQSSurDz397F397JaQ>
    <xmx:KxAxYpSzlPwJKFj1Y8Slw9LwiEoJ7jvjZgrqCWCChMCvwThQMTLw5g>
    <xmx:KxAxYn23sdassGALvQxeicZWTHDDcHecWxXtngiZ_F98asoQkYs9zA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:16:11 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 5/5] generic: test fs-verity EFBIG scenarios
Date:   Tue, 15 Mar 2022 15:16:01 -0700
Message-Id: <b07e3b6cc2d44310a0d46f68d2031ef60f3af4cc.1647382272.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647382272.git.boris@bur.io>
References: <cover.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs, ext4, and f2fs cache the Merkle tree past EOF, which restricts
the maximum file size beneath the normal maximum. Test the logic in
those filesystems against files with sizes near the maximum.

To work properly, this does require some understanding of the practical
but not standardized layout of the Merkle tree. This is a bit unpleasant
and could make the test incorrect in the future, if the implementation
changes. On the other hand, it feels quite useful to test this tricky
edge case. It could perhaps be made more generic by adding some ioctls
to let the file system communicate the maximum file size for a verity
file or some information about the storage of the Merkle tree.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity         | 11 ++++++++
 tests/generic/690     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/690.out |  7 +++++
 3 files changed, 82 insertions(+)
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

diff --git a/common/verity b/common/verity
index db03510e..2b3d4dae 100644
--- a/common/verity
+++ b/common/verity
@@ -348,3 +348,14 @@ _fsv_scratch_corrupt_merkle_tree()
 		;;
 	esac
 }
+
+_require_fsverity_max_file_size_limit()
+{
+	case $FSTYP in
+	btrfs|ext4|f2fs)
+		;;
+	*)
+		_notrun "$FSTYP does not store verity data past EOF; no special file size limit"
+		;;
+	esac
+}
diff --git a/tests/generic/690 b/tests/generic/690
new file mode 100755
index 00000000..afdd95f2
--- /dev/null
+++ b/tests/generic/690
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
+#
+# FS QA Test 690
+#
+# fs-verity requires the filesystem to decide how it stores the Merkle tree,
+# which can be quite large.
+# It is convenient to treat the Merkle tree as past EOF, and ext4, f2fs, and
+# btrfs do so in at least some fashion. This leads to an edge case where a
+# large file can be under the file system file size limit, but trigger EFBIG
+# on enabling fs-verity. Test enabling verity on some large files to exercise
+# EFBIG logic for filesystems with fs-verity specific limits.
+#
+. ./common/preamble
+_begin_fstest auto quick verity
+
+
+# Import common functions.
+. ./common/filter
+. ./common/verity
+
+# real QA test starts here
+_supported_fs generic
+_require_test
+_require_math
+_require_scratch_verity
+_require_fsverity_max_file_size_limit
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+fsv_file=$SCRATCH_MNT/file.fsv
+
+max_sz=$(_get_max_file_size)
+_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
+truncate -s $max_sz $fsv_file
+_fsv_enable $fsv_file |& _filter_scratch
+
+# The goal of this second test is to make a big enough file that we trip the
+# EFBIG codepath, but not so big that we hit it immediately when writing the
+# first Merkle leaf.
+#
+# The Merkle tree is stored with the leaf node level (L0) last, but it is
+# written first.  To get an interesting overflow, we need the maximum file size
+# (MAX) to be in the middle of L0 -- ideally near the beginning of L0 so that we
+# don't have to write many blocks before getting an error.
+#
+# With SHA-256 and 4K blocks, there are 128 hashes per block.  Thus, ignoring
+# padding, L0 is 1/128 of the file size while the other levels in total are
+# 1/128**2 + 1/128**3 + 1/128**4 + ... = 1/16256 of the file size.  So still
+# ignoring padding, for L0 start exactly at MAX, the file size must be s such
+# that s + s/16256 = MAX, i.e. s = MAX * (16256/16257).  Then to get a file size
+# where MAX occurs *near* the start of L0 rather than *at* the start, we can
+# just subtract an overestimate of the padding: 64K after the file contents,
+# then 4K per level, where the consideration of 8 levels is sufficient.
+sz=$(echo "scale=20; $max_sz * (16256/16257) - 65536 - 4096*8" | $BC -q | cut -d. -f1)
+_fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
+truncate -s $sz $fsv_file
+_fsv_enable $fsv_file |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/690.out b/tests/generic/690.out
new file mode 100644
index 00000000..a3e2b9b9
--- /dev/null
+++ b/tests/generic/690.out
@@ -0,0 +1,7 @@
+QA output created by 690
+
+# way too big: fail on first merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
+
+# still too big: fail on first invalid merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
-- 
2.31.0

