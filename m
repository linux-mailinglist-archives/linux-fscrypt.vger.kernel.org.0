Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B433D7EDF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Oct 2019 20:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbfJOSZ4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Oct 2019 14:25:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfJOSZ4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Oct 2019 14:25:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AA95222D0;
        Tue, 15 Oct 2019 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163444;
        bh=/hpTM+O+Z8VWmjP8yz15AC0xcLB2kV1VFiz+xCRpXPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKtEYthJ/koUQIvoK5+629MmU9J+Zq3u13QdkUoQjJbkaVYzvE0wtEzSgX4hDPebv
         PqNkshdEnZMq0ZU30/5t7uQK/J8J8rTRA9QQpqDu57D2uThZhFgej4HmbNw8312tKd
         2+YnuyVnTjhY0K+zFoSeXBE6ZknykRcUiiC+5d18=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 7/9] generic: verify ciphertext of v2 encryption policies with AES-256
Date:   Tue, 15 Oct 2019 11:16:41 -0700
Message-Id: <20191015181643.6519-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
In-Reply-To: <20191015181643.6519-1-ebiggers@kernel.org>
References: <20191015181643.6519-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Verify ciphertext for v2 encryption policies that use AES-256-XTS to
encrypt file contents and AES-256-CTS-CBC to encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/802     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |  6 ++++++
 tests/generic/group   |  1 +
 3 files changed, 50 insertions(+)
 create mode 100755 tests/generic/802
 create mode 100644 tests/generic/802.out

diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100755
index 00000000..457260b2
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/802
+#
+# Verify ciphertext for v2 encryption policies that use AES-256-XTS to encrypt
+# file contents and AES-256-CTS-CBC to encrypt file names.
+#
+# This is the same as generic/548, except using v2 policies.
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
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC v2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/802.out b/tests/generic/802.out
new file mode 100644
index 00000000..c0930809
--- /dev/null
+++ b/tests/generic/802.out
@@ -0,0 +1,6 @@
+QA output created by 802
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2
diff --git a/tests/generic/group b/tests/generic/group
index 6d1ecf5a..6b6002e1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -583,3 +583,4 @@
 578 auto quick rw clone
 800 auto quick encrypt
 801 auto quick encrypt
+802 auto quick encrypt
-- 
2.23.0.700.g56cf767bdb-goog

