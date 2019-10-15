Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08D01D7EE7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Oct 2019 20:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389089AbfJOSZ5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Oct 2019 14:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfJOSZ5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Oct 2019 14:25:57 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56F5E222D1;
        Tue, 15 Oct 2019 18:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163444;
        bh=eYdj6nW1X42BTHaVsqRt5KCIEizR+MebdyD1sNPoDrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jq0ZY5Xi+1OmWL8Pe2Y8E3PRQM9JZcvsWyl7WFTaJgce7PlaUSIFfuP/em30Eg+Js
         bEND92SItzXyKPvF5ugVjNuYYbwYYPpTWdlCIcqA3LbR7PCRpMbOOJ98hM7BMXdlFc
         9XZ5CBK8egeNckmmke6bvOn+naMs1O5a/o390P0c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 8/9] generic: verify ciphertext of v2 encryption policies with AES-128
Date:   Tue, 15 Oct 2019 11:16:42 -0700
Message-Id: <20191015181643.6519-9-ebiggers@kernel.org>
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
index 6b6002e1..6f5c15b2 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -584,3 +584,4 @@
 800 auto quick encrypt
 801 auto quick encrypt
 802 auto quick encrypt
+803 auto quick encrypt
-- 
2.23.0.700.g56cf767bdb-goog

