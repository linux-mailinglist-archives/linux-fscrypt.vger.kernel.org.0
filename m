Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515F679057A
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbjIBF4U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjIBF4U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:20 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEAC10F6;
        Fri,  1 Sep 2023 22:56:17 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EF1FE803B8;
        Sat,  2 Sep 2023 01:56:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634177; bh=vGSsk/5B1Ps74F/JCs2e0jmq8/pZ+D4gbano0VHmuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsQJqefQo4S0FeckXrm/Fx8CSd5O3C4qAb2hfo3ba3u7o9g0quJPjgN45Zmo9Pvr9
         a0pK6k0QFgfe2JWUqFuhpGh70rwWMauBVzE47LyY1JxPE+VgW6Xx70QidgQCcBWSAo
         K7GuL7P9x9pOFOByyiEpe0lHaGJKzt5AbUriaSttXit1prahkWVF2yhc3c2sDYaXxn
         OPW7+v6WYbJDAIaqY3TOFOfloTlbGyq2v+UPpORWAR/jskrMVUyRnheiw/s51dfpFV
         m2NJxuE9MuWKDmH6xhOcGj2GlizkDIkYe14Aj7wECB7v5RjVoZuezz//9eZcqF+Vu7
         xpceHqbqq1Waw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 13/13] fscrypt: update documentation for per-extent keys
Date:   Sat,  2 Sep 2023 01:54:31 -0400
Message-ID: <3024fee53a842fe8f09e07fe98e0df7b5e05e048.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.41.0

