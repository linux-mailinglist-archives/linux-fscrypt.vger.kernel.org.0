Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE212A0E3
	for <lists+linux-fscrypt@lfdr.de>; Sat, 25 May 2019 00:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404366AbfEXWEq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404364AbfEXWEo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 18:04:44 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8842D21874;
        Fri, 24 May 2019 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558735483;
        bh=/1pMI+/AJcaGv7Uq6INHF/OBWwCAY0WN8cjrWI9b9vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J3UfYZlUpR9j8owmfdxnMkSRNotjhQvwppe76NenwOB+8cIkcHjn6R9An0rY0LBer
         e3ntDUjaa88tDOTopZXfWVrPjtXqnnZt/u+CYT2/nvrDnZ7WdHb9PQgs+mq4rIJyAV
         kOMpTxIA1c6ycaSWwbct6UnzpUGjZUziotiwfRh4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH v2 7/7] generic: verify ciphertext of v1 encryption policies with Adiantum
Date:   Fri, 24 May 2019 15:04:25 -0700
Message-Id: <20190524220425.201170-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
In-Reply-To: <20190524220425.201170-1-ebiggers@kernel.org>
References: <20190524220425.201170-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Verify ciphertext for v1 encryption policies that use Adiantum to
encrypt file contents and file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/702     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/702.out | 10 ++++++++++
 tests/generic/group   |  1 +
 3 files changed, 54 insertions(+)
 create mode 100755 tests/generic/702
 create mode 100644 tests/generic/702.out

diff --git a/tests/generic/702 b/tests/generic/702
new file mode 100755
index 00000000..c7ac7be4
--- /dev/null
+++ b/tests/generic/702
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/702
+#
+# Verify ciphertext for v1 encryption policies that use Adiantum to encrypt file
+# contents and file names.
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
+_supported_os Linux
+
+# Test both with and without the DIRECT_KEY flag.
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum direct
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/702.out b/tests/generic/702.out
new file mode 100644
index 00000000..0dd80dae
--- /dev/null
+++ b/tests/generic/702.out
@@ -0,0 +1,10 @@
+QA output created by 702
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+	options: direct
diff --git a/tests/generic/group b/tests/generic/group
index 85cc2165..2fe51dcc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -552,3 +552,4 @@
 547 auto quick log
 700 auto quick encrypt
 701 auto quick encrypt
+702 auto quick encrypt
-- 
2.22.0.rc1.257.g3120a18244-goog

