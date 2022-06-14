Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F0554A7AE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jun 2022 05:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiFND6l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Jun 2022 23:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237666AbiFND61 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Jun 2022 23:58:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2543F637E;
        Mon, 13 Jun 2022 20:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4804B80D13;
        Tue, 14 Jun 2022 03:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3530BC3411B;
        Tue, 14 Jun 2022 03:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655179103;
        bh=WXZpz+dTnwY7h/5r3XpM8J82ngxzqIIgauF8paQgEug=;
        h=From:To:Cc:Subject:Date:From;
        b=nIj2w+8eF3c9KjuYbeiY03jGs4Nihzl9LEDaWhVYJ0sKzoLiIEHddJ5yo5hzVdQBb
         1rqXKcTDoLfqH6aWuVEJT3u5kctDmEywo2hMY/YjdOzF4EbWaeFCzRaho4V1NprqcM
         9YtD3s3xbuHVkOA+sBDxhVG1yfcMoBylZCCsURXgizlZo72VBNDMGO56tDK1LlGlyP
         pTMh025ckr7SrQLYfV0DOvgFCGQHnA97kg6gqvdYhAgrfkXR3v9wwvViAAUGTnrUBf
         yCUiz+bwSwZfO5YZ/W4J4b2y+UfdKwPzrK7pl4PtJJnoQBQlnRS/3gXUXawC6mMyoT
         5IQl6JxWYMVxg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, linux-doc@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: [PATCH RESEND] fs-verity: mention btrfs support
Date:   Mon, 13 Jun 2022 20:57:43 -0700
Message-Id: <20220614035743.81014-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

btrfs supports fs-verity since Linux v5.15.  Document this.

Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

[resent to add linux-doc to CC]

 Documentation/filesystems/fsverity.rst | 53 +++++++++++++++-----------
 fs/verity/Kconfig                      | 10 ++---
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 756f2c215ba13..cb8e7573882a1 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -11,9 +11,9 @@ Introduction
 
 fs-verity (``fs/verity/``) is a support layer that filesystems can
 hook into to support transparent integrity and authenticity protection
-of read-only files.  Currently, it is supported by the ext4 and f2fs
-filesystems.  Like fscrypt, not too much filesystem-specific code is
-needed to support fs-verity.
+of read-only files.  Currently, it is supported by the ext4, f2fs, and
+btrfs filesystems.  Like fscrypt, not too much filesystem-specific
+code is needed to support fs-verity.
 
 fs-verity is similar to `dm-verity
 <https://www.kernel.org/doc/Documentation/device-mapper/verity.txt>`_
@@ -473,9 +473,9 @@ files being swapped around.
 Filesystem support
 ==================
 
-fs-verity is currently supported by the ext4 and f2fs filesystems.
-The CONFIG_FS_VERITY kconfig option must be enabled to use fs-verity
-on either filesystem.
+fs-verity is supported by several filesystems, described below.  The
+CONFIG_FS_VERITY kconfig option must be enabled to use fs-verity on
+any of these filesystems.
 
 ``include/linux/fsverity.h`` declares the interface between the
 ``fs/verity/`` support layer and filesystems.  Briefly, filesystems
@@ -544,6 +544,13 @@ Currently, f2fs verity only supports a Merkle tree block size of 4096.
 Also, f2fs doesn't support enabling verity on files that currently
 have atomic or volatile writes pending.
 
+btrfs
+-----
+
+btrfs supports fs-verity since Linux v5.15.  Verity-enabled inodes are
+marked with a RO_COMPAT inode flag, and the verity metadata is stored
+in separate btree items.
+
 Implementation details
 ======================
 
@@ -622,14 +629,14 @@ workqueue, and then the workqueue work does the decryption or
 verification.  Finally, pages where no decryption or verity error
 occurred are marked Uptodate, and the pages are unlocked.
 
-Files on ext4 and f2fs may contain holes.  Normally, ``->readahead()``
-simply zeroes holes and sets the corresponding pages Uptodate; no bios
-are issued.  To prevent this case from bypassing fs-verity, these
-filesystems use fsverity_verify_page() to verify hole pages.
+On many filesystems, files can contain holes.  Normally,
+``->readahead()`` simply zeroes holes and sets the corresponding pages
+Uptodate; no bios are issued.  To prevent this case from bypassing
+fs-verity, these filesystems use fsverity_verify_page() to verify hole
+pages.
 
-ext4 and f2fs disable direct I/O on verity files, since otherwise
-direct I/O would bypass fs-verity.  (They also do the same for
-encrypted files.)
+Filesystems also disable direct I/O on verity files, since otherwise
+direct I/O would bypass fs-verity.
 
 Userspace utility
 =================
@@ -648,7 +655,7 @@ Tests
 To test fs-verity, use xfstests.  For example, using `kvm-xfstests
 <https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
 
-    kvm-xfstests -c ext4,f2fs -g verity
+    kvm-xfstests -c ext4,f2fs,btrfs -g verity
 
 FAQ
 ===
@@ -771,15 +778,15 @@ weren't already directly answered in other parts of this document.
     e.g. magically trigger construction of a Merkle tree.
 
 :Q: Does fs-verity support remote filesystems?
-:A: Only ext4 and f2fs support is implemented currently, but in
-    principle any filesystem that can store per-file verity metadata
-    can support fs-verity, regardless of whether it's local or remote.
-    Some filesystems may have fewer options of where to store the
-    verity metadata; one possibility is to store it past the end of
-    the file and "hide" it from userspace by manipulating i_size.  The
-    data verification functions provided by ``fs/verity/`` also assume
-    that the filesystem uses the Linux pagecache, but both local and
-    remote filesystems normally do so.
+:A: So far all filesystems that have implemented fs-verity support are
+    local filesystems, but in principle any filesystem that can store
+    per-file verity metadata can support fs-verity, regardless of
+    whether it's local or remote.  Some filesystems may have fewer
+    options of where to store the verity metadata; one possibility is
+    to store it past the end of the file and "hide" it from userspace
+    by manipulating i_size.  The data verification functions provided
+    by ``fs/verity/`` also assume that the filesystem uses the Linux
+    pagecache, but both local and remote filesystems normally do so.
 
 :Q: Why is anything filesystem-specific at all?  Shouldn't fs-verity
     be implemented entirely at the VFS level?
diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index 54598cd801457..aad1f1d998b9d 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -14,11 +14,11 @@ config FS_VERITY
 	help
 	  This option enables fs-verity.  fs-verity is the dm-verity
 	  mechanism implemented at the file level.  On supported
-	  filesystems (currently EXT4 and F2FS), userspace can use an
-	  ioctl to enable verity for a file, which causes the filesystem
-	  to build a Merkle tree for the file.  The filesystem will then
-	  transparently verify any data read from the file against the
-	  Merkle tree.  The file is also made read-only.
+	  filesystems (currently ext4, f2fs, and btrfs), userspace can
+	  use an ioctl to enable verity for a file, which causes the
+	  filesystem to build a Merkle tree for the file.  The filesystem
+	  will then transparently verify any data read from the file
+	  against the Merkle tree.  The file is also made read-only.
 
 	  This serves as an integrity check, but the availability of the
 	  Merkle tree root hash also allows efficiently supporting

base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
-- 
2.36.1

