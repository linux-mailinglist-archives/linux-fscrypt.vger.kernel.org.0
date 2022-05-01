Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F7E516204
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241244AbiEAFYz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbiEAFYx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:24:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE88D13D44;
        Sat, 30 Apr 2022 22:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2365B80CB4;
        Sun,  1 May 2022 05:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AFBC385AE;
        Sun,  1 May 2022 05:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651382486;
        bh=j7Ojm0Y/TtfoVP201D1ipsjgRonwxGdjQzShixa9xnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6ARVntjOb1475mSdnTLgfG5NPeqOCiJMaXq9PfiYVlXui/Rm0/i3DQ99xXd8gB6+
         7t/8HEmQzpfv0vlPqHSAcVYcKR3+C6dplpEbp/G6YwXYtqe+FrwWnpy4ESuoPKPnBw
         HJKoBus6N7QvKPFWt7h92zxYTAG6sPWbqF+4Ixx+vdKgGpxZb3hbCB7E9c8f+1uLUw
         dtsLQmJN0tqOon2jgTzpwdHjP99FTk1Xz41svYoZRbTWKOqeLZYGRE443aiRwQhnxb
         TJMWdRUu27CuQfQnVvnmuZyEAEu/zn9DtTar4oCsNYyEHiLh1/1v4GhIGMK7psyu8H
         H9jrtOGXCQWMQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: [xfstests PATCH 1/2] ext4/053: update the test_dummy_encryption tests
Date:   Sat, 30 Apr 2022 22:19:27 -0700
Message-Id: <20220501051928.540278-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220501051928.540278-1-ebiggers@kernel.org>
References: <20220501051928.540278-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The kernel patch "ext4: only allow test_dummy_encryption when supported"
will tighten the requirements on when the test_dummy_encryption mount
option will be accepted.  Update ext4/053 accordingly.

Move the test cases to later in the file to group them with the other
test cases that use do_mkfs to add custom mkfs options instead of using
the "default" filesystem that the test creates at the beginning.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/ext4/053 | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tests/ext4/053 b/tests/ext4/053
index bf6e3f6b..84f3eab9 100755
--- a/tests/ext4/053
+++ b/tests/ext4/053
@@ -512,20 +512,6 @@ for fstype in ext2 ext3 ext4; do
 	mnt noinit_itable
 	mnt max_dir_size_kb=4096
 
-	if _has_kernel_config CONFIG_FS_ENCRYPTION; then
-		mnt test_dummy_encryption
-		mnt test_dummy_encryption=v1
-		mnt test_dummy_encryption=v2
-		not_mnt test_dummy_encryption=v3
-		not_mnt test_dummy_encryption=
-	else
-		mnt test_dummy_encryption ^test_dummy_encryption
-		mnt test_dummy_encryption=v1 ^test_dummy_encryption=v1
-		mnt test_dummy_encryption=v2 ^test_dummy_encryption=v2
-		mnt test_dummy_encryption=v3 ^test_dummy_encryption=v3
-		not_mnt test_dummy_encryption=
-	fi
-
 	if _has_kernel_config CONFIG_FS_ENCRYPTION_INLINE_CRYPT; then
 		mnt inlinecrypt
 	else
@@ -687,6 +673,27 @@ for fstype in ext2 ext3 ext4; do
 	mnt_then_not_remount defaults jqfmt=vfsv1
 	remount defaults grpjquota=,usrjquota= ignored
 
+	echo "== Testing the test_dummy_encryption option" >> $seqres.full
+	# Since kernel commit "ext4: only allow test_dummy_encryption when
+	# supported", the test_dummy_encryption mount option is only allowed
+	# when the filesystem has the encrypt feature and the kernel has
+	# CONFIG_FS_ENCRYPTION.  Note, the encrypt feature requirement implies
+	# that this option is never allowed on ext2 or ext3 mounts.
+	if [[ $fstype == ext4 ]] && _has_kernel_config CONFIG_FS_ENCRYPTION; then
+		do_mkfs -O encrypt $SCRATCH_DEV ${SIZE}k
+		mnt test_dummy_encryption
+		mnt test_dummy_encryption=v1
+		mnt test_dummy_encryption=v2
+		not_mnt test_dummy_encryption=bad
+		not_mnt test_dummy_encryption=
+		do_mkfs -O ^encrypt $SCRATCH_DEV ${SIZE}k
+	fi
+	not_mnt test_dummy_encryption
+	not_mnt test_dummy_encryption=v1
+	not_mnt test_dummy_encryption=v2
+	not_mnt test_dummy_encryption=bad
+	not_mnt test_dummy_encryption=
+
 done #for fstype in ext2 ext3 ext4; do
 
 $UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
-- 
2.36.0

