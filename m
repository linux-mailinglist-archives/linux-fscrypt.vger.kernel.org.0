Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA6578E9C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235082AbiGRX7Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiGRX7I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:59:08 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B926E33A1D;
        Mon, 18 Jul 2022 16:58:44 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BB2395C00C5;
        Mon, 18 Jul 2022 19:58:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 19:58:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658188723; x=1658275123; bh=qy
        7N1GyHcvwMceOhY4MUI5S8Z6Lx7/pKZC1pdl3g7J0=; b=c9E2rEzpaKRTGh6hw2
        HXVevhm8R6auLAnzy51YD9veW6ck2zOWWN+b02w3myq663oIhsEVMUw10v39limd
        /wbEIQnwPVVuV5ag91Gm1bc5/ABUQS5be7+l3Y9F4WBxV1As0q4nclLzEkinGnX3
        npbk/yPuLrkms6Oy816IJwzE3z8YdT9klJj1EZLJ2+ILrrjQuFX4X4IwUm71gXaQ
        srvGdjvDe43cvjTCQSw5hyEEipZLUsFeyoygYUZwjXdD1KBLxcCHtDIw7GQaQPWj
        qbiKn7Q2f4m2S+E92ShS6LRL5bEzU4ej66AWUQ4x13OuKTfyb41KHMom8mdScZaU
        ehWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658188723; x=1658275123; bh=qy7N1GyHcvwMc
        eOhY4MUI5S8Z6Lx7/pKZC1pdl3g7J0=; b=IWXM5a7bdaKyBTpC/kLvJ8FDQ8udx
        Ohr2wYy9oDalpCGBFCn3T+vvdOZw56p5xFVVLHVWZBJfEcCyFhK+2olwpwZmL9aU
        qYlIyLG/c9vTgrs/3EfFYmTjObG3azlCeqEXfbJg8Kdxxfcxy04Ax/dF3Fe45gWq
        YCl8bTAje5CpH2J/OX+hSJrvuQzoZ9OYjcQ12fdTPl9H8saIl30eweXzmlfyGv1l
        VnEzA+9chxPVC4i3gX+X55SWTeHbteQxDJ8GHfIwCo1SNFcnK9ICvAIDSeZMPYD/
        5q/W/4hS4IgOXn6YRc735HHtW/Vp0J/Y6PKWk2dyOW1Hj6Ah6s/edEAxQ==
X-ME-Sender: <xms:s_PVYn2Vc55No_QP9ienUYM0dWpE0HZ02mxTvC2fqQhyAkggqnXj0g>
    <xme:s_PVYmEQt8wMU9kpEPIcPJQeaQTveMwbSc0lpRJjc8Rg5l_wcQYt29qempdZ-RMHv
    XfmVuJV6TppFeAk1Nk>
X-ME-Received: <xmr:s_PVYn53ddHBtrjPKTz8OC42CGvwawxamTehFDqXw4tfuQrp6aQ13tg4IUe-wJIArZa4NbxgnzUilAGIXvDHnPeCm7rROQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:s_PVYs2AamkoVQl4ywj1i7D8aRRD_y15dZ2HEZkV-XoV738Kxw3JmQ>
    <xmx:s_PVYqHJUFHKfjmbYS9SUhu_vBZBdTBq__1BrvT4YngUgZGiEzFmVQ>
    <xmx:s_PVYt8b3zOxIDMioDSyGSqZxiEOLEqvA3jtn1ewh7jvjntD7zTHSg>
    <xmx:s_PVYvQJtYhB6Zr0i7WpxXRc4aub0bXEpZympWE97p5AmQ3oKFq9uQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:58:43 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v12 5/5] generic: test fs-verity EFBIG scenarios
Date:   Mon, 18 Jul 2022 16:58:33 -0700
Message-Id: <da538edbae5c1adaa385315be57873b882aa9b2b.1658188603.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658188603.git.boris@bur.io>
References: <cover.1658188603.git.boris@bur.io>
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
index 7d61511c..cb7fa333 100644
--- a/common/verity
+++ b/common/verity
@@ -350,3 +350,14 @@ _fsv_scratch_corrupt_merkle_tree()
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
2.37.1

