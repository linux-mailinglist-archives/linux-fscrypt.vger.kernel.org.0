Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42B14B5EDE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Feb 2022 01:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiBOAKT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 19:10:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiBOAKS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 19:10:18 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857FDA66DF;
        Mon, 14 Feb 2022 16:10:09 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 8C7EB5C02D8;
        Mon, 14 Feb 2022 19:10:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 14 Feb 2022 19:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; bh=GxZggmqNYCmwaqWV7dJDhj4lMSEA48
        3iaBW1BCfwmx8=; b=zSXk47CGyPWzgoFG0qRX0k90izsv4A3J1DbxMZiuMq3YmL
        UZ9V8gtjnt/h4p/Wd1XPsNvdm9ypzeXcK7r3RYtsPVZ6h8Y1tgDBvvi5ttU1MuPd
        qLG8DQ+n5EttuKsoVpZMX+yGxUmcJCykZRFZJfzs9JPyZLVtPe3E4j6/66Et9OKQ
        C1d/7tvzM+c09wmX4XWx/rFsn4caTBC3Ns/5duwgtVJemM2p8ywBX3adKKUlgZTp
        i38+GpxTLVnBmDs/qD8LA553HSp4PODlY9Zk64MhKEoemqe1ntI3K692d0ctyJ2r
        BQmzB0uUibNwGx6FlHIFPrrdB7JwMwZHsRDl8FJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GxZggm
        qNYCmwaqWV7dJDhj4lMSEA483iaBW1BCfwmx8=; b=O0Ef9Xo9B9YXBf4RTOfEep
        KUeoArh283QAFBt9mHklNf3VAnAbYgM8/wilbB3gA1TY0a7+iIHAsDedsFs/A+S0
        V+3TLP6p5iOoe32ONp7WZ+eMIeIOWWs4mws55Kjw6c0i8N3HRL4EN3eT+3WnfoDm
        bDT9aHZv+e8bINnWvhjc+GaYqVgeGTc3B0kNqefKGQ1+YP9AcBe2DGpU3A0mYF3u
        r46MD1bFGabcv8GCjF1CpKmTuY3/JdYXHmevY7wQ2QwJG+kQtjDDCl+56ROJHyoJ
        NJB087s4oaTyn3u/no/fNSSb2CN8daI6mdxK6s12mK19jJXLBZ39/dd9018Io+qg
        ==
X-ME-Sender: <xms:YO8KYneujVAxSAf5iDWjeX9LG0hRTVrjfrWt2U9zoxwQh878-nShvA>
    <xme:YO8KYtNOvOZI39Heje3fDkSOCMz99cq30HIAx7sMSyDQHSkVc-KXmHwgCR60_7m-L
    ETvRqbTvomziaf2PvY>
X-ME-Received: <xmr:YO8KYgh64whREvy6BgU79UccYa92rklRZwIgoCyFhf6KeSUXSlQYR6KzMxy_ty_LdvrvEusUQT_RDrx8SoEPmhK__KQDsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:YO8KYo-RwdyPHi5YA-frXVggYK8prsCgHNV_fwWMuDYGsypmTLCs0w>
    <xmx:YO8KYjs4SVWCrCgnjrlQUU8xs6lgtJ2EuaXidN32i_fONWGFLpyZAA>
    <xmx:YO8KYnGP_JnxNxO4mFjIM_nEAuwTO6K0KDufxRVFC1TZUk8IZKKpBQ>
    <xmx:YO8KYs7xrvrY36ooEYhnMJVHvCtDNKUJEfEIgDhrqUUDNYV9cy96zg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 19:10:07 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 4/4] generic: test fs-verity EFBIG scenarios
Date:   Mon, 14 Feb 2022 16:09:58 -0800
Message-Id: <f8189930d20888a7ac95b7fc2fbb0d522e8851fc.1644883592.git.boris@bur.io>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1644883592.git.boris@bur.io>
References: <cover.1644883592.git.boris@bur.io>
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
 tests/generic/690     | 66 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/690.out |  7 +++++
 3 files changed, 84 insertions(+)
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

diff --git a/common/verity b/common/verity
index 07d9d3fe..8be86ef7 100644
--- a/common/verity
+++ b/common/verity
@@ -345,3 +345,14 @@ _fsv_scratch_corrupt_merkle_tree()
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
index 00000000..77906dd8
--- /dev/null
+++ b/tests/generic/690
@@ -0,0 +1,66 @@
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
2.34.0

