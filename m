Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F31F3246F3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Feb 2021 23:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhBXWhf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 17:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235411AbhBXWhe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 17:37:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C955B64F0D;
        Wed, 24 Feb 2021 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614206213;
        bh=XVB9mtWiVpXscrWHajKrky2qktMODcN6tzM3M74OnU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYTHotL6vnYJW1I/mfKICnKhESknK5CRSc4EFgPgP6sje/sIMXvZSx5gWHj5yd3OS
         0RIOs6zpjPV1XhCptg8CMmGHxDj3eRRDU8edbAfQ+B9REF+Iq9usnH7RfiJVyqXtBL
         LYekha7dByF9NUiUdcphm9jhwSSD/C1FbSHIo923O7HCpVFkERh3EdcRltMDK+pDCN
         exT4yp6mCwk9nUB3UYDz1I3YDjB+LXETJaUqDjeOEKdUM+R0Uqa7jfbk7lKXkgQXid
         guIbnIWqHjX4GaZ7bjv0nDAb3Zqsy32Fl2yG6E4tTjYKqbGyHG7VlelUgtc9eytVsK
         ykdzp9PcNFpCA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v2 4/4] generic: test retrieving verity signature
Date:   Wed, 24 Feb 2021 14:35:37 -0800
Message-Id: <20210224223537.110491-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224223537.110491-1-ebiggers@kernel.org>
References: <20210224223537.110491-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a test which tests dumping the built-in signature of a verity file
using the new FS_IOC_READ_VERITY_METADATA ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/902     | 66 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/902.out |  7 +++++
 tests/generic/group   |  1 +
 3 files changed, 74 insertions(+)
 create mode 100755 tests/generic/902
 create mode 100644 tests/generic/902.out

diff --git a/tests/generic/902 b/tests/generic/902
new file mode 100755
index 00000000..ee1096df
--- /dev/null
+++ b/tests/generic/902
@@ -0,0 +1,66 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright 2021 Google LLC
+#
+# FS QA Test No. 902
+#
+# Test retrieving the built-in signature of a verity file using
+# FS_IOC_READ_VERITY_METADATA.
+#
+# This is separate from the other tests for FS_IOC_READ_VERITY_METADATA because
+# the fs-verity built-in signature support is optional.
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
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+rm -f $seqres.full
+
+_supported_fs generic
+_require_scratch_verity
+_require_fsverity_builtin_signatures
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+echo -e "\n# Setting up signed verity file"
+_fsv_generate_cert $tmp.key $tmp.cert $tmp.cert.der
+_fsv_clear_keyring
+_fsv_load_cert $tmp.cert.der
+fsv_file=$SCRATCH_MNT/file
+echo foo > $fsv_file
+_fsv_sign $fsv_file $tmp.sig --key=$tmp.key --cert=$tmp.cert >> $seqres.full
+_fsv_enable $fsv_file --signature=$tmp.sig
+_require_fsverity_dump_metadata $fsv_file
+
+echo -e "\n# Dumping and comparing signature"
+_fsv_dump_signature $fsv_file > $tmp.sig2
+# The signature returned by FS_IOC_READ_VERITY_METADATA should exactly match the
+# one we passed to FS_IOC_ENABLE_VERITY earlier.
+cmp $tmp.sig $tmp.sig2
+
+echo -e "\n# Dumping and comparing signature (in chunks)"
+sig_size=$(stat -c %s $tmp.sig)
+for (( i = 0; i < sig_size; i += 13 )); do
+	_fsv_dump_signature $fsv_file --offset=$i --length=13
+done > $tmp.sig2
+cmp $tmp.sig $tmp.sig2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/902.out b/tests/generic/902.out
new file mode 100644
index 00000000..4b8d9f6e
--- /dev/null
+++ b/tests/generic/902.out
@@ -0,0 +1,7 @@
+QA output created by 902
+
+# Setting up signed verity file
+
+# Dumping and comparing signature
+
+# Dumping and comparing signature (in chunks)
diff --git a/tests/generic/group b/tests/generic/group
index 3cc40795..ce9aa950 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -626,3 +626,4 @@
 621 auto quick encrypt
 622 auto shutdown metadata atime
 901 auto quick verity
+902 auto quick verity
-- 
2.30.1

