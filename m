Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61904DCC6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 23:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFTVip (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 17:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfFTVik (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 17:38:40 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86187214AF;
        Thu, 20 Jun 2019 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066719;
        bh=fZRcCueYWlIUE+x9dYmZJUdxrmHOPyZEN3htnAyEhTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvmexbB6szRvVaiWTEj3W9AkIUBUiWayaOoN1gOpNATayH+V68NpSBXFp7tCmKAXt
         94p5kJ1NcTHN9KCcF86H3+lOVI/qfIvu37eNRy17ZuoprCj6fj/dSoBrlJNxqbH6pU
         WgVmfKQJCmHvglPMPJwUaSTSiv/u0FsMiYKYWxm0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v2 7/8] generic: test using fs-verity and fscrypt simultaneously
Date:   Thu, 20 Jun 2019 14:36:13 -0700
Message-Id: <20190620213614.113685-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620213614.113685-1-ebiggers@kernel.org>
References: <20190620213614.113685-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

This primarily verifies correct ordering of the hooks for each feature:
fscrypt needs to be first.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/904     | 80 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/904.out | 12 +++++++
 tests/generic/group   |  1 +
 3 files changed, 93 insertions(+)
 create mode 100755 tests/generic/904
 create mode 100644 tests/generic/904.out

diff --git a/tests/generic/904 b/tests/generic/904
new file mode 100755
index 00000000..61bdae22
--- /dev/null
+++ b/tests/generic/904
@@ -0,0 +1,80 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2018 Google LLC
+#
+# FS QA Test generic/904
+#
+# Test using fs-verity and fscrypt simultaneously.  This primarily verifies
+# correct ordering of the hooks for each feature: fscrypt needs to be first.
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
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_verity
+_require_scratch_encryption
+_require_command "$KEYCTL_PROG" keyctl
+
+_scratch_mkfs_encrypted_verity &>> $seqres.full
+_scratch_mount
+
+fsv_orig_file=$tmp.file
+edir=$SCRATCH_MNT/edir
+fsv_file=$edir/file.fsv
+
+# Set up an encrypted directory.
+_new_session_keyring
+keydesc=$(_generate_encryption_key)
+mkdir $edir
+_set_encpolicy $edir $keydesc
+
+# Create a file within the encrypted directory and enable verity on it.
+# Then check that it has an encryption policy as well.
+head -c 100000 /dev/zero > $fsv_orig_file
+cp $fsv_orig_file $fsv_file
+_fsv_enable $fsv_file
+echo
+$XFS_IO_PROG -r -c "get_encpolicy" $fsv_file | _filter_scratch \
+	| sed 's/Master key descriptor:.*/Master key descriptor: 0000000000000000/'
+echo
+
+# Verify that the file contents are as expected.  This should be going through
+# both the decryption and verity I/O paths.
+cmp $fsv_orig_file $fsv_file && echo "Files matched"
+
+# Just in case, try again after a mount cycle to empty the page cache.
+_scratch_cycle_mount
+cmp $fsv_orig_file $fsv_file && echo "Files matched"
+
+# Corrupt some bytes as a sanity check that fs-verity is really working.
+# This also verifies that the data on-disk is really encrypted, since otherwise
+# the data being written here would be identical to the old data.
+head -c 1000 /dev/zero | _fsv_scratch_corrupt_bytes $fsv_file 50000
+md5sum $fsv_file |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/904.out b/tests/generic/904.out
new file mode 100644
index 00000000..5f4e249a
--- /dev/null
+++ b/tests/generic/904.out
@@ -0,0 +1,12 @@
+QA output created by 904
+
+Encryption policy for SCRATCH_MNT/edir/file.fsv:
+	Policy version: 0
+	Master key descriptor: 0000000000000000
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+
+Files matched
+Files matched
+md5sum: SCRATCH_MNT/edir/file.fsv: Input/output error
diff --git a/tests/generic/group b/tests/generic/group
index 3927f779..5b4c32ff 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -563,3 +563,4 @@
 901 auto quick verity
 902 auto quick verity
 903 auto quick verity
+904 auto quick verity encrypt
-- 
2.22.0.410.gd8fdbe21b5-goog

