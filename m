Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A217EDA0DD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Oct 2019 00:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfJPWQf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Oct 2019 18:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfJPWQe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Oct 2019 18:16:34 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64F002168B;
        Wed, 16 Oct 2019 22:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571264193;
        bh=TqEWrui8v2IJqhlGNgLhnJHRs0UJfYjhgPHFu58TtsI=;
        h=From:To:Cc:Subject:Date:From;
        b=1XslRl97eJiwhnrSDNVbKvxfeYUuEZDmCBoYYvYGMkJqHJKvIrJF1r2iUV+olvt3e
         ilQo/kUOsWdw8DSlqxJMRKdVze0wZm7oVBTPBkw/a7rjzyHEZIN6NZjYMziD75PC4g
         aShbKvLeIu0xR95MuejHeUqKf4uXPqydExchfmtg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [xfstests-bld PATCH] test-appliance: add ext4/encrypt_1k test config
Date:   Wed, 16 Oct 2019 15:15:52 -0700
Message-Id: <20191016221552.299566-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a test configuration to allow testing ext4 encryption with 1k
blocks, which kernel patches have been proposed to support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .../files/root/fs/ext4/cfg/encrypt_1k         |  5 ++++
 .../files/root/fs/ext4/cfg/encrypt_1k.exclude | 27 +++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k
new file mode 100644
index 0000000..5e97cc0
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k
@@ -0,0 +1,5 @@
+SIZE=small
+export EXT_MKFS_OPTIONS="-O encrypt -b 1024"
+export EXT_MOUNT_OPTIONS="test_dummy_encryption"
+REQUIRE_FEATURE=encryption
+TESTNAME="Ext4 encryption 1k block"
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
new file mode 100644
index 0000000..e31c371
--- /dev/null
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
@@ -0,0 +1,27 @@
+# These tests are also excluded in encrypt.exclude.
+# See there for the reasons.
+ext4/004
+ext4/022
+ext4/026
+generic/082
+generic/219
+generic/230
+generic/231
+generic/232
+generic/233
+generic/235
+generic/270
+generic/382
+generic/204
+
+# These tests are also excluded in 1k.exclude.
+# See there for the reasons.
+ext4/034
+generic/273
+generic/454
+
+# These tests use _scratch_populate_cached() which tries to create a 1023-byte
+# symlink, which fails with encrypt_1k because encrypted symlinks are limited to
+# blocksize-3 bytes, not blocksize-1 as is the case for no encryption.
+ext4/023
+ext4/028
-- 
2.23.0

