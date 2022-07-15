Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5A0576822
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jul 2022 22:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiGOUcF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jul 2022 16:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOUcE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jul 2022 16:32:04 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAC1186E1;
        Fri, 15 Jul 2022 13:32:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CFD895C00F8;
        Fri, 15 Jul 2022 16:32:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 15 Jul 2022 16:32:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1657917122; x=1658003522; bh=q5
        DOQo2bazxS8RB6WteWfATTFQZIkZkhAO0NLJh/ycQ=; b=NHkPasHS33VXXPn4Er
        DOPWWnZE3dYOsmJO4yO70udexBDd+KLTvrmcGJpZtpoW5Ppk88Fw1JVYKo3WU7NB
        5RAC2fBcrhLR/WzaNnFabX6zlaOxmqllQdIXFrxHZPe5UM846pqMCTqBbfIjN5RK
        k7M4pGO40jpz9SVuY0tYRItib8rwdZAsoW2NYqDGp436EzF9LoIqP3tmljn4hPTr
        ydqRAyrtwrdExnz0a73hLL2pm4r+8jMkQih2maudk/ox6ZwBR6hryeU6VOyV8KYm
        FX9s89QM7j9pXMhsbluW0brQJVTL8RICg+ODTPKV08OOSi8aonBZel+i1BfetuCn
        UfcA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657917122; x=1658003522; bh=q5DOQo2bazxS8
        RB6WteWfATTFQZIkZkhAO0NLJh/ycQ=; b=PlT5CjJIIbUrCIk63rJe0Wb1nYzOh
        tXUMyhLdHDPdF63pu7/7FOtcRxV191tN2ANfNYXly3/YQQHrikJt+Tq3QziAScsR
        3VVoXRoz4ydfYJW7JamKDrJ4b+J+egulQticRMisdUGAVGEWcE9ge+5H+hk1dcYW
        46Rv1RU2U7mU7ByGoNMfy9X6nnytdsPSWK5tLJR2GPPRR+Y2Y6s9C1MzIW+FVQxg
        LHTUR/rKhC8+t98GTqEjtBojb70XNzfI4ltombH5V85T76WPvDd1VNCi0LvnHqxC
        X1dimil7wPX7HaEI1ZT03L1eoksZ+mW8RFmuypCQgOnLa2t4EVIshnWyg==
X-ME-Sender: <xms:ws7RYpPndg6p8Kr3FMKGgseUYmXmNW9HAAgIbR5MP3-FSvCKRVCMoQ>
    <xme:ws7RYr_HKDru2cME3-W_eufuSOJrQrV3lbTEDaJ8j6MiLocbHX7lCGx5JdOcHvw5V
    P-xvbwejl_xShUC5hk>
X-ME-Received: <xmr:ws7RYoT-RiRgz-PLaYutk1AHiWdXtlW4aBg4tUnYwbSR9M8QKL4UoCe9POwq7CNoR5CHXyil1RpCLFaM_bSgwT3cBpOXSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekuddgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhr
    ihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnh
    epgeduteffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhish
    essghurhdrihho
X-ME-Proxy: <xmx:ws7RYltieJlTC22IJJia2Xbe09l0nsmZB0NbVTdwcoLs58Kzn4Wkhw>
    <xmx:ws7RYhdnx1LPGc54e-tTIUT0aka0dI5bujthNi_IggldiBvL6RKkLw>
    <xmx:ws7RYh0roOFs6ivY4xH2dfkar5MCiv2wLhnq4_B7nCUtbm0Aq3jPRQ>
    <xmx:ws7RYo5mRAW2LtVkVIiJ4UbDZLnbCdQFG6utKHLw7OTBUkLsSlL_eQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Jul 2022 16:32:02 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: [PATCH v10 5/5] generic: test fs-verity EFBIG scenarios
Date:   Fri, 15 Jul 2022 13:31:52 -0700
Message-Id: <97cbee79e4d59f2080bc033c921e0b7aef651327.1657916662.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657916662.git.boris@bur.io>
References: <cover.1657916662.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 common/verity         | 11 ++++++++
 tests/generic/692     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/692.out |  7 +++++
 3 files changed, 82 insertions(+)
 create mode 100644 tests/generic/692
 create mode 100644 tests/generic/692.out

diff --git a/common/verity b/common/verity
index f9ccf2ff..786e11e3 100644
--- a/common/verity
+++ b/common/verity
@@ -351,3 +351,14 @@ _fsv_scratch_corrupt_merkle_tree()
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
diff --git a/tests/generic/692 b/tests/generic/692
new file mode 100644
index 00000000..0bb1fd33
--- /dev/null
+++ b/tests/generic/692
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Meta, Inc.  All Rights Reserved.
+#
+# FS QA Test 692
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
diff --git a/tests/generic/692.out b/tests/generic/692.out
new file mode 100644
index 00000000..05996713
--- /dev/null
+++ b/tests/generic/692.out
@@ -0,0 +1,7 @@
+QA output created by 692
+
+# way too big: fail on first merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
+
+# still too big: fail on first invalid merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
-- 
2.35.1

