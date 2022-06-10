Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4723A5458F6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jun 2022 02:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiFJAHO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 20:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiFJAHN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 20:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE131E4B55;
        Thu,  9 Jun 2022 17:07:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D1A460B43;
        Fri, 10 Jun 2022 00:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAE2C34115;
        Fri, 10 Jun 2022 00:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654819631;
        bh=jIjBc8E9Fs1woT9Va1+rxlmfiKvnSnF0c/ckjor99Ig=;
        h=From:To:Cc:Subject:Date:From;
        b=WABC9AeeF2HCEspdURfAgc9vU5VbmERg0juPQn34+rtbWg1JQiMuLYws2X1/YyChx
         FK2UpxjessiGMvhZNNTZqexUcKGc7MsZKLEYxAVirH6VQIphlqPR7zAA9QSJW67nmB
         qeXzEMpcsDMNRL3kDOTm1ms6Q1W4WFvcEpAdv7hKtPYgLpTsJMA1cxpZxNaGKDSyv0
         6rM/yFe8b3miiZkvhNKd2piyqzwu5egcsElaPMyMe0AH3enNgMnoqsAte2uFCIIKZP
         HO8sisnXk4vudxiXa4P4QdEi7rm6MJ+t8F8Xs5oY2gzb435bqMAMrHNs68WN6pbIa0
         GrQ92zlN2RXrA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: [PATCH] fs-verity: mention btrfs support
Date:   Thu,  9 Jun 2022 17:06:16 -0700
Message-Id: <20220610000616.18225-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
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
-- 
2.36.1

