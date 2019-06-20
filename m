Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5837A4D755
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 20:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfFTSRw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 14:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729563AbfFTSRv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 14:17:51 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C16CF205F4;
        Thu, 20 Jun 2019 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054670;
        bh=His2GEyLOsppSYqxvpWMEdSHNZvzQPrCQt8k7Cb6maI=;
        h=From:To:Cc:Subject:Date:From;
        b=HiBAfuiEylS4DprCpXv/qQKOsRqSExKdaTSiyDJvh6VU6Vhrk2j77ZxbJprE0EX9F
         pDnfi1YcLwud+uCnpTCtoOt7Hja4uWLL1giXaDh4B9RoudtXOASaRhFFqjngOlPQNW
         NCd5B6U+nk8KyEiV/bECXzq/v9iLJHspNjf+NNac=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: [PATCH] fscrypt: document testing with xfstests
Date:   Thu, 20 Jun 2019 11:16:58 -0700
Message-Id: <20190620181658.225792-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document how to test ext4, f2fs, and ubifs encryption with xfstests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 39 +++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 87d4e266ffc86d..82efa41b0e6c02 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -649,3 +649,42 @@ Note that the precise way that filenames are presented to userspace
 without the key is subject to change in the future.  It is only meant
 as a way to temporarily present valid filenames so that commands like
 ``rm -r`` work as expected on encrypted directories.
+
+Tests
+=====
+
+To test fscrypt, use xfstests, which is Linux's de facto standard
+filesystem test suite.  First, run all the tests in the "encrypt"
+group on the relevant filesystem(s).  For example, to test ext4 and
+f2fs encryption using `kvm-xfstests
+<https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
+
+    kvm-xfstests -c ext4,f2fs -g encrypt
+
+UBIFS encryption can also be tested this way, but it should be done in
+a separate command, and it takes some time for kvm-xfstests to set up
+emulated UBI volumes::
+
+    kvm-xfstests -c ubifs -g encrypt
+
+No tests should fail.  However, tests that use non-default encryption
+modes (e.g. generic/549 and generic/550) will be skipped if the needed
+algorithms were not built into the kernel's crypto API.  Also, tests
+that access the raw block device (e.g. generic/399, generic/548,
+generic/549, generic/550) will be skipped on UBIFS.
+
+Besides running the "encrypt" group tests, for ext4 and f2fs it's also
+possible to run most xfstests with the "test_dummy_encryption" mount
+option.  This option causes all new files to be automatically
+encrypted with a dummy key, without having to make any API calls.
+This tests the encrypted I/O paths more thoroughly.  To do this with
+kvm-xfstests, use the "encrypt" filesystem configuration::
+
+    kvm-xfstests -c ext4/encrypt,f2fs/encrypt -g auto
+
+Because this runs many more tests than "-g encrypt" does, it takes
+much longer to run; so also consider using `gce-xfstests
+<https://github.com/tytso/xfstests-bld/blob/master/Documentation/gce-xfstests.md>`_
+instead of kvm-xfstests::
+
+    gce-xfstests -c ext4/encrypt,f2fs/encrypt -g auto
-- 
2.22.0.410.gd8fdbe21b5-goog

