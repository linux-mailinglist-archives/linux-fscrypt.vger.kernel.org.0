Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 566FC2A0E6
	for <lists+linux-fscrypt@lfdr.de>; Sat, 25 May 2019 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404374AbfEXWEr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 18:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:44320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404176AbfEXWEo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 18:04:44 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD1521872;
        Fri, 24 May 2019 22:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558735483;
        bh=9FcqD00Z+Ip5/7Ffbq/BiFfLb5UyVB8AgSEaW5tLU7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz+8FgQEr45RNqE5A0k3QVUpmgKWrbuOUQzcqwEVyCAWmxKU00kuzxS5q31Bhnazr
         P93LIko2SO7LkbG+y39db7FGec4oEZa0cWkjUmERDqaBHnjifo+pMph/JKwsjqNjRt
         uqXHdlQ3TdzIMHOp1qTn6I3SD3t+R37NoU9QQzTk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH v2 6/7] generic: verify ciphertext of v1 encryption policies with AES-128
Date:   Fri, 24 May 2019 15:04:24 -0700
Message-Id: <20190524220425.201170-7-ebiggers@kernel.org>
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

Verify ciphertext for v1 encryption policies that use AES-128-CBC-ESSIV
to encrypt file contents and AES-128-CTS-CBC to encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/701     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/701.out |  5 +++++
 tests/generic/group   |  1 +
 3 files changed, 47 insertions(+)
 create mode 100755 tests/generic/701
 create mode 100644 tests/generic/701.out

diff --git a/tests/generic/701 b/tests/generic/701
new file mode 100755
index 00000000..d477f5bd
--- /dev/null
+++ b/tests/generic/701
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/701
+#
+# Verify ciphertext for v1 encryption policies that use AES-128-CBC-ESSIV to
+# encrypt file contents and AES-128-CTS-CBC to encrypt file names.
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
+_verify_ciphertext_for_encryption_policy AES-128-CBC-ESSIV AES-128-CTS-CBC
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/701.out b/tests/generic/701.out
new file mode 100644
index 00000000..cfb6c924
--- /dev/null
+++ b/tests/generic/701.out
@@ -0,0 +1,5 @@
+QA output created by 701
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-128-CBC-ESSIV
+	filenames_encryption_mode: AES-128-CTS-CBC
diff --git a/tests/generic/group b/tests/generic/group
index 69ed721a..85cc2165 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -551,3 +551,4 @@
 546 auto quick clone enospc log
 547 auto quick log
 700 auto quick encrypt
+701 auto quick encrypt
-- 
2.22.0.rc1.257.g3120a18244-goog

