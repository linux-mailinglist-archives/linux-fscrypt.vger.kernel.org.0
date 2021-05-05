Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1173749DA
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 23:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhEEVFy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 17:05:54 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56949 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhEEVFw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 17:05:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B4B195C00EF;
        Wed,  5 May 2021 17:04:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 05 May 2021 17:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=5Encc5Qw2xcaQ4Q4P/4440fsyR
        KBfEJbEsDdpTYSjBs=; b=HLNIAwULp2fDmfSymvUGyorV3W9KZgZd12qH/c5OJL
        u0/5tg+QEzrExnLaNJEWBKhNMovxYbqULfqY2JeVLogQp+NeizpG/aaNAtQ9Vozv
        zk0uLHFi/ifqQctCgmwU7h/bsFWW4jZ8P+++UeuUZLK5jgm6xnx1WQcdf94vUda9
        lm/BsG8zYsEpECX0RwA41Dc1Ugdk7wDjox+rfC9VwaT7R/IIz5yH2EeESHS9WXSo
        FZMXcjQIsOv2fJwiTk/y9G+UmQ3txvSGYyvo74RURazDqETRNivYd9mK8wf7uwFl
        wNGx4TufEwhr6CDDp9UPARYBcShyEY9NCZfd+MJ4Ze/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5Encc5Qw2xcaQ4Q4P/4440fsyRKBfEJbEsDdpTYSjBs=; b=mw2rZFqO
        o/v8jrY3+/Fho9jpu+WTXBAO5NE3sMQvxzZbwwDW8q0GcLj+pi4CXhxEBREASo/3
        QgXAFSpWUB2cwtouNEFrS3452SkXynivHIJNjJFni39ULQUJwzFShQnIgluyMskS
        tK9WPmTH7VovjH40P74bg1OFpzjFPmfjD6zNRYGbn0E+AEmvgEEGhMcr0D0R+XJ2
        QcxmHi2bvzbfbbIsbMIGpHfoRQGCeUaQDWPXCCng8jqBr3HOezOanLs9kigwRs9R
        /kJBxUUObPkRH5kEt6cTXv53f/0KZoBYTfrT3tD9No3jKo9SfhHG8QVjjXCr87KA
        09/0l5rG577CSg==
X-ME-Sender: <xms:dgiTYIEisOvEzmlq1CywvGR9Yu5-PgMYgnZABBDUdP5ofjB4ebGcEw>
    <xme:dgiTYBWz4I0UC_EmjGPJxZO0uGonJFh7LmeIdgcVG0Z1MSkEBvI1CbfwPHC6sF_iQ
    XY8qyjgywTSdccWxPk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:dgiTYCJ2TY6JqPU7eY-fmQNRuas0O49sMRjERirJM4-CU0NAOgy82g>
    <xmx:dgiTYKFEWdfkQ1TF1RLie9IQXE-b3nZ3f_YmkR6qXoAXsjWauRzl2w>
    <xmx:dgiTYOWiWgPq2ySOY-48n7bRhloe89jb-HBZRUv4o4viWInuJGQNqw>
    <xmx:dgiTYBfjvTlt32tRZmKsRip4TjsutQODU3VdE60GY1wqeMrWiELyUg>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 17:04:54 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 4/4] generic: test fs-verity EFBIG scenarios
Date:   Wed,  5 May 2021 14:04:46 -0700
Message-Id: <508058f805a45808764a477e9ad04353a841cf53.1620248200.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1620248200.git.boris@bur.io>
References: <cover.1620248200.git.boris@bur.io>
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
 tests/generic/632     | 86 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/632.out |  7 ++++
 tests/generic/group   |  1 +
 3 files changed, 94 insertions(+)
 create mode 100755 tests/generic/632
 create mode 100644 tests/generic/632.out

diff --git a/tests/generic/632 b/tests/generic/632
new file mode 100755
index 00000000..5a5ed576
--- /dev/null
+++ b/tests/generic/632
@@ -0,0 +1,86 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
+#
+# FS QA Test 632
+#
+# Test some EFBIG scenarios with very large files.
+# To create the files, use pwrite with an offset close to the
+# file system's max file size.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs ext4 f2fs
+_require_test
+_require_math
+_require_scratch_verity
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+fsv_file=$SCRATCH_MNT/file.fsv
+
+max_sz=$(_get_max_file_size)
+_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
+# have to go back by 4096 from max to not hit the fsverity MAX_DEPTH check.
+$XFS_IO_PROG -fc "pwrite -q $(($max_sz - 4096)) 1" $fsv_file
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
+# just smaller than MAX, so that we don't have to write many blocks to blow up.
+
+# 0                        EOF round-to-64k L7L6L5 L4   L3    L2    L1  L0 MAX  EOM
+# |-------------------------|               ||-|--|---|----|-----|------|--|!!!!!|
+
+# Given this structure, we can compute the size of the file that yields the
+# desired properties:
+# sz + 64k + sz/128^8 + sz/128^7 + ... + sz/128^2 < MAX
+# (128^8)sz + (128^8)64k + sz + (128)sz + (128^2)sz + ... + (128^6)sz < (128^8)MAX
+# sz(128^8 + 128^6 + 128^5 + 128^4 + 128^3 + 128^2 + 128 + 1) < (128^8)(MAX - 64k)
+# sz < (128^8/(128^8 + (128^6 + ... 1))(MAX - 64k)
+#
+# Do the actual caclulation with 'bc' and 20 digits of precision.
+set -f
+calc="scale=20; ($max_sz - 65536) * ((128^8) / (1 + 128 + 128^2 + 128^3 + 128^4 + 128^5 + 128^6 + 128^8))"
+sz=$(echo $calc | $BC -q | cut -d. -f1)
+set +f
+
+
+_fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
+$XFS_IO_PROG -fc "pwrite -q $sz 1" $fsv_file
+_fsv_enable $fsv_file |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/632.out b/tests/generic/632.out
new file mode 100644
index 00000000..59602c24
--- /dev/null
+++ b/tests/generic/632.out
@@ -0,0 +1,7 @@
+QA output created by 632
+
+# way too big: fail on first merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
+
+# still too big: fail on first invalid merkle block
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
diff --git a/tests/generic/group b/tests/generic/group
index ab00cc04..76d46e86 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -634,3 +634,4 @@
 629 auto quick rw copy_range
 630 auto quick rw dedupe clone
 631 auto rw overlay rename
+632 auto quick verity
-- 
2.30.2

