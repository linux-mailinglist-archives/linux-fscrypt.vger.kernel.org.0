Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA617409C7D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 20:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbhIMSqE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:46:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44911 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240151AbhIMSqD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:46:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id D26E15C01D8;
        Mon, 13 Sep 2021 14:44:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 13 Sep 2021 14:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=EZMgD8gCQ0N95PL4jZnTJencwH
        VKgqAY01gdJAbHXyI=; b=0QOVp32lMYWY8IPJ1iIBx58fEV0n0oa7CYiG8OgI3f
        8q1KXVNVQH35Hqd2xIJdw+vHsfGYeTPtONcOUSMBjlmTzcTAKo9dhsgk1aLzoYQ2
        WXRchplVDwqE9sugLxf+LKwuuNLFaNOQbQkiIXU9yLcNQJ02sOWRLQvXR6XPvxFA
        rTsby9gs3foBCBj6crtI7BVvl9DOGiF17KNvrZGV1037H74VdGQnboj3tF4dwzQE
        vDJay1H7iDIUDaNRJLPzQ8Sw/tlsQXnPOMAY0jJ5afMdzVWvcH32E1JvdfSPpW5u
        NNufvslzLkXATrTUe0JCuQG2vIaDwa5HvlhWN8DzZ6eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EZMgD8gCQ0N95PL4jZnTJencwHVKgqAY01gdJAbHXyI=; b=DUiQViSd
        hExYUF2ZiluYOykzP6Anh63tjJAdjmtNDAuVNSi5f+QTLMCjk2DsT1jkcJCxca8x
        KEXJp8GHHuPcCNDY8xI1leF+EsAQm76hJII+mi/1LFmLsQgUjEv8jITmC5qEVXcM
        /PnVCHnWHCnLICI5uOs8p1bvl92TAB8ohA53r03EL8VVdDrtnRshBdUnqSFdcOfJ
        ujQrn9PsqujREaIaoLJrT/kE82WpUQ+FSQYCIdKJseeHpR5T9b/HhDKXlTEWAhec
        aoarg/DjstplGL+Xf49wXcN7AYeSyx+aEtR5HM4X5TZbkAHNBRvFvA6MNwHsdKUt
        Ar/Ht9a5LApyYA==
X-ME-Sender: <xms:Hpw_YdW2XZLgKkD8NP3xYriJnh06mZlFymd0Sm013fwzLo8xSseN0w>
    <xme:Hpw_YdlSfA6MzZONz-5u3nH-ai8T01IF-z57T7wunb9YS-N3Wp_MOfxlcA4YIUyqB
    DQMn5yhvHCrKAMptZc>
X-ME-Received: <xmr:Hpw_YZaUymLej7VLJWmAEowSdmk-5JK7knGJVT5ukiR4uktFSGWKOwISK4C0o5KOImEjW-Ax3fRCLQRleNpW-Jze2Jxeig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:Hpw_YQV062QDhVN9Lqtqh8tztGH3IbUuedlKZqe14DGXJl4AFosMBg>
    <xmx:Hpw_YXmoXAlELp2PsYAopIIhJg1Q-vXmGP9u-7OUgLztedjr_zVQSA>
    <xmx:Hpw_YdcNQ_q4MtPH0ccaCV3FvpiPFsjS1dQxlmURIvBYlysdbPlGAA>
    <xmx:Hpw_Yczr3P7jj_zqOZ2dWOKrGLzXXI2GYf5KH6QyqqcavTndtJVp2A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 14:44:46 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 4/4] generic: test fs-verity EFBIG scenarios
Date:   Mon, 13 Sep 2021 11:44:37 -0700
Message-Id: <b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631558495.git.boris@bur.io>
References: <cover.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 common/verity         | 11 ++++++
 tests/generic/690     | 86 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/690.out |  7 ++++
 3 files changed, 104 insertions(+)
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

diff --git a/common/verity b/common/verity
index 74163987..ca080f1e 100644
--- a/common/verity
+++ b/common/verity
@@ -340,3 +340,14 @@ _fsv_scratch_corrupt_merkle_tree()
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
index 00000000..251f3cc8
--- /dev/null
+++ b/tests/generic/690
@@ -0,0 +1,86 @@
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
+_require_scratch_nocheck
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+fsv_file=$SCRATCH_MNT/file.fsv
+
+max_sz=$(_get_max_file_size)
+_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
+# have to go back by 4096 from max to not hit the fsverity MAX_LEVELS check.
+truncate -s $(($max_sz - 4095)) $fsv_file
+_fsv_enable $fsv_file |& _filter_scratch
+
+# The goal of this second test is to make a big enough file that we trip the
+# EFBIG codepath, but not so big that we hit it immediately as soon as we try
+# to write a Merkle leaf. Because of the layout of the Merkle tree that
+# fs-verity uses, this is a bit complicated to compute dynamically.
+
+# The layout of the Merkle tree has the leaf nodes last, but writes them first.
+# To get an interesting overflow, we need the start of L0 to be < MAX but the
+# end of the merkle tree (EOM) to be past MAX. Ideally, the start of L0 is only
+# just smaller than MAX, so that we don't have to write many blocks to blow up,
+# but we take some liberties with adding alignments rather than computing them
+# correctly, so we under-estimate the perfectly sized file.
+
+# We make the following assumptions to arrive at a Merkle tree layout:
+# The Merkle tree is stored past EOF aligned to 64k.
+# 4K blocks and pages
+# Merkle tree levels aligned to the block (not pictured)
+# SHA-256 hashes (32 bytes; 128 hashes per block/page)
+# 64 bit max file size (and thus 8 levels)
+
+# 0                        EOF round-to-64k L7L6L5 L4   L3    L2    L1  L0 MAX  EOM
+# |-------------------------|               ||-|--|---|----|-----|------|--|!!!!!|
+
+# Given this structure, we can compute the size of the file that yields the
+# desired properties. (NB the diagram skips the block alignment of each level)
+# sz + 64k + sz/128^8 + 4k + sz/128^7 + 4k + ... + sz/128^2 + 4k < MAX
+# sz + 64k + 7(4k) + sz/128^8 + sz/128^7 + ... + sz/128^2 < MAX
+# sz + 92k + sz/128^2 < MAX
+# (128^8)sz + (128^8)92k + sz + (128)sz + (128^2)sz + ... + (128^6)sz < (128^8)MAX
+# sz(128^8 + 128^6 + 128^5 + 128^4 + 128^3 + 128^2 + 128 + 1) < (128^8)(MAX - 92k)
+# sz < (128^8/(128^8 + (128^6 + ... + 128 + 1)))(MAX - 92k)
+#
+# Do the actual caclulation with 'bc' and 20 digits of precision.
+# set -f prevents the * from being expanded into the files in the cwd.
+set -f
+calc="scale=20; ($max_sz - 94208) * ((128^8) / (1 + 128 + 128^2 + 128^3 + 128^4 + 128^5 + 128^6 + 128^8))"
+sz=$(echo $calc | $BC -q | cut -d. -f1)
+set +f
+
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
2.33.0

