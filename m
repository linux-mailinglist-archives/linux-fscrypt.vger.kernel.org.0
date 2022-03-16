Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933324DB957
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 21:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357938AbiCPU0v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 16:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357916AbiCPU0u (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 16:26:50 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9454849F03;
        Wed, 16 Mar 2022 13:25:32 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CFB0E3201F7B;
        Wed, 16 Mar 2022 16:25:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 16 Mar 2022 16:25:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=K9PPSGkc2e5BRTkUvpmHCZvk339Rzh
        ttEZFwKOqMMTM=; b=QZwCQrMVxsUYgiOup+6eW/k2eilhcQj50NlOoAWpBSLplJ
        aQVBFsSR45SPW7Fvi/bA76eY8aezlPGMRLANwEiCGSyiEb2SC76WVMjj9idnxwdF
        V6/1ctxhYrAaykXHvTN5X+wTnJOAHJGjc1Bj8rBD+ZBDEgPZ8M5lL9dWDsfKFTMF
        q7k9e4GA0ef8wN/NQRvnsBirngOVhOXAn9wtS9EOTAGDlbasf6k8iZITOX+Oacmr
        uTCDSjiWJRf8tZpIQt2uE746MNxBCP2IexdWw23lKT8c4qiNcZWy7Sqja3RpZ6UZ
        J5IlTcI6bgUYt2ybJBk5Usj9tcfPenOdScVWdZJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=K9PPSG
        kc2e5BRTkUvpmHCZvk339RzhttEZFwKOqMMTM=; b=CbGiL9QGIYdvZQXYunW2fY
        rFE0oBNWukDpC4pnV8JOQ5TPN+wlKyFFbo81ajWjsg+TcaDvXjKna8ncl6iSSDPc
        kPq+k+AopkQm2tzgI7cpKEsxBY6ceJk+hpCuFOshxCNCM3MwWMM62gR86QW8i6E0
        cNNZmSj3miQq3a+cSrwJW27fwugTRgGumHLpmLXZ2ecFulXRfkRY05fsDcSIbxVM
        JmoIlZBHv3We0bbm+cgJtj1HN4o4vBjwWjKx6viMQxfFocsz2ecjcFWvIAQ1Lemp
        ohUZEHSS+fk5DwCxZGVEsKTn9CVJvI5SwETMsS4vs8UqF1AOmD/0xk8XGukny1nA
        ==
X-ME-Sender: <xms:u0cyYoDkd1FNI8wT_IXb_nByXqNnAG3JSzsmkcAZWYBqOWNEK98g5Q>
    <xme:u0cyYqhmTVUvj24dLW5tnq3_qChRHkXvS67BM9y2_b3CVN0jKVSfG5tl_F70ihCML
    dik8j8MaMl85w8yX5I>
X-ME-Received: <xmr:u0cyYrn9byav6Unbl85YJClUcGAx-hXpntX6n87_WEeVQ7KlKS-9LU6oBHcxft-M6wpVH4Ojn8G54o_cyX8JlC3qg88hWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:u0cyYuypEpWn-J0jW9jY8_cNNt3Ew_ELEBJWdt4qFLPtRGKz3MM9FQ>
    <xmx:u0cyYtQlcMcIjFdG9i6MBjt6R51FCF27HDTTf0cjKznvn7CZr9sQ5g>
    <xmx:u0cyYpYvE-WUWpS6btYMBNMR_dneHeiIr_ZNNvBkowyLDV2GsTWlOw>
    <xmx:u0cyYoeZYj0TuVqup354GsPQ49dlMyHlk2VUxxSpHr23AGVgBpDKEg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Mar 2022 16:25:30 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v8 5/5] generic: test fs-verity EFBIG scenarios
Date:   Wed, 16 Mar 2022 13:25:15 -0700
Message-Id: <a49cc77ece554918995f3dac756b5551a50f71c9.1647461985.git.boris@bur.io>
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
index c6a47013..8d08d3ea 100644
--- a/common/verity
+++ b/common/verity
@@ -342,3 +342,14 @@ _fsv_scratch_corrupt_merkle_tree()
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

