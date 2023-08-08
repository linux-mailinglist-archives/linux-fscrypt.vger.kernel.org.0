Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A627774648
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjHHSyk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbjHHSyW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:22 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D286763F4D;
        Tue,  8 Aug 2023 10:09:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6601F800E0;
        Tue,  8 Aug 2023 13:09:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514543; bh=vGSsk/5B1Ps74F/JCs2e0jmq8/pZ+D4gbano0VHmuZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDW3Iy3aRVCoRKOJfdYc26O3RzDa4ed6+KityPxSbopRgQyoy/rZnix2pDaPMiKjF
         Q+cPRqriTIB8RI/QkPTR7WdClP3S1zRTtABdM8Iu+fSLCKtB1KwmPQD07KYpYMpUXu
         UqqOWJjiEPHn5t9YkcCYjCGUK0ynuAINEsR2io9g6OWuhkyHiz4ITS6eKsLDQIm6K9
         0PH7m68YqJIOEVpOeSPumQ96Ip6gnEdICvjj5yXnoAP7f/mNwm3MDweFIZ82EdMoLJ
         G4qItBXO3Z5gXL66QD+UVumnF3t1Rmma93enfxx3+sP2m+3pdGtJVednHWSLVPRpWr
         nWfDvPGen+2mQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 16/16] fscrypt: update documentation for per-extent keys
Date:   Tue,  8 Aug 2023 13:08:33 -0400
Message-ID: <8712f622048a514722c3d9ed71e6e32fc40f6ccb.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
2.41.0

