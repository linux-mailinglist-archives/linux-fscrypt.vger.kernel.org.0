Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6401ED833
	for <lists+linux-fscrypt@lfdr.de>; Wed,  3 Jun 2020 23:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgFCVzp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Jun 2020 17:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgFCVzo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Jun 2020 17:55:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0080D204EF;
        Wed,  3 Jun 2020 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591221344;
        bh=R4fNoE/V83KUWOOchGYb1qdwOG+iP/zrahv26j4hVII=;
        h=From:To:Cc:Subject:Date:From;
        b=qanbruc0DKsoMMz1Mra0u4RAmgPgCGIDhPjze56SbL0frK/LcmNCFwON/vcvgpUvR
         AIYS4YSOj9QwOWNpcn4V6YuFGfwPbWglOLFPouRtE//sWW/VgCbdEZPsh4Lvgnlzu5
         uowmOUALqDbG7tk+N2eCC7ZtB6hKX15sFh3GIYNw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [xfstests-bld PATCH] test-appliance: exclude ext4/023 and ext4/028 from encrypt config
Date:   Wed,  3 Jun 2020 14:54:57 -0700
Message-Id: <20200603215457.146447-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In Linux 5.8, the test_dummy_encryption mount option will use v2
encryption policies rather than v1 as it previously did.  This increases
the size of the encryption xattr slightly, causing two ext4 tests to
start failing due to xattr spillover.  Exclude these tests.

See kernel commit ed318a6cc0b6 ("fscrypt: support
test_dummy_encryption=v2") for more details.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .../files/root/fs/ext4/cfg/encrypt.exclude          |  2 ++
 .../files/root/fs/ext4/cfg/encrypt_1k.exclude       | 13 +++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
index 304201e..47c26e7 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
@@ -5,7 +5,9 @@ ext4/004	# dump/restore doesn't handle quotas
 # xattr size.  This causes problems with encryption
 # which requires its own xattrs which take space.
 ext4/022
+ext4/023
 ext4/026
+ext4/028
 
 # file systems with encryption enabled can't be mounted with ext3
 ext4/044
diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
index e31c371..cd60151 100644
--- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
+++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt_1k.exclude
@@ -1,8 +1,15 @@
 # These tests are also excluded in encrypt.exclude.
 # See there for the reasons.
+#
+# Due to the 1k block size, ext4/023 and ext4/028 also fail for a second reason:
+# they use _scratch_populate_cached() which tries to create a 1023-byte symlink,
+# which fails with encrypt_1k because encrypted symlinks are limited to
+# blocksize-3 bytes, not blocksize-1 as is the case for no encryption.
 ext4/004
 ext4/022
+ext4/023
 ext4/026
+ext4/028
 generic/082
 generic/219
 generic/230
@@ -19,9 +26,3 @@ generic/204
 ext4/034
 generic/273
 generic/454
-
-# These tests use _scratch_populate_cached() which tries to create a 1023-byte
-# symlink, which fails with encrypt_1k because encrypted symlinks are limited to
-# blocksize-3 bytes, not blocksize-1 as is the case for no encryption.
-ext4/023
-ext4/028
-- 
2.26.2

