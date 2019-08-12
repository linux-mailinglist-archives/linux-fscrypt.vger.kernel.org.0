Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815028A521
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfHLR6s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfHLR6s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7449D206C2;
        Mon, 12 Aug 2019 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632727;
        bh=1dg63GOjA6z11uYePjAtt0mxxq36eU0TpDoVmR8qX8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUa2Lcr58HeggNj7VZM+YSzh5Uozr6bWoz+tLR3HniHoDFZf3QzRnSK5WvygsfDrv
         l0124YCfP2mdarUsbhwkBNopq0dYHgnafiyGeOMa+5VNt2s7H74YZ2L89UNpaIo/Cq
         aihNFsYMp6gMWMOvASRYYzZ1gx4J8ELkX6gLyVj0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 8/9] generic: verify ciphertext of v2 encryption policies with AES-128
Date:   Mon, 12 Aug 2019 10:58:08 -0700
Message-Id: <20190812175809.34810-9-ebiggers@kernel.org>
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

Verify ciphertext for v2 encryption policies that use AES-128-CBC-ESSIV
to encrypt file contents and AES-128-CTS-CBC to encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/803     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/803.out |  6 ++++++
 tests/generic/group   |  1 +
 3 files changed, 50 insertions(+)
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out

diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100755
index 00000000..c12daeff
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/803
+#
+# Verify ciphertext for v2 encryption policies that use AES-128-CBC-ESSIV to
+# encrypt file contents and AES-128-CTS-CBC to encrypt file names.
+#
+# This is the same as generic/549, except using v2 policies.
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
+_verify_ciphertext_for_encryption_policy AES-128-CBC-ESSIV AES-128-CTS-CBC v2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 00000000..f4051d27
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,6 @@
+QA output created by 803
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-128-CBC-ESSIV
+	filenames_encryption_mode: AES-128-CTS-CBC
+	options: v2
diff --git a/tests/generic/group b/tests/generic/group
index 29c9af30..6deae98f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -571,3 +571,4 @@
 800 auto quick encrypt
 801 auto quick encrypt
 802 auto quick encrypt
+803 auto quick encrypt
-- 
2.23.0.rc1.153.gdeed80330f-goog

