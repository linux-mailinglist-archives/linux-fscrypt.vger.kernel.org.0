Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57777617041
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 23:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiKBWGu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiKBWGt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 18:06:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1152065C7;
        Wed,  2 Nov 2022 15:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5C96B82511;
        Wed,  2 Nov 2022 22:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F222C433C1;
        Wed,  2 Nov 2022 22:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667426805;
        bh=dzmvHm1VBFlX5yeoYPk9Me1Xe6QcnRkG9Ag0n4N0WNc=;
        h=From:To:Cc:Subject:Date:From;
        b=KGKnbFELeHz8McMI47VGks19zIEnqA+ePNCi8YsZ7fq+JR/MF8mLluIUdBC0qdBjG
         q/2D1BxqtG2u2HNZkZ27fNuIsUao5VRb5uvcRgbTa5GCVfUtEgufLa3COWH5AnM86v
         xdg0uSXCYieSxw/8lP/XGSrFy0/oRw7DRysrSrD5F0s4ciS5TzB9EbfQGTJOauiIW6
         heBYFGvph9Hsg6YKF5Xb3LExQmk4gZM2fiyZxQpSwOBD27AeyI2c+zmiDMZETz+q97
         5X3FModMmzsMlWguXH6ZypRV4/GMsaBFLla/Q1HilslMtfy+u1LW/Bi2h5t03dLVvJ
         Es1SQVyRmXTCA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [e2fsprogs PATCH v2] e2fsck: don't allow journal inode to have encrypt flag
Date:   Wed,  2 Nov 2022 15:05:51 -0700
Message-Id: <20221102220551.3940-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Since the kernel is being fixed to consider journal inodes with the
'encrypt' flag set to be invalid, also update e2fsck accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: generate the test filesystem image dynamically.

 e2fsck/journal.c                   |  3 ++-
 tests/f_badjour_encrypted/expect.1 | 30 ++++++++++++++++++++++++++++++
 tests/f_badjour_encrypted/expect.2 |  7 +++++++
 tests/f_badjour_encrypted/name     |  1 +
 tests/f_badjour_encrypted/script   | 11 +++++++++++
 5 files changed, 51 insertions(+), 1 deletion(-)
 create mode 100644 tests/f_badjour_encrypted/expect.1
 create mode 100644 tests/f_badjour_encrypted/expect.2
 create mode 100644 tests/f_badjour_encrypted/name
 create mode 100644 tests/f_badjour_encrypted/script

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index d802c5e9..343e48ba 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1039,7 +1039,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			tried_backup_jnl++;
 		}
 		if (!j_inode->i_ext2.i_links_count ||
-		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode)) {
+		    !LINUX_S_ISREG(j_inode->i_ext2.i_mode) ||
+		    (j_inode->i_ext2.i_flags & EXT4_ENCRYPT_FL)) {
 			retval = EXT2_ET_NO_JOURNAL;
 			goto try_backup_journal;
 		}
diff --git a/tests/f_badjour_encrypted/expect.1 b/tests/f_badjour_encrypted/expect.1
new file mode 100644
index 00000000..0b13b9eb
--- /dev/null
+++ b/tests/f_badjour_encrypted/expect.1
@@ -0,0 +1,30 @@
+Superblock has an invalid journal (inode 8).
+Clear? yes
+
+*** journal has been deleted ***
+
+Pass 1: Checking inodes, blocks, and sizes
+Journal inode is not in use, but contains data.  Clear? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(24--25) -(27--41) -(107--1113)
+Fix? yes
+
+Free blocks count wrong for group #0 (934, counted=1958).
+Fix? yes
+
+Free blocks count wrong (934, counted=1958).
+Fix? yes
+
+Recreate journal? yes
+
+Creating journal (1024 blocks):  Done.
+
+*** journal has been regenerated ***
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 11/256 files (0.0% non-contiguous), 1114/2048 blocks
+Exit status is 1
diff --git a/tests/f_badjour_encrypted/expect.2 b/tests/f_badjour_encrypted/expect.2
new file mode 100644
index 00000000..76934be2
--- /dev/null
+++ b/tests/f_badjour_encrypted/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/256 files (9.1% non-contiguous), 1114/2048 blocks
+Exit status is 0
diff --git a/tests/f_badjour_encrypted/name b/tests/f_badjour_encrypted/name
new file mode 100644
index 00000000..e8f4c04f
--- /dev/null
+++ b/tests/f_badjour_encrypted/name
@@ -0,0 +1 @@
+journal inode has encrypt flag
diff --git a/tests/f_badjour_encrypted/script b/tests/f_badjour_encrypted/script
new file mode 100644
index 00000000..e6778f1d
--- /dev/null
+++ b/tests/f_badjour_encrypted/script
@@ -0,0 +1,11 @@
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+
+touch $TMPFILE
+$MKE2FS -t ext4 -b 1024 $TMPFILE 2M
+$DEBUGFS -w -R 'set_inode_field <8> flags 0x80800' $TMPFILE
+
+SKIP_GUNZIP="true"
+. $cmd_dir/run_e2fsck

base-commit: aad34909b6648579f42dade5af5b46821aa4d845
-- 
2.38.1

