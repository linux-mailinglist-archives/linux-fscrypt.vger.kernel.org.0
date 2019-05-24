Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74242A0DE
	for <lists+linux-fscrypt@lfdr.de>; Sat, 25 May 2019 00:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbfEXWEo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 18:04:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404353AbfEXWEn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 18:04:43 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EB021871;
        Fri, 24 May 2019 22:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558735483;
        bh=4kobK6WaFEHUuDwLE2PVnRKVqEJZDJRVWStRMFgZYxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZV0kbKK9YixF3Qc3T5LUtlf1LL50kOCfaG4h5IOigKGEmWrTztaOLF+kgBph+IQqz
         DkgJtu2nfMUwukNTeLttd+DrWjBMC+PWs4lTR+Li816NkedNnAApTjaXH6lfUociYE
         ChYReI+m0N98JjefafBJDiykKN1ilj7DBP4l0vJA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH v2 5/7] generic: verify ciphertext of v1 encryption policies with AES-256
Date:   Fri, 24 May 2019 15:04:23 -0700
Message-Id: <20190524220425.201170-6-ebiggers@kernel.org>
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

Verify ciphertext for v1 encryption policies that use AES-256-XTS to
encrypt file contents and AES-256-CTS-CBC to encrypt file names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/700     | 41 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/700.out |  5 +++++
 tests/generic/group   |  1 +
 3 files changed, 47 insertions(+)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out

diff --git a/tests/generic/700 b/tests/generic/700
new file mode 100755
index 00000000..c6dc8b90
--- /dev/null
+++ b/tests/generic/700
@@ -0,0 +1,41 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/700
+#
+# Verify ciphertext for v1 encryption policies that use AES-256-XTS to encrypt
+# file contents and AES-256-CTS-CBC to encrypt file names.
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
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/700.out b/tests/generic/700.out
new file mode 100644
index 00000000..ea2de143
--- /dev/null
+++ b/tests/generic/700.out
@@ -0,0 +1,5 @@
+QA output created by 700
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
diff --git a/tests/generic/group b/tests/generic/group
index 49639fc9..69ed721a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -550,3 +550,4 @@
 545 auto quick cap
 546 auto quick clone enospc log
 547 auto quick log
+700 auto quick encrypt
-- 
2.22.0.rc1.257.g3120a18244-goog

