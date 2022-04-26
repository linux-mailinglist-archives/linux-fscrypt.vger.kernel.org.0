Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C110F510C24
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 00:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355915AbiDZWnh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Apr 2022 18:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355909AbiDZWng (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Apr 2022 18:43:36 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D3314096;
        Tue, 26 Apr 2022 15:40:27 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 531905C0164;
        Tue, 26 Apr 2022 18:40:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 26 Apr 2022 18:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651012827; x=1651099227; bh=I+
        HxmkzZNhZ0P3kPMHejig53XLe7o7IFnigO5Hnymis=; b=dD5voST/UNPV3LAvqm
        9YFkDYbX/aUWFcvPheEKOB9ZesQWvlj58+IiWZRtxd1QaRkQk3JaiHN9PI8Dy+9j
        eB3RDd1Ftkh97dfpVyWZnFYuK9CYmeAP7LeUmHIqjFz2UuwEyWw1/Jx22QX6WuGC
        qMtuV7UMyBjN25ZtcWAkrRAvvx+t2pgHPLhTUdf2DhzMqeJPoyDU7MfmPztWwNwj
        boiQCoPDSIJEgaRKQ2bx2d5Te0AC71+KDZhYOn1qDuwYfGwMaf5KnI1iE4P2qxMb
        AwDVTdcwghlpPiVh46MyJxTmXQ/lxO0U6kNOoHRyXQ08VGMdPriofvMHEks8p8eq
        j2Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651012827; x=1651099227; bh=I+HxmkzZNhZ0P3kPMHejig53XLe7o7IFnig
        O5Hnymis=; b=LwFgGjVq0k+hb1XkNxidvjbI/g1kz0XShklE4qfDjS8mh38w/pt
        oHrVmFb7Ba7VfJWgF2+lYXwvf70RTmRKIpH0LakWwHxKQCi9/+vrwkMDEgDcajGh
        Hrx/GO4OCVzP8H1GA/B2aK9cpdIDpwLb58lmDgJ0MoSEanZApwrtzECHv9VM5PKZ
        Ngl8F3/psUE8XYHS/oWAafr78nlsPfUjqnPljP+CItLGFIxs/N1mliepHCOyXD9e
        HqzWHei7AAd0rNOf2derMPLJ3ZLtuCNsxcDPisHmW2c4Qz7lSWdK6DsqpIniBr9Q
        xJ+PNfz3Z0OnrpWVhhIpQJ8XEHvj7EqbhZg==
X-ME-Sender: <xms:23RoYkpX7aaMhPLNqPKUIyjwjP1LKyUYoIYuODXOV5-nEp5i5cmlIw>
    <xme:23RoYqrCqDsmYk8XRVav1b-xiTnXI3ts6SCd3Egv9ztsVuiKRh2UmefWTdctvgNMN
    weq36tnUeOou1Xn0XA>
X-ME-Received: <xmr:23RoYpP21939iUrWdZ0Mbct8G3X-nkpQaRcYMJc8SvZQnEzLwM70ybzDU1QtfKvZmCTqcC30kwysL8dmZpwH7HiJyBQVRw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:23RoYr5644pLsXLXZBUmO5_OjZOYdhRZV-ZU4ibc-2uchP2kpM_Jsw>
    <xmx:23RoYj67jarRgCzK4AfCxZmJjp4uIUx8IME_IVOVDi0KjW5r0yArXQ>
    <xmx:23RoYrgJodbh2IIZbqWXrB2NG05mvpEIoXJTCYjbG7S7S7Rlhpq-tg>
    <xmx:23RoYjGyUVIqUGjaX3o376xSga6eewBSKg7Bu1xieAgWyW97gMU0Hw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 18:40:26 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v9 5/5] generic: test fs-verity EFBIG scenarios
Date:   Tue, 26 Apr 2022 15:40:16 -0700
Message-Id: <b79c0fe9c23a5911943f797dedb25f28f1759f73.1651012461.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651012461.git.boris@bur.io>
References: <cover.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 8cde2737..657af8aa 100644
--- a/common/verity
+++ b/common/verity
@@ -347,3 +347,14 @@ _fsv_scratch_corrupt_merkle_tree()
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
2.35.1

