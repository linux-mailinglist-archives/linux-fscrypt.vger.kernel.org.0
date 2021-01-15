Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FEA2F8471
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 19:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbhAOSbD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 13:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387524AbhAOSbB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 13:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB83523A7C;
        Fri, 15 Jan 2021 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610735421;
        bh=Zx+DKeYBgI/GfjZ0hi4SNhfY3GNWutg/K/C8V9kfqdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0L4j8OcdiQhWhaA3lFznkCBSPrE6zUF8PqcJjOuy1RL3ttPOC2xIxraA2lLNPOWD
         hR7vaqwtorwbVYMC5g71KuX9G821NatdnGeMVjOeHfY8L9txlCRz2kjuPQpAY0NuID
         wNFRErvojCbHW/gQVQuFeagBwyiZ7dJWeH5yA6wps6dRULQgss1JrWJz0dR6AscPon
         sJ1km6FSX2KsF3KAmFjS97xPA1km91yX6tofMy6L/koqPj52vinla0ljeLky5eHBSQ
         mWVSzaPV7aJ/PqiFWrTwxeN1kN/QJ5ubDeAkCzAs30mzm+qdazEiHX/jjUROAJmWpE
         qkIFNWUiidusQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [xfstests RFC PATCH 4/4] generic: test retrieving verity signature
Date:   Fri, 15 Jan 2021 10:28:37 -0800
Message-Id: <20210115182837.36333-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115182837.36333-1-ebiggers@kernel.org>
References: <20210115182837.36333-1-ebiggers@kernel.org>
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
 create mode 100644 tests/generic/902
 create mode 100644 tests/generic/902.out

diff --git a/tests/generic/902 b/tests/generic/902
new file mode 100644
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
index 3f2edfc0..84fec240 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -625,3 +625,4 @@
 620 auto mount quick
 621 auto quick encrypt
 901 auto quick verity
+902 auto quick verity
-- 
2.30.0

