Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A3B247E79
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Aug 2020 08:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgHRGbg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Aug 2020 02:31:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgHRGbe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Aug 2020 02:31:34 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010742075E;
        Tue, 18 Aug 2020 06:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597732294;
        bh=YCIfkNQoZMTK45gIqN25QClyTsdrB5QyhGJVVQrLLA0=;
        h=From:To:Cc:Subject:Date:From;
        b=hmwQMQVHI/u25dQ+mNOIO/4UK9GbcA0qvZLH0cmejGHzckP1vfPuApAAMKYB67LsY
         q2vpWF153vERqu9QPGBM3utSQSaXxOQ2wS9/K66lGhQKb7Y4JyaM/gZ4GuSJe5e03w
         OX/D84YqVd5C/f9+2f9WPqQ0/Utm590xLwPEGV9Y=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic/574: fix sporadic failure with test_dummy_encryption
Date:   Mon, 17 Aug 2020 23:30:23 -0700
Message-Id: <20200818063023.93833-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When the "test_dummy_encryption" mount option is specified, the
fs-verity file corruption test generic/574 is flaky; it fails about 1%
of the time.  This happens because in the three test cases where a
single byte of the test file is corrupted, sometimes the new byte
happens to be the same as the original.  This is specific to
test_dummy_encryption because the encrypted data is nondeterministic
(and appears random), unlike the unencrypted data.

Fix this by corrupting 5 bytes instead of 1, so that the probability of
failure becomes effectively zero.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/574     | 11 ++++++++---
 tests/generic/574.out |  6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tests/generic/574 b/tests/generic/574
index 246f0858..da776a24 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -135,10 +135,15 @@ corruption_test()
 	fi
 }
 
-corruption_test 131072 0 1
-corruption_test 131072 4095 1
+# Note: these tests just overwrite some bytes without checking their original
+# values.  Therefore, make sure to overwrite at least 5 or so bytes, to make it
+# nearly guaranteed that there will be a change -- even when the test file is
+# encrypted due to the test_dummy_encryption mount option being specified.
+
+corruption_test 131072 0 5
+corruption_test 131072 4091 5
 corruption_test 131072 65536 65536
-corruption_test 131072 131071 1
+corruption_test 131072 131067 5
 
 # Non-zeroed bytes in the final partial block beyond EOF should cause reads to
 # fail too.  Such bytes would be visible via mmap().
diff --git a/tests/generic/574.out b/tests/generic/574.out
index 5b304c83..d43474c5 100644
--- a/tests/generic/574.out
+++ b/tests/generic/574.out
@@ -1,6 +1,6 @@
 QA output created by 574
 
-# Corruption test: file_len=131072 zap_offset=0 zap_len=1
+# Corruption test: file_len=131072 zap_offset=0 zap_len=5
 0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
 Corrupting bytes...
 Validating corruption (reading full file)...
@@ -14,7 +14,7 @@ Bus error
 Validating corruption (reading just corrupted part via mmap)...
 Bus error
 
-# Corruption test: file_len=131072 zap_offset=4095 zap_len=1
+# Corruption test: file_len=131072 zap_offset=4091 zap_len=5
 0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
 Corrupting bytes...
 Validating corruption (reading full file)...
@@ -42,7 +42,7 @@ Bus error
 Validating corruption (reading just corrupted part via mmap)...
 Bus error
 
-# Corruption test: file_len=131072 zap_offset=131071 zap_len=1
+# Corruption test: file_len=131072 zap_offset=131067 zap_len=5
 0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
 Corrupting bytes...
 Validating corruption (reading full file)...
-- 
2.28.0

