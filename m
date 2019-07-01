Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF8E5C2EB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jul 2019 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfGAS1b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jul 2019 14:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbfGAS1b (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jul 2019 14:27:31 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C16821851;
        Mon,  1 Jul 2019 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562005649;
        bh=LFrGT1iwmeY9I51yPhoLeorTghMaFfwgfEhKM8SuBCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zMx86pNqhRCpfpeK9DK1yqycB0XgEK01Rx6kc+Gy9juq3z9XiJoBRNChEi4YjBZV
         XTAW/g98YLlu8BOcZOA3RcSw92PxfAVzgj+ykuUW0oZmnMTXEFRWZgosDgFak+jU+O
         bOSxFv6mqFZxnQHa6Mqi0UPktA4CtFdIHWnLsbwk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v3 6/8] generic: test that fs-verity is using the correct measurement values
Date:   Mon,  1 Jul 2019 11:25:45 -0700
Message-Id: <20190701182547.165856-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701182547.165856-1-ebiggers@kernel.org>
References: <20190701182547.165856-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This test verifies that fs-verity is doing its Merkle tree-based hashing
correctly, i.e. that it hasn't been broken by a change.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/903     | 112 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/903.out |   5 ++
 tests/generic/group   |   1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/generic/903
 create mode 100644 tests/generic/903.out

diff --git a/tests/generic/903 b/tests/generic/903
new file mode 100755
index 00000000..55f4a3ba
--- /dev/null
+++ b/tests/generic/903
@@ -0,0 +1,112 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2018 Google LLC
+#
+# FS QA Test generic/903
+#
+# Test that fs-verity is using the correct measurement values.  This test
+# verifies that fs-verity is doing its Merkle tree-based hashing correctly,
+# i.e. that it hasn't been broken by a change.
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
+_supported_fs generic
+_supported_os Linux
+_require_scratch_verity
+if [ $FSV_BLOCK_SIZE != 4096 ]; then
+	_notrun "4096-byte verity block size not supported on this platform"
+fi
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+fsv_orig_file=$SCRATCH_MNT/file
+fsv_file=$SCRATCH_MNT/file.fsv
+
+algs=(sha256 sha512)
+
+# Try files with 0, 1, and multiple Merkle tree levels.
+file_sizes=(0 4096 65536 65536 100000000)
+
+# Try both unsalted and salted, and check that empty salt is the same as no salt
+salts=('' '' '' '--salt=' '--salt=f3c93fa6fb828c0e1587e5714ecf6f56')
+
+# The expected file measurements are here rather than in the expected output
+# file because not all hash algorithms may be available.
+sha256_vals=(
+sha256:3d248ca542a24fc62d1c43b916eae5016878e2533c88238480b26128a1f1af95
+sha256:babc284ee4ffe7f449377fbf6692715b43aec7bc39c094a95878904d34bac97e
+sha256:011e3f2b1dc89b75d78cddcc2a1b85cd8a64b2883e5f20f277ae4c0617e0404f
+sha256:011e3f2b1dc89b75d78cddcc2a1b85cd8a64b2883e5f20f277ae4c0617e0404f
+sha256:9d33cab743468fcbe4edab91a275b30dd543c12dd5e6ce6f2f737f66a1558f06
+)
+sha512_vals=(
+sha512:ccf9e5aea1c2a64efa2f2354a6024b90dffde6bbc017825045dce374474e13d10adb9dadcc6ca8e17a3c075fbd31336e8f266ae6fa93a6c3bed66f9e784e5abf
+sha512:928922686c4caf32175f5236a7f964e9925d10a74dc6d8344a8bd08b23c228ff5792573987d7895f628f39c4f4ebe39a7367d7aeb16aaa0cd324ac1d53664e61
+sha512:eab7224ce374a0a4babcb2db25e24836247f38b87806ad9be9e5ba4daac2f5b814fc0cbdfd9f1f8499b3c9a6c1b38fe08974cce49883ab4ccd04462fd2f9507f
+sha512:eab7224ce374a0a4babcb2db25e24836247f38b87806ad9be9e5ba4daac2f5b814fc0cbdfd9f1f8499b3c9a6c1b38fe08974cce49883ab4ccd04462fd2f9507f
+sha512:f7083a38644880d25539488313e9e5b41a4d431a0e383945129ad2c36e3c1d0f28928a424641bb1363c12b6e770578102566acea73baf1ce8ee15336f5ba2446
+)
+
+test_alg()
+{
+	local alg=$1
+	local -n vals=${alg}_vals
+	local i
+	local file_size
+	local expected actual salt_arg
+
+	_fsv_scratch_begin_subtest "Check for expected measurement values ($alg)"
+
+	if ! _fsv_have_hash_algorithm $alg $fsv_file; then
+		if [ "$alg" = sha256 ]; then
+			_fail "Something is wrong - sha256 hash should always be available"
+		fi
+		return 0
+	fi
+
+	for i in ${!file_sizes[@]}; do
+		file_size=${file_sizes[$i]}
+		expected=${vals[$i]}
+		salt_arg=${salts[$i]}
+
+		head -c $file_size /dev/zero > $fsv_orig_file
+		cp $fsv_orig_file $fsv_file
+		_fsv_enable --hash-alg=$alg $salt_arg $fsv_file
+		actual=$(_fsv_measure $fsv_file)
+		if [ "$actual" != "$expected" ]; then
+			echo "Mismatch: expected $expected, kernel calculated $actual (file_size=$file_size)"
+		fi
+		cmp $fsv_orig_file $fsv_file
+		rm -f $fsv_file
+	done
+}
+
+for alg in ${algs[@]}; do
+	test_alg $alg
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/903.out b/tests/generic/903.out
new file mode 100644
index 00000000..02508828
--- /dev/null
+++ b/tests/generic/903.out
@@ -0,0 +1,5 @@
+QA output created by 903
+
+# Check for expected measurement values (sha256)
+
+# Check for expected measurement values (sha512)
diff --git a/tests/generic/group b/tests/generic/group
index 62fc73fa..97fd5a32 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -563,3 +563,4 @@
 900 auto quick verity
 901 auto quick verity
 902 auto quick verity
+903 auto quick verity
-- 
2.22.0.410.gd8fdbe21b5-goog

