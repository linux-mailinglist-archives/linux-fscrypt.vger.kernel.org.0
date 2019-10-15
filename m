Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1CA6D7EEA
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Oct 2019 20:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbfJOS0C (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Oct 2019 14:26:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfJOSZ5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Oct 2019 14:25:57 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A181A222CB;
        Tue, 15 Oct 2019 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163443;
        bh=pQRF+ZXOzBk/Odo8CcH9Vd+Da+HwrNlFUC4vKvs4HfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c50A2VKq75soeAV35ffPkfTAu4f6E6zXHQR6VDVZ72KO6/G5ckNXZ6KJfkny56oIC
         98MBovrTdihVz40/me6606zo1LB7TvgNyb36+YRwnKU7ymYOapIFb1WNbjL5pf2vjv
         Nqmd1XeQNmaLqF6oVQpANLKQXL9S7MWc787Q6es0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 5/9] generic: add basic test for fscrypt API additions
Date:   Tue, 15 Oct 2019 11:16:39 -0700
Message-Id: <20191015181643.6519-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
In-Reply-To: <20191015181643.6519-1-ebiggers@kernel.org>
References: <20191015181643.6519-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a basic test of the fscrypt filesystem-level encryption keyring and
v2 encryption policies.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/800     | 127 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/800.out |  91 ++++++++++++++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 219 insertions(+)
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out

diff --git a/tests/generic/800 b/tests/generic/800
new file mode 100755
index 00000000..79a101f6
--- /dev/null
+++ b/tests/generic/800
@@ -0,0 +1,127 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/800
+#
+# Basic test of the fscrypt filesystem-level encryption keyring
+# and v2 encryption policies.
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+echo
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
+_supported_os Linux
+_require_scratch_encryption -v 2
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+test_with_policy_version()
+{
+	local vers=$1
+	local raw_key=""
+	local i
+
+	for i in {1..64}; do
+		raw_key+="\\x$(printf "%02x" $i)"
+	done
+
+	if (( vers == 1 )); then
+		# Key descriptor: arbitrary value
+		local keyspec="0000111122223333"
+		local add_enckey_args="-d $keyspec"
+	else
+		# Key identifier:
+		# HKDF-SHA512(key=raw_key, salt="", info="fscrypt\0\x01")
+		local keyspec="69b2f6edeee720cce0577937eb8a6751"
+		local add_enckey_args=""
+	fi
+
+	mkdir $dir
+	echo "# Setting v$vers encryption policy"
+	_set_encpolicy $dir $keyspec
+	echo "# Getting v$vers encryption policy"
+	_get_encpolicy $dir | _filter_scratch
+	if (( vers == 1 )); then
+		echo "# Getting v1 encryption policy using old ioctl"
+		_get_encpolicy $dir -1 | _filter_scratch
+	fi
+	echo "# Trying to create file without key added yet"
+	$XFS_IO_PROG -f $dir/file |& _filter_scratch
+	echo "# Getting encryption key status"
+	_enckey_status $SCRATCH_MNT $keyspec
+	echo "# Adding encryption key"
+	_add_enckey $SCRATCH_MNT "$raw_key" $add_enckey_args
+	echo "# Creating encrypted file"
+	echo contents > $dir/file
+	echo "# Getting encryption key status"
+	_enckey_status $SCRATCH_MNT $keyspec
+	echo "# Removing encryption key"
+	_rm_enckey $SCRATCH_MNT $keyspec
+	echo "# Getting encryption key status"
+	_enckey_status $SCRATCH_MNT $keyspec
+	echo "# Verifying that the encrypted directory was \"locked\""
+	cat $dir/file |& _filter_scratch
+	cat "$(find $dir -type f)" |& _filter_scratch | cut -d ' ' -f3-
+
+	# Test removing key with a file open.
+	echo "# Re-adding encryption key"
+	_add_enckey $SCRATCH_MNT "$raw_key" $add_enckey_args
+	echo "# Creating another encrypted file"
+	echo foo > $dir/file2
+	echo "# Removing key while an encrypted file is open"
+	exec 3< $dir/file
+	_rm_enckey $SCRATCH_MNT $keyspec
+	echo "# Non-open file should have been evicted"
+	cat $dir/file2 |& _filter_scratch
+	echo "# Open file shouldn't have been evicted"
+	cat $dir/file
+	echo "# Key should be in \"incompletely removed\" state"
+	_enckey_status $SCRATCH_MNT $keyspec
+	echo "# Closing file and removing key for real now"
+	exec 3<&-
+	_rm_enckey $SCRATCH_MNT $keyspec
+	cat $dir/file |& _filter_scratch
+
+	echo "# Cleaning up"
+	rm -r $dir
+	_scratch_cycle_mount	# Clear all keys
+	echo
+}
+
+dir=$SCRATCH_MNT/dir
+
+test_with_policy_version 1
+
+test_with_policy_version 2
+
+echo "# Trying to remove absent key"
+_rm_enckey $SCRATCH_MNT abcdabcdabcdabcd
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/800.out b/tests/generic/800.out
new file mode 100644
index 00000000..a4027e2a
--- /dev/null
+++ b/tests/generic/800.out
@@ -0,0 +1,91 @@
+QA output created by 800
+
+# Setting v1 encryption policy
+# Getting v1 encryption policy
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 0
+	Master key descriptor: 0000111122223333
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Getting v1 encryption policy using old ioctl
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 0
+	Master key descriptor: 0000111122223333
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Trying to create file without key added yet
+SCRATCH_MNT/dir/file: Required key not available
+# Getting encryption key status
+Absent
+# Adding encryption key
+Added encryption key with descriptor 0000111122223333
+# Creating encrypted file
+# Getting encryption key status
+Present
+# Removing encryption key
+Removed encryption key with descriptor 0000111122223333
+# Getting encryption key status
+Absent
+# Verifying that the encrypted directory was "locked"
+cat: SCRATCH_MNT/dir/file: No such file or directory
+Required key not available
+# Re-adding encryption key
+Added encryption key with descriptor 0000111122223333
+# Creating another encrypted file
+# Removing key while an encrypted file is open
+Removed encryption key with descriptor 0000111122223333, but files still busy
+# Non-open file should have been evicted
+cat: SCRATCH_MNT/dir/file2: Required key not available
+# Open file shouldn't have been evicted
+contents
+# Key should be in "incompletely removed" state
+Incompletely removed
+# Closing file and removing key for real now
+Removed encryption key with descriptor 0000111122223333
+cat: SCRATCH_MNT/dir/file: No such file or directory
+# Cleaning up
+
+# Setting v2 encryption policy
+# Getting v2 encryption policy
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 2
+	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Trying to create file without key added yet
+SCRATCH_MNT/dir/file: Required key not available
+# Getting encryption key status
+Absent
+# Adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Creating encrypted file
+# Getting encryption key status
+Present (user_count=1, added_by_self)
+# Removing encryption key
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Getting encryption key status
+Absent
+# Verifying that the encrypted directory was "locked"
+cat: SCRATCH_MNT/dir/file: No such file or directory
+Required key not available
+# Re-adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Creating another encrypted file
+# Removing key while an encrypted file is open
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, but files still busy
+# Non-open file should have been evicted
+cat: SCRATCH_MNT/dir/file2: Required key not available
+# Open file shouldn't have been evicted
+contents
+# Key should be in "incompletely removed" state
+Incompletely removed
+# Closing file and removing key for real now
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+cat: SCRATCH_MNT/dir/file: No such file or directory
+# Cleaning up
+
+# Trying to remove absent key
+Error removing encryption key: Required key not available
diff --git a/tests/generic/group b/tests/generic/group
index 6f9c4e12..cf2240ec 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -581,3 +581,4 @@
 576 auto quick verity encrypt
 577 auto quick verity
 578 auto quick rw clone
+800 auto quick encrypt
-- 
2.23.0.700.g56cf767bdb-goog

