Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECB374C7A8
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjGISyP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGISyN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:13 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F5510C;
        Sun,  9 Jul 2023 11:54:12 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3822580B29;
        Sun,  9 Jul 2023 14:54:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928852; bh=FO7b4xLL3bsxFufSNj7q1itrm1F6yVnsku7LAoCNJSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7dnDpucFDht2hVWsXp9MawtNHK4Qr1MWwADdCcs+02Q/RmIXfrqGdePpTkmAPWCy
         ECP78TKpmnB84laUwtxnFHc4V+IBS9WvWxVuYBSgqLbF/Bfn9ZrLogGqIKGA65WgRD
         jyepZJNXdf1Ze6C8rulqXMFAncNKDhRSwnSnj65ZheqcmR4wIl+U79bPi18GFiekWc
         LqAGStrxeHZsKeVk686EjM1vp1of8QMCf2oFT+5FIq4eYbh4BOBepZTXWuFOdeSYgK
         Y+hPlOJR0ZSGYlL73MQyOZJ5ZkY3Q6jrUI3jMt6mZQJfudh4GxfckLWxg1LJ/1g+Es
         wxG1GGPCHbK1g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 14/14] fscrypt: update documentation for per-extent keys
Date:   Sun,  9 Jul 2023 14:53:47 -0400
Message-Id: <5808ad06771b4e7e40c8736364a24ce6d8556901.1688927487.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927487.git.sweettea-kernel@dorminy.me>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add some documentation of how extent-based encryption works, hopefully
enough for future filesystem users.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 Documentation/filesystems/fscrypt.rst | 43 +++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index eccd327e6df5..e862d59bd5b5 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -31,7 +31,7 @@ However, except for filenames, fscrypt does not encrypt filesystem
 metadata.
 
 Unlike eCryptfs, which is a stacked filesystem, fscrypt is integrated
-directly into supported filesystems --- currently ext4, F2FS, and
+directly into supported filesystems --- currently btrfs, ext4, F2FS, and
 UBIFS.  This allows encrypted files to be read and written without
 caching both the decrypted and encrypted pages in the pagecache,
 thereby nearly halving the memory used and bringing it in line with
@@ -125,6 +125,11 @@ However, these ioctls have some limitations:
   well as kill any processes whose working directory is in an affected
   encrypted directory.
 
+- If the filesystem is using extent-based encryption, the master
+  encryption key will *not* be wiped from kernel memory until all
+  inodes using the key have been evicted (requiring that all files
+  using the key are closed).
+
 - The kernel cannot magically wipe copies of the master key(s) that
   userspace might have as well.  Therefore, userspace must wipe all
   copies of the master key(s) it makes as well; normally this should
@@ -280,6 +285,11 @@ included in the IV.  Moreover:
   key derived using the KDF.  Users may use the same master key for
   other v2 encryption policies.
 
+For filesystems with extent-based content encryption (e.g. btrfs),
+this is the only choice. Data shared among multiple inodes must share
+the exact same key, therefore necessitating inodes using the same key
+for contents encryption.
+
 IV_INO_LBLK_64 policies
 -----------------------
 
@@ -381,12 +391,13 @@ to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
 with ciphertext expansion.
 
-Contents encryption
--------------------
+Inode-based contents encryption
+-------------------------------
 
-For file contents, each filesystem block is encrypted independently.
-Starting from Linux kernel 5.5, encryption of filesystems with block
-size less than system's page size is supported.
+Most filesystems use the previously discussed per-file keys. For these
+filesystems, for file contents, each filesystem block is encrypted
+independently.  Starting from Linux kernel 5.5, encryption of filesystems
+with block size less than system's page size is supported.
 
 Each block's IV is set to the logical block number within the file as
 a little endian number, except that:
@@ -410,6 +421,26 @@ Note that because file logical block numbers are included in the IVs,
 filesystems must enforce that blocks are never shifted around within
 encrypted files, e.g. via "collapse range" or "insert range".
 
+Extent-based contents encryption
+--------------------------------
+
+For certain filesystems (currently only btrfs), data is encrypted on a
+per-extent basis, for whatever the filesystem's notion of an extent is. The
+scheme is exactly as with inode-based contents encryption, except that the
+'inode number' for an extent is requested from the filesystem instead of from
+the file's inode, and the 'logical block number' refers to an offset within the
+extent.
+
+Because the encryption material is per-extent instead of per-inode, as long
+as the extent's encryption context does not change, the filesystem may shift
+around the position of the extent, and may have multiple files referring to
+the same encrypted extent.
+
+Not all extents within a file are decrypted simultaneously, so it is possible
+for a file read to fail partway through the file if it crosses into an extent
+whose key is unavailable.  However, all writes will succeed, unless the key is
+removed mid-write.
+
 Filenames encryption
 --------------------
 
-- 
2.40.1

