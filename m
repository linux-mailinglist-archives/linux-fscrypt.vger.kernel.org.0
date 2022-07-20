Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7953157AB2B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 02:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiGTAuL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 20:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGTAuK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 20:50:10 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF8284;
        Tue, 19 Jul 2022 17:50:09 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2229332001FF;
        Tue, 19 Jul 2022 20:50:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 19 Jul 2022 20:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658278207; x=1658364607; bh=Z/
        ScZcYly62LPugXqA1E0RFAVGO1KRdhrR/RtutZVQU=; b=FVmBlks/BqbtwugQbA
        5ZaVFW133P0/K6KAlMthoEHcVeGdRtoyv/fZUAPtkGZEvL7k9GcX+rKGc4oaBwo4
        gwpBsspkP3vcaOcrGCRaQh6vyWNXY09KP8bhhoX6wRaMqTb9ll2LKPfz3mMPqXJo
        KenYHtzDzFpinx7k2VFLxrzmsTMT/7HUZt+Jlfv0AtZmQcxswbvFPXUYs2EAPujI
        84V+ClhO3I3AhysUZMuUZTUsWJCCpcq4vCLU9Dhvb+LNA2u3TfeK2BEX1CGx+iAK
        K80eFMrxNYvyVK/oDWpuIIPly3Rfg2JO6gKePJmuGMrXY/jc7GU9RoXns74GOmeO
        CRZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658278207; x=1658364607; bh=Z/ScZcYly62LP
        ugXqA1E0RFAVGO1KRdhrR/RtutZVQU=; b=zjzF88279Z+sAFoC4vXDREx1ApAPh
        tdscfRpKLX8V2UeH3+H1cw0FGBu23jQsSZi/40zuKoEQYkF/uON/eHF1axRWC2bk
        lAbMl3msl7WI/P6zqUokf9ehJ2EY8DoktXuTIsqeXzyUF3XYMhl8qs8BZGHI1jri
        m4Sl8yLVwvD06x6rwC+HMQR7jOpybK42WprbvN+x2M+hr9jTt5Et+qf35BAE54Ac
        wtCctiPBwW1GWFicXHKhekL5oO5IybtkB4+tDpNzC6qkZqFqOXa6aALQORZoGEk2
        9sxPNkeXzOMVAHZqPu8fnUP9zQ3u5zm/YZVZpyC8WV7NuKBCUPGJFfWRw==
X-ME-Sender: <xms:P1HXYnkNKMi9Fv-L9lHA4B0-TyXrK9_B5zjdKzXIhTwyf-qHxOzotw>
    <xme:P1HXYq2OqtY5hk1cqJzeBkRLfUNWL0XlHfOp5A-bYSMRKasP6MjtFjAIF2sArUG-h
    rsv_GMrpQBluxSNoPw>
X-ME-Received: <xmr:P1HXYtqFqieSUTQPJ_PK4kfhwDBmnaEXkeG1QyN7ACfCKXmBzN-QkcpFBO2iabCM3BqkOB5htQ4w9czkde0V0ctkIluQ5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeluddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:P1HXYvlFuM31q9QYGTarq6sFucSNMmuc-XqFITmBwHiau9atS9Xz-A>
    <xmx:P1HXYl1FI9KlqhYTaVFeNSfxLPvRXrXXo3RRzRXMKaI2m0V7PoyBkg>
    <xmx:P1HXYuuy-EEhCnqvQyHuN_-MsX3sHV31vNpDKPtgkwzXZNk6GNC4wQ>
    <xmx:P1HXYjDB3IQfDgO0vwCj8ejkc6JbsUv1mY5YUsz3C1xdByVWjQRaOw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Jul 2022 20:50:06 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v13 5/5] generic: test fs-verity EFBIG scenarios
Date:   Tue, 19 Jul 2022 17:49:50 -0700
Message-Id: <ff74fa26e99c7aef886a770bfc72b3694211c84f.1658277755.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658277755.git.boris@bur.io>
References: <cover.1658277755.git.boris@bur.io>
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
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/verity         | 11 ++++++++
 tests/generic/692     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/692.out |  7 +++++
 3 files changed, 82 insertions(+)
 create mode 100644 tests/generic/692
 create mode 100644 tests/generic/692.out

diff --git a/common/verity b/common/verity
index 4c50d2b1..65a39d3e 100644
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

