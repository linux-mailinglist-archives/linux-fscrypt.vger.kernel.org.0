Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00525ADC75
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiIFAfy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiIFAfx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:35:53 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3FF696E5;
        Mon,  5 Sep 2022 17:35:51 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BFD2A807FE;
        Mon,  5 Sep 2022 20:35:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424551; bh=+thUT6Cq6999iUqrVM0TWGw5+/2kA0ydzokSIPEYGbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcnTHF6F03sZ/rApjqbg2Ai2QMBh2l3krFtZrjWD0gN/45dH7MJcM9Ds/XUCtDRci
         9nXBeT1uFloVxTp7y+DvUe1jwgHwD9gB6Cm3GFkfPkwEBsz8ve38niiYGVPSQUN3/5
         Vl/N0mXbnNOfWG0woIFAYg8919xn8LUWKDEQbHzJtJXInMHYwJCZMENJS8GNnkm6mi
         fsW8J/On8now+9BtX13x+9wIBX8H96RptGWnq8oiy06CuOJBIQ3G/VMmgkTTbpbufM
         zKEDC/McDdtIF3EOkZHfgJqweF4WMkH8iUDVWfuX6tSi9MIFo49AHLRfMF21gCkXM+
         Oc7CDS3sOYWjw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 06/20] fscrypt: document btrfs' fscrypt quirks.
Date:   Mon,  5 Sep 2022 20:35:21 -0400
Message-Id: <162ee6895a7d5060d1cd1ce9b2cff885eec9a062.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

As btrfs has a couple of quirks in its encryption compared to other filesystems, they
should be documented like ext4's quirks. Additionally, extent-based
contents encryption, being wholly new, deserves its own section to
compare against file-based contents encryption.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 Documentation/filesystems/fscrypt.rst | 62 +++++++++++++++++++--------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 5ba5817c17c2..9dd7e8c0090a 100644
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
@@ -41,10 +41,10 @@ causing application compatibility issues; fscrypt allows the full 255
 bytes (NAME_MAX).  Finally, unlike eCryptfs, the fscrypt API can be
 used by unprivileged users, with no need to mount anything.
 
-fscrypt does not support encrypting files in-place.  Instead, it
-supports marking an empty directory as encrypted.  Then, after
-userspace provides the key, all regular files, directories, and
-symbolic links created in that directory tree are transparently
+For most filesystems, fscrypt does not support encrypting files
+in-place.  Instead, it supports marking an empty directory as encrypted.
+Then, after userspace provides the key, all regular files, directories,
+and symbolic links created in that directory tree are transparently
 encrypted.
 
 Threat model
@@ -280,6 +280,11 @@ included in the IV.  Moreover:
   key derived using the KDF.  Users may use the same master key for
   other v2 encryption policies.
 
+For filesystems with extent-based content encryption (e.g. btrfs),
+this is the only choice. Data shared among multiple inodes must share
+the exact same key, therefore necessitating inodes using the same key
+for contents encryption.
+
 IV_INO_LBLK_64 policies
 -----------------------
 
@@ -374,12 +379,12 @@ to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
 with ciphertext expansion.
 
-Contents encryption
--------------------
+File-based contents encryption
+------------------------------
 
-For file contents, each filesystem block is encrypted independently.
-Starting from Linux kernel 5.5, encryption of filesystems with block
-size less than system's page size is supported.
+For most filesystems, each filesystem block within each file is
+encrypted independently.  Starting from Linux kernel 5.5, encryption of
+filesystems with block size less than system's page size is supported.
 
 Each block's IV is set to the logical block number within the file as
 a little endian number, except that:
@@ -403,6 +408,20 @@ Note that because file logical block numbers are included in the IVs,
 filesystems must enforce that blocks are never shifted around within
 encrypted files, e.g. via "collapse range" or "insert range".
 
+Extent-based contents encryption
+--------------------------------
+
+For certain filesystems (currently only btrfs), data is encrypted on a
+per-extent basis. Each filesystem block in a data extent is encrypted
+independently. Multiple files may refer to the extent, as long as they
+all share the same key.  The filesystem may relocate the extent on disk,
+as long as the encrypted data within the extent retains its offset
+within the data extent.
+
+Each extent stores a random starting IV; each block's IV within this is
+set to the logical block number within the extent as a little endian
+number.
+
 Filenames encryption
 --------------------
 
@@ -525,13 +544,14 @@ This structure must be initialized as follows:
   struct fscrypt_policy_v2.
 
 If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
-verifies that the file is an empty directory.  If so, the specified
-encryption policy is assigned to the directory, turning it into an
-encrypted directory.  After that, and after providing the
-corresponding master key as described in `Adding keys`_, all regular
-files, directories (recursively), and symlinks created in the
-directory will be encrypted, inheriting the same encryption policy.
-The filenames in the directory's entries will be encrypted as well.
+verifies that the file is an empty directory, unless btrfs is being
+used.  If so, the specified encryption policy is assigned to the
+directory, turning it into an encrypted directory.  After that, and
+after providing the corresponding master key as described in `Adding
+keys`_, all regular files, directories (recursively), and symlinks
+created in the directory will be encrypted, inheriting the same
+encryption policy.  The filenames in the directory's entries will be
+encrypted as well.
 
 Alternatively, if the file is already encrypted, then
 FS_IOC_SET_ENCRYPTION_POLICY validates that the specified encryption
@@ -552,6 +572,14 @@ Note that the ext4 filesystem does not allow the root directory to be
 encrypted, even if it is empty.  Users who want to encrypt an entire
 filesystem with one key should consider using dm-crypt instead.
 
+Note that btrfs permits setting a currently unencrypted 'subvolume' to
+encrypted. This means all newly written data, and files, will be
+encrypted, but existing data and filenames will remain unencrypted. This
+is intended for use in containers: initially identical unencrypted
+snapshot volumes provide the base for multiple containers' filesystems,
+but after each encrypts their volume with a different key, any new
+sensitive data written by the container will be encrypted.
+
 FS_IOC_SET_ENCRYPTION_POLICY can fail with the following errors:
 
 - ``EACCES``: the file is not owned by the process's uid, nor does the
-- 
2.35.1

