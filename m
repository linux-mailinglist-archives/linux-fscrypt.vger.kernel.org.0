Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5713FD6B7E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Oct 2019 00:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbfJNWGm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Oct 2019 18:06:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730859AbfJNWGl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Oct 2019 18:06:41 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8289D21721;
        Mon, 14 Oct 2019 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571090800;
        bh=6ZSRWDRTAQJMgAGTx2YsjUObOmwBsJD3GxlEsVboQGk=;
        h=From:To:Cc:Subject:Date:From;
        b=cM22FCSLONOFGHpWRDyFP/nsKcFW1Qv4UwBbCYqINEVl4r/QI3MQsvfUOj9y8CUdB
         zZKKSra2v+HbYyUWJEx7QZcBXvdveCmt4jMALlrEFjXygjzofwszbCS7i6WFU24jwq
         n9pCV9c9GIoAn1nihQLGH6ChzmYTyt1kLOhD9/w4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH] generic: add an fs-verity stress test
Date:   Mon, 14 Oct 2019 15:05:21 -0700
Message-Id: <20191014220521.15458-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a stress test for fs-verity.  This tests enabling fs-verity on
multiple files concurrently with concurrent readers on those files (with
reads occurring before, during, and after the fs-verity enablement),
while fsstress is also running on the same filesystem.

I haven't seen any failures from running this on ext4 and f2fs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/906     | 115 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/906.out |   2 +
 tests/generic/group   |   1 +
 3 files changed, 118 insertions(+)
 create mode 100755 tests/generic/906
 create mode 100644 tests/generic/906.out

diff --git a/tests/generic/906 b/tests/generic/906
new file mode 100755
index 00000000..78796487
--- /dev/null
+++ b/tests/generic/906
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/906
+#
+# Stress test for fs-verity.  This tests enabling fs-verity on multiple files
+# concurrently with concurrent readers on those files (with reads occurring
+# before, during, and after the fs-verity enablement), while fsstress is also
+# running on the same filesystem.
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
+	# Stop all subprocesses.
+	$KILLALL_PROG -q $FSSTRESS_PROG
+	touch $tmp.done
+	wait
+
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
+_require_command "$KILLALL_PROG" killall
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+fsv_file_size=10000000
+nproc_enabler=$((4 * LOAD_FACTOR))
+nproc_reader=$((6 * LOAD_FACTOR))
+nproc_stress=$((3 * LOAD_FACTOR))
+runtime=$((20 * TIME_FACTOR))
+
+# Create the test files and start the fs-verity enabler processes.
+for ((proc = 0; proc < nproc_enabler; proc++)); do
+	orig_file=$SCRATCH_MNT/orig$proc
+	fsv_file=$SCRATCH_MNT/fsv$proc
+	head -c $fsv_file_size /dev/urandom > $orig_file
+	(
+		while [ ! -e $tmp.done ]; do
+			rm -f $fsv_file
+			cp $orig_file $fsv_file
+			_fsv_enable $fsv_file
+			# Give the readers some time to read from the file.
+			sleep 0.$((RANDOM % 100))
+		done
+	) &
+done
+
+# Start the reader processes.
+for ((proc = 0; proc < nproc_reader; proc++)); do
+	(
+		while [ ! -e $tmp.done ]; do
+			# Choose a random file for each iteration, so that
+			# sometimes multiple processes read from the same file.
+			i=$((RANDOM % nproc_enabler))
+			orig_file=$SCRATCH_MNT/orig$i
+			fsv_file=$SCRATCH_MNT/fsv$i
+
+			# After the copy from $orig_file to $fsv_file has
+			# completed, the contents of these two files should
+			# match, regardless of whether verity has been enabled
+			# or not yet (or is currently being enabled).
+			cmp $orig_file $fsv_file |& _filter_scratch | \
+				grep -v "SCRATCH_MNT/fsv$i: No such file or directory" | \
+				grep -v "EOF on SCRATCH_MNT/fsv$i"
+
+			_fsv_measure $fsv_file 2>&1 >/dev/null | \
+				grep -v "No such file or directory" | \
+				grep -v "No data available"
+		done
+	) &
+done
+
+# Start a process that occasionally runs 'sync && drop_caches'.  This makes more
+# reads go through fs-verity for real, rather than just returning pagecache.
+(
+	while [ ! -e $tmp.done ]; do
+		sleep 2.$((RANDOM % 100))
+		sync && echo 3 > /proc/sys/vm/drop_caches
+	done
+) &
+
+# Start the fsstress processes.
+$FSSTRESS_PROG $FSSTRESS_AVOID -p $nproc_stress -l 0 -d $SCRATCH_MNT/stressdir \
+	>> $seqres.full 2>&1 &
+
+# Run for a while.
+sleep $runtime
+
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/906.out b/tests/generic/906.out
new file mode 100644
index 00000000..94ee4185
--- /dev/null
+++ b/tests/generic/906.out
@@ -0,0 +1,2 @@
+QA output created by 906
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 6f9c4e12..d55d0eea 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -581,3 +581,4 @@
 576 auto quick verity encrypt
 577 auto quick verity
 578 auto quick rw clone
+906 auto stress verity
-- 
2.23.0.700.g56cf767bdb-goog

