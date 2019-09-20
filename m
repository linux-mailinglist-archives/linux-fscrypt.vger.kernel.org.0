Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C003B88A0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394435AbfITAiH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393239AbfITAiF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:38:05 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34AC121907;
        Fri, 20 Sep 2019 00:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568939885;
        bh=SOkr2+Ie/H65hFU+Nzsm60N8BhpHsBOuz2yjOy1gcAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aMEUM0p0WQHxhFQID8ybqzLeZTzSl5135EMy8jvoZDJKssjKD941mQx4GQ2WcImY
         BUBMR5BjqcZTH4Zj7SMHyv8co90owDreCtuxksjGDi43YgPOWWVB8TIqmzl8z9AEZM
         lIc+u+mZ0yT8rQIlCQGqNoesf32i7nxAQrPSGFZ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 9/9] generic: verify ciphertext of v2 encryption policies with Adiantum
Date:   Thu, 19 Sep 2019 17:37:53 -0700
Message-Id: <20190920003753.40281-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920003753.40281-1-ebiggers@kernel.org>
References: <20190920003753.40281-1-ebiggers@kernel.org>
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
index 08a79b21..94838ab5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -574,3 +574,4 @@
 801 auto quick encrypt
 802 auto quick encrypt
 803 auto quick encrypt
+804 auto quick encrypt
-- 
2.23.0.351.gc4317032e6-goog

