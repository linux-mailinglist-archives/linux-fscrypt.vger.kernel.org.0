Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0A02A13F0
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 08:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgJaHYi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 03:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgJaHYi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 03:24:38 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A35520791;
        Sat, 31 Oct 2020 07:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604129077;
        bh=mQCKfHHAx95lV/0bmNOiTKhN8f3W2JM+iSd8Q74+fQU=;
        h=From:To:Cc:Subject:Date:From;
        b=b+fF7VR9XiADFpOAgl95Efv+7IHInggxFphFwpFiqTC9p/TynIyjRcnfrf3FiPfw5
         mCSxbjUVdH4OBVIAAf5+sLJtIaDSsKRa0h/JiEzwCjEGv8nbW6h+t/rmrPo0FzPCBr
         jt3/0XgOJaEZnkZQAtvGyYu4IoozJYuTJcpFgTPg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic: test that encryption nonces are unique and random
Date:   Sat, 31 Oct 2020 00:23:44 -0700
Message-Id: <20201031072344.800741-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test that encryption nonces are unique and random, where randomness is
approximated as "incompressible by the xz program".

This gets indirectly tested by generic/399, but there are some gaps.
It's good to test for this directly too.

This test runs and passes on ext4 and f2fs.  It doesn't currently run on
ubifs because _get_encryption_nonce() isn't implemented for ubifs yet.
(At some point I'll probably switch _get_encryption_nonce() to use
FS_IOC_GET_ENCRYPTION_NONCE, which was added in Linux 5.7.  But for now
I'd like to keep the tests using it runnable on older kernels too.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/900     | 118 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  16 ++++++
 tests/generic/group   |   1 +
 3 files changed, 135 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..6881579a
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,118 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2020 Google LLC
+#
+# FS QA Test No. 900
+#
+# Test that encryption nonces are unique and random, where randomness is
+# approximated as "incompressible by the xz program".
+#
+# An encryption nonce is the 16-byte value that the filesystem generates for
+# each encrypted file.  These nonces must be unique in order to cause different
+# files to be encrypted differently, which is an important security property.
+# In practice, they need to be random to achieve that; and it's easy enough to
+# test for both uniqueness and randomness, so we test for both.
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
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_encryption -v 2
+_require_get_encryption_nonce_support
+_require_command "$XZ_PROG" xz
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+echo -e "\n# Adding encryption keys"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" -d $TEST_KEY_DESCRIPTOR
+
+# Create a bunch of encrypted files and directories -- enough for the uniqueness
+# and randomness tests to be meaningful, but not so many that this test takes a
+# long time.  Test using both v1 and v2 encryption policies, and for each of
+# those test the case of an encryption policy that is assigned to an empty
+# directory as well as the case of a file created in an encrypted directory.
+echo -e "\n# Creating encrypted files and directories"
+inodes=()
+for i in {1..50}; do
+	dir=$SCRATCH_MNT/v1_policy_dir_$i
+	mkdir $dir
+	inodes+=("$(stat -c %i $dir)")
+	_set_encpolicy $dir $TEST_KEY_DESCRIPTOR
+
+	dir=$SCRATCH_MNT/v2_policy_dir_$i
+	mkdir $dir
+	inodes+=("$(stat -c %i $dir)")
+	_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+done
+for i in {1..50}; do
+	file=$SCRATCH_MNT/v1_policy_dir_1/$i
+	touch $file
+	inodes+=("$(stat -c %i $file)")
+
+	file=$SCRATCH_MNT/v2_policy_dir_1/$i
+	touch $file
+	inodes+=("$(stat -c %i $file)")
+done
+_scratch_unmount
+
+# Build files that contain all the nonces.  nonces_hex contains them in hex, one
+# per line.  nonces_bin contains them in binary, all concatenated.
+echo -e "\n# Getting encryption nonces from inodes"
+echo -n > $tmp.nonces_hex
+echo -n > $tmp.nonces_bin
+for inode in "${inodes[@]}"; do
+	nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
+	then
+		_fail "Expected nonce to be 16 bytes (32 hex characters), but got \"$nonce\""
+	fi
+	echo $nonce >> $tmp.nonces_hex
+	echo -ne "$(echo $nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
+		>> $tmp.nonces_bin
+done
+
+# Verify the uniqueness and randomness of the nonces.  In theory randomness
+# implies uniqueness here, but it's easy enough to explicitly test for both.
+
+echo -e "\n# Verifying uniqueness of nonces"
+echo "Listing non-unique nonces:"
+sort < $tmp.nonces_hex | uniq -d
+
+echo -e "\n# Verifying randomness of nonces"
+uncompressed_size=$(stat -c %s $tmp.nonces_bin)
+echo "Uncompressed size is $uncompressed_size bytes"
+compressed_size=$($XZ_PROG -c < $tmp.nonces_bin | wc -c)
+echo "Compressed size is $compressed_size bytes" >> $seqres.full
+# The xz format has 60 bytes of overhead.  Go a bit lower to avoid flakiness.
+if (( compressed_size >= uncompressed_size + 55 )); then
+	echo "Nonces are incompressible, as expected"
+else
+	_fail "Nonces are compressible (non-random); compressed $uncompressed_size => $compressed_size bytes!"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..9f957b15
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,16 @@
+QA output created by 900
+
+# Adding encryption keys
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Added encryption key with descriptor 0000111122223333
+
+# Creating encrypted files and directories
+
+# Getting encryption nonces from inodes
+
+# Verifying uniqueness of nonces
+Listing non-unique nonces:
+
+# Verifying randomness of nonces
+Uncompressed size is 3200 bytes
+Nonces are incompressible, as expected
diff --git a/tests/generic/group b/tests/generic/group
index 8054d874..478eda18 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -615,3 +615,4 @@
 610 auto quick prealloc zero
 611 auto quick attr
 612 auto quick clone
+900 auto quick encrypt
-- 
2.29.1

