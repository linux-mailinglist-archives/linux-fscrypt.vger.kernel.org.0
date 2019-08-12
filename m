Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503D68A520
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfHLR6s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbfHLR6s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB002075B;
        Mon, 12 Aug 2019 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632727;
        bh=mrR4sPSU0corPZShaDIrizmRtxNvZFkVfCu6r/pm0Vw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stLriqad5V5IXgi0w6kI8MrtmujncyzXNluosZIGBC6Zv/ZMyjLT69vE6jfofdxBF
         psiLlrigtmbU7TFEh9z+P3mRbuqKpgKgxuGVaCdozuJoSmmOAthuZwx0bu5wfl2ef4
         5v7qZvxR3tzOlyMyntRDe7BDXyCYdZ5Fgfw0bgEs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 9/9] generic: verify ciphertext of v2 encryption policies with Adiantum
Date:   Mon, 12 Aug 2019 10:58:09 -0700
Message-Id: <20190812175809.34810-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175809.34810-1-ebiggers@kernel.org>
References: <20190812175809.34810-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Verify ciphertext for v2 encryption policies that use Adiantum to
encrypt file contents and file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/804     | 45 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/804.out | 11 +++++++++++
 tests/generic/group   |  1 +
 3 files changed, 57 insertions(+)
 create mode 100755 tests/generic/804
 create mode 100644 tests/generic/804.out

diff --git a/tests/generic/804 b/tests/generic/804
new file mode 100755
index 00000000..72e7b025
--- /dev/null
+++ b/tests/generic/804
@@ -0,0 +1,45 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/804
+#
+# Verify ciphertext for v2 encryption policies that use Adiantum to encrypt file
+# contents and file names.
+#
+# This is the same as generic/550, except using v2 policies.
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
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum v2
+_verify_ciphertext_for_encryption_policy Adiantum Adiantum v2 direct
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/804.out b/tests/generic/804.out
new file mode 100644
index 00000000..726376b2
--- /dev/null
+++ b/tests/generic/804.out
@@ -0,0 +1,11 @@
+QA output created by 804
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+	options: v2
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: Adiantum
+	filenames_encryption_mode: Adiantum
+	options: v2 direct
diff --git a/tests/generic/group b/tests/generic/group
index 6deae98f..c73ad0d9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -572,3 +572,4 @@
 801 auto quick encrypt
 802 auto quick encrypt
 803 auto quick encrypt
+804 auto quick encrypt
-- 
2.23.0.rc1.153.gdeed80330f-goog

