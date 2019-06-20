Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEA4DCB4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 23:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfFTVil (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 17:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfFTVij (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 17:38:39 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EC62208CA;
        Thu, 20 Jun 2019 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066718;
        bh=V+X0j3RoLIP9jo4cD1boHW7vIrMRQP3jzr1LIyfiC1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5uaXOLnXZ7BVz0SR+lMxutRxGT9kQR4NtPCc4ImsyliGwgBguSUrnk0yamwMrvOT
         HAaR/ghHC9Mhl2igYOslTHCoq0GsN/WdIUpdbH1BOXjE9C4uNfT+D2Jn5jDIZtc9XL
         A1d6AiWbIzxxO/s0xhlra+IPhfw9W+SY2/N7wCgY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v2 4/8] generic: test access controls on the fs-verity ioctls
Date:   Thu, 20 Jun 2019 14:36:10 -0700
Message-Id: <20190620213614.113685-5-ebiggers@kernel.org>
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

Test access controls on the fs-verity ioctls.  FS_IOC_MEASURE_VERITY is
allowed on any file, whereas FS_IOC_ENABLE_VERITY requires write access.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/901     | 73 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out | 14 +++++++++
 tests/generic/group   |  1 +
 3 files changed, 88 insertions(+)
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100755
index 00000000..56dab587
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,73 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2018 Google LLC
+#
+# FS QA Test generic/901
+#
+# Test access controls on the fs-verity ioctls.  FS_IOC_MEASURE_VERITY is
+# allowed on any file, whereas FS_IOC_ENABLE_VERITY requires write access.
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
+_require_user
+_require_chattr ia
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+fsv_file=$SCRATCH_MNT/file.fsv
+
+_fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY doesn't require root"
+echo foo > $fsv_file
+chmod 666 $fsv_file
+_user_do "$FSVERITY_PROG enable $fsv_file"
+
+_fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires write access"
+echo foo > $fsv_file >> $seqres.full
+chmod 444 $fsv_file
+_user_do "$FSVERITY_PROG enable $fsv_file" |& _filter_scratch
+
+_fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires !append-only"
+echo foo > $fsv_file >> $seqres.full
+$CHATTR_PROG +a $fsv_file
+$FSVERITY_PROG enable $fsv_file |& _filter_scratch
+$CHATTR_PROG -a $fsv_file
+
+_fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires !immutable"
+echo foo > $fsv_file >> $seqres.full
+$CHATTR_PROG +i $fsv_file
+$FSVERITY_PROG enable $fsv_file |& _filter_scratch
+$CHATTR_PROG -i $fsv_file
+
+_fsv_scratch_begin_subtest "FS_IOC_MEASURE_VERITY doesn't require root"
+_fsv_create_enable_file $fsv_file >> $seqres.full
+chmod 444 $fsv_file
+su $qa_user -c "$FSVERITY_PROG measure $fsv_file" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 00000000..a9e4c364
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,14 @@
+QA output created by 901
+
+# FS_IOC_ENABLE_VERITY doesn't require root
+
+# FS_IOC_ENABLE_VERITY requires write access
+Permission denied
+
+# FS_IOC_ENABLE_VERITY requires !append-only
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Operation not permitted
+
+# FS_IOC_ENABLE_VERITY requires !immutable
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Operation not permitted
+
+# FS_IOC_MEASURE_VERITY doesn't require root
diff --git a/tests/generic/group b/tests/generic/group
index ed6839a9..003fbff4 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -560,3 +560,4 @@
 555 auto quick cap
 556 auto quick casefold
 900 auto quick verity
+901 auto quick verity
-- 
2.22.0.410.gd8fdbe21b5-goog

