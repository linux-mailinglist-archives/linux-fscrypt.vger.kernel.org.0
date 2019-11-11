Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5423DF81DD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Nov 2019 22:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfKKVFn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 Nov 2019 16:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfKKVFn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 Nov 2019 16:05:43 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F572184C;
        Mon, 11 Nov 2019 21:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573506342;
        bh=6h3PwKp+QN2wQyScuCsfGMThDSu+zjqg25jEKX7f+BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cs4z1kk1mFAfCh/XtGeh1wfXMB2Wzdo+93q9iSQfB+8EtDVNsvB3EosBxTFBNtopQ
         PWpgEWxke0EzB+Gp+a7Bhol9lEjPa3Or9WxYXmzng3wXqP6/LdtD4OLaXdhyDgvx+n
         BeYNbOM2Qa98/z41/lkDoSfIy2PLRAfI1E/V5K/U=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH 5/5] generic: verify ciphertext of IV_INO_LBLK_64 encryption policies
Date:   Mon, 11 Nov 2019 13:04:27 -0800
Message-Id: <20191111210427.137256-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191111210427.137256-1-ebiggers@kernel.org>
References: <20191111210427.137256-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Verify ciphertext for v2 encryption policies that use the IV_INO_LBLK_64
flag and use AES-256-XTS to encrypt file contents and AES-256-CTS-CBC to
encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/805     | 43 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |  6 ++++++
 tests/generic/group   |  1 +
 3 files changed, 50 insertions(+)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100644
index 00000000..d07b620b
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,43 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/805
+#
+# Verify ciphertext for v2 encryption policies that use the IV_INO_LBLK_64 flag
+# and use AES-256-XTS to encrypt file contents and AES-256-CTS-CBC to encrypt
+# file names.
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
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC \
+	v2 iv_ino_lblk_64
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/805.out b/tests/generic/805.out
new file mode 100644
index 00000000..84ec773f
--- /dev/null
+++ b/tests/generic/805.out
@@ -0,0 +1,6 @@
+QA output created by 805
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 iv_ino_lblk_64
diff --git a/tests/generic/group b/tests/generic/group
index e5d0c1da..02e4cc45 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -588,3 +588,4 @@
 583 auto quick encrypt
 584 auto quick encrypt
 585 auto rename
+805 auto quick encrypt
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

