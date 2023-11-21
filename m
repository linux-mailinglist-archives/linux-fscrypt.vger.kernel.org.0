Return-Path: <linux-fscrypt+bounces-10-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 936B77F3954
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45471C210BE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 22:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD1E5A10D;
	Tue, 21 Nov 2023 22:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZWBWzwc"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B0D5812C;
	Tue, 21 Nov 2023 22:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78CC4339A;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700606377;
	bh=umCuFGN2fvdZ+2kf5o7EsnbD7X97WCaVkuR4lIaN3mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZWBWzwcrEm26xDQ8TxD0Pk8ybINPhnrBWu3ilH4q/c+4hP8SkZv/XzEMw3pTYdj8
	 PGIeuI/gcG5SMi85/TUma9ccqq/teob0v8p9dfIfP8a4UgUKXDdtdJmWcZUPmFjFGS
	 UGGYugXbAhTRLnxpo/Tf/rj/f1K+oc2B6DBm7WykpaSFfnwobc9MGTyAOuZGkSF3nF
	 JSe26wy0TrSB9f0lRIr6JjfuZO5h8sSi7DCxF42QpoC9I0EzshGrsUUrqTaIizjq0E
	 hJMiCf9Mh9v0Sq0AGbkDWH10rosJt8ZPyqgnCOaoTLmJB6BSGfK0ftt2vuuaIui76T
	 P9myy1fNhtYXA==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 4/4] generic: add test for custom crypto data unit size
Date: Tue, 21 Nov 2023 14:39:09 -0800
Message-ID: <20231121223909.4617-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231121223909.4617-1-ebiggers@kernel.org>
References: <20231121223909.4617-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a test that verifies the on-disk format of encrypted files that use
a crypto data unit size that differs from the filesystem block size.
This tests the functionality that was introduced in Linux 6.7 by kernel
commit 5b1188847180 ("fscrypt: support crypto data unit size less than
filesystem block size").

This depends on the xfsprogs patch
"xfs_io/encrypt: support specifying crypto data unit size"
(https://lore.kernel.org/r/20231013062639.141468-1-ebiggers@kernel.org)
which adds the '-s' option to the set_encpolicy command of xfs_io.

As usual, the test skips itself when any prerequisite isn't met.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/900     | 29 +++++++++++++++++++++++++++++
 tests/generic/900.out | 11 +++++++++++
 2 files changed, 40 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..8d1b5766
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,29 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2023 Google LLC
+#
+# FS QA Test No. generic/900
+#
+# Verify the on-disk format of encrypted files that use a crypto data unit size
+# that differs from the filesystem block size.  This tests the functionality
+# that was introduced in Linux 6.7 by kernel commit 5b1188847180
+# ("fscrypt: support crypto data unit size less than filesystem block size").
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+. ./common/filter
+. ./common/encrypt
+
+_supported_fs generic
+
+# For now, just test 512-byte and 1024-byte data units.  Filesystems accept
+# power-of-2 sizes between 512 and the filesystem block size, inclusively.
+# Testing 512 and 1024 ensures this test will run for any FS block size >= 1024
+# (provided that the filesystem supports sub-block data units at all).
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC v2 log2_dusize=9
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC v2 log2_dusize=10
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..3259f08c
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,11 @@
+QA output created by 900
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 log2_dusize=9
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 log2_dusize=10
-- 
2.42.1


